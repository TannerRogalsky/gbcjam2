return function()
  return {
    gravity_wells = {
    },
    target = Planet:new(0, 0, 30, 10 ^ 16, {150, 150, 150}),
    start = {
      direction = -math.pi,
      planet = Planet:new(1200, 0, 60, 10 ^ 14, {100, 100, 255})
    },
    asteroids = {}
  }
end
