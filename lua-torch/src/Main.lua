require("optim")
require("ParamsParser")
require("Package")
require("Model")
local MinibatchLoader = require("MinibatchLoader")

opt = ParamsParser()
opt.batch_size = 30
opt.data_dir = "../data"
opt.isUsedCuda = true

local lengDict = 500
local lengLabel = 300
local lengWordVector = 200
local dropoutRate = 0.5

if (opt.isUsedCuda) then 
    require 'cutorch'
    require 'cunn'
end 
model = RnnSemanticParser.model.Seq2Seq(lengDict, lengWordVector, lengLabel, dropoutRate, opt.isUsedCuda)
-- model:testAttention()
-- assert(false)

 -- load data
train_loader = MinibatchLoader.create(opt, 'train')
print (train_loader.num_batch)
assert(false)
--  -- load batch data
local enc_batch, enc_len_batch, dec_batch = train_loader:random_batch()
-- print (enc_batch)
-- print (enc_len_batch)
-- print (dec_batch)
-- assert(false)

-- x1  = torch.Tensor({{0,2,5}, {3,4,5}}):t()
-- x2  = torch.Tensor({{2,5,6,7,0}, {2,3,4,5,0}}):t()
-- y1  = torch.Tensor({{5,6,17,18,0}, {3,3,5,8,0}}):t()
-- y = model:forward(x1, x2,y1)
-- y = model:backward(x1, x2,y1)
-- print (x1, x2,y1)
-- model:testAttention()
-- print (y)

optimState = {
    learningRate = 0.01,  
    momentum = 0.5,
    -- learningRateDecay = 0.0001
}
params, gradParams = model:getParameters()

for epoch = 1, 1000 do
   -- local function we give to optim
   -- it takes current weights as input, and outputs the loss
   -- and the gradient of the loss with respect to the weights
   -- gradParams is calculated implicitly by calling 'backward',
   -- because the model's weight and bias gradient tensors
   -- are simply views onto gradParams
   function feval(params)
      gradParams:zero()
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
      print (epoch .. ": " .. loss)
      return loss, gradParams
   end
   optim.sgd(feval, params, optimState)
end