local items = {
  list = {
    {
      tiles = { { x = 1, y = 4} },
      description = 'Stereo player',
      features = {
        fatigue = 0,
        time = 2,
        fun = 3,
        health = 0,
        money = 0,
      }
    }
  }
}

function items:collide_with(x, y)
  local set = { }
  for _, item in ipairs(self.list)
    for _, tile in ipairs(item.tiles)
      if x == tile.x and y == tile.y then
        set[#set + 1] = item
        break
      end
    end
  end
  return set
end

return items