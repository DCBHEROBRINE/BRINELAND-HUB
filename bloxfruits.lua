-- ============================================================
-- BRINELAND BLOX FRUITS AUTO-FARM & SEA UNLOCKER
-- Loaded automatically via main.lua router
-- ============================================================

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage= game:GetService("ReplicatedStorage")
local Workspace        = game:GetService("Workspace")
local RunService       = game:GetService("RunService")
local Players          = game:GetService("Players")
local LocalPlayer      = Players.LocalPlayer

-- UI Guard
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild("BrinelandBloxFruits") then
    PlayerGui.BrinelandBloxFruits:Destroy()
end

-- Configurations
local Config = {
    AutoLevel       = false,
    AutoSea2        = false,
    AutoSea3        = false,
    TweenSpeed      = 280,
    FastAttack      = true,
    BringMobs       = true,
    BringRadius     = 50
}

-- Safe Character Get
local function GetCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function GetHRP()
    local char = GetCharacter()
    return char:WaitForChild("HumanoidRootPart", 5) or char.PrimaryPart
end

-- Teleport / Movement Helper
local function TweenTo(targetCFrame)
    local hrp = GetHRP()
    if not hrp then return end
    
    local dist = (hrp.Position - targetCFrame.Position).Magnitude
    if dist < 5 then
        hrp.CFrame = targetCFrame
        return
    end

    local duration = math.max(0.1, dist / Config.TweenSpeed)
    local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
end

-- Get Current Level
local function GetLevel()
    local data = LocalPlayer:FindFirstChild("Data")
    if data and data:FindFirstChild("Level") then
        return data.Level.Value
    end
    return 1
end

