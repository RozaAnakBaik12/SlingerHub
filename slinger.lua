--[[
    SlingerHub V5.3 - WindUI Edition (Clean & Stable)
    FIX: Anti Self-Destruct & Anti Infinite Yield
    REMOVED: Rank Check & Animation Assets Waiting
]]

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-------------------------------------------
----- =======[ CORE SERVICES ] =======
-------------------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

-- bypass network tanpa stuck (Fix Infinite Yield)
local net = nil
pcall(function()
    net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
end)

-- State Management
local state = { 
    AutoFish = false, 
    Blatant = false,
    AutoSell = false,
    AutoBuyBait = false,
    BaitType = "Worm"
}

-------------------------------------------
----- =======[ UI WINDOW ] =======
-------------------------------------------
local Window = WindUI:CreateWindow({
    Title = "SlingerHub V5.3",
    Icon = "anchor",
    Author = "SlingerDev",
    Folder = "SlingerHub_V5_Clean",
    Size = UDim2.fromOffset(580, 420),
    Theme = "Rose",
    KeySystem = false
})

local MainTab = Window:Tab({ Title = "Fishing", Icon = "fish" })
local UtilityTab = Window:Tab({ Title = "Utility", Icon = "wrench" })

-------------------------------------------
----- =======[ FISHING ENGINE ] =======
-------------------------------------------
local FishSection = MainTab:Section({ Title = "Automation", Icon = "cpu" })

local function RunSlingerFish()
    task.spawn(function()
        while state.AutoFish do
            pcall(function()
                -- Langsung tembak Remote (Bypass Animasi biang kerok error)
                net["RE/EquipToolFromHotbar"]:FireServer(1)
                
                if state.Blatant then
                    -- BLATANT METHOD (Double Cast)
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
                    for i = 1, 4 do net["RE/FishingCompleted"]:FireServer() end
                else
                    -- NORMAL METHOD
                    net["RF/ChargeFishingRod"]:InvokeServer(tick())
                    net["RF/RequestFishingMinigameStarted"]:InvokeServer(1.2, 1)
                    task.wait(1.5)
                    net["RE/FishingCompleted"]:FireServer()
                end
            end)
            task.wait(0.2)
        end
    end)
end

FishSection:Toggle({
    Title = "Enable Auto Fish",
    Callback = function(v)
        state.AutoFish = v
        if v then RunSlingerFish() end
    end
})

FishSection:Toggle({
    Title = "Blatant Mode (Fast)",
    Callback = function(v) state.Blatant = v end
})

-------------------------------------------
----- =======[ UTILITIES ] =======
-------------------------------------------
local ShopSection = UtilityTab:Section({ Title = "Shop & Items" })

ShopSection:Toggle({
    Title = "Auto Sell All (30s)",
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

ShopSection:Button({
    Title = "Teleport to Sisyphus Statue",
    Callback = function()
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = CFrame.new(-3728, -135, -1012) end
    end
})

-- Anti-AFK Force
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(0.5)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

WindUI:Notify({Title = "SlingerHub", Content = "UI Loaded! Rank Check & Error Assets Removed."})
