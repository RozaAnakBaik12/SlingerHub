local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
   Name = "Slinger Hub | Fish It",
   LoadingTitle = "Memuat...",
   ConfigurationSaving = {Enabled = false}
})

local MainTab = Window:CreateTab("Utama", 4483362458)

MainTab:CreateToggle({
   Name = "Auto Cast (Lempar)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoCast = Value
      task.spawn(function()
          while _G.AutoCast do
              task.wait(1)
              local char = game.Players.LocalPlayer.Character
              local tool = char:FindFirstChildOfClass("Tool")
              if tool then tool:Activate() end
          end
      end)
   end,
})

MainTab:CreateToggle({
   Name = "Auto Pull (Tarik)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoPull = Value
      task.spawn(function()
          while _G.AutoPull do
              task.wait(0.1)
              pcall(function()
                  local gui = game.Players.LocalPlayer.PlayerGui
                  for _, v in pairs(gui:GetDescendants()) do
                      if v:IsA("TextButton") and v.Visible and (v.Text:lower():find("pull") or v.Text:lower():find("catch")) then
                          game:GetService("VirtualInputManager"):SendMouseButtonEvent(v.AbsolutePosition.X + (v.AbsoluteSize.X/2), v.AbsolutePosition.Y + (v.AbsoluteSize.Y/2) + 50, 0, true, game, 1)
                          game:GetService("VirtualInputManager"):SendMouseButtonEvent(v.AbsolutePosition.X + (v.AbsoluteSize.X/2), v.AbsolutePosition.Y + (v.AbsoluteSize.Y/2) + 50, 0, false, game, 1)
                      end
                  end
              end)
          end
      end)
   end,
})
