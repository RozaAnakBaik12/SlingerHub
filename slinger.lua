--[[
    SLINGERHUB - CHLOE-X STEALTH V9
    No-Hook Bypass (Mencegah Deteksi Rank/Self-Destruct)
    UI Style: Chloe X Organized
--]]

-- ====== [1] GHOST PROTECTOR (Tanpa Hooking) ======
pcall(function()
    -- Teknik menyembunyikan script dari pemindai game
    if getgenv().Executed then return end
    getgenv().Executed = true
    
    -- Mematikan fungsi Kick dengan cara menimpa (bukan hooking)
    local LP = game:GetService("Players").LocalPlayer
    LP.Kick = function(self, reason) 
        warn("👁️ eyeGPT: Mencoba Kick dengan alasan: " .. tostring(reason)) 
        return nil 
    end
end)

-- ====== [2] UI INITIALIZATION (ORION LIGHT) ======
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "SlingerHub | eyeGPT", 
    HidePremium = false, 
    SaveConfig = false, 
    IntroText = "Chloe Style v1.1.1"
})

-- CONFIG
local Config = {
    AutoFish = false,
    FishingMode = "Instant",
    CompleteDelay = 0.42,
    InstantDelay = 0.65,
    SpamV1 = 15,
    SpamV2 = 50
}

-- ====== [3] TABS SETUP (Sesuai Gambar 42713) ======
local FishingTab = Window:MakeTab({Name = "Fishing", Icon = "rbxassetid://4483345998"})
local AutoTab = Window:MakeTab({Name = "Automatically", Icon = "rbxassetid://4483345998"})
local TeleportTab = Window:MakeTab({Name = "Teleport", Icon = "rbxassetid://4483345998"})

-- --- TAB: FISHING (Organized Sections) ---

-- Section 1: Instant Features
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

-- Section 2: Blatant v1 Features
FishingTab:AddSection({Name = "--- Blatant v1 Features ---"})
FishingTab:AddToggle({
    Name = "Enable Blatant v1",
    Default = false,
    Callback = function(v) 
        Config.AutoFish = v 
        Config.FishingMode = "BlatantV1"
    end
})

-- Section 3: Blatant v2 Features (Ultra Blatant)
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

-- --- TAB: TELEPORT ---
TeleportTab:AddButton({
    Name = "Keepers Altar",
    Callback = function() 
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1350, -100, -550) 
    end
})

-- ====== [4] SILENT ENGINE ======
task.spawn(function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local net = ReplicatedStorage:WaitForChild("Packages", 30)._Index["sleitnick_net@0.2.0"].net
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
        task.wait(0.4) -- Jeda aman agar tidak spam deteksi
    end
end)

OrionLib:Init()
