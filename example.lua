local Library
pcall(function()
    if readfile and isfile and isfile("unagitatedly_ui.lua") then
        Library = loadstring(readfile("unagitatedly_ui.lua"))()
    end
end)
if not Library then
    local success, res = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/unagitatedly/repo/refs/heads/main/unagitatedly_ui.lua"))()
    end)
    if success and res then
        Library = res
    else
        Library = loadfile("unagitatedly_ui.lua")()
    end
end

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
    Boxes = true,
    Skeletons = false,
    Tracers = false,
    Chams = false,
    Fly = false,
    FlySpeed = 75,
    SpeedHack = false,
    WalkSpeed = 24,
    AimKey = Enum.KeyCode.E,
    FlyKey = Enum.KeyCode.F,
    AccentColor = Color3.fromRGB(244, 166, 205),
    EspColor = Color3.fromRGB(130, 200, 255),
    CrosshairColor = Color3.fromRGB(255, 255, 255),
}

AimbotCard:CreateToggle({
    Name = "Enable Silent Aim",
    Default = false,
    Callback = function(val)
        State.Aimbot = val
        Library:Notify({
            Title = "Aimbot",
            Content = "Silent Aim " .. (val and "Enabled" or "Disabled"),
            Duration = 2.5
        })
    end
})

AimbotCard:CreateKeybind({
    Name = "Aimbot Activation Key",
    Default = Enum.KeyCode.E,
    Callback = function(key)
        State.AimKey = key
    end
})

AimbotCard:CreateDivider()

