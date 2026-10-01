--[[
    ============================================================
    STEAL AN EGG - REVISED HUB V7
    - Game Verification Lock (Only runs in "Steal an Egg")
    - Instant Proximity Prompts (Built-in Always-On Feature)
    - Re-engineered Auto Place Egg (Equip -> Teleport to Plot -> Place)
    - Re-engineered Auto Hatch (GUI Buttons & Plot Prompts)
    - Multi-Click Registration Fix
    - Plain Text UI (No Bracket/HTML Tags)
    - Animated Open/Close GUI Toggle
    ============================================================
]]

-- ================= GAME VERIFICATION LOCK =================
local MarketplaceService = game:GetService("MarketplaceService")
local isCorrectGame = false

local success, placeInfo = pcall(function()
    return MarketplaceService:GetProductInfo(game.PlaceId)
end)

if success and placeInfo and placeInfo.Name then
    local nameLower = placeInfo.Name:lower()
    if nameLower:find("steal") and nameLower:find("egg") then
        isCorrectGame = true
    end
end

if not isCorrectGame then
    warn("[STEAL AN EGG HUB] Execution stopped: This script only works in 'Steal an Egg'.")
    return
end

-- ================= SERVICES =================
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace        = game:GetService("Workspace")
local RunService       = game:GetService("RunService")
local LocalPlayer      = Players.LocalPlayer

-- ================= CLEANUP PREVIOUS INSTANCES =================
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild("StealAnEggHubV7") then
    PlayerGui.StealAnEggHubV7:Destroy()
end

-- ================= CONFIGURATION =================
local Config = {
    AutoSteal            = false,
    StealMethod          = "Tween", -- "Tween", "Walk"
    TweenSpeed           = 80,
    StealWalkSpeed       = 28,
    
    AutoHit              = false,
    HitRange             = 12,
    
    AutoPlaceEgg         = false,
    AutoHatch            = false,
    
    AutoUpgradeTreadmill = false,
    AutoUpgradePen       = false,
    
    EnableSpeed          = false,
    PlayerSpeed          = 24
}

-- ================= HELPER FUNCTIONS =================

-- Robust Multi-Click Event Binder
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

-- Locate Local Player's Plot Base / Safe Zone
local function GetMyPlot()
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return nil end

    for _, plot in ipairs(plots:GetChildren()) do
        local owner = plot:FindFirstChild("Owner") or plot:FindFirstChild("OwnerValue") or plot:FindFirstChild("Player")
        if owner and (owner.Value == LocalPlayer or owner.Value == LocalPlayer.Name) then
            return plot
        end
        
        for _, desc in ipairs(plot:GetDescendants()) do
            if desc:IsA("TextLabel") and (desc.Text:find(LocalPlayer.Name) or desc.Text:find(LocalPlayer.DisplayName)) then
                return plot
            end
        end
    end
    return plots:FindFirstChild("1") or plots:GetChildren()[1]
end

local function GetSafeZoneCFrame()
    local myPlot = GetMyPlot()
    if myPlot then
        local treadmill = myPlot:FindFirstChild("TreadmillUpgrade") or myPlot:FindFirstChild("Treadmill")
        if treadmill then
            local base = treadmill:FindFirstChildWhichIsA("BasePart", true)
            if base then return base.CFrame + Vector3.new(0, 4, 0) end
        end
        local plotBase = myPlot:FindFirstChildWhichIsA("BasePart")
        if plotBase then return plotBase.CFrame + Vector3.new(0, 5, 0) end
    end
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart.CFrame or CFrame.new(0, 10, 0)
end

-- Touch Part Simulation
local function TouchPart(part)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp and part and part:IsA("BasePart") then
        pcall(function()
            if firetouchinterest then
                firetouchinterest(hrp, part, 0)
                task.wait(0.02)
                firetouchinterest(hrp, part, 1)
            end
        end)
    end
end

-- Click UI Button Simulation
local function ClickButton(button)
    pcall(function()
        if firesignal then
            firesignal(button.MouseButton1Click)
            firesignal(button.Activated)
        else
            for _, conn in ipairs(getconnections(button.MouseButton1Click)) do conn:Fire() end
            for _, conn in ipairs(getconnections(button.Activated)) do conn:Fire() end
        end
    end)
end

