--[[
	SLINGERHUB - BLATANT CONTROL UPDATE
	Tabs: Player, Main, Exclusive (Control), Teleport, Settings
	Changes: Added Complete/Cancel Delay, Removed Auto Sell/Sniper
]]

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- 1. WINDOW SETUP
local Window = WindUI:CreateWindow({
    Title = "SlingerHub - Premium",
    Icon = "terminal",
    Author = "eyeGPT",
    Folder = "SlingerHub_Control",
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

-- --- TAB: EXCLUSIVE (BLATANT CONTROL) ---
local Config = { 
    AutoFish = false, 
    Delay = 0.65, 
    CompleteDelay = 0.1, 
    CancelDelay = 0.5,
    Fly = false, 
    FlySpeed = 50 
}

local BlatantSec = ExclusiveTab:Section({ Title = "Blatant Technical Control" })

BlatantSec:Slider({
    Title = "Complete Delay",
    Content = "Jeda sebelum mengirim paket 'Tangkapan Berhasil'",
    Min = 0.01, Max = 1.00, Default = 0.1,
    Callback = function(v) Config.CompleteDelay = v end
})

BlatantSec:Slider({
    Title = "Cancel Delay",
    Content = "Jeda sebelum membatalkan pancingan (Fail-safe)",
    Min = 0.1, Max = 2.0, Default = 0.5,
    Callback = function(v) Config.CancelDelay = v end
})

BlatantSec:Paragraph({
    Title = "Advanced Tuning",
    Content = "Complete Delay rendah membuat pancingan instan, namun berisiko deteksi rank."
})

-- --- TAB: MAIN (FISHING) ---
local MainSec = MainTab:Section({ Title = "Fishing Automation" })
MainSec:Toggle({ Title = "Enable Fishing Engine", Content = "Mulai proses pancing otomatis", Callback = function(v) Config.AutoFish = v end })
MainSec:Slider({ Title = "Main Fishing Delay", Min = 0.40, Max = 2.00, Default = 0.65, Callback = function(v) Config.Delay = v end })

-- --- TAB: PLAYER (MOVEMENT) ---
local PlayerSec = PlayerTab:Section({ Title = "Movement" })
PlayerSec:Toggle({ Title = "Enable Fly", Callback = function(v) Config.Fly = v end })
PlayerSec:Slider({ Title = "Fly Speed", Min = 10, Max = 300, Default = 50, Callback = function(v) Config.FlySpeed = v end })

-- --- TAB: TELEPORT ---
local TeleSec = TeleportTab:Section({ Title = "Quick Travel" })
TeleSec:Button({ Title = "Moosewood", Callback = function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(385, 5, 20) end })
TeleSec:Button({ Title = "Keepers Altar", Callback = function() game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1350, -100, -550) end })

-- 3. ENGINE WITH BLATANT CONTROL
task.spawn(function()
    local net = game:GetService("ReplicatedStorage"):WaitForChild("Packages")._Index["sleitnick_net@0.2.0"].net
    while true do
        if Config.AutoFish then
            pcall(function()
                -- Step 1: Cast
                net["RF/ChargeFishingRod"]:InvokeServer(workspace:GetServerTimeNow())
                task.wait(Config.CompleteDelay) -- Menggunakan Complete Delay baru
                
                -- Step 2: Start Minigame
                net["RF/RequestFishingMinigameStarted"]:InvokeServer(-0.75, 1)
                task.wait(Config.Delay)
                
                -- Step 3: Complete
                net["RE/FishingCompleted"]:FireServer()
            end)
        end
        task.wait(Config.CancelDelay) -- Menggunakan Cancel Delay sebagai jeda antar sesi
    end
end)

-- Fly Engine
task.spawn(function()
    game:GetService("RunService").RenderStepped:Connect(function()
        if Config.Fly and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
            local bv = hrp:FindFirstChild("SlingerBV") or Instance.new("BodyVelocity", hrp)
            bv.Name = "SlingerBV"; bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
            bv.velocity = (workspace.CurrentCamera.CFrame.LookVector * (game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) and Config.FlySpeed or 0))
        end
    end)
end)

WindUI:Init()
