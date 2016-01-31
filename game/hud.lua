local utils = require('lib.utils')

local hud = {
  world = nil,
  sheet = {},
  atlas = nil,
  message = '',
  message_time = 0,
}

function hud:initialize(world)
  self.world = world

  self.sheet, self.atlas = utils.load_atlas('assets/hud.png', 16, 16)
  
  self.small_font = love.graphics.setNewFont('assets/fonts/slkscr.ttf', 8)
  self.normal_font = love.graphics.setNewFont('assets/fonts/victor-pixel.ttf', 10)
  self.big_font = love.graphics.setNewFont('assets/fonts/retro.ttf', 14)
  self.fancy_font = love.graphics.setNewFont('assets/fonts/dot_digital-7.ttf', 20)
end

function hud:input()
end

function hud:update(dt)
  local daytime = utils.time_of_day(self.world.time)
  if self.message ~= daytime then
    self.message = daytime
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
  
  -- Diplay the current time.
  local time = utils.format_time(world.time)
  local width = self.fancy_font:getWidth(time)
  local max_width = width + 4
  love.graphics.setColor(0, 0, 0, 191)
  love.graphics.rectangle('fill', 320 - max_width, 0, max_width, self.fancy_font:getHeight())
  
  love.graphics.setColor(191, 191, 127, 255)
  love.graphics.setFont(self.fancy_font)
  love.graphics.print(time, 320 - width - 2, 0)
  
  -- Display the player statistics.
  local stats = string.format('FATIGUE: %d | FUN: %d | HEALTH: %d | MONEY: %d', 
    math.floor(world.player.statistics.fatigue),
    math.floor(world.player.statistics.fun),
    math.floor(world.player.statistics.health),
    math.floor(world.player.statistics.money))
  
  love.graphics.setColor(0, 0, 0, 191)
  love.graphics.rectangle('fill', 0, 240 - 10, 320, 10)
  
  love.graphics.setColor(191, 191, 127, 255)
  love.graphics.setFont(self.normal_font)
  love.graphics.print(stats, 0, 240 - 10)
  
  -- Decide which messages to show. Either the interaction question or
  -- the current "day-time"
  local messages = nil
  local font = nil
  if world.is_interacting then
    messages = {
      world.item_object.question,
      string.format('(will take %s)', utils.time_to_string(world.item_object.time)),
      'Z = YES | X = NO'
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
  love.graphics.setFont(self.small_font)
  love.graphics.print('FPS: ' .. love.timer.getFPS(), 0, 0)  

--  love.graphics.setColor(255, 255, 255)
end

return hud