--[[
	Brineland Hub - Bake or Die (Full Master Edition)
	- Custom blue/purple mobile GUI (drag title bar, "-" minimise, "X" close)
	- Full Remote Recorder & Replay system for reliable pickups/deposits
	- Auto Zombie Grinder & Auto Crafting Grinder (fully implemented)
	- Bring Items / Medicine / Zombies with instant/fallback methods
	- Optimized Caching ESP, respawn-safe WalkSpeed/JumpPower, and Noclip cleanup
]]

local env = (getgenv and getgenv()) or _G

for _, key in ipairs({ "BrinelandHubUnload", "ZanneoHubUnload" }) do
	if env[key] then pcall(env[key]) end
end

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")
local LocalPlayer = Players.LocalPlayer

-- Tweakables
local ATTACK_INTERVAL = 0.1
local ESP_INTERVAL = 0.25
local MAX_HIGHLIGHTS = 30
local CONFIG_FOLDER = "Brineland"
local CONFIG_PATH = CONFIG_FOLDER .. "/BakeOrDie.json"

local MEDICINE_KEYWORDS = { "bandage", "revive", "first", "medkit", "medic", "heal", "aidkit", "aid kit" }
local MATERIAL_KEYWORDS = { "wood", "scrap", "scratch", "nail", "plank", "board", "metal", "iron", "stool", "chair" }
local PICKUP_PATTERNS = { "pick", "take", "grab", "collect" }
local PICKUP_KEY = Enum.KeyCode.E
local DEPOSIT_PATTERNS = { "deposit", "grind", "insert", "put", "place" }
local DEPOSIT_KEY = Enum.KeyCode.Q
local GRIND_PER_SECOND = 3
local PICKUP_DELAY = 0.04

local GRINDER_COORDS = {
	zombies = Vector3.new(-14, 51, 110),
	crafting = Vector3.new(13, 51, 118),
}

local TELEPORTS = {
	{ "Hospital", Vector3.new(124, 19, 382) },
	{ "Warehouse", Vector3.new(605, 51, 122) },
	{ "Bank", Vector3.new(947, 51, -127) },
	{ "Zombie Grinder", Vector3.new(-14, 51, 110) },
	{ "Items Grinder", Vector3.new(13, 51, 118) },
}

-- State
local alive = true
local connections = {}
local state = {
	killAura = false,
	auraDistance = 25,
	weaponSlot = 2,
	walkSpeed = nil,
	jumpPower = nil,
	noclip = false,
	esp = {
		monsters = false,
		items = false,
		medicine = false,
		bodies = false,
		showNames = true,
		showDistance = true,
		showHighlight = true,
	},
}

local function track(connection)
	table.insert(connections, connection)
	return connection
end

local cleanup

---------------------------------------------------------------------
-- GUI Library
---------------------------------------------------------------------
local THEME = {
	Background = Color3.fromRGB(16, 13, 40),
	BackgroundEnd = Color3.fromRGB(40, 22, 86),
	Topbar = Color3.fromRGB(10, 8, 28),
	Element = Color3.fromRGB(28, 23, 66),
	ElementHover = Color3.fromRGB(44, 36, 98),
	Accent = Color3.fromRGB(0, 170, 255),
	AccentEnd = Color3.fromRGB(125, 85, 255),
	Text = Color3.fromRGB(240, 240, 255),
	SubText = Color3.fromRGB(170, 170, 215),
	Danger = Color3.fromRGB(225, 35, 65),
	Off = Color3.fromRGB(72, 68, 112),
}

local function new(class, props, parent)
	local inst = Instance.new(class)
	for key, value in pairs(props) do inst[key] = value end
	if parent then inst.Parent = parent end
	return inst
end

local function corner(inst, radius) return new("UICorner", { CornerRadius = UDim.new(0, radius) }, inst) end
local function stroke(inst, color, transparency) return new("UIStroke", { Color = color, Transparency = transparency, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, inst) end
local function gradient(inst, from, to, rotation) return new("UIGradient", { Color = ColorSequence.new(from, to), Rotation = rotation or 0 }, inst) end

local function textLabel(parent, props)
	local base = { BackgroundTransparency = 1, Font = Enum.Font.GothamMedium, TextSize = 13, TextColor3 = THEME.Text, TextXAlignment = Enum.TextXAlignment.Left }
	for key, value in pairs(props) do base[key] = value end
	return new("TextLabel", base, parent)
end

local function protectedParent(inst)
	local ok = pcall(function() inst.Parent = (gethui and gethui()) or CoreGui end)
	if not ok or not inst.Parent then inst.Parent = LocalPlayer:WaitForChild("PlayerGui") end
end

local Gui = new("ScreenGui", { Name = "BrinelandHub", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling })
protectedParent(Gui)

local Main = new("Frame", { Name = "Main", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(0.5, 0.8), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Active = true, ClipsDescendants = true }, Gui)
new("UISizeConstraint", { MinSize = Vector2.new(330, 220), MaxSize = Vector2.new(520, 340) }, Main)
corner(Main, 12)
stroke(Main, THEME.Accent, 0.55)
gradient(Main, THEME.Background, THEME.BackgroundEnd, 35)

local Topbar = new("Frame", { Name = "Topbar", Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = THEME.Topbar, BackgroundTransparency = 0.15, BorderSizePixel = 0, Active = true }, Main)

textLabel(Topbar, { Position = UDim2.fromOffset(12, 0), Size = UDim2.new(1, -96, 1, 0), Font = Enum.Font.GothamBold, TextSize = 15, RichText = true, TextTruncate = Enum.TextTruncate.AtEnd, Text = 'BRINELAND <font color="#18D4FF">BAKE OR DIE</font>' })

local function topButton(text, color, xOffset)
	local button = new("TextButton", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, xOffset, 0.5, 0), Size = UDim2.fromOffset(32, 26), BackgroundColor3 = color, AutoButtonColor = false, Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = Color3.new(1, 1, 1), Text = text }, Topbar)
	corner(button, 6)
	return button
end

local MinimiseButton = topButton("-", Color3.fromRGB(40, 38, 100), -46)
local CloseButton = topButton("X", THEME.Danger, -8)

