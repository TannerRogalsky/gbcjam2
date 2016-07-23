return function()
  return {
    gravity_wells = {
    },
    targets = {
      Planet:new(1000, 0, 50, 10 ^ 14, {255, 100, 100}, 'MARS'), -- MARS
      Planet:new(3000, 0, 188, 10 ^ 14, {100, 100, 100}, 'JUPITER'), -- JUPITER
      Planet:new(5000, 0, 148, 10 ^ 14, {200, 200, 255}, 'SATURN'), -- SATURN
      Planet:new(7000, 0, 86, 10 ^ 14, {100, 100, 255}, 'URANUS'), -- URANUS
      Planet:new(9000, 0, 88, 10 ^ 14, {100, 200, 255}, 'NEPTUNE'), -- NEPTUNE
    },
    start = {
      direction = 0,
      planet = Planet:new(0, 0, 54, 10 ^ 14, {100, 100, 255}, 'EARTH')
    },
    asteroids = {}
  }
end
