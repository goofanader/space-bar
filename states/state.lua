require("middleclass")
require("middleclass-commons")

State = class("State")

function State:initialize(name)
   self.name = name
end

function State:draw()
end

function State:update(dt)
end

function State:keypressed(key, isrepeat)
end

function State:keyreleased(key)
end

function State:textinput(text)
end

function State:__tostring()
   return State.class.name .. ": " .. self.name
end