# unagitatedly UI Library

A lightweight, dark-themed UI library for Roblox scripts built with vanilla Luau and TweenService.

---

## Features

- **Matcha Theme**: Deep charcoal base (`#0b0b10`), pastel pink accents (`#f4a6cd`), crisp borders (`#1a1a24`).
- **Layout**: Tabbed navigation with 2-column responsive card layouts.
- **Controls**: Toggles, sliders, scrolling dropdowns, text inputs, standard and accent action buttons.
- **HUD Overlays**: Draggable FPS/ping watermark and active feature keybind indicator.

---

## Installation

Load the library directly in your Roblox script / executor:

```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/unagitatedly/repo/main/unagitatedly_ui.lua"))()
```

Or load from your executor workspace locally:

```lua
local Library = loadstring(readfile("unagitatedly_ui.lua"))()
```

Or with fallback support (local file first, then GitHub):

```lua
local Library = loadstring(readfile and (pcall(readfile, "unagitatedly_ui.lua") and readfile("unagitatedly_ui.lua") or readfile("matcha_lib.lua")) or game:HttpGet("https://raw.githubusercontent.com/unagitatedly/repo/main/unagitatedly_ui.lua"))()
```

---

## Example Usage

```lua
local Library = loadstring(readfile and readfile("unagitatedly_ui.lua") or game:HttpGet("https://raw.githubusercontent.com/unagitatedly/repo/main/unagitatedly_ui.lua"))()

local Window = Library:CreateWindow({
    Title = "unagitatedly",
    SubTitle = " ·  Universal",
    Badge = "Standard",
    Version = "v2.1",
    Size = UDim2.new(0, 680, 0, 760),
    ToggleKey = Enum.KeyCode.Insert,
    Footer = {
        OnlineText = "0 online",
        OnlineColor = "#22c55e",
        CenterText = "match remake",
        BuildDate = "August 2026",
        BuildColor = "#f4a6cd",
    }
})

-- Create a Tab
local CombatTab = Window:CreateTab("Combat")

-- Create Left and Right Cards
local AimCard = CombatTab:CreateCard("Aimbot Settings", "Left")
local PredCard = CombatTab:CreateCard("Velocity Lead", "Right")

-- Toggle
AimCard:CreateToggle({
    Name = "Enable Aimbot",
    Default = false,
    Callback = function(state)
        print("Aimbot:", state)
    end
})

-- Slider
AimCard:CreateSlider({
    Name = "Smoothness X",
    Min = 1.0,
    Max = 30.0,
    Default = 4.0,
    Format = "%.1f",
    Callback = function(val)
        print("Smoothness:", val)
    end
})

-- Dropdown
AimCard:CreateDropdown({
    Name = "Target Bone",
    Options = { "Head", "UpperTorso", "HumanoidRootPart" },
    Default = 0,
    Callback = function(idx, option)
        print("Selected:", option)
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

-- Button
PredCard:CreateButton({
    Name = "Save Settings",
    Accent = true,
    Callback = function()
        print("Saved!")
    end
})

-- Draggable Watermark
local Watermark = Library:CreateWatermark({
    Title = "unagitatedly"
})

-- Draggable Active Modules HUD
local KeybindHUD = Library:CreateKeybindHUD({
    Title = "Active Modules"
})

KeybindHUD:Register("Aimbot", function() return true end)
KeybindHUD:Register("Wallbang", function() return false end)
```

---

## Controls Reference

| Control | Parameters | Return / Methods |
|---|---|---|
| `CreateWindow(config)` | `Title`, `SubTitle`, `Badge`, `Version`, `Size`, `ToggleKey`, `Footer` | `Window` object |
| `Window:CreateTab(name)` | Tab name string | `Tab` object with `.CreateCard` |
| `Tab:CreateCard(title, side)` | `title` string, `side` (`"Left"` / `"Right"`) | `Card` object |
| `Card:CreateToggle(config)` | `Name`, `Default`, `Callback` | `{ Set(bool), Get() }` |
| `Card:CreateSlider(config)` | `Name`, `Min`, `Max`, `Default`, `Format`, `Callback` | `{ Set(num), Get() }` |
| `Card:CreateDropdown(config)` | `Name`, `Options`, `Default`, `Callback` | `{ Set(idx), Get() }` |
| `Card:CreateTextInput(config)` | `Name`, `Placeholder`, `Default`, `Callback` | `{ Set(str), Get() }` |
| `Card:CreateButton(config)` | `Name`, `Accent` (boolean), `Callback` | `TextButton` instance |
| `Library:CreateWatermark(config)` | `Title` | Draggable Watermark Frame |
| `Library:CreateKeybindHUD(config)` | `Title` | `{ Register(name, getterFn) }` |
| `Library:SpoofDevice(platform)` | `"PC"`, `"Mobile"`, `"Console"`, `"Disabled"` | Spoofs input platform & touch/gamepad state |

---

## Default Colors

| Property | Value | Description |
|---|---|---|
| `accent` | `rgb(244, 166, 205)` | Pastel pink primary |
| `accentBright` | `rgb(255, 130, 185)` | Bright hover pink |
| `windowBg` | `rgb(11, 11, 16)` | Window background |
| `cardBg` | `rgb(16, 16, 23)` | Card surface |
| `inputBg` | `rgb(20, 20, 29)` | Inputs & dropdown boxes |
| `border` | `rgb(26, 26, 36)` | Subtle stroke borders |
| `text` | `rgb(245, 245, 250)` | Primary text |
| `textMuted` | `rgb(115, 115, 138)` | Secondary labels |
