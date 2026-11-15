-- ============================================================
-- BRINELAND HUB: THROW FOOD FOR ANIMALS (MASTER EDITION, v3)
-- Repository: https://github.com/DCBHEROBRINE/BRINELAND-HUB.git
--
-- v7 changes:
--   * The pill at the top only shows while the window is hidden (window open = no pill).
--   * Removed Path Lock, Auto Equip Tool and Auto Click. Anti-AFK stays and is now a visible
--     switch in the Extras tab (on by default).
--   * New: Auto 2x Speed Button - presses the round "x2" button when it pops up.
--   * Everything from v6 (treadmill detection, Auto Throw with cutscene removal, farm) is unchanged.
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

-- Running the script again unloads the previous copy first
if env.BrinelandThrowFoodUnload then pcall(env.BrinelandThrowFoodUnload) end

-- Remove any old GUI left behind in PlayerGui / CoreGui / gethui
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
local TELEPORT_INTERVAL = 1 -- how often Auto Farm checks where you are
local TELEPORT_TOLERANCE = 4 -- studs (flat distance). Closer than this = no teleport
local REMOTE_TIMEOUT = 10 -- seconds before a RemoteFunction call counts as failed

local EXPECTED_REMOTES = {
	"Throw_Complete", "Training_Start", "Training_Stop",
	"Plot_EquipBest", "Plot_SellAll", "Stand_Upgrade", "Shop_ClaimFree",
}

-- ============================================================
-- SETTINGS (one table drives defaults, limits, sliders and validation)
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
	-- switches (never saved, loops always start OFF)
	AutoThrow = false,
	AutoTrain = false,
	AutoEquipBest = false,
	AutoSell = false,
	AutoUpgradeBar = false,
	AutoClaimFreeAnimal = false,
	AutoFarm = false,
	AutoBoost = false,
	-- always-on helper (shown as a switch, starts ON, not part of FEATURE_KEYS)
	AntiAFK = true,
}
for key, rule in pairs(SETTINGS_SCHEMA) do Config[key] = rule.default end

-- every on/off feature (closing the window switches these off)
local FEATURE_KEYS = {
	"AutoThrow", "AutoTrain", "AutoEquipBest", "AutoSell", "AutoUpgradeBar", "AutoClaimFreeAnimal",
	"AutoFarm", "AutoBoost",
}

local alive = true
local connections = {}
local function track(connection)
	table.insert(connections, connection)
	return connection
end

local notify = function() end -- replaced once the GUI exists

-- Problems only (missing / failed remotes, bad config, loop errors) go to the console.
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
-- Returns (validValue, note). validValue is nil when the input cannot be used at all.
local function validateSetting(key, value)
	local rule = SETTINGS_SCHEMA[key]
	if not rule then return nil, "unknown setting" end

	if type(value) ~= "number" or value ~= value or value == math.huge or value == -math.huge then
		return nil, "expected a finite number"
	end

	local clamped = math.max(rule.min, math.min(rule.max, value))
	local snapped = rule.min + math.floor((clamped - rule.min) / rule.step + 0.5) * rule.step
	snapped = math.max(rule.min, math.min(rule.max, snapped))
	snapped = math.floor(snapped * 10000 + 0.5) / 10000

	if math.abs(snapped - value) > 1e-6 then
		return snapped, "adjusted to fit " .. rule.min .. " to " .. rule.max
	end
	return snapped
end

local saveQueued = false
local function queueSave() end -- assigned below (needs saveSettings)

-- Used by the sliders. Returns true when the stored value actually changed.
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
	local ok, err = pcall(function()
		if not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end
		writefile(CONFIG_PATH, HttpService:JSONEncode(data))
	end)
	if not ok then log("Config save failed: " .. tostring(err)) end
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
	if not okRead then
		log("Config could not be read: " .. tostring(raw))
		return
	end
	if raw == nil then return end -- first run, no file yet

	local okDecode, data = pcall(function() return HttpService:JSONDecode(raw) end)
	if not okDecode or type(data) ~= "table" then
		log("Config file is corrupt, using defaults")
		return
	end

	-- keys from older versions (PerfectThrow, ResolveOnly, ...) are simply ignored
	for _, key in ipairs(SAVED_KEYS) do
		local stored = data[key]
		if stored ~= nil then
			local valid, note = validateSetting(key, stored)
			if valid == nil then
				log("Config ignored " .. key .. ": " .. note)
			else
				Config[key] = valid
				if note then
					log("Config " .. key .. " " .. tostring(stored) .. " -> " .. tostring(valid) .. " (" .. note .. ")")
				end
			end
		end
	end
