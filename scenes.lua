-- Written by Rabia Alhaffar in 5/September/2020
-- ICECREAMBOY game scenes
local limit = 1
local drawtitle = false
local animate_banner = false
scenes = {
  -- Main menu
  function()
    if (#snowballs == 0) then create_snowballs(200) end
    rl.BeginDrawing()
    rl.ClearBackground(rl.WHITE)
    rl.DrawRectangle(0, rl.GetScreenHeight() / 3, ternary((limit >= rl.GetScreenWidth()), rl.GetScreenWidth(), limit), 200, rl.BLUE)
    if (limit >= rl.GetScreenWidth()) then drawtitle = true end
    if drawtitle then
      update_snowballs()
      rl.DrawText("ICECREAMBOY", (rl.GetScreenWidth() - (rl.MeasureText("ICECREAMBOY", 172))) / 2, rl.GetScreenHeight() / 2.8, 172, rl.WHITE)
      rl.DrawText("CLICK ANYWHERE TO START!", (rl.GetScreenWidth() - (rl.MeasureText("CLICK ANYWHERE TO START!", 48))) / 2, rl.GetScreenHeight() / 1.5, 48, rl.BLACK)
      rl.DrawTexturePro(raylua, texrec(raylua), rl.Rectangle(28, rl.GetScreenHeight() - 156, 128, 128), rl.Vector2(0, 0), 0, rl.WHITE)
    end
    if rl.IsMouseButtonPressed(0) and drawtitle then
      drawtitle = false
      animate_banner = true
      rl.PlaySound(select_sound)
    end
    if animate_banner then
      limit = limit - 40
      if (limit <= 0) then
        timers.menu = 0
        current_scene = 2
        animate_banner = false
        drawtitle = false
        limit = 1
        balls = {}
        snowballs = {}
        requests = {}
        balls_count = 1
        balls_limit = 5
        lives = 3
        money = 0
        timers = { menu = 0, game = 0, lose = 0 }
      end
    end
    rl.DrawFPS(10, 10)
    rl.EndDrawing()
    if (limit > rl.GetScreenWidth()) then
      limit = rl.GetScreenWidth()
    else
      limit = limit + 10
    end
    timers.menu = timers.menu + 10
  end,
  
  -- Gameplay
  function()
    rl.BeginDrawing()
    rl.ClearBackground(rl.WHITE)
    update_game()
    rl.DrawFPS(10, 10)
    rl.EndDrawing()
    timers.game = timers.game + 1
  end,
}
