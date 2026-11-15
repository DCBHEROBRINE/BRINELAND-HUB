-- ============================================================
-- BRINELAND HUB: THROW FOOD FOR ANIMALS (MASTER EDITION, v4)
-- Repository: https://github.com/DCBHEROBRINE/BRINELAND-HUB.git
-- ============================================================

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
local PHASE1_SECONDS = 600
local PHASE2_SECONDS = 300
local TELEPORT_INTERVAL = 1
local TELEPORT_TOLERANCE = 4
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
	FarmUpgradeDelay = { default = 60,     min = 5,    max = 120, step = 5 },
}

local SAVED_KEYS = {
	"PerfectValue", "TapMethod", "TrainDelay", "UpgradeDelay",
	"EquipDelay", "FreeDelay", "SellDelay", "FarmUpgradeDelay",
}

local Config = {
	AutoThrow = false,
	AutoTrain = false,
	AutoEquipBest = false,
	AutoSell = false,
	AutoUpgradeBar = false,
	AutoClaimFreeAnimal = false,
	AutoFarm = false,
	-- Hidden features (Always on permanently)
	AntiAFK = true,
	AutoBoost = true,
}
for key, rule in pairs(SETTINGS_SCHEMA) do Config[key] = rule.default end

local FEATURE_KEYS = {
	"AutoThrow", "AutoTrain", "AutoEquipBest", "AutoSell", "AutoUpgradeBar", "AutoClaimFreeAnimal",
	"AutoFarm",
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

local function validateSetting(key, value)
	local rule = SETTINGS_SCHEMA[key]
	if not rule then return nil, "unknown setting" end
	if type(value) ~= "number" or value ~= value or value == math.huge or value == -math.huge then
		return nil, "expected a finite number"
	end
	local clamped = math.max(rule.min, math.min(rule.max, value))
	local snapped = rule.min + math.floor((clamped - rule.min) / rule.step + 0.5) * rule.step
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
	while not finished and os.clock() - startedAt < REMOTE_TIMEOUT do task.wait() end
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
	return "{table}"
end

local function callRemote(name, ...)
	local remote, reason = getRemote(name)
	if not remote then
		RemoteLast[name] = "missing"
		return RemoteStatus.Missing, reason
	end
	local args = table.pack(...)
	if remote:IsA("RemoteFunction") then
		local ok, result = invokeFunction(remote, args)
		if not ok then
			RemoteLast[name] = "failed"
			return RemoteStatus.Failed, result
		end
		RemoteLast[name] = summarize(result)
		return RemoteStatus.Returned, result
	end
	pcall(function() remote:FireServer(table.unpack(args, 1, args.n)) end)
	RemoteLast[name] = "sent"
	return RemoteStatus.Sent
end

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
			pcall(action)
			task.wait(math.max(0.05, intervalFn()))
		end
	end)
end

local function stopLoop(key)
	Config[key] = false
	Tokens[key] = nil
end

-- ============================================================
-- ALWAYS-ON BACKGROUND HELPERS (Anti-AFK & Auto Boost)
-- ============================================================
track(LocalPlayer.Idled:Connect(function()
	if not Config.AntiAFK then return end
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end))

local function isShown(inst)
	local node = inst
	while node do
		if node:IsA("GuiObject") and not node.Visible then return false end
		if node:IsA("LayerCollector") and not node.Enabled then return false end
		node = node.Parent
	end
	return true
end

local function isBoostText(text)
	local plain = string.gsub(text, "<[^>]+>", "")
	plain = string.gsub(plain, "%s+", "")
	plain = string.lower(plain)
	return plain == "x2" or plain == "2x" or plain == "×2" or plain == "2×"
end

local function findBoostButton()
	for _, inst in ipairs(PlayerGui:GetDescendants()) do
		if (inst:IsA("TextLabel") or inst:IsA("TextButton")) and isBoostText(inst.Text)
			and isShown(inst) and not inst:FindFirstAncestor("ThrowFoodHub") then
			local button = inst:IsA("GuiButton") and inst or inst:FindFirstAncestorWhichIsA("GuiButton")
			if button and isShown(button) then return button end
		end
	end
	return nil
end

