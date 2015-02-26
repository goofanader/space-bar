require 'middleclass'
require 'middleclass-commons'
local anim8 = require 'libraries/anim8'

Player = class("Player")
Player.static.guyImage = love.graphics.newImage("media/images/spaceguy.png")
Player.static.shipImage = love.graphics.newImage("media/images/spaceship.png")
Player.static.deathImage = love.graphics.newImage("media/images/shipasplode.png")
Player.static.deathSound = love.sound.newSoundData("media/sound/Player_Death.wav")
Player.static.gotHit = love.sound.newSoundData("media/sound/Hit_Hurt4.wav")

function Player:initialize()
   self.image = Player.static.guyImage

   self.x = 0
   self.y = windowHeight / 2 - (self.image:getHeight() / 2)
   self.width = 8
   self.height = 8

   self.worldX = 0
   self.worldY = self.y
   self.scale = SCALE

   self.grid = anim8.newGrid(self.width, self.height, self.image:getWidth(), self.image:getHeight())
   self.mainAnimation = anim8.newAnimation(self.grid('1-2', 1), 2 / FRAME_RATE)
   self.deathAnimation = anim8.newAnimation(self.grid('1-2', 1), 1 / FRAME_RATE, function(instance)
         if instance.classObject.deathLoops >= 2 then
            instance.classObject.marked = true
            instance:pause()
            self.isReallyDead = true
         else
            instance:gotoFrame(1)
            instance.classObject.deathLoops = instance.classObject.deathLoops + 1
         end
      end
   )
   self.deathAnimation.classObject = self
   self.deathLoops = 0
   self.isDead = false
   self.isReallyDead = false

   self.timeTotal = 0
   self.bulletTime = BULLET_TIME + 1
   self.wantBullet = false

   self.animation = self.mainAnimation

   self.lives = getSharecartData("Switch0") and mod(getSharecartData("Misc2"), MAX_LIVES) or 1
   self.wantsGhost = false
   self.isGhost = false
   self.wantsHit = false
   self.ghostAlpha = 255 / 2
   self.ghostCounter = 0
   self.ghostTime = 0

   if self.lives == 0 then
      self.lives = 1
   end
end

function Player:draw()
   local r,g,b,a = love.graphics.getColor()
   if not self.isGhost then
      love.graphics.setColor(255, 255, 255, 255)
   else
      love.graphics.setColor(255, 255, 255, self.ghostAlpha)
   end

   self.animation:draw(self.image, self.x, self.y, 0, self.scale, self.scale)
   
   love.graphics.setColor(r,g,b,a)
end

function Player:update(dt)
   self.timeTotal = self.timeTotal + dt
   self.bulletTime = self.bulletTime + dt
   self.animation:update(dt)

   if not self.isDead then
      local prevX, prevY = self.x, self.y
      local prevWX, prevWY = self.worldX, self.worldY

      --update movement via keyboard presses
      local keysDown = keyPressQueue:getRepeats()
      
      --[[for k,v in pairs(keysDown) do
         print(k,v)
      end
      print("===")]]
      
      if keysDown["up"] then
         self.y = self.y - MOVEMENT
      end
      if keysDown["down"] then
         self.y = self.y + MOVEMENT
      end

      if keysDown["left"] then
         self.x = self.x - MOVEMENT
      end
      if keysDown["right"] then
         self.x = self.x + MOVEMENT
      end

      if keysDown[" "] and self.bulletTime > BULLET_TIME then
         -- pew pew lasers
         --[[addToBulletList(self.x + self.image:getWidth(), self.y, self.worldX + self.image:getWidth(), self.worldY, "Player", 1)]]
         self.wantBullet = true
         self.bulletTime = 0
      end

      self.y = self.y + math.sin(self.timeTotal * 10)
      self.worldY = self.y

      self.worldX = self.worldX + MOVEMENT + self.x

      if self.x < 0 then
         self.worldX = self.worldX + prevX - self.x
         self.x = prevX
      elseif self.x > windowWidth - self.width * self.scale then
         self.worldX = self.worldX - (self.x - prevX)
         self.x = prevX
      end

      if self.y < 0 or self.y > windowHeight - self.height * self.scale then
         --print(love.keyboard.isDown("up") and love.keyboard.isDown("left") and love.keyboard.isDown(" "))
         self.y = prevY
         self.worldY = self.y
      end

      self.shape:move(self.x - prevX, self.y - prevY)

      if self.isGhost then
         self.ghostTime = self.ghostTime + dt

         if self.ghostTime > .2 then
            self.ghostTime = 0
            self.ghostAlpha = self.ghostAlpha == 255 and 0 or 255
            self.ghostCounter = self.ghostCounter + 1
            
            if self.ghostCounter > 7 then
               self.ghostCounter = 0
               self.isGhost = false
               self.wantsHit = true
            end
         end
      end
   end
end

function Player:killMe()
   if not self.isGhost then
      self.lives = self.lives - 1

      if self.lives < 1 then
         self.animation = self.deathAnimation
         self.image = Player.deathImage
         self.isDead = true

         playSound(Player.deathSound, .5)
         return true
      else
         self.wantsGhost = true
         self.isGhost = true
         
         playSound(Player.gotHit, .2)
      end
   end

   return false
end

function Player:__tostring()
   return "Player (" .. self.x .. "," .. self.y .. ")"
end