end
loadSettings()

-- ============================================================
-- REMOTES
-- ============================================================
-- Missing  : the remote does not exist (nothing was sent)
-- Failed   : the call errored or a RemoteFunction timed out
-- Sent     : a RemoteEvent was fired (events have no reply, so this is not a confirmation)
-- Returned : a RemoteFunction answered (the returned value is the only server result we get)
local RemoteStatus = { Missing = "Missing", Failed = "Failed", Sent = "Sent", Returned = "Returned" }

local RemotesFolder
local RemoteCache = {}

local function getRemotesFolder()
	if RemotesFolder and RemotesFolder:IsDescendantOf(ReplicatedStorage) then
		return RemotesFolder
	end
	RemotesFolder = ReplicatedStorage:FindFirstChild("Remotes")
	table.clear(RemoteCache) -- folder was replaced or is missing, drop stale references
	return RemotesFolder
end

-- Returns remote, or nil plus a reason.
local function getRemote(name)
	local cached = RemoteCache[name]
	if cached and cached:IsDescendantOf(ReplicatedStorage) then return cached end
	RemoteCache[name] = nil

	local folder = getRemotesFolder()
	if not folder then return nil, "Remotes folder not found" end

	local remote = folder:FindFirstChild(name)
	if not remote then return nil, "not in Remotes folder" end
	if not (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
		return nil, "is a " .. remote.ClassName .. ", not a remote"
	end

	RemoteCache[name] = remote
	return remote
end

-- InvokeServer can wait forever if the server never answers, which would freeze the loop calling it.
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
		return false, "timed out after " .. REMOTE_TIMEOUT .. "s"
	end
	return ok, result
end

local RemoteLast = {} -- [remote name] = short text of its last outcome (shown in the status labels)

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
		if count > 5 then
			table.insert(parts, "...")
			break
		end
		local kind = typeof(item)
		local shown = (kind == "string" or kind == "number" or kind == "boolean") and tostring(item) or kind
		table.insert(parts, tostring(key) .. "=" .. clip(shown, 20))
	end
	return clip("{" .. table.concat(parts, ", ") .. "}", 70)
end

-- Returns status, value. Never throws.
local function callRemote(name, ...)
	local remote, reason = getRemote(name)
	if not remote then
		RemoteLast[name] = "missing (" .. reason .. ")"
		log(name .. " missing: " .. reason)
		return RemoteStatus.Missing, reason
	end

	local args = table.pack(...)

	if remote:IsA("RemoteFunction") then
		local ok, result = invokeFunction(remote, args)
		if not ok then
			RemoteLast[name] = "failed: " .. clip(result, 50)
			log(name .. " failed: " .. tostring(result))
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
		log(name .. " failed: " .. tostring(err))
		return RemoteStatus.Failed, err
	end
	RemoteLast[name] = "sent (event, no reply)"
	return RemoteStatus.Sent
end

-- Wait for the Remotes folder in the background so the GUI shows up immediately
task.spawn(function()
	local folder = ReplicatedStorage:WaitForChild("Remotes", 15)
	if not alive then return end
	if not folder then
		log("Remotes folder NOT found - wrong game?")
		notify("Brineland", "Remotes folder not found. Are you in Throw Food For Animals?", 6)
		return
	end

	RemotesFolder = folder
	table.clear(RemoteCache)

	local missing = {}
	for _, name in ipairs(EXPECTED_REMOTES) do
		if not folder:FindFirstChild(name) then table.insert(missing, name) end
	end
	if #missing > 0 then
		log("Remotes not found: " .. table.concat(missing, ", "))
		notify("Brineland", "Some remotes were not found: " .. table.concat(missing, ", "), 6)
	end
end)

-- ============================================================
-- LOOP ENGINE (one token per loop so a quick off/on never runs twice)
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
-- Anti-AFK (the switch in the Extras tab sets Config.AntiAFK, it starts ON)
track(LocalPlayer.Idled:Connect(function()
	if not Config.AntiAFK then return end
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end))

-- Moves you onto a spot only when you are away from it, so it never interrupts training or
-- throwing. Keeps your facing and stops any drift. Returns true when it actually moved you.
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
-- TREADMILL (the training spot)
-- Instead of trusting fixed coordinates, the script looks for the treadmill OBJECT in the world.
-- It prefers YOUR treadmill (an owner attribute / value, or a model named after you), otherwise
-- the nearest one, and stands on its biggest surface. Fixed coordinates are only a fallback.
-- ============================================================
local Treadmill = { inst = nil, position = nil, how = "none", scannedAt = -math.huge }
local treadmillScanning = false
local TRAIN_TOLERANCE = 2.5 -- studs: stay this close to the middle of the treadmill
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
	for _, other in ipairs(Players:GetPlayers()) do
		if other ~= LocalPlayer and (name == other.Name or name == other.DisplayName or name == tostring(other.UserId)) then
			return true
		end
	end
	return false
end

-- 2 = marked as yours, 1 = inside something named after you, 0 = no owner information,
-- -1 = belongs to another player
local function ownership(inst)
	local node = inst
	while node and node ~= workspace do
		for key, value in pairs(node:GetAttributes()) do
			if OWNER_KEYS[string.lower(key)] then
				return isMe(value) and 2 or -1
			end
		end
		for _, child in ipairs(node:GetChildren()) do
			if OWNER_KEYS[string.lower(child.Name)]
				and (child:IsA("ObjectValue") or child:IsA("StringValue") or child:IsA("IntValue") or child:IsA("NumberValue")) then
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
		if index % 4000 == 0 then task.wait() end -- big worlds: never freeze the game
		if nameSaysTreadmill(inst) and (inst:IsA("Model") or inst:IsA("BasePart")) then
			local target = inst
			if inst:IsA("BasePart") then target = treadmillAncestor(inst) or inst end
			if not seen[target] then
				seen[target] = true
				table.insert(found, target)
			end
		end
	end
	-- drop containers that only hold other treadmills (for example a model called "Treadmills")
	local leaves = {}
	for _, candidate in ipairs(found) do
		local container = false
		for _, other in ipairs(found) do
			if other ~= candidate and other:IsDescendantOf(candidate) then
				container = true
				break
			end
		end
		if not container then table.insert(leaves, candidate) end
	end
	return leaves
end

-- Where to stand: the top of the treadmill's biggest flat part.
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
				inst = candidate,
				position = position,
				score = ownership(candidate),
				distance = root and (root.Position - position).Magnitude or 0,
			})
		end
	end

	local best
	for _, option in ipairs(options) do
		local usable = option.score >= 0
		local bestUsable = best and best.score >= 0
		if not best
			or (usable and not bestUsable)
			or (usable == bestUsable and (option.score > best.score or (option.score == best.score and option.distance < best.distance))) then
			best = option
		end
	end

	if best then
		Treadmill.inst = best.inst
		Treadmill.position = best.position
		Treadmill.how = best.score == 2 and "yours" or best.score == 1 and "named after you"
			or best.score == 0 and "nearest" or "nearest (owner unknown)"
	else
		Treadmill.inst, Treadmill.position, Treadmill.how = nil, nil, "none"
	end
