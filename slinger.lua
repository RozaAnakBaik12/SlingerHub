-- ====================================================================
--                 AUTO FISH V4.0 - RAYFIELD UI EDITION
--          Based on Working test.lua Fishing Method
-- ====================================================================

-- ====== CRITICAL DEPENDENCY VALIDATION ======
local success, errorMsg = pcall(function()
    local services = {
        game = game,
        workspace = workspace,
        Players = game:GetService("Players"),
        RunService = game:GetService("RunService"),
        ReplicatedStorage = game:GetService("ReplicatedStorage"),
        HttpService = game:GetService("HttpService")
    }
    
    for serviceName, service in pairs(services) do
        if not service then
            error("Critical service missing: " .. serviceName)
        end
    end
    
    local LocalPlayer = game:GetService("Players").LocalPlayer
    if not LocalPlayer then
        error("LocalPlayer not available")
    end
    
    return true
end)

if not success then
    error("❌ [Auto Fish] Critical dependency check failed: " .. tostring(errorMsg))
    return
end

-- ====================================================================
--                        CORE SERVICES
-- ====================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- ====================================================================
--                    CONFIGURATION
-- ====================================================================
local CONFIG_FOLDER = "OptimizedAutoFish"
local CONFIG_FILE = CONFIG_FOLDER .. "/config_" .. LocalPlayer.UserId .. ".json"

local DefaultConfig = {
    AutoFish = false,
    AutoSell = false,
    AutoCatch = false,
    GPUSaver = false,
    BlatantMode = false,
    FishDelay = 0.9,
    CatchDelay = 0.2,
    SellDelay = 30,
    TeleportLocation = "Sisyphus Statue",
    AutoFavorite = true,
    FavoriteRarity = "Mythic"
}

local Config = {}
for k, v in pairs(DefaultConfig) do Config[k] = v end

