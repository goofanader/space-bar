require("middleclass")
require("middleclass-commons")

GameOver = class("GameOver", State)
GameOver.static.endTypingSound = love.sound.newSoundData("media/sound/Name_Entered.wav")

GameOver.static.messages = {
   {"Game Over", 0, 49},
   {"You are humanity's last hope", 50, 99},
   {"If you cannot beat them, we will die", 100, 149},
   {"They were human once", 150, 199},
   {"It's all our fault", 200, 249},
   {"We shouldn't have played god", 250, 299},
   {"They are too strong", 300, 349},
   {"I'm sorry about your father", 350, 399},
   {"We cannot win", 400, MAX_MISC}
}

function GameOver:initialize(backgrounds, score, hiscore, x, y, gameTime, bombs)
   State.initialize(self, "GameOver")

   self.background = backgrounds

   self.nameString = "Name: "
   self.cursor = "_"
   self.inputtedText = rtrim(tostring(getSharecartData("PlayerName")))

   if self.inputtedText:len() > MAX_NAME_CHARS then
      self.inputtedText = self.inputtedText:sub(1, MAX_NAME_CHARS)
   end

   self.namePrompt = self.nameString .. self.cursor

   self.overallTime = 0
   self.score = score or 0
   self.hiscore = hiscore or 0
   self.x = x or 0
   self.y = y or 0
   self.gameTime = gameTime
   self.bombs = bombs

   love.keyboard.setKeyRepeat(true)
   self.isTyping = true
   
   -- set screen back to center
   local width, height, flags = love.window.getMode()
   flags.x = initWinX
   flags.y = initWinY
   love.window.setMode(width, height, flags)
end

function GameOver:update(dt)
   if love.keyboard.isDown(" ") and not self.isTyping then
      currState = Gameplay:new()
   end

   --update the background
   --[[for i,v in ipairs(self.background) do
      v:update(dt)
   efnd]]
   self.overallTime = self.overallTime + dt

   if self.overallTime > .5 then
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
   
   -- set the screen to center
   --[[local winX, winY, flags = love.window.getMode()
   if flags.x ~= initWinX then
      if flags.x - initWinX < 0 then
         flags.x = flags.x + 1
      else
         flags.x = flags.x - 1
      end
   end

   if flags.y ~= initWinY then
      if flags.y - initWinY < 0 then
         flags.y = flags.y + 1
      else
         flags.y = flags.y - 1
      end
   end

   love.window.setMode(winX, winY, flags)]]
end

function GameOver:getMessageString()
   for i, messageList in ipairs(GameOver.messages) do
      if self.score >= messageList[2] and self.score <= messageList[3] then
         return "\"" .. messageList[1] .. "\""
      end
   end

   return "\"" .. GameOver.messages[#GameOver.messages][1] .. "\""
end

function GameOver:draw()
   -- draw the background
   for i,v in ipairs(self.background) do
      v:draw()
   end

   love.graphics.setColor(4, 174, 204, 255)
   love.graphics.setFont(FIFTY_FONT)
   local mainString = (self.isTyping or self.score < 50) and "GAME OVER" or self:getMessageString():upper()
   love.graphics.printf(mainString, 5, windowHeight / 8, windowWidth - 5, "center")

   love.graphics.setColor(255, 255, 255, 255)
   love.graphics.setFont(TEN_FONT)
   love.graphics.printf("Exit: ESC", windowWidth - 100, 5, 95, "right")
   love.graphics.printf("Score: " .. self.score, windowWidth / 4, 5, windowWidth / 2, "center")
   love.graphics.printf("Hi-score: " .. self.hiscore, windowWidth / 4, windowHeight - 20, windowWidth / 2, "center")

   love.graphics.setFont(TWENTY_FONT)
   love.graphics.printf(self.nameString .. self.inputtedText .. self.cursor, windowWidth / 4, windowHeight / 8 * 5, windowWidth / 2, "left")

   if not self.isTyping then
      love.graphics.printf("Play Again: Spacebar", windowWidth / 4, windowHeight / 8 * 3.5, windowWidth / 2, "center")
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
      --local sharecartData = sharecart.love_load(love, args)
      saveToSharecart("PlayerName", self.inputtedText)
      love.keyboard.setKeyRepeat(false)

      -- save scores
      saveToSharecart("Misc0", mod(self.score, MAX_MISC + 1))
      saveToSharecart("Misc1", mod(self.hiscore, MAX_MISC + 1))
      saveToSharecart("Misc2", mod(math.ceil(self.gameTime), MAX_MISC + 1))
      saveToSharecart("Misc3", self.bombs)
      saveToSharecart("MapX", math.floor(mod(self.x, MAX_COORDINATES)))
      saveToSharecart("MapY", math.floor(mod(self.y, MAX_COORDINATES)))

      -- randomly change sharecart switches, hehe
      for i = 0, MAX_SWITCHES do
         local switch = "Switch" .. i
         local switchValue = randomGenerator:random()
         saveToSharecart(switch, switchValue >= .5)
      end
   end

   if key == "backspace" and self.isTyping then
      self.inputtedText = string.sub(self.inputtedText, 1, self.inputtedText:len() - 1)
   end
end

function GameOver:textinput(text)
   if self.isTyping and self.inputtedText:len() < MAX_NAME_CHARS then
      self.inputtedText = self.inputtedText .. text
   end
end

function GameOver:__tostring()
   return "game over."
end