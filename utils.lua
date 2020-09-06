-- Written by Rabia Alhaffar in 5/September/2020
-- ICECREAMBOY utilities
function random_color()
  return rl.Color(rl.GetRandomValue(0, 255), rl.GetRandomValue(0, 255), rl.GetRandomValue(0, 255), rl.GetRandomValue(0, 255))
end

function texrec(t)
  return rl.Rectangle(0, 0, t.width, t.height)
end

function ternary(a, t, f)
  if a then
    return t
  else
    return f
  end
end

function mouserec()
  return rl.Rectangle(rl.GetMouseX(), rl.GetMouseY(), 1, 1)
end