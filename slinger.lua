--[[
    SLINGERHUB - INVENTORY EXPERIMENT
    Metode: Remote Replication (Mencoba menggandakan item di tas)
    Risiko: SANGAT TINGGI (Dapat memicu Self-Destruct)
]]

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "SlingerHub - Inv Dupe",
    Icon = "package",
    Author = "eyeGPT",
    Folder = "SlingerHub_Inv",
    Size = UDim2.fromOffset(350, 250),
    Theme = "Indigo"
})

local Main = Window:Tab({ Title = "Inventory", Icon = "archive" })
local Section = Main:Section({ Title = "Experimental Dupe" })

-- Fungsi untuk mencoba dupe via Remote
local function TryInventoryDupe()
    pcall(function()
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local net = ReplicatedStorage:WaitForChild("Packages")._Index["sleitnick_net@0.2.0"].net
        
        -- Mencoba memicu pengiriman data item berkali-kali ke server
        -- Teknik ini menargetkan fungsi penyimpanan item
        for i = 1, 5 do
            net["RE/UpdateInventory"]:FireServer() -- Menembak remote update secara paksa
        end
    end)
end

Section:Button({
    Title = "Execute Inv Dupe",
    Content = "Klik untuk mencoba penggandaan tas",
    Callback = function()
        WindUI:Notify({Title = "Processing", Content = "Mencoba sinkronisasi data...", Duration = 2})
        TryInventoryDupe()
    end
})

Section:Paragraph({
    Title = "Catatan Keamanan",
    Content = "Jika terjadi 'Self Destruct', segera kurangi penggunaan fitur ini dan kembali ke Dupe Pancing."
})

WindUI:Init()
