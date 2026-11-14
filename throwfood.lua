-- ============================================================
-- BRINELAND HUB: THROW FOOD FOR ANIMALS (MASTER EDITION, v6.2)
-- Repository: https://github.com/DCBHEROBRINE/BRINELAND-HUB.git
-- ============================================================

-- Place ID Check for Throw Food for Animals
if game.PlaceId ~= 120219252362013 then
	warn("[Brineland Hub] Wrong game detected! This script is only for Throw Food For Animals.")
	return
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local env = (getgenv and getgenv()) or _G

if env.BrinelandThrowFoodUnload then pcall(env.BrinelandThrowFoodUnload) end

local function destroyIfExists(guiName)
	local pGui = LocalPlayer:FindFirstChild("PlayerGui")
	if pGui and pGui:FindFirstChild(guiName) then pGui[guiName]:Destroy() end
	local ok, core = pcall(function() return (gethui and gethui()) or CoreGui end)
	if ok and core and core:FindFirstChild(guiName) then core[guiName]:Destroy() end
end
destroyIfExists("ThrowFoodHub")

-- ============================================================
-- CONSTANTS
-- ============================================================
local CONFIG_FOLDER = "Brineland"
local CONFIG_PATH = CONFIG_FOLDER .. "/ThrowFood.json"

local TRAIN_POSITION = Vector3.new(-9, 5, -8)
local THROW_POSITION = Vector3.new(7, 5, -34)
local PHASE1_SECONDS = 600 -- training + upgrades
local PHASE2_SECONDS = 300 -- throwing + equip best + sell all
local TELEPORT_INTERVAL = 1 
local TELEPORT_TOLERANCE = 4 
local PATH_RADIUS = 150 
local REMOTE_TIMEOUT = 10 

local EXPECTED_REMOTES = {
	"Throw_Complete", "Training_Start", "Training_Stop",
	"Plot_EquipBest", "Plot_SellAll", "Stand_Upgrade", "Shop_ClaimFree",
}

-- ============================================================
-- SETTINGS SCHEMA
-- ============================================================
local SETTINGS_SCHEMA = {
	PerfectValue     = { default = 20,     min = 1,    max = 100, step = 1 },
	TapMethod        = { default = 1,      min = 1,    max = 3,   step = 1 },
	TrainDelay       = { default = 0.5,    min = 0.1,  max = 3,   step = 0.1 },
	UpgradeDelay     = { default = 5,      min = 1,    max = 15,  step = 0.5 },
	EquipDelay       = { default = 2,      min = 0.5,  max = 5,   step = 0.25 },
	FreeDelay        = { default = 5,      min = 1,    max = 15,  step = 0.5 },
	SellDelay        = { default = 5,      min = 1,    max = 15,  step = 0.5 },
	ClickDelay       = { default = 0.4,    min = 0.1,  max = 2,   step = 0.1 },
	FarmUpgradeDelay = { default = 60,     min = 5,    max = 120, step = 5 },
}

local SAVED_KEYS = {
	"PerfectValue", "TapMethod", "TrainDelay", "UpgradeDelay",
	"EquipDelay", "FreeDelay", "SellDelay", "ClickDelay", "FarmUpgradeDelay",
}

local Config = {
	AutoThrow = false,
	AutoTrain = false,
	AutoEquipBest = false,
	AutoSell = false,
	AutoUpgradeBar = false,
	AutoClaimFreeAnimal = false,
	AutoFarm = false,
	PathLock = false,
	AutoTool = false,
	AutoClick = false,
}
for key, rule in pairs(SETTINGS_SCHEMA) do Config[key] = rule.default end

local FEATURE_KEYS = {
	"AutoThrow", "AutoTrain", "AutoEquipBest", "AutoSell", "AutoUpgradeBar", "AutoClaimFreeAnimal",
	"AutoFarm", "PathLock", "AutoTool", "AutoClick",
}

local alive = true
local connections = {}
local function track(connection)
	table.insert(connections, connection)
	return connection
end

local notify = function() end

local lastWarning
local function log(message)
	message = tostring(message)
	if message == lastWarning then return end
	lastWarning = message
	warn("[Brineland] " .. message)
end

-- ============================================================
-- CONFIG: VALIDATION + FILE
-- ============================================================
local function validateSetting(key, value)
	local rule = SETTINGS_SCHEMA[key]
	if not rule then return nil, "unknown setting" end

	if type(value) ~= "number" or value ~= value or value == math.huge or value == -math.huge then
		return nil, "expected a finite number"
	end

	local clamped = math.max(rule.min, math.min(rule.max, value))
	local snapped = rule.min + math.floor((clamped - rule.min) / rule.step + 0.5) * rule.step
	snapped = math.max(rule.min, math.min(rule.max, snapped))
	return math.floor(snapped * 10000 + 0.5) / 10000
end

local saveQueued = false
local function queueSave() end

local function setSetting(key, value)
	local valid = validateSetting(key, value)
	if valid == nil or valid == Config[key] then return false end
	Config[key] = valid
	queueSave()
	return true
end

local function saveSettings()
	if not (writefile and makefolder and isfolder) then return end
	local data = {}
	for _, key in ipairs(SAVED_KEYS) do data[key] = Config[key] end
	pcall(function()
		if not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end
		writefile(CONFIG_PATH, HttpService:JSONEncode(data))
	end)
end

queueSave = function()
	if saveQueued then return end
	saveQueued = true
	task.delay(0.6, function()
		saveQueued = false
		if alive then saveSettings() end
	end)
end

local function loadSettings()
	if not (readfile and isfile) then return end
	local okRead, raw = pcall(function()
		if isfile(CONFIG_PATH) then return readfile(CONFIG_PATH) end
	end)
	if not okRead or raw == nil then return end

	local okDecode, data = pcall(function() return HttpService:JSONDecode(raw) end)
	if not okDecode or type(data) ~= "table" then return end

	for _, key in ipairs(SAVED_KEYS) do
		local stored = data[key]
		if stored ~= nil then
			local valid = validateSetting(key, stored)
			if valid ~= nil then Config[key] = valid end
		end
	end
end
loadSettings()

-- ============================================================
-- REMOTES
-- ============================================================
local RemoteStatus = { Missing = "Missing", Failed = "Failed", Sent = "Sent", Returned = "Returned" }
local RemotesFolder
local RemoteCache = {}

local function getRemotesFolder()
	if RemotesFolder and RemotesFolder:IsDescendantOf(ReplicatedStorage) then
		return RemotesFolder
	end
	RemotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
	table.clear(RemoteCache)
	return RemotesFolder
end

local function getRemote(name)
	local cached = RemoteCache[name]
	if cached and cached:IsDescendantOf(ReplicatedStorage) then return cached end
	RemoteCache[name] = nil

	local folder = getRemotesFolder()
	if not folder then return nil, "Remotes folder not found" end

	local remote = folder:FindFirstChild(name)
	if not remote then return nil, "not in Remotes folder" end
	RemoteCache[name] = remote
	return remote
end

local function invokeFunction(remote, args)
	local finished, ok, result = false, false, nil
	local worker = task.spawn(function()
		ok, result = pcall(function()
			return remote:InvokeServer(table.unpack(args, 1, args.n))
		end)
		finished = true
	end)

	local startedAt = os.clock()
	while not finished and os.clock() - startedAt < REMOTE_TIMEOUT do
		task.wait()
	end

	if not finished then
		pcall(task.cancel, worker)
		return false, "timed out"
	end
	return ok, result
end

local RemoteLast = {}

