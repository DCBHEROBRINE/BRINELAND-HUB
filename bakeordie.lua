-- ============================================================
-- BRINELAND BAKE OR DIE HUB (`bakeordie.lua`)
-- Repository: https://github.com/DCBHEROBRINE/BRINELAND-HUB.git
-- Discord: https://discord.gg/epWMbuXSN5
-- ============================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

if PlayerGui:FindFirstChild("BakeOrDieHub") then
    PlayerGui.BakeOrDieHub:Destroy()
end

local Config = {
    AutoBake = false,
    AutoCollect = false,
    AutoUpgrade = false,
    SpeedEnabled = false,
    WalkSpeed = 16,
    Noclip = false
}

-- Safe Click / Touch helper
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

-- Core automation loops
task.spawn(function()
    while task.wait(0.2) do
        if Config.AutoBake then
            pcall(function()
                -- Add auto-bake / interacting logic here according to game remotes/prompts
                for _, prompt in ipairs(Workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") and (prompt.ObjectText:lower():find("bake") or prompt.ActionText:lower():find("bake")) then
                        prompt.HoldDuration = 0
                        fireproximityprompt(prompt)
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.25) do
        if Config.AutoCollect then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and (obj.Name:lower():find("coin") or obj.Name:lower():find("money") or obj.Name:lower():find("cash") or obj.Name:lower():find("bread")) then
                            if (obj.Position - hrp.Position).Magnitude < 40 then
                                firetouchinterest(hrp, obj, 0)
                                task.wait(0.01)
                                firetouchinterest(hrp, obj, 1)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

RunService.Stepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        if Config.SpeedEnabled then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = Config.WalkSpeed end
        end
        if Config.Noclip then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
            end
        end
    end)
end)

-- UI Construction
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BakeOrDieHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local OpenToggleBtn = Instance.new("TextButton")
OpenToggleBtn.Size = UDim2.fromOffset(50, 50)
OpenToggleBtn.Position = UDim2.new(0, 15, 0.5, -25)
OpenToggleBtn.BackgroundColor3 = Color3.fromRGB(220, 100, 30)
OpenToggleBtn.BackgroundTransparency = 0.15
OpenToggleBtn.Text = "<b>BAKE</b>"
OpenToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenToggleBtn.Font = Enum.Font.GothamBold
OpenToggleBtn.TextSize = 11
OpenToggleBtn.RichText = true
OpenToggleBtn.Active = true
OpenToggleBtn.Parent = ScreenGui
Instance.new("UICorner", OpenToggleBtn).CornerRadius = UDim.new(1, 0)

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
ToggleStroke.Thickness = 2
ToggleStroke.Parent = OpenToggleBtn

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.fromOffset(360, 420)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 12, 26)
MainFrame.BackgroundTransparency = 0.18
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local FrameStroke = Instance.new("UIStroke")
FrameStroke.Color = Color3.fromRGB(255, 140, 0)
FrameStroke.Thickness = 2
FrameStroke.Parent = MainFrame

local isGuiOpen = true
local function SetGuiState(state)
    isGuiOpen = state
    if isGuiOpen then
        MainFrame.Visible = true
        MainFrame:TweenSizeAndPosition(UDim2.fromOffset(360, 420), UDim2.new(0.5, -180, 0.5, -210), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.3, true)
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
TopBar.BackgroundTransparency = 0.25
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "<b>BRINELAND</b> <font color=\"#FF8C00\">BAKE OR DIE</font>"
Title.TextColor3 = Color3.fromRGB(255, 140, 0)
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
    tabBtn.Size = UDim2.new(0.32, 0, 1, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(24, 18, 42)
    tabBtn.BackgroundTransparency = 0.3
    tabBtn.Text = "<b>" .. tabName .. "</b>"
    tabBtn.TextColor3 = Color3.fromRGB(180, 180, 210)
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 11
    tabBtn.RichText = true
    tabBtn.Parent = TabBar
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

    local container = Instance.new("ScrollingFrame")
    container.Size = UDim2.new(1, -12, 1, -86)
    container.Position = UDim2.new(0, 6, 0, 80)
    container.BackgroundTransparency = 1
    container.ScrollBarThickness = 3
    container.ScrollBarImageColor3 = Color3.fromRGB(255, 140, 0)
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
        tabBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end)

    return container
end

local MainTab   = CreateTab("Main")
local UpgradesTab = CreateTab("Upgrades")
local PlayerTab = CreateTab("Player")

TabFrames["Main"].Container.Visible = true
TabFrames["Main"].Button.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
TabFrames["Main"].Button.TextColor3 = Color3.fromRGB(255, 255, 255)

local function CreateToggle(parent, text, configKey)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 38)
    frame.BackgroundColor3 = Color3.fromRGB(22, 18, 38)
    frame.BackgroundTransparency = 0.25
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
    toggleBg.BackgroundColor3 = Config[configKey] and Color3.fromRGB(255, 140, 0) or Color3.fromRGB(45, 35, 65)
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
        TweenService:Create(toggleBg, TweenInfo.new(0.18), {BackgroundColor3 = state and Color3.fromRGB(255, 140, 0) or Color3.fromRGB(45, 35, 65)}):Play()
    end)
end

CreateToggle(MainTab, "Auto Bake", "AutoBake")
CreateToggle(MainTab, "Auto Collect Items", "AutoCollect")
CreateToggle(UpgradesTab, "Auto Buy Upgrades", "AutoUpgrade")
CreateToggle(PlayerTab, "Enable Speed Boost", "SpeedEnabled")
CreateToggle(PlayerTab, "Noclip", "Noclip")

print("[BRINELAND] bakeordiescript.lua loaded successfully!")
