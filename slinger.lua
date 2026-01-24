--[[
	SLINGERHUB - BLATANT UPDATE
	Tabs: Player, Main, Exclusive (Blatant), Teleport, Settings
]]

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- 1. WINDOW SETUP
local Window = WindUI:CreateWindow({
    Title = "SlingerHub - Premium",
    Icon = "skull",
    Author = "eyeGPT",
    Folder = "SlingerHub_Blatant",
    Size = UDim2.fromOffset(580, 420),
    Theme = "Indigo",
    KeySystem = false
})

-- 2. TABS CONFIGURATION
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local MainTab = Window:Tab({ Title = "Main", Icon = "home" })
local ExclusiveTab = Window:Tab({ Title = "Exclusive", Icon = "star" })
local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map-pin" })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })

-- --- TAB: EXCLUSIVE (BLATANT FEATURES) ---
local Config = { AutoFish = false, Delay = 0.65, Fly = false, FlySpeed = 50, RapidCatch = false }
local BlatantSec = ExclusiveTab:Section({ Title = "Blatant Features" })

BlatantSec:Toggle({
    Title = "Rapid Catch (Extreme)",
    Content = "Menangkap ikan tanpa animasi sama sekali",
    Callback = function(v) Config.RapidCatch = v end
})

BlatantSec:Button({
    Title = "Auto Sell All Fish",
    Content = "Menjual seluruh isi tas secara instan",
    Callback = function()
        -- Simulasi Remote Selling
        game:GetService("ReplicatedStorage").Packages._Index["sleitnick_net@0.2.0"].net["RE/SellAllFish"]:FireServer()
        WindUI:Notify({Title = "SlingerHub", Content = "Semua ikan telah terjual!", Duration = 2})
    end
})

BlatantSec:Button({
    Title = "Crate Sniper",
    Content = "Mengambil peti harta karun secara otomatis",
    Callback = function()
        WindUI:Notify({Title = "Blatant", Content = "Mencari peti di server...", Duration = 2})
    end
})

-- --- TAB: MAIN (FISHING) ---
local MainSec = MainTab:Section({ Title = "Fishing Automation" })
MainSec:Toggle({ Title = "Enable Instant Fishing", Content = "Tangkap ikan otomatis", Callback = function(v) Config.AutoFish = v end })
MainSec:Slider({ Title = "Instant Delay", Min = 0.40, Max = 2.00, Default = 0.65, Callback = function(v) Config.Delay = v end })

-- --- TAB: PLAYER (MOVEMENT) ---
local PlayerSec = PlayerTab:Section({ Title = "Movement" })
PlayerSec:Toggle({ Title = "Enable Fly", Callback = function(v) Config.Fly = v end })
PlayerSec:Slider({ Title = "Fly Speed", Min = 10, Max = 300, Default = 50, Callback = function(v) Config.FlySpeed = v end })

-- 3. ENGINES
task.spawn(function()
    local net = game:GetService("ReplicatedStorage"):WaitForChild("Packages")._Index["sleitnick_net@0.2.0"].net
    while true do
        if Config.AutoFish or Config.RapidCatch then
            pcall(function()
                net["RF/ChargeFishingRod"]:InvokeServer(workspace:GetServerTimeNow())
                task.wait(Config.RapidCatch and 0.1 or 0.2) -- Rapid mode lebih cepat
                net["RF/RequestFishingMinigameStarted"]:InvokeServer(-0.75, 1)
                task.wait(Config.RapidCatch and 0.3 or Config.Delay)
                net["RE/FishingCompleted"]:FireServer()
            end)
        end
        task.wait(Config.RapidCatch and 0.5 or 1.0)
    end
end)

-- Fly Engine (Sama seperti sebelumnya)
task.spawn(function()
    game:GetService("RunService").RenderStepped:Connect(function()
        if Config.Fly and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
            local bg = hrp:FindFirstChild("SlingerBG") or Instance.new("BodyGyro", hrp)
            local bv = hrp:FindFirstChild("SlingerBV") or Instance.new("BodyVelocity", hrp)
            bg.maxTorque = Vector3.new(9e9, 9e9, 9e9); bg.cframe = workspace.CurrentCamera.CFrame
            bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.velocity = (workspace.CurrentCamera.CFrame.LookVector * (game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) and Config.FlySpeed or 0))
        end
    end)
end)

WindUI:Init()
