require("middleclass")
require("middleclass-commons")

Background = class("Background")
Background.static.image = love.graphics.newImage("images/space.png")

function Background:initialize(x, y)
   self.image = Background.static.image
   self.x = x
   self.y = y
   
   self.movement = MOVEMENT
   self.scale = 1 --SCALE
end

function Background:update(dt)
   self.x = self.x - self.movement
   if self.x <= -self.image:getWidth() + 4 then
      self.x = windowWidth
   end
end

function Background:draw()
   love.graphics.draw(self.image, self.x, self.y, 0, self.scale)
end
