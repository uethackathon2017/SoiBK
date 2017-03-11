-- init package 
if (RnnSemanticParser == nil) then 
    
    -- table save all sub class this project
    RnnSemanticParser = {
        model = {},
        dataset={}
    }
    
    -- init manual seed to gen random value without change
    torch.manualSeed(0)
end 
require "optim"
require 'xlua'
require "pl.stringx"
include("MinibatchLoader.lua")
include("Model.lua")
include("ParamsParser.lua")
include("SymbolsManager.lua")
include("utils.lua")
include("WordCombiner.lua")
include("OtomatParser.lua")