-- Dragging Support with connection tracking
do
	local dragging, dragStart, startPosition = false, nil, nil
	track(Topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPosition = Main.Position
			local endConn
			endConn = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					if endConn then endConn:Disconnect() end
				end
			end)
			track(endConn)
		end
	end))
	track(UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			Main.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
		end
	end))
end

local Pill = new("TextButton", { Name = "Pill", AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 10), Size = UDim2.fromOffset(124, 30), BackgroundColor3 = Color3.new(1, 1, 1), AutoButtonColor = false, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = Color3.new(1, 1, 1), Text = "BRINELAND", Visible = false }, Gui)
corner(Pill, 15)
gradient(Pill, THEME.Accent, THEME.AccentEnd, 0)

local function setMinimised(minimised)
	Main.Visible = not minimised
	Pill.Visible = minimised
end

MinimiseButton.MouseButton1Click:Connect(function() setMinimised(true) end)
Pill.MouseButton1Click:Connect(function() setMinimised(false) end)
CloseButton.MouseButton1Click:Connect(function() if cleanup then cleanup() end end)

track(UserInputService.InputBegan:Connect(function(input, processed)
	if not processed and input.KeyCode == Enum.KeyCode.RightShift then setMinimised(Main.Visible) end
end))

local TabBar = new("ScrollingFrame", { Position = UDim2.fromOffset(8, 44), Size = UDim2.new(1, -16, 0, 30), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0, ScrollingDirection = Enum.ScrollingDirection.X, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.X }, Main)
new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Center }, TabBar)

local Content = new("Frame", { Position = UDim2.fromOffset(8, 80), Size = UDim2.new(1, -16, 1, -88), BackgroundTransparency = 1 }, Main)

