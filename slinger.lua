--[[
    SLINGERHUB V6.9 - FIXED BYPASS EDITION
    - UI: WindUI (Biru)
    - Tab Main: Blatant Rolling (Safe, Fast, Brutal), Auto Fish, Instant
    - Tab Shop: Auto Sell All, Auto Buy Weather
    - Tab Teleport: Save/Reset Position & Island Rolling
    - FIX: Menghapus Total Modul "Self Destruct" yang bikin error merah
]]

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

-- Ambil Network langsung tanpa cek Rank (Bypass Keamanan)
local net = nil
pcall(function() net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net end)

local state = { 
    AutoFish = false, 
    BlatantLevel = "Safe", 
    InstantReel = false,
    AutoSell = false,
    AutoBuyWeather = false,
    SavedPos = nil
}

-------------------------------------------
----- =======[ FISHING ENGINE ] =======
-------------------------------------------
local function StartFishing()
    task.spawn(function()
        while state.AutoFish do
            pcall(function()
                if net then
                    net["RE/EquipToolFromHotbar"]:FireServer(1)
                    
                    if state.BlatantLevel == "Brutal" then
                        -- TRIPLE CAST (Paling Cepat)
                        for i = 1, 3 do
                            task.spawn(function()
                                net["RF/ChargeFishingRod"]:InvokeServer(tick())
                                net["RF/RequestFishingMinigameStarted"]:InvokeServer(1.28, 1)
                            end)
                        end
                        task.wait(0.65)
                        for i = 1, 10 do net["RE/FishingCompleted"]:FireServer() end
                    elseif state.BlatantLevel == "Fast" then
                        -- DOUBLE CAST (Cepat)
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
                        -- SAFE MODE
                        net["RF/ChargeFishingRod"]:InvokeServer(tick())
                        net["RF/RequestFishingMinigameStarted"]:InvokeServer(1.2, 1)
                        if state.InstantReel then task.wait(0.4) else task.wait(2.2) end
                        net["RE/FishingCompleted"]:FireServer()
                    end
                end
            end)
            task.wait(0.1)
        end
    end)
end

-------------------------------------------
----- =======[ UI SETUP (BLUE) ] =======
-------------------------------------------
local Window = WindUI:CreateWindow({
    Title = "SlingerHub V6.9 | NO ERROR",
    Icon = "zap",
    Author = "SlingerDev",
    Folder = "SlingerHub_Fixed_Final",
    Size = UDim2.fromOffset(580, 420),
    Theme = "Blue"
})

local MainTab = Window:Tab({ Title = "Main", Icon = "zap" })
local ShopTab = Window:Tab({ Title = "Shop", Icon = "shopping-bag" })
local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map" })

-- TAB MAIN
local MainSection = MainTab:Section({ Title = "Fishing Control" })
MainSection:Toggle({ Title = "Auto Fish", Callback = function(v) state.AutoFish = v if v then StartFishing() end end })
MainSection:Dropdown({ Title = "Blatant Mode (Rolling)", Values = {"Safe", "Fast", "Brutal"}, Callback = function(v) state.BlatantLevel = v end })
MainSection:Toggle({ Title = "Instant Fishing", Callback = function(v) state.InstantReel = v end })

-- TAB SHOP
local ShopSection = ShopTab:Section({ Title = "Economy" })
ShopSection:Toggle({ Title = "Auto Sell (60s)", Callback = function(v) 
    state.AutoSell = v 
    task.spawn(function()
        while state.AutoSell do
            if net then pcall(function() net["RF/SellAllItems"]:InvokeServer() end) end
            task.wait(60)
        end
    end)
end })
ShopSection:Toggle({ Title = "Auto Buy Weather", Callback = function(v) 
    state.AutoBuyWeather = v 
    task.spawn(function()
        while state.AutoBuyWeather do
            if net then pcall(function() net["RF/PurchaseWeather"]:InvokeServer("Rain", 1) end) end
            task.wait(30)
        end
    end)
end })

-- TAB TELEPORT
local PosSection = TeleportTab:Section({ Title = "Position Manager" })
PosSection:Button({ Title = "Save Position", Callback = function() state.SavedPos = LocalPlayer.Character.HumanoidRootPart.CFrame end })
PosSection:Button({ Title = "TP Saved Position", Callback = function() if state.SavedPos then LocalPlayer.Character.HumanoidRootPart.CFrame = state.SavedPos end end })
PosSection:Button({ Title = "Reset Position", Callback = function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(45, 252, 2987) end })

local IslandSection = TeleportTab:Section({ Title = "Island Rolling" })
local locs = {["Spawn"] = CFrame.new(45, 252, 2987), ["Sisyphus"] = CFrame.new(-3728, -135, -1012), ["Esoteric"] = CFrame.new(3248, -1301, 1403)}
local names = {}; for n,_ in pairs(locs) do table.insert(names, n) end
IslandSection:Dropdown({ Title = "Select Island", Values = names, Callback = function(s) LocalPlayer.Character.HumanoidRootPart.CFrame = locs[s] end })

-- Anti-AFK
LocalPlayer.Idled:Connect(function() VirtualUser:CaptureController() VirtualUser:ClickButton2(Vector2.new()) end)

WindUI:Notify({Title = "SlingerHub V6.9", Content = "Semua Error 'Self-Destruct' Berhasil Dibuang!"})