end

-- Finds the treadmill when it is missing (or every minute, in case it was replaced).
local function ensureTreadmill()
	local inst = Treadmill.inst
	local valid = inst and inst:IsDescendantOf(workspace)
	local age = os.clock() - Treadmill.scannedAt
	if treadmillScanning or (valid and age < 60) or (not valid and age < 4) then return end
	treadmillScanning = true
	local ok, err = pcall(refreshTreadmill)
	treadmillScanning = false
	if not ok then log("Treadmill scan error: " .. tostring(err)) end
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
-- The script cannot read the game's real training state, so it does not guess it.
-- While training is wanted, ONE heartbeat walks you onto the treadmill and keeps sending
-- Training_Start every Train Delay. That also recovers training after a teleport or respawn.
-- When training is no longer wanted the heartbeat ends and sends exactly one Training_Stop.
-- ============================================================
local Farm = { phase = 1, left1 = PHASE1_SECONDS, left2 = PHASE2_SECONDS, resetGen = 0 }
local trainingLoopRunning = false
local trainWithObject = false -- flips if the server refuses a plain Start (then the treadmill is sent too)

-- Auto Farm owns the cycle while it runs (train in Phase 1, throw in Phase 2).
-- Without it, the Auto Train / Auto Throw buttons decide.
local function wantsTraining()
	if Config.AutoFarm then return Farm.phase == 1 end
	return Config.AutoTrain
end

-- Training walks you to the treadmill, except when Auto Throw runs on its own (you cannot be at
-- both spots, so you stay where you are).
local function movesForTraining()
	return wantsTraining() and not (Config.AutoThrow and not Config.AutoFarm)