local function clip(text, limit)
	text = tostring(text)
	if #text > limit then return string.sub(text, 1, limit - 3) .. "..." end
	return text
end

local function summarize(value)
	if value == nil then return "returned nothing" end
	if typeof(value) ~= "table" then return clip(value, 60) end
	local parts, count = {}, 0
	for key, item in pairs(value) do
		count = count + 1
		if count > 5 then table.insert(parts, "..."); break end
		local kind = typeof(item)
		local shown = (kind == "string" or kind == "number" or kind == "boolean") and tostring(item) or kind
		table.insert(parts, tostring(key) .. "=" .. clip(shown, 20))
	end
	return clip("{" .. table.concat(parts, ", ") .. "}", 70)
end

local function callRemote(name, ...)
	local remote, reason = getRemote(name)
	if not remote then
		RemoteLast[name] = "missing (" .. reason .. ")"
		return RemoteStatus.Missing, reason
	end

	local args = table.pack(...)
	if remote:IsA("RemoteFunction") then
		local ok, result = invokeFunction(remote, args)
		if not ok then
			RemoteLast[name] = "failed: " .. clip(result, 50)
			return RemoteStatus.Failed, result
		end
		RemoteLast[name] = summarize(result)
		return RemoteStatus.Returned, result
	end

	local ok, err = pcall(function()
		remote:FireServer(table.unpack(args, 1, args.n))
	end)
	if not ok then
		RemoteLast[name] = "failed: " .. clip(err, 50)
		return RemoteStatus.Failed, err
	end
	RemoteLast[name] = "sent (event)"
	return RemoteStatus.Sent
end

task.spawn(function()
	local folder = ReplicatedStorage:WaitForChild("Remotes", 15)
	if not alive then return end
	if folder then
		RemotesFolder = folder
		table.clear(RemoteCache)
	end
end)

-- ============================================================
-- LOOP ENGINE
-- ============================================================
local Tokens = {}

local function startLoop(key, intervalFn, action)
	local token = {}
	Tokens[key] = token
	Config[key] = true
	task.spawn(function()
		while alive and Config[key] and Tokens[key] == token do
			local ok, err = pcall(action)
			if not ok then log(key .. " error: " .. tostring(err)) end
			task.wait(math.max(0.05, intervalFn()))
		end
	end)
end

local function stopLoop(key)
	Config[key] = false
	Tokens[key] = nil
end

-- ============================================================
-- FEATURES
-- ============================================================
local function equipTool()
	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum or char:FindFirstChildOfClass("Tool") then return end
	local backpack = LocalPlayer:FindFirstChild("Backpack")
	local tool = backpack and backpack:FindFirstChildOfClass("Tool")
	if tool then hum:EquipTool(tool) end
end

local function virtualClick()
	local camera = workspace.CurrentCamera
	local size = camera and camera.ViewportSize or Vector2.new(800, 400)
	VirtualUser:CaptureController()
	VirtualUser:ClickButton1(Vector2.new(size.X / 2, size.Y / 2))
end

local function pathLock()
	local area = workspace:FindFirstChild("StarterArea")
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not (area and hrp and area:IsA("PVInstance")) then return end
	local areaCFrame = area:GetPivot()
	if (hrp.Position - areaCFrame.Position).Magnitude > PATH_RADIUS then
		char:PivotTo(areaCFrame + Vector3.new(0, 3, 0))
	end
end

track(LocalPlayer.Idled:Connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end))

local function teleportTo(position, tolerance)
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return false end
	local offset = hrp.Position - position
	local flat = Vector3.new(offset.X, 0, offset.Z).Magnitude
	if flat > (tolerance or TELEPORT_TOLERANCE) or math.abs(offset.Y) > 15 then
		hrp.CFrame = CFrame.new(position, position + hrp.CFrame.LookVector)
		hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		return true
	end
	return false
end

-- ============================================================
-- TREADMILL FINDER
-- ============================================================
local Treadmill = { inst = nil, position = nil, how = "none", scannedAt = -math.huge }
local treadmillScanning = false
local TRAIN_TOLERANCE = 2.5
local OWNER_KEYS = {
	owner = true, ownerid = true, owneruserid = true, ownername = true,
	userid = true, playerid = true, player = true, playername = true,
}

local function isMe(value)
	if value == nil then return false end
	if typeof(value) == "Instance" then return value == LocalPlayer end
	local text = tostring(value)
	return text == tostring(LocalPlayer.UserId) or text == LocalPlayer.Name or text == LocalPlayer.DisplayName
end

local function isAnotherPlayer(name)
	local function checkName(other)
		return other ~= LocalPlayer and (name == other.Name or name == other.DisplayName or name == tostring(other.UserId))
	end
	for _, other in ipairs(Players:GetPlayers()) do
		if checkName(other) then return true end
	end
	return false
end

local function ownership(inst)
	local node = inst
	while node and node ~= workspace do
		for key, value in pairs(node:GetAttributes()) do
			if OWNER_KEYS[string.lower(key)] then return isMe(value) and 2 or -1 end
		end
		for _, child in ipairs(node:GetChildren()) do
			if OWNER_KEYS[string.lower(child.Name)] and (child:IsA("ObjectValue") or child:IsA("StringValue") or child:IsA("IntValue") or child:IsA("NumberValue")) then
				return isMe(child.Value) and 2 or -1
			end
		end
		if isMe(node.Name) then return 1 end
		if isAnotherPlayer(node.Name) then return -1 end
		node = node.Parent
	end
	return 0
end

local function nameSaysTreadmill(inst)
	return string.find(string.lower(inst.Name), "treadmill", 1, true) ~= nil
end

local function treadmillAncestor(part)
	local node = part.Parent
	while node and node ~= workspace do
		if node:IsA("Model") and nameSaysTreadmill(node) then return node end
		node = node.Parent
	end
	return nil
end

local function findTreadmillCandidates()
	local found, seen = {}, {}
	for index, inst in ipairs(workspace:GetDescendants()) do
		if index % 4000 == 0 then task.wait() end
		if nameSaysTreadmill(inst) and (inst:IsA("Model") or inst:IsA("BasePart")) then
			local target = inst
			if inst:IsA("BasePart") then target = treadmillAncestor(inst) or inst end
			if not seen[target] then
				seen[target] = true
				table.insert(found, target)
			end
		end
	end
	local leaves = {}
	for _, candidate in ipairs(found) do
		local container = false
		for _, other in ipairs(found) do
			if other ~= candidate and other:IsDescendantOf(candidate) then container = true; break end
		end
		if not container then table.insert(leaves, candidate) end
	end
	return leaves
end

local function standPositionOn(target)
	local best, bestArea
	local function consider(part)
		if part:IsA("BasePart") then
			local size = part.Size
			local area = size.X * size.Y * size.Z / math.max(0.05, math.min(size.X, size.Y, size.Z))
			if not bestArea or area > bestArea then best, bestArea = part, area end
		end
	end
	consider(target)
	for _, descendant in ipairs(target:GetDescendants()) do consider(descendant) end
	if not best then return nil end
	local cf, size = best.CFrame, best.Size
	local halfHeight = (math.abs(cf.RightVector.Y) * size.X + math.abs(cf.UpVector.Y) * size.Y + math.abs(cf.LookVector.Y) * size.Z) / 2
	return best.Position + Vector3.new(0, halfHeight + 3.5, 0)
end

