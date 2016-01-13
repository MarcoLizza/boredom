local _world = require("world")
local _player = require("player")

local _dampening = 0

function love.load(args)
  if args[#args] == "-debug" then require("mobdebug").start() end

  love.graphics.setDefaultFilter("nearest", "nearest", 0)

  _world:initialize()
  _player:initialize(_world)
end

function love.update(dt)
  _dampening = _dampening + dt
  if _dampening >= 0.25 then
    _dampening = _dampening - 0.25
    _player:input()
    _world:input()
  end

  _world:update(dt)
  _player:update(dt)
end

function love.draw()
  _world:draw(function(level)
      if level == 2 then
        _player:draw()
      end
    end)

  love.graphics.setColor(255, 255, 255)
  love.graphics.print("FPS: " .. love.timer.getFPS(), 0, 0)
end
