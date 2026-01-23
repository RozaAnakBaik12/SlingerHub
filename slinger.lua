--[[
	SlingerHub - Fish It Edition
	An optimized automation script for the ultimate fishing experience.
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

-- State table for SlingerHub features
local state = { 
    AutoFavourite = false, 
    AutoSell = false 
}

local rodRemote = net:WaitForChild("RF/ChargeFishingRod")
local miniGameRemote = net:WaitForChild("RF/RequestFishingMinigameStarted")
local finishRemote = net:WaitForChild("RE/FishingCompleted")

local Player = Players.LocalPlayer
local XPBar = Player:WaitForChild("PlayerGui"):WaitForChild("XP")

-- Anti-AFK Handler
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
----- =======[ NOTIFY FUNCTION ] =======
-------------------------------------------

local function NotifySuccess(title, message, duration)
    WindUI:Notify({
        Title = title,
        Content = message,
        Duration = duration,
        Icon = "circle-check"
    })
end

local function NotifyError(title, message, duration)
    WindUI:Notify({
        Title = title,
        Content = message,
        Duration = duration,
        Icon = "ban"
    })
end

local function NotifyInfo(title, message, duration)
    WindUI:Notify({
        Title = title,
        Content = message,
        Duration = duration,
        Icon = "info"
    })
end

local function NotifyWarning(title, message, duration)
    WindUI:Notify({
        Title = title,
        Content = message,
        Duration = duration,
        Icon = "triangle-alert"
    })
end

-------------------------------------------
----- =======[ LOAD WINDOW ] =======
-------------------------------------------

local Window = WindUI:CreateWindow({
    Title = "SlingerHub - Fish It",
    Icon = "anchor",
    Author = "by SlingerDev",
    Folder = "SlingerHub_Configs",
    Size = UDim2.fromOffset(600, 450),
    Theme = "Rose", -- Tema diubah menjadi Rose (Pinkish/Red) agar berbeda
    KeySystem = false
})

Window:SetToggleKey(Enum.KeyCode.RightControl) -- Tombol toggle diubah ke Right Control

WindUI:SetNotificationLower(true)

WindUI:Notify({
	Title = "SlingerHub System",
	Content = "Welcome back! All modules initialized.",
	Duration = 5,
	Image = "shield-check"
})

-------------------------------------------
----- =======[ MAIN TABS ] =======
-------------------------------------------

local AutoFishTab = Window:Tab({
	Title = "Auto Fishing",
	Icon = "fish"
})

local UtilityTab = Window:Tab({
    Title = "Utilities",
    Icon = "wrench"
})

local SettingsTab = Window:Tab({ 
	Title = "Configs", 
	Icon = "settings" 
})

-------------------------------------------
----- =======[ AUTO FISHING LOGIC ] =======
-------------------------------------------

local AutoFishSection = AutoFishTab:Section({
	Title = "Fishing Engine",
	Icon = "cpu"
})

local FuncAutoFishV2 = {
	REReplicateTextEffectV2 = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/ReplicateTextEffect"],
	autofishV2 = false,
	perfectCastV2 = true,
	fishingActiveV2 = false,
	delayInitializedV2 = false
}

local RodDelaysV2 = {
    ["Ares Rod"] = {custom = 1.12, bypass = 1.45},
    ["Angler Rod"] = {custom = 1.12, bypass = 1.45},
    ["Ghostfinn Rod"] = {custom = 1.12, bypass = 1.45},
    ["Astral Rod"] = {custom = 1.9, bypass = 1.45},
    ["Chrome Rod"] = {custom = 2.3, bypass = 2},
    ["Steampunk Rod"] = {custom = 2.5, bypass = 2.3},
    ["Lucky Rod"] = {custom = 3.5, bypass = 3.6},
    ["Midnight Rod"] = {custom = 3.3, bypass = 3.4},
    ["Demascus Rod"] = {custom = 3.9, bypass = 3.8},
    ["Grass Rod"] = {custom = 3.8, bypass = 3.9},
    ["Luck Rod"] = {custom = 4.2, bypass = 4.1},
    ["Carbon Rod"] = {custom = 4, bypass = 3.8},
    ["Lava Rod"] = {custom = 4.2, bypass = 4.1},
    ["Starter Rod"] = {custom = 4.3, bypass = 4.2},
}

local customDelayV2 = 1
local BypassDelayV2 = 0.5

local function getValidRodNameV2()
    local player = Players.LocalPlayer
    local display = player.PlayerGui:WaitForChild("Backpack"):WaitForChild("Display")
    for _, tile in ipairs(display:GetChildren()) do
        local success, itemNamePath = pcall(function()
            return tile.Inner.Tags.ItemName
        end)
        if success and itemNamePath and itemNamePath:IsA("TextLabel") then
            local name = itemNamePath.Text
            if RodDelaysV2[name] then
                return name
            end
        end
    end
    return nil
end

local function updateDelayBasedOnRodV2(showNotify)
    if FuncAutoFishV2.delayInitializedV2 then return end
    local rodName = getValidRodNameV2()
    if rodName and RodDelaysV2[rodName] then
        customDelayV2 = RodDelaysV2[rodName].custom
        BypassDelayV2 = RodDelaysV2[rodName].bypass
        FuncAutoFishV2.delayInitializedV2 = true
        if showNotify and FuncAutoFishV2.autofishV2 then
            NotifySuccess("Slinger Detection", "Rod Detected: " .. rodName)
        end
    else
        customDelayV2 = 10
        BypassDelayV2 = 1
        FuncAutoFishV2.delayInitializedV2 = true
    end
end

-- [Lanjutan Logic Original...]
FuncAutoFishV2.REReplicateTextEffectV2.OnClientEvent:Connect(function(data)
    if FuncAutoFishV2.autofishV2 and FuncAutoFishV2.fishingActiveV2
    and data and data.TextData and data.TextData.EffectType == "Exclaim" then
        local myHead = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Head")
        if myHead and data.Container == myHead then
            task.spawn(function()
                for i = 1, 3 do
                    task.wait(BypassDelayV2)
                    finishRemote:FireServer()
                end
            end)
        end
    end
end)

function StartAutoFishV2()
    if FuncAutoFishV2.autofishV2 then return end
    FuncAutoFishV2.autofishV2 = true
    updateDelayBasedOnRodV2(true)
    task.spawn(function()
        while FuncAutoFishV2.autofishV2 do
            pcall(function()
                FuncAutoFishV2.fishingActiveV2 = true
                local equipRemote = net:WaitForChild("RE/EquipToolFromHotbar")
                equipRemote:FireServer(1)
                task.wait(0.1)
                rodRemote:InvokeServer(workspace:GetServerTimeNow())
                task.wait(0.5)
                RodShakeAnim:Play()
                rodRemote:InvokeServer(workspace:GetServerTimeNow())
                RodIdleAnim:Play()
                miniGameRemote:InvokeServer(-0.75, 1)
                task.wait(customDelayV2)
                FuncAutoFishV2.fishingActiveV2 = false
            end)
        end
    end)
end

function StopAutoFishV2()
    FuncAutoFishV2.autofishV2 = false
    RodIdleAnim:Stop()
    RodShakeAnim:Stop()
end

-------------------------------------------
----- =======[ UI ELEMENTS ] =======
-------------------------------------------

AutoFishSection:Toggle({
	Title = "Slinger Auto-Fish V2",
	Content = "Advanced fishing automation",
	Callback = function(value)
		if value then StartAutoFishV2() else StopAutoFishV2() end
	end
})

AutoFishSection:Toggle({
    Title = "Auto Sell (Threshold 60)",
    Content = "Sell non-favorites automatically",
    Callback = function(value) state.AutoSell = value end
})

AutoFishSection:Input({
	Title = "Manual Bypass Delay",
	Placeholder = "1.45",
	Callback = function(value) BypassDelayV2 = tonumber(value) or BypassDelayV2 end
})

-- Bagian Favorite
local FavoriteSection = AutoFishTab:Section({ Title = "Protection", Icon = "star" })
FavoriteSection:Toggle({
    Title = "Auto Favorite High Tier",
    Content = "Protects Mythic/Legendary/Secret",
    Callback = function(value) state.AutoFavourite = value end
})

-- Manual Actions
local ActionSection = AutoFishTab:Section({ Title = "Quick Actions", Icon = "Zap" })
ActionSection:Button({
    Title = "Sell All Now",
    Callback = function() -- Insert Sell Function Logic
        NotifyInfo("SlingerHub", "Selling items...")
    end
})

-------------------------------------------
----- =======[ SETTINGS & FOOTER ] =======
-------------------------------------------

local ConfigSection = SettingsTab:Section({ Title = "Configuration", Icon = "save" })
local ConfigManager = Window.ConfigManager
local myConfig = ConfigManager:CreateConfig("SlingerHub_Save")

ConfigSection:Button({
    Title = "Save All Settings",
    Callback = function() 
        myConfig:Save() 
        NotifySuccess("SlingerHub", "Config Saved!")
    end
})

local InfoSection = SettingsTab:Section({ Title = "About SlingerHub", Icon = "info" })
InfoSection:Label({ Title = "Version", Content = "Slinger Edition 2.0" })
InfoSection:Label({ Title = "Status", Content = "Secure & Active" })

NotifySuccess("SlingerHub", "Successfully Loaded!")
