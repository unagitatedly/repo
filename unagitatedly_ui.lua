local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Library = {
    ActiveDropdownCloseFn = nil,
    Windows = {},
    Flags = {},
    ScreenGui = nil,
    NotificationContainer = nil,
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
        textDark = Color3.fromRGB(65, 65, 82),
        font = Enum.Font.GothamMedium,
        fontBold = Enum.Font.GothamBold,
    }
}

local function ParseColor(c)
    if typeof(c) == "Color3" then return c end
    if typeof(c) == "string" and c:sub(1, 1) == "#" then
        local hex = c:gsub("#", "")
        if #hex == 6 then
            local r = tonumber(hex:sub(1, 2), 16) or 255
            local g = tonumber(hex:sub(3, 4), 16) or 255
            local b = tonumber(hex:sub(5, 6), 16) or 255
            return Color3.fromRGB(r, g, b)
        end
    end
    return Library.Theme.accent
end

local function Tween(obj, props, t, style, dir)
    local tw = TweenService:Create(obj, TweenInfo.new(t or 0.15, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props)
    tw:Play()
    return tw
end

local function CreateStroke(parent, color, thickness, trans)
    local s = Instance.new("UIStroke")
    s.Color = color or Library.Theme.border
    s.Thickness = thickness or 1
    s.Transparency = trans or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

local ScreenParent = LocalPlayer:WaitForChild("PlayerGui")
pcall(function()
    if gethui then
        ScreenParent = gethui()
    elseif CoreGui then
        ScreenParent = CoreGui
    end
end)

function Library:CloseDropdown()
    if Library.ActiveDropdownCloseFn then
        Library.ActiveDropdownCloseFn()
        Library.ActiveDropdownCloseFn = nil
    end
end

function Library:Destroy()
    Library:CloseDropdown()
    if Library.ScreenGui then
        pcall(function() Library.ScreenGui:Destroy() end)
        Library.ScreenGui = nil
    end
    if getgenv and getgenv()._UnagitatedlyUI then
        pcall(function() getgenv()._UnagitatedlyUI:Destroy() end)
        getgenv()._UnagitatedlyUI = nil
    end
end

function Library:Notify(nConfig)
    nConfig = nConfig or {}
    local title = nConfig.Title or "unagitatedly"
    local content = nConfig.Content or ""
    local duration = nConfig.Duration or 3.5

    local parentGui = Library.ScreenGui or ScreenParent:FindFirstChildOfClass("ScreenGui")
    if not parentGui then
        parentGui = Instance.new("ScreenGui")
        parentGui.Name = HttpService:GenerateGUID(false)
        parentGui.ResetOnSpawn = false
        parentGui.IgnoreGuiInset = true
        parentGui.DisplayOrder = 9999
        parentGui.Parent = ScreenParent
        Library.ScreenGui = parentGui
    end

    if not Library.NotificationContainer or not Library.NotificationContainer.Parent then
        local notifBox = Instance.new("Frame")
        notifBox.Name = "Notifications"
        notifBox.Size = UDim2.new(0, 280, 1, -40)
        notifBox.Position = UDim2.new(1, -290, 0, 20)
        notifBox.BackgroundTransparency = 1
        notifBox.ZIndex = 500
        notifBox.Parent = parentGui

        local layout = Instance.new("UIListLayout")
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
        layout.Padding = UDim.new(0, 8)
        layout.Parent = notifBox

        Library.NotificationContainer = notifBox
    end

    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 56)
    card.BackgroundColor3 = Library.Theme.cardBg
    card.BackgroundTransparency = 0.05
    card.Position = UDim2.new(1, 300, 0, 0)
    card.BorderSizePixel = 0
    card.ZIndex = 501
    card.Parent = Library.NotificationContainer

    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 8)
    cc.Parent = card

    local stroke = CreateStroke(card, Library.Theme.borderBright, 1, 0)

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 8)
    pad.PaddingBottom = UDim.new(0, 8)
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)
    pad.Parent = card

    local tLbl = Instance.new("TextLabel")
    tLbl.Size = UDim2.new(1, 0, 0, 16)
    tLbl.BackgroundTransparency = 1
    tLbl.Font = Library.Theme.fontBold
    tLbl.TextSize = 12
    tLbl.TextColor3 = Library.Theme.accent
    tLbl.TextXAlignment = Enum.TextXAlignment.Left
    tLbl.Text = title
    tLbl.ZIndex = 502
    tLbl.Parent = card

    local cLbl = Instance.new("TextLabel")
    cLbl.Size = UDim2.new(1, 0, 0, 22)
    cLbl.Position = UDim2.new(0, 0, 0, 18)
    cLbl.BackgroundTransparency = 1
    cLbl.Font = Library.Theme.font
    cLbl.TextSize = 11
    cLbl.TextColor3 = Library.Theme.text
    cLbl.TextXAlignment = Enum.TextXAlignment.Left
    cLbl.TextWrapped = true
    cLbl.Text = content
    cLbl.ZIndex = 502
    cLbl.Parent = card

    Tween(card, { BackgroundTransparency = 0 }, 0.2)

    task.delay(duration, function()
        if card and card.Parent then
            local tw = Tween(card, { BackgroundTransparency = 1 }, 0.25)
            Tween(stroke, { Transparency = 1 }, 0.25)
            Tween(tLbl, { TextTransparency = 1 }, 0.25)
            Tween(cLbl, { TextTransparency = 1 }, 0.25)
            tw.Completed:Connect(function()
                card:Destroy()
            end)
        end
    end)
end

