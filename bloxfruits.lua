-- ============================================================
-- BRINELAND HUB - FULLY FIXED BLOX FRUITS AUTO-FARM
-- ============================================================

if not game:IsLoaded() then 
    repeat game.Loaded:Wait() until game:IsLoaded() 
end

-- Team Selector
repeat task.wait(1)
    pcall(function()
        local chooseTeam = game:GetService("Players").LocalPlayer.PlayerGui.Main:FindFirstChild("ChooseTeam")
        if chooseTeam and chooseTeam.Visible == true then
            if _G.Team == "Marines" then
                for _, v in pairs(getconnections(chooseTeam.Container.Marines.Frame.ViewportFrame.TextButton.MouseButton1Click)) do
                    v.Function()
                end
            else
                for _, v in pairs(getconnections(chooseTeam.Container.Pirates.Frame.ViewportFrame.TextButton.MouseButton1Click)) do
                    v.Function()
                end
            end
        end
    end)
until game.Players.LocalPlayer.Neutral == false

if _G.Fast_Delay == nil then
	_G.Fast_Delay = 0.3
end

-- Auto Rejoin
task.spawn(function()
    while true do 
        task.wait()
        getgenv().rejoin = game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(Kick)
            if not _G.TP_Ser and _G.Rejoin then
                if Kick.Name == 'ErrorPrompt' and Kick:FindFirstChild('MessageArea') and Kick.MessageArea:FindFirstChild("ErrorFrame") then
                    game:GetService("TeleportService"):Teleport(game.PlaceId)
                    task.wait(50)
                end
            end
        end)
    end
end)

-- Anti-AFK
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end)

task.spawn(function()
	while task.wait(3) do
		game:GetService("VirtualUser"):CaptureController()
	end
end)

-- World Tracker
Old_World = false
New_World = false
Three_World = false
local placeId = game.PlaceId
if placeId == 2753915549 then
    Old_World = true
elseif placeId == 4442272183 then
    New_World = true
elseif placeId == 7449423635 then
    Three_World = true
end

_G.Color = Color3.fromRGB(68, 202, 186)

-- Core Settings
_G.Setting_table = {
    Auto_Farm = false,
    FastAttack = true,
	Auto_Buso = true,
	Auto_Ken = true,
	BringMob = true,
	Show_Damage = true,
	NoClip = true,
	Save_Member = true,
	Melee_A = true,
	Defense_A = true,
	SkillZ = true,
	Rejoin = true,
	Anti_AFK = true,
	K_MAX = 50,
	Chest_Lock = 50,
	Delay_C = 15
}

_G.Check_Save_Setting = "CheckSaveSetting"

getgenv()['JsonEncode'] = function(msg)
    return game:GetService("HttpService"):JSONEncode(msg)
end
getgenv()['JsonDecode'] = function(msg)
    return game:GetService("HttpService"):JSONDecode(msg)
end
getgenv()['Check_Setting'] = function(Name)
    if not _G.Dis and not isfolder('Switch Hub BF Premium') then
        makefolder('Switch Hub BF Premium')
    end
    if not _G.Dis and not isfile('Switch Hub BF Premium/'..Name..'.json') then
        writefile('Switch Hub BF Premium/'..Name..'.json', JsonEncode(_G.Setting_table))
    end
end
getgenv()['Get_Setting'] = function(Name)
    if not _G.Dis and isfolder('Switch Hub BF Premium') and isfile('Switch Hub BF Premium/'..Name..'.json') then
        _G.Setting_table = JsonDecode(readfile('Switch Hub BF Premium/'..Name..'.json'))
        return _G.Setting_table
	elseif not _G.Dis then
        Check_Setting(Name)
    end
end

Check_Setting(_G.Check_Save_Setting)
Get_Setting(_G.Check_Save_Setting)

-- Weapon Detection
if type(_G.Setting_table.Weapon) ~= 'string' then
	for _, v2 in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do  
		if tostring(v2.ToolTip) == "Melee" or tostring(v2.ToolTip) == "Sword" or tostring(v2.ToolTip) == "Blox Fruit" then
			_G.Setting_table.Weapon = v2.Name
		end
	end
end

-- Teleportation Helpers
function TP(P1)
	if not _G.Stop_Tween then
		local char = game.Players.LocalPlayer.Character
		if not char or not char:FindFirstChild("HumanoidRootPart") then return end
		local Distance = (P1.Position - char.HumanoidRootPart.Position).Magnitude
		local Speed = 325
		if Distance < 250 then
			Speed = 5000
		elseif Distance < 500 then
			Speed = 650
		elseif Distance < 1000 then
			Speed = 350
		else
			Speed = 325
		end
		local Tween = game:GetService("TweenService"):Create(char.HumanoidRootPart, TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear), {CFrame = P1})
		if _G.Stop_Tween or Auto_Raid then
			Tween:Cancel()
		elseif char.Humanoid.Health > 0 then
			Tween:Play()
		end
	end
