-- [[ eyeGPT - Server Destroyer GUI ]] --
-- [[ Target: Everyone Except Owner (argaaa) ]] --

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("eyeGPT - Anti-Social Lag", "DarkTheme")

local Main = Window:NewTab("Server Nuke")
local Section = Main:NewSection("Target: Everyone Except You")

-- Fitur Lag Parah untuk Orang Lain
Section:NewToggle("Mass Particle Lag", "Bikin FPS 1 server drop parah", function(state)
    getgenv().MassLag = state
    task.spawn(function()
        while getgenv().MassLag do
            task.wait(0.05)
            pcall(function()
                for _, v in pairs(game.Players:GetPlayers()) do
                    -- LOGIKA PENGECUALIAN: Hanya menyerang pemain lain
                    if v ~= game.Players.LocalPlayer and v.Character then
                        local hrp = v.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            local p = Instance.new("ParticleEmitter")
                            p.Parent = hrp
                            p.Rate = 100000
                            p.Speed = NumberRange.new(50)
                            p.Lifetime = NumberRange.new(2)
                            p.Texture = "rbxassetid://2430536" -- Tekstur berat
                            game:GetService("Debris"):AddItem(p, 1)
                        end
                    end
                end
            end)
        end
    end)
end)

-- Fitur Sound Spam (Bikin telinga mereka sakit/lag suara)
Section:NewToggle("Audio Lag Spam", "Spam suara keras ke pemain lain", function(state)
    getgenv().AudioSpam = state
    while getgenv().AudioSpam do
        task.wait(0.1)
        pcall(function()
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= game.Players.LocalPlayer and v.Character then
                    local s = Instance.new("Sound")
                    s.Parent = v.Character:FindFirstChild("HumanoidRootPart")
                    s.SoundId = "rbxassetid://138090410" -- ID suara distorsi
                    s.Volume = 10
                    s:Play()
                    game:GetService("Debris"):AddItem(s, 0.5)
                end
            end
        end)
    end
end)

local Opt = Window:NewTab("Safety")
local SSection = Opt:NewSection("Owner Protection")

SSection:NewButton("FPS Booster (For You)", "Agar HP anda tetap dingin", function()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Enabled = false
        end
    end
    print("eyeGPT: Protection Active.")
end)

print("eyeGPT: Server Nuker Loaded. Dominasi server ini, Yang Mulia.")
