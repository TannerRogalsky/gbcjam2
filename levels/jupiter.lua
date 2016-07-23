return function()
  return {
    gravity_wells = {
      GravityWell:new(0, 0, 10 ^ 16),
      GravityWell:new(-400, 0, 10 ^ 16),
      GravityWell:new(-400, -400, 10 ^ 16),
      GravityWell:new(0, -400, 10 ^ 16),
    },
    target = Planet:new(-800, 0, 10 ^ 16, {255, 100, 100}),
    start = {
      direction = -math.pi / 2,
      planet = Planet:new(400, 300, 10 ^ 14, {100, 100, 255})
    }
  }
end
