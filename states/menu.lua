require("middleclass")
require("middleclass-commons")

Menu = class("Menu")

function Menu:initialize()
end

function Menu:draw()
end

function Menu:update(dt)
end

function Menu:keypressed(key, isrepeat)
end

function Menu:__tostring()
   return "State: Menu"
end