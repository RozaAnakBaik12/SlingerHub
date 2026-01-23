local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "SLINGER HUB | VIP EDITION",
    SubTitle = "Categorized Features",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark"
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Exclusive = Window:AddTab({ Title = "Exclusive", Icon = "star" }),
    Shop = Window:AddTab({ Title = "Shop", Icon = "shopping-cart" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- [ TAB EXCLUSIVE - KATEGORI TERPISAH ]
Tabs.Exclusive:AddSection("Fishing Modes")

-- 1. MODE INSTANT (KILAT)
local InstantToggle = Tabs.Exclusive:AddToggle("InstantFish", {Title = "Instant Fishing", Default = false })

-- 2. MODE BLATANT (BAR-BAR DENGAN SETTING)
local BlatantToggle = Tabs.Exclusive:AddToggle("BlatantV3", {Title = "Ultra Blatant V3", Default = false })

-- 3. MODE LEGIT (AMAN / SEPERTI ASLI)
local LegitToggle = Tabs.Exclusive:AddToggle("LegitMode", {Title = "Legit Mode (Human-Like)", Default = false })

Tabs.Exclusive:AddSection("Blatant Settings")
local CompDelay = Tabs.Exclusive:AddInput("CompDelay", {Title = "Complete Delay", Default = "0.42"})
local CanDelay = Tabs.Exclusive:AddInput("CanDelay", {Title = "Cancel Delay", Default = "0.3"})
local RecDelay = Tabs.Exclusive:AddInput("RecDelay", {Title = "Re-Cast Delay", Default = "0.000"})

-- [ LOGIC PEMISAHAN FITUR ]
task.spawn(function()
    while task.wait() do
        pcall(function()
            local net = game:GetService("ReplicatedStorage").Packages._Index["sleitnick_net@0.2.0"].net
            
            if InstantToggle.Value then
                -- Mode Instant: Tanpa Jeda sama sekali
                net["RE/FishingCompleted"]:FireServer()
                task.wait(0.01)
            elseif BlatantToggle.Value then
                -- Mode Blatant: Menggunakan Delay Input (0.42 sesuai gambar)
                task.wait(tonumber(CompDelay.Value) or 0.42)
                net["RE/FishingCompleted"]:FireServer()
                task.wait(tonumber(RecDelay.Value) or 0)
            elseif LegitToggle.Value then
                -- Mode Legit: Delay acak agar tidak terkena ban
                task.wait(math.random(1.5, 3.0))
                net["RE/FishingCompleted"]:FireServer()
            end
        end)
    end
end)

Tabs.Exclusive:AddSection("Automation")
local AutoCast = Tabs.Exclusive:AddToggle("AutoCast", {Title = "Auto Cast / Re-Cast", Default = false })
task.spawn(function()
    while task.wait(1.5) do
        if AutoCast.Value then
            local tool = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
    end
end)

-- [ TETAP SERTAKAN FITUR PENTING LAINNYA ]
Tabs.Shop:AddSection("Protection")
Tabs.Shop:AddToggle("AutoFav", {Title = "Auto Favorite (Mythic+)", Default = true })
Tabs.Shop:AddToggle("AutoSell", {Title = "Auto Sell All (60s)", Default = false })

Tabs.Main:AddToggle("FPSBoost", {Title = "Unlock FPS", Default = true}):OnChanged(function(v)
    if v then setfpscap(999) else setfpscap(60) end
end)

local SaveManager = Fluent:AddSaveManager()
SaveManager:SetLibrary(Fluent)
SaveManager:SetFolder("SlingerHub/FishIt")
SaveManager:BuildConfigSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()
