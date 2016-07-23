local function getNearestGravityWellToPoint(x, y, gravity_wells)
  local fx, fy = 0, 0

  local x1, y1, dist, cdx, cdy = x, y, math.maxinteger, nil, nil
  local dx, dy, closest_well

  for _,gravity_well in pairs(gravity_wells) do
    local x2, y2 = gravity_well:getPosition()
    local dx, dy = x1 - x2, y1 - y2
    local dist2 = dx * dx + dy * dy

    if (dist == nil or dist2 < dist) then
      cdx, cdy = dx, dy
      closest_well = gravity_well
      dist = dist2
    end
  end

  return closest_well, cdx, cdy, dist
end

return getNearestGravityWellToPoint
