local constants = require('game.constants')

local items = {
--  map = require('assets/itemsmap'),
  items = {
    {
      x = 13 * 16,
      y = 0 * 16,
      width = 32,
      height = 48,
      image = 'assets/items/television.png',
      sheet = nil,
      is_near = false,
      is_in_front = false,
      data = {
        question = 'Would you like me to watch some TV?',
        time = 1 * 60 * 60,
        features = {
          fatigue = 2,
          fun = 2,
          health = -1,
          money = 0,
        },
      },
    },
    {
      x = 1 * 16,
      y = 5 * 16,
      width = 32,
      height = 64,
      image = 'assets/items/bed.png',
      sheet = nil,
      is_near = false,
      is_in_front = false,
      data = {
        question = 'Should I go to bed?',
        time = 8 * 60 * 60,
        features = {
          fatigue = -4,
          fun = 0,
          health = 2,
          money = 0,
        },
      },
    },
  },
  shader = nil
}

local function inside(x, y, item)
  if x >= item.x and y >= item.y and x < (item.x + item.width) and y < (item.y + item.height) then
    return true
  end
  return false
end

function items:initialize(player)
  self.player = player
    
  self.shader = love.graphics.newShader('shaders/modulate.glsl')

  for _, item in pairs(self.items) do
    item.sheet = love.graphics.newImage(item.image)
  end
end

function items:update(dt)
  -- items are to be updated AFTER the player, so that we can precalculate
  -- the "is_near" state here, ano not during the draw phase.
  for _, item in pairs(self.items) do
    local x, y = self.player:position()
    item.is_near = inside(x - constants.TILE_WIDTH, y, item) or inside(x + constants.TILE_WIDTH, y, item)
      or inside(x, y - constants.TILE_HEIGHT, item) or inside(x, y + constants.TILE_HEIGHT, item)
      
    local x1, y1 = self.player:pointing_to()
    item.is_in_front = inside(x1, y1, item)
  end
end

function items:draw()
  for _, item in pairs(self.items) do
    if item.is_near then
      self.shader:send('_chroma', item.is_in_front and { 0.5, 1.0, 0.5 } or { 0.5, 0.5, 1.0 });
      love.graphics.setShader(self.shader)
    end
--    love.graphics.scale(3, 3)
    love.graphics.draw(item.sheet, item.x * 3, item.y * 3, 0, 3, 3) -- SCALE
--    love.graphics.scale(1, 1)
    if item.is_near then
      love.graphics.setShader()
    end
  end
end

function items:at(x, y)
  for _, item in pairs(self.items) do
    if inside(x, y, item) then
      return item.data
    end
  end
  return nil
end

return items
