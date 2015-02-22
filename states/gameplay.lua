require("middleclass")
require("middleclass-commons")

Gameplay = class("Gameplay")

function Gameplay:initialize()
   self.collider = HC(100, self.onCollision, self.collisionStop)
   local tempPlayer = Player:new()
   self.player = self.collider:addRectangle(tempPlayer.x, tempPlayer.y, tempPlayer.width * tempPlayer.scale, tempPlayer.height * tempPlayer.scale)
   self.player.class = tempPlayer
   self.player.class.shape = self.player
   --self.collider:addToGroup("playerStuff", self.player)
   
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

function Gameplay.onCollision(dt, shapeA, shapeB, mtvX, mtvY)
   print(shapeA.class.class.name .. " hit " .. shapeB.class.class.name)
end

function Gameplay.collisionStop(dt, shapeA, shapeB)
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
   self.player.class:draw()
   
   if drawHitboxes then
      love.graphics.setColor(255,0,0, 155)
      self.player:draw("fill")
      love.graphics.setColor(255,255,255,255)
   end
   
   -- draw each bullet
   for i = self.bulletCounterBase, self.bulletCounter do
      if self.bulletList[i] then
         self.bulletList[i].class:draw()
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
         self.bulletList[i].class:update(dt)
         
         -- remove the bullet if it's marked to be removed
         if self.bulletList[i].class.marked then
            self.collider:remove(self.bulletList[i])
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
   self.player.class:update(dt)
   -- give the player a bullet if they requested it
   if self.player.class.wantBullet then
      local newBullet = Bullet:new(self.player.class.x + self.player.class.image:getWidth(), self.player.class.y, self.player.class.worldX + self.player.class.image:getWidth(), self.player.class.worldY, "Player", 1, self.bulletCounter)
      self.bulletList[self.bulletCounter] = self.collider:addRectangle(newBullet.x, newBullet.y, newBullet.image:getWidth(), newBullet.image:getHeight())
      self.bulletList[self.bulletCounter].class = newBullet
      self.bulletList[self.bulletCounter].class.shape = self.bulletList[self.bulletCounter]
      
      self.collider:addToGroup("bullets", self.bulletList[self.bulletCounter])
      self.collider:addToGroup("playerBullets", self.bulletList[self.bulletCounter])
      
      self.bulletCounter = self.bulletCounter + 1
      self.player.class.wantBullet = false
   end
   
   -- update the enemies
   for i = self.enemyCounterBase, self.enemyCounter do
      local enemy = self.enemyList[i]
      
      if enemy then
         enemy:update(dt)
         
         -- remove enemy if marked
         if enemy.marked then
            self.enemyList[i] = nil
            
            if i == self.enemyCounterBase then
               self.enemyCounterBase = self.enemyCounterBase + 1
               while not self.enemyList[self.enemyCounterBase] and self.enemyCounterBase < self.enemyCounter do
                  self.enemyCounterBase = self.enemyCounterBase + 1
               end
            end
         end
         
         -- shoot a bullet if requested
         if enemy.wantBullet then
            local newBullet = Bullet:new(enemy.x - enemy.laserImage:getWidth(), enemy.y + (enemy.width / 2 * enemy.scale) - (enemy.laserImage:getHeight() / 2), 0, 0, enemy.name, -1, self.bulletCounter, enemy.laserImage, enemy.bulletSpeed)
            enemy.wantBullet = false
            self.bulletList[self.bulletCounter] = self.collider:addRectangle(newBullet.x, newBullet.y, newBullet.image:getWidth(), newBullet.image:getHeight())
            self.bulletList[self.bulletCounter].class = newBullet
            self.bulletList[self.bulletCounter].class.shape = self.bulletList[self.bulletCounter]
            
            self.collider:addToGroup("bullets", self.bulletList[self.bulletCounter])
            
            self.bulletCounter = self.bulletCounter + 1
         end
      end
   end
   
   -- determine whether to create a new enemy
   local enemyChance = 9
   local maxEnemies = 100--3
   local enemyTime = randomGenerator:random(7,15) * .1
   
   self.enemyOverallTime = self.enemyOverallTime + dt
   if randomGenerator:random(1,10) > enemyChance and self:getItemCount(self.enemyList, self.enemyCounterBase, self.enemyCounter) < maxEnemies and self.enemyOverallTime > enemyTime then
      self.enemyList[self.enemyCounter] = EasyAlien:new()
      self.enemyCounter = self.enemyCounter + 1
      self.enemyOverallTime = 0
   end
   
   self.collider:update(dt)
end

function Gameplay:getItemCount(theTable, base, max)
   local ret = 0
   for i = base, max do
      if theTable[i] then
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