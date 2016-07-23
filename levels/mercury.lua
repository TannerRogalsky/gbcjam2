return function()
  return {
    gravity_wells = {
      GravityWell:new(0, 0, 40, 10 ^ 16),
      GravityWell:new(-400, 0, 40, 10 ^ 16),
      GravityWell:new(-400, -400, 40, 10 ^ 16),
      GravityWell:new(0, -400, 40, 10 ^ 16),
    },
    target = Planet:new(-800, 0, 20, 10 ^ 16, {255, 230, 230}),
    start = {
      direction = -math.pi / 2,
      planet = Planet:new(400, 300, 40, 10 ^ 14, {100, 100, 255})
    },
    asteroids = {
      Asteroid:new(-200, 0, 10, -25, -30)
    }
  }
end
