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

function items:initialize(player)
  self.player = player
    
  self.shader = love.graphics.newShader('shaders/outline.glsl')
end

function items:update(dt)
  -- items are to be updated AFTER the player, so that we can precalculate
  -- the "is_near" state here, ano not during the draw phase.
  for _, item in pairs(self.items) do
    item.is_near = is_near(player, item)
    item.is_in_front = is_in_front(player, item)
  end
end

function items:draw()
  for _, item in pairs(self.items) do
    if item.is_near then
      self.shader:send('_step', { 1 / item.width, 1 / item.height });
      self.shader:send('_color', item.is_in_front and { 0.0, 1.0, 0.0 } or { 0.0, 0.0, 1.0 });
      love.graphics.setShader(self.shader)
    end
    love.graphics.draw(item.image, item.x, item.y) -- SCALE
    if item.is_near then
      love.graphics.setShader()
    end
  end
end

function items:neighbours(x, y)
  local set = {}
  for _, item in ipairs(self.list) do
    for _, tile in ipairs(item.tiles) do
      if x == tile.x and y == tile.y then
        set[#set + 1] = item
        break
      end
    end
  end
  return set
end

local function inside(x, y, item)
  if x >= item.x and y >= item.y and x < (item.x + item.width) and y < (item.y + item.height) then
    return true
  end
  return false
end

function items:find(x, y)
  for _, item in pairs(self.items) do
    if inside(x, y, item) then
      return item.data
    end
  end
  return nil
end

local function is_in_front(player, item)
  local x, y = player.x, player.y
  -- should consider the player facing direction, too
  if player.facing == FACING_UP then
    y = y - 16
  elseif player.facing == FACING_DOWN then
    y = y + 16
  elseif player.facing == FACING_LEFT then
    x = x - 16
  elseif player.facing == FACING_RIGHT then
    x = x + 16
  end
  return inside(x, y, item)
end

local function is_near(player, item)
  local x, y = player.x, player.y
  -- should consider the player facing direction, too
  return inside(x - constants.TILE_WIDTH, y, item) or inside(x + constants.TILE_WIDTH, y, item)
    or inside(x, y - constants.TILE_HEIGHT, item) or inside(x, y + constants.TILE_HEIGHT, item)
end

return items
