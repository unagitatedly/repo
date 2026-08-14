local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/unagitatedly/repo/refs/heads/main/unagitatedly_ui.lua"))()

local Window = Library:CreateWindow({
    Title = "unagitatedly",
    SubTitle = " ·  Universal Hub",
    Badge = "v2.0",
    Version = "2.0",
    Size = UDim2.new(0, 680, 0, 760),
    ToggleKey = Enum.KeyCode.Insert,
    Theme = {
        accent = Color3.fromRGB(244, 166, 205),
        accentBright = Color3.fromRGB(255, 130, 185),
        windowBg = Color3.fromRGB(11, 11, 16),
        cardBg = Color3.fromRGB(16, 16, 23),
        inputBg = Color3.fromRGB(20, 20, 29),
        border = Color3.fromRGB(26, 26, 36),
        borderBright = Color3.fromRGB(42, 42, 58),
        text = Color3.fromRGB(245, 245, 250),
        textMuted = Color3.fromRGB(115, 115, 138),
    },
    Footer = {
        OnlineText = "1,420 online",
        OnlineColor = "#22c55e",
        CenterText = "unagitatedly hub",
        BuildDate = "August 14 2026",
        BuildColor = "#f4a6cd",
    }
})

local CombatTab = Window:CreateTab("Combat")
local VisualsTab = Window:CreateTab("Visuals")
local MiscTab = Window:CreateTab("Misc")
local SettingsTab = Window:CreateTab("Settings")

local AimbotCard = CombatTab:CreateCard("Aimbot Configuration", "Left")
local WeaponCard = CombatTab:CreateCard("Weapon & Trigger", "Right")

local State = {
    Aimbot = false,
    SilentAim = false,
    Triggerbot = false,
    SmoothX = 4.0,
    SmoothY = 4.0,
    TargetBone = "Head",
    ESP = false,
    Chams = false,
    Fly = false,
    FlySpeed = 50,
    AimKey = Enum.KeyCode.E,
    AccentColor = Color3.fromRGB(244, 166, 205),
}

local AimbotToggle = AimbotCard:CreateToggle({
    Name = "Enable Silent Aim",
    Default = false,
    Callback = function(val)
        State.Aimbot = val
        Library:Notify({
            Title = "Aimbot",
            Content = "Silent Aim " .. (val and "Enabled" or "Disabled"),
            Duration = 2
        })
    end
})

local AimKeybind = AimbotCard:CreateKeybind({
    Name = "Aimbot Activation Key",
    Default = Enum.KeyCode.E,
    Callback = function(key)
        State.AimKey = key
        print("Aim key set to:", key.Name)
    end
})

local SmoothXSlider = AimbotCard:CreateSlider({
    Name = "Horizontal Smoothing",
    Min = 1.0,
    Max = 30.0,
    Default = 4.0,
    Step = 0.5,
    Format = "%.1f",
    Callback = function(val)
        State.SmoothX = val
    end
})

local SmoothYSlider = AimbotCard:CreateSlider({
    Name = "Vertical Smoothing",
    Min = 1.0,
    Max = 30.0,
    Default = 4.0,
    Step = 0.5,
    Format = "%.1f",
    Callback = function(val)
        State.SmoothY = val
    end
})

local BoneDropdown = AimbotCard:CreateDropdown({
    Name = "Target Hitbox",
    Options = { "Head", "UpperTorso", "HumanoidRootPart" },
    Default = "Head",
    Callback = function(idx, opt)
        State.TargetBone = opt
        print("Selected Hitbox:", opt)
    end
})

WeaponCard:CreateToggle({
    Name = "Enable Triggerbot",
    Default = false,
    Callback = function(val)
        State.Triggerbot = val
    end
})

WeaponCard:CreateSlider({
    Name = "Reaction Delay",
    Min = 0,
    Max = 200,
    Default = 25,
    Step = 5,
    Format = "%.0f ms",
    Callback = function(val)
        print("Delay set to:", val)
    end
})

WeaponCard:CreateTextInput({
    Name = "Target Player Filter",
    Placeholder = "Enter username...",
    Default = "",
    Callback = function(text)
        print("Filtering for player:", text)
    end
})

