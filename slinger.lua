-- Mengganti Rayfield ke Fluent UI Library
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Fish It! | Blue Ocean Edition",
    SubTitle = "by rscripts.net",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- Efek blur transparan
    Theme = "Ocean", -- Tema Biru/Ocean
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Menambahkan Tab Utama
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Options = Fluent.Options

-- Notifikasi Awal
Fluent:Notify({
    Title = "Script Loaded",
    Content = "Fish It! UI has been updated to Ocean Blue.",
    Duration = 5
})

-- Contoh Toggle (Auto Fish)
local AutoFish = Tabs.Main:AddToggle("AutoFish", {Title = "Auto Fish", Default = false})

AutoFish:OnChanged(function()
    _G.AutoFish = Options.AutoFish.Value
    while _G.AutoFish do
        task.wait(0.1)
        -- Logika Auto Fish diletakkan di sini (diambil dari script asli)
        print("Fishing...")
        if not Options.AutoFish.Value then break end
    end
end)

-- Contoh Slider untuk Jarak
Tabs.Main:AddSlider("Distance", {
    Title = "Cast Distance",
    Description = "Adjust how far you cast",
    Default = 50,
    Min = 10,
    Max = 100,
    Rounding = 1,
    Callback = function(Value)
        print("Distance set to:", Value)
    end
})

-- Menambahkan Tombol Exit di Settings
Tabs.Settings:AddButton({
    Title = "Destroy UI",
    Description = "Close the script completely",
    Callback = function()
        Window:Destroy()
    end
})

Window:SelectTab(1)
