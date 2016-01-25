local utils = require('lib.utils')

-- @module world
local world = {
  map = require('game.map'),
  player = require('game.player'),
  cursor = require('game.cursor'),
  time = 8 * 60 * 60,
  speed = 48.0,
  --
  question = nil
}

function world:initialize()
  self.map:initialize()
  self.cursor:initialize(self.map)
  self.player:initialize(self.map)
end

function world:input()
  if self.question then
    if love.keyboard.isDown('x') then
--      self.player:apply(self.question_data)
      self.question = nil
    elseif 'z' then
      self.question = nil
    end
    return
  end

  if love.keyboard.isDown('x') then
    local x, y = self.player:pointing_to()
    local data = self.items:at(x, y)
    if data then
      self.question = 'Do you?';
    end
  end
  
  self.map:input()
  self.cursor:input()
  self.player:input()
end

function world:update(dt)
  self.map:update(dt)
  self.cursor:update(dt)
  self.player:update(dt)

  self.time = self.time + (dt * self.speed)
end

function world:draw()
--  love.graphics.scale(3, 3)
  
  self.map:draw(function(level)
      if level == 3 then
        self.cursor:draw()
        self.player:draw()
      end
    end)

  love.graphics.setColor(191, 191, 127)
  love.graphics.print(utils.format_time(self.time) .. ' (' .. utils.time_of_day(self.time) .. ')', 0, 16)
  
  if self.question then
    love.graphics.print(self.question, 0, 32)
  end
end

return world