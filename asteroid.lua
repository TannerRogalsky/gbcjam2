local Asteroid = class('Asteroid', Base)
local getForce = require('shared.get_force')

function Asteroid:initialize(x, y, radius, evaluator)
  Base.initialize(self)

  self.origin_x = x
  self.origin_y = y

  local p = love.physics
  self.body = p.newBody(world, x, y, 'dynamic')
  self.fixture = p.newFixture(self.body, p.newCircleShape(radius), 1)
  self.fixture:setUserData(self)

  self.evaluator = evaluator
end

function Asteroid:update(dt)
  if self.evaluator then
    local dx, dy = self.evaluator(love.timer.getTime())
    self.body:setPosition(self.origin_x + dx, self.origin_y + dy)
  end
  self.body:applyForce(200 * dt, love.math.random() - 0.5 * 50 * dt)
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
