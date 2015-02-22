require("middleclass")
require("middleclass-commons")

Gameplay = class("Gameplay")

function Gameplay:initialize()
   self.player = Player:new()
   self.bulletList = {}
   self.bulletCounter = 1
   self.bulletCounterBase = self.bulletCounter
end

function Gameplay:draw()
   self.player:draw()
   
   for i = self.bulletCounterBase, self.bulletCounter do
      if self.bulletList[i] then
         self.bulletList[i]:draw()
      end
   end
end

function Gameplay:update(dt)
   --[[local tableCopy = {}
   for i = self.bulletCounterBase, self.bulletCounter do
      if self.bulletList[i] then
         table.insert(tableCopy, i, self.bulletList[i])
      end
   end]]
   
   for i = self.bulletCounterBase, self.bulletCounter do
      if self.bulletList[i] then
         self.bulletList[i]:update(dt)
         
         if self.bulletList[i].marked then
            self.bulletList[i] = nil
            
            if i == self.bulletCounterBase then
               self.bulletCounterBase = self.bulletCounterBase + 1
            end
         end
      end
   end
   
   self.player:update(dt)
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