end

function EquipWeapon(ToolSe)
	local char = game.Players.LocalPlayer.Character
	local backpack = game.Players.LocalPlayer:FindFirstChild("Backpack")
	if not char or not backpack then return end
	
	if not char:FindFirstChildOfClass("Tool") then
		local tool = backpack:FindFirstChild(ToolSe)
		if not tool then
			for _, item in pairs(backpack:GetChildren()) do
				if item:IsA("Tool") and (item.ToolTip == "Melee" or item.ToolTip == "Sword" or item.ToolTip == "Blox Fruit") then
					tool = item
					break
				end
			end
		end
		if tool then
			char.Humanoid:EquipTool(tool)
		end
	end
end

-- Level & Quest Coordinates Registry (Preserving Original Data)
function CheckLevel()
	local Lv = game:GetService("Players").LocalPlayer.Data.Level.Value
	if Old_World then
		if Lv <= 9 or SelectMonster == "Bandit [Lv. 5]" then
			Ms = "Bandit [Lv. 5]"
			NameQuest = "BanditQuest1"
			QuestLv = 1
			NameMon = "Bandit"
			CFrameQ = CFrame.new(1060.9383544922, 16.455066680908, 1547.7841796875)
			CFrameMon = CFrame.new(1038.5533447266, 41.296249389648, 1576.5098876953)
		elseif Lv <= 14 or SelectMonster == "Monkey [Lv. 14]" then
			Ms = "Monkey [Lv. 14]"
			NameQuest = "JungleQuest"
			QuestLv = 1
			NameMon = "Monkey"
			CFrameQ = CFrame.new(-1601.6553955078, 36.85213470459, 153.38809204102)
			CFrameMon = CFrame.new(-1448.1446533203, 50.851993560791, 63.60718536377)
		elseif Lv <= 29 or SelectMonster == "Gorilla [Lv. 20]" then
			Ms = "Gorilla [Lv. 20]"
			NameQuest = "JungleQuest"
			QuestLv = 2
			NameMon = "Gorilla"
			CFrameQ = CFrame.new(-1601.6553955078, 36.85213470459, 153.38809204102)
			CFrameMon = CFrame.new(-1142.6488037109, 40.462348937988, -515.39227294922)
		elseif Lv <= 39 or SelectMonster == "Pirate [Lv. 35]" then
			Ms = "Pirate [Lv. 35]"
			NameQuest = "BuggyQuest1"
			QuestLv = 1
			NameMon = "Pirate"
			CFrameQ = CFrame.new(-1140.1761474609, 4.752049446106, 3827.4057617188)
			CFrameMon = CFrame.new(-1201.0881347656, 40.628940582275, 3857.5966796875)
		elseif Lv <= 59 or SelectMonster == "Brute [Lv. 45]" then
			Ms = "Brute [Lv. 45]"
			NameQuest = "BuggyQuest1"
			QuestLv = 2
			NameMon = "Brute"
			CFrameQ = CFrame.new(-1140.1761474609, 4.752049446106, 3827.4057617188)
			CFrameMon = CFrame.new(-1387.5324707031, 24.592035293579, 4100.9575195313)
		elseif Lv <= 74 or SelectMonster == "Desert Bandit [Lv. 60]" then
			Ms = "Desert Bandit [Lv. 60]"
			NameQuest = "DesertQuest"
			QuestLv = 1
			NameMon = "Desert Bandit"
			CFrameQ = CFrame.new(896.51721191406, 6.4384617805481, 4390.1494140625)
			CFrameMon = CFrame.new(984.99896240234, 16.109552383423, 4417.91015625)
		elseif Lv <= 89 or SelectMonster == "Desert Officer [Lv. 70]" then
			Ms = "Desert Officer [Lv. 70]"
			NameQuest = "DesertQuest"
			QuestLv = 2
			NameMon = "Desert Officer"
			CFrameQ = CFrame.new(896.51721191406, 6.4384617805481, 4390.1494140625)
			CFrameMon = CFrame.new(1547.1510009766, 14.452038764954, 4381.8002929688)
		elseif Lv <= 99 or SelectMonster == "Snow Bandit [Lv. 90]" then
			Ms = "Snow Bandit [Lv. 90]"
			NameQuest = "SnowQuest"
			QuestLv = 1
			NameMon = "Snow Bandit"
			CFrameQ = CFrame.new(1386.8073730469, 87.272789001465, -1298.3576660156)
			CFrameMon = CFrame.new(1356.3028564453, 105.76865386963, -1328.2418212891)
		elseif Lv <= 119 or SelectMonster == "Snowman [Lv. 100]" then
			Ms = "Snowman [Lv. 100]"
			NameQuest = "SnowQuest"
			QuestLv = 2
			NameMon = "Snowman"
			CFrameQ = CFrame.new(1386.8073730469, 87.272789001465, -1298.3576660156)
			CFrameMon = CFrame.new(1218.7956542969, 138.01184082031, -1488.0262451172)
		elseif Lv <= 149 or SelectMonster == "Chief Petty Officer [Lv. 120]" then
			Ms = "Chief Petty Officer [Lv. 120]"
			NameQuest = "MarineQuest2"
			QuestLv = 1
			NameMon = "Chief Petty Officer"
			CFrameQ = CFrame.new(-5035.49609375, 28.677835464478, 4324.1840820313)
			CFrameMon = CFrame.new(-4931.1552734375, 65.793113708496, 4121.8393554688)
		else
			Ms = "Galley Captain [Lv. 650]"
			NameQuest = "FountainQuest"
			QuestLv = 2
			NameMon = "Galley Captain"
			CFrameQ = CFrame.new(5258.2788085938, 38.526931762695, 4050.044921875)
			CFrameMon = CFrame.new(5677.6772460938, 92.786109924316, 4966.6323242188)
		end
	end
	if New_World then
		if Lv <= 724 or SelectMonster == "Raider [Lv. 700]" then
			Ms = "Raider [Lv. 700]"
			NameQuest = "Area1Quest"
			QuestLv = 1
			NameMon = "Raider"
			CFrameQ = CFrame.new(-427.72567749023, 72.99634552002, 1835.9426269531)
			CFrameMon = CFrame.new(68.874565124512, 93.635643005371, 2429.6752929688)
		else
			Ms = "Water Fighter [Lv. 1450]"
			NameQuest = "ForgottenQuest"
			QuestLv = 2
			NameMon = "Water Fighter"
			CFrameQ = CFrame.new(-3054.5827636719, 236.87213134766, -10147.790039063)
			CFrameMon = CFrame.new(-3262.9301757813, 298.69036865234, -10552.529296875)
		end
	end
	if Three_World then
		if Lv <= 1524 or SelectMonster == "Pirate Millionaire [Lv. 1500]" then
			Ms = "Pirate Millionaire [Lv. 1500]"
			NameQuest = "PiratePortQuest"
			QuestLv = 1
			NameMon = "Pirate Millionaire"
			CFrameQ = CFrame.new(-289.61752319336, 43.819011688232, 5580.0903320313)
			CFrameMon = CFrame.new(-435.68109130859, 189.69866943359, 5551.0756835938)
		else
			Ms = "Cake Guard [Lv. 2225]"
			NameQuest = "CakeQuest1"
			QuestLv = 2
			NameMon = "Cake Guards"
			CFrameQ = CFrame.new(-2017.4874267578125, 36.85276412963867, -12027.53515625)
			CFrameMon = CFrame.new(-1430.4925537109375, 36.85621643066406, -12322.162109375)
		end
	end
