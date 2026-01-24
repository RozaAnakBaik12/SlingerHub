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
Tabs.Exclusive:AddDropdown("FishingMode", {
    Title = "Select Fishing Mode",
    Values = {"Legit", "Instant", "Ultra Blatant V3"},
    Default = "Legit",
    Callback = function(Value) Config.FishingMode = Value end
})

Tabs.Exclusive:AddSection("Mode Configurations")
Tabs.Exclusive:AddInput("InstantDelay", {Title = "Instant Finish Delay", Default = "0.65", Callback = function(v) Config.CompleteDelay = tonumber(v) end})
Tabs.Exclusive:AddInput("LegitDelay", {Title = "Legit Wait Time", Default = "2.5", Callback = function(v) Config.LegitWait = tonumber(v) end})
Tabs.Exclusive:AddInput("CDelay", {Title = "Complete Delay (Blatant)", Default = "0.42", Callback = function(v) Config.CompleteDelay = tonumber(v) end})
Tabs.Exclusive:AddInput("CanDelay", {Title = "Cancel Delay", Default = "0.3", Callback = function(v) Config.CancelDelay = tonumber(v) end})

-- --- TAB: TELEPORT ---
for category, locs in pairs(LOCATIONS) do
    Tabs.Teleport:AddSection(category)
    for name, cf in pairs(locs) do
        Tabs.Teleport:AddButton({Title = name, Callback = function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = cf end})
    end
end

-- ====== [5] LOGIC ENGINE ======
task.spawn(function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local net = ReplicatedStorage:WaitForChild("Packages", 25)._Index["sleitnick_net@0.2.0"].net
    local Events = {
        fishing = net:WaitForChild("RE/FishingCompleted"),
        charge = net:WaitForChild("RF/ChargeFishingRod"),
        minigame = net:WaitForChild("RF/RequestFishingMinigameStarted"),
        equip = net:WaitForChild("RE/EquipToolFromHotbar"),
        sell = net:WaitForChild("RF/SellAllItems")
    }

    while true do
        if Options.AutoFish.Value then
            pcall(function()
                if Options.AutoEquip.Value then Events.equip:FireServer(1) end
                task.wait(Config.ReCastDelay)
                Events.charge:InvokeServer(1755848498.4834)
                Events.minigame:InvokeServer(1.2854545116425, 1)
                
                if Config.FishingMode == "Legit" then
                    task.wait(Config.LegitWait)
                    Events.fishing:FireServer()
                elseif Config.FishingMode == "Instant" then
                    task.wait(Config.CompleteDelay)
                    Events.fishing:FireServer()
                elseif Config.FishingMode == "Ultra Blatant V3" then
                    task.wait(Config.CompleteDelay)
                    for i = 1, Config.SpamPower do Events.fishing:FireServer() end
                end
            end)
            task.wait(Config.CancelDelay)
        end
        task.wait(0.1)
    end
end)

task.spawn(function()
    while true do
        if Options.AutoSell.Value then pcall(function() game:GetService("ReplicatedStorage").Packages._Index["sleitnick_net@0.2.0"].net:WaitForChild("RF/SellAllItems"):InvokeServer() end) end
        task.wait(Config.SellDelay)
    end
end)

Window:SelectTab(Tabs.Main)
Fluent:Notify({Title = "SlingerHub", Content = "Semua fitur telah digabungkan. Selamat memancing, Owner!", Duration = 5})
