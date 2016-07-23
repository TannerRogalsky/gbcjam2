local MovityWell = class('MovityWell', GravityWell)

function MovityWell:initialize(x, y, size, mass, evaluator)
  GravityWell.initialize(self, x, y, size, mass)

  self.origin_x, self.origin_y = x, y
  self.evaluator = evaluator
end

function MovityWell:update(dt)
  local dx, dy = self.evaluator(love.timer.getTime())
  self.body:setPosition(self.origin_x + dx, self.origin_y + dy)
end

function MovityWell:draw()
  local x, y = self.body:getPosition()
  g.setColor(255, 255, 255)
  g.circle('fill', x, y, self:getRadius())
end

return MovityWell
