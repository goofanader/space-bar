require("middleclass")
require("middleclass-commons")
local anim8 = require("libraries/anim8")

Alien = class("Alien")
--Alien.static.deathImage = love.graphics.newImage("images/bigaliensplosion.png")

function Alien:initialize(name, image, x, y, width, height, animationSpeed)
   self.name = name
   self.image = image
   
   self.x = x
   self.y = y
   
   self.width = width
   self.height = height
   
   self.scale = SCALE
   self.marked = false
   
   self.animGrid = anim8.newGrid(width, height, image:getWidth(), image:getHeight())
   animationSpeed = not animationSpeed and 6 / FRAME_RATE or animationSpeed
   self.mainAnimation = anim8.newAnimation(self.animGrid('1-2', 1), animationSpeed)
   
   self.deathAnimation = anim8.newAnimation(self.animGrid('1-2',1), 1 / FRAME_RATE, function(instance)
         if instance.classObject.deathLoops >= 2 then
            instance.classObject.marked = true
            instance:pause()
         else
            instance:gotoFrame(1)
            instance.classObject.deathLoops = instance.classObject.deathLoops + 1
         end
      end
   )
   self.deathAnimation.classObject = self
   self.deathLoops = 0
   self.isDead = false
   
   self.animation = self.mainAnimation
   self.lives = 1
end

function Alien:draw()
   self.animation:draw(self.image, self.x, self.y, 0, self.scale)
end

function Alien:update(dt)
   self.animation:update(dt)
end

function Alien:killMe()
   self.lives = self.lives - 1
   
   if self.lives <= 0 then
      self.animation = self.deathAnimation
      self.image = self.deathImage
      self.isDead = true
   end
   
   return true
end

function Alien:__tostring()
   return "Alien: " .. self.name
end