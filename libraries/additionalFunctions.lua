-- remove trailing whitespace from string.
-- http://en.wikipedia.org/wiki/Trim_(8programming)
function rtrim(s)
  local n = #s
  while n > 0 and s:find("^%s", n) do n = n - 1 end
  return s:sub(1, n)
end

-- convert string to boolean
function strToBool(str)
   if str == "true" then
      return true
   elseif str == "false" then
      return false
   else
      return nil
   end
end

---
-- Splits a string on the given pattern, returned as a table of the delimited strings.
-- @param str the string to parse through
-- @param pat the pattern/delimiter to look for in str
-- @return a table of the delimited strings. If pat is empty, returns str. If str is not given, aka '' is given, then it returns an empty table.
function split(str, pat)
   if pat == '' then
      return str
   end

   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
         table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end

-- Get just the filename, none of the folder parts.
function justFilename(filePath)
   if filePath ~= "" then
      local filenameParts = split(filePath, '/')
      return filenameParts[#filenameParts]
   else
      return ""
   end
end

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

