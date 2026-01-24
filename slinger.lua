--[[
	SLINGERHUB - WORLD EXPLORER EDITION
	Tabs: Player, Main, Exclusive, Teleport, Settings
	Feature: Full Island Teleports + Instant Fishing
]]

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- 1. WINDOW SETUP
local Window = WindUI:CreateWindow({
    Title = "SlingerHub - Premium",
    Icon = "map",
    Author = "eyeGPT",
    Folder = "SlingerHub_Final",
    Size = UDim2.fromOffset(580, 420),
    Theme = "Indigo",
    KeySystem = false
})

-- 2. TABS CONFIGURATION
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local MainTab = Window:Tab({ Title = "Main", Icon = "home" })
local ExclusiveTab = Window:Tab({ Title = "Exclusive", Icon = "star" })
local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map-pin" })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })

-- --- TAB: MAIN (INSTANT FISHING) ---
local Config = { AutoFish = false, Delay = 0.65 }
local MainSec = MainTab:Section({ Title = "Instant Fishing" })

MainSec:Toggle({
    Title = "Enable Instant Fishing",
    Content = "Menangkap ikan otomatis tanpa dupe",
    Callback = function(v) Config.AutoFish = v end
})

MainSec:Slider({
    Title = "Instant Delay",
    Min = 0.40, Max = 2.00, Default = 0.65,
    Callback = function(v) Config.Delay = v end
})

-- --- TAB: TELEPORT (ALL ISLANDS) ---
local TeleSec = TeleportTab:Section({ Title = "Island & Location Select" })

local Destinasi = {
    ["Moosewood (Main)"] = Vector3.new(385, 5, 20),
    ["Roslit Bay"] = Vector3.new(-1450, 5, 650),
    ["Terrapin Island"] = Vector3.new(-100, 5, 1450),
    ["Sunken Ship"] = Vector3.new(-2500, -50, -1000),
    ["Mushgrove Swamp"] = Vector3.new(2500, 5, -700),
    ["Snowcap Island"] = Vector3.new(2600, 5, 2400),
    ["Keepers Altar"] = Vector3.new(1350, -100, -550),
    ["Desolate Deep"] = Vector3.new(-1500, -200, -2500)
}

for Name, Coord in pairs(Destinasi) do
    TeleSec:Button({
        Title = "Go to " .. Name,
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Coord)
            WindUI:Notify({Title = "Teleport", Content = "Berhasil ke " .. Name, Duration = 2})
        end
    })
end

-- --- TAB: PLAYER ---
local PlayerSec = PlayerTab:Section({ Title = "Movement" })
PlayerSec:Slider({ Title = "WalkSpeed", Min = 16, Max = 200, Default = 16, Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end })

-- 3. INSTANT ENGINE
task.spawn(function()
    local net = game:GetService("ReplicatedStorage"):WaitForChild("Packages")._Index["sleitnick_net@0.2.0"].net
    while true do
        if Config.AutoFish then
            pcall(function()
                net["RF/ChargeFishingRod"]:InvokeServer(workspace:GetServerTimeNow())
                task.wait(0.2)
                net["RF/RequestFishingMinigameStarted"]:InvokeServer(-0.75, 1)
                task.wait(Config.Delay)
                net["RE/FishingCompleted"]:FireServer()
            end)
        end
        task.wait(1.0)
    end
end)

WindUI:Init()
