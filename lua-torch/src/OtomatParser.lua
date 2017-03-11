
function parserState1(idxPoint)
    -- body
    local bRet = false 
    if #tblListState < idxPoint + 1  then
        return bRet 
    else 
        -- state open bracket 
        if (tblListState[idxPoint + 1] == mapWordId["("]) then 
            bRet = parserState2(idxPoint + 1)
            return bRet
        end 
    end  

    return bRet 
end

function parserState2(idxPoint)
    local bRet = false 
    if #tblListState < idxPoint + 1  then
        return bRet 
    else 
        -- check next 
        local nextIdx = tblListState[idxPoint + 1]
        if (nextIdx==mapWordId["trang_thai"]) then 
            bRet = parserState19(idxPoint + 1)
            return bRet 
        elseif (nextIdx==mapWordId["not"]) then 
            lstState["not"] = true
            bRet = parserState175(idxPoint + 1)

            return bRet
        elseif (nextIdx==mapWordId["or"]) then 
            bRet = parserState3(idxPoint + 1)
            return bRet
        elseif (nextIdx==mapWordId["and"]) then 
            bRet = parserState4(idxPoint + 1)
            return bRet
        elseif (nextIdx==mapWordId["cam_xuc"]) then 
            bRet = parserState18(idxPoint + 1)
            return bRet
        end
    end  
    return bRet
end

function parserState3(idxPoint)
    local bRet = false 
    if #tblListState < idxPoint + 1  then
        return bRet 
    else 
        -- check next 
        if (tblListState[idxPoint + 1]==mapWordId["("]) then 
            bRet = parserState5(idxPoint + 1)
            return bRet 
        end
    end  
    return bRet
end

function parserState4(idxPoint)
    local bRet = false 
    if #tblListState < idxPoint + 1  then
        return bRet 
    else 
        -- check next 
        if (tblListState[idxPoint + 1]==mapWordId["("]) then 
            bRet = parserState5(idxPoint + 1)
            return bRet 
        end
    end  
    return bRet
end

function parserState5(idxPoint)
    local bRet = false 
    if #tblListState < idxPoint + 1  then
        return bRet 
    else 
        -- check next 
        local nextIdx = tblListState[idxPoint + 1]
        if (nextIdx==mapWordId["trang_thai"]) then 
            bRet = parserState7(idxPoint + 1)
            return bRet 
        elseif (nextIdx==mapWordId["not"]) then 
            lstState["not"] = true
            bRet = parserState6(idxPoint + 1)
            return bRet
        elseif (nextIdx==mapWordId["cam_xuc"]) then 
            bRet = parserState8(idxPoint + 1)
            return bRet
        end
    end  
    return bRet
end

function parserState6(idxPoint)
    local bRet = false 
    if #tblListState < idxPoint + 1  then
        return bRet 
    else 
        -- check next 
        local nextIdx = tblListState[idxPoint + 1]
        if (nextIdx==mapWordId["trang_thai"]) then 
            bRet = parserState7(idxPoint + 1)
            return bRet 
        elseif (nextIdx==mapWordId["cam_xuc"]) then 
            bRet = parserState8(idxPoint + 1)
            return bRet
        end
    end  
    return bRet
end

function parserState7(idxPoint)
    local bRet = false 
    if #tblListState < idxPoint + 1  then
        return bRet 
    else 
        -- check next 
        local nextIdx = tblListState[idxPoint + 1]
        if (nextIdx==mapWordId["("]) then 
            bRet = parserState9(idxPoint + 1)
            return bRet 
        end
    end  
    return bRet
end

function parserState8(idxPoint)
    local bRet = false 
    if #tblListState < idxPoint + 1  then
        return bRet 
    else 
        -- check next 
        local nextIdx = tblListState[idxPoint + 1]
        if (nextIdx==mapWordId["("]) then 
            bRet = parserState10(idxPoint + 1)
            return bRet 
        end
    end  
    return bRet
end

