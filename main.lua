local constants = require('game.constants')
local Stateful = require('lib.stateful')

local stateful = nil

function love.load(args)
  if args[#args] == '-debug' then require('mobdebug').start() end

  love.graphics.setDefaultFilter('nearest', 'nearest', 1)

  -- Initializes the state-engine.
  stateful = Stateful.new()
  stateful:initialize({
    splash = require('game.splash'),
    game = require('game.game')
  })
  stateful:switch_to('splash')
end

function love.keypressed(key, scancode, isrepeat)
  if key == 'f12' then
    local screenshot = love.graphics.newScreenshot()
    screenshot:encode('png', os.time() .. '.png')
  end
end

function love.update(dt)
  stateful:update(dt)
end

function love.draw()
  love.graphics.push()
  love.graphics.scale(constants.MAGNIFICATION_FACTOR)

  stateful:draw()
  
  love.graphics.pop()
end
