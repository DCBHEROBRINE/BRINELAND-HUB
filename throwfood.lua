-- BRINELAND: startup diagnostics and mobile Home layout
-- Paste this entire file into the executor after joining the game.
print("[Brineland] Starting Throw Food hub...")
local startupOK, startupError = xpcall(function()
-- ============================================================
-- BRINELAND HUB: THROW FOOD FOR ANIMALS (MASTER EDITION, v3)
-- Repository: https://github.com/DCBHEROBRINE/BRINELAND-HUB.git
--
-- Module-based Auto Throw update: retains the existing hub and farm.
-- Perfect/Fast Throw use game modules when available. No old camera/GUI cutscene guard.
-- Switch restoration is explicit; saved automation can sell or upgrade.
-- ============================================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local deadline = os.clock() + 15
while not LocalPlayer and os.clock() < deadline do
    task.wait(0.1)
    LocalPlayer = Players.LocalPlayer
end
if not LocalPlayer then error("LocalPlayer not ready. Join the game before running the script.") end
local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 15)
if not PlayerGui then error("PlayerGui not found after 15 seconds.") end
print("[Brineland] PlayerGui ready; creating hub.")
local env = _G
if type(getgenv) == "function" then
    local ok, value = pcall(getgenv)
    if ok and type(value) == "table" then env = value end
end

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

local PHASE1_SECONDS = 600 -- training + upgrades
local PHASE2_SECONDS = 300 -- throwing + equip best + sell all
local TELEPORT_INTERVAL = 1 -- how often Auto Farm checks where you are
local TELEPORT_TOLERANCE = 4 -- studs (flat distance). Closer than this = no teleport
local REMOTE_TIMEOUT = 10 -- seconds before a RemoteFunction call counts as failed

local EXPECTED_REMOTES = {
	"Training_Start", "Training_Stop",
	"Plot_EquipBest", "Plot_SellAll", "Stand_Upgrade", "Shop_ClaimFree",
}

-- ============================================================
-- SETTINGS (one table drives defaults, limits, sliders and validation)
-- ============================================================
local SETTINGS_SCHEMA = {
	FastSpeed        = { default = 3, min = 0.25, max = 10, step = 0.25 },
	TrainDelay       = { default = 0.5,    min = 0.1,  max = 3,   step = 0.1 },
	UpgradeDelay     = { default = 5,      min = 1,    max = 15,  step = 0.5 },
	EquipDelay       = { default = 2,      min = 0.5,  max = 5,   step = 0.25 },
	FreeDelay        = { default = 5,      min = 1,    max = 15,  step = 0.5 },
	SellDelay        = { default = 5,      min = 1,    max = 15,  step = 0.5 },
	FarmUpgradeDelay = { default = 60,     min = 5,    max = 120, step = 5 },
}

local SAVED_KEYS = {
	"FastSpeed", "TrainDelay", "UpgradeDelay",
	"EquipDelay", "FreeDelay", "SellDelay", "FarmUpgradeDelay",
}