-- ============================================================
-- QUEST & ISLAND DATA ROUTER (Sea 1, Sea 2, Sea 3)
-- ============================================================
local function GetQuestData()
    local level = GetLevel()
    local placeId = game.PlaceId

    -- FIRST SEA (Level 1 - 700)
    if level < 700 then
        if level >= 1 and level < 15 then
            local team = LocalPlayer.Team and LocalPlayer.Team.Name or "Pirates"
            if team == "Marines" then
                return { QuestName = "MarineQuest", QuestLevel = 1, EnemyName = "Trainee", QuestCFrame = CFrame.new(-2708, 25, 2104), EnemyCFrame = CFrame.new(-2740, 25, 2120) }
            else
                return { QuestName = "BanditQuest1", QuestLevel = 1, EnemyName = "Bandit", QuestCFrame = CFrame.new(1059, 16, 1549), EnemyCFrame = CFrame.new(1145, 16, 1630) }
            end
        elseif level >= 15 and level < 30 then
            return { QuestName = "JungleQuest", QuestLevel = 1, EnemyName = "Monkey", QuestCFrame = CFrame.new(-1598, 36, 153), EnemyCFrame = CFrame.new(-1618, 36, 145) }
        elseif level >= 30 and level < 60 then
            return { QuestName = "BuggyQuest1", QuestLevel = 1, EnemyName = "Pirate", QuestCFrame = CFrame.new(-1140, 4, 3828), EnemyCFrame = CFrame.new(-1210, 4, 3910) }
        elseif level >= 60 and level < 90 then
            return { QuestName = "DesertQuest", QuestLevel = 1, EnemyName = "Desert Bandit", QuestCFrame = CFrame.new(894, 6, 4390), EnemyCFrame = CFrame.new(950, 6, 4450) }
        elseif level >= 90 and level < 120 then
            return { QuestName = "SnowQuest", QuestLevel = 1, EnemyName = "Snow Bandit", QuestCFrame = CFrame.new(1385, 87, -1298), EnemyCFrame = CFrame.new(1320, 87, -1350) }
        elseif level >= 120 and level < 150 then
            return { QuestName = "MarineTreeQuest", QuestLevel = 1, EnemyName = "Chief Petty Officer", QuestCFrame = CFrame.new(-5030, 20, 4320), EnemyCFrame = CFrame.new(-4920, 20, 4280) }
        elseif level >= 150 and level < 190 then
            return { QuestName = "SkyQuest1", QuestLevel = 1, EnemyName = "Sky Bandit", QuestCFrame = CFrame.new(-4840, 718, -2620), EnemyCFrame = CFrame.new(-4980, 718, -2570) }
        elseif level >= 190 and level < 225 then
            return { QuestName = "PrisonerQuest", QuestLevel = 1, EnemyName = "Prisoner", QuestCFrame = CFrame.new(530, 1, 470), EnemyCFrame = CFrame.new(480, 1, 520) }
        elseif level >= 225 and level < 300 then
            return { QuestName = "ColosseumQuest", QuestLevel = 1, EnemyName = "Toga Warrior", QuestCFrame = CFrame.new(-1580, 7, -2980), EnemyCFrame = CFrame.new(-1700, 7, -3050) }
        elseif level >= 300 and level < 375 then
            return { QuestName = "MagmaQuest", QuestLevel = 1, EnemyName = "Military Soldier", QuestCFrame = CFrame.new(-5310, 12, 8510), EnemyCFrame = CFrame.new(-5400, 12, 8580) }
        elseif level >= 375 and level < 450 then
            return { QuestName = "FishmanQuest", QuestLevel = 1, EnemyName = "Fishman Warrior", QuestCFrame = CFrame.new(61120, 18, 1560), EnemyCFrame = CFrame.new(61000, 18, 1500) }
        elseif level >= 450 and level < 625 then
            return { QuestName = "SkyQuest2", QuestLevel = 1, EnemyName = "God's Guard", QuestCFrame = CFrame.new(-7860, 5545, -380), EnemyCFrame = CFrame.new(-7720, 5545, -420) }
        elseif level >= 625 and level <= 700 then
            return { QuestName = "FountainQuest", QuestLevel = 1, EnemyName = "Corporal", QuestCFrame = CFrame.new(5250, 38, 4050), EnemyCFrame = CFrame.new(5120, 38, 4120) }
        end
    
    -- SECOND SEA (Level 700 - 1500)
    elseif level >= 700 and level < 1500 then
        if level >= 700 and level < 875 then
            return { QuestName = "Area1Quest", QuestLevel = 1, EnemyName = "Raider", QuestCFrame = CFrame.new(-425, 73, 1835), EnemyCFrame = CFrame.new(-550, 73, 1750) }
        elseif level >= 875 and level < 950 then
            return { QuestName = "Area2Quest", QuestLevel = 1, EnemyName = "Marine Lieutenant", QuestCFrame = CFrame.new(-2440, 73, -3210), EnemyCFrame = CFrame.new(-2560, 73, -3150) }
        elseif level >= 950 and level < 1000 then
            return { QuestName = "GraveyardQuest", QuestLevel = 1, EnemyName = "Zombie", QuestCFrame = CFrame.new(-5490, 48, -795), EnemyCFrame = CFrame.new(-5600, 48, -720) }
        elseif level >= 1000 and level < 1100 then
            return { QuestName = "SnowMountainQuest", QuestLevel = 1, EnemyName = "Snow Trooper", QuestCFrame = CFrame.new(610, 400, -5370), EnemyCFrame = CFrame.new(500, 400, -5450) }
        elseif level >= 1100 and level < 1250 then
            return { QuestName = "IceSideQuest", QuestLevel = 1, EnemyName = "Lab Subordinate", QuestCFrame = CFrame.new(-6060, 15, -4980), EnemyCFrame = CFrame.new(-5950, 15, -5100) }
        elseif level >= 1250 and level < 1350 then
            return { QuestName = "ShipQuest1", QuestLevel = 1, EnemyName = "Ship Deckhand", QuestCFrame = CFrame.new(1030, 125, 32900), EnemyCFrame = CFrame.new(1150, 125, 33000) }
        elseif level >= 1350 and level < 1425 then
            return { QuestName = "FrostQuest", QuestLevel = 1, EnemyName = "Arctic Warrior", QuestCFrame = CFrame.new(5560, 28, -6200), EnemyCFrame = CFrame.new(5700, 28, -6100) }
        elseif level >= 1425 and level < 1500 then
            return { QuestName = "ForgottenQuest", QuestLevel = 1, EnemyName = "Water Fighter", QuestCFrame = CFrame.new(-3050, 230, -10140), EnemyCFrame = CFrame.new(-3180, 230, -10250) }
        end

    -- THIRD SEA (Level 1500 - 2800)
    else
        if level >= 1500 and level < 1575 then
            return { QuestName = "PortTownQuest", QuestLevel = 1, EnemyName = "Pirate Millionaire", QuestCFrame = CFrame.new(-290, 44, 5580), EnemyCFrame = CFrame.new(-420, 44, 5650) }
        elseif level >= 1575 and level < 1700 then
            return { QuestName = "HydraTownQuest", QuestLevel = 1, EnemyName = "Dragon Crew Warrior", QuestCFrame = CFrame.new(5750, 610, -280), EnemyCFrame = CFrame.new(5880, 610, -350) }
        elseif level >= 1700 and level < 1775 then
            return { QuestName = "GreatTreeQuest", QuestLevel = 1, EnemyName = "Marine Commodore", QuestCFrame = CFrame.new(2180, 28, -6740), EnemyCFrame = CFrame.new(2300, 28, -6820) }
        elseif level >= 1775 and level < 1975 then
            return { QuestName = "TurtleQuest1", QuestLevel = 1, EnemyName = "Fishman Raider", QuestCFrame = CFrame.new(-10480, 330, -8800), EnemyCFrame = CFrame.new(-10600, 330, -8900) }
        elseif level >= 1975 and level < 2075 then
            return { QuestName = "HauntedQuest1", QuestLevel = 1, EnemyName = "Reborn Skeleton", QuestCFrame = CFrame.new(-9510, 140, 5530), EnemyCFrame = CFrame.new(-9620, 140, 5600) }
        elseif level >= 2075 and level < 2450 then
            return { QuestName = "PeanutQuest", QuestLevel = 1, EnemyName = "Peanut Scout", QuestCFrame = CFrame.new(-2120, 48, -10120), EnemyCFrame = CFrame.new(-2250, 48, -10200) }
        elseif level >= 2450 and level < 2600 then
            return { QuestName = "TikiQuest1", QuestLevel = 1, EnemyName = "Isle Outlaw", QuestCFrame = CFrame.new(-16530, 55, 300), EnemyCFrame = CFrame.new(-16680, 55, 420) }
        else
            return { QuestName = "SubmergedQuest", QuestLevel = 1, EnemyName = "Deepsea Abomination", QuestCFrame = CFrame.new(-18900, 20, 1200), EnemyCFrame = CFrame.new(-19050, 20, 1300) }
        end
    end
