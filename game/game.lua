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
  -- TODO: if the time of day changes, draw a black screen with the text
  -- big in the middle for a while.
  self.world:draw()
end

return game