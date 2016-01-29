local game = {
  world = require('game.world')
}

function game:initialize()
  self.world:initialize()
end

function game:enter()
end

function game:leave()
end

function game:update(dt)
  self.world:input(dt)
  self.world:update(dt)
  
  return nil
end

function game:draw()
  self.world:draw()
end

return game