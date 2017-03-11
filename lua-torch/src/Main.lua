require "optim"
require 'xlua'

require("ParamsParser")
require("Package")
require("Model")
require("SymbolsManager")
require("utils")

local MinibatchLoader = require("MinibatchLoader")

opt = ParamsParser()
opt.batch_size = 20
opt.decay_rate = 0.95
opt.data_dir = "../data"
opt.isUsedCuda = true

local lengDict = 500
local lengLabel = 150
local lengWordVector = 200
local dropoutRate = 0.5

 -- load data train
train_loader = MinibatchLoader.create(opt, 'train')
print (train_loader.num_batch)

-- initialize the vocabulary manager to display text
word_manager, form_manager = unpack(torch.load('../data/map.t7'))
lengDict = word_manager.vocab_size
lengLabel = form_manager.vocab_size

model = RnnSemanticParser.model.Seq2Seq(lengDict, lengWordVector, lengLabel, dropoutRate)
if (opt.isUsedCuda) then 
    require 'cutorch'
    require 'cunn'
    model:cuda()
end 
-- model = torch.load("../model/model_cpu.t7")
-- model:testAttention()

--  -- load batch data
local dataTest = torch.load('../data/test.t7')

optimState = {
    learningRate = 0.01,  
    momentum = 0.95,
    alpha = opt.decay_rate
    -- learningRateDecay = 0.0001
}

-- training 
local maxEpochs = 150
for iterator = 1, maxEpochs*train_loader.num_batch do

    -- params 
    collectgarbage()
    params, gradParams = model:getParameters()
    
    -- local function we give to optim
    -- it takes current weights as input, and outputs the loss
    -- and the gradient of the loss with respect to the weights
    -- gradParams is calculated implicitly by calling 'backward',
    -- because the model's weight and bias gradient tensors
    -- are simply views onto gradParams
    function feval(x)
        if x ~= params then
            params:copy(x)
        end
    
        gradParams:zero()
        
        -- load batch data
        local enc_batch, enc_len_batch, dec_batch = train_loader:random_batch()
        enc_batch = enc_batch : t()

        local decIn = torch.Tensor(dec_batch:size(1), dec_batch:size(2)-1)
                            :copy((dec_batch[{{},{1,-2}}] )) 
                            :t()

        for col = 1, decIn:size(2) do
        if(decIn[decIn:size(1)][col] == 0 or decIn[decIn:size(1)][col] == 2) then 
            local row = decIn:size(1)
            while row > 0 do 
                if (decIn[row][col] ~= 0)then 
                    decIn[row][col] = 0
                    bcheck = true
                    break
                end
                row = row -1 
            end 
        end
        end      
      
        local decOut = torch.Tensor(dec_batch:size(1), dec_batch:size(2)-1)
                            :copy(dec_batch[{{},{2,-1}}]) 
                            :t()
        if (opt.isUsedCuda) then 
			decIn = decIn:cuda()
			decOut = decOut:cuda()
			enc_batch = enc_batch:cuda()
        end 
        local loss = model:forward(enc_batch, decIn, decOut)
        local dloss_doutputs = model:backward(enc_batch, decIn, decOut)

        loss = loss/enc_batch:size(2)
        if (iterator %100 ==0) then
            print (iterator .. ": " .. loss)
            xlua.progress(iterator, maxEpochs*train_loader.num_batch)
        end 
        return loss, gradParams
    end

    optim.rmsprop(feval, params, optimState)
    
    model:forget()

    collectgarbage()
end

xlua.progress(maxEpochs, maxEpochs)
torch.save('../model/model_cpu_5.t7', model:unCuda())

-- load model
model = torch.load("../model/model_cpu_5.t7")

local countTrue = 0
for i = 1, #dataTest do 
    local predictions = model:eval (dataTest[i][1])
    predictions = { table.unpack (predictions, 2, #predictions -1) }

    -- print (word_manager_convert_to_string(dataTest[i][1]))
    -- print (convert_to_string(predictions))
    -- print (convert_to_string(dataTest[i][2] ))
    if isSameTable(predictions, dataTest[i][2] ) then 
        countTrue = countTrue + 1
        print ("++")
    else
        print ("--") 
    end 
end 
print("acc = "..(countTrue*1.0/#dataTest))

