--[[
    SLINGERHUB - WINDUI OWNER EDITION
    UI: WindUI (Ultra Stable for Mobile)
    Features: Ultra Blatant V3, Instant/Legit, Teleport, Anti-Self Destruct
--]]

-- ====== [1] ANTI-SELF DESTRUCT BYPASS ======
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or method == "kick" then 
            warn("👁️ eyeGPT: Melindungi dari Self-Destruct/Kick.")
            return nil 
        end
        return old(self, ...)
    end)
end)

-- ====== [2] WINDUI INITIALIZATION ======
local WindUI = loadstring(game:HttpGet("https://tree-hub.vercel.app/api/UI/WindUI"))()
local Window = WindUI:CreateWindow({
    Title = "SlingerHub | eyeGPT",
    Icon = "rbxassetid://10723343321",
    Author = "ArgaaaAi",
    Folder = "SlingerHub_WindUI"
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
    SpamPower = 25,
    AutoSell = false
}

-- ====== [4] TABS SETUP ======
local MainTab = Window:CreateTab({ Name = "Main", Icon = "rbxassetid://10723343321" })
local ExclusiveTab = Window:CreateTab({ Name = "Exclusive", Icon = "rbxassetid://10704905386" })
local PlayerTab = Window:CreateTab({ Name = "Players", Icon = "rbxassetid://10704907106" })
local TeleportTab = Window:CreateTab({ Name = "Teleport", Icon = "rbxassetid://10704905140" })

-- --- TAB: MAIN ---
MainTab:AddSection("Automation")
MainTab:AddToggle({
    Title = "Auto Fishing",
    Default = false,
    Callback = function(v) Config.AutoFish = v end
})
MainTab:AddToggle({
    Title = "Auto Equip Rod",
    Default = true,
    Callback = function(v) Config.AutoEquip = v end
})
MainTab:AddToggle({
    Title = "Auto Sell All",
    Default = false,
    Callback = function(v) Config.AutoSell = v end
})

-- --- TAB: EXCLUSIVE (PAHAJI STYLE) ---
ExclusiveTab:AddSection("Ultra Blatant V3")
ExclusiveTab:AddDropdown({
    Title = "Select Mode",
    Multi = false,
    Options = {"Legit", "Instant", "Ultra Blatant V3"},
    Default = "Legit",
    Callback = function(v) Config.FishingMode = v end
})

ExclusiveTab:AddSection("Settings")
ExclusiveTab:AddSlider({Title = "Instant Delay", Min = 0.1, Max = 2, Default = 0.65, Callback = function(v) Config.InstantDelay = v end})
ExclusiveTab:AddSlider({Title = "Complete Delay (Blatant)", Min = 0.1, Max = 1, Default = 0.42, Callback = function(v) Config.CompleteDelay = v end})
ExclusiveTab:AddSlider({Title = "Cancel Delay", Min = 0.1, Max = 1, Default = 0.3, Callback = function(v) Config.CancelDelay = v end})

-- --- TAB: PLAYERS ---
PlayerTab:AddSlider({Title = "Speed", Min = 16, Max = 200, Default = 18, Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v end})
PlayerTab:AddSlider({Title = "Jump", Min = 50, Max = 300, Default = 50, Callback = function(v) game.Players.LocalPlayer.Character.Humanoid.JumpPower = v end})

-- --- TAB: TELEPORT ---
TeleportTab:AddButton({Title = "Moosewood (Spawn)", Callback = function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(452, 150, 230) end})
TeleportTab:AddButton({Title = "Keepers Altar", Callback = function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1350, -100, -550) end})

-- ====== [5] LOGIC ENGINE ======
task.spawn(function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local net = ReplicatedStorage:WaitForChild("Packages")._Index["sleitnick_net@0.2.0"].net
    local Events = {
        fishing = net:WaitForChild("RE/FishingCompleted"),
        charge = net:WaitForChild("RF/ChargeFishingRod"),
        minigame = net:WaitForChild("RF/RequestFishingMinigameStarted"),
        equip = net:WaitForChild("RE/EquipToolFromHotbar"),
        sell = net:WaitForChild("RF/SellAllItems")
    }

    while true do
        if Config.AutoFish then
            pcall(function()
                if Config.AutoEquip then Events.equip:FireServer(1) end
                
                Events.charge:InvokeServer(1755848498.4834)
                Events.minigame:InvokeServer(1.2854545116425, 1)
                
                if Config.FishingMode == "Legit" then
                    task.wait(Config.LegitWait)
                    Events.fishing:FireServer()
                elseif Config.FishingMode == "Instant" then
                    task.wait(Config.InstantDelay)
                    Events.fishing:FireServer()
                elseif Config.FishingMode == "Ultra Blatant V3" then
                    task.wait(Config.CompleteDelay)
                    for i = 1, Config.SpamPower do Events.fishing:FireServer() end
                end
            end)
        end
        
        if Config.AutoSell then pcall(function() Events.sell:InvokeServer() end) end
        task.wait(Config.CancelDelay)
    end
end)

WindUI:Notify({Title = "SlingerHub", Content = "WindUI Loaded! Anti-Self Destruct Active.", Duration = 5})
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
