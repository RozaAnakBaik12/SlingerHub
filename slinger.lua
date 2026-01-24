--[[
	SlingerHub - Fixed Edition
	No Rank Check | No Self-Destruct | Optimized for Delta
]]

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Membersihkan koneksi lama agar tidak tumpang tindih
for i,v in next, getconnections(game:GetService("Players").LocalPlayer.Idled) do
    v:Disable()
end

-------------------------------------------
----- =======[ GLOBAL VARIABLES ] =======
-------------------------------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index")["sleitnick_net@0.2.0"].net

-- State
local state = { AutoFish = false, AutoSell = false, AutoFav = false }

-- Remotes (Tanpa pcall berlebihan agar tidak stuck)
local rodRemote = net:WaitForChild("RF/ChargeFishingRod")
local miniGameRemote = net:WaitForChild("RF/RequestFishingMinigameStarted")
local finishRemote = net:WaitForChild("RE/FishingCompleted")

-------------------------------------------
----- =======[ UI SETUP ] =======
-------------------------------------------
local Window = WindUI:CreateWindow({
    Title = "SlingerHub - Fixed",
    Icon = "anchor",
    Author = "SlingerDev",
    Folder = "Slinger_Fixed",
    Size = UDim2.fromOffset(580, 420),
    Theme = "Rose",
    KeySystem = false
})

local MainTab = Window:Tab({ Title = "Automation", Icon = "fish" })
local Section = MainTab:Section({ Title = "Fishing Bot", Icon = "cpu" })

-------------------------------------------
----- =======[ CORE FUNCTION ] =======
-------------------------------------------

local function StartSlingerFish()
    task.spawn(function()
        while state.AutoFish do
            pcall(function()
                -- Equip Rod
                local equip = net:WaitForChild("RE/EquipToolFromHotbar")
                equip:FireServer(1)
                task.wait(0.3)

                -- Casting
                rodRemote:InvokeServer(workspace:GetServerTimeNow())
                task.wait(0.2)
                
                -- Simulate Casting Power
                miniGameRemote:InvokeServer(-0.75, 1)
                
                -- Waiting for fish (Customizable delay)
                task.wait(3.5) 
            end)
            if not state.AutoFish then break end
            task.wait(0.1)
        end
    end)
end

-- Hook untuk menangkap ikan (Exclaim detection)
local textEffect = net:WaitForChild("RE/ReplicateTextEffect")
textEffect.OnClientEvent:Connect(function(data)
    if state.AutoFish and data.TextData and data.TextData.EffectType == "Exclaim" then
        if data.Container == (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")) then
            task.wait(0.5) -- Delay bypass aman
            finishRemote:FireServer()
        end
    end
end)

-------------------------------------------
----- =======[ TOGGLES ] =======
-------------------------------------------

Section:Toggle({
    Title = "Auto Fish V2",
    Content = "Start fishing without rank check",
    Callback = function(value)
        state.AutoFish = value
        if value then 
            StartSlingerFish()
            WindUI:Notify({Title = "SlingerHub", Content = "Bot Started!", Icon = "circle-check"})
        end
    end
})

Section:Button({
    Title = "Force Sell All",
    Callback = function()
        net:WaitForChild("RF/SellAllItems"):InvokeServer()
    end
})

WindUI:Notify({Title = "SlingerHub", Content = "Fixed Script Loaded!", Duration = 5})
