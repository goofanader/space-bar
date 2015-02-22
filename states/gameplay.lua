require("middleclass")
require("middleclass-commons")

Gameplay = class("Gameplay")

function Gameplay:initialize()
   self.player = Player:new()
   self.bulletList = {}
   self.bulletCounter = 1
   self.bulletCounterBase = self.bulletCounter
   
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
end

function Gameplay:keypressed(key, isrepeat)
end

function Gameplay:__tostring()
   return "State: Gameplay"
end