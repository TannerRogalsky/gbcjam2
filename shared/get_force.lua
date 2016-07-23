local GRAV_CONST = 0.00000000006674

local function getForce(x, y, mass, gravity_wells)
  local fx, fy = 0, 0

  local x1, y1 = x, y
  for _,gravity_well in pairs(gravity_wells) do
    local x2, y2 = gravity_well:getPosition()
    local dx, dy = x1 - x2, y1 - y2
    local dist2 = dx * dx + dy * dy
    local force = GRAV_CONST * (mass * gravity_well:getMass() / dist2)

    local phi = math.atan2(y2 - y1, x2 - x1)
    fx, fy = fx + force * math.cos(phi), fy + force * math.sin(phi)
  end

  return fx, fy
end

return getForce
