local table = require "table"
table.unpack = unpack or table.unpack
x = {
  3,
  1,
  {1,1}
}
b,c,d = table.unpack(x)
print(b)
-- --[[
function contains(tab, val)
  for _,x in ipairs(tab) do
    if type(x) == 'table' then
      if #x == #val then 
        truth = 0
        for i,a in ipairs(x) do
          if val[i] == a then
            truth = truth+1
          end
        end
        if truth == #x then return true end
      end
    end
  end
end

print(contains(x, {1,1}))
--]]