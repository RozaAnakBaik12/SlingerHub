--[[
    SlingerHub - Premium UI Edition
    Style: Pahaji Hub (Elegant Sidebar)
    Status: Owner Mode / Anti-Self Destruct / Full Blatant
--]]

-- ====== ULTIMATE BYPASS (Melindungi dari Self-Destruct) ======
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" then return nil end
        return old(self, ...)
    end)
end)

-- ====== UI LIBRARY SETUP (Fluent Style) ======
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "SlingerHub | Team eyeGPT",
    SubTitle = "by ArgaaaAi",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- ====== CONFIGURATION ======
local Options = Fluent.Options
local Config = {
    AutoFish = false,
    Blatant = false,
    CompleteDelay = 0.42,
    CancelDelay = 0.3,
    ReCastDelay = 0.0,
    SpamPower = 20
}

-- ====== SERVICES & EVENTS ======
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local net = ReplicatedStorage:WaitForChild("Packages", 20)._Index["sleitnick_net@0.2.0"].net
local Events = {
    fishing = net:WaitForChild("RE/FishingCompleted"),
    charge = net:WaitForChild("RF/ChargeFishingRod"),
    minigame = net:WaitForChild("RF/RequestFishingMinigameStarted"),
    equip = net:WaitForChild("RE/EquipToolFromHotbar")
}

-- ====== TABS (Sesuai Gambar Sidebar) ======
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Exclusive = Window:AddTab({ Title = "Exclusive", Icon = "star" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- ====== EXCLUSIVE TAB (Isi Seperti Gambar) ======
Tabs.Exclusive:AddSection("Ultra Blatant V3 Settings")

local BlatantToggle = Tabs.Exclusive:AddToggle("UltraBlatant", {Title = "Ultra Blatant V3", Default = false })
BlatantToggle:OnChanged(function()
    Config.Blatant = Options.UltraBlatant.Value
end)

Tabs.Exclusive:AddInput("CompleteDelay", {
    Title = "Complete Delay",
    Default = "0.42",
    Placeholder = "0.42",
    Numeric = true,
    Finished = true,
    Callback = function(Value) Config.CompleteDelay = tonumber(Value) end
})

Tabs.Exclusive:AddInput("CancelDelay", {
    Title = "Cancel Delay",
    Default = "0.3",
    Placeholder = "0.3",
    Numeric = true,
    Finished = true,
    Callback = function(Value) Config.CancelDelay = tonumber(Value) end
})

Tabs.Exclusive:AddInput("ReCastDelay", {
    Title = "Re-Cast Delay",
    Default = "0.000",
    Placeholder = "0.000",
    Numeric = true,
    Finished = true,
    Callback = function(Value) Config.ReCastDelay = tonumber(Value) end
})

Tabs.Exclusive:AddButton({
    Title = "Unlock FPS",
    Description = "Boost your game performance",
    Callback = function()
        setfpscap(999)
    end
})

-- ====== MAIN TAB (Master Switch) ======
Tabs.Main:AddSection("Automation")

local FishToggle = Tabs.Main:AddToggle("AutoFish", {Title = "Enable Auto Fish", Default = false })
FishToggle:OnChanged(function()
    Config.AutoFish = Options.AutoFish.Value
    task.spawn(function()
        while Config.AutoFish do
            pcall(function()
                Events.equip:FireServer(1)
                task.wait(Config.ReCastDelay)
                
                -- Casting
                task.spawn(function()
                    Events.charge:InvokeServer(1755848498.4834)
                    task.wait(0.01)
                    Events.minigame:InvokeServer(1.2854545116425, 1)
                end)
                
                task.wait(Config.CompleteDelay)
                
                -- Catching
                if Config.Blatant then
                    for i = 1, Config.SpamPower do
                        Events.fishing:FireServer()
                    end
                else
                    Events.fishing:FireServer()
                end
            end)
            task.wait(Config.CancelDelay)
        end
    end)
end)

-- ====== STARTUP ======
Window:SelectTab(Tabs.Exclusive)

Fluent:Notify({
    Title = "SlingerHub Premium",
    Content = "Welcome Back, Owner. UI Loaded Successfully.",
    Duration = 5
})
