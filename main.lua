local love = require "love"
-- local table =  require "table"


function tprint(x)
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

cycle = {
  facing = 'up',
  color = {},
  coords = {},
  lastCoords = {}
}
function cycle:new(o)
  o = o or {}
  setmetatable(o,self)
  self.__index = self
  return o
end
function cycle:move()
  -- print(self.coords[2])
  local foo = self.coords 
  self.lastCoords[#(self.lastCoords)+1] = foo
  tprint(self.lastCoords)
  -- print(self.lastCoords[#(self.lastCoords)][1])
  if self.facing == 'up' then
    self.coords[2] = self.coords[2]-1
  elseif self.facing == 'down' then
    self.coords[2] = self.coords[2]+1
  elseif self.facing == 'left' then
    self.coords[1] = self.coords[1]-1
  elseif self.facing == 'right' then
    self.coords[1] = self.coords[1]+1
  end
  -- print(#(self.lastCoords))
  if self.coords[1] >= width 
    or self.coords[1] <= 0
    or self.coords[2] >= width
    or self.coords[2] <= 0
  then
    love.event.quit()
  end
end

function love.load()
  height = love.graphics.getHeight()
  width = love.graphics.getWidth()
  -- of course my first idea is to implement a class in a lang that doesn't BLOODY HAVE CLASSES

  players = {
    red = cycle:new{
      color={1, 0, 0.5, 1},
      coords={100,100},
      keys={
        u='i',
        d='k',
        l='j',
        r='l'
      }
    }
    --[[
    blue = cycle:new{
      color={0, 1, 0.5, 1},
      coords={width/2, height/2},
      keys={
        u='w',
        d='s',
        l='a',
        r='d'
      }
    }
    --]]
  }
end

function love.draw()
  for _,bike in pairs(players) do
    love.graphics.setColor(bike.color[1],bike.color[2],bike.color[3],bike.color[4])
    love.graphics.rectangle('fill', bike.coords[1], bike.coords[2], 10,10)

    -- print(#(bike.lastCoords))
    -- --[[
    for i in ipairs(bike.lastCoords) do
      -- print(i)
      love.graphics.setColor(0,1,0,1)
      love.graphics.rectangle('fill', bike.lastCoords[i][1], bike.lastCoords[i][2], 5,5)
    end
    --]]
  end
end

function love.update()
  for _,bike in pairs(players) do
    bike:move()
  end
  -- love.graphics.setColor(0,0,1,1)
  -- love.graphics.rectangle('fill', 100, 100, 10, 10)
end

function love.keypressed(key, scancode, isrepeat)
  if key == 'escape' then
      love.event.quit()
  end
  for _,bike in pairs(players) do
    if key == bike.keys.u and (bike.facing == 'left' or bike.facing == 'right') then
      bike.facing = 'up'
    elseif key == bike.keys.d and (bike.facing == 'left' or bike.facing == 'right') then
      bike.facing = 'down'
    elseif key == bike.keys.l and (bike.facing == 'up' or bike.facing == 'down') then
      bike.facing = 'left'
    elseif key == bike.keys.r and (bike.facing == 'up' or bike.facing == 'down') then
      bike.facing = 'right'
    end
  end
end
