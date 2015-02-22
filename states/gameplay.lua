require("middleclass")
require("middleclass-commons")

Gameplay = class("Gameplay")

function Gameplay:initialize()
   self.player = Player:new()
   self.bulletList = {}
   self.bulletCounter = 1
   self.bulletCounterBase = self.bulletCounter
   
   self.enemyList = {}
   self.enemyCounter = 1
   self.enemyCounterBase = self.enemyCounter
   self.enemyOverallTime = 1
   
   self.background = {}
   self.background[1] = Background:new(0,0)
   self.background[2] = Background:new(512,0) --513?
   self.background[3] = Background:new(1024,0)
end

function Gameplay:draw()
   -- draw the background
   for i,v in ipairs(self.background) do
      v:draw()
   end
   
   -- draw the enemies
   for i = self.enemyCounterBase, self.enemyCounter do
      if self.enemyList[i] then
         self.enemyList[i]:draw()
      end
   end
   
   -- draw the player
   self.player:draw()
   
   -- draw each bullet
   for i = self.bulletCounterBase, self.bulletCounter do
      if self.bulletList[i] then
         self.bulletList[i]:draw()
      end
   end
end

function Gameplay:update(dt)
   --update the background
   for i,v in ipairs(self.background) do
      v:update(dt)
   end
   
   -- update the bullets
   for i = self.bulletCounterBase, self.bulletCounter do
      if self.bulletList[i] then
         self.bulletList[i]:update(dt)
         
         -- remove the bullet if it's marked to be removed
         if self.bulletList[i].marked then
            self.bulletList[i] = nil
            
            if i == self.bulletCounterBase then
               self.bulletCounterBase = self.bulletCounterBase + 1
               while not self.bulletList[self.bulletCounterBase] and self.bulletCounterBase < self.bulletCounter do
                  self.bulletCounterBase = self.bulletCounterBase + 1
               end
            end
         end
      end
   end
   
   -- update the player
   self.player:update(dt)
   -- give the player a bullet if they requested it
   if self.player.wantBullet then
      self.bulletList[self.bulletCounter] = Bullet:new(self.player.x + self.player.image:getWidth(), self.player.y, self.player.worldX + self.player.image:getWidth(), self.player.worldY, "Player", 1, self.bulletCounter)
      self.bulletCounter = self.bulletCounter + 1
      self.player.wantBullet = false
   end
   
   -- update the enemies
   for i = self.enemyCounterBase, self.enemyCounter do
      if self.enemyList[i] then
         self.enemyList[i]:update(dt)
         
         if self.enemyList[i].marked then
            self.enemyList[i] = nil
            
            if i == self.enemyCounterBase then
               self.enemyCounterBase = self.enemyCounterBase + 1
               while not self.enemyList[self.enemyCounterBase] and self.enemyCounterBase < self.enemyCounter do
                  self.enemyCounterBase = self.enemyCounterBase + 1
               end
            end
         end
      end
   end
   
   -- determine whether to create a new enemy
   local enemyChance = 9
   local maxEnemies = 100--3
   local enemyTime = randomGenerator:random(7,15) * .1
   
   self.enemyOverallTime = self.enemyOverallTime + dt
   if randomGenerator:random(1,10) > enemyChance and self:getEnemyCount() < maxEnemies and self.enemyOverallTime > enemyTime then
      self.enemyList[self.enemyCounter] = EasyAlien:new()
      self.enemyCounter = self.enemyCounter + 1
      self.enemyOverallTime = 0
   end
end

function Gameplay:getEnemyCount()
   local ret = 0
   for i = self.enemyCounterBase, self.enemyCounter do
      if self.enemyList[i] then
         ret = ret + 1
      end
   end
   
   return ret
end

function Gameplay:keypressed(key, isrepeat)
end

function Gameplay:__tostring()
   return "State: Gameplay"
end