--[[
	SLINGERHUB - THE ULTIMATE FISH IT SCRIPT
	UI Style: WindUI (Modern, Premium, Minimalist)
	Developer: Team eyeGPT
]]

-- [1] BYPASS SYSTEM (Silent Mode)
pcall(function()
    local LP = game:GetService("Players").LocalPlayer
    LP.Kick = function() return nil end -- Blokir fungsi kick dasar
end)

-- [2] LOAD UI LIBRARY
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- [3] GLOBAL VARIABLES & SERVICES
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = game:GetService("Players").LocalPlayer
local net = ReplicatedStorage:WaitForChild("Packages")._Index["sleitnick_net@0.2.0"].net

local Config = {
    AutoFish = false,
    Mode = "Instant", -- Options: Legit, Instant, Blatant
    InstantDelay = 0.65,
    CompleteDelay = 0.42,
    AutoSell = false,
    AutoPerfect = true
}

-- [4] INITIALIZE WINDOW
local Window = WindUI:CreateWindow({
    Title = "SlingerHub - Fish It",
    Icon = "fish",
    Author = "by @eyeGPT",
    Folder = "SlingerHub_Final",
    Size = UDim2.fromOffset(580, 420),
    Theme = "Indigo",
    KeySystem = false
})

-- [5] TABS SETUP
local MainTab = Window:Tab({ Title = "Main", Icon = "home" })
local FishingTab = Window:Tab({ Title = "Fishing", Icon = "fish" })
local TeleportTab = Window:Tab({ Title = "Teleport", Icon = "map-pin" })
local SettingsTab = Window:Tab({ Title = "Settings", Icon = "settings" })

-- --- TAB: MAIN ---
local MainSec = MainTab:Section({ Title = "Karakter & Stat" })
MainSec:Button({
    Title = "Boost FPS",
    Content = "Menghapus lag untuk pengalaman maksimal",
    Callback = function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
        end
    end
})

-- --- TAB: FISHING (FULL FEATURES) ---
local FishSec = FishingTab:Section({ Title = "Otomatisasi Pancing" })

FishSec:Toggle({
    Title = "Mulai Pancing Otomatis",
    Content = "Aktifkan untuk mulai menangkap ikan",
    Callback = function(v) Config.AutoFish = v end
})

FishSec:Dropdown({
    Title = "Mode Memancing",
    Values = {"Legit", "Instant", "Ultra Blatant V3"},
    Callback = function(v) Config.Mode = v end
})

local SettingSec = FishingTab:Section({ Title = "Pengaturan Delay" })
SettingSec:Input({
    Title = "Instant Delay",
    Placeholder = "0.65",
    Callback = function(v) Config.InstantDelay = tonumber(v) or 0.65 end
})

FishingTab:Section({ Title = "Ekstra" }):Toggle({
    Title = "Auto Sell All",
    Content = "Otomatis menjual ikan saat tas penuh",
    Callback = function(v) Config.AutoSell = v end
})

-- --- TAB: TELEPORT ---
local LocSec = TeleportTab:Section({ Title = "Lokasi Pulau" })
local Locations = {
    ["Moosewood (Spawn)"] = Vector3.new(385, 5, 20),
    ["Keepers Altar"] = Vector3.new(1350, -100, -550),
    ["Tropical Grove"] = Vector3.new(-2038, 3, 3650),
    ["Esoteric Depths"] = Vector3.new(3157, -1303, 1439)
}

for Name, Pos in pairs(Locations) do
    LocSec:Button({
        Title = "Ke " .. Name,
        Callback = function()
            LP.Character.HumanoidRootPart.CFrame = CFrame.new(Pos + Vector3.new(0, 5, 0
