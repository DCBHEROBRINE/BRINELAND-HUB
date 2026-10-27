-- ==============================================================================
-- STEAL AN EGG HUB V7 (MASTER ENGINE IDEMPOTENT SECURE EDITION)
-- ==============================================================================

local getenv = getgenv or function() return _G end
local env = getenv()

if env.StealAnEggMasterCleanup then 
    pcall(env.StealAnEggMasterCleanup) 
end

local function cloneRef(obj)
    if cloneref then return cloneref(obj) end
    return obj
end

local function getService(name)
    local success, service = pcall(function() return game:GetService(name) end)
    if success and service then return cloneRef(service) end
    return nil
end

local TweenService      = getService("TweenService")
local UserInputService  = getService("UserInputService")
local Workspace         = getService("Workspace")
local RunService        = getService("RunService")
local Players           = getService("Players")
local ReplicatedStorage = getService("ReplicatedStorage")
local VirtualUser       = getService("VirtualUser")
local CoreGui           = getService("CoreGui")

local LocalPlayer = Players and Players.LocalPlayer

local function getGuiParent()
    if gethui then
        local ok, res = pcall(gethui)
        if ok and res then return res end
    end
    if CoreGui then return CoreGui end
    if LocalPlayer then
        local pGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if not pGui then pGui = LocalPlayer:WaitForChild("PlayerGui", 5) end
        return pGui
    end
    return nil
end

local guiParent = getGuiParent()
if not guiParent then
    warn("[Steal An Egg Hub]: Critical error - Unable to resolve a valid GUI parent.")
    return
end

if guiParent:FindFirstChild("StealAnEggHubV7") then
    guiParent.StealAnEggHubV7:Destroy()
end

-- Configuration with strict bounds for inputs
local Config = {
    AutoSteal            = false,
    StealMethod          = "Tween",
    TweenSpeed           = 80,
    StealWalkSpeed       = 28,
    AutoHit              = false,
    HitRange             = 12,
    AutoPlaceEgg         = false,
    AutoHatch            = false,
    AutoUpgradeTreadmill = false,
    AutoUpgradePen       = false,
    EnableSpeed          = false,
    PlayerSpeed          = 24,
    AutoReturn           = true,
    AntiAFK              = true,
    ScanDelay            = 0.35,
    InteractDelay        = 0.15,
}

local InputBounds = {
    TweenSpeed     = {min = 5, max = 500},
    StealWalkSpeed = {min = 5, max = 150},
    HitRange       = {min = 1, max = 50},
    PlayerSpeed    = {min = 16, max = 200},
    ScanDelay      = {min = 0.05, max = 5},
    InteractDelay  = {min = 0.01, max = 2},
}

-- Master State & Cleanup Handles
local State = {
    Running      = true,
    Stealing     = false,
    HomeBaseCF   = nil,
    Connections  = {},
    ActiveTweens = {},
}

env.MasterState = State

local promptScanThread = nil

-- Idempotent Cleanup Implementation
local function cleanup()
    if not State or not State.Running then
        return
    end

    State.Running = false
    State.Stealing = false

    for _, conn in ipairs(State.Connections) do
        if conn and conn.Connected then
            pcall(function()
                conn:Disconnect()
            end)
        end
    end

    table.clear(State.Connections)

    for _, record in ipairs(State.ActiveTweens) do
        if record and record.Tween then
            pcall(function()
                record.Tween:Cancel()
            end)
        end
    end

    table.clear(State.ActiveTweens)

    pcall(function()
        if promptScanThread and coroutine.status(promptScanThread) ~= "dead" then
            task.cancel(promptScanThread)
        end
    end)

    if guiParent then
        local found = guiParent:FindFirstChild("StealAnEggHubV7")
        if found then pcall(function() found:Destroy() end) end
    end

    env.StealAnEggMasterCleanup = nil
    print("[Steal An Egg Hub] Shutdown complete. All loops and connections disconnected.")
end
env.StealAnEggMasterCleanup = cleanup

if env.StopMasterOld then
    pcall(env.StopMasterOld)
end
env.StopMasterOld = cleanup

-- Character & Remote Utilities
local function getChar() return LocalPlayer and LocalPlayer.Character end
local function getHum()  local c = getChar(); return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot() local c = getChar(); return c and c:FindFirstChild("HumanoidRootPart") end
local function alive()   local h = getHum(); return h and h.Health > 0 and getRoot() ~= nil end

if LocalPlayer then
    table.insert(State.Connections, LocalPlayer.CharacterAdded:Connect(function()
        State.HomeBaseCF = nil
    end))
end

