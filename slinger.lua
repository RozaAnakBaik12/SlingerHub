--[[
    SlingerHub V5.5 - WindUI Optimized
    - Main Tab: Blatant & Instant Fishing (Moved)
    - Teleport Tab: Island List & Dropdown Selector (New)
    - Anti-Error: No Rank Check & No Infinite Yield
]]

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-------------------------------------------
----- =======[ CORE SERVICES ] =======
-------------------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

local net = nil
pcall(function()
    net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
end)

local state = { 
    AutoFish = false, 
    Blatant = false,
    InstantReel = false,
    AutoSell = false
}

-------------------------------------------
----- =======[ UI WINDOW ] =======
-------------------------------------------
local Window = WindUI:CreateWindow({
    Title = "SlingerHub V5.5",
    Icon = "anchor",
    Author = "SlingerDev",
    Folder = "SlingerHub_V5_5",
    Size = UDim2.fromOffset(580, 420),
    Theme = "Rose",
    KeySystem = false
})

local MainTab = Window:Tab({ Title = "Main", Icon = "zap" })
local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map" })
local UtilityTab = Window:Tab({ Title = "Utility", Icon = "wrench" })

-------------------------------------------
----- =======[ MAIN: BLATANT & INSTANT ] =======
-------------------------------------------
local MainSection = MainTab:Section({ Title = "Fishing Engine", Icon = "fish" })

local function StartFishing()
    task.spawn(function()
        while state.AutoFish do
            pcall(function()
                net["RE/EquipToolFromHotbar"]:FireServer(1)
                
                if state.Blatant then
                    -- BLATANT METHOD: Double Casting
                    task.spawn(function()
                        net["RF/ChargeFishingRod"]:InvokeServer(tick())
                        net["RF/RequestFishingMinigameStarted"]:InvokeServer(1.28, 1)
                    end)
                    task.wait(0.05)
                    task.spawn(function()
                        net["RF/ChargeFishingRod"]:InvokeServer(tick())
                        net["RF/RequestFishingMinigameStarted"]:InvokeServer(1.28, 1)
                    end)
                    task.wait(0.85) 
                    for i = 1, 5 do net["RE/FishingCompleted"]:FireServer() end
                else
                    -- NORMAL / INSTANT
                    net["RF/ChargeFishingRod"]:InvokeServer(tick())
                    net["RF/RequestFishingMinigameStarted"]:InvokeServer(1.2, 1)
                    if state.InstantReel then task.wait(0.5) else task.wait(2.2) end
                    net["RE/FishingCompleted"]:FireServer()
                end
            end)
            task.wait(0.2)
        end
    end)
end

MainSection:Toggle({
    Title = "Auto Fish (Fixed)",
    Callback = function(v)
        state.AutoFish = v
        if v then StartFishing() end
    end
})

MainSection:Toggle({
    Title = "⚡ Blatant Mode",
    Callback = function(v) state.Blatant = v end
})

MainSection:Toggle({
    Title = "🎯 Instant Fishing",
    Callback = function(v) state.InstantReel = v end
})

-------------------------------------------
----- =======[ TELEPORT: ISLAND & ROLLING ] =======
-------------------------------------------
local IslandSection = TeleportTab:Section({ Title = "Island Locations", Icon = "navigation" })

local locations = {
    ["Spawn / Starter"] = CFrame.new(45, 252, 2987),
    ["Sisyphus Statue"] = CFrame.new(-3728, -135, -1012),
    ["Esoteric Depths"] = CFrame.new(3248, -1301, 1403),
    ["Coral Reefs"] = CFrame.new(-3114, 1, 2237),
    ["Tropical Grove"] = CFrame.new(-2038, 3, 3650),
    ["Weather Machine"] = CFrame.new(-1488, 83, 1876),
    ["Ancient Jungle"] = CFrame.new(1831, 6, -299)
}

-- Buat list nama untuk dropdown
local locationNames = {}
for name, _ in pairs(locations) do table.insert(locationNames, name) end

-- Fitur Rolling / Dropdown Teleport
IslandSection:Dropdown({
    Title = "Select Island (Rolling)",
    Values = locationNames,
    Callback = function(selected)
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and locations[selected] then
            hrp.CFrame = locations[selected]
            WindUI:Notify({Title = "Teleport", Content = "Arrived at " .. selected})
        end
    end
})

-- Tombol Cepat di bawahnya
IslandSection:Button({
    Title = "Teleport to Spawn (Quick)",
    Callback = function()
        LocalPlayer.Character.HumanoidRootPart.CFrame = locations["Spawn / Starter"]
    end
})

-------------------------------------------
----- =======[ UTILITY ] =======
-------------------------------------------
local UtilSection = UtilityTab:Section({ Title = "Extra Tools", Icon = "star" })

UtilSection:Toggle({
    Title = "Auto Sell All (60s)",
    Callback = function(v)
        state.AutoSell = v
        task.spawn(function()
            while state.AutoSell do
                pcall(function() net["RF/SellAllItems"]:InvokeServer() end)
                task.wait(60)
            end
        end)
    end
})

-- Anti-AFK (Bypass Idle)
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

WindUI:Notify({Title = "SlingerHub", Content = "V5.5 Loaded! Teleport Dropdown Ready."})
