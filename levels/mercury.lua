return function()
  return {
    gravity_wells = {
      GravityWell:new(-1000, 0, 1000, 10 ^ 19),
      GravityWell:new(2000, 0, 60, 10 ^ 16),
    },
    target = Planet:new(400, 0, 30, 10 ^ 16, {255, 100, 100}),
    start = {
      direction = math.pi / 2,
      planet = Planet:new(3000, 0, 60, 10 ^ 14, {100, 100, 255})
    },
    asteroids = {}
  }
end
