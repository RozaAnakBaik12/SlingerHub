local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Slinger Hub | Fish It! VIP",
   LoadingTitle = "Memuat Sistem Pancing...",
   ConfigurationSaving = {Enabled = false}
})

-- [ TAB ]
local MainTab = Window:CreateTab("Auto Farm", 4483362458)
local PlayerTab = Window:CreateTab("Player", 4483362458)

-- [ FITUR UTAMA ]
MainTab:CreateSection("Fishing Mode")

MainTab:CreateToggle({
   Name = "Auto Cast (Lempar Otomatis)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoCast = Value
      task.spawn(function()
          while _G.AutoCast do
              task.wait(1)
              local char = game.Players.LocalPlayer.Character
              local tool = char:FindFirstChildOfClass("Tool")
              if tool then 
                  tool:Activate() 
              end
          end
      end)
   end,
})

MainTab:CreateToggle({
   Name = "Instant Fishing (Tarik Kilat)",
   CurrentValue = false,
   Callback = function(Value)
      _G.InstantFish = Value
      task.spawn(function()
          while _G.InstantFish do
              task.wait(0.01) -- Cek super cepat
              pcall(function()
                  local gui = game.Players.LocalPlayer.PlayerGui
                  local vim = game:GetService("VirtualInputManager")
                  
                  -- Mencari tombol pancing dengan cara lebih teliti
                  for _, v in pairs(gui:GetDescendants()) do
                      if v:IsA("TextButton") and v.Visible then
                          local txt = v.Text:lower()
                          -- Deteksi semua kemungkinan teks tombol di Fish It!
                          if txt:find("klik") or txt:find("pull") or txt:find("catch") or v.Name:lower():find("fish") then
                              -- Spam klik brutal di posisi tombol
                              for i = 1, 10 do
                                  vim:SendMouseButtonEvent(v.AbsolutePosition.X + (v.AbsoluteSize.X/2), v.AbsolutePosition.Y + (v.AbsoluteSize.Y/2) + 54, 0, true, game, 1)
                                  vim:SendMouseButtonEvent(v.AbsolutePosition.X + (v.AbsoluteSize.X/2), v.AbsolutePosition.Y + (v.AbsoluteSize.Y/2) + 54, 0, false, game, 1)
                              end
                          end
                      end
                  end
              end)
          end
      end)
   end,
})

-- [ LEGIT MODE ]
MainTab:CreateSection("Legit Mode")
MainTab:CreateToggle({
   Name = "Legit Fishing (Tarik Santai)",
   CurrentValue = false,
   Callback = function(Value)
      _G.LegitFish = Value
      task.spawn(function()
          while _G.LegitFish do
              task.wait(0.4) -- Jeda agar terlihat seperti manusia
              pcall(function()
                  local gui = game.Players.LocalPlayer.PlayerGui
                  for _, v in pairs(gui:GetDescendants()) do
                      if v:IsA("TextButton") and v.Visible and v.Text:lower():find("klik") then
                          local vim = game:GetService("VirtualInputManager")
                          vim:SendMouseButtonEvent(v.AbsolutePosition.X + (v.AbsoluteSize.X/2), v.AbsolutePosition.Y + (v.AbsoluteSize.Y/2) + 54, 0, true, game, 1)
                          vim:SendMouseButtonEvent(v.AbsolutePosition.X + (v.AbsoluteSize.X/2), v.AbsolutePosition.Y + (v.AbsoluteSize.Y/2) + 54, 0, false, game, 1)
                      end
                  end
              end)
          end
      end)
   end,
})

-- [ PLAYER TP ]
local target = ""
PlayerTab:CreateInput({
   Name = "Username Target",
   PlaceholderText = "Ketik nama...",
   Callback = function(t) target = t end
})

PlayerTab:CreateToggle({
   Name = "Teleport ke Player",
   CurrentValue = false,
   Callback = function(Value)
      _G.TP = Value
      task.spawn(function()
          while _G.TP do
              task.wait(0.1)
              pcall(function()
                  local p2 = game.Players:FindFirstChild(target)
                  if p2 then
                      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p2.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
                  end
              end)
          end
      end)
   end,
})
