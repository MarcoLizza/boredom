local constants = require('game.constants')

local gamestates = {
--  require('game.splash'),
  require('game.game')
}

local state = gamestates[1]

function switch_to(index)
  if state then
    state:leave()
  end
  state = gamestates[index]
  state:enter()
end

function love.load(args)
  if args[#args] == '-debug' then require('mobdebug').start() end

  love.graphics.setDefaultFilter('nearest', 'nearest', 1)

  -- love.graphics.setBackgroundColor(255, 255, 255)
  local font = love.graphics.setNewFont("assets/fonts/slkscr.ttf", 8)

  for _, v in ipairs(gamestates) do
    v:initialize()
  end

  switch_to(1)
end

function love.keypressed(key, scancode, isrepeat)
  if key == 'f12' then
    local screenshot = love.graphics.newScreenshot()
    screenshot:encode('png', os.time() .. '.png')
  end
end


--local _time = 0
function love.update(dt)
  local change, index = state:update(dt)
  if change then
    switch_to(index)
  end
--  _time = _time + dt
end

function love.draw()
  love.graphics.push()
  love.graphics.scale(constants.MAGNIFICATION_FACTOR)

  state:draw()

--  local alpha = (math.sin(_time * math.pi / 0.5) + 1.0) / 2.0
--  love.graphics.setColor(255, 255, 255, alpha * 255)
--  love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
--  love.graphics.setColor(255, 255, 255, 255)
  
  love.graphics.setColor(255, 255, 255)
  love.graphics.print('FPS: ' .. love.timer.getFPS(), 0, 0)
  
  love.graphics.pop()
end