AimbotCard:CreateSlider({
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

AimbotCard:CreateSlider({
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
    Name = "Target Hitbox Bone",
    Options = { "Head", "UpperTorso", "HumanoidRootPart" },
    Default = "Head",
    Callback = function(idx, opt)
        State.TargetBone = opt
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
    Name = "Triggerbot Delay",
    Min = 0,
    Max = 200,
    Default = 25,
    Step = 5,
    Format = "%.0f ms",
    Callback = function(val)
    end
})

WeaponCard:CreateDivider()

WeaponCard:CreateTextInput({
    Name = "Target Player Filter",
    Placeholder = "Enter target username...",
    Default = "",
    Callback = function(text)
    end
})

WeaponCard:CreateButton({
    Name = "Refresh Hitbox Target List",
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
local ChamCard = VisualsTab:CreateCard("Chams & Visual Colors", "Right")

EspCard:CreateToggle({
    Name = "Master Player ESP",
    Default = false,
    Callback = function(val)
        State.ESP = val
    end
})

EspCard:CreateToggle({
    Name = "2D Bounding Boxes",
    Default = true,
    Callback = function(val)
        State.Boxes = val
    end
})

EspCard:CreateToggle({
    Name = "Skeleton Lines",
    Default = false,
    Callback = function(val)
        State.Skeletons = val
    end
})

EspCard:CreateToggle({
    Name = "Snaplines / Tracers",
    Default = false,
    Callback = function(val)
        State.Tracers = val
    end
})

EspCard:CreateColorPicker({
    Name = "ESP Box Color",
    Default = Color3.fromRGB(130, 200, 255),
    Callback = function(col)
        State.EspColor = col
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
    Name = "Chams Transparency",
    Min = 0.0,
    Max = 1.0,
    Default = 0.45,
    Step = 0.05,
    Format = "%.2f",
    Callback = function(val)
    end
})

ChamCard:CreateDivider()

ChamCard:CreateColorPicker({
    Name = "Crosshair Overlay Color",
    Default = Color3.fromRGB(255, 255, 255),
    Callback = function(col)
        State.CrosshairColor = col
    end
})

local MoveCard = MiscTab:CreateCard("Movement Modifiers", "Left")
local ServerCard = MiscTab:CreateCard("Server & Utilities", "Right")

MoveCard:CreateToggle({
    Name = "Fly Mode",
    Default = false,
    Callback = function(val)
        State.Fly = val
    end
})

MoveCard:CreateKeybind({
    Name = "Fly Toggle Key",
    Default = Enum.KeyCode.F,
    Callback = function(key)
        State.FlyKey = key
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

MoveCard:CreateDivider()

MoveCard:CreateToggle({
    Name = "WalkSpeed Override",
    Default = false,
    Callback = function(val)
        State.SpeedHack = val
    end
})

MoveCard:CreateSlider({
    Name = "Custom WalkSpeed",
    Min = 16,
    Max = 150,
    Default = 24,
    Step = 1,
    Format = "%.0f",
    Callback = function(val)
        State.WalkSpeed = val
    end
})

ServerCard:CreateButton({
    Name = "Rejoin Current Server",
    Accent = false,
    Callback = function()
        Library:Notify({
            Title = "Server",
            Content = "Rejoining server instance...",
            Duration = 3
        })
    end
})

ServerCard:CreateButton({
    Name = "Server Hop (Low Ping)",
    Accent = true,
    Callback = function()
        Library:Notify({
            Title = "Server Hop",
            Content = "Searching for optimal server...",
            Duration = 3
        })
    end
})

local CustomCardLeft = SettingsTab:CreateCard("Window & Header Customizer", "Left")
local CustomCardRight = SettingsTab:CreateCard("HUD & Footer Customizer", "Right")

local Watermark = Library:CreateWatermark({
    Title = "unagitatedly"
})

local KeybindHUD = Library:CreateKeybindHUD({
    Title = "Active Modules"
})

KeybindHUD:Register("Silent Aim", function() return State.Aimbot end, Enum.KeyCode.E)
KeybindHUD:Register("Triggerbot", function() return State.Triggerbot end)
KeybindHUD:Register("Player ESP", function() return State.ESP end)
KeybindHUD:Register("Wallhack Chams", function() return State.Chams end)
KeybindHUD:Register("Fly Mode", function() return State.Fly end, Enum.KeyCode.F)

CustomCardLeft:CreateTextInput({
    Name = "Change UI Title",
    Placeholder = "Enter new window title...",
    Default = "unagitatedly",
    Callback = function(text)
        Window:SetTitle(text)
    end
})

CustomCardLeft:CreateTextInput({
    Name = "Change UI Subtitle",
    Placeholder = "Enter new subtitle...",
    Default = " ·  Universal Hub",
    Callback = function(text)
        Window:SetSubTitle(text)
    end
})

CustomCardLeft:CreateTextInput({
    Name = "Change Badge Text",
    Placeholder = "Enter badge text (e.g. VIP, DEV)...",
    Default = "v2.0",
    Callback = function(text)
        Window:SetBadge(text)
    end
})

CustomCardLeft:CreateTextInput({
    Name = "Change Top-Right Version Text",
    Placeholder = "Enter version (e.g. 2.0, PRO)...",
    Default = "2.0",
    Callback = function(text)
        Window:SetVersion(text)
    end
})

CustomCardLeft:CreateDivider()

CustomCardLeft:CreateColorPicker({
    Name = "Change UI Accent Theme Color",
    Default = Color3.fromRGB(244, 166, 205),
    Callback = function(col)
        Window:SetTheme({
            accent = col,
            accentBright = col
        })
    end
})

CustomCardLeft:CreateButton({
    Name = "Unload & Destroy UI",
    Accent = false,
    Callback = function()
        Window:Destroy()
    end
})

CustomCardRight:CreateTextInput({
    Name = "Change Watermark Title",
    Placeholder = "Enter watermark title...",
    Default = "unagitatedly",
    Callback = function(text)
        Watermark.SetTitle(text)
    end
})

CustomCardRight:CreateTextInput({
    Name = "Change Keybind HUD Title",
    Placeholder = "Enter HUD title...",
    Default = "Active Modules",
    Callback = function(text)
        KeybindHUD:SetTitle(text)
    end
})

CustomCardRight:CreateTextInput({
    Name = "Change Center Footer Text",
    Placeholder = "Enter center text...",
    Default = "unagitatedly hub",
    Callback = function(text)
        Window:SetFooter({ CenterText = text })
    end
})

CustomCardRight:CreateTextInput({
    Name = "Change Online Status Count",
    Placeholder = "Enter online count...",
    Default = "1,420 online",
    Callback = function(text)
        Window:SetFooter({ OnlineText = text })
    end
})

CustomCardRight:CreateDivider()

CustomCardRight:CreateToggle({
    Name = "Filter Keybind HUD (Only Active)",
    Default = false,
    Callback = function(val)
        KeybindHUD:SetOnlyActive(val)
    end
})

CustomCardRight:CreateDropdown({
    Name = "Notification Position",
    Options = { "Bottom Right", "Top Right", "Bottom Left", "Top Left" },
    Default = "Bottom Right",
    Callback = function(idx, opt)
        Library:SetNotificationPosition(opt)
        Library:Notify({
            Title = "Notification Position",
            Content = "Position set to " .. opt,
            Duration = 2.5
        })
    end
})

CustomCardRight:CreateButton({
    Name = "Send Test Slide Notification",
    Accent = true,
    Callback = function()
        Library:Notify({
            Title = "Notification Test",
            Content = "Smooth slide-in and custom real-time editing!",
            Duration = 3.5
        })
    end
})

Library:Notify({
    Title = "unagitatedly",
    Content = "UI loaded successfully! Press [Insert] to toggle menu.",
    Duration = 4
})
