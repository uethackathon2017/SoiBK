-- include "../src/Package.lua" 

-- ------------------------------------------------------------------------------------------
-- require init package = global variant table with path to RnnSemanticParser
local WordCombiner = torch.class("RnnSemanticParser.WordCombiner") 

-- ------------------------------------------------------------------------------------------
-- init object
-- ------------------------------------------------------------------------------------------
function WordCombiner:__init()
end 

-- ------------------------------------------------------------------------------------------
-- generate state define sentence
-- ------------------------------------------------------------------------------------------
function WordCombiner:generate(elementsSentence) 
    local sentences = {}
    local bEmptyListSentence = true 
    
    for i = #listFileName - 1, 1, -1 do 
        local key = listFileName[i]
        local values = elementsSentence[key]

        -- add new element to sentence 
        local tmpSentences = {}
        for idSentence, sentence in pairs(sentences) do 
            for k, v in pairs(values) do 
                local newSentences = cloneTable(sentence)
                table.insert(newSentences, 1, v)
                table.insert(tmpSentences, newSentences)
            end 
        end
        for k, v in pairs (tmpSentences) do 
            table.insert( sentences, v)
        end 

        -- add new init sentence 
        if bEmptyListSentence then 
            bEmptyListSentence = false
            for k, v in pairs(values) do 
                table.insert(sentences, {v})
            end 
            -- add new element to sentence 
            local valuesLevelAfter = elementsSentence[listFileName[#listFileName]]
            local tmpSentences = {}
            for idSentence, sentence in pairs(sentences) do 
                for k, v in pairs(valuesLevelAfter) do 
                    local newSentences = cloneTable(sentence)
                    table.insert(newSentences, v)
                    table.insert(tmpSentences, newSentences)
                end 
            end
            for k, v in pairs (tmpSentences) do 
                table.insert( sentences, v)
            end 
        end 

        for k, v in pairs(sentences) do 
            print (table.concat(v, " "))
        end 
        
    end 
   
end 

-- ------------------------------------------------------------------------------------------
-- load file metadata
-- ------------------------------------------------------------------------------------------
function WordCombiner:loadDictRecombine(listFileName, prefixFolder)
    self.elementsSentence = {}     -- ds cac dong trong cac file {filename => {line1 => word1,..}}
    self.dictWordCombine = {}      -- du lieu word recombine
    local pathFolder  = ""
    if (prefixFolder ~= nil ) then 
        pathFolder = prefixFolder
    end 

    for k, fileName in pairs(listFileName) do  
        local lineTbl = linesFromFile(pathFolder .. fileName)

        -- load each line 
        for lineId, word in pairs(lineTbl) do 
            if (self.dictWordCombine[word] ~= nil)then 
                print("dupplicate value of word: ".. word .. ' of file: '..fileName)
                print (self.dictWordCombine[word])
            end
            -- save info word combine index
            self.dictWordCombine[word] = {}
            table.insert( self.dictWordCombine[word], fileName )
            table.insert( self.dictWordCombine[word], lineId )
        end 
        self.elementsSentence[fileName] = lineTbl
    end
end 

-- ------------------------------------------------------------------------------------------
-- load file metadata
-- ------------------------------------------------------------------------------------------
function WordCombiner:findInDictRecombine(infoWord)
    if (torch.type(infoWord) == "table") then 
        for word, info in pairs(self.dictWordCombine) do 
            if (info[1] == infoWord[1] and info[2] == infoWord[2]) then 
                return word
            end 
        end 
    end
    return nil
end

-- ------------------------------------------------------------------------------------------
-- load dict Infernot
-- ------------------------------------------------------------------------------------------
function WordCombiner:loadDictInferNot(listFileName, prefixFolder)
    self.dictWordInferNot = {}     -- ds cac dong trong cac file {filename => {line1 => word1,..}}
    local pathFolder  = ""
    if (prefixFolder ~= nil ) then 
        pathFolder = prefixFolder
    end 
    for k, fileName in pairs(listFileName) do  
        local lineTbl = linesFromFile(pathFolder .. fileName)

        -- load each line 
        for lineId, line in pairs(lineTbl) do 
            local info = line:split(":")
            if(#info == 2) then 
                if(self.dictWordCombine[info[2]] == nil)then 
                    print("not found value of word: ".. info[2])
                end
                -- save info word infer combine index
                self.dictWordInferNot[info[1]] = self.dictWordCombine[info[2]]
            else 
                print ("line err size ".. line)
            end
        end 
    end
end 

-- ------------------------------------------------------------------------------------------
-- get Infernot
-- ------------------------------------------------------------------------------------------
function WordCombiner:getInferNot(info)
    local word = self:findInDictRecombine(info)
    return self.dictWordInferNot[word]
end 
-- ------------------------------------------------------------------------------------------
-- combine sentence
-- input: sentence is seperate by " " each word 
-- out: sentence is replace with combine info 
-- ------------------------------------------------------------------------------------------
function WordCombiner:combineSentence(sSentence)
    local lstWord = sSentence:split(" ")
    local sSentenceCombined = ""
    local infoCombined = {}
    for idx, word in pairs (lstWord) do 
        if (#word > 0) then 
            local info = self.dictWordCombine[word]
            if  info == nil then 
                -- skeep this word 
                sSentenceCombined = sSentenceCombined .." " .. word
                table.insert( infoCombined, -1)
            else 
                -- combined this word and info 
                sSentenceCombined = sSentenceCombined .. " " .. info[1]
                table.insert( infoCombined, info)
            end 
        end 
    end 
    if (#sSentenceCombined > 0) then 
        sSentenceCombined = sSentenceCombined:sub(2)
    end 
    return sSentenceCombined, infoCombined
end 

-- ------------------------------------------------------------------------------------------
-- parse state word generated from model 
-- ------------------------------------------------------------------------------------------
function WordCombiner:parseStateInfer(stateInfered)
    
    -- parse stateInfered to validate result and reIndex from infoCombined 
    -- local partermFuncName = "(cam_xuc|trang_thai)"
    -- local partermArgs = "ng.dung (feel:i|state:i)"
    -- local partermProlog = string.format("%s \\( %s \\)", partermFuncName, partermArgs)
    -- local partermNotProlog = string.format("not %s", partermProlog)
    -- local partermFunc = string.format("(%s|%s)", partermProlog, partermNotProlog)
    -- local andLogic = string.format("and \\( (%s)+ \\)", partermFunc)
    -- local orLogic = string.format("or \\( (%s)+ \\)", partermFunc)
    -- local logic = string.format("(%s|%s|%s)", andLogic, orLogic, partermFunc)
    
    local partermFeel = "cam_xuc %( ng%.dung (feel:i) %)"
    local partermState = "trang_thai %( ng%.dung (state:i) %)"
    local partermNotFeel = "not (feel:i)"
    local partermNotState = "not (state:i)"
    local partermAndLogic = "and %( (.*) %)"
    local partermOrLogic = "or ( .* )"
    
    local infer1, infer2, count
    stateInfered, count = string.gsub(stateInfered, partermState, "%1")
    if(count > 0) then 
       stateInfered = string.gsub(stateInfered, partermNotState, "%1-")
    end 
    stateInfered, count = string.gsub(stateInfered, partermFeel, "%1")
    if(count > 0) then 
        stateInfered = string.gsub(stateInfered, partermNotFeel, "%1-")
    end
    
    return stateInfered
end

-- ------------------------------------------------------------------------------------------
-- get state word generated from model 
-- ------------------------------------------------------------------------------------------
function WordCombiner:getStateInfer(infoCombined, stateInfered)
    local bGotState = false
    local bGotFeel = false
    
    -- lst State
    local lstState, lstFeel = {}, {} 
    for idx, info in pairs(infoCombined) do 
        if (torch.type(info) == "table") then 
            if info[1] == "state" then 
                table.insert(lstState, info)
            elseif info[1] == "feel" then 
                table.insert(lstFeel, info)
            end
        end 
    end 
    -- validate open and close backet ()


    -- parse stateInfered to validate result and reIndex from infoCombined 
    stateInfered = self:parseStateInfer(stateInfered)
    local idxState, idxFeel = 1, 1
    for k in string.gmatch(stateInfered, "state:i ") do
        if idxState > #lstState then 
            print("warning some state1 lost: idxState > #lstState in getStateInfer")
            bGotState = false
            break
        else 
            stateInfered = string.gsub(stateInfered, "state:i ", 
                lstState[idxState][1] .. ":" .. lstState[idxState][2] .. " ", 1)
            bGotState = true
        end
        idxState = idxState + 1
    end

    for k in string.gmatch(stateInfered, "feel:i ") do
        if idxFeel > #lstFeel then 
            print("warning some feel1 lost: idxFeel > #lstFeel in getStateInfer")
            bGotFeel = false
            break
        else
            stateInfered = string.gsub(stateInfered, "feel:i ", 
                lstFeel[idxFeel][1] .. ":" .. lstFeel[idxFeel][2] .." ", 1)
            bGotFeel = true
        end 
        idxFeel = idxFeel + 1
    end

    -- parse stateInferedNot
    local idxState, idxFeel = 1, 1
    for k in string.gmatch(stateInfered, "state:i-") do
        if idxState > #lstState then 
            print("warning some state lost: idxState > #lstState in getStateInfer")
            break
        else 
            local info = self:getInferNot (lstState[idxState])
            stateInfered = string.gsub(stateInfered, "state:i%-", 
                 info[1] .. ":" .. info[2], 1)
            bGotState = true
        end
        idxState = idxState + 1
    end

    for k in string.gmatch(stateInfered, "feel:i-") do
        if idxFeel > #lstFeel then 
            print("warning some feel lost: idxFeel > #lstFeel in getStateInfer")
            break
        else
            local info = self:getInferNot (lstFeel[idxFeel])
            stateInfered = string.gsub(stateInfered, "feel:i%-", 
                info[1] .. ":" ..info[2], 1)
            bGotFeel = true
        end 
        idxFeel = idxFeel + 1
    end
    
    -- parse andOrLogic
    lstStateRet= {}
    local partermEmotion = "(%w+:%d+)"
    print(stateInfered)
    if (bGotFeel == true or bGotState == true) then 
        for state in string.gmatch(stateInfered, partermEmotion) do
            local info = state:split(":")
            if (lstStateRet[info[1]] == nil) then 
                lstStateRet[info[1]] = info[2]+0
            elseif(info[2]+0 <= lstStateRet[info[1]]) then
                lstStateRet[info[1]] = info[2]+0
            end
        end
    else 
        print (":: not detect this Emotion")
    end

    -- convert id state and feel to string 
    if (lstStateRet["state"] == nil)then
        lstStateRet["state"] = "bình_thường"
    else
        lstStateRet["state"] =  self:findInDictRecombine({"state", lstStateRet["state"]})
    end
    if (lstStateRet["feel"] == nil)then
        lstStateRet["feel"] = "không_cảm_xúc"
    else 
        lstStateRet["feel"] =  self:findInDictRecombine({"feel", lstStateRet["feel"]})
    end 


    return lstStateRet
end

-- ------------------------------------------------------------------------------------------
-- get state word generated from model 
-- ------------------------------------------------------------------------------------------
function WordCombiner:getStateInfer2(infoCombined, stateInferedTbl, form_manager)
    local bGotState = false
    local bGotFeel = false
    local lstStateRet = {}
    lstStateRet["state"] = "bình_thường"
    lstStateRet["feel"] = "không_cảm_xúc"

    -- lst State
    local lstStateEncode, lstFeelEncode = {}, {} 
    for idx, info in pairs(infoCombined) do 
        if (torch.type(info) == "table") then 
            if info[1] == "state" then 
                table.insert(lstStateEncode, info)
            elseif info[1] == "feel" then 
                table.insert(lstFeelEncode, info)
            end
        end 
    end 

    tblListState = stateInferedTbl
    mapWordId = form_manager.symbol2idx
    lstState = {}
    
    local bCheck = parserState1(0)
    
    local stateInfo = nil
    local feelInfo = nil
    print (lstFeelEncode, lstStateEncode)
    -- combine state infered 
    if (bCheck == true) then 
        local states = lstState["state"]    
        local feels = lstState["feel"]

        -- xu ly state trong ds cac state
        if(states  ~= nil and #states == #lstStateEncode) then 
            for k, v in pairs(states) do 
                -- lay thong tin state hien tai 
                local curState = nil
                if (v == -1) then 
                    -- not state or not feel 
                    curState = self:getInferNot(lstStateEncode[k])
                elseif (v == 1) then 
                    curState = lstStateEncode[k]
                end 
                
                -- toi uu chuoi state -> chon state co id thap hon
                if (stateInfo == nil) then 
                    stateInfo = curState
                else
                    if (stateInfo[2] > curState[2]) then 
                        stateInfo = curState
                    end 
                end
            end
        else 
            print("[W] count state not equal!")
        end    

        -- xu ly feel trong ds cac feel 
        if(feels ~= nil and #feels == #lstFeelEncode) then 
            for k, v in pairs(feels) do 
                -- lay thong tin feel hien tai 
                local curFeel = nil
                if (v == -1) then 
                    -- not state or not feel 
                    curFeel = self:getInferNot(lstFeelEncode[k])
                elseif (v == 1) then 
                    curFeel = lstFeelEncode[k]
                end 
                
                -- toi uu chuoi state -> chon feel co id thap hon
                if (feelInfo == nil) then 
                    feelInfo = curFeel
                elseif (feelInfo[2] > curFeel[2]) then 
                    feelInfo = curFeel
                end 
            end
        end

    else 
        print("[W] bCheck validate infer state = FAIL")
    end
    
    -- get word - save and return 
    print (feelInfo)
    print (stateInfo)
    if (feelInfo ~= nil) then 
        lstStateRet["feel"] = self:findInDictRecombine(feelInfo)
    end 
    if (stateInfo ~= nil) then 
        lstStateRet["state"] = self:findInDictRecombine(stateInfo)
    end 
    
    print ("sdfsdfsdf")
    print (lstStateRet)
    print ("sdfsdfsdf")
    return lstStateRet
end

-- ------------------------------------------------------------------------------------------
-- test this class 
-- ------------------------------------------------------------------------------------------
-- local wordCombiner = RnnSemanticParser.WordCombiner()
-- local listFileName = {"feel","level-after", "level-before",
--     "s","state", "time", "time-long", "verb"}
-- wordCombiner:loadDictRecombine(listFileName)

-- listFileName = {"state-not", "feel-not"}
-- wordCombiner:loadDictInferNot(listFileName)

-- local sSentence, info =  wordCombiner:combineSentence("vừa buồn vừa chán vừa đau_đầu quá")
-- -- print ( "|".. sSentence .. "|")
-- print (info)
-- wordCombiner:getStateInfer(info, sSentence)

-- generate(elementsSentence)