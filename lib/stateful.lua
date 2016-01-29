local Stateful = {
  states = {},
  current = nil
}

Stateful.__index = Stateful

-- Create a new [Stateful] class instance.
function Stateful.new()
  local self = setmetatable({}, Stateful)
  return self
end

-- Initialized the instance, binding the passed states table and initializing
-- each state in sequence. The states can be indexed both by a numeric index
-- or table key.
function Stateful:initialize(states)
  for key, state in pairs(states) do
    state:initialize()
    self.states[key] = state
  end
end

-- Leave the current state, if any, and switch to the new one (whose index/key
-- match the formal argument [key]).
function Stateful:switch_to(key)
  -- Check if the requested state exists. If not, bail out.
  local state = self.states[key]
  if not state then
    return
  end
  if self.current then
    self.current:leave()
  end
  self.current = state
  self.current:enter()
end

-- Update the current state, if any. Also handle the state-switch mechanism.
function Stateful:update(dt)
  -- Current state not defined, bail out.
  if not self.current then
    return
  end
  -- Update the current state. The result value is the key of the new state to
  -- be activated, or [nil] to continue with the current one.
  local key = self.current:update(dt)
  if key then
    self:switch_to(key)
  end
end

-- Draw the current state, if any.
function Stateful:draw()
  if not self.current then
    return
  end
  self.current:draw()
end

return Stateful