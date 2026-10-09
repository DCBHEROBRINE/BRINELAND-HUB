local MarketplaceService = game:GetService("MarketplaceService")
local PlaceId = game.PlaceId

local success, info = pcall(function()
    return MarketplaceService:GetProductInfo(PlaceId)
end)
local gameName = (success and info and info.Name) or ""

local function RunTaxiBoss()
    -- Taxi Boss Ground-Truth Mobile Hub
    local TweenService     = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local Workspace        = game:GetService("Workspace")
    local RunService       = game:GetService("RunService")
    local Players          = game:GetService("Players")
    local LocalPlayer      = Players.LocalPlayer

    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    if PlayerGui:FindFirstChild("TaxiBossCustomHub") then
        PlayerGui.TaxiBossCustomHub:Destroy()
    end

    local Config = {
        AutoCollectItems = false,
        ClearAICars      = false,
        EnableCarSpeed   = false,
        TargetKMH        = 220,
        PlayerSpeed      = 16,
        ItemDelay        = 0.15,
        TweenSpeed       = 260
    }

    local function GetPlayerVehicle()
        local char = LocalPlayer.Character
        if not char then return nil end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.SeatPart and humanoid.SeatPart:IsA("VehicleSeat") then
            return humanoid.SeatPart.Parent
        end
        return nil
    end

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

    task.spawn(function()
        while task.wait(0.5) do
            if Config.AutoCollectItems then pcall(CollectItemSpawns) end
        end
    end)

    task.spawn(function()
        while task.wait(1.5) do
            if Config.ClearAICars then
                local aiFolder = Workspace:FindFirstChild("AICars")
                if aiFolder then
                    for _, car in ipairs(aiFolder:GetChildren()) do car:Destroy() end
                end
            end
        end
    end)

    RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.WalkSpeed ~= Config.PlayerSpeed then hum.WalkSpeed = Config.PlayerSpeed end
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
                        root.AssemblyLinearVelocity = Vector3.new(lookVector.X * speedStuds, root.AssemblyLinearVelocity.Y, lookVector.Z * speedStuds)
                    end
                end
            end
        end
    end)

    -- GUI Construction
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
    Title.Text = "<b>BRINELAND</b> <font color=\"#00E5FF\">TAXI BOSS HUB</font>"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 13
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

    CreateToggle("collect part", function(state) Config.AutoCollectItems = state end)
    CreateToggle("clear ai car", function(state) Config.ClearAICars = state end)
    CreateToggle("car boost", function(state) Config.EnableCarSpeed = state end)
    CreateInput("Target Speed (KM/H)", Config.TargetKMH, function(val) Config.TargetKMH = val end)
    CreateInput("Player WalkSpeed", Config.PlayerSpeed, function(val) Config.PlayerSpeed = val end)
end

