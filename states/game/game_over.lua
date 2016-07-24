local Over = Game:addState('Over')

function Over:enteredState()
  click_timer = cron.after(0.2, function()
    click_timer = nil
  end)
end

function Over:draw()
  g.setColor(255, 255, 255)
  g.draw(game.preloaded_images['menu_end.png'], 0, 0)
end

function Over:update(dt)
  if click_timer then
    click_timer:update(dt)
  end
end

function Over:mousereleased()
  if click_timer == nil then
    self:gotoState('Menu')
  end
end

function Over:keyreleased()
  if click_timer == nil then
    self:gotoState('Menu')
  end
end

function Over:exitedState()
end

return Over
