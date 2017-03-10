require("ParamsParser")
require("Package")
require("Model")

opt = ParamsParser()
torch.manualSeed(1)
 opt = {}
 opt.rnn_size = 10

linear = nn.Linear(2*opt.rnn_size, opt.rnn_size)
-- linear.weight = torch.rand(2*opt.rnn_size, opt.rnn_size):t()
-- print (linear(torch.Tensor(2*opt.rnn_size):fill(7)))
-- model = RnnSemanticParser.model.Seq2Seq()

x1  = torch.Tensor({{0,2,5}, {3,4,5}}):t()
x2  = torch.Tensor({{2,5,6,7,0}, {2,3,4,5,0}}):t()
y1  = torch.Tensor({{5,6,7,8,0}, {3,4,5,8,0}}):t()

-- y = model:forward(x1, x2, y1)
-- y = model:backward(x1, x2, y1)
x1  = torch.rand(3,5,10)--:fill(1)
x2  = torch.rand(3,7,10) -- :fill(2)
x2[1]:fill(1)
x2[2]:fill(2)
x2[3]:fill(3)

 enc_s_top = x1 
 dec_s_top = torch.rand(3,10)--(nn.SplitTable(2)(x2))[1]
 dec_s_top[1]:fill(1)
 dec_s_top[2]:fill(2)
 dec_s_top[3]:fill(3)
--  print (enc_s_top, dec_s_top)

 -- (batch*length*H) * (batch*H*1) = (batch*length*1)
  local dot = nn.MM()({enc_s_top, nn.View(opt.rnn_size ,1):setNumInputDims(1)(dec_s_top)})
  local attention = nn.SoftMax()(nn.Sum(3)(dot))
--   print (attention)
  -- (batch*length*H)^T * (batch*length*1) = (batch*H*1)
  local enc_attention = nn.MM(true, false)({enc_s_top, nn.View(-1, 1):setNumInputDims(1)(attention)})
  print ("hid")
  print(nn.Sum(3)(enc_attention))
  local hid = nn.Tanh()(linear(nn.JoinTable(2)({nn.Sum(3)(enc_attention), dec_s_top})))
  print ("hid")
  print (hid)
  -- local h2y_in = hid

    local model = nn.Sequential()

    local encodeAttention = nn.Sequential()
                              :add(nn.MM(false, true))
                              :add(nn.SplitTable(3))
                              :add(nn.Sequencer(nn.SoftMax()))
                              :add(nn.JoinTable(1))
                              :add(nn.View(7,3,5))  -- seqDec x batch x seqEnc 
                              :add(nn.Transpose({1,2}, {2,3}))  -- seqDec x batch x seqEnc 

    local attentionLayer = nn.ConcatTable()
                                :add(
                                    nn.Sequential()
                                        :add( nn.ConcatTable()
                                                  :add(nn.SelectTable(1))
                                                  :add(encodeAttention)
                                        )
                                        :add(nn.MM(true, false))
                                )
                                :add( nn.Sequential()
                                                :add(nn.SelectTable(2))
                                                :add(nn.Transpose({2,3}))
                                )
    model   :add(attentionLayer)
            -- :add(nn.JoinTable(2))
            -- :add(nn.SplitTable(3))
            -- :add(nn.Sequencer(linear))
            -- :add(nn.Sequencer(nn.Tanh()))
    
    out =  (model:forward({x1, x2}))
    print (out)
    print (out[1])
    -- print (out[1][2])

    -- print (out[2][1])
    -- print (out[2][2])
