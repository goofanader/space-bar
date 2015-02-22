require("middleclass")
require("middleclass-commons")
local anim8 = require("libraries/anim8")

Alien = class("Alien")

function Alien:initialize(name, image, x, y, width, height, animationSpeed)
   self.name = name
   self.image = image
   
   self.x = x
   self.y = y
   
   self.width = width
   self.height = height
   
   self.scale = SCALE
   self.marked = false
   
   self.animGrid = anim8.newGrid(width, height, image:getWidth(), image:getHeight())
   animationSpeed = not animationSpeed and 6 / FRAME_RATE or animationSpeed
   self.animation = anim8.newAnimation(self.animGrid('1-2', 1), animationSpeed)
end

function Alien:draw()
   self.animation:draw(self.image, self.x, self.y, 0, self.scale)
end

function Alien:update(dt)
   self.animation:update(dt)
end

function Alien:__tostring()
   return "Alien: " .. self.name
end