local Planet = class('Planet', GravityWell)

function Planet:initialize(x, y, size, mass, color, name)
  GravityWell.initialize(self, x, y, size, mass)

  self.name = name
  self.color = color
end

function Planet:draw()
  local x, y = self.body:getPosition()
  g.setColor(self.color)
  g.circle('fill', x, y, self:getRadius())
end

return Planet