local function refreshTreadmill()
	Treadmill.scannedAt = os.clock()
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")

	local options = {}
	for _, candidate in ipairs(findTreadmillCandidates()) do
		local position = standPositionOn(candidate)
		if position then
			table.insert(options, {
				inst = candidate, position = position, score = ownership(candidate),
				distance = root and (root.Position - position).Magnitude or 0,
			})
		end
	end

	local best
	for _, option in ipairs(options) do
		local usable = option.score >= 0
		local bestUsable = best and best.score >= 0
		if not best or (usable and not bestUsable) or (usable == bestUsable and (option.score > best.score or (option.score == best.score and option.distance < best.distance))) then
			best = option
		end
	end

	if best then
		Treadmill.inst = best.inst
		Treadmill.position = best.position
		Treadmill.how = best.score == 2 and "yours" or best.score == 1 and "named after you" or best.score == 0 and "nearest" or "nearest (owner unknown)"
	else
		Treadmill.inst, Treadmill.position, Treadmill.how = nil, nil, "none"
	end
end

local function ensureTreadmill()
	local inst = Treadmill.inst
	local valid = inst and inst:IsDescendantOf(workspace)
	local age = os.clock() - Treadmill.scannedAt
	if treadmillScanning or (valid and age < 60) or (not valid and age < 4) then return end
	treadmillScanning = true
	pcall(refreshTreadmill)
	treadmillScanning = false
end

local function trainSpot()
	local inst = Treadmill.inst
	if inst and inst:IsDescendantOf(workspace) and Treadmill.position then
		return Treadmill.position, TRAIN_TOLERANCE
	end
	return TRAIN_POSITION, TELEPORT_TOLERANCE
end

-- ============================================================
-- TRAINING
-- ============================================================
local Farm = { phase = 1, left1 = PHASE1_SECONDS, left2 = PHASE2_SECONDS, resetGen = 0 }
local trainingLoopRunning = false
local trainWithObject = false

local function wantsTraining()
	if Config.AutoFarm then return Farm.phase == 1 end
	return Config.AutoTrain
end

local function movesForTraining()
	return wantsTraining() and not (Config.AutoThrow and not Config.AutoFarm)
end

local function looksRejected(status, value)
	if status == RemoteStatus.Failed then return true end
	if value == false then return true end
	if type(value) == "table" then
		for key, item in pairs(value) do
			local lower = type(key) == "string" and string.lower(key) or ""
			if item == false and (lower == "success" or lower == "ok" or lower == "succeeded" or lower == "started" or lower == "allowed") then return true end
			if (lower == "error" or lower == "err") and item ~= nil and item ~= false then return true end
		end
	end
	return false
end

local function trainCall(name)
	local treadmill = Treadmill.inst
	if trainWithObject and treadmill and treadmill:IsDescendantOf(workspace) then
		return callRemote(name, treadmill)
	end
	return callRemote(name)
end

local function shortName(inst)
	return string.gsub(inst:GetFullName(), "^Workspace%.", "")
end

local function trainStatusText()
	local lines = {}
	if not wantsTraining() then
		table.insert(lines, "Training is off.")
	else
		table.insert(lines, "Training: sending Start every " .. Config.TrainDelay .. "s")
	end
	local inst = Treadmill.inst
	if inst and inst:IsDescendantOf(workspace) then
		table.insert(lines, "Treadmill: " .. Treadmill.how .. " - " .. clip(shortName(inst), 36))
	else
		table.insert(lines, "Treadmill: not found, using default spot")
	end
	if Config.AutoTrain and Config.AutoThrow and not Config.AutoFarm then
		table.insert(lines, "Staying put because Auto Throw is on.")
	end
	table.insert(lines, "Server: " .. (RemoteLast.Training_Start or "no reply yet"))
	return table.concat(lines, "\n")
end

local function refreshTraining()
	if trainingLoopRunning or not wantsTraining() then return end
	trainingLoopRunning = true

	task.spawn(function()
		pcall(function()
			repeat
				local sinceStart = math.huge
				local sinceMove = math.huge
				local lastClock = os.clock()

				while alive and wantsTraining() do
					ensureTreadmill()
					local now = os.clock()
					local elapsed = now - lastClock
					lastClock = now
					sinceStart = sinceStart + elapsed
					sinceMove = sinceMove + elapsed

					if movesForTraining() and sinceMove >= TELEPORT_INTERVAL then
						sinceMove = 0
						local position, tolerance = trainSpot()
						if teleportTo(position, tolerance) then
							sinceStart = math.min(sinceStart, Config.TrainDelay - 0.3)
						end
					end

					if sinceStart >= Config.TrainDelay then
						sinceStart = 0
						local status, value = trainCall("Training_Start")
						if status ~= RemoteStatus.Missing and Treadmill.inst and looksRejected(status, value) then
							trainWithObject = not trainWithObject
						end
					end
					task.wait(0.1)
				end
				trainCall("Training_Stop")
			until not (alive and wantsTraining())
		end)
		trainingLoopRunning = false
	end)
end

-- ============================================================
-- AUTO THROW
-- ============================================================
local ThrowUI = { label = nil, scannedAt = 0, numbers = {}, numbersAt = 0 }
local ThrowInfo = {
	found = false, value = nil, peak = 0, taps = 0, lastTapValue = nil, lastTapNote = "",
	skipPressed = 0, hiddenGuis = 0, guiHiderOff = false,
}
local throwWatcherRunning = false
local cameraHold = nil
local cameraBound = false
local guiGuard = nil
local hiddenGuis = {}
local ThrowSpot = nil
local CAMERA_BIND = "BrinelandNoCutscene"
local TAP_NAMES = { "screen tap", "game button", "virtual click" }
local hubCovers = function() return false end

local function wantsThrowing()
	if Config.AutoFarm then return Farm.phase == 2 end
	return Config.AutoThrow
end

local function isShown(inst)
	local node = inst
	while node do
		if node:IsA("GuiObject") and not node.Visible then return false end
		if node:IsA("LayerCollector") and not node.Enabled then return false end
		node = node.Parent
	end
	return true
end

local function numberFromText(text)
	local plain = string.gsub(text, "<[^>]+>", "")
	return tonumber(string.match(plain, "^%s*%+%s*(%d+)%s*$"))
end

local function findTapLabel()
	ThrowUI.scannedAt = os.clock()
	for _, inst in ipairs(PlayerGui:GetDescendants()) do
		if inst:IsA("TextLabel") or inst:IsA("TextButton") then
			if string.find(string.upper(inst.Text), "TAP TO THROW", 1, true) and not inst:FindFirstAncestor("ThrowFoodHub") then
				return inst
			end
		end
	end
	return nil
end

local function collectNumberLabels(root)
	local found = {}
	for _, inst in ipairs(root:GetDescendants()) do
		if inst:IsA("TextLabel") and numberFromText(inst.Text) and not inst:FindFirstAncestor("ThrowFoodHub") then
			table.insert(found, inst)
		end
	end
	return found
end

local function readNumber(tapLabel)
	local best, bestDistance
	local center = tapLabel.AbsolutePosition + tapLabel.AbsoluteSize / 2
	for _, inst in ipairs(ThrowUI.numbers) do
		if inst:IsDescendantOf(PlayerGui) and isShown(inst) then
			local value = numberFromText(inst.Text)
			if value then
				local distance = (inst.AbsolutePosition - center).Magnitude
				if not bestDistance or distance < bestDistance then best, bestDistance = value, distance end
			end
		end
	end
	return best
end