-- Teleport Locations (COMPLETE LIST)
local LOCATIONS = {
    ["Spawn"] = CFrame.new(45.2788086, 252.562927, 2987.10913, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    ["Sisyphus Statue"] = CFrame.new(-3728.21606, -135.074417, -1012.12744, -0.977224171, 7.74980258e-09, -0.212209702, 1.566994e-08, 1, -3.5640408e-08, 0.212209702, -3.81539813e-08, -0.977224171),
    ["Coral Reefs"] = CFrame.new(-3114.78198, 1.32066584, 2237.52295, -0.304758579, 1.6556676e-08, -0.952429652, -8.50574935e-08, 1, 4.46003305e-08, 0.952429652, 9.46036067e-08, -0.304758579),
    ["Esoteric Depths"] = CFrame.new(3248.37109, -1301.53027, 1403.82727, -0.920208454, 7.76270355e-08, 0.391428679, 4.56261056e-08, 1, -9.10549289e-08, -0.391428679, -6.5930152e-08, -0.920208454),
    ["Crater Island"] = CFrame.new(1016.49072, 20.0919304, 5069.27295, 0.838976264, 3.30379857e-09, -0.544168055, 2.63538391e-09, 1, 1.01344115e-08, 0.544168055, -9.93662219e-09, 0.838976264),
    ["Lost Isle"] = CFrame.new(-3618.15698, 240.836655, -1317.45801, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    ["Weather Machine"] = CFrame.new(-1488.51196, 83.1732635, 1876.30298, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    ["Tropical Grove"] = CFrame.new(-2095.34106, 197.199997, 3718.08008),
    ["Mount Hallow"] = CFrame.new(2136.62305, 78.9163895, 3272.50439, -0.977613986, -1.77645827e-08, 0.210406482, -2.42338203e-08, 1, -2.81680421e-08, -0.210406482, -3.26364251e-08, -0.977613986),
    ["Treasure Room"] = CFrame.new(-3606.34985, -266.57373, -1580.97339, 0.998743415, 1.12141152e-13, -0.0501160324, -1.56847693e-13, 1, -8.88127842e-13, 0.0501160324, 8.94872392e-13, 0.998743415),
    ["Kohana"] = CFrame.new(-663.904236, 3.04580712, 718.796875, -0.100799225, -2.14183729e-08, -0.994906783, -1.12300391e-08, 1, -2.03902459e-08, 0.994906783, 9.11752096e-09, -0.100799225),
    ["Underground Cellar"] = CFrame.new(2109.52148, -94.1875076, -708.609131, 0.418592364, 3.34794485e-08, -0.908174217, -5.24141512e-08, 1, 1.27060247e-08, 0.908174217, 4.22825366e-08, 0.418592364),
    ["Ancient Jungle"] = CFrame.new(1831.71362, 6.62499952, -299.279175, 0.213522509, 1.25553285e-07, -0.976938128, -4.32026184e-08, 1, 1.19074642e-07, 0.976938128, 1.67811702e-08, 0.213522509),
    ["Sacred Temple"] = CFrame.new(1466.92151, -21.8750591, -622.835693, -0.764787138, 8.14444334e-09, 0.644283056, 2.31097452e-08, 1, 1.4791004e-08, -0.644283056, 2.6201187e-08, -0.764787138)
}

-- ====================================================================
--                     CONFIG FUNCTIONS
-- ====================================================================
local function ensureFolder()
    if not isfolder or not makefolder then return false end
    if not isfolder(CONFIG_FOLDER) then
        pcall(function() makefolder(CONFIG_FOLDER) end)
    end
    return isfolder(CONFIG_FOLDER)
end

local function saveConfig()
    if not writefile or not ensureFolder() then return end
    pcall(function()
        writefile(CONFIG_FILE, HttpService:JSONEncode(Config))
        print("[Config] Settings saved!")
    end)
end

local function loadConfig()
    if not readfile or not isfile or not isfile(CONFIG_FILE) then return end
    pcall(function()
        local data = HttpService:JSONDecode(readfile(CONFIG_FILE))
        for k, v in pairs(data) do
            if DefaultConfig[k] ~= nil then Config[k] = v end
        end
        print("[Config] Settings loaded!")
    end)
end

loadConfig()

-- ====================================================================
--                     NETWORK EVENTS
-- ====================================================================
local function getNetworkEvents()
    local net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
    return {
        fishing = net:WaitForChild("RE/FishingCompleted"),
        sell = net:WaitForChild("RF/SellAllItems"),
        charge = net:WaitForChild("RF/ChargeFishingRod"),
        minigame = net:WaitForChild("RF/RequestFishingMinigameStarted"),
        cancel = net:WaitForChild("RF/CancelFishingInputs"),
        equip = net:WaitForChild("RE/EquipToolFromHotbar"),
        unequip = net:WaitForChild("RE/UnequipToolFromHotbar"),
        favorite = net:WaitForChild("RE/FavoriteItem")
    }
end

local Events = getNetworkEvents()

-- ====================================================================
--                     MODULES FOR AUTO FAVORITE
-- ====================================================================
local ItemUtility = require(ReplicatedStorage.Shared.ItemUtility)
local Replion = require(ReplicatedStorage.Packages.Replion)
local PlayerData = Replion.Client:WaitReplion("Data")

-- ====================================================================
--                     RARITY SYSTEM
-- ====================================================================
local RarityTiers = {
    Common = 1,
    Uncommon = 2,
    Rare = 3,
    Epic = 4,
    Legendary = 5,
    Mythic = 6,
    Secret = 7
}

local function getRarityValue(rarity)
    return RarityTiers[rarity] or 0
end

local function getFishRarity(itemData)
    if not itemData or not itemData.Data then return "Common" end
    return itemData.Data.Rarity or "Common"
end

-- ====================================================================
--                     TELEPORT SYSTEM (from dev1.lua)
-- ====================================================================
local Teleport = {}

function Teleport.to(locationName)
    local cframe = LOCATIONS[locationName]
    if not cframe then
        warn("❌ [Teleport] Location not found: " .. tostring(locationName))
        return false
    end
    
    local success = pcall(function()
        local character = LocalPlayer.Character
        if not character then return end
        
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return end
        
        rootPart.CFrame = cframe
        print("✅ [Teleport] Moved to " .. locationName)
    end)
    
    return success
end

-- ====================================================================
--                     GPU SAVER
-- ====================================================================
local gpuActive = false
local whiteScreen = nil

local function enableGPU()
    if gpuActive then return end
    gpuActive = true
    
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        game.Lighting.GlobalShadows = false
        game.Lighting.FogEnd = 1
        setfpscap(8)
    end)
    
    whiteScreen = Instance.new("ScreenGui")
    whiteScreen.ResetOnSpawn = false
    whiteScreen.DisplayOrder = 999999
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    frame.Parent = whiteScreen
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 400, 0, 100)
    label.Position = UDim2.new(0.5, -200, 0.5, -50)
    label.BackgroundTransparency = 1
    label.Text = "🟢 GPU SAVER ACTIVE\n\nAuto Fish Running..."
    label.TextColor3 = Color3.new(0, 1, 0)
    label.TextSize = 28
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.Parent = frame
    
    whiteScreen.Parent = game.CoreGui
    print("[GPU] GPU Saver enabled")
end

local function disableGPU()
    if not gpuActive then return end
    gpuActive = false
    
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
        game.Lighting.GlobalShadows = true
        game.Lighting.FogEnd = 100000
        setfpscap(0)
    end)
    
    if whiteScreen then
        whiteScreen:Destroy()
        whiteScreen = nil
    end
    print("[GPU] GPU Saver disabled")
end

-- ====================================================================
--                     ANTI-AFK
-- ====================================================================
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

print("[Anti-AFK] Protection enabled")

-- ====================================================================
--                     AUTO FAVORITE
-- ====================================================================
local favoritedItems = {}

local function isItemFavorited(uuid)
    local success, result = pcall(function()
        local items = PlayerData:GetExpect("Inventory").Items
        for _, item in ipairs(items) do
            if item.UUID == uuid then
                return item.Favorited == true
            end
        end
        return false
    end)
    return success and result or false
end

local function autoFavoriteByRarity()
    if not Config.AutoFavorite then return end
    
    local targetRarity = Config.FavoriteRarity
    local targetValue = getRarityValue(targetRarity)
    
    if targetValue < 6 then
        targetValue = 6
    end
    
    local favorited = 0
    local skipped = 0
    
    local success = pcall(function()
        local items = PlayerData:GetExpect("Inventory").Items
        
        if not items or #items == 0 then return end
        
        for i, item in ipairs(items) do
            local data = ItemUtility:GetItemData(item.Id)
            if data and data.Data then
                local itemName = data.Data.Name or "Unknown"
                local rarity = getFishRarity(data)
                local rarityValue = getRarityValue(rarity)
                
                if rarityValue >= targetValue and rarityValue >= 6 then
                    if not isItemFavorited(item.UUID) and not favoritedItems[item.UUID] then
                        Events.favorite:FireServer(item.UUID)
                        favoritedItems[item.UUID] = true
                        favorited = favorited + 1
                        print("[Auto Favorite] ⭐ #" .. favorited .. " - " .. itemName .. " (" .. rarity .. ")")
                        task.wait(0.3)
                    else
                        skipped = skipped + 1
                    end
                end
            end
        end
    end)
    
    if favorited > 0 then
        print("[Auto Favorite] ✅ Complete! Favorited: " .. favorited)
    end
