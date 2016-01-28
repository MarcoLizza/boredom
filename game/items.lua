local constants = require('game.constants')

local items = {
  items = {
    {
      x = 2,
      y = 1,
      width = 3,
      height = 1,
      facings = { up = true },
      condition = function(world) end,
      object = {
        question = 'Will I cook something to eat?',
        time = 1 * 60 * 60,
        features = {
          fatigue = 1,
          fun = 1,
          health = 0,
          money = -2,
        },
      },
    },
    {
      x = 5,
      y = 1,
      width = 2,
      height = 1,
      facings = { up = true },
      object = {
        question = 'Should I relax myself and watch TV?',
        time = 8 * 60 * 60,
        features = {
          fatigue = -1,
          fun = 2,
          health = -1,
          money = -1,
        },
      },
    },
    {
      x = 8,
      y = 1,
      width = 1,
      height = 1,
      facings = { up = true },
      object = {
        question = 'Should I... a-ehm...',
        time = 0.25 * 60 * 60,
        features = {
          fatigue = 0,
          fun = -1,
          health = 1,
          money = 0,
        },
      },
    },
    {
      x = 9,
      y = 1,
      width = 2,
      height = 1,
      facings = { up = true },
      object = {
        question = 'Have a bath?',
        time = 0.5 * 60 * 60,
        features = {
          fatigue = -1,
          fun = -1,
          health = 2,
          money = -1,
        },
      },
    },
    {
      x = 18,
      y = 2,
      width = 1,
      height = 1,
      facings = { right = true, up = true },
      object = {
        question = 'Yawn! Should I go to bed?',
        time = 8 * 60 * 60,
        features = {
          fatigue = -4,
          fun = 1,
          health = 2,
          money = 0,
        },
      },
    },
    {
      x = 2,
      y = 5,
      width = 2,
      height = 1,
      facings = { up = true },
      object = {
        question = 'Should I work to my computer game?',
        time = 3 * 60 * 60,
        features = {
          fatigue = -2,
          fun = 3,
          health = -1,
          money = -1,
        },
      },
    },
    {
      x = 5,
      y = 5,
      width = 2,
      height = 1,
      facings = { up = true },
      object = {
        question = 'Feel like reading some books?',
        time = 1 * 60 * 60,
        features = {
          fatigue = -1,
          fun = 2,
          health = 1,
          money = 0,
        },
      },
    },
    {
      x = 8,
      y = 5,
      width = 1,
      height = 1,
      facings = { up = true },
      object = {
        question = 'Yum! I\'m starving! Eat some food?',
        time = 0.5 * 60 * 60,
        features = {
          fatigue = -1,
          fun = 1,
          health = 3,
          money = -1,
        },
      },
    },
    {
      x = 16,
      y = 6,
      width = 2,
      height = 1,
      facings = { up = true },
      object = {
        question = 'Da-da-da-dan! Play some piano?',
        time = 2 * 60 * 60,
        features = {
          fatigue = -1,
          fun = 3,
          health = -1,
          money = 0,
        },
      },
    },
    {
      x = 5,
      y = 9,
      width = 1,
      height = 1,
      facings = { up = true },
      object = {
        question = 'Oh, my! What a mess! Go clean it!',
        time = 1 * 60 * 60,
        features = {
          fatigue = -2,
          fun = -2,
          health = 1,
          money = 0,
        },
      },
    },
    {
      x = 10,
      y = 13,
      width = 1,
      height = 1,
      facings = { down = true },
      object = {
        question = 'Let\'s go to work...',
        time = 8 * 60 * 60,
        features = {
          fatigue = -4,
          fun = -2,
          health = -2,
          money = 8,
        },
      },
    },
  }
}

function items:initialize(player)
  self.player = player
  
  -- Scale the map-coordinates to display-coordinates for ease of use.
  for _, item in ipairs(self.items) do
    item.x = item.x * constants.TILE_WIDTH
    item.y = item.y * constants.TILE_HEIGHT
    item.width = item.width * constants.TILE_WIDTH
    item.height = item.height * constants.TILE_HEIGHT
  end
end

function items:update(dt)
end

function items:draw()
  -- Items are *real* map objects. We are drawing them with the map itself.
end

function items:at(x, y, facing)
  for _, item in pairs(self.items) do
    if x >= item.x and y >= item.y and x < (item.x + item.width) and y < (item.y + item.height) then
      if not facing or item.facings[facing] then
        return item.object
      end
    end
  end
  return nil
end

return items
