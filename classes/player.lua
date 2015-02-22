require 'middleclass'
require 'middleclass-commons'
local anim8 = require 'libraries/anim8'

Player = class("Player")
Player.static.guyImage = love.graphics.newImage("images/spaceguy.png")
Player.static.shipImage = love.graphics.newImage("images/spaceship.png")

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
   self.animation = anim8.newAnimation(self.grid('1-2', 1), 2 / FRAME_RATE)
   
   self.timeTotal = 0
   self.bulletTime = BULLET_TIME + 1
   self.wantBullet = false
end

function Player:draw()
   self.animation:draw(self.image, self.x, self.y, 0, self.scale, self.scale)
end

function Player:update(dt)
   self.timeTotal = self.timeTotal + dt
   self.bulletTime = self.bulletTime + dt
   self.animation:update(dt)
   
   local prevX, prevY = self.x, self.y
   local prevWX, prevWY = self.worldX, self.worldY
   
   --update movement via keyboard presses
   if love.keyboard.isDown("up") then
      self.y = self.y - MOVEMENT
   end
   if love.keyboard.isDown("down") then
      self.y = self.y + MOVEMENT
   end
   
   if love.keyboard.isDown("left") then
      self.x = self.x - MOVEMENT
   end
   if love.keyboard.isDown("right") then
      self.x = self.x + MOVEMENT
   end
   
   if love.keyboard.isDown(" ") and self.bulletTime > BULLET_TIME then
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
end

function Player:__tostring()
   return "Player (" .. self.x .. "," .. self.y .. ")"
end