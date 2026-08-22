# unagitatedly UI Library

A lightweight, matcha inspired UI library for Roblox scripts built with pure Luau and TweenService.

---

## Features

- **Matcha Theme**: Deep charcoal base (`#0b0b10`), pastel pink accents (`#f4a6cd`), crisp borders (`#1a1a24`).
- **Full Customizability**: Live runtime editing for titles, subtitles, badges, footers, themes, and labels.
- **Controls**: Toggles, sliders with step snapping, searchable/scrollable dropdowns with dynamic refresh, interactive keybinds, color pickers, text inputs, standard and accent action buttons.
- **Toast Notifications**: Built-in glassmorphic corner notification system.
- **HUD Overlays**: Draggable live FPS/ping watermark and active feature keybind indicators.

---

## Installation

Load the library directly in your Roblox script or executor:

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/chirdas-lol/repo/refs/heads/main/unagitatedly_ui.lua"))()
```

---

## Quick Example

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/chirdas-loly/repo/refs/heads/main/unagitatedly_ui.lua"))()

local Window = Library:CreateWindow({
    Title = "unagitatedly",
    SubTitle = " ·  Universal Hub",
    Badge = "v2.0",
    Version = "2.0",
    Size = UDim2.new(0, 680, 0, 760),
    ToggleKey = Enum.KeyCode.Insert,
    Footer = {
        OnlineText = "1,420 online",
        OnlineColor = "#22c55e",
        CenterText = "unagitatedly hub",
        BuildDate = "August 14 2026",
        BuildColor = "#f4a6cd",
    }
})

local CombatTab = Window:CreateTab("Combat")
local AimCard = CombatTab:CreateCard("Aimbot Settings", "Left")
local PredCard = CombatTab:CreateCard("Velocity Lead", "Right")

-- Toggle
AimCard:CreateToggle({
    Name = "Enable Silent Aim",
    Default = false,
    Callback = function(state)
        print("Silent Aim:", state)
    end
})

-- Keybind
AimCard:CreateKeybind({
    Name = "Aim Key",
    Default = Enum.KeyCode.E,
    Callback = function(key)
        print("Aim key set to:", key.Name)
    end
})

-- Slider
AimCard:CreateSlider({
    Name = "Smoothness X",
    Min = 1.0,
    Max = 30.0,
    Default = 4.0,
    Step = 0.5,
    Format = "%.1f",
    Callback = function(val)
        print("Smoothness:", val)
    end
})

-- Dropdown
local BoneDrop = AimCard:CreateDropdown({
    Name = "Target Hitbox",
    Options = { "Head", "UpperTorso", "HumanoidRootPart" },
    Default = "Head",
    Callback = function(idx, option)
        print("Selected:", option)
    end
})

-- Color Picker
PredCard:CreateColorPicker({
    Name = "Accent Color",
    Default = Color3.fromRGB(244, 166, 205),
    Callback = function(col)
        print("Color changed")
    end
})

-- Text Input
PredCard:CreateTextInput({
    Name = "Webhook URL",
    Placeholder = "https://discord.com/api/webhooks/...",
    Default = "",
    Callback = function(text)
        print("Webhook:", text)
    end
})

-- Action Button
PredCard:CreateButton({
    Name = "Send Notification",
    Accent = true,
    Callback = function()
        Library:Notify({
            Title = "unagitatedly",
            Content = "Notification triggered!",
            Duration = 3
        })
    end
})

-- Watermark
local Watermark = Library:CreateWatermark({
    Title = "unagitatedly"
})

-- Keybind HUD
local KeybindHUD = Library:CreateKeybindHUD({
    Title = "Active Modules"
})

KeybindHUD:Register("Silent Aim", function() return true end)
```

---

## Controls Reference

| Control | Parameters | Return / Methods |
|---|---|---|
| `CreateWindow(config)` | `Title`, `SubTitle`, `Badge`, `Version`, `Size`, `ToggleKey`, `Theme`, `Footer` | `Window` object |
| `Window:SetTitle(title)` | `title` string | Updates header title |
| `Window:SetSubTitle(sub)` | `sub` string | Updates header subtitle |
| `Window:SetBadge(text, bgCol, txtCol)` | `text`, optional background & text colors | Updates header badge |
| `Window:SetFooter(cfg)` | `OnlineText`, `OnlineColor`, `CenterText`, `BuildDate` | Updates footer text & colors |
| `Window:Toggle()` / `Show()` / `Hide()` | None | Controls window visibility |
| `Window:Destroy()` | None | Unloads and cleans up the UI |
| `Window:CreateTab(name)` | Tab name string | `Tab` object with `.CreateCard` |
| `Tab:CreateCard(title, side)` | `title` string, `side` (`"Left"` / `"Right"`) | `Card` object |
| `Card:CreateToggle(config)` | `Name`, `Default`, `Callback` | `{ Set(bool), Get() }` |
| `Card:CreateSlider(config)` | `Name`, `Min`, `Max`, `Default`, `Step`, `Format`, `Callback` | `{ Set(num), Get() }` |
| `Card:CreateDropdown(config)` | `Name`, `Options`, `Default`, `Callback` | `{ Set(val), Refresh(options, default), Get() }` |
| `Card:CreateKeybind(config)` | `Name`, `Default` (`Enum.KeyCode`), `Callback` | `{ Set(key), Get() }` |
| `Card:CreateColorPicker(config)` | `Name`, `Default` (`Color3`/hex), `Callback` | `{ Set(col), Get() }` |
| `Card:CreateTextInput(config)` | `Name`, `Placeholder`, `Default`, `Callback` | `{ Set(str), Get() }` |
| `Card:CreateButton(config)` | `Name`, `Accent` (boolean), `Callback` | `{ SetText(str), SetCallback(fn), Instance }` |
| `Card:CreateLabel(config)` | `Text` string or `{ Text, Color }` | `{ SetText(str), SetColor(col), Instance }` |
| `Library:Notify(config)` | `Title`, `Content`, `Duration` | Spawns corner toast notification |
| `Library:CreateWatermark(config)` | `Title` | `{ SetTitle(str), SetVisible(bool), Frame }` |
| `Library:CreateKeybindHUD(config)` | `Title` | `{ Register(name, getterFn), SetTitle(str), SetVisible(bool), Frame }` |

---

## Theme Properties

| Property | Default Value | Description |
|---|---|---|
| `accent` | `rgb(244, 166, 205)` | Pastel pink primary |
| `accentBright` | `rgb(255, 130, 185)` | Hover pink |
| `windowBg` | `rgb(11, 11, 16)` | Window background |
| `cardBg` | `rgb(16, 16, 23)` | Card surface |
| `inputBg` | `rgb(20, 20, 29)` | Inputs, keybinds & dropdowns |
| `border` | `rgb(26, 26, 36)` | Subtle stroke border |
| `borderBright` | `rgb(42, 42, 58)` | Highlight stroke border |
| `text` | `rgb(245, 245, 250)` | Primary text |
| `textMuted` | `rgb(115, 115, 138)` | Secondary labels |
