--[[ 
    SLINGERHUB REBORN - ANTI-SELF DESTRUCT V100
    Security: Deep Hook & Rank-Spoofer
    UI: Lucide Modern (Minimalist Stealth)
--]]

-- [1] EMERGENCY BYPASS (WAJIB PALING ATAS)
pcall(function()
    local LP = game:GetService("Players").LocalPlayer
    -- Matikan fungsi Kick permanen
    LP.Kick = function() return nil end
    hookfunction(LP.Kick, function() return nil end)
    
    -- Blokir Rank-Check & Destruct Remote
    local oldNC
    oldNC = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or tostring(self):find("Destruct") or tostring(self):find("Rank") then
            return nil
        end
        return oldNC(self, ...)
    end)
end)

-- [2] MODERN UI INITIALIZATION
local Lucide = loadstring(game:HttpGet("https://raw.githubusercontent.com/skidvape/Lucide/main/Lucide.lua"))()
local Window = Lucide:CreateWindow({
    Name = "SlingerHub | eyeGPT",
    Description = "Supreme Owner Edition",
    TabsWidth = 120
})

-- CONFIG
local Config = {
    AutoFish = false,
    FishMode = "Instant",
    CompDelay = 0.42,
    InstDelay = 0.65,
    CanDelay = 0.3,
    Spam = 45
}

-- [3] TABS SETUP (Identik Pahaji)
local Main = Window:CreateTab("Main")
local Exclusive = Window:CreateTab("Exclusive")
local Teleport = Window:CreateTab("Teleport")

-- TAB: MAIN
Main:CreateToggle("Auto Fishing", "Mulai pancing otomatis", false, function(v) Config.AutoFish = v end)
Main:CreateToggle("Auto Equip", "Otomatis pegang rod", true, function(v) _G.Equip = v end)

-- TAB: EXCLUSIVE (INSTANT & BLATANT)
Exclusive:CreateSection("Fishing Modes")
Exclusive:CreateDropdown("Mode", "Pilih Mode", {"Legit", "Instant", "Ultra Blatant V3"}, function(v) Config.FishMode = v end)

Exclusive:CreateSection("Delay Settings")
Exclusive:CreateSlider("Instant Delay", 0.1, 2, 0.65, function(v) Config.InstDelay = v end)
Exclusive:CreateSlider("Complete Delay", 0.1, 1, 0.42, function(v) Config.CompDelay = v end)
Exclusive:CreateSlider("Cancel Delay", 0.1, 1, 0.3, function(v) Config.CanDelay = v end)

-- TAB: TELEPORT
Teleport:CreateButton("Keepers Altar", function() 
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1350, -100, -550) 
end)

-- [4] STABLE ENGINE
task.spawn(function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local net = ReplicatedStorage:WaitForChild("Packages", 30)._Index["sleitnick_net@0.2.0"].net
    local RE = {
        fish = net:WaitForChild("RE/FishingCompleted"),
        rod = net:WaitForChild("RF/ChargeFishingRod"),
        game = net:WaitForChild("RF/RequestFishingMinigameStarted")
    }

    while true do
        if Config.AutoFish then
            pcall(function()
                RE.rod:InvokeServer(1755848498.4834)
                RE.game:InvokeServer(1.2854545116425, 1)
                
                -- Penentuan Jeda
                if Config.FishMode == "Legit" then task.wait(2.5)
                elseif Config.FishMode == "Instant" then task.wait(Config.InstDelay)
                else task.wait(Config.CompDelay) end
                
                -- Eksekusi Tangkap
                if Config.FishMode == "Ultra Blatant V3" then
                    for i = 1, Config.Spam do RE.fish:FireServer() end
                else
                    RE.fish:FireServer()
                end
            end)
        end
        task.wait(Config.CanDelay)
    end
end)
