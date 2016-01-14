local utils = require('utils')

-- @module world
local world = {
  map = require('map'),
  player = require('player'),
  time = 0,
  speed = 48.0
}

function world.initialize(self)
  self.map:initialize()
  self.player:initialize(self.map)
end

function world.input(self)
  self.map:input()
  self.player:input()
end

function world.update(self, dt)
  self.map:update()
  self.player:update()
  
  self.time = self.time + (dt * self.speed)
end

function world.draw(self)
  self.map:draw(function(level)
      if level == 2 then
        self.player:draw()
      end
    end)

  love.graphics.setColor(191, 191, 127)
  love.graphics.print(utils.format_time(self.time), 0, 16)
end

return world