end

local function looksRejected(status, value)
	if status == RemoteStatus.Failed then return true end
	if value == false then return true end
	if type(value) == "table" then
		for key, item in pairs(value) do
			local lower = type(key) == "string" and string.lower(key) or ""
			if item == false and (lower == "success" or lower == "ok" or lower == "succeeded" or lower == "started" or lower == "allowed") then
				return true
			end
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
	local name = string.gsub(inst:GetFullName(), "^Workspace%.", "")
	return name
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
		table.insert(lines, "Treadmill: not found, using the default spot")
	end
	if Config.AutoTrain and Config.AutoThrow and not Config.AutoFarm then
		table.insert(lines, "Staying put because Auto Throw is on.")
	end
	table.insert(lines, "Server: " .. (RemoteLast.Training_Start or "no reply yet"))
	return table.concat(lines, "\n")
end

-- Safe to call as often as you like: does nothing if the heartbeat is already running.
local function refreshTraining()
	if trainingLoopRunning or not wantsTraining() then return end
	trainingLoopRunning = true

	task.spawn(function()
		local ok, err = pcall(function()
			repeat
				local sinceStart = math.huge -- send the first Start immediately
				local sinceMove = math.huge
				local lastClock = os.clock()

				while alive and wantsTraining() do
					ensureTreadmill() -- may take a moment on the first scan

					local now = os.clock()
					local elapsed = now - lastClock
					lastClock = now
					sinceStart = sinceStart + elapsed
					sinceMove = sinceMove + elapsed

					if movesForTraining() and sinceMove >= TELEPORT_INTERVAL then
						sinceMove = 0
						local position, tolerance = trainSpot()
						if teleportTo(position, tolerance) then
							-- give the server a moment to see the new position before Start
							sinceStart = math.min(sinceStart, Config.TrainDelay - 0.3)
						end
					end

					if sinceStart >= Config.TrainDelay then
						sinceStart = 0
						local status, value = trainCall("Training_Start")
						if status ~= RemoteStatus.Missing and Treadmill.inst and looksRejected(status, value) then
							trainWithObject = not trainWithObject -- try the other way of asking next time
						end
					end
					task.wait(0.1)
				end

				trainCall("Training_Stop")
				-- if training was wanted again while Stop was in flight, keep going
			until not (alive and wantsTraining())
		end)
		trainingLoopRunning = false
		if not ok then log("Training loop error: " .. tostring(err)) end
	end)
end

-- ============================================================
-- AUTO THROW
-- The script cannot see the game's code, so it reads the game's own throw bar:
--   1. finds the "TAP TO THROW!" text on screen
--   2. reads the "+N" number that follows the bar marker (+4, +10 ... +20)
--   3. taps the screen the moment N reaches Perfect Bar Value
--   4. cancels the cutscene: holds the camera where it was and ends the throw
-- ============================================================
local ThrowUI = { label = nil, scannedAt = 0, numbers = {}, numbersAt = 0 }
local ThrowInfo = {
	found = false, value = nil, peak = 0, taps = 0, lastTapValue = nil, lastTapNote = "",
	skipPressed = 0, hiddenGuis = 0, guiHiderOff = false,
}
local throwWatcherRunning = false
local cameraHold = nil -- { type, subject, fov, cframe, rootPos, expires } while the cutscene lock is on
local cameraBound = false
local guiGuard = nil -- { baseline = { [ScreenGui] = true }, expires = time } after a tap
local hiddenGuis = {} -- screens this script switched off because of a cutscene
local ThrowSpot = nil -- where you stood the last time the throw bar was on screen
local CAMERA_BIND = "BrinelandNoCutscene"
local TAP_NAMES = { "screen tap", "game button", "virtual click" }

-- assigned once the window exists, so a tap is never aimed at this hub's own window or logo
local hubCovers = function() return false end

local function wantsThrowing()
	if Config.AutoFarm then return Farm.phase == 2 end
	return Config.AutoThrow
end

-- true when the object and every parent of it are visible
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
	return tonumber(string.match(plain, "^%s*%+%s*(%d+)%s*$")) -- exactly "+N"
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

-- The visible "+N" label closest to the "TAP TO THROW!" text wins.
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

-- Returns the current bar number, or nil when the throw bar is not on screen.
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

-- A spot on screen that is not under this hub's own window or logo.
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

-- Tap method 1: real screen tap (touch on phones, mouse on PC)
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

-- Tap method 2: press the game's own tap button directly
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

