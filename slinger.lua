--[[
    ╔══════════════════════════════════════════╗
    ║             SLINGER HUB v1.0             ║
    ║        PREMIUM FISHING INTERFACE         ║
    ║        OWNER: Lizz | Ozaaa            ║
    ╚══════════════════════════════════════════╝
]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("SLINGER HUB - eyeGPT EDITION", "Midnight")

-- FARMING TAB
local Farm = Window:NewTab("Main Farming")
local FarmSection = Farm:NewSection("Automated Fishing")

FarmSection:NewToggle("Slinger Auto-Fish", "Otomatis melempar dan menarik kail", function(state)
    _G.SlingerFishing = state
    spawn(function()
        while _G.SlingerFishing do
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then
                    tool:Activate()
                    -- Bypass logic for SlingerHub
                    task.wait(0.1)
                    game:GetService("ReplicatedStorage").Events.FishingEvent:FireServer("Cast")
                end
            end)
            task.wait(0.5)
        end
    end)
end)

FarmSection:NewToggle("Instant Reel", "Menarik ikan seketika tanpa minigame", function(state)
    _G.InstantReel = state
    spawn(function()
        while _G.InstantReel do
            game:GetService("ReplicatedStorage").Events.FishingEvent:FireServer("ReelIn", true)
            task.wait(0.05)
        end
    end)
end)

-- TELEPORT TAB
local Teleport = Window:NewTab("Locations")
local TPSection = Teleport:NewSection("Instant Warp")

TPSection:NewButton("Sell Area", "Teleport ke tempat jual ikan", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(100, 20, 200) -- Ganti koordinat sesuai map
end)

TPSection:NewButton("Deep Sea", "Area ikan langka", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-500, 10, 1500)
end)

-- PLAYER TAB
local Player = Window:NewTab("Player")
local PSection = Player:NewSection("Ability")

PSection:NewSlider("Movement Speed", "Atur kecepatan lari", 250, 16, function(v)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
end)

PSection:NewButton("Anti-AFK", "Cegah diskoneksi saat farming", function()
    local vu = game:GetService("VirtualUser")
    game.Players.LocalPlayer.Idled:Connect(function()
        vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
        wait(1)
        vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    end)
end)

-- SYSTEM TAB
local Sys = Window:NewTab("System")
local SSection = Sys:NewSection("Owner: argaaa")
SSection:NewButton("Destroy GUI", "Menghapus menu SlingerHub", function()
    Library:DestroyGui()
end)
