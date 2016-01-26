local utils = require('lib.utils')

local OBJECT_LAYER_INDEX = 4

-- @module world
local world = {
  map = require('game.map'),
  items = require('game.items'),
  player = require('game.player'),
  cursor = require('game.cursor'),
  time = 8 * 60 * 60,
  speed = 48.0,
  --
  dampener = require('lib.dampener'),
  item_data = nil
}

function world:initialize()
  self.map:initialize()
  self.cursor:initialize(self.map)
  self.player:initialize(self.map)
  self.items:initialize(self.player)
end

function world:input(dt)
  local passed = self.dampener:passed(dt)
  
  if self.item_data then
    if passed and love.keyboard.isDown('z') then
      self.player:apply(self.item_data.features)
      self.time = self.time + self.item_data.time
      self.item_data = nil
    elseif passed and love.keyboard.isDown('x') then
      self.item_data = nil
    end
    return
  end

  if passed and love.keyboard.isDown('x') then
    local x, y = self.player:pointing_to()
    local item_data = self.items:at(x, y)
    if item_data then
      self.item_data = item_data
    end
  end
  
  self.map:input(dt)
  self.cursor:input(dt)
  self.player:input(dt)
end

function world:update(dt)
  self.map:update(dt)
  self.cursor:update(dt)
  self.player:update(dt)
  self.items:update(dt)

  -- Advance time only when we are not asking for using input. That is
  -- the game is paused when asking for user input.
  if self.item_data then
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

  love.graphics.setColor(191, 191, 127)
  love.graphics.print(utils.format_time(self.time) .. ' (' .. utils.time_of_day(self.time) .. ')', 0, 16)
  
  if self.item_data then
    love.graphics.setColor(127, 191, 127)
    love.graphics.print(self.item_data.question, 0, 32)
    love.graphics.print('(Will take ' .. utils.time_to_string(self.item_data.time) .. ')', 0, 48)
  end
end

return world