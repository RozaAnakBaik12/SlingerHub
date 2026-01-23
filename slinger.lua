local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Slinger Hub | Fish It!",
   LoadingTitle = "Delta Mobile Support",
   ConfigurationSaving = {Enabled = false}
})

local Tab = Window:CreateTab("Auto Farm", 4483362458)

Tab:CreateToggle({
   Name = "Auto Cast & Pull",
   CurrentValue = false,
   Callback = function(Value)
      _G.Fishing = Value
      while _G.Fishing do
         task.wait(0.5)
         local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
         if tool then
            tool:Activate()
         end
         
         -- Mencari tombol pull secara otomatis
         local gui = game.Players.LocalPlayer.PlayerGui
         for _, v in pairs(gui:GetDescendants()) do
            if v:IsA("TextButton") and v.Visible and (v.Text:lower():find("pull") or v.Text:lower():find("catch")) then
               local vim = game:GetService("VirtualInputManager")
               vim:SendMouseButtonEvent(v.AbsolutePosition.X + (v.AbsoluteSize.X/2), v.AbsolutePosition.Y + (v.AbsoluteSize.Y/2) + 50, 0, true, game, 1)
               vim:SendMouseButtonEvent(v.AbsolutePosition.X + (v.AbsoluteSize.X/2), v.AbsolutePosition.Y + (v.AbsoluteSize.Y/2) + 50, 0, false, game, 1)
            end
         end
      end
   end,
})
