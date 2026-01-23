--[[ 
    SLINGER HUB - FISCH VERSION
    Pastikan menggunakan link Raw yang benar!
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Slinger Hub | Fisch",
   LoadingTitle = "Mengaktifkan Slinger Hub...",
   LoadingSubtitle = "by RozaAnakBaik12",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "SlingerHub_Configs"
   },
   KeySystem = false
})

local MainTab = Window:CreateTab("Utama", 4483362458)

-- TOGGLE AUTO SHAKE
MainTab:CreateToggle({
   Name = "Auto Shake (Instant)",
   CurrentValue = false,
   Flag = "AutoShake", 
   Callback = function(Value)
      _G.AutoShake = Value
      task.spawn(function()
          while _G.AutoShake do
              task.wait(0.01) -- Agar tidak lag
              local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
              local shakeUI = PlayerGui:FindFirstChild("shakeui", true)
              if shakeUI and shakeUI.Enabled then
                  local safe = shakeUI:FindFirstChild("safezone", true)
                  if safe then
                      local button = safe:FindFirstChild("button", true)
                      if button then
                          -- Menggunakan VirtualInputManager agar lebih akurat
                          game:GetService("VirtualInputManager"):SendMouseButtonEvent(button.AbsolutePosition.X + (button.AbsoluteSize.X / 2), button.AbsolutePosition.Y + (button.AbsoluteSize.Y / 2), 0, true, game, 1)
                          game:GetService("VirtualInputManager"):SendMouseButtonEvent(button.AbsolutePosition.X + (button.AbsoluteSize.X / 2), button.AbsolutePosition.Y + (button.AbsoluteSize.Y / 2), 0, false, game, 1)
                      end
                  end
              end
          end
      end)
   end,
})

-- TOGGLE INSTANT REEL
MainTab:CreateToggle({
   Name = "Instant Reel",
   CurrentValue = false,
   Flag = "InstantReel",
   Callback = function(Value)
      _G.InstantReel = Value
      local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
      PlayerGui.ChildAdded:Connect(function(child)
          if _G.InstantReel and child.Name == "reel" then
              task.wait(0.1)
              local event = game:GetService("ReplicatedStorage"):FindFirstChild("events")
              if event and event:FindFirstChild("reelfinished") then
                  event.reelfinished:FireServer(100, true)
              end
          end
      end)
   end,
})

Rayfield:Notify({
   Title = "Slinger Hub Aktif!",
   Content = "Selamat menggunakan, Roza!",
   Duration = 5,
   Image = 4483362458,
})
