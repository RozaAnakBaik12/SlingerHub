--[[
    SLINGERHUB - CHLOE-STYLE UI
    UI: Orion Library (Sub-Menu Organized)
    Security: Stealth Bypass V8 (Anti-Self Destruct)
--]]

-- ====== [1] STEALTH BYPASS (Mencegah Self-Destruct) ======
pcall(function()
    local LP = game:GetService("Players").LocalPlayer
    -- Mematikan fungsi Kick tanpa memicu deteksi hook berat
    LP.Kick = function() return nil end
    
    local oldNC
    oldNC = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or tostring(self):find("Destruct") then 
            return nil 
        end
        return oldNC(self, ...)
    end)
end)

-- ====== [2] UI INITIALIZATION ======
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "SlingerHub | eyeGPT", HidePremium = false, SaveConfig = false, IntroText = "Chloe Style Loaded"})

-- CONFIG
local Config = {
    AutoFish = false,
    FishingMode = "Legit",
    CompleteDelay = 0.42,
    InstantDelay = 0.65,
    SpamV1 = 15,
    SpamV2 = 45
}

-- ====== [3] TABS SETUP (Sesuai Gambar 42713) ======
local InfoTab = Window:MakeTab({Name = "Info", Icon = "rbxassetid://4483345998"})
local FishingTab = Window:MakeTab({Name = "Fishing", Icon = "rbxassetid://4483345998"})
local AutoTab = Window:MakeTab({Name = "Automatically", Icon = "rbxassetid://4483345998"})

-- --- TAB: FISHING (Sub-Menu Separated) ---

-- Section: Instant Features
FishingTab:AddSection({Name = "--- Instant Features ---"})
FishingTab:AddToggle({
    Name = "Instant Fishing",
    Default = false,
    Callback = function(v) 
        Config.AutoFish = v 
        Config.FishingMode = "Instant"
    end
})
FishingTab:AddTextbox({
    Name = "Instant Delay",
    Default = "0.65",
    Callback = function(v) Config.InstantDelay = tonumber(v) or 0.65 end
})

-- Section: Blatant v1 Features
FishingTab:AddSection({Name = "--- Blatant v1 Features ---"})
FishingTab:AddToggle({
    Name = "Enable Blatant v1",
    Default = false,
    Callback = function(v) 
        Config.AutoFish = v 
        Config.FishingMode = "BlatantV1"
    end
})

-- Section: Blatant v2 Features (Ultra Blatant)
FishingTab:AddSection({Name = "--- Blatant v2 Features ---"})
FishingTab:AddToggle({
    Name = "Enable Blatant v2 (Ultra)",
    Default = false,
    Callback = function(v) 
        Config.AutoFish = v 
        Config.FishingMode = "BlatantV2"
    end
})
FishingTab:AddTextbox({
    Name = "Complete Delay",
    Default = "0.42",
    Callback = function(v) Config.CompleteDelay = tonumber(v) or 0.42 end
})

-- --- TAB: AUTOMATICALLY ---
AutoTab:AddSection({Name = "General Automation"})
AutoTab:AddToggle({Name = "Auto Sell Features", Default = false, Callback = function(v) _G.AutoSell = v end})

-- ====== [4] CORE ENGINE ======
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
                
                -- Delay Logic
                if Config.FishingMode == "Instant" then 
                    task.wait(Config.InstantDelay)
                    Events.fishing:FireServer()
                elseif Config.FishingMode == "BlatantV1" then
                    task.wait(Config.CompleteDelay)
                    for i = 1, Config.SpamV1 do Events.fishing:FireServer() end
                elseif Config.FishingMode == "BlatantV2" then
                    task.wait(Config.CompleteDelay)
                    for i = 1, Config.SpamV2 do Events.fishing:FireServer() end
                end
            end)
        end
        task.wait(0.3)
    end
end)

OrionLib:Init()