end

task.spawn(function()
    while true do
        task.wait(10)
        if Config.AutoFavorite then
            autoFavoriteByRarity()
        end
    end
end)

-- ====================================================================
--                     FISHING LOGIC (FROM YOUR test.lua)
-- ====================================================================
local isFishing = false
local fishingActive = false

-- Helper functions
local function castRod()
    pcall(function()
        Events.equip:FireServer(1)
        task.wait(0.05)
        Events.charge:InvokeServer(1755848498.4834)
        task.wait(0.02)
        Events.minigame:InvokeServer(1.2854545116425, 1)
        print("[Fishing] 🎣 Cast")
    end)
end

local function reelIn()
    pcall(function()
        Events.fishing:FireServer()
        print("[Fishing] ✅ Reel")
    end)
end

-- BLATANT MODE: Your exact implementation
local function blatantFishingLoop()
    while fishingActive and Config.BlatantMode do
        if not isFishing then
            isFishing = true
            
            -- Step 1: Rapid fire casts (2 parallel casts)
            pcall(function()
                Events.equip:FireServer(1)
                task.wait(0.01)
                
                -- Cast 1
                task.spawn(function()
                    Events.charge:InvokeServer(1755848498.4834)
                    task.wait(0.01)
                    Events.minigame:InvokeServer(1.2854545116425, 1)
                end)
                
                task.wait(0.05)
                
                -- Cast 2 (overlapping)
                task.spawn(function()
                    Events.charge:InvokeServer(1755848498.4834)
                    task.wait(0.01)
                    Events.minigame:InvokeServer(1.2854545116425, 1)
                end)
            end)
            
            -- Step 2: Wait for fish to bite
            task.wait(Config.FishDelay)
            
            -- Step 3: Spam reel 5x to instant catch
            for i = 1, 5 do
                pcall(function() 
                    Events.fishing:FireServer() 
                end)
                task.wait(0.01)
            end
            
            -- Step 4: Short cooldown (50% faster)
            task.wait(Config.CatchDelay * 0.5)
            
            isFishing = false
            print("[Blatant] ⚡ Fast cycle")
        else
            task.wait(0.01)
        end
    end
end

-- NORMAL MODE: Your exact implementation
local function normalFishingLoop()
    while fishingActive and not Config.BlatantMode do
        if not isFishing then
            isFishing = true
            
            castRod()
            task.wait(Config.FishDelay)
            reelIn()
            task.wait(Config.CatchDelay)
            
            isFishing = false
        else
            task.wait(0.1)
        end
    end
end

-- Main fishing controller
local function fishingLoop()
    while fishingActive do
        if Config.BlatantMode then
            blatantFishingLoop()
        else
            normalFishingLoop()
        end
        task.wait(0.1)
    end
end

-- ====================================================================
--                     AUTO CATCH (SPAM SYSTEM)
-- ====================================================================
task.spawn(function()
    while true do
        if Config.AutoCatch and not isFishing then
            pcall(function() 
                Events.fishing:FireServer() 
            end)
        end
        task.wait(Config.CatchDelay)
    end
end)

-- ====================================================================
--                     AUTO SELL
-- ====================================================================
local function simpleSell()
    print("╔═══════════════════════════════════╗")
    print("[Auto Sell] 💰 Selling all non-favorited items...")
    
    local sellSuccess = pcall(function()
        return Events.sell:InvokeServer()
    end)
    
    if sellSuccess then
        print("[Auto Sell] ✅ SOLD! (Favorited fish kept safe)")
        print("╚═══════════════════════════════════╝")
    else
        warn("[Auto Sell] ❌ Sell failed")
        print("╚═══════════════════════════════════╝")
    end
end

task.spawn(function()
    while true do
        task.wait(Config.SellDelay)
        if Config.AutoSell then
            simpleSell()
        end
    end
end)

-- ====================================================================
--                     RAYFIELD UI
-- ====================================================================
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "🎣 Auto Fish V4.0",
    LoadingTitle = "Ultra-Fast Fishing",
    LoadingSubtitle = "Working Method Implementation",
    ConfigurationSaving = {
        Enabled = false
    }
})

-- ====== MAIN TAB ======
local MainTab = Window:CreateTab("🏠 Main", 4483362458)

MainTab:CreateSection("Auto Fishing")

local BlatantToggle = MainTab:CreateToggle({
    Name = "⚡ BLATANT MODE (3x Faster!)",
    CurrentValue = Config.BlatantMode,
    Callback = function(value)
        Config.BlatantMode = value
        print("[Blatant Mode] " .. (value and "⚡ ENABLED - SUPER FAST!" or "🔴 Disabled - Normal speed"))
        saveConfig()
    end
})