function Library:CreateWindow(config)
    config = config or {}
    local Title = config.Title or "unagitatedly"
    local SubTitle = config.SubTitle or " ·  Universal"
    local BadgeText = config.Badge or "Standard"
    local Version = config.Version or "2.0"
    local Size = config.Size or UDim2.new(0, 680, 0, 760)
    local ToggleKey = config.ToggleKey or Enum.KeyCode.Insert
    if typeof(ToggleKey) == "string" and Enum.KeyCode[ToggleKey] then
        ToggleKey = Enum.KeyCode[ToggleKey]
    end

    if config.Theme and typeof(config.Theme) == "table" then
        for k, v in pairs(config.Theme) do
            Library.Theme[k] = (typeof(v) == "string" and v:sub(1, 1) == "#") and ParseColor(v) or v
        end
    end

    local FooterCfg = config.Footer or {
        OnlineText = "0 online",
        OnlineColor = "#22c55e",
        CenterText = "match remake",
        BuildDate = "August 13 2026",
        BuildColor = "#f4a6cd",
    }

    if getgenv and getgenv()._UnagitatedlyUI then
        pcall(function() getgenv()._UnagitatedlyUI:Destroy() end)
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = HttpService:GenerateGUID(false)
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 9999
    ScreenGui.Parent = ScreenParent
    Library.ScreenGui = ScreenGui

    if getgenv then
        getgenv()._UnagitatedlyUI = ScreenGui
    end

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = Size
    MainFrame.Position = UDim2.new(0.5, -Size.X.Offset * 0.5, 0.5, -Size.Y.Offset * 0.5)
    MainFrame.BackgroundColor3 = Library.Theme.windowBg
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.ClipsDescendants = false
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 14)
    MainCorner.Parent = MainFrame

    CreateStroke(MainFrame, Library.Theme.border, 1.2, 0)

    local HeaderBar = Instance.new("Frame")
    HeaderBar.Name = "HeaderBar"
    HeaderBar.Size = UDim2.new(1, -36, 0, 36)
    HeaderBar.Position = UDim2.new(0, 18, 0, 14)
    HeaderBar.BackgroundTransparency = 1
    HeaderBar.ZIndex = 3
    HeaderBar.Parent = MainFrame

    local isDragging, dragStart, startPos = false, nil, nil
    HeaderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Library:CloseDropdown()
            isDragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then isDragging = false end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local BrandContainer = Instance.new("Frame")
    BrandContainer.Size = UDim2.new(0.7, 0, 1, 0)
    BrandContainer.BackgroundTransparency = 1
    BrandContainer.ZIndex = 3
    BrandContainer.Parent = HeaderBar

    local BrandLayout = Instance.new("UIListLayout")
    BrandLayout.FillDirection = Enum.FillDirection.Horizontal
    BrandLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    BrandLayout.SortOrder = Enum.SortOrder.LayoutOrder
    BrandLayout.Padding = UDim.new(0, 6)
    BrandLayout.Parent = BrandContainer

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.AutomaticSize = Enum.AutomaticSize.X
    TitleLabel.Size = UDim2.new(0, 0, 1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Library.Theme.fontBold
    TitleLabel.TextSize = 13
    TitleLabel.TextColor3 = Library.Theme.accent
    TitleLabel.Text = Title
    TitleLabel.LayoutOrder = 1
    TitleLabel.ZIndex = 3
    TitleLabel.Parent = BrandContainer

    local SubTitleLabel = Instance.new("TextLabel")
    SubTitleLabel.AutomaticSize = Enum.AutomaticSize.X
    SubTitleLabel.Size = UDim2.new(0, 0, 1, 0)
    SubTitleLabel.BackgroundTransparency = 1
    SubTitleLabel.Font = Library.Theme.font
    SubTitleLabel.TextSize = 13
    SubTitleLabel.TextColor3 = Library.Theme.text
    SubTitleLabel.Text = SubTitle
    SubTitleLabel.LayoutOrder = 2
    SubTitleLabel.ZIndex = 3
    SubTitleLabel.Parent = BrandContainer

    local StandardBadge = Instance.new("TextLabel")
    StandardBadge.Size = UDim2.new(0, 62, 0, 19)
    StandardBadge.BackgroundColor3 = Color3.fromRGB(34, 18, 28)
    StandardBadge.Font = Library.Theme.fontBold
    StandardBadge.TextSize = 10
    StandardBadge.TextColor3 = Color3.fromRGB(244, 140, 185)
    StandardBadge.Text = BadgeText
    StandardBadge.LayoutOrder = 3
    StandardBadge.ZIndex = 3
    StandardBadge.Parent = BrandContainer

    local sbc = Instance.new("UICorner")
    sbc.CornerRadius = UDim.new(0, 10)
    sbc.Parent = StandardBadge
    local badgeStroke = CreateStroke(StandardBadge, Color3.fromRGB(56, 28, 44), 1, 0)

    local VersionLabel = Instance.new("TextLabel")
    VersionLabel.Size = UDim2.new(0.3, 0, 1, 0)
    VersionLabel.Position = UDim2.new(0.7, 0, 0, 0)
    VersionLabel.BackgroundTransparency = 1
    VersionLabel.Font = Library.Theme.fontBold
    VersionLabel.TextSize = 11
    VersionLabel.TextColor3 = Library.Theme.textDark
    VersionLabel.TextXAlignment = Enum.TextXAlignment.Right
    VersionLabel.Text = Version
    VersionLabel.ZIndex = 3
    VersionLabel.Parent = HeaderBar

    local TopNavContainer = Instance.new("Frame")
    TopNavContainer.Name = "TopNavContainer"
    TopNavContainer.Size = UDim2.new(1, -36, 0, 32)
    TopNavContainer.Position = UDim2.new(0, 18, 0, 52)
    TopNavContainer.BackgroundTransparency = 1
    TopNavContainer.ZIndex = 3
    TopNavContainer.Parent = MainFrame

    local TopNavLayout = Instance.new("UIListLayout")
    TopNavLayout.FillDirection = Enum.FillDirection.Horizontal
    TopNavLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TopNavLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TopNavLayout.Padding = UDim.new(0, 6)
    TopNavLayout.Parent = TopNavContainer

    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "ContentArea"
    ContentArea.Size = UDim2.new(1, -36, 1, -128)
    ContentArea.Position = UDim2.new(0, 18, 0, 92)
    ContentArea.BackgroundTransparency = 1
    ContentArea.ZIndex = 3
    ContentArea.Parent = MainFrame

    local FooterBar = Instance.new("Frame")
    FooterBar.Name = "FooterBar"
    FooterBar.Size = UDim2.new(1, -36, 0, 24)
    FooterBar.Position = UDim2.new(0, 18, 1, -26)
    FooterBar.BackgroundTransparency = 1
    FooterBar.ZIndex = 3
    FooterBar.Parent = MainFrame

    local OnlineLabel = Instance.new("TextLabel")
    OnlineLabel.Size = UDim2.new(0.33, 0, 1, 0)
    OnlineLabel.BackgroundTransparency = 1
    OnlineLabel.Font = Library.Theme.fontBold
    OnlineLabel.TextSize = 11
    OnlineLabel.TextColor3 = Library.Theme.textMuted
    OnlineLabel.TextXAlignment = Enum.TextXAlignment.Left
    OnlineLabel.RichText = true
    OnlineLabel.Text = string.format("<font color='%s'>●</font>  %s", FooterCfg.OnlineColor or "#22c55e", FooterCfg.OnlineText or "0 online")
    OnlineLabel.ZIndex = 3
    OnlineLabel.Parent = FooterBar

    local DiscordLabel = Instance.new("TextLabel")
    DiscordLabel.Size = UDim2.new(0.34, 0, 1, 0)
    DiscordLabel.Position = UDim2.new(0.33, 0, 0, 0)
    DiscordLabel.BackgroundTransparency = 1
    DiscordLabel.Font = Library.Theme.font
    DiscordLabel.TextSize = 11
    DiscordLabel.TextColor3 = Library.Theme.textMuted
    DiscordLabel.TextXAlignment = Enum.TextXAlignment.Center
    DiscordLabel.Text = FooterCfg.CenterText or "match remake"
    DiscordLabel.ZIndex = 3
    DiscordLabel.Parent = FooterBar

    local BuildLabel = Instance.new("TextLabel")
    BuildLabel.Size = UDim2.new(0.33, 0, 1, 0)
    BuildLabel.Position = UDim2.new(0.67, 0, 0, 0)
    BuildLabel.BackgroundTransparency = 1
    BuildLabel.Font = Library.Theme.font
    BuildLabel.TextSize = 11
    BuildLabel.TextColor3 = Library.Theme.textMuted
    BuildLabel.TextXAlignment = Enum.TextXAlignment.Right
    BuildLabel.RichText = true
    BuildLabel.Text = string.format("Build: <font color='%s'>%s</font>", FooterCfg.BuildColor or "#f4a6cd", FooterCfg.BuildDate or "August 13 2026")
    BuildLabel.ZIndex = 3
    BuildLabel.Parent = FooterBar

    local WindowObj = {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        ContentArea = ContentArea,
        Tabs = {},
        NavButtons = {},
        CurrentTab = nil,
    }

    function WindowObj:SetTitle(newTitle)
        TitleLabel.Text = tostring(newTitle or "")
    end

    function WindowObj:SetSubTitle(newSubTitle)
        SubTitleLabel.Text = tostring(newSubTitle or "")
    end

    function WindowObj:SetBadge(text, bgCol, txtCol)
        StandardBadge.Text = tostring(text or "")
        if bgCol then StandardBadge.BackgroundColor3 = ParseColor(bgCol) end
        if txtCol then StandardBadge.TextColor3 = ParseColor(txtCol) end
    end

    function WindowObj:SetVersion(ver)
        VersionLabel.Text = tostring(ver or "")
    end

    function WindowObj:SetFooter(cfg)
        cfg = cfg or {}
        if cfg.OnlineText or cfg.OnlineColor then
            OnlineLabel.Text = string.format("<font color='%s'>●</font>  %s", cfg.OnlineColor or FooterCfg.OnlineColor or "#22c55e", cfg.OnlineText or FooterCfg.OnlineText or "0 online")
        end
        if cfg.CenterText then
            DiscordLabel.Text = tostring(cfg.CenterText)
        end
        if cfg.BuildDate or cfg.BuildColor then
            BuildLabel.Text = string.format("Build: <font color='%s'>%s</font>", cfg.BuildColor or FooterCfg.BuildColor or "#f4a6cd", cfg.BuildDate or FooterCfg.BuildDate or "August 13 2026")
        end
    end

    function WindowObj:Toggle()
        MainFrame.Visible = not MainFrame.Visible
        if not MainFrame.Visible then Library:CloseDropdown() end
    end

    function WindowObj:Show()
        MainFrame.Visible = true
    end

    function WindowObj:Hide()
        MainFrame.Visible = false
        Library:CloseDropdown()
    end

    function WindowObj:Destroy()
        Library:CloseDropdown()
        pcall(function() ScreenGui:Destroy() end)
    end

    function WindowObj:SwitchTab(name)
        WindowObj.CurrentTab = name
        Library:CloseDropdown()
        for tabName, btn in pairs(WindowObj.NavButtons) do
            local isSel = (tabName == name)
            Tween(btn, {
                BackgroundColor3 = isSel and Color3.fromRGB(22, 22, 32) or Color3.fromRGB(11, 11, 16),
                BackgroundTransparency = isSel and 0 or 1,
                TextColor3 = isSel and Library.Theme.text or Library.Theme.textMuted
            }, 0.15)
            local str = btn:FindFirstChildOfClass("UIStroke")
            if str then
                Tween(str, { Transparency = isSel and 0 or 1 }, 0.15)
            end
        end
        for tabName, page in pairs(WindowObj.Tabs) do
            page.Visible = (tabName == name)
        end
    end

    function WindowObj:CreateTab(name)
        local isFirst = (next(WindowObj.Tabs) == nil)

        local btn = Instance.new("TextButton")
        btn.Name = "Nav_" .. name
        btn.AutomaticSize = Enum.AutomaticSize.X
        btn.Size = UDim2.new(0, 0, 0, 28)
        btn.BackgroundColor3 = isFirst and Color3.fromRGB(22, 22, 32) or Color3.fromRGB(11, 11, 16)
        btn.BackgroundTransparency = isFirst and 0 or 1
        btn.BorderSizePixel = 0
        btn.Font = Library.Theme.fontBold
        btn.TextSize = 10
        btn.TextColor3 = isFirst and Library.Theme.text or Library.Theme.textMuted
        btn.Text = "  " .. name .. "  "
        btn.LayoutOrder = #TopNavContainer:GetChildren()
        btn.ZIndex = 4
        btn.Parent = TopNavContainer

        local bc = Instance.new("UICorner")
        bc.CornerRadius = UDim.new(0, 8)
        bc.Parent = btn

        CreateStroke(btn, Library.Theme.borderBright, 1, isFirst and 0 or 1)

        WindowObj.NavButtons[name] = btn

        btn.MouseButton1Click:Connect(function()
            WindowObj:SwitchTab(name)
        end)

        local page = Instance.new("ScrollingFrame")
        page.Name = "Page_" .. name
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 2
        page.ScrollBarImageColor3 = Library.Theme.borderBright
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.Visible = isFirst
        page.ZIndex = 3
        page.Parent = ContentArea

        page:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
            Library:CloseDropdown()
        end)

        local leftCol = Instance.new("Frame")
        leftCol.Name = "LeftColumn"
        leftCol.Size = UDim2.new(0.5, -8, 1, 0)
        leftCol.Position = UDim2.new(0, 0, 0, 0)
        leftCol.BackgroundTransparency = 1
        leftCol.ZIndex = 3
        leftCol.Parent = page

        local leftLayout = Instance.new("UIListLayout")
        leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
        leftLayout.Padding = UDim.new(0, 8)
        leftLayout.Parent = leftCol

        local rightCol = Instance.new("Frame")
        rightCol.Name = "RightColumn"
        rightCol.Size = UDim2.new(0.5, -8, 1, 0)
        rightCol.Position = UDim2.new(0.5, 8, 0, 0)
        rightCol.BackgroundTransparency = 1
        rightCol.ZIndex = 3
        rightCol.Parent = page

        local rightLayout = Instance.new("UIListLayout")
        rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
        rightLayout.Padding = UDim.new(0, 8)
        rightLayout.Parent = rightCol

        WindowObj.Tabs[name] = page
        if isFirst then
            WindowObj.CurrentTab = name
        end

        local TabObj = {}

        function TabObj:CreateCard(cardTitle, side)
            local targetCol = (side and side:lower() == "right") and rightCol or leftCol

            local card = Instance.new("Frame")
            card.Size = UDim2.new(1, 0, 0, 0)
            card.AutomaticSize = Enum.AutomaticSize.Y
            card.BackgroundColor3 = Library.Theme.cardBg
            card.BorderSizePixel = 0
            card.ZIndex = 3
            card.Parent = targetCol

            local cc = Instance.new("UICorner")
            cc.CornerRadius = UDim.new(0, 10)
            cc.Parent = card

            CreateStroke(card, Library.Theme.border, 1, 0)

            local pad = Instance.new("UIPadding")
            pad.PaddingTop = UDim.new(0, 12)
            pad.PaddingBottom = UDim.new(0, 12)
            pad.PaddingLeft = UDim.new(0, 14)
            pad.PaddingRight = UDim.new(0, 14)
            pad.Parent = card

            local cardLayout = Instance.new("UIListLayout")
            cardLayout.SortOrder = Enum.SortOrder.LayoutOrder
            cardLayout.Padding = UDim.new(0, 8)
            cardLayout.Parent = card

            local cHeader = nil
            if cardTitle then
                cHeader = Instance.new("TextLabel")
                cHeader.Size = UDim2.new(1, 0, 0, 18)
                cHeader.BackgroundTransparency = 1
                cHeader.Font = Library.Theme.fontBold
                cHeader.TextSize = 12
                cHeader.TextColor3 = Library.Theme.text
                cHeader.TextXAlignment = Enum.TextXAlignment.Left
                cHeader.Text = cardTitle
                cHeader.LayoutOrder = 1
                cHeader.ZIndex = 4
                cHeader.Parent = card
            end

            local CardObj = { Frame = card, Header = cHeader }

            function CardObj:SetTitle(newTitle)
                if cHeader then cHeader.Text = tostring(newTitle or "") end
            end

            function CardObj:CreateLabel(lConfig)
                local text = typeof(lConfig) == "string" and lConfig or (lConfig and lConfig.Text or "")
                local color = (typeof(lConfig) == "table" and lConfig.Color) and ParseColor(lConfig.Color) or Library.Theme.textMuted

                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1, 0, 0, 18)
                lbl.BackgroundTransparency = 1
                lbl.Font = Library.Theme.font
                lbl.TextSize = 11
                lbl.TextColor3 = color
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.Text = text
                lbl.LayoutOrder = #card:GetChildren() + 1
                lbl.ZIndex = 4
                lbl.Parent = card

                return {
                    SetText = function(t) lbl.Text = tostring(t or "") end,
                    SetColor = function(c) lbl.TextColor3 = ParseColor(c) end,
                    Instance = lbl
                }
            end

            function CardObj:CreateToggle(tConfig)
                tConfig = tConfig or {}
                local name = tConfig.Name or "Toggle"
                local defaultVal = not not tConfig.Default
                local callback = tConfig.Callback or function() end

                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 22)
                row.BackgroundTransparency = 1
                row.LayoutOrder = #card:GetChildren() + 1
                row.ZIndex = 4
                row.Parent = card

                local clickArea = Instance.new("TextButton")
                clickArea.Size = UDim2.new(1, 0, 1, 0)
                clickArea.BackgroundTransparency = 1
                clickArea.Text = ""
                clickArea.ZIndex = 4
                clickArea.Parent = row

                local box = Instance.new("Frame")
                box.Size = UDim2.new(0, 14, 0, 14)
                box.Position = UDim2.new(0, 0, 0.5, -7)
                box.BackgroundColor3 = defaultVal and Library.Theme.accent or Color3.fromRGB(20, 20, 28)
                box.BorderSizePixel = 0
                box.ZIndex = 4
                box.Parent = row

                local bc2 = Instance.new("UICorner")
                bc2.CornerRadius = UDim.new(0, 4)
                bc2.Parent = box

                local bs = CreateStroke(box, defaultVal and Library.Theme.accent or Library.Theme.borderBright, 1, 0)

                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1, -26, 1, 0)
                lbl.Position = UDim2.new(0, 24, 0, 0)
                lbl.BackgroundTransparency = 1
                lbl.Font = Library.Theme.fontBold
                lbl.TextSize = 12
                lbl.TextColor3 = defaultVal and Library.Theme.text or Library.Theme.textMuted
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.Text = name
                lbl.ZIndex = 4
                lbl.Parent = row

                local state = defaultVal

                local function SetState(newVal)
                    state = not not newVal
                    if state then
                        Tween(box, { BackgroundColor3 = Library.Theme.accent }, 0.12)
                        Tween(bs, { Color = Library.Theme.accent }, 0.12)
                        Tween(lbl, { TextColor3 = Library.Theme.text }, 0.12)
                    else
                        Tween(box, { BackgroundColor3 = Color3.fromRGB(20, 20, 28) }, 0.12)
                        Tween(bs, { Color = Library.Theme.borderBright }, 0.12)
                        Tween(lbl, { TextColor3 = Library.Theme.textMuted }, 0.12)
                    end
                    pcall(callback, state)
                end

                clickArea.MouseButton1Click:Connect(function()
                    SetState(not state)
                end)

                return { Set = SetState, Get = function() return state end }
            end

            function CardObj:CreateSlider(sConfig)
                sConfig = sConfig or {}
                local name = sConfig.Name or "Slider"
                local minVal = tonumber(sConfig.Min) or 0
                local maxVal = tonumber(sConfig.Max) or 100
                if maxVal < minVal then maxVal = minVal end
                local defaultVal = tonumber(sConfig.Default) or minVal
                local formatStr = sConfig.Format or "%.2f"
                local step = tonumber(sConfig.Step)
                local callback = sConfig.Callback or function() end

                local container = Instance.new("Frame")
                container.Size = UDim2.new(1, 0, 0, 32)
                container.BackgroundTransparency = 1
                container.LayoutOrder = #card:GetChildren() + 1
                container.ZIndex = 4
                container.Parent = card

                local topLabel = Instance.new("TextLabel")
                topLabel.Size = UDim2.new(0.6, 0, 0, 14)
                topLabel.BackgroundTransparency = 1
                topLabel.Font = Library.Theme.fontBold
                topLabel.TextSize = 11
                topLabel.TextColor3 = Library.Theme.textMuted
                topLabel.TextXAlignment = Enum.TextXAlignment.Left
                topLabel.Text = name
                topLabel.ZIndex = 4
                topLabel.Parent = container

                local valLabel = Instance.new("TextLabel")
                valLabel.Size = UDim2.new(0.4, 0, 0, 14)
                valLabel.Position = UDim2.new(0.6, 0, 0, 0)
                valLabel.BackgroundTransparency = 1
                valLabel.Font = Library.Theme.fontBold
                valLabel.TextSize = 11
                valLabel.TextColor3 = Library.Theme.text
                valLabel.TextXAlignment = Enum.TextXAlignment.Right
                valLabel.ZIndex = 4
                valLabel.Parent = container

                local track = Instance.new("Frame")
                track.Size = UDim2.new(1, 0, 0, 4)
                track.Position = UDim2.new(0, 0, 0, 20)
                track.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
                track.BorderSizePixel = 0
                track.ZIndex = 4
                track.Parent = container

                local tc = Instance.new("UICorner")
                tc.CornerRadius = UDim.new(1, 0)
                tc.Parent = track

                local range = math.max(1e-4, maxVal - minVal)
                local pct = math.clamp((defaultVal - minVal) / range, 0, 1)

                local fill = Instance.new("Frame")
                fill.Size = UDim2.new(pct, 0, 1, 0)
                fill.BackgroundColor3 = Library.Theme.accent
                fill.BorderSizePixel = 0
                fill.ZIndex = 5
                fill.Parent = track

                local fc = Instance.new("UICorner")
                fc.CornerRadius = UDim.new(1, 0)
                fc.Parent = fill

                local knob = Instance.new("Frame")
                knob.Size = UDim2.new(0, 10, 0, 10)
                knob.Position = UDim2.new(pct, -5, 0.5, -5)
                knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                knob.BorderSizePixel = 0
                knob.ZIndex = 6
                knob.Parent = track

                local kc = Instance.new("UICorner")
                kc.CornerRadius = UDim.new(1, 0)
                kc.Parent = knob

                local currentVal = defaultVal

                local function SetValue(val)
                    local v = tonumber(val) or minVal
                    if step and step > 0 then
                        v = math.floor((v - minVal) / step + 0.5) * step + minVal
                    end
                    currentVal = math.clamp(v, minVal, maxVal)
                    local p = math.clamp((currentVal - minVal) / range, 0, 1)
                    fill.Size = UDim2.new(p, 0, 1, 0)
                    knob.Position = UDim2.new(p, -5, 0.5, -5)
                    valLabel.Text = string.format(formatStr, currentVal)
                    pcall(callback, currentVal)
                end

                SetValue(defaultVal)

                local isSliding = false
                local clickArea = Instance.new("TextButton")
                clickArea.Size = UDim2.new(1, 0, 0, 16)
                clickArea.Position = UDim2.new(0, 0, 0, 14)
                clickArea.BackgroundTransparency = 1
                clickArea.Text = ""
                clickArea.ZIndex = 7
                clickArea.Parent = container

                clickArea.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isSliding = true
                        local trackW = track.AbsoluteSize.X
                        local relX = (trackW > 0) and math.clamp((input.Position.X - track.AbsolutePosition.X) / trackW, 0, 1) or 0
                        SetValue(minVal + relX * (maxVal - minVal))
                    end
                end)

                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        isSliding = false
                    end
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                        local trackW = track.AbsoluteSize.X
                        local relX = (trackW > 0) and math.clamp((input.Position.X - track.AbsolutePosition.X) / trackW, 0, 1) or 0
                        SetValue(minVal + relX * (maxVal - minVal))
                    end
                end)

                return { Set = SetValue, Get = function() return currentVal end }
            end

            function CardObj:CreateDropdown(dConfig)
                dConfig = dConfig or {}
                local name = dConfig.Name or "Dropdown"
                local options = dConfig.Options or { "Option 1", "Option 2" }
                local callback = dConfig.Callback or function() end

                local defaultIdx = 0
                if typeof(dConfig.Default) == "number" then
                    defaultIdx = dConfig.Default
                    if defaultIdx >= 1 and defaultIdx <= #options and not options[defaultIdx + 1] and defaultIdx == #options then
                        defaultIdx = defaultIdx - 1
                    end
                elseif typeof(dConfig.Default) == "string" then
                    for i, opt in ipairs(options) do
                        if opt == dConfig.Default then
                            defaultIdx = i - 1
                            break
                        end
                    end
                end

                local container = Instance.new("Frame")
                container.Size = UDim2.new(1, 0, 0, 48)
                container.BackgroundTransparency = 1
                container.LayoutOrder = #card:GetChildren() + 1
                container.ZIndex = 4
                container.Parent = card

                local topLabel = Instance.new("TextLabel")
                topLabel.Size = UDim2.new(1, 0, 0, 14)
                topLabel.BackgroundTransparency = 1
                topLabel.Font = Library.Theme.fontBold
                topLabel.TextSize = 11
                topLabel.TextColor3 = Library.Theme.textMuted
                topLabel.TextXAlignment = Enum.TextXAlignment.Left
                topLabel.Text = name
                topLabel.ZIndex = 4
                topLabel.Parent = container

                local comboBtn = Instance.new("TextButton")
                comboBtn.Size = UDim2.new(1, 0, 0, 28)
                comboBtn.Position = UDim2.new(0, 0, 0, 18)
                comboBtn.BackgroundColor3 = Library.Theme.inputBg
                comboBtn.BorderSizePixel = 0
                comboBtn.Font = Library.Theme.fontBold
                comboBtn.TextSize = 11
                comboBtn.TextColor3 = Library.Theme.text
                comboBtn.TextXAlignment = Enum.TextXAlignment.Left
                comboBtn.Text = "   " .. tostring(options[defaultIdx + 1] or options[1] or "")
                comboBtn.ZIndex = 5
                comboBtn.Parent = container

                local cc2 = Instance.new("UICorner")
                cc2.CornerRadius = UDim.new(0, 6)
                cc2.Parent = comboBtn

                CreateStroke(comboBtn, Library.Theme.border, 1, 0)

                local chevron = Instance.new("TextLabel")
                chevron.Size = UDim2.new(0, 24, 1, 0)
                chevron.Position = UDim2.new(1, -24, 0, 0)
                chevron.BackgroundTransparency = 1
                chevron.Font = Library.Theme.fontBold
                chevron.TextSize = 10
                chevron.TextColor3 = Library.Theme.textMuted
                chevron.Text = "v"
                chevron.ZIndex = 5
                chevron.Parent = comboBtn

                local currentIdx = defaultIdx
                local dropOverlay = nil
                local dropBlocker = nil

                local function destroyOverlay()
                    if dropBlocker then dropBlocker:Destroy() dropBlocker = nil end
                    if dropOverlay then dropOverlay:Destroy() dropOverlay = nil chevron.Text = "v" end
                end

                comboBtn.MouseButton1Click:Connect(function()
                    if dropOverlay then
                        Library:CloseDropdown()
                        return
                    end

                    Library:CloseDropdown()
                    chevron.Text = "^"

                    dropBlocker = Instance.new("TextButton")
                    dropBlocker.Name = "DropdownBackdrop"
                    dropBlocker.Size = UDim2.new(1, 0, 1, 0)
                    dropBlocker.BackgroundTransparency = 1
                    dropBlocker.Text = ""
                    dropBlocker.ZIndex = 198
                    dropBlocker.Parent = ScreenGui

                    dropBlocker.MouseButton1Click:Connect(function()
                        Library:CloseDropdown()
                    end)

                    local maxVisible = math.min(#options, 6)
                    local popupHeight = (maxVisible * 26) + 8

                    dropOverlay = Instance.new("ScrollingFrame")
                    dropOverlay.Name = "DropdownPopup"
                    dropOverlay.Size = UDim2.new(0, comboBtn.AbsoluteSize.X, 0, popupHeight)
                    dropOverlay.Position = UDim2.new(0, comboBtn.AbsolutePosition.X, 0, comboBtn.AbsolutePosition.Y + comboBtn.AbsoluteSize.Y + 4)
                    dropOverlay.BackgroundColor3 = Library.Theme.cardBg
                    dropOverlay.BorderSizePixel = 0
                    dropOverlay.ScrollBarThickness = (#options > 6) and 3 or 0
                    dropOverlay.ScrollBarImageColor3 = Library.Theme.borderBright
                    dropOverlay.CanvasSize = UDim2.new(0, 0, 0, #options * 26 + 6)
                    dropOverlay.ZIndex = 200
                    dropOverlay.Parent = ScreenGui

                    local doc = Instance.new("UICorner")
                    doc.CornerRadius = UDim.new(0, 6)
                    doc.Parent = dropOverlay

                    CreateStroke(dropOverlay, Library.Theme.borderBright, 1, 0)

                    local dLayout = Instance.new("UIListLayout")
                    dLayout.SortOrder = Enum.SortOrder.LayoutOrder
                    dLayout.Padding = UDim.new(0, 2)
                    dLayout.Parent = dropOverlay

                    local dPad = Instance.new("UIPadding")
                    dPad.PaddingTop = UDim.new(0, 4)
                    dPad.PaddingBottom = UDim.new(0, 4)
                    dPad.PaddingLeft = UDim.new(0, 4)
                    dPad.PaddingRight = UDim.new(0, 4)
                    dPad.Parent = dropOverlay

                    for i, opt in ipairs(options) do
                        local optBtn = Instance.new("TextButton")
                        optBtn.Size = UDim2.new(1, 0, 0, 24)
                        optBtn.BackgroundColor3 = (i - 1 == currentIdx) and Library.Theme.inputBg or Color3.fromRGB(0, 0, 0)
                        optBtn.BackgroundTransparency = (i - 1 == currentIdx) and 0 or 1
                        optBtn.BorderSizePixel = 0
                        optBtn.Font = Library.Theme.fontBold
                        optBtn.TextSize = 11
                        optBtn.TextColor3 = (i - 1 == currentIdx) and Library.Theme.accent or Library.Theme.text
                        optBtn.TextXAlignment = Enum.TextXAlignment.Left
                        optBtn.Text = "  " .. tostring(opt)
                        optBtn.ZIndex = 201
                        optBtn.Parent = dropOverlay

                        local oc = Instance.new("UICorner")
                        oc.CornerRadius = UDim.new(0, 4)
                        oc.Parent = optBtn

                        optBtn.MouseEnter:Connect(function()
                            if i - 1 ~= currentIdx then
                                Tween(optBtn, { BackgroundColor3 = Color3.fromRGB(25, 25, 36), BackgroundTransparency = 0.5 }, 0.1)
                            end
                        end)
                        optBtn.MouseLeave:Connect(function()
                            if i - 1 ~= currentIdx then
                                Tween(optBtn, { BackgroundTransparency = 1 }, 0.1)
                            end
                        end)

                        optBtn.MouseButton1Click:Connect(function()
                            currentIdx = i - 1
                            comboBtn.Text = "   " .. tostring(opt)
                            Library:CloseDropdown()
                            pcall(callback, currentIdx, opt)
                        end)
                    end

                    Library.ActiveDropdownCloseFn = destroyOverlay
                end)

                return {
                    Set = function(val)
                        if typeof(val) == "number" then
                            local idx = val
                            if idx >= 1 and idx <= #options and not options[idx + 1] and idx == #options then
                                idx = idx - 1
                            end
                            currentIdx = math.clamp(idx, 0, math.max(0, #options - 1))
                            comboBtn.Text = "   " .. tostring(options[currentIdx + 1] or "")
                            pcall(callback, currentIdx, options[currentIdx + 1])
                        elseif typeof(val) == "string" then
                            for i, opt in ipairs(options) do
                                if opt == val then
                                    currentIdx = i - 1
                                    comboBtn.Text = "   " .. tostring(opt)
                                    pcall(callback, currentIdx, opt)
                                    break
                                end
                            end
                        end
                    end,
                    Refresh = function(newOptions, newDefault)
                        options = newOptions or options
                        currentIdx = 0
                        if newDefault then
                            if typeof(newDefault) == "number" then
                                currentIdx = newDefault
                            elseif typeof(newDefault) == "string" then
                                for i, opt in ipairs(options) do
                                    if opt == newDefault then currentIdx = i - 1 break end
                                end
                            end
                        end
                        comboBtn.Text = "   " .. tostring(options[currentIdx + 1] or options[1] or "")
                    end,
                    Get = function() return currentIdx, options[currentIdx + 1] end
                }
            end

            function CardObj:CreateKeybind(kConfig)
                kConfig = kConfig or {}
                local name = kConfig.Name or "Keybind"
                local currentKey = kConfig.Default or Enum.KeyCode.E
                if typeof(currentKey) == "string" and Enum.KeyCode[currentKey] then
                    currentKey = Enum.KeyCode[currentKey]
                end
                local callback = kConfig.Callback or function() end

                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 24)
                row.BackgroundTransparency = 1
                row.LayoutOrder = #card:GetChildren() + 1
                row.ZIndex = 4
                row.Parent = card

                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(0.65, 0, 1, 0)
                lbl.BackgroundTransparency = 1
                lbl.Font = Library.Theme.fontBold
                lbl.TextSize = 11
                lbl.TextColor3 = Library.Theme.textMuted
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.Text = name
                lbl.ZIndex = 4
                lbl.Parent = row

                local keyBtn = Instance.new("TextButton")
                keyBtn.Size = UDim2.new(0, 70, 0, 20)
                keyBtn.Position = UDim2.new(1, -70, 0.5, -10)
                keyBtn.BackgroundColor3 = Library.Theme.inputBg
                keyBtn.BorderSizePixel = 0
                keyBtn.Font = Library.Theme.fontBold
                keyBtn.TextSize = 10
                keyBtn.TextColor3 = Library.Theme.accent
                keyBtn.Text = "[" .. (currentKey and currentKey.Name or "None") .. "]"
                keyBtn.ZIndex = 5
                keyBtn.Parent = row

                local kbc = Instance.new("UICorner")
                kbc.CornerRadius = UDim.new(0, 4)
                kbc.Parent = keyBtn
                local ks = CreateStroke(keyBtn, Library.Theme.border, 1, 0)

                local listening = false
                keyBtn.MouseButton1Click:Connect(function()
                    if listening then return end
                    listening = true
                    keyBtn.Text = "[...]"
                    Tween(ks, { Color = Library.Theme.accent }, 0.12)

                    local conn
                    conn = UserInputService.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            currentKey = input.KeyCode
                            keyBtn.Text = "[" .. currentKey.Name .. "]"
                            listening = false
                            Tween(ks, { Color = Library.Theme.border }, 0.12)
                            conn:Disconnect()
                            pcall(callback, currentKey)
                        end
                    end)
                end)

                return {
                    Set = function(k)
                        if typeof(k) == "string" and Enum.KeyCode[k] then k = Enum.KeyCode[k] end
                        currentKey = k
                        keyBtn.Text = "[" .. (currentKey and currentKey.Name or "None") .. "]"
                    end,
                    Get = function() return currentKey end
                }
            end

            function CardObj:CreateColorPicker(cConfig)
                cConfig = cConfig or {}
                local name = cConfig.Name or "Color Picker"
                local currentColor = ParseColor(cConfig.Default or Library.Theme.accent)
                local callback = cConfig.Callback or function() end

                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 24)
                row.BackgroundTransparency = 1
                row.LayoutOrder = #card:GetChildren() + 1
                row.ZIndex = 4
                row.Parent = card

                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(0.75, 0, 1, 0)
                lbl.BackgroundTransparency = 1
                lbl.Font = Library.Theme.fontBold
                lbl.TextSize = 11
                lbl.TextColor3 = Library.Theme.textMuted
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.Text = name
                lbl.ZIndex = 4
                lbl.Parent = row

                local cBtn = Instance.new("TextButton")
                cBtn.Size = UDim2.new(0, 32, 0, 18)
                cBtn.Position = UDim2.new(1, -32, 0.5, -9)
                cBtn.BackgroundColor3 = currentColor
                cBtn.BorderSizePixel = 0
                cBtn.Text = ""
                cBtn.ZIndex = 5
                cBtn.Parent = row

                local cbc = Instance.new("UICorner")
                cbc.CornerRadius = UDim.new(0, 4)
                cbc.Parent = cBtn
                CreateStroke(cBtn, Library.Theme.borderBright, 1, 0)

                local presets = {
                    Color3.fromRGB(244, 166, 205),
                    Color3.fromRGB(96, 165, 250),
                    Color3.fromRGB(52, 211, 153),
                    Color3.fromRGB(251, 191, 36),
                    Color3.fromRGB(248, 113, 113),
                    Color3.fromRGB(192, 132, 252),
                    Color3.fromRGB(255, 255, 255),
                }
                local pIdx = 1

                cBtn.MouseButton1Click:Connect(function()
                    pIdx = (pIdx % #presets) + 1
                    currentColor = presets[pIdx]
                    Tween(cBtn, { BackgroundColor3 = currentColor }, 0.15)
                    pcall(callback, currentColor)
                end)

                return {
                    Set = function(c)
                        currentColor = ParseColor(c)
                        cBtn.BackgroundColor3 = currentColor
                        pcall(callback, currentColor)
                    end,
                    Get = function() return currentColor end
                }
            end

            function CardObj:CreateButton(bConfig)
                bConfig = bConfig or {}
                local name = bConfig.Name or "Button"
                local isAccent = bConfig.Accent or false
                local callback = bConfig.Callback or function() end

                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 28)
                btn.BackgroundColor3 = isAccent and Library.Theme.accent or Library.Theme.inputBg
                btn.BorderSizePixel = 0
                btn.Font = Library.Theme.fontBold
                btn.TextSize = 11
                btn.TextColor3 = isAccent and Color3.fromRGB(16, 16, 24) or Library.Theme.text
                btn.Text = name
                btn.LayoutOrder = #card:GetChildren() + 1
                btn.ZIndex = 4
                btn.Parent = card

                local bbc = Instance.new("UICorner")
                bbc.CornerRadius = UDim.new(0, 6)
                bbc.Parent = btn

                if not isAccent then
                    CreateStroke(btn, Library.Theme.border, 1, 0)
                end

                btn.MouseEnter:Connect(function()
                    Tween(btn, { BackgroundColor3 = isAccent and Library.Theme.accentBright or Color3.fromRGB(26, 26, 38) }, 0.12)
                end)
                btn.MouseLeave:Connect(function()
                    Tween(btn, { BackgroundColor3 = isAccent and Library.Theme.accent or Library.Theme.inputBg }, 0.12)
                end)

                btn.MouseButton1Click:Connect(function()
                    pcall(callback)
                end)

                return {
                    SetText = function(t) btn.Text = tostring(t or "") end,
                    SetCallback = function(fn) callback = fn end,
                    Instance = btn
                }
            end

            function CardObj:CreateTextInput(iConfig)
                iConfig = iConfig or {}
                local name = iConfig.Name or "Input"
                local defaultVal = iConfig.Default or ""
                local placeholder = iConfig.Placeholder or "Enter value..."
                local callback = iConfig.Callback or function() end

                local container = Instance.new("Frame")
                container.Size = UDim2.new(1, 0, 0, 48)
                container.BackgroundTransparency = 1
                container.LayoutOrder = #card:GetChildren() + 1
                container.ZIndex = 4
                container.Parent = card

                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1, 0, 0, 14)
                lbl.BackgroundTransparency = 1
                lbl.Font = Library.Theme.fontBold
                lbl.TextSize = 11
                lbl.TextColor3 = Library.Theme.textMuted
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.Text = name
                lbl.ZIndex = 4
                lbl.Parent = container

                local box = Instance.new("TextBox")
                box.Size = UDim2.new(1, 0, 0, 28)
                box.Position = UDim2.new(0, 0, 0, 18)
                box.BackgroundColor3 = Library.Theme.inputBg
                box.BorderSizePixel = 0
                box.Font = Library.Theme.font
                box.TextSize = 11
                box.TextColor3 = Library.Theme.text
                box.TextXAlignment = Enum.TextXAlignment.Left
                box.PlaceholderText = placeholder
                box.PlaceholderColor3 = Library.Theme.textMuted
                box.Text = tostring(defaultVal or "")
                box.ClearTextOnFocus = false
                box.ZIndex = 5
                box.Parent = container

                local tbp = Instance.new("UIPadding")
                tbp.PaddingLeft = UDim.new(0, 10)
                tbp.PaddingRight = UDim.new(0, 10)
                tbp.Parent = box

                local tbc = Instance.new("UICorner")
                tbc.CornerRadius = UDim.new(0, 6)
                tbc.Parent = box
                local stroke = CreateStroke(box, Library.Theme.border, 1, 0)

                box.Focused:Connect(function()
                    Tween(stroke, { Color = Library.Theme.accent }, 0.12)
                end)
                box.FocusLost:Connect(function(enterPressed)
                    Tween(stroke, { Color = Library.Theme.border }, 0.12)
                    pcall(callback, box.Text, enterPressed)
                end)

                return {
                    Set = function(t) box.Text = tostring(t or "") end,
                    Get = function() return box.Text end
                }
            end

            return CardObj
        end

        return TabObj
    end

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == ToggleKey then
            WindowObj:Toggle()
        end
    end)

    return WindowObj
