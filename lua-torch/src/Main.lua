require("Package")

local MinibatchLoader = require("MinibatchLoader")

opt = ParamsParser()
opt.data_dir = "../data_gen_train"

local lengDict = opt.lengDict --500
local lengLabel = opt.lengLabel
local lengWordVector = opt.lengWordVector
local nNumLayerLstmIntermediate = opt.nNumLayerLstmIntermediate
local dropoutRate = opt.dropoutRate

if (opt.isUsedCuda) then 
    require 'cutorch'
    require 'cunn'
end

 -- load data train
train_loader = MinibatchLoader.create(opt, 'train')
train_loader:transformer_matrix(opt.isUsedCuda)
print ("Num batch = " .. train_loader.num_batch)
print ("Num sample = " .. train_loader.num_sample)

-- initialize the vocabulary manager to display text
word_manager, form_manager = unpack(torch.load('../data_gen_train/map.t7'))
lengDict = word_manager.vocab_size
lengLabel = form_manager.vocab_size
print (string.format("lengDict = %d, lengLabel = %d",lengDict, lengLabel))

model = RnnSemanticParser.model.Seq2Seq(lengDict, lengWordVector, lengLabel, nNumLayerLstmIntermediate, dropoutRate)
if (opt.isUsedCuda) then 
    model:cuda()
end 
-- model = torch.load("../model/model_cpu.t7")
-- model:testAttention()

--  -- load batch data
local dataTest = torch.load('../data_gen_train/test.t7')
print (string.format("num datatest = %d", #dataTest))
-- print (dataTest)
optimState = {
    learningRate = opt.lr,  
    momentum = opt.momentum,
    alpha = opt.decayrate
    --learningRateDecay = 0.0001
}

-- training 
if (opt.training == true) then 
    local maxEpochs = opt.maxEpoch
    model:training()
    for iterator = 1, maxEpochs*train_loader.num_batch do

        -- params 
        collectgarbage()
        params, gradParams = model:getParameters()
        local enc_batch, decIn, decOut = train_loader:random_matrix()
        -- print (enc_batch, decIn, decOut)
        -- assert(false )

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
            
            local loss = model:forward(enc_batch, decIn, decOut)
            local dloss_doutputs = model:backward(enc_batch, decIn, decOut)

            loss = loss/enc_batch:size(2)
            if (iterator % 10 ==0) then
                print (iterator .. "err : " .. loss)
                xlua.progress(iterator, maxEpochs*train_loader.num_batch)
            end 
            
            gradParams:clamp(-5, 5)

            return loss, gradParams
        end

        optim.rmsprop(feval, params, optimState)
        
        model:forget()

        collectgarbage()
    end

    xlua.progress(maxEpochs, maxEpochs)
    torch.save('../model/model_cpu.t7', model:unCuda())
end 

-- load model
if (opt.testing == true) then 
    model = torch.load("../model/model_cpu.t7")
    model:evaluate()

    local countTrue = 0
    for i = 1, #dataTest do 
        local predictions = model:eval (dataTest[i][1])
        predictions = { table.unpack (predictions, 2, #predictions -1) }

        if isSameTable(predictions, dataTest[i][2] ) then 
            countTrue = countTrue + 1
            print ("++")
        else
            print (word_manager_convert_to_string(dataTest[i][1]))
            print (convert_to_string(dataTest[i][2] ))
            print (convert_to_string(predictions))
            print ("--") 
        end 
    end 
    print("acc = "..(countTrue*1.0/#dataTest))
end 

-- valueate 
-- ------------------------------------------------------------------------------------------
-- test this class 
-- ------------------------------------------------------------------------------------------
function evalXX(sSentenceIn)
    if (opt.eval == true) then 
        if (opt.testing==false and  opt.training == false) then
            model = torch.load("../model/model_cpu.t7")
        end 
        local wordCombiner = RnnSemanticParser.WordCombiner()
        local prefixFolder = "../data_gen/"
        local listFileName = {"feel","level-after", "level-before",
            "s","state", "time", "time-long", "verb"}
        wordCombiner:loadDictRecombine(listFileName, prefixFolder)

        listFileName = {"state-not", "feel-not"}
        wordCombiner:loadDictInferNot(listFileName, prefixFolder)

        local sSentence, info =  wordCombiner:combineSentence (sSentenceIn)--("lan thấy casi gi hi vãi")
        local sentenceId = word_manager:get_symbol_idx_for_list(sSentence:split(" "))
        print ( word_manager_convert_to_string(sentenceId))
        print (info)

        local predictions = model:eval (sentenceId)
        predictions = { table.unpack (predictions, 2, #predictions -1) }
        print (convert_to_string(predictions))

        --  local state = wordCombiner:getStateInfer(info, convert_to_string(predictions))
        local state = wordCombiner:getStateInfer2(info, predictions, form_manager)
        local sJsonResult = string.format("{%s:\"%s\", %s:\"%s\"}", 
            "state", state["state"], "feel", state["feel"])
        return (sJsonResult)
    end
end
print (evalXX("tôi đang ăn cơm"))
print (evalXX("tôi đang đá bóng"))
print (evalXX("bạn có khỏe không"))
print (evalXX("mình đi chơi đi"))
print (evalXX("bạn đang vui à"))
print (evalXX("bạn chơi có vui không"))

