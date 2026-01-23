local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- [ SERVICES & REMOTES ]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
local finishRemote = net:WaitForChild("RE/FishingCompleted")
local buyWeatherRemote = net:WaitForChild("RF/PurchaseWeather")

-- [ STATE ]
local fishMode = { Instant = false, Blatant = false, Legit = false }
local autoBuyWeather = false
local blatantDelay = "0.42"

-- [ WINDOW CREATION ]
local Window = WindUI:CreateWindow({
    Title = "Slinger Hub | VIP V7",
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
    Content = "Sangat Cepat - High Risk",
    Callback = function(v) fishMode.Instant = v end
})

FishSection:Toggle({
    Title = "Blatant Mode",
    Content = "Gunakan Delay di Bawah",
    Callback = function(v) fishMode.Blatant = v end
})

FishSection:Toggle({
    Title = "Legit Mode",
    Content = "Aman & Manusiawi",
    Callback = function(v) fishMode.Legit = v end
})

FishSection:Input({
    Title = "Blatant Delay",
    Placeholder = "0.42",
    Callback = function(v) blatantDelay = v end
})

-- [ AUTOMATICALLY SECTION ]
local AutoShopSection = AutoTab:Section({ Title = "Shop Features", Icon = "shopping-cart" })

AutoShopSection:Toggle({
    Title = "Auto Buy Weather",
    Content = "Otomatis beli cuaca Meteor",
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
        
        -- Auto Buy Weather (Meteor)
        if autoBuyWeather then
            pcall(function() buyWeatherRemote:InvokeServer("Meteor") end)
            task.wait(10)
        end
    end
end)

-- [ TELEPORT SECTION ]
local TPSection = TeleportTab:Section({ Title = "Islands", Icon = "map" })
local locations = {["Weather Machine"] = Vector3.new(-1471,-3,1929), ["Tropical Grove"] = Vector3.new(-2038,3,3650)}

for name, pos in pairs(locations) do
    TPSection:Button({
        Title = "Teleport " .. name,
        Callback = function() 
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos) 
        end
    })
end

WindUI:Notify({ Title = "Slinger Hub", Content = "Menu Loaded! Chloe Style Active.", Duration = 5 })
