local _world = require('world')

local _dampening = 0

function love.load(args)
  if args[#args] == '-debug' then require('mobdebug').start() end

  love.filesystem.setIdentity('D:\anorak')

  love.graphics.setDefaultFilter('nearest', 'nearest', 0)

  _world:initialize()
end

function love.keypressed(key, scancode, isrepeat)
  if key == 'f12' then
    local screenshot = love.graphics.newScreenshot()
    screenshot:encode('png', 'screenshot.png')
  end
end

function love.update(dt)
  _dampening = _dampening + dt
  if _dampening >= 0.125 then
    _dampening = _dampening - 0.125
    _world:input()
  end

  _world:update(dt)
end

function love.draw()
  _world:draw()

  love.graphics.setColor(255, 255, 255)
  love.graphics.print('FPS: ' .. love.timer.getFPS(), 0, 0)
end
