function mod(a, b)
   --a % b == a - math.floor(a / b) * b
   return a - math.floor(a / b) * b
end

function sleep(n, channel)
   t0 = os.clock()
   
   while os.clock() - t0 <= n do
      if channel and channel:peek() then
         break
      end
   end
end

-- Functions for Ovals
function getOvalX(y, xLength, yLength, offsetX)
   offsetX = offsetX or 0
   
   return math.sqrt((1 - (math.pow(y, 2) / math.pow(yLength, 2))) * math.pow(xLength, 2)) + offsetX
end

function getOvalY(x, xLength, yLength, offsetY)
   offsetY = offsetY or 0
   
   return math.sqrt((1 - (math.pow(x, 2) / math.pow(xLength, 2))) * math.pow(yLength, 2)) + offsetY
end

function getFoci(a, b)
   local c = math.sqrt(math.pow(b, 2) - math.pow(a, 2))
   return c
end

