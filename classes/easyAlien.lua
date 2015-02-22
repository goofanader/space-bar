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
   local prevY = self.y
   self.x = self.x + math.sin(self.overallTime * 10) - MOVEMENT
   self.y = self.y + math.cos(self.overallTime * 10) + MOVEMENT * self.yDirection
   
   if self.y > windowHeight - self.height * self.scale or self.y < 0 then
      self.yDirection = -self.yDirection
      self.y = self.y + math.cos(self.overallTime * 10) + MOVEMENT * self.yDirection
   end
end
EasyAlien.static.movements[3] = function(self, dt)
   self.x = self.x - math.cos(self.overallTime / 10) - MOVEMENT
   self.y = self.y - math.cos(self.overallTime * 10)
end
EasyAlien.static.movements[4] = function(self, dt)
   self.x = self.x + math.sin(self.overallTime * 10) - MOVEMENT
   self.y = self.y + math.cos(self.overallTime * 10)
end

function EasyAlien:initialize()
   local x = windowWidth
   local y = randomGenerator:random(windowHeight - EasyAlien.images[1]:getHeight() * SCALE)
   local imageIndex = randomGenerator:random(1, table.getn(EasyAlien.images))
   
   Alien.initialize(self, "Easy", EasyAlien.images[imageIndex], x, y, 8, 8, EasyAlien.imageSpeeds[imageIndex])
   
   self.laserImage = EasyAlien.laserImages[randomGenerator:random(1,3)]
   self.bulletSpeed = MOVEMENT - 1
   
   self.maxBulletTime = randomGenerator:random(10,25) * .1
   self.bulletTime = randomGenerator:random(self.maxBulletTime / .1) * .1
   self.movementFunction = EasyAlien.movements[randomGenerator:random(1, table.getn(EasyAlien.movements))]
   
   self.overallTime = 0
   self.yDirection = 1
   self.xDirection = 1
end

function EasyAlien:update(dt)
   Alien.update(self, dt)
   
   if not self.isDead then
      local prevX, prevY = self.x, self.y
      
      self.overallTime = self.overallTime + dt
      self.movementFunction(self, dt)
      self.bulletTime = self.bulletTime + dt
      
      if self.x < -self.width * self.scale then
         self.marked = true
      end
      
      if self.y < -self.height * self.scale or self.y > windowHeight then
         self.marked = true
      end
      
      if self.bulletTime > self.maxBulletTime then
         self.bulletTime = 0
         self.wantBullet = true
      end
      
      self.shape:move(self.x - prevX, self.y - prevY)
   else
      self.x = self.x - MOVEMENT
   end
end