local function readBarValue()
	local now = os.clock()
	local label = ThrowUI.label

	if not (label and label:IsDescendantOf(PlayerGui)) then
		ThrowUI.label = nil
		if now - ThrowUI.scannedAt < 0.5 then
			ThrowInfo.found = false
			return nil
		end
		label = findTapLabel()
		ThrowUI.label = label
		ThrowUI.numbers = {}
		ThrowUI.numbersAt = 0
		if not label then
			ThrowInfo.found = false
			return nil
		end
	end

	ThrowInfo.found = true
	if not isShown(label) then return nil end

	local value = readNumber(label)
	if value == nil and now - ThrowUI.numbersAt >= 0.5 then
		ThrowUI.numbersAt = now
		local root = label:FindFirstAncestorWhichIsA("ScreenGui")
		ThrowUI.numbers = root and collectNumberLabels(root) or {}
		if #ThrowUI.numbers == 0 then ThrowUI.numbers = collectNumberLabels(PlayerGui) end
		value = readNumber(label)
	end
	return value
end

local function pickTapPoint()
	local camera = workspace.CurrentCamera
	local size = camera and camera.ViewportSize or Vector2.new(800, 400)
	local candidates = {
		Vector2.new(size.X * 0.5, size.Y * 0.5),
		Vector2.new(size.X * 0.3, size.Y * 0.5),
		Vector2.new(size.X * 0.7, size.Y * 0.5),
		Vector2.new(size.X * 0.5, size.Y * 0.92),
		Vector2.new(size.X * 0.5, size.Y * 0.12),
	}
	for _, point in ipairs(candidates) do
		if not hubCovers(point) then return point end
	end
	return candidates[1]
end

local function tapWithInputManager(point)
	local okService, manager = pcall(function() return game:GetService("VirtualInputManager") end)
	if not (okService and manager) then return false end
	local ok = pcall(function()
		if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
			manager:SendTouchEvent(1, 0, point.X, point.Y)
			task.wait(0.03)
			manager:SendTouchEvent(1, 2, point.X, point.Y)
		else
			manager:SendMouseButtonEvent(point.X, point.Y, 0, true, game, 1)
			task.wait(0.03)
			manager:SendMouseButtonEvent(point.X, point.Y, 0, false, game, 1)
		end
	end)
	return ok
end

local function findTapButton()
	local label = ThrowUI.label
	if not label then return nil end
	if label:IsA("GuiButton") then return label end
	local parentButton = label:FindFirstAncestorWhichIsA("GuiButton")
	if parentButton then return parentButton end

	local root = label:FindFirstAncestorWhichIsA("ScreenGui")
	local best, bestArea
	if root then
		for _, inst in ipairs(root:GetDescendants()) do
			if inst:IsA("GuiButton") and isShown(inst) then
				local area = inst.AbsoluteSize.X * inst.AbsoluteSize.Y
				if not bestArea or area > bestArea then best, bestArea = inst, area end
			end
		end
	end
	return best
end

local function pressButton(button)
	if getconnections then
		for _, name in ipairs({ "Activated", "MouseButton1Click", "MouseButton1Down" }) do
			local okList, list = pcall(getconnections, button[name])
			if okList and type(list) == "table" and #list > 0 then
				for _, connection in ipairs(list) do pcall(function() connection:Fire() end) end
				return true
			end
		end
		return false
	end
	if firesignal then return (pcall(firesignal, button.Activated)) end
	return false
end

local function tapWithVirtualUser(point)
	return (pcall(function()
		VirtualUser:CaptureController()
		VirtualUser:ClickButton1(point)
	end))
end

local function tapForThrow()
	local point = pickTapPoint()
	for offset = 0, 2 do
		local method = ((Config.TapMethod - 1 + offset) % 3) + 1
		local worked = false
		if method == 1 then worked = tapWithInputManager(point)
		elseif method == 2 then
			local button = findTapButton()
			worked = button ~= nil and pressButton(button)
		else worked = tapWithVirtualUser(point) end
		if worked then return TAP_NAMES[method] end
	end
	return nil
end

local function captureCamera()
	local camera = workspace.CurrentCamera
	if not camera then return nil end
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	return {
		type = camera.CameraType, subject = camera.CameraSubject,
		fov = camera.FieldOfView, cframe = camera.CFrame,
		rootPos = root and root.Position or nil, expires = os.clock() + 15,
	}
end

local function releaseCamera()
	local hold = cameraHold
	cameraHold = nil
	if cameraBound then
		cameraBound = false
		pcall(function() RunService:UnbindFromRenderStep(CAMERA_BIND) end)
	end
	local camera = workspace.CurrentCamera
	if hold and camera then
		camera.CameraType = hold.type
		if hold.subject then camera.CameraSubject = hold.subject end
	end
end

local function holdCamera(state)
	cameraHold = state
	if cameraBound then return end
	cameraBound = true
	RunService:BindToRenderStep(CAMERA_BIND, Enum.RenderPriority.Last.Value + 100, function()
		local hold = cameraHold
		local camera = workspace.CurrentCamera
		if not hold or not camera or not alive or os.clock() > hold.expires then
			releaseCamera()
			return
		end
		if hold.rootPos then
			local char = LocalPlayer.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if not root or (root.Position - hold.rootPos).Magnitude > 8 then
				releaseCamera()
				return
			end
		end
		camera.CameraType = Enum.CameraType.Scriptable
		camera.FieldOfView = hold.fov
		camera.CFrame = hold.cframe
	end)
end

local function snapshotGuis()
	local baseline = {}
	for _, gui in ipairs(PlayerGui:GetChildren()) do
		if gui:IsA("ScreenGui") and gui.Enabled then baseline[gui] = true end
	end
	return baseline
end

local function isBarGui(gui)
	local root = ThrowUI.label and ThrowUI.label:FindFirstAncestorWhichIsA("ScreenGui")
	if gui == root then return true end
	for _, label in ipairs(ThrowUI.numbers) do
		if label:IsDescendantOf(gui) then return true end
	end
	local lower = string.lower(gui.Name)
	if string.find(lower, "throw", 1, true) and not (string.find(lower, "cutscene", 1, true) or string.find(lower, "cinematic", 1, true)) then
		return true
	end
	return false
end

local function hideNewGuis()
	local guard = guiGuard
	if not guard or ThrowInfo.guiHiderOff then return end
	if os.clock() > guard.expires then guiGuard = nil; return end
	for _, gui in ipairs(PlayerGui:GetChildren()) do
		if gui:IsA("ScreenGui") and gui.Enabled and not guard.baseline[gui] and gui.Name ~= "ThrowFoodHub" and not isBarGui(gui) then
			gui.Enabled = false
			hiddenGuis[gui] = true
			ThrowInfo.hiddenGuis = ThrowInfo.hiddenGuis + 1
		end
	end
end

local function restoreHiddenGuis()
	for gui in pairs(hiddenGuis) do
		if gui.Parent then gui.Enabled = true end
		hiddenGuis[gui] = nil
	end
end

local function screenCenterOf(inst)
	local center = inst.AbsolutePosition + inst.AbsoluteSize / 2
	local gui = inst:FindFirstAncestorWhichIsA("ScreenGui")
	if gui and not gui.IgnoreGuiInset then center = center + GuiService:GetGuiInset() end
	return center
end

local function pressSkipButton()
	local function checkButton(inst)
		if inst:IsA("GuiButton") and isShown(inst) and not inst:FindFirstAncestor("ThrowFoodHub") then
			local text = inst:IsA("TextButton") and inst.Text or ""
			if text == "" then
				for _, child in ipairs(inst:GetChildren()) do
					if child:IsA("TextLabel") then text = child.Text; break end
				end
			end
			local plain = string.gsub(text, "<[^>]+>", "")
			if string.match(string.upper(plain), "^%s*SKIP") then
				if not pressButton(inst) then tapWithInputManager(screenCenterOf(inst)) end
				return true
			end
		end
		return false
	end
	for _, inst in ipairs(PlayerGui:GetDescendants()) do
		if checkButton(inst) then return true end
	end
	return false
