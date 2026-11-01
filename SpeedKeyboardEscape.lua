-- ============================================================
-- BRINELAND HUB: +1 SPEED KEYBOARD ESCAPE (PRODUCTION VERSION)
-- Repository: https://github.com/DCBHEROBRINE/BRINELAND-HUB.git
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

--------------------------------------------------------------------------------
-- 1. CONNECTION & LIFECYCLE MANAGER
--------------------------------------------------------------------------------
local ConnectionManager = {
    Connections = {},
    Add = function(self, conn)
        table.insert(self.Connections, conn)
        return conn
    end,
    Clean = function(self)
        for _, conn in ipairs(self.Connections) do
            if conn and conn.Connected then
                conn:Disconnect()
            end
        end
        self.Connections = {}
    end
}

ConnectionManager:Add(LocalPlayer.AncestryChanged:Connect(function(_, parent)
    if not parent then ConnectionManager:Clean() end
end))

--------------------------------------------------------------------------------
-- 2. GLOBAL STATE & TRACKING
--------------------------------------------------------------------------------
local AutoWinEnabled = false
local AutoFarmEnabled = false
local AutoTreadmillEnabled = false
local AutoRebirth = false
local AirWalkEnabled = false
local AutoEscapeEnabled = false
local AirWalkPart = nil

local TargetWinsLimit = 100
local CurrentWinsFarmed = 0
local FarmDelay = 2.0

local SelectedWinPadInstance = nil
local WinPadMap = {}
local LiveCollectables = {}
local LivePrompts = {}

local originalWalkSpeed = 16
local originalCollisions = setmetatable({}, {__mode = "k"})
local originalAnchoredStates = setmetatable({}, {__mode = "k"})

local function RegisterItem(obj)
    if not obj or not obj:IsA("BasePart") then return end
    local name = obj.Name:lower()
    if name:match("collect") or name:match("coin") or name:match("gem") or name:match("reward") or name:match("pickup") or name:match("drop") then
        LiveCollectables[obj] = true
    end
end

for _, obj in ipairs(Workspace:GetDescendants()) do
    RegisterItem(obj)
    if obj:IsA("ProximityPrompt") or obj:IsA("ClickDetector") then
        LivePrompts[obj] = true
    end
end

ConnectionManager:Add(Workspace.DescendantAdded:Connect(function(obj)
    RegisterItem(obj)
    if obj:IsA("ProximityPrompt") or obj:IsA("ClickDetector") then
        LivePrompts[obj] = true
    end
end))

ConnectionManager:Add(Workspace.DescendantRemoving:Connect(function(obj)
    LiveCollectables[obj] = nil
    LivePrompts[obj] = nil
end))

local CachedTreadmill = nil
local LastTreadmillSearch = 0
local function FindTreadmill()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    if CachedTreadmill and CachedTreadmill.Parent and CachedTreadmill:IsDescendantOf(Workspace) then
        if (root.Position - CachedTreadmill.Position).Magnitude <= 200 then
            return CachedTreadmill
        end
    end

    if tick() - LastTreadmillSearch < 1.0 then return nil end
    LastTreadmillSearch = tick()

    CachedTreadmill = nil
    local closest, shortest = nil, 200

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name == "treadmill" or name:match("treadmill") or name:match("gympart") or name:match("runningmachine") then
                if obj:FindFirstChild("TouchInterest") or obj:FindFirstChildOfClass("ProximityPrompt") or obj.CanTouch then
                    local dist = (root.Position - obj.Position).Magnitude
                    if dist < shortest then
                        shortest = dist
                        closest = obj
                    end
                end
            end
        end
    end

    if closest then CachedTreadmill = closest end
    return closest
end

local function ScanForWinPads()
    WinPadMap = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name:match("win") or name:match("finish") or name:match("reward") or name:match("%+%d") or name:match("goal") or name == "end" or name:match("exit") then
                if obj:FindFirstChild("TouchInterest") or obj.CanTouch then
                    local key = string.format("%s [%d, %d]", obj.Name, math.floor(obj.Position.X), math.floor(obj.Position.Z))
                    WinPadMap[key] = obj
                end
            end
        end
    end
end
ScanForWinPads()

