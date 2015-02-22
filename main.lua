require("libraries/additionalFunctions")
local sharecart = require("sharecart")
require("constants")
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
   
   for i = 2, table.getn(directorySplit) - 1 do
      iniFileString = iniFileString .. slashes .. directorySplit[i]
   end
   
   print("iniFileString: " .. iniFileString)
   os.execute("mkdir " .. iniFileString .. slashes .. "dat")
   
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
      
      for i = 0, 7 do
         iniFileObject:write("Switch" .. i .. "=True\n")
      end
      iniFileObject:close()
   else
      print("Could not create file!")
      love.event.quit()
   end
end

function love.load()
   drawHitboxes = false
   
   love.graphics.setDefaultFilter("nearest")
   windowWidth, windowHeight = love.graphics.getDimensions()
   
   require("classes/player")
   require("classes/bullet")
   require("classes/background")
   require("classes/easyAlien")
   
   require("states/gameplay")
   require("states/menu")
   
   local sharecartData = sharecart.love_load(love, args)
   if sharecartData == nil then
      print("ini file not found")
      createSaveFile()
      
      -- reload the data
      sharecartData = sharecart.love_load(love, args)
   end
   
   if sharecartData.Misc0 ~= 0 then
      randomGenerator = love.math.newRandomGenerator(sharecartData.Misc0)
   else
      randomGenerator = love.math.newRandomGenerator(1)
   end
   
   currState = Gameplay:new()
end

function love.update(dt)
   currState:update(dt)
end

function love.draw()
   currState:draw()
end

function love.keypressed(key, isrepeat)
   if key == "escape" or key == "q" then
      love.event.quit()
   end
   
   currState:keypressed(key, isrepeat)
end

function love.quit()
   --iniFileObject:close()
end