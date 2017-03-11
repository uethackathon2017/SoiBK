function word_manager_convert_to_string(idx_list, f_out)
  local w_list = {}
  local count_word = 0
  if (torch.type (idx_list) == 'table') then 
    count_word =  #idx_list
    for i = 1, count_word do
      table.insert(w_list, word_manager:get_idx_symbol(idx_list[i]))
    end
  elseif (
    torch.type(idx_list) == 'torch.DoubleTensor'
    or torch.type(idx_list) == 'torch.IntTensor'
    or torch.type(idx_list) == 'torch.LongTensor'
    or torch.type(idx_list) == 'torch.FloatTensor'
  ) then 
    count_word = idx_list:size(1)
    for i = 1, count_word do
      table.insert(w_list, word_manager:get_idx_symbol(idx_list[i][1]))
    end
  else 
    print('input not process : '..torch.type(idx_list))
  end 
  
  return table.concat(w_list, ' ')
end

function convert_to_string(idx_list, f_out)
  local w_list = {}
  local count_word = 0
  if (torch.type (idx_list) == 'table') then 
    count_word =  #idx_list
    for i = 1, count_word do
      table.insert(w_list, form_manager:get_idx_symbol(idx_list[i]))
    end
  elseif (
    torch.type(idx_list) == 'torch.DoubleTensor'
    or torch.type(idx_list) == 'torch.IntTensor'
    or torch.type(idx_list) == 'torch.LongTensor'
    or torch.type(idx_list) == 'torch.FloatTensor'
  ) then 
    count_word = idx_list:size(1)
    for i = 1, count_word do
      table.insert(w_list, form_manager:get_idx_symbol(idx_list[i][1]))
    end
  else 
    print('input not process : '..torch.type(idx_list))
  end 
  
  return table.concat(w_list, ' ')
end

function shallowcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function isSameTable(x, y)
    local bRet = true 
    if (#x == #y)then 
      for i =1, #x do 
        if (x[i]~=y[i]) then 
          bRet = false
          break
        end 
      end
    else 
      bRet = false
    end

    return bRet 
end
