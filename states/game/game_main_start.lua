local MainStart = Game:addState('MainStart')
local drawShip = require('shared.draw_ship')

function MainStart:enteredState()
  local Camera = require("lib/camera")
  self.camera = Camera:new()

  local p = love.physics
  world = p.newWorld(0, 0, true)

  local radius = 10
  triangle_mesh = g.newMesh({
    {0, -radius},
    {radius, radius},
    {-radius, radius},
  })

  triangle_body = p.newBody(world, g.getWidth() / 2, g.getHeight() / 2, 'dynamic')
  triangle_shape = p.newPolygonShape(0, -radius, radius, radius, -radius, radius)
  triangle_fixture = p.newFixture(triangle_body, triangle_shape, 3)

  level = require('levels/test')()
  local start_thrust = 50
  local start = level.start
  local tx, ty = start.planet:getPosition()
  tx = tx + (start.planet:getRadius() + radius) * math.cos(start.direction)
  ty = ty + (start.planet:getRadius() + radius) * math.sin(start.direction)
  triangle_body:setPosition(tx, ty)
  triangle_body:applyLinearImpulse(math.cos(start.direction) * start_thrust, math.sin(start.direction) * start_thrust)

  g.setFont(self.preloaded_fonts["04b03_16"])
  self.camera:scale(2, 2)
  local cx = tx - g.getWidth() / (2 / self.camera.scaleX)
  local cy = ty - g.getHeight() / (2 / self.camera.scaleY)
  self.camera:setPosition(cx, cy)
end

function MainStart:draw()
  self.camera:set()

  for i,gravity_well in pairs(GravityWell.instances) do
    gravity_well:draw()
  end

  drawShip(triangle_body)

  self.camera:unset()
end

function MainStart:mousepressed(x, y, button, isTouch)
end

function MainStart:mousereleased(x, y, button, isTouch)
  self:gotoState('Main')
end

function MainStart:keypressed(key, scancode, isrepeat)
end

function MainStart:keyreleased(key, scancode)
end

function MainStart:gamepadpressed(joystick, button)
end

function MainStart:gamepadreleased(joystick, button)
end

function MainStart:focus(has_focus)
end

function MainStart:exitedState()
end

return MainStart
