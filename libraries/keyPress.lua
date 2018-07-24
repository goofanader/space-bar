require("middleclass")
require("middleclass-commons")

KeyPress = class("KeyPress")

function KeyPress:initialize(key)
   self.key = key
   self.timeStart = love.timer.getTime()
   self.timeEnd = false

   self.queueIndex = false
end

function KeyPress:setTimeEnd()
   self.timeEnd = love.timer.getTime()
end

function KeyPress:hasEnded()
   if self.timeEnd then
      return true
   else
      return false
   end
end

function KeyPress:__tostring()
   local timeEnd = self.timeEnd or "?"
   local str = ""

   --[[if self.key == 'space' then
      str = str .. "[spacebar]"
   else]]
      str = str .. self.key
   --end

   return str .. " (" .. self.timeStart .. " - " .. timeEnd .. ")"
end