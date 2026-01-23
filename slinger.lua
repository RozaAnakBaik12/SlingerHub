local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- [ FIX SERVICES & REMOTES ]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = game:GetService("Players").LocalPlayer
local net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")

-- [ GLOBAL STATE ]
local state = {
    Instant = false,
    Blatant = false,
    Legit = false,
    AutoSell = false,
    AutoBuyWeather = false,
    SelectedWeather = "Meteor",
    Delay = "0.42"
}

-- [ WINDOW CREATION - CHLOE X STYLE ]
local Window = WindUI:CreateWindow({
    Title = "SLINGER HUB | V15 FINAL",
    Icon = "fish",
    Author = "Chloe X Style",
    Folder = "SlingerHub",
    Size = UDim2.fromOffset(600, 450),
    Theme = "Indigo",
    KeySystem = false
})

-- [ TABS - SESUAI VIDEO CHLOE X ]
local FishingTab = Window:Tab({ Title = "Fishing", Icon = "fish" })
local AutoTab = Window:Tab({ Title = "Automatically", Icon = "refresh-cw" })
local TradingTab = Window:Tab({ Title = "Trading", Icon = "users" })
local MenuTab = Window:Tab({ Title = "Menu", Icon = "layout" })
local QuestTab = Window:Tab({ Title = "Quest", Icon = "scroll" })
local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map-pin" })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "user-cog" })

-- [ FISHING SECTION ]
local FishSection = FishingTab:Section({ Title = "Fishing Features", Icon = "anchor" })

FishSection:Toggle({ Title = "Instant Fishing", Callback = function(v) state.Instant = v end })
FishSection:Toggle({ Title = "Blatant Mode", Callback = function(v) state.Blatant = v end })
FishSection:Input({ Title = "Complete Delay", Placeholder = "0.42", Callback = function(v) state.Delay = v end })

-- [ AUTOMATICALLY - AUTO SELL & MERCHANT ]
local AutoSection = AutoTab:Section({ Title = "Automation", Icon = "shopping-cart" })

AutoSection:Toggle({ Title = "Auto Sell All", Callback = function(v) state.AutoSell = v end })
AutoSection:Toggle({ Title = "Auto Buy Weather", Callback = function(v) state.AutoBuyWeather = v end })
AutoSection:Dropdown({
    Title = "Weather Type",
    Options = {"Meteor", "Rain", "Fog", "Windy", "Clear"},
    Callback = function(v) state.SelectedWeather = v end
})

-- [ TELEPORT - MERCHANT ]
local TPSection = TeleportTab:Section({ Title = "Utility", Icon = "map" })
TPSection:Button({
    Title = "Teleport to Merchant",
    Callback = function()
        local merchant = workspace:FindFirstChild("Merchant") or workspace:FindFirstChild("Travelling Merchant")
        if merchant then
            LocalPlayer.Character.HumanoidRootPart.CFrame = merchant.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
        end
    end
})

-- [ LOGIC UTAMA: INSTANT FISHING & AUTO PULL ]
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            
            -- Otomatis lempar pancing jika tidak sedang memancing
            if (state.Instant or state.Blatant) and not char:FindFirstChild("FishingRod") then
                local tool = LocalPlayer.Backpack:FindFirstChild("FishingRod") or char:FindFirstChild("FishingRod")
                if tool then
                    char.Humanoid:EquipTool(tool)
                    task.wait(0.2)
                    net:FindFirstChild("RF/ChargeFishingRod"):InvokeServer()
                    task.wait(0.1)
                    net:FindFirstChild("RE/CastFishingRod"):FireServer(100)
                end
            end
        end)
    end
end)

-- Deteksi "!" dan Tarik Ikan
local ReplicateText = net:FindFirstChild("RE/ReplicateTextEffect")
if ReplicateText then
    ReplicateText.OnClientEvent:Connect(function(data)
        if (state.Instant or state.Blatant) and data.TextData and data.TextData.EffectType == "Exclaim" then
            if data.Container == LocalPlayer.Character:FindFirstChild("Head") then
                task.spawn(function()
                    if state.Instant then task.wait(0.01) else task.wait(tonumber(state.Delay) or 0.42) end
                    net:FindFirstChild("RE/FishingCompleted"):FireServer()
                end)
            end
        end
    end)
end

-- Logic Auto Sell & Weather
task.spawn(function()
    while task.wait(5) do
        if state.AutoSell then pcall(function() net:FindFirstChild("RF/SellAllItems"):InvokeServer() end) end
        if state.AutoBuyWeather then pcall(function() net:FindFirstChild("RF/PurchaseWeather"):InvokeServer(state.SelectedWeather) end) end
    end
end)

WindUI:Notify({ Title = "Slinger Hub", Content = "V15 LENGKAP & FIX!", Duration = 5 })