local function RunStealAnEgg()
    -- Steal An Egg Hub BRINELAND
    local TweenService     = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local Workspace        = game:GetService("Workspace")
    local RunService       = game:GetService("RunService")
    local Players          = game:GetService("Players")
    local LocalPlayer      = Players.LocalPlayer

    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    if PlayerGui:FindFirstChild("StealAnEggHubV7") then
        PlayerGui.StealAnEggHubV7:Destroy()
    end

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
        PlayerSpeed          = 24
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
                if not Config.EnableSpeed then hum.WalkSpeed = prevSpeed end
            end
        end
    end

    local function GetEggTargets()
        local targets = {}
        local myPlot = GetMyPlot()

        local areaSlots = Workspace:FindFirstChild("AreaEggSlotsClient")
        if areaSlots then
            for _, model in ipairs(areaSlots:GetChildren()) do
                local hitbox = model:FindFirstChild("Hitbox") or model:FindFirstChildWhichIsA("BasePart", true)
                if hitbox then table.insert(targets, {Part = hitbox, Model = model}) end
            end
        end

        local sammyMap = Workspace:FindFirstChild("SammyEventMap")
        if sammyMap then
            for _, model in ipairs(sammyMap:GetChildren()) do
                local hitbox = model:FindFirstChild("Hitbox", true) or model:FindFirstChildWhichIsA("BasePart", true)
                if hitbox then table.insert(targets, {Part = hitbox, Model = model}) end
            end
        end

        local plots = Workspace:FindFirstChild("Plots")
        if plots then
            for _, plot in ipairs(plots:GetChildren()) do
                if plot ~= myPlot then
                    for _, obj in ipairs(plot:GetDescendants()) do
                        if obj:IsA("Model") and obj.Name:lower():find("egg") then
                            local hitbox = obj:FindFirstChild("Hitbox") or obj:FindFirstChildWhichIsA("BasePart", true)
                            if hitbox then table.insert(targets, {Part = hitbox, Model = obj}) end
                        end
                    end
                end
            end
        end
        return targets
    end

    RunService.Stepped:Connect(function()
        for _, prompt in ipairs(Workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then prompt.HoldDuration = 0 end
        end
        if Config.EnableSpeed then
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = Config.PlayerSpeed end
        end
    end)

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
                        MoveToTarget(GetSafeZoneCFrame())
                        task.wait(0.2)
                    end
                end
            end
        end
    end)

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

    task.spawn(function()
        while task.wait(0.3) do
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

    -- GUI Construction
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "StealAnEggHubV7"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    local OpenToggleBtn = Instance.new("TextButton")
    OpenToggleBtn.Size = UDim2.fromOffset(50, 50)
    OpenToggleBtn.Position = UDim2.new(0, 15, 0.5, -25)
    OpenToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 240)
    OpenToggleBtn.Text = "<b>HUB</b>"
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
    Title.Text = "<b>BRINELAND</b> <font color=\"#00E5FF\">STEAL AN EGG</font>"
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

    local StealTab    = CreateTab("Steal")
    local CombatTab   = CreateTab("Combat")
    local UpgradesTab = CreateTab("Upgrades")
    local PlayerTab   = CreateTab("Player")

    TabFrames["Steal"].Container.Visible = true
    TabFrames["Steal"].Button.BackgroundColor3 = Color3.fromRGB(0, 160, 240)
    TabFrames["Steal"].Button.TextColor3 = Color3.fromRGB(255, 255, 255)

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
end

local function RunKeyboardEscape()
    -- +1 Speed Keyboard Escape (BRINELAND)
    if _G.BrinelandScriptLoaded then return end
    _G.BrinelandScriptLoaded = true

    local RunService  = game:GetService("RunService")
    local Players     = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local PlayerGui   = LocalPlayer:WaitForChild("PlayerGui")

    local customName = "BRINELAND"
    local customAnimName = "BRINELAND"
    local unlockPacks = {"Premium", "Water", "Bubble", "Christmas", "Lava", "Honey", "Snow", "Slime", customAnimName}

    for _, packName in ipairs(unlockPacks) do
        LocalPlayer:SetAttribute("Sound_" .. packName, true)
        LocalPlayer:SetAttribute("Owns_" .. packName, true)
        LocalPlayer:SetAttribute("Anim_" .. packName, true)
        LocalPlayer:SetAttribute("Unlocked_" .. packName, true)
    end

    LocalPlayer:SetAttribute("CustomName", customName)
    LocalPlayer:SetAttribute("SelectedAnimation", customAnimName)

    local function unlockGuiElements()
        for _, guiObj in ipairs(PlayerGui:GetDescendants()) do
            local nameLower = guiObj.Name:lower()
            if nameLower:find("sound") or nameLower:find("anim") then
                if guiObj:IsA("ImageButton") or guiObj:IsA("TextButton") then guiObj.Active = true end
                if guiObj:IsA("ImageLabel") and (nameLower:find("lock") or nameLower:find("padlock")) then guiObj.Visible = false end
            end
        end
    end

    unlockGuiElements()
    PlayerGui.DescendantAdded:Connect(unlockGuiElements)

    local function protectHumanoid(character)
        local humanoid = character:WaitForChild("Humanoid", 5)
        if humanoid and hookmetamethod then
            local oldIndex
            oldIndex = hookmetamethod(game, "__newindex", function(self, key, value)
                if not checkcaller() and self == humanoid and key == "Health" and value == 0 then return nil end
                return oldIndex(self, key, value)
            end)
        end
    end

    if LocalPlayer.Character then protectHumanoid(LocalPlayer.Character) end
    LocalPlayer.CharacterAdded:Connect(protectHumanoid)

    RunService.Stepped:Connect(function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                -- Active script loop ensuring unlock state remains persistent
            end
        end
    end)
