require("middleclass")
require("middleclass-commons")

Bullet = class("Bullet")
Bullet.static.image = love.graphics.newImage("images/lazr.png")

function Bullet:initialize(x, y, worldX, worldY, owner, direction, index, image, movementSpeed, movementAcceleration)
   self.x = x
   self.y = y
   self.worldX = worldX
   self.worldY = worldY
   
   self.owner = owner
   self.direction = direction
   
   self.index = index
   self.image = not image and Bullet.static.image or image
   self.movement = MOVEMENT + (not movementSpeed and 5 or movementSpeed)
   self.acceleration = not movementAcceleration and 0 or movementAcceleration
   
   self.marked = false -- marked for removement
end

function Bullet:update(dt)
   local prevX, prevY = self.x, self.y
   
   self.x = self.x + (self.movement * self.direction)
   self.worldX = self.worldX + self.movement * self.direction
   
   if self.x < -self.image:getWidth() or self.x > windowWidth then
      --removeFromBulletList(self.index)
      self.marked = true
   end
   
   self.shape:moveTo(self.x - prevX, self.y - prevY)
end

function Bullet:draw()
   if not self.marked then
      love.graphics.draw(self.image, self.x, self.y, 0, SCALE)
   end
end

function Bullet:__tostring()
   return "Bullet's owner: " .. self.owner
end