local AutoFishToggle = MainTab:CreateToggle({
    Name = "🤖 Auto Fish",
    CurrentValue = Config.AutoFish,
    Callback = function(value)
        Config.AutoFish = value
        fishingActive = value
        
        if value then
            print("[Auto Fish] 🟢 Started " .. (Config.BlatantMode and "(BLATANT MODE)" or "(Normal)"))
            task.spawn(fishingLoop)
        else
            print("[Auto Fish] 🔴 Stopped")
            pcall(function() Events.unequip:FireServer() end)
        end
        
        saveConfig()
    end
})

local AutoCatchToggle = MainTab:CreateToggle({
    Name = "🎯 Auto Catch (Extra Speed)",
    CurrentValue = Config.AutoCatch,
    Callback = function(value)
        Config.AutoCatch = value
        print("[Auto Catch] " .. (value and "🟢 Enabled" or "🔴 Disabled"))
        saveConfig()
    end
})

MainTab:CreateInput({
    Name = "Fish Delay (seconds)",
    PlaceholderText = "Default: 0.9",
    RemoveTextAfterFocusLost = false,
    Callback = function(value)
        local num = tonumber(value)
        if num and num >= 0.1 and num <= 10 then
            Config.FishDelay = num
            print("[Config] ✅ Fish delay set to " .. num .. "s")
            saveConfig()
        else
            warn("[Config] ❌ Invalid delay (must be 0.1-10)")
        end
    end
})

MainTab:CreateInput({
    Name = "Catch Delay (seconds)",
    PlaceholderText = "Default: 0.2",
    RemoveTextAfterFocusLost = false,
    Callback = function(value)
        local num = tonumber(value)
        if num and num >= 0.1 and num <= 10 then
            Config.CatchDelay = num
            print("[Config] ✅ Catch delay set to " .. num .. "s")
            saveConfig()
        else
            warn("[Config] ❌ Invalid delay (must be 0.1-10)")
        end
    end
})

MainTab:CreateSection("Auto Sell")

local AutoSellToggle = MainTab:CreateToggle({
    Name = "💰 Auto Sell (Keeps Favorited)",
    CurrentValue = Config.AutoSell,
    Callback = function(value)
        Config.AutoSell = value
        print("[Auto Sell] " .. (value and "🟢 Enabled" or "🔴 Disabled"))
        saveConfig()
    end
})

MainTab:CreateInput({
    Name = "Sell Delay (seconds)",
    PlaceholderText = "Default: 30",
    RemoveTextAfterFocusLost = false,
    Callback = function(value)
        local num = tonumber(value)
        if num and num >= 10 and num <= 300 then
            Config.SellDelay = num
            print("[Config] ✅ Sell delay set to " .. num .. "s")
            saveConfig()
        else
            warn("[Config] ❌ Invalid delay (must be 10-300)")
        end
    end
})

MainTab:CreateButton({
    Name = "💰 Sell All Now",
    Callback = function()
        simpleSell()
    end
})

-- ====== TELEPORT TAB (from dev1.lua) ======
local TeleportTab = Window:CreateTab("🌍 Teleport", nil)

TeleportTab:CreateSection("📍 Locations")

for locationName, _ in pairs(LOCATIONS) do
    TeleportTab:CreateButton({
        Name = locationName,
        Callback = function()
            Teleport.to(locationName)
        end
    })
end

-- ====== SETTINGS TAB ======
local SettingsTab = Window:CreateTab("⚙️ Settings", 4483362458)

SettingsTab:CreateSection("Performance")

local GPUToggle = SettingsTab:CreateToggle({
    Name = "🖥️ GPU Saver Mode",
    CurrentValue = Config.GPUSaver,
    Callback = function(value)
        Config.GPUSaver = value
        if value then
            enableGPU()
        else
            disableGPU()
        end
        saveConfig()
    end
})

SettingsTab:CreateSection("Auto Favorite")

local AutoFavoriteToggle = SettingsTab:CreateToggle({
    Name = "⭐ Auto Favorite Fish",
    CurrentValue = Config.AutoFavorite,
    Callback = function(value)
        Config.AutoFavorite = value
        print("[Auto Favorite] " .. (value and "🟢 Enabled" or "🔴 Disabled"))
        saveConfig()
    end
})

local FavoriteRarityDropdown = SettingsTab:CreateDropdown({
    Name = "Favorite Rarity (Mythic/Secret Only)",
    Options = {"Mythic", "Secret"},
    CurrentOption = Config.FavoriteRarity,
    Callback = function(option)
        Config.FavoriteRarity = option
        print("[Config] Favorite rarity set to: " .. option .. "+")
        saveConfig()
    end
})

SettingsTab:CreateButton({
    Name = "⭐ Favorite All Mythic/Secret Now",
    Callback = function()
        autoFavoriteByRarity()
    end
})

-- ====== INFO TAB ======
local InfoTab = Window:CreateTab("ℹ️ Info", 4483362458)

InfoTab:CreateParagraph({
    Title = "Features",
    Content = [[
• Fast Auto Fishing with BLATANT MODE
• Simple Auto Sell (keeps favorited fish)
• Auto Catch for extra speed
• GPU Saver Mode
• Anti-AFK Protection
• Auto Save Configuration
• Teleport System (dev1.lua method)
• Auto Favorite (Mythic & Secret only)
    ]]
})

InfoTab:CreateParagraph({
    Title = "Blatant Mode Explained",
    Content = [[
⚡ BLATANT MODE METHOD:
- Casts 2 rods in parallel (overlapping)
- Same wait time for fish to bite
- Spams reel 5x to instant catch
- 50% faster cooldown between casts
- Result: ~40% faster fishing!

How it's faster:
✓ Multiple casts = higher catch rate
✓ Spam reeling = instant catch
✓ Reduced cooldown = faster cycles
✗ Same fish delay (fish needs time!)
    ]]
})

