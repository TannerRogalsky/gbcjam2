return function()
  return {
    gravity_wells = {
    },
    targets = {
      Planet:new(1000, 0, 40, 10 ^ 14, {255, 100, 100}, 'MARS'), -- MARS
      Planet:new(3000, 0, 150, 10 ^ 14, {100, 100, 100}, 'JUPITER'), -- JUPITER
      Planet:new(5000, 0, 120, 10 ^ 14, {200, 200, 255}, 'SATURN'), -- SATURN
      Planet:new(7000, 0, 100, 10 ^ 14, {100, 100, 255}, 'URANUS'), -- URANUS
      Planet:new(9000, 0, 100, 10 ^ 14, {100, 200, 255}, 'NEPTUNE'), -- NEPTUNE
    },
    start = {
      direction = 0,
      planet = Planet:new(0, 0, 60, 10 ^ 14, {100, 100, 255})
    },
    asteroids = {}
  }
end
