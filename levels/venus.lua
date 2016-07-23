return function()
  return {
    gravity_wells = {
      GravityWell:new(0, 0, 100, 10 ^ 20),
      GravityWell:new(800, 0, 60, 10 ^ 16),
    },
    target = Planet:new(400, 0, 30, 10 ^ 16, {255, 100, 100}),
    start = {
      direction = -math.pi,
      planet = Planet:new(1200, 300, 60, 10 ^ 14, {100, 100, 255})
    },
    asteroids = {}
  }
end
