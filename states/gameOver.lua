require("middleclass")
require("middleclass-commons")

GameOver = class("GameOver")

function GameOver:initialize(backgrounds, score, hiscore)
   self.background = backgrounds
   --[[self.background[1] = Background:new(0,0)
   self.background[2] = Background:new(512,0) --513?
   self.background[3] = Background:new(1024,0)]]

   --self.font = GameOver.font
   local sharecartData = sharecart.love_load(love, args)
   
   self.nameString = "Name: "
   self.cursor = "_"
   self.inputtedText = sharecartData.PlayerName

   self.namePrompt = self.nameString .. self.cursor

   self.overallTime = 0
   self.score = score or 0
   self.hiscore = hiscore or 0

   love.keyboard.setKeyRepeat(true)
   self.isTyping = true
end

function GameOver:update(dt)
   if love.keyboard.isDown(" ") and not self.isTyping then
      currState = Gameplay:new()
   end

   --update the background
   --[[for i,v in ipairs(self.background) do
      v:update(dt)
   end]]
   self.overallTime = self.overallTime + dt

   if self.overallTime > 1 then
      self.overallTime = 0

      if self.isTyping then
         if self.cursor == " " then
            self.cursor = "_"
         else
            self.cursor = " "
         end
      else
         self.cursor = " "
      end
   end
end

function GameOver:draw()
   -- draw the background
   for i,v in ipairs(self.background) do
      v:draw()
   end

   love.graphics.setColor(255, 255, 255, 255)
   love.graphics.setFont(FIFTY_FONT)
   love.graphics.printf("GAME OVER", windowWidth / 4, windowHeight / 8, windowWidth / 2, "center")

   love.graphics.setFont(TEN_FONT)
   love.graphics.printf("Exit: ESC", windowWidth - 100, 5, 95, "right")
   love.graphics.printf("Score: " .. self.score, windowWidth / 4, 5, windowWidth / 2, "center")
   love.graphics.printf("Hi-score: " .. self.hiscore, windowWidth / 4, windowHeight - 20, windowWidth / 2, "center")

   love.graphics.setFont(TWENTY_FONT)
   love.graphics.printf(self.nameString .. self.inputtedText .. self.cursor, windowWidth / 4, windowHeight / 8 * 5, windowWidth / 2, "left")
   
   if not self.isTyping then
      love.graphics.printf("Play Again: Spacebar", windowWidth / 4, windowHeight / 8 * 5, windowWidth / 2, "right")
   end
end

function GameOver:keypressed(key, isrepeat)
   if key == " " and not self.isTyping then
      currState = Gameplay:new(self.hiscore)
   end

   if key == "return" and self.isTyping then
      self.isTyping = not self.isTyping
      self.cursor = " "
      
      -- save name
      local sharecartData = sharecart.love_load(love, args)
      sharecartData.PlayerName = self.inputtedText
      love.keyboard.setKeyRepeat(false)
      
      -- save scores
      sharecartData.Misc0 = self.score
      sharecartData.Misc1 = self.hiscore
   end

   if key == "backspace" and self.isTyping then
      self.inputtedText = string.sub(self.inputtedText, 1, self.inputtedText:len() - 1)
   end
end

function GameOver:textinput(text)
   if self.isTyping then
      self.inputtedText = self.inputtedText .. text
   end
end

function GameOver:__tostring()
   return "game over."
end