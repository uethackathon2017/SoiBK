require 'nn'
require 'rnn'

-- require init package = global variant table with path to RnnSemanticParser.model
local Seq2Seq = torch.class("RnnSemanticParser.model.Seq2Seq") 

-- constructor 
function Seq2Seq:__init()

    local lengDict = 100
    local lengLabel = 40
    local lengWordVector = 5

    --
    -- init encode layer 
    local lookupTableE  = nn.LookupTableMaskZero(lengDict, lengWordVector)
    self.lstmEncoder    = nn.FastLSTM(lengWordVector, lengWordVector)
    local switchLayer   = nn.ConcatTable()              -- 1 input => n output
                            :add (nn.Identity())        -- for attention layer
                            :add (nn.Select(1,-1))      -- for decode layser
    self.encoder        = nn.Sequential()
                                :add(lookupTableE)
                                :add(nn.Sequencer(self.lstmEncoder:maskZero(1)))
                                -- :add(switchLayer)

    --
    -- init decode layer 
    local   lookupTableD  = nn.LookupTableMaskZero(lengDict, lengWordVector)
    self.lstmDecoder      = nn.FastLSTM(lengWordVector, lengWordVector)            
    local   linear        = nn.Linear(lengWordVector, lengLabel)
    local   logSofmax     = nn.LogSoftMax()            
    self.decoder          = nn.Sequential()
                                :add(lookupTableD)
                                :add(nn.Sequencer(self.lstmDecoder:maskZero(1)))
                                :add(nn.Sequencer(nn.MaskZero(linear,1)))
                                :add(nn.Sequencer(nn.MaskZero(logSofmax,1)))
                
    --
    -- test model 
    -- x  = torch.Tensor({{0,2,5}, {3,4,5}}):t()
    -- print (x)

    -- y  = self.encoder:forward(x)
    -- print (lstmDecoder:get(1):get(1):get(1))
	-- y  = decoder:forward(x)
end

--[[ Forward coupling: Copy encoder cell and output to decoder LSTM ]]--
function Seq2Seq:forwardConnect(inputSeqLen)
	self.lstmDecoder.userPrevOutput =
    	rnn.recursiveCopy(self.lstmDecoder.userPrevOutput, self.lstmEncoder.outputs[inputSeqLen])
	self.lstmDecoder.userPrevCell =
    	rnn.recursiveCopy(self.lstmDecoder.userPrevCell, self.lstmEncoder.cells[inputSeqLen])
end

--[[ Backward coupling: Copy decoder gradients to encoder LSTM ]]--
function Seq2Seq:backwardConnect(inputSeqLen)
  	self.lstmEncoder:setGradHiddenState(inputSeqLen, self.lstmDecoder:getGradHiddenState(0))
end

--[[ Forward ]]--
function Seq2Seq:forward(inputEncode, inputDecode)
    self.encoder:forward(inputEncode)
    self:forwardConnect(inputEncode:size(1))
    out = self.decoder:forward(inputDecode)
    print(out)
end
