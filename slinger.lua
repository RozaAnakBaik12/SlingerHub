local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-------------------------------------------
----- =======[ GLOBAL FUNCTION ] =======
-------------------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")

-- State Table (Gabungan Ziaan + Chloe)
local state = {
    Instant = false, Blatant = false, Legit = false,
    AutoSell = false, AutoFavourite = false, AutoBuyWeather = false,
    SelectedWeather = "Meteor", Delay = "0.42",
    PerfectCast = true, AutoFishV2 = false
}

-- Remotes
local rodRemote = net:WaitForChild("RF/ChargeFishingRod")
local miniGameRemote = net:WaitForChild("RF/RequestFishingMinigameStarted")
local finishRemote = net:WaitForChild("RE/FishingCompleted")

-------------------------------------------
----- =======[ LOAD WINDOW ] =======
-------------------------------------------
local Window = WindUI:CreateWindow({
    Title = "SLINGER x ZIAAN | VIP",
    Icon = "fish",
    Author = "Chloe Style - V16",
    Folder = "ZiaanHub",
    Size = UDim2.fromOffset(600, 450),
    Theme = "Indigo",
    KeySystem = false
})

-- TABS (Urutan Chloe X)
local FishingTab = Window:Tab({ Title = "Fishing", Icon = "fish" })
local AutoTab = Window:Tab({ Title = "Automatically", Icon = "refresh-cw" })
local TradingTab = Window:Tab({ Title = "Trading", Icon = "users" })
local MenuTab = Window:Tab({ Title = "Menu", Icon = "layout" })
local QuestTab = Window:Tab({ Title = "Quest", Icon = "scroll" })
local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map-pin" })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "user-cog" })

-------------------------------------------
----- =======[ FISHING TAB ] =======
-------------------------------------------
local FishSection = FishingTab:Section({ Title = "Fishing Modes", Icon = "anchor" })

FishSection:Toggle({ Title = "Instant Fishing", Callback = function(v) state.Instant = v end })
FishSection:Toggle({ Title = "Blatant Mode", Callback = function(v) state.Blatant = v end })
FishSection:Input({ Title = "Bypass Delay", Placeholder = "0.42", Callback = function(v) state.Delay = v end })

local ZiaanSection = FishingTab:Section({ Title = "Ziaan Logic (V2)", Icon = "cpu" })
ZiaanSection:Toggle({ Title = "Auto Fish V2 (Optimized)", Callback = function(v) state.AutoFishV2 = v end })
ZiaanSection:Toggle({ Title = "Auto Perfect Cast", Value = true, Callback = function(v) state.PerfectCast = v end })

-------------------------------------------
----- =======[ AUTOMATICALLY TAB ] =======
-------------------------------------------
local AutoSection = AutoTab:Section({ Title = "Automation", Icon = "shopping-cart" })

AutoSection:Toggle({ Title = "Auto Sell All", Callback = function(v) state.AutoSell = v end })
AutoSection:Toggle({ Title = "Auto Favourite (Legendary+)", Callback = function(v) state.AutoFavourite = v end })
AutoSection:Toggle({ Title = "Auto Buy Weather", Callback = function(v) state.AutoBuyWeather = v end })
AutoSection:Dropdown({
    Title = "Select Weather",
    Options = {"Meteor", "Rain", "Fog", "Windy", "Clear"},
    Callback = function(v) state.SelectedWeather = v end
})

-------------------------------------------
----- =======[ TELEPORT TAB ] =======
-------------------------------------------
local TPSection = TeleportTab:Section({ Title = "Quick Teleport", Icon = "map" })

local islandCoords = {
	["Weather Machine"] = Vector3.new(-1471, -3, 1929),
	["Tropical Grove"] = Vector3.new(-2038, 3, 3650),
	["Esoteric Depths"] = Vector3.new(3157, -1303, 1439)
}

for name, pos in pairs(islandCoords) do
    TPSection:Button({ Title = name, Callback = function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0,5,0)) end })
end

TPSection:Button({
    Title = "Teleport to Merchant",
    Callback = function()
        local merchant = workspace:FindFirstChild("Merchant") or workspace:FindFirstChild("Travelling Merchant")
        if merchant then LocalPlayer.Character.HumanoidRootPart.CFrame = merchant.PrimaryPart.CFrame + Vector3.new(0,5,0) end
    end
})

-------------------------------------------
----- =======[ LOGIC SYSTEM ] =======
-------------------------------------------

-- Logic Instant/Blatant
local ReplicateText = net:FindFirstChild("RE/ReplicateTextEffect")
if ReplicateText then
    ReplicateText.OnClientEvent:Connect(function(data)
        if (state.Instant or state.Blatant) and data.TextData and data.TextData.EffectType == "Exclaim" then
            if data.Container == LocalPlayer.Character:FindFirstChild("Head") then
                task.spawn(function()
                    if state.Instant then task.wait(0.01) else task.wait(tonumber(state.Delay) or 0.42) end
                    finishRemote:FireServer()
                end)
            end
        end
    end)
end

-- Logic Ziaan Auto Fish V2 & Auto Sell
task.spawn(function()
    while task.wait(1) do
        -- Auto Fish V2
        if state.AutoFishV2 then
            pcall(function()
                local char = LocalPlayer.Character
                if not char:FindFirstChild("FishingRod") then
                    net:WaitForChild("RE/EquipToolFromHotbar"):FireServer(1)
                end
                rodRemote:InvokeServer(workspace:GetServerTimeNow())
                task.wait(0.5)
                miniGameRemote:InvokeServer(0, 1)
            end)
        end
        
        -- Auto Sell
        if state.AutoSell then
            pcall(function() net:FindFirstChild("RF/SellAllItems"):InvokeServer() end)
        end
        
        -- Auto Buy Weather
        if state.AutoBuyWeather then
            pcall(function() net:FindFirstChild("RF/PurchaseWeather"):InvokeServer(state.SelectedWeather) end)
        end
    end
end)

-- FPS Boost (Ziaan Hub Original)
for _, v in pairs(game:GetDescendants()) do
    if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
end

WindUI:Notify({ Title = "ZiaanHub x Slinger", Content = "Script Loaded with Chloe Style!", Duration = 5 })