-- ================= MOVEMENT ENGINE =================
local function MoveToTarget(targetCFrame)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp then return end

    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    if distance < 3 then return end

    if Config.StealMethod == "Tween" then
        local duration = math.max(0.05, distance / math.max(10, Config.TweenSpeed))
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
        tween:Play()
        tween.Completed:Wait()

    elseif Config.StealMethod == "Walk" then
        if hum then
            local prevSpeed = hum.WalkSpeed
            hum.WalkSpeed = Config.StealWalkSpeed
            hum:MoveTo(targetCFrame.Position)
            local timeout = 0
            repeat
                task.wait(0.1)
                timeout = timeout + 0.1
            until (hrp.Position - targetCFrame.Position).Magnitude <= 4 or timeout >= (distance / math.max(5, Config.StealWalkSpeed))
            
            if not Config.EnableSpeed then
                hum.WalkSpeed = prevSpeed
            end
        end
    end
end

-- ================= SCAN ALL EGGS =================
local function GetEggTargets()
    local targets = {}
    local myPlot = GetMyPlot()

    -- 1. AreaEggSlotsClient
    local areaSlots = Workspace:FindFirstChild("AreaEggSlotsClient")
    if areaSlots then
        for _, model in ipairs(areaSlots:GetChildren()) do
            local hitbox = model:FindFirstChild("Hitbox") or model:FindFirstChildWhichIsA("BasePart", true)
            if hitbox then
                table.insert(targets, {Part = hitbox, Model = model})
            end
        end
    end

    -- 2. SammyEventMap
    local sammyMap = Workspace:FindFirstChild("SammyEventMap")
    if sammyMap then
        for _, model in ipairs(sammyMap:GetChildren()) do
            local hitbox = model:FindFirstChild("Hitbox", true) or model:FindFirstChildWhichIsA("BasePart", true)
            if hitbox then
                table.insert(targets, {Part = hitbox, Model = model})
            end
        end
    end

    -- 3. Enemy Plots
    local plots = Workspace:FindFirstChild("Plots")
    if plots then
        for _, plot in ipairs(plots:GetChildren()) do
            if plot ~= myPlot then
                for _, obj in ipairs(plot:GetDescendants()) do
                    if obj:IsA("Model") and obj.Name:lower():find("egg") then
                        local hitbox = obj:FindFirstChild("Hitbox") or obj:FindFirstChildWhichIsA("BasePart", true)
                        if hitbox then
                            table.insert(targets, {Part = hitbox, Model = obj})
                        end
                    end
                end
            end
        end
    end

    return targets
end

-- ================= BACKGROUND THREADS =================

