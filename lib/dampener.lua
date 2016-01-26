local dampener = {
  time = 0,
  delay = 0.125
}

function dampener:update(dt)
  self.time = self.time + dt
end

function dampener:passed()
  if self.time >= self.delay then
    return true
  end
  return false
end

function dampener:reset()
  self.time = 0
end

return dampener