end

local function skipCutscene()
	task.wait(0.15)
	callRemote("Throw_Complete")
	for _ = 1, 6 do
		task.wait(0.4)
		if not alive then break end
		if pressSkipButton() then
			ThrowInfo.skipPressed = ThrowInfo.skipPressed + 1
			break
		end
	end
end

local function learnThrowSpot()
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if root then ThrowSpot = root.Position end
end

local function throwSpotPosition()
	return ThrowSpot or THROW_POSITION
end

local function learnThrowSpotIfBarVisible()
	readBarValue()
	local label = ThrowUI.label
	if label and label:IsDescendantOf(PlayerGui) and isShown(label) then learnThrowSpot() end
end

local function refreshThrowing()
	if throwWatcherRunning or not wantsThrowing() then return end
	throwWatcherRunning = true

	task.spawn(function()
		pcall(function()
			local armed = true
			local lastTapAt = 0
			local lastLearnAt = 0
			local barMissingSince = nil

			while alive and wantsThrowing() do
				RunService.RenderStepped:Wait()
				local value = readBarValue()
				ThrowInfo.value = value
				if value and value > ThrowInfo.peak then ThrowInfo.peak = value end

				hideNewGuis()

				if value == nil then
					armed = true
					barMissingSince = barMissingSince or os.clock()
					if next(hiddenGuis) and not ThrowInfo.guiHiderOff and os.clock() - barMissingSince > 10 then
						restoreHiddenGuis()
						ThrowInfo.guiHiderOff = true
						guiGuard = nil
					end
				else
					barMissingSince = nil
					if next(hiddenGuis) and os.clock() - lastTapAt > 1.5 then table.clear(hiddenGuis) end
					if os.clock() - lastLearnAt > 1 then
						lastLearnAt = os.clock()
						learnThrowSpot()
					end

					if value < Config.PerfectValue then
						armed = true
					elseif armed then
						armed = false
						lastTapAt = os.clock()

						if cameraHold then cameraHold.expires = os.clock() + 15
						else
							local state = captureCamera()
							if state then holdCamera(state) end
						end
						if not ThrowInfo.guiHiderOff then
							guiGuard = { baseline = snapshotGuis(), expires = os.clock() + 6 }
						end

						task.spawn(function()
							local method = tapForThrow()
							ThrowInfo.taps = ThrowInfo.taps + 1
							ThrowInfo.lastTapValue = value
							ThrowInfo.lastTapNote = method or "no tap method could run"
							skipCutscene()
						end)
					elseif os.clock() - lastTapAt > 2 then
						armed = true
					end
				end
			end
		end)
		throwWatcherRunning = false
		ThrowInfo.value = nil
		releaseCamera()
	end)
end

local function throwStatusText()
	local lines = {}
	if not wantsThrowing() then
		table.insert(lines, "Auto Throw is off.")
	elseif not ThrowInfo.found then
		table.insert(lines, "Looking for the throw bar... stand at the throw spot.")
	elseif ThrowInfo.value == nil then
		table.insert(lines, "Throw bar not on screen right now.")
	else
		table.insert(lines, "Bar: +" .. ThrowInfo.value .. "   (taps at +" .. Config.PerfectValue .. ")")
	end
	if ThrowInfo.peak > 0 then
		table.insert(lines, "Highest bar value seen: +" .. ThrowInfo.peak)
	end
	if ThrowInfo.taps > 0 then
		table.insert(lines, "Taps: " .. ThrowInfo.taps .. " (last at +" .. tostring(ThrowInfo.lastTapValue) .. ", " .. ThrowInfo.lastTapNote .. ")")
		table.insert(lines, "Cutscene: camera " .. (cameraHold and "locked" or "free")
			.. ", screens hidden " .. ThrowInfo.hiddenGuis .. (ThrowInfo.guiHiderOff and " (off)" or "")
			.. ", Skip " .. ThrowInfo.skipPressed + 1 .. "x")
		table.insert(lines, "Throw_Complete: " .. (RemoteLast.Throw_Complete or "n/a"))
	end
	return table.concat(lines, "\n")
end

-- ============================================================
-- AUTO FARM
-- ============================================================
local function farmStatusText()
	local left = Farm.phase == 1 and Farm.left1 or Farm.left2
	local name = Farm.phase == 1 and "Phase 1: Training + Upgrades" or "Phase 2: Throw + Equip + Sell"
	return name .. "\n" .. math.max(0, math.floor(left)) .. "s left" .. (Config.AutoFarm and " (running)" or " (paused)")
end

local function newPhaseTimers(phase)
	if phase == 1 then return { upgrade = math.huge } end
	return { teleport = math.huge, equip = math.huge, sell = math.huge }
end

local function advanceTimers(timers, dt)
	for key, value in pairs(timers) do timers[key] = value + dt end
end

local function due(timers, key, delay)
	if timers[key] >= delay then timers[key] = 0; return true end
	return false
end

local function resetFarmCycle()
	Farm.phase = 1
	Farm.left1 = PHASE1_SECONDS
	Farm.left2 = PHASE2_SECONDS
	Farm.resetGen = Farm.resetGen + 1
	refreshTraining()
end

local function farmLoop(token)
	local currentGen = Farm.resetGen
	local timers = newPhaseTimers(Farm.phase)
	local lastTick = os.clock()

	local function stillOn() return alive and Config.AutoFarm and Tokens.AutoFarm == token end
	local function stale() return not stillOn() or Farm.resetGen ~= currentGen end

	local function switchPhase(newPhase)
		Farm.phase = newPhase
		timers = newPhaseTimers(newPhase)
		refreshTraining()
		refreshThrowing()
	end

	local function runTick(dt)
		if Farm.phase == 1 then
			advanceTimers(timers, dt)
			refreshTraining()
			if due(timers, "upgrade", Config.FarmUpgradeDelay) then callRemote("Stand_Upgrade") end
			if stale() then return end
			Farm.left1 = Farm.left1 - dt
			if Farm.left1 <= 0 then
				Farm.left1 = PHASE1_SECONDS
				switchPhase(2)
				notify("Switching Phase", "Phase 2: throw, equip best and sell starting.", 3)
			end
		else
			advanceTimers(timers, dt)
			if due(timers, "teleport", TELEPORT_INTERVAL) then teleportTo(throwSpotPosition()) end
			refreshThrowing()
			if due(timers, "equip", Config.EquipDelay) then callRemote("Plot_EquipBest") end
			if stale() then return end
			if due(timers, "sell", Config.SellDelay) then callRemote("Plot_SellAll") end
			if stale() then return end
			Farm.left2 = Farm.left2 - dt
			if Farm.left2 <= 0 then
				Farm.left2 = PHASE2_SECONDS
				switchPhase(1)
				notify("Loop Restarting", "Returning to Phase 1 (training and upgrades).", 3)
			end
		end
	end

	while stillOn() do
		if Farm.resetGen ~= currentGen then
			currentGen = Farm.resetGen
			timers = newPhaseTimers(Farm.phase)
			lastTick = os.clock()
		end

		local now = os.clock()
		local dt = now - lastTick
		lastTick = now

		runTick(dt)
		task.wait(0.05)
	end
end

local function startFarm()
	local token = {}
	Tokens.AutoFarm = token
	Config.AutoFarm = true
	notify("Auto Farming Resumed", farmStatusText(), 3)
	pcall(learnThrowSpotIfBarVisible)
	refreshTraining()
	refreshThrowing()
	task.spawn(function()
		pcall(farmLoop, token)
	end)
