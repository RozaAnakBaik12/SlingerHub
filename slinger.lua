--[[
    SlingerHub - Premium Fishing Suite
    UI: Wind UI (Custom Edition)
    Status: Owner Mode Active
    Authorized by: ArgaaaAi
--]]

local WindUI = loadstring(game:HttpGet("https://tree-hub.vercel.app/api/UI/WindUI"))()
local Window = WindUI:CreateWindow({
    Title = "SlingerHub 👁️",
    Icon = "rbxassetid://10723343321",
    Author = "ArgaaaAi",
    Folder = "SlingerHub_Configs"
})

-- ====== CORE SERVICES & CONFIG ======
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

local Config = {
    AutoFish = false,
    AutoSell = false,
    AutoCatch = false,
    GPUSaver = false,
    BlatantMode = false,
    FishDelay = 0.9,
    CatchDelay = 0.2,
    SellDelay = 30,
    FavoriteRarity = "Mythic",
    AutoFavorite = true
}

local LOCATIONS = {
    ["Spawn"] = CFrame.new(45.2788086, 252.562927, 2987.10913),
    ["Sisyphus Statue"] = CFrame.new(-3728.21606, -135.074417, -1012.12744),
    ["Coral Reefs"] = CFrame.new(-3114.78198, 1.32066584, 2237.52295),
    ["Esoteric Depths"] = CFrame.new(3248.37109, -1301.53027, 1403.82727),
    ["Crater Island"] = CFrame.new(1016.49072, 20.0919304, 5069.27295)
}

-- ====== NETWORK EVENTS ======
local net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
local Events = {
    fishing = net:WaitForChild("RE/FishingCompleted"),
    sell = net:WaitForChild("RF/SellAllItems"),
    charge = net:WaitForChild("RF/ChargeFishingRod"),
    minigame = net:WaitForChild("RF/RequestFishingMinigameStarted"),
    equip = net:WaitForChild("RE/EquipToolFromHotbar"),
    favorite = net:WaitForChild("RE/FavoriteItem")
}

-- ====== FISHING LOGIC ======
local fishingActive = false
local isFishing = false

local function blatantFishing()
    while fishingActive and Config.BlatantMode do
        if not isFishing then
            isFishing = true
            pcall(function()
                Events.equip:FireServer(1)
                task.wait(0.01)
                task.spawn(function()
                    Events.charge:InvokeServer(1755848498.4834)
                    Events.minigame:InvokeServer(1.2854545116425, 1)
                end)
            end)
            task.wait(Config.FishDelay)
            for i = 1, 5 do
                Events.fishing:FireServer()
                task.wait(0.01)
            end
            task.wait(Config.CatchDelay * 0.5)
            isFishing = false
        end
        task.wait(0.01)
    end
end

-- ====== WIND UI TABS ======
local MainTab = Window:CreateTab({ Name = "Automation", Icon = "rbxassetid://10723343321" })

MainTab:AddSection("SlingerHub Core")

MainTab:AddToggle({
    Title = "Blatant Mode (3x Speed)",
    Default = Config.BlatantMode,
    Callback = function(value)
        Config.BlatantMode = value
    end
})

MainTab:AddToggle({
    Title = "Auto Fishing",
    Default = Config.AutoFish,
    Callback = function(value)
        fishingActive = value
        if value then
            task.spawn(function()
                while fishingActive do
                    if Config.BlatantMode then blatantFishing() else
                        if not isFishing then
                            isFishing = true
                            Events.equip:FireServer(1)
                            Events.charge:InvokeServer(1755848498.4834)
                            Events.minigame:InvokeServer(1.2854545116425, 1)
                            task.wait(Config.FishDelay)
                            Events.fishing:FireServer()
                            task.wait(Config.CatchDelay)
                            isFishing = false
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})

MainTab:AddSlider({
    Title = "Action Delay",
    Min = 0.1, Max = 5, Default = 0.9,
    Callback = function(value) Config.FishDelay = value end
})

local WorldTab = Window:CreateTab({ Name = "World", Icon = "rbxassetid://10704907530" })

WorldTab:AddSection("Teleport Gate")

for locName, cframe in pairs(LOCATIONS) do
    WorldTab:AddButton({
        Title = "Travel to " .. locName,
        Callback = function()
            LocalPlayer.Character.HumanoidRootPart.CFrame = cframe
        end
    })
end

local MiscTab = Window:CreateTab({ Name = "Economy", Icon = "rbxassetid://10709819149" })

MiscTab:AddToggle({
    Title = "Auto Sell Items",
    Default = Config.AutoSell,
    Callback = function(value)
        Config.AutoSell = value
        task.spawn(function()
            while Config.AutoSell do
                Events.sell:InvokeServer()
                task.wait(Config.SellDelay)
            end
        end)
    end
})

Window:SelectTab(MainTab)

WindUI:Notify({
    Title = "SlingerHub Active",
    Content = "Welcome Back, Owner.",
    Duration = 5
})
