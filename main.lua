local constants = require("constants")

function love.load(args)
  if args[#args] == "-debug" then require("mobdebug").start() end
end

function love.draw()
  love.graphics.setColor(20, 255, 0, 255)
  love.graphics.print("Hello",
    constants.WINDOW_WIDTH / 2, constants.WINDOW_HEIGHT / 2)
end