-- Tap method 3: virtual mouse click
local function tapWithVirtualUser(point)
	return (pcall(function()
		VirtualUser:CaptureController()
		VirtualUser:ClickButton1(point)
	end))
end

-- Uses the chosen Tap Method first, then the others if it cannot run. Returns the method used.
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
			worked = tapWithVirtualUser(point)
		end
		if worked then return TAP_NAMES[method] end
	end
	return nil
end

-- Cutscene cancel, part 1: lock the camera to the view the throw started with. The lock stays
-- on for as long as Auto Throw keeps throwing, so the throw cutscene never shows. The camera is
-- set to Scriptable and re-applied after every other camera step, every frame.
local function captureCamera()
	local camera = workspace.CurrentCamera
	if not camera then return nil end
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	return {
		type = camera.CameraType,
		subject = camera.CameraSubject,
		fov = camera.FieldOfView,
		cframe = camera.CFrame,
		rootPos = root and root.Position or nil,
		expires = os.clock() + 15, -- renewed by every tap; ends the lock if throwing stops
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
				releaseCamera() -- you walked away or respawned: the camera is yours again
				return
			end
		end
		camera.CameraType = Enum.CameraType.Scriptable
		camera.FieldOfView = hold.fov
		camera.CFrame = hold.cframe
	end)
end

-- Cutscene cancel, part 2: switch off screens that only appeared because of the throw.
-- Only screens that were NOT showing at the moment of the tap are touched, never the throw bar's
-- own screens. If the bar fails to come back, everything is put back and hiding is turned off.
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
	if string.find(lower, "throw", 1, true)
		and not (string.find(lower, "cutscene", 1, true) or string.find(lower, "cinematic", 1, true)) then
		return true
	end
	return false
end

local function hideNewGuis()
	local guard = guiGuard
	if not guard or ThrowInfo.guiHiderOff then return end
	if os.clock() > guard.expires then
		guiGuard = nil
		return
	end
	for _, gui in ipairs(PlayerGui:GetChildren()) do
		if gui:IsA("ScreenGui") and gui.Enabled and not guard.baseline[gui]
			and gui.Name ~= "ThrowFoodHub" and not isBarGui(gui) then
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

-- Cutscene cancel, part 3: press a visible "Skip" button if the game offers one.
local function screenCenterOf(inst)
	local center = inst.AbsolutePosition + inst.AbsoluteSize / 2
	local gui = inst:FindFirstAncestorWhichIsA("ScreenGui")
	if gui and not gui.IgnoreGuiInset then center = center + GuiService:GetGuiInset() end
	return center
end

local function pressSkipButton()
	for _, inst in ipairs(PlayerGui:GetDescendants()) do
		if inst:IsA("GuiButton") and isShown(inst) and not inst:FindFirstAncestor("ThrowFoodHub") then
			local text = inst:IsA("TextButton") and inst.Text or ""
			if text == "" then
				for _, child in ipairs(inst:GetChildren()) do
					if child:IsA("TextLabel") then
						text = child.Text
						break
					end
				end
			end
			local plain = string.gsub(text, "<[^>]+>", "")
			if string.match(string.upper(plain), "^%s*SKIP") then
				if not pressButton(inst) then tapWithInputManager(screenCenterOf(inst)) end
				return true
			end
		end
	end
	return false
end

-- Cutscene cancel, part 4: end the throw on the server right away.
local function skipCutscene()
	task.wait(0.15) -- let the game's own Throw_Resolve go out first
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

-- Remember where you stand while the throw bar is on screen (Auto Farm goes back there).
-- To be safe it only counts after the bar has stayed up for 1.5 seconds while you stood still
-- (a bar that lingers for a moment after a teleport must never become the "throw spot").
local spotCandidate = nil -- { position, since }

local function rootPosition()
	local char = LocalPlayer.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	return root and root.Position or nil
end

local function observeThrowSpot(barVisible)
	local position = barVisible and rootPosition() or nil
	if not position then
		spotCandidate = nil
		return
	end
	local now = os.clock()
	if not spotCandidate or (position - spotCandidate.position).Magnitude > 3 then
		spotCandidate = { position = position, since = now }
	elseif now - spotCandidate.since >= 1.5 then
		ThrowSpot = spotCandidate.position
	end
end

local function throwSpotPosition()
	return ThrowSpot or THROW_POSITION
end