end

-- Fast Attack Loop
task.spawn(function()
    while task.wait(0.05) do
        pcall(function()
            if _G.Setting_table.FastAttack and _G.Setting_table.Auto_Farm then
                local player = game.Players.LocalPlayer
                if player.Character and player.Character:FindFirstChildOfClass("Tool") then
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
                end
            end
        end)
    end
end)

-- ACCURATE QUEST DETECTOR FUNCTION
local function HasActiveQuest()
    local player = game.Players.LocalPlayer
    local mainGui = player.PlayerGui:FindFirstChild("Main")
    
    -- Check 1: Check UI quest container frame visibility
    if mainGui and mainGui:FindFirstChild("Quest") and mainGui.Quest.Visible == true then
        return true
    end
    
    -- Check 2: Check server dialogue state
    local questTitle = mainGui and mainGui.Quest:FindFirstChild("Container") and mainGui.Quest.Container:FindFirstChild("QuestTitle")
    if questTitle and questTitle.Text ~= "" then
        return true
    end
    
    return false
end

-- MAIN AUTO-FARM CORE LOOP
task.spawn(function()
    while task.wait(0.15) do
        pcall(function()
            if _G.Setting_table.Auto_Farm then
                CheckLevel()
                
                local player = game.Players.LocalPlayer
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") or char.Humanoid.Health <= 0 then return end
                
                -- Detect quest status accurately
                local questActive = HasActiveQuest()
                
                if not questActive then
                    -- Move to Quest Giver NPC and execute quest handshake remote
                    if CFrameQ then
                        TP(CFrameQ)
                        if (CFrameQ.Position - char.HumanoidRootPart.Position).Magnitude <= 15 then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, QuestLv)
                            task.wait(0.5)
                        end
                    end
                else
                    -- Quest active: Equip designated weapon & fight quest mobs
                    EquipWeapon(_G.Setting_table.Weapon)
                    
                    local enemiesFolder = workspace:FindFirstChild("Enemies")
                    local targetEnemy = nil
                    
                    if enemiesFolder then
                        for _, enemy in pairs(enemiesFolder:GetChildren()) do
                            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 and enemy:FindFirstChild("HumanoidRootPart") then
                                if enemy.Name == NameMon or enemy.Name == Ms or (NameMon and string.find(enemy.Name, NameMon)) then
                                    targetEnemy = enemy
                                    break
                                end
                            end
                        end
                    end
                    
                    if targetEnemy and targetEnemy:FindFirstChild("HumanoidRootPart") then
                        -- Position character safely overhead mob target
                        char.HumanoidRootPart.CFrame = targetEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 6, 0)
                        
                        -- Bring Mobs Magnet Cluster Engine
                        if _G.Setting_table.BringMob then
                            for _, nearbyEnemy in pairs(enemiesFolder:GetChildren()) do
                                if nearbyEnemy:FindFirstChild("HumanoidRootPart") and nearbyEnemy:FindFirstChild("Humanoid") and nearbyEnemy.Humanoid.Health > 0 then
                                    if nearbyEnemy.Name == NameMon or nearbyEnemy.Name == Ms or (NameMon and string.find(nearbyEnemy.Name, NameMon)) then
                                        nearbyEnemy.HumanoidRootPart.CFrame = targetEnemy.HumanoidRootPart.CFrame
                                        nearbyEnemy.HumanoidRootPart.CanCollide = false
                                    end
                                end
                            end
                        end
                    else
                        -- Teleport to mob spawn anchor if mobs are dead
                        if CFrameMon then
                            TP(CFrameMon)
                        end
                    end
                end
            end
        end)
    end
