local Main = Game:addState('Main')
local getForce = require('shared.get_force')
local drawGame = require('shared.draw_game')

local pow = math.pow
local function inOutExpo(t, b, c, d)
  if t == 0 then return b end
  if t == d then return b + c end
  t = t / d * 2
  if t < 1 then return c / 2 * pow(2, 10 * (t - 1)) + b - c * 0.0005 end
  return c / 2 * 1.0005 * (-pow(2, -10 * (t - 1)) + 2) + b
end

function Main:enteredState()
  local function spawnAsteroid()
    local ax, ay = self.camera:mousePosition(-50, love.math.random(g.getHeight()))
    local asteroid = Asteroid:new(ax, ay, love.math.random(10, 30))
    asteroid.body:applyLinearImpulse(50, 0)
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

  local px, py = player:getPosition()
  local cx = px - g.getWidth() / (2 / self.camera.scaleX)
  local cy = py - g.getHeight() / (2 / self.camera.scaleY)
  self.camera:setPosition(cx, cy)
  -- self.camera:setRotation(inOutExpo(tx, 0, math.pi / 2, 9000))

  local distToEdge = self.universeEdge - math.abs(py)
  if distToEdge < 0 then
    return self:gotoState("Over")
  elseif distToEdge < 500 then
    print("You'll die soon " .. distToEdge)
    -- g.setShader(self.vingette_shader)
  end

  local tx, ty = level.targets[target_index]:getPosition()
  local tr = level.targets[target_index]:getRadius()

  if self.scanState == 2 and love.timer.getTime() - 2.5 > self.scanTime then
    self.scanState = 0
    target_index = target_index + 1
  elseif self.scanState == 1 and tx - px < -tr then
    self.scanState = 2
    self.scanTime = love.timer.getTime()
  elseif self.scanState == 0 and tx - px < tr * 2 then
    self.scanState = 1
    self.scanTime = love.timer.getTime()
  end


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
