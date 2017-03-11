require 'nn'
require 'rnn'

-- ------------------------------------------------------------------------------------------
-- require init package = global variant table with path to RnnSemanticParser.model
local Seq2Seq = torch.class("RnnSemanticParser.model.Seq2Seq") 

-- ------------------------------------------------------------------------------------------
-- constructor 
function Seq2Seq:__init(lengDict, lengWordVector, lengLabel, dropoutRate, isUseCuda)

    --
    -- init encode layer 
    -- batch x seqEncodeSize[word-encode id] => batch x SeqLengEncode x HiddenSize [double value]
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
    -- batch x seqEncodeSize[word-decode id] => batch x SeqLengDecode x HiddenSize [double value]
    local   lookupTableD  = nn.LookupTableMaskZero(lengDict, lengWordVector)
    self.lstmDecoder      = nn.FastLSTM(lengWordVector, lengWordVector)            
    local   linear        = nn.Linear(lengWordVector, lengLabel)
    local   logSofmax     = nn.LogSoftMax()            
    self.decoder          = nn.Sequential()
                                :add(lookupTableD)
                                :add(nn.Sequencer(self.lstmDecoder:maskZero(1)))
                                -- :add(nn.Sequencer(nn.MaskZero(linear,1)))
                                -- :add(nn.Sequencer(nn.MaskZero(logSofmax,1)))
    --
    -- init attention layer 
    -- {input1, input2} => output
    --      input1 =  out of encoder{1,SeqLengEncode} : matrix [batchxSeqLengEnxHiddenSize]
    --      input2 =  out of decoder{1,SeqLengEncode} : matrix [batchxSeqLengDexHiddenSize]
    local attention = nn.Sequential()
                              :add(nn.MM(false, true))
                              :add(nn.SplitTable(3))
                              :add(nn.Sequencer(nn.MaskZero(nn.SoftMax(), 1)))
                              :add(nn.Sequencer(nn.View(-1,1):setNumInputDims(1)))
                              :add(nn.JoinTable(2,2))

    local encodeAttention = nn.ConcatTable()
                                :add(nn.Sequential()
                                        :add(nn.ConcatTable()
                                                  :add(nn.SelectTable(1)) -- to get encode state output
                                                  :add(attention))        -- calculate s_t_k
                                        :add(nn.MM(true, false)))
                                :add(nn.Sequential()
                                        :add(nn.SelectTable(2))     -- to get decode state output
                                        :add(nn.Transpose({2,3})))  -- transpose dims 2 vs 3
    
    self.attention = nn.Sequential()
            :add(encodeAttention)
            :add(nn.JoinTable(2))
            :add(nn.SplitTable(3))
            :add(nn.Sequencer(nn.MaskZero(nn.Linear(2*lengWordVector, lengWordVector), 1)))
            :add(nn.Sequencer(nn.MaskZero(nn.Tanh(), 1)))
            :add(nn.Sequencer(nn.MaskZero(nn.Dropout(dropoutRate),1)))
            :add(nn.Sequencer(nn.MaskZero(nn.Linear(lengWordVector, lengLabel),1)))
            :add(nn.Sequencer(nn.MaskZero(nn.LogSoftMax(),1)))
    
    --
    -- init criterion 
    -- if batchSize > 1 then
        self.criterion = nn.SequencerCriterion(nn.MaskZeroCriterion(nn.ClassNLLCriterion(),1))
    -- else
    --     self.criterion = nn.SequencerCriterion(nn.ClassNLLCriterion())
    -- end

    --
    -- init transpose 
    self.parseInputAttention = nn.ParallelTable() 
                                    :add(nn.Transpose({1,2}))
                                    :add(nn.Transpose({1,2}))

    self.isUseCuda = isUseCuda
    if (isUseCuda) then 
        self.encoder = self.encoder:cuda()
        self.decoder = self.decoder:cuda()
        self.attention = self.attention:cuda()
        self.attention = self.attention:cuda()
        self.criterion = self.criterion:cuda()
        self.parseInputAttention = self.parseInputAttention:cuda()
    end 
    -- test model 
    -- x  = torch.Tensor({{0,2,5}, {3,4,5}}):t()
    -- print (x)

    -- y  = self.encoder:forward(x)
    -- print (lstmDecoder:get(1):get(1):get(1))
	-- y  = decoder:forward(x)
end

-- ------------------------------------------------------------------------------------------
--[[ Forward coupling: Copy encoder cell and output to decoder LSTM ]]--
function Seq2Seq:forwardConnect(inputSeqLen)
	self.lstmDecoder.userPrevOutput =
    	rnn.recursiveCopy(self.lstmDecoder.userPrevOutput, self.lstmEncoder.outputs[inputSeqLen])
	self.lstmDecoder.userPrevCell =
    	rnn.recursiveCopy(self.lstmDecoder.userPrevCell, self.lstmEncoder.cells[inputSeqLen])
end

-- ------------------------------------------------------------------------------------------
--[[ Backward coupling: Copy decoder gradients to encoder LSTM ]]--
function Seq2Seq:backwardConnect(inputSeqLen)
  	self.lstmEncoder:setGradHiddenState(inputSeqLen, self.lstmDecoder:getGradHiddenState(0))
end

-- ------------------------------------------------------------------------------------------
--[[ Forward ]]--
function Seq2Seq:forward(inputEncode, inputDecode, targetDecode)
    self.outputEncode       = self.encoder:forward(inputEncode)
    self:forwardConnect(inputEncode:size(1))
    self.outputDecode       = self.decoder:forward(inputDecode)

    self.inputAttention     = self.parseInputAttention:forward({
                                    self.outputEncode,
                                    self.outputDecode
                                })
    self.outputAttention    = self.attention:forward(self.inputAttention)
    local splitTargetDecode = nn.SplitTable(1)
    if (self.isUseCuda == true) then 
        splitTargetDecode = splitTargetDecode:cuda()
    end
    return (self.criterion:forward(self.outputAttention, splitTargetDecode(targetDecode)))