-- Background loop for Auto 2x Boost Button
task.spawn(function()
	while alive do
		task.wait(1.5)
		if Config.AutoBoost then
			pcall(function()
				local btn = findBoostButton()
				if btn then
					if getconnections then
						for _, conn in ipairs(getconnections(btn.MouseButton1Click)) do conn:Fire() end
					elseif firesignal then
						firesignal(btn.Activated)
					end
				end
			end)
		end
	end
end)

-- ============================================================
-- FIXED TREADMILL DETECTION & RESOLUTION
-- ============================================================
local Treadmill = { inst = nil, position = nil, how = "none", scannedAt = -math.huge }
local treadmillScanning = false
local TRAIN_TOLERANCE = 2.5

local function isMe(value)
	if value == nil then return false end
	if typeof(value) == "Instance" then return value == LocalPlayer end
	local text = tostring(value)
	return text == tostring(LocalPlayer.UserId) or text == LocalPlayer.Name or text == LocalPlayer.DisplayName
end

-- Improved ownership check looking for Owner or Player values inside models/plots
local function getTreadmillScore(inst)
	local node = inst
	while node and node ~= workspace do
		for key, value in pairs(node:GetAttributes()) do
			local lKey = string.lower(key)
			if lKey:find("owner") or lKey:find("player") or lKey:find("user") then
				if isMe(value) then return 3 end
			end
		end
		for _, child in ipairs(node:GetChildren()) do
			local cName = string.lower(child.Name)
			if (cName:find("owner") or cName:find("player") or cName:find("user")) then
				if child:IsA("ObjectValue") or child:IsA("StringValue") or child:IsA("IntValue") or child:IsA("NumberValue") then
					if isMe(child.Value) then return 3 end
				end
			end
		end
		if isMe(node.Name) then return 2 end
		node = node.Parent
	end
	return 0
end

local function nameSaysTreadmill(inst)
	local name = string.lower(inst.Name)
	return name:find("treadmill", 1, true) or name:find("train", 1, true) or name:find("gym", 1, true)
end

local function findTreadmillCandidates()
	local found, seen = {}, {}
	-- Check plots workspace specifically first, then general descendants
	local plots = workspace:FindFirstChild("Plots") or workspace:FindFirstChild("Map")
	local searchRoot = plots or workspace

	for _, inst in ipairs(searchRoot:GetDescendants()) do
		if nameSaysTreadmill(inst) and (inst:IsA("Model") or inst:IsA("BasePart")) then
			local target = inst:IsA("BasePart") and inst.Parent or inst
			if target and not seen[target] then
				seen[target] = true
				table.insert(found, target)
			end
		end
	end
	return found
end

local function standPositionOn(target)
	local best
	local function consider(part)
		if part:IsA("BasePart") then
			best = part
		end
	end
	if target:IsA("BasePart") then consider(target) end
	for _, desc in ipairs(target:GetDescendants()) do consider(desc) end
	if not best then return nil end
	return best.Position + Vector3.new(0, 3.5, 0)
end

local function refreshTreadmill()
	Treadmill.scannedAt = os.clock()
	local candidates = findTreadmillCandidates()
	local best, bestScore = nil, -1

	for _, candidate in ipairs(candidates) do
		local score = getTreadmillScore(candidate)
		local pos = standPositionOn(candidate)
		if pos and score > bestScore then
			bestScore = score
			best = { inst = candidate, position = pos, score = score }
		end
	end

	if best then
		Treadmill.inst = best.inst
		Treadmill.position = best.position
		Treadmill.how = best.score >= 2 and "Your Treadmill" or "Nearest Treadmill"
	else
		Treadmill.inst, Treadmill.position, Treadmill.how = nil, nil, "none"
	end
end

local function ensureTreadmill()
	local inst = Treadmill.inst
	local valid = inst and inst:IsDescendantOf(workspace)
	if treadmillScanning or (valid and os.clock() - Treadmill.scannedAt < 30) then return end
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
-- TRAINING LOOP
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

local function trainCall(name)
	local treadmill = Treadmill.inst
	if trainWithObject and treadmill and treadmill:IsDescendantOf(workspace) then
		return callRemote(name, treadmill)
	end
	return callRemote(name)