local function getRemote(name)
    if not ReplicatedStorage then return nil end
    local r = ReplicatedStorage:FindFirstChild(name, true)
    if r and (r:IsA("RemoteEvent") or r:IsA("RemoteFunction")) then return r end
    
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and obj.Name:lower() == name:lower() then
            return obj
        end
    end
    return nil
end

local function fireRemote(name, ...)
    local r = getRemote(name)
    if not r then return false end
    return pcall(function()
        if r:IsA("RemoteEvent") then r:FireServer(...)
        elseif r:IsA("RemoteFunction") then r:InvokeServer(...) end
    end)
end

local function ClickButton(button)
    pcall(function()
        if firesignal then
            firesignal(button.Activated)
        elseif getconnections then
            for _, conn in ipairs(getconnections(button.Activated)) do 
                pcall(function() conn:Fire() end) 
            end
        elseif button:IsA("GuiButton") then
            button:Activate()
        end
    end)
end

local function BindClick(button, callback)
    button.Active = true
    local lastClick = 0
    local function trigger()
        local now = tick()
        if now - lastClick > 0.15 then
            lastClick = now
            pcall(callback)
        end
    end
    table.insert(State.Connections, button.Activated:Connect(trigger))
end

local function GetMyPlot()
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return nil end

    for _, plot in ipairs(plots:GetChildren()) do
        local owner = plot:FindFirstChild("Owner") or plot:FindFirstChild("OwnerValue") or plot:FindFirstChild("Player")
        if owner and owner:IsA("ValueBase") then
            local val = owner.Value
            if LocalPlayer and (val == LocalPlayer or val == LocalPlayer.Name or val == LocalPlayer.UserId or (typeof(val) == "Instance" and (val == LocalPlayer or (val:IsA("Player") and val.Name == LocalPlayer.Name)))) then
                return plot
            end
        end
        for _, desc in ipairs(plot:GetDescendants()) do
            if desc:IsA("TextLabel") and LocalPlayer then
                local txt = desc.Text
                local descName = desc.Name:lower()
                if (descName:find("owner") or descName:find("name") or descName:find("title")) and (txt == LocalPlayer.Name or txt == LocalPlayer.DisplayName or txt:lower() == (LocalPlayer.Name:lower() .. "'s plot")) then
                    return plot
                end
            end
        end
    end
    return nil
end

local function GetSafeZoneCFrame()
    if State.HomeBaseCF then return State.HomeBaseCF end
    local myPlot = GetMyPlot()
    if myPlot then
        local treadmill = myPlot:FindFirstChild("TreadmillUpgrade") or myPlot:FindFirstChild("Treadmill")
        if treadmill then
            local base = treadmill:FindFirstChildWhichIsA("BasePart", true)
            if base then 
                State.HomeBaseCF = base.CFrame + Vector3.new(0, 4, 0)
                return State.HomeBaseCF 
            end
        end
        local plotBase = myPlot:FindFirstChildWhichIsA("BasePart")
        if plotBase then 
            State.HomeBaseCF = plotBase.CFrame + Vector3.new(0, 5, 0)
            return State.HomeBaseCF 
        end
    end
    local char = getChar()
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        State.HomeBaseCF = root.CFrame
        return State.HomeBaseCF
    end
    return CFrame.new(0, 10, 0)
end

local function TouchPart(part)
    local char = getChar()
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

local function MoveToTarget(targetCFrame)
    local char = getChar()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not targetCFrame then return end

    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    if distance < 3 then return end

    if Config.StealMethod == "Tween" and TweenService then
        local duration = math.min(3, math.max(0.05, distance / math.max(10, Config.TweenSpeed)))
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
        
        local tweenRecord = {Tween = tween}
        table.insert(State.ActiveTweens, tweenRecord)
        
        local completed = false
        local conn
        conn = tween.Completed:Connect(function()
            completed = true
            if conn then conn:Disconnect() end
            for i, record in ipairs(State.ActiveTweens) do
                if record == tweenRecord then
                    table.remove(State.ActiveTweens, i)
                    break
                end
            end
        end)
        
        tween:Play()
        
        local elapsed = 0
        while not completed and elapsed < (duration + 1) do
            if not State.Running or not alive() then 
                pcall(function() tween:Cancel() end)
                if conn then conn:Disconnect() end
                for i, record in ipairs(State.ActiveTweens) do
                    if record == tweenRecord then
                        table.remove(State.ActiveTweens, i)
                        break
                    end
                end
                break 
            end
            task.wait(0.05)
            elapsed = elapsed + 0.05
        end
    elseif Config.StealMethod == "Walk" then
        if hum then
            local prevSpeed = hum.WalkSpeed
            hum.WalkSpeed = Config.StealWalkSpeed
            hum:MoveTo(targetCFrame.Position)
            local timeout = 0
            repeat
                task.wait(0.1)
                timeout = timeout + 0.1
            until (hrp.Position - targetCFrame.Position).Magnitude <= 4 or timeout >= (distance / math.max(5, Config.StealWalkSpeed)) or not State.Running
            if not Config.EnableSpeed then hum.WalkSpeed = prevSpeed end
        end
    end
