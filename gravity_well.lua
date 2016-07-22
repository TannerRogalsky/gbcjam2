local GravityWell = class('GravityWell', Base)

function GravityWell:initialize(x, y, density)
  Base.initialize(self)

  local p = love.physics
  self.body = p.newBody(world, x, y, 'dynamic')
  self.fixture = p.newFixture(self.body, p.newCircleShape(40), density)
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

return GravityWell
