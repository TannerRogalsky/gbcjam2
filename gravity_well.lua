local GravityWell = class('GravityWell', Base)

function GravityWell:initialize(x, y, density)
  Base.initialize(self)

  local p = love.physics
  self.body = p.newBody(world, x, y, 'dynamic')
  self.fixture = p.newFixture(self.body, p.newCircleShape(40), density)
end

return GravityWell
