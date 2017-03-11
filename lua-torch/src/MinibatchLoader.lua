local MinibatchLoader = {}
MinibatchLoader.__index = MinibatchLoader

local function to_vector_list(l)
  for i = 1, #l do
    l[i] = l[i][{{},1}]
  end
  return l
end


function MinibatchLoader.create(opt, name)
  local self = {}
  setmetatable(self, MinibatchLoader)

  local data_file = path.join(opt.data_dir, name .. '.t7')

  print('loading data: ' .. name)
  local data = torch.load(data_file)

  -- batch padding
  if #data % opt.batch_size ~= 0 then
    local n = #data
    for i = 1, #data % opt.batch_size do
      table.insert(data, n-i+1, data[n-i+1])
    end
  end
  
  self.enc_batch_list = {}
  self.enc_len_batch_list = {}
  self.dec_batch_list = {}
  local p = 0
  local newData = {}
  local mtIdx = torch.randperm(#data)
  for i = 1, #data  do
    newData[i] = data[mtIdx[i]]
  end
  data = newData
  newData = nil 

  while p + opt.batch_size <= #data do
    -- build enc matrix --------------------------------
    local max_len = -1
    for i = 1, opt.batch_size do
      local w_list = data[p + i][1]
      if #w_list > max_len then
        max_len = #w_list
      end
    end

    local m_text = torch.zeros(opt.batch_size, max_len + 2)
    local enc_len_list = {}
    
	for i = 1, opt.batch_size do
      local w_list = data[p + i][1]

	  -- add <S>
	  m_text[i][max_len + 2 - (#w_list + 2) + 1] = 1	

	  -- add <E>
	  m_text[i][max_len + 2] = 2	
		
	  -- reversed order
      for j = 1, #w_list do
		m_text[i][max_len + 2 - (#w_list + 2) + j + 1] = w_list[#w_list - j + 1]
		-- m_text[i][j + 1] = w_list[j]
      end

      table.insert(enc_len_list, #w_list + 2)
    end
    table.insert(self.enc_batch_list, m_text)
    table.insert(self.enc_len_batch_list, enc_len_list)
    
	-- build dec matrix --------------------------------
    max_len = -1
    for i = 1, opt.batch_size do
      local w_list = data[p + i][2]
      if #w_list > max_len then
        max_len = #w_list
      end
    end
    m_text = torch.zeros(opt.batch_size, max_len + 2)
    -- add <S>
    m_text[{{}, 1}] = 1
    for i = 1, opt.batch_size do
      local w_list = data[p + i][2]
      for j = 1, #w_list do
        m_text[i][j + 1] = w_list[j]
      end
      -- add <E>
      m_text[i][#w_list + 2] = 2
    end
    table.insert(self.dec_batch_list, m_text)
    p = p + opt.batch_size
  end

  -- reset batch index
  self.num_batch = #self.enc_batch_list
  self.num_sample= #data

  assert(#self.enc_batch_list == #self.dec_batch_list)

  collectgarbage()
  return self
end

-- function MinibatchLoader.create(opt, name)
--   local self = {}
--   setmetatable(self, MinibatchLoader)

--   local data_file = path.join(opt.data_dir, name .. '.t7')

--   print('loading data: ' .. name)
--   local data = torch.load(data_file)

--   -- batch padding
--   if #data % opt.batch_size ~= 0 then
--     local n = #data
--     for i = 1, #data % opt.batch_size do
--       table.insert(data, n-i+1, data[n-i+1])
--     end
--   end
  
--   self.enc_batch_list = {}
--   self.enc_len_batch_list = {}
--   self.dec_batch_list = {}
--   local p = 0
--   while p + opt.batch_size <= #data do
--     -- build enc matrix --------------------------------
--     local max_len = #data[p + opt.batch_size][1]
--     local m_text = torch.zeros(opt.batch_size, max_len + 2)
--     local enc_len_list = {}
--     -- add <S>
--     m_text[{{}, 1}] = 1
--     for i = 1, opt.batch_size do
--       local w_list = data[p + i][1]
--       for j = 1, #w_list do
--         -- reversed order
--         m_text[i][j + 1] = w_list[#w_list - j + 1]
--         -- m_text[i][j + 1] = w_list[j]
--       end
--       -- add <E> (for encoder, we need dummy <E> at the end)
--       for j = #w_list + 2, max_len +2 do
--         m_text[i][j] = 2
--       end

--       table.insert(enc_len_list, #w_list + 2)
--     end
--     table.insert(self.enc_batch_list, m_text)
--     table.insert(self.enc_len_batch_list, enc_len_list)
--     -- build dec matrix --------------------------------
--     max_len = -1
--     for i = 1, opt.batch_size do
--       local w_list = data[p + i][2]
--       if #w_list > max_len then
--         max_len = #w_list
--       end
--     end
--     m_text = torch.zeros(opt.batch_size, max_len + 2)
--     -- add <S>
--     m_text[{{}, 1}] = 1
--     for i = 1, opt.batch_size do
--       local w_list = data[p + i][2]
--       for j = 1, #w_list do
--         m_text[i][j + 1] = w_list[j]
--       end
--       -- add <E>
--       m_text[i][#w_list + 2] = 2
--     end
--     table.insert(self.dec_batch_list, m_text)

--     p = p + opt.batch_size
--   end

--   -- reset batch index
--   self.num_batch = #self.enc_batch_list

--   assert(#self.enc_batch_list == #self.dec_batch_list)

--   collectgarbage()
--   return self
-- end

function MinibatchLoader:random_batch()
  local p = math.random(self.num_batch)
  return self.enc_batch_list[p], self.enc_len_batch_list[p], self.dec_batch_list[p]
end

function MinibatchLoader:all_batch()
  local r = {}
  for p = 1, self.num_batch do
    table.insert(r, {self.enc_batch_list[p], self.enc_len_batch_list[p], self.dec_batch_list[p]})
  end
  return r
end

function MinibatchLoader:transformer_matrix(isUsedCuda)
	-- load batch data
	self.decIn = {}
	self.decOut = {}
	for p = 1, self.num_batch do
		-- local enc_batch, enc_len_batch, dec_batch = self.enc_batch_list[p], self.enc_len_batch_list[p], self.dec_batch_list[p]
		self.enc_batch_list[p] = self.enc_batch_list[p] : t()

		self.decIn[p] = torch.Tensor(self.dec_batch_list[p]:size(1), self.dec_batch_list[p]:size(2)-1)
							:copy((self.dec_batch_list[p][{{},{1,-2}}] )) 
							:t()

		for col = 1, self.decIn[p]:size(2) do
			if(self.decIn[p][self.decIn[p]:size(1)][col] == 0 or self.decIn[p][self.decIn[p]:size(1)][col] == 2) then 
				local row = self.decIn[p]:size(1)
				while row > 0 do 
					if (self.decIn[p][row][col] ~= 0)then 
						self.decIn[p][row][col] = 0
						bcheck = true
						break
					end
					row = row -1 
				end 
			end
		end      
	
		self.decOut[p] = torch.Tensor(self.dec_batch_list[p]:size(1), self.dec_batch_list[p]:size(2)-1)
						:copy(self.dec_batch_list[p][{{},{2,-1}}]) 
						:t()
             -- load batch data
    if (isUsedCuda) then 
      self.decIn[p]:cuda()
      self.decOut[p]:cuda()
      self.enc_batch_list[p]:cuda()
    end 
	end
	self.dec_batch_list = nil
end 

function MinibatchLoader:random_matrix()
	local p = math.random(self.num_batch)
	return self.enc_batch_list[p], self.decIn[p], self.decOut[p]
end 

return MinibatchLoader
