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
    local encoder       = nn.Sequential()
    local lookupTable   = nn.LookupTableMaskZero(lengDict, lengWordVector)
    local lstm          = nn.FastLSTM(lengWordVector, lengWordVector)
    local switchLayer   = nn.ConcatTable()              -- 1 input => n output
                            :add (nn.Identity())        -- for attention layer
                            :add (nn.Select(1,-1))      -- for decode layser
    
    encoder :add(lookupTable)
            :add(nn.Sequencer(lstm:maskZero(1)))
            :add(switchLayer)
    self.encoder = encoder
    print (self.encoder)

    --
    -- init decode layer 
    local   decoder       = nn.Sequential()
            lookupTable   = nn.LookupTableMaskZero(lengDict, lengWordVector)
            lstm          = nn.FastLSTM(lengWordVector, lengWordVector)            
    local   linear        = nn.Linear(lengWordVector, lengLabel)
    local   logSofmax     = nn.LogSoftMax()            
    
    decoder :add(lookupTable)
            :add(nn.Sequencer(lstm:maskZero(1)))
            :add(nn.Sequencer(nn.MaskZero(linear,1)))
            :add(nn.Sequencer(nn.MaskZero(logSofmax,1)))
                

    --
    -- test model 
    x  = torch.Tensor({{0,2,5}, {3,4,5}}):t()
    print (x)

    y  = encoder:forward(x)
    print (y[1])
    print (y[2])

    return encoder
end


