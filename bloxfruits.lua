-- ============================================================
-- BRINELAND HUB - BLOX FRUITS ULTIMATE V3 (KILL AURA)
-- Repository: https://github.com/DCBHEROBRINE/BRINELAND-HUB.git
-- Discord: https://discord.gg/epWMbuXSN5
-- ============================================================

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace        = game:GetService("Workspace")
local RunService       = game:GetService("RunService")
local Lighting         = game:GetService("Lighting")
local Players          = game:GetService("Players")
local LocalPlayer      = Players.LocalPlayer

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild("BrinelandBloxFruitsHub") then
    PlayerGui.BrinelandBloxFruitsHub:Destroy()
end

-- Configuration Table
local Config = {
    EnableSpeed        = false,
    PlayerSpeed        = 50,
    EnableJump         = false,
    JumpPower          = 100,
    KillAura           = false,
    KillAuraRange      = 50,
    PlayerESP          = false,
    ShowPlayerInventory= false,
    IslandESP          = false,
    FruitESP           = false,
    AutoFruitTween     = false,
    AutoGacha          = false,
    RemoveGachaAnim    = false,
    KillBoss           = false,
    SelectedBoss       = "None",
    SelectedNPC        = "None",
    SelectedIsland     = "Jungle",
    SelectedPlayer     = "None",
    TweenSpeed         = 300
}

local activeTween = nil

local function StopTween()
    if activeTween then
        activeTween:Cancel()
        activeTween = nil
    end
end

local function TweenToCFrame(targetCFrame, speedOverride)
    StopTween()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local dist = (hrp.Position - targetCFrame.Position).Magnitude
    local speed = speedOverride or Config.TweenSpeed
    local duration = math.max(0.05, dist / math.max(10, speed))

    activeTween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame + Vector3.new(0, 3, 0)})
    activeTween:Play()
end

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

