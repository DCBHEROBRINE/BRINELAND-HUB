-- ============================================================
-- BRINELAND HUB: +1 SPEED KEYBOARD ESCAPE (ULTIMATE REFINED)
-- Repository: https://github.com/DCBHEROBRINE/BRINELAND-HUB.git
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

--------------------------------------------------------------------------------
-- 1. ROBUST CENTRALIZED CONNECTION & LIFECYCLE MANAGER
--------------------------------------------------------------------------------
local ConnectionManager = {
    Connections = {},
    Threads = {},
    Instances = {},
    AddConnection = function(self, conn)
        table.insert(self.Connections, conn)
        return conn
    end,
    AddThread = function(self, thread)
        table.insert(self.Threads, thread)
        return thread
    end,
    AddInstance = function(self, inst)
        table.insert(self.Instances, inst)
        return inst
    end,
    Clean = function(self)
        -- Reset all feature states
        AutoWinEnabled = false
        AutoTreadmillEnabled = false
        AutoRebirth = false
        AirWalkEnabled = false
        AutoEscapeEnabled = false
        AntiAfkEnabled = false
        FreeKeySoundsEnabled = false

        for _, conn in ipairs(self.Connections) do
            if conn and conn.Connected then
                pcall(function() conn:Disconnect() end)
            end
        end
        self.Connections = {}

        for _, thread in ipairs(self.Threads) do
            pcall(function() task.cancel(thread) end)
        end
        self.Threads = {}

        for _, inst in ipairs(self.Instances) do
            if inst and inst.Parent then
                pcall(function() inst:Destroy() end)
            end
        end
        self.Instances = {}
    end
}

--------------------------------------------------------------------------------
-- 2. STATE VARIABLES & CONFIGURATIONS
--------------------------------------------------------------------------------
AutoWinEnabled = false
AutoTreadmillEnabled = false
AutoRebirth = false
AirWalkEnabled = false
AutoEscapeEnabled = false
AntiAfkEnabled = false
FreeKeySoundsEnabled = false

local TargetWinsLimit = 100
local CurrentWinsFarmed = 0
local FarmDelay = 2.0

local SelectedWinPadInstance = nil
local WinPadMap = {}
local AirWalkPart = nil
local originalCollisions = setmetatable({}, {__mode = "k"})

-- Keyboard Sound Engine Assets
local KeySoundIds = {
    Mechanical = "rbxassetid://9114223178",
    Thocky     = "rbxassetid://9114223522",
    Bubble     = "rbxassetid://9114223945",
    Cyber      = "rbxassetid://9114224211"
}
local SelectedSoundProfile = "Mechanical"

--------------------------------------------------------------------------------
-- 3. UTILITIES & SOUND ENGINE
--------------------------------------------------------------------------------
local function EscapeRichText(text)
    return text:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("\"", "&quot;"):gsub("'", "&apos;")
end

local function PlayFreeKeySound()
    if not FreeKeySoundsEnabled then return end
    local soundId = KeySoundIds[SelectedSoundProfile] or KeySoundIds.Mechanical
    
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Volume = 1.2
    sound.Pitch = math.random(95, 105) / 100 -- Adds authentic mechanical click variation
    sound.Parent = SoundService
    sound:Play()

    task.spawn(function()
        sound.Ended:Wait()
        sound:Destroy()
    end)
end

-- Key Press Detector for Free Key Sound Emulation
ConnectionManager:AddConnection(UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.Keyboard then
        PlayFreeKeySound()
    end
end))

local function ScanForWinPads()
    WinPadMap = {}
    local padList = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name:match("win") or name:match("finish") or name:match("reward") or name:match("%+%d") or name:match("goal") or name == "end" or name:match("exit") then
                if obj:FindFirstChild("TouchInterest") or obj.CanTouch then
                    local uniqueKey = string.format("%s [%d, %d] (%s)", obj.Name, math.floor(obj.Position.X), math.floor(obj.Position.Z), tostring(obj))
                    table.insert(padList, uniqueKey)
                    WinPadMap[uniqueKey] = obj
                end
            end
        end
    end
    if #padList == 0 then table.insert(padList, "No win pads detected") end
    return padList
