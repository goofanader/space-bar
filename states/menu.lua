require("middleclass")
require("middleclass-commons")

Menu = class("Menu")

function Menu:initialize()
   local sharecartData = sharecart.love_load(love, args)
   self.hiscore = sharecartData.Misc1
   self.score = 0
end

function Menu:draw()
   -- draw the background
   --[[for i,v in ipairs(self.background) do
      v:draw()
   end]]

   love.graphics.setColor(255, 255, 255, 255)
   love.graphics.setFont(FIFTY_FONT)
   love.graphics.printf("SPACE BAR", windowWidth / 4, windowHeight / 8, windowWidth / 2, "center")

   love.graphics.setFont(TEN_FONT)
   love.graphics.printf("Exit: ESC", windowWidth - 100, 5, 95, "right")
   love.graphics.printf("Score: " .. self.score, windowWidth / 4, 5, windowWidth / 2, "center")
   love.graphics.printf("Hi-score: " .. self.hiscore, windowWidth / 4, windowHeight - 20, windowWidth / 2, "center")

   love.graphics.setFont(TWENTY_FONT)
   love.graphics.printf("to Start", windowWidth / 4, windowHeight / 8 * 5, windowWidth / 2, "center")
end

function Menu:update(dt)
end

function Menu:keypressed(key, isrepeat)
   if key == " " then
      currState = Gameplay:new(self.hiscore)
   end
end

function Menu:textinput(text)
end

function Menu:__tostring()
   return "State: Menu"
end