function parserState9(idxPoint)
    local bRet = false 
    if #tblListState < idxPoint + 1  then
        return bRet 
    else 
        -- check next 
        local nextIdx = tblListState[idxPoint + 1]
        if (nextIdx==mapWordId["ng.dung"]) then 
            bRet = parserState11(idxPoint + 1)
            return bRet 
        end
    end  
    return bRet
end

function parserState10(idxPoint)
    local bRet = false 
    if #tblListState < idxPoint + 1  then
        return bRet 
    else 
        -- check next 
        local nextIdx = tblListState[idxPoint + 1]
        if (nextIdx==mapWordId["ng.dung"]) then 
            bRet = parserState12(idxPoint + 1)
            return bRet 
        end
    end  
    return bRet
end

function parserState11(idxPoint)
    local bRet = false 
    if #tblListState < idxPoint + 1  then
        return bRet 
    else 
        -- check next 
        local nextIdx = tblListState[idxPoint + 1]
        if (nextIdx==mapWordId["state:i"]) then 
            if (lstState["state"] == nil) then 
                lstState["state"] = {}
            end
            if (lstState["not"] == true) then 
                lstState["not"] = nil
                table.insert(lstState["state"], -1)
            else 
                table.insert(lstState["state"], 1)
            end

            bRet = parserState13(idxPoint + 1)
            return bRet 
        end
    end  
    return bRet
end

function parserState12(idxPoint)
    local bRet = false 
    if #tblListState < idxPoint + 1  then
        return bRet 
    else 
        -- check next 
        local nextIdx = tblListState[idxPoint + 1]
        if (nextIdx==mapWordId["feel:i"]) then 
            if (lstState["feel"] == nil) then 
                lstState["feel"] = {}
            end
            if (lstState["not"] == true) then 
                lstState["not"] = nil
                table.insert(lstState["feel"], -1)
            else 
                table.insert(lstState["feel"], 1)
            end

            bRet = parserState14(idxPoint + 1)
            return bRet 
        end
    end  
    return bRet
end

function parserState13(idxPoint)
    local bRet = false 
    if #tblListState < idxPoint + 1  then
        return bRet 
    else 
        -- check next 
        local nextIdx = tblListState[idxPoint + 1]
        if (nextIdx==mapWordId[")"]) then 
            bRet = parserState15(idxPoint + 1)
            return bRet 
        end
    end  
    return bRet
end

function parserState14(idxPoint)
    local bRet = false 
    if #tblListState < idxPoint + 1  then
        return bRet 
    else 
        -- check next 
        local nextIdx = tblListState[idxPoint + 1]
        if (nextIdx==mapWordId[")"]) then 
            bRet = parserState15(idxPoint + 1)
            return bRet 
        end
    end  
    return bRet
end

function parserState15(idxPoint)
    local bRet = false 
    if #tblListState < idxPoint + 1  then
        return bRet 
    else 
        -- check next 
        local nextIdx = tblListState[idxPoint + 1]
        if (nextIdx==mapWordId["trang_thai"]) then 
            bRet = parserState7(idxPoint + 1)
            return bRet 
        elseif (nextIdx==mapWordId["not"]) then 
            lstState["not"] = true
            bRet = parserState6(idxPoint + 1)
            return bRet
        elseif (nextIdx==mapWordId["cam_xuc"]) then 
            bRet = parserState8(idxPoint + 1)
            return bRet
        elseif (nextIdx==mapWordId[")"]) then 
            bRet = parserState16(idxPoint + 1)
            return bRet
        end
    end  
    return bRet
end

