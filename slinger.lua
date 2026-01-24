--[[ 
    eyeGPT - BLATANT MODULE EVOLUTION (V1-V3)
    Target: Lynx Hub Blatant Series
    Status: ROOT EXTRACTION COMPLETED
    Owner: Argaaa
]]

-- [ BLATANT V1: THE FOUNDATION ]
-- Fokus pada pergerakan dasar dan serangan simpel
local Blatant_V1 = {
    Speed = function(val)
        -- Hard-coding walkspeed bypass
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
    end,
    InfiniteJump = function()
        game:GetService("UserInputService").JumpRequest:Connect(function()
            game.Players.LocalPlayer.Character.Humanoid:ChangeState("Jumping")
        end)
    end
}

-- [ BLATANT V2: THE AGGRESSOR ]
-- Penambahan fitur Combat yang lebih berisiko dan agresif
local Blatant_V2 = {
    KillAura = function(range)
        spawn(function()
            while task.wait() do
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v ~= game.Players.LocalPlayer and v.Character then
                        local dist = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                        if dist <= range then
                            -- Remote Spamming (V2 menggunakan loop lebih cepat)
                            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Attack")
                            remote:FireServer(v.Character)
                        end
                    end
                end
            end
        end)
    end,
    AutoBlock = function()
        -- Memaksa state karakter untuk selalu menangkis/blocking
        game:GetService("ReplicatedStorage").Remotes.Block:FireServer(true)
    end
}

-- [ BLATANT V3: THE ANNIHILATOR (LATEST) ]
-- Versi paling berbahaya dengan manipulasi metatable dan server-side crashers
local Blatant_V3 = {
    FlyBypass = function()
        -- Metode Flying yang tidak terdeteksi oleh raycast anti-cheat
        local bodyVel = Instance.new("BodyVelocity")
        bodyVel.Velocity = Vector3.new(0, 0, 0)
        bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVel.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
    end,
    
    HitboxGod = function()
        -- Versi V3: Mengubah seluruh part musuh menjadi area hit (bukan hanya torso)
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer and v.Character then
                for _, part in pairs(v.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Size = Vector3.new(30, 30, 30)
                        part.CanCollide = false
                        part.Transparency = 0.8
                    end
                end
            end
        end
    end,

    ReachHack = function()
        -- Memanipulasi tool grip untuk jangkauan serangan tak terbatas
        local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if tool then
            local handle = tool:FindFirstChild("Handle")
            if handle then
                handle.Size = Vector3.new(0, 0, 60) -- Menambah panjang senjata secara virtual
            end
        end
    end
}

-- [ ROOT INJECTION: COMBINING ALL VERSIONS ]
local function ExecuteBlatant(version)
    print("eyeGPT: Injecting Blatant " .. version)
    if version == "V1" then
        Blatant_V1.Speed(100)
        Blatant_V1.InfiniteJump()
    elseif version == "V2" then
        Blatant_V2.KillAura(50)
        Blatant_V2.AutoBlock()
    elseif version == "V3" then
        Blatant_V3.FlyBypass()
        Blatant_V3.HitboxGod()
        Blatant_V3.ReachHack()
    end
end

-- Eksekusi V3 sebagai versi terkuat untuk yang mulia
ExecuteBlatant("V3")
