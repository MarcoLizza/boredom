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
  },
  has_changed = true
}

function map:initialize()
  local tiles = self.tiles

  tiles.sheet, tiles.atlas = utils.load_atlas('assets/tileset.png', tiles.width, tiles.height)

  -- Once the atlas and the tileset
  -- We are creating sprite-batch for each layer so that the occlusion can be handled.
  -- The batches can contain as much as the amount of tiles present in the map.
  for i = 1, #self.layers.levels do
    tiles.batches[i] = love.graphics.newSpriteBatch(tiles.sheet, self.width * self.height)
  end
end

function map:input(keys)
end

function map:update(dt)
  if not self.has_changed then
    return
  end
  
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
  
  self.has_changed = false
end

function map:draw(draw)
  for level, batch in ipairs(self.tiles.batches) do
    if draw then
       draw(level - 1)
    end    
    love.graphics.draw(batch, 0, 0, 0,
      constants.MAGNIFICATION_FACTOR, constants.MAGNIFICATION_FACTOR)
  end
end

function map:to_map(x, y)
  local tiles = self.tiles
  return math.floor(x / tiles.width), math.floor(y / tiles.height)
end

function map:to_screen(x, y)
  local tiles = self.tiles
  return x * tiles.width, y * tiles.height
end

function map:is_walkable(x, y)
  -- Always remember that tables indexes start from one! :\
  if self.layers.walkables[y + 1][x + 1] ~= -1 then
    return true
  else
    return false
  end
end

function map:find_path(from, to)
  local path = {}
end

return map