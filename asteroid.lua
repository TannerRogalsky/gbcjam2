local Asteroid = class('Asteroid', Base)
local getForce = require('shared.get_force')

function Asteroid:initialize(x, y, radius, dx, dy)
  Base.initialize(self)

  local p = love.physics
  self.body = p.newBody(world, x, y, 'dynamic')
  self.fixture = p.newFixture(self.body, p.newCircleShape(radius), 1)
  self.fixture:setUserData(self)

  self.body:applyLinearImpulse(dx, dy)
end

function Asteroid:update(dt)
  local tx, ty = self.body:getPosition()
  local fx, fy = getForce(tx, ty, self.body:getMass(), GravityWell.instances)
  self.body:applyForce(fx, fy)
end

function Asteroid:getPosition()
  return self.body:getPosition()
end

function Asteroid:getMass()
  return self.body:getMass()
end

function Asteroid:testPoint(x, y)
  return self.fixture:testPoint(x, y)
end

function Asteroid:getRadius()
  return self.fixture:getShape():getRadius()
end

function Asteroid:draw()
  local x, y = self.body:getPosition()
  g.setColor(100, 255, 100)
  g.circle('fill', x, y, self:getRadius())
end

return Asteroid
