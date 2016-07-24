local getForce = require('shared.get_force')
local getNearestGravityWellToPoint = require('shared.get_nearest_gravity_well_to_point')
local Player = class('Player', Base)

function Player:initialize(x, y, radius, fuel)
  Base.initialize(self)

  self.fuel = fuel or 10
  self.max_fuel = self.fuel

  local p = love.physics
  self.body = p.newBody(world, x, y, 'dynamic')
  self.fixture = p.newFixture(self.body, p.newCircleShape(radius), 3)
  self.fixture:setUserData(self)
  self.maxVelocity = 180
  self.body:setAngularDamping(2)

  -- Do particle shit
  self.enginepsystem = love.graphics.newParticleSystem(game.preloaded_images['flare-2.png'], 320)
  self.enginepsystem:setParticleLifetime(0.3, 0.8)
  self.enginepsystem:setSizes(0.2, 0.4)
  self.enginepsystem:setEmissionRate(50)
  self.enginepsystem:setSpeed(1.2, 1.4)
  -- self.enginepsystem:setLinearAcceleration(-20, -20, 20, 20) -- Random movement in all directions.
  self.enginepsystem:setColors(255, 255, 255, 255, 255, 255, 255, 0) -- Fade to transparency.
end

function Player:begin_contact(other, contact, nx, ny)
  if other == level.targets[target_index] then
    game:gotoState("Over")
  end
end

function Player:getPosition()
  return self.body:getPosition()
end

function Player:getLinearVelocity()
  return self.body:getLinearVelocity()
end

function Player:update(dt)
  local px, py = self.body:getPosition()
  local fx, fy = getForce(px, py, self.body:getMass(), GravityWell.instances)
  self.body:applyForce(fx, fy)

  self.fuel = math.min(self.max_fuel, self.fuel + dt)

  -- clamp linear velocity
  vx, vy = self.body:getLinearVelocity()
  self.body:setLinearVelocity(math.clamp(-self.maxVelocity, vx, self.maxVelocity), math.clamp(-self.maxVelocity, vy, self.maxVelocity))

  -- get closest gravity_well
  local nearestWell, dx, dy, dist = getNearestGravityWellToPoint(px, py, GravityWell.instances)
  dist = dist - (nearestWell:getRadius() ^ 2)

  -- If we're within an arbitrary dist^2, try and rotate to land using magic numbers
  if (dist < 25000) then
    local phi = math.atan2(dy, dx)
    local angle = (phi + math.pi / 2) - player.body:getAngle()
    angle = (angle + math.pi) % (math.tau) - math.pi
    player.body:applyTorque(angle * (0.022 * (26000 - dist)) )
  end

  -- set engine particle system rotation
  self.enginepsystem:setDirection(self.body:getAngle())
  self.enginepsystem:update(dt)

end

function Player:draw()
  g.setColor(255, 100, 100)
  g.draw(self.enginepsystem, 0, 0)

  local x, y = self.body:getPosition()
  local mass = self.body:getMass()
  local vx, vy = self.body:getLinearVelocity()
  local phi = self.body:getAngle()

  self.enginepsystem:setPosition(x, y)

  local radius = self.fixture:getShape():getRadius()

  g.setColor(255, 255, 255)
  -- g.circle('fill', x, y, radius)
  local bg = game.preloaded_images['juno_panels.png']
  local bgw, bgh = bg:getWidth(), bg:getHeight()
  local fg = game.preloaded_images['juno_face.png']
  local fgw, fgh = fg:getWidth(), fg:getHeight()
  local scale = bgw / 2 / radius
  g.draw(bg, x, y, love.timer.getTime(), scale, scale, bgw / 2, bgh / 2)
  g.draw(fg, x, y, phi, scale, scale, fgw / 2, fgh / 2)

  g.setColor(0, 255, 0)
  local tx, ty = level.targets[target_index]:getPosition()
  local phi = math.atan2(ty - y, tx - x)
  g.line(x, y, x + 100 * math.cos(phi), y + 100 * math.sin(phi))

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

return Player
