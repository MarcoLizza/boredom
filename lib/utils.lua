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

-- We are generically calling the source image "sheet" since it contains
-- the whole set of sub-images, and the quad-set "atlas" since it does
-- not contains any image-data but only rectangles used to pick the
-- frames from the sheet.
function utils.load_atlas(filename, frame_width, frame_height)
  local sheet = love.graphics.newImage(filename)
  local atlas = {}

--  sheet:setFilter('nearest', 'nearest', 0)

  -- The frames are organized in the sheet in a single row-by-colums,
  -- so we can get dynamically the amount of tiles with a couple of
  -- simple division.
  local columns = sheet:getWidth() / frame_width
  local rows = sheet:getHeight() / frame_height
  for i = 1, rows do
    for j = 1, columns do
      atlas[#atlas + 1] = love.graphics.newQuad((j - 1) * frame_width, (i - 1) * frame_height,
        frame_width, frame_width, sheet:getWidth(), sheet:getHeight())
    end
  end
  
  return sheet, atlas
end

return utils