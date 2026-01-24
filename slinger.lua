--[[ 
    SLINGERHUB V5.2 - STABLE
    REMOVED: Rank Check (Anti Self-Destruct) & Animation Waiting (Fix Infinite Yield)
    KEPT: Auto Fish, Blatant Mode, Auto Sell, Teleport.
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-------------------------------------------
----- =======[ CORE SERVICES ] =======
-------------------------------------------
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Fix Infinite Yield: Ambil Network tanpa menunggu aset animasi
local net = nil
pcall(function()
    net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
end)

local state = { 
    AutoFish = false, 
    Blatant = false, 
    AutoSell = false 
}

-------------------------------------------
----- =======[ UI WINDOW ] =======
-------------------------------------------
local Window = Rayfield:CreateWindow({
    Name = "🎣 SlingerHub V5.2 | Stable",
    LoadingTitle = "Removing Error Modules...",
    ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("🏠 Main", 4483362458)
local TeleportTab = Window:CreateTab("🌍 Teleport", "map")

-------------------------------------------
----- =======[ FISHING LOGIC ] =======
-------------------------------------------
MainTab:CreateSection("Safe Fishing")

local function RunFishing()
    task.spawn(function()
        while state.AutoFish do
            pcall(function()
                -- Gunakan Remote langsung (Bypass Animasi yang bikin error)
                net["RE/EquipToolFromHotbar"]:FireServer(1)
                
                if state.Blatant then
                    -- Method Blatant (Double Cast - Cepat)
                    task.spawn(function()
                        net["RF/ChargeFishingRod"]:InvokeServer(tick())
                        net["RF/RequestFishingMinigameStarted"]:InvokeServer(1.28, 1)
                    end)
                    task.wait(0.1)
                    for i = 1, 3 do net["RE/FishingCompleted"]:FireServer() end
                else
                    -- Method Normal (Stabil)
                    net["RF/ChargeFishingRod"]:InvokeServer(tick())
                    net["RF/RequestFishingMinigameStarted"]:InvokeServer(1.2, 1)
                    task.wait(1.5)
                    net["RE/FishingCompleted"]:FireServer()
                end
            end)
            task.wait(0.5)
        end
    end)
end

MainTab:CreateToggle({
    Name = "🤖 Auto Fish",
    CurrentValue = false,
    Callback = function(v)
        state.AutoFish = v
        if v then RunFishing() end
    end
})

MainTab:CreateToggle({
    Name = "⚡ Blatant Mode",
    CurrentValue = false,
    Callback = function(v) state.Blatant = v end
})

-------------------------------------------
----- =======[ UTILITIES ] =======
-------------------------------------------
MainTab:CreateSection("Fast Utility")

MainTab:CreateToggle({
    Name = "💰 Auto Sell (30s)",
    Callback = function(v)
        state.AutoSell = v
        task.spawn(function()
            while state.AutoSell do
                pcall(function() net["RF/SellAllItems"]:InvokeServer() end)
                task.wait(30)
            end
        end)
    end
})

-------------------------------------------
----- =======[ TELEPORTS ] =======
-------------------------------------------
local LOCATIONS = {
	["Sisyphus Statue"] = CFrame.new(-3728, -135, -1012),
	["Esoteric Depths"] = CFrame.new(3248, -1301, 1403),
	["Coral Reefs"] = CFrame.new(-3114, 1, 2237)
}

for name, cf in pairs(LOCATIONS) do
    TeleportTab:CreateButton({
        Name = "🚀 Go to " .. name,
        Callback = function()
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = cf end
        end
    })
end

Rayfield:Notify({ Title = "SlingerHub", Content = "Error modules removed. Ready to fish!", Duration = 5 })
