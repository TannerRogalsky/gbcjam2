local Menu = Game:addState('Menu')

function Menu:enteredState()
end

function Menu:draw()
  g.setColor(255, 255, 255)
  g.draw(game.preloaded_images['menu_start.png'], 0, 0)
end

function Menu:keypressed(key, scancode, isrepeat)
end

function Menu:keyreleased(key, scancode)
  if key == 'return' then
    self:gotoState('MainStart')
  elseif key == "escape" then
    love.event.push("quit")
  end
end

function Menu:mousereleased()
  self:gotoState('MainStart')
end

function Menu:exitedState()
end

return Menu
