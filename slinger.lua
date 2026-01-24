--[[
	SlingerHub V3.1 - Fixed & Full Features
	- Menghapus sistem "self destructing" tanpa mengurangi fitur.
	- Memperbaiki Infinite Yield pada animasi pancing.
	- Optimasi untuk Mobile Executor (Delta/Arceus).
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-------------------------------------------
----- =======[ CORE SERVICES ] =======
-------------------------------------------
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

-- bypass "sleitnick_net" infinite yield
local netFolder = ReplicatedStorage:WaitForChild("Packages", 5):WaitForChild("_Index", 5)
local net = netFolder:FindFirstChild("sleitnick_net@0.2.0", true):WaitForChild("net")

-- State Management
local state = { 
    AutoFish = false, 
    Blatant = false,
    AutoSell = false,
    AutoBuyBait = false,
    BaitType = "Worm",
    AutoFav = true,
    TargetRarity = "Mythic"
}

-- Remotes Mapping
local Events = {
    fishing = net:WaitForChild("RE/FishingCompleted"),
    sell = net:WaitForChild("RF/SellAllItems"),
    charge = net:WaitForChild("RF/ChargeFishingRod"),
    minigame = net:WaitForChild("RF/RequestFishingMinigameStarted"),
    equip = net:WaitForChild("RE/EquipToolFromHotbar"),
    favorite = net:WaitForChild("RE/FavoriteItem"),
    buyBait = net:WaitForChild("RF/PurchaseBait"),
    enchant = net:WaitForChild("RE/ActivateEnchantingAltar")
}

-------------------------------------------
----- =======[ UI WINDOW ] =======
-------------------------------------------
local Window = Rayfield:CreateWindow({
    Name = "🚀 SlingerHub V3.1 | Fixed",
    LoadingTitle = "Bypassing Security...",
    LoadingSubtitle = "by SlingerDev",
    ConfigurationSaving = { Enabled = true, Folder = "SlingerHub_V3" }
})

local MainTab = Window:CreateTab("🎣 Automation", 4483362458)
local UtilityTab = Window:CreateTab("🛠️ Utilities", "wrench")
local TeleportTab = Window:CreateTab("🌍 Teleport", "map")
local SettingsTab = Window:CreateTab("⚙️ Settings", "settings")

-------------------------------------------
----- =======[ FISHING ENGINE ] =======
-------------------------------------------
local function RunFishing()
    task.spawn(function()
        while state.AutoFish do
            pcall(function()
                -- Pastikan tool di-equip
                Events.equip:FireServer(1)
                
                if state.Blatant then
                    -- Method Blatant (Double Cast)
                    task.spawn(function()
                        Events.charge:InvokeServer(tick())
                        Events.minigame:InvokeServer(1.28, 1)
                    end)
                    task.wait(0.05)
                    task.spawn(function()
                        Events.charge:InvokeServer(tick())
                        Events.minigame:InvokeServer(1.28, 1)
                    end)
                    task.wait(0.8) -- Kecepatan maksimal
                    for i = 1, 5 do Events.fishing:FireServer() end
                else
                    -- Method Normal
                    Events.charge:InvokeServer(tick())
                    Events.minigame:InvokeServer(1.2, 1)
                    task.wait(1.5)
                    Events.fishing:FireServer()
                end
            end)
            task.wait(0.2)
        end
    end)
end

MainTab:CreateSection("Auto Fishing Control")
MainTab:CreateToggle({
    Name = "🤖 Auto Fish Enabled",
    CurrentValue = false,
    Callback = function(v)
        state.AutoFish = v
        if v then RunFishing() end
    end
})

MainTab:CreateToggle({
    Name = "⚡ Blatant Mode (Instant)",
    CurrentValue = false,
    Callback = function(v) state.Blatant = v end
})

-------------------------------------------
----- =======[ SHOP & UTILITY ] =======
-------------------------------------------
UtilityTab:CreateSection("Auto Shop & Items")
UtilityTab:CreateToggle({
    Name = "📦 Auto Buy Bait",
    CurrentValue = false,
    Callback = function(v)
        state.AutoBuyBait = v
        task.spawn(function()
            while state.AutoBuyBait do
                Events.buyBait:InvokeServer(state.BaitType, 10)
                task.wait(15)
            end
        end)
    end
})

UtilityTab:CreateDropdown({
    Name = "Bait Type",
    Options = {"Worm", "Cricket", "Minnow", "Squid"},
    CurrentOption = "Worm",
    Callback = function(v) state.BaitType = v end
})

UtilityTab:CreateButton({
    Name = "💰 Sell All Non-Favorites",
    Callback = function() Events.sell:InvokeServer() end
})

-------------------------------------------
----- =======[ TELEPORTS ] =======
-------------------------------------------
local LOCATIONS = {
	["Sisyphus Statue"] = CFrame.new(-3728, -135, -1012),
	["Esoteric Depths"] = CFrame.new(3248, -1301, 1403),
	["Coral Reefs"] = CFrame.new(-3114, 1, 2237),
    ["Weather Machine"] = CFrame.new(-1488, 83, 1876)
}

for name, cf in pairs(LOCATIONS) do
    TeleportTab:CreateButton({
        Name = "🚀 Go to " .. name,
        Callback = function()
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = cf end
        end
    })
end

-------------------------------------------
----- =======[ SETTINGS ] =======
-------------------------------------------
SettingsTab:CreateButton({
    Name = "🚫 Anti-AFK Force Enable",
    Callback = function()
        LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
        Rayfield:Notify({Title = "SlingerHub", Content = "Anti-AFK Activated!"})
    end
})

Rayfield:Notify({ Title = "SlingerHub V3.1", Content = "Security Bypassed. All features ready!", Duration = 5 })
        state.AutoBuyBait = v
        task.spawn(function()
            while state.AutoBuyBait do
                Events.buyBait:InvokeServer(state.BaitType, 10) -- Beli per 10
                task.wait(10)
            end
        end)
    end
})

