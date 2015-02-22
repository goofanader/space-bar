require("classes/additionalFunctions")
local sharecart = require("sharecart")

function love.load()
   --[[-- load the o_o.ini file
   local userDirectory = love.filesystem.getWorkingDirectory()
   --print(userDirectory)
   local directorySplit = split(userDirectory, "/")
   iniFileObject = nil
   iniFileString = directorySplit[1]
   
   for i = 2, table.getn(directorySplit) - 1 do
      iniFileString = iniFileString .. "/" .. directorySplit[i]
   end
   
   print("iniFileString: " .. iniFileString)
   
   if not love.filesystem.exists(iniFileString .. "/dat/o_o.ini") then
      print("woooaahh")
      if not love.filesystem.exists(iniFileString .. "/dat") then
         print("aw yeah")
         if not love.filesystem.createDirectory(iniFileString .. "/dat") then
            print("couldn't create 'dat' folder!")
            love.event.quit()
         end
      end
   
      iniFileObject = love.filesystem.newFile(iniFileString .. "/dat/o_o.ini")
      iniFileObject:open("w")
      
      -- write a new o_o.ini file! --
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
   end
   
   iniFileObject = love.filesystem.newFile(iniFileString .. "/dat/o_o.ini")
   iniFileObject:open("r")
   
   print(iniFileString)]]
   local sharecartData = sharecart.love_load(love, args)
   if sharecartData == nil then
      print("ini file not found")
      
      
      local userDirectory = love.filesystem.getWorkingDirectory()
      --print(userDirectory)
      local directorySplit = split(userDirectory, "/")
      iniFileObject = nil
      iniFileString = directorySplit[1]
      
      for i = 2, table.getn(directorySplit) - 1 do
         iniFileString = iniFileString .. "\\" .. directorySplit[i]
      end
      
      print("iniFileString: " .. iniFileString)
      os.execute("mkdir " .. iniFileString .. "\\dat")
      
      iniFileObject = io.open(iniFileString .. "\\dat\\o_o.ini", "w")
      
      -- write a new o_o.ini file! --
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
   end
end

function love.update(dt)
end

function love.draw()
end

function love.keypressed(key, isrepeat)
   if key == "escape" or key == "q" then
      love.event.quit()
   end
end

function love.quit()
   --iniFileObject:close()
end