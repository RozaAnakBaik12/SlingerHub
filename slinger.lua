-- SLINGERHUB V7.0 | BYPASS & STABLE
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

-- bypass network fetching langsung ke root
local net = nil
pcall(function() 
    net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net 
end)

local state = { 
    AutoFish = false, 
    BlatantLevel = "Safe", 
    AutoSell = false,
    AutoBuyWeather = false,
    SavedPos = nil
}

local function StartFishing()
    task.spawn(function()
        while state.AutoFish do
            if not net then break end
            pcall(function()
                net["RE/EquipToolFromHotbar"]:FireServer(1)
                
                if state.BlatantLevel == "Brutal" then
                    -- TRIPLE POWER (Logic SlingerHub)
                    for i = 1, 3 do
                        task.spawn(function()
                            net["RF/ChargeFishingRod"]:InvokeServer(tick())
                            net["RF/RequestFishingMinigameStarted"]:InvokeServer(1.28, 1)
                        end)
                    end
                    task.wait(0.7)
                    for i = 1, 10 do net["RE/FishingCompleted"]:FireServer() end
                elseif state.BlatantLevel == "Fast" then
                    -- DOUBLE POWER
                    task.spawn(function()
                        net["RF/ChargeFishingRod"]:InvokeServer(tick())
                        net["RF/RequestFishingMinigameStarted"]:InvokeServer(1.28, 1)
                    end)
                    task.wait(0.85)
                    for i = 1, 5 do net["RE/FishingCompleted"]:FireServer() end
                else
                    -- SAFE MODE
                    net["RF/ChargeFishingRod"]:InvokeServer(tick())
                    net["RF/RequestFishingMinigameStarted"]:InvokeServer(1.2, 1)
                    task.wait(2.2)
                    net["RE/FishingCompleted"]:FireServer()
                end
            end)
            task.wait(0.1)
        end
    end)
end

local Window = WindUI:CreateWindow({
    Title = "SlingerHub V7.0 | BLUE",
    Icon = "anchor",
    Author = "SlingerDev",
    Folder = "SlingerHub_V7",
    Size = UDim2.fromOffset(580, 420),
    Theme = "Blue"
})

local MainTab = Window:Tab({ Title = "Main", Icon = "zap" })
local ShopTab = Window:Tab({ Title = "Shop", Icon = "shopping-bag" })
local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map" })

-- MAIN SECTION
local MainSection = MainTab:Section({ Title = "Fishing Engine" })
MainSection:Toggle({ Title = "Auto Fish", Callback = function(v) state.AutoFish = v if v then StartFishing() end end })
MainSection:Dropdown({ Title = "Blatant Rolling", Values = {"Safe", "Fast", "Brutal"}, Callback = function(v) state.BlatantLevel = v end })

-- SHOP SECTION
local ShopSection = ShopTab:Section({ Title = "Economy" })
ShopSection:Toggle({ Title = "Auto Sell All (60s)", Callback = function(v) 
    state.AutoSell = v 
    task.spawn(function() while state.AutoSell do pcall(function() net["RF/SellAllItems"]:InvokeServer() end) task.wait(60) end end)
end })

-- TELEPORT SECTION
local PosSection = TeleportTab:Section({ Title = "Position Manager" })
PosSection:Button({ Title = "Save Position", Callback = function() state.SavedPos = LocalPlayer.Character.HumanoidRootPart.CFrame end })
PosSection:Button({ Title = "TP to Saved", Callback = function() if state.SavedPos then LocalPlayer.Character.HumanoidRootPart.CFrame = state.SavedPos end end })
PosSection:Button({ Title = "Reset Position", Callback = function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(45, 252, 2987) end })

local IslandSection = TeleportTab:Section({ Title = "Island Rolling" })
local locs = {["Spawn"] = CFrame.new(45, 252, 2987), ["Sisyphus"] = CFrame.new(-3728, -135, -1012), ["Esoteric"] = CFrame.new(3248, -1301, 1403)}
local names = {}; for n,_ in pairs(locs) do table.insert(names, n) end
IslandSection:Dropdown({ Title = "Select Island", Values = names, Callback = function(s) LocalPlayer.Character.HumanoidRootPart.CFrame = locs[s] end })

-- Anti-AFK
LocalPlayer.Idled:Connect(function() VirtualUser:CaptureController() VirtualUser:ClickButton2(Vector2.new()) end)
WindUI:Notify({Title = "SlingerHub V7.0", Content = "Script Bypassed & Ready to Use!"})
