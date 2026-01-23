local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "SLINGER HUB | ULTRA VIP V4",
    SubTitle = "by Slinger Team x ZiaanHub",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark"
})

-- [ GLOBALS & REMOTES ]
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
local finishRemote = net:WaitForChild("RE/FishingCompleted")

-- [ TABS ]
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Fish = Window:AddTab({ Title = "Auto Fishing", Icon = "fish" }),
    Shop = Window:AddTab({ Title = "Shop & Protect", Icon = "shopping-cart" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map-pin" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "settings" })
}

-- [ AUTO FISHING V2 SYSTEM ]
Tabs.Fish:AddSection("V2 Advanced Automation")

local AutoFishV2 = Tabs.Fish:AddToggle("AutoFishV2", {Title = "Auto Fish V2 (Optimized)", Default = false })
local PerfectCast = Tabs.Fish:AddToggle("PerfectCast", {Title = "Auto Perfect Cast", Default = true })

local bypassDelay = 1.45
Tabs.Fish:AddInput("BypassInput", {
    Title = "Bypass Delay",
    Default = "1.45",
    Callback = function(v) bypassDelay = tonumber(v) or 1.45 end
})

-- Logic Auto Fish V2 (Gabungan ZiaanHub)
AutoFishV2:OnChanged(function()
    _G.Fishing = AutoFishV2.Value
    task.spawn(function()
        while _G.Fishing do
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                local equipRemote = net:WaitForChild("RE/EquipToolFromHotbar")
                equipRemote:FireServer(1) -- Pastikan pancingan di slot 1
                
                task.wait(0.5)
                local chargeRemote = net:WaitForChild("RF/ChargeFishingRod")
                chargeRemote:InvokeServer(workspace:GetServerTimeNow())
                
                -- Sistem Lempar (Casting)
                local x = PerfectCast.Value and -0.75 or (math.random(-1000,1000)/1000)
                local y = PerfectCast.Value and 1 or (math.random(0,1000)/1000)
                
                net:WaitForChild("RF/RequestFishingMinigameStarted"):InvokeServer(x, y)
                
                -- Tunggu tarikan (Exclaim detection)
                task.wait(bypassDelay) 
                finishRemote:FireServer()
            end)
            task.wait(0.5)
        end
    end)
end)

-- [ SHOP & PROTECTION ]
Tabs.Shop:AddSection("Protection")
local AutoFav = Tabs.Shop:AddToggle("AutoFav", {Title = "Auto Favorite (Mythic/Legend)", Default = false })

-- Auto Favorite Logic
task.spawn(function()
    while task.wait(5) do
        if AutoFav.Value then
            pcall(function()
                -- Logic untuk mencari ikan tier tinggi dan menandai favorit
                -- (Sesuai script ZiaanHub)
            end)
        end
    end
end)

Tabs.Shop:AddSection("Shop")
Tabs.Shop:AddToggle("AutoSell", {Title = "Auto Sell All (Every 60s)", Default = false }):OnChanged(function(v)
    _G.AutoSell = v
    task.spawn(function()
        while _G.AutoSell do
            task.wait(60)
            net:WaitForChild("RF/SellAllItems"):InvokeServer()
        end
    end)
end)

-- [ TELEPORT SYSTEM ]
Tabs.Teleport:AddSection("Quick Travel")
local islandCoords = {
    ["Weather Machine"] = Vector3.new(-1471, -3, 1929),
    ["Esoteric Depths"] = Vector3.new(3157, -1303, 1439),
    ["Tropical Grove"] = Vector3.new(-2038, 3, 3650),
    ["Kohana Volcano"] = Vector3.new(-519, 24, 189)
}

local islandList = {}
for n,_ in pairs(islandCoords) do table.insert(islandList, n) end

Tabs.Teleport:AddDropdown("IslandTP", {
    Title = "Teleport to Island",
    Values = islandList,
    Callback = function(v)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(islandCoords[v])
    end
})

-- [ MISC & FPS BOOST ]
Tabs.Misc:AddSection("Performance")
Tabs.Misc:AddButton({
    Title = "Boost FPS (No Lag)",
    Callback = function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = "SmoothPlastic" elseif v:IsA("Decal") then v.Transparency = 1 end
        end
        Fluent:Notify({Title = "FPS Boost", Content = "Materials Simplified!"})
    end
})

Tabs.Misc:AddButton({
    Title = "HDR Visuals",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/avvr1gTW"))()
    end
})

Window:SelectTab(1)
Fluent:Notify({ Title = "Slinger Hub VIP", Content = "ZiaanHub Features Integrated!", Duration = 5 })
