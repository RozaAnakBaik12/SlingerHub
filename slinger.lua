local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "SLINGER HUB | BLATANT V3",
    SubTitle = "Premium Version",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark"
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Exclusive = Window:AddTab({ Title = "Exclusive", Icon = "star" }),
    Shop = Window:AddTab({ Title = "Shop", Icon = "shopping-cart" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- [ TAB EXCLUSIVE - BLATANT FEATURES ]
Tabs.Exclusive:AddSection("Blatant Automation")

local BlatantToggle = Tabs.Exclusive:AddToggle("BlatantFishing", {Title = "Ultra Blatant V3", Default = false })
local AutoCast = Tabs.Exclusive:AddToggle("AutoCast", {Title = "Auto Cast / Re-Cast", Default = false })

-- Logic Blatant Fishing (Sesuai Video 41931.mp4)
BlatantToggle:OnChanged(function()
    _G.Blatant = BlatantToggle.Value
    task.spawn(function()
        while _G.Blatant do
            task.wait(0.01)
            pcall(function()
                -- Mengirim sinyal "FishingCompleted" secara instan ke server
                local net = game:GetService("ReplicatedStorage").Packages._Index["sleitnick_net@0.2.0"].net
                net["RE/FishingCompleted"]:FireServer()
            end)
        end
    end)
end)

-- [ TAB MAIN - PERFORMANCE ]
Tabs.Main:AddSection("Performance Boost")

Tabs.Main:AddButton({
    Title = "Unlock FPS",
    Callback = function()
        setfpscap(999) -- Membuka batas FPS
        Fluent:Notify({Title = "System", Content = "FPS Unlocked!", Duration = 3})
    end
})

-- [ TAB SHOP - PROTECTION ]
Tabs.Shop:AddSection("Protection")
Tabs.Shop:AddToggle("AutoFav", {Title = "Auto Favorite Secret/Mythic", Default = true })

-- [ SETTINGS ]
Tabs.Settings:AddButton({
    Title = "Boost FPS (Remove Textures)",
    Callback = function()
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic end
        end
    end
})

Window:SelectTab(2) -- Langsung buka tab Exclusive
Fluent:Notify({ Title = "Slinger Hub", Content = "Ultra Blatant V3 Loaded!", Duration = 5 })
