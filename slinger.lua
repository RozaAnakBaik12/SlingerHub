local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "SLINGER HUB | FISH IT! VIP",
   LoadingTitle = "Initializing Premium System...",
   ConfigurationSaving = {
      Enabled = false,
      FolderName = "SlingerHub"
   },
   KeySystem = false,
   Theme = "Ocean", -- Tema baru yang lebih bersih
})

-- [ TABS ]
local MainTab = Window:CreateTab("Main Menu", 4483362458)
local FishTab = Window:CreateTab("Fishing Tool", 4483362458)
local BlatantTab = Window:CreateTab("Blatant & TP", 4483362458)

-- [ MAIN MENU ]
MainTab:CreateSection("Player Status")
MainTab:CreateLabel("User: " .. game.Players.LocalPlayer.DisplayName)

MainTab:CreateButton({
   Name = "Anti-AFK (Cegah Kick)",
   Callback = function()
       local vu = game:GetService("VirtualUser")
       game:GetService("Players").LocalPlayer.Idled:Connect(function()
           vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
           wait(1)
           vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
       end)
       Rayfield:Notify({Title = "System", Content = "Anti-AFK Aktif!", Duration = 3})
   end,
})

MainTab:CreateSlider({
   Name = "Speed Hack",
   Range = {16, 250},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

-- [ FISHING TOOL - LEGIT ]
FishTab:CreateSection("Legit Fishing (Safe Mode)")

FishTab:CreateToggle({
   Name = "Auto Cast (Normal)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoCast = Value
      task.spawn(function()
          while _G.AutoCast do
              task.wait(1.5)
              local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
              if tool then tool:Activate() end
          end
      end)
   end,
})

FishTab:CreateToggle({
   Name = "Legit Pull (Tarik Santai)",
   CurrentValue = false,
   Callback = function(Value)
      _G.LegitFish = Value
      task.spawn(function()
          while _G.LegitFish do
              task.wait(0.4) -- Jeda manusiawi agar tidak dicurigai
              pcall(function()
                  local gui = game.Players.LocalPlayer.PlayerGui
                  for _, v in pairs(gui:GetDescendants()) do
                      if v:IsA("TextButton") and v.Visible and (v.Text:lower():find("klik") or v.Text:lower():find("pull")) then
                          game:GetService("VirtualInputManager"):SendMouseButtonEvent(v.AbsolutePosition.X + (v.AbsoluteSize.X/2), v.AbsolutePosition.Y + (v.AbsoluteSize.Y/2) + 54, 0, true, game, 1)
                          game:GetService("VirtualInputManager"):SendMouseButtonEvent(v.AbsolutePosition.X + (v.AbsoluteSize.X/2), v.AbsolutePosition.Y + (v.AbsoluteSize.Y/2) + 54, 0, false, game, 1)
                      end
                  end
              end)
          end
      end)
   end,
})

-- [ BLATANT MODE ]
BlatantTab:CreateSection("Instant Mode (Risk High)")

BlatantTab:CreateToggle({
   Name = "Instant Fishing (Fast Win)",
   CurrentValue = false,
   Callback = function(Value)
      _G.InstantFish = Value
      task.spawn(function()
          while _G.InstantFish do
              task.wait(0.01)
              pcall(function()
                  local gui = game.Players.LocalPlayer.PlayerGui
                  for _, v in pairs(gui:GetDescendants()) do
                      if v:IsA("TextButton") and v.Visible and (v.Text:lower():find("klik") or v.Text:lower():find("fish")) then
                          -- Spam klik brutal untuk bypass minigame
                          for i = 1, 15 do
                             game:GetService("VirtualInputManager"):SendMouseButtonEvent(v.AbsolutePosition.X + (v.AbsoluteSize.X/2), v.AbsolutePosition.Y + (v.AbsoluteSize.Y/2) + 54, 0, true, game, 1)
                             game:GetService("VirtualInputManager"):SendMouseButtonEvent(v.AbsolutePosition.X + (v.AbsoluteSize.X/2), v.AbsolutePosition.Y + (v.AbsoluteSize.Y/2) + 54, 0, false, game, 1)
                          end
                      end
                  end
              end)
          end
      end)
   end,
})

BlatantTab:CreateSection("Teleport Control")

local target = ""
BlatantTab:CreateInput({
   Name = "Username Target",
   PlaceholderText = "Ketik nama...",
   Callback = function(t) target = t end
})

BlatantTab:CreateToggle({
   Name = "TP Loop to Player",
   CurrentValue = false,
   Callback = function(Value)
      _G.TP = Value
      task.spawn(function()
          while _G.TP do
              task.wait(0.1)
              pcall(function()
                  local p2 = game.Players:FindFirstChild(target)
                  if p2 and p2.Character then
                      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p2.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                  end
              end)
          end
      end)
   end,
})
