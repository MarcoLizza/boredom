local constants = require('game.constants')

local items = {
  map = require('assets/itemsmap'),
  items = {
    {
      x = 0,
      y = 0,
      width = 32,
      height = 32,
      data = {
        description = 'TV',
        features = {
          fatigue = 0,
          time = 2,
          fun = 3,
          health = 0,
          money = 0,
        },
      },
      image = love.graphics.newImage('assets/items/television.png')
    },
    is_near = false,
    is_in_front = false
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
    
  self.shader = love.graphics.newShader('shaders/outline.glsl')
end

function items:update(dt)
  -- items are to be updated AFTER the player, so that we can precalculate
  -- the "is_near" state here, ano not during the draw phase.
  for _, item in pairs(self.items) do
    local x, y = player:position()
    item.is_near = inside(x - constants.TILE_WIDTH, y, item) or inside(x + constants.TILE_WIDTH, y, item)
      or inside(x, y - constants.TILE_HEIGHT, item) or inside(x, y + constants.TILE_HEIGHT, item)
      
    local x1, y1 = player:pointing_to()
    item.is_in_front = inside(x1, y1, item)
  end
end

function items:draw()
  for _, item in pairs(self.items) do
    if item.is_near then
      self.shader:send('_step', { 1 / item.width, 1 / item.height });
      self.shader:send('_chroma', item.is_in_front and { 0.0, 1.0, 0.0 } or { 0.0, 0.0, 1.0 });
      love.graphics.setShader(self.shader)
    end
    love.graphics.draw(item.image, item.x, item.y) -- SCALE
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