local Toast
local function notify(title, message, duration)
	if not alive or not Gui.Parent then return end
	if Toast then Toast:Destroy() end
	local toast = new("Frame", { AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -14), Size = UDim2.fromOffset(0, 0), AutomaticSize = Enum.AutomaticSize.XY, BackgroundColor3 = THEME.Topbar, BorderSizePixel = 0 }, Gui)
	corner(toast, 10)
	stroke(toast, THEME.Accent, 0.4)
	new("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14), PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8) }, toast)
	textLabel(toast, { Size = UDim2.fromOffset(0, 0), AutomaticSize = Enum.AutomaticSize.XY, TextWrapped = true, RichText = true, Text = '<font color="#18D4FF"><b>' .. tostring(title) .. "</b></font>\n" .. tostring(message) })
	Toast = toast
	task.delay(duration or 4, function()
		if Toast == toast then Toast = nil end
		toast:Destroy()
	end)
end

-- Configuration Handling
local flags = {}
local saveQueued = false

local function saveConfig()
	if not (writefile and makefolder and isfolder) then return end
	local data = {}
	for flag, handler in pairs(flags) do data[flag] = handler.get() end
	pcall(function()
		if not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end
		writefile(CONFIG_PATH, HttpService:JSONEncode(data))
	end)
end

local function queueSave()
	if saveQueued then return end
	saveQueued = true
	task.delay(0.6, function()
		saveQueued = false
		if alive then saveConfig() end
	end)
end

local function loadConfig()
	if not (readfile and isfile) then return end
	local ok, data = pcall(function()
		if isfile(CONFIG_PATH) then return HttpService:JSONDecode(readfile(CONFIG_PATH)) end
	end)
	if ok and type(data) == "table" then
		for flag, value in pairs(data) do
			local handler = flags[flag]
			if handler then pcall(handler.set, value) end
		end
	end
end

local tabs = {}

local function selectTab(selected)
	for _, tab in ipairs(tabs) do
		local on = tab == selected
		tab.page.Visible = on
		TweenService:Create(tab.button, TweenInfo.new(0.15), { BackgroundColor3 = on and THEME.Accent or THEME.Element, TextColor3 = on and Color3.new(1, 1, 1) or THEME.SubText }):Play()
	end
end

local function createTab(name)
	local tab = {}
	tab.button = new("TextButton", { Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, BackgroundColor3 = THEME.Element, AutoButtonColor = false, Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = THEME.SubText, Text = name, LayoutOrder = #tabs + 1 }, TabBar)
	corner(tab.button, 8)
	new("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) }, tab.button)

	local page = new("ScrollingFrame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = THEME.Accent, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false }, Content)
	new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, page)
	new("UIPadding", { PaddingRight = UDim.new(0, 8), PaddingBottom = UDim.new(0, 6) }, page)
	tab.page = page

	local order = 0
	local function nextOrder() order += 1 return order end
	local function row(height)
		local frame = new("Frame", { Size = UDim2.new(1, 0, 0, height), BackgroundColor3 = THEME.Element, BorderSizePixel = 0, LayoutOrder = nextOrder() }, page)
		corner(frame, 8)
		stroke(frame, THEME.Accent, 0.85)
		return frame
	end

	tab.button.MouseButton1Click:Connect(function() selectTab(tab) end)

	function tab:Section(text)
		textLabel(page, { Size = UDim2.new(1, 0, 0, 18), Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = THEME.Accent, Text = string.upper(text), LayoutOrder = nextOrder() })
	end

	function tab:Button(opts)
		local frame = row(36)
		local button = new("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = THEME.Text, Text = opts.Name }, frame)
		button.MouseButton1Down:Connect(function() TweenService:Create(frame, TweenInfo.new(0.1), { BackgroundColor3 = THEME.ElementHover }):Play() end)
		local function release() TweenService:Create(frame, TweenInfo.new(0.2), { BackgroundColor3 = THEME.Element }):Play() end
		button.MouseButton1Up:Connect(release)
		button.MouseLeave:Connect(release)
		button.MouseButton1Click:Connect(function()
			task.spawn(function() pcall(opts.Callback) end)
		end)
	end

	function tab:Toggle(opts)
		local value = opts.Default or false
		local frame = row(36)
		textLabel(frame, { Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -64, 1, 0), Font = Enum.Font.GothamBold, TextSize = 13, Text = opts.Name })
		local switch = new("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0), Size = UDim2.fromOffset(38, 20), BackgroundColor3 = THEME.Off, BorderSizePixel = 0 }, frame)
		corner(switch, 10)
		local knob = new("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 2, 0.5, 0), Size = UDim2.fromOffset(16, 16), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0 }, switch)
		corner(knob, 8)
		local click = new("TextButton", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", ZIndex = 2 }, frame)

		local function render()
			TweenService:Create(knob, TweenInfo.new(0.15), { Position = value and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0) }):Play()
			TweenService:Create(switch, TweenInfo.new(0.15), { BackgroundColor3 = value and THEME.Accent or THEME.Off }):Play()
		end
		render()

		local function set(newValue)
			value = newValue and true or false
			render()
			pcall(opts.Callback, value)
			queueSave()
		end

		click.MouseButton1Click:Connect(function() set(not value) end)
		if opts.Flag then flags[opts.Flag] = { get = function() return value end, set = set } end

		local object = {}
		function object:Set(newValue) set(newValue) end
		return object
	end

	function tab:Slider(opts)
		local min, max, increment = opts.Min, opts.Max, opts.Increment or 1
		local value = opts.Default or min
		local frame = row(50)
		textLabel(frame, { Position = UDim2.fromOffset(10, 5), Size = UDim2.new(0.6, 0, 0, 18), Font = Enum.Font.GothamBold, Text = opts.Name })
		local valueLabel = textLabel(frame, { AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 5), Size = UDim2.new(0.4, 0, 0, 18), TextXAlignment = Enum.TextXAlignment.Right, TextColor3 = THEME.Accent, Font = Enum.Font.GothamBold })
		local hit = new("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 10, 1, -3), Size = UDim2.new(1, -20, 0, 24), BackgroundTransparency = 1, Active = true }, frame)
		local bar = new("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.new(1, 0, 0, 8), BackgroundColor3 = THEME.Off, BorderSizePixel = 0 }, hit)
		corner(bar, 4)
		local fill = new("Frame", { Size = UDim2.fromScale(0, 1), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0 }, bar)
		corner(fill, 4)
		gradient(fill, THEME.Accent, THEME.AccentEnd, 0)
		local knob = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0, 0.5), Size = UDim2.fromOffset(16, 16), BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0 }, bar)
		corner(knob, 8)

		local function render()
			local alpha = (max > min) and (value - min) / (max - min) or 0
			fill.Size = UDim2.fromScale(alpha, 1)
			knob.Position = UDim2.new(alpha, 0, 0.5, 0)
			valueLabel.Text = tostring(value) .. (opts.Suffix and (" " .. opts.Suffix) or "")
		end

		local function set(newValue)
			newValue = tonumber(newValue)
			if not newValue then return end
			newValue = min + math.floor((newValue - min) / increment + 0.5) * increment
			newValue = math.clamp(math.floor(newValue * 1000 + 0.5) / 1000, min, max)
			if newValue == value then return end
			value = newValue
			render()
			pcall(opts.Callback, value)
			queueSave()
		end

		local dragging = false
		local function fromX(x)
			local alpha = math.clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
			set(min + alpha * (max - min))
		end

		track(hit.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				page.ScrollingEnabled = false
				fromX(input.Position.X)
			end
		end))
		track(UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				fromX(input.Position.X)
			end
		end))
		track(UserInputService.InputEnded:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
				dragging = false
				page.ScrollingEnabled = true
			end
		end))

		render()
		if opts.Flag then flags[opts.Flag] = { get = function() return value end, set = set } end
	end

	function tab:Stepper(opts)
		local options = opts.Options
		local index = table.find(options, opts.Default) or 1
		local frame = row(36)
		textLabel(frame, { Position = UDim2.fromOffset(10, 0), Size = UDim2.new(1, -130, 1, 0), Font = Enum.Font.GothamBold, Text = opts.Name })
		local function arrow(text, xOffset)
			local button = new("TextButton", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, xOffset, 0.5, 0), Size = UDim2.fromOffset(28, 24), BackgroundColor3 = THEME.ElementHover, AutoButtonColor = false, Font = Enum.Font.GothamBold, TextSize = 16, TextColor3 = THEME.Text, Text = text }, frame)
			corner(button, 6)
			return button
		end
		local right = arrow(">", -8)
		local left = arrow("<", -80)
		local valueLabel = textLabel(frame, { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -40, 0.5, 0), Size = UDim2.fromOffset(36, 24), TextXAlignment = Enum.TextXAlignment.Center, TextColor3 = THEME.Accent, Font = Enum.Font.GothamBold, TextSize = 14 })

		local function set(option)
			local found = table.find(options, option)
			if not found then return end
			index = found
			valueLabel.Text = tostring(options[index])
			pcall(opts.Callback, options[index])
			queueSave()
		end

		valueLabel.Text = tostring(options[index])
		left.MouseButton1Click:Connect(function() set(options[(index - 2) % #options + 1]) end)
		right.MouseButton1Click:Connect(function() set(options[index % #options + 1]) end)
		if opts.Flag then flags[opts.Flag] = { get = function() return options[index] end, set = set } end
	end

	table.insert(tabs, tab)
	if #tabs == 1 then selectTab(tab) end
	return tab
end

---------------------------------------------------------------------
-- Game Mechanics & Remotes
---------------------------------------------------------------------
local ZAP
pcall(function()
	local client = ReplicatedStorage:WaitForChild("Client", 10)
	ZAP = require(client:WaitForChild("ClientRemotes", 10))
end)

local function getCharacter()
	local char = LocalPlayer.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChildOfClass("Humanoid")
	return char, root, hum
end

local function getFolder(name) return workspace:FindFirstChild(name) end

local function isLiveMonster(monster)
	if not monster:IsA("Model") or not monster:FindFirstChild("HumanoidRootPart") then return false end
	local hum = monster:FindFirstChildOfClass("Humanoid")
	return not hum or hum.Health > 0
end

local function fireAttack(monster)
	if not (ZAP and ZAP.meleeAttack) then return false end
	return pcall(function()
		ZAP.meleeAttack.fire({ monsters = { monster }, civilians = {}, activeSlot = state.weaponSlot })
	end)
end

local function nameMatches(name, keywords)
	name = string.lower(name)
	for _, keyword in ipairs(keywords) do
		if string.find(name, keyword, 1, true) then return true end
	end
	return false
end

local function isMedicine(obj) return nameMatches(obj.Name, MEDICINE_KEYWORDS) end
local function hasTag(obj, tag) return CollectionService:HasTag(obj, tag) end

local function classify(obj)
	if obj:FindFirstChild("ProductPriceTag") then return isMedicine(obj) and "Medicine" or "Shop" end
	if hasTag(obj, "Corpse") or obj:FindFirstChild("HumanoidRootPart") then return "Body" end
	if isMedicine(obj) then return "Medicine" end
	if hasTag(obj, "CraftingPart") or hasTag(obj, "Blueprint") or nameMatches(obj.Name, MATERIAL_KEYWORDS) then return "Material" end
	return "Item"
end

local function listInteractables()
	local list = {}
	local function walk(parent)
		for _, obj in ipairs(parent:GetChildren()) do
			if obj:IsA("Folder") then walk(obj)
			elseif obj:IsA("PVInstance") then table.insert(list, { obj = obj, kind = classify(obj) }) end
		end
	end
	local folder = getFolder("Interactables")
	if folder then walk(folder) end
	return list
end

local function targetPart(obj, kind)
	if kind == "Body" then
		local root = obj:FindFirstChild("HumanoidRootPart")
		if root then return root end
	end
	if obj:IsA("BasePart") then return obj end
	return obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
end

local VirtualInputManager
pcall(function() VirtualInputManager = game:GetService("VirtualInputManager") end)

local jobs

local function gone(obj) return obj.Parent == nil or not obj:IsDescendantOf(workspace) end

local function hotbarFull()
	local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	local progress = playerGui and playerGui:FindFirstChild("WrenchPickupProgress")
	if not progress then return false end
	for _, label in ipairs(progress:GetDescendants()) do
		if label:IsA("TextLabel") and label.Text == "Hotbar Full" then return true end
	end
	return false
end

local function pressKey(keyCode)
	if not VirtualInputManager then return false end
	return pcall(function()
		VirtualInputManager:SendKeyEvent(true, keyCode, false, game)
		task.wait(0.05)
		VirtualInputManager:SendKeyEvent(false, keyCode, false, game)
	end)
end

local function findByPath(path)
	local node = workspace
	for _, name in ipairs(path) do node = node and node:FindFirstChild(name) end
	return node
end

local function cframeOf(inst)
	if inst:IsA("BasePart") then return inst.CFrame end
	if inst:IsA("Attachment") then return inst.WorldCFrame end
	if inst:IsA("PVInstance") then return inst:GetPivot() end
	return nil
end

local function depositCFrame(station)
	local deposit = station:FindFirstChild("ObjectDeposit", true)
	local cf = deposit and cframeOf(deposit)
	if cf then return cf end
	local mesh = station:FindFirstChild("Meshes/Grinder_Shredder1", true)
	cf = mesh and cframeOf(mesh)
	return cf or cframeOf(station)
end

local function frontOfCamera()
	local camera = workspace.CurrentCamera
	if camera then return CFrame.new(camera.CFrame.Position + camera.CFrame.LookVector * 5) end
	local _, root = getCharacter()
	if root then return CFrame.new(root.Position + root.CFrame.LookVector * 5) end
end

-- Hotbar Handling
local HOTBAR_CATEGORIES = { ["melee"] = true, ["healing"] = true, ["corpse"] = true, ["ingredient"] = true, ["crafting part"] = true, ["blueprint"] = true }
local SLOT_KEYS = { Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four, Enum.KeyCode.Five, Enum.KeyCode.Six, Enum.KeyCode.Seven, Enum.KeyCode.Eight, Enum.KeyCode.Nine, Enum.KeyCode.Zero }

local function looksSelected(frame)
	local function yellow(stroke)
		local c = stroke.Color
		return stroke.Enabled and c.R > 0.85 and c.G > 0.65 and c.B < 0.45
	end
	for _, inst in ipairs(frame:GetDescendants()) do if inst:IsA("UIStroke") and yellow(inst) then return true end end
	for _, child in ipairs(frame:GetChildren()) do if child:IsA("UIStroke") and yellow(child) then return true end end
	return false
end

local function readHotbar()
	local slots, seen = {}, {}
	local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	if not playerGui then return slots end

	for _, label in ipairs(playerGui:GetDescendants()) do
		if label:IsA("TextLabel") and HOTBAR_CATEGORIES[string.lower(label.Text)] and not label:IsDescendantOf(Gui) then
			local frame = label.Parent
			local info = { category = label.Text, frame = frame }
			for _, other in ipairs(frame:GetDescendants()) do
				if other:IsA("TextLabel") and other ~= label then
					local text = other.Text
					local number = string.match(text, "^%s*(%d+)%s*$")
					local count = string.match(text, "^%s*x(%d+)%s*$")
					if number and not info.slot and tonumber(number) <= 10 then info.slot = tonumber(number)
					elseif count then info.count = tonumber(count)
					elseif text ~= "" and not number and not HOTBAR_CATEGORIES[string.lower(text)] and not info.name then info.name = text end
				end
			end
			if info.slot and not seen[info.slot] then
				seen[info.slot] = true
				info.count = info.count or 1
				info.name = info.name or ""
				info.selected = looksSelected(frame)
				table.insert(slots, info)
			end
		end
	end
	table.sort(slots, function(a, b) return a.slot < b.slot end)
	return slots
end

local function selectSlot(slot)
	if slot.selected then return true end
	local key = SLOT_KEYS[slot.slot]
	if key and pressKey(key) then return true end
	local button = slot.frame:IsA("GuiButton") and slot.frame or slot.frame:FindFirstChildWhichIsA("GuiButton", true)
	if button and firesignal then
		pcall(firesignal, button.MouseButton1Click)
		return true
	end
	return false
end

local function isZombieSlot(slot) return string.find(string.lower(slot.category), "corpse", 1, true) ~= nil end
local function isCraftingSlot(slot)
	local category = string.lower(slot.category)
	return string.find(category, "crafting", 1, true) ~= nil or string.find(category, "blueprint", 1, true) ~= nil or nameMatches(slot.name, MATERIAL_KEYWORDS)
end

-- Full Remote Recorder & Replay
local recipes = { pickup = nil, deposit = {} }
local rejected = {}
local recorder = { hooked = false, replaying = false, originals = {}, lastLogged = {} }
local recentCalls = {}
local SKIP_REMOTES = { meleeAttack = true }

local function describe(value, depth)
	depth = depth or 0
	local kind = typeof(value)
	if kind == "Instance" then return "<" .. value.ClassName .. " " .. value.Name .. ">"
	elseif kind == "table" then
		if depth >= 2 then return "{...}" end
		local parts, count = {}, 0
		for key, child in pairs(value) do
			count += 1
			if count > 6 then table.insert(parts, "...") break end
			table.insert(parts, tostring(key) .. "=" .. describe(child, depth + 1))
		end
		return "{" .. table.concat(parts, ", ") .. "}"
	elseif kind == "string" then return '"' .. string.sub(value, 1, 24) .. '"' end
	return tostring(value)
end

local function deepCopy(value, depth)
	depth = depth or 0
	if type(value) ~= "table" or depth > 4 then return value end
	local copy = {}
	for key, child in pairs(value) do copy[key] = deepCopy(child, depth + 1) end
	return copy
end

local function findInstanceUnder(value, folder, depth)
	depth = depth or 0
	if not folder then return nil end
	if typeof(value) == "Instance" and value:IsDescendantOf(folder) then return value
	elseif type(value) == "table" and depth < 4 then
		for _, child in pairs(value) do
			local found = findInstanceUnder(child, folder, depth + 1)
			if found then return found end
		end
	end
end

local function itemPath(inst)
	local folder = workspace:FindFirstChild("Interactables")
	local node, path = inst, {}
	while node.Parent and node.Parent ~= folder and not node.Parent:IsA("Folder") do
		table.insert(path, 1, node.Name)
		node = node.Parent
	end
	return path
end

local function onCall(name, method, ...)
	if not alive or recorder.replaying or SKIP_REMOTES[name] then return end
	local args = table.pack(...)
	
	local now = os.clock()
	if now - (recorder.lastLogged[name] or 0) > 1 then
		recorder.lastLogged[name] = now
		local parts = {}
		for index = 1, args.n do parts[index] = describe(args[index]) end
		table.insert(recentCalls, name .. "." .. method .. "(" .. table.concat(parts, ", ") .. ")")
		if #recentCalls > 25 then table.remove(recentCalls, 1) end
	end

	if not recipes.pickup and not rejected["pickup:" .. name] then
		local interactables = workspace:FindFirstChild("Interactables")
		for index = 1, args.n do
			local found = findInstanceUnder(args[index], interactables)
			if found then
				recipes.pickup = { name = name, method = method, args = deepCopy(args), item = found, path = itemPath(found) }
				break
			end
		end
	end

	if jobs then
		for key, job in pairs(jobs) do
			if not recipes.deposit[key] and not rejected[key .. ":" .. name] then
				local station = findByPath(job.stationPath)
				if station then
					for index = 1, args.n do
						local found = findInstanceUnder(args[index], station)
						if found then
							recipes.deposit[key] = { name = name, method = method, args = deepCopy(args) }
							break
						end
					end
				end
			end
		end
	end
end

local function hookRemotes()
	if recorder.hooked or not ZAP then return end
	for name, remote in pairs(ZAP) do
		if type(remote) == "table" then
			for _, method in ipairs({ "fire", "call" }) do
				local original = remote[method]
				if type(original) == "function" then
					local ok = pcall(function()
						remote[method] = function(...)
							pcall(onCall, name, method, ...)
							return original(...)
						end
					end)
					if ok then
						table.insert(recorder.originals, { remote = remote, method = method, original = original })
					end
				end
			end
		end
	end
	recorder.hooked = true
end

local function unhookRemotes()
	for _, entry in ipairs(recorder.originals) do
		pcall(function() entry.remote[entry.method] = entry.original end)
	end
	table.clear(recorder.originals)
	recorder.hooked = false
end

local function rebuild(value, recipe, target, slot, depth)
	depth = depth or 0
	if typeof(value) == "Instance" then
		if recipe.item and target and value == recipe.item then
			local node = target
			for _, name in ipairs(recipe.path or {}) do node = node and node:FindFirstChild(name) end
			return node or target
		end
		return value
	elseif type(value) == "table" and depth < 4 then
		local copy = {}
		for key, child in pairs(value) do
			if slot and type(key) == "string" and type(child) == "number" and string.find(string.lower(key), "slot", 1, true) then copy[key] = slot
			else copy[key] = rebuild(child, recipe, target, slot, depth + 1) end
		end
		return copy
	end
	return value
end

local function replay(recipe, target, slot)
	local remote = ZAP and ZAP[recipe.name]
	local fn = remote and remote[recipe.method]
	if type(fn) ~= "function" then return false end
	local args = {}
	for index = 1, recipe.args.n do args[index] = rebuild(recipe.args[index], recipe, target, slot) end
	recorder.replaying = true
	local ok = pcall(fn, table.unpack(args, 1, recipe.args.n))
	recorder.replaying = false
	return ok
end

local function findPrompt(inst, patterns)
	local fallback
	for _, descendant in ipairs(inst:GetDescendants()) do
		if descendant:IsA("ProximityPrompt") then
			local text = string.lower(descendant.ActionText .. " " .. descendant.ObjectText)
			for _, pattern in ipairs(patterns) do if string.find(text, pattern, 1, true) then return descendant end end
			fallback = fallback or descendant
		end
	end
	return fallback
end

local function firePrompt(prompt)
	if not (prompt and fireproximityprompt) then return false end
	pcall(function() prompt.Enabled = true prompt.HoldDuration = 0 end)
	return pcall(fireproximityprompt, prompt)
end

local pickupMethods = {
	recipe = function(obj) return recipes.pickup ~= nil and replay(recipes.pickup, obj) end,
	prompt = function(obj)
		if firePrompt(findPrompt(obj, PICKUP_PATTERNS)) then return true end
		local detector = obj:FindFirstChildWhichIsA("ClickDetector", true)
		return detector ~= nil and fireclickdetector ~= nil and pcall(fireclickdetector, detector)
	end,
	key = function(obj)
		if not VirtualInputManager then return false end
		local target = frontOfCamera()
		if target then pcall(function() obj:PivotTo(target) end) end
		task.wait(0.04)
		pcall(function()
			VirtualInputManager:SendKeyEvent(true, PICKUP_KEY, false, game)
			task.wait(0.05)
			VirtualInputManager:SendKeyEvent(false, PICKUP_KEY, false, game)
		end)
		return gone(obj)
	end,
}
local METHOD_ORDER = { "recipe", "prompt", "key" }

local function pickUp(obj)
	for _, name in ipairs(METHOD_ORDER) do
		if gone(obj) then return true end
		if pickupMethods[name](obj) then
			local deadline = os.clock() + 0.5
			while os.clock() < deadline do
				if gone(obj) then workingMethod = name return true end
				task.wait(0.04)
			end
		end
		if gone(obj) then workingMethod = name return true end
	end
	return false
end

local function bringKinds(kinds, niceName)
	local _, root = getCharacter()
	if not root then notify("Brineland", "Character not found.") return end
	task.spawn(function()
		local list = {}
		for _, entry in ipairs(listInteractables()) do if kinds[entry.kind] then table.insert(list, entry.obj) end end
		local brought, picked = 0, 0
		for _, obj in ipairs(list) do
			if not alive then return end
			local _, currentRoot = getCharacter()
			if not currentRoot or hotbarFull() then break end
			if pcall(function() obj:PivotTo(currentRoot.CFrame + Vector3.new(0, 2, 0)) end) then
				brought += 1
				if pickUp(obj) then picked += 1 end
			end
			task.wait(PICKUP_DELAY)
		end
		notify("Brineland", "Brought " .. brought .. " " .. niceName .. ", picked up " .. picked .. ".", 5)
	end)
end

-- Auto Grinder Job System Implementation
local function moveNear(root, position)
	local flat = Vector3.new(root.Position.X - position.X, 0, root.Position.Z - position.Z)
	local direction = flat.Magnitude > 0.1 and flat.Unit or Vector3.new(0, 0, 1)
	local standAt = position + direction * 5 + Vector3.new(0, 3, 0)
	root.CFrame = CFrame.lookAt(standAt, Vector3.new(position.X, standAt.Y, position.Z))
end

local function nextTarget(kinds, failed, position)
	local best, bestDistance
	for _, entry in ipairs(listInteractables()) do
		if kinds[entry.kind] and not failed[entry.obj] then
			local cf = cframeOf(entry.obj)
			local distance = cf and (cf.Position - position).Magnitude
			if distance and (not bestDistance or distance < bestDistance) then
				best, bestDistance = entry.obj, distance
			end
		end
	end
	return best
end

jobs = {
	zombies = {
		key = "zombies", title = "Auto Zombie Grinder", machineName = "Zombie Grinder",
		stationPath = { "Stations", "Grinder" },
		fetchKinds = { Body = true }, matches = isZombieSlot,
	},
	crafting = {
		key = "crafting", title = "Auto Crafting Grinder", machineName = "Crafting Grinder",
		stationPath = { "Stations", "BlueprintsTable", "Grinder" },
		fetchKinds = { Material = true }, matches = isCraftingSlot,
	},
}

local function matchingSlots(job)
	local result = {}
	for _, slot in ipairs(readHotbar()) do
		if job.matches(slot) then table.insert(result, slot) end
	end
	return result
end

local function totalCount(job)
	local total = 0
	for _, slot in ipairs(matchingSlots(job)) do total += slot.count end
	return total
end

local function depositItem(job, station, slotNumber)
	local recipe = recipes.deposit[job.key]
	if recipe then return replay(recipe, nil, slotNumber) end
	if station and firePrompt(findPrompt(station, DEPOSIT_PATTERNS)) then return true end
	return pressKey(DEPOSIT_KEY)
end

local function runGrinder(job)
	local token = {}
	job.token = token
	task.spawn(function()
		local origin
		pcall(function()
			local function stillOn() return alive and job.token == token end
			local station = findByPath(job.stationPath)
			local manual = GRINDER_COORDS[job.key]

			local function depositPosition()
				if manual then return manual end
				local cf = station and depositCFrame(station)
				return cf and cf.Position
			end

			local interval = 1 / GRIND_PER_SECOND
			local done, stagnant = 0, 0
			local failedTargets = {}
			local lastTotal = totalCount(job)

			local function goNear()
				local _, root = getCharacter()
				local position = depositPosition()
				if not (root and position) then return end
				origin = origin or root.CFrame
				moveNear(root, position)
			end

			if not recipes.deposit[job.key] then goNear() end

			while stillOn() do
				local tickStart = os.clock()
				local _, currentRoot = getCharacter()
				local stationPosition = depositPosition()
				if not stationPosition then break end

				if not currentRoot then
					task.wait(1)
				else
					local remote = recipes.deposit[job.key] ~= nil
					if not remote and (currentRoot.Position - stationPosition).Magnitude > 15 then
						goNear()
						task.wait(0.3)
					end

					local slots = matchingSlots(job)
					if #slots > 0 then
						local slot = slots[1]
						selectSlot(slot)
						task.wait(0.05)
						depositItem(job, station, slot.slot)
						task.wait(math.max(interval - (os.clock() - tickStart), 0.03))

						local total = totalCount(job)
						if total < lastTotal then
							done += lastTotal - total
							stagnant = 0
						else
							stagnant += 1
						end
						lastTotal = total

						if stagnant >= 5 then
							if remote then
								rejected[job.key .. ":" .. recipes.deposit[job.key].name] = true
								recipes.deposit[job.key] = nil
								stagnant = 0
								goNear()
							else
								break
							end
						end
					else
						local target = nextTarget(job.fetchKinds, failedTargets, stationPosition)
						if not target then
							task.wait(0.6)
						else
							local spot = currentRoot.CFrame
							pcall(function() target:PivotTo(spot) end)
							if not pickUp(target) then failedTargets[target] = true end
							lastTotal = totalCount(job)
						end
					end
				end
			end
			notify("Brineland", job.title .. ": " .. done .. " deposited.", 4)
		end)
		if origin then
			local _, finalRoot = getCharacter()
			if finalRoot then finalRoot.CFrame = origin end
		end
		if job.token == token then
			job.token = nil
			if job.toggle then job.toggle:Set(false) end
		end
	end)
end

hookRemotes()

-- Character Stats & Noclip
local originalStats = setmetatable({}, { __mode = "k" })

local function applyStats()
	local _, _, hum = getCharacter()
	if not hum then return end
	if not originalStats[hum] then originalStats[hum] = { walkSpeed = hum.WalkSpeed, jumpPower = hum.JumpPower, jumpHeight = hum.JumpHeight } end
	if state.walkSpeed and hum.WalkSpeed ~= state.walkSpeed then hum.WalkSpeed = state.walkSpeed end
	if state.jumpPower then
		if hum.UseJumpPower then
			if hum.JumpPower ~= state.jumpPower then hum.JumpPower = state.jumpPower end
		else
			local height = (state.jumpPower ^ 2) / (2 * workspace.Gravity)
			if math.abs(hum.JumpHeight - height) > 0.01 then hum.JumpHeight = height end
		end
	end
end

local function restoreStats()
	local _, _, hum = getCharacter()
	local original = hum and originalStats[hum]
	if not original then return end
	hum.WalkSpeed = original.walkSpeed
	hum.JumpPower = original.jumpPower
	hum.JumpHeight = original.jumpHeight
end

track(LocalPlayer.CharacterAdded:Connect(function(char)
	task.spawn(function()
		local hum = char:WaitForChild("Humanoid", 10)
		if hum and alive then task.wait(0.2) applyStats() end
	end)
end))

track(game:GetService("RunService").Stepped:Connect(function()
	if state.noclip then
		local char = LocalPlayer.Character
		if char then
			for _, part in ipairs(char:GetDescendants()) do if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end end
		end
	end
end))

-- ESP System
local ESPFolder = new("Folder", { Name = "BrinelandESP" })
protectedParent(ESPFolder)
local tracked = {}

local function removeEntry(model)
	local entry = tracked[model]
	if not entry then return end
	if entry.billboard then entry.billboard:Destroy() end
	if entry.highlight then entry.highlight:Destroy() end
	tracked[model] = nil
end

local function clearESP() for model in pairs(tracked) do removeEntry(model) end end

local function refreshESP()
	local _, root = getCharacter()
	local seen = {}
	if root then
		local targets = {}
		
		if state.esp.monsters then
			local folder = getFolder("Monsters")
			if folder then
				for _, monster in ipairs(folder:GetChildren()) do
					if monster:IsA("Model") then
						local hrp = monster:FindFirstChild("HumanoidRootPart") or monster:FindFirstChild("Head") or monster.PrimaryPart
						if hrp then table.insert(targets, { model = monster, part = hrp, label = "Monster: " .. monster.Name, color = Color3.fromRGB(255, 50, 50) }) end
					end
				end
			end
		end

		if state.esp.items or state.esp.medicine or state.esp.bodies then
			for _, entry in ipairs(listInteractables()) do
				local kind = entry.kind
				local wanted = ((kind == "Item" or kind == "Material") and state.esp.items)
					or (kind == "Medicine" and state.esp.medicine)
					or (kind == "Body" and state.esp.bodies)
				if wanted then
					local part = targetPart(entry.obj, kind)
					if part then
						table.insert(targets, { model = entry.obj, part = part, label = kind .. ": " .. entry.obj.Name, color = kind == "Medicine" and Color3.fromRGB(255, 90, 220) or Color3.fromRGB(50, 255, 50) })
					end
				end
			end
		end

		for _, target in ipairs(targets) do target.distance = (root.Position - target.part.Position).Magnitude end
		table.sort(targets, function(a, b) return a.distance < b.distance end)

		for rank, target in ipairs(targets) do
			local model = target.model
			local entry = tracked[model]
			if not entry then
				entry = { part = target.part, label = target.label, color = target.color }
				local bb = new("BillboardGui", { Adornee = entry.part, Size = UDim2.new(0, 200, 0, 50), StudsOffset = Vector3.new(0, 3, 0), AlwaysOnTop = true }, ESPFolder)
				entry.text = new("TextLabel", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, TextColor3 = entry.color, TextSize = 13, Font = Enum.Font.GothamBold, TextStrokeTransparency = 0 }, bb)
				entry.billboard = bb
				tracked[model] = entry
			end
			seen[model] = true

			local lines = {}
			if state.esp.showNames then table.insert(lines, entry.label) end
			if state.esp.showDistance then table.insert(lines, math.floor(target.distance) .. " studs") end
			entry.billboard.Enabled = #lines > 0
			entry.text.Text = table.concat(lines, "\n")

			local wantHighlight = state.esp.showHighlight and rank <= MAX_HIGHLIGHTS
			if wantHighlight and not entry.highlight then
				entry.highlight = new("Highlight", { Adornee = model, FillColor = entry.color, OutlineColor = Color3.new(1, 1, 1), FillTransparency = 0.4, DepthMode = Enum.HighlightDepthMode.AlwaysOnTop }, ESPFolder)
			elseif not wantHighlight and entry.highlight then
				entry.highlight:Destroy()
				entry.highlight = nil
			end
		end
	end
	for model in pairs(tracked) do if not seen[model] or not model.Parent then removeEntry(model) end end
end

local function espEnabled()
	local esp = state.esp
	return esp.monsters or esp.items or esp.medicine or esp.bodies
end

task.spawn(function()
	while alive do
		task.wait(ESP_INTERVAL)
		if espEnabled() then pcall(refreshESP) end
	end
end)

---------------------------------------------------------------------
-- UI Tabs Construction
---------------------------------------------------------------------
local CombatTab = createTab("Combat")
CombatTab:Section("Kill Aura")
CombatTab:Toggle({ Name = "Kill Aura", Flag = "KillAura", Callback = function(v) state.killAura = v end })
CombatTab:Slider({ Name = "Kill Aura Distance", Min = 10, Max = 50, Increment = 5, Default = 25, Suffix = "studs", Flag = "AuraDistance", Callback = function(v) state.auraDistance = v end })
CombatTab:Button({ Name = "Kill All Zombies", Callback = function()
	local folder = getFolder("Monsters")
	if not folder then notify("Brineland", "Monsters folder not found.") return end
	for _, monster in ipairs(folder:GetChildren()) do
		if not alive then break end
		if isLiveMonster(monster) then fireAttack(monster) task.wait(ATTACK_INTERVAL) end
	end
end })

local ItemsTab = createTab("Items")
ItemsTab:Section("Bring & Pick Up")
ItemsTab:Button({ Name = "Bring Items (wood, scrap...)", Callback = function() bringKinds({ Item = true, Material = true }, "items") end })
ItemsTab:Button({ Name = "Bring Medicine", Callback = function() bringKinds({ Medicine = true }, "medicine items") end })
ItemsTab:Button({ Name = "Bring Zombies", Callback = function() bringKinds({ Body = true }, "zombies") end })

local GrinderTab = createTab("Grinder")
GrinderTab:Section("Auto Grinders")
jobs.zombies.toggle = GrinderTab:Toggle({
	Name = "Auto Zombie Grinder",
	Callback = function(value)
		if value then runGrinder(jobs.zombies) else jobs.zombies.token = nil end
	end,
})
jobs.crafting.toggle = GrinderTab:Toggle({
	Name = "Auto Crafting Grinder",
	Callback = function(value)
		if value then runGrinder(jobs.crafting) else jobs.crafting.token = nil end
	end,
})

local TeleportTab = createTab("Teleport")
TeleportTab:Section("Locations")
for _, place in ipairs(TELEPORTS) do
	local placeName, position = place[1], place[2]
	TeleportTab:Button({ Name = placeName, Callback = function()
		local _, root = getCharacter()
		if not root then notify("Brineland", "Character not found.") return end
		root.CFrame = CFrame.new(position + Vector3.new(0, 3, 0))
		notify("Brineland", "Teleported to " .. placeName .. ".", 2)
	end })
end

local PlayerTab = createTab("Player")
PlayerTab:Section("Movement & Stats")
PlayerTab:Slider({ Name = "WalkSpeed", Min = 16, Max = 200, Increment = 5, Default = 16, Flag = "WalkSpeed", Callback = function(v) state.walkSpeed = v applyStats() end })
PlayerTab:Slider({ Name = "JumpPower", Min = 50, Max = 200, Increment = 10, Default = 50, Flag = "JumpPower", Callback = function(v) state.jumpPower = v applyStats() end })
PlayerTab:Stepper({ Name = "Weapon Slot", Options = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, Default = 2, Flag = "WeaponSlot", Callback = function(opt) state.weaponSlot = tonumber(opt) or 2 end })
PlayerTab:Toggle({ Name = "Noclip", Flag = "Noclip", Callback = function(v) state.noclip = v end })

local ESPTab = createTab("ESP")
ESPTab:Section("ESP Categories")
ESPTab:Toggle({ Name = "Monster ESP", Flag = "MonsterESP", Callback = function(v) state.esp.monsters = v end })
ESPTab:Toggle({ Name = "Item ESP", Flag = "ItemESP", Callback = function(v) state.esp.items = v end })
ESPTab:Toggle({ Name = "Medicine ESP", Flag = "MedicineESP", Callback = function(v) state.esp.medicine = v end })
ESPTab:Toggle({ Name = "Zombie / Body ESP", Flag = "BodyESP", Callback = function(v) state.esp.bodies = v end })
ESPTab:Section("ESP Options")
ESPTab:Toggle({ Name = "Show Names", Default = true, Flag = "ShowNames", Callback = function(v) state.esp.showNames = v end })
ESPTab:Toggle({ Name = "Show Distance", Default = true, Flag = "ShowDistance", Callback = function(v) state.esp.showDistance = v end })
ESPTab:Toggle({ Name = "Show Highlight", Default = true, Flag = "ShowHighlight", Callback = function(v) state.esp.showHighlight = v end })

---------------------------------------------------------------------
-- Kill Aura Loop
---------------------------------------------------------------------
task.spawn(function()
	while alive do
		task.wait(ATTACK_INTERVAL)
		if state.killAura and ZAP then
			pcall(function()
				local _, root = getCharacter()
				local folder = getFolder("Monsters")
				if not (root and folder) then return end
				local nearest, nearestDistance = nil, state.auraDistance
				for _, monster in ipairs(folder:GetChildren()) do
					if isLiveMonster(monster) then
						local distance = (root.Position - monster.HumanoidRootPart.Position).Magnitude
						if distance < nearestDistance then nearest, nearestDistance = monster, distance end
					end
				end
				if nearest then fireAttack(nearest) end
			end)
		end
	end
end)

---------------------------------------------------------------------
-- Cleanup & Initialization
---------------------------------------------------------------------
task.spawn(function()
	while alive do
		task.wait(0.5)
		pcall(applyStats)
	end
end)

cleanup = function()
	if not alive then return end
	saveConfig()
	alive = false
	for _, conn in ipairs(connections) do pcall(function() conn:Disconnect() end) end
	table.clear(connections)
	pcall(unhookRemotes)
	clearESP()
	pcall(function() ESPFolder:Destroy() end)
	pcall(restoreStats)
	pcall(function() Gui:Destroy() end)
	if env.BrinelandHubUnload == cleanup then env.BrinelandHubUnload = nil end
end
env.BrinelandHubUnload = cleanup

loadConfig()
notify("Brineland Hub", "Bake or Die Full Hub Loaded Successfully!", 4)
