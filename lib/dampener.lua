local dampener = {
  time = 0,
  delay = 0.125
}

function dampener:passed(dt)
  self.time = self.time + dt
  if self.time >= self.delay then
    self.time = 0
    return true
  end
  return false
end

return dampener