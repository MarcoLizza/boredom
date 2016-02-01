--[[

Copyright (c) 2016 by Marco Lizza (marco.lizza@gmail.com)

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgement in the product documentation would be
   appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.

]]--

-- MODULE INCLUSIONS -----------------------------------------------------------

local config = require('game.config')
local constants = require('game.constants')
local utils = require('lib.utils')

-- MODULE DECLARATION ----------------------------------------------------------

local hud = {
  world = nil,
  sheet = {},
  atlas = nil,
  message = '',
  message_time = 0
}

-- MODULE FUNCTIONS ------------------------------------------------------------

function hud:initialize(world)
  self.world = world

  self.sheet, self.atlas = utils.load_atlas('assets/hud.png',
    constants.TILE_WIDTH, constants.TILE_HEIGHT)

  self.small_font = love.graphics.setNewFont('assets/fonts/slkscr.ttf', 8)
  self.normal_font = love.graphics.setNewFont('assets/fonts/victor-pixel.ttf', 10)
  self.big_font = love.graphics.setNewFont('assets/fonts/retro.ttf', 14)
end

function hud:input(keys)
end

function hud:update(dt)
  local daytime = utils.time_of_day(self.world.time)
  if self.message ~= daytime then
    self.message = daytime -- TODO: display also the # of day!
    self.message_time = 5
    return
  end
  
  if self.message_time > 0 then
    self.message_time = self.message_time - dt
  end
end

function hud:draw()
  local world = self.world
  
  -- If the player can interact with an object from its position, draw the
  -- interaction icon on top of the player itself.
  if world.item_object then
    local x, y = world.player:position()
    love.graphics.draw(self.sheet, self.atlas[11], x, (y - 16 - 4 - 8))
  end
  
  -- Display the player attributes and time.
  local stats = string.format('FATIGUE: %d - FUN: %d - HEALTH: %d - MONEY: %d', 
    math.floor(world.player.attributes.fatigue),
    math.floor(world.player.attributes.fun),
    math.floor(world.player.attributes.health),
    math.floor(world.player.attributes.money))

  local time = string.format('%s (day #%d)',
    utils.format_time(world.time), utils.to_days(world.time) + 1)

  love.graphics.setColor(0, 0, 0, 191)
  love.graphics.rectangle('fill', 0, 240 - 8, 320, 8)
  
  love.graphics.setFont(self.small_font)
  love.graphics.setColor(191, 191, 127, 255)
  love.graphics.print(stats, 0, 240 - 8)
  local width = self.small_font:getWidth(time)
  love.graphics.print(time, 320 - width, 240 - 8)

  -- Decide which messages to show. Either the interaction question or
  -- the current "day-time"
  local messages = nil
  local font = nil
  if world.is_interacting then
    messages = {
      world.item_object.question,
      string.format('(will take %s)', utils.time_to_string(world.item_object.time)),
      'X = YES | C = NO'
    }
    font = self.normal_font
  elseif self.message_time > 0 then
    messages = {
      self.message
    }
    font = self.big_font
  end
  
  if messages then
    local height = #messages * font:getHeight()
    local top = (240 - height) / 2

    love.graphics.setColor(0, 0, 0, 223)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    love.graphics.setColor(255, 255, 255)
    love.graphics.setFont(font)
    for _, message in ipairs(messages) do
      local width = font:getWidth(message)
      love.graphics.print(message, (320 - width) / 2, top)
      top = top + font:getHeight()
    end
  end

  love.graphics.setColor(255, 255, 255)
  if config.debug.fps then
    love.graphics.setFont(self.small_font)
    love.graphics.print('FPS: ' .. love.timer.getFPS(), 0, 0)  
  end
end

-- END OF MODULE ---------------------------------------------------------------

return hud

-- END OF FILE -----------------------------------------------------------------
