local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- [ SERVICES & REMOTES ]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
local finishRemote = net:WaitForChild("RE/FishingCompleted")
local buyWeatherRemote = net:WaitForChild("RF/PurchaseWeather") -- Remote untuk beli cuaca

-- [ STATE ]
local fishMode = { Instant = false, Blatant = false, Legit = false }
local autoBuyWeather = false
local blatantDelay = "0.42"

-- [ WINDOW CREATION ]
local Window = WindUI:CreateWindow({
    Title = "Slinger Hub | VIP",
    Icon = "fish",
    Author = "Chloe X Style",
    Folder = "SlingerHub",
    Size = UDim2.fromOffset(600, 450),
    Theme = "Indigo",
    KeySystem = false
})

-- [ TABS CHLOE X STYLE ]
local FishingTab = Window:Tab({ Title = "Fishing", Icon = "fish" })
local AutoTab = Window:Tab({ Title = "Automatically", Icon = "refresh-cw" })
local TradingTab = Window:Tab({ Title = "Trading", Icon = "users" })
local MenuTab = Window:Tab({ Title = "Menu", Icon = "layout" })
local QuestTab = Window:Tab({ Title = "Quest", Icon = "scroll" })
local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map-pin" })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "user-cog" })

-- [ FISHING SECTION ]
local FishSection = FishingTab:Section({ Title = "Fishing Modes", Icon = "anchor" })

FishSection:Toggle({
    Title = "Instant Fishing",
    Content = "Sangat Cepat - High Risk",
    Callback = function(v) fishMode.Instant = v end
})

FishSection:Toggle({
    Title = "Blatant Mode",
    Content = "Setting Delay Manual",
    Callback = function(v) fishMode.Blatant = v end
})

FishSection:Toggle({
    Title = "Legit Mode",
    Content = "Delay Manusiawi (Aman)",
    Callback = function(v) fishMode.Legit = v end
})

FishSection:Input({
    Title = "Blatant Delay",
    Placeholder = "0.42",
    Callback = function(v) blatantDelay = v end
})

-- [ AUTOMATICALLY SECTION - SHOP FEATURES ]
local AutoShopSection = AutoTab:Section({ Title = "Shop Features", Icon = "shopping-cart" })

-- FITUR BARU: AUTO BUY WEATHER
AutoShopSection:Toggle({
    Title = "Auto Buy Weather",
    Content = "Otomatis beli cuaca jika tidak ada buff aktif",
    Callback = function(v)
        autoBuyWeather = v
    end
})

AutoShopSection:Toggle({
    Title = "Auto Sell All",
    Content = "Jual semua ikan setiap 60 detik",
    Callback = function(v)
        _G.AutoSell = v
    end
})

-- [ LOGIC EXECUTION ]
-- Logic Fishing
task.spawn(function()
    while task.wait() do
        pcall(function()
            if fishMode.Instant then
                finishRemote:FireServer()
                task.wait(0.01)
            elseif fishMode.Blatant then
                task.wait(tonumber(blatantDelay) or 0.42)
                finishRemote:FireServer()
            elseif fishMode.Legit then
                task.wait(math.random(2, 4))
                finishRemote:FireServer()
            end
        end)
    end
end)

-- Logic Auto Buy Weather & Auto Sell
task.spawn(function()
    while task.wait(5) do
        -- Auto Buy Weather
        if autoBuyWeather then
            pcall(function()
                -- Membeli cuaca 'Meteor' (Bisa diganti sesuai keinginan)
                buyWeatherRemote:InvokeServer("Meteor") 
            end)
        end
        
        -- Auto Sell
        if _G.AutoSell then
            pcall(function()
                net:WaitForChild("RF/SellAllItems"):InvokeServer()
            end)
            task.wait(55) -- Sisa waktu dari wait(5) di atas
        end
    end
end)

-- [ TELEPORT SECTION ]
local TPSection = TeleportTab:Section({ Title = "Islands", Icon = "map" })
local islandCoords = {["Weather Machine"] = Vector3.new(-1471,-3,1929), ["Tropical Grove"] = Vector3