WeaponCard:CreateButton({
    Name = "Quick Refresh Target List",
    Accent = true,
    Callback = function()
        BoneDropdown:Refresh({ "Head", "Neck", "UpperTorso", "LowerTorso", "HumanoidRootPart" }, "Head")
        Library:Notify({
            Title = "Target List",
            Content = "Hitbox bones refreshed successfully!",
            Duration = 2.5
        })
    end
})

local EspCard = VisualsTab:CreateCard("Player ESP", "Left")
local ChamCard = VisualsTab:CreateCard("Chams & Colors", "Right")

EspCard:CreateToggle({
    Name = "Master ESP",
    Default = false,
    Callback = function(val)
        State.ESP = val
    end
})

EspCard:CreateToggle({
    Name = "2D Bounding Boxes",
    Default = true,
    Callback = function(val)
        print("Box ESP:", val)
    end
})

EspCard:CreateToggle({
    Name = "Skeleton Lines",
    Default = false,
    Callback = function(val)
        print("Skeleton ESP:", val)
    end
})

ChamCard:CreateToggle({
    Name = "Wallhack Chams",
    Default = false,
    Callback = function(val)
        State.Chams = val
    end
})

ChamCard:CreateColorPicker({
    Name = "Chams Accent Color",
    Default = Color3.fromRGB(244, 166, 205),
    Callback = function(col)
        State.AccentColor = col
    end
})

ChamCard:CreateSlider({
    Name = "Fill Transparency",
    Min = 0.0,
    Max = 1.0,
    Default = 0.45,
    Step = 0.05,
    Format = "%.2f",
    Callback = function(val)
        print("Transparency:", val)
    end
})

local MoveCard = MiscTab:CreateCard("Movement Modifiers", "Left")

MoveCard:CreateToggle({
    Name = "Fly Mode",
    Default = false,
    Callback = function(val)
        State.Fly = val
    end
})

MoveCard:CreateSlider({
    Name = "Fly Speed",
    Min = 10,
    Max = 300,
    Default = 75,
    Step = 5,
    Format = "%.0f studs/s",
    Callback = function(val)
        State.FlySpeed = val
    end
})

local CustomCard = SettingsTab:CreateCard("Live UI Customizer", "Left")
local InfoCard = SettingsTab:CreateCard("Library Information", "Right")

CustomCard:CreateTextInput({
    Name = "Change UI Title",
    Placeholder = "New title...",
    Default = "unagitatedly",
    Callback = function(text)
        Window:SetTitle(text)
    end
})

CustomCard:CreateTextInput({
    Name = "Change UI Subtitle",
    Placeholder = "New subtitle...",
    Default = " ·  Universal Hub",
    Callback = function(text)
        Window:SetSubTitle(text)
    end
})

CustomCard:CreateTextInput({
    Name = "Change Badge Text",
    Placeholder = "e.g. VIP / Premium",
    Default = "v2.0",
    Callback = function(text)
        Window:SetBadge(text)
    end
})

CustomCard:CreateButton({
    Name = "Send Test Notification",
    Accent = true,
    Callback = function()
        Library:Notify({
            Title = "unagitatedly",
            Content = "Everything is customizable and editable!",
            Duration = 3
        })
    end
})

CustomCard:CreateButton({
    Name = "Unload & Destroy UI",
    Accent = false,
    Callback = function()
        Window:Destroy()
    end
})

InfoCard:CreateLabel({
    Text = "Version: 2.0 Standalone",
    Color = "#f4a6cd"
})

InfoCard:CreateLabel({
    Text = "Toggle UI with [Insert] Key",
    Color = "#73738a"
})

local Watermark = Library:CreateWatermark({
    Title = "unagitatedly"
})

local KeybindHUD = Library:CreateKeybindHUD({
    Title = "Active Modules"
})

KeybindHUD:Register("Silent Aim", function() return State.Aimbot end)
KeybindHUD:Register("Triggerbot", function() return State.Triggerbot end)
KeybindHUD:Register("Player ESP", function() return State.ESP end)
KeybindHUD:Register("Wallhack Chams", function() return State.Chams end)
KeybindHUD:Register("Fly Mode", function() return State.Fly end)

Library:Notify({
    Title = "unagitatedly",
    Content = "UI loaded successfully! Press [Insert] to toggle.",
    Duration = 4
})

print("[unagitatedly] Example initialized with full customization!")
