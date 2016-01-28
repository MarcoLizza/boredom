local utils = require('lib.utils')

local hud = {
  world = nil,
  sheet = {},
  atlas = nil,
}

function hud:initialize(world)
  self.world = world

  self.sheet, self.atlas = utils.load_atlas('assets/hud.png', 16, 16)
end

function hud:input()
end

function hud:update(dt)
end

function hud:draw()
  local world = self.world
  
  if world.item_object then
    local x, y = world.player:position()
    love.graphics.draw(self.sheet, self.atlas[11], x, (y - 16 - 4))
  end
  
  love.graphics.setColor(15, 15, 63, 127)
  love.graphics.rectangle('fill', 0, 0, 20 * 16, 24)
  
  love.graphics.setColor(191, 191, 127, 127)
  love.graphics.print(utils.format_time(world.time) .. ' (' .. utils.time_of_day(world.time) .. ')', 0, 8)
  
  if world.is_interacting then
    love.graphics.setColor(63, 15, 63, 127)
    love.graphics.print(world.item_object.question .. ' (will take ' .. utils.time_to_string(world.item_object.time) .. ')', 0, 16)
  end
end

return hud