end

local function GetEggTargets()
    local targets = {}
    local myPlot = GetMyPlot()
    local root = getRoot()
    if not root or not alive() then return targets end

    local areaSlots = Workspace:FindFirstChild("AreaEggSlotsClient")
    if areaSlots then
        for _, model in ipairs(areaSlots:GetChildren()) do
            local hitbox = model:FindFirstChild("Hitbox") or model:FindFirstChildWhichIsA("BasePart", true)
            if hitbox then table.insert(targets, {Part = hitbox, Model = model, Distance = (hitbox.Position - root.Position).Magnitude}) end
        end
    end

    local sammyMap = Workspace:FindFirstChild("SammyEventMap")
    if sammyMap then
        for _, model in ipairs(sammyMap:GetChildren()) do
            local hitbox = model:FindFirstChild("Hitbox", true) or model:FindFirstChildWhichIsA("BasePart", true)
            if hitbox then table.insert(targets, {Part = hitbox, Model = model, Distance = (hitbox.Position - root.Position).Magnitude}) end
        end
    end

    local plots = Workspace:FindFirstChild("Plots")
    if plots then
        for _, plot in ipairs(plots:GetChildren()) do
            if plot ~= myPlot then
                for _, obj in ipairs(plot:GetDescendants()) do
                    if obj:IsA("Model") and obj.Name:lower():find("egg") then
                        local hitbox = obj:FindFirstChild("Hitbox") or obj:FindFirstChildWhichIsA("BasePart", true)
                        if hitbox then table.insert(targets, {Part = hitbox, Model = obj, Distance = (hitbox.Position - root.Position).Magnitude}) end
                    end
                end
            end
        end
    end
    table.sort(targets, function(a, b) return a.Distance < b.Distance end)
    return targets
end

promptScanThread = task.spawn(function()
    while State.Running do
        task.wait(0.5)
        if not State.Running then break end
        for _, prompt in ipairs(Workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then prompt.HoldDuration = 0 end
        end
    end
end)

local steppedConn = RunService.Stepped:Connect(function()
    if not State.Running then return end
    if Config.EnableSpeed then
        local char = getChar()
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = Config.PlayerSpeed end
    end
end)
table.insert(State.Connections, steppedConn)

if LocalPlayer then
    local idledConn = LocalPlayer.Idled:Connect(function()
        if Config.AntiAFK and State.Running and VirtualUser then
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new(0,0))
            end)
        end
    end)
    table.insert(State.Connections, idledConn)
end

task.spawn(function()
    GetSafeZoneCFrame()
    while State.Running do
        task.wait(Config.ScanDelay)
        if Config.AutoSteal and not State.Stealing and alive() then
            State.Stealing = true
            local success, err = pcall(function()
                local targets = GetEggTargets()
                if #targets > 0 then
                    local target = targets[1]
                    local hitboxPart = target.Part
                    if hitboxPart and hitboxPart.Parent then
                        MoveToTarget(hitboxPart.CFrame + Vector3.new(0, 2, 0))
                        TouchPart(hitboxPart)
                        local prompt = target.Model:FindFirstChildWhichIsA("ProximityPrompt", true) or hitboxPart:FindFirstChildWhichIsA("ProximityPrompt")
                        if prompt then
                            prompt.HoldDuration = 0
                            pcall(function() fireproximityprompt(prompt) end)
                        end
                        task.wait(Config.InteractDelay)
                        if Config.AutoReturn then
                            MoveToTarget(GetSafeZoneCFrame())
                        end
                        task.wait(0.2)
                    end
                end
            end)
            if not success then
                warn("[Steal An Egg Hub Error]:", err)
                task.wait(0.5)
            end
            State.Stealing = false
        end
    end
end)

task.spawn(function()
    while task.wait(0.08) do
        if not State.Running then break end
        if Config.AutoHit then
            local char = getChar()
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local tool = char and char:FindFirstChildOfClass("Tool")
            if hrp and tool then
                local targetFound = false
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if (obj:IsA("Model") and obj ~= char and obj:FindFirstChildOfClass("Humanoid")) or (obj.Name == "Hitbox" and obj.Parent ~= char and not obj:IsDescendantOf(char)) then
                        local targetPart = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")) or obj
                        if targetPart and targetPart:IsA("BasePart") then
                            if (targetPart.Position - hrp.Position).Magnitude <= Config.HitRange then
                                targetFound = true
                                break
                            end
                        end
                    end
                end
                if targetFound then tool:Activate() end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.25) do
        if not State.Running then break end
        if Config.AutoPlaceEgg then
            local char = getChar()
            local backpack = LocalPlayer and LocalPlayer:FindFirstChild("Backpack")
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
                        MoveToTarget(GetSafeZoneCFrame())
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

