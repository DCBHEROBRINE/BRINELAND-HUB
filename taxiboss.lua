--[[
    ============================================================
    TAXI BOSS - CUSTOM GROUND-TRUTH MOBILE HUB
    Targeting updates:
      - Renamed toggles: "collect part", "clear ai car", "car boost"
    ============================================================
]]

-- ================= SERVICES =================
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace        = game:GetService("Workspace")
local RunService       = game:GetService("RunService")
local LocalPlayer      = Players.LocalPlayer

-- ================= CLEANUP PREVIOUS INSTANCES =================
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild("TaxiBossCustomHub") then
    PlayerGui.TaxiBossCustomHub:Destroy()
end

-- ================= CONFIGURATION =================
local Config = {
    AutoCollectItems = false,
    ClearAICars      = false,
    EnableCarSpeed   = false,
    TargetKMH        = 220,
    PlayerSpeed      = 16,
    ItemDelay        = 0.15,
    TweenSpeed       = 260
}

-- ================= UTILITY & VEHICLE DETECTOR =================
local function GetPlayerVehicle()
    local char = LocalPlayer.Character
    if not char then return nil end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.SeatPart and humanoid.SeatPart:IsA("VehicleSeat") then
        return humanoid.SeatPart.Parent
    end
    return nil
end

local function GetGroundCFrame(cframe)
    local rayOrigin = cframe.Position + Vector3.new(0, 30, 0)
    local rayDirection = Vector3.new(0, -100, 0)
    
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    
    local filterList = {LocalPlayer.Character}
    local veh = GetPlayerVehicle()
    if veh then table.insert(filterList, veh) end
    params.FilterDescendantsInstances = filterList

    local result = Workspace:Raycast(rayOrigin, rayDirection, params)
    if result then
        return CFrame.new(result.Position + Vector3.new(0, 3.2, 0)) * (cframe - cframe.Position)
    end
    return cframe
end

-- ================= ITEM SPAWN FARMING =================
local function CollectItemSpawns()
    local itemFolder = Workspace:FindFirstChild("ItemSpawnLocations")
    if not itemFolder then return end

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    for _, zone in ipairs(itemFolder:GetChildren()) do
        if not Config.AutoCollectItems then break end

        local spawnedItems = {}
        for _, child in ipairs(zone:GetChildren()) do
            if child:IsA("Model") or (child:IsA("BasePart") and child.Name ~= zone.Name) then
                table.insert(spawnedItems, child)
            end
        end

        for _, item in ipairs(spawnedItems) do
            if not Config.AutoCollectItems then break end

            local targetPart = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart", true)) or item
            local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)

            if targetPart then
                char:PivotTo(targetPart.CFrame * CFrame.new(0, 2, 0))
                task.wait(0.08)

                if prompt and prompt.Enabled then
                    fireproximityprompt(prompt)
                else
                    firetouchinterest(hrp, targetPart, 0)
                    task.wait(0.02)
                    firetouchinterest(hrp, targetPart, 1)
                end

                task.wait(Config.ItemDelay)
            end
        end
    end
end

-- ================= BACKGROUND THREADS =================

-- 1. Auto Collect Items Loop
task.spawn(function()
    while task.wait(0.5) do
        if Config.AutoCollectItems then
            pcall(CollectItemSpawns)
        end
    end
end)

-- 2. AI Traffic Wiping Loop
task.spawn(function()
    while task.wait(1.5) do
        if Config.ClearAICars then
            local aiFolder = Workspace:FindFirstChild("AICars")
            if aiFolder then
                for _, car in ipairs(aiFolder:GetChildren()) do
                    car:Destroy()
                end
            end
        end
    end
end)

-- 3. Vehicle & Character Physics Controller
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed ~= Config.PlayerSpeed then
            hum.WalkSpeed = Config.PlayerSpeed
        end
    end

    if Config.EnableCarSpeed then
        local veh = GetPlayerVehicle()
        if veh then
            local seat = veh:FindFirstChildOfClass("VehicleSeat") or veh:FindFirstChild("SEAT", true)
            if seat and seat:IsA("VehicleSeat") then
                local speedStuds = Config.TargetKMH / 1.008
                seat.MaxSpeed = speedStuds
                seat.Torque = 90000

                if seat.Throttle > -1 then
                    local root = seat.AssemblyRootPart or seat
                    local lookVector = seat.CFrame.LookVector
                    root.AssemblyLinearVelocity = Vector3.new(
                        lookVector.X * speedStuds,
                        root.AssemblyLinearVelocity.Y,
                        lookVector.Z * speedStuds
                    )
                end
            end
        end
    end
end)

-- ================= GUI DESIGN & MOBILE CONTROLS =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "TaxiBossCustomHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.fromOffset(340, 320)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(16, 12, 28)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(55, 20, 95)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(25, 35, 115)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(15, 65, 145))
})
Gradient.Rotation = 45
Gradient.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(150, 85, 255)
Stroke.Thickness = 1.5
Stroke.Parent = MainFrame

-- TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(10, 8, 20)
TopBar.BackgroundTransparency = 0.3
TopBar.Parent = MainFrame
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -85, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "<b>TAXI BOSS</b> <font color=\"#00E5FF\">DEX HUB</font>"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.RichText = true
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- MINIMIZE BUTTON
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

-- CLOSE BUTTON
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

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- CONTAINER
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

-- MINIMIZE LOGIC
local isMinimized = false
MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        Container.Visible = false
        TweenService:Create(MainFrame, TweenInfo.new(0.25), {Size = UDim2.fromOffset(340, 40)}):Play()
        MinimizeBtn.Text = "<b>+</b>"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.25), {Size = UDim2.fromOffset(340, 320)}):Play()
        task.wait(0.15)
        Container.Visible = true
        MinimizeBtn.Text = "<b>–</b>"
    end
end)

-- DRAGGABLE LOGIC FOR MOBILE
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
UserInputService.InputEnded:Connect(function(input) dragging = false end)

-- UI CONTROLLERS
local function CreateToggle(text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(22, 18, 45)
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

local function CreateInput(text, defaultVal, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(22, 18, 45)
    frame.Parent = Container
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
    textBox.Size = UDim2.fromOffset(65, 24)
    textBox.Position = UDim2.new(1, -72, 0.5, -12)
    textBox.BackgroundColor3 = Color3.fromRGB(35, 28, 65)
    textBox.Text = tostring(defaultVal)
    textBox.TextColor3 = Color3.fromRGB(0, 229, 255)
    textBox.Font = Enum.Font.GothamBold
    textBox.TextSize = 11
    textBox.Parent = frame
    Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 4)

    textBox.FocusLost:Connect(function()
        local n = tonumber(textBox.Text)
        if n then callback(n) end
    end)
end

-- ================= POPULATE TOGGLES =================
CreateToggle("collect part", function(state)
    Config.AutoCollectItems = state
end)

CreateToggle("clear ai car", function(state)
    Config.ClearAICars = state
end)

CreateToggle("car boost", function(state)
    Config.EnableCarSpeed = state
end)

CreateInput("Target Speed (KM/H)", Config.TargetKMH, function(val)
    Config.TargetKMH = val
end)

CreateInput("Player WalkSpeed", Config.PlayerSpeed, function(val)
    Config.PlayerSpeed = val
end)
