local Over = Game:addState('OverTransition')

local time = 1

function Over:enteredState(image)
  self.image = image
  click_timer = cron.after(time, function()
    self:gotoState('Over')
  end)
end

function Over:draw()
  if click_timer then
    local a = click_timer.running * 255
    g.setColor(255, 255, 255, 255 - a)
    g.draw(self.image, 0, 0)
  end
end

function Over:update(dt)
  if click_timer then
    click_timer:update(dt)
  end
end

function Over:exitedState()
end

return Over
