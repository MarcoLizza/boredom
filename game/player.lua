local utils = require('lib.utils')
local tweener = require('lib.tweener')
local Animator = require('lib.animator')
local constants = require('game.constants')

local FACING_UP = 1
local FACING_RIGHT = 2
local FACING_LEFT = 3
local FACING_DOWN = 4

local TILE_OFFSET_Y = 4

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
  statistics = {
    fatigue = 0,
    fun = 0,
    health = 0,
    money = 0
  },
  --
  tweener = nil,
  offset_x = 0,
  offset_y = 0,
  --
  activity_marker = os.time(),
  is_idle = false
}

function player:initialize(map)
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

--  self.shader = love.graphics.newShader('shaders/outline.glsl')
--  self.shader:send('_step', { 1 / self.sheet:getWidth(), 1 / self.sheet:getHeight() });
--  self.shader:send('_chroma', { 0.0, 1.0, 1.0 });

  self.x = 128
  self.y = 128
end

function player:input(dt)
  if self.tweener then
    return
  end

  local facing = self.facing

  local delta_x = 0
  local delta_y = 0

  if love.keyboard.isDown('left') then
    delta_x = -constants.TILE_WIDTH
    delta_y = 0
    facing = FACING_LEFT
  end
  if love.keyboard.isDown('right') then
    delta_x = constants.TILE_WIDTH
    delta_y = 0
    facing = FACING_RIGHT
  end
  if love.keyboard.isDown('up') then
    delta_x = 0
    delta_y = -constants.TILE_HEIGHT
    facing = FACING_UP
  end
  if love.keyboard.isDown('down') then
    delta_x = 0
    delta_y = constants.TILE_HEIGHT
    facing = FACING_DOWN
  end

  if delta_x == 0 and delta_y == 0 then
    return
  end

  self.activity_marker = os.time()

  -- A change in the direction will switch to the correct animation.
  if self.facing ~= facing then
    self.animator:switch_to(facing)
    self.facing = facing
  end

  -- Obtain the player map-coordinates
  local x, y = self.map:to_map(self.x + delta_x, self.y + delta_y)

  if self.map:is_walkable(x, y) then
    self.tweener = tweener.linear(0.25, function(ratio) 
        return { x = delta_x * ratio, y = delta_y * ratio }
      end)
  end
end

function player:update(dt)
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

  -- Retrieve the update tweened offset position. Keep the offset updated
  -- while tweening. Once ended, move to the next "cell" the dispose the
  -- tweener to release user input.
  local offset, continue = self.tweener(dt)

  if continue then
    self.offset_x = offset.x
    self.offset_y = offset.y
  else
    self.x = self.x + offset.x
    self.y = self.y + offset.y
    self.offset_x = 0
    self.offset_y = 0
    self.tweener = nil
  end
end

function player:draw()
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

function player:apply(features)
  local s = self.statistics
  
  s.fatigue = s.fatigue + features.fatigue
  s.fun = s.fun + features.fun
  s.health = s.health + features.health
  s.money = s.money + features.money
end

function player:position()
  return self.x, self.y
end

function player:pointing_to()
  local x, y = self.x, self.y
  if self.facing == FACING_UP then
    y = y - constants.TILE_HEIGHT
  elseif self.facing == FACING_DOWN then
    y = y + constants.TILE_HEIGHT
  elseif self.facing == FACING_LEFT then
    x = x - constants.TILE_WIDTH
  elseif self.facing == FACING_RIGHT then
    x = x + constants.TILE_WIDTH
  end
  return x, y
end

return player