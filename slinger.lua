local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
-- Tema Ocean Blue
local Window = Library.CreateLib("Fish It! - Blue Ocean", "Ocean")

local MainTab = Window:NewTab("Main")
local MainSection = MainTab:NewSection("Auto Farm")

MainSection:NewToggle("Auto Fish", "Mancing otomatis", function(v)
    _G.AutoFish = v
    spawn(function()
        while _G.AutoFish do
            task.wait(0.5)
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
            if remote and remote:FindFirstChild("Fishing") then
                remote.Fishing:FireServer("Cast")
                task.wait(0.8)
                remote.Fishing:FireServer("Reel")
            end
        end
    end)
end)

MainSection:NewToggle("Auto Sell", "Jual ikan otomatis", function(v)
    _G.AutoSell = v
    spawn(function()
        while _G.AutoSell do
            task.wait(5)
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
            if remote and remote:FindFirstChild("Sell") then
                remote.Sell:FireServer()
            end
        end
    end)
end)

local TPTab = Window:NewTab("Teleport")
local TPSection = TPTab:NewSection("Rolling")

TPSection:NewToggle("Island Rolling", "Pindah pulau tiap 10 detik", function(v)
    _G.IslandRolling = v
    local Islands = {
        CFrame.new(150, 20, 300),
        CFrame.new(-200, 20, 450),
        CFrame.new(500, 25, -100)
    }
    spawn(function()
        local i = 1
        while _G.IslandRolling do
            if not _G.IslandRolling then break end
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Islands[i]
            i = i % #Islands + 1
            task.wait(10)
        end
    end)
end)

TPSection:NewToggle("Player Rolling", "Pindah ke player lain", function(v)
    _G.PlayerRolling = v
    spawn(function()
        while _G.PlayerRolling do
            for _, p in pairs(game.Players:GetPlayers()) do
                if not _G.PlayerRolling then break end
                if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame
                    task.wait(5)
                end
            end
            task.wait(1)
        end
    end)
end)

local MiscTab = Window:NewTab("Misc")
local MiscSection = MiscTab:NewSection("Player")

MiscSection:NewSlider("WalkSpeed", "Lari kencang", 200, 16, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

-- Anti AFK (Tanam di background, gak pake UI)
local VirtualUser = game:GetService("VirtualUser")
game.Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)
