local Over = Game:addState('Over')

function Over:enteredState()
end

function Over:mousereleased()
  self:gotoState('Menu')
end

function Over:keyreleased()
  self:gotoState('Menu')
end

function Over:exitedState()
end

return Over
