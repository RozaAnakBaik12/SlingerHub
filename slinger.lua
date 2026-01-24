--[[
    SLINGERHUB V6.1 - BLUE EDITION (FULL UPDATE)
    - UI: WindUI (Theme: Blue)
    - New Tab: Shop (Auto Sell, Auto Buy Weather)
    - Updated Tab: Teleport (Save & Reset Position, Island Rolling)
    - Tab Main: Blatant, Instant Fishing, Auto Fish
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
    AutoSell = false,
    AutoBuyWeather = false,
    SavedPos = nil
}

-------------------------------------------
----- =======[ UI WINDOW ] =======
-------------------------------------------
local Window = WindUI:CreateWindow({
    Title = "SlingerHub V6.1",
    Icon = "shopping-cart",
    Author = "SlingerDev",
    Folder = "SlingerHub_V6_1",
    Size = UDim2.fromOffset(580, 420),
    Theme = "Blue"
})

local MainTab = Window:Tab({ Title = "Main", Icon = "zap" })
local ShopTab = Window:Tab({ Title = "Shop", Icon = "shopping-bag" })
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

MainSection:Toggle({ Title = "Auto Fish", Callback = function(v) state.AutoFish = v if v then StartFishing() end end })
MainSection:Toggle({ Title = "⚡ Blatant Mode", Callback = function(v) state.Blatant = v end })
MainSection:Toggle({ Title = "🎯 Instant Fishing", Callback = function(v) state.InstantReel = v end })

-------------------------------------------
----- =======[ SHOP: SELL & WEATHER ] =======
-------------------------------------------
local ShopSection = ShopTab:Section({ Title = "Store & Economy", Icon = "dollar-sign" })

ShopSection:Toggle({
    Title = "Auto Sell All (60s)",
    Callback = function(v)
        state.AutoSell = v
        task.spawn(function()
            while state.AutoSell do
                if net then pcall(function() net["RF/SellAllItems"]:InvokeServer() end) end
                task.wait(60)
            end
        end)
    end
})

ShopSection:Toggle({
    Title = "Auto Buy Weather",
    Callback = function(v)
        state.AutoBuyWeather = v
        task.spawn(function()
            while state.AutoBuyWeather do
                -- Menggunakan Remote untuk merubah cuaca/beli item cuaca jika tersedia
                if net then pcall(function() net["RF/PurchaseWeather"]:InvokeServer("Rain", 1) end) end
                task.wait(30)
            end
        end)
    end
})

-------------------------------------------
----- =======[ TELEPORT: PRO POSITION ] =======
-------------------------------------------
local PosSection = TeleportTab:Section({ Title = "Position Manager", Icon = "map-pin" })

PosSection:Button({
    Title = "Save Current Position",
    Callback = function()
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            state.SavedPos = hrp.CFrame
            WindUI:Notify({Title = "Position Saved", Content = "Your current spot has been recorded."})
        end
    end
})

PosSection:Button({
    Title = "Teleport to Saved Position",
    Callback = function()
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp and state.SavedPos then
            hrp.CFrame = state.SavedPos
        else
            WindUI:Notify({Title = "Error", Content = "No position saved!"})
        end
    end
})

PosSection:Button({
    Title = "Reset Position (To Spawn)",
    Callback = function()
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(45, 252, 2987) -- Posisi Spawn Default
        end
    end
})

local IslandSection = TeleportTab:Section({ Title = "Island Rolling", Icon = "navigation" })
local locations = {
    ["Spawn Island"] = CFrame.new(45, 252, 2987),
    ["Sisyphus Statue"] = CFrame.new(-3728, -135, -1012),
    ["Esoteric Depths"] = CFrame.new(3248, -1301, 1403),
    ["Coral Reefs"] = CFrame.new(-3114, 1, 2237)
}
local
