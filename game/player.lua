local utils = require('lib.utils')
local tweener = require('lib.tweener')
local Animator = require('lib.animator')

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
  map = nil,
  animator = Animator.new(),
  frame = nil,
  facing = FACING_RIGHT,
  --
  tweener = nil,
  offset_x = 0,
  offset_y = 0,
  --
  activity_marker = os.time(),
  is_idle = false
}

function player.initialize(self, map)
  self.map = map
  
  self.sheet, self.atlas = utils.load_atlas('assets/player.png', self.width, self.height)

  self.animator:initialize({
      { 1 },
      { 2 },
      { 3 },
      { 4 }
    }, 10.0)
  self.animator:switch_to(FACING_RIGHT)

  self.shader = love.graphics.newShader('shaders/modulate.glsl')
  self.shader:send('_chroma', { 0.5, 0.5, 1.0 });

  self.x = 128
  self.y = 128
end

function player.input(self)
  if self.tweener then
    return
  end

  local facing = self.facing

  local delta_x = 0
  local delta_y = 0

  if love.keyboard.isDown('left') then
    delta_x = -PIXELS_TO_MOVE
    delta_y = 0
    facing = FACING_LEFT
  end
  if love.keyboard.isDown('right') then
    delta_x = PIXELS_TO_MOVE
    delta_y = 0
    facing = FACING_RIGHT
  end
  if love.keyboard.isDown('up') then
    delta_x = 0
    delta_y = -PIXELS_TO_MOVE
    facing = FACING_UP
  end
  if love.keyboard.isDown('down') then
    delta_x = 0
    delta_y = PIXELS_TO_MOVE
    facing = FACING_DOWN
  end

  if delta_x == 0 and delta_y == 0 then
    return
  end

  self.activity_marker = os.time()

  -- Obtain the player map-coordinates
  local x, y = self.map:to_map(self.x + delta_x, self.y + delta_y)

  if self.map:is_walkable(x, y) then
    -- A change in the direction will switch to the correct animation.
    if self.facing ~= facing then
      self.animator:switch_to(facing)
      self.facing = facing
    end

    self.tweener = tweener.linear(0.25, function(ratio) 
        return { delta_x * ratio, delta_y * ratio }
      end)
  end
end

function player.update(self, dt)
  -- When the user does not interact for a period, the actor will switch
  -- into "idle" state.
  local inactivity_time = os.difftime(self.activity_marker, os.time())
  self.is_idle = math.abs(inactivity_time) > 30

  -- Pump the player animation. Returns the updated atlas index of the frame
  -- to be drawn.
  self.frame = self.animator:update(dt)

  -- If the tweener is not, shortcut exit since we are not moving the player.
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

function player.draw(self)
  if self.is_idle then
      love.graphics.setShader(self.shader)
  end
  love.graphics.draw(self.sheet, self.atlas[self.frame],
    (self.x + self.offset_x) * 3 , (self.y + self.offset_y - TILE_OFFSET_Y) * 3,
    0, 3, 3)
  if self.is_idle then
      love.graphics.setShader()
  end
end

return player