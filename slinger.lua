--[[
    SLINGERHUB V5.9 - STABLE BYPASS
    - FIX: Menghapus Total Modul "Self-Destruct" (Rank Check)
    - FIX: Menghapus Tunggu Animasi (Anti Infinite Yield/Mesh Error)
    - UI: WindUI (Main & Teleport Menu)
]]

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-------------------------------------------
----- =======[ CORE BYPASS ] =======
-------------------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

-- Ambil Network langsung tanpa pengecekan ribet
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
    Title = "SlingerHub V5.9",
    Icon = "anchor",
    Author = "SlingerDev",
    Folder = "SlingerHub_Fixed_Final",
    Size = UDim2.fromOffset(580, 420),
    Theme = "Rose"
})

local MainTab = Window:Tab({ Title = "Main", Icon = "zap" })
local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map" })

-------------------------------------------
----- =======[ MAIN: FISHING ENGINE ] =======
-------------------------------------------
local MainSection = MainTab:Section({ Title = "Automation", Icon = "fish" })

local function StartFishing()
    task.spawn(function()
        while state.AutoFish do
            pcall(function()
                if net then
                    net["RE/EquipToolFromHotbar"]:FireServer(1)
                    
                    if state.Blatant then
                        -- BLATANT: Double Cast (Melempar 2 Kail)
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
    Title = "⚡ Blatant Mode",
    Callback = function(v) state.Blatant = v end
})

MainSection:Toggle({
    Title = "🎯 Instant Fishing",
    Callback = function(v) state.InstantReel = v end
})

-------------------------------------------
----- =======[ TELEPORT: ISLAND SELECTION ] =======
-------------------------------------------
local IslandSection = TeleportTab:Section({ Title = "Island Teleports", Icon = "navigation" })

local locations = {
    ["Spawn Island"] = CFrame.new(45, 252, 2987),
    ["Sisyphus Statue"] = CFrame.new(-3728, -135, -1012),
    ["Esoteric Depths"] = CFrame.new(3248, -1301, 1403),
    ["Coral Reefs"] = CFrame.new(-3114, 1, 2237),
    ["Tropical Grove"] = CFrame.new(-2038, 3, 3650)
}

local locationNames = {}
for name, _ in pairs(locations) do table.insert(locationNames, name) end

IslandSection:Dropdown({
    Title = "Select Island (Rolling)",
    Values = locationNames,
    Callback = function(selected)
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and locations[selected] then
            hrp.CFrame = locations[selected]
        end
    end
})

-- Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

WindUI:Notify({Title = "SlingerHub V5.9", Content = "Bypass Berhasil! Rank check dihapus."})
