local getForce = require('shared.get_force')

local function drawShip(triangle_body)
  local x, y = triangle_body:getPosition()
  local mass = triangle_body:getMass()
  local vx, vy = triangle_body:getLinearVelocity()
  local phi = triangle_body:getAngle()

  g.setColor(255, 255, 255)
  g.draw(triangle_mesh, x, y, phi)

  local dt = 1/10

  g.setColor(255, 0, 0)

  for i=1,60 do
    local fx, fy = getForce(x, y, mass, GravityWell.instances)
    local acc_x, acc_y = fx / mass, fy / mass
    local tx, ty = acc_x * dt, acc_x * dt

    local dx, dy = dt * (vx + tx / 2), dt * (vy + ty / 2)
    g.line(x, y, x + dx, y + dy)
    x, y = x + dx, y + dy
    vx, vy = vx + tx, vy + ty

    local do_break = false
    for _,gw in pairs(GravityWell.instances) do
      if gw:testPoint(x, y) then
        g.print('bang', x, y)
        return
      end
    end
  end
end

return drawShip