end

local function stopFarm()
	stopLoop("AutoFarm")
	notify("Auto Farming Paused", farmStatusText(), 3)
end

-- ============================================================
-- GUI & UI (Safe UIInstancing & Oval Brineland Pill Header)
-- ============================================================
local THEME = {
	Panel = Color3.fromRGB(16, 12, 28),
	Top = Color3.fromRGB(25, 18, 45),
	Row = Color3.fromRGB(24, 16, 45),
	Tab = Color3.fromRGB(30, 20, 55),
	TabText = Color3.fromRGB(170, 160, 210),
	Accent = Color3.fromRGB(0, 229, 255),
	TabOn = Color3.fromRGB(0, 160, 240),
	Off = Color3.fromRGB(45, 30, 75),
	Text = Color3.fromRGB(240, 240, 255),
	Purple = Color3.fromRGB(120, 50, 255),
}

local function make(class, props, parent)
	local inst = Instance.new(class)
	for key, value in pairs(props) do inst[key] = value end
	if parent then inst.Parent = parent end
	return inst
end

local function round(inst, radius)
	return make("UICorner", { CornerRadius = radius }, inst)
end

local ScreenGui = make("ScreenGui", {
	Name = "ThrowFoodHub",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	DisplayOrder = 999,
})
pcall(function() ScreenGui.Parent = (gethui and gethui()) or CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = PlayerGui end

local function makeDraggable(handle, target)
	local dragging, dragStart, startPos, moved = false, nil, nil, 0
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			moved = 0
			dragStart = input.Position
			startPos = target.Position
		end
	end)
	track(UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			moved = math.max(moved, math.abs(delta.X) + math.abs(delta.Y))
			target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end))
	track(UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end))
	return function() return moved > 8 end
end

-- Main Window
local MainFrame = make("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromScale(0.5, 0.8),
	BackgroundColor3 = THEME.Panel,
	BackgroundTransparency = 0.05,
	BorderSizePixel = 0,
	Visible = true,
	Active = true,
	ClipsDescendants = true,
}, ScreenGui)
make("UISizeConstraint", { MinSize = Vector2.new(330, 240), MaxSize = Vector2.new(420, 420) }, MainFrame)
round(MainFrame, UDim.new(0, 10))
make("UIStroke", { Color = Color3.fromRGB(90, 40, 220), Thickness = 1.5 }, MainFrame)

local TopBar = make("Frame", {
	Size = UDim2.new(1, 0, 0, 38),
	BackgroundColor3 = THEME.Top,
	BorderSizePixel = 0,
}, MainFrame)
round(TopBar, UDim.new(0, 10))
make("Frame", {
	Size = UDim2.new(1, 0, 0.5, 0),
	Position = UDim2.new(0, 0, 0.5, 0),
	BackgroundColor3 = THEME.Top,
	BorderSizePixel = 0,
}, TopBar)

make("TextLabel", {
	Size = UDim2.new(1, -76, 1, 0),
	Position = UDim2.new(0, 12, 0, 0),
	BackgroundTransparency = 1,
	Text = '<b>BRINELAND</b> <font color="#00E5FF">| THROW FOOD</font>',
	TextColor3 = Color3.fromRGB(255, 255, 255),
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	RichText = true,
	TextXAlignment = Enum.TextXAlignment.Left,
}, TopBar)

local MinimizeBtn = make("TextButton", {
	Size = UDim2.fromOffset(26, 26),
	Position = UDim2.new(1, -62, 0.5, -13),
	BackgroundColor3 = Color3.fromRGB(45, 30, 80),
	Text = "-",
	TextColor3 = THEME.Accent,
	Font = Enum.Font.GothamBold,
	TextSize = 16,
}, TopBar)
round(MinimizeBtn, UDim.new(0, 6))

local CloseBtn = make("TextButton", {
	Size = UDim2.fromOffset(26, 26),
	Position = UDim2.new(1, -30, 0.5, -13),
	BackgroundColor3 = Color3.fromRGB(200, 35, 65),
	Text = "X",
	TextColor3 = Color3.fromRGB(255, 255, 255),
	Font = Enum.Font.GothamBold,
	TextSize = 12,
}, TopBar)
round(CloseBtn, UDim.new(0, 6))

makeDraggable(TopBar, MainFrame)

-- ============================================================
-- OVAL BRINELAND PILL HEADER (TOP CORNER)
-- ============================================================
local HubPill = make("Frame", {
	Name = "ThrowFoodPill",
	AnchorPoint = Vector2.new(0.5, 0),
	Position = UDim2.new(0.5, 0, 0, 4),
	Size = UDim2.new(0.44, 0, 0, 40),
	BackgroundColor3 = Color3.fromRGB(18, 12, 40),
	BorderSizePixel = 0,
	Active = true,
}, ScreenGui)
make("UISizeConstraint", { MinSize = Vector2.new(290, 36), MaxSize = Vector2.new(420, 44) }, HubPill)
round(HubPill, UDim.new(1, 0))
make("UIStroke", { Color = Color3.fromRGB(110, 55, 255), Thickness = 2 }, HubPill)

local pillTitle = make("TextLabel", {
	Size = UDim2.new(1, -96, 1, 0),
	Position = UDim2.new(0, 20, 0, 0),
	BackgroundTransparency = 1,
	Text = '<b>BRINELAND</b> <font color="#00E5FF">THROW FOOD HUB</font>',
	TextColor3 = Color3.fromRGB(255, 255, 255),
	Font = Enum.Font.GothamBold,
	TextScaled = true,
	RichText = true,
	TextXAlignment = Enum.TextXAlignment.Left,
}, HubPill)
make("UITextSizeConstraint", { MaxTextSize = 13, MinTextSize = 8 }, pillTitle)

local PlusBtn = make("TextButton", {
	Size = UDim2.fromOffset(30, 30),
	Position = UDim2.new(1, -74, 0.5, -15),
	BackgroundColor3 = Color3.fromRGB(62, 36, 150),
	Text = "-",
	TextColor3 = THEME.Accent,
	Font = Enum.Font.GothamBold,
	TextSize = 18,
	AutoButtonColor = true,
}, HubPill)
round(PlusBtn, UDim.new(0, 8))

local PillCloseBtn = make("TextButton", {
	Size = UDim2.fromOffset(30, 30),
	Position = UDim2.new(1, -38, 0.5, -15),
	BackgroundColor3 = Color3.fromRGB(205, 30, 62),
	Text = "X",
	TextColor3 = Color3.fromRGB(255, 255, 255),
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	AutoButtonColor = true,
}, HubPill)
round(PillCloseBtn, UDim.new(0, 8))

makeDraggable(HubPill, HubPill)

local function setWindowVisible(visible)
	MainFrame.Visible = visible
	PlusBtn.Text = visible and "-" or "+"
end
PlusBtn.MouseButton1Click:Connect(function() setWindowVisible(not MainFrame.Visible) end)
MinimizeBtn.MouseButton1Click:Connect(function() setWindowVisible(false) end)

hubCovers = function(point)
	local function inside(frame)
		if not (frame and frame.Visible) then return false end
		local position, size = frame.AbsolutePosition, frame.AbsoluteSize
		return point.X >= position.X - 8 and point.X <= position.X + size.X + 8
			and point.Y >= position.Y - 8 and point.Y <= position.Y + size.Y + 8
	end
	return inside(MainFrame) or inside(HubPill)
end

