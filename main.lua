require("libraries/additionalFunctions")
local sharecart = require("sharecart")
require("constants")

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
   love.graphics.setDefaultFilter("nearest")
   windowWidth, windowHeight = love.graphics.getDimensions()
   
   require("classes/player")
   require("classes/bullet")
   
   local sharecartData = sharecart.love_load(love, args)
   if sharecartData == nil then
      print("ini file not found")
      createSaveFile()
      
      -- reload the data
      --sharecartData = sharecart.love_load(love, args)
   end
   
   player = Player:new()
   bulletList = {}
   bulletCounter = 1
   bulletCounterBase = 1
   
   bulletImage = love.graphics.newImage("images/lazr.png")
end

function addToBulletList(x, y, worldX, worldY, owner, direction)
   bulletList[bulletCounter] = Bullet:new(x, y, worldX, worldY, owner, direction, bulletCounter)
   bulletCounter = bulletCounter + 1
end

function removeFromBulletList(index)
   bulletList[index] = nil--, index)
   --bulletCounter = bulletCounter - 1???
   if index == bulletCounterBase then
      bulletCounterBase = bulletCounterBase + 1
   end
end

function love.update(dt)
   local tableCopy = {}
   for i = bulletCounterBase, bulletCounter do
      if bulletList[i] then
         table.insert(tableCopy, i, bulletList[i])
      end
   end
   
   for i = bulletCounterBase, bulletCounter do
      if bulletList[i] then
         bulletList[i]:update(dt)
      end
   end
   
   player:update(dt)
end

function love.draw()
   player:draw()
   
   for i = bulletCounterBase, bulletCounter do
      if bulletList[i] then
         bulletList[i]:draw()
      end
      --it's not drawing here after the first one gets removed. Switch to a key-based system rather than by i... it doesn't work??
   end
end

function love.keypressed(key, isrepeat)
   if key == "escape" or key == "q" then
      love.event.quit()
   end
end

function love.quit()
   --iniFileObject:close()
end