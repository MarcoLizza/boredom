local constants = require('game.constants')
local utils = require('lib.utils')
local tweener = require('lib.tweener')
local Animator = require('lib.animator')

local cursor = {
  x = 8,
  y = 8,
  width = constants.TILE_WIDTH,
  height = constants.TILE_HEIGHT,
  map = nil,
  sheet = nil,
  atlas = {},
  animator = Animator.new(),
  --
  tweener = nil,
  offset_x = 0,
  offset_y = 0,
  --
  frame = nil
}


function cursor:initialize(map)
  self.map = map
  
  self.sheet, self.atlas = utils.load_atlas('assets/cursor.png', self.width, self.height)
  
  self.animator:initialize({
      { 1, 2, 3, 4, 3, 2 }
    }, 12.0)
  self.animator:switch_to(1)
end

function cursor:input()
  if self.tweener then
    return
  end

  local delta_x = 0
  local delta_y = 0

  if love.keyboard.isDown('left') then
    delta_x = -1
    delta_y = 0
  end
  if love.keyboard.isDown('right') then
    delta_x = 1
    delta_y = 0
  end
  if love.keyboard.isDown('up') then
    delta_x = 0
    delta_y = -1
  end
  if love.keyboard.isDown('down') then
    delta_x = 0
    delta_y = 1
  end

  if delta_x == 0 and delta_y == 0 then
    return
  end

  local x, y = self.x + delta_x, self.y + delta_y

  if self.map:is_walkable(x, y) then

    -- Create a vector tweener. That means we can hypotetically move
    -- diagonally (if we are letting both x and y delta to be set
    -- at the same time).
    self.tweener = tweener.linear(0.25, function(ratio) 
        return { delta_x * ratio, delta_y * ratio }
      end)
  end
end

function cursor:update(dt)
  self.frame = self.animator:update(dt)

  if not self.tweener then
    return
  end

  local delta, continue = self.tweener(dt)

  if continue then
    self.offset_x = delta[1]
    self.offset_y = delta[2]
  else
    self.x = self.x + delta[1]
    self.y = self.y + delta[2]
    self.offset_x = 0
    self.offset_y = 0
    self.tweener = nil
  end
end

function cursor:draw()
  love.graphics.draw(self.sheet, self.atlas[self.frame],
    (self.x + self.offset_x) * constants.TILE_WIDTH * constants.MAGNIFICATION_FACTOR,
    (self.y + self.offset_y) * constants.TILE_HEIGHT * constants.MAGNIFICATION_FACTOR,
    0, constants.MAGNIFICATION_FACTOR, constants.MAGNIFICATION_FACTOR)
end

return cursor