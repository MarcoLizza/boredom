local OBJECT_LAYER_INDEX = 4

-- @module world
local world = {
  map = require('game.map'),
  items = require('game.items'),
  player = require('game.player'),
  cursor = require('game.cursor'),
  hud = require('game.hud'),
  time = 8 * 60 * 60,
  speed = 48.0,
  dampener = require('lib.dampener'),
  -- INTERACTION --
  item_object = nil
}

function world:initialize()
  self.map:initialize()
  self.cursor:initialize(self.map)
  self.player:initialize(self.map)
  self.items:initialize(self.player)
  self.hud:initialize(self)
end

local function grab_input()
  local keys = {}
  keys['z'] = love.keyboard.isDown('z')
  keys['x'] = love.keyboard.isDown('x')
  keys['up'] = love.keyboard.isDown('up')
  keys['down'] = love.keyboard.isDown('down')
  keys['left'] = love.keyboard.isDown('left')
  keys['right'] = love.keyboard.isDown('right')
  
  local has_input = false
  for _,v in pairs(keys) do
    if v then
      has_input = true
      break
    end
  end
  
  return keys, has_input
end

function world:input(dt)
  self.dampener:update(dt)
  local passed = self.dampener:passed()

  local keys, has_input = grab_input()

  if self.item_object then
    if passed and keys['z'] then
      self.player:apply(self.item_object.features)
      self.time = self.time + self.item_object.time
      self.item_object = nil
      self.dampener:reset()
    elseif passed and keys['x'] then
      self.item_object = nil
      self.dampener:reset()
    end
    return
  end
  
  if passed and keys['x'] then
    local x, y = self.player:pointing_to()
    local item_object = self.items:at(x, y)
    if item_object then
      self.item_object = item_object
    end
    self.dampener:reset()
  end
  
  self.map:input(keys)
  self.cursor:input(keys)
  self.player:input(keys)
  self.hud:input(dt)
end

function world:update(dt)
  self.map:update(dt)
  self.cursor:update(dt)
  self.player:update(dt)
  self.items:update(dt) -- items are updater *after* the player
  self.hud:update(dt)

  -- Keep the player "focus-object" updated.
--  local x, y = self.player:pointing_to()
--  self.item_object = self.items:at(x, y)

  -- Advance time only when we are not asking for using input. That is
  -- the game is paused when asking for user input.
  if self.item_object then
    return
  end

  self.time = self.time + (dt * self.speed)
end

function world:draw()
--  love.graphics.scale(3, 3)
  
  self.map:draw(function(level)
      if level == OBJECT_LAYER_INDEX then
        self.cursor:draw()
        self.items:draw()
        self.player:draw()
      end
    end)

  self.hud:draw()
end

return world