end

-- ============================================================
-- AUTO ATTACK & MOB BRING
-- ============================================================
local function AutoAttackTarget(targetMob)
    local char = GetCharacter()
    local hrp = GetHRP()
    if not char or not hrp or not targetMob or not targetMob:FindFirstChild("HumanoidRootPart") then return end

    -- Position hover slightly above mob to dodge ground hits
    hrp.CFrame = targetMob.HumanoidRootPart.CFrame * CFrame.new(0, 11, 0) * CFrame.Angles(math.rad(-90), 0, 0)

    -- Auto Equip Tool
    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.ToolTip == "Melee" or tool.ToolTip == "Blox Fruit" or tool.ToolTip == "Sword") then
            tool.Parent = char
            break
        end
    end

    -- Fast Attack Event Trigger
    if Config.FastAttack then
        pcall(function()
            local combatReg = ReplicatedStorage:FindFirstChild("RigControllerEvent") or ReplicatedStorage:FindFirstChild("Remotes")
            if combatReg then
                combatReg.FireServer(combatReg, "weaponAttack")
            else
                local tool = char:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end
        end)
    end

    -- Magnet/Bring nearby mobs
    if Config.BringMobs then
        for _, mob in ipairs(Workspace.Enemies:GetChildren()) do
            if mob.Name == targetMob.Name and mob:FindFirstChild("HumanoidRootPart") and mob ~= targetMob then
                if (mob.HumanoidRootPart.Position - targetMob.HumanoidRootPart.Position).Magnitude <= Config.BringRadius then
                    mob.HumanoidRootPart.CFrame = targetMob.HumanoidRootPart.CFrame
                    mob.HumanoidRootPart.CanCollide = false
                end
            end
        end
    end
end

