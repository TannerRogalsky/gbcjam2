local MainStart = Game:addState('MainStart')
local drawGame = require('shared.draw_game')

local function getLevelBounds(world)
  local x1, y1, x2, y2 = math.huge, math.huge, -math.huge, -math.huge
  local bodies = world:getBodyList()
  for _,body in ipairs(bodies) do
    for _,fixture in ipairs(body:getFixtureList()) do
      local fx1, fy1, fx2, fy2 = fixture:getBoundingBox()
      if x1 > fx1 then x1 = fx1 end
      if y1 > fy1 then y1 = fy1 end
      if x2 < fx2 then x2 = fx2 end
      if y2 < fy2 then y2 = fy2 end
    end
  end
  return x1, y1, x2, y2
end

function MainStart:enteredState()
  local Camera = require("lib/camera")
  self.camera = Camera:new()

  local bg = game.preloaded_images['background_space.png']
  bg:setWrap('mirroredrepeat', 'mirroredrepeat')
  bg_quad = g.newQuad(0, 0, 100000, 100000, bg:getWidth(), bg:getHeight())

  local p = love.physics
  world = p.newWorld(0, 0, true)
  world:setCallbacks(unpack(require('physics_callbacks')))

  -- level = require('levels.' .. self.sorted_names[self.level_index])()
  level = require('levels.test')()
  target_index = 1

  self.asteroids = level.asteroids

  sprites = require('images.sprites')
  asteroids_batch = g.newSpriteBatch(sprites.texture, 100000, 'stream')
  asteroid_quads = {
    sprites.quads.asteroid_1,
    sprites.quads.asteroid_2,
    sprites.quads.asteroid_3,
  }

  local radius = 20
  local start_thrust = 50
  local start = level.start
  local tx, ty = start.planet:getPosition()
  tx = tx + (start.planet:getRadius() + radius) * math.cos(start.direction)
  ty = ty + (start.planet:getRadius() + radius) * math.sin(start.direction)

  player = Player:new(tx, ty, radius)
  player.body:applyLinearImpulse(math.cos(start.direction) * start_thrust, math.sin(start.direction) * start_thrust)
  player.body:setAngle(start.direction + math.pi / 2)

  g.setFont(self.preloaded_fonts["04b03_16"])
  self.camera:scale(0.5, 0.5)
  local cx = tx - g.getWidth() / (2 / self.camera.scaleX)
  local cy = ty - g.getHeight() / (2 / self.camera.scaleY)
  self.camera:setPosition(cx, cy)

  self.universeEdge = 1000
  self.scanState = 0
  self.scanTime = 0
  self.dataPerRadius = 1
  self.dataPerSecondScanning = 23

  -- self.vignetteShader = g.newShader('shaders/vignette_shader.glsl')
end

function MainStart:update(dt)
  for i,asteroid in ipairs(level.asteroids) do
    asteroid:update(dt)
  end
end

function MainStart:draw()
  drawGame(self)
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
