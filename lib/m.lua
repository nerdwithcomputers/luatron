local love = require "love"
local m = {}

function m.quit()
  love.event.quit()
end

function m.tprint(x)
  print('open')
  for i,j in ipairs(x) do
    print('[')
    for c,v in ipairs(j) do
      print(c, v)
    end
    print(']\n')
  end
  print('close\n')
end

-- bugger me this is massive
-- AND ITS NOT EVEN EXHAUSTIVE
function m.contains(tab, val)
  for _,x in ipairs(tab) do
    if type(x) == 'table' then
      if #x == #val then 
        truth = 0
        for i,a in ipairs(x) do
          if val[i] == a then
            truth = truth+1
          end
        end
        if truth == #x then
          return true
        end
      end
    end
  end
end

return m