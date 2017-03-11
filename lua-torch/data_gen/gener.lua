
-- read file to table 
function linesFromFile( sPathFile )
    local pairRets = {}
    for line in io.lines(sPathFile) do
        table.insert(pairRets, line)
    end
    return pairRets
end


-- read file to table 
function cloneTable( table )
    local newTable = {}
    for k, v in pairs(table) do 
        newTable[k] = v
    end 
    return newTable
end

-- load file metadata
local listFileName = {"s", "time", "verb", "level-before","state","level-after"}
local elementsSentence = {}
for k, v in pairs(listFileName) do 
    elementsSentence[v] = linesFromFile(v)
end

-- generate state define sentence
-- print(elementsSentence)
function generate(elementsSentence) 
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

generate(elementsSentence)