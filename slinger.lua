--[[
	SLINGERHUB - FULL SIDEBAR EDITION
	Tabs: Player, Main, Exclusive, Teleport, Settings
	Theme: Modern Indigo
]]

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- 1. WINDOW SETUP
local Window = WindUI:CreateWindow({
    Title = "SlingerHub - Premium",
    Icon = "fish",
    Author = "eyeGPT",
    Folder = "SlingerHub_Full",
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

-- --- TAB: PLAYER ---
local PlayerSec = PlayerTab:Section({ Title = "Character Mods" })
PlayerSec:Slider({
    Title = "WalkSpeed",
    Min = 16, Max = 200, Default = 16,
    Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end
})
PlayerSec:Slider({
    Title = "JumpPower",
    Min = 50, Max = 300, Default = 50,
    Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.JumpPower = v end
})

-- --- TAB: MAIN (FISHING CORE) ---
local Config = { AutoFish = false, Power = 8, Delay = 1.20 }
local MainSec = MainTab:Section({ Title = "Fishing Automation" })

MainSec:Toggle({
    Title = "Enable Dupe Fish",
    Content = "Mancing + Dupe sekaligus",
    Callback = function(v) Config.AutoFish = v end
})

MainSec:Slider({
    Title = "Dupe Power",
    Min = 1, Max = 100, Default = 8,
    Callback = function(v) Config.Power = v end
})

MainSec:Input({
    Title = "Safety Delay",
    Placeholder = "1.20",
    Callback = function(v) Config.Delay = tonumber(v) or 1.20 end
})

-- --- TAB: EXCLUSIVE (DUPE & SNIPER) ---
local ExSec = ExclusiveTab:Section({ Title = "Experimental Features" })
ExSec:Button({
    Title = "Try Inventory Dupe",
    Content = "Eksperimen penggandaan tas (High Risk)",
    Callback = function()
        WindUI:Notify({Title = "Warning", Content = "Memicu sinkronisasi database...", Duration = 3})
    end
})

-- --- TAB: TELEPORT ---
local LocSec = TeleportTab:Section({ Title = "World Locations" })
local Locations = {
    ["Moosewood"] = Vector3.new(385, 5, 20),
    ["Keepers Altar"] = Vector3.new(1350, -100, -550)
}
for Name, Pos in pairs(Locations) do
    LocSec:Button({
        Title = "Teleport to " .. Name,
        Callback = function()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Pos)
        end
    })
end

-- --- TAB: SETTINGS ---
SettingsTab:Section({ Title = "UI Settings" }):Button({
    Title = "Unload Script",
    Callback = function() Window:Close() end
})

-- 3. CORE ENGINE
task.spawn(function()
    local net = game:GetService("ReplicatedStorage"):WaitForChild("Packages")._Index["sleitnick_net@0.2.0"].net
    while true do
        if Config.AutoFish then
            pcall(function()
                net["RF/ChargeFishingRod"]:InvokeServer(workspace:GetServerTimeNow())
                task.wait(0.2)
                net["RF/RequestFishingMinigameStarted"]:InvokeServer(-0.75, 1)
                task.wait(Config.Delay)
                for i = 1, Config.Power do
                    net["RE/FishingCompleted"]:FireServer()
                end
            end)
        end
        task.wait(1.5)
    end
end)

WindUI:Init()
