-- http://lua-users.org/wiki/ObjectOrientationTutorial
local Animator = {
  animations = {},
  period = 1 / 50,
  animation = nil,
  frame = 0,
  elapsed = 0
}

Animator.__index = Animator

function Animator.new()
  local self = setmetatable({}, Animator)
  return self
end

function Animator:initialize(animations, frequency)
  self.animations = animations
  self.period = 1 / frequency
end

function Animator:update(dt)
  if not self.animation then
    return
  end
  
  self.elapsed = self.elapsed + dt
  while self.elapsed > self.period do
    self.frame = (self.frame % #self.animation) + 1 -- move to next, damned 1-indices!
    self.elapsed = self.elapsed - self.period
  end
  
  return self.animation[self.frame]
end

function Animator:switch_to(index, reset)
  if reset or true then
    self.elapsed = 0
    self.frame = nil
  end

  if index >= 1 and index <= #self.animations then
    self.animation = self.animations[index]
    self.frame = 1
  end
end

return Animator