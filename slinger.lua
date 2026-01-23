local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "SLINGER HUB | VIP EDITION",
    SubTitle = "Team Slinger",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Exclusive = Window:AddTab({ Title = "Exclusive", Icon = "star" }),
    Shop = Window:AddTab({ Title = "Shop", Icon = "shopping-cart" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- [ TAB EXCLUSIVE - SETTINGAN PERSIS GAMBAR ]
Tabs.Exclusive:AddSection("Blatant Automation")

local BlatantToggle = Tabs.Exclusive:AddToggle("BlatantV3", {Title = "Ultra Blatant V3", Default = false })

-- Menambahkan kolom input manual seperti di foto PAHAJI HUB
local CompDelay = Tabs.Exclusive:AddInput("CompleteDelay", {
    Title = "Complete Delay",
    Default = "0.42",
    Placeholder = "Contoh: 0.42",
    Callback = function(Value) end
})

local CanDelay = Tabs.Exclusive:AddInput("CancelDelay", {
    Title = "Cancel Delay",
    Default = "0.3",
    Placeholder = "Contoh: 0.3",
    Callback = function(Value) end
})

local RecastDelay = Tabs.Exclusive:AddInput("RecastDelay", {
    Title = "Re-Cast Delay",
    Default = "0.000",
    Placeholder = "Contoh: 0.000",
    Callback = function(Value) end
})

-- Logic Utama Blatant (Menggunakan Input di atas)
task.spawn(function()
    while task.wait(0.1) do
        if BlatantToggle.Value then
            pcall(function()
                local delayTime = tonumber(CompDelay.Value) or 0.42
                task.wait(delayTime)
                game:GetService("ReplicatedStorage").Packages._Index["sleitnick_net@0.2.0"].net["RE/FishingCompleted"]:FireServer()
                
                -- Jeda sebelum lempar lagi (Re-Cast)
                task.wait(tonumber(RecastDelay.Value) or 0)
            end)
        end
    end
end)

-- [ PERFORMA ]
Tabs.Main:AddSection("Performance")
Tabs.Main:AddToggle("UnlockFPS", {Title = "Unlock FPS", Default = true }):OnChanged(function(v)
    if v then setfpscap(999) else setfpscap(60) end
end)

-- [ CONFIG SAVE MANAGER ]
local SaveManager = Fluent:AddSaveManager()
SaveManager:SetLibrary(Fluent)
SaveManager:SetFolder("SlingerHub/FishIt")
SaveManager:BuildConfigSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()
