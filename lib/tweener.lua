-- module tweener.lua
local tweener = {
}

-- Creates a tweening linear functor that interpolates between the values [from]
-- and [to] in [time] seconds. Internally accumulates the current time upon each
-- subsequent call. Returns both the interpolated value and a boolean telling
-- wether the tweening has ended.
function tweener.linear(time, callback)
  local current = 0
  return function(dt)
    current = current + dt
    if current > time then
      current = time
    end
    local ratio = current / time
    return callback(ratio), current < time
  end
end

return tweener