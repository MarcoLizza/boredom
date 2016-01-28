-- http://lua-users.org/wiki/ObjectOrientationTutorial
local Animator = {
  animations = {},
  period = 1 / 50,
  animation = nil,
  elapsed = 0,
  frame = nil,
  running = nil
}

Animator.__index = Animator

function Animator.new()
  local self = setmetatable({}, Animator)
  return self
end

function Animator:initialize(animations, frequency)
  self.animations = animations
  self.period = 1 / (frequency or 50)
end

function Animator:update(dt)
  if not self.animation or not self.running then
    return
  end
  
  self.elapsed = self.elapsed + dt
  while self.elapsed > self.period do
    self.frame = (self.frame % #self.animation) + 1 -- move to next, damned 1-indices!
    self.elapsed = self.elapsed - self.period
  end
end

function Animator:switch_to(index, reset)
  if reset or true then
    self.elapsed = 0
    self.frame = nil
    self.running = true
  end

  if self.animations[index] then
    self.animation = self.animations[index]
    self.frame = 1
  end
end

function Animator:pause()
  self.running = false
end

function Animator:resume()
  self.running = true
end

function Animator:seek(frame)
  if frame >= 1 and frame <= #self.animation then
    self.frame = frame
  end
end

function Animator:get_frame()
  return self.animation[self.frame]
end

return Animator