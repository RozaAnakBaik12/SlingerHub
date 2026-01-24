--[[
    SLINGERHUB - STEALTH FINAL V7
    No Hooking - No Self Destruct Trigger
    UI: Mobile-Friendly Lightweight
--]]

-- 1. SILENT INITIALIZATION
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = game:GetService("Players").LocalPlayer

-- 2. LIGHTWEIGHT UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("SlingerHub | Team eyeGPT", "Midnight")

-- CONFIG (Sesuai Gambar)
local Config = {
    AutoFish = false,
    FishingMode = "Instant",
    CompleteDelay = 0.42,
    CancelDelay = 0.3,
    InstantDelay = 0.65,
    SpamPower = 30
}

-- 3. TABS (Pahaji Style Sidebar)
local Main = Window:NewTab("Main")
local Exclusive = Window:NewTab("Exclusive")
local Teleport = Window:NewTab("Teleport")

-- --- TAB: MAIN ---
local MainSection = Main:NewSection("Fishing")
MainSection:NewToggle("Auto Fishing", "Start fishing", function(v)
    Config.AutoFish = v
end)

-- --- TAB: EXCLUSIVE (Ultra Blatant V3) ---
local ExSection = Exclusive:NewSection("Ultra Blatant V3")
ExSection:NewDropdown("Mode", "Pilih Mode", {"Legit", "Instant", "Ultra Blatant V3"}, function(v)
    Config.FishingMode = v
end)
ExSection:NewTextBox("Complete Delay", "Default: 0.42", function(v)
    Config.CompleteDelay = tonumber(v) or 0.42
end)

-- --- TAB: TELEPORT ---
local TeleSection = Teleport:NewSection("Locations")
TeleSection:NewButton("Keepers Altar", "Teleport to Altar", function()
    LP.Character.HumanoidRootPart.CFrame = CFrame.new(1350, -100, -550)
end)

-- 4. STEALTH ENGINE (Tanpa Hooking Agar Tidak Meledak)
task.spawn(function()
    local net = ReplicatedStorage:WaitForChild("Packages", 30)._Index["sleitnick_net@0.2.0"].net
    local Events = {
        fishing = net:WaitForChild("RE/FishingCompleted"),
        charge = net:WaitForChild("RF/ChargeFishingRod"),
        minigame = net:WaitForChild("RF/RequestFishingMinigameStarted")
    }

    while true do
        if Config.AutoFish then
            pcall(function()
                Events.charge:InvokeServer(1755848498.4834)
                Events.minigame:InvokeServer(1.2854545116425, 1)
                
                if Config.FishingMode == "Legit" then task.wait(2.5)
                elseif Config.FishingMode == "Instant" then task.wait(Config.InstantDelay)
                else task.wait(Config.CompleteDelay) end
                
                if Config.FishingMode == "Ultra Blatant V3" then
                    for i = 1, Config.SpamPower do Events.fishing:FireServer() end
                else
                    Events.fishing:FireServer()
                end
            end)
        end
        task.wait(Config.CancelDelay)
    end
end)
