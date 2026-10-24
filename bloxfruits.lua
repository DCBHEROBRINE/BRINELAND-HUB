-- ============================================================
-- FULLY INTEGRATED BLOX FRUITS AUTO-FARM SCRIPT
-- ============================================================

if not game:IsLoaded() then 
    repeat game.Loaded:Wait() until game:IsLoaded() 
end

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

_G.Setting_table = {
    Auto_Farm = true, -- Set to true by default for auto farm execution
    FastAttack = true,
	Auto_Buso = true,
	Auto_Ken = true,
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
getgenv()['Update_Setting'] = function(Name)
    if not _G.Dis and isfolder('Switch Hub BF Premium') and isfile('Switch Hub BF Premium/'..Name..'.json') then
        writefile('Switch Hub BF Premium/'..Name..'.json', JsonEncode(_G.Setting_table))
	elseif not _G.Dis then
        Check_Setting(Name)
    end
end

Check_Setting(_G.Check_Save_Setting)
Get_Setting(_G.Check_Save_Setting)

if _G.Setting_table.Save_Member then
	getgenv()['MyName'] = game.Players.LocalPlayer.Name
	print("Save Member")
elseif _G.Setting_table.Save_All_Member then
	getgenv()['MyName'] = "AllMember"
	print("Save All Member")
else
	getgenv()['MyName'] = "None"
	_G.Dis = true
end

Check_Setting(getgenv()['MyName'])
Get_Setting(getgenv()['MyName'])

if type(_G.Setting_table.Weapon) ~= 'string' then
	for _, v2 in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do  
		if tostring(v2.ToolTip) == "Melee" or tostring(v2.ToolTip) == "Sword" or tostring(v2.ToolTip) == "Blox Fruit" then
			_G.Setting_table.Weapon = v2.Name
		end
	end
end

function Text(value)
    game.StarterGui:SetCore("SendNotification", {
        Title = "Switch Notification", 
        Text = tostring(value),
        Icon = "http://www.roblox.com/asset/?id=9606070311",
        Duration = 10
    })
end

function Com()
    game.StarterGui:SetCore("SendNotification", {
        Title = "Switch Notification", 
        Text = "✅  Complete",
        Icon = "http://www.roblox.com/asset/?id=9606070311",
        Duration = 5
    })
end

function TelePBoss(p)
	if (p.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude >= 2000 and not Auto_Raid and game.Players.LocalPlayer.Character.Humanoid.Health > 0 then
		if NameQuest == "FishmanQuest" then
			_G.Stop_Tween = true
			TP(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
			task.wait(.5)
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
			_G.Stop_Tween = nil
		elseif Ms == "God's Guard [Lv. 450]" then
			_G.Stop_Tween = true
			TP(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
			task.wait(.5)
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-4607.82275, 872.54248, -1667.55688))
			_G.Stop_Tween = nil
		elseif NameQuest == "SkyExp1Quest" then
			_G.Stop_Tween = true
			TP(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
			task.wait(.5)
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-7894.6176757813, 5547.1416015625, -380.29119873047))
			_G.Stop_Tween = nil
		elseif NameQuest == "ShipQuest1" or NameQuest == "ShipQuest2" then
			_G.Stop_Tween = true
			TP(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
			task.wait(.5)
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
			_G.Stop_Tween = nil
		elseif NameQuest == "FrostQuest" then
			_G.Stop_Tween = true
			TP(game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame)
			task.wait(.5)
			game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(-6508.5581054688, 89.034996032715, -132.83953857422))
			_G.Stop_Tween = nil
		else
			Mix_Farm = true
			_G.Stop_Tween = true
			game.Players.LocalPlayer.Character.Humanoid:ChangeState(15)
			repeat 
				task.wait(.5)
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = p
				task.wait()
				game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetSpawnPoint")
			until (p.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude < 1500 and game.Players.LocalPlayer.Character.Humanoid.Health > 0
			task.wait(.5)
			_G.Stop_Tween = nil
			Mix_Farm = nil
		end
	end
end

function CheckQuestBoss()
	if _G.SelectBoss == "Saber Expert [Lv. 200] [Boss]" then
		MsBoss = "Saber Expert [Lv. 200] [Boss]"
		NameBoss = "Saber Expert"
		CFrameBoss = CFrame.new(-1458.89502, 29.8870335, -50.633564, 0.858821094, 1.13848939e-08, 0.512275636, -4.85649254e-09, 1, -1.40823326e-08, -0.512275636, 9.6063415e-09, 0.858821094)
	elseif _G.SelectBoss == "The Saw [Lv. 100] [Boss]" then
		MsBoss = "The Saw [Lv. 100] [Boss]"
		NameBoss = "The Saw"
		CFrameBoss = CFrame.new(-683.519897, 13.8534927, 1610.87854, -0.290192783, 6.88365773e-08, 0.956968188, 6.98413629e-08, 1, -5.07531119e-08, -0.956968188, 5.21077759e-08, -0.290192783)
	elseif _G.SelectBoss == "Greybeard [Lv. 750] [Raid Boss]" then
		MsBoss = "Greybeard [Lv. 750] [Raid Boss]"
		NameBoss = "Greybeard"
		CFrameBoss = CFrame.new(-4955.72949, 80.8163834, 4305.82666, -0.433646321, -1.03394289e-08, 0.901083171, -3.0443168e-08, 1, -3.17633075e-09, -0.901083171, -2.88092288e-08, -0.433646321)
	end
end

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
		elseif Lv <= 174 or SelectMonster == "Sky Bandit [Lv. 150]" then
			Ms = "Sky Bandit [Lv. 150]"
			NameQuest = "SkyQuest"
			QuestLv = 1
			NameMon = "Sky Bandit"
			CFrameQ = CFrame.new(-4842.1372070313, 717.69543457031, -2623.0483398438)
			CFrameMon = CFrame.new(-4955.6411132813, 365.46365356445, -2908.1865234375)
		elseif Lv <= 249 or SelectMonster == "Dark Master [Lv. 175]" then
			Ms = "Dark Master [Lv. 175]"
			NameQuest = "SkyQuest"
			QuestLv = 2
			NameMon = "Dark Master"
			CFrameQ = CFrame.new(-4842.1372070313, 717.69543457031, -2623.0483398438)
			CFrameMon = CFrame.new(-5148.1650390625, 439.04571533203, -2332.9611816406)
		elseif Lv <= 274 or SelectMonster == "Toga Warrior [Lv. 250]" then
			Ms = "Toga Warrior [Lv. 250]"
			NameQuest = "ColosseumQuest"
			QuestLv = 1
			NameMon = "Toga Warrior"
			CFrameQ = CFrame.new(-1577.7890625, 7.4151420593262, -2984.4838867188)
			CFrameMon = CFrame.new(-1872.5166015625, 49.080215454102, -2913.810546875)
		elseif Lv <= 299 or SelectMonster == "Gladiator [Lv. 275]" then
			Ms = "Gladiator [Lv. 275]"
			NameQuest = "ColosseumQuest"
			QuestLv = 2
			NameMon = "Gladiator"
			CFrameQ = CFrame.new(-1577.7890625, 7.4151420593262, -2984.4838867188)
			CFrameMon = CFrame.new(-1521.3740234375, 81.203170776367, -3066.3139648438)
		elseif Lv <= 329 or SelectMonster == "Military Soldier [Lv. 300]" then
			Ms = "Military Soldier [Lv. 300]"
			NameQuest = "MagmaQuest"
			QuestLv = 1
			NameMon = "Military Soldier"
			CFrameQ = CFrame.new(-5316.1157226563, 12.262831687927, 8517.00390625)
			CFrameMon = CFrame.new(-5369.0004882813, 61.24352645874, 8556.4921875)
		elseif Lv <= 374 or SelectMonster == "Military Spy [Lv. 325]" then
			Ms = "Military Spy [Lv. 325]"
			NameQuest = "MagmaQuest"
			QuestLv = 2
			NameMon = "Military Spy"
			CFrameQ = CFrame.new(-5316.1157226563, 12.262831687927, 8517.00390625)
			CFrameMon = CFrame.new(-5984.0532226563, 82.14656829834, 8753.326171875)
		elseif Lv <= 399 or SelectMonster == "Fishman Warrior [Lv. 375]" then
			Ms = "Fishman Warrior [Lv. 375]"
			NameQuest = "FishmanQuest"
			QuestLv = 1
			NameMon = "Fishman Warrior"
			CFrameQ = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
			CFrameMon = CFrame.new(60844.10546875, 98.462875366211, 1298.3985595703)
		elseif Lv <= 449 or SelectMonster == "Fishman Commando [Lv. 400]" then
			Ms = "Fishman Commando [Lv. 400]"
			NameQuest = "FishmanQuest"
			QuestLv = 2
			NameMon = "Fishman Commando"
			CFrameQ = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
			CFrameMon = CFrame.new(61738.3984375, 64.207321166992, 1433.8375244141)
		elseif Lv <= 474 or SelectMonster == "God's Guard [Lv. 450]" then
			Ms = "God's Guard [Lv. 450]"
			NameQuest = "SkyExp1Quest"
			QuestLv = 1
			NameMon = "God's Guard"
			CFrameQ = CFrame.new(-4721.8603515625, 845.30297851563, -1953.8489990234)
			CFrameMon = CFrame.new(-4628.0498046875, 866.92877197266, -1931.2352294922)
		elseif Lv <= 524 or SelectMonster == "Shanda [Lv. 475]" then
			Ms = "Shanda [Lv. 475]"
			NameQuest = "SkyExp1Quest"
			QuestLv = 2
			NameMon = "Shanda"
			CFrameQ = CFrame.new(-7863.1596679688, 5545.5190429688, -378.42266845703)
			CFrameMon = CFrame.new(-7685.1474609375, 5601.0751953125, -441.38876342773)
		elseif Lv <= 549 or SelectMonster == "Royal Squad [Lv. 525]" then
			Ms = "Royal Squad [Lv. 525]"
			NameQuest = "SkyExp2Quest"
			QuestLv = 1
			NameMon = "Royal Squad"
			CFrameQ = CFrame.new(-7903.3828125, 5635.9897460938, -1410.923828125)
			CFrameMon = CFrame.new(-7654.2514648438, 5637.1079101563, -1407.7550048828)
		elseif Lv <= 624 or SelectMonster == "Royal Soldier [Lv. 550]" then
			Ms = "Royal Soldier [Lv. 550]"
			NameQuest = "SkyExp2Quest"
			QuestLv = 2
			NameMon = "Royal Soldier"
			CFrameQ = CFrame.new(-7903.3828125, 5635.9897460938, -1410.923828125)
			CFrameMon = CFrame.new(-7760.4106445313, 5679.9077148438, -1884.8112792969)
		elseif Lv <= 649 or SelectMonster == "Galley Pirate [Lv. 625]" then
			Ms = "Galley Pirate [Lv. 625]"
			NameQuest = "FountainQuest"
			QuestLv = 1
			NameMon = "Galley Pirate"
			CFrameQ = CFrame.new(5258.2788085938, 38.526931762695, 4050.044921875)
			CFrameMon = CFrame.new(5557.1684570313, 152.32717895508, 3998.7758789063)
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
		elseif Lv <= 774 or SelectMonster == "Mercenary [Lv. 725]" then
			Ms = "Mercenary [Lv. 725]"
			NameQuest = "Area1Quest"
			QuestLv = 2
			NameMon = "Mercenary"
			CFrameQ = CFrame.new(-427.72567749023, 72.99634552002, 1835.9426269531)
			CFrameMon = CFrame.new(-864.85009765625, 122.47104644775, 1453.1505126953)
		elseif Lv <= 799 or SelectMonster == "Swan Pirate [Lv. 775]" then
			Ms = "Swan Pirate [Lv. 775]"
			NameQuest = "Area2Quest"
			QuestLv = 1
			NameMon = "Swan Pirate"
			CFrameQ = CFrame.new(635.61151123047, 73.096351623535, 917.81298828125)
			CFrameMon = CFrame.new(1065.3669433594, 137.64012145996, 1324.3798828125)
		elseif Lv <= 874 or SelectMonster == "Factory Staff [Lv. 800]" then
			Ms = "Factory Staff [Lv. 800]"
			NameQuest = "Area2Quest"
			QuestLv = 2
			NameMon = "Factory Staff"
			CFrameQ = CFrame.new(635.61151123047, 73.096351623535, 917.81298828125)
			CFrameMon = CFrame.new(533.22045898438, 128.46876525879, 355.62615966797)
		elseif Lv <= 899 or SelectMonster == "Marine Lieutenant [Lv. 875]" then
			Ms = "Marine Lieutenant [Lv. 875]"
			NameQuest = "MarineQuest3"
			QuestLv = 1
			NameMon = "Marine Lieutenant"
			CFrameQ = CFrame.new(-2440.9934082031, 73.04190826416, -3217.7082519531)
			CFrameMon = CFrame.new(-2489.2622070313, 84.613594055176, -3151.8830566406)
		elseif Lv <= 949 or SelectMonster == "Marine Captain [Lv. 900]" then
			Ms = "Marine Captain [Lv. 900]"
			NameQuest = "MarineQuest3"
			QuestLv = 2
			NameMon = "Marine Captain"
			CFrameQ = CFrame.new(-2440.9934082031, 73.04190826416, -3217.7082519531)
			CFrameMon = CFrame.new(-2335.2026367188, 79.786659240723, -3245.8674316406)
		elseif Lv <= 974 or SelectMonster == "Zombie [Lv. 950]" then
			Ms = "Zombie [Lv. 950]"
			NameQuest = "ZombieQuest"
			QuestLv = 1
			NameMon = "Zombie"
			CFrameQ = CFrame.new(-5494.3413085938, 48.505931854248, -794.59094238281)
			CFrameMon = CFrame.new(-5536.4970703125, 101.08577728271, -835.59075927734)
		elseif Lv <= 999 or SelectMonster == "Vampire [Lv. 975]" then
			Ms = "Vampire [Lv. 975]"
			NameQuest = "ZombieQuest"
			QuestLv = 2
			NameMon = "Vampire"
			CFrameQ = CFrame.new(-5494.3413085938, 48.505931854248, -794.59094238281)
			CFrameMon = CFrame.new(-5806.1098632813, 16.722528457642, -1164.4384765625)
		elseif Lv <= 1049 or SelectMonster == "Snow Trooper [Lv. 1000]" then
			Ms = "Snow Trooper [Lv. 1000]"
			NameQuest = "SnowMountainQuest"
			QuestLv = 1
			NameMon = "Snow Trooper"
			CFrameQ = CFrame.new(607.05963134766, 401.44781494141, -5370.5546875)
			CFrameMon = CFrame.new(535.21051025391, 432.74209594727, -5484.9165039063)
		elseif Lv <= 1099 or SelectMonster == "Winter Warrior [Lv. 1050]" then
			Ms = "Winter Warrior [Lv. 1050]"
			NameQuest = "SnowMountainQuest"
			QuestLv = 2
			NameMon = "Winter Warrior"
			CFrameQ = CFrame.new(607.05963134766, 401.44781494141, -5370.5546875)
			CFrameMon = CFrame.new(1234.4449462891, 456.95419311523, -5174.130859375)
		elseif Lv <= 1124 or SelectMonster == "Lab Subordinate [Lv. 1100]" then
			Ms = "Lab Subordinate [Lv. 1100]"
			NameQuest = "IceSideQuest"
			QuestLv = 1
			NameMon = "Lab Subordinate"
			CFrameQ = CFrame.new(-6061.841796875, 15.926671981812, -4902.0385742188)
			CFrameMon = CFrame.new(-5720.5576171875, 63.309471130371, -4784.6103515625)
		elseif Lv <= 1174 or SelectMonster == "Horned Warrior [Lv. 1125]" then
			Ms = "Horned Warrior [Lv. 1125]"
			NameQuest = "IceSideQuest"
			QuestLv = 2
			NameMon = "Horned Warrior"
			CFrameQ = CFrame.new(-6061.841796875, 15.926671981812, -4902.0385742188)
			CFrameMon = CFrame.new(-6292.751953125, 91.181983947754, -5502.6499023438)
		elseif Lv <= 1199 or SelectMonster == "Magma Ninja [Lv. 1175]" then
			Ms = "Magma Ninja [Lv. 1175]"
			NameQuest = "FireSideQuest"
			QuestLv = 1
			NameMon = "Magma Ninja"
			CFrameQ = CFrame.new(-5429.0473632813, 15.977565765381, -5297.9614257813)
			CFrameMon = CFrame.new(-5461.8388671875, 130.36347961426, -5836.4702148438)
		elseif Lv <= 1249 or SelectMonster == "Lava Pirate [Lv. 1200]" then
			Ms = "Lava Pirate [Lv. 1200]"
			NameQuest = "FireSideQuest"
			QuestLv = 2
			NameMon = "Lava Pirate"
			CFrameQ = CFrame.new(-5429.0473632813, 15.977565765381, -5297.9614257813)
			CFrameMon = CFrame.new(-5251.1889648438, 55.164535522461, -4774.4096679688)
		elseif Lv <= 1274 or SelectMonster == "Ship Deckhand [Lv. 1250]" then
			Ms = "Ship Deckhand [Lv. 1250]"
			NameQuest = "ShipQuest1"
			QuestLv = 1
			NameMon = "Ship Deckhand"
			CFrameQ = CFrame.new(1040.2927246094, 125.08293151855, 32911.0390625)
			CFrameMon = CFrame.new(921.12365722656, 125.9839553833, 33088.328125)
		elseif Lv <= 1299 or SelectMonster == "Ship Engineer [Lv. 1275]" then
			Ms = "Ship Engineer [Lv. 1275]"
			NameQuest = "ShipQuest1"
			QuestLv = 2
			NameMon = "Ship Engineer"
			CFrameQ = CFrame.new(1040.2927246094, 125.08293151855, 32911.0390625)
			CFrameMon = CFrame.new(886.28179931641, 40.47790145874, 32800.83203125)
		elseif Lv <= 1324 or SelectMonster == "Ship Steward [Lv. 1300]" then
			Ms = "Ship Steward [Lv. 1300]"
			NameQuest = "ShipQuest2"
			QuestLv = 1
			NameMon = "Ship Steward"
			CFrameQ = CFrame.new(971.42065429688, 125.08293151855, 33245.54296875)
			CFrameMon = CFrame.new(943.85504150391, 129.58183288574, 33444.3671875)
		elseif Lv <= 1349 or SelectMonster == "Ship Officer [Lv. 1325]" then
			Ms = "Ship Officer [Lv. 1325]"
			NameQuest = "ShipQuest2"
			QuestLv = 2
			NameMon = "Ship Officer"
			CFrameQ = CFrame.new(971.42065429688, 125.08293151855, 33245.54296875)
			CFrameMon = CFrame.new(955.38458251953, 181.08335876465, 33331.890625)
		elseif Lv <= 1374 or SelectMonster == "Arctic Warrior [Lv. 1350]" then
			Ms = "Arctic Warrior [Lv. 1350]"
			NameQuest = "FrostQuest"
			QuestLv = 1
			NameMon = "Arctic Warrior"
			CFrameQ = CFrame.new(5668.1372070313, 28.202531814575, -6484.6005859375)
			CFrameMon = CFrame.new(5935.4541015625, 77.26016998291, -6472.7568359375)
		elseif Lv <= 1424 or SelectMonster == "Snow Lurker [Lv. 1375]" then
			Ms = "Snow Lurker [Lv. 1375]"
			NameQuest = "FrostQuest"
			QuestLv = 2
			NameMon = "Snow Lurker"
			CFrameQ = CFrame.new(5668.1372070313, 28.202531814575, -6484.6005859375)
			CFrameMon = CFrame.new(5628.482421875, 57.574996948242, -6618.3481445313)
		elseif Lv <= 1449 or SelectMonster == "Sea Soldier [Lv. 1425]" then
			Ms = "Sea Soldier [Lv. 1425]"
			NameQuest = "ForgottenQuest"
			QuestLv = 1
			NameMon = "Sea Soldier"
			CFrameQ = CFrame.new(-3054.5827636719, 236.87213134766, -10147.790039063)
			CFrameMon = CFrame.new(-3185.0153808594, 58.789089202881, -9663.6064453125)
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
		elseif Lv <= 1574 or SelectMonster == "Pistol Billionaire [Lv. 1525]" then
			Ms = "Pistol Billionaire [Lv. 1525]"
			NameQuest = "PiratePortQuest"
			QuestLv = 2
			NameMon = "Pistol Billionaire"
			CFrameQ = CFrame.new(-289.61752319336, 43.819011688232, 5580.0903320313)
			CFrameMon = CFrame.new(-236.53652954102, 217.46676635742, 6006.0883789063)
		elseif Lv <= 1599 or SelectMonster == "Dragon Crew Warrior [Lv. 1575]" then
			Ms = "Dragon Crew Warrior [Lv. 1575]"
			NameQuest = "AmazonQuest"
			QuestLv = 1
			NameMon = "Dragon Crew Warrior"
			CFrameQ = CFrame.new(5833.1147460938, 51.60498046875, -1103.0693359375)
			CFrameMon = CFrame.new(6301.9975585938, 104.77153015137, -1082.6075439453)
		elseif Lv <= 1624 or SelectMonster == "Dragon Crew Archer [Lv. 1600]" then
			Ms = "Dragon Crew Archer [Lv. 1600]"
			NameQuest = "AmazonQuest"
			QuestLv = 2
			NameMon = "Dragon Crew Archer"
			CFrameQ = CFrame.new(5833.1147460938, 51.60498046875, -1103.0693359375)
			CFrameMon = CFrame.new(6831.1171875, 441.76708984375, 446.58615112305)
		elseif Lv <= 1649 or SelectMonster == "Female Islander [Lv. 1625]" then
			Ms = "Female Islander [Lv. 1625]"
			NameQuest = "AmazonQuest2"
			QuestLv = 1
			NameMon = "Female Islander"
			CFrameQ = CFrame.new(5446.8793945313, 601.62945556641, 749.45672607422)
			CFrameMon = CFrame.new(5792.5166015625, 848.14392089844, 1084.1818847656)
		elseif Lv <= 1699 or SelectMonster == "Giant Islander [Lv. 1650]" then
			Ms = "Giant Islander [Lv. 1650]"
			NameQuest = "AmazonQuest2"
			QuestLv = 2
			NameMon = "Giant Islander"
			CFrameQ = CFrame.new(5446.8793945313, 601.62945556641, 749.45672607422)
			CFrameMon = CFrame.new(5009.5068359375, 664.11071777344, -40.960144042969)
		elseif Lv <= 1724 or SelectMonster == "Marine Commodore [Lv. 1700]" then
			Ms = "Marine Commodore [Lv. 1700]"
			NameQuest = "MarineTreeIsland"
			QuestLv = 1
			NameMon = "Marine Commodore"
			CFrameQ = CFrame.new(2179.98828125, 28.731239318848, -6740.0551757813)
			CFrameMon = CFrame.new(2198.0063476563, 128.71075439453, -7109.5043945313)
		elseif Lv <= 1774 or SelectMonster == "Marine Rear Admiral [Lv. 1725]" then
			Ms = "Marine Rear Admiral [Lv. 1725]"
			NameQuest = "MarineTreeIsland"
			QuestLv = 2
			NameMon = "Marine Rear Admiral"
			CFrameQ = CFrame.new(2179.98828125, 28.731239318848, -6740.0551757813)
			CFrameMon = CFrame.new(3294.3142089844, 385.41125488281, -7048.6342773438)
		elseif Lv <= 1799 or SelectMonster == "Fishman Raider [Lv. 1775]" then
			Ms = "Fishman Raider [Lv. 1775]"
			NameQuest = "DeepForestIsland3"
			QuestLv = 1
			NameMon = "Fishman Raider"
			CFrameQ = CFrame.new(-10582.759765625, 331.78845214844, -8757.666015625)
			CFrameMon = CFrame.new(-10553.268554688, 521.38439941406, -8176.9458007813)
		elseif Lv <= 1824 or SelectMonster == "Fishman Captain [Lv. 1800]" then
			Ms = "Fishman Captain [Lv. 1800]"
			NameQuest = "DeepForestIsland3"
			QuestLv = 2
			NameMon = "Fishman Captain"
			CFrameQ = CFrame.new(-10583.099609375, 331.78845214844, -8759.4638671875)
			CFrameMon = CFrame.new(-10789.401367188, 427.18637084961, -9131.4423828125)
		elseif Lv <= 1849 or SelectMonster == "Forest Pirate [Lv. 1825]" then
			Ms = "Forest Pirate [Lv. 1825]"
			NameQuest = "DeepForestIsland"
			QuestLv = 1
			NameMon = "Forest Pirate"
			CFrameQ = CFrame.new(-13232.662109375, 332.40396118164, -7626.4819335938)
			CFrameMon = CFrame.new(-13489.397460938, 400.30349731445, -7770.251953125)
		elseif Lv <= 1899 or SelectMonster == "Mythological Pirate [Lv. 1850]" then
			Ms = "Mythological Pirate [Lv. 1850]"
			NameQuest = "DeepForestIsland"
			QuestLv = 2
			NameMon = "Mythological Pirate"
			CFrameQ = CFrame.new(-13232.662109375, 332.40396118164, -7626.4819335938)
			CFrameMon = CFrame.new(-13508.616210938, 582.46228027344, -6985.3037109375)
		elseif Lv <= 1924 or SelectMonster == "Jungle Pirate [Lv. 1900]" then
			Ms = "Jungle Pirate [Lv. 1900]"
			NameQuest = "DeepForestIsland2"
			QuestLv = 1
			NameMon = "Jungle Pirate"
			CFrameQ = CFrame.new(-12682.096679688, 390.88653564453, -9902.1240234375)
			CFrameMon = CFrame.new(-12267.103515625, 459.75262451172, -10277.200195313)
		elseif Lv <= 1974 or SelectMonster == "Musketeer Pirate [Lv. 1925]" then
			Ms = "Musketeer Pirate [Lv. 1925]"
			NameQuest = "DeepForestIsland2"
			QuestLv = 2
			NameMon = "Musketeer Pirate"
			CFrameQ = CFrame.new(-12682.096679688, 390.88653564453, -9902.1240234375)
			CFrameMon = CFrame.new(-13291.5078125, 520.47338867188, -9904.638671875)
		elseif Lv <= 1999 or SelectMonster == "Reborn Skeleton [Lv. 1975]" then
			Ms = "Reborn Skeleton [Lv. 1975]"
			NameQuest = "HauntedQuest1"
			QuestLv = 1
			NameMon = "Reborn Skeleton"
			CFrameQ = CFrame.new(-9480.80762, 142.130661, 5566.37305)
			CFrameMon = CFrame.new(-8817.880859375, 191.16761779785, 6298.6557617188)
		elseif Lv <= 2024 or SelectMonster == "Living Zombie [Lv. 2000]" then
			Ms = "Living Zombie [Lv. 2000]"
			NameQuest = "HauntedQuest1"
			QuestLv = 2
			NameMon = "Living Zombie"
			CFrameQ = CFrame.new(-9480.80762, 142.130661, 5566.37305)
			CFrameMon = CFrame.new(-10103.7529, 238.565979, 6179.75977)
		elseif Lv <= 2049 or SelectMonster == "Demonic Soul [Lv. 2025]" then
			Ms = "Demonic Soul [Lv. 2025]"
			NameQuest = "HauntedQuest2"
			QuestLv = 1
			NameMon = "Demonic Souls"
			CFrameQ = CFrame.new(-9515.39551, 172.266037, 6078.89746)
			CFrameMon = CFrame.new(-9709.30762, 204.695892, 6044.04688)
		elseif Lv <= 2074 or SelectMonster == "Posessed Mummy [Lv. 2050]" then
			Ms = "Posessed Mummy [Lv. 2050]"
			NameQuest = "HauntedQuest2"
			QuestLv = 2
			NameMon = "Posessed Mummys"
			CFrameQ = CFrame.new(-9515.39551, 172.266037, 6078.89746)
			CFrameMon = CFrame.new(-9554.11035, 65.6141663, 6041.73584)
		elseif Lv <= 2099 or SelectMonster == "Peanut Scout [Lv. 2075]" then
			Ms = "Peanut Scout [Lv. 2075]"
			NameQuest = "PeanutQuest1"
			QuestLv = 1
			NameMon = "Peanut Scout"
			CFrameQ = CFrame.new(-2104.453125, 38.129974365234, -10194.0078125)
			CFrameMon = CFrame.new(-2068.0949707031, 76.512603759766, -10117.150390625)
		elseif Lv <= 2124 or SelectMonster == "Peanut President [Lv. 2100]" then
			Ms = "Peanut President [Lv. 2100]"
			NameQuest = "PeanutQuest2"
			QuestLv = 2
			NameMon = "Peanut Presidents"
			CFrameQ = CFrame.new(-2104.453125, 38.129974365234, -10194.0078125)
			CFrameMon = CFrame.new(-2067.33203125, 90.557350158691, -10552.051757812)
		elseif Lv <= 2149 or SelectMonster == "Ice Cream Chef [Lv. 2125]" then
			Ms = "Ice Cream Chef [Lv. 2125]"
			NameQuest = "IceCreamQuest1"
			QuestLv = 1
			NameMon = "Ice Cream Chefs"
			CFrameQ = CFrame.new(-821.35913085938, 65.845329284668, -10965.2578125)
			CFrameMon = CFrame.new(-796.37261962891, 110.95275878906, -10847.473632812)
		elseif Lv <= 2200 or SelectMonster == "Ice Cream Commander [Lv. 2150]" then
			Ms = "Ice Cream Commander [Lv. 2150]"
			NameQuest = "IceCreamIslandQuest"
			QuestLv = 2
			NameMon = "Ice Cream Commanders"
			CFrameQ = CFrame.new(-821.35913085938, 65.845329284668, -10965.2578125)
			CFrameMon = CFrame.new(-697.65338134766, 174.48368835449, -11218.38671875)
		elseif Lv <= 2224 or SelectMonster == "Cookie Crafter [Lv. 2200]" then
			Ms = "Cookie Crafter [Lv. 2200]"
			NameQuest = "CakeQuest1"
			QuestLv = 1
			NameMon = "Cookie Crafters"
			CFrameQ = CFrame.new(-2017.4874267578125, 36.85276412963867, -12027.53515625)
			CFrameMon = CFrame.new(-2358.5791015625, 36.85615539550781, -12111.052734375)
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

function TP(P1)
	if not _G.Stop_Tween then
		local Distance = (P1.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
		local Speed = 325
		if Distance < 250 then
			Speed = 5000
		elseif Distance < 500 then
			Speed = 650
		elseif Distance < 1000 then
			Speed = 350
		elseif Distance >= 1000 then
			Speed = 325
		end
		local Tween = game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear), {CFrame = P1})
		if _G.Stop_Tween or Auto_Raid then
			Tween:Cancel()
		elseif game.Players.LocalPlayer.Character.Humanoid.Health > 0 then
			Tween:Play()
		end
	end
end

function TP3(P1)
	local Distance = (P1.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
	local Speed = 325
	local tween = game:GetService("TweenService"):Create(
		game.Players.LocalPlayer.Character.HumanoidRootPart,
		TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),
		{CFrame = P1}
	)
	tween:Play()
	if _G.Stop_Tween then
		tween:Cancel()
	end
end

function TP2(P1)
	local Distance = (P1.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
	local Speed = 325
	local tween = game:GetService("TweenService"):Create(
		game.Players.LocalPlayer.Character.HumanoidRootPart,
		TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),
		{CFrame = P1}
	)
	tween:Play()
	if _G.Stop_Tween then
		tween:Cancel()
	end
	_G.Clip = true
	task.wait(Distance/Speed)
	_G.Clip = false
end

function EquipWeapon(ToolSe)
	local char = game.Players.LocalPlayer.Character
	local backpack = game.Players.LocalPlayer:FindFirstChild("Backpack")
	if not char or not backpack then return end
	
	if not char:FindFirstChildOfClass("Tool") then
		local tool = backpack:FindFirstChild(ToolSe) or backpack:GetChildren()[1]
		if tool and tool:IsA("Tool") then
			task.wait(.2)
			char.Humanoid:EquipTool(tool)
		end
	end
end

-- Fast Attack Loop
task.spawn(function()
    while task.wait(0.05) do
        pcall(function()
            if _G.Setting_table.FastAttack then
                local player = game.Players.LocalPlayer
                if player.Character and player.Character:FindFirstChildOfClass("Tool") then
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
                end
            end
        end)
    end
end)

-- Full Complete Auto-Farm Core Loop (Reading Level, Quests, Bring Mobs, & Tweening)
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            if _G.Setting_table.Auto_Farm then
                CheckLevel()
                
                local player = game.Players.LocalPlayer
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") or char.Humanoid.Health <= 0 then return end
                
                local mainGui = player.PlayerGui:FindFirstChild("Main")
                local hasQuest = mainGui and mainGui:FindFirstChild("Quest") and mainGui.Quest.Visible
                
                if not hasQuest then
                    -- No quest: Tween to Quest Giver NPC CFrame and invoke quest remote
                    if CFrameQ then
                        TP(CFrameQ)
                        if (CFrameQ.Position - char.HumanoidRootPart.Position).Magnitude < 15 then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, QuestLv)
                            task.wait(0.5)
                        end
                    end
                else
                    -- Quest active: Equip weapon and farm mobs
                    if _G.Setting_table.Weapon then
                        EquipWeapon(_G.Setting_table.Weapon)
                    end
                    
                    local enemiesFolder = workspace:FindFirstChild("Enemies")
                    local targetEnemy = nil
                    
                    if enemiesFolder then
                        for _, enemy in pairs(enemiesFolder:GetChildren()) do
                            if enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                                if enemy.Name == NameMon or enemy.Name == Ms or (NameMon and string.find(enemy.Name, NameMon)) then
                                    targetEnemy = enemy
                                    break
                                end
                            end
                        end
                    end
                    
                    if targetEnemy and targetEnemy:FindFirstChild("HumanoidRootPart") then
                        -- Hover above mob safely
                        TP(targetEnemy.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0))
                        
                        -- Bring Mobs / Cluster Magnet
                        for _, nearbyEnemy in pairs(enemiesFolder:GetChildren()) do
                            if nearbyEnemy:FindFirstChild("HumanoidRootPart") and nearbyEnemy:FindFirstChild("Humanoid") and nearbyEnemy.Humanoid.Health > 0 then
                                if nearbyEnemy.Name == NameMon or nearbyEnemy.Name == Ms or (NameMon and string.find(nearbyEnemy.Name, NameMon)) then
                                    nearbyEnemy.HumanoidRootPart.CFrame = targetEnemy.HumanoidRootPart.CFrame
                                    nearbyEnemy.HumanoidRootPart.CanCollide = false
                                end
                            end
                        end
                    else
                        -- Fallback to mob spawn CFrame if no live mobs found
                        if CFrameMon then
                            TP(CFrameMon)
                        end
                    end
                end
            end
        end)
    end
end)
