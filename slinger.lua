local WindUI = loadstring(game:HttpGet("https://tree-hub.vercel.app/api/main/windui"))()

local Window = WindUI:CreateWindow({
    Title = "Fish It!",
    Icon = "rbxassetid://10723343321", -- Icon ikan
    Author = "Blue Edition",
    Folder = "FishItConfig"
})

-- TEMA BIRU OCEAN
Window:EditTheme({
    AccentColor = Color3.fromRGB(0, 120, 215),
    OutlineColor = Color3.fromRGB(30, 30, 40),
    BackgroundColor = Color3.fromRGB(15, 15, 20)
})

local MainTab = Window:Tab({ Title = "Main", Icon = "home" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "layers" })

-- [ FITUR DARI SCRIPT ASLI ] --

MainTab:Toggle({
    Title = "Auto Fish",
    Default = false,
    Callback = function(v)
        _G.AutoFish = v
        spawn(function()
            while _G.AutoFish do
                task.wait(0.1)
                -- Logic: Cast Rod & Catch
                local args = { [1] = "Cast" }
                game:GetService("ReplicatedStorage").Events.Fishing:FireServer(unpack(args))
                
                -- Auto Reel (Logic dari raw link)
                game:GetService("ReplicatedStorage").Events.Fishing:FireServer("Reel")
            end
        end)
    end
})

MainTab:Toggle({
    Title = "Auto Sell Fish",
    Default = false,
    Callback = function(v)
        _G.AutoSell = v
        spawn(function()
            while _G.AutoSell do
                task.wait(2)
                game:GetService("ReplicatedStorage").Events.Sell:FireServer()
            end
        end)
    end
})

MainTab:Button({
    Title = "Unlock All Rods (Client)",
    Callback = function()
        -- Logic dari raw rscripts.net
        for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Main.Rods:GetChildren()) do
            if v:IsA("Frame") then v.Visible = true end
        end
    end
})

MiscTab:Slider({
    Title = "WalkSpeed",
    Min = 16,
    Max = 200,
    Default = 16,
    Callback = function(v)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
    end
})

MiscTab:Button({
    Title = "Teleport to Ocean",
    Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(150, 20, 300) -- Koordinat contoh ocean
    end
})

-- Notifikasi kalau sudah siap
WindUI:Notify({
    Title = "Success!",
    Content = "Script Fish It! Blue Wind UI Loaded (Keyless)",
    Duration = 5
})
