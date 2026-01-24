--[[
    SlingerHub - SUPREME OWNER EDITION
    Status: FULL FEATURES / ANTI-CRASH / BLATANT
    Authorized by: ArgaaaAi
--]]

-- 1. ULTIMATE BYPASS (Melindungi dari Kick & Self-Destruct)
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" then return nil end
        return old(self, ...)
    end)
    game:GetService("ContentProvider").PreloadAsync = function() return end
end)

-- 2. LIBRARY LOADING (Kavo - Lebih Ringan untuk Mobile)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("SlingerHub 👁️", "GrapeTheme")

-- 3. CONFIG & EVENTS
local Config = {AutoFish = false, Blatant = false, Power = 20, Delay = 0.4, AutoSell = false}
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local net = ReplicatedStorage:WaitForChild("Packages", 20)._Index["sleitnick_net@0.2.0"].net
local Events = {
    fishing = net:WaitForChild("RE/FishingCompleted"),
    charge = net:WaitForChild("RF/ChargeFishingRod"),
    minigame = net:WaitForChild("RF/RequestFishingMinigameStarted"),
    equip = net:WaitForChild("RE/EquipToolFromHotbar"),
    sell = net:WaitForChild("RF/SellAllItems")
}

-- 4. MAIN TAB
local Main = Window:NewTab("Main")
local Section = Main:NewSection("Master Fishing")

Section:NewToggle("Auto Fishing", "Mulai memancing otomatis", function(v)
    Config.AutoFish = v
    task.spawn(function()
        while Config.AutoFish do
            pcall(function()
                Events.equip:FireServer(1)
                task.spawn(function()
                    Events.charge:InvokeServer(1755848498.4834)
                    task.wait(0.01)
                    Events.minigame:InvokeServer(1.2854545116425, 1)
                end)
                task.wait(Config.Delay)
                local loop = Config.Blatant and Config.Power or 1
                for i = 1, loop do
                    Events.fishing:FireServer()
                    if Config.Blatant then task.wait(0.01) end
                end
            end)
            task.wait(0.1)
        end
    end)
end)

Section:NewToggle("Blatant Mode", "Kecepatan brutal", function(v)
    Config.Blatant = v
end)

Section:NewSlider("Blatant Power", "Jumlah spam reel", 150, 10, function(v)
    Config.Power = v
end)

Section:NewSlider("Bite Delay", "Kecepatan ikan gigit", 2, 0, function(v)
    Config.Delay = v
end)

-- 5. WORLD & MISC TAB
local World = Window:NewTab("Misc")
local MSection = World:NewSection("Utility")

MSection:NewToggle("Auto Sell All", "Jual ikan otomatis", function(v)
    Config.AutoSell = v
    task.spawn(function()
        while Config.AutoSell do
            Events.sell:InvokeServer()
            task.wait(20)
        end
    end)
end)

MSection:NewButton("Instant Sell", "Jual sekarang", function()
    Events.sell:InvokeServer()
end)

MSection:NewButton("FPS Optimizer", "Mengurangi lag", function()
    settings().Rendering.QualityLevel = 1
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
            v.Material = Enum.Material.SmoothPlastic
        end
    end
end)

print("SlingerHub Full Loaded!")