-- Used when you switch Auto Farm on yourself: if the bar is up right now, you are at the spot.
local function learnThrowSpotIfBarVisible()
	readBarValue()
	local label = ThrowUI.label
	if label and label:IsDescendantOf(PlayerGui) and isShown(label) then
		ThrowSpot = rootPosition() or ThrowSpot
	end
end

-- One watcher runs while throwing is wanted (Auto Throw, or Auto Farm in Phase 2).
-- Safe to call as often as you like: does nothing if the watcher is already running.
local function refreshThrowing()
	if throwWatcherRunning or not wantsThrowing() then return end
	throwWatcherRunning = true

	task.spawn(function()
		local ok, err = pcall(function()
			local armed = true
			local lastTapAt = 0
			local barMissingSince = nil

			while alive and wantsThrowing() do
				RunService.RenderStepped:Wait()

				local value = readBarValue()
				ThrowInfo.value = value
				if value and value > ThrowInfo.peak then ThrowInfo.peak = value end

				hideNewGuis()

				if value == nil then
					armed = true
					observeThrowSpot(false)
					barMissingSince = barMissingSince or os.clock()
					-- the bar did not come back after something was hidden: put it all back
					if next(hiddenGuis) and not ThrowInfo.guiHiderOff and os.clock() - barMissingSince > 10 then
						restoreHiddenGuis()
						ThrowInfo.guiHiderOff = true
						guiGuard = nil
					end
				else
					barMissingSince = nil
					if next(hiddenGuis) and os.clock() - lastTapAt > 1.5 then table.clear(hiddenGuis) end
					observeThrowSpot(true)

					if value < Config.PerfectValue then
						armed = true
					elseif armed then
						armed = false
						lastTapAt = os.clock()

						-- lock the camera to the throw view BEFORE the tap, keep it locked afterwards
						if cameraHold then
							cameraHold.expires = os.clock() + 15
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
						armed = true -- the tap did not register, try again
					end
				end
			end
		end)
		throwWatcherRunning = false
		ThrowInfo.value = nil
		releaseCamera() -- throwing stopped: the camera is the game's again
		if not ok then log("Auto Throw error: " .. tostring(err)) end
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
			.. ", Skip " .. ThrowInfo.skipPressed .. "x")
		table.insert(lines, "Throw_Complete: " .. (RemoteLast.Throw_Complete or "n/a"))
	end
	return table.concat(lines, "\n")
end

-- ============================================================
-- AUTO 2x SPEED BUTTON
-- A round "x2" button pops up now and then; tapping it gives 2x speed for a while.
-- This finds it (a visible button with "x2" written on it) and presses it for you.
-- Anything inside a shop / gamepass / purchase screen is never touched.
-- ============================================================
local BoostInfo = { found = false, presses = 0, note = "waiting for the button to appear" }
local boostPressedAt = setmetatable({}, { __mode = "k" }) -- [button] = time of the last press
local BOOST_BLOCKED_WORDS = { "shop", "store", "gamepass", "robux", "premium", "purchase", "product", "vip" }

local function isBoostText(text)
	local plain = string.gsub(text, "<[^>]+>", "")
	plain = string.gsub(plain, "%s+", "")
	plain = string.lower(plain)
	return plain == "x2" or plain == "2x" or plain == "×2" or plain == "2×"
end

local function insideBlockedScreen(inst)
	local node = inst
	while node and node ~= PlayerGui do
		local lower = string.lower(node.Name)
		for _, word in ipairs(BOOST_BLOCKED_WORDS) do
			if string.find(lower, word, 1, true) then return true end
		end
		node = node.Parent
	end
	return false
end

local function usableBoostButton(button)
	if not (button and isShown(button)) then return false end
	local size = button.AbsoluteSize
	if size.X > 300 or size.Y > 300 then return false end -- a floating button, not a big panel
	return not insideBlockedScreen(button)
end

local function findBoostButton()
	for _, inst in ipairs(PlayerGui:GetDescendants()) do
		if (inst:IsA("TextLabel") or inst:IsA("TextButton")) and isBoostText(inst.Text)
			and isShown(inst) and not inst:FindFirstAncestor("ThrowFoodHub") then
			-- the clickable thing: the text itself, the button it sits inside, or a button next to it
			local button = inst:IsA("GuiButton") and inst or inst:FindFirstAncestorWhichIsA("GuiButton")
			if not button and inst.Parent then
				for _, sibling in ipairs(inst.Parent:GetChildren()) do
					if sibling:IsA("GuiButton") then
						button = sibling
						break
					end
				end
			end
			if usableBoostButton(button) then return button end
		end
	end
	return nil