end)

-- ============================================================
-- BRINELAND HUB GUI SYSTEM
-- ============================================================
local PlayerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
if PlayerGui:FindFirstChild("BrinelandBFGui") then
    PlayerGui.BrinelandBFGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrinelandBFGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.fromOffset(320, 260)
MainFrame.Position = UDim2.new(0.5, -160, 0.4, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 12, 28)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(68, 202, 186)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 0, 38)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "<b>BRINELAND HUB</b> - <font color=\"#44CABA\">BLOX FRUITS</font>"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.RichText = true
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.fromOffset(24, 24)
CloseBtn.Position = UDim2.new(1, -28, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 40, 70)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.Parent = MainFrame
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local Container = Instance.new("ScrollingFrame")
Container.Size = UDim2.new(1, -16, 1, -48)
Container.Position = UDim2.new(0, 8, 0, 42)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 3
Container.ScrollBarImageColor3 = Color3.fromRGB(68, 202, 186)
Container.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 6)
Layout.Parent = Container

local function AddToggle(labelText, settingKey)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -4, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(25, 20, 42)
    frame.Parent = Container
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -50, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "<b>" .. labelText .. "</b>"
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.RichText = true
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = frame

    local toggleBg = Instance.new("Frame")
    toggleBg.Size = UDim2.fromOffset(36, 18)
    toggleBg.Position = UDim2.new(1, -42, 0.5, -9)
    toggleBg.BackgroundColor3 = _G.Setting_table[settingKey] and Color3.fromRGB(68, 202, 186) or Color3.fromRGB(45, 38, 68)
    toggleBg.Parent = frame
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.fromOffset(14, 14)
    knob.Position = _G.Setting_table[settingKey] and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.Parent = toggleBg
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = frame

    btn.MouseButton1Click:Connect(function()
        _G.Setting_table[settingKey] = not _G.Setting_table[settingKey]
        local state = _G.Setting_table[settingKey]
        game:GetService("TweenService"):Create(knob, TweenInfo.new(0.18), {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
        game:GetService("TweenService"):Create(toggleBg, TweenInfo.new(0.18), {BackgroundColor3 = state and Color3.fromRGB(68, 202, 186) or Color3.fromRGB(45, 38, 68)}):Play()
    end)
end

AddToggle("Auto Level Farm (1-2400+)", "Auto_Farm")
AddToggle("Fast Attack Speed", "FastAttack")
AddToggle("Bring Mobs / Magnet", "BringMob")
AddToggle("Auto Buso Haki", "Auto_Buso")
AddToggle("Auto Ken Haki", "Auto_Ken")