-- ============================================================
-- KILL AURA ENGINE
-- ============================================================
task.spawn(function()
    while task.wait(0.08) do
        if Config.KillAura then
            pcall(function()
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local tool = char and char:FindFirstChildOfClass("Tool")

                if hrp and tool then
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("Model") and obj ~= char then
                            local hum = obj:FindFirstChildOfClass("Humanoid")
                            local targetHrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")

                            if hum and hum.Health > 0 and targetHrp then
                                local distance = (targetHrp.Position - hrp.Position).Magnitude
                                if distance <= Config.KillAuraRange then
                                    pcall(function() tool:Activate() end)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ============================================================
-- DYNAMIC SPAWNED DETECTORS (BOSSES & NPCS)
-- ============================================================
local function GetSpawnedBosses()
    local spawnedBosses = {}
    local enemies = Workspace:FindFirstChild("Enemies") or Workspace
    for _, enemy in ipairs(enemies:GetChildren()) do
        if enemy:IsA("Model") then
            local hum = enemy:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                if enemy:FindFirstChild("Boss") or enemy.Name:find("Boss") or enemy.Name:find("King") or enemy.Name:find("Admiral") or enemy.Name:find("God") or enemy.Name:find("Lord") then
                    if not table.find(spawnedBosses, enemy.Name) then
                        table.insert(spawnedBosses, enemy.Name)
                    end
                end
            end
        end
    end
    if #spawnedBosses == 0 then table.insert(spawnedBosses, "No Boss Spawned") end
    return spawnedBosses
end

local function GetSpawnedNPCs()
    local spawnedNPCs = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and not Players:GetPlayerFromCharacter(obj) then
            local hum = obj:FindFirstChildOfClass("Humanoid")
            if hum and obj:FindFirstChild("Head") and not obj:IsDescendantOf(Workspace:FindFirstChild("Enemies") or Workspace) then
                if not table.find(spawnedNPCs, obj.Name) then
                    table.insert(spawnedNPCs, obj.Name)
                end
            end
        end
    end
    if #spawnedNPCs == 0 then table.insert(spawnedNPCs, "None") end
    return spawnedNPCs
end

-- ============================================================
-- GACHA, BOSS & FPS ENGINE
-- ============================================================
task.spawn(function()
    while task.wait(0.1) do
        if Config.RemoveGachaAnim then
            pcall(function()
                local mainGui = PlayerGui:FindFirstChild("Main")
                if mainGui then
                    local cutscene = mainGui:FindFirstChild("GachaCutscene") or mainGui:FindFirstChild("FruitGacha")
                    if cutscene then cutscene.Visible = false end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(2) do
        if Config.AutoGacha then
            pcall(function()
                local comms = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") or game:GetService("ReplicatedStorage")
                local commF = comms:FindFirstChild("CommF_")
                if commF then commF:InvokeServer("Cousin", "Buy") end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        if Config.KillBoss and Config.SelectedBoss ~= "No Boss Spawned" and Config.SelectedBoss ~= "None" then
            pcall(function()
                local char = LocalPlayer.Character
                local tool = char and char:FindFirstChildOfClass("Tool")
                local enemies = Workspace:FindFirstChild("Enemies") or Workspace
                local boss = enemies:FindFirstChild(Config.SelectedBoss)

                if boss then
                    local bossHrp = boss:FindFirstChild("HumanoidRootPart") or boss:FindFirstChildWhichIsA("BasePart")
                    local hum = boss:FindFirstChildOfClass("Humanoid")
                    if bossHrp and hum and hum.Health > 0 then
                        TweenToCFrame(bossHrp.CFrame * CFrame.new(0, 8, 0))
                        if tool then tool:Activate() end
                    end
                end
            end)
        end
    end
end)

local function ApplyFPSBoost()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("Part") or v:IsA("UnionOperation") or v:IsA("MeshPart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            elseif v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                v.Enabled = false
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v:Destroy()
            end
        end
    end)
end

-- ============================================================
-- ESP SYSTEMS
-- ============================================================
RunService.Stepped:Connect(function()
    local char = LocalPlayer.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            if Config.EnableSpeed then hum.WalkSpeed = Config.PlayerSpeed end
            if Config.EnableJump then hum.UseJumpPower = true hum.JumpPower = Config.JumpPower end
        end
    end
end)

local Islands = {
    ["Marine Starter"] = CFrame.new(2449, 7, 1145),
    ["Pirate Starter"] = CFrame.new(1062, 16, 1423),
    ["Jungle"]         = CFrame.new(-1249, 11, 381),
    ["Pirate Village"] = CFrame.new(-1140, 4, 3828),
    ["Desert"]         = CFrame.new(1062, 6, 4390),
    ["Frozen Village"] = CFrame.new(1198, 20, -1210),
    ["Marine Fortress"]= CFrame.new(-4884, 21, 4302),
    ["Skypiea"]        = CFrame.new(-4950, 715, -2611),
    ["Prison"]         = CFrame.new(4875, 5, 734),
    ["Colosseum"]      = CFrame.new(-1390, 7, -2900),
    ["Magma Village"]  = CFrame.new(-5315, 12, 8515),
    ["Fountain City"]  = CFrame.new(5128, 6, 4048)
}

local IslandESPFolder = Instance.new("Folder", Workspace)
IslandESPFolder.Name = "BrinelandIslandESP"
local IslandTags = {}

for name, cf in pairs(Islands) do
    local part = Instance.new("Part")
    part.Size = Vector3.new(1, 1, 1)
    part.CFrame = cf
    part.Anchored = true
    part.Transparency = 1
    part.CanCollide = false
    part.Parent = IslandESPFolder

    local bb = Instance.new("BillboardGui")
    bb.Adornee = part
    bb.Size = UDim2.fromOffset(160, 40)
    bb.AlwaysOnTop = true

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(0, 229, 255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.RichText = true
    lbl.Parent = bb
    bb.Parent = part

    IslandTags[name] = { Part = part, Label = lbl, Billboard = bb }
end

RunService.Heartbeat:Connect(function()
    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    for name, data in pairs(IslandTags) do
        if Config.IslandESP and myHrp then
            data.Billboard.Enabled = true
            local dist = math.floor((data.Part.Position - myHrp.Position).Magnitude)
            data.Label.Text = string.format("<b>🏝️ %s\n<font color=\"#FFFFFF\">[%dm]</font></b>", name, dist)
        else
            data.Billboard.Enabled = false
        end
    end
end)

local FruitESPStorage = {}
RunService.Heartbeat:Connect(function()
    if not Config.FruitESP then
        for _, v in pairs(FruitESPStorage) do if v then v:Destroy() end end
        FruitESPStorage = {}
        return
    end

    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Tool") or (obj:IsA("Model") and obj:FindFirstChild("Handle")) then
            if obj.Name:lower():find("fruit") or obj:FindFirstChild("Fruit") then
                local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                if handle and not FruitESPStorage[obj] then
                    local bb = Instance.new("BillboardGui")
                    bb.Adornee = handle
                    bb.Size = UDim2.fromOffset(140, 35)
                    bb.AlwaysOnTop = true

                    local lbl = Instance.new("TextLabel")
                    lbl.Size = UDim2.new(1, 0, 1, 0)
                    lbl.BackgroundTransparency = 1
                    lbl.Text = "<b>🍎 " .. obj.Name .. "</b>"
                    lbl.TextColor3 = Color3.fromRGB(255, 80, 80)
                    lbl.Font = Enum.Font.GothamBold
                    lbl.TextSize = 11
                    lbl.RichText = true
                    lbl.Parent = bb
                    bb.Parent = handle

                    FruitESPStorage[obj] = bb
                end
            end
        end
    end
end)

local ESPStorage = {}
local function RemovePlayerESP(player)
    if ESPStorage[player] then
        if ESPStorage[player].Connection then ESPStorage[player].Connection:Disconnect() end
        if ESPStorage[player].Highlight then ESPStorage[player].Highlight:Destroy() end
        if ESPStorage[player].Billboard then ESPStorage[player].Billboard:Destroy() end
        ESPStorage[player] = nil
    end
end

local function CreatePlayerESP(player)
    if player == LocalPlayer then return end
    local function CharacterAdded(char)
        RemovePlayerESP(player)
        if not char then return end
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        local hum = char:WaitForChild("Humanoid", 5)
        if not hrp or not hum then return end

        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.fromRGB(0, 229, 255)
        highlight.OutlineColor = Color3.fromRGB(150, 85, 255)
        highlight.FillTransparency = 0.5
        highlight.Adornee = char
        highlight.Enabled = Config.PlayerESP
        highlight.Parent = char

        local billboard = Instance.new("BillboardGui")
        billboard.Adornee = hrp
        billboard.Size = UDim2.fromOffset(180, 60)
        billboard.StudsOffset = Vector3.new(0, 4, 0)
        billboard.AlwaysOnTop = true

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, 0, 0.33, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = "<b>" .. player.DisplayName .. "</b>"
        nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        nameLabel.Font = Enum.Font.GothamBold
        nameLabel.TextSize = 11
        nameLabel.RichText = true
        nameLabel.Parent = billboard

        local infoLabel = Instance.new("TextLabel")
        infoLabel.Size = UDim2.new(1, 0, 0.33, 0)
        infoLabel.Position = UDim2.new(0, 0, 0.33, 0)
        infoLabel.BackgroundTransparency = 1
        infoLabel.TextColor3 = Color3.fromRGB(0, 229, 255)
        infoLabel.Font = Enum.Font.Gotham
        infoLabel.TextSize = 10
        infoLabel.RichText = true
        infoLabel.Parent = billboard

        local invLabel = Instance.new("TextLabel")
        invLabel.Size = UDim2.new(1, 0, 0.33, 0)
        invLabel.Position = UDim2.new(0, 0, 0.66, 0)
        invLabel.BackgroundTransparency = 1
        invLabel.TextColor3 = Color3.fromRGB(255, 215, 0)
        invLabel.Font = Enum.Font.GothamBold
        invLabel.TextSize = 9
        invLabel.RichText = true
        invLabel.Parent = billboard
        billboard.Parent = hrp

        local updateConn = RunService.Heartbeat:Connect(function()
            if not char.Parent or not hum or hum.Health <= 0 or not Config.PlayerESP then
                billboard.Enabled = false; highlight.Enabled = false
                return
            end
            local myChar = LocalPlayer.Character
            local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local dist = myHrp and math.floor((hrp.Position - myHrp.Position).Magnitude) or 0

            billboard.Enabled = true
            highlight.Enabled = true
            infoLabel.Text = string.format("<b>HP: %d/%d | Dist: %dm</b>", math.floor(hum.Health), math.floor(hum.MaxHealth), dist)

            if Config.ShowPlayerInventory then
                invLabel.Visible = true
                local tools = {}
                local equipped = char:FindFirstChildOfClass("Tool")
                if equipped then table.insert(tools, "⚔️" .. equipped.Name) end
                local backpack = player:FindFirstChild("Backpack")
                if backpack then
                    for _, item in ipairs(backpack:GetChildren()) do
                        if item:IsA("Tool") and #tools < 4 then table.insert(tools, item.Name) end
                    end
                end
                invLabel.Text = "<b>[Inv: " .. (#tools > 0 and table.concat(tools, ", ") or "Empty") .. "]</b>"
            else
                invLabel.Visible = false
            end
        end)
        ESPStorage[player] = { Highlight = highlight, Billboard = billboard, Connection = updateConn }
    end
    if player.Character then CharacterAdded(player.Character) end
    player.CharacterAdded:Connect(CharacterAdded)
end

for _, p in ipairs(Players:GetPlayers()) do CreatePlayerESP(p) end
Players.PlayerAdded:Connect(CreatePlayerESP)
Players.PlayerRemoving:Connect(RemovePlayerESP)

local function ToggleESPState(state)
    Config.PlayerESP = state
    for _, data in pairs(ESPStorage) do
        if data.Highlight then data.Highlight.Enabled = state end
        if data.Billboard then data.Billboard.Enabled = state end
    end
end

-- ============================================================
-- USER INTERFACE
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

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.fromOffset(370, 440)
MainFrame.Position = UDim2.new(0.5, -185, 0.5, -220)
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
        MainFrame:TweenSizeAndPosition(UDim2.fromOffset(370, 440), UDim2.new(0.5, -185, 0.5, -220), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.3, true)
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
Title.Size = UDim2.new(1, -85, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "<b>BRINELAND</b> <font color=\"#00E5FF\">BLOX FRUITS HUB</font>"
Title.TextColor3 = Color3.fromRGB(0, 225, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.RichText = true
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.fromOffset(26, 26)
MinimizeBtn.Position = UDim2.new(1, -62, 0.5, -13)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 40, 80)
MinimizeBtn.Text = "<b>–</b>"
MinimizeBtn.TextColor3 = Color3.fromRGB(0, 229, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 16
MinimizeBtn.RichText = true
MinimizeBtn.Parent = TopBar
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)

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
TabLayout.Padding = UDim.new(0, 2)
TabLayout.Parent = TabBar

local TabFrames = {}
local function CreateTab(tabName)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0.16, 0, 1, 0)
    tabBtn.BackgroundColor3 = Color3.fromRGB(24, 18, 42)
    tabBtn.Text = "<b>" .. tabName .. "</b>"
    tabBtn.TextColor3 = Color3.fromRGB(180, 180, 210)
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 9
    tabBtn.RichText = true
    tabBtn.Parent = TabBar
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 5)

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

local isMinimized = false
BindClick(MinimizeBtn, function()
    isMinimized = not isMinimized
    if isMinimized then
        for _, data in pairs(TabFrames) do data.Container.Visible = false end
        TabBar.Visible = false
        TweenService:Create(MainFrame, TweenInfo.new(0.25), {Size = UDim2.fromOffset(370, 40)}):Play()
        MinimizeBtn.Text = "<b>+</b>"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.25), {Size = UDim2.fromOffset(370, 440)}):Play()
        task.wait(0.15)
        TabBar.Visible = true
        for _, data in pairs(TabFrames) do
            if data.Button.BackgroundColor3 == Color3.fromRGB(0, 160, 240) then
                data.Container.Visible = true
            end
        end
        MinimizeBtn.Text = "<b>–</b>"
    end
end)

local MainTab    = CreateTab("Main")
local BossTab    = CreateTab("Boss")
local TeleTab    = CreateTab("Teleport")
local FruitTab   = CreateTab("Fruits")
local ServerTab  = CreateTab("Server")
local MiscTab    = CreateTab("Misc")

TabFrames["Main"].Container.Visible = true
TabFrames["Main"].Button.BackgroundColor3 = Color3.fromRGB(0, 160, 240)
TabFrames["Main"].Button.TextColor3 = Color3.fromRGB(255, 255, 255)

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

local function CreateToggle(parent, text, initialVal, callback)
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
    toggleBg.BackgroundColor3 = initialVal and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(45, 35, 65)
    toggleBg.Parent = frame
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(16, 16)
    knob.Position = initialVal and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = toggleBg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = frame

    local active = initialVal
    BindClick(btn, function()
        active = not active
        TweenService:Create(knob, TweenInfo.new(0.18), {Position = active and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
        TweenService:Create(toggleBg, TweenInfo.new(0.18), {BackgroundColor3 = active and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(45, 35, 65)}):Play()
        callback(active)
    end)
end

local function CreateSelector(parent, text, options, configKey)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 38)
    frame.BackgroundColor3 = Color3.fromRGB(22, 18, 38)
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.4, 0, 1, 0)
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
    btn.Size = UDim2.fromOffset(130, 24)
    btn.Position = UDim2.new(1, -136, 0.5, -12)
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
    return btn
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

local function CreateButton(parent, text, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 38)
    frame.BackgroundColor3 = Color3.fromRGB(0, 150, 220)
    frame.Parent = parent
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = "<b>" .. text .. "</b>"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.RichText = true
    btn.Parent = frame

    BindClick(btn, callback)
end

local function CreateInfoLabel(parent, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -4, 0, 28)
    lbl.BackgroundColor3 = Color3.fromRGB(20, 16, 35)
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(220, 220, 240)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.RichText = true
    lbl.Parent = parent
    Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 6)
    return lbl
end

-- ============================================================
-- POPULATE TABS
-- ============================================================
CreateToggle(MainTab, "Enable Kill Aura", Config.KillAura, function(state) Config.KillAura = state end)
CreateInput(MainTab, "Kill Aura Range (Studs)", "KillAuraRange")
CreateToggle(MainTab, "Auto Roll Gacha (Cousin)", Config.AutoGacha, function(state) Config.AutoGacha = state end)
CreateToggle(MainTab, "Remove Gacha Animation", Config.RemoveGachaAnim, function(state) Config.RemoveGachaAnim = state end)

local bossSelectorBtn = CreateSelector(BossTab, "Spawned Bosses", GetSpawnedBosses(), "SelectedBoss")
CreateButton(BossTab, "Refresh Spawned Bosses", function()
    local newList = GetSpawnedBosses()
    Config.SelectedBoss = newList[1] or "None"
    bossSelectorBtn.Text = "<b>" .. tostring(Config.SelectedBoss) .. "</b>"
end)
CreateToggle(BossTab, "Boss Kill (Auto Attack)", Config.KillBoss, function(state)
    Config.KillBoss = state
    if not state then StopTween() end
end)

local islandNames = {}
for name, _ in pairs(Islands) do table.insert(islandNames, name) end
CreateSelector(TeleTab, "Select Island", islandNames, "SelectedIsland")
CreateButton(TeleTab, "Tween to Selected Island", function()
    local islandCF = Islands[Config.SelectedIsland]
    if islandCF then TweenToCFrame(islandCF) end
end)

local npcSelectorBtn = CreateSelector(TeleTab, "Spawned NPCs", GetSpawnedNPCs(), "SelectedNPC")
CreateButton(TeleTab, "Tween to Selected NPC", function()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name == Config.SelectedNPC then
            local npcHrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
            if npcHrp then
                TweenToCFrame(npcHrp.CFrame)
                break
            end
        end
    end
end)

local function GetPlayerNames()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(list, p.Name) end
    end
    if #list == 0 then table.insert(list, "None") end
    return list
end

CreateSelector(TeleTab, "Select Player", GetPlayerNames(), "SelectedPlayer")
CreateButton(TeleTab, "Tween to Selected Player", function()
    local targetPlayer = Players:FindFirstChild(Config.SelectedPlayer)
    if targetPlayer and targetPlayer.Character then
        local targetHrp = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        if targetHrp then TweenToCFrame(targetHrp.CFrame) end
    end
end)

CreateToggle(FruitTab, "Fruit ESP (See Fruits)", Config.FruitESP, function(state) Config.FruitESP = state end)
CreateToggle(FruitTab, "Auto Tween to Spawned Fruit", Config.AutoFruitTween, function(state) Config.AutoFruitTween = state end)
CreateButton(FruitTab, "Tween to Nearest Fruit NOW", function()
    for _, obj in ipairs(Workspace:GetChildren()) do
        local handle = obj:FindFirstChild("Handle") or (obj:IsA("Model") and obj:FindFirstChildWhichIsA("BasePart"))
        if handle and (obj.Name:lower():find("fruit") or obj:FindFirstChild("Fruit")) then
            TweenToCFrame(handle.CFrame)
            break
        end
    end
end)

local UptimeLabel  = CreateInfoLabel(ServerTab, "Server Uptime: 0m")
local PlayersLabel = CreateInfoLabel(ServerTab, "Players: 0/12")
local MoonLabel    = CreateInfoLabel(ServerTab, "Full Moon: 🔴 No")
local PrehisLabel  = CreateInfoLabel(ServerTab, "Prehistoric Island: 🔴 OFF")
local KitsuneLabel = CreateInfoLabel(ServerTab, "Kitsune Island: 🔴 OFF")
local MirageLabel  = CreateInfoLabel(ServerTab, "Mirage Island: 🔴 OFF")

task.spawn(function()
    while task.wait(2) do
        pcall(function()
            local uptime = math.floor(workspace.DistributedGameTime / 60)
            UptimeLabel.Text = string.format("<b>Server Uptime: <font color=\"#00E5FF\">%dm</font></b>", uptime)
            PlayersLabel.Text = string.format("<b>Players: <font color=\"#00E5FF\">%d/%d</font></b>", #Players:GetPlayers(), Players.MaxPlayers)

            local isFullMoon = (Lighting:FindFirstChild("Sky") and Lighting.Sky.MoonTextureId == "rbxassetid://97091490") or (Lighting.ClockTime >= 18 or Lighting.ClockTime <= 5)
            MoonLabel.Text = isFullMoon and "<b>Full Moon: <font color=\"#00FF88\">🟢 Active</font></b>" or "<b>Full Moon: <font color=\"#FF3366\">🔴 Inactive</font></b>"

            local prehis = Workspace:FindFirstChild("PrehistoricIsland") or Workspace:FindFirstChild("Prehistoric")
            PrehisLabel.Text = prehis and "<b>Prehistoric Island: <font color=\"#00FF88\">🟢 ON</font></b>" or "<b>Prehistoric Island: <font color=\"#FF3366\">🔴 OFF</font></b>"

            local kitsune = Workspace:FindFirstChild("KitsuneIsland") or Workspace:FindFirstChild("Kitsune")
            KitsuneLabel.Text = kitsune and "<b>Kitsune Island: <font color=\"#00FF88\">🟢 ON</font></b>" or "<b>Kitsune Island: <font color=\"#FF3366\">🔴 OFF</font></b>"

            local mirage = Workspace:FindFirstChild("MirageIsland") or Workspace:FindFirstChild("Mirage")
            MirageLabel.Text = mirage and "<b>Mirage Island: <font color=\"#00FF88\">🟢 ON</font></b>" or "<b>Mirage Island: <font color=\"#FF3366\">🔴 OFF</font></b>"
        end)
    end
end)

CreateButton(MiscTab, "🚀 BOOST FPS NOW", function() ApplyFPSBoost() end)
CreateToggle(MiscTab, "Island ESP (Names & Distances)", Config.IslandESP, function(state) Config.IslandESP = state end)
CreateToggle(MiscTab, "Player ESP", Config.PlayerESP, function(state) ToggleESPState(state) end)
CreateToggle(MiscTab, "Show Player Inventory / Hotbar", Config.ShowPlayerInventory, function(state) Config.ShowPlayerInventory = state end)
CreateToggle(MiscTab, "Enable Speed Boost", Config.EnableSpeed, function(state) Config.EnableSpeed = state end)
CreateToggle(MiscTab, "Enable Jump Boost", Config.EnableJump, function(state) Config.EnableJump = state end)

print("[BRINELAND] Ultimate Blox Fruits Hub V3 Loaded Successfully!")