end

local CachedTreadmill = nil
local function FindTreadmill()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end

    if CachedTreadmill and CachedTreadmill.Parent and CachedTreadmill:IsDescendantOf(Workspace) then
        if (root.Position - CachedTreadmill.Position).Magnitude <= 200 then
            return CachedTreadmill
        end
    end

    CachedTreadmill = nil
    local closest, shortest = nil, 200
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local name = obj.Name:lower()
            if name == "treadmill" or name:match("treadmill") or name:match("runningmachine") then
                if obj:FindFirstChild("TouchInterest") or obj.CanTouch then
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

--------------------------------------------------------------------------------
-- 4. CHARACTER LIFECYCLE MANAGEMENT
--------------------------------------------------------------------------------
ConnectionManager:AddConnection(LocalPlayer.CharacterRemoving:Connect(function()
    if AirWalkPart then
        AirWalkPart:Destroy()
        AirWalkPart = nil
    end
    originalCollisions = setmetatable({}, {__mode = "k"})
end))

--------------------------------------------------------------------------------
-- 5. BACKGROUND WORKERS
--------------------------------------------------------------------------------
ConnectionManager:AddThread(task.spawn(function()
    while true do
        task.wait(0.2)
        if AutoWinEnabled and SelectedWinPadInstance and SelectedWinPadInstance.Parent then
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                local success = pcall(function()
                    root.CFrame = SelectedWinPadInstance.CFrame * CFrame.new(0, 2.5, 0)
                end)
                if success then
                    CurrentWinsFarmed = CurrentWinsFarmed + 1
                    if CurrentWinsFarmed >= TargetWinsLimit then
                        AutoWinEnabled = false
                        CurrentWinsFarmed = 0
                    end
                end
                task.wait(FarmDelay)
            end
        end
    end
end))

ConnectionManager:AddThread(task.spawn(function()
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
end))

ConnectionManager:AddThread(task.spawn(function()
    while true do
        task.wait(2.0)
        if AutoRebirth then
            local rEv = ReplicatedStorage:FindFirstChild("Rebirth") or ReplicatedStorage:FindFirstChild("RebirthEvent")
            if rEv and rEv:IsA("RemoteEvent") then pcall(function() rEv:FireServer() end) end
        end
    end
end))

ConnectionManager:AddConnection(RunService.RenderStepped:Connect(function()
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
            ConnectionManager:AddInstance(AirWalkPart)
        end
        AirWalkPart.CFrame = root.CFrame * CFrame.new(0, -3.5, 0)
    else
        if AirWalkPart then
            AirWalkPart:Destroy()
            AirWalkPart = nil
        end
    end

    if AutoEscapeEnabled then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                if originalCollisions[part] == nil then originalCollisions[part] = part.CanCollide end
                part.CanCollide = false
            end
        end
    else
        for part, state in pairs(originalCollisions) do
            if part and part.Parent then part.CanCollide = state end
        end
        originalCollisions = setmetatable({}, {__mode = "k"})
    end
end))

--------------------------------------------------------------------------------
-- 6. BRINELAND CUSTOM UI (BLUE & PURPLE MIX)
--------------------------------------------------------------------------------
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild("SpeedKeyboardEscapeHub") then
    PlayerGui.SpeedKeyboardEscapeHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SpeedKeyboardEscapeHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

ConnectionManager:AddConnection(ScreenGui.AncestryChanged:Connect(function(_, parent)
    if not parent then
        ConnectionManager:Clean()
    end
end))

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.fromOffset(360, 420)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -210)
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

-- Top Bar
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

ConnectionManager:AddConnection(CloseBtn.MouseButton1Click:Connect(function()
    ConnectionManager:Clean()
    ScreenGui:Destroy()
end))

-- Tab System
local TabBar = Instance.new("Frame")
TabBar.Size = UDim2.new(1, -12, 0, 32)
TabBar.Position = UDim2.new(0, 6, 0, 44)
TabBar.BackgroundTransparency = 1
TabBar.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 3)
TabLayout.Parent = TabBar