end

local function pressBoost()
	local button = findBoostButton()
	BoostInfo.found = button ~= nil
	if not button then
		BoostInfo.note = "waiting for the button to appear"
		return
	end

	local last = boostPressedAt[button]
	if last and os.clock() - last < 8 then return end -- just pressed it, give it time to go away
	boostPressedAt[button] = os.clock()

	local method
	if pressButton(button) then
		method = "button signal"
	else
		local point = screenCenterOf(button)
		if hubCovers(point) then
			BoostInfo.note = "button is behind this window, hide the window"
			return
		end
		if tapWithInputManager(point) then method = "screen tap" end
	end

	if method then
		BoostInfo.presses = BoostInfo.presses + 1
		BoostInfo.note = "pressed it (" .. method .. ")"
	else
		BoostInfo.note = "found it but could not press it"
	end
end

local function boostStatusText()
	if not Config.AutoBoost then return "Auto 2x Speed is off." end
	return "2x speed button: " .. BoostInfo.note .. "\nPressed so far: " .. BoostInfo.presses
end

-- ============================================================
-- AUTO FARM (independent timers + reset generation)
-- ============================================================
local function farmStatusText()
	local left = Farm.phase == 1 and Farm.left1 or Farm.left2
	local name = Farm.phase == 1 and "Phase 1: Training + Upgrades" or "Phase 2: Throw + Equip + Sell"
	return name .. "\n" .. math.max(0, math.floor(left)) .. "s left" .. (Config.AutoFarm and " (running)" or " (paused)")
end

-- Every timer starts "already due" so each action fires on the first tick of a phase.
local function newPhaseTimers(phase)
	if phase == 1 then
		return { upgrade = math.huge }
	end
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
	Farm.resetGen = Farm.resetGen + 1 -- the running loop sees this and re-primes its timers
	refreshTraining()
end

local function farmLoop(token)
	local currentGen = Farm.resetGen
	local timers = newPhaseTimers(Farm.phase)
	local lastTick = os.clock()

	local function stillOn() return alive and Config.AutoFarm and Tokens.AutoFarm == token end
	-- remote calls yield, so re-check after them
	local function stale() return not stillOn() or Farm.resetGen ~= currentGen end

	local function switchPhase(newPhase)
		Farm.phase = newPhase
		timers = newPhaseTimers(newPhase)
		refreshTraining() -- Phase 1 starts the training heartbeat, Phase 2 lets it send Stop
		refreshThrowing() -- Phase 2 starts the throw watcher, Phase 1 lets it end
	end

	local function runTick(dt)
		if Farm.phase == 1 then
			advanceTimers(timers, dt)

			refreshTraining() -- the training heartbeat walks you to the treadmill and trains

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

			refreshThrowing() -- keeps the Auto Throw watcher alive (no-op if it is already running)

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
	pcall(learnThrowSpotIfBarVisible) -- if you are standing at the throw spot right now, remember it
	refreshTraining()
	refreshThrowing()
	task.spawn(function()
		local ok, err = pcall(farmLoop, token)
		if not ok then log("Farm error: " .. tostring(err)) end
	end)
end

local function stopFarm()
	stopLoop("AutoFarm") -- the training heartbeat notices and sends the final Stop
	notify("Auto Farming Paused", farmStatusText(), 3)
end

-- ============================================================
-- GUI (blue / purple theme)
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

-- Drag support for any frame (mouse and touch). Returns a function telling if the last press was a drag.
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

