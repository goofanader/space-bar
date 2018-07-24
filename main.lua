require("libraries/additionalFunctions")
sharecart = require("sharecart")
HC = require("libraries/hardoncollider")
require("libraries/queue")
require("libraries/keyPress")

function getSharecartDat()
   local userDirectory = love.filesystem.getWorkingDirectory()
   local directorySplit = split(userDirectory, "/")
   local iniFileString = directorySplit[1]
   local slashes = "/"

   local osname = love._os

   if osname == "Windows" then
      slashes = "\\"
   end

   if osname == "OS X" and love.filesystem.isFused() then
       for i = 2, #directorySplit - 1 do
          if osname == "OS X" and love.filesystem.isFused() and directorySplit[i]:find("%.app") then
             break
          end

          iniFileString = iniFileString .. slashes .. directorySplit[i]
      end
  else
      iniFileString = userDirectory
  end

   local datFolder = iniFileString .. slashes .. "dat"

   return datFolder, slashes
end

function createSaveFile()
   local iniFileObject = nil

   local datFolder, slashes = getSharecartDat()
   local quotes = love._os == "Windows" and "\"" or ""

   -- it would be nice to check if dat folder already exists, but whatever
   local mkdirDatFolder = datFolder
   if love._os ~= "Windows" then
      -- escape any spaces in mkdirDatFolder
      local words = split(mkdirDatFolder, " ")
      mkdirDatFolder = words[1]
      for i = 2, #words do
         mkdirDatFolder = mkdirDatFolder .. "\\ " .. words[i]
      end
   end
   os.execute("mkdir " .. quotes .. mkdirDatFolder .. quotes)

   iniFileObject = io.open(datFolder .. slashes .."o_o.ini", "w")

   -- write a new o_o.ini file! --
   if iniFileObject then
      iniFileObject:write("[Main]\n")
      iniFileObject:write("MapX=0\n")
      iniFileObject:write("MapY=0\n")
      iniFileObject:write("Misc0=0\n")
      iniFileObject:write("Misc1=0\n")
      iniFileObject:write("Misc2=0\n")
      iniFileObject:write("Misc3=3\n")
      iniFileObject:write("PlayerName=Player\n")

      for i = 0, MAX_SWITCHES do
         iniFileObject:write("Switch" .. i .. "=FALSE\n")
      end
      iniFileObject:close()
   else
      print("Could not create file!")
      love.event.quit()
   end
end

function reloadSharecartData()
   createSaveFile()
   return sharecart.love_load(love, arg)
end

function checkSharecartData()
   local sharecartData
   if not pcall(function()
         sharecartData = sharecart.love_load(love, arg)
      end
      ) then
      return reloadSharecartData()
   end

   if sharecartData == nil then
      --print("sharecart null")
      -- ini file not found
      sharecartData = reloadSharecartData()
   else
      -- Check to see if it's a valid Sharecart file
      local datFolder, slashes = getSharecartDat()
      local iniFile = io.open(datFolder .. slashes .. "o_o.ini", "r")
      if iniFile:read() ~= "[Main]" then
         return reloadSharecartData()
      end
      iniFile:close()

      local sharecartNames = {
         "MapX", "MapY"
      }
      for i = 0, 3 do
         table.insert(sharecartNames, "Misc" .. i)
      end
      table.insert(sharecartNames, "PlayerName")
      for i = 0, MAX_SWITCHES do
         table.insert(sharecartNames, "Switch" .. i)
      end

      local sharecartNameSearch = {
         {"Map", "number", 0, MAX_COORDINATES},
         {"Misc", "number", 0, MAX_MISC},
         {"Player", "string", false, MAX_COORDINATES},
         {"Switch", "boolean"}
      }

      for i, value in ipairs(sharecartNames) do
         local data = sharecartData[value]

         local checkFunction = function(string, data, checks)
            local key, dataType, min, max = unpack(checks)

            if string:find(key) then
               if dataType ~= "string" then
                  assert(type(data) == dataType, dataType .. " expected")
               end

               if min then
                  assert(data >= min, data .. " too small")
               end
               if max then
                  if dataType == "string" then
                     assert(data:len() <= max, "'" .. data .. "' string too big")
                  else
                     assert(data <= max, data .. " too big")
                  end
               end
            end
         end

         for i, nameSearch in ipairs(sharecartNameSearch) do
            if not pcall(function()
                  checkFunction(value, data, nameSearch)
               end
               ) then
               sharecartData = reloadSharecartData()
               break
            end
         end
      end
   end

   return sharecartData
end


function saveToSharecart(varName, data)
   local sharecartData = checkSharecartData()

   sharecartData[varName] = data
end

function getSharecartData(varName)
   local sharecartData = checkSharecartData()

   return sharecartData[varName]
end

function playSound(sound, volume)
   volume = volume or 1.0

   local newSound = love.audio.newSource(sound, "static")
   newSound:setVolume(volume)
   newSound:play()
end

function love.load()
   drawHitboxes = false
   --overallTime = 0

   love.graphics.setDefaultFilter("nearest")
   local width, height, flags = love.window.getMode()
   windowWidth = width
   windowHeight = height
   initWinX = flags.x
   initWinY = flags.y

   require("constants")

   require("classes/player")
   require("classes/bullet")
   require("classes/background")
   require("classes/easyAlien")
   require("classes/mediumAlien")
   require("classes/bossAlien")

   require("states/state")
   require("states/gameplay")
   require("states/menu")
   require("states/gameOver")

   keyPressQueue = Queue:new()
   validKeys = {
      ["left"] = true,
      ["right"] = true,
      ["up"] = true,
      ["down"] = true,
      ["space"] = true,
      ["lshift"] = true--bomb key
   }

   local misc0 = getSharecartData("Misc0")
   if misc0 ~= 0 then
      randomGenerator = love.math.newRandomGenerator(misc0)
   else
      randomGenerator = love.math.newRandomGenerator(1)
   end

   currState = Menu:new()--Gameplay:new()
   love.keyboard.setKeyRepeat(true)

   music = love.audio.newSource("media/sound/spacemusic.wav", "stream")
   music:setLooping(true)
   music:play()
end

function love.update(dt)
   --overallTime = overallTime + dt
   currState:update(dt)
   --[[local width, height, tables = love.window.getMode()
   love.window.setMode(windowWidth, windowHeight, {x=tables.x + 1, y=tables.y + 1, borderless=true})]]
end

function love.draw()
   currState:draw()
end

function love.keypressed(key, scancode, isrepeat)
   if key == "escape" then
      love.event.quit()
   end

   if not isrepeat then
      --if validKeys[key] then
      --print(key, validKeys[key])
      local newEntry = KeyPress:new(key)

      keyPressQueue:pushright(newEntry)
      keyPressQueue.repeats[key] = newEntry
      --end
   end

   currState:keypressed(key, isrepeat)
end

function love.keyreleased(key)
   if validKeys[key] then
      keyPressQueue:setEndTime(key)
   end

   currState:keyreleased(key)
end

function love.textinput(text)
   currState:textinput(text)
end

function love.resize(width, height)
   windowWidth = width
   windowHeight = height
end

function love.quit()
   --iniFileObject:close()
end