local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- [ RE-CHECK SERVICES ]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
-- Pakai pcall supaya kalau jalurnya salah, menu tetap muncul gak macet
local finishRemote = net:FindFirstChild("RE/FishingCompleted")
local buyWeatherRemote = net:FindFirstChild("RF/PurchaseWeather")

-- [ STATE ]
local fishMode = { Instant = false, Blatant = false, Legit = false }
local autoBuyWeather = false
local blatantDelay = "0.42"

-- [ WINDOW CREATION ]
local Window = WindUI:CreateWindow({
    Title = "SLINGER HUB | VIP V8",
    Icon = "fish",
    Author = "Chloe X Style",
    Folder = "SlingerHub",
    Size = UDim2.fromOffset(600, 450),
    Theme = "Indigo",
    KeySystem = false
})

-- [ TABS SESUAI CHLOE X ]
local FishingTab = Window:Tab({ Title = "Fishing", Icon = "fish" })
local AutoTab = Window:Tab({ Title = "Automatically", Icon = "refresh-cw" })
local TradingTab = Window:Tab({ Title = "Trading", Icon = "users" })
local MenuTab = Window:Tab({ Title = "Menu", Icon = "layout" })
local QuestTab = Window:Tab({ Title = "Quest", Icon = "scroll" })
local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map-pin" })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "user-cog" })

-- [ FISHING SECTION ]
local FishSection = FishingTab:Section({ Title = "Fishing Features", Icon = "anchor" })

FishSection:Toggle({
    Title = "Instant Fishing",
    Content = "Sangat Cepat - Kilat",
    Callback = function(v) fishMode.Instant = v end
})

FishSection:Toggle({
    Title = "Blatant Mode",
    Content = "Atur Delay di Bawah",
    Callback = function(v) fishMode.Blatant = v end
})

FishSection:Toggle({
    Title = "Legit Mode",
    Content = "Aman & Slow",
    Callback = function(v) fishMode.Legit = v end
})

FishSection:Input({
    Title = "Complete Delay",
    Placeholder = "0.42",
    Callback = function(v) blatantDelay = v end
})

-- [ AUTOMATICALLY SECTION ]
local AutoShopSection = AutoTab:Section({ Title = "Shop Features", Icon = "shopping-cart" })

AutoShopSection:Toggle({
    Title = "Auto Buy Weather",
    Content = "Otomatis beli Meteor",
    Callback = function(v) autoBuyWeather = v end
})

AutoShopSection:Toggle({
    Title = "Auto Sell All",
    Content = "Jual setiap 60 detik",
    Callback = function(v) _G.AutoSell = v end
})

-- [ LOGIC EXECUTION ]
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

-- Auto Buy Weather Logic
task.spawn(function()
    while task.wait(5) do
        if autoBuyWeather and buyWeatherRemote then
            pcall(function() buyWeatherRemote:InvokeServer("Meteor") end)
        end
    end
end)

WindUI:Notify({ Title = "Slinger Hub", Content = "Menu Berhasil Dimuat!", Duration = 5 })
