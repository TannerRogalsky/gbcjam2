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

  juno_speech_data = {
    {
      text = "What beautiful red vistas! I hope everyone back on Earth enjoys these images!",
      image = game.preloaded_images['juno_emotion_happy.png']
    },
    {
      text = "Enormous Jupiter! I hope they aren't having storms like this on Earth!",
      image = game.preloaded_images['juno_emotion_normal.png']
    },
    {
      text = "Rings! I sure do miss Earth, though!",
      image = game.preloaded_images['juno_emotion_anxious.png']
    },
    {
      text = "It's cold out here. I'm so lonely.",
      image = game.preloaded_images['juno_emotion_crying.png']
    },
    {
      text = "...",
      image = game.preloaded_images['juno_emotion_dead.png']
    }
  }

  juno_pos = {x = g.getWidth() - 64 * 2, y = g.getHeight()}

  overlay_alpha = 0
end

function Main:update(dt)
  player:update(dt)
  asteroid_spawn:update(dt)

  local vx, vy = player:getLinearVelocity()
  local s = 0.5 + (math.abs(vx) + math.abs(vy)) / 2 / player.maxVelocity * 6
  local current_scale = self.camera.scaleX
  local delta = math.clamp(-dt / 6, s - current_scale, dt / 6)
  self.camera:setScale(current_scale + delta, current_scale + delta)

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
    -- g.setShader(self.vingette_shader)
    overlay_alpha = (500 - distToEdge) / 500 * 255
  end

  local tx, ty = level.targets[target_index]:getPosition()
  local tr = level.targets[target_index]:getRadius()
  local dx, dy = px - tx, py - ty
  local tDist2 = dx * dx + dy * dy
  tDist2 = tDist2 - (tr ^ 2)

  if self.scanState == 1 then
    local dataGatheredThisStep = (self.dataPerSecondScanning / (tDist2 / 4000)) * dt
    self.planetDataGathered[target_index] = self.planetDataGathered[target_index] + dataGatheredThisStep
  end

  if self.scanState == 2 and love.timer.getTime() - 2.5 > self.scanTime then
    self.scanState = 0
    self.totalDataGathered = self.totalDataGathered + self.planetDataGathered[target_index]
    target_index = target_index + 1
  elseif self.scanState == 1 and tx - px < -tr then
    self.scanState = 2
    self.planetDataGathered[target_index] = math.min(self.planetDataGathered[target_index], tr * self.dataPerRadius)
    self.scanTime = love.timer.getTime()
    current_juno_speech_data = juno_speech_data[target_index]
    flavour_tween_in = tween.new(0.5, juno_pos, {y = g.getHeight() - 64 * 2}, 'linear')
  elseif self.scanState == 0 and tx - px < tr * 2 then
    self.scanState = 1
    self.planetDataGathered[target_index] = 0
    self.scanTime = love.timer.getTime()
  end

  if flavour_tween_in and flavour_tween_in:update(dt) then
    flavour_tween_in = nil
    speech_bubble_animation = anim8.newAnimation({
      sprites.quads.speech_1,
      sprites.quads.speech_2,
      sprites.quads.speech_3,
      sprites.quads.speech_4,
      sprites.quads.speech_5,
    }, 0.1, function()
      speech_bubble_animation:pauseAtEnd()
      speech_bubble_wait = cron.after(6, function()
        speech_bubble_animation = nil
        flavour_tween_out = tween.new(0.5, juno_pos, {y = g.getHeight()}, 'linear')
      end)
    end)
  end

  if speech_bubble_animation then
    speech_bubble_animation:update(dt)
  end

  if speech_bubble_wait and speech_bubble_wait:update(dt) then
    speech_bubble_wait = nil
  end

  if flavour_tween_out and flavour_tween_out:update(dt) then
    flavour_tween_out = nil
  end

  world:update(dt)
end

function Main:draw()
  drawGame(self)

  if current_juno_speech_data then
    local scale = 2
    g.draw(current_juno_speech_data.image, juno_pos.x, juno_pos.y, 0, scale, scale)

    if speech_bubble_animation then
      speech_bubble_animation:draw(sprites.texture, g.getWidth() / 2 - 64 * 1.5, g.getHeight() - 100)

      if speech_bubble_animation.status == "paused" then
        g.setColor(0, 0, 0)
        g.printf(current_juno_speech_data.text, g.getWidth() / 2 - 90, g.getHeight() - 100, 425)
      end
    end
  end

  g.setColor(255, 255, 255, overlay_alpha)
  g.draw(overlay)
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
