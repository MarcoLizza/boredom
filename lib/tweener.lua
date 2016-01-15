-- module tweener.lua
local tweener = {
}

-- Creates a tweening linear functor that interpolates between the values [from]
-- and [to] in [time] seconds. Internally accumulates the current time upon each
-- subsequent call. Returns both the interpolated value and a boolean telling
-- wether the tweening has ended.
function tweener.linear(from, to, time)
  local current = 0
  local delta = to - from
  return function(dt)
    current = current + dt
    if current >= time then
      return to, true
    else
      return delta * current / time + from, false
    end
  end
end

return tweener