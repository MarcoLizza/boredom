local utils = require('lib.utils')
local tweener = require('lib.tweener')
local Animator = require('lib.animator')
local constants = require('game.constants')

local TILE_OFFSET_Y = 4 + 8 -- compensate also for the bigger sprite height

local player = {
  x = 0,
  y = 0,
  width = 16,
  height = 24,
  sheet = nil,
  atlas = {},
  map = nil,
  animator = Animator.new(),
  frame = nil,
  facing = 'right',
  --
  statistics = {
    fatigue = 1,
    fun = 0,
    health = 3,
    money = 2
  },
  -- MOVEMENT --
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
      up = { 13, 14, 15, 16 },
      right = { 5, 6, 7, 8 },
      left = { 9, 10, 11, 12 },
      down = { 1, 2, 3, 4 }
    }, 8.0)
  self.animator:switch_to('right')
  self.animator:pause()

  self.shader = love.graphics.newShader('shaders/modulate.glsl')
  self.shader:send('_chroma', { 0.5, 0.5, 1.0 });

  self.x = 128 -- TODO: randomize?
  self.y = 128
end

function player:input(keys)
  if self.tweener then
    return
  end

  local facing = self.facing

  local delta_x = 0
  local delta_y = 0

  if keys['left'] then
    delta_x = -constants.TILE_WIDTH
    delta_y = 0
    facing = 'left'
  end
  if keys['right'] then
    delta_x = constants.TILE_WIDTH
    delta_y = 0
    facing = 'right'
  end
  if keys['up'] then
    delta_x = 0
    delta_y = -constants.TILE_HEIGHT
    facing = 'up'
  end
  if keys['down'] then
    delta_x = 0
    delta_y = constants.TILE_HEIGHT
    facing = 'down'
  end

  if delta_x == 0 and delta_y == 0 then
    return
  end

  self.activity_marker = os.time()

  -- A change in the direction will switch to the correct animation. However,
  -- the animation is initially paused, we will resume it only if the destination
  -- tile is walkable.
  if self.facing ~= facing then
    self.animator:switch_to(facing)
    self.animator:pause()
    self.facing = facing
  end

  -- Obtain the player map-coordinates
  local x, y = self.map:to_map(self.x + delta_x, self.y + delta_y)

  -- If the destination tile is walkable, the start the tweening movement
  -- and resume the animation
  if self.map:is_walkable(x, y) then
    self.tweener = tweener.linear(0.5, function(ratio) 
        return { x = delta_x * ratio, y = delta_y * ratio }
      end)
    self.animator:resume()
  end
end

function player:update(dt)
  -- When the user does not interact for a period, the actor will switch
  -- into "idle" state.
  local inactivity_time = os.difftime(self.activity_marker, os.time())
  self.is_idle = math.abs(inactivity_time) > 30

  -- Keep the player statistics updated for time related changes.
  self:update_statistics(dt)

  -- Pump the player animation. Returns the updated atlas index of the frame
  -- to be drawn.
  self.animator:update(dt)

  -- If the tweener is not set, shortcut exit since we are not moving the player.
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
    
    self.animator:pause()
    self.animator:seek(1)
  end
end

function player:draw()
  if self.is_idle then
    love.graphics.setShader(self.shader)
  end
  local frame = self.animator:get_frame()
  love.graphics.draw(self.sheet, self.atlas[frame],
    (self.x + self.offset_x), (self.y + self.offset_y - TILE_OFFSET_Y))
  if self.is_idle then
    love.graphics.setShader()
  end
end

function player:apply(features, time)
  local statistics = self.statistics
  
  statistics.fatigue = statistics.fatigue + features.fatigue
  statistics.fun = statistics.fun + features.fun
  statistics.health = statistics.health + features.health
  statistics.money = statistics.money + features.money
  
  self:update_statistics(time / 60) -- threat hours as they are realtime seconds
end

function player:update_statistics(dt)
  local statistics = self.statistics

  statistics.fatigue = statistics.fatigue + (0.010 * dt)
  statistics.fun = statistics.fun + (-0.020 * dt)
  statistics.health = statistics.health + (-0.005 * dt)
  statistics.money = statistics.money + (-0.005 * dt)
end

function player:position()
  return self.x + self.offset_x, self.y + self.offset_y
end

function player:pointing_to()
  local x, y = self.x, self.y
  if self.facing == 'up' then
    y = y - constants.TILE_HEIGHT
  elseif self.facing == 'down' then
    y = y + constants.TILE_HEIGHT
  elseif self.facing == 'left' then
    x = x - constants.TILE_WIDTH
  elseif self.facing == 'right' then
    x = x + constants.TILE_WIDTH
  end
  return x, y
end

return player