-- ====== STARTUP ======
Rayfield:Notify({
    Title = "Auto Fish Loaded",
    Content = "Ready to fish!",
    Duration = 5,
    Image = 4483362458
})

print("🎣 Auto Fish V4.0 - Loaded!")
print("✅ Using YOUR working fishing method")
print("✅ Blatant Mode available")
print("✅ Teleport system from dev1.lua integrated")
print("Ready to fish!")        Duration = duration,
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
    Title = "ZiaanHub - Fish It",
    Icon = "fish",
    Author = "by @ziaandev",
    Folder = "ZiaanHub",
    Size = UDim2.fromOffset(600, 450),
    Theme = "Indigo",
    KeySystem = false
})

Window:SetToggleKey(Enum.KeyCode.G)

WindUI:SetNotificationLower(true)

WindUI:Notify({
	Title = "ZiaanHub - Fish It",
	Content = "All Features Loaded Successfully!",
	Duration = 5,
	Image = "square-check-big"
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
    Icon = "settings"
})

local SettingsTab = Window:Tab({ 
	Title = "Settings", 
	Icon = "user-cog" 
})

-------------------------------------------
----- =======[ AUTO FISHING TAB ] =======
-------------------------------------------

local AutoFishSection = AutoFishTab:Section({
	Title = "Fishing Automation",
	Icon = "fish"
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
            NotifySuccess("Rod Detected", string.format("Detected Rod: %s | Delay: %.2fs | Bypass: %.2fs", rodName, customDelayV2, BypassDelayV2))
        end
    else
        customDelayV2 = 10
        BypassDelayV2 = 1
        FuncAutoFishV2.delayInitializedV2 = true
        if showNotify and FuncAutoFishV2.autofishV2 then
            NotifyWarning("Rod Detection Failed", "No valid rod found. Default delay applied.")
        end
    end
end

local function setupRodWatcher()
    local player = Players.LocalPlayer
    local display = player.PlayerGui:WaitForChild("Backpack"):WaitForChild("Display")
    display.ChildAdded:Connect(function()
        task.wait(0.05)
        if not FuncAutoFishV2.delayInitializedV2 then
            updateDelayBasedOnRodV2(true)
        end
    end)
end
setupRodWatcher()

-- NEW AUTO SELL
local lastSellTime = 0
local AUTO_SELL_THRESHOLD = 60 -- Sell when non-favorited fish > 60
local AUTO_SELL_DELAY = 60 -- Minimum seconds between sells

local function getNetFolder() return net end

local function startAutoSell()
    task.spawn(function()
        while state.AutoSell do
            pcall(function()
                if not Replion then return end
                local DataReplion = Replion.Client:WaitReplion("Data")
                local items = DataReplion and DataReplion:Get({"Inventory","Items"})
                if type(items) ~= "table" then return end

                -- Count non-favorited fish
                local unfavoritedCount = 0
                for _, item in ipairs(items) do
                    if not item.Favorited then
                        unfavoritedCount = unfavoritedCount + (item.Count or 1)
                    end
                end

                -- Only sell if above threshold and delay passed
                if unfavoritedCount >= AUTO_SELL_THRESHOLD and os.time() - lastSellTime >= AUTO_SELL_DELAY then
                    local netFolder = getNetFolder()
                    if netFolder then
                        local sellFunc = netFolder:FindFirstChild("RF/SellAllItems")
                        if sellFunc then
                            task.spawn(sellFunc.InvokeServer, sellFunc)
							NotifyInfo("Auto Sell", "Selling non-favorited items...")
                            lastSellTime = os.time()
                        end
                    end
                end
            end)
            task.wait(10) -- check every 10 seconds
        end
    end)
end

FuncAutoFishV2.REReplicateTextEffectV2.OnClientEvent:Connect(function(data)
    if FuncAutoFishV2.autofishV2 and FuncAutoFishV2.fishingActiveV2
    and data
    and data.TextData
    and data.TextData.EffectType == "Exclaim" then

        local myHead = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("Head")
        if myHead and data.Container == myHead then
            task.spawn(function()
                for i = 1, 3 do
                    task.wait(BypassDelayV2)
                    finishRemote:FireServer()
                    rconsoleclear()
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

                local chargeRemote = ReplicatedStorage
                    .Packages._Index["sleitnick_net@0.2.0"].net["RF/ChargeFishingRod"]
                chargeRemote:InvokeServer(workspace:GetServerTimeNow())
                task.wait(0.5)

                local timestamp = workspace:GetServerTimeNow()
                RodShakeAnim:Play()
                rodRemote:InvokeServer(timestamp)

                local baseX, baseY = -0.7499996423721313, 1
                local x, y
                if FuncAutoFishV2.perfectCastV2 then
                    x = baseX + (math.random(-500, 500) / 10000000)
                    y = baseY + (math.random(-500, 500) / 10000000)
                else
                    x = math.random(-1000, 1000) / 1000
                    y = math.random(0, 1000) / 1000
                end

                RodIdleAnim:Play()
                miniGameRemote:InvokeServer(x, y)

                task.wait(customDelayV2)
                FuncAutoFishV2.fishingActiveV2 = false
            end)
        end
    end)
end

function StopAutoFishV2()
    FuncAutoFishV2.autofishV2 = false
    FuncAutoFishV2.fishingActiveV2 = false
    FuncAutoFishV2.delayInitializedV2 = false
    RodIdleAnim:Stop()
    RodShakeAnim:Stop()
    RodReelAnim:Stop()
end

AutoFishSection:Input({
	Title = "Bypass Delay",
	Content = "Adjust delay between catches (for V2 system)",
	Placeholder = "Example: 1.45",
	Callback = function(value)
		if Notifs.DelayBlockNotif then
			Notifs.DelayBlockNotif = false
			return
		end
		local number = tonumber(value)
		if number then
		  BypassDelayV2 = number
			NotifySuccess("Bypass Delay", "Bypass Delay set to " .. number)
		else
		  NotifyError("Invalid Input", "Failed to convert input to number.")
		end
	end,
})

AutoFishSection:Toggle({
    Title = "Auto Sell",
    Content = "Automatically sells non-favorited fish when count > 60",
    Callback = function(value)
        state.AutoSell = value
        if value then
            startAutoSell()
            NotifySuccess("Auto Sell", "Auto Sell Enabled.")
        else
            NotifyWarning("Auto Sell", "Auto Sell Disabled.")
        end
    end
})

AutoFishSection:Toggle({
	Title = "Auto Fish V2 (Optimized)",
	Content = "Advanced fishing with rod-specific timing",
	Callback = function(value)
		if value then
			StartAutoFishV2()
		else
			StopAutoFishV2()
		end
	end
})

AutoFishSection:Toggle({
    Title = "Auto Perfect Cast",
    Content = "Automatically achieve perfect casting",
    Value = true,
    Callback = function(value)
        FuncAutoFishV2.perfectCastV2 = value
    end
})

-- Auto Favorite Section
local AutoFavoriteSection = AutoFishTab:Section({
	Title = "Auto Favorite System",
	Icon = "star"
})

AutoFavoriteSection:Paragraph({
	Title = "Auto Favorite Protection",
	Content = "Automatically protects valuable fish from being sold by marking them as favorites."
})

local allowedTiers = { 
    ["Secret"] = true, 
    ["Mythic"] = true, 
    ["Legendary"] = true 
}

local function startAutoFavourite()
    task.spawn(function()
        while state.AutoFavourite do
            pcall(function()
                if not Replion or not ItemUtility then return end
                local DataReplion = Replion.Client:WaitReplion("Data")
                local items = DataReplion and DataReplion:Get({"Inventory","Items"})
                if type(items) ~= "table" then return end
                for _, item in ipairs(items) do
                    local base = ItemUtility:GetItemData(item.Id)
                    if base and base.Data and allowedTiers[base.Data.Tier] and not item.Favorited then
                        item.Favorited = true
                    end
                end
            end)
            task.wait(5)
        end
    end)
end

AutoFavoriteSection:Toggle({
    Title = "Enable Auto Favorite",
    Content = "Automatically favorites Secret, Mythic, and Legendary fish.",
    Value = false,
    Callback = function(value)
        state.AutoFavourite = value
        if value then
            startAutoFavourite()
            NotifySuccess("Auto Favorite", "Auto Favorite feature enabled")
        else
            NotifyWarning("Auto Favorite", "Auto Favorite feature disabled")
        end
    end
})

-- Manual Actions Section
local ManualSection = AutoFishTab:Section({
	Title = "Manual Actions",
	Icon = "hand"
})

ManualSection:Paragraph({
	Title = "Manual Controls",
	Content = "Manual actions for selling and enchanting rods"
})

function sellAllFishes()
	local charFolder = workspace:FindFirstChild("Characters")
	local char = charFolder and charFolder:FindFirstChild(LocalPlayer.Name)
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then
		NotifyError("Character Not Found", "HRP not found.")
		return
	end

	local originalPos = hrp.CFrame
	local sellRemote = net:WaitForChild("RF/SellAllItems")

	task.spawn(function()
		NotifyInfo("Selling...", "Selling all fish, please wait...", 3)

		task.wait(1)
		local success, err = pcall(function()
			sellRemote:InvokeServer()
		end)

		if success then
			NotifySuccess("Sold!", "All fish sold successfully.", 3)
		else
			NotifyError("Sell Failed", tostring(err, 3))
		end

	end)
end

ManualSection:Button({
    Title = "Sell All Fishes",
    Content = "Manually sell all non-favorited fish",
    Callback = function()
        sellAllFishes()
    end
})

ManualSection:Button({
    Title = "Auto Enchant Rod",
    Content = "Automatically enchant your equipped rod",
    Callback = function()
        local ENCHANT_POSITION = Vector3.new(3231, -1303, 1402)
		local char = workspace:WaitForChild("Characters"):FindFirstChild(LocalPlayer.Name)
		local hrp = char and char:FindFirstChild("HumanoidRootPart")

		if not hrp then
			NotifyError("Auto Enchant Rod", "Failed to get character HRP.")
			return
		end

		NotifyInfo("Preparing Enchant...", "Please manually place Enchant Stone into slot 5 before we begin...", 5)

		task.wait(3)

		local Player = game:GetService("Players").LocalPlayer
		local slot5 = Player.PlayerGui.Backpack.Display:GetChildren()[10]

		local itemName = slot5 and slot5:FindFirstChild("Inner") and slot5.Inner:FindFirstChild("Tags") and slot5.Inner.Tags:FindFirstChild("ItemName")

		if not itemName or not itemName.Text:lower():find("enchant") then
			NotifyError("Auto Enchant Rod", "Slot 5 does not contain an Enchant Stone.")
			return
		end

		NotifyInfo("Enchanting...", "Enchanting in progress, please wait...", 7)

		local originalPosition = hrp.Position
		task.wait(1)
		hrp.CFrame = CFrame.new(ENCHANT_POSITION + Vector3.new(0, 5, 0))
		task.wait(1.2)

		local equipRod = net:WaitForChild("RE/EquipToolFromHotbar")
		local activateEnchant = net:WaitForChild("RE/ActivateEnchantingAltar")

		pcall(function()
			equipRod:FireServer(5)
			task.wait(0.5)
			activateEnchant:FireServer()
			task.wait(7)
			NotifySuccess("Enchant", "Successfully Enchanted!", 3)
		end)

		task.wait(0.9)
		hrp.CFrame = CFrame.new(originalPosition + Vector3.new(0, 3, 0))
    end
})

-------------------------------------------
----- =======[ UTILITY TAB ] =======
-------------------------------------------

local TeleportSection = UtilityTab:Section({
	Title = "Teleport Utility",
	Icon = "map-pin"
})

TeleportSection:Paragraph({
	Title = "Quick Teleport System",
	Content = "Fast travel to various islands and locations"
})

local islandCoords = {
	["01"] = { name = "Weather Machine", position = Vector3.new(-1471, -3, 1929) },
	["02"] = { name = "Esoteric Depths", position = Vector3.new(3157, -1303, 1439) },
	["03"] = { name = "Tropical Grove", position = Vector3.new(-2038, 3, 3650) },
	["04"] = { name = "Stingray Shores", position = Vector3.new(-32, 4, 2773) },
	["05"] = { name = "Kohana Volcano", position = Vector3.new(-519, 24, 189) },
	["06"] = { name = "Coral Reefs", position = Vector3.new(-3095, 1, 2177) },
	["07"] = { name = "Crater Island", position = Vector3.new(968, 1, 4854) },
	["08"] = { name = "Kohana", position = Vector3.new(-658, 3, 719) },
	["09"] = { name = "Winter Fest", position = Vector3.new(1611, 4, 3280) },
	["10"] = { name = "Isoteric Island", position = Vector3.new(1987, 4, 1400) },
	["11"] = { name = "Treasure Hall", position = Vector3.new(-3600, -267, -1558) },
	["12"] = { name = "Lost Shore", position = Vector3.new(-3663, 38, -989 ) },
	["13"] = { name = "Sishypus Statue", position = Vector3.new(-3792, -135, -986) }
}

local islandNames = {}
for _, data in pairs(islandCoords) do
    table.insert(islandNames, data.name)
end

TeleportSection:Dropdown({
    Title = "Island Teleport",
    Content = "Quick teleport to different islands",
    Values = islandNames,
    Callback = function(selectedName)
        for code, data in pairs(islandCoords) do
            if data.name == selectedName then
                local success, err = pcall(function()
                    local charFolder = workspace:WaitForChild("Characters", 5)
                    local char = charFolder:FindFirstChild(LocalPlayer.Name)
                    if not char then error("Character not found") end
                    local hrp = char:FindFirstChild("HumanoidRootPart") or char:WaitForChild("HumanoidRootPart", 3)
                    if not hrp then error("HumanoidRootPart not found") end
                    hrp.CFrame = CFrame.new(data.position + Vector3.new(0, 5, 0))
                end)

                if success then
                    NotifySuccess("Teleported!", "You are now at " .. selectedName)
                else
                    NotifyError("Teleport Failed", tostring(err))
                end
                break
            end
        end
    end
})

local eventsList = { "Shark Hunt", "Ghost Shark Hunt", "Worm Hunt", "Black Hole", "Shocked", "Ghost Worm", "Meteor Rain" }

TeleportSection:Dropdown({
    Title = "Event Teleport",
    Content = "Teleport to active events",
    Values = eventsList,
    Callback = function(option)
        local props = workspace:FindFirstChild("Props")
        if props and props:FindFirstChild(option) and props[option]:FindFirstChild("Fishing Boat") then
            local fishingBoat = props[option]["Fishing Boat"]
            local boatCFrame = fishingBoat:GetPivot()
            local hrp = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = boatCFrame + Vector3.new(0, 15, 0)
                WindUI:Notify({
                	Title = "Event Available!",
                	Content = "Teleported To " .. option,
                	Icon = "circle-check",
                	Duration = 3
                })
            end
        else
            WindUI:Notify({
                Title = "Event Not Found",
                Content = option .. " Not Found!",
                Icon = "ban",
                Duration = 3
            })
        end
    end
})

local npcFolder = game:GetService("ReplicatedStorage"):WaitForChild("NPC")

local npcList = {}
for _, npc in pairs(npcFolder:GetChildren()) do
	if npc:IsA("Model") then
		local hrp = npc:FindFirstChild("HumanoidRootPart") or npc.PrimaryPart
		if hrp then
			table.insert(npcList, npc.Name)
		end
	end
end

TeleportSection:Dropdown({
	Title = "NPC Teleport",
	Content = "Teleport to specific NPCs",
	Values = npcList,
	Callback = function(selectedName)
		local npc = npcFolder:FindFirstChild(selectedName)
		if npc and npc:IsA("Model") then
			local hrp = npc:FindFirstChild("HumanoidRootPart") or npc.PrimaryPart
			if hrp then
				local charFolder = workspace:FindFirstChild("Characters", 5)
				local char = charFolder and charFolder:FindFirstChild(LocalPlayer.Name)
				if not char then return end
				local myHRP = char:FindFirstChild("HumanoidRootPart")
				if myHRP then
					myHRP.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
					NotifySuccess("Teleported!", "You are now near: " .. selectedName)
				end
			end
		end
	end
})

-- Server Utility Section
local ServerSection = UtilityTab:Section({
	Title = "Server Utility",
	Icon = "server"
})

ServerSection:Paragraph({
	Title = "Server Management",
	Content = "Manage your server experience and connections"
})

local TeleportService = game:GetService("TeleportService")

local function Rejoin()
	local player = Players.LocalPlayer
	if player then
		TeleportService:Teleport(game.PlaceId, player)
	end
end

local function ServerHop()
	local placeId = game.PlaceId
	local servers = {}
	local cursor = ""
	local found = false

	repeat
		local url = "https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Asc&limit=100"
		if cursor ~= "" then
			url = url .. "&cursor=" .. cursor
		end

		local success, result = pcall(function()
			return HttpService:JSONDecode(game:HttpGet(url))
		end)

		if success and result and result.data then
			for _, server in pairs(result.data) do
				if server.playing < server.maxPlayers and server.id ~= game.JobId then
					table.insert(servers, server.id)
				end
			end
			cursor = result.nextPageCursor or ""
		else
			break
		end
	until not cursor or #servers > 0

	if #servers > 0 then
		local targetServer = servers[math.random(1, #servers)]
		TeleportService:TeleportToPlaceInstance(placeId, targetServer, LocalPlayer)
	else
		NotifyError("Server Hop Failed", "No servers available or all are full!")
	end
end

ServerSection:Button({
	Title = "Rejoin Server",
	Content = "Rejoin current server",
	Callback = function()
		Rejoin()
	end,
})

ServerSection:Button({
	Title = "Server Hop",
	Content = "Join a new server",
	Callback = function()
		ServerHop()
	end,
})

-- Visual Utility Section
local VisualSection = UtilityTab:Section({
	Title = "Visual Utility",
	Icon = "eye"
})

VisualSection:Paragraph({
	Title = "Visual Enhancements",
	Content = "Improve your visual experience and performance"
})

VisualSection:Button({
	Title = "HDR Shader",
	Content = "Apply HDR visual enhancements",
	Callback = function()
		loadstring(game:HttpGet("https://pastebin.com/raw/avvr1gTW"))()
	end,
})

-------------------------------------------
----- =======[ SETTINGS TAB ] =======
-------------------------------------------

local ConfigSection = SettingsTab:Section({
	Title = "Configuration",
	Icon = "save"
})

ConfigSection:Paragraph({
	Title = "Settings Management",
	Content = "Manage your script configuration and preferences"
})

local ConfigManager = Window.ConfigManager
local myConfig = ConfigManager:CreateConfig("ZiaanHubConfig")

ConfigSection:Button({
    Title = "Save Settings",
    Content = "Save current configuration",
    Callback = function()
        myConfig:Save()
        NotifySuccess("Config Saved", "Configuration has been saved!")
    end
})

ConfigSection:Button({
    Title = "Load Settings",
    Content = "Load saved configuration",
    Callback = function()
        myConfig:Load()
        NotifySuccess("Config Loaded", "Configuration has been loaded!")
    end
})

-- Anti-AFK Section
local AFKSection = SettingsTab:Section({
	Title = "Anti-AFK System",
	Icon = "user-x"
})

AFKSection:Paragraph({
	Title = "AFK Prevention",
	Content = "Prevent being kicked for inactivity"
})

local AntiAFKEnabled = true
local AFKConnection = nil

AFKSection:Toggle({
	Title = "Anti-AFK",
	Content = "Prevent automatic disconnection",
	Value = true,
	Callback = function(Value)
		if Notifs.AFKBN then
			Notifs.AFKBN = false
			return
		end
  
		AntiAFKEnabled = Value
		if AntiAFKEnabled then
			if AFKConnection then
				AFKConnection:Disconnect()
			end
			
			local VirtualUser = game:GetService("VirtualUser")

			AFKConnection = LocalPlayer.Idled:Connect(function()
				pcall(function()
					VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
					task.wait(1)
					VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
				end)
			end)

			NotifySuccess("Anti-AFK Activated", "You will now avoid being kicked.")

		else
			if AFKConnection then
				AFKConnection:Disconnect()
				AFKConnection = nil
			end

			NotifySuccess("Anti-AFK Deactivated", "You can now go idle again.")
		end
	end,
})

-- Information Section
local InfoSection = SettingsTab:Section({
	Title = "Script Information",
	Icon = "info"
})

InfoSection:Paragraph({
	Title = "ZiaanHub - Fish It",
	Content = "Advanced fishing automation script with comprehensive features"
})

InfoSection:Label({
	Title = "Version",
	Content = "1.6.45"
})

InfoSection:Label({
	Title = "Developer",
	Content = "@ziaandev"
})

InfoSection:Label({
	Title = "Status",
	Content = "Operational"
})

WindUI:Notify({
	Title = "ZiaanHub - Fish It",
	Content = "Script loaded successfully! Enjoy your fishing experience.",
	Duration = 5,
	Icon = "circle-check"
})
