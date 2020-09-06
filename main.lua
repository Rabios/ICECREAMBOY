-- Written by Rabia Alhaffar in 5/September/2020
-- ICECREAMBOY main game script!
rl = require("raylib")

rl.SetConfigFlags(rl.FLAG_MSAA_4X_HINT)
rl.SetConfigFlags(rl.FLAG_VSYNC_HINT)
rl.InitWindow(rl.GetScreenWidth(), rl.GetScreenHeight(), "ICECREAMBOY")
rl.ToggleFullscreen()
rl.InitAudioDevice()

rl.SetTargetFPS(60)
rl.SetTextureFilter(rl.GetFontDefault().texture, rl.FILTER_POINT)

dofile("assets.lua")
dofile("utils.lua")
dofile("logic.lua")
dofile("scenes.lua")

current_scene = 1
load_assets()

while not rl.WindowShouldClose() do
  scenes[current_scene]() -- Run current scene from scenes array
end

unload_assets()
rl.CloseAudioDevice()
rl.CloseWindow()
os.exit(0)