-- Toast notifications
local Toast
notify = function(title, message, duration)
	if not alive or not ScreenGui.Parent then return end
	if Toast then Toast:Destroy() end
	local toast = make("Frame", {
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1, -14),
		Size = UDim2.fromOffset(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = Color3.fromRGB(10, 8, 28),
		BorderSizePixel = 0,
	}, ScreenGui)
	round(toast, UDim.new(0, 10))
	make("UIStroke", { Color = THEME.Accent, Transparency = 0.4, Thickness = 1 }, toast)
	make("UIPadding", {
		PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14),
		PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8),
	}, toast)
	make("TextLabel", {
		Size = UDim2.fromOffset(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		TextWrapped = true,
		RichText = true,
		Font = Enum.Font.GothamMedium,
		TextSize = 12,
		TextColor3 = THEME.Text,
		Text = '<font color="#00E5FF"><b>' .. tostring(title) .. "</b></font>\n" .. tostring(message),
	}, toast)
	Toast = toast
	task.delay(duration or 4, function()
		if Toast == toast then Toast = nil end
		toast:Destroy()
	end)
end

-- Tabs
local TabBar = make("ScrollingFrame", {
	Size = UDim2.new(1, -12, 0, 32),
	Position = UDim2.new(0, 6, 0, 44),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 0,
	ScrollingDirection = Enum.ScrollingDirection.X,
	CanvasSize = UDim2.new(0, 0, 0, 0),
	AutomaticCanvasSize = Enum.AutomaticSize.X,
}, MainFrame)
make("UIListLayout", {
	FillDirection = Enum.FillDirection.Horizontal,
	Padding = UDim.new(0, 4),
	SortOrder = Enum.SortOrder.LayoutOrder,
}, TabBar)

local TabFrames = {}
local TabOrder = {}

local function selectTab(name)
	for tabName, data in pairs(TabFrames) do
		local on = tabName == name
		data.Container.Visible = on
		data.Button.BackgroundColor3 = on and THEME.TabOn or THEME.Tab
		data.Button.TextColor3 = on and Color3.fromRGB(255, 255, 255) or THEME.TabText
	end
end

local function CreateTab(tabName)
	local tabBtn = make("TextButton", {
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = THEME.Tab,
		Text = tabName,
		TextColor3 = THEME.TabText,
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		LayoutOrder = #TabOrder + 1,
	}, TabBar)
	round(tabBtn, UDim.new(0, 6))
	make("UIPadding", { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) }, tabBtn)

	local container = make("ScrollingFrame", {
		Size = UDim2.new(1, -12, 1, -86),
		Position = UDim2.new(0, 6, 0, 82),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = THEME.Accent,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Visible = false,
	}, MainFrame)
	make("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, container)
	make("UIPadding", { PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 8) }, container)

	TabFrames[tabName] = { Button = tabBtn, Container = container }
	table.insert(TabOrder, tabName)
	tabBtn.MouseButton1Click:Connect(function() selectTab(tabName) end)
	return container
end

-- UI Element Generators
local Toggles = {}
local rowOrder = setmetatable({}, { __mode = "k" })

local function nextOrder(parent)
	rowOrder[parent] = (rowOrder[parent] or 0) + 1
	return rowOrder[parent]
end

local function CreateSection(parent, text)
	make("TextLabel", {
		Size = UDim2.new(1, 0, 0, 18),
		BackgroundTransparency = 1,
		Text = string.upper(text),
		TextColor3 = THEME.Accent,
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		LayoutOrder = nextOrder(parent),
	}, parent)
end

local function CreateToggle(parent, text, configKey, callback)
	local frame = make("Frame", {
		Size = UDim2.new(1, 0, 0, 38),
		BackgroundColor3 = THEME.Row,
		BackgroundTransparency = 0.2,
		BorderSizePixel = 0,
		LayoutOrder = nextOrder(parent),
	}, parent)
	round(frame, UDim.new(0, 6))

	make("TextLabel", {
		Size = UDim2.new(1, -60, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = THEME.Text,
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, frame)

	local toggleBg = make("Frame", {
		Size = UDim2.fromOffset(40, 20),
		Position = UDim2.new(1, -46, 0.5, -10),
		BackgroundColor3 = Config[configKey] and THEME.Accent or THEME.Off,
		BorderSizePixel = 0,
	}, frame)
	round(toggleBg, UDim.new(1, 0))

	local knob = make("Frame", {
		Size = UDim2.fromOffset(16, 16),
		Position = Config[configKey] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
	}, toggleBg)
	round(knob, UDim.new(1, 0))

	local button = make("TextButton", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Text = "",
		ZIndex = 2,
	}, frame)

	local handle = {}
	function handle.Set(on)
		Config[configKey] = on and true or false
		local state = Config[configKey]
		TweenService:Create(knob, TweenInfo.new(0.15), {
			Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
		}):Play()
		toggleBg.BackgroundColor3 = state and THEME.Accent or THEME.Off
		if callback then
			local ok, err = pcall(callback, state)
			if not ok then log(configKey .. " toggle error: " .. tostring(err)) end
		end
		queueSave()
	end
	Toggles[configKey] = handle

	button.MouseButton1Click:Connect(function() handle.Set(not Config[configKey]) end)
	return handle
end

local function CreateButton(parent, text, callback)
	local button = make("TextButton", {
		Size = UDim2.new(1, 0, 0, 38),
		BackgroundColor3 = Color3.fromRGB(40, 25, 80),
		Text = text,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		LayoutOrder = nextOrder(parent),
	}, parent)
	round(button, UDim.new(0, 6))
	button.MouseButton1Click:Connect(function()
		task.spawn(function()
			local ok, err = pcall(callback)
			if not ok then log(text .. " error: " .. tostring(err)) end
		end)
	end)
	return button
end

local function CreateLabel(parent, text, height)
	local label = make("TextLabel", {
		Size = UDim2.new(1, 0, 0, height or 44),
		BackgroundColor3 = THEME.Row,
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
		Text = text,
		TextColor3 = THEME.TabText,
		Font = Enum.Font.GothamMedium,
		TextSize = 11,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		LayoutOrder = nextOrder(parent),
	}, parent)
	round(label, UDim.new(0, 6))
	make("UIPadding", {
		PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8),
		PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6),
	}, label)
	return label
end

local function formatNumber(value)
	return tostring(math.floor(value * 10000 + 0.5) / 10000)
end

local function CreateSlider(parent, text, configKey, suffix)
	local rule = SETTINGS_SCHEMA[configKey]
	local minV, maxV = rule.min, rule.max

	local frame = make("Frame", {
		Size = UDim2.new(1, 0, 0, 50),
		BackgroundColor3 = THEME.Row,
		BackgroundTransparency = 0.2,
		BorderSizePixel = 0,
		LayoutOrder = nextOrder(parent),
	}, parent)
	round(frame, UDim.new(0, 6))

	make("TextLabel", {
		Position = UDim2.new(0, 10, 0, 4),
		Size = UDim2.new(0.6, 0, 0, 18),
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = THEME.Text,
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, frame)
	local valueLabel = make("TextLabel", {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -10, 0, 4),
		Size = UDim2.new(0.4, 0, 0, 18),
		BackgroundTransparency = 1,
		TextColor3 = THEME.Accent,
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Right,
	}, frame)

	local hit = make("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 10, 1, -3),
		Size = UDim2.new(1, -20, 0, 24),
		BackgroundTransparency = 1,
		Active = true,
	}, frame)
	local bar = make("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(1, 0, 0, 8),
		BackgroundColor3 = THEME.Off,
		BorderSizePixel = 0,
	}, hit)
	round(bar, UDim.new(0, 4))
	local fill = make("Frame", {
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = THEME.Accent,
		BorderSizePixel = 0,
	}, bar)
	round(fill, UDim.new(0, 4))
	local knob = make("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.fromOffset(16, 16),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
		BorderSizePixel = 0,
	}, bar)
	round(knob, UDim.new(1, 0))

	local function render()
		local value = Config[configKey]
		local alpha = (maxV > minV) and (value - minV) / (maxV - minV) or 0
		fill.Size = UDim2.new(alpha, 0, 1, 0)
		knob.Position = UDim2.new(alpha, 0, 0.5, 0)
		valueLabel.Text = formatNumber(value) .. (suffix and (" " .. suffix) or "")
	end
	render()

	local function setFromAlpha(alpha)
		if setSetting(configKey, minV + alpha * (maxV - minV)) then render() end
	end

	local dragging = false
	local function fromX(x)
		setFromAlpha(math.max(0, math.min(1, (x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1))))
	end

	hit.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			parent.ScrollingEnabled = false
			fromX(input.Position.X)
		end
	end)
	track(UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			fromX(input.Position.X)
		end
	end))
	track(UserInputService.InputEnded:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			dragging = false
			parent.ScrollingEnabled = true
		end
	end))