end

local function trainStatusText()
	local lines = {}
	if not wantsTraining() then
		table.insert(lines, "Training is off.")
	else
		table.insert(lines, "Training: Active")
	end
	local inst = Treadmill.inst
	if inst and inst:IsDescendantOf(workspace) then
		table.insert(lines, "Treadmill: Connected (" .. Treadmill.how .. ")")
	else
		table.insert(lines, "Treadmill: Searching...")
	end
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
						teleportTo(position, tolerance)
					end

					if sinceStart >= Config.TrainDelay then
						sinceStart = 0
						trainCall("Training_Start")
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
-- AUTO THROW ENGINE
-- ============================================================
local ThrowUI = { label = nil, scannedAt = 0, numbers = {}, numbersAt = 0 }
local ThrowInfo = { found = false, value = nil, peak = 0, taps = 0 }
local throwWatcherRunning = false
local cameraHold = nil
local cameraBound = false
local hiddenGuis = {}
local ThrowSpot = nil
local CAMERA_BIND = "BrinelandNoCutscene"
local TAP_NAMES = { "screen tap", "game button", "virtual click" }
local hubCovers = function() return false end

local function wantsThrowing()
	if Config.AutoFarm then return Farm.phase == 2 end
	return Config.AutoThrow
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
		value = readNumber(label)
	end
	return value
end

local function pickTapPoint()
	local camera = workspace.CurrentCamera
	local size = camera and camera.ViewportSize or Vector2.new(800, 400)
	return Vector2.new(size.X * 0.5, size.Y * 0.5)
end

local function tapWithInputManager(point)
	local okService, manager = pcall(function() return game:GetService("VirtualInputManager") end)
	if not (okService and manager) then return false end
	pcall(function()
		manager:SendTouchEvent(1, 0, point.X, point.Y)
		task.wait(0.03)
		manager:SendTouchEvent(1, 2, point.X, point.Y)
	end)
	return true
end

local function findTapButton()
	local label = ThrowUI.label
	if not label then return nil end
	return label:IsA("GuiButton") and label or label:FindFirstAncestorWhichIsA("GuiButton")
end

local function pressButton(button)
	if firesignal then return pcall(firesignal, button.Activated) end
	return false
end

local function tapForThrow()
	local point = pickTapPoint()
	for offset = 0, 2 do
		local method = ((Config.TapMethod - 1 + offset) % 3) + 1
		local worked = false
		if method == 1 then
			worked = tapWithInputManager(point)
		elseif method == 2 then
			local button = findTapButton()
			worked = button ~= nil and pressButton(button)
		else
			pcall(function()
				VirtualUser:CaptureController()
				VirtualUser:ClickButton1(point)
			end)
			worked = true
		end
		if worked then return TAP_NAMES[method] end
	end
	return nil
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
		camera.CameraType = Enum.CameraType.Scriptable
		camera.FieldOfView = hold.fov
		camera.CFrame = hold.cframe
	end)
end

local function skipCutscene()
	task.wait(0.15)
	callRemote("Throw_Complete")
end

