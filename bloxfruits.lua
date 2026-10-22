-- ============================================================
-- BRINELAND HUB - BLOX FRUITS EDITION
-- Repository: https://github.com/DCBHEROBRINE/BRINELAND-HUB.git
-- Discord: https://discord.gg/epWMbuXSN5
-- ============================================================

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace        = game:GetService("Workspace")
local RunService       = game:GetService("RunService")
local Players          = game:GetService("Players")
local LocalPlayer      = Players.LocalPlayer

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild("BrinelandBloxFruitsHub") then
    PlayerGui.BrinelandBloxFruitsHub:Destroy()
end

local Config = {
    AutoFarmLevel      = false,
    SelectedWeapon     = "Melee",
    AutoBone           = false,
    AutoCakePrince     = false,
    FastAttack         = false,
    AimbotSkill        = false,
    AutoBounty         = false,
    AutoRaid           = false,
    AutoChest          = false,
    EnableSpeed        = false,
    PlayerSpeed        = 24,
    TweenSpeed         = 300
}

local function BindClick(button, callback)
    button.Active = true
    local lastClick = 0
    local function trigger()
        local now = tick()
        if now - lastClick > 0.08 then
            lastClick = now
            callback()
        end
    end
    button.MouseButton1Click:Connect(trigger)
    button.Activated:Connect(trigger)
end

-- Core Loop Mechanics (Speed Boost & Fast Attack placeholders)
RunService.Stepped:Connect(function()
    if Config.EnableSpeed then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = Config.PlayerSpeed end
    end
end)

-- ============================================================
-- UI SETUP & WINDOW CREATION
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrinelandBloxFruitsHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local OpenToggleBtn = Instance.new("TextButton")
OpenToggleBtn.Size = UDim2.fromOffset(50, 50)
OpenToggleBtn.Position = UDim2.new(0, 15, 0.5, -25)
OpenToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 240)
OpenToggleBtn.Text = "<b>BF</b>"
OpenToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenToggleBtn.Font = Enum.Font.GothamBold
OpenToggleBtn.TextSize = 13
OpenToggleBtn.RichText = true
OpenToggleBtn.Active = true
OpenToggleBtn.Parent = ScreenGui
Instance.new("UICorner", OpenToggleBtn).CornerRadius = UDim.new(1, 0)

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
ToggleStroke.Thickness = 2
ToggleStroke.Parent = OpenToggleBtn

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.fromOffset(360, 430)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -215)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 12, 26)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local FrameStroke = Instance.new("UIStroke")
FrameStroke.Color = Color3.fromRGB(0, 210, 255)
FrameStroke.Thickness = 2
FrameStroke.Parent = MainFrame

local isGuiOpen = true
local function SetGuiState(state)
    isGuiOpen = state
    if isGuiOpen then
        MainFrame.Visible = true
        MainFrame:TweenSizeAndPosition(UDim2.fromOffset(360, 430), UDim2.new(0.5, -180, 0.5, -215), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.3, true)
    else
        MainFrame:TweenSizeAndPosition(UDim2.fromOffset(0, 0), UDim2.new(0.5, 0, 0.5, 0), Enum.EasingDirection.In, Enum.EasingStyle.Back, 0.25, true, function()
            if not isGuiOpen then MainFrame.Visible = false end
        end)
    end
end

BindClick(OpenToggleBtn, function() SetGuiState(not isGuiOpen) end)

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(10, 8, 18)
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "<b>BRINELAND</b> <font color=\"#00E5FF\">BLOX FRUITS</font>"
Title.TextColor3 = Color3.fromRGB(0, 225, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.RichText = true
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.fromOffset(26, 26)
CloseBtn.Position = UDim2.new(1, -32, 0.5, -13)
CloseBtn.BackgroundColor3 = Color3.fromRGB(225, 35, 75)
CloseBtn.Text = "<b>X</b>"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.RichText = true
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

BindClick(CloseBtn, function() SetGuiState(false) end)

local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -12, 0, 32)
TabBar.Position = UDim2.new(0, 6, 0, 44)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 4)
TabLayout.Parent = TabBar

local TabFrames = {}
local function CreateTab(tabName)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0.24, 0, 1, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(24, 18, 42)
    tabBtn.Text = "<b>" .. tabName .. "</b>"
    tabBtn.TextColor3 = Color3.fromRGB(180, 180, 210)
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 10
    tabBtn.RichText = true
    tabBtn.Parent = TabBar
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, -12, 1, -86)
    container.Position = UDim2.new(0, 6, 0, 80)
    container.BackgroundTransparency = 1
    container.ScrollBarThickness = 3
    container.ScrollBarImageColor3 = Color3.fromRGB(0, 210, 255)
    container.Visible = false
    container.Parent = MainFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 6)
    listLayout.Parent = container

    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        container.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 12)
    end)

    TabFrames[tabName] = { Button = tabBtn, Container = container }

    BindClick(tabBtn, function()
        for _, data in pairs(TabFrames) do
            data.Container.Visible = false
            data.Button.BackgroundColor3 = Color3.fromRGB(24, 18, 42)
            data.Button.TextColor3 = Color3.fromRGB(180, 180, 210)
        end
        container.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 240)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    return container
