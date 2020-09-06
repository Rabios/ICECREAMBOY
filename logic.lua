-- Written by Rabia Alhaffar in 5/September/2020
-- ICECREAMBOY game logic
balls             = {}
snowballs         = {}
orders_count      = 0
orders            = {}
balls_count       = 0
balls_limit       = 4
current_order     = 0
orders_limit      = 5
lives             = 3
money             = 0
customer_num      = 1
timers            = { menu = 0, game = 0, lose = 0 }
icecreams = {
  { "CHOCOLATE",  rl.BROWN    },
  { "STRAWBERRY", rl.PINK     },
  { "LEMON",      rl.YELLOW   },
  { "MILK",       rl.RAYWHITE },
  { "MANGO",      rl.ORANGE   },
  { "KIWI",       rl.LIME     },
  { "BERRY",      rl.PURPLE   },
}

man1 = {
  timer = 0,
  finished = false,
  requested = false,
  moved = false,
  state = "happy",
  health = 100,
  happy  = rl.LoadTexture("resources/images/man1_happy.png"),
  normal = rl.LoadTexture("resources/images/man1_normal.png"),
  sad    = rl.LoadTexture("resources/images/man1_sad.png")
}
man1.x = man1.happy.width
man1.y = -man1.happy.height

girl1 = {
  timer = 0,
  finished = false,
  requested = false,
  moved = false,
  state = "happy",
  health = 100,
  happy  = rl.LoadTexture("resources/images/girl1_happy.png"),
  normal = rl.LoadTexture("resources/images/girl1_normal.png"),
  sad    = rl.LoadTexture("resources/images/girl1_sad.png")
}
girl1.x = girl1.happy.width
girl1.y = -(girl1.happy.height + man1.happy.height)

current_customer = man1

function order()
  local orderlist = {}
  if not (orders_count + 1 > orders_limit) then
    orders_count = orders_count + 1
    current_order = current_order + 1
    for i = 1, rl.GetRandomValue(1, balls_limit), 1 do
      table.insert(orderlist, icecreams[rl.GetRandomValue(1, 7)][2])
    end
    table.insert(orders, orderlist)
  end
end

function create_snowballs(n)
  snowballs = {}
  for i = 1, n, 1 do
    table.insert(snowballs, {
        x = rl.GetRandomValue(0, rl.GetScreenWidth()),
        y = rl.GetRandomValue(0, -rl.GetScreenHeight()),
        w = 64,
        h = 64,
        color = random_color()
    })
  end
end

function update_snowballs()
  for i in ipairs(snowballs) do
    rl.DrawTexturePro(ball, texrec(ball), rl.Rectangle(snowballs[i].x, snowballs[i].y, snowballs[i].w, snowballs[i].h), rl.Vector2(0, 0), 0, snowballs[i].color)
    snowballs[i].y = snowballs[i].y + 2
    if snowballs[i].y > rl.GetScreenHeight() then
      snowballs[i].x = rl.GetRandomValue(0, rl.GetScreenWidth())
      snowballs[i].y = rl.GetRandomValue(0, -rl.GetScreenHeight())
      snowballs[i].w = 64
      snowballs[i].h = 64
      snowballs[i].color = random_color()
    end
  end
end

