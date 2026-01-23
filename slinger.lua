-- SLINGER HUB BRUTAL EDITION (NO LIBRARY)
-- Dibuat khusus karena Rayfield sering Error di HP

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CastBtn = Instance.new("TextButton")
local PullBtn = Instance.new("TextButton")
local CloseBtn = Instance.new("TextButton")

-- Setup UI (Biar pasti muncul di layar)
ScreenGui.Name = "SlingerHubUI"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Position = UDim2.new(0.5, -90, 0.4, -60)
MainFrame.Size = UDim2.new(0, 180, 0, 160)
MainFrame.BorderSizePixel = 2
MainFrame.Active = true
MainFrame.Draggable = true -- Biar bisa digeser di HP

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "SLINGER HUB"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

CastBtn.Name = "CastBtn"
CastBtn.Parent = MainFrame
CastBtn.Position = UDim2.new(0.1, 0, 0.25, 0)
CastBtn.Size = UDim2.new(0.8, 0, 0.25, 0)
CastBtn.Text = "AUTO CAST: OFF"
CastBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CastBtn.TextColor3 = Color3.new(1, 1, 1)

PullBtn.Name = "PullBtn"
PullBtn.Parent = MainFrame
PullBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
PullBtn.Size = UDim2.new(0.8, 0, 0.25, 0)
PullBtn.Text = "AUTO PULL: OFF"
PullBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
PullBtn.TextColor3 = Color3.new(1, 1, 1)

CloseBtn.Parent = MainFrame
CloseBtn.Position = UDim2.new(0.8, 0, 0, 0)
CloseBtn.Size = UDim2.new(0.2, 0, 0, 30)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.BackgroundColor3 = Color3.new(1, 0, 0)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- FITUR AUTO CAST (LEMPAR)
local casting = false
CastBtn.MouseButton1Click:Connect(function()
    casting = not casting
    CastBtn.Text = casting and "AUTO CAST: ON" or "AUTO CAST: OFF"
    CastBtn.BackgroundColor3 = casting and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    
    task.spawn(function()
        while casting do
            local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
            task.wait(1.5)
        end
    end)
end)

-- FITUR AUTO PULL (TARIK)
local pulling = false
PullBtn.MouseButton1Click:Connect(function()
    pulling = not pulling
    PullBtn.Text = pulling and "AUTO PULL: ON" or "AUTO PULL: OFF"
    PullBtn.BackgroundColor3 = pulling and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    
    task.spawn(function()
        while pulling do
            task.wait(0.1)
            pcall(function()
                local gui = game.Players.LocalPlayer.PlayerGui
                for _, v in pairs(gui:GetDescendants()) do
                    if v:IsA("TextButton") and v.Visible and (v.Text:lower():find("pull") or v.Text:lower():find("catch")) then
                        -- Simulasi klik di HP
                        local vim = game:GetService("VirtualInputManager")
                        vim:SendMouseButtonEvent(v.AbsolutePosition.X + (v.AbsoluteSize.X/2), v.AbsolutePosition.Y + (v.AbsoluteSize.Y/2) + 50, 0, true, game, 1)
                        vim:SendMouseButtonEvent(v.AbsolutePosition.X + (v.AbsoluteSize.X/2), v.AbsolutePosition.Y + (v.AbsoluteSize.Y/2) + 50, 0, false, game, 1)
                    end
                end
            end)
        end
    end)
end)
