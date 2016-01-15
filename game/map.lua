local constants = require('game.constants')
local utils = require('lib.utils')

-- @module world
local map = {
  width = 20,
  height = 15,
  layers = require('assets/tilemap'),
  viewport = {
    x = 0,
    y = 0,
    rows = 15,
    columns = 20,
  },
  tiles = {
    width = 16,
    height = 16,
    --
    sheet = {},
    atlas = nil,
    batches = {}
  }
}

function map.to_map(self, x, y)
  local tiles = self.tiles
  return math.floor(x / tiles.width), math.floor(y / tiles.height)
end

function map.to_screen(self, x, y)
  local tiles = self.tiles
  return x * tiles.width, y * tiles.height
end

function map.is_walkable(self, x, y)
  -- Always remember that tables indexes start from one! :\
  if self.layers.walkables[y + 1][x + 1] ~= -1 then
    return true
  else
    return false
  end
end

function map.initialize(self)
  local tiles = self.tiles

  tiles.sheet, tiles.atlas = utils.load_atlas('assets/tileset.png', tiles.width, tiles.height)

  -- Once the atlas and the tileset
  -- We are creating sprite-batch for each layer so that the occlusion can be handled.
  -- The batches can contain as much as the amount of tiles present in the map.
  for i = 1, #self.layers.levels do
    tiles.batches[i] = love.graphics.newSpriteBatch(tiles.sheet, self.width * self.height)
  end
end

function map.input(self)
end

function map.update(self, dt)
  local layers = self.layers
  local viewport = self.viewport
  local tiles = self.tiles
  local atlas = tiles.atlas

  for level, cells in ipairs(layers.levels) do
    local batch = tiles.batches[level]
    batch:clear()
    for i = 1, viewport.rows do
      local y = (i - 1) * tiles.height
      for j = 1, viewport.columns do
        local x = (j - 1) * tiles.width
        local cell = cells[i][j] + 1
        if cell ~= 0 then -- exclude 'zeroed' cells
          batch:add(atlas[cell], x, y)
        end
      end
    end
    batch:flush()
  end
end

function map.draw(self, draw)
  love.graphics.setColor(63, 63, 63)
  love.graphics.rectangle('fill', 0, 0, constants.WINDOW_WIDTH, constants.WINDOW_HEIGHT)
  
  for level, batch in ipairs(self.tiles.batches) do
    if draw then
       draw(level - 1)
    end
    love.graphics.setColor(255, 255, 255) -- reset the drawing color not to affect sprite-batch
    love.graphics.draw(batch, 0, 0, 0,
      constants.MAGNIFICATION_FACTOR, constants.MAGNIFICATION_FACTOR)
  end
end

return map