require "../src/SymbolsManager.lua"
local stringx = require "pl.stringx"

function process_train_data(opt)
  require('pl.stringx').import()
  require 'pl.seq'

  local timer = torch.Timer()
  
  local data = {}

  local word_manager = SymbolsManager(true)
  word_manager:init_from_file(path.join(opt.data_dir, 'dictWord.txt'), 0, opt.max_vocab_size)
  local form_manager = SymbolsManager(true)
  form_manager:init_from_file(path.join(opt.data_dir, 'dictFormWord.txt'), 0, opt.max_vocab_size)

  print('loading text file...')
  local f = torch.DiskFile(path.join(opt.data_dir, opt.train .. '.txt'), 'r', true)
  f:clearError()
  local rawdata = f:readString('*l')
  while (not f:hasError()) do
    if (rawdata:strip():sub(1,2) ~= "//") and (#(rawdata:strip()) > 0) then 
      local l_list = rawdata:strip():split('=>')
      local w_list = word_manager:get_symbol_idx_for_list(l_list[1]:split(' '))
      local r_list = form_manager:get_symbol_idx_for_list(l_list[2]:split(' '))
      table.insert(data,{w_list,r_list})
    end
    -- read next line
    rawdata = f:readString('*l')
  end
  f:close()

  collectgarbage()

  -- save output preprocessed files
  local out_mapfile = path.join(opt.data_dir, 'map.t7')
  print('saving ' .. out_mapfile)
  torch.save(out_mapfile, {word_manager, form_manager})

  collectgarbage()

  local out_datafile = path.join(opt.data_dir, opt.train .. '.t7')
  print('saving ' .. out_datafile)
  torch.save(out_datafile, data)

  collectgarbage()
end

function serialize_data(opt, name)
  require('pl.stringx').import()
  require 'pl.seq'

  local fn = path.join(opt.data_dir, name .. '.txt')

  if not path.exists(fn) then
    print('no file: ' .. fn)
    return nil
  end

  local timer = torch.Timer()
  
  local word_manager, form_manager = table.unpack(torch.load(path.join(opt.data_dir, 'map.t7')))

  local data = {}

  print('loading text file...')
  local f = torch.DiskFile(fn, 'r', true)
  f:clearError()
  local rawdata = f:readString('*l')
  while (not f:hasError()) do
    if (rawdata:strip():sub(1,2) ~= "//") and (#(rawdata:strip()) > 0) then 
      local l_list = rawdata:strip():split('=>')
      local w_list = word_manager:get_symbol_idx_for_list(l_list[1]:split(' '))
      local r_list = form_manager:get_symbol_idx_for_list(l_list[2]:split(' '))
      table.insert(data,{w_list,r_list})
    end
    -- read next line
    rawdata = f:readString('*l')
  end
  f:close()

  collectgarbage()

  -- save output preprocessed files
  local out_datafile = path.join(opt.data_dir, name .. '.t7')
  -- print (data)
  -- assert(false )

  print('saving ' .. out_datafile)
  torch.save(out_datafile, data)
end

-- read file to table 
function  readMapSentence( sPathFile )
    local pairRets = {}
    for line in io.lines(sPathFile) do
      if (line:sub(1,2) ~= "//") and (#line > 0) then 
		    table.insert(pairRets, stringx.split(line, "=>"))
      end
    end
    return pairRets
end

function extractDict(mapSentences)
	-- extract form and word encode  
	local dictWord, dictFormLogic = {}, {}
	for k, v in pairs(mapSentences) do 
		local lstWord = stringx.split(v[1], " ")
		for k1,word in pairs (lstWord) do
			if dictWord[word] == nil then 
				dictWord[word] = 1
			else 
				dictWord[word] = dictWord[word] + 1
			end 
		end
		local lstFormWord = stringx.split(v[2], " ")
		for k1,word in pairs (lstFormWord) do
			if dictFormLogic[word] == nil then 
				dictFormLogic[word] = 1
			else 
				dictFormLogic[word] = dictFormLogic[word] + 1
			end 
		end
	end 
	return dictWord, dictFormLogic
end

local mapSentences = readMapSentence("train.txt")
local dictWord, dictFormLogic =  extractDict(mapSentences)
local pathDictWord, pathDictForm = "dictWord.txt", "dictFormWord.txt"
local fileDictWord = io.open(pathDictWord, "w")
local fileDictForm = io.open(pathDictForm, "w")

for k, v in pairs(dictWord) do 
	fileDictWord:write(k .. "\t" .. v .. "\n")
end 
fileDictForm:write("(\t" .. dictFormLogic["("] .. "\n")
fileDictForm:write(")\t" .. dictFormLogic[")"] .. "\n")
for k, v in pairs(dictFormLogic) do 
	if k ~= "(" and k ~= ")" then 
	  fileDictForm:write(k .. "\t" .. v .. "\n")
	end
end 
fileDictWord:close()
fileDictForm:close()

local cmd = torch.CmdLine()
cmd:option('-data_dir', '', 'data directory')
cmd:option('-train', 'train', 'train data path')
cmd:option('-test', 'test', 'test data path')
cmd:option('-min_freq', 0, 'minimum word frequency')
cmd:option('-max_vocab_size', 15000, 'maximum vocabulary size')
cmd:text()
opt = cmd:parse(arg)

process_train_data(opt)
serialize_data(opt, opt.test)