end

-- ------------------------------------------------------------------------------------------
--[[ Backward ]]--
function Seq2Seq:backward(inputEncode, inputDecode, targetDecode)
    local splitTargetDecode = nn.SplitTable(1)
    if (self.isUseCuda == true) then 
        splitTargetDecode = splitTargetDecode:cuda()
    end
    local dloss_dx      = self.criterion:backward(self.outputAttention, splitTargetDecode(targetDecode))
    local gradInputAtt  = self.attention:backward(self.inputAttention, dloss_dx)
    local gradOutLstm   = self.parseInputAttention:backward(self.inputAttention, gradInputAtt)

    self.decoder:backward(inputDecode, gradOutLstm[2])
    self:backwardConnect(inputEncode:size(1))
    self.encoder:backward(inputEncode,  gradOutLstm[1])
end

-- ------------------------------------------------------------------------------------------
function Seq2Seq:getParameters()
  return nn.Container()
            :add(self.encoder)
            :add(self.decoder)
            :add(self.parseInputAttention)
            :add(self.attention)
            :getParameters()
end

-- ------------------------------------------------------------------------------------------
--[[ matrix -> table ]]--
function SplitOutputTable(input, isBatchSizeFirst)
    local modelConvert = nn.Sequential()
                        :add(nn.JoinTable(1))
                        :add(nn.View(#input, input[1]:size(1), input[1]:size(2)))
    if(isBatchSizeFirst == true) then 
        modelConvert    :add(nn.Transpose({1,2}))
    end 
    return modelConvert(input)
end

-- ------------------------------------------------------------------------------------------
--[[ test ]]--
function Seq2Seq:testAttention()
    torch.manualSeed(1)
    opt = {}
    opt.rnn_size = 10

    linear = nn.Linear(2*opt.rnn_size, opt.rnn_size)

    x1  = torch.Tensor({{0,2,5}, {3,4,5}}):t()
    x2  = torch.Tensor({{2,5,6,7,0}, {2,3,4,5,0}}):t()
    y1  = torch.Tensor({{5,6,7,8,0}, {3,4,5,8,5}}):t()

    x1  = torch.rand(3,5,10)
    x2  = torch.rand(3,7,10)
    x1[1][1] :fill(0)
    x1[1][2] :fill(0)
    x1[2][1] :fill(0)
    x2[1][7] :fill(0)
    x2[2][7] :fill(0)
    x2[2][6] :fill(0)
    print (x1, x2)

    enc_s_top = x1 
    dec_s_top = torch.Tensor(3,10):copy(nn.SelectTable(1)(nn.SplitTable(2)(x2)))
    print (dec_s_top)

    -- (batch*length*H) * (batch*H*1) = (batch*length*1)
    local dot = nn.MM()({enc_s_top, nn.View(opt.rnn_size ,1):setNumInputDims(1)(dec_s_top)})
    local attention = nn.SoftMax()(nn.Sum(3)(dot))
    --   print (attention)
    -- (batch*length*H)^T * (batch*length*1) = (batch*H*1)
    local enc_attention = nn.MM(true, false)({enc_s_top, nn.View(-1, 1):setNumInputDims(1)(attention)})
    print ("hid")
    -- print(nn.Sum(3)(enc_attention))
    local hid = nn.Tanh()(linear(nn.JoinTable(2)({nn.Sum(3)(enc_attention), dec_s_top})))
    print ("hid")
    -- print (hid)
    -- local h2y_in = hid
    print ("afhhihii")
    local attention = nn.Sequential()
                                :add(nn.MM(false, true))
                                :add(nn.SplitTable(3))
                                :add(nn.Sequencer(nn.MaskZero(nn.SoftMax(), 1)))
                                :add(nn.JoinTable(1))
                                :add(nn.View(7,3,5))              -- seqDec x batch x seqEnc 
                                :add(nn.Transpose({1,2}, {2,3}))  -- batch x seqEnc x seqDec
    local attention2 = nn.Sequential()
                                :add(nn.MM(false, true))
                                :add(nn.SplitTable(3))
                                :add(nn.Sequencer(nn.MaskZero(nn.SoftMax(), 1)))
                                :add(nn.Sequencer(nn.View(-1,1):setNumInputDims(1)))
                                :add(nn.JoinTable(2,2))

    local encodeAttention = nn.ConcatTable()
                                :add(nn.Sequential()
                                        :add(nn.ConcatTable()
                                                  :add(nn.SelectTable(1)) -- to get encode state output
                                                  :add(attention))        -- calculate s_t_k
                                        :add(nn.MM(true, false)))
                                :add(nn.Sequential()
                                        :add(nn.SelectTable(2))     -- to get decode state output
                                        :add(nn.Transpose({2,3})))  -- transpose dims 2 vs 3
    
    local modelAttention = nn.Sequential()
            :add(encodeAttention)
            :add(nn.JoinTable(2))
            :add(nn.SplitTable(3))
            :add(nn.Sequencer(nn.MaskZero(linear, 1)))
            :add(nn.Sequencer(nn.MaskZero(nn.Tanh(), 1)))
            :add(nn.Sequencer(nn.MaskZero(nn.LogSoftMax(),1)))
    
    out =  (attention:forward({x1, x2}))
    out2 =  (attention2:forward({x1, x2}))
    -- local hi =  attention:backward({x1, x2}, out)
    -- print ({x1, x2})
    print (out)
    print (out2)
    -- print (out[1])
    -- print (out[6])
    -- print (out[7])
end