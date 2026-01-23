local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- [ SERVICES ]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
local finishRemote = net:WaitForChild("RE/FishingCompleted")

-- [ STATE ]
local fishMode = { Instant = false, Blatant = false, Legit = false }
local blatantDelay = "0.42"

-- [ WINDOW ]
local Window = WindUI:CreateWindow({
    Title = "Slinger Hub | VIP",
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

-- [ FISHING TAB - FITUR TERPISAH ]
local FishSection = FishingTab:Section({ Title = "Fishing Features", Icon = "anchor" })

FishSection:Toggle({
    Title = "Instant Fishing",
    Content = "Mode Paling Cepat",
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

-- [ LOGIC FISHING ]
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

-- [ AUTOMATICALLY TAB ]
local AutoSection = AutoTab:Section({ Title = "Shop Features", Icon = "shopping-cart" })
AutoSection:Toggle({
    Title = "Auto Sell All",
    Content = "Otomatis jual setiap 60 detik",
    Callback = function(v)
        _G.AutoSell = v
        task.spawn(function()
            while _G.AutoSell do
                net:WaitForChild("RF/SellAllItems"):InvokeServer()
                task.wait(60)
            end
        end)
    end
})

-- [ TELEPORT TAB ]
local TPSection = TeleportTab:Section({ Title = "Islands", Icon = "map" })
local islandCoords = {["Weather Machine"] = Vector3.new(-1471,-3,1929), ["Tropical Grove"] = Vector3.new(-2038,3,3650)}

for name, pos in pairs(islandCoords) do
    TPSection:Button({
        Title = "Teleport " .. name,
        Callback = function() 
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos) 
        end
    })
end

-- [ SETTINGS ]
local SetSection = SettingsTab:Section({ Title = "System", Icon = "cpu" })
SetSection:Button({ Title = "Unlock FPS", Callback = function() setfpscap(999) end })
SetSection:Button({ Title = "Boost FPS", Callback = function() 
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
    end
end})
