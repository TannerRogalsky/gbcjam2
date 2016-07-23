local Asteroid = class('Asteroid', Base)
local getForce = require('shared.get_force')

function Asteroid:initialize(x, y, radius, evaluator)
  Base.initialize(self)

  self.origin_x = x
  self.origin_y = y

  local p = love.physics
  self.body = p.newBody(world, x, y, 'dynamic')

  local astindex = love.math.random(#asteroid_quads)

  local vertices = {
    {
      {-9, 2, -2, 9, -2, 10, -7, 10, -12, 7, -12, 4},
      {4, 8, 3, -6, 3, -7, 8, -7, 10, -5, 10, 3},
      {3, -6, 4, 8, -2, 9, -9, 2, -9, -1, -5, -5},
    }, {
      {12, -1, 0, 8, 1, -7, 11, -7},
      {9, 10, 1, 10, 0, 8, 12, -1, 13, -1, 13, 6},
      {-11, -7, -7, -9, 0, -9, 1, -7, 0, 8, -5, 8, -13, 0, -13, -4},
    }, {
      {-10, -14, -3, -14, 1, -11, 2, -8, -4, 12, -13, 2, -15, -2, -15, -9},
      {15, 9, 10, 14, -2, 14, -4, 12, 2, -8, 5, -8, 13, -3},
      {-13, 6, -13, 2, -4, 12, -9, 11},
    }
  }
  for i,verts in ipairs(vertices[astindex]) do
    local fixture = p.newFixture(self.body, p.newPolygonShape(verts), 1)
    fixture:setUserData(self)
  end
  -- self.fixture = p.newFixture(self.body, p.newCircleShape(radius), 1)
  -- self.fixture = p.newFixture(self.body, p.newChainShape(true, {26, -13, 20, -8, 14, -7, 14, -6, 9, -6, 4, -9, 4, -12, 7, -14, 7, -17, 11, -21, 19, -22, 19, -23, 24, -23, 26, -21}), 1)
  -- self.fixture:setUserData(self)

  self.quad = asteroid_quads[astindex]
  local _, _, w, h = self.quad:getViewport()
  self.batch_id = asteroids_batch:add(self.quad, x, y, 0, 1, 1, w / 2, h / 2)

  self.evaluator = evaluator
end

function Asteroid:update(dt)
  if self.evaluator then
    local dx, dy = self.evaluator(love.timer.getTime())
    self.body:setPosition(self.origin_x + dx, self.origin_y + dy)
  end
  self.body:applyForce(200 * dt, love.math.random() - 0.5 * 50 * dt)

  local x, y = self:getPosition()
  local phi = self.body:getAngle()
  local _, _, w, h = self.quad:getViewport()
  asteroids_batch:set(self.batch_id, self.quad, x, y, phi, 1, 1, w / 2, h / 2)
end

function Asteroid:getPosition()
  return self.body:getPosition()
end

function Asteroid:getMass()
  return self.body:getMass()
end

function Asteroid:draw()
  local x, y = self.body:getPosition()
  g.setColor(100, 255, 100)
  g.circle('fill', x, y, self:getRadius())
end

return Asteroid
