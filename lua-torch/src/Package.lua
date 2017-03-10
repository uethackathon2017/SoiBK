-- init package 
RnnSemanticParser = {
    model = {},
    dataset={}
}

-- init manual seed to gen random value without change
torch.manualSeed(0)