-- ============================================================
-- AUTO SEA 2 & SEA 3 UNLOCK ROUTINE
-- ============================================================
local function CheckAndUnlockSeas()
    local level = GetLevel()

    -- Auto Sea 2 Progression (Level 700+)
    if level >= 700 and game.PlaceId == 2753915549 and Config.AutoSea2 then
        print("[BRINELAND] Starting Sea 2 Unlock Sequence...")
        -- Talk to Military Detective / Ice Admiral Boss Quest
        ReplicatedStorage.Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
        task.wait(1)
        TweenTo(CFrame.new(1385, 87, -1298)) -- Ice Castle Cave
        -- Trigger teleport to Sea 2 via Experienced Captain
        ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelDressrosa")
        return true
    end

    -- Auto Sea 3 Progression (Level 1500+)
    if level >= 1500 and game.PlaceId == 4442272183 and Config.AutoSea3 then
        print("[BRINELAND] Starting Sea 3 Unlock Sequence...")
        -- Talk to King Red Head / Rip_Indra Quest
        ReplicatedStorage.Remotes.CommF_:InvokeServer("ZilphaQuestProgress", "Begin")
        task.wait(1)
        ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelZilpha")
        return true
    end

    return false
end

-- Main Auto Level Loop
task.spawn(function()
    while task.wait(0.1) do
        if Config.AutoLevel then
            pcall(function()
                if CheckAndUnlockSeas() then return end

                local qData = GetQuestData()
                local questGui = LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
                
                -- Check if active quest matches expected level quest
                if not questGui or not questGui.Visible then
                    TweenTo(qData.QuestCFrame)
                    task.wait(0.2)
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", qData.QuestName, qData.QuestLevel)
                else
                    -- Search target enemy
                    local targetMob = nil
                    for _, enemy in ipairs(Workspace.Enemies:GetChildren()) do
                        if enemy.Name == qData.EnemyName and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChildOfClass("Humanoid").Health > 0 then
                            targetMob = enemy
                            break
                        end
                    end

                    if targetMob then
                        AutoAttackTarget(targetMob)
                    else
                        TweenTo(qData.EnemyCFrame)
                    end
                end
            end)
        end
    end
end)

-- ============================================================
-- GUI BUILDER
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrinelandBloxFruits"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.fromOffset(320, 290)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -145)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 28)
MainFrame.Active = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(0, 229, 255)
Stroke.Thickness = 1.5
Stroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 40)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "<b>BRINELAND</b> <font color=\"#00E5FF\">BLOX FRUITS HUB</font>"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.RichText = true
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.fromOffset(26, 26)
CloseBtn.Position = UDim2.new(1, -32, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 35, 70)
CloseBtn.Text = "<b>X</b>"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.RichText = true
CloseBtn.Parent = MainFrame
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -16, 1, -50)
Container.Position = UDim2.new(0, 8, 0, 44)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 3
Container.ScrollBarImageColor3 = Color3.fromRGB(0, 229, 255)
Container.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 6)
Layout.Parent = Container

local function CreateToggle(text, configKey)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 38)
    frame.BackgroundColor3 = Color3.fromRGB(24, 20, 44)
    frame.Parent = Container
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -50, 1, 0)
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
    toggleBg.Size = UDim2.fromOffset(38, 18)
    toggleBg.Position = UDim2.new(1, -44, 0.5, -9)
    toggleBg.BackgroundColor3 = Config[configKey] and Color3.fromRGB(0, 229, 255) or Color3.fromRGB(45, 38, 68)
    toggleBg.Parent = frame
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(14, 14)
    knob.Position = Config[configKey] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = toggleBg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = frame

    btn.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        local state = Config[configKey]
        TweenService:Create(knob, TweenInfo.new(0.18), {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
        TweenService:Create(toggleBg, TweenInfo.new(0.18), {BackgroundColor3 = state and Color3.fromRGB(0, 229, 255) or Color3.fromRGB(45, 38, 68)}):Play()
    end)
end

CreateToggle("Auto Farm Level (1 - 2800)", "AutoLevel")
CreateToggle("Auto Unlock Second Sea", "AutoSea2")
CreateToggle("Auto Unlock Third Sea", "AutoSea3")
CreateToggle("Fast Attack Speed", "FastAttack")
CreateToggle("Bring / Magnet Mobs", "BringMobs")
