local utils = {
}

-- The day is divided into five regions of time, that is "night", "morning",
-- "noon", "afternoon", and "evening" according to the following diagram.
--
--           1         2
-- 012345678901234567890123
-- |       |   |   |   |
-- nnnnnnnnMMMMNNNNAAAAEEEE
local SECONDS_IN_MINUTE = 60
local SECONDS_IN_HOUR = 60 * SECONDS_IN_MINUTE
-- local SECONDS_IN_DAY = 26 * SECONDS_IN_HOUR

local MORNING = 8 * SECONDS_IN_HOUR
local NOON = 12 * SECONDS_IN_HOUR
local AFTERNOON = 16 * SECONDS_IN_HOUR
local EVENING = 20 * SECONDS_IN_HOUR

-- Formats the current game time (in floating-point seconds) to a more
-- conveniente "HH:MM:SS" format.
function utils.format_time(time)
  time = math.floor(time)
  local seconds = time % 60
  
  time = math.floor(time / 60)
  local minutes = time % 60
  
  time = math.floor(time / 60)
  local hours = time % 24

  return string.format('%02d:%02d:%02d', hours, minutes, seconds)
end

-- Returns a string decribing the current time of day (e.g. "noon") given
-- the time expressed in seconds.
function utils.time_of_day(time)
  time = math.floor(time % 86400)

  if time >= MORNING and time < NOON then
    return 'morning'
  elseif time >= NOON and time < AFTERNOON then
    return 'noon'
  elseif time >= AFTERNOON and time < EVENING then
    return 'afternoon'
  elseif time >= EVENING then
    return 'evening'
  else
    return 'night'
  end
end


return utils