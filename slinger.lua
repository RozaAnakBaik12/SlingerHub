local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- [ SERVICES & REMOTES ]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")

-- [ STATE & CONFIG ]
local fishMode = { Instant = false, Blatant = false, Legit = false }
local autoBuyWeather = false
local selectedWeather = "Meteor"
local blatantDelay = "0.42"
local autoSellEnabled = false

-- [ WINDOW CREATION - CHLOE X STYLE ]
local Window = WindUI:CreateWindow({
    Title = "SLINGER HUB | V13 VIP",
    Icon = "fish",
    Author = "Chloe X Style",
    Folder = "SlingerHub",
    Size = UDim2.fromOffset(600, 450),
    Theme = "Indigo",
    KeySystem = false
})

-- [ TABS SESUAI CHLOE X - TIDAK ADA YANG DIHAPUS ]
local FishingTab = Window:Tab({ Title = "Fishing", Icon = "fish" })
local AutoTab = Window:Tab({ Title = "Automatically", Icon = "refresh-cw" })
local TradingTab = Window:Tab({ Title = "Trading", Icon = "users" })
local MenuTab = Window:Tab({ Title = "Menu", Icon = "layout" })
local QuestTab = Window:Tab({ Title = "Quest", Icon = "scroll" })
local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map-pin" })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "user-cog" })

-- [ TAB FISHING - FITUR TERPISAH ]
local FishSection = FishingTab:Section({ Title = "Fishing Features", Icon = "anchor" })

FishSection:Toggle({ Title = "Instant Fishing", Content = "Auto Pull Instan", Callback = function(v) fishMode.Instant = v end })
FishSection:Toggle({ Title = "Blatant Mode", Content = "Delay Sesuai Input", Callback = function(v) fishMode.Blatant = v end })
FishSection:Toggle({ Title = "Legit Mode", Content = "Main Aman", Callback = function(v) fishMode.Legit = v end })
FishSection:Input({ Title = "Complete Delay", Placeholder = "0.42", Callback = function(v) blatantDelay = v end })

-- [ TAB AUTOMATICALLY - SHOP & WEATHER ]
local AutoSection = AutoTab:Section({ Title = "Shop Features", Icon = "shopping-cart" })

AutoSection:Toggle({ Title = "Auto Sell All", Content = "Jual Ikan Otomatis", Callback = function(v) autoSellEnabled = v end })
AutoSection:Toggle({ Title = "Auto Buy Weather", Content = "Beli Cuaca Pilihan", Callback = function(v) autoBuyWeather = v end })
AutoSection:Dropdown({
    Title = "Select Weather",
    Options = {"Meteor", "Rain", "Fog", "Windy", "Clear"},
    Default = "Meteor",
    Callback = function(v) selectedWeather = v end
})

-- [ TAB TELEPORT - MERCHANT ]
local TPSection = TeleportTab:Section({ Title = "Teleport Utility", Icon = "map" })

TPSection:Button({
    Title = "Teleport to Merchant",
    Content = "Cari Travelling Merchant",
    Callback = function()
        local merchant = workspace:FindFirstChild("Merchant") or workspace:FindFirstChild("Travelling Merchant")
        if merchant and merchant.PrimaryPart then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = merchant.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
        else
            WindUI:Notify({ Title = "Not Found", Content = "Merchant belum muncul!", Duration = 3 })
        end
    end
})

-- [ LOGIC EXECUTION - ANTI MACET ]
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

task.spawn(function()
    while task.wait(5) do
        if autoSellEnabled then pcall(function() net:FindFirstChild("RF/SellAllItems"):InvokeServer() end) end
        if autoBuyWeather then pcall(function() net:FindFirstChild("RF/PurchaseWeather"):InvokeServer(selectedWeather) end) end
    end
end)

WindUI:Notify({ Title = "Slinger Hub", Content = "V13 Loaded! Semua Fitur Aman.", Duration = 5 })
