require("middleclass")
require("middleclass-commons")

Menu = class("Menu", State)

Menu.static.titleImage = love.graphics.newImage("images/spacebar.png")
Menu.static.arrowsImage = love.graphics.newImage("images/arrowkeys.png")

function Menu:initialize()
   State.initialize(self, "Menu")
   
   self.hiscore = getSharecartData("Misc1")
   self.score = 0
   
   self.background = {}
   self.background[1] = Background:new(0,0)
   self.background[2] = Background:new(512,0) --513?
   self.background[3] = Background:new(1024,0)
   
   self.sampleEnemies = {}
   self.sampleEnemies[1] = EasyAlien:new()
   self.sampleEnemies[1].x = windowWidth / 16 * 12
   self.sampleEnemies[1].y = windowHeight / 3
   
   self.sampleEnemies[2] = EasyAlien:new()
   self.sampleEnemies[2].x = windowWidth / 16 * 13
   self.sampleEnemies[2].y = windowHeight / 3
   
   self.sampleEnemies[3] = EasyAlien:new()
   self.sampleEnemies[3].x = windowWidth / 16 * 14
   self.sampleEnemies[3].y = windowHeight / 3
   
   self.overallTime = 0
end

function Menu:draw()
   -- draw the background
   for i,v in ipairs(self.background) do
      v:draw()
   end
   
   for i,v in ipairs(self.sampleEnemies) do
      v:draw()
   end

   love.graphics.setColor(255, 255, 255, 255)
   --love.graphics.setFont(FIFTY_FONT)
   --love.graphics.printf("SPACE BAR", windowWidth / 4, windowHeight / 8, windowWidth / 2, "center")
   love.graphics.draw(Menu.titleImage, windowWidth / 2 - (Menu.titleImage:getWidth() / 2), windowHeight / 7)

   love.graphics.setFont(TEN_FONT)
   love.graphics.printf("Exit: ESC", windowWidth - 100, 5, 95, "right")
   love.graphics.printf("Score: " .. self.score, windowWidth / 4, 5, windowWidth / 2, "center")
   love.graphics.printf("Hi-score: " .. self.hiscore, windowWidth / 4, windowHeight - 20, windowWidth / 2, "center")

   love.graphics.setFont(TWENTY_FONT)
   love.graphics.printf("to Start", windowWidth / 4, windowHeight / 8 * 5, windowWidth / 2, "center")
   
   love.graphics.draw(Menu.arrowsImage, windowWidth / 8 - (Menu.arrowsImage:getWidth() / 2), windowHeight / 8)
   love.graphics.printf("to Move", windowWidth / 16, windowHeight / 8 * 5, windowWidth / 8, "center")
   
   love.graphics.printf("Destroy", windowWidth / 16 * 12, windowHeight / 8 * 5, windowWidth / 7, "center")
end

function Menu:update(dt)
   self.overallTime = self.overallTime + dt
   
   for i,v in ipairs(self.sampleEnemies) do
      v.animation:update(dt)
      
      if mod(i, 2) == 1 then
         v.y = v.y + math.sin(self.overallTime * 10)
      else
         v.y = v.y + math.cos(self.overallTime * 10)
      end
   end
end

function Menu:keypressed(key, isrepeat)
   if key == " " then
      currState = Gameplay:new(self.hiscore)
   end
end

function Menu:__tostring()
   return "State: Menu"
end