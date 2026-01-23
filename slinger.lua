local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
   Name = "Slinger Hub | Fish It! v3",
   LoadingTitle = "Mengaktifkan Script...",
   ConfigurationSaving = { Enabled = true, FolderName = "Slinger_Fish" }
})

local MainTab = Window:CreateTab("Auto Farm", 4483362458)

-- AUTO CAST (LEMPAR PANCING)
MainTab:CreateToggle({
   Name = "Auto Cast (Otomatis Lempar)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoCast = Value
      task.spawn(function()
          while _G.AutoCast do
              task.wait(0.5)
              local char = game.Players.LocalPlayer.Character
              local tool = char:FindFirstChildOfClass("Tool")
              if tool then
                  -- Mencoba berbagai cara melempar (RemoteEvent umum)
                  local event = tool:FindFirstChild("Click") or tool:FindFirstChild("RemoteEvent") or tool:FindFirstChild("Cast")
                  if event and event:IsA("RemoteEvent") then
                      event:FireServer()
                  else
                      -- Jika tidak ada remote, coba simulasi klik layar
                      tool:Activate()
                  end
              end
          end
      end)
   end,
})

-- AUTO REEL (PENARIK IKAN UNIVERSAL)
MainTab:CreateToggle({
   Name = "Auto Pull (Tarik Ikan)",
   CurrentValue = false,
   Callback = function(Value)
      _G.AutoPull = Value
      task.spawn(function()
          while _G.AutoPull do
              task.wait(0.1) -- Cek setiap 0.1 detik
              pcall(function()
                  local gui = game.Players.LocalPlayer.PlayerGui
                  -- Mencari tombol apa pun yang muncul saat ikan ditarik
                  for _, v in pairs(gui:GetDescendants()) do
                      if v:IsA("TextButton") and v.Visible and v.Parent.Visible then
                          -- Cek jika tombol mengandung kata kunci pancingan
                          local txt = v.Text:lower()
                          if txt:find("pull") or txt:find("click") or txt:find("tap") or txt:find("shake") then
                              -- Simulasi klik tepat di tombol tersebut
                              local vim = game:GetService("VirtualInputManager")
                              vim:SendMouseButtonEvent(v.AbsolutePosition.X + (v.AbsoluteSize.X/2), v.AbsolutePosition.Y + (v.AbsoluteSize.Y/2) + 50, 0, true, game, 1)
                              vim:SendMouseButtonEvent(v.AbsolutePosition.X + (v.AbsoluteSize.X/2), v.AbsolutePosition.Y + (v.AbsoluteSize.Y/2) + 50, 0, false, game, 1)
                          end
                      end
                  end
              end)
          end
      end)
   end,
})

Rayfield:Notify({
   Title = "Slinger Hub Aktif",
   Content = "Silakan pegang pancingan lalu nyalakan fitur!",
   Duration = 5
})
