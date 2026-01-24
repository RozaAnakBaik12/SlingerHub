--[[
	SLINGERHUB - DUPE ONLY (SIMPLE UI)
	Bypass: Silent Stealth V12
	Fitur: Hanya Packet Multiplier (Dupe)
]]

-- 1. BYPASS DASAR
pcall(function()
    game:GetService("Players").LocalPlayer.Kick = function() return nil end
end)

-- 2. LOAD UI SIMPLE
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "SlingerHub Dupe",
    Icon = "copy",
    Author = "eyeGPT",
    Folder = "SlingerHub_Dupe",
    Size = UDim2.fromOffset(350, 300), -- Ukuran kecil & simple
    Theme = "Indigo"
})

-- CONFIG
local Config = {
    DupeActive = false,
    Power = 5,
    Delay = 0.8
}

-- 3. UI LAYOUT
local Main = Window:Tab({ Title = "Dupe", Icon = "box" })
local Section = Main:Section({ Title = "Fish Multiplier" })

Section:Toggle({
    Title = "Enable Dupe",
    Content = "Gandakan hasil tangkapan ikan",
    Callback = function(v) Config.DupeActive = v end
})

Section:Slider({
    Title = "Dupe Power",
    Min = 1,
    Max = 100,
    Default = 5,
    Callback = function(v) Config.Power = v end
})

Section:Input({
    Title = "Safety Delay",
    Placeholder = "0.8",
    Callback = function(v) Config.Delay = tonumber(v) or 0.8 end
})

-- 4. DUPE ENGINE (Pahaji/Chloe Style Optimized)
task.spawn(function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local net = ReplicatedStorage:WaitForChild("Packages")._Index["sleitnick_net@0.2.0"].net
    local finish = net:WaitForChild("RE/FishingCompleted")
    local charge = net:WaitForChild("RF/ChargeFishingRod")
    local mini = net:WaitForChild("RF/RequestFishingMinigameStarted")

    while true do
        if Config.DupeActive then
            pcall(function()
                -- Start
                charge:InvokeServer(workspace:GetServerTimeNow())
                task.wait(0.2)
                mini:InvokeServer(-0.75, 1)
                
                -- Catch Delay (Penting agar rank tidak deteksi)
                task.wait(Config.Delay)
                
                -- Packet Spam (The Dupe)
                for i = 1, Config.Power do
                    finish:FireServer()
                end
            end)
        end
        task.wait(1.5) -- Cooldown pancingan
    end
end)

WindUI:Notify({Title = "SlingerHub", Content = "Dupe Only Loaded!", Duration = 3})
