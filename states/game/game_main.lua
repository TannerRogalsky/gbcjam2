local Main = Game:addState('Main')
local getForce = require('shared.get_force')

function Main:enteredState()
end

function Main:update(dt)
  world:update(dt)

  player:update(dt)

  local tx, ty = player:getPosition()

  local cx = tx - g.getWidth() / (2 / self.camera.scaleX)
  local cy = ty - g.getHeight() / (2 / self.camera.scaleY)
  self.camera:setPosition(cx, cy)

  -- local thrust = 50
  -- if love.keyboard.isDown('w') then
  --   local phi = triangle_body:getAngle() - math.pi / 2
  --   triangle_body:applyForce(thrust * math.cos(phi), thrust * math.sin(phi))
  -- end

  -- if love.keyboard.isDown('a') then triangle_body:applyTorque(-thrust) end
  -- if love.keyboard.isDown('d') then triangle_body:applyTorque(thrust) end
end

function Main:draw()
  self.camera:set()

  for i,gravity_well in pairs(GravityWell.instances) do
    gravity_well:draw()
  end

  player:draw()

  self.camera:unset()
end

function Main:mousepressed(x, y, button, isTouch)
end

function Main:mousereleased(x, y, button, isTouch)
  local mx, my = self.camera:mousePosition(x, y)
  local px, py = player:getPosition()
  local dx, dy = px - mx, py - my
  local phi = math.atan2(dy, dx)
  local thrust = 100
  player.body:setAngle(phi + math.pi / 2)
  player.body:applyLinearImpulse(thrust * math.cos(phi), thrust * math.sin(phi))
end

function Main:keypressed(key, scancode, isrepeat)
end

function Main:keyreleased(key, scancode)
  if key == 'r' then
    self:gotoState('MainStart')
  elseif key == 'escape' then
    self:gotoState('Menu')
  end
end

function Main:gamepadpressed(joystick, button)
end

function Main:gamepadreleased(joystick, button)
end

function Main:focus(has_focus)
end

function Main:exitedState()
  self.camera = nil
  world:destroy()
  for id,gw in pairs(GravityWell.instances) do
    gw:destroy()
  end
end

return Main
