-- SLINGERHUB V6.6 - TOTAL CLEAN VERSION (NO SELF-DESTRUCT)
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local net = nil
pcall(function() net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net end)

local state = { AutoFish = false, BlatantLevel = "Safe", SavedPos = nil }

local function StartFishing()
    task.spawn(function()
        while state.AutoFish do
            pcall(function()
                if net then
                    net["RE/EquipToolFromHotbar"]:FireServer(1)
                    if state.BlatantLevel == "Brutal" then
                        for i = 1, 3 do task.spawn(function() net["RF/ChargeFishingRod"]:InvokeServer(tick()) net["RF/RequestFishingMinigameStarted"]:InvokeServer(1.28, 1) end) end
                        task.wait(0.7)
                        for i = 1, 10 do net["RE/FishingCompleted"]:FireServer() end
                    elseif state.BlatantLevel == "Fast" then
                        task.spawn(function() net["RF/ChargeFishingRod"]:InvokeServer(tick()) net["RF/RequestFishingMinigameStarted"]:InvokeServer(1.28, 1) end)
                        task.wait(0.05)
                        task.spawn(function() net["RF/ChargeFishingRod"]:InvokeServer(tick()) net["RF/RequestFishingMinigameStarted"]:InvokeServer(1.28, 1) end)
                        task.wait(0.85)
                        for i = 1, 5 do net["RE/FishingCompleted"]:FireServer() end
                    else
                        net["RF/ChargeFishingRod"]:InvokeServer(tick())
                        net["RF/RequestFishingMinigameStarted"]:InvokeServer(1.2, 1)
                        task.wait(2.2)
                        net["RE/FishingCompleted"]:FireServer()
                    end
                end
            end)
            task.wait(0.1)
        end
    end)
end

local Window = WindUI:CreateWindow({
    Title = "SlingerHub V6.6 | ANTI-ERROR",
    Author = "SlingerDev",
    Theme = "Blue"
})

local MainTab = Window:Tab({ Title = "Main", Icon = "zap" })
local ShopTab = Window:Tab({ Title = "Shop", Icon = "shopping-bag" })
local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map" })

MainTab:Section({ Title = "Fishing" }):Toggle({ Title = "Auto Fish", Callback = function(v) state.AutoFish = v if v then StartFishing() end end })
MainTab:Section({ Title = "Settings" }):Dropdown({ Title = "Blatant Mode", Values = {"Safe", "Fast", "Brutal"}, Callback = function(v) state.BlatantLevel = v end })

ShopTab:Section({ Title = "Store" }):Toggle({ Title = "Auto Sell (60s)", Callback = function(v) 
    task.spawn(function() while v do if net then net["RF/SellAllItems"]:InvokeServer() end task.wait(60) end end)
end })

local TP = TeleportTab:Section({ Title = "Manager" })
TP:Button({ Title = "Save Pos", Callback = function() state.SavedPos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame end })
TP:Button({ Title = "TP Saved", Callback = function() if state.SavedPos then game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = state.SavedPos end end })
TP:Button({ Title = "Reset", Callback = function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(45, 252, 2987) end })

local Island = TeleportTab:Section({ Title = "Island" })
local locs = {["Spawn"] = CFrame.new(45, 252, 2987), ["Sisyphus"] = CFrame.new(-3728, -135, -1012)}
local names = {}; for n,_ in pairs(locs) do table.insert(names, n) end
Island:Dropdown({ Title = "Rolling Island", Values = names, Callback = function(s) game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = locs[s] end })

game.Players.LocalPlayer.Idled:Connect(function() game:GetService("VirtualUser"):CaptureController() game:GetService("VirtualUser"):ClickButton2(Vector2.new()) end)

-- Anti-AFK
LocalPlayer.Idled:Connect(function() VirtualUser:CaptureController() VirtualUser:ClickButton2(Vector2.new()) end)

WindUI:Notify({Title = "SlingerHub V6.5", Content = "Semua Error "Self-Destruct" Sudah Dihapus!"})

PosSection:Button({
    Title = "Reset Position (To Spawn)",
    Callback = function()
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(45, 252, 2987) -- Posisi Spawn Default
        end
    end
})

local IslandSection = TeleportTab:Section({ Title = "Island Rolling", Icon = "navigation" })
local locations = {
    ["Spawn Island"] = CFrame.new(45, 252, 2987),
    ["Sisyphus Statue"] = CFrame.new(-3728, -135, -1012),
    ["Esoteric Depths"] = CFrame.new(3248, -1301, 1403),
    ["Coral Reefs"] = CFrame.new(-3114, 1, 2237)
}
local
