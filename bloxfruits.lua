-- ============================================================
-- BRINELAND BLOX FRUITS 1-2800 DYNAMIC AUTO-FARM ENGINE
-- Repository: https://github.com/DCBHEROBRINE/BRINELAND-HUB.git
-- Loaded automatically via main.lua router
-- ============================================================

if not game:IsLoaded() then game.Loaded:Wait() end

local Players           = game:GetService("Players")
local TweenService       = game:GetService("TweenService")
local VirtualUser        = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local RunService         = game:GetService("RunService")
local UserInputService   = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer

-- GUI Cleanup
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild("BrinelandBloxFruits") then
    PlayerGui.BrinelandBloxFruits:Destroy()
end

-- Global Control Variables
getgenv().AutoFarm   = false
getgenv().FastAttack = true
getgenv().BringMob   = true
getgenv().AutoSea2   = false
getgenv().AutoSea3   = false
getgenv().TweenSpeed = 325

-- Anti-AFK Kick Protection
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- Safe Anti-Cheat Bypass Teleportation Method
local function TweenTo(targetCFrame)
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local root = char:WaitForChild("HumanoidRootPart", 5)
    if not root then return end
    
    local distance = (root.Position - targetCFrame.Position).Magnitude
    local speed = getgenv().TweenSpeed or 325
    local duration = distance / speed
    
    if distance < 20 then
        root.CFrame = targetCFrame
        return
    end
    
    local tween = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
end

-- Weapon Auto-Equip Helper
local function EquipWeapon()
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not char or not backpack then return end
    
    for _, tool in pairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.ToolTip == "Melee" or tool.ToolTip == "Sword" or tool.ToolTip == "Blox Fruit") then
            char.Humanoid:EquipTool(tool)
            break
        end
    end
end

-- Fast Attack Engine Loop
task.spawn(function()
    while task.wait(0.05) do
        pcall(function()
            if getgenv().FastAttack and getgenv().AutoFarm and LocalPlayer.Character then
                if LocalPlayer.Character:FindFirstChildOfClass("Tool") then
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                end
            end
        end)
    end
end)

-- Level Acquisition Helper
local function GetLevel()
    local data = LocalPlayer:FindFirstChild("Data")
    if data and data:FindFirstChild("Level") then
        return data.Level.Value
    end
    return 1
end

-- Dynamic Level & NPC Quest Router (Level 1 - 2800)
local function GetActiveQuestTarget()
    local myLevel = GetLevel()
    local targetQuest, targetMob, npcName
    
    -- FIRST SEA (Level 1 - 700)
    if myLevel < 10 then 
        targetQuest = "Bandits"; targetMob = "Bandit"; npcName = "Bandit Quest Giver"
    elseif myLevel < 15 then 
        targetQuest = "Monkeys"; targetMob = "Monkey"; npcName = "Monkey Quest Giver"
    elseif myLevel < 30 then 
        targetQuest = "Gorillas"; targetMob = "Gorilla"; npcName = "Monkey Quest Giver"
    elseif myLevel < 75 then 
        targetQuest = "Pirates"; targetMob = "Pirate"; npcName = "Pirate Village Quest Giver"
    elseif myLevel < 90 then 
        targetQuest = "Brutes"; targetMob = "Brute"; npcName = "Pirate Village Quest Giver"
    elseif myLevel < 120 then 
        targetQuest = "DesertBandits"; targetMob = "Desert Bandit"; npcName = "Desert Quest Giver"
    elseif myLevel < 250 then 
        targetQuest = "SnowBandits"; targetMob = "Snow Bandit"; npcName = "Snow Quest Giver"
    elseif myLevel < 430 then 
        targetQuest = "ChiefGally"; targetMob = "Chief Petty Officer"; npcName = "Marineford Quest Giver"
    elseif myLevel < 700 then 
        targetQuest = "FishmanCommandos"; targetMob = "Fishman Commando"; npcName = "Underwater Quest Giver"
    
    -- SECOND SEA (Level 700 - 1500)
    elseif myLevel < 875 then 
        targetQuest = "Raiders"; targetMob = "Raider"; npcName = "Kingdom of Rose Quest Giver"
    elseif myLevel < 1100 then 
        targetQuest = "SwanPirates"; targetMob = "Swan Pirate"; npcName = "Kingdom of Rose Quest Giver"
    elseif myLevel < 1350 then 
        targetQuest = "SnowSoldiers"; targetMob = "Snow Soldier"; npcName = "Snow Mountain Quest Giver"
    elseif myLevel < 1500 then 
        targetQuest = "WaterCommandos"; targetMob = "Water Commando"; npcName = "Forgotten Island Quest Giver"
    
    -- THIRD SEA (Level 1500 - 2800)
    elseif myLevel < 1775 then 
        targetQuest = "PistolBillionaires"; targetMob = "Pistol Billionaire"; npcName = "Floating Turtle Quest Giver"
    elseif myLevel < 2000 then 
        targetQuest = "MythologicalPirates"; targetMob = "Mythological Pirate"; npcName = "Floating Turtle Quest Giver"
    elseif myLevel < 2200 then 
        targetQuest = "CookiePirates"; targetMob = "Cookie Pirate"; npcName = "Ice Cream Land Quest Giver"
    elseif myLevel < 2500 then 
        targetQuest = "CocoaWarriors"; targetMob = "Cocoa Warrior"; npcName = "Chocolate Land Quest Giver"
    else 
        targetQuest = "CandyPirates"; targetMob = "Candy Pirate"; npcName = "Candy Land Quest Giver" 
    end
    
    return targetQuest, targetMob, npcName