local function refreshThrowing()
	if throwWatcherRunning or not wantsThrowing() then return end
	throwWatcherRunning = true

	task.spawn(function()
		pcall(function()
			local armed = true
			local lastTapAt = 0

			while alive and wantsThrowing() do
				RunService.RenderStepped:Wait()
				local value = readBarValue()
				ThrowInfo.value = value
				if value and value > ThrowInfo.peak then ThrowInfo.peak = value end

				if value == nil then
					armed = true
				else
					if value < Config.PerfectValue then
						armed = true
					elseif armed then
						armed = false
						lastTapAt = os.clock()
						if cameraHold then
							cameraHold.expires = os.clock() + 15
						else
							local camera = workspace.CurrentCamera
							if camera then
								holdCamera({
									type = camera.CameraType, subject = camera.CameraSubject,
									fov = camera.FieldOfView, cframe = camera.CFrame, expires = os.clock() + 15
								})
							end
						end
						task.spawn(function()
							tapForThrow()
							ThrowInfo.taps = ThrowInfo.taps + 1
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
	if not wantsThrowing() then return "Auto Throw is off." end
	if not ThrowInfo.found then return "Looking for throw bar..." end
	if ThrowInfo.value == nil then return "Throw bar not on screen." end
	return "Bar: +" .. ThrowInfo.value .. " (Target: +" .. Config.PerfectValue .. ")"
end

-- ============================================================
-- AUTO FARM
-- ============================================================
local function farmStatusText()
	local left = Farm.phase == 1 and Farm.left1 or Farm.left2
	local name = Farm.phase == 1 and "Phase 1: Training" or "Phase 2: Throw & Sell"
	return name .. "\n" .. math.max(0, math.floor(left)) .. "s left"
end

local function newPhaseTimers(phase)
	if phase == 1 then return { upgrade = math.huge } end
	return { teleport = math.huge, equip = math.huge, sell = math.huge }
end

local function advanceTimers(timers, dt)
	for key, value in pairs(timers) do timers[key] = value + dt end
end

local function due(timers, key, delay)
	if timers[key] >= delay then
		timers[key] = 0
		return true
	end
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

	while stillOn() do
		if Farm.resetGen ~= currentGen then
			currentGen = Farm.resetGen
			timers = newPhaseTimers(Farm.phase)
			lastTick = os.clock()
		end
		local now = os.clock()
		local dt = now - lastTick
		lastTick = now

		if Farm.phase == 1 then
			advanceTimers(timers, dt)
			refreshTraining()
			if due(timers, "upgrade", Config.FarmUpgradeDelay) then callRemote("Stand_Upgrade") end
			if stale() then return end
			Farm.left1 = Farm.left1 - dt
			if Farm.left1 <= 0 then switchPhase(2) end
		else
			advanceTimers(timers, dt)
			if due(timers, "teleport", TELEPORT_INTERVAL) then teleportTo(THROW_POSITION) end
			refreshThrowing()
			if due(timers, "equip", Config.EquipDelay) then callRemote("Plot_EquipBest") end
			if stale() then return end
			if due(timers, "sell", Config.SellDelay) then callRemote("Plot_SellAll") end
			if stale() then return end
			Farm.left2 = Farm.left2 - dt
			if Farm.left2 <= 0 then switchPhase(1) end
		end
		task.wait(0.05)
	end
end

local function startFarm()
	local token = {}
	Tokens.AutoFarm = token
	Config.AutoFarm = true
	refreshTraining()
	refreshThrowing()
	task.spawn(function() pcall(farmLoop, token) end)
end

local function stopFarm()
	stopLoop("AutoFarm")
end

-- ============================================================
-- GUI SETUP
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
}, (pcall(function() return gethui() end) and gethui()) or CoreGui)

local MainFrame = make("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromScale(0.5, 0.8),
	BackgroundColor3 = THEME.Panel,
	BorderSizePixel = 0,
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

-- Dragging handle logic
local dragging, dragStart, startPos = false, nil, nil
TopBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = MainFrame.Position
	end
end)
track(UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end))
track(UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end))

-- Floating Pill
local HubPill = make("Frame", {
	Name = "ThrowFoodPill",
	AnchorPoint = Vector2.new(0.5, 0),
	Position = UDim2.new(0.5, 0, 0, 4),
	Size = UDim2.new(0.44, 0, 0, 40),
	BackgroundColor3 = Color3.fromRGB(18, 12, 40),
	BorderSizePixel = 0,
	Visible = false,
	Active = true,
}, ScreenGui)
make("UISizeConstraint", { MinSize = Vector2.new(290, 36), MaxSize = Vector2.new(420, 44) }, HubPill)
round(HubPill, UDim.new(1, 0))
make("UIStroke", { Color = Color3.fromRGB(110, 55, 255), Thickness = 2 }, HubPill)

local PlusBtn = make("TextButton", {
	Size = UDim2.fromOffset(30, 30),
	Position = UDim2.new(1, -74, 0.5, -15),
	BackgroundColor3 = Color3.fromRGB(62, 36, 150),
	Text = "+",
	TextColor3 = THEME.Accent,
	Font = Enum.Font.GothamBold,
	TextSize = 18,
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
}, HubPill)
round(PillCloseBtn, UDim.new(0, 8))