function parserState16(idxPoint)
    local bRet = false 
    if #tblListState < idxPoint + 1  then
        return bRet 
    else 
        -- check next 
        local nextIdx = tblListState[idxPoint + 1]
        if (nextIdx==mapWordId["trang_thai"]) then 
            bRet = parserState7(idxPoint + 1)
            return bRet 
        elseif (nextIdx==mapWordId["not"]) then 
            lstState["not"] = true
            bRet = parserState6(idxPoint + 1)
            return bRet
        elseif (nextIdx==mapWordId["or"]) then 
            bRet = parserState3(idxPoint + 1)
            return bRet
        elseif (nextIdx==mapWordId["and"]) then 
            bRet = parserState4(idxPoint + 1)
            return bRet
        elseif (nextIdx==mapWordId["cam_xuc"]) then 
            bRet = parserState8(idxPoint + 1)
            return bRet
        elseif (nextIdx==mapWordId[")"]) then 
            bRet = parserState17(idxPoint + 1)
        return bRet
        end
    end  
    return bRet
end

function parserState17(idxPoint)
    if #tblListState == idxPoint  then
        return true 
    else 
        return false
    end
end


function parserState18(idxPoint)
    local bRet = false 
    if #tblListState < idxPoint + 4  then
        return bRet 
    else 
        -- check next 
        local nextIdx1 = tblListState[idxPoint + 1]
        local nextIdx2 = tblListState[idxPoint + 2]
        local nextIdx3 = tblListState[idxPoint + 3]
        local nextIdx4 = tblListState[idxPoint + 4]
        
        if (nextIdx1==mapWordId["("] and nextIdx2==mapWordId["ng.dung"]
            and nextIdx3==mapWordId["feel:i"] and nextIdx4==mapWordId[")"]
        ) then 
            if (lstState["feel"] == nil) then 
                lstState["feel"] = {}
            end
            if (lstState["not"] == true) then 
                lstState["not"] = nil
                table.insert(lstState["feel"], -1)
            else 
                table.insert(lstState["feel"], 1)
            end

            bRet = parserState20(idxPoint + 4)
            return bRet 
        end
    end  
    return bRet
end

function parserState19(idxPoint)
    local bRet = false 
    if #tblListState < idxPoint + 4  then
        return bRet 
    else 
        -- check next 
        local nextIdx1 = tblListState[idxPoint + 1]
        local nextIdx2 = tblListState[idxPoint + 2]
        local nextIdx3 = tblListState[idxPoint + 3]
        local nextIdx4 = tblListState[idxPoint + 4]
        
        if (nextIdx1==mapWordId["("] and nextIdx2==mapWordId["ng.dung"]
            and nextIdx3==mapWordId["state:i"] and nextIdx4==mapWordId[")"]
        ) then 
            if (lstState["state"] == nil) then 
                lstState["state"] = {}
            end
            if (lstState["not"] == true) then 
                lstState["not"] = nil
                table.insert(lstState["state"], -1)
            else 
                table.insert(lstState["state"], 1)
            end

            bRet = parserState20(idxPoint + 4)
            return bRet 
        end
    end  
    return bRet
end

function parserState20(idxPoint)
    local bRet = false 
    if #tblListState < idxPoint + 1  then
        return bRet 
    else 
        -- check next 
        local nextIdx = tblListState[idxPoint + 1]
        
        if (nextIdx==mapWordId[")"] ) then 
            bRet = parserState21(idxPoint + 1)
            return bRet 
        elseif (nextIdx==mapWordId["cam_xuc"] ) then 
            bRet = parserState18(idxPoint + 1)
            return bRet 
        elseif (nextIdx==mapWordId["trang_thai"] ) then 
            bRet = parserState19(idxPoint + 1)
            return bRet 
        end
    end  
    return bRet
end


function parserState21(idxPoint)
    if #tblListState == idxPoint then
        return true 
    else 
        return false
    end
end

function parserState175(idxPoint)
  local bRet = false 
    if #tblListState < idxPoint + 1  then
        return bRet 
    else 
        -- check next 
        local nextIdx = tblListState[idxPoint + 1]
        if (nextIdx==mapWordId["cam_xuc"] ) then 
            bRet = parserState18(idxPoint + 1)
            return bRet 
        elseif (nextIdx==mapWordId["trang_thai"] ) then 
            bRet = parserState19(idxPoint + 1)
            return bRet 
        end
    end  
    return bRet
end