local MainStart = Game:addState('MainStart')

function MainStart:enteredState()
  local Camera = require("lib/camera")
  self.camera = Camera:new()

  local p = love.physics
  world = p.newWorld(0, 0, true)
  world:setCallbacks(unpack(require('physics_callbacks')))

  level = require('levels.' .. self.sorted_names[self.level_index])()

  local radius = 10
  local start_thrust = 50
  local start = level.start
  local tx, ty = start.planet:getPosition()
  tx = tx + (start.planet:getRadius() + radius) * math.cos(start.direction)
  ty = ty + (start.planet:getRadius() + radius) * math.sin(start.direction)

  player = Player:new(tx, ty, radius)
  player.body:applyLinearImpulse(math.cos(start.direction) * start_thrust, math.sin(start.direction) * start_thrust)

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

  player:draw()

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
  if key == 'escape' then
    self:gotoState('Menu')
  end
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
