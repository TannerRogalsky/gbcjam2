local Planet = class('Planet', GravityWell)

function Planet:initialize(x, y, size, mass, color, name)
  GravityWell.initialize(self, x, y, size, mass)

  self.name = name
  self.color = color

  self.image = game.preloaded_images['planet_' .. name:lower() .. '.png']
end

function Planet:draw()
  local x, y = self.body:getPosition()
  -- g.setColor(self.color)
  -- g.circle('fill', x, y, self:getRadius())
  local w, h = self.image:getDimensions()
  g.draw(self.image, x, y, 0, 3, 3, w / 2, h / 2)
end

return Planet