local function setWindowVisible(visible)
	MainFrame.Visible = visible
	HubPill.Visible = not visible
end
PlusBtn.MouseButton1Click:Connect(function() setWindowVisible(true) end)
MinimizeBtn.MouseButton1Click:Connect(function() setWindowVisible(false) end)

-- Tabs setup (Removed Extras tab completely)
local TabBar = make("ScrollingFrame", {
	Size = UDim2.new(1, -12, 0, 32),
	Position = UDim2.new(0, 6, 0, 44),
	BackgroundTransparency = 1,
	ScrollBarThickness = 0,
	ScrollingDirection = Enum.ScrollingDirection.X,
	AutomaticCanvasSize = Enum.AutomaticSize.X,
}, MainFrame)
make("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4) }, TabBar)

local TabFrames = {}
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
	}, TabBar)
	round(tabBtn, UDim.new(0, 6))
	make("UIPadding", { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) }, tabBtn)

	local container = make("ScrollingFrame", {
		Size = UDim2.new(1, -12, 1, -86),
		Position = UDim2.new(0, 6, 0, 82),
		BackgroundTransparency = 1,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = THEME.Accent,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Visible = false,
	}, MainFrame)
	make("UIListLayout", { Padding = UDim.new(0, 6) }, container)

	TabFrames[tabName] = { Button = tabBtn, Container = container }
	tabBtn.MouseButton1Click:Connect(function() selectTab(tabName) end)
	return container
end

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
		LayoutOrder = nextOrder(parent),
	}, parent)
end

local function CreateToggle(parent, text, configKey, callback)
	local frame = make("Frame", {
		Size = UDim2.new(1, 0, 0, 38),
		BackgroundColor3 = THEME.Row,
		BackgroundTransparency = 0.2,
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
	}, frame)
	round(toggleBg, UDim.new(1, 0))

	local knob = make("Frame", {
		Size = UDim2.fromOffset(16, 16),
		Position = Config[configKey] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
		BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	}, toggleBg)
	round(knob, UDim.new(1, 0))

	local button = make("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "" }, frame)
	button.MouseButton1Click:Connect(function()
		Config[configKey] = not Config[configKey]
		local state = Config[configKey]
		TweenService:Create(knob, TweenInfo.new(0.15), { Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8) }):Play()
		toggleBg.BackgroundColor3 = state and THEME.Accent or THEME.Off
		if callback then pcall(callback, state) end
	end)
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
	button.MouseButton1Click:Connect(callback)
end

local function CreateLabel(parent, text, height)
	local label = make("TextLabel", {
		Size = UDim2.new(1, 0, 0, height or 44),
		BackgroundColor3 = THEME.Row,
		BackgroundTransparency = 0.4,
		Text = text,
		TextColor3 = THEME.TabText,
		Font = Enum.Font.GothamMedium,
		TextSize = 11,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		LayoutOrder = nextOrder(parent),
	}, parent)
	round(label, UDim.new(0, 6))
	return label
end

