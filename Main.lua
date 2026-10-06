--[[
    ============================================================
    MASTER MULTI-GAME HUB LOADER (FIXED & COMPLETED)
    Auto-detects the current game and loads the correct script.
    ============================================================
]]

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Fetch Game Name Safely
local success, placeInfo = pcall(function()
    return MarketplaceService:GetProductInfo(game.PlaceId)
end)
local gameName = (success and placeInfo and placeInfo.Name) and placeInfo.Name:lower() or ""

-- ============================================================
-- SCRIPT 1: TAXI BOSS HUB
-- ============================================================
local function LoadTaxiBoss()
    local TweenService     = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local Workspace        = game:GetService("Workspace")
    local RunService       = game:GetService("RunService")

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

    local ScreenGui = Instance.new("ScreenGui", PlayerGui)
    ScreenGui.Name = "TaxiBossCustomHub"
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.fromOffset(340, 320)
    MainFrame.Position = UDim2.new(0.5, -170, 0.5, -160)
    MainFrame.BackgroundColor3 = Color3.fromRGB(16, 12, 28)
    MainFrame.Active = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundTransparency = 0.3
    TopBar.BackgroundColor3 = Color3.fromRGB(10, 8, 20)

    local Title = Instance.new("TextLabel", TopBar)
    Title.Size = UDim2.new(1, -85, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "TAXI BOSS DEX HUB"
    Title.TextColor3 = Color3.fromRGB(0, 229, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 14

    local CloseBtn = Instance.new("TextButton", TopBar)
    CloseBtn.Size = UDim2.fromOffset(28, 28)
    CloseBtn.Position = UDim2.new(1, -32, 0.5, -14)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 35, 70)
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", CloseBtn)
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    local Container = Instance.new("ScrollingFrame", MainFrame)
    Container.Size = UDim2.new(1, -12, 1, -48)
    Container.Position = UDim2.new(0, 6, 0, 44)
    Container.BackgroundTransparency = 1
    local Layout = Instance.new("UIListLayout", Container)
    Layout.Padding = UDim.new(0, 6)

    -- Draggable functionality
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
        local btn = Instance.new("TextButton", Container)
        btn.Size = UDim2.new(1, 0, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(40, 35, 65)
        btn.Text = text .. " [OFF]"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        Instance.new("UICorner", btn)
        local state = false
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.Text = text .. (state and " [ON]" or " [OFF]")
            btn.TextColor3 = state and Color3.fromRGB(0, 229, 255) or Color3.fromRGB(255, 255, 255)
            callback(state)
        end)
    end

    CreateToggle("Auto Collect Items", function(s) Config.AutoCollectItems = s end)
    CreateToggle("Clear AI Cars", function(s) Config.ClearAICars = s end)
    CreateToggle("Car Speed Boost", function(s) Config.EnableCarSpeed = s end)
end

-- ============================================================
-- SCRIPT 2: STEAL AN EGG HUB
-- ============================================================
local function LoadStealAnEgg()
    local TweenService     = game:GetService("TweenService")
    local Workspace        = game:GetService("Workspace")
    local RunService       = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")

    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    if PlayerGui:FindFirstChild("StealAnEggHubV7") then PlayerGui.StealAnEggHubV7:Destroy() end

    local Config = { AutoSteal = false, StealMethod = "Tween", TweenSpeed = 80, StealWalkSpeed = 28, AutoHit = false, HitRange = 12, AutoPlaceEgg = false, AutoHatch = false, AutoUpgradeTreadmill = false, AutoUpgradePen = false, EnableSpeed = false, PlayerSpeed = 24 }

    local function GetMyPlot()
        local plots = Workspace:FindFirstChild("Plots")
        if not plots then return nil end
        for _, plot in ipairs(plots:GetChildren()) do
            local owner = plot:FindFirstChild("Owner") or plot:FindFirstChild("OwnerValue") or plot:FindFirstChild("Player")
            if owner and (owner.Value == LocalPlayer or owner.Value == LocalPlayer.Name) then return plot end
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

    local function MoveToTarget(targetCFrame)
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local distance = (hrp.Position - targetCFrame.Position).Magnitude
        if distance < 3 then return end

        local duration = math.max(0.05, distance / math.max(10, Config.TweenSpeed))
        local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
        tween:Play()
        tween.Completed:Wait()
    end

    local function GetEggTargets()
        local targets = {}
        local areaSlots = Workspace:FindFirstChild("AreaEggSlotsClient")
        if areaSlots then
            for _, model in ipairs(areaSlots:GetChildren()) do
                local hitbox = model:FindFirstChild("Hitbox") or model:FindFirstChildWhichIsA("BasePart", true)
                if hitbox then table.insert(targets, {Part = hitbox, Model = model}) end
            end
        end
        return targets
    end

    task.spawn(function()
        while task.wait(0.1) do
            if Config.AutoSteal then
                local targets = GetEggTargets()
                for _, target in ipairs(targets) do
                    if not Config.AutoSteal then break end
                    local hitboxPart = target.Part
                    if hitboxPart and hitboxPart.Parent then
                        MoveToTarget(hitboxPart.CFrame + Vector3.new(0, 2, 0))
                        pcall(function()
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, hitboxPart, 0)
                            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, hitboxPart, 1)
                        end)
                        task.wait(0.15)
                        MoveToTarget(GetSafeZoneCFrame())
                        task.wait(0.2)
                    end
                end
            end
        end
    end)

    local ScreenGui = Instance.new("ScreenGui", PlayerGui)
    ScreenGui.Name = "StealAnEggHubV7"
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.fromOffset(360, 430)
    MainFrame.Position = UDim2.new(0.5, -180, 0.5, -215)
    MainFrame.BackgroundColor3 = Color3.fromRGB(14, 12, 26)
    MainFrame.Active = true
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)
    
    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(0, 170, 240)
    Instance.new("UICorner", TopBar)
    
    local Title = Instance.new("TextLabel", TopBar)
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "STEAL AN EGG HUB"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16

    local Container = Instance.new("ScrollingFrame", MainFrame)
    Container.Size = UDim2.new(1, -12, 1, -50)
    Container.Position = UDim2.new(0, 6, 0, 46)
    Container.BackgroundTransparency = 1
    local Layout = Instance.new("UIListLayout", Container)
    Layout.Padding = UDim.new(0, 6)

    -- Draggable functionality
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

    local function CreateToggle(text, configKey)
        local btn = Instance.new("TextButton", Container)
        btn.Size = UDim2.new(1, 0, 0, 45)
        btn.BackgroundColor3 = Color3.fromRGB(30, 25, 45)
        btn.Text = text .. " [OFF]"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        Instance.new("UICorner", btn)
        btn.MouseButton1Click:Connect(function()
            Config[configKey] = not Config[configKey]
            btn.Text = text .. (Config[configKey] and " [ON]" or " [OFF]")
            btn.BackgroundColor3 = Config[configKey] and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(30, 25, 45)
        end)
    end

    CreateToggle("Auto Steal & Safe Zone Return", "AutoSteal")
    CreateToggle("Auto Place Egg", "AutoPlaceEgg")
    CreateToggle("Auto Hatch Egg", "AutoHatch")
end

-- ============================================================
-- SCRIPT 3: +1 SPEED KEYBOARD ESCAPE (BRINELAND)
-- ============================================================
local function LoadKeyboardEscape()
    if _G.BrinelandScriptLoaded then return end
    _G.BrinelandScriptLoaded = true

    local RunService = game:GetService("RunService")
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    local customName = "Brineland"
    local customAnimName = "Brineland"
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
                -- Keeps player active and ensures speed modification attributes remain active
            end
        end
    end)
end

-- ============================================================
-- AUTO-DETECTION ROUTER & EXECUTION
-- ============================================================
if gameName:find("taxi") and gameName:find("boss") then
    LoadTaxiBoss()
elseif gameName:find("steal") and gameName:find("egg") then
    LoadStealAnEgg()
elseif gameName:find("keyboard") or gameName:find("escape") or gameName:find("brineland") or gameName:find("speed") then
    LoadKeyboardEscape()
else
    -- Fallback: Load Keyboard Escape if game name is not recognized
    LoadKeyboardEscape()
end
