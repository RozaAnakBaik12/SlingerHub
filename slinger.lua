--[[
    SLINGERHUB - STEALTH OWNER EDITION
    Bypass: Anti-Rank Stealth V6
    UI: Kavo Library (Ultra Light & Stable for Mobile)
--]]

-- ====== [1] STEALTH BYPASS (DIJAMIN TIDAK TERDETEKSI) ======
pcall(function()
    local LP = game:GetService("Players").LocalPlayer
    
    -- Mengunci fungsi Kick agar tidak bisa dipanggil oleh game
    local function disableKick()
        LP.Kick = function() return nil end
    end
    disableKick()
    LP.CharacterAdded:Connect(disableKick)

    -- Memblokir sinyal Destruct tanpa menggunakan hookmetamethod yang berat
    local raw = getrawmetatable(game)
    setreadonly(raw, false)
    local old = raw.__namecall
    raw.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or tostring(self):find("Destruct") then
            return nil
        end
        return old(self, ...)
    end)
end)

-- ====== [2] LIGHTWEIGHT UI (KAVO) ======
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("SlingerHub | Team eyeGPT", "Midnight")

-- CONFIG
local Config = {
    AutoFish = false,
    FishingMode = "Instant",
    CompleteDelay = 0.42,
    CancelDelay = 0.3,
    InstantDelay = 0.65,
    SpamPower = 40
}

-- ====== [3] TABS SETUP (IDENTIK PAHAJI) ======
local Main = Window:NewTab("Main")
local Exclusive = Window:NewTab("Exclusive")
local Teleport = Window:NewTab("Teleport")

-- --- TAB: MAIN ---
local MainSection = Main:NewSection("Automation")
MainSection:NewToggle("Auto Fishing", "Mulai memancing otomatis", function(v)
    Config.AutoFish = v
end)

-- --- TAB: EXCLUSIVE (PAHAJI STYLE) ---
local ExSection = Exclusive:NewSection("Ultra Blatant V3 & Instant")
ExSection:NewDropdown("Mode Selection", "Pilih mode pancing", {"Legit", "Instant", "Ultra Blatant V3"}, function(v)
    Config.FishingMode = v
end)

ExSection:NewTextBox("Instant Delay", "Default: 0.65", function(v)
    Config.InstantDelay = tonumber(v) or 0.65
end)

ExSection:NewTextBox("Complete Delay", "Default: 0.42", function(v)
    Config.CompleteDelay = tonumber(v) or 0.42
end)

-- --- TAB: TELEPORT ---
local TeleSection = Teleport:NewSection("Locations")
TeleSection:NewButton("Keepers Altar", "Teleport ke Altar", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1350, -100, -550)
end)

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
                
                if Config.FishingMode == "Legit" then task.wait(2.5)
                elseif Config.FishingMode == "Instant" then task.wait(Config.InstantDelay)
                else task.wait(Config.CompleteDelay) end
                
                if Config.FishingMode == "Ultra Blatant V3" then
                    for i = 1, Config.SpamPower do Events.fishing:FireServer() end
                else
                    Events.fishing:FireServer()
                end
