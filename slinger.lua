--[[
    SLINGERHUB - ORION MODERN EDITION
    UI: Orion Library (Minimalist & Stable)
    Status: Supreme Owner / Anti-Self Destruct
--]]

-- ====== [1] ANTI-KICK & SELF DESTRUCT BYPASS ======
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" then 
            warn("👁️ eyeGPT: Blocked attempt to kick the Owner.")
            return nil 
        end
        return old(self, ...)
    end)
end)

-- ====== [2] INITIALIZE ORION UI ======
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({
    Name = "SlingerHub | Team eyeGPT", 
    HidePremium = false, 
    SaveConfig = true, 
    ConfigFolder = "SlingerHub_Orion"
})

-- ====== [3] CONFIGURATION ======
local Config = {
    AutoFish = false,
    AutoEquip = true,
    FishingMode = "Legit",
    CompleteDelay = 0.42,
    InstantDelay = 0.65,
    CancelDelay = 0.3,
    LegitWait = 2.5,
    SpamPower = 35,
    AutoSell = false
}

-- ====== [4] TABS SETUP (Pahaji Hub Style) ======
local MainTab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998"})
local PlayerTab = Window:MakeTab({Name = "Players", Icon = "rbxassetid://4483345998"})
local ExclusiveTab = Window:MakeTab({Name = "Exclusive", Icon = "rbxassetid://4483345998"})
local TeleportTab = Window:MakeTab({Name = "Teleport", Icon = "rbxassetid://4483345998"})

-- --- TAB: MAIN (Automation) ---
MainTab:AddSection({Name = "Fishing Automation"})
MainTab:AddToggle({
    Name = "Auto Fishing",
    Default = false,
    Callback = function(v) Config.AutoFish = v end
})
MainTab:AddToggle({
    Name = "Auto Equip Rod",
    Default = true,
    Callback = function(v) Config.AutoEquip = v end
})
MainTab:AddToggle({
    Name = "Auto Sell All",
    Default = false,
    Callback = function(v) Config.AutoSell = v end
})

-- --- TAB: PLAYERS (Movement) ---
PlayerTab:AddSection({Name = "Character Mods"})
PlayerTab:AddSlider({
    Name = "WalkSpeed",
    Min = 16, Max = 200, Default = 18,
    Increment = 1, ValueName = "Speed",
    Callback = function(v) pcall(function() game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end) end
})
PlayerTab:AddSlider({
    Name = "JumpPower",
    Min = 50, Max =
