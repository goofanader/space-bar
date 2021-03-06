require("middleclass")
require("middleclass-commons")

Gameplay = class("Gameplay", State)
Gameplay.static.score = 0
Gameplay.static.bombs = 0
Gameplay.static.bombPoints = 0
Gameplay.static.gainedBomb = false
Gameplay.static.beginGameSound = love.sound.newSoundData("media/sound/Name_Entered.wav")

function Gameplay:initialize(hiscore)
   State.initialize(self, "Gameplay")

   self.collider = HC(100, self.onCollision, self.collisionStop)
   local tempPlayer = Player:new()
   self.player = self.collider:addRectangle(tempPlayer.x, tempPlayer.y, tempPlayer.width * tempPlayer.scale, tempPlayer.height * tempPlayer.scale)
   self.player.class = tempPlayer
   self.player.class.shape = self.player
   self.collider:addToGroup("playerStuff", self.player)

   self.bulletList = {}
   self.bulletCounter = 1
   self.bulletCounterBase = self.bulletCounter

   self.enemyList = {}
   self.enemyCounter = 1
   self.enemyCounterBase = self.enemyCounter
   self.enemyOverallTime = 1
   self.isBossFight = false

   self.background = {}
   self.background[1] = Background:new(0,0)
   self.background[2] = Background:new(512,0) --513?
   self.background[3] = Background:new(1024,0)

   self.hiscore = hiscore
   Gameplay.static.score = 0
   Gameplay.static.bombs = mod(getSharecartData("Misc3"), MAX_BOMBS + 1)
   self.bombCounter = 0
   self.bombAlpha = 255 / 2
   self.bombTime = 0

   self.bossObject = nil
   self.scale = 1

   self.beginTime = love.timer.getTime()

   playSound(Gameplay.beginGameSound, .3)
end

function Gameplay.onCollision(dt, shapeA, shapeB, mtvX, mtvY)
   if shapeA.class.class.super.name == "Alien" and shapeB.class.class.name == "Bullet" and not shapeA.class.isDead then
      shapeA.class:killMe()
      shapeB.class.marked = true
      Gameplay.static.score = Gameplay.static.score + 1
      Gameplay.static.bombPoints = Gameplay.bombPoints + 1

      if Gameplay.bombPoints >= GET_BOMB_POINTS and Gameplay.bombs < MAX_BOMBS then
         Gameplay.static.bombs = Gameplay.static.bombs + 1
         Gameplay.static.gainedBomb = true
         Gameplay.static.bombPoints = 0
      end
   end

   if shapeB.class.class.super.name == "Alien" and shapeA.class.class.name == "Bullet" and not shapeB.class.isDead then
      shapeB.class:killMe()
      shapeA.class.marked = true
      Gameplay.static.score = Gameplay.static.score + 1
      Gameplay.static.bombPoints = Gameplay.bombPoints + 1

      if Gameplay.bombPoints >= GET_BOMB_POINTS and Gameplay.bombs < MAX_BOMBS then
         Gameplay.static.bombs = Gameplay.static.bombs + 1
         Gameplay.static.gainedBomb = true
         Gameplay.static.bombPoints = 0
      end
   end

   if shapeA.class.class.name == "Player" and not shapeA.class.isDead and (shapeB.class.class.name == "Bullet" or (shapeB.class.class.super.name == "Alien" and not shapeB.class.isDead)) then
      shapeA.class:killMe()
   end

   if shapeB.class.class.name == "Player" and not shapeB.class.isDead and (shapeA.class.class.name == "Bullet" or (shapeA.class.class.super.name == "Alien" and not shapeA.class.isDead)) then
      shapeB.class:killMe()
   end
end

function Gameplay.collisionStop(dt, shapeA, shapeB)
end

