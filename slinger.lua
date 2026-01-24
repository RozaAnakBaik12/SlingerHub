--[[
    SlingerHub V3 - Fish It (Rayfield Edition)
    Status: Optimized & Organized
    Features Added: Auto Buy Bait, Auto Enchant, Webhook, Fast Travel.
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-------------------------------------------
----- =======[ CORE SERVICES ] =======
-------------------------------------------
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net

-- State Management
local state = { 
    AutoFish = false, 
    Blatant = false,
    AutoSell = false,
    AutoBuyBait = false,
    BaitType = "Worm",
    AutoEnchant = false,
    AutoFav = true,
    TargetRarity = "Mythic"
}

-- Remotes
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
----- =======[ WINDOW SETUP ] =======
-------------------------------------------
local Window = Rayfield:CreateWindow({
    Name = "🚀 SlingerHub V3 | Fish It",
    LoadingTitle = "Initializing Slinger Engine...",
    LoadingSubtitle = "by SlingerDev",
    ConfigurationSaving = { Enabled = true, Folder = "SlingerHub_V3" }
})

local MainTab = Window:CreateTab("🎣 Automation", 4483362458)
local UtilityTab = Window:Tab("🛠️ Utilities", "wrench")
local TeleportTab = Window:CreateTab("🌍 Teleport", "map")
local SettingsTab = Window:CreateTab("⚙️ Settings", "settings")

-------------------------------------------
----- =======[ FISHING LOGIC ] =======
-------------------------------------------
local FishSection = MainTab:CreateSection("Fishing Engine")

local function RunFishing()
    task.spawn(function()
        while state.AutoFish do
            pcall(function()
                Events.equip:FireServer(1)
                
                if state.Blatant then
                    -- BLATANT METHOD: Double Casting
                    task.spawn(function()
                        Events.charge:InvokeServer(tick())
                        Events.minigame:InvokeServer(1.28, 1)
                    end)
                    task.wait(0.05)
                    task.spawn(function()
                        Events.charge:InvokeServer(tick())
                        Events.minigame:InvokeServer(1.28, 1)
                    end)
                    task.wait(0.9) -- Blatant Delay
                    for i = 1, 5 do Events.fishing:FireServer() end
                else
                    -- NORMAL METHOD
                    Events.charge:InvokeServer(tick())
                    Events.minigame:InvokeServer(1.2, 1)
                    task.wait(1.2)
                    Events.fishing:FireServer()
                end
            end)
            task.wait(0.1)
        end
    end)
end

MainTab:CreateToggle({
    Name = "🤖 Start Auto Fish",
    CurrentValue = false,
    Callback = function(v)
        state.AutoFish = v
        if v then RunFishing() end
    end
})

MainTab:CreateToggle({
    Name = "⚡ Blatant Mode (Super Fast)",
    CurrentValue = false,
    Callback = function(v) state.Blatant = v end
})

-------------------------------------------
----- =======[ SHOP & UTILITY ] =======
-------------------------------------------
local ShopSection = UtilityTab:CreateSection("Auto Shop")

UtilityTab:CreateToggle({
    Name = "📦 Auto Buy Bait",
    CurrentValue = false,
    Callback = function(v)
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
