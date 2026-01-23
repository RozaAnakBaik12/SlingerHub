-- LOAD LIBRARY GUI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- BUAT WINDOW UTAMA
local Window = Rayfield:CreateWindow({
   Name = "Slinger Hub | Testing",
   LoadingTitle = "Loading Script...",
   ConfigurationSaving = { Enabled = true, FolderName = "FishIt_Config" }
})

-- TAB UTAMA
local MainTab = Window:CreateTab("Fishing Main", 4483362458)

-- FITUR AUTO SHAKE (BLATANT)
MainTab:CreateToggle({
   Name = "Auto Shake (Instant)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoShake = Value
      while _G.AutoShake do
         task.wait()
         -- Logika mencari UI Shake di game Fisch
         local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
         local shakeUI = PlayerGui:FindFirstChild("shakeui", true)
         if shakeUI and shakeUI.Enabled then
             -- Langsung klik tombol shake tanpa animasi
             for _, v in pairs(shakeUI:GetDescendants()) do
                 if v:IsA("ImageButton") then
                     guiV1 = v
                     game:GetService("VirtualInputManager"):SendMouseButtonEvent(v.AbsolutePosition.X, v.AbsolutePosition.Y, 0, true, game, 1)
                     game:GetService("VirtualInputManager"):SendMouseButtonEvent(v.AbsolutePosition.X, v.AbsolutePosition.Y, 0, false, game, 1)
                 end
             end
         end
      end
   end,
})

-- FITUR INSTANT REEL (SANGAT BLATANT)
MainTab:CreateToggle({
   Name = "Instant Reel (Instan Tangkap)",
   CurrentValue = false,
   Callback = function(Value)
      _G.InstantReel = Value
      -- Ini mendeteksi jika mini-game pancing muncul, langsung kirim sinyal menang
      local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
      PlayerGui.ChildAdded:Connect(function(child)
          if _G.InstantReel and child.Name == "reel" then 
              task.wait(0.2)
              -- Mengirim Remote Event ke Server bahwa ikan sudah didapat
              game:GetService("ReplicatedStorage").events.reelfinished:FireServer(100, true)
          end
      end)
   end,
})

-- TAB TELEPORT
local TPTab = Window:CreateTab("Teleport", 4483362458)

TPTab:CreateButton({
   Name = "TP to Moosewood (Main Island)",
   Callback = function()
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(380, 135, 230) -- Koordinat contoh
   end,
})

Rayfield:Notify({
   Title = "Script Loaded",
   Content = "Selamat menggunakan Fish It Clone!",
   Duration = 5
})