function Gameplay:draw()
   -- draw the background
   for i,v in ipairs(self.background) do
      v:draw()
   end

   love.graphics.push()
   -- draw the HUD
   love.graphics.setColor(1, 1, 1, 1)
   love.graphics.setFont(TEN_FONT)
   love.graphics.printf("Exit: ESC", windowWidth - 100, 5, 95, "right")
   love.graphics.printf("Score: " .. Gameplay.static.score, windowWidth / 4, 5, windowWidth / 2, "center")
   love.graphics.printf("Hi-score: " .. self.hiscore, windowWidth / 4, windowHeight - 20, windowWidth / 2, "center")

   --draw player lives
   love.graphics.printf("Lives: x" .. self.player.class.lives, 5, 5, windowWidth / 8, "left")

   --draw bombs
   love.graphics.printf("Bombs: x" .. Gameplay.bombs, 5, TEN_FONT:getHeight() + 5, windowWidth / 8, "left")
   love.graphics.pop()

   love.graphics.push()
   love.graphics.scale(self.scale)
   -- draw the enemies
   for i = self.enemyCounterBase, self.enemyCounter do
      if self.enemyList[i] then
         self.enemyList[i].class:draw()

         if drawHitboxes then
            love.graphics.setColor(0,1,1, 1)
            self.enemyList[i]:draw("fill")
            love.graphics.setColor(1,1,1,1)
         end
      end
   end

   -- draw the player
   self.player.class:draw()

   if Gameplay.static.gainedBomb then
      --draw the text
      local r,g,b,a = love.graphics.getColor()
      love.graphics.setColor(0, 1, 0, self.bombAlpha/255)
      love.graphics.setFont(TEN_FONT)
      love.graphics.printf("+bomb", self.player.class.x + self.player.class.width * self.player.class.scale + 5, self.player.class.y, TEN_FONT:getWidth("+bomb"), "left")
      love.graphics.setColor(r,g,b,a)
   end

   if drawHitboxes then
      love.graphics.setColor(1,0,0, 155/255)
      self.player:draw("fill")
      love.graphics.setColor(1,1,1,1)
   end

   -- draw each bullet
   for i = self.bulletCounterBase, self.bulletCounter do
      if self.bulletList[i] then
         self.bulletList[i].class:draw()

         if drawHitboxes then
            love.graphics.setColor(1,1,0, 155/255)
            self.bulletList[i]:draw("fill")
            love.graphics.setColor(1,1,1,1)
         end
      end
   end
   love.graphics.pop()
end