end

function Library:CreateWatermark(wConfig)
    wConfig = wConfig or {}
    local Title = wConfig.Title or "unagitatedly"

    local parentGui = Library.ScreenGui or ScreenParent:FindFirstChildOfClass("ScreenGui")
    if not parentGui then
        parentGui = Instance.new("ScreenGui")
        parentGui.Name = HttpService:GenerateGUID(false)
        parentGui.ResetOnSpawn = false
        parentGui.IgnoreGuiInset = true
        parentGui.DisplayOrder = 9999
        parentGui.Parent = ScreenParent
        Library.ScreenGui = parentGui
    end

    local Watermark = Instance.new("Frame")
    Watermark.Name = "Watermark"
    Watermark.Size = UDim2.new(0, 240, 0, 24)
    Watermark.Position = UDim2.new(1, -255, 0, 15)
    Watermark.BackgroundColor3 = Library.Theme.windowBg
    Watermark.BorderSizePixel = 0
    Watermark.Active = true
    Watermark.ZIndex = 10
    Watermark.Parent = parentGui

    local wmc = Instance.new("UICorner")
    wmc.CornerRadius = UDim.new(0, 6)
    wmc.Parent = Watermark
    CreateStroke(Watermark, Library.Theme.border, 1, 0)

    local isDragging, dragStart, startPos = false, nil, nil
    Watermark.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPos = Watermark.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then isDragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Watermark.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local wmLabel = Instance.new("TextLabel")
    wmLabel.Size = UDim2.new(1, -12, 1, 0)
    wmLabel.Position = UDim2.new(0, 6, 0, 0)
    wmLabel.BackgroundTransparency = 1
    wmLabel.Font = Library.Theme.fontBold
    wmLabel.TextSize = 10
    wmLabel.TextColor3 = Library.Theme.text
    wmLabel.TextXAlignment = Enum.TextXAlignment.Left
    wmLabel.RichText = true
    wmLabel.ZIndex = 11
    wmLabel.Parent = Watermark

    local currentTitle = Title
    local FrameCount, LastTick, Fps = 0, tick(), 60
    RunService.RenderStepped:Connect(function()
        FrameCount = FrameCount + 1
        if tick() - LastTick >= 0.5 then
            Fps = math.floor(FrameCount / (tick() - LastTick))
            FrameCount, LastTick = 0, tick()
        end
        local ping = 35
        pcall(function() ping = math.floor(LocalPlayer:GetNetworkPing() * 1000) end)
        wmLabel.Text = string.format("<font color='#f4a6cd'>%s</font> | %d FPS | %d ms", currentTitle, Fps, ping)
    end)

    return {
        SetTitle = function(t) currentTitle = tostring(t or "") end,
        SetVisible = function(v) Watermark.Visible = not not v end,
        Frame = Watermark
    }
