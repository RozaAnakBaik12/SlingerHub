--[[
    SLINGERHUB - ULTIMATE ANTI-DESTRUCT
    Security: Deep-Kernel Bypass V5 (Anti-Rank Check)
    UI: Orion Library Modern
--]]

-- ====== [1] EMERGENCY BYPASS (WAJIB JALAN PERTAMA) ======
pcall(function()
    local LP = game:GetService("Players").LocalPlayer
    
    -- Mematikan fungsi Kick secara total
    hookfunction(LP.Kick, function() return nil end)
    
    -- Memblokir semua komunikasi remote yang memicu 'Self Destruct'
    local oldNC
    oldNC = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if method == "Kick" or tostring(self):find("Destruct") or tostring(self):find("Rank") then
            warn("👁️ eyeGPT: Upaya deteksi diblokir!")
            return nil
        end
        return oldNC(self, unpack(args))
    end)
    
    -- Mencegah Error Logging
    game:GetService("ScriptContext").Error:Connect(function() return end)
end)

-- ====== [2] MODERN UI INITIALIZATION (ORION) ======
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "SlingerHub | eyeGPT SUPREME", 
    HidePremium = false, 
    SaveConfig = false, 
    IntroText = "System Secured - Welcome Owner"
})

-- CONFIG
local Config = {
    AutoFish = false,
    FishingMode = "Instant",
    CompleteDelay = 0.42,
    CancelDelay = 0.3,
    InstantDelay = 0.65,
    SpamPower = 40
}

-- ====== [3] TABS SETUP (PAHAJI STYLE) ======
local MainTab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998"})
local PlayerTab = Window:MakeTab({Name = "Players", Icon = "rbxassetid://4483345998"})
local ExclusiveTab = Window:MakeTab({Name = "Exclusive", Icon = "rbxassetid://4483345998"})
local TeleportTab = Window:MakeTab({Name = "Teleport", Icon = "rbxassetid://4483345998"})

-- --- TAB: MAIN ---
MainTab:AddSection({Name = "Automation"})
MainTab:AddToggle({
    Name = "Auto Fishing",
    Default = false,
    Callback = function(v) Config.AutoFish = v end
})

-- --- TAB: EXCLUSIVE (INSTANT & BLATANT) ---
ExclusiveTab:AddSection({Name = "Fishing Modes"})
ExclusiveTab:AddDropdown({
    Name = "Mode Selection",
    Default = "Instant",
    Options = {"Legit", "Instant", "Ultra Blatant V3"},
    Callback = function(v) Config.FishingMode = v end
})

ExclusiveTab:AddSection({Name = "Mode Settings"})
ExclusiveTab:AddTextbox({
    Name = "Instant Fishing Delay",
    Default = "0.65",
    Callback = function(v) Config.InstantDelay = tonumber(v) or 0.65 end
})
ExclusiveTab:AddTextbox({
    Name = "Complete Delay (Blatant)",
    Default = "0.42",
    Callback = function(v) Config.CompleteDelay = tonumber(v) or 0.42 end
})

-- --- TAB: TELEPORT ---
TeleportTab:AddButton({
    Name = "Keepers Altar",
    Callback = function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1350, -100, -550) end
})

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
                
                -- Penentuan Delay
                if Config.FishingMode == "Legit" then 
                    task.wait(2.5)
                elseif Config.FishingMode == "Instant" then 
                    task.wait(Config.InstantDelay)
                else 
                    task.wait(Config.CompleteDelay) 
                end
                
                -- Eksekusi Tangkap
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