-- Main window (scales to the screen, good for mobile)
local MainFrame = make("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromScale(0.5, 0.8),
	BackgroundColor3 = THEME.Panel,
	BackgroundTransparency = 0.05,
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

-- Brineland pill (top of the screen, same look as the old hub): title, a "+" button that shows /
-- hides the window, and an "X" button that closes the script. Drag the pill to move it.
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
round(HubPill, UDim.new(1, 0)) -- fully rounded = oval
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
	Text = "+",
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
	HubPill.Visible = not visible -- the pill is only there while the window is hidden
end
setWindowVisible(true)
PlusBtn.MouseButton1Click:Connect(function() setWindowVisible(true) end)
MinimizeBtn.MouseButton1Click:Connect(function() setWindowVisible(false) end)

-- Auto Throw uses this so it never taps on top of this hub's own window or pill.
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

-- Tabs (scrollable tab bar so every tab fits on a phone)
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

-- Element generators -----------------------------------------------------------
local Toggles = {} -- [config key] = { Set = function(on) }
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

-- Range and step come from SETTINGS_SCHEMA, so the slider can never disagree with validation.
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
-- TABS AND FEATURES
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
	if on then refreshThrowing() end -- turning it off needs nothing: the watcher ends itself
end)
local ThrowStatus = CreateLabel(ThrowTab, throwStatusText(), 104)
CreateSection(ThrowTab, "Training & Plot")
CreateToggle(ThrowTab, "Auto Train", "AutoTrain", function(on)
	if on then refreshTraining() end -- turning it off needs nothing: the heartbeat sends Stop itself
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
CreateLabel(FarmTab, "Phase 1 (10 min): go to your treadmill, keep training and upgrade. Phase 2 (5 min): go to the throw spot, auto throw at the perfect bar, equip best and sell all (equip and sell use their own delays from Settings). Turning it off pauses and keeps your place in the cycle.", 110)

-- Extras
CreateSection(ExtrasTab, "Anti-AFK")
CreateToggle(ExtrasTab, "Anti-AFK (always on by default)", "AntiAFK", nil)
CreateLabel(ExtrasTab, "Stops Roblox from kicking you for standing still. Leave it on.", 44)
CreateSection(ExtrasTab, "2x speed button")
CreateToggle(ExtrasTab, "Auto 2x Speed Button", "AutoBoost", loopCallback("AutoBoost",
	function() return 1.5 end, pressBoost))
local BoostStatus = CreateLabel(ExtrasTab, boostStatusText(), 56)

-- Settings
CreateSection(SettingsTab, "Auto Throw")
CreateSlider(SettingsTab, "Perfect Bar Value", "PerfectValue", nil)
CreateSlider(SettingsTab, "Tap Method", "TapMethod", nil)
CreateLabel(SettingsTab, "Auto Throw taps when the bar number reaches Perfect Bar Value. Tap Method: 1 = screen tap, 2 = press the game's tap button, 3 = virtual click. If it never taps or the tap does nothing, try the next number.", 96)
CreateSection(SettingsTab, "Delays")
CreateSlider(SettingsTab, "Train Delay", "TrainDelay", "s")
CreateSlider(SettingsTab, "Upgrade Delay", "UpgradeDelay", "s")
CreateSlider(SettingsTab, "Equip Delay", "EquipDelay", "s")
CreateSlider(SettingsTab, "Free Animal Delay", "FreeDelay", "s")
CreateSlider(SettingsTab, "Sell Delay", "SellDelay", "s")
CreateSlider(SettingsTab, "Farm Upgrade Delay", "FarmUpgradeDelay", "s")
CreateLabel(SettingsTab, "Brineland Hub - Throw Food For Animals. Settings are validated and saved to Brineland/ThrowFood.json.", 62)

selectTab("Throw & Train")

-- Keep the status labels fresh
task.spawn(function()
	while alive do
		task.wait(0.3)
		FarmStatus.Text = farmStatusText()
		ThrowStatus.Text = throwStatusText()
		TrainStatus.Text = trainStatusText()
		BoostStatus.Text = boostStatusText()
		local barLabel = ThrowUI.label
		observeThrowSpot(barLabel ~= nil and barLabel:IsDescendantOf(PlayerGui) and isShown(barLabel))
	end
end)

-- ============================================================
-- CLOSE / CLEANUP
-- ============================================================
local function cleanup()
	if not alive then return end
	saveSettings()
	-- switch every feature off first (the training heartbeat then sends the final Training_Stop)
	for _, key in ipairs(FEATURE_KEYS) do
		if Config[key] and Toggles[key] then pcall(Toggles[key].Set, false) end
	end
	alive = false
	releaseCamera() -- hand the camera back to the game if the cutscene lock is on
	restoreHiddenGuis() -- and switch back on anything that was hidden for the current throw
	for _, connection in ipairs(connections) do pcall(function() connection:Disconnect() end) end
	pcall(function() ScreenGui:Destroy() end)
	if env.BrinelandThrowFoodUnload == cleanup then env.BrinelandThrowFoodUnload = nil end
end
env.BrinelandThrowFoodUnload = cleanup

CloseBtn.MouseButton1Click:Connect(cleanup)
PillCloseBtn.MouseButton1Click:Connect(cleanup)

notify("Brineland Hub", "Throw Food For Animals loaded. Tap FOOD to hide / show.", 4)
print("[BRINELAND] Throw Food For Animals Master Edition v7 loaded!")
