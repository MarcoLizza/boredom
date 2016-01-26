local constants = require('game.constants')

local items = {
  items = {
    {
      x = 13 * 16,
      y = 0 * 16,
      width = 32,
      height = 48,
      image = 'assets/items/television.png',
      sheet = nil,
      is_near = false,
      is_in_front = false,
      object = {
        question = 'Would you like me to watch some TV?',
        time = 1 * 60 * 60,
        features = {
          fatigue = 2,
          fun = 2,
          health = -1,
          money = 0,
        },
      },
    },
    {
      x = 1 * 16,
      y = 5 * 16,
      width = 32,
      height = 64,
      image = 'assets/items/bed.png',
      sheet = nil,
      is_near = false,
      is_in_front = false,
      object = {
        question = 'Should I go to bed?',
        time = 8 * 60 * 60,
        features = {
          fatigue = -4,
          fun = 0,
          health = 2,
          money = 0,
        },
      },
    },
  }
}

function items:initialize(player)
  self.player = player

  for _, item in pairs(self.items) do
    item.sheet = love.graphics.newImage(item.image)
  end
end

function items:update(dt)
end

function items:draw()
  for _, item in pairs(self.items) do
    love.graphics.draw(item.sheet, item.x * 3, item.y * 3, 0, 3, 3) -- SCALE
  end
end

function items:at(x, y)
  for _, item in pairs(self.items) do
    if x >= item.x and y >= item.y and x < (item.x + item.width) and y < (item.y + item.height) then
      return item.object
    end
  end
  return nil
end

return items
