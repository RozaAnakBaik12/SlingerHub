--[[
    SLINGERHUB - GOD-BYPASS WITH UI
    UI: Orion Modern (Pahaji Style)
    Protection: Anti-Self Destruct V4 (Root Locked)
--]]

-- ====== [1] EMERGENCY ROOT BYPASS (AGAR TIDAK MELEDAK) ======
pcall(function()
    local LP = game:GetService("Players").LocalPlayer
    -- Mematikan fungsi Kick dari akar
    hookfunction(LP.Kick, function() return nil end)
    
    local oldNC
    oldNC = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        -- Blokir deteksi rank dan self-destruct
        if method == "Kick" or tostring(self):find("Destruct") or tostring(self):find("Rank") then 
            return nil 
        end
        return oldNC(self, ...)
    end)
end)

-- ====== [2] MODERN UI INITIALIZATION ======
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "SlingerHub | eyeGPT SUPREME", 
    HidePremium = false, 
    SaveConfig = false, 
    IntroText = "God-Bypass UI Active"
})

-- CONFIG
local Config = {
    AutoFish = false,
    FishingMode = "Instant",
    CompleteDelay = 0.42,
    CancelDelay = 0.3,
    InstantDelay = 0.65,
    SpamPower = 45
}

-- ====== [3] TABS (PAHAJI STYLE) ======
local MainTab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998"})
local ExclusiveTab = Window:MakeTab({Name = "Exclusive", Icon = "rbxassetid://4483345998"})
local PlayerTab = Window:MakeTab({Name = "Players", Icon = "rbxassetid://4483345998"})
local TeleportTab = Window:MakeTab({Name = "Teleport", Icon = "rbxassetid://4483345998"})

-- --- TAB: MAIN ---
MainTab:AddToggle({
    Name = "Auto Fishing",
    Default = false,
    Callback = function(v) Config.AutoFish = v end
})

-- --- TAB: EXCLUSIVE (Ultra Blatant V3 & Legit/Instant) ---
ExclusiveTab:AddSection({Name = "Mode Selection"})
ExclusiveTab:AddDropdown({
    Name = "Fishing Mode",
    Default = "Instant",
    Options = {"Legit", "Instant", "Ultra Blatant V3"},
    Callback = function(v) Config.FishingMode = v end
})

ExclusiveTab:AddSection({Name = "Delay Settings"})
ExclusiveTab:AddTextbox({
    Name = "Instant Delay",
    Default = "0.65",
    Callback = function(v) Config.InstantDelay = tonumber(v) end
})
ExclusiveTab:AddTextbox({
    Name = "Complete Delay",
    Default = "0.42",
    Callback = function(v) Config.CompleteDelay = tonumber(v) end
})
ExclusiveTab:AddTextbox({
    Name = "Cancel Delay",
    Default = "0.3",
    Callback = function(v) Config.CancelDelay = tonumber(v) end
})

-- --- TAB: TELEPORT ---
TeleportTab:AddButton({
    Name = "Keepers Altar",
    Callback = function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1350, -100, -550) end
})

-- ====== [4] LOGIC ENGINE ======
task.spawn(function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local net = ReplicatedStorage:WaitForChild("Packages")._Index["sleitnick_net@0.2.0"].net
    local Events = {
        fishing = net:WaitForChild("RE/FishingCompleted"),
        charge = net:WaitForChild("RF/ChargeFishingRod"),
        minigame = net:WaitForChild("RF/RequestFishingMinigameStarted")
    }

    while true do
        if Config.AutoFish then
            pcall(function()
                Events.charge:InvokeServer(1755848498.4834)
                Events.minigame:InvokeServer(1.2854545116425, 1)
                
                if Config.FishingMode == "Legit" then task.wait(2.5)
                elseif Config.FishingMode == "Instant" then task.wait(Config.InstantDelay)
                else task.wait(Config.CompleteDelay) end
                
                if Config.FishingMode == "Ultra Blatant V3" then
                    for i = 1, Config.SpamPower do Events.fishing:FireServer() end
                else
                    Events.fishing:FireServer()
                end
            end)
        end
        task.wait(Config.CancelDelay)
    end
end)

OrionLib:Init()
