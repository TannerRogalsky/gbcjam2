local hsl2rgb = require('lib.hsl')

local function drawGame(game)
  game.camera:set()

  for i,gravity_well in pairs(GravityWell.instances) do
    gravity_well:draw()
  end

  for i,asteroid in ipairs(game.asteroids) do
    asteroid:draw()
  end

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
end
return drawGame