local TabFrames = {}
local function CreateTab(tabName)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0.24, 0, 1, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(24, 18, 42)
    tabBtn.BackgroundTransparency = 0.3
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
    container.ScrollBarImageColor3 = Color3.fromRGB(0, 229, 255)
    container.Visible = false
    container.Parent = MainFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 6)
    listLayout.Parent = container

    ConnectionManager:AddConnection(listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        container.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 16)
    end))

    TabFrames[tabName] = { Button = tabBtn, Container = container }

    ConnectionManager:AddConnection(tabBtn.MouseButton1Click:Connect(function()
        for _, data in pairs(TabFrames) do
            data.Container.Visible = false
            data.Button.BackgroundColor3 = Color3.fromRGB(24, 18, 42)
            data.Button.TextColor3 = Color3.fromRGB(180, 180, 210)
        end
        container.Visible = true
        tabBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 240)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    end))

    return container
end

local AreaTab   = CreateTab("Area")
local FarmsTab  = CreateTab("Farms")
local PlayerTab = CreateTab("Player")
local MiscTab   = CreateTab("Misc")

TabFrames["Area"].Container.Visible = true
TabFrames["Area"].Button.BackgroundColor3 = Color3.fromRGB(0, 160, 240)
TabFrames["Area"].Button.TextColor3 = Color3.fromRGB(255, 255, 255)

local isMinimized = false
ConnectionManager:AddConnection(MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        for _, data in pairs(TabFrames) do data.Container.Visible = false end
        TabBar.Visible = false
        TweenService:Create(MainFrame, TweenInfo.new(0.25), {Size = UDim2.fromOffset(360, 40)}):Play()
        MinimizeBtn.Text = "<b>+</b>"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.25), {Size = UDim2.fromOffset(360, 420)}):Play()
        task.wait(0.15)
        TabBar.Visible = true
        for _, data in pairs(TabFrames) do
            if data.Button.BackgroundColor3 == Color3.fromRGB(0, 160, 240) then
                data.Container.Visible = true
            end
        end
        MinimizeBtn.Text = "<b>–</b>"
    end
end))

-- Dragging
local dragging, dragStart, startPos
ConnectionManager:AddConnection(TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = MainFrame.Position
    end
end))
ConnectionManager:AddConnection(UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end))
ConnectionManager:AddConnection(UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end))

--------------------------------------------------------------------------------
-- 7. UI COMPONENT BUILDERS
--------------------------------------------------------------------------------
local function CreateToggle(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(22, 18, 45)
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
    ConnectionManager:AddConnection(btn.MouseButton1Click:Connect(function()
        active = not active
        TweenService:Create(knob, TweenInfo.new(0.2), {Position = active and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
        TweenService:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = active and Color3.fromRGB(0, 229, 255) or Color3.fromRGB(40, 35, 65)}):Play()
        callback(active)
    end))
end

local function CreateInput(parent, text, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(22, 18, 45)
    frame.BackgroundTransparency = 0.25
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.6, 0, 1, 0)
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
    textBox.Size = UDim2.fromOffset(70, 24)
    textBox.Position = UDim2.new(1, -78, 0.5, -12)
    textBox.BackgroundColor3 = Color3.fromRGB(35, 28, 65)
    textBox.Text = tostring(defaultVal)
    textBox.TextColor3 = Color3.fromRGB(0, 229, 255)
    textBox.Font = Enum.Font.GothamBold
    textBox.TextSize = 11
    textBox.Parent = frame
    Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 4)

    ConnectionManager:AddConnection(textBox.FocusLost:Connect(function()
        local n = tonumber(textBox.Text)
        if n then callback(n) end
    end))
end

--------------------------------------------------------------------------------
-- 8. POPULATING TABS
--------------------------------------------------------------------------------
-- AREA TAB
local padOptions = ScanForWinPads()
local padSelectorBtn = Instance.new("TextButton")
padSelectorBtn.Size = UDim2.new(1, -4, 0, 38)
padSelectorBtn.BackgroundColor3 = Color3.fromRGB(22, 18, 45)
padSelectorBtn.BackgroundTransparency = 0.25
padSelectorBtn.Text = "<b>Win Pad: <font color=\"#00E5FF\">Select Win Pad</font></b>"
padSelectorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
padSelectorBtn.Font = Enum.Font.GothamBold
padSelectorBtn.TextSize = 11
padSelectorBtn.RichText = true
padSelectorBtn.Parent = AreaTab
Instance.new("UICorner", padSelectorBtn).CornerRadius = UDim.new(0, 6)