end

local FarmTab  = CreateTab("Farm")
local CombatTab = CreateTab("Combat")
local SeaTab   = CreateTab("Sea Events")
local PlayerTab = CreateTab("Player")

TabFrames["Farm"].Container.Visible = true
TabFrames["Farm"].Button.BackgroundColor3 = Color3.fromRGB(0, 160, 240)
TabFrames["Farm"].Button.TextColor3 = Color3.fromRGB(255, 255, 255)

-- Draggable Window functionality
local dragging, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function() dragging = false end)

-- UI Element Builders
local function CreateToggle(parent, text, configKey)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 38)
    frame.BackgroundColor3 = Color3.fromRGB(22, 18, 38)
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -55, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "<b>" .. text .. "</b>"
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.RichText = true
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.fromOffset(40, 20)
    toggleBg.Position = UDim2.new(1, -46, 0.5, -10)
    toggleBg.BackgroundColor3 = Config[configKey] and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(45, 35, 65)
    toggleBg.Parent = frame
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(16, 16)
    knob.Position = Config[configKey] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = toggleBg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = frame

    BindClick(btn, function()
        Config[configKey] = not Config[configKey]
        local state = Config[configKey]
        TweenService:Create(knob, TweenInfo.new(0.18), {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
        TweenService:Create(toggleBg, TweenInfo.new(0.18), {BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(45, 35, 65)}):Play()
    end)
end

local function CreateSelector(parent, text, options, configKey)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 38)
    frame.BackgroundColor3 = Color3.fromRGB(22, 18, 38)
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.5, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "<b>" .. text .. "</b>"
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.RichText = true
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(100, 24)
    btn.Position = UDim2.new(1, -106, 0.5, -12)
    btn.BackgroundColor3 = Color3.fromRGB(35, 28, 58)
    btn.Text = "<b>" .. tostring(Config[configKey]) .. "</b>"
    btn.TextColor3 = Color3.fromRGB(0, 225, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.RichText = true
    btn.Parent = frame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    BindClick(btn, function()
        local currentVal = Config[configKey]
        local idx = 1
        for i, option in ipairs(options) do
            if option == currentVal then idx = i break end
        end
        idx = (idx % #options) + 1
        Config[configKey] = options[idx]
        btn.Text = "<b>" .. tostring(options[idx]) .. "</b>"
    end)
end

local function CreateInput(parent, text, configKey)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 38)
    frame.BackgroundColor3 = Color3.fromRGB(22, 18, 38)
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.65, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "<b>" .. text .. "</b>"
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.RichText = true
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.fromOffset(60, 24)
    textBox.Position = UDim2.new(1, -66, 0.5, -12)
    textBox.BackgroundColor3 = Color3.fromRGB(35, 28, 58)
    textBox.Text = tostring(Config[configKey])
    textBox.TextColor3 = Color3.fromRGB(0, 225, 255)
    textBox.Font = Enum.Font.GothamBold
    textBox.TextSize = 11
    textBox.Parent = frame
    Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 6)

    textBox.FocusLost:Connect(function()
        local val = tonumber(textBox.Text)
        if val then Config[configKey] = val end
    end)
end

-- Populate Tabs
CreateToggle(FarmTab, "Auto Farm Level", "AutoFarmLevel")
CreateSelector(FarmTab, "Select Weapon", {"Melee", "Sword", "Blox Fruit"}, "SelectedWeapon")
CreateToggle(FarmTab, "Auto Bone Farm", "AutoBone")
CreateToggle(FarmTab, "Auto Cake Prince", "AutoCakePrince")

CreateToggle(CombatTab, "Fast Attack (M1)", "FastAttack")
CreateToggle(CombatTab, "Aimbot Skill", "AimbotSkill")
CreateToggle(CombatTab, "Auto Bounty / Kill Players", "AutoBounty")

CreateToggle(SeaTab, "Auto Sea Events / Terror Shark", "AutoRaid")
CreateToggle(SeaTab, "Auto Chest / Materials", "AutoChest")

CreateToggle(PlayerTab, "Enable Speed Boost", "EnableSpeed")
CreateInput(PlayerTab, "Player WalkSpeed", "PlayerSpeed")
CreateInput(PlayerTab, "Tween Speed Value", "TweenSpeed")

print("[BRINELAND] Blox Fruits Hub Loaded Successfully!")
