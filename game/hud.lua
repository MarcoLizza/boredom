local utils = require('lib.utils')

local hud = {
  world = nil
}

function hud:initialize(world)
  self.world = world
end

function hud:input()
end

function hud:update(dt)
end

function hud:draw()
  local world = self.world
  
  love.graphics.setColor(15, 15, 63)
  love.graphics.rectangle('fill', 0, 0, 20 * 16 * 3, 16 * 3)
  
  love.graphics.setColor(191, 191, 127)
  love.graphics.print(utils.format_time(world.time) .. ' (' .. utils.time_of_day(world.time) .. ')', 0, 16)
  
  if world.is_interacting then
    love.graphics.setColor(127, 191, 127)
    love.graphics.print(world.item_object.question .. '(will take ' .. utils.time_to_string(world.item_object.time) .. ')', 0, 32)
  end
end

return hud