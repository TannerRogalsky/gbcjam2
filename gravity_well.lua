local GravityWell = class('GravityWell', Base)
GravityWell.static.instances = {}

function GravityWell:initialize(x, y, radius, mass)
  Base.initialize(self)

  local p = love.physics
  self.body = p.newBody(world, x, y, 'dynamic')
  self.fixture = p.newFixture(self.body, p.newCircleShape(radius), 1)
  self.body:setMass(mass)
  self.fixture:setUserData(self)

  GravityWell.instances[self.id] = self
end

function GravityWell:getPosition()
  return self.body:getPosition()
end

function GravityWell:getMass()
  return self.body:getMass()
end

function GravityWell:testPoint(x, y)
  return self.fixture:testPoint(x, y)
end

function GravityWell:getRadius()
  return self.fixture:getShape():getRadius()
end

function GravityWell:destroy()
  GravityWell.instances[self.id] = nil
end

function GravityWell:draw()
  local x, y = self.body:getPosition()
  g.setColor(255, 255, 255)
  g.circle('fill', x, y, self:getRadius())
end

return GravityWell