end

function Library:CreateKeybindHUD(hConfig)
    hConfig = hConfig or {}
    local Title = hConfig.Title or "Active Modules"

    local parentGui = Library.ScreenGui or ScreenParent:FindFirstChildOfClass("ScreenGui")
    if not parentGui then
        parentGui = Instance.new("ScreenGui")
        parentGui.Name = HttpService:GenerateGUID(false)
        parentGui.ResetOnSpawn = false
        parentGui.IgnoreGuiInset = true
        parentGui.DisplayOrder = 9999
        parentGui.Parent = ScreenParent
        Library.ScreenGui = parentGui
    end

    local KeybindHud = Instance.new("Frame")
    KeybindHud.Name = "KeybindHUD"
    KeybindHud.Size = UDim2.new(0, 175, 0, 180)
    KeybindHud.Position = UDim2.new(0, 20, 0.5, -90)
    KeybindHud.BackgroundColor3 = Library.Theme.windowBg
    KeybindHud.BorderSizePixel = 0
    KeybindHud.Active = true
    KeybindHud.ZIndex = 10
    KeybindHud.Parent = parentGui

    local khc = Instance.new("UICorner")
    khc.CornerRadius = UDim.new(0, 10)
    khc.Parent = KeybindHud
    CreateStroke(KeybindHud, Library.Theme.border, 1, 0)

    local khTitleBar = Instance.new("Frame")
    khTitleBar.Size = UDim2.new(1, 0, 0, 26)
    khTitleBar.BackgroundTransparency = 1
    khTitleBar.ZIndex = 11
    khTitleBar.Parent = KeybindHud

    local isDragging, dragStart, startPos = false, nil, nil
    khTitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPos = KeybindHud.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then isDragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            KeybindHud.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local khTitle = Instance.new("TextLabel")
    khTitle.Size = UDim2.new(1, -20, 1, 0)
    khTitle.Position = UDim2.new(0, 10, 0, 0)
    khTitle.BackgroundTransparency = 1
    khTitle.Font = Library.Theme.fontBold
    khTitle.TextSize = 11
    khTitle.TextColor3 = Library.Theme.accent
    khTitle.TextXAlignment = Enum.TextXAlignment.Left
    khTitle.Text = Title
    khTitle.ZIndex = 11
    khTitle.Parent = khTitleBar

    local khList = Instance.new("Frame")
    khList.Size = UDim2.new(1, -20, 1, -32)
    khList.Position = UDim2.new(0, 10, 0, 28)
    khList.BackgroundTransparency = 1
    khList.ZIndex = 11
    khList.Parent = KeybindHud

    local khLayout = Instance.new("UIListLayout")
    khLayout.SortOrder = Enum.SortOrder.LayoutOrder
    khLayout.Padding = UDim.new(0, 3)
    khLayout.Parent = khList

    local TrackedModules = {}

    local HudObj = { Frame = KeybindHud }

    function HudObj:SetTitle(newTitle)
        khTitle.Text = tostring(newTitle or "")
    end

    function HudObj:SetVisible(v)
        KeybindHud.Visible = not not v
    end

    function HudObj:Register(name, getterFn)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 16)
        row.BackgroundTransparency = 1
        row.LayoutOrder = #khList:GetChildren() + 1
        row.ZIndex = 11
        row.Parent = khList

        local nLbl = Instance.new("TextLabel")
        nLbl.Size = UDim2.new(0.65, 0, 1, 0)
        nLbl.BackgroundTransparency = 1
        nLbl.Font = Library.Theme.font
        nLbl.TextSize = 10
        nLbl.TextColor3 = Library.Theme.text
        nLbl.TextXAlignment = Enum.TextXAlignment.Left
        nLbl.Text = name
        nLbl.ZIndex = 11
        nLbl.Parent = row

        local sLbl = Instance.new("TextLabel")
        sLbl.Size = UDim2.new(0.35, 0, 1, 0)
        sLbl.Position = UDim2.new(0.65, 0, 0, 0)
        sLbl.BackgroundTransparency = 1
        sLbl.Font = Library.Theme.fontBold
        sLbl.TextSize = 10
        sLbl.TextColor3 = Library.Theme.textMuted
        sLbl.TextXAlignment = Enum.TextXAlignment.Right
        sLbl.Text = "[OFF]"
        sLbl.ZIndex = 11
        sLbl.Parent = row

        table.insert(TrackedModules, { Label = sLbl, Getter = getterFn })
    end

    RunService.RenderStepped:Connect(function()
        for _, item in ipairs(TrackedModules) do
            local success, state = pcall(item.Getter)
            if success and state then
                item.Label.Text = "<font color='#22c55e'>[ON]</font>"
            else
                item.Label.Text = "<font color='#73738a'>[OFF]</font>"
            end
            item.Label.RichText = true
        end
    end)

    return HudObj
end

return Library