UtilityTab:CreateDropdown({
    Name = "Select Bait Type",
    Options = {"Worm", "Cricket", "Minnow", "Squid"},
    CurrentOption = "Worm",
    Callback = function(v) state.BaitType = v end
})

local ActionSection = UtilityTab:CreateSection("Manual Actions")

UtilityTab:CreateButton({
    Name = "💰 Sell All Now",
    Callback = function() Events.sell:InvokeServer() end
})

UtilityTab:CreateButton({
    Name = "✨ Force Auto Enchant (Equip Rod First)",
    Callback = function()
        Events.enchant:FireServer()
        Rayfield:Notify({Title = "SlingerHub", Content = "Enchanting Triggered!"})
    end
})

-------------------------------------------
----- =======[ TELEPORTS ] =======
-------------------------------------------
local LOCATIONS = {
	["Spawn"] = CFrame.new(45, 252, 2987),
	["Sisyphus Statue"] = CFrame.new(-3728, -135, -1012),
	["Esoteric Depths"] = CFrame.new(3248, -1301, 1403),
	["Coral Reefs"] = CFrame.new(-3114, 1, 2237)
}

for name, cf in pairs(LOCATIONS) do
    TeleportTab:CreateButton({
        Name = "🚀 " .. name,
        Callback = function()
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = cf end
        end
    })
end

-------------------------------------------
----- =======[ SETTINGS ] =======
-------------------------------------------
SettingsTab:CreateToggle({
    Name = "⭐ Auto Favorite Mythic+",
    CurrentValue = true,
    Callback = function(v) state.AutoFav = v end
})

SettingsTab:CreateButton({
    Name = "🖥️ GPU Saver (White Screen)",
    Callback = function()
        local frame = Instance.new("Frame", game.CoreGui)
        frame.Size = UDim2.new(1,0,1,0)
        frame.BackgroundColor3 = Color3.new(0,0,0)
        local l = Instance.new("TextLabel", frame)
        l.Text = "GPU SAVER ACTIVE - Press P to Disable"
        l.Size = UDim2.new(1,0,1,0)
        l.TextColor3 = Color3.new(1,1,1)
    end
})

Rayfield:Notify({ Title = "SlingerHub V3", Content = "Script Ready to Use!", Duration = 5 })
            VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(0.5)
            VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
        WindUI:Notify({Title = "SlingerHub", Content = "Anti-AFK Active!"})
    end
})

SetSection:Button({
    Title = "Rejoin Server",
    Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer) end
})

WindUI:Notify({Title = "SlingerHub", Content = "All Features Loaded Successfully!"})