end

-- Auto Sea Unlocking Handler
local function CheckSeaUnlocks()
    local level = GetLevel()
    if level >= 700 and game.PlaceId == 2753915549 and getgenv().AutoSea2 then
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("DressrosaQuestProgress", "Detective")
            task.wait(1)
            TweenTo(CFrame.new(1385, 87, -1298))
            ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelDressrosa")
        end)
        return true
    elseif level >= 1500 and game.PlaceId == 4442272183 and getgenv().AutoSea3 then
        pcall(function()
            ReplicatedStorage.Remotes.CommF_:InvokeServer("ZilphaQuestProgress", "Begin")
            task.wait(1)
            ReplicatedStorage.Remotes.CommF_:InvokeServer("TravelZilpha")
        end)
        return true
    end
    return false
end

-- Main Auto-Farm Core System Loop Execution Engine
task.spawn(function()
    while task.wait(0.2) do
        if getgenv().AutoFarm then
            pcall(function()
                if CheckSeaUnlocks() then return end

                local qName, mName, npcName = GetActiveQuestTarget()
                local mainGui = LocalPlayer.PlayerGui:FindFirstChild("Main")
                local hasQuest = mainGui and mainGui:FindFirstChild("Quest") and mainGui.Quest.Visible

                -- If player does NOT have an active quest window open
                if not hasQuest then
                    local npc = workspace:FindFirstChild("NPCs") and workspace.NPCs:FindFirstChild(npcName) or workspace:FindFirstChild(npcName)
                    if npc and npc:FindFirstChild("HumanoidRootPart") then
                        TweenTo(npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("StartQuest", qName, 1)
                    end
                else
                    -- If active quest accepted, farm target mobs
                    EquipWeapon()
                    local enemyFolder = workspace:FindFirstChild("Enemies") and workspace.Enemies:GetChildren() or {}
                    local targetMob = nil
                    
                    for _, enemy in pairs(enemyFolder) do
                        if enemy.Name == mName and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                            targetMob = enemy
                            break
                        end
                    end
                    
                    if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                        -- Hover position overhead
                        LocalPlayer.Character.HumanoidRootPart.CFrame = targetMob.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
                        
                        -- Magnet / Bring Mobs Routine
                        if getgenv().BringMob then
                            for _, nearbyEnemy in pairs(workspace.Enemies:GetChildren()) do
                                if nearbyEnemy.Name == mName and nearbyEnemy:FindFirstChild("HumanoidRootPart") then
                                    nearbyEnemy.HumanoidRootPart.CFrame = targetMob.HumanoidRootPart.CFrame
                                    nearbyEnemy.HumanoidRootPart.CanCollide = false
                                end
                            end
                        end
                    else
                        -- Teleport to mob spawn anchor if no live mobs found on map
                        local spawnPoint = workspace:FindFirstChild("_WorldOrigin") and workspace._WorldOrigin:FindFirstChild("EnemySpawns") and workspace._WorldOrigin.EnemySpawns:FindFirstChild(mName)
                        if spawnPoint then
                            TweenTo(spawnPoint.CFrame)
                        end
                    end
                end
            end)
        end
    end
end)

-- ============================================================
-- GUI INTERFACE BUILDER
-- ============================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrinelandBloxFruits"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.fromOffset(330, 290)
MainFrame.Position = UDim2.new(0.5, -165, 0.5, -145)
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

local function CreateToggle(text, globalKey)
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
    toggleBg.BackgroundColor3 = getgenv()[globalKey] and Color3.fromRGB(0, 229, 255) or Color3.fromRGB(45, 38, 68)
    toggleBg.Parent = frame
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(14, 14)
    knob.Position = getgenv()[globalKey] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = toggleBg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = frame

    btn.MouseButton1Click:Connect(function()
        getgenv()[globalKey] = not getgenv()[globalKey]
        local state = getgenv()[globalKey]
        TweenService:Create(knob, TweenInfo.new(0.18), {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
        TweenService:Create(toggleBg, TweenInfo.new(0.18), {BackgroundColor3 = state and Color3.fromRGB(0, 229, 255) or Color3.fromRGB(45, 38, 68)}):Play()
    end)
end

CreateToggle("Auto Level Farm (1-2800)", "AutoFarm")
CreateToggle("Fast Attack Mode", "FastAttack")
CreateToggle("Magnet / Bring Mobs", "BringMob")
CreateToggle("Auto Unlock Second Sea", "AutoSea2")
CreateToggle("Auto Unlock Third Sea", "AutoSea3")
