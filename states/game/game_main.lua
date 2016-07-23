local Main = Game:addState('Main')
local getForce = require('shared.get_force')
local drawGame = require('shared.draw_game')

function Main:enteredState()
end

function Main:update(dt)
  player:update(dt)

  for i,asteroid in ipairs(level.asteroids) do
    asteroid:update(dt)
  end

  local tx, ty = player:getPosition()
  local cx = tx - g.getWidth() / (2 / self.camera.scaleX)
  local cy = ty - g.getHeight() / (2 / self.camera.scaleY)
  self.camera:setPosition(cx, cy)

  world:update(dt)
end

function Main:draw()
  drawGame(self)
end

function Main:mousepressed(x, y, button, isTouch)
end

function Main:mousereleased(x, y, button, isTouch)
  local cost = 2
  if player.fuel >= cost then
    local mx, my = self.camera:mousePosition(x, y)
    local px, py = player:getPosition()
    local dx, dy = px - mx, py - my
    local phi = math.atan2(dy, dx)
    local thrust = 10
    player.body:setAngle(phi + math.pi / 2)
    player.body:applyLinearImpulse(thrust * math.cos(phi), thrust * math.sin(phi))
    player.fuel = player.fuel - cost
  end
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
