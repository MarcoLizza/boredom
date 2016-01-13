local _constants = require("constants")

local player = {
  x = 0,
  y = 0,
  vx = 0,
  vy = 0,
  world = nil
}

function player.input(self)
  local x = math.floor(self.x / 16)
  local y = math.floor(self.y / 16)
  
  if love.keyboard.isDown("left") then
    x = x - 1
  end
  if love.keyboard.isDown("right") then
    x = x + 1
  end
  if love.keyboard.isDown("up") then
    y = y - 1
  end
  if love.keyboard.isDown("down") then
    y = y + 1
  end

  if self.world:walkable(x, y) then
    self.x = x * 16
    self.y = y * 16
  end
end

function player.initialize(self, world)
  self.x = 128
  self.y = 128
  self.world = world
--  self.y = 50
--  self.y = 50
--  self.vx = 100
--  self.vy = 100
end

function player.update(self, dt)
--  self.x = self.x + self.vx * dt
--  self.y = self.y + self.vy * dt
--  if self.x < 0 or self.x >= _constants.SCREEN_WIDTH then
--    self.vx = -self.vx
--  end
--  if self.y < 0 or self.y >= _constants.SCREEN_HEIGHT then
--    self.vy = -self.vy
--  end
end

function player.draw(self)
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("fill", self.x * 3, self.y * 3, 16 * 3, 16 * 3)
end

return player