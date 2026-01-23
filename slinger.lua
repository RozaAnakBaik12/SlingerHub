local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- [ SERVICES & REMOTES ]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")

-- [ WINDOW CREATION ]
local Window = WindUI:CreateWindow({
    Title = "SLINGER HUB | V12 MERCHANT",
    Icon = "fish",
    Author = "Chloe X Style",
    Folder = "SlingerHub",
    Size = UDim2.fromOffset(600, 450),
    Theme = "Indigo",
    KeySystem = false
})

-- [ TABS ]
local FishingTab = Window:Tab({ Title = "Fishing", Icon = "fish" })
local AutoTab = Window:Tab({ Title = "Automatically", Icon = "refresh-cw" })
local TradingTab = Window:Tab({ Title = "Trading", Icon = "users" })
local MenuTab = Window:Tab({ Title = "Menu", Icon = "layout" })
local QuestTab = Window:Tab({ Title = "Quest", Icon = "scroll" })
local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map-pin" })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "user-cog" })

-- [ FISHING - TETAP LENGKAP ]
local FishSection = FishingTab:Section({ Title = "Fishing Modes", Icon = "anchor" })
local fishMode = { Instant = false, Blatant = false, Legit = false }
local blatantDelay = "0.42"

FishSection:Toggle({ Title = "Instant Fishing", Callback = function(v) fishMode.Instant = v end })
FishSection:Toggle({ Title = "Blatant Mode", Callback = function(v) fishMode.Blatant = v end })
FishSection:Input({ Title = "Complete Delay", Placeholder = "0.42", Callback = function(v) blatantDelay = v end })

-- [ AUTOMATICALLY - LENGKAP + WEATHER ]
local AutoShopSection = AutoTab:Section({ Title = "Shop Features", Icon = "shopping-cart" })
local autoBuyWeather = false
local selectedWeather = "Meteor"

AutoShopSection:Toggle({ Title = "Auto Sell All", Callback = function(v) _G.AutoSell = v end })
AutoShopSection:Toggle({ Title = "Auto Buy Weather", Callback = function(v) autoBuyWeather = v end })
AutoShopSection:Dropdown({
    Title = "Select Weather",
    Options = {"Meteor", "Rain", "Fog", "Windy", "Clear"},
    Callback = function(v) selectedWeather = v end
})

-- [ TELEPORT - SEKARANG ADA MERCHANT ]
local MerchantSection = TeleportTab:Section({ Title = "Merchant Utility", Icon = "store" })

MerchantSection:Button({
    Title = "Teleport to Merchant",
    Content = "Langsung ke lokasi Merchant jika muncul",
    Callback = function()
        local merchant = workspace:FindFirstChild("Merchant") or workspace:FindFirstChild("Travelling Merchant")
        if merchant and merchant:FindFirstChild("HumanoidRootPart") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = merchant.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
            WindUI:Notify({ Title = "Success", Content = "Teleported to Merchant!", Duration = 3 })
        else
            WindUI:Notify({ Title = "Error", Content = "Merchant not found in this server!", Duration = 3 })
        end
    end
})

-- [ LOGIC EXECUTION ]
-- Logic Auto Fish
local ReplicateText = net:FindFirstChild("RE/ReplicateTextEffect")
if ReplicateText then
    ReplicateText.OnClientEvent:Connect(function(data)
        if (fishMode.Instant or fishMode.Blatant) and data and data.TextData and data.TextData.EffectType == "Exclaim" then
            if data.Container == game.Players.LocalPlayer.Character:FindFirstChild("Head") then
                task.spawn(function()
                    if fishMode.Instant then task.wait(0.01) else task.wait(tonumber(blatantDelay) or 0.42) end
                    net:FindFirstChild("RE/FishingCompleted"):FireServer()
                end)
            end
        end
    end)
end

-- Logic Auto Sell & Weather
task.spawn(function()
    while task.wait(5) do
        if _G.AutoSell then pcall(function() net:FindFirstChild("RF/SellAllItems"):InvokeServer() end) end
        if autoBuyWeather then pcall(function() net:FindFirstChild("RF/PurchaseWeather"):InvokeServer(selectedWeather) end) end
    end
end)
