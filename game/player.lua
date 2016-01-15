local utils = require('lib.utils')
local tweener = require('lib.tweener')

local FACING_UP = 1
local FACING_RIGHT = 2
local FACING_LEFT = 3
local FACING_DOWN = 4

local TILE_OFFSET_Y = 4

local PIXELS_TO_MOVE = 16

local player = {
  x = 0,
  y = 0,
  width = 16,
  height = 16,
  sheet = nil,
  atlas = {},
  facing = FACING_RIGHT,
  map = nil,
  --
  tweener = nil,
  offset_x = 0,
  offset_y = 0
}

function player.input(self)
  if self.tweener then
    return
  end

  -- Obtain the player map-coordinates
  local x, y = self.map:to_map(self.x, self.y)
  local facing = self.facing
  local changed = false
  
  if love.keyboard.isDown('left') then
    x = x - 1
    facing = FACING_LEFT
    changed = true
  end
  if love.keyboard.isDown('right') then
    x = x + 1
    facing = FACING_RIGHT
    changed = true
  end
  if love.keyboard.isDown('up') then
    y = y - 1
    facing = FACING_UP
    changed = true
  end
  if love.keyboard.isDown('down') then
    y = y + 1
    facing = FACING_DOWN
    changed = true
  end

  if changed and self.map:is_walkable(x, y) then
    self.facing = facing
    self.tweener = tweener.linear(0, PIXELS_TO_MOVE, 0.25)
  end
end

function player.initialize(self, map)
  self.sheet, self.atlas = utils.load_atlas('assets/player.png', self.width, self.height)

  self.x = 128
  self.y = 128
  self.map = map
end

function player.update(self, dt)
  if not self.tweener then
    return
  end

  local delta, is_done = self.tweener(dt)

  if self.facing == FACING_UP then
    self.offset_y = -delta
  elseif self.facing == FACING_RIGHT then
    self.offset_x = delta
  elseif self.facing == FACING_LEFT then
    self.offset_x = -delta
  elseif self.facing == FACING_DOWN then
    self.offset_y = delta
  end

  if is_done then
    self.tweener = nil
    self.offset_x = 0
    self.offset_y = 0

    if self.facing == FACING_UP then
      self.y = self.y - PIXELS_TO_MOVE
    elseif self.facing == FACING_RIGHT then
      self.x = self.x + PIXELS_TO_MOVE
    elseif self.facing == FACING_LEFT then
      self.x = self.x - PIXELS_TO_MOVE
    elseif self.facing == FACING_DOWN then
      self.y = self.y + PIXELS_TO_MOVE
    end
  end
end

function player.draw(self)
  love.graphics.draw(self.sheet, self.atlas[self.facing],
    (self.x + self.offset_x) * 3 , (self.y + self.offset_y - TILE_OFFSET_Y) * 3,
    0, 3, 3)
end

return player