-- 1. INSTANT PROXIMITY PROMPTS (BUILT-IN FEATURE)
RunService.Stepped:Connect(function()
    for _, prompt in ipairs(Workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            prompt.HoldDuration = 0
        end
    end

    if Config.EnableSpeed then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = Config.PlayerSpeed
        end
    end
end)

-- 2. AUTO STEAL & SAFE ZONE RETURN
task.spawn(function()
    while true do
        task.wait(0.1)

        if Config.AutoSteal then
            local targets = GetEggTargets()
            
            for _, target in ipairs(targets) do
                if not Config.AutoSteal then break end

                local hitboxPart = target.Part
                if hitboxPart and hitboxPart.Parent then
                    MoveToTarget(hitboxPart.CFrame + Vector3.new(0, 2, 0))

                    TouchPart(hitboxPart)
                    local prompt = target.Model:FindFirstChildWhichIsA("ProximityPrompt", true) or hitboxPart:FindFirstChildWhichIsA("ProximityPrompt")
                    if prompt then
                        prompt.HoldDuration = 0
                        pcall(function() fireproximityprompt(prompt) end)
                    end

                    task.wait(0.15)

                    local safeZoneCFrame = GetSafeZoneCFrame()
                    MoveToTarget(safeZoneCFrame)
                    
                    task.wait(0.2)
                end
            end
        end
    end
end)

-- 3. AUTO HIT ENGINE
task.spawn(function()
    while task.wait(0.08) do
        if Config.AutoHit then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local tool = char and char:FindFirstChildOfClass("Tool")

            if hrp and tool then
                local targetFound = false

                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if (obj:IsA("Model") and obj ~= char and obj:FindFirstChildOfClass("Humanoid")) or (obj.Name == "Hitbox" and obj.Parent ~= char and not obj:IsDescendantOf(char)) then
                        local targetPart = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")) or obj
                        
                        if targetPart and targetPart:IsA("BasePart") then
                            local dist = (targetPart.Position - hrp.Position).Magnitude
                            if dist <= Config.HitRange then
                                targetFound = true
                                break
                            end
                        end
                    end
                end

                if targetFound then
                    tool:Activate()
                end
            end
        end
    end
end)

-- 4. AUTO PLACE EGG
task.spawn(function()
    while task.wait(0.25) do
        if Config.AutoPlaceEgg then
            local char = LocalPlayer.Character
            local backpack = LocalPlayer:FindFirstChild("Backpack")

            if char and backpack then
                local eggTool = nil
                for _, tool in ipairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") and (tool.Name:lower():find("egg") or tool.Name:lower():find("steal")) then
                        eggTool = tool
                        tool.Parent = char
                        break
                    end
                end

                if not eggTool then
                    for _, tool in ipairs(char:GetChildren()) do
                        if tool:IsA("Tool") and (tool.Name:lower():find("egg") or tool.Name:lower():find("steal")) then
                            eggTool = tool
                            break
                        end
                    end
                end

                if eggTool then
                    local myPlot = GetMyPlot()
                    if myPlot then
                        local safeCFrame = GetSafeZoneCFrame()
                        MoveToTarget(safeCFrame)
                        task.wait(0.1)

                        eggTool:Activate()

                        for _, desc in ipairs(myPlot:GetDescendants()) do
                            if desc:IsA("ProximityPrompt") then
                                desc.HoldDuration = 0
                                pcall(function() fireproximityprompt(desc) end)
                            elseif desc:IsA("BasePart") and (desc.Name:lower():find("place") or desc.Name:lower():find("slot") or desc.Name:lower():find("hatch")) then
                                TouchPart(desc)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- 5. AUTO HATCH
task.spawn(function()
    while task.wait(0.25) do
        if Config.AutoHatch then
            for _, descendant in ipairs(PlayerGui:GetDescendants()) do
                if descendant:IsA("TextButton") or descendant:IsA("ImageButton") then
                    local name = descendant.Name:lower()
                    local text = (descendant:IsA("TextButton") and descendant.Text or ""):lower()
                    
                    if name:find("hatch") or text:find("hatch") or name:find("claim") or text:find("claim") or text:find("open") then
                        ClickButton(descendant)
                    end
                end
            end

            local myPlot = GetMyPlot()
            if myPlot then
                for _, desc in ipairs(myPlot:GetDescendants()) do
                    if desc:IsA("ProximityPrompt") then
                        local actText = desc.ActionText:lower()
                        local objText = desc.ObjectText:lower()
                        if actText:find("hatch") or objText:find("hatch") or actText:find("open") then
                            desc.HoldDuration = 0
                            pcall(function() fireproximityprompt(desc) end)
                        end
                    end
                end
            end
        end
    end
end)

-- 6. AUTO UPGRADES
task.spawn(function()
    while task.wait(0.3) do
        local myPlot = GetMyPlot()
        if myPlot then
            if Config.AutoUpgradeTreadmill then
                local treadmillModel = myPlot:FindFirstChild("TreadmillUpgrade") or myPlot:FindFirstChild("Treadmill")
                if treadmillModel then
                    for _, part in ipairs(treadmillModel:GetDescendants()) do
                        if part:IsA("BasePart") then
                            TouchPart(part)
                        elseif part:IsA("TextButton") or part:IsA("ImageButton") then
                            ClickButton(part)
                        end
                    end
                end
            end

            if Config.AutoUpgradePen then
                local penModel = myPlot:FindFirstChild("PlotUpgrade") or myPlot:FindFirstChild("PenUpgrade") or myPlot:FindFirstChild("Plot")
                if penModel then
                    for _, part in ipairs(penModel:GetDescendants()) do
                        if part:IsA("BasePart") then
                            TouchPart(part)
                        elseif part:IsA("TextButton") or part:IsA("ImageButton") then
                            ClickButton(part)
                        end
                    end
                end
            end
        end
    end
end)

-- ================= GUI DESIGN =================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "StealAnEggHubV7"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- FLOATING TOGGLE BUTTON
local OpenToggleBtn = Instance.new("TextButton")
OpenToggleBtn.Size = UDim2.fromOffset(50, 50)
OpenToggleBtn.Position = UDim2.new(0, 15, 0.5, -25)
OpenToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 240)
OpenToggleBtn.Text = "HUB"
OpenToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenToggleBtn.Font = Enum.Font.GothamBold
OpenToggleBtn.TextSize = 13
OpenToggleBtn.Active = true
OpenToggleBtn.Parent = ScreenGui

Instance.new("UICorner", OpenToggleBtn).CornerRadius = UDim.new(1, 0)
local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
ToggleStroke.Thickness = 2
ToggleStroke.Parent = OpenToggleBtn

-- MAIN FRAME
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

-- ANIMATED OPEN / CLOSE CONTROLLER
local isGuiOpen = true

local function SetGuiState(state)
    isGuiOpen = state
    if isGuiOpen then
        MainFrame.Visible = true
        MainFrame:TweenSizeAndPosition(
            UDim2.fromOffset(360, 430),
            UDim2.new(0.5, -180, 0.5, -215),
            Enum.EasingDirection.Out,
            Enum.EasingStyle.Back,
            0.3,
            true
        )
    else
        MainFrame:TweenSizeAndPosition(
            UDim2.fromOffset(0, 0),
            UDim2.new(0.5, 0, 0.5, 0),
            Enum.EasingDirection.In,
            Enum.EasingStyle.Back,
            0.25,
            true,
            function()
                if not isGuiOpen then
                    MainFrame.Visible = false
                end
            end
        )
    end
end

BindClick(OpenToggleBtn, function()
    SetGuiState(not isGuiOpen)
end)

-- TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundColor3 = Color3.fromRGB(10, 8, 18)
TopBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "STEAL AN EGG HUB V7"
Title.TextColor3 = Color3.fromRGB(0, 225, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.fromOffset(26, 26)
CloseBtn.Position = UDim2.new(1, -32, 0.5, -13)
CloseBtn.BackgroundColor3 = Color3.fromRGB(225, 35, 75)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

BindClick(CloseBtn, function()
    SetGuiState(false)
end)

-- TAB BAR
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
    tabBtn.Text = tabName
    tabBtn.TextColor3 = Color3.fromRGB(180, 180, 210)
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 10
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

local StealTab    = CreateTab("Steal")
local CombatTab   = CreateTab("Combat")
local UpgradesTab = CreateTab("Upgrades")
local PlayerTab   = CreateTab("Player")

TabFrames["Steal"].Container.Visible = true
TabFrames["Steal"].Button.BackgroundColor3 = Color3.fromRGB(0, 160, 240)
TabFrames["Steal"].Button.TextColor3 = Color3.fromRGB(255, 255, 255)

-- DRAGGABLE LOGIC FOR TOUCH & MOUSE
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

-- UI BUILDER FUNCTIONS
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
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
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
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromOffset(100, 24)
    btn.Position = UDim2.new(1, -106, 0.5, -12)
    btn.BackgroundColor3 = Color3.fromRGB(35, 28, 58)
    btn.Text = tostring(Config[configKey])
    btn.TextColor3 = Color3.fromRGB(0, 225, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
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
        btn.Text = tostring(options[idx])
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
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
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

-- ================= POPULATE CONTROLS =================

-- TAB 1: STEAL
CreateToggle(StealTab, "Auto Steal & Safe Zone Return", "AutoSteal")
CreateSelector(StealTab, "Steal Method", {"Tween", "Walk"}, "StealMethod")
CreateInput(StealTab, "Tween Speed Value", "TweenSpeed")
CreateInput(StealTab, "Steal Walk Speed", "StealWalkSpeed")
CreateToggle(StealTab, "Auto Place Egg", "AutoPlaceEgg")
CreateToggle(StealTab, "Auto Hatch Egg", "AutoHatch")

-- TAB 2: COMBAT
CreateToggle(CombatTab, "Auto Hit (Equipped Bat)", "AutoHit")
CreateInput(CombatTab, "Hit Range (Studs)", "HitRange")

-- TAB 3: UPGRADES
CreateToggle(UpgradesTab, "Auto Upgrade Treadmill", "AutoUpgradeTreadmill")
CreateToggle(UpgradesTab, "Auto Upgrade Pen", "AutoUpgradePen")

-- TAB 4: PLAYER
CreateToggle(PlayerTab, "Enable Speed Boost", "EnableSpeed")
CreateInput(PlayerTab, "Player WalkSpeed", "PlayerSpeed")
