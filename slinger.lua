--[[
    SLINGERHUB - UNBREAKABLE EDITION
    Security: Anti-Tamper V4 (Root Bypass)
    UI: Orion Library
--]]

-- ====== [1] ROOT BYPASS (WAJIB PALING ATAS) ======
pcall(function()
    -- Mematikan fungsi Kick secara global
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local oldKick
    oldKick = hookfunction(LocalPlayer.Kick, function(self, ...)
        warn("👁️ eyeGPT: Upaya Self-Destruct/Kick telah DIMATIKAN secara paksa.")
        return nil
    end)
    
    -- Memblokir Remote Event penghancur diri
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" or tostring(self):find("Destruct") then
            return nil
        end
        return oldNamecall(self, ...)
    end)
    
    -- Membersihkan memori untuk mencegah deteksi
    setfflag("AbuseReportScreenshot", "False")
end)

-- ====== [2] INITIALIZE ORION UI ======
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "SlingerHub 👁️ | SUPREME", 
    HidePremium = false, 
    SaveConfig = false, 
    IntroText = "Authorized for Owner"
})

-- ====== [3] CONFIG & LOGIC ======
local Config = {
    AutoFish = false,
    FishingMode = "Legit",
    CompleteDelay = 0.42,
    CancelDelay = 0.3,
    SpamPower = 35
}

-- TABS (Identik dengan Pahaji Style)
local MainTab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998"})
local PlayerTab = Window:MakeTab({Name = "Players", Icon = "rbxassetid://4483345998"})
local ExclusiveTab = Window:MakeTab({Name = "Exclusive", Icon = "rbxassetid://4483345998"})

-- --- TAB: EXCLUSIVE (Fitur Utama Anda) ---
ExclusiveTab:AddSection({Name = "Ultra Blatant V3"})
ExclusiveTab:AddDropdown({
    Name = "Mode Selection",
    Default = "Legit",
    Options = {"Legit", "Instant", "Ultra Blatant V3"},
    Callback = function(v) Config.FishingMode = v end
})

ExclusiveTab:AddTextbox({
    Name = "Complete Delay",
    Default = "0.42",
    Callback = function(v) Config.CompleteDelay = tonumber(v) or 0.42 end
})

-- --- TAB: MAIN ---
MainTab:AddToggle({
    Name = "Auto Fishing",
    Default = false,
    Callback = function(v) Config.AutoFish = v end
})

-- ====== [4] MESIN PANCING ======
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
