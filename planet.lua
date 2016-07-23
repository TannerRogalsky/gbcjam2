local Planet = class('Planet', GravityWell)

function Planet:initialize(x, y, density, color)
  GravityWell.initialize(self, x, y, density)

  self.color = color
end

function Planet:draw()
  local x, y = self.body:getPosition()
  g.setColor(self.color)
  g.circle('fill', x, y, self:getRadius())
end

return Planet
