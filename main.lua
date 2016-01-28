local constants = require('game.constants')
local world = require('game.world')

function love.load(args)
  if args[#args] == '-debug' then require('mobdebug').start() end

  love.graphics.setDefaultFilter('nearest', 'nearest', 1)

  -- love.graphics.setBackgroundColor(255, 255, 255)
  local font = love.graphics.setNewFont("assets/fonts/slkscr.ttf", 8)

  world:initialize()
end

function love.keypressed(key, scancode, isrepeat)
  if key == 'f12' then
    local screenshot = love.graphics.newScreenshot()
    screenshot:encode('png', os.time() .. '.png')
  end
end

function love.update(dt)
  world:input(dt)
  world:update(dt)
end

function love.draw()
  love.graphics.push()
  love.graphics.scale(constants.MAGNIFICATION_FACTOR)

  world:draw()

  love.graphics.setColor(255, 255, 255)
  love.graphics.print('FPS: ' .. love.timer.getFPS(), 0, 0)
  
  love.graphics.pop()
end
