local Main = Game:addState('Main')

local GRAV_CONST = 0.00000000006674

local function getForce(x, y, mass, gravity_wells)
  local fx, fy = 0, 0

  local x1, y1 = x, y
  for _,gravity_well in ipairs(gravity_wells) do
    local x2, y2 = gravity_well:getPosition()
    local dx, dy = x1 - x2, y1 - y2
    local dist2 = dx * dx + dy * dy
    local force = GRAV_CONST * (mass * gravity_well:getMass() / dist2)

    local phi = math.atan2(y2 - y1, x2 - x1)
    fx, fy = fx + force * math.cos(phi), fy + force * math.sin(phi)
  end

  return fx, fy
end

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

  triangle_body:applyLinearImpulse(0, -200)

  gravity_wells = {}
  table.insert(gravity_wells, GravityWell:new(0, 0, 10 ^ 16))
  table.insert(gravity_wells, GravityWell:new(-400, 0, 10 ^ 16))
  table.insert(gravity_wells, GravityWell:new(-400, -400, 10 ^ 16))
  table.insert(gravity_wells, GravityWell:new(0, -400, 10 ^ 16))

  g.setFont(self.preloaded_fonts["04b03_16"])
  self.camera:scale(2, 2)
  self.camera:move(-g.getWidth(), - g.getHeight())
end

function Main:update(dt)
  world:update(dt)

  local tx, ty = triangle_body:getPosition()
  local fx, fy = getForce(tx, ty, triangle_body:getMass(), gravity_wells)
  triangle_body:applyForce(fx, fy)

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
    local mass = triangle_body:getMass()
    local vx, vy = triangle_body:getLinearVelocity()
    local phi = triangle_body:getAngle()

    g.draw(triangle_mesh, x, y, phi)

    local dt = love.timer.getAverageDelta() * 2

    g.setColor(255, 0, 0)

    for i=1,60 do
      local fx, fy = getForce(x, y, mass, gravity_wells)
      local acc_x, acc_y = fx / mass, fy / mass
      local tx, ty = acc_x * dt, acc_x * dt

      local dx, dy = dt * (vx + tx / 2), dt * (vy + ty / 2)
      g.line(x, y, x + dx, y + dy)
      x, y = x + dx, y + dy
      vx, vy = vx + tx, vy + ty

      local do_break = false
      for _,gw in ipairs(gravity_wells) do
        if gw:testPoint(x, y) then
          g.print('bang', x, y)
          do_break = true
          break
        end
      end

      if do_break then break end
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