end

-- ============================================================
-- TABS AND FEATURES SETUP
-- ============================================================
local ThrowTab = CreateTab("Throw & Train")
local ShopTab = CreateTab("Upgrades & Shop")
local FarmTab = CreateTab("Farm")
local ExtrasTab = CreateTab("Extras")
local SettingsTab = CreateTab("Settings")

local function loopCallback(key, intervalFn, action, onStop)
	return function(on)
		if on then
			startLoop(key, intervalFn, action)
		else
			stopLoop(key)
			if onStop then task.spawn(onStop) end
		end
	end
end

-- Throw & Train
CreateSection(ThrowTab, "Throwing")
CreateToggle(ThrowTab, "Auto Throw", "AutoThrow", function(on)
	if on then refreshThrowing() end
end)
local ThrowStatus = CreateLabel(ThrowTab, throwStatusText(), 104)
CreateSection(ThrowTab, "Training & Plot")
CreateToggle(ThrowTab, "Auto Train", "AutoTrain", function(on)
	if on then refreshTraining() end
end)
local TrainStatus = CreateLabel(ThrowTab, trainStatusText(), 78)
CreateToggle(ThrowTab, "Auto Equip Best", "AutoEquipBest", loopCallback("AutoEquipBest",
	function() return Config.EquipDelay end,
	function() callRemote("Plot_EquipBest") end))
CreateToggle(ThrowTab, "Auto Sell All", "AutoSell", loopCallback("AutoSell",
	function() return Config.SellDelay end,
	function() callRemote("Plot_SellAll") end))

-- Upgrades & Shop
CreateSection(ShopTab, "Upgrades & Shop")
CreateToggle(ShopTab, "Auto Upgrade Stand", "AutoUpgradeBar", loopCallback("AutoUpgradeBar",
	function() return Config.UpgradeDelay end,
	function() callRemote("Stand_Upgrade") end))
CreateToggle(ShopTab, "Auto Claim Free Animal", "AutoClaimFreeAnimal", loopCallback("AutoClaimFreeAnimal",
	function() return Config.FreeDelay end,
	function() callRemote("Shop_ClaimFree") end))
CreateButton(ShopTab, "Upgrade Stand Now", function() callRemote("Stand_Upgrade") end)
CreateButton(ShopTab, "Claim Free Animal Now", function() callRemote("Shop_ClaimFree") end)

-- Farm
CreateSection(FarmTab, "Auto Farming (resumable)")
CreateToggle(FarmTab, "Auto Farming", "AutoFarm", function(on)
	if on then startFarm() else stopFarm() end
end)
local FarmStatus = CreateLabel(FarmTab, farmStatusText(), 44)
CreateButton(FarmTab, "Reset Farming Cycle Timers", function()
	resetFarmCycle()
	notify("Farming Timers Reset", "Cycle reset back to Phase 1 (10 min training).", 3)
end)
CreateLabel(FarmTab, "Phase 1 (10 min): go to your treadmill, keep training and upgrade. Phase 2 (5 min): go to the throw spot, auto throw at the perfect bar, equip best and sell all. Turning it off pauses and keeps your place in the cycle.", 110)

-- Extras
CreateSection(ExtrasTab, "Roubalix features")
CreateToggle(ExtrasTab, "Path Lock (stay near StarterArea)", "PathLock", loopCallback("PathLock",
	function() return 0.4 end, pathLock))
CreateToggle(ExtrasTab, "Auto Equip Tool", "AutoTool", loopCallback("AutoTool",
	function() return 1 end, equipTool))
CreateToggle(ExtrasTab, "Auto Click (center of screen)", "AutoClick", loopCallback("AutoClick",
	function() return Config.ClickDelay end, virtualClick))
CreateLabel(ExtrasTab, "Anti-AFK is always on.", 28)

-- Settings
CreateSection(SettingsTab, "Auto Throw")
CreateSlider(SettingsTab, "Perfect Bar Value", "PerfectValue", nil)
CreateSlider(SettingsTab, "Tap Method", "TapMethod", nil)
CreateLabel(SettingsTab, "Auto Throw taps when the bar number reaches Perfect Bar Value. Tap Method: 1 = screen tap, 2 = press the game's tap button, 3 = virtual click.", 96)
CreateSection(SettingsTab, "Delays")
CreateSlider(SettingsTab, "Train Delay", "TrainDelay", "s")
CreateSlider(SettingsTab, "Upgrade Delay", "UpgradeDelay", "s")
CreateSlider(SettingsTab, "Equip Delay", "EquipDelay", "s")
CreateSlider(SettingsTab, "Free Animal Delay", "FreeDelay", "s")
CreateSlider(SettingsTab, "Sell Delay", "SellDelay", "s")
CreateSlider(SettingsTab, "Click Delay", "ClickDelay", "s")
CreateSlider(SettingsTab, "Farm Upgrade Delay", "FarmUpgradeDelay", "s")
CreateLabel(SettingsTab, "Brineland Hub - Throw Food For Animals. Settings are validated and saved to Brineland/ThrowFood.json.", 62)

selectTab("Throw & Train")

task.spawn(function()
	while alive do
		task.wait(0.3)
		FarmStatus.Text = farmStatusText()
		ThrowStatus.Text = throwStatusText()
		TrainStatus.Text = trainStatusText()
		local barLabel = ThrowUI.label
		if barLabel and barLabel:IsDescendantOf(PlayerGui) and isShown(barLabel) then learnThrowSpot() end
	end
end)

-- ============================================================
-- CLOSE / CLEANUP
-- ============================================================
local function cleanup()
	if not alive then return end
	saveSettings()
	for _, key in ipairs(FEATURE_KEYS) do
		if Config[key] and Toggles[key] then pcall(Toggles[key].Set, false) end
	end
	alive = false
	releaseCamera()
	restoreHiddenGuis()
	for _, connection in ipairs(connections) do pcall(function() connection:Disconnect() end) end
	pcall(function() ScreenGui:Destroy() end)
	if env.BrinelandThrowFoodUnload == cleanup then env.BrinelandThrowFoodUnload = nil end
end
env.BrinelandThrowFoodUnload = cleanup

CloseBtn.MouseButton1Click:Connect(cleanup)
PillCloseBtn.MouseButton1Click:Connect(cleanup)

notify("Brineland Hub", "Throw Food For Animals loaded successfully!", 4)
print("[BRINELAND] Throw Food For Animals Master Edition v6.2 loaded!")
