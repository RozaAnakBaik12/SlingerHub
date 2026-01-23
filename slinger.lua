local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
   Name = "Slinger Hub | Fish It!",
   LoadingTitle = "Memuat Fitur...",
   ConfigurationSaving = { Enabled = true, FolderName = "Slinger_FishIt" }
})

local MainTab = Window:CreateTab("Fishing AFK", 4483362458)

-- FITUR AUTO CAST (OTOMATIS LEMPAR)
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
              if tool and tool:FindFirstChild("Click") then -- Mencari event klik pada alat pancing
                  tool.Click:FireServer()
              end
          end
      end)
   end,
})

-- FITUR AUTO REEL / SHAKE (PENARIK IKAN)
MainTab:CreateToggle({
   Name = "Auto Reel (Otomatis Tarik)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoReel = Value
      task.spawn(function()
          while _G.AutoReel do
              task.wait(0.1)
              pcall(function()
                  local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
                  -- Di Fish It!, biasanya ada UI "Bar" atau "Button" yang muncul
                  for _, v in pairs(PlayerGui:GetDescendants()) do
                      if v:IsA("TextButton") and (v.Text:lower():find("pull") or v.Text:lower():find("click")) and v.Visible then
                          -- Simulasi klik tombol tarik
                          game:GetService("VirtualInputManager"):SendMouseButtonEvent(v.AbsolutePosition.X + (v.AbsoluteSize.X / 2), v.AbsolutePosition.Y + (v.AbsoluteSize.Y / 2) + 50, 0, true, game, 1)
                          game:GetService("VirtualInputManager"):SendMouseButtonEvent(v.AbsolutePosition.X + (v.AbsoluteSize.X / 2), v.AbsolutePosition.Y + (v.AbsoluteSize.Y / 2) + 50, 0, false, game, 1)
                      end
                  end
              end)
          end
      end)
   end,
})

-- FITUR AUTO SELL (JUAL OTOMATIS)
MainTab:CreateToggle({
   Name = "Auto Sell (Jual Ikan)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoSell = Value
      task.spawn(function()
          while _G.AutoSell do
              task.wait(5) -- Jual setiap 5 detik
              -- Logika TP ke NPC Sell atau kirim Remote Event Sell
              -- (Tergantung lokasi NPC di Fish It!)
              game:GetService("ReplicatedStorage").Events.SellFish:FireServer() -- Contoh remote
          end
      end)
   end,
})

Rayfield:Notify({
   Title = "Slinger Hub Loaded",
   Content = "Khusus untuk Fish It! - Semoga beruntung!",
   Duration = 5
})
