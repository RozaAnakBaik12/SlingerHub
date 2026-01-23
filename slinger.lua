local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
   Name = "Slinger Hub | Fish It!",
   LoadingTitle = "Memuat Menu SlingerHub...",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "SlingerHub_FishIt"
   },
   KeySystem = false
})

local MainTab = Window:CreateTab("Auto Farm", 4483362458)

-- TOGGLE AUTO CAST
MainTab:CreateToggle({
   Name = "Auto Cast (Lempar Pancing)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoCast = Value
      task.spawn(function()
          while _G.AutoCast do
              task.wait(1)
              local char = game.Players.LocalPlayer.Character
              local tool = char:FindFirstChildOfClass("Tool")
              if tool then
                  tool:Activate() -- Simulasi klik untuk melempar
              end
          end
      end)
   end,
})

-- TOGGLE AUTO PULL/SHAKE
MainTab:CreateToggle({
   Name = "Auto Pull (Tarik Ikan)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoPull = Value
      task.spawn(function()
          while _G.AutoPull do
              task.wait(0.1)
              pcall(function()
                  local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
                  -- Mencari tombol pancing di game Fish It!
                  for _, v in pairs(PlayerGui:GetDescendants()) do
                      if v:IsA("TextButton") and v.Visible and (v.Text:lower():find("pull") or v.Text:lower():find("catch") or v.Text:lower():find("tap")) then
                          local vim = game:GetService("VirtualInputManager")
                          vim:SendMouseButtonEvent(v.AbsolutePosition.X + (v.AbsoluteSize.X/2), v.AbsolutePosition.Y + (v.AbsoluteSize.Y/2) + 50, 0, true, game, 1)
                          vim:SendMouseButtonEvent(v.AbsolutePosition.X + (v.AbsoluteSize.X/2), v.AbsolutePosition.Y + (v.AbsoluteSize.Y/2) + 50, 0, false, game, 1)
                      end
                  end
              end)
          end
      end)
   end,
})

Rayfield:Notify({
   Title = "Slinger Hub Berhasil Dimuat",
   Content = "Selamat memancing di Fish It!",
   Duration = 5,
   Image = 4483362458,
})
