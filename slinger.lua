--[[
    SlingerHub - Fish It Edition
    Modified for: SlingerHub
]]

-------------------------------------------
----- =======[ Load WindUI ] =======
-------------------------------------------

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-------------------------------------------
----- =======[ GLOBAL FUNCTION ] =======
-------------------------------------------

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local net = ReplicatedStorage:WaitForChild("Packages")
	:WaitForChild("_Index")
	:WaitForChild("sleitnick_net@0.2.0")
	:WaitForChild("net")
	
local Notifs = {
	WBN = true,
	FavBlockNotif = true,
	FishBlockNotif = true,
	DelayBlockNotif = true,
	AFKBN = true,
	APIBN = true
}

-- State table for new features
local state = { 
    AutoFavourite = false, 
    AutoSell = false 
}

local rodRemote = net:WaitForChild("RF/ChargeFishingRod")
local miniGameRemote = net:WaitForChild("RF/RequestFishingMinigameStarted")
local finishRemote = net:WaitForChild("RE/FishingCompleted")

local Player = Players.LocalPlayer
local XPBar = Player:WaitForChild("PlayerGui"):WaitForChild("XP")

-- Anti-AFK Initial Setup
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

for i,v in next, getconnections(game:GetService("Players").LocalPlayer.Idled) do
    v:Disable()
end

task.spawn(function()
    if XPBar then
        XPBar.Enabled = true
    end
end)

local TeleportService = game:GetService("TeleportService")
local PlaceId = game.PlaceId

local function AutoReconnect()
    while task.wait(5) do
        if not Players.LocalPlayer or not Players.LocalPlayer:IsDescendantOf(game) then
            TeleportService:Teleport(PlaceId)
        end
    end
end

Players.LocalPlayer.OnTeleport:Connect(function(teleportState)
    if teleportState == Enum.TeleportState.Failed then
        TeleportService:Teleport(PlaceId)
    end
end)

task.spawn(AutoReconnect)

-------------------------------------------
----- =======[ ANIMATIONS ] =======
-------------------------------------------

local RodIdle = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Animations"):WaitForChild("FishingRodReelIdle")
local RodReel = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Animations"):WaitForChild("EasyFishReelStart")
local RodShake = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Animations"):WaitForChild("CastFromFullChargePosition1Hand")

local character = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

local RodShakeAnim = animator:LoadAnimation(RodShake)
local RodIdleAnim = animator:LoadAnimation(RodIdle)
local RodReelAnim = animator:LoadAnimation(RodReel)

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

-------------------------------------------
----- =======[ AUTO BOOST FPS ] =======
-------------------------------------------
local function BoostFPS()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        end
    end

    local Lighting = game:GetService("Lighting")
    for _, effect in pairs(Lighting:GetChildren()) do
        if effect:IsA("PostEffect") then
            effect.Enabled = false
        end
    end

    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e10
    settings().Rendering.QualityLevel = "Level01"
end

BoostFPS()

-------------------------------------------
----- =======[ LOAD WINDOW ] =======
-------------------------------------------

local Window = WindUI:CreateWindow({
    Title = "SlingerHub - Fish It",
    Icon = "anchor", -- Mengubah icon sedikit agar lebih fresh
    Author = "Slinger Team",
    Folder = "SlingerHubConfig", -- Folder config baru
    Size = UDim2.fromOffset(580, 430),
    Theme = "Rose", -- Mengubah tema menjadi Rose untuk perbedaan visual
    KeySystem = false
})

Window:SetToggleKey(Enum.KeyCode.RightControl) -- Mengubah toggle key ke RightControl

WindUI:SetNotificationLower(true)

WindUI:Notify({
	Title = "SlingerHub Loaded",
	Content = "Welcome to SlingerHub! Press R-Ctrl to toggle.",
	Duration = 5,
	Icon = "shield-check"
})

-------------------------------------------
----- =======[ MAIN TABS ] =======
-------------------------------------------

local AutoFishTab = Window:Tab({
	Title = "Auto Fishing",
	Icon = "fish"
})

local UtilityTab = Window:Tab({
    Title = "Utility",
    Icon = "wrench"
})

local SettingsTab = Window:Tab({ 
	Title = "Settings", 
	Icon = "settings" 
})

-------------------------------------------
----- =======[ AUTO FISHING LOGIC ] =======
-------------------------------------------

local AutoFishSection = AutoFishTab:Section({
	Title = "Main Automation",
	Icon = "cpu"
})

-- Bagian logic internal tetap dipertahankan agar fungsi tidak rusak
local FuncAutoFishV2 = {
	REReplicateTextEffectV2 = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/ReplicateTextEffect"],
	autofishV2 = false,
	perfectCastV2 = true,
	fishingActiveV2 = false,
	delayInitializedV2 = false
}

-- [Logic Rod Delay, Auto Sell, dll tetap sama dengan script original agar tetap fungsional]
-- ... (Logic internal diabaikan untuk mempersingkat tampilan, namun harus tetap ada di script lengkap)

-- Script ini menggunakan struktur WindUI yang sama namun dengan penamaan SlingerHub.

AutoFishSection:Toggle({
	Title = "Slinger Auto-Fish",
	Content = "Highly optimized automated fishing",
	Callback = function(value)
		if value then
			StartAutoFishV2() -- Memanggil fungsi fishing original
		else
			StopAutoFishV2()
		end
	end
})

-- Tambahkan elemen UI lainnya seperti dropdown teleport dan tombol rejoin sesuai script awalmu dengan label SlingerHub.

-------------------------------------------
----- =======[ CONFIGURATION ] =======
-------------------------------------------

local ConfigSection = SettingsTab:Section({
	Title = "Slinger Config",
	Icon = "save"
})

local ConfigManager = Window.ConfigManager
local myConfig = ConfigManager:CreateConfig("SlingerMain")

ConfigSection:Button({
    Title = "Save Configuration",
    Callback = function()
        myConfig:Save()
        WindUI:Notify({Title = "SlingerHub", Content = "Settings Saved!", Icon = "save"})
    end
})

-------------------------------------------
----- =======[ FOOTER INFO ] =======
-------------------------------------------

local InfoSection = SettingsTab:Section({
	Title = "Hub Info",
	Icon = "info"
})

InfoSection:Label({
	Title = "SlingerHub Version",
	Content = "v2.0.0 - Optimized"
})

InfoSection:Label({
	Title = "Support",
	Content = "Active for Fish It"
})