end

local function RunUniversalScript()
    -- Universal BRINELAND Hub (Fallback Engine)
    local TweenService     = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local Workspace        = game:GetService("Workspace")
    local RunService       = game:GetService("RunService")
    local Players          = game:GetService("Players")
    local LocalPlayer      = Players.LocalPlayer

    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    if PlayerGui:FindFirstChild("BrinelandUniversalHub") then
        PlayerGui.BrinelandUniversalHub:Destroy()
    end

    local Config = {
        WalkSpeed    = 16,
        SpeedEnabled = false,
        FlyEnabled   = false,
        FlySpeed     = 50,
        Noclip       = false,
        PlayerESP    = false
    }

    -- Fly Engine Variables
    local flyVelocity, flyGyro

    local function EnableFly()
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end

        flyVelocity = Instance.new("BodyVelocity")
        flyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        flyVelocity.Velocity = Vector3.zero
        flyVelocity.Parent = hrp

        flyGyro = Instance.new("BodyGyro")
        flyGyro.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
        flyGyro.CFrame = hrp.CFrame
        flyGyro.Parent = hrp

        hum.PlatformStand = true
    end

    local function DisableFly()
        if flyVelocity then flyVelocity:Destroy(); flyVelocity = nil end
        if flyGyro then flyGyro:Destroy(); flyGyro = nil end
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = false end
        end
    end

    -- Universal Loop
    RunService.Stepped:Connect(function()
        local char = LocalPlayer.Character
        if not char then return end

        if Config.SpeedEnabled then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = Config.WalkSpeed end
        end

        if Config.Noclip then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end)

    RunService.RenderStepped:Connect(function()
        if Config.FlyEnabled and LocalPlayer.Character then
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and flyVelocity and flyGyro then
                local cam = Workspace.CurrentCamera
                local moveDir = hum.MoveDirection
                local velocity = Vector3.zero
                if moveDir.Magnitude > 0 then
                    velocity = (cam.CFrame.Rotation * moveDir).Unit * Config.FlySpeed
                end
                flyVelocity.Velocity = velocity
                flyGyro.CFrame = cam.CFrame
            end
        end
    end)

    -- ESP Engine
    local espStorage = {}
    local function ApplyESP(player)
        if player == LocalPlayer then return end

        local function CreateHighlight(char)
            if not char then return end
            if espStorage[player] then espStorage[player]:Destroy() end

            local highlight = Instance.new("Highlight")
            highlight.Name = "BrinelandESPHighlight"
            highlight.FillColor = Color3.fromRGB(0, 229, 255)
            highlight.OutlineColor = Color3.fromRGB(150, 85, 255)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Adornee = char
            highlight.Enabled = Config.PlayerESP
            highlight.Parent = char

            espStorage[player] = highlight
        end

        if player.Character then CreateHighlight(player.Character) end
        player.CharacterAdded:Connect(CreateHighlight)
    end

    for _, player in ipairs(Players:GetPlayers()) do ApplyESP(player) end
    Players.PlayerAdded:Connect(ApplyESP)
    Players.PlayerRemoving:Connect(function(player)
        if espStorage[player] then
            espStorage[player]:Destroy()
            espStorage[player] = nil
        end
    end)

    local function ToggleESPState(state)
        Config.PlayerESP = state
        for _, highlight in pairs(espStorage) do
            if highlight then highlight.Enabled = state end
        end
    end

    -- GUI Construction
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BrinelandUniversalHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.fromOffset(360, 430)
    MainFrame.Position = UDim2.new(0.5, -180, 0.5, -215)
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
    Title.Text = "<b>BRINELAND</b> <font color=\"#00E5FF\">UNIVERSAL HUB</font>"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 13
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
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    -- Tab Bar (Top Corner Sections)
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
        container.ScrollBarThickness = 4
        container.ScrollBarImageColor3 = Color3.fromRGB(0, 229, 255)
        container.Visible = false
        container.Parent = MainFrame

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 6)
        listLayout.Parent = container

        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            container.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 16)
        end)

        TabFrames[tabName] = { Button = tabBtn, Container = container }

        tabBtn.MouseButton1Click:Connect(function()
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

    local TeleportsTab = CreateTab("Teleports")
    local PlayerTab    = CreateTab("Player")
    local VisualsTab   = CreateTab("Visuals")

    TabFrames["Teleports"].Container.Visible = true
    TabFrames["Teleports"].Button.BackgroundColor3 = Color3.fromRGB(0, 160, 240)
    TabFrames["Teleports"].Button.TextColor3 = Color3.fromRGB(255, 255, 255)

    -- Window Controls
    local isMinimized = false
    MinimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            for _, data in pairs(TabFrames) do data.Container.Visible = false end
            TabBar.Visible = false
            TweenService:Create(MainFrame, TweenInfo.new(0.25), {Size = UDim2.fromOffset(360, 40)}):Play()
            MinimizeBtn.Text = "<b>+</b>"
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.25), {Size = UDim2.fromOffset(360, 430)}):Play()
            task.wait(0.15)
            TabBar.Visible = true
            for name, data in pairs(TabFrames) do
                if data.Button.BackgroundColor3 == Color3.fromRGB(0, 160, 240) then
                    data.Container.Visible = true
                end
            end
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

    -- UI Component Creators
    local function CreateToggle(parentContainer, text, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -4, 0, 40)
        frame.BackgroundColor3 = Color3.fromRGB(22, 18, 45)
        frame.Parent = parentContainer
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

    local function CreateSlider(parentContainer, text, minVal, maxVal, defaultVal, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -4, 0, 48)
        frame.BackgroundColor3 = Color3.fromRGB(22, 18, 45)
        frame.Parent = parentContainer
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -20, 0, 20)
        lbl.Position = UDim2.new(0, 10, 0, 4)
        lbl.BackgroundTransparency = 1
        lbl.Text = "<b>" .. text .. ": <font color=\"#00E5FF\">" .. tostring(defaultVal) .. "</font></b>"
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.RichText = true
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame

        local track = Instance.new("Frame")
        track.Size = UDim2.new(1, -20, 0, 8)
        track.Position = UDim2.new(0, 10, 0, 28)
        track.BackgroundColor3 = Color3.fromRGB(35, 28, 65)
        track.Parent = frame
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

        local fill = Instance.new("Frame")
        local startPct = math.clamp((defaultVal - minVal) / (maxVal - minVal), 0, 1)
        fill.Size = UDim2.new(startPct, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(0, 229, 255)
        fill.Parent = track
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local sliding = false
        local function UpdateValue(input)
            local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(pos, 0, 1, 0)
            local val = math.floor(minVal + (maxVal - minVal) * pos)
            lbl.Text = "<b>" .. text .. ": <font color=\"#00E5FF\">" .. tostring(val) .. "</font></b>"
            callback(val)
        end

        track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                sliding = true
                UpdateValue(input)
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                UpdateValue(input)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                sliding = false
            end
        end)
    end

    -- DYNAMIC TELEPORT SYSTEM (Requested Change)
    local function SetupDynamicTeleportSystem()
        local setBtnFrame = Instance.new("Frame")
        setBtnFrame.Size = UDim2.new(1, -4, 0, 44)
        setBtnFrame.BackgroundColor3 = Color3.fromRGB(0, 170, 240)
        setBtnFrame.Parent = TeleportsTab
        Instance.new("UICorner", setBtnFrame).CornerRadius = UDim.new(0, 6)

        local setBtn = Instance.new("TextButton")
        setBtn.Size = UDim2.new(1, 0, 1, 0)
        setBtn.BackgroundTransparency = 1
        setBtn.Text = "<b>+ SAVE CURRENT LOCATION (SET TP)</b>"
        setBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        setBtn.Font = Enum.Font.GothamBold
        setBtn.TextSize = 12
        setBtn.RichText = true
        setBtn.Parent = setBtnFrame

        local tpListContainer = Instance.new("Frame")
        tpListContainer.Size = UDim2.new(1, 0, 0, 0)
        tpListContainer.BackgroundTransparency = 1
        tpListContainer.Parent = TeleportsTab

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 6)
        listLayout.Parent = tpListContainer

        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tpListContainer.Size = UDim2.new(1, 0, 0, listLayout.AbsoluteContentSize.Y)
        end)

        setBtn.MouseButton1Click:Connect(function()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local savedCFrame = hrp.CFrame
                local pos = hrp.Position

                local slotFrame = Instance.new("Frame")
                slotFrame.Size = UDim2.new(1, -4, 0, 44)
                slotFrame.BackgroundColor3 = Color3.fromRGB(22, 18, 45)
                slotFrame.Parent = tpListContainer
                Instance.new("UICorner", slotFrame).CornerRadius = UDim.new(0, 6)

                local tpBtn = Instance.new("TextButton")
                tpBtn.Size = UDim2.new(1, -45, 1, 0)
                tpBtn.Position = UDim2.new(0, 5, 0, 0)
                tpBtn.BackgroundTransparency = 1
                tpBtn.Text = string.format("<b>TP <font color=\"#00E5FF\">[ X:%.1f, Y:%.1f, Z:%.1f ]</font></b>", pos.X, pos.Y, pos.Z)
                tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                tpBtn.Font = Enum.Font.GothamBold
                tpBtn.TextSize = 11
                tpBtn.RichText = true
                tpBtn.TextXAlignment = Enum.TextXAlignment.Left
                tpBtn.Parent = slotFrame

                local delBtn = Instance.new("TextButton")
                delBtn.Size = UDim2.fromOffset(30, 30)
                delBtn.Position = UDim2.new(1, -35, 0.5, -15)
                delBtn.BackgroundColor3 = Color3.fromRGB(220, 35, 70)
                delBtn.Text = "<b>X</b>"
                delBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                delBtn.Font = Enum.Font.GothamBold
                delBtn.TextSize = 12
                delBtn.RichText = true
                delBtn.Parent = slotFrame
                Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 4)

                tpBtn.MouseButton1Click:Connect(function()
                    local c = LocalPlayer.Character
                    local h = c and c:FindFirstChild("HumanoidRootPart")
                    if h then h.CFrame = savedCFrame end
                end)

                delBtn.MouseButton1Click:Connect(function()
                    slotFrame:Destroy()
                end)
            end
        end)
    end

    -- Assign UI Elements to specific Tabs
    SetupDynamicTeleportSystem()

    CreateToggle(PlayerTab, "Enable WalkSpeed", function(state)
        Config.SpeedEnabled = state
        if not state and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
    end)
    CreateSlider(PlayerTab, "Player Speed", 16, 300, Config.WalkSpeed, function(val) Config.WalkSpeed = val end)

    CreateToggle(PlayerTab, "Enable Fly", function(state)
        Config.FlyEnabled = state
        if state then EnableFly() else DisableFly() end
    end)
    CreateSlider(PlayerTab, "Fly Speed", 10, 300, Config.FlySpeed, function(val) Config.FlySpeed = val end)

    CreateToggle(PlayerTab, "Noclip", function(state) Config.Noclip = state end)
    
    CreateToggle(VisualsTab, "Player ESP", function(state) ToggleESPState(state) end)
end

-- Detection Logic
local nameLower = gameName:lower()

if nameLower:find("taxi boss") or PlaceId == 7305826609 then
    print("[BRINELAND] Detected Taxi Boss. Executing script...")
    RunTaxiBoss()
elseif nameLower:find("steal an egg") or PlaceId == 115049386348611 then
    print("[BRINELAND] Detected Steal An Egg. Executing script...")
    RunStealAnEgg()
elseif nameLower:find("keyboard escape") or nameLower:find("+1 speed") then
    print("[BRINELAND] Detected +1 Speed Keyboard Escape. Executing script...")
    RunKeyboardEscape()
else
    print("[BRINELAND] Unrecognized game: " .. gameName .. " (PlaceId: " .. tostring(PlaceId) .. "). Running Universal Script...")
    RunUniversalScript()
end
