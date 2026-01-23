local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Slinger Hub | BLATANT MODE",
   LoadingTitle = "Mengaktifkan Fitur Bar-bar...",
   ConfigurationSaving = {Enabled = false}
})

local MainTab = Window:CreateTab("Auto Farm", 4483362458)
local PlayerTab = Window:CreateTab("Player (Blatant)", 4483362458)

-- [ AUTO FARM ]
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
   Name = "Instant Fishing (Tarik Kilat)",
   CurrentValue = false,
   Callback = function(Value)
      _G.InstantPull = Value
      task.spawn(function()
          while _G.InstantPull do
              task.wait(0.001) -- Speed Gila
              pcall(function()
                  local gui = game.Players.LocalPlayer.PlayerGui
                  for _, v in pairs(gui:GetDescendants()) do
                      if v:IsA("TextButton") and v.Visible and (v.Text:lower():find("pull") or v.Text:lower():find("catch")) then
                          local vim = game:GetService("VirtualInputManager")
                          -- Spam klik brutal
                          for i = 1, 20 do
                             vim:SendMouseButtonEvent(v.AbsolutePosition.X + (v.AbsoluteSize.X/2), v.AbsolutePosition.Y + (v.AbsoluteSize.Y/2) + 54, 0, true, game, 1)
                             vim:SendMouseButtonEvent(v.AbsolutePosition.X + (v.AbsoluteSize.X/2), v.AbsolutePosition.Y + (v.AbsoluteSize.Y/2) + 54, 0, false, game, 1)
                          end
                      end
                  end
              end)
          end
      end)
   end,
})

-- [ PLAYER TELEPORT ]
local TargetName = ""
PlayerTab:CreateInput({
   Name = "Username Target",
   PlaceholderText = "Masukkan Nama...",
   RemoveTextAfterFocusLost = false,
   Callback = function(Text)
      TargetName = Text
   end,
})

PlayerTab:CreateToggle({
   Name = "Loop Teleport to Player",
   CurrentValue = false,
   Callback = function(Value)
      _G.TPPlayer = Value
      task.spawn(function()
          while _G.TPPlayer do
              task.wait(0.1)
              pcall(function()
                  for _, p in pairs(game.Players:GetPlayers()) do
                      if p.Name:lower():find(TargetName:lower()) and p ~= game.Players.LocalPlayer then
                          game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                      end
                  end
              end)
          end
      end)
   end,
})

Rayfield:Notify({Title = "Slinger Hub Aktif", Content = "Siap bar-bar!", Duration = 5})
