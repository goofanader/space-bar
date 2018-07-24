---
-- Queue holds both a regular queue and a double queue - whichever is needed for your needs.
-- @module queue

require("middleclass")
require("middleclass-commons")

Queue = class("Queue")

function Queue:initialize()
   self.first = 0
   self.last = -1
   self.values = {}

   self.repeats = {}
end

function Queue:pushleft(value)
   local first = self.first - 1
   value.queueIndex = first

   self.first = first
   self.values[first] = value

   self.repeats[value.key] = self.values[first]
end

function Queue:pushright(value)
   local last = self.last + 1
   value.queueIndex = last

   self.last = last
   self.values[last] = value

   self.repeats[value.key] = self.values[last]
end

function Queue:popLeft()
   local first = self.first

   if first > self.last then
      error("list is empty")
   end

   local value = self.values[first]
   self.values[first] = nil
   self.first = first + 1

   return value
end

function Queue:popright()
   local last = self.last

   if self.first > last then
      error("list is empty")
   end

   local value = self.values[last]
   self.values[last] = nil
   self.last = last - 1

   return value
end

function Queue:peekleft()
   return self.values[self.first]
end

function Queue:peekright()
   return self.values[self.last]
end

function Queue:hasRepeats()
   for key, value in pairs(self.repeats) do
      return true
   end

   return false
end

function Queue:getRepeats()
   return self.repeats
end

function Queue:setEndTime(key)
    if key ~= nil and self.repeats[key] ~= nil then
       self.values[self.repeats[key].queueIndex]:setTimeEnd()
       self.repeats[key] = nil
   end
end

function Queue:printQueue(maxPrintNum)
   maxPrintNum = maxPrintNum and maxPrintNum + self.first <= self.last and maxPrintNum + self.first or self.last

   for i = self.first, maxPrintNum do
      print(self.values[i])
   end
end