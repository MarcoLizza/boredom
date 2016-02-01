--[[

Copyright (c) 2016 by Marco Lizza (marco.lizza@gmail.com)

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgement in the product documentation would be
   appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.

]]--

-- MODULE INCLUSIONS -----------------------------------------------------------

Dampener = require('lib.dampener')
utils = require('lib.utils')

-- MODULE DECLARATION ----------------------------------------------------------

-- @module world
local world = {
  map = require('game.map'),
  items = require('game.items'),
  player = require('game.player'),
  hud = require('game.hud'),
  dampener = Dampener.new(),
  speed = 15.0,
  -- SIMULATION --
  time = nil,
  -- INTERACTION --
  item_object = nil,
  is_interacting = false
}

-- LOCAL CONSTANTS -------------------------------------------------------------

local OBJECT_LAYER_INDEX = 4

local KEYS = {
  'x', 'c', 'up', 'down', 'left', 'right'
}

-- MODULE FUNCTIONS ------------------------------------------------------------

function world:initialize()
  self.map:initialize()
  self.player:initialize(self.map)
  self.items:initialize(self.player)
  self.hud:initialize(self)

  self.dampener:initialize(0.5)
end

function world:reset()
  self.dampener:reset()

  self.time = 8 * 60 * 60 -- game start a 8 'o clock (AM)

  self.player:reset()
end

function world:input(dt)
  self.dampener:update(dt)
  local passed = self.dampener:passed()

  local keys, has_input = utils.grab_input(KEYS)

  if self.is_interacting then
    if passed and keys['x'] then
      self.player:apply(self.item_object.features, self.item_object.time)
      self.time = self.time + self.item_object.time
      self.is_interacting = false
      self.dampener:reset()
    elseif passed and keys['c'] then
      self.is_interacting = false
      self.dampener:reset()
    end
    return
  end

  if passed and keys['x'] then
    if self.item_object then
      self.is_interacting = true
    end
    self.dampener:reset()
  end

  self.map:input(keys)
  self.items:input(keys)
  self.player:input(keys)
  self.hud:input(keys)
end

function world:update(dt)
  self.map:update(dt)
  self.items:update(dt)
  self.player:update(dt)
  self.hud:update(dt)

  -- Keep the player "focus-object" updated.
  local x, y = self.player:pointing_to()
  self.item_object = self.items:at(x, y, self.player.facing)

  -- Advance time only when we are not asking for using input. That is
  -- the game is paused when asking for user input.
  if self.is_interacting then
    return
  end

  self.time = self.time + (dt * self.speed)
end

function world:draw()
  self.map:draw(function(level)
      if level == OBJECT_LAYER_INDEX then
        self.items:draw()
        self.player:draw()
      end
    end)

  self.hud:draw()
end

-- END OF MODULE ---------------------------------------------------------------

return world

-- END OF FILE -----------------------------------------------------------------
