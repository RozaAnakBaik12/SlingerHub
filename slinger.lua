--[[
	SlingerHub - Full Version (Anti Self-Destruct)
	Optimized for Delta & Mobile Executors
]]

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-------------------------------------------
----- =======[ INITIALIZATION ] =======
-------------------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index")["sleitnick_net@0.2.0"].net

-- State Management
local state = { 
    AutoFish = false, 
    AutoSell = false, 
    AutoFav = false,
    PerfectCast = true
}

-- Remotes
local rodRemote = net:WaitForChild("RF/ChargeFishingRod")
local miniGameRemote = net:WaitForChild("RF/RequestFishingMinigameStarted")
local finishRemote = net:WaitForChild("RE/FishingCompleted")
local sellRemote = net:WaitForChild("RF/SellAllItems")

-------------------------------------------
----- =======[ UI WINDOW ] =======
-------------------------------------------
local Window = WindUI:CreateWindow({
    Title = "SlingerHub - Fish It",
    Icon = "anchor",
    Author = "SlingerDev",
    Folder = "SlingerHub_Fixed",
    Size = UDim2.fromOffset(600, 450),
    Theme = "Rose",
    KeySystem = false
})

Window:SetToggleKey(Enum.KeyCode.RightControl)

local AutoFishTab = Window:Tab({ Title = "Fishing", Icon = "fish" })
local UtilityTab = Window:Tab({ Title = "Utility", Icon = "wrench" })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })

-------------------------------------------
----- =======[ AUTO FISHING LOGIC ] =======
-------------------------------------------
local FishSection = AutoFishTab:Section({ Title = "Automation", Icon = "cpu" })

-- Auto Fish Function
local function RunSlingerFish()
    task.spawn(function()
        while state.AutoFish do
            pcall(function()
                local char = LocalPlayer.Character
                if not char then return end
                
                -- Equip Rod (Slot 1)
                net:WaitForChild("RE/EquipToolFromHotbar"):FireServer(1)
                task.wait(0.3)

                -- Cast Rod
                rodRemote:InvokeServer(workspace:GetServerTimeNow())
                task.wait(0.4)
                
                -- Start Minigame
                miniGameRemote:InvokeServer(-0.75, 1)
                task.wait(2) -- Delay cooldown
            end)
            if not state.AutoFish then break end
            task.wait(0.5)
        end
    end)
end

-- Catch Detection (Exclaim)
net:WaitForChild("RE/ReplicateTextEffect").OnClientEvent:Connect(function(data)
    if state.AutoFish and data.TextData and data.TextData.EffectType == "Exclaim" then
        if data.Container == (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")) then
            task.wait(0.4) -- Bypass delay
            finishRemote:FireServer()
        end
    end
end)

FishSection:Toggle({
    Title = "Enable Auto Fish",
    Callback = function(v)
        state.AutoFish = v
        if v then RunSlingerFish() end
    end
})

FishSection:Toggle({
    Title = "Auto Sell All",
    Content = "Jual ikan otomatis setiap 60 detik",
    Callback = function(v)
        state.AutoSell = v
        task.spawn(function()
            while state.AutoSell do
                sellRemote:InvokeServer()
                task.wait(60)
            end
        end)
    end
})

-------------------------------------------
----- =======[ UTILITY (TELEPORT) ] =======
-------------------------------------------
local TPSection = UtilityTab:Section({ Title = "Teleports", Icon = "map" })

local islandCoords = {
	["Esoteric Depths"] = Vector3.new(3157, -1303, 1439),
	["Tropical Grove"] = Vector3.new(-2038, 3, 3650),
	["Kohana Volcano"] = Vector3.new(-519, 24, 189),
    ["Weather Machine"] = Vector3.new(-1471, -3, 1929)
}

local islandNames = {}
for name, _ in pairs(islandCoords) do table.insert(islandNames, name) end

TPSection:Dropdown({
    Title = "Select Island",
    Values = islandNames,
    Callback = function(selected)
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(islandCoords[selected] + Vector3.new(0, 5, 0))
        end
    end
})

-------------------------------------------
----- =======[ SETTINGS ] =======
-------------------------------------------
local SetSection = SettingsTab:Section({ Title = "Misc", Icon = "user" })

SetSection:Button({
    Title = "Anti-AFK (Force Activate)",
    Callback = function()
        LocalPlayer.Idled:Connect(function()
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
