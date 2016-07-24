local hsl2rgb = require('lib.hsl')
local dots = {' [█    ]', ' [██   ]', ' [███  ]', ' [████ ]', ' [█████]'}

local function drawGame(game)
  game.camera:set()

  g.draw(game.preloaded_images['background_space.png'], bg_quad, -10000, -10000)

  for i,gravity_well in pairs(GravityWell.instances) do
    gravity_well:draw()
  end

  g.setColor(255, 255, 255)
  g.draw(asteroids_batch)

  player:draw()

  game.camera:unset()

  do
    local w, h = 20, 50
    g.setColor(255, 255, 255)
    g.rectangle('fill', 5, 5, w, h)
    local fuel_ratio = player.fuel / player.max_fuel
    g.setColor(hsl2rgb(fuel_ratio / 2, 0.5, 0.75))
    local gauge_height = fuel_ratio * (h - 2)
    g.rectangle('fill', 6, 6 + h - 2, w - 2, (-h + 2) * fuel_ratio)

    g.setColor(255, 255, 255)
    g.print('ENERGY', 5, 5 + h + 5)
  end

  do
    g.setColor(255, 255, 255)
    local dotTime = (love.timer.getTime() - game.scanTime) * 2
    if game.scanState == 0 then
      g.print('NEXT TARGET: ' .. level.targets[target_index].name, 5, g.getHeight() - 16)
    elseif game.scanState == 1 then
      g.print('SCANNING : ' .. level.targets[target_index].name .. dots[math.floor((dotTime % #dots) + 1)], 5, g.getHeight() - 16)
    elseif game.scanState == 2 then
      g.print('TRANSMITTING ' .. dots[math.floor((dotTime % #dots) + 1)], 5, g.getHeight() - 16)
    end
  end
end
return drawGame