local function CreateSlider(parent, text, configKey, suffix)
	local rule = SETTINGS_SCHEMA[configKey]
	local minV, maxV = rule.min, rule.max

	local frame = make("Frame", {
		Size = UDim2.new(1, 0, 0, 50),
		BackgroundColor3 = THEME.Row,
		BackgroundTransparency = 0.2,
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
	}, hit)
	round(bar, UDim.new(0, 4))
	local fill = make("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = THEME.Accent }, bar)
	round(fill, UDim.new(0, 4))

	local function render()
		local val = Config[configKey]
		local alpha = (maxV > minV) and (val - minV) / (maxV - minV) or 0
		fill.Size = UDim2.new(alpha, 0, 1, 0)
		valueLabel.Text = tostring(val) .. (suffix or "")
	end
	render()

	hit.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			local alpha = math.clamp((input.Position.X - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
			if setSetting(configKey, minV + alpha * (maxV - minV)) then render() end
		end
	end)
end

-- ============================================================
-- TAB CREATION (Extras Tab Removed)
-- ============================================================
local ThrowTab = CreateTab("Throw & Train")
local ShopTab = CreateTab("Upgrades & Shop")
local FarmTab = CreateTab("Farm")
local SettingsTab = CreateTab("Settings")

local function loopCallback(key, intervalFn, action)
	return function(on)
		if on then startLoop(key, intervalFn, action) else stopLoop(key) end
	end
end

-- Throw & Train
CreateSection(ThrowTab, "Throwing")
CreateToggle(ThrowTab, "Auto Throw", "AutoThrow", function(on) if on then refreshThrowing() end end)
local ThrowStatus = CreateLabel(ThrowTab, "Throw status...", 70)
CreateSection(ThrowTab, "Training & Plot")
CreateToggle(ThrowTab, "Auto Train", "AutoTrain", function(on) if on then refreshTraining() end end)
local TrainStatus = CreateLabel(TrainTab, "Training status...", 60)
CreateToggle(ThrowTab, "Auto Equip Best", "AutoEquipBest", loopCallback("AutoEquipBest", function() return Config.EquipDelay end, function() callRemote("Plot_EquipBest") end))
CreateToggle(ThrowTab, "Auto Sell All", "AutoSell", loopCallback("AutoSell", function() return Config.SellDelay end, function() callRemote("Plot_SellAll") end))

-- Upgrades & Shop
CreateSection(ShopTab, "Upgrades & Shop")
CreateToggle(ShopTab, "Auto Upgrade Stand", "AutoUpgradeBar", loopCallback("AutoUpgradeBar", function() return Config.UpgradeDelay end, function() callRemote("Stand_Upgrade") end))
CreateToggle(ShopTab, "Auto Claim Free Animal", "AutoClaimFreeAnimal", loopCallback("AutoClaimFreeAnimal", function() return Config.FreeDelay end, function() callRemote("Shop_ClaimFree") end))
CreateButton(ShopTab, "Upgrade Stand Now", function() callRemote("Stand_Upgrade") end)
CreateButton(ShopTab, "Claim Free Animal Now", function() callRemote("Shop_ClaimFree") end)

-- Farm
CreateSection(FarmTab, "Auto Farming")
CreateToggle(FarmTab, "Auto Farming", "AutoFarm", function(on) if on then startFarm() else stopFarm() end end)
local FarmStatus = CreateLabel(FarmTab, "Farm status...", 44)
CreateButton(FarmTab, "Reset Farming Cycle Timers", resetFarmCycle)

-- Settings
CreateSection(SettingsTab, "Auto Throw")
CreateSlider(SettingsTab, "Perfect Bar Value", "PerfectValue", nil)
CreateSlider(SettingsTab, "Tap Method", "TapMethod", nil)
CreateSection(SettingsTab, "Delays")
CreateSlider(SettingsTab, "Train Delay", "TrainDelay", "s")
CreateSlider(SettingsTab, "Upgrade Delay", "UpgradeDelay", "s")
CreateSlider(SettingsTab, "Equip Delay", "EquipDelay", "s")
CreateSlider(SettingsTab, "Free Animal Delay", "FreeDelay", "s")
CreateSlider(SettingsTab, "Sell Delay", "SellDelay", "s")
CreateSlider(SettingsTab, "Farm Upgrade Delay", "FarmUpgradeDelay", "s")

selectTab("Throw & Train")

-- Status Update Loop
task.spawn(function()
	while alive do
		task.wait(0.5)
		pcall(function()
			FarmStatus.Text = farmStatusText()
			ThrowStatus.Text = throwStatusText()
			TrainStatus.Text = trainStatusText()
		end)
	end
end)

local function cleanup()
	if not alive then return end
	saveSettings()
	for _, key in ipairs(FEATURE_KEYS) do
		if Config[key] then stopLoop(key) end
	end
	alive = false
	releaseCamera()
	for _, connection in ipairs(connections) do pcall(function() connection:Disconnect() end) end
	pcall(function() ScreenGui:Destroy() end)
	if env.BrinelandThrowFoodUnload == cleanup then env.BrinelandThrowFoodUnload = nil end
end
env.BrinelandThrowFoodUnload = cleanup

CloseBtn.MouseButton1Click:Connect(cleanup)
PillCloseBtn.MouseButton1Click:Connect(cleanup)

print("[BRINELAND] Throw Food For Animals Master Edition v4 loaded successfully!")
