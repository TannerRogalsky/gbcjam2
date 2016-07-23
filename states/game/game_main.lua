local Main = Game:addState('Main')
local getForce = require('shared.get_force')
local drawGame = require('shared.draw_game')

function Main:enteredState()
  local function spawnAsteroid()
    local ax, ay = self.camera:mousePosition(-50, love.math.random(g.getHeight()))
    local asteroid = Asteroid:new(ax, ay, love.math.random(10, 30))
    asteroid.body:applyLinearImpulse(200, 0)
    table.insert(level.asteroids, asteroid)
  end
  asteroid_spawn = cron.every(0.5, spawnAsteroid)
  -- for i=1,10 do
  --   spawnAsteroid()
  -- end
end

function Main:update(dt)
  player:update(dt)
  asteroid_spawn:update(dt)

  local vx, vy = player:getLinearVelocity()
  local s = (math.abs(vx) + math.abs(vy)) / 2 / player.maxVelocity
  self.camera:setScale(0.5 + s * 6, 0.5 + s * 6)

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
    local thrust = 30

    -- rotate player toward direction of travel based on mouse impulses
    local angle = (phi + math.pi / 2) - player.body:getAngle()
    angle = (angle + math.pi) % (math.pi * 2) - math.pi
    player.body:applyTorque(angle * 3500)

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
