--[[
    SLINGERHUB - GOD-BYPASS (NO UI EDITION)
    Tujuan: Menembus Self-Destruct & Eksekusi Instan
--]]

-- 1. TOTAL PROTECTION (Mematikan semua fungsi deteksi game)
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local old = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        -- Memblokir semua upaya Kick dan pengecekan Rank
        if method == "Kick" or method == "kick" or tostring(self):find("Destruct") then 
            return nil 
        end
        return old(self, ...)
    end)
    
    -- Menghapus fungsi Kick dari player
    hookfunction(game.Players.LocalPlayer.Kick, function() return nil end)
end)

-- 2. CORE SETTINGS (Ubah angka di sini sesuai keinginan)
local Settings = {
    Mode = "Blatant", -- Pilih: "Legit", "Instant", atau "Blatant"
    CompleteDelay = 0.42, -- Jeda tangkap
    SpamPower = 50 -- Kekuatan tarikan untuk Blatant
}

-- 3. LOGIC PANCING OTOMATIS (Langsung Jalan Setelah Execute)
task.spawn(function()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local net = ReplicatedStorage:WaitForChild("Packages", 30)._Index["sleitnick_net@0.2.0"].net
    local Events = {
        fishing = net:WaitForChild("RE/FishingCompleted"),
        charge = net:WaitForChild("RF/ChargeFishingRod"),
        minigame = net:WaitForChild("RF/RequestFishingMinigameStarted"),
        equip = net:WaitForChild("RE/EquipToolFromHotbar")
    }

    print("👁️ eyeGPT: SlingerHub Active. Self-Destruct Blocked!")

    while true do
        pcall(function()
            -- Auto Equip & Cast
            Events.equip:FireServer(1)
            task.wait(0.1)
            Events.charge:InvokeServer(1755848498.4834)
            Events.minigame:InvokeServer(1.2854545116425, 1)
            
            -- Mode Handling
            if Settings.Mode == "Legit" then
                task.wait(2.5)
                Events.fishing:FireServer()
            elseif Settings.Mode == "Instant" then
                task.wait(0.65) -- Instant delay
                Events.fishing:FireServer()
            elseif Settings.Mode == "Blatant" then
                task.wait(Settings.CompleteDelay)
                for i = 1, Settings.SpamPower do
                    Events.fishing:FireServer()
                end
            end
        end)
        task.wait(0.5) -- Jeda antar lemparan
    end
end)
