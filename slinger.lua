--[[
	SLINGERHUB - MODERN EDITION
	UI: WindUI (Indigo/Green Theme)
	Security: Stealth Bypass V10 (Anti-Self Destruct)
]]

-------------------------------------------
----- =======[ STEALTH BYPASS ] =======
-------------------------------------------
pcall(function()
    local LP = game:GetService("Players").LocalPlayer
    -- Mematikan fungsi Kick tanpa memicu deteksi metatable berat
    LP.Kick = function() return nil end
    
    local oldNC
    oldNC = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" or tostring(self):find("Destruct") then 
            return nil 
        end
        return oldNC(self, ...)
    end)
end)

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
local net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
	
local state = { AutoFavourite = false, AutoSell = false }

local rodRemote = net:WaitForChild("RF/ChargeFishingRod")
local miniGameRemote = net:WaitForChild("RF/RequestFishingMinigameStarted")
local finishRemote = net:WaitForChild("RE/FishingCompleted")

-------------------------------------------
----- =======[ LOAD WINDOW ] =======
-------------------------------------------
local Window = WindUI:CreateWindow({
    Title = "SlingerHub - Premium Fish",
    Icon = "fish",
    Author = "by Team eyeGPT",
    Folder = "SlingerHubConfig",
    Size = UDim2.fromOffset(580, 420),
    Theme = "Green", -- Mengubah ke tema Green agar lebih modern
    KeySystem = false
})

Window:SetToggleKey(Enum.KeyCode.G)

WindUI:Notify({
	Title = "SlingerHub Activated",
	Content = "Welcome, Owner. Systems are secure.",
	Duration = 5,
	Icon = "shield-check"
})

-------------------------------------------
----- =======[ MAIN TABS ] =======
-------------------------------------------
local AutoFishTab = Window:Tab({ Title = "Fishing", Icon = "fish" })
local UtilityTab = Window:Tab({ Title = "Utility", Icon = "settings" })
local SettingsTab = Window:Tab({ Title = "Config", Icon = "user-cog" })

-------------------------------------------
----- =======[ FISHING TAB ] =======
-------------------------------------------
local FishSection = AutoFishTab:Section({ Title = "Automated Systems", Icon = "zap" })

local FuncAutoFishV2 = {
	autofishV2 = false,
	perfectCastV2 = true,
	fishingActiveV2 = false,
	BypassDelayV2 = 0.65 -- Sesuai Instant Delay
}

-- Engine Pancing (Sesuai Struktur Chloe X)
FishSection:Toggle({
	Title = "Auto Fishing (Instant)",
	Content = "Instant catch using 0.65s delay logic",
	Callback = function(value)
		FuncAutoFishV2.autofishV2 = value
        if value then
            task.spawn(function()
                while FuncAutoFishV2.autofishV2 do
                    pcall(function()
                        net:WaitForChild("RE/EquipToolFromHotbar"):FireServer(1)
                        task.wait(0.1)
                        rodRemote:InvokeServer(workspace:GetServerTimeNow())
                        task.wait(0.2)
                        miniGameRemote:InvokeServer(-0.75, 1)
                        task.wait(FuncAutoFishV2.BypassDelayV2)
                        finishRemote:FireServer()
                    end)
                    task.wait(0.5)
                end
            end)
        end
	end
})

FishSection:Input({
	Title = "Custom Instant Delay",
	Content = "Default is 0.65 (Chloe Style)",
	Placeholder = "0.65",
	Callback = function(value)
		FuncAutoFishV2.BypassDelayV2 = tonumber(value) or 0.65
	end,
})

FishSection:Toggle({
    Title = "Auto Sell All",
    Content = "Sells inventory items automatically",
    Callback = function(value)
        state.AutoSell = value
        task.spawn(function()
            while state.AutoSell do
                pcall(function() net:WaitForChild("RF/SellAllItems"):InvokeServer() end)
                task.wait(30)
            end
        end)
    end
})

-------------------------------------------
----- =======[ UTILITY TAB ] =======
-------------------------------------------
local TeleSection = UtilityTab:Section({ Title = "Teleportation", Icon = "map" })

local islandCoords = {
	["Esoteric Depths"] = Vector3.new(3157, -1303, 1439),
	["Keepers Altar"] = Vector3.new(1350, -100, -550), -- Lokasi Favorit
	["Tropical Grove"] = Vector3.new(-2038, 3, 3650),
    ["Winter Fest"] = Vector3.new(1611, 4, 3280)
}

local islandNames = {}
for name, _ in pairs(islandCoords) do table.insert(islandNames, name) end

TeleSection:Dropdown({
    Title = "Island Teleport",
    Values = islandNames,
    Callback = function(selectedName)
        local pos = islandCoords[selectedName]
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
    end
})

TeleSection:Button({
	Title = "Boost FPS",
	Content = "Optimize performance for mobile",
	Callback = function()
		for _, v in pairs(game:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
        end
        WindUI:Notify({Title = "Optimized", Content = "FPS Boost Applied", Duration = 3})
	end,
})

-------------------------------------------
----- =======[ CONFIG TAB ] =======
-------------------------------------------
local ConfSection = SettingsTab:Section({ Title = "Management", Icon = "database" })

ConfSection:Button({
	Title = "Server Hop",
	Callback = function() 
        local TeleportService = game:GetService("TeleportService")
        TeleportService:Teleport(game.PlaceId, LocalPlayer) 
    end,
})

ConfSection:Label({ Title = "SlingerHub v2.0", Content = "Developed by Team eyeGPT" })
