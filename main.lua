local constants = require('game.constants')
local Stateful = require('lib.stateful')

local stateful = nil

function love.load(args)
  if args[#args] == '-debug' then require('mobdebug').start() end

  love.graphics.setDefaultFilter('nearest', 'nearest', 1)

  -- love.graphics.setBackgroundColor(255, 255, 255)
  local font = love.graphics.setNewFont('assets/fonts/slkscr.ttf', 8)
--  local font = love.graphics.newImageFont('assets/imagefonts/arcade_17.png', ' abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,!?-+/():;%&`\'*#=[]"')
--  local font = love.graphics.newImageFont('assets/imagefonts/silkscreen_normal_8.png', ' !\"#$%&\'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~')
--  love.graphics.setFont(font)

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

  love.graphics.setColor(255, 255, 255)
  love.graphics.print('FPS: ' .. love.timer.getFPS(), 0, 0)
  
  love.graphics.pop()
end
