-- Account = {balance = 0, cash=1}
    
-- function Account:new (o)
--     o = o or {}
--     setmetatable(o, self)
--     self.__index = self
--     return o
-- end

-- function Account:deposit (v)
--     self.balance = self.balance + v
-- end

-- function Account:withdraw (v)
--     if v > self.balance then error"insufficient funds" end
--     self.balance = self.balance - v
-- end

-- a = Account:new{balance=12}

-- print(a.balance)
-- print(a.cash)


function tprint(x)
  print('[')
  for i,j in ipairs(x) do
    print(i,x[i])
  end
  print(']')
end


x = {}
table.insert(x, {1,1})
table.insert(x, {1,2})
tprint(x)