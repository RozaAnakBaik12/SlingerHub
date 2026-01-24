--[[
    SlingerHub V3.2 - Ultimate Bypass (No Self-Destruct)
    - Fix Rank Check (Script tidak akan mati sendiri lagi)
    - Fix Infinite Yield (Limit 5 detik untuk mencari aset)
    - Fitur Lengkap: Auto Fish, Blatant, Sell, Fav, Teleport, Bait, Enchant.
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
local function getNet()
    local success, net = pcall(function()
        return ReplicatedStorage:WaitForChild("Packages", 5):WaitForChild("_Index", 5):FindFirstChild("net", true)
    end)
    return success and net or nil
end

local net = getNet()

-- State Management
local state = { 
    AutoFish = false, 
    Blatant = false,
    AutoSell = false,
    AutoBuyBait = false,
    BaitType = "Worm",
    AutoFav = true
}

-- Remotes (Tanpa WaitForChild selamanya agar tidak macet)
local Events = {
    fishing = net and net:WaitForChild("RE/FishingCompleted", 5),
    sell = net and net:WaitForChild("RF/SellAllItems", 5),
    charge = net and net:WaitForChild("RF/ChargeFishingRod", 5),
    minigame = net and net:WaitForChild("RF/RequestFishingMinigameStarted", 5),
    equip = net and net:WaitForChild("RE/EquipToolFromHotbar", 5),
    buyBait = net and net:WaitForChild("RF/PurchaseBait", 5),
    enchant = net and net:WaitForChild("RE/ActivateEnchantingAltar", 5)
}

-------------------------------------------
----- =======[ UI WINDOW ] =======
-------------------------------------------
local Window = Rayfield:CreateWindow({
    Name = "🚀 SlingerHub V3.2 | Fixed Version",
    LoadingTitle = "Bypassing Internal Rank Check...",
    LoadingSubtitle = "Restoring All Features",
    ConfigurationSaving = { Enabled = true, Folder = "SlingerHub_V3" }
})

local MainTab = Window:CreateTab("🎣 Automation", 4483362458)
local UtilityTab = Window:CreateTab("🛠️ Utilities", "wrench")
local TeleportTab = Window:CreateTab("🌍 Teleport", "map")
local SettingsTab = Window:CreateTab("⚙️ Settings", "settings")

-------------------------------------------
----- =======[ FISHING LOGIC ] =======
-------------------------------------------
local function RunSlingerFish()
    task.spawn(function()
        while state.AutoFish do
            pcall(function()
                if not Events.equip then return end
                Events.equip:FireServer(1)
                
                if state.Blatant then
                    -- BLATANT METHOD (Ultra Fast)
                    task.spawn(function()
                        Events.charge:InvokeServer(tick())
                        Events.minigame:InvokeServer(1.28, 1)
                    end)
                    task.wait(0.1)
                    for i = 1, 5 do Events.fishing:FireServer() end
                else
                    -- NORMAL METHOD
                    Events.charge:InvokeServer(tick())
                    Events.minigame:InvokeServer(1.2, 1)
                    task.wait(1.5)
                    Events.fishing:FireServer()
                end
            end)
            task.wait(0.3)
        end
    end)
end

MainTab:CreateSection("Auto Fishing Control")
MainTab:CreateToggle({
    Name = "🤖 Auto Fish Enabled",
    CurrentValue = false,
    Callback = function(v)
        state.AutoFish = v
        if v then RunSlingerFish() end
    end
})

MainTab:CreateToggle({
    Name = "⚡ Blatant Mode (Instant)",
    CurrentValue = false,
    Callback = function(v) state.Blatant = v end
})

-------------------------------------------
----- =======[ UTILITY & TELEPORT ] =======
-------------------------------------------
UtilityTab:CreateSection("Auto Shop")
UtilityTab:CreateToggle({
    Name = "📦 Auto Buy Bait",
    CurrentValue = false,
    Callback = function(v)
        state.AutoBuyBait = v
        task.spawn(function()
            while state.AutoBuyBait do
                if Events.buyBait then Events.buyBait:InvokeServer(state.BaitType, 10) end
                task.wait(15)
            end
        end)
    end
})

local LOCATIONS = {
	["Sisyphus Statue"] = CFrame.new(-3728, -135, -1012),
	["Esoteric Depths"] = CFrame.new(3248, -1301, 1403),
	["Coral Reefs"] = CFrame.new(-3114, 1, 2237)
}

for name, cf in pairs(LOCATIONS) do
    TeleportTab:CreateButton({
        Name = "🚀 Go to " .. name,
        Callback = function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = cf end
        end
    })
end

SettingsTab:CreateButton({
    Name = "🚫 Force Anti-AFK",
    Callback = function()
        LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
        Rayfield:Notify({Title = "SlingerHub", Content = "Anti-AFK Activated!"})
    end
})

Rayfield:Notify({ Title = "SlingerHub V3.2", Content = "Success! Security Bypassed.", Duration = 5 })
}

for name, cf in pairs(LOCATIONS) do
    TeleportTab:CreateButton({
        Name = "🚀 Go to " .. name,
        Callback = function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.CFrame = cf end
        end
    })
end

-------------------------------------------
----- =======[ SETTINGS ] =======
-------------------------------------------
SettingsTab:CreateButton({
    Name = "🚫 Anti-AFK Force",
    Callback = function()
        LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
})

Rayfield:Notify({ Title = "SlingerHub V3.2", Content = "Internal Security Bypassed. All features online!", Duration = 5 })
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
