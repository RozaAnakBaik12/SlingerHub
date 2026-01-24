--[[
    SlingerHub - GOD MODE EDITION
    Status: Owner Mode / Anti-Self Destruct / DNS Fixed
    Authorized: ArgaaaAi
--]]

-- ====== BAGIAN 1: ANTI-SELF DESTRUCT (WAJIB DI ATAS) ======
pcall(function()
    local oldHook
    oldHook = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" then
            warn("👁️ eyeGPT: Melindungi Owner dari upaya Kick/Self-Destruct.")
            return nil
        end
        return oldHook(self, ...)
    end)
    
    -- Anti-Crash & Asset Fixer
    game:GetService("ContentProvider").PreloadAsync = function() return end
    settings().Rendering.QualityLevel = 1
end)

-- ====== BAGIAN 2: UI & CONFIG ======
local WindUI = loadstring(game:HttpGet("https://tree-hub.vercel.app/api/UI/WindUI"))()
local Window = WindUI:CreateWindow({
    Title = "SlingerHub 👁️ [GOD MODE]",
    Icon = "rbxassetid://10723343321",
    Author = "ArgaaaAi",
    Folder = "SlingerHub_GodMode"
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = {
    AutoFish = false,
    BlatantMode = false,
    SpamPower = 30,
    FishDelay = 0.35,
    AutoSell = false
}

local net = ReplicatedStorage:WaitForChild("Packages", 15)._Index["sleitnick_net@0.2.0"].net
local Events = {
    fishing = net:WaitForChild("RE/FishingCompleted"),
    sell = net:WaitForChild("RF/SellAllItems"),
    charge = net:WaitForChild("RF/ChargeFishingRod"),
    minigame = net:WaitForChild("RF/RequestFishingMinigameStarted"),
    equip = net:WaitForChild("RE/EquipToolFromHotbar")
}

-- ====== BAGIAN 3: ENGINE ======
local function runBlatant()
    pcall(function()
        Events.equip:FireServer(1)
        task.spawn(function()
            Events.charge:InvokeServer(1755848498.4834)
            task.wait(0.01)
            Events.minigame:InvokeServer(1.2854545116425, 1)
        end)
        task.wait(Config.FishDelay)
        for i = 1, Config.SpamPower do
            Events.fishing:FireServer()
            task.wait(0.01)
        end
    end)
end

-- ====== BAGIAN 4: UI TABS ======
local MainTab = Window:CreateTab({ Name = "Main Menu", Icon = "rbxassetid://10723343321" })

MainTab:AddSection("Master Control")

MainTab:AddToggle({
    Title = "Auto Fishing",
    Default = false,
    Callback = function(v) 
        Config.AutoFish = v 
        task.spawn(function()
            while Config.AutoFish do
                if Config.BlatantMode then runBlatant() else
                    pcall(function()
                        Events.equip:FireServer(1)
                        Events.charge:InvokeServer(1755848498.4834)
                        Events.minigame:InvokeServer(1.2854545116425, 1)
                        task.wait(1.5)
                        Events.fishing:FireServer()
                    end)
                end
                task.wait(0.1)
            end
        end)
    end
})

MainTab:AddToggle({
    Title = "Blatant Mode (Dangerous)",
    Default = false,
    Callback = function(v) Config.BlatantMode = v end
})

MainTab:AddSlider({
    Title = "Blatant Power",
    Min = 10, Max = 150, Default = 30,
    Callback = function(v) Config.SpamPower = v end
})

local ExtraTab = Window:CreateTab({ Name = "Extra", Icon = "rbxassetid://10709819149" })
ExtraTab:AddToggle({
    Title = "Auto Sell",
    Default = false,
    Callback = function(v)
        Config.AutoSell = v
        task.spawn(function()
            while Config.AutoSell do
                Events.sell:InvokeServer()
                task.wait(20)
            end
        end)
    end
})

Window:SelectTab(MainTab)

WindUI:Notify({
    Title = "SlingerHub Loaded",
    Content = "Sistem Pertahanan & Eksploitasi Aktif, Yang Mulia.",
    Duration = 5
})
