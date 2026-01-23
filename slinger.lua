local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "SLINGER HUB | ULTRA DEBUG",
    SubTitle = "Fixing Fishing Issues",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Fishing = Window:AddTab({ Title = "Exclusive", Icon = "star" }),
    Shop = Window:AddTab({ Title = "Shop", Icon = "shopping-cart" })
}

-- [ FIX FISHING LOGIC ]
Tabs.Fishing:AddSection("Auto Farm Fix")

local AutoCast = Tabs.Fishing:AddToggle("AutoCast", {Title = "Auto Cast (Force)", Default = false })
local InstantPull = Tabs.Fishing:AddToggle("InstantPull", {Title = "Ultra Blatant V3 (Instant)", Default = false })

-- Logic Lempar (Auto Cast)
AutoCast:OnChanged(function()
    task.spawn(function()
        while AutoCast.Value do
            task.wait(1.5)
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                local tool = char:FindFirstChildOfClass("Tool") or game.Players.LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
                if tool then
                    tool.Parent = char
                    tool:Activate() -- Memaksa lempar
                end
            end)
        end
    end)
end)

-- Logic Tarik (Instant Fishing) - Diperbarui untuk mendeteksi tombol di video kamu
InstantPull:OnChanged(function()
    task.spawn(function()
        while InstantPull.Value do
            task.wait(0.01)
            pcall(function()
                local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
                local VIM = game:GetService("VirtualInputManager")
                
                -- Mencari elemen UI yang muncul saat ikan terpancing (Klik Cepat!)
                for _, v in pairs(PlayerGui:GetDescendants()) do
                    -- Deteksi Berdasarkan Teks atau Posisi (Cek Video 42122.mp4)
                    if v:IsA("TextButton") and v.Visible and (v.Text:lower():find("klik") or v.Name:lower():find("fish") or v.Text:find("!")) then
                        -- Klik Brutal di lokasi tombol
                        for i = 1, 10 do
                            VIM:SendMouseButtonEvent(v.AbsolutePosition.X + (v.AbsoluteSize.X/2), v.AbsolutePosition.Y + (v.AbsoluteSize.Y/2) + 54, 0, true, game, 1)
                            VIM:SendMouseButtonEvent(v.AbsolutePosition.X + (v.AbsoluteSize.X/2), v.AbsolutePosition.Y + (v.AbsoluteSize.Y/2) + 54, 0, false, game, 1)
                        end
                    end
                end
            end)
        end
    end)
end)

-- [ AUTO SELL FIX ]
Tabs.Shop:AddSection("Shop")
Tabs.Shop:AddToggle("AutoSell", {Title = "Auto Sell", Default = false }):OnChanged(function(Value)
    task.spawn(function()
        while Value do
            task.wait(2)
            -- Mencoba berbagai kemungkinan event sell
            local events = game:GetService("ReplicatedStorage"):FindFirstChild("Events")
            if events then
                if events:FindFirstChild("SellAll") then events.SellAll:FireServer() end
                if events:FindFirstChild("Sell") then events.Sell:FireServer() end
            end
        end
    end)
end)

Window:SelectTab(1)
Fluent:Notify({ Title = "Slinger Hub", Content = "Fix Applied! Try Fishing now.", Duration = 5 })
