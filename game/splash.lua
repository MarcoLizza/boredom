local splash = {
  states = {
    { mode = 'fade-in', delay = 1, file = 'assets/splash_0.png' },
    { mode = 'display', delay = 5, file = 'assets/splash_0.png' },
    { mode = 'cross-out', delay = 0.25, file = 'assets/splash_0.png' },
    { mode = 'cross-in', delay = 0.25, file = 'assets/splash_1.png' },
    { mode = 'display', delay = 5, file = 'assets/splash_1.png' },
    { mode = 'cross-out', delay = 0.25, file = 'assets/splash_1.png' },
    { mode = 'cross-in', delay = 0.25, file = 'assets/splash_2.png' },
    { mode = 'display', delay = 5, file = 'assets/splash_2.png' },
    { mode = 'fade-out', delay = 2, file = 'assets/splash_2.png' },
  },
  index = nil,
  state = nil,
  image = nil,
  delay = 0,
  progress = 0
}

local function ease(value)
  return math.pow(value, 2.0)
end

function splash:initialize()
end

function splash:enter()
  self.index = 0
  self.delay = 0
  self.progress = 0
end

function splash:leave()
  self.image = nil
end

function splash:update(dt)
  if self.progress < self.delay then
    self.progress = self.progress + dt
  end
  
  if self.progress >= self.delay then
    -- Advance to the next state. When the end of the sequence is reached, we
    -- need to switch to the game state.
    self.index = self.index + 1
    if self.index > #self.states then
      return 'game'
    end
    -- Get the next state. If an image is defined, pre-load it. Then, we
    -- store the new state delay and reset the progress variable.
    self.state = self.states[self.index]
    if self.state.file then
      self.image = love.graphics.newImage(self.state.file)
    end
    self.delay = self.state.delay
    self.progress = 0
  end

  return nil
end

function splash:draw()
  local mode = self.state.mode
  
  if self.image then
    love.graphics.draw(self.image, 0, 0)
  end
  
  local alpha = self.progress / self.delay
  
  local color = nil
  if mode == 'fade-in' then -- from black
    local factor = ease(1.0 - alpha)
    color = { 0, 0, 0, factor * 255 }
  elseif mode == 'fade-out' then -- to black
    local factor = ease(alpha)
    color = { 0, 0, 0, factor * 255 }
  elseif mode == 'cross-in' then -- from white
    local factor = ease(1.0 - alpha)
    color = { 255, 255, 255, factor * 255 }
  elseif mode == 'cross-out' then -- to white
    local factor = ease(alpha)
    color = { 255, 255, 255, factor * 255 }
  end
  if color then
    love.graphics.setColor(color)
    love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    love.graphics.setColor(255, 255, 255)
  end
end

return splash