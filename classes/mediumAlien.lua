require("middleclass")
require("middleclass-commons")
require("classes/alien")

local anim8 = require("libraries/anim8")
local MOVEMENT = MOVEMENT - 1

MediumAlien = class("MediumAlien", Alien)
MediumAlien.static.images = {}

for i = 1, 3 do
   MediumAlien.static.images[i] = love.graphics.newImage("images/bigalien" .. i .. ".png")
end
MediumAlien.static.imageSpeeds = {}
MediumAlien.static.imageSpeeds[5] = {9 / FRAME_RATE, 3 / FRAME_RATE}

MediumAlien.static.laserImages = {}
for i = 1, 3 do
   MediumAlien.static.laserImages[i] = love.graphics.newImage("images/alienlazr" .. i .. ".png")
end

MediumAlien.static.deathImage = love.graphics.newImage("images/bigaliensplosion.png")

MediumAlien.static.movements = {}
MediumAlien.static.movements[1] = function(self, dt)
   self.x = self.x - MOVEMENT
   self.y = self.y + math.sin(self.overallTime * 10)
end
MediumAlien.static.movements[2] = function(self, dt)
   local prevY = self.y
   self.x = self.x + math.sin(self.overallTime * 10) - MOVEMENT
   self.y = self.y + math.cos(self.overallTime * 10) + MOVEMENT * self.yDirection
   
   if self.y > windowHeight - self.height * self.scale or self.y < 0 then
      self.yDirection = -self.yDirection
      self.y = self.y + math.cos(self.overallTime * 10) + MOVEMENT * self.yDirection
   end
end
MediumAlien.static.movements[3] = function(self, dt)
   self.x = self.x - math.cos(self.overallTime / 10) - MOVEMENT
   self.y = self.y - math.cos(self.overallTime * 10)
end
MediumAlien.static.movements[4] = function(self, dt)
   self.x = self.x + math.sin(self.overallTime * 10) - MOVEMENT
   self.y = self.y + math.cos(self.overallTime * 10)
end

function MediumAlien:initialize()
   local x = windowWidth
   local y = randomGenerator:random(windowHeight - MediumAlien.images[1]:getHeight() * SCALE)
   local imageIndex = randomGenerator:random(1, table.getn(MediumAlien.images))
   
   Alien.initialize(self, "Easy", MediumAlien.images[imageIndex], x, y, 16, 16, MediumAlien.imageSpeeds[imageIndex])
   
   self.laserImage = MediumAlien.laserImages[randomGenerator:random(1,3)]
   self.bulletSpeed = MOVEMENT - 1
   
   self.maxBulletTime = randomGenerator:random(10,25) * .1
   self.bulletTime = randomGenerator:random(self.maxBulletTime / .1) * .1
   self.movementFunction = MediumAlien.movements[randomGenerator:random(1, table.getn(MediumAlien.movements))]
   
   self.overallTime = 0
   self.yDirection = 1
   self.xDirection = 1
   
   self.deathImage = MediumAlien.deathImage
   self.lives = 5
   
   self.width = 16
   self.height = 16
end

function MediumAlien:update(dt)
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