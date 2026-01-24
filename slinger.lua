--[[
    SLINGERHUB V5.6 - THE FINAL STABLE VERSION
    - UI: WindUI (Rose Theme)
    - Tab Main: Blatant Mode, Instant Fishing, Auto Fish
    - Tab Teleport: Island Selection (Rolling/Dropdown) & Fast Buttons
    - Fixed: No Rank Check, No Self-Destruct, No Infinite Yield
]]

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-------------------------------------------
----- =======[ CORE SERVICES ] =======
-------------------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

-- Ambil Network tanpa resiko stuck/infinite yield
local net = nil
pcall(function()
    net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
end)

-- State Management
local state = { 
    AutoFish = false, 
    Blatant = false,
    InstantReel = false,
    AutoSell = false
}

-------------------------------------------
----- =======[ UI WINDOW SETUP ] =======
-------------------------------------------
local Window = WindUI:CreateWindow({
    Title = "SlingerHub V5.6",
    Icon = "anchor",
    Author = "SlingerDev",
    Folder = "SlingerHub_V5_6",
    Size = UDim2.fromOffset(580, 420),
    Theme = "Rose",
    KeySystem = false
})

local MainTab = Window:Tab({ Title = "Main", Icon = "zap" })
local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map" })
local UtilityTab = Window:Tab({ Title = "Utility", Icon = "wrench" })

-------------------------------------------
----- =======[ MAIN: FISHING ENGINE ] =======
-------------------------------------------
local MainSection = MainTab:Section({ Title = "Fishing Automation", Icon = "fish" })

local function StartFishing()
    task.spawn(function()
        while state.AutoFish do
            pcall(function()
                -- Pastikan Rod ter-equip di Slot 1
                net["RE/EquipToolFromHotbar"]:FireServer(1)
                
                if state.Blatant then
                    -- METODE BLATANT: Double Cast (Melempar 2 kail sekaligus)
                    task.spawn(function()
                        net["RF/ChargeFishingRod"]:InvokeServer(tick())
                        net["RF/RequestFishingMinigameStarted"]:InvokeServer(1.28, 1)
                    end)
                    task.wait(0.05)
                    task.spawn(function()
                        net["RF/ChargeFishingRod"]:InvokeServer(tick())
                        net["RF/RequestFishingMinigameStarted"]:InvokeServer(1.28, 1)
                    end)
                    -- Delay gigitan dipangkas habis
                    task.wait(0.85) 
                    -- Spam Reel agar Instan Catch
                    for i = 1, 5 do net["RE/FishingCompleted"]:FireServer() end
                else
                    -- METODE NORMAL / INSTANT REEL
                    net["RF/ChargeFishingRod"]:InvokeServer(tick())
                    net["RF/RequestFishingMinigameStarted"]:InvokeServer(1.2, 1)
                    
                    if state.InstantReel then
                        task.wait(0.5) -- Tarik instan setelah 0.5 detik
                    else
                        task.wait(2.5) -- Tunggu normal
                    end
                    net["RE/FishingCompleted"]:FireServer()
                end
            end)
            task.wait(0.2)
        end
    end)
end

MainSection:Toggle({
    Title = "Auto Fish",
    Callback = function(v)
        state.AutoFish = v
        if v then StartFishing() end
    end
})

MainSection:Toggle({
    Title = "⚡ Blatant Mode (Brutal)",
    Callback = function(v) state.Blatant = v end
})

MainSection:Toggle({
    Title = "🎯 Instant Fishing (No Minigame)",
    Callback = function(v) state.InstantReel = v end
})

-------------------------------------------
----- =======[ TELEPORT: ISLAND & ROLLING ] =======
-------------------------------------------
local IslandSection = TeleportTab:Section({ Title = "Island Teleports", Icon = "navigation" })

local locations = {
    ["Spawn Island"] = CFrame.new(45, 252, 2987),
    ["Sisyphus Statue"] = CFrame.new(-3728, -135, -1012),
    ["Esoteric Depths"] = CFrame.new(3248, -1301, 1403),
    ["Coral Reefs"] = CFrame.new(-3114, 1, 2237),
    ["Tropical Grove"] = CFrame.new(-2038, 3, 3650),
    ["Weather Machine"] = CFrame.new(-1488, 83, 1876),
    ["Ancient Jungle"] = CFrame.new(1831, 6, -299)
}

-- List untuk Dropdown (Rolling)
local locationNames = {}
for name, _ in pairs(locations) do table.insert(locationNames, name) end

IslandSection:Dropdown({
    Title = "Select Island (Rolling Menu)",
    Values = locationNames,
    Callback = function(selected)
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and locations[selected] then
            hrp.CFrame = locations[selected]
            WindUI:Notify({Title = "Slinger Teleport", Content = "Moved to " .. selected})
        end
    end
})

-- Tambahkan tombol cepat untuk pulau populer di bawah rolling menu
IslandSection:Button({
    Title = "Quick TP: Sisyphus Statue",
    Callback = function()
        LocalPlayer.Character.HumanoidRootPart.CFrame = locations["Sisyphus Statue"]
    end
})

IslandSection:Button({
    Title = "Quick TP: Esoteric Depths",
    Callback = function()
        LocalPlayer.Character.HumanoidRootPart.CFrame = locations["Esoteric Depths"]
    end
})

-------------------------------------------
----- =======[ UTILITY & ANTI-AFK ] =======
-------------------------------------------
local UtilSection = UtilityTab:Section({ Title = "Extra Utilities", Icon = "star" })

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

-- Sistem Anti-AFK (Agar tidak kena Kick saat AFK Memancing)
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

WindUI:Notify({Title = "SlingerHub V5.6", Content = "Fitur Lengkap & Menu Rapi Telah Dimuat!"})
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
