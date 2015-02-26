require("libraries/additionalFunctions")
sharecart = require("sharecart")
HC = require("libraries/hardoncollider")

function createSaveFile()
   local userDirectory = love.filesystem.getWorkingDirectory()
   local directorySplit = split(userDirectory, "/")
   local iniFileObject = nil
   local iniFileString = directorySplit[1]
   local slashes = "/"
   
   local osname = nil
   -- the following tidbit of code for finding the os was taken from http://www.wellho.net/resources/ex.php4?item=u112/getos --
   local fh, err = io.popen("uname -o 2>/dev/null", "r")
   if fh then
      osname = fh:read()
   end
   
   if not osname then
      slashes = "\\"
   end
   
   for i = 2, #directorySplit - 1 do
      iniFileString = iniFileString .. slashes .. directorySplit[i]
   end
   
   print("iniFileString: " .. iniFileString)
   os.execute("mkdir \"" .. iniFileString .. slashes .. "dat\"")
   
   iniFileObject = io.open(iniFileString .. slashes .. "dat" .. slashes .."o_o.ini", "w")
   
   -- write a new o_o.ini file! --
   if iniFileObject then
      iniFileObject:write("[Main]\n")
      iniFileObject:write("MapX=0\n")
      iniFileObject:write("MapY=0\n")
      iniFileObject:write("Misc0=0\n")
      iniFileObject:write("Misc1=0\n")
      iniFileObject:write("Misc2=0\n")
      iniFileObject:write("Misc3=0\n")
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

function saveToSharecart(varName, data)
   local sharecartData = sharecart.love_load(love, args)
   if sharecartData == nil then
      -- ini file not found
      createSaveFile()
      
      -- reload the data
      sharecartData = sharecart.love_load(love, args)
   end
   
   sharecartData[varName] = data
end

function getSharecartData(varName)
   local sharecartData = sharecart.love_load(love, args)
   if sharecartData == nil then
      -- ini file not found
      createSaveFile()
      
      -- reload the data
      sharecartData = sharecart.love_load(love, args)
   end
   
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
   windowWidth, windowHeight = love.graphics.getDimensions()
   
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
   
   local misc0 = getSharecartData("Misc0")
   if misc0 ~= 0 then
      randomGenerator = love.math.newRandomGenerator(misc0)
   else
      randomGenerator = love.math.newRandomGenerator(1)
   end
   
   currState = Menu:new()--Gameplay:new()
   
   music = love.audio.newSource("media/sound/spacemusic.wav")
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

function love.keypressed(key, isrepeat)
   if key == "escape" then
      love.event.quit()
   end
   
   currState:keypressed(key, isrepeat)
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