-- package.path = 'lib/?.lua;lib/?/?.lua;lib/?/init.lua;?.lua;?/init.lua;' .. package.path
-- love.filesystem.setRequirePath(package.path)
local love = require "love"
local vudu = require "lib.vudu.vudu"
local table =  require "table"
local m = require "lib.m"
local helium = require "lib.helium"
local click = require "lib.helium.shell.button"
local menu = helium.scene.new(true)
local titleFont = love.graphics.newFont("assets/3270_font/3270NerdFont-Regular.ttf", 40)
local defaultFont = love.graphics.newFont("assets/3270_font/3270NerdFont-Regular.ttf", 20)
menu:activate()
table.unpack = table.unpack or unpack

aWidth = 800
aHeight = 600
arena = love.graphics.newCanvas(aWidth, aHeight)
crashcoords = {}
gamestate = "menu"

cycle = {
  facing = 'up',
  color = {},
  coords={},
  lastCoords = {}
}
function cycle:new(o)
  o = o or {}
  setmetatable(o,self)
  self.__index = self
  return o
end
function cycle:move()
  local coordarr = {table.unpack(self.coords)}
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
  self.lastCoords[#self.lastCoords+1] = coordarr
  crashcoords[#crashcoords+1] = coordarr
  if self.coords[1] >= aWidth 
    or self.coords[1] <= 0
    or self.coords[2] >= aHeight
    or self.coords[2] <= 0
  then
    m.quit()
  end
end

function love.load()
  vudu.initialize()
  players = {
    red = cycle:new{
      color={1, 0, 0.5, 1},
      coords={math.random(aWidth),math.random(aHeight)},
      keys={
        u='i',
        d='k',
        l='j',
        r='l'
      }
    },
    blue = cycle:new{
      color={0, 1, 0.5, 1},
      coords={math.random(aWidth),math.random(aHeight)},
      keys={
        u='w',
        d='s',
        l='a',
        r='d'
      }
    }
  }
  width, height = love.graphics.getDimensions()
  text = helium(function(param, view)
    -- if not param.font then
    --   param.font = defaultFont
    -- end
    return function()
      love.graphics.setFont(param.font or defaultFont)
        love.graphics.print(param.text, 0, 0, 0, param.size, param.size)
        love.graphics.setFont(defaultFont)
    end
  end)
  textbox = helium(function(param,view)
    return function()
      love.graphics.setFont(param.font or defaultFont)
        love.graphics.setColor(0.3, 0.3, 1)
		    love.graphics.rectangle('fill', 0, 0, view.w, view.h)
		    love.graphics.setColor(1, 1, 1)
        -- txt, x,y, r, sx,sy, ox,oy, kx,ky
		    love.graphics.print(param.text, 0,0, 0, 1,1, -1*love.graphics.getFont():getWidth(param.text)/2)
      love.graphics.setFont(defaultFont)
    end
  end)
  button = helium(function(param,view)
    local state = click()
    return function()
      if state.down then
        param.func()
      end
      love.graphics.setColor(param.color)
      love.graphics.rectangle('fill', 0,0, view.w, view.h)
      love.graphics.print(param.text)
    end
  end)
  title=textbox({
    text="TRON",
    font=titleFont
  }, 100,50)
  title:draw(width/2-title.baseView.w/2,100)
  start=button(
    {
      func=(function()
        print('start')
      end),
      color={0,1,0},
      text='start'
    }, 50,30)
  start:draw(width/2-start.baseView.w/2,200)
end

function love.draw()
  if gamestate == "game" then
    love.graphics.setCanvas(arena)
    love.graphics.clear()
    for _,bike in pairs(players) do
      love.graphics.setColor(bike.color)
      love.graphics.rectangle('fill', bike.coords[1], bike.coords[2], 10,10)
      for i in ipairs(bike.lastCoords) do
        love.graphics.setColor(bike.color)
        love.graphics.rectangle('fill', bike.lastCoords[i][1], bike.lastCoords[i][2], 5,5)
      end
      love.graphics.setCanvas()
      love.graphics.draw(arena, 0,0, 0)
    end
  elseif gamestate == "menu" then
    menu:draw()
  end
end

function love.update(dt)
  width, height = love.graphics.getDimensions()
  if gamestate == "game" then
    for _,bike in pairs(players) do
      bike:move()
      if m.contains(crashcoords, bike.coords) then
        m.quit()
      end
    end
  elseif gamestate == "menu" then
    title.baseView.x = width/2 - title.baseView.w/2
    menu:update(dt)
  end
end

function love.keypressed(key, scancode, isrepeat)
  if key == 'escape' then
    m.quit()
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