local Config = {
	-- Dangerous automation starts off; saved switch states can be restored explicitly.
	AutoThrow = false,
	PerfectThrow = true,
	FastThrow = true,
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
	"AutoFarm", "AutoBoost", "PerfectThrow", "FastThrow",
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

local savedSwitches = {}
local suppressSwitchSave = false
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
	if not (writefile and makefolder and isfolder) then return false end
	local data = {}
	for _, key in ipairs(SAVED_KEYS) do data[key] = Config[key] end
	data.Switches = savedSwitches
	local ok, err = pcall(function()
		if not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end
		writefile(CONFIG_PATH, HttpService:JSONEncode(data))
	end)
	if not ok then log("Config save failed: " .. tostring(err)) end
	return ok
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

	if type(data.Switches) == "table" then
		for _, key in ipairs(FEATURE_KEYS) do
			if type(data.Switches[key]) == "boolean" then savedSwitches[key] = data.Switches[key] end
		end
		if type(data.Switches.AntiAFK) == "boolean" then savedSwitches.AntiAFK = data.Switches.AntiAFK end
	end
	-- Legacy numeric throw-bar settings are ignored by the new module-based throw.
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
	local ok, err = pcall(function()
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end)
	if not ok then log("Anti-AFK input unavailable: " .. tostring(err)) end
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
			-- Only consider reasonably horizontal, collidable top faces.
			if not part.CanCollide or math.abs(part.CFrame.UpVector.Y) < 0.8 then return end
			local area = size.X * size.Z
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
		-- Never intentionally choose a treadmill marked as another player's.
		if option.score >= 0 and (not best or option.score > best.score or (option.score == best.score and option.distance < best.distance)) then
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
	return nil, TRAIN_TOLERANCE
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
		table.insert(lines, "No usable treadmill found; not teleporting.")
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
						if position and teleportTo(position, tolerance) then
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
-- AUTO THROW: adapted from the supplied chukunhax module-based code.
-- No screen taps, camera lock, GUI hiding, or Throw_Complete spam.
-- It relies on this game's own ClientState / ThrowMeter / shared modules.
-- ============================================================
local hubCovers = function() return false end -- assigned when our window exists
local function isShown(inst)
    local node = inst
    while node do
        if node:IsA("GuiObject") and not node.Visible then return false end
        if node:IsA("LayerCollector") and not node.Enabled then return false end
        node = node.Parent
    end
    return true
end
local function tapWithInputManager(point)
    local okService, manager = pcall(function() return game:GetService("VirtualInputManager") end)
    if not (okService and manager) then return false end
    return pcall(function()
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
end
-- A successful signal call only means an attempt; it does not confirm game action.
local function pressButton(button)
    if type(getconnections) == "function" then
        for _, name in ipairs({ "Activated", "MouseButton1Click", "MouseButton1Down" }) do
            local okList, list = pcall(getconnections, button[name])
            if okList and type(list) == "table" then
                for _, connection in ipairs(list) do
                    if connection.Enabled ~= false then
                        local ok = pcall(function() connection:Fire() end)
                        if ok then return true end
                    end
                end
            end
        end
    end
    if type(firesignal) == "function" then return pcall(firesignal, button.Activated) end
    return false
end
local function screenCenterOf(inst)
    local center = inst.AbsolutePosition + inst.AbsoluteSize / 2
    local gui = inst:FindFirstAncestorWhichIsA("ScreenGui")
    if gui and not gui.IgnoreGuiInset then center = center + GuiService:GetGuiInset() end
    return center
end

local function wantsThrowing()
    if Config.AutoFarm then return Farm.phase == 2 end
    return Config.AutoThrow
end
local Throw = { loading = false, nextLoad = 0, note = "Off", mods = {}, originals = {}, writes = {}, errors = {} }
local function tryModule(inst, label)
    if not inst then Throw.errors[label] = "not found"; return nil end
    if not inst:IsA("ModuleScript") then Throw.errors[label] = "not a ModuleScript"; return nil end
    local ok, value = pcall(require, inst)
    if ok and type(value) == "table" then Throw.errors[label] = nil; return value end
    Throw.errors[label] = ok and "module did not return a table" or ("require: " .. clip(value, 100))
    return nil
end
local function loadThrowModules()
    if Throw.loading or os.clock() < Throw.nextLoad then return end
    Throw.loading = true
    Throw.nextLoad = os.clock() + 8
    task.spawn(function()
        local ok, err = pcall(function()
            local scripts = LocalPlayer:FindFirstChild("PlayerScripts")
            local client = scripts and scripts:FindFirstChild("Client")
            local controllers = client and client:FindFirstChild("Controllers")
            local shared = ReplicatedStorage:FindFirstChild("Shared")
            local config = ReplicatedStorage:FindFirstChild("Config")
            local modules = Throw.mods
            modules.state = modules.state or tryModule(controllers and controllers:FindFirstChild("ClientState"), "ClientState")
            modules.meter = modules.meter or tryModule(controllers and controllers:FindFirstChild("ThrowMeter"), "ThrowMeter")
            modules.config = modules.config or tryModule(config and config:FindFirstChild("GameConfig"), "GameConfig")
            modules.math = modules.math or tryModule(shared and shared:FindFirstChild("ThrowMeterMath"), "ThrowMeterMath")
            modules.arc = modules.arc or tryModule(shared and shared:FindFirstChild("ProjectileMath"), "ProjectileMath")
            modules.anim = modules.anim or tryModule(shared and shared:FindFirstChild("AnimationLibrary"), "AnimationLibrary")
        end)
        Throw.loading = false
        if not ok then Throw.errors.loader = clip(err, 120); log("Auto Throw module loading error: " .. tostring(err)) else Throw.errors.loader = nil end
    end)
end
local function restoreThrowMods()
    local m, o, w = Throw.mods, Throw.originals, Throw.writes
    pcall(function() if m.arc and o.arc and m.arc.CreateArc == w.arc then m.arc.CreateArc = o.arc end end)
    pcall(function() if m.anim and o.anim and m.anim.Play == w.anim then m.anim.Play = o.anim end end)
    if o.meterSaved and m.meter then
        pcall(function() if m.meter.TestAutoTap == w.meter then m.meter.TestAutoTap = o.meter end end)
    end
    if o.sequence then
        for key, value in pairs(o.sequence) do
            pcall(function() if o.sequenceTable[key] == w.sequence[key] then o.sequenceTable[key] = value end end)
        end
    end
    Throw.originals, Throw.writes = {}, {}
end
local sequenceKeys = { "FadeIn", "FadeOut", "POVDuration", "RevealZoomNormal", "RevealZoomDramatic", "ShowTimeNormal", "ShowTimeShort", "SkipAfterRevealDelay" }
local function installThrowMods()
    local m, o, w = Throw.mods, Throw.originals, Throw.writes
    if Config.PerfectThrow and m.meter and m.math and type(m.math.HalfPeriod) == "function" then
        local ok, half = pcall(m.math.HalfPeriod)
        if ok and type(half) == "number" and half == half and half > 0 then
            if not o.meterSaved then o.meter, o.meterSaved = m.meter.TestAutoTap, true end
            local value = half - (0.005 + math.random() * 0.002)
            local changed = pcall(function() m.meter.TestAutoTap = value end)
            if changed then w.meter = value; Throw.errors.meterWrite = nil
            else Throw.errors.meterWrite = "ThrowMeter is not writable" end
        else
            Throw.errors.HalfPeriod = ok and "returned an invalid value" or clip(half, 100)
        end
    elseif o.meterSaved then
        pcall(function() if m.meter.TestAutoTap == w.meter then m.meter.TestAutoTap = o.meter end end)
        o.meterSaved, o.meter, w.meter = nil, nil, nil
    end
    if not Config.FastThrow then
        -- Restore fast changes while leaving perfect mode on.
        pcall(function() if m.arc and o.arc and m.arc.CreateArc == w.arc then m.arc.CreateArc = o.arc end end)
        pcall(function() if m.anim and o.anim and m.anim.Play == w.anim then m.anim.Play = o.anim end end)
        if o.sequence then
            for key, value in pairs(o.sequence) do pcall(function() if o.sequenceTable[key] == w.sequence[key] then o.sequenceTable[key] = value end end) end
        end
        o.arc, o.anim, o.sequence, o.sequenceTable = nil, nil, nil, nil
        w.arc, w.anim, w.sequence = nil, nil, nil
        return
    end
    local function speed() return Config.FastSpeed * (0.94 + math.random() * 0.12) end
    if m.arc and not o.arc and type(m.arc.CreateArc) == "function" then
        local original = m.arc.CreateArc
        local wrapper = function(a, b, time, ...)
            if alive and wantsThrowing() and Config.FastThrow and type(time) == "number" then time = math.max(0.35, time / speed()) end
            return original(a, b, time, ...)
        end
        local ok = pcall(function() m.arc.CreateArc = wrapper end)
        if ok then o.arc, w.arc = original, wrapper; Throw.errors.arcWrite = nil else Throw.errors.arcWrite = "not writable" end
    end
    if m.anim and not o.anim and type(m.anim.Play) == "function" then
        local original = m.anim.Play
        local wrapper = function(rig, id, ...)
            local tr = original(rig, id, ...)
            if alive and wantsThrowing() and Config.FastThrow and tr and type(m.anim.GetThrowId) == "function" then
                local ok, throwId = pcall(m.anim.GetThrowId)
                if ok and throwId ~= nil and id == throwId then pcall(function() tr:AdjustSpeed(speed()) end) end
            end
            return tr
        end
        local ok = pcall(function() m.anim.Play = wrapper end)
        if ok then o.anim, w.anim = original, wrapper; Throw.errors.animWrite = nil else Throw.errors.animWrite = "not writable" end
    end
    local sequence = m.config and m.config.Sequence
    if type(sequence) == "table" then
        if not o.sequence then
            o.sequence, o.sequenceTable, w.sequence = {}, sequence, {}
            for _, key in ipairs(sequenceKeys) do if type(sequence[key]) == "number" then o.sequence[key] = sequence[key] end end
        end
        if sequence == o.sequenceTable then
            for key, base in pairs(o.sequence) do
                if w.sequence[key] == nil or sequence[key] == w.sequence[key] then
                    local value = math.max(0.08, base / Config.FastSpeed)
                    local ok = pcall(function() sequence[key] = value end)
                    if ok then w.sequence[key] = value end
                end
            end
        end
    end
end
local function throwCharacter()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if root and root:IsA("BasePart") and hum and hum.Health > 0 then return root, hum end
end
local function throwTarget(root)
    local area = workspace:FindFirstChild("StarterArea")
    if not area then return nil end
    local position, size
    if area:IsA("BasePart") then position, size = area.Position, area.Size
    elseif area:IsA("Model") then local cf; cf, size = area:GetBoundingBox(); position = cf.Position end
    if not position or not size then return nil end
    local line = area:FindFirstChild("CrossLine")
    local z = line and line:IsA("BasePart") and line.Position.Z or (position.Z + size.Z / 2)
    local halfX = math.max(0, size.X / 2 - 3)
    local x = math.clamp(root.Position.X, position.X - halfX, position.X + halfX)
    return Vector3.new(x, position.Y + size.Y / 2 + 3, z - 3)
end
local function refreshThrowing()
    if not wantsThrowing() then restoreThrowMods(); Throw.note = "Off" end
end
task.spawn(function()
    while alive do
        if wantsThrowing() then
            local ok, err = pcall(function()
                loadThrowModules()
                local m = Throw.mods
                Throw.note = "Waiting for game modules"
                if m.meter and m.math then Throw.note = "Module ready (server result not confirmed)" end
                installThrowMods()
                local root, hum = throwCharacter()
                if not root then Throw.note = "Waiting for character"; return end
                local state = m.state
                if state and (rawget(state, "Busy") == true or rawget(state, "OfflineOpen") == true) then Throw.note = "Game is busy"; return end
                if root.Anchored then Throw.note = "Character is anchored"; return end
                local target = throwTarget(root)
                if not target then Throw.note = "StarterArea not found"; return end
                local flat = Vector3.new(root.Position.X - target.X, 0, root.Position.Z - target.Z).Magnitude
                if flat > 1.5 then hum:MoveTo(target); Throw.note = "Walking to throw area" end
            end)
            if not ok then Throw.note = "Error; see console"; log("Auto Throw error: " .. tostring(err)) end
        else
            refreshThrowing()
        end
        task.wait(0.35)
    end
end)
local function throwStatusText()
    if not wantsThrowing() then return "Auto Throw is off.\nPerfect and Fast options apply when throwing is active." end
    local m = Throw.mods
    local meter = (m.meter and m.math and type(m.math.HalfPeriod) == "function") and "loaded" or "missing/unavailable"
    local detail = Throw.errors.meterWrite or Throw.errors.HalfPeriod or Throw.errors.ThrowMeter or Throw.errors.ThrowMeterMath
    return "Auto Throw: " .. Throw.note .. "\nMeter: " .. meter
        .. " | Fast modules: " .. ((m.arc or m.anim or m.config) and "loaded" or "unavailable")
        .. (detail and ("\nDetails: " .. tostring(detail)) or "")
end

-- ============================================================
-- AUTO 2x SPEED BUTTON
-- A round "x2" button pops up now and then; tapping it gives 2x speed for a while.
-- This finds it (a visible button with "x2" written on it) and presses it for you.
-- Shop/purchase name and text checks reduce false positives but cannot prove safety.
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
		local text = (node:IsA("TextLabel") or node:IsA("TextButton")) and string.lower(node.Text) or ""
		for _, word in ipairs(BOOST_BLOCKED_WORDS) do
			if string.find(lower, word, 1, true) or string.find(text, word, 1, true) then return true end
		end
		if node:IsA("GuiButton") then
			for _, child in ipairs(node:GetDescendants()) do
				if child:IsA("TextLabel") or child:IsA("TextButton") then
					local childText = child.Text:lower()
					for _, word in ipairs(BOOST_BLOCKED_WORDS) do if childText:find(word, 1, true) then return true end end
				end
			end
		end
		node = node.Parent
	end
	return false
end

local function usableBoostButton(button)
	if not (button and isShown(button)) then return false end
	local size = button.AbsoluteSize
	if size.X > 300 or size.Y > 300 then return false end
	if insideBlockedScreen(button) then return false end
	-- Require a speed/boost hint close to the button, not just unrelated "x2" text.
	local node, depth, relevant = button, 0, false
	while node and node ~= PlayerGui and depth < 4 do
		local name = node.Name:lower()
		if name:find("speed", 1, true) or name:find("boost", 1, true) then relevant = true end
		if node:IsA("TextLabel") or node:IsA("TextButton") then
			local text = node.Text:lower()
			if text:find("speed", 1, true) or text:find("boost", 1, true) then relevant = true end
		end
		node, depth = node.Parent, depth + 1
	end
	return relevant
end

local function findBoostButton()
	for _, inst in ipairs(PlayerGui:GetDescendants()) do
		if (inst:IsA("TextLabel") or inst:IsA("TextButton")) and isBoostText(inst.Text)
			and isShown(inst) and not inst:FindFirstAncestor("ThrowFoodHub") then
			-- Text must belong to the clickable button, never an arbitrary sibling.
			local button = inst:IsA("GuiButton") and inst or inst:FindFirstAncestorWhichIsA("GuiButton")
			if usableBoostButton(button) then return button end
		end
	end
	return nil
end

local function pressBoost()
	local button = findBoostButton()
	BoostInfo.found = button ~= nil
	if not button then
		BoostInfo.note = "waiting for a recognizable speed button"
		return
	end

	local last = boostPressedAt[button]
	if last and os.clock() - last < 8 then return end -- just pressed it, give it time to go away
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
		boostPressedAt[button] = os.clock()
		BoostInfo.presses = BoostInfo.presses + 1
		BoostInfo.note = "attempted (" .. method .. "); not confirmed"
	else
		BoostInfo.note = "found it but could not press it"
	end
end

local function boostStatusText()
	if not Config.AutoBoost then return "Auto 2x Speed is off." end
	return "2x speed button: " .. BoostInfo.note .. "\nAttempts: " .. BoostInfo.presses
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
	return { equip = math.huge, sell = math.huge }
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

			refreshThrowing() -- module-based throw walks towards StarterArea

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
	refreshTraining()
	refreshThrowing()
	task.spawn(function()
		local ok, err = pcall(farmLoop, token)
		if not ok then log("Farm error: " .. tostring(err)) end
	end)
end

local function stopFarm()
	stopLoop("AutoFarm") -- the training heartbeat notices and sends the final Stop
	refreshThrowing()
	refreshTraining()
	notify("Auto Farming Paused", farmStatusText(), 3)
end

-- ============================================================
-- GUI: same monochrome style as Brineland main.lua
-- ============================================================
local THEME = {
    Panel = Color3.fromRGB(10, 10, 12),
    Top = Color3.fromRGB(24, 24, 28),
    Row = Color3.fromRGB(24, 24, 28),
    Tab = Color3.fromRGB(24, 24, 28),
    TabText = Color3.fromRGB(180, 180, 190),
    Accent = Color3.fromRGB(255, 255, 255),
    TabOn = Color3.fromRGB(255, 255, 255),
    Off = Color3.fromRGB(46, 46, 54),
    Text = Color3.fromRGB(255, 255, 255),
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
-- Match main.lua: use PlayerGui first; avoid a hidden/inaccessible executor container.
local okGui, guiError = pcall(function() ScreenGui.Parent = PlayerGui end)
if not okGui or not ScreenGui.Parent then
    if type(gethui) == "function" then
        pcall(function() ScreenGui.Parent = gethui() end)
    end
    if not ScreenGui.Parent then pcall(function() ScreenGui.Parent = CoreGui end) end
end
if not ScreenGui.Parent then error("Could not display Throw Food GUI: " .. tostring(guiError)) end
ScreenGui.Enabled = true
print("[Brineland] GUI parented to " .. ScreenGui.Parent.ClassName)

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

-- Main window, top bar, and collapse button like main.lua. No extra pill.
local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)
local HUB_WIDTH = math.max(250, math.min(420, vp.X - 24))
local HUB_HEIGHT = math.max(190, math.min(315, vp.Y - 65))
local MainFrame = make("Frame", {
    Position = UDim2.fromOffset(16, 48), Size = UDim2.fromOffset(HUB_WIDTH, HUB_HEIGHT),
    BackgroundColor3 = THEME.Panel, BackgroundTransparency = 0.06,
    BorderSizePixel = 0, Active = true, ClipsDescendants = true,
}, ScreenGui)
round(MainFrame, UDim.new(0, 12))
make("UIStroke", {Color = THEME.Text, Thickness = 1.5, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, MainFrame)
local TopBar = make("Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = THEME.Top, BackgroundTransparency = 0.1, BorderSizePixel = 0, Active = true}, MainFrame)
round(TopBar, UDim.new(0, 12))
make("TextLabel", {Size = UDim2.new(1, -130, 1, 0), Position = UDim2.fromOffset(12, 0),
    BackgroundTransparency = 1, Text = "Brineland", TextColor3 = THEME.Text,
    Font = Enum.Font.Fondamento, TextSize = 19, TextXAlignment = Enum.TextXAlignment.Left}, TopBar)
local HomeBtn = make("TextButton", {Size = UDim2.fromOffset(50, 24), Position = UDim2.new(1, -120, 0.5, -12),
    BackgroundColor3 = THEME.Accent, Text = "Home", TextColor3 = THEME.Panel, Font = Enum.Font.GothamBold, TextSize = 10}, TopBar)
round(HomeBtn, UDim.new(1, 0))
local MinimizeBtn = make("TextButton", {Size = UDim2.fromOffset(26, 26), Position = UDim2.new(1, -62, 0.5, -13),
    BackgroundColor3 = THEME.Off, Text = "▼", TextColor3 = THEME.Text, Font = Enum.Font.GothamBold, TextSize = 10}, TopBar)
round(MinimizeBtn, UDim.new(1, 0))
make("UIStroke", {Color = THEME.Text, Transparency = 0.2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, MinimizeBtn)
local CloseBtn = make("TextButton", {Size = UDim2.fromOffset(26, 26), Position = UDim2.new(1, -32, 0.5, -13),
    BackgroundColor3 = THEME.Off, Text = "X", TextColor3 = THEME.Text, Font = Enum.Font.GothamBold, TextSize = 11}, TopBar)
round(CloseBtn, UDim.new(1, 0))
make("UIStroke", {Color = THEME.Text, Transparency = 0.2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, CloseBtn)
makeDraggable(TopBar, MainFrame)
hubCovers = function(point)
    if not MainFrame.Visible then return false end
    local p, size = MainFrame.AbsolutePosition, MainFrame.AbsoluteSize
    return point.X >= p.X - 8 and point.X <= p.X + size.X + 8 and point.Y >= p.Y - 8 and point.Y <= p.Y + size.Y + 8
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
		BackgroundColor3 = THEME.Panel,
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
		Text = '<font color="#FFFFFF"><b>' .. tostring(title) .. "</b></font>\n" .. tostring(message),
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
local activeTab, collapsed = "Home", false
local function selectTab(name)
    activeTab = name
    for tabName, data in pairs(TabFrames) do
        local on = tabName == name
        data.Container.Visible = on and not collapsed
        if data.Button then
            data.Button.BackgroundColor3 = on and THEME.TabOn or THEME.Tab
            data.Button.TextColor3 = on and THEME.Panel or THEME.TabText
        end
    end
    HomeBtn.BackgroundColor3 = name == "Home" and THEME.Text or THEME.Off
    HomeBtn.TextColor3 = name == "Home" and THEME.Panel or THEME.Text
end
local function setCollapsed(on)
    collapsed = on
    TabBar.Visible = not on
    MainFrame.Size = UDim2.fromOffset(HUB_WIDTH, on and 40 or HUB_HEIGHT)
    MinimizeBtn.Text = on and "▲" or "▼"
    selectTab(activeTab)
end
MinimizeBtn.MouseButton1Click:Connect(function() setCollapsed(not collapsed) end)
HomeBtn.MouseButton1Click:Connect(function() if collapsed then setCollapsed(false) end; selectTab("Home") end)
track(UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then MainFrame.Visible = not MainFrame.Visible end
end))

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
	round(tabBtn, UDim.new(1, 0))
    make("UIStroke", {Color = THEME.Text, Thickness = 1, Transparency = 0.35, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, tabBtn)
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
	round(frame, UDim.new(0, 8))
    make("UIStroke", {Color = THEME.Text, Thickness = 1, Transparency = 0.25, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, frame)

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
		BackgroundColor3 = Config[configKey] and THEME.Panel or THEME.Text,
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
		if not suppressSwitchSave then savedSwitches[configKey] = state end
		TweenService:Create(knob, TweenInfo.new(0.15), {
			Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
		}):Play()
		toggleBg.BackgroundColor3 = state and THEME.Accent or THEME.Off
        knob.BackgroundColor3 = state and THEME.Panel or THEME.Text
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
		BackgroundColor3 = THEME.Row,
		Text = text,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		LayoutOrder = nextOrder(parent),
	}, parent)
	round(button, UDim.new(1, 0))
    make("UIStroke", {Color = THEME.Text, Thickness = 1, Transparency = 0.25, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, button)
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
	round(frame, UDim.new(0, 8))
    make("UIStroke", {Color = THEME.Text, Thickness = 1, Transparency = 0.25, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, frame)

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
local HomeTab = make("ScrollingFrame", {
    Size = UDim2.new(1, -14, 1, -83), Position = UDim2.new(0, 7, 0, 80),
    BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false,
    CanvasSize = UDim2.fromOffset(0, 232), ScrollBarThickness = 3,
    ScrollBarImageColor3 = THEME.Text,
}, MainFrame)
TabFrames.Home = {Container = HomeTab}
local ThrowTab = CreateTab("Throw & Train")
local ShopTab = CreateTab("Upgrades & Shop")
local FarmTab = CreateTab("Farm")
local ExtrasTab = CreateTab("Extras")
local SettingsTab = CreateTab("Settings")
-- Welcome, social buttons and two quick-navigation cards, like main.lua.
make("TextLabel", {Size = UDim2.new(0.62, 0, 0, 34), Position = UDim2.fromOffset(6, 2), BackgroundTransparency = 1,
    Text = "Welcome back to\nBRINELAND HUB", TextColor3 = THEME.Text, Font = Enum.Font.GothamBold, TextSize = 13,
    TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left}, HomeTab)
make("TextLabel", {Size = UDim2.new(0.62, 0, 0, 56), Position = UDim2.fromOffset(6, 38), BackgroundTransparency = 1,
    Text = "Throw Food for Animals\nTraining, throw and farm tools.\nUse the tabs above to get started.", TextColor3 = THEME.TabText,
    Font = Enum.Font.Gotham, TextSize = 10, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top}, HomeTab)
local badge = make("Frame", {Size = UDim2.new(0.35, -6, 0, 88), Position = UDim2.new(0.65, 2, 0, 4), BackgroundColor3 = THEME.Row}, HomeTab)
round(badge, UDim.new(0, 10))
make("UIStroke", {Color = THEME.Text, Thickness = 1, Transparency = 0.25, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, badge)
make("TextLabel", {Size = UDim2.new(1, -10, 0, 26), Position = UDim2.fromOffset(5, 8), BackgroundTransparency = 1,
    Text = "BRINELAND", TextColor3 = THEME.Text, Font = Enum.Font.Fondamento, TextSize = 16}, badge)
make("TextLabel", {Size = UDim2.new(1, -10, 0, 44), Position = UDim2.fromOffset(5, 36), BackgroundTransparency = 1,
    Text = "THROW FOOD\nEDITION", TextColor3 = THEME.TabText, Font = Enum.Font.GothamBold, TextSize = 9, TextWrapped = true}, badge)
local function homeButton(text, x, y, w, h, action)
    local b = make("TextButton", {Size = UDim2.new(0.49, -2, 0, h), Position = UDim2.new(x, 0, 0, y),
        BackgroundColor3 = THEME.Row, Text = text, TextColor3 = THEME.Text, Font = Enum.Font.GothamBold,
        TextSize = 10, TextWrapped = true}, HomeTab)
    round(b, UDim.new(0, 8))
    make("UIStroke", {Color = THEME.Text, Thickness = 1, Transparency = 0.25, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, b)
    b.MouseButton1Click:Connect(action)
end
local function copySocial(url)
    local copy = setclipboard or toclipboard
    if type(copy) == "function" then
        local ok = pcall(copy, url)
        notify("Brineland", ok and "Link copied." or "Could not copy link.", 3)
    else notify("Brineland", "Clipboard not supported.", 3) end
end
homeButton("DISCORD", 0, 100, 0.49, 32, function() copySocial("https://discord.gg/epWMbuXSN5") end)
homeButton("YOUTUBE", 0.51, 100, 0.49, 32, function() copySocial("https://youtube.com/@dcb_herobrine?si=PN8mSo36sJFaySFQ") end)
-- Two feature cards with the same title/description layout as main.lua.
local function homeCard(x, title, description, target)
    local card = make("TextButton", {Size = UDim2.new(0.49, -2, 0, 84),
        Position = UDim2.new(x, 0, 0, 140), BackgroundColor3 = THEME.Row,
        Text = "", AutoButtonColor = false}, HomeTab)
    round(card, UDim.new(0, 10))
    make("UIStroke", {Color = THEME.Text, Thickness = 1, Transparency = 0.25,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, card)
    make("TextLabel", {Size = UDim2.new(1, -16, 0, 22), Position = UDim2.fromOffset(10, 8),
        BackgroundTransparency = 1, Text = title, TextColor3 = THEME.Text,
        Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left}, card)
    make("TextLabel", {Size = UDim2.new(1, -16, 0, 44), Position = UDim2.fromOffset(10, 32),
        BackgroundTransparency = 1, Text = description, TextColor3 = THEME.TabText,
        Font = Enum.Font.Gotham, TextSize = 10, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top}, card)
    card.MouseButton1Click:Connect(function() selectTab(target) end)
end
homeCard(0, "Throw & Train", "Auto Throw, Perfect, Fast and training", "Throw & Train")
homeCard(0.51, "Auto Farm", "Training and throw cycles", "Farm")

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
CreateToggle(ThrowTab, "Auto Throw", "AutoThrow", function() refreshThrowing() end)
CreateToggle(ThrowTab, "Perfect Throw", "PerfectThrow", function() end)
CreateToggle(ThrowTab, "Fast Throw", "FastThrow", function() end)
local ThrowStatus = CreateLabel(ThrowTab, throwStatusText(), 104)
CreateSection(ThrowTab, "Training & Plot")
CreateToggle(ThrowTab, "Auto Train", "AutoTrain", function(on)
	if on then refreshTraining() end -- turning it off needs nothing: the heartbeat sends Stop itself
end)
local TrainStatus = CreateLabel(ThrowTab, trainStatusText(), 78)
CreateToggle(ThrowTab, "Auto Equip Best", "AutoEquipBest", loopCallback("AutoEquipBest",
	function() return Config.EquipDelay end,
	function() if not Config.AutoFarm then callRemote("Plot_EquipBest") end end))
CreateToggle(ThrowTab, "Auto Sell All", "AutoSell", loopCallback("AutoSell",
	function() return Config.SellDelay end,
	function() if not Config.AutoFarm then callRemote("Plot_SellAll") end end))

-- Upgrades & Shop
CreateSection(ShopTab, "Upgrades & Shop")
CreateToggle(ShopTab, "Auto Upgrade Stand", "AutoUpgradeBar", loopCallback("AutoUpgradeBar",
	function() return Config.UpgradeDelay end,
	function() if not Config.AutoFarm then callRemote("Stand_Upgrade") end end))
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
CreateLabel(FarmTab, "Phase 1 (10 min): train and upgrade. Phase 2 (5 min): walk to the throw area, throw, equip best and SELL ALL. Farm owns upgrade/equip/sell while running. Pausing keeps the cycle position for this session.", 110)

-- Extras
CreateSection(ExtrasTab, "Anti-AFK")
CreateToggle(ExtrasTab, "Anti-AFK (always on by default)", "AntiAFK", nil)
CreateLabel(ExtrasTab, "Attempts to prevent idle disconnects; support depends on your executor.", 44)
CreateSection(ExtrasTab, "2x speed button")
CreateToggle(ExtrasTab, "Auto 2x Speed Button", "AutoBoost", loopCallback("AutoBoost",
	function() return 1.5 end, pressBoost))
local BoostStatus = CreateLabel(ExtrasTab, boostStatusText(), 56)

-- Settings
CreateSection(SettingsTab, "Auto Throw")
CreateSlider(SettingsTab, "Fast Throw Speed", "FastSpeed", "x")
CreateButton(SettingsTab, "Retry Throw Modules", function()
    Throw.nextLoad = 0
    loadThrowModules()
    notify("Auto Throw", "Retrying module loading. Check Throw & Train status.", 4)
end)
CreateButton(SettingsTab, "Copy Diagnostics", function()
    local lines = {"PlaceId: " .. tostring(game.PlaceId), "Auto Throw: " .. Throw.note}
    for _, name in ipairs({"ClientState", "ThrowMeter", "ThrowMeterMath", "GameConfig", "ProjectileMath", "AnimationLibrary", "meterWrite", "HalfPeriod", "arcWrite", "animWrite", "loader"}) do
        if Throw.errors[name] then table.insert(lines, name .. ": " .. tostring(Throw.errors[name])) end
    end
    for _, name in ipairs(EXPECTED_REMOTES) do
        local remote = getRemote(name)
        table.insert(lines, name .. ": " .. (remote and "found" or "missing"))
    end
    local copy = setclipboard or toclipboard
    local ok = type(copy) == "function" and pcall(copy, table.concat(lines, "\n"))
    notify("Diagnostics", ok and "Copied diagnostics." or "Clipboard not supported.", 4)
end)
CreateLabel(SettingsTab, "Uses the game's ThrowMeter and math modules; Perfect and Fast are applied only while Auto Throw or farm phase 2 is active. Module support and successful throws depend on the game.", 92)
CreateSection(SettingsTab, "Saved Switches")
CreateLabel(SettingsTab, "Switch states are saved. They do not start automatically. Loading can start farming, upgrades and SELL ALL.", 62)
CreateButton(SettingsTab, "Save Current Switches", function()
	for key in pairs(Toggles) do savedSwitches[key] = Config[key] == true end
	if saveSettings() then
		notify("Config", "Current switches saved.", 4)
	else
		notify("Config", "Could not save switches. Check executor file support.", 5)
	end
end)
CreateButton(SettingsTab, "Load Saved Switches", function()
	if not next(savedSwitches) then notify("Config", "No saved switches yet.", 4); return end
	-- Avoid overwriting the remaining snapshot while toggles are being applied.
	suppressSwitchSave = true
	for _, key in ipairs({ "PerfectThrow", "FastThrow", "AntiAFK", "AutoFarm", "AutoTrain", "AutoThrow", "AutoEquipBest", "AutoSell", "AutoUpgradeBar", "AutoClaimFreeAnimal", "AutoBoost" }) do
		local value = savedSwitches[key]
		if type(value) == "boolean" and Toggles[key] then Toggles[key].Set(value) end
	end
	suppressSwitchSave = false
	notify("Config", "Saved switches loaded.", 4)
end)
CreateSection(SettingsTab, "Delays")
CreateSlider(SettingsTab, "Train Delay", "TrainDelay", "s")
CreateSlider(SettingsTab, "Upgrade Delay", "UpgradeDelay", "s")
CreateSlider(SettingsTab, "Equip Delay", "EquipDelay", "s")
CreateSlider(SettingsTab, "Free Animal Delay", "FreeDelay", "s")
CreateSlider(SettingsTab, "Sell Delay", "SellDelay", "s")
CreateSlider(SettingsTab, "Farm Upgrade Delay", "FarmUpgradeDelay", "s")
CreateLabel(SettingsTab, "Brineland Hub - Throw Food For Animals. Settings are validated and saved to Brineland/ThrowFood.json.", 62)

selectTab("Home")
print("[Brineland] Home screen ready.")

-- Keep the status labels fresh
task.spawn(function()
	while alive do
		task.wait(0.3)
		FarmStatus.Text = farmStatusText()
		ThrowStatus.Text = throwStatusText()
		TrainStatus.Text = trainStatusText()
		BoostStatus.Text = boostStatusText()
	end
end)

-- ============================================================
-- CLOSE / CLEANUP
-- ============================================================
local function cleanup()
	if not alive then return end
	saveSettings()
	suppressSwitchSave = true -- unloading must not erase the saved on/off states
	-- switch every feature off first (the training heartbeat then sends the final Training_Stop)
	for _, key in ipairs(FEATURE_KEYS) do
		if Config[key] and Toggles[key] then pcall(Toggles[key].Set, false) end
	end
	alive = false
	restoreThrowMods() -- restore only module fields still owned by this hub
	for _, connection in ipairs(connections) do pcall(function() connection:Disconnect() end) end
	pcall(function() ScreenGui:Destroy() end)
	if env.BrinelandThrowFoodUnload == cleanup then env.BrinelandThrowFoodUnload = nil end
end
env.BrinelandThrowFoodUnload = cleanup

CloseBtn.MouseButton1Click:Connect(cleanup)

notify("Brineland Hub", "Throw Food loaded. Use the arrow to collapse or expand.", 4)
print("[BRINELAND] Throw Food For Animals Master Edition (module throw update) loaded!")

end, function(err)
    if debug and type(debug.traceback) == "function" then
        return debug.traceback(tostring(err), 2)
    end
    return tostring(err)
end)
if not startupOK then
    warn("[Brineland] Startup failed: " .. tostring(startupError))
end
