--[[
    SLINGERHUB - ULTIMATE OWNER EDITION (PAHAJI STYLE)
    UI: Fluent Library (Elegant Sidebar)
    Bypass: Anti-Self Destruct & DNS Fixer
    Features: Ultra Blatant V3, Instant/Legit Mode, Full Teleport, Player Mods
--]]

-- ====== [1] ULTIMATE BYPASS & DEFENSE ======
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" then 
            warn("👁️ eyeGPT: Blocked an attempt to Kick/Self-Destruct.")
            return nil 
        end
        return old(self, ...)
    end)
    -- DNS & Asset Fixer
    game:GetService("ContentProvider").PreloadAsync = function() return end
end)

-- ====== [2] UI SETUP ======
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({
    Title = "SlingerHub | Team eyeGPT",
    SubTitle = "by ArgaaaAi",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark"
})

-- ====== [3] CONFIGURATION ======
local Options = Fluent.Options
local Config = {
    FishingMode = "Legit",
    CompleteDelay = 0.42,
    CancelDelay = 0.3,
    ReCastDelay = 0.0,
    LegitWait = 2.5,
    SpamPower = 25,
    AutoSell = false,
    SellDelay = 30
}

local LOCATIONS = {
    ["Main Islands"] = {
        ["Moosewood (Spawn)"] = CFrame.new(452, 150, 230),
        ["Roslit Bay"] = CFrame.new(-1488, 83, 1876),
        ["Terrapin Island"] = CFrame.new(-195, 140, 1950),
        ["Mushgrove Swamp"] = CFrame.new(2450, 130, -700)
    },
    ["Special Areas"] = {
        ["Keepers Altar"] = CFrame.new(1350, -100, -550),
        ["The Depths"] = CFrame.new(3248, -1301, 1403),
        ["Sisyphus Statue"] = CFrame.new(-3728, -135, -1012),
        ["Coral Reef"] = CFrame.new(-3114, 1, 2237)
    }
}

-- ====== [4] TABS SETUP ======
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Players = Window:AddTab({ Title = "Players", Icon = "user" }),
    Exclusive = Window:AddTab({ Title = "Exclusive", Icon = "star" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- --- TAB: MAIN ---
Tabs.Main:AddSection("Automation")
Tabs.Main:AddToggle("AutoFish", {Title = "Enable Auto Fish", Default = false})
Tabs.Main:AddToggle("AutoEquip", {Title = "Auto Equip Rod", Default = true})
Tabs.Main:AddToggle("AutoSell", {Title = "Auto Sell All", Default = false})
Tabs.Main:AddSlider("SellDelay", {Title = "Sell Delay (s)", Default = 30, Min = 10, Max = 120, Callback = function(v) Config.SellDelay = v end})

-- --- TAB: PLAYERS ---
Tabs.Players:AddSlider("WalkSpeed", { Title = "Speed", Default = 18, Min = 16, Max = 200, Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end })
Tabs.Players:AddSlider("JumpPower", { Title = "Jump", Default = 50, Min = 50, Max = 300, Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.JumpPower = v end })

-- --- TAB: EXCLUSIVE ---
Tabs.Exclusive:AddSection("Fishing Mode Selection")
Tabs.Exclusive:AddDropdown("
