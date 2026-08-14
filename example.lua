local Library = loadstring(readfile and (pcall(readfile, "unagitatedly_ui.lua") and readfile("unagitatedly_ui.lua") or readfile("matcha_lib.lua")) or game:HttpGet("https://raw.githubusercontent.com/unagitatedly/repo/main/unagitatedly_ui.lua"))()

local Window = Library:CreateWindow({
    Title = "unagitatedly",
    SubTitle = " ·  Example Script",
    Badge = "Standard",
    Version = "R2K",
    Size = UDim2.new(0, 680, 0, 760),
    ToggleKey = Enum.KeyCode.Insert,
    Footer = {
        OnlineText = "0 online",
        OnlineColor = "#22c55e",
        CenterText = "match remake",
        BuildDate = "August 13 2026",
        BuildColor = "#f4a6cd",
    }
})

local CombatTab = Window:CreateTab("Combat")
local VisualsTab = Window:CreateTab("Visuals")
local MiscTab = Window:CreateTab("Misc")
local ConfigTab = Window:CreateTab("Configs")

local AimbotCard = CombatTab:CreateCard("Aimbot Settings", "Left")
local PredictionCard = CombatTab:CreateCard("Velocity Prediction", "Right")

local State = {
    Aimbot = false,
    SilentAim = false,
    Triggerbot = false,
    SmoothX = 4.0,
    SmoothY = 4.0,
    TargetBone = "Head",
    ESP = false,
    Fly = false,
    FlySpeed = 50,
}

AimbotCard:CreateToggle({
    Name = "Enable Aimbot",
    Default = false,
    Callback = function(val)
        State.Aimbot = val
        print("Aimbot:", val)
    end
})

AimbotCard:CreateToggle({
    Name = "Silent Aim",
    Default = false,
    Callback = function(val)
        State.SilentAim = val
        print("Silent Aim:", val)
    end
})

AimbotCard:CreateSlider({
    Name = "Smoothness X",
    Min = 1.0,
    Max = 30.0,
    Default = 4.0,
    Format = "%.1f",
    Callback = function(val)
        State.SmoothX = val
    end
})

AimbotCard:CreateSlider({
    Name = "Smoothness Y",
    Min = 1.0,
    Max = 30.0,
    Default = 4.0,
    Format = "%.1f",
    Callback = function(val)
        State.SmoothY = val
    end
})

AimbotCard:CreateDropdown({
    Name = "Target Bone",
    Options = { "Head", "UpperTorso", "HumanoidRootPart" },
    Default = 0,
    Callback = function(idx, opt)
        State.TargetBone = opt
        print("Selected bone:", opt)
    end
})

PredictionCard:CreateToggle({
    Name = "Enable Triggerbot (Auto Shoot)",
    Default = false,
    Callback = function(val)
        State.Triggerbot = val
        print("Triggerbot:", val)
    end
})

PredictionCard:CreateSlider({
    Name = "Reaction Delay (ms)",
    Min = 0,
    Max = 200,
    Default = 25,
    Format = "%.0f ms",
    Callback = function(val)
        print("Delay:", val)
    end
})

PredictionCard:CreateTextInput({
    Name = "Custom Webhook URL",
    Placeholder = "https://discord.com/api/webhooks/...",
    Default = "",
    Callback = function(text)
        print("Webhook set to:", text)
    end
})

PredictionCard:CreateButton({
    Name = "Test Action (Accent Button)",
    Accent = true,
    Callback = function()
        print("Accent button pressed!")
    end
})

local EspCard = VisualsTab:CreateCard("Player ESP", "Left")
local ChamCard = VisualsTab:CreateCard("Player Chams", "Right")

EspCard:CreateToggle({
    Name = "Enable Visual ESP",
    Default = false,
    Callback = function(val)
        State.ESP = val
    end
})

EspCard:CreateToggle({
    Name = "2D Bounding Boxes",
    Default = false,
    Callback = function(val)
        print("Boxes:", val)
    end
})

EspCard:CreateToggle({
    Name = "Skeleton ESP (Bones)",
    Default = false,
    Callback = function(val)
        print("Skeleton:", val)
    end
})

ChamCard:CreateToggle({
    Name = "Enable Wallhack Chams",
    Default = false,
    Callback = function(val)
        print("Chams:", val)
    end
})

ChamCard:CreateSlider({
    Name = "Fill Transparency",
    Min = 0.0,
    Max = 1.0,
    Default = 0.45,
    Format = "%.2f",
    Callback = function(val)
        print("Fill Trans:", val)
    end
})

local MoveCard = MiscTab:CreateCard("Movement & Fly", "Left")

MoveCard:CreateToggle({
    Name = "Enable Fly Mode",
    Default = false,
    Callback = function(val)
        State.Fly = val
    end
})

MoveCard:CreateSlider({
    Name = "Fly Speed",
    Min = 10,
    Max = 200,
    Default = 50,
    Format = "%.0f studs/s",
    Callback = function(val)
        State.FlySpeed = val
    end
})

local Watermark = Library:CreateWatermark({
    Title = "unagitatedly"
})

local KeybindHUD = Library:CreateKeybindHUD({
    Title = "Active Modules"
})

KeybindHUD:Register("Aimbot", function() return State.Aimbot end)
KeybindHUD:Register("Silent Aim", function() return State.SilentAim end)
KeybindHUD:Register("Triggerbot", function() return State.Triggerbot end)
KeybindHUD:Register("Player ESP", function() return State.ESP end)
KeybindHUD:Register("Fly Mode", function() return State.Fly end)

print("[unagitatedly] Example loaded successfully!")