local padDropdownContainer = Instance.new("ScrollingFrame")
padDropdownContainer.Size = UDim2.new(1, -4, 0, 120)
padDropdownContainer.BackgroundColor3 = Color3.fromRGB(18, 14, 35)
padDropdownContainer.BackgroundTransparency = 0.2
padDropdownContainer.ScrollBarThickness = 3
padDropdownContainer.Visible = false
padDropdownContainer.Parent = AreaTab
Instance.new("UICorner", padDropdownContainer).CornerRadius = UDim.new(0, 6)

local dropLayout = Instance.new("UIListLayout")
dropLayout.Padding = UDim.new(0, 4)
dropLayout.Parent = padDropdownContainer

ConnectionManager:AddConnection(dropLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    padDropdownContainer.CanvasSize = UDim2.new(0, 0, 0, dropLayout.AbsoluteContentSize.Y + 8)
end))

local function RefreshPadDropdown()
    for _, child in ipairs(padDropdownContainer:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    padOptions = ScanForWinPads()
    for _, key in ipairs(padOptions) do
        local pBtn = Instance.new("TextButton")
        pBtn.Size = UDim2.new(1, -6, 0, 30)
        pBtn.BackgroundColor3 = Color3.fromRGB(35, 28, 65)
        pBtn.Text = "<b>" .. EscapeRichText(key) .. "</b>"
        pBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
        pBtn.Font = Enum.Font.GothamBold
        pBtn.TextSize = 10
        pBtn.RichText = true
        pBtn.Parent = padDropdownContainer
        Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 4)

        ConnectionManager:AddConnection(pBtn.MouseButton1Click:Connect(function()
            SelectedWinPadInstance = WinPadMap[key]
            padSelectorBtn.Text = "<b>Win Pad: <font color=\"#00E5FF\">" .. EscapeRichText(key) .. "</font></b>"
            padDropdownContainer.Visible = false
        end))
    end
end
RefreshPadDropdown()

ConnectionManager:AddConnection(padSelectorBtn.MouseButton1Click:Connect(function()
    padDropdownContainer.Visible = not padDropdownContainer.Visible
    RefreshPadDropdown()
end))

CreateToggle(AreaTab, "Auto Win / Stealth Farm", function(state)
    AutoWinEnabled = state
    if state and not SelectedWinPadInstance then
        for _, pad in pairs(WinPadMap) do
            SelectedWinPadInstance = pad
            break
        end
    end
end)

CreateInput(AreaTab, "Target Wins Limit", TargetWinsLimit, function(val) TargetWinsLimit = val end)
CreateInput(AreaTab, "Farm Delay (Sec)", FarmDelay, function(val) FarmDelay = val end)

-- FARMS TAB
CreateToggle(FarmsTab, "Auto Train on Treadmill", function(state) AutoTreadmillEnabled = state end)
CreateToggle(FarmsTab, "Auto Rebirth", function(state) AutoRebirth = state end)

-- PLAYER TAB
CreateToggle(PlayerTab, "Unlock All Key Sounds (Free)", function(state) FreeKeySoundsEnabled = state end)
CreateToggle(PlayerTab, "Auto Escape (Noclip)", function(state) AutoEscapeEnabled = state end)
CreateToggle(PlayerTab, "Walk on Air Platform", function(state) AirWalkEnabled = state end)

-- MISC TAB
CreateToggle(MiscTab, "Anti-AFK Protection", function(state) AntiAfkEnabled = state end)

ConnectionManager:AddConnection(RunService.Stepped:Connect(function()
    if AntiAfkEnabled then
        local vim = game:GetService("VirtualInputManager")
        pcall(function() vim:SendKeyEvent(true, Enum.KeyCode.W, false, game) end)
    end
end))

print("[BRINELAND] SpeedKeyboardEscape.lua updated with Free Key Sounds!")