task.spawn(function()
    while task.wait(0.25) do
        if not State.Running then break end
        if Config.AutoHatch then
            local playerGui = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
            if playerGui then
                for _, descendant in ipairs(playerGui:GetDescendants()) do
                    if descendant:IsA("TextButton") or descendant:IsA("ImageButton") then
                        local name = descendant.Name:lower()
                        local text = (descendant:IsA("TextButton") and descendant.Text or ""):lower()
                        if name:find("hatch") or text:find("hatch") or name:find("claim") or text:find("claim") or ((text:find("open") or text:find("buy")) and (text:find("egg") or text:find("pet"))) then
                            ClickButton(descendant)
                        end
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

task.spawn(function()
    while task.wait(0.3) do
        if not State.Running then break end
        local myPlot = GetMyPlot()
        if myPlot then
            if Config.AutoUpgradeTreadmill then
                local treadmillModel = myPlot:FindFirstChild("TreadmillUpgrade") or myPlot:FindFirstChild("Treadmill")
                if treadmillModel then
                    for _, part in ipairs(treadmillModel:GetDescendants()) do
                        if part:IsA("BasePart") then TouchPart(part)
                        elseif part:IsA("TextButton") or part:IsA("ImageButton") then ClickButton(part) end
                    end
                end
            end
            if Config.AutoUpgradePen then
                local penModel = myPlot:FindFirstChild("PlotUpgrade") or myPlot:FindFirstChild("PenUpgrade") or myPlot:FindFirstChild("Plot")
                if penModel then
                    for _, part in ipairs(penModel:GetDescendants()) do
                        if part:IsA("BasePart") then TouchPart(part)
                        elseif part:IsA("TextButton") or part:IsA("ImageButton") then ClickButton(part) end
                    end
                end
            end
        end
    end
end)

local initSuccess, initError = pcall(function()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "StealAnEggHubV7"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = guiParent

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
        cleanup()
        SetGuiState(false) 
    end)

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

        table.insert(State.Connections, listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            container.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 12)
        end))

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

    local dragging, dragStart, startPos
    if UserInputService then
        table.insert(State.Connections, TopBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; dragStart = input.Position; startPos = MainFrame.Position
            end
        end))
        table.insert(State.Connections, UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end))
        table.insert(State.Connections, UserInputService.InputEnded:Connect(function() dragging = false end))
    end

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
            if TweenService then
                TweenService:Create(knob, TweenInfo.new(0.18), {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
                TweenService:Create(toggleBg, TweenInfo.new(0.18), {BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(45, 35, 65)}):Play()
            else
                knob.Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                toggleBg.BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(45, 35, 65)
            end
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

        table.insert(State.Connections, textBox.FocusLost:Connect(function()
            local val = tonumber(textBox.Text)
            if val then
                local bounds = InputBounds[configKey]
                if bounds then
                    val = math.clamp(val, bounds.min, bounds.max)
                else
                    val = math.max(0.01, val)
                end
                Config[configKey] = val
                textBox.Text = tostring(val)
            else
                textBox.Text = tostring(Config[configKey])
            end
        end))
    end

    CreateToggle(StealTab, "Auto Steal & Safe Zone Return", "AutoSteal")
    CreateSelector(StealTab, "Steal Method", {"Tween", "Walk"}, "StealMethod")
    CreateInput(StealTab, "Tween Speed Value", "TweenSpeed")
    CreateInput(StealTab, "Steal Walk Speed", "StealWalkSpeed")
    CreateToggle(StealTab, "Auto Place Egg", "AutoPlaceEgg")
    CreateToggle(StealTab, "Auto Hatch Egg", "AutoHatch")

    CreateToggle(CombatTab, "Auto Hit (Equipped Bat)", "AutoHit")
    CreateInput(CombatTab, "Hit Range (Studs)", "HitRange")

    CreateToggle(UpgradesTab, "Auto Upgrade Treadmill", "AutoUpgradeTreadmill")
    CreateToggle(UpgradesTab, "Auto Upgrade Pen", "AutoUpgradePen")

    CreateToggle(PlayerTab, "Enable Speed Boost", "EnableSpeed")
    CreateInput(PlayerTab, "Player WalkSpeed", "PlayerSpeed")
end)

if initSuccess then
    print("[Steal An Egg Hub V7] Master Engine successfully initialized and ready!")
else
    warn("[Steal An Egg Hub V7] Initialization failed:", initError)
end