function Gameplay:update(dt)
   --update the background
   for i,v in ipairs(self.background) do
      v:update(dt)
   end

   -- update the bomb message if need be
   if Gameplay.static.gainedBomb then
      self.bombTime = self.bombTime + dt

      if self.bombTime > .5 then
         self.bombTime = 0
         self.bombCounter = self.bombCounter + 1
         self.bombAlpha = self.bombAlpha == 255 and 255 / 2 or 255

         if self.bombCounter > 3 then
            Gameplay.static.gainedBomb = false
            self.bombCounter = 0
            self.bombAlpha = 255 / 2
         end
      end
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
      self.bulletList[self.bulletCounter] = self.collider:addRectangle(newBullet.x, newBullet.y, newBullet.image:getWidth() * newBullet.scale, newBullet.image:getHeight() * newBullet.scale)
      self.bulletList[self.bulletCounter].class = newBullet
      self.bulletList[self.bulletCounter].class.shape = self.bulletList[self.bulletCounter]

      self.collider:addToGroup("bullets", self.bulletList[self.bulletCounter])
      self.collider:addToGroup("playerStuff", self.bulletList[self.bulletCounter])

      self.bulletCounter = self.bulletCounter + 1
      self.player.class.wantBullet = false
   end

   -- update the enemies
   for i = self.enemyCounterBase, self.enemyCounter do
      local enemy = self.enemyList[i]

      if enemy then
         enemy = enemy.class
         enemy:update(dt)

         -- remove enemy if marked
         if enemy.marked then
            if enemy.class.name == "BossAlien" then
               self.isBossFight = false
            end

            self.collider:remove(self.enemyList[i])
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
            self.bulletList[self.bulletCounter] = self.collider:addRectangle(newBullet.x, newBullet.y, newBullet.image:getWidth() * newBullet.scale, newBullet.image:getHeight() * newBullet.scale)
            self.bulletList[self.bulletCounter].class = newBullet
            self.bulletList[self.bulletCounter].class.shape = self.bulletList[self.bulletCounter]

            self.collider:addToGroup("bullets", self.bulletList[self.bulletCounter])
            self.collider:addToGroup("aliens", self.bulletList[self.bulletCounter])

            self.bulletCounter = self.bulletCounter + 1
         end
      end
   end

   -- determine whether to create a new enemy
   local enemyChance = 65
   local bigEnemyChance = 85
   local bossChance = 98
   local maxEnemies = 10
   local enemyTime = randomGenerator:random(7,15) * .1
   self.enemyOverallTime = self.enemyOverallTime + dt

   if not self.isBossFight then
      if randomGenerator:random(1, 100) > bossChance and self.enemyOverallTime > enemyTime and self:getItemCount(self.enemyList, self.enemyCounterBase, self.enemyCounter) < maxEnemies then
         local newAlien = BossAlien:new()
         self.enemyList[self.enemyCounter] = self.collider:addRectangle(newAlien.x, newAlien.y, newAlien.width * newAlien.scale, newAlien.height * newAlien.scale)
         self.enemyList[self.enemyCounter].class = newAlien
         self.enemyList[self.enemyCounter].class.shape = self.enemyList[self.enemyCounter]

         self.collider:addToGroup("aliens", self.enemyList[self.enemyCounter])

         self.enemyCounter = self.enemyCounter + 1

         self.enemyOverallTime = 0
         self.isBossFight = true
         self.bossObject = newAlien
      end
   else
      enemyChance = 35
      enemyTime = randomGenerator:random(5,10) * .1
      maxEnemies = 15
   end

   if randomGenerator:random(1,100) > bigEnemyChance and self.enemyOverallTime > enemyTime and self:getItemCount(self.enemyList, self.enemyCounterBase, self.enemyCounter) < maxEnemies then
      local newAlien = MediumAlien:new()
      self.enemyList[self.enemyCounter] = self.collider:addRectangle(newAlien.x, newAlien.y, newAlien.width * newAlien.scale, newAlien.height * newAlien.scale)
      self.enemyList[self.enemyCounter].class = newAlien
      self.enemyList[self.enemyCounter].class.shape = self.enemyList[self.enemyCounter]

      self.collider:addToGroup("aliens", self.enemyList[self.enemyCounter])

      self.enemyCounter = self.enemyCounter + 1
      self.enemyOverallTime = self.enemyOverallTime - enemyTime / 8 * 7
   end

   if randomGenerator:random(1,100) > enemyChance and self:getItemCount(self.enemyList, self.enemyCounterBase, self.enemyCounter) < maxEnemies and self.enemyOverallTime > enemyTime then
      local newAlien = EasyAlien:new()
      self.enemyList[self.enemyCounter] = self.collider:addRectangle(newAlien.x, newAlien.y, newAlien.width * newAlien.scale, newAlien.height * newAlien.scale)
      self.enemyList[self.enemyCounter].class = newAlien
      self.enemyList[self.enemyCounter].class.shape = self.enemyList[self.enemyCounter]

      self.collider:addToGroup("aliens", self.enemyList[self.enemyCounter])

      self.enemyCounter = self.enemyCounter + 1
      self.enemyOverallTime = self.enemyOverallTime - enemyTime / 8 * 7
   end
   --else
   --[[if self.bossObject then
         if self.bossObject.mode == "entrance" then
            self.scale = self.scale - dt + .01
         elseif self.bossObject.mode == "shooting" then
            self.scale = .25
         end
      end]]
--end

   self.collider:update(dt)

   if Gameplay.static.score > self.hiscore then
      self.hiscore = Gameplay.static.score
   end

   if self.player.class.wantsGhost then
      self.collider:setGhost(self.player)
      self.player.class.wantsGhost = false
   elseif self.player.class.wantsHit then
      self.collider:setSolid(self.player)
      self.player.class.wantsHit = false
   end

   if self.player.class.isReallyDead then
      local x, y = self.player.class.worldX, self.player.class.worldY

      self.collider:clear()
      currState = GameOver:new(self.background, Gameplay.static.score, self.hiscore, x, y, love.timer.getTime() - self.beginTime, Gameplay.static.bombs)
   end
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
   if key == "lshift" and Gameplay.static.bombs > 0 then
      Gameplay.static.bombs = Gameplay.static.bombs - 1
      self.enemyOverallTime = 0

      -- remove everything
      -- first, enemies
      for i = self.enemyCounterBase, self.enemyCounter do
         if self.enemyList[i] and self.enemyList[i].class.lives > 0 then
            self.enemyList[i].class:killMe(true)
         end
      end

      -- and then bullets
      for i = self.bulletCounterBase, self.bulletCounter do
         if self.bulletList[i] and not self.bulletList[i].class.marked then
            self.bulletList[i].class.marked = true
         end
      end
   end
end

function Gameplay:__tostring()
   return "State: Gameplay"
end