--------------------------------------------------------------------------------
-- 3. BACKGROUND WORKERS
--------------------------------------------------------------------------------
task.spawn(function()
    while true do
        task.wait(0.2)
        if AutoWinEnabled and SelectedWinPadInstance and SelectedWinPadInstance.Parent then
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                pcall(function()
                    local targetCFrame = SelectedWinPadInstance.CFrame * CFrame.new(0, 2.5, 0)
                    root.CFrame = targetCFrame
                    CurrentWinsFarmed = CurrentWinsFarmed + 1
                    if CurrentWinsFarmed >= TargetWinsLimit then
                        AutoWinEnabled = false
                    end
                end)
                task.wait(FarmDelay)
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.15)
        if AutoTreadmillEnabled then
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                local treadmill = FindTreadmill()
                if treadmill then
                    root.CFrame = treadmill.CFrame * CFrame.new(0, 3, 0)
                    root.AssemblyLinearVelocity = Vector3.zero
                end
            end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(2.0)
        if AutoRebirth then
            local rEv = ReplicatedStorage:FindFirstChild("Rebirth") or ReplicatedStorage:FindFirstChild("RebirthEvent")
            if rEv and rEv:IsA("RemoteEvent") then pcall(function() rEv:FireServer() end) end
        end
    end
end)

ConnectionManager:Add(RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if AirWalkEnabled then
        if not AirWalkPart then
            AirWalkPart = Instance.new("Part")
            AirWalkPart.Size = Vector3.new(12, 1, 12)
            AirWalkPart.Anchored = true
            AirWalkPart.Transparency = 0.6
            AirWalkPart.Color = Color3.fromRGB(0, 229, 255)
            AirWalkPart.Material = Enum.Material.Glass
            AirWalkPart.Parent = Workspace
        end
        AirWalkPart.CFrame = root.CFrame * CFrame.new(0, -3.5, 0)
    else
        if AirWalkPart then AirWalkPart:Destroy(); AirWalkPart = nil end
    end

    if AutoEscapeEnabled then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end))

--------------------------------------------------------------------------------
-- 4. BRINELAND CUSTOM UI (BLUE & PURPLE MIX)
--------------------------------------------------------------------------------
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild("SpeedKeyboardEscapeHub") then
    PlayerGui.SpeedKeyboardEscapeHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpeedKeyboardEscapeHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.fromOffset(360, 380)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 11, 25)
MainFrame.BackgroundTransparency = 0.18
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local FrameStroke = Instance.new("UIStroke")
FrameStroke.Color = Color3.fromRGB(0, 229, 255)
FrameStroke.Thickness = 1.5
FrameStroke.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(10, 8, 18)
TopBar.BackgroundTransparency = 0.25
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -85, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "<b>BRINELAND</b> <font color=\"#00E5FF\">KEYBOARD ESCAPE</font>"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.RichText = true
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.fromOffset(28, 28)
MinimizeBtn.Position = UDim2.new(1, -64, 0.5, -14)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 40, 80)
MinimizeBtn.Text = "<b>–</b>"
MinimizeBtn.TextColor3 = Color3.fromRGB(0, 229, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 16
MinimizeBtn.RichText = true
MinimizeBtn.Parent = TopBar
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.fromOffset(28, 28)
CloseBtn.Position = UDim2.new(1, -32, 0.5, -14)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 35, 70)
CloseBtn.Text = "<b>X</b>"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.RichText = true
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -12, 1, -48)
Container.Position = UDim2.new(0, 6, 0, 44)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 4
Container.ScrollBarImageColor3 = Color3.fromRGB(0, 229, 255)
Container.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 6)
Layout.Parent = Container

Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Container.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 12)
end)

local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        Container.Visible = false
        TweenService:Create(MainFrame, TweenInfo.new(0.25), {Size = UDim2.fromOffset(360, 40)}):Play()
        MinimizeBtn.Text = "<b>+</b>"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.25), {Size = UDim2.fromOffset(360, 380)}):Play()
        task.wait(0.15)
        Container.Visible = true
        MinimizeBtn.Text = "<b>–</b>"
    end
end)

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

local function CreateToggle(text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(22, 18, 45)
    frame.BackgroundTransparency = 0.25
    frame.Parent = Container
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
    toggleBg.BackgroundColor3 = Color3.fromRGB(40, 35, 65)
    toggleBg.Parent = frame
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(16, 16)
    knob.Position = UDim2.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = toggleBg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = frame

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = active and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
        TweenService:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = active and Color3.fromRGB(0, 229, 255) or Color3.fromRGB(40, 35, 65)}):Play()
        callback(active)
    end)
end

-- UI Controls
CreateToggle("Auto Train on Treadmill", function(state) AutoTreadmillEnabled = state end)
CreateToggle("Auto Win / Escape", function(state)
    AutoWinEnabled = state
    if state and not SelectedWinPadInstance then
        for _, pad in pairs(WinPadMap) do
            SelectedWinPadInstance = pad
            break
        end
    end
end)
CreateToggle("Auto Rebirth", function(state) AutoRebirth = state end)
CreateToggle("Auto Escape (Noclip)", function(state) AutoEscapeEnabled = state end)
CreateToggle("Walk on Air Platform", function(state) AirWalkEnabled = state end)

print("[BRINELAND] SpeedKeyboardEscape loaded cleanly!")
