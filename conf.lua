function love.conf(t)
   t.window.width = 1024
   t.window.height = 128
   t.version = "11.1"
   t.window.title = "Space Bar"
   t.window.borderless = true
   t.console = false
   --t.window.resizable = true
   t.accelerometerjoystick = false      -- Enable the accelerometer on iOS and Android by exposing it as a Joystick (boolean)
    t.externalstorage = false           -- True to save files (and read from the save directory) in external storage on Android (boolean)
    t.gammacorrect = false              -- Enable gamma-correct rendering, when supported by the system (boolean)
    t.audio.mixwithsystem = false        -- Keep background music playing when opening LOVE (boolean, iOS and Android only)
    t.window.vsync = 1                  -- Vertical sync mode (number)
    t.modules.touch = false              -- Enable the touch module (boolean)
    t.modules.video = false              -- Enable the video module (boolean)
end