function update_palette()
  for p in ipairs(icecreams) do
    rl.DrawRectangle((p * 200) - 200, rl.GetScreenHeight() - 200, 200, 200, icecreams[p][2])
    rl.DrawRectangleLines((p * 200) - 200, rl.GetScreenHeight() - 200, 200, 200, rl.BLACK)
    if rl.CheckCollisionRecs(rl.Rectangle((p * 200) - 200, rl.GetScreenHeight() - 200, 200, 200), mouserec()) then
      if rl.IsMouseButtonPressed(0) then
        if not (balls_count > balls_limit) then
          rl.PlaySound(addball_sound)
          table.insert(balls, icecreams[p][2])
          balls_count = balls_count + 1
        end
      end
      rl.DrawText(icecreams[p][1], (p * 200) - 200, rl.GetScreenHeight() - 200, 24, rl.WHITE)
    end
    if rl.IsMouseButtonPressed(1) then
      if (#balls > 0) then
        table.remove(balls, #balls)
        balls_count = 1
      end
    end
  end
end

-- Check equality between 2 icecreams (To check what you do with order if right!)
function correct_tables(arr1, arr2)
  local check = 0
  if (#arr1 > 0 and #arr2 > 0) then
    if (#arr2 == #arr1) then
      for a in ipairs(arr2) do
        if (arr2[a] == arr1[a]) then
          check = check + 1
        end
      end
      return (check == #arr2)
    end
  end
end

man1.logic = function()
  if not man1.finished then
    rl.DrawTexturePro(man1[man1.state], texrec(man1[man1.state]), rl.Rectangle(man1.x, man1.y, 256, 256), rl.Vector2(0, 0), 0, rl.WHITE)
    if not man1.moved then
      man1.y = man1.y + 5
      if (man1.y >= rl.GetScreenHeight() / 3) then
        man1.moved = true
        order()
        man1.requested = true
      end
    end
    if man1.requested then
      if not (man1.health <= 0) then
        rl.DrawRectangle(rl.GetScreenWidth() - 200, 200, man1.health * 2, 20, rl.RED)
        rl.DrawRectangleLines(rl.GetScreenWidth() - 200, 200, man1.health * 2, 20, rl.GOLD)
        man1.health = man1.health - 0.1
        if rl.CheckCollisionRecs(rl.Rectangle(man1.x, man1.y, 256, 256), rl.Rectangle(rl.GetMouseX(), rl.GetMouseY(), 1, 1)) and rl.IsMouseButtonPressed(0) then
          if correct_tables(balls, orders[current_order]) then
            rl.SetSoundVolume(money_sound, 0.2)
            rl.PlaySound(money_sound)
            current_customer = girl1
            customer_num = customer_num + 1
            money = money + (#balls * 100)
            balls = {}
            balls_count = 1
            man1.finished = true
          else
            rl.TraceLog(rl.LOG_INFO, tostring(#balls)..","..tostring(#orders[current_order]))
          end
        end
      end
    end
    if (man1.health <= 50) then man1.state = "normal" end
    if (man1.health <= 25) then man1.state = "sad" end
    if (man1.health <= 0) then
      rl.SetSoundVolume(lose_sound, 0.2)
      rl.PlaySound(lose_sound)
      current_customer = girl1
      lives = lives - 1
      customer_num = customer_num + 1
      man1.finished = true
    end
    man1.timer = man1.timer + 1
  end
end

girl1.logic = function()
  if not girl1.finished then
    rl.DrawTexturePro(girl1[girl1.state], texrec(girl1[girl1.state]), rl.Rectangle(girl1.x, girl1.y, 256, 256), rl.Vector2(0, 0), 0, rl.WHITE)
    if not girl1.moved then
      girl1.y = girl1.y + 5
      if (girl1.y >= rl.GetScreenHeight() / 3) then
        girl1.moved = true
        order()
        girl1.requested = true
      end
    end
    if girl1.requested then
      if not (girl1.health <= 0) then
        rl.DrawRectangle(rl.GetScreenWidth() - 200, 200, girl1.health * 2, 20, rl.RED)
        rl.DrawRectangleLines(rl.GetScreenWidth() - 200, 200, girl1.health * 2, 20, rl.GOLD)
        girl1.health = girl1.health - 0.1
        if rl.CheckCollisionRecs(rl.Rectangle(girl1.x, girl1.y, 256, 256), rl.Rectangle(rl.GetMouseX(), rl.GetMouseY(), 1, 1)) and rl.IsMouseButtonPressed(0) then
          if correct_tables(balls, orders[current_order]) then
            rl.SetSoundVolume(money_sound, 0.2)
            rl.PlaySound(money_sound)
            money = money + (#balls * 100)
            balls = {}
            balls_count = 1
            girl1.finished = true
          end
        end
      end
    end
    if (girl1.health <= 50) then girl1.state = "normal" end
    if (girl1.health <= 25) then girl1.state = "sad" end
    if (girl1.health <= 0) then
      rl.SetSoundVolume(lose_sound, 0.2)
      rl.PlaySound(lose_sound)
      lives = lives - 1
      current_order = current_order + 1
      girl1.finished = true
    end
    girl1.timer = girl1.timer + 1
  end
end

function update_cone()
  rl.DrawTexturePro(cone, texrec(cone), rl.Rectangle(rl.GetMouseX(), rl.GetMouseY(), 64, 64), rl.Vector2(0, 0), 0, rl.WHITE)
  for b in ipairs(balls) do
    if not (balls[b] == nil) then
      rl.DrawTexturePro(ball, texrec(ball), rl.Rectangle(rl.GetMouseX(), rl.GetMouseY() - (b * 64), 64, 64), rl.Vector2(0, 0), 0, balls[b])
    end
  end
end

function update_money()
  rl.DrawTexturePro(money_image, texrec(money_image), rl.Rectangle(32, 32, 64, 32), rl.Vector2(0, 0), 0, rl.WHITE)
  rl.DrawText("$"..money, 128, 32, 32, rl.GREEN)
end

function update_lives()
  for h = 1, lives, 1 do
    rl.DrawTexturePro(heart, texrec(heart), rl.Rectangle(h * 32 + ((h - 1) * 8), 72, 32, 32), rl.Vector2(0, 0), 0, rl.WHITE)
  end
end

function update_orders()
  if (#orders > 0) then
    rl.DrawRectangleLines(rl.GetScreenWidth() - 200, 0, 200, 200, rl.GOLD)
    rl.DrawTexturePro(cone, texrec(cone), rl.Rectangle((rl.GetScreenWidth() - (32 * 3.5)), rl.GetScreenHeight() - 600, 32, 32), rl.Vector2(0, 0), 0, rl.WHITE)
    if orders[current_order] then
      for rb in ipairs(orders[current_order]) do
        rl.DrawTexturePro(ball, texrec(ball), rl.Rectangle((rl.GetScreenWidth() - (32 * 3.5)), (rl.GetScreenHeight() - 600) - (rb * 32), 32, 32), rl.Vector2(0, 0), 0, orders[current_order][rb])
      end
      if rl.IsKeyPressed(rl.KEY_A) or rl.IsKeyPressed(rl.KEY_LEFT) then
        if not ((current_order - 1) == 0) and orders[current_order - 1] then
          current_order = current_order - 1
        end
      elseif rl.IsKeyPressed(rl.KEY_D) or rl.IsKeyPressed(rl.KEY_RIGHT) then
        if not ((current_order + 1) > orders_limit) and orders[current_order + 1] then
          current_order = current_order + 1
        end
      end
    end
  end
end

function update_customers()
  if (customer_num == 1) then
    man1.logic()
  elseif (customer_num == 2) then
    girl1.logic()
  end
end

function update_game()
  rl.DrawTexturePro(street, texrec(street), rl.Rectangle(0, 0, rl.GetScreenWidth(), rl.GetScreenHeight() - 200), rl.Vector2(0, 0), 0, rl.WHITE)
  update_palette()
  update_money()
  update_lives()
  update_orders()
  update_customers()
  update_cone()
  timers.game = timers.game + 1
end