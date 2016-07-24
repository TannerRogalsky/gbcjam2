local Win = Game:addState('Win')

function Win:enteredState()
  click_timer = cron.after(0.2, function()
    click_timer = nil
  end)
end

function Win:draw()
  g.setColor(255, 255, 255)
  g.draw(game.preloaded_images['menu_end_good.png'], 0, 0)
end

function Win:update(dt)
  if click_timer then
    click_timer:update(dt)
  end
end

function Win:mousereleased()
  if click_timer == nil then
    self:gotoState('Menu')
  end
end

function Win:keyreleased()
  if click_timer == nil then
    self:gotoState('Menu')
  end
end

function Win:exitedState()
end

return Win
