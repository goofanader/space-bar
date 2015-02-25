require("middleclass")
require("middleclass-commons")
require("classes/alien")

local anim8 = require("libraries/anim8")
local MOVEMENT = MOVEMENT - 1
local WINDOW_TIME = .05

BossAlien = class("BossAlien", Alien)
BossAlien.static.image = love.graphics.newImage("media/images/bigboss.png")

BossAlien.static.laserImages = {}
for i = 1, 3 do
   BossAlien.static.laserImages[i] = love.graphics.newImage("media/images/alienlazr" .. i .. ".png")
end

BossAlien.static.deathImage = love.graphics.newImage("media/images/bigbosssplosion.png")

BossAlien.static.movements = {}
--[[BossAlien.static.movements[1] = function(self, dt)
   self.x = self.x - MOVEMENT
   self.y = self.y + math.sin(self.overallTime * 10)
end
BossAlien.static.movements[2] = function(self, dt)
   local prevY = self.y
   self.x = self.x + math.sin(self.overallTime * 10) - MOVEMENT
   self.y = self.y + math.cos(self.overallTime * 10) + MOVEMENT * self.yDirection
   
   if self.y > windowHeight - self.height * self.scale or self.y < 0 then
      self.yDirection = -self.yDirection
      self.y = self.y + math.cos(self.overallTime * 10) + MOVEMENT * self.yDirection
   end
end
BossAlien.static.movements[3] = function(self, dt)
   self.x = self.x - math.cos(self.overallTime / 10) - MOVEMENT
   self.y = self.y - math.cos(self.overallTime * 10)
end
BossAlien.static.movements[4] = function(self, dt)
   self.x = self.x + math.sin(self.overallTime * 10) - MOVEMENT
   self.y = self.y + math.cos(self.overallTime * 10)
end]]

BossAlien.static.openingSound = love.sound.newSoundData("media/sound/Boss_Sound.wav")

function BossAlien:initialize()
   local x = windowWidth
   local y = (windowHeight / 2) - (BossAlien.image:getHeight() / 2)
   --local imageIndex = randomGenerator:random(1, table.getn(BossAlien.images))
   
   Alien.initialize(self, "Boss", BossAlien.image, x, y, 64, 64)
   
   self.scale = 1.75
   self.laserImage = BossAlien.laserImages[randomGenerator:random(1,3)]
   self.bulletSpeed = MOVEMENT + 2
   
   self.maxBulletTime = randomGenerator:random(5,10) * .1
   self.bulletTime = randomGenerator:random(self.maxBulletTime / .1) * .1
   --self.movementFunction = BossAlien.movements[randomGenerator:random(1, table.getn(BossAlien.movements))]
   
   self.overallTime = 0
   self.windowTime = 0
   self.maxWindowTime = 0
   self.yDirection = 1
   self.xDirection = 1
   
   self.deathImage = BossAlien.deathImage
   self.lives = 15
   
   self.width = 64
   self.height = 64
   
   self.initWidth = windowWidth
   self.initHeight = windowHeight
   self.endWidth = windowWidth-- + 128
   self.endHeight = windowHeight + math.pow(2, 6)
   
   self.mode = "entrance"
   self.y = (windowHeight / 2) - (self.height / 2 * self.scale)
   
   playSound(BossAlien.openingSound, .1)
   --playSound(BossAlien.openingSound, .3)
end

function BossAlien:update(dt)
   Alien.update(self, dt)
   self.overallTime = self.overallTime + dt
   self.maxWindowTime = self.maxWindowTime + dt
   self.bulletTime = self.bulletTime + dt
   
   if not self.isDead then
      local prevX, prevY = self.x, self.y
      
      if self.mode == "entrance" then
         self.x = self.x - MOVEMENT
         
         if self.maxWindowTime > WINDOW_TIME then
            --love.window.setMode(self.initWidth + self.windowTime, self.initHeight + self.windowTime, {borderless=false})
            self.windowTime = self.windowTime + 1
            self.maxWindowTime = 0
         end
         if self.x < windowWidth - self.width * self.scale - 10 then
            self.mode = "shooting"
         end
      elseif self.mode == "shooting" then
         self.y = self.y + math.sin(self.overallTime * 5)
      
         if self.bulletTime > self.maxBulletTime then
            self.bulletTime = 0
            self.wantBullet = true
         end
      end
      
      --[[self.overallTime = self.overallTime + dt
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
      end]]
      
      self.shape:move(self.x - prevX, self.y - prevY)
   else
      --self.x = self.x - MOVEMENT
   end
end