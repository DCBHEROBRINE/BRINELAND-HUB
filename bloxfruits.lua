-- =====================================================================
-- BLOX FRUITS FIRST SEA MASTER AUTO-FARM SCRIPT
-- Integrated with Safe UI Validation, Level Tracking, and Coordinates
-- =====================================================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer

-- Configuration Settings
getgenv().AutoFarmSettings = {
    Enabled = true,
    SelectWeapon = "Melee", -- Change to Melee, Sword, or Blox Fruit
    TweenSpeed = 350,       -- Adjust travel speed
    AutoHaki = true,
}

-- Remotes & Workspace Folders
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
local CommF_ = Remotes and Remotes:WaitForChild("CommF_", 10)
local EnemiesFolder = workspace:WaitForChild("Enemies", 10)

-- UI Safe Initialization (Startup safety with timeouts)
local playerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
local mainGui = playerGui and playerGui:WaitForChild("Main", 10)

-- Helper: Get Character RootPart safely
local function getRootPart()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

-- Helper: Get Humanoid safely
local function getHumanoid()
    local char = LocalPlayer.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

-- Helper: Get Level Safely
local function getLevel()
    local success, data = pcall(function()
        return LocalPlayer:WaitForChild("Data", 3)
    end)
    if success and data then
        local lvl = data:FindFirstChild("Level")
        return lvl and lvl.Value or 1
    end
    return 1
end

-- First Sea Level Brackets mapped with your exact Quest Giver CFrames
local function getQuestData(level)
    if level >= 1 and level <= 9 then
        return "BanditQuest1", 1, "Bandit", CFrame.new(1059.37, 15.44, 1550.42)
    elseif level >= 10 and level <= 14 then
        return "JungleQuest", 1, "Monkey", CFrame.new(-1601.65, 36.85, 153.38)
    elseif level >= 15 and level <= 29 then
        return "JungleQuest", 2, "Gorilla", CFrame.new(-1601.65, 36.85, 153.38)
    elseif level >= 30 and level <= 59 then
        return "BuggyQuest1", 1, "Pirate", CFrame.new(-1900.22, 5.02, 4280.91)
    elseif level >= 60 and level <= 89 then
        return "DesertQuest", 1, "Desert Bandit", CFrame.new(903.62, 7.39, 4390.11)
    elseif level >= 90 and level <= 119 then
        return "SnowQuest", 1, "Snow Bandit", CFrame.new(1342.55, 38.21, -1355.22)
    elseif level >= 120 and level <= 174 then
        return "MarineQuest2", 1, "Chief Petty Officer", CFrame.new(-5035.88, 25.64, 4220.15)
    else
        return "SkyQuest", 1, "Sky Bandit", CFrame.new(-4840.33, 715.42, -2620.88)
    end
end

-- Robust Quest Info Checker (Uses FindFirstChild to prevent loop lag/freezing)
local function getActiveQuestInfo()
    if not mainGui then return nil, nil end
    local questFrame = mainGui:FindFirstChild("Quest")
    
    if questFrame and questFrame.Visible then
        local container = questFrame:FindFirstChild("Container") or questFrame:FindFirstChild("Content")
        if container then
            local titleLabel = container:FindFirstChild("QuestTitle")
            local progressLabel = container:FindFirstChild("QuestProgress")
            
            local title = titleLabel and titleLabel.Text or "Unknown"
            local progress = progressLabel and progressLabel.Text or "0/0"
            return title, progress
        end
    end
    return nil, nil
end

-- Smooth Tweening System
local activeTween = nil
local function TweenTo(targetCFrame)
    local rootPart = getRootPart()
    if not rootPart then return end

    if activeTween then activeTween:Cancel() end

    local distance = (rootPart.Position - targetCFrame.Position).Magnitude
    local speed = getgenv().AutoFarmSettings.TweenSpeed
    local timeTaken = distance / speed

    activeTween = TweenService:Create(rootPart, TweenInfo.new(timeTaken, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    activeTween:Play()
end

-- Weapon Equipping Manager
local function EquipWeapon()
    local char = LocalPlayer.Character
    if not char then return end
    local weaponType = getgenv().AutoFarmSettings.SelectWeapon
    
    for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.ToolTip == weaponType or (weaponType == "Melee" and tool.ToolTip == "Combat")) then
            local humanoid = getHumanoid()
            if humanoid then humanoid:EquipTool(tool) end
        end
    end
end

-- Background Task: Auto Buso Haki
task.spawn(function()
    while task.wait(1) do
        if getgenv().AutoFarmSettings.AutoHaki and LocalPlayer.Character then
            if not LocalPlayer.Character:FindFirstChild("HasBuso") then
                pcall(function()
                    if CommF_ then CommF_:InvokeServer("Buso") end
                end)
            end
        end
    end
end)

-- Background Task: Anti-AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- =====================================================================
-- MAIN RUNTIME LOOP
-- =====================================================================
task.spawn(function()
    while task.wait(0.1) do
        if not getgenv().AutoFarmSettings.Enabled then continue end

        local rootPart = getRootPart()
        local humanoid = getHumanoid()

        if rootPart and humanoid and humanoid.Health > 0 then
            EquipWeapon()

            local currentLevel = getLevel()
            local questName, questIndex, targetMob, npcCFrame = getQuestData(currentLevel)
            local questTitle, questProgress = getActiveQuestInfo()

            -- 1. If no active quest, tween to the Quest Giver NPC and accept it
            if not questTitle then
                TweenTo(npcCFrame)
                
                if (rootPart.Position - npcCFrame.Position).Magnitude < 15 then
                    pcall(function()
                        if CommF_ then
                            CommF_:InvokeServer("StartQuest", questName, questIndex)
                        end
                    end)
                    task.wait(1)
                end
            else
                -- 2. Quest is active! Find and farm the correct mob in workspace.Enemies
                local targetEnemy = nil
                local shortestDist = math.huge

                pcall(function()
                    for _, enemy in pairs(EnemiesFolder:GetChildren()) do
                        local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
                        local enemyHum = enemy:FindFirstChildOfClass("Humanoid")

                        if enemy.Name == targetMob and enemyRoot and enemyHum and enemyHum.Health > 0 then
                            local dist = (rootPart.Position - enemyRoot.Position).Magnitude
                            if dist < shortestDist then
                                shortestDist = dist
                                targetEnemy = enemy
                            end
                        end
                    end
                end)

                if targetEnemy then
                    local enemyRoot = targetEnemy:FindFirstChild("HumanoidRootPart")
                    if enemyRoot then
                        -- Position slightly above the target mob
                        TweenTo(enemyRoot.CFrame + Vector3.new(0, 5, 0))

                        -- Attack action
                        pcall(function()
                            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                            VirtualUser:ClickButton1(Vector2.new(800, 600), workspace.CurrentCamera.CFrame)
                        end)
                    end
                end
            end
        end
    end
end)

print("🚀 Blox Fruits Master First Sea Auto-Farm Loaded Successfully!")
