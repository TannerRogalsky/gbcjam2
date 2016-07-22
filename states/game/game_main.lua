local Main = Game:addState('Main')

local GRAV_CONST = 0.00000000006674

function Main:enteredState()
  local Camera = require("lib/camera")
  self.camera = Camera:new()

  local p = love.physics
  world = p.newWorld(0, 0, true)

  local radius = 30
  triangle_mesh = g.newMesh({
    {0, -radius},
    {radius, radius},
    {-radius, radius},
  })

  triangle_body = p.newBody(world, g.getWidth() / 2, g.getHeight() / 2, 'dynamic')
  triangle_shape = p.newPolygonShape(0, -radius, radius, radius, -radius, radius)
  triangle_fixture = p.newFixture(triangle_body, triangle_shape, 1)

  fx, fy = 50 * 50, -200 * 50
  triangle_body:applyForce(fx, fy)

  gravity_wells = {}
  table.insert(gravity_wells, GravityWell:new(0, 0, 10 ^ 16))

  g.setFont(self.preloaded_fonts["04b03_16"])
  self.camera:scale(2, 2)
  self.camera:move(-g.getWidth(), - g.getHeight())
end

function Main:update(dt)
  world:update(dt)

  fx, fy = 0, 0

  local bodies = world:getBodyList()
  for _,bodyA in ipairs(bodies) do
    for _,bodyB in ipairs(bodies) do
      if bodyA ~= bodyB then
        local x1, y1 = bodyA:getPosition()
        local x2, y2 = bodyB:getPosition()
        local dx, dy = x1 - x2, y1 - y2
        local dist2 = dx * dx + dy * dy
        local force = GRAV_CONST * (bodyA:getMass() * bodyB:getMass() / dist2)

        local bodyADirection = math.atan2(y2 - y1, x2 - x1)
        bodyA:applyForce(force * math.cos(bodyADirection), force * math.sin(bodyADirection))

        local bodyBDirection = math.atan2(y1 - y2, x1 - x2)
        bodyB:applyForce(force * math.cos(bodyBDirection), force * math.sin(bodyBDirection))

        if bodyA == triangle_body then
          fx, fy = fx + force * math.cos(bodyADirection), fy + force * math.sin(bodyADirection)
        elseif bodyB == triangle_body then
          fx, fy = fx + force * math.cos(bodyBDirection), fy + force * math.sin(bodyBDirection)
        end
      end
    end
  end

  local thrust = 50
  if love.keyboard.isDown('w') then
    local phi = triangle_body:getAngle() - math.pi / 2
    triangle_body:applyForce(thrust * math.cos(phi), thrust * math.sin(phi))
  end

  if love.keyboard.isDown('a') then triangle_body:applyTorque(-thrust) end
  if love.keyboard.isDown('d') then triangle_body:applyTorque(thrust) end
end

function Main:draw()
  self.camera:set()

  g.setColor(255, 255, 255)
  for i,gravity_well in ipairs(gravity_wells) do
    local x, y = gravity_well.body:getPosition()
    g.circle('fill', x, y, 40)
  end

  do
    local x, y = triangle_body:getPosition()
    local phi = triangle_body:getAngle()
    g.draw(triangle_mesh, x, y, phi)

    local vx, vy = triangle_body:getLinearVelocity()
    local w = triangle_body:getAngularVelocity()

    g.setColor(255, 0, 0)
    local mass = triangle_body:getMass()
    local acc_x, acc_y = fx / mass, fy / mass
    do
      local dt = 1/60*2
      local tx, ty = acc_x * dt, acc_x * dt
      local px, py = x, y
      for i=1,100 do
        local dx, dy = dt * (vx + tx / 2), dt * (vy + ty / 2)
        g.line(px, py, px + dx, py + dy)
        px, py = px + dx, py + dy
        vx, vy = vx + tx, vy + ty
      end
    end
  end

  self.camera:unset()
end

function Main:mousepressed(x, y, button, isTouch)
end

function Main:mousereleased(x, y, button, isTouch)
end

function Main:keypressed(key, scancode, isrepeat)
end

function Main:keyreleased(key, scancode)
end

function Main:gamepadpressed(joystick, button)
end

function Main:gamepadreleased(joystick, button)
end

function Main:focus(has_focus)
end

function Main:exitedState()
  self.camera = nil
end

return Main
