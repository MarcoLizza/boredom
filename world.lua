local _constants = require("constants")

-- @module world
local world = {
  map = {
    width = 20,
    height = 15,
    layers = require("assets/map"),
  },
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
    atlas = {},
    image = nil,
    batches = {}
  }
}

function world.walkable(self, x, y)
  return true
end

function world.initialize(self)
  local tiles = self.tiles
  local map = self.map

  tiles.image = love.graphics.newImage("assets/tileset.png")

  -- The tiles are organized in the tileset in a single row, so we can get
  -- dynamically the amount of tiles with a simple division.
  local amount = tiles.image:getWidth() / tiles.width
  for i = 1, amount do
    tiles.atlas[i] = love.graphics.newQuad((i - 1) * tiles.width, 0, tiles.width, tiles.width,
      tiles.image:getWidth(), tiles.image:getHeight())
  end

  -- We are creating sprite-batch for each layer so that the occlusion can be handled.
  -- The batches can contain as much as the amount of tiles present in the map.
  for i = 1, #map.layers do
    tiles.batches[i] = love.graphics.newSpriteBatch(tiles.image, tiles.width * tiles.height)
  end
end

function world.input(self)
end

function world.update(self, dt)
  local layers = self.map.layers
  local viewport = self.viewport
  local tiles = self.tiles
  local atlas = tiles.atlas
  local batch = tiles.batch

  for level, cells in ipairs(layers) do
    local batch = tiles.batches[level]
    batch:clear()
    for i = 1, viewport.rows do
      local y = (i - 1) * tiles.height
      for j = 1, viewport.columns do
        local x = (j - 1) * tiles.width
        local cell = cells[i][j]
        if cell ~= 0 then -- exclude "zeroed" cells
          batch:add(atlas[cell], x, y)
        end
      end
    end
    batch:flush()
  end
end

function world.draw(self, draw)
  love.graphics.setColor(63, 63, 63)
  love.graphics.rectangle("fill", 0, 0, _constants.WINDOW_WIDTH, _constants.WINDOW_HEIGHT)
  
  for level, batch in ipairs(self.tiles.batches) do
    if draw then
       draw(level - 1)
    end
    love.graphics.setColor(255, 255, 255) -- reset the drawing color not to affect sprite-batch
    love.graphics.draw(batch, 0, 0, 0,
      _constants.MAGNIFICATION_FACTOR, _constants.MAGNIFICATION_FACTOR)
  end
end

return world