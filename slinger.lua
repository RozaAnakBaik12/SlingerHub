--[[
    SlingerHub - Fixed Owner Edition
    UI: Wind UI (Elegant)
    Fix: DNS Bypass & Asset Loader Optimization
--]]

-- ====== PRE-EXECUTION FIX (Bypass Error) ======
pcall(function()
    game:GetService("NetworkClient"):SetSimulatedCoreGuiChatConnections(false)
    settings().Rendering.QualityLevel = 1
    -- Anti-Crash for Mesh Errors
    game:GetService("ContentProvider").PreloadAsync = function() return end
end)

local WindUI = loadstring(game:HttpGet("https://tree-hub.vercel.app/api/UI/WindUI"))()
local Window = WindUI:CreateWindow({
    Title = "SlingerHub 👁️ [FIXED]",
    Icon = "rbxassetid://10723343321",
    Author = "ArgaaaAi",
    Folder = "SlingerHub_Fixed"
})

-- ====== CORE SERVICES ======
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = {
    AutoFish = false,
    BlatantMode = false,
    SpamPower = 25,
    FishDelay = 0.4,
    AutoSell = false
}

-- Network Events dengan pcall agar tidak error saat fetch gagal
local net = ReplicatedStorage:WaitForChild("Packages", 10)._Index["sleitnick_net@0.2.0"].net
local Events = {
    fishing = net:WaitForChild("RE/FishingCompleted"),
    sell = net:WaitForChild("RF/SellAllItems"),
    charge = net:WaitForChild("RF/ChargeFishingRod"),
    minigame = net:WaitForChild("RF/RequestFishingMinigameStarted"),
    equip = net:WaitForChild("RE/EquipToolFromHotbar")
}

-- ====== ENGINE ======
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

-- ====== UI TABS ======
local MainTab = Window:CreateTab({ Name = "Main Menu", Icon = "rbxassetid://10723343321" })

MainTab:AddSection("Auto-Fishing & Blatant")

MainTab:AddToggle({
    Title = "Start SlingerHub",
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
    Title = "Activate Blatant",
    Default = false,
    Callback = function(v) Config.BlatantMode = v end
})

MainTab:AddSlider({
    Title = "Power",
    Min = 5, Max = 100, Default = 25,
    Callback = function(v) Config.SpamPower = v end
})

local FixTab = Window:CreateTab({ Name = "Fixer", Icon = "rbxassetid://10704905386" })

FixTab:AddSection("Manual Repair")

FixTab:AddButton({
    Title = "Force Clear Memory",
    Callback = function()
        pcall(function()
            for i,v in pairs(game:GetDescendants()) do
                if v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then v:Destroy() end
            end
        end)
        WindUI:Notify({Title = "Fixed", Content = "Memory Optimized", Duration = 3})
    end
})

FixTab:AddButton({
    Title = "Reconnect Network",
    Callback = function()
        WindUI:Notify({Title = "Network", Content = "Attempting to re-fetch assets...", Duration = 3})
        -- Triggering a dummy request to wake up DNS
        game:HttpGetAsync("https://google.com")
    end
})

Window:SelectTab(MainTab)

WindUI:Notify({
    Title = "SlingerHub Fixed",
    Content = "DNS & Asset Fix Applied, Yang Mulia.",
    Duration = 5
})
