require("middleclass")
require("middleclass-commons")
require("classes/alien")

local anim8 = require("libraries/anim8")

EasyAlien = class("EasyAlien", Alien)
EasyAlien.static.images = {}

for i = 1, 6 do
   EasyAlien.static.images[i] = love.graphics.newImage("images/alien" .. i .. ".png")
end
EasyAlien.static.imageSpeeds = {}
EasyAlien.static.imageSpeeds[5] = {9 / FRAME_RATE, 3 / FRAME_RATE}

EasyAlien.static.laserImages = {}
for i = 1, 3 do
   EasyAlien.static.laserImages[i] = love.graphics.newImage("images/alienlazr" .. i .. ".png")
end

EasyAlien.static.movements = {}
EasyAlien.static.movements[1] = function(self, dt)
   self.x = self.x - MOVEMENT
   self.y = self.y + math.sin(self.overallTime * 10)
end
EasyAlien.static.movements[2] = function(self, dt)
   --[[local maxTime = 1
   local superMovement = 40
   
   if self.overallTime > maxTime then
      if self.y + superMovement * self.yDirection > windowHeight - self.height then
         self.yDirection = -self.yDirection
      elseif self.y + superMovement * self.yDirection < 0 then
         self.yDirection = -self.yDirection
      end
      
      self.y = self.y + superMovement * self.yDirection
      self.overallTime = 0
   end]]
   
   self.x = self.x + math.sin(self.overallTime * 10) - MOVEMENT
   self.y = self.y + math.cos(self.overallTime * 10)
end
EasyAlien.static.movements[3] = function(self, dt)
   self.x = self.x - math.cos(self.overallTime / 10) - MOVEMENT
   self.y = self.y - math.cos(self.overallTime * 10)
end

function EasyAlien:initialize()
   local x = windowWidth
   local y = randomGenerator:random(windowHeight - EasyAlien.images[1]:getHeight() * SCALE)
   local imageIndex = randomGenerator:random(1, table.getn(EasyAlien.images))
   
   Alien.initialize(self, "Easy", EasyAlien.images[imageIndex], x, y, 8, 8, EasyAlien.imageSpeeds[imageIndex])
   
   self.laserImage = EasyAlien.laserImages[randomGenerator:random(1,3)]
   
   self.maxBulletTime = randomGenerator:random(2,10) * .1
   self.bulletTime = randomGenerator:random(self.maxBulletTime / .1) * .1
   self.movementFunction = EasyAlien.movements[randomGenerator:random(1, table.getn(EasyAlien.movements))]
   
   self.overallTime = 0
   self.yDirection = 1
   self.xDirection = 1
end

function EasyAlien:update(dt)
   Alien.update(self, dt)
   self.overallTime = self.overallTime + dt
   self.movementFunction(self, dt)
   
   if self.x < -self.width * self.scale then
      self.marked = true
   end
   
   if self.y < -self.height * self.scale or self.y > windowHeight then
      self.marked = true
   end
end