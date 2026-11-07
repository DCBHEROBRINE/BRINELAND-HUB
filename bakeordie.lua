--[[
	Brineland Hub - Bake or Die (Fully Fixed & Optimized)
	- Blue/purple mobile GUI: drag the title bar, "-" minimises, "X" closes
	- Auto Bake, Auto Collect Cash/Bread, Auto Upgrade
	- Teleport tab, ESP, WalkSpeed / JumpPower / Noclip
]]

local function brinelandFatal(err)
	err = tostring(err)
	warn("Brineland failed to start:\n" .. err)
	pcall(function() if setclipboard then setclipboard("Brineland failed to start:\n" .. err) end end)
	pcall(function()
		local gui = Instance.new("ScreenGui")
		gui.Name = "BrinelandError"
		gui.ResetOnSpawn = false
		gui.IgnoreGuiInset = true
		gui.DisplayOrder = 1000
		local parented = pcall(function() gui.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
		if not parented or not gui.Parent then
			gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
		end
		local frame = Instance.new("Frame")
		frame.AnchorPoint = Vector2.new(0.5, 0.5)
		frame.Position = UDim2.fromScale(0.5, 0.5)
		frame.Size = UDim2.new(0.8, 0, 0, 220)
		frame.BackgroundColor3 = Color3.fromRGB(30, 14, 28)
		frame.BorderSizePixel = 0
		frame.Parent = gui
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -16, 1, -48)
		label.Position = UDim2.fromOffset(8, 8)
		label.BackgroundTransparency = 1
		label.TextWrapped = true
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextYAlignment = Enum.TextYAlignment.Top
		label.Font = Enum.Font.Code
		label.TextSize = 13
		label.TextColor3 = Color3.fromRGB(255, 200, 200)
		label.Text = "Brineland failed to start:\n\n" .. string.sub(err, 1, 900)
		label.Parent = frame
		local close = Instance.new("TextButton")
		close.AnchorPoint = Vector2.new(1, 1)
		close.Position = UDim2.new(1, -8, 1, -8)
		close.Size = UDim2.fromOffset(80, 28)
		close.Text = "Close"
		close.Font = Enum.Font.GothamBold
		close.TextSize = 14
		close.TextColor3 = Color3.new(1, 1, 1)
		close.BackgroundColor3 = Color3.fromRGB(225, 35, 65)
		close.Parent = frame
		close.MouseButton1Click:Connect(function() gui:Destroy() end)
	end)
end

local brinelandOk, brinelandErr = xpcall(function()

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

-- Settings & Config
local ESP_INTERVAL = 0.25
local MAX_HIGHLIGHTS = 30
local CONFIG_FOLDER = "Brineland"
local CONFIG_PATH = CONFIG_FOLDER .. "/BakeOrDie.json"

local TELEPORTS = {
	{ "Spawn / Lobby", Vector3.new(0, 10, 0) },
	{ "Oven Area", Vector3.new(10, 10, 10) },
	{ "Shop / Upgrades", Vector3.new(-15, 10, 15) },
}

local alive = true
local connections = {}
local state = {
	autoBake = false,
	autoCollect = false,
	autoUpgrade = false,
	walkSpeed = nil,
	jumpPower = nil,
	noclip = false,
	esp = {
		ovens = false,
		items = false,
		players = false,
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
	for key, value in pairs(props) do
		inst[key] = value
	end
	if parent then inst.Parent = parent end
	return inst
end

local function corner(inst, radius)
	return new("UICorner", { CornerRadius = UDim.new(0, radius) }, inst)
end

local function stroke(inst, color, transparency)
	return new("UIStroke", {
		Color = color,
		Transparency = transparency,
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, inst)
end

local function gradient(inst, from, to, rotation)
	return new("UIGradient", { Color = ColorSequence.new(from, to), Rotation = rotation or 0 }, inst)
end

local function textLabel(parent, props)
	local base = {
		BackgroundTransparency = 1,
		Font = Enum.Font.GothamMedium,
		TextSize = 13,
		TextColor3 = THEME.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
	}
	for key, value in pairs(props) do
		base[key] = value
	end
	return new("TextLabel", base, parent)
end

local function protectedParent(inst)
	local ok = pcall(function()
		inst.Parent = (gethui and gethui()) or CoreGui
	end)
	if not ok or not inst.Parent then
		inst.Parent = LocalPlayer:WaitForChild("PlayerGui")
	end
end

local Gui = new("ScreenGui", {
	Name = "BrinelandHub",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	DisplayOrder = 999,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
protectedParent(Gui)

local Main = new("Frame", {
	Name = "Main",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromScale(0.5, 0.8),
	BackgroundColor3 = Color3.new(1, 1, 1),
	BorderSizePixel = 0,
	Active = true,
	ClipsDescendants = true,
}, Gui)
new("UISizeConstraint", { MinSize = Vector2.new(330, 220), MaxSize = Vector2.new(520, 360) }, Main)
corner(Main, 12)
stroke(Main, THEME.Accent, 0.55)
gradient(Main, THEME.Background, THEME.BackgroundEnd, 35)

local Topbar = new("Frame", {
	Name = "Topbar",
	Size = UDim2.new(1, 0, 0, 38),
	BackgroundColor3 = THEME.Topbar,
	BackgroundTransparency = 0.15,
	BorderSizePixel = 0,
	Active = true,
}, Main)

textLabel(Topbar, {
	Position = UDim2.fromOffset(12, 0),
	Size = UDim2.new(1, -96, 1, 0),
	Font = Enum.Font.GothamBold,
	TextSize = 15,
	RichText = true,
	TextTruncate = Enum.TextTruncate.AtEnd,
	Text = 'BRINELAND <font color="#18D4FF">BAKE OR DIE</font>',
})

local function topButton(text, color, xOffset)
	local button = new("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, xOffset, 0.5, 0),
		Size = UDim2.fromOffset(32, 26),
		BackgroundColor3 = color,
		AutoButtonColor = false,
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		TextColor3 = Color3.new(1, 1, 1),
		Text = text,
	}, Topbar)
	corner(button, 6)
	return button
end

local MinimiseButton = topButton("-", Color3.fromRGB(40, 38, 100), -46)
local CloseButton = topButton("X", THEME.Danger, -8)

-- Dragging (Mouse & Touch)
do
	local dragging, dragStart, startPosition = false, nil, nil
	Topbar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPosition = Main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	track(UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			local view = Gui.AbsoluteSize
			local x = math.clamp(startPosition.X.Offset + delta.X, -view.X / 2 + 60, view.X / 2 - 60)
			local y = math.clamp(startPosition.Y.Offset + delta.Y, -view.Y / 2 + 30, view.Y / 2 - 30)
			Main.Position = UDim2.new(startPosition.X.Scale, x, startPosition.Y.Scale, y)
		end
	end))
end

local Pill = new("TextButton", {
	Name = "Pill",
	AnchorPoint = Vector2.new(0.5, 0),
	Position = UDim2.new(0.5, 0, 0, 10),
	Size = UDim2.fromOffset(124, 30),
	BackgroundColor3 = Color3.new(1, 1, 1),
	AutoButtonColor = false,
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	TextColor3 = Color3.new(1, 1, 1),
	Text = "BRINELAND",
	Visible = false,
}, Gui)
corner(Pill, 15)
gradient(Pill, THEME.Accent, THEME.AccentEnd, 0)

local function setMinimised(minimised)
	Main.Visible = not minimised
	Pill.Visible = minimised
end

MinimiseButton.MouseButton1Click:Connect(function() setMinimised(true) end)
Pill.MouseButton1Click:Connect(function() setMinimised(false) end)
CloseButton.MouseButton1Click:Connect(function()
	if cleanup then cleanup() end
end)

local TabBar = new("ScrollingFrame", {
	Position = UDim2.fromOffset(8, 44),
	Size = UDim2.new(1, -16, 0, 30),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 0,
	ScrollingDirection = Enum.ScrollingDirection.X,
	CanvasSize = UDim2.new(),
	AutomaticCanvasSize = Enum.AutomaticSize.X,
}, Main)
new("UIListLayout", {
	FillDirection = Enum.FillDirection.Horizontal,
	Padding = UDim.new(0, 6),
	SortOrder = Enum.SortOrder.LayoutOrder,
	VerticalAlignment = Enum.VerticalAlignment.Center,
}, TabBar)

local Content = new("Frame", {
	Position = UDim2.fromOffset(8, 80),
	Size = UDim2.new(1, -16, 1, -88),
	BackgroundTransparency = 1,
}, Main)

local Toast
local function notify(title, message, duration)
	if not alive or not Gui.Parent then return end
	if Toast then Toast:Destroy() end
	local toast = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1, -14),
		Size = UDim2.fromOffset(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = THEME.Topbar,
		BorderSizePixel = 0,
	}, Gui)
	corner(toast, 10)
	stroke(toast, THEME.Accent, 0.4)
	new("UIPadding", {
		PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14),
		PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8),
	}, toast)
	local label = textLabel(toast, {
		Size = UDim2.fromOffset(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		TextWrapped = true,
		RichText = true,
		Text = '<font color="#18D4FF"><b>' .. tostring(title) .. "</b></font>\n" .. tostring(message),
	})
	new("UISizeConstraint", { MaxSize = Vector2.new(320, math.huge) }, label)
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
	for flag, handler in pairs(flags) do
		data[flag] = handler.get()
	end
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
		if isfile(CONFIG_PATH) then
			return HttpService:JSONDecode(readfile(CONFIG_PATH))
		end
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
		TweenService:Create(tab.button, TweenInfo.new(0.15), {
			BackgroundColor3 = on and THEME.Accent or THEME.Element,
			TextColor3 = on and Color3.new(1, 1, 1) or THEME.SubText,
		}):Play()
	end
end

local function createTab(name)
	local tab = {}

	tab.button = new("TextButton", {
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = THEME.Element,
		AutoButtonColor = false,
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		TextColor3 = THEME.SubText,
		Text = name,
		LayoutOrder = #tabs + 1,
	}, TabBar)
	corner(tab.button, 8)
	new("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) }, tab.button)

	local page = new("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = THEME.Accent,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Visible = false,
	}, Content)
	new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, page)
	new("UIPadding", { PaddingRight = UDim.new(0, 8), PaddingBottom = UDim.new(0, 6) }, page)
	tab.page = page

	local order = 0
	local function nextOrder()
		order += 1
		return order
	end

	local function row(height)
		local frame = new("Frame", {
			Size = UDim2.new(1, 0, 0, height),
			BackgroundColor3 = THEME.Element,
			BorderSizePixel = 0,
			LayoutOrder = nextOrder(),
		}, page)
		corner(frame, 8)
		stroke(frame, THEME.Accent, 0.85)
		return frame
	end

	tab.button.MouseButton1Click:Connect(function() selectTab(tab) end)

	function tab:Section(text)
		textLabel(page, {
			Size = UDim2.new(1, 0, 0, 18),
			Font = Enum.Font.GothamBold,
			TextSize = 12,
			TextColor3 = THEME.Accent,
			Text = string.upper(text),
			LayoutOrder = nextOrder(),
		})
	end

	function tab:Button(opts)
		local frame = row(36)
		local button = new("TextButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Font = Enum.Font.GothamBold,
			TextSize = 14,
			TextColor3 = THEME.Text,
			Text = opts.Name,
		}, frame)
		button.MouseButton1Down:Connect(function()
			TweenService:Create(frame, TweenInfo.new(0.1), { BackgroundColor3 = THEME.ElementHover }):Play()
		end)
		local function release()
			TweenService:Create(frame, TweenInfo.new(0.2), { BackgroundColor3 = THEME.Element }):Play()
		end
		button.MouseButton1Up:Connect(release)
		button.MouseLeave:Connect(release)
		button.MouseButton1Click:Connect(function()
			task.spawn(function()
				local ok, err = pcall(opts.Callback)
				if not ok then warn("Brineland | " .. opts.Name .. " error: " .. tostring(err)) end
			end)
		end)
	end

	function tab:Toggle(opts)
		local value = opts.Default or false
		local frame = row(36)
		textLabel(frame, {
			Position = UDim2.fromOffset(10, 0),
			Size = UDim2.new(1, -64, 1, 0),
			Font = Enum.Font.GothamBold,
			TextSize = 13,
			Text = opts.Name,
		})
		local switch = new("Frame", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -10, 0.5, 0),
			Size = UDim2.fromOffset(38, 20),
			BackgroundColor3 = THEME.Off,
			BorderSizePixel = 0,
		}, frame)
		corner(switch, 10)
		local knob = new("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 2, 0.5, 0),
			Size = UDim2.fromOffset(16, 16),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
		}, switch)
		corner(knob, 8)
		local click = new("TextButton", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = "",
			ZIndex = 2,
		}, frame)

		local function render()
			TweenService:Create(knob, TweenInfo.new(0.15), {
				Position = value and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0),
			}):Play()
			TweenService:Create(switch, TweenInfo.new(0.15), {
				BackgroundColor3 = value and THEME.Accent or THEME.Off,
			}):Play()
		end
		render()

		local function set(newValue)
			value = newValue and true or false
			render()
			local ok, err = pcall(opts.Callback, value)
			if not ok then warn("Brineland | " .. opts.Name .. " error: " .. tostring(err)) end
			queueSave()
		end

		click.MouseButton1Click:Connect(function() set(not value) end)
		if opts.Flag then
			flags[opts.Flag] = { get = function() return value end, set = set }
		end

		local object = {}
		function object:Set(newValue) set(newValue) end
		return object
	end

	function tab:Slider(opts)
		local min, max, increment = opts.Min, opts.Max, opts.Increment or 1
		local value = opts.Default or min
		local frame = row(50)
		textLabel(frame, {
			Position = UDim2.fromOffset(10, 5),
			Size = UDim2.new(0.6, 0, 0, 18),
			Font = Enum.Font.GothamBold,
			Text = opts.Name,
		})
		local valueLabel = textLabel(frame, {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, -10, 0, 5),
			Size = UDim2.new(0.4, 0, 0, 18),
			TextXAlignment = Enum.TextXAlignment.Right,
			TextColor3 = THEME.Accent,
			Font = Enum.Font.GothamBold,
		})
		local hit = new("Frame", {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 10, 1, -3),
			Size = UDim2.new(1, -20, 0, 24),
			BackgroundTransparency = 1,
			Active = true,
		}, frame)
		local bar = new("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.fromScale(0, 0.5),
			Size = UDim2.new(1, 0, 0, 8),
			BackgroundColor3 = THEME.Off,
			BorderSizePixel = 0,
		}, hit)
		corner(bar, 4)
		local fill = new("Frame", {
			Size = UDim2.fromScale(0, 1),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
		}, bar)
		corner(fill, 4)
		gradient(fill, THEME.Accent, THEME.AccentEnd, 0)
		local knob = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0, 0.5),
			Size = UDim2.fromOffset(16, 16),
			BackgroundColor3 = Color3.new(1, 1, 1),
			BorderSizePixel = 0,
		}, bar)
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
			local ok, err = pcall(opts.Callback, value)
			if not ok then warn("Brineland | " .. opts.Name .. " error: " .. tostring(err)) end
			queueSave()
		end

		local dragging = false
		local function fromX(x)
			local alpha = math.clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
			set(min + alpha * (max - min))
		end

		hit.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				page.ScrollingEnabled = false
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
				page.ScrollingEnabled = true
			end
		end))

		render()
		if opts.Flag then
			flags[opts.Flag] = { get = function() return value end, set = set }
		end
	end

	table.insert(tabs, tab)
	if #tabs == 1 then selectTab(tab) end
	return tab
end

---------------------------------------------------------------------
-- Bake or Die Game Logic & Automation
---------------------------------------------------------------------
local function getCharacter()
	local char = LocalPlayer.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChildOfClass("Humanoid")
	return char, root, hum
end

local function firePromptByName(keywords)
	pcall(function()
		for _, descendant in ipairs(workspace:GetDescendants()) do
			if descendant:IsA("ProximityPrompt") then
				local text = string.lower((descendant.ActionText or "") .. " " .. (descendant.ObjectText or ""))
				for _, kw in ipairs(keywords) do
					if string.find(text, kw, 1, true) then
						descendant.HoldDuration = 0
						pcall(fireproximityprompt, descendant)
					end
				end
			end
		end
	end)
end

-- Automation loops for Bake or Die
task.spawn(function()
	while alive do
		task.wait(0.3)
		if state.autoBake then
			firePromptByName({ "bake", "cook", "oven", "start", "prepare" })
		end
		if state.autoCollect then
			firePromptByName({ "collect", "take", "grab", "pick", "cash", "coin", "bread" })
		end
		if state.autoUpgrade then
			firePromptByName({ "upgrade", "buy", "purchase" })
		end
	end
end)

-- Character Stats & Noclip
local originalStats = setmetatable({}, { __mode = "k" })

local function applyStats()
	local _, _, hum = getCharacter()
	if not hum then return end

	if not originalStats[hum] then
		originalStats[hum] = { walkSpeed = hum.WalkSpeed, jumpPower = hum.JumpPower, jumpHeight = hum.JumpHeight }
	end

	if state.walkSpeed and hum.WalkSpeed ~= state.walkSpeed then
		hum.WalkSpeed = state.walkSpeed
	end

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
		if hum and alive then
			task.wait(0.2)
			applyStats()
		end
	end)
end))

track(game:GetService("RunService").Stepped:Connect(function()
	if state.noclip then
		local char = LocalPlayer.Character
		if char then
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") and part.CanCollide then
					part.CanCollide = false
				end
			end
		end
	end
end))

---------------------------------------------------------------------
-- ESP System
---------------------------------------------------------------------
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

local function clearESP()
	for model in pairs(tracked) do removeEntry(model) end
end

local function refreshESP()
	local _, root = getCharacter()
	local seen = {}

	if root and (state.esp.ovens or state.esp.items or state.esp.players) then
		local targets = {}

		-- Scan workspace for relevant objects
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") or obj:IsA("Model") then
				local name = string.lower(obj.Name)
				local isOven = state.esp.ovens and (string.find(name, "oven") or string.find(name, "bake"))
				local isItem = state.esp.items and (string.find(name, "cash") or string.find(name, "coin") or string.find(name, "bread") or string.find(name, "item"))
				
				if isOven or isItem then
					local part = obj:IsA("BasePart") and obj or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
					if part then
						table.insert(targets, { model = obj, part = part, label = obj.Name, color = isOven and Color3.fromRGB(255, 140, 0) or Color3.fromRGB(50, 255, 50) })
					end
				end
			end
		end

		if state.esp.players then
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= LocalPlayer and player.Character then
					local hrp = player.Character:FindFirstChild("HumanoidRootPart")
					if hrp then
						table.insert(targets, { model = player.Character, part = hrp, label = player.Name, color = Color3.fromRGB(0, 170, 255) })
					end
				end
			end
		end

		for _, target in ipairs(targets) do
			target.distance = (root.Position - target.part.Position).Magnitude
		end
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

	for model in pairs(tracked) do
		if not seen[model] or not model.Parent then removeEntry(model) end
	end
end

task.spawn(function()
	while alive do
		task.wait(ESP_INTERVAL)
		pcall(refreshESP)
	end
end)

---------------------------------------------------------------------
-- UI Tabs & Controls
---------------------------------------------------------------------
local MainTab = createTab("Automation")
MainTab:Section("Baking Automation")
MainTab:Toggle({
	Name = "Auto Bake",
	Flag = "AutoBake",
	Callback = function(v) state.autoBake = v end,
})
MainTab:Toggle({
	Name = "Auto Collect Cash / Bread",
	Flag = "AutoCollect",
	Callback = function(v) state.autoCollect = v end,
})
MainTab:Toggle({
	Name = "Auto Upgrade",
	Flag = "AutoUpgrade",
	Callback = function(v) state.autoUpgrade = v end,
})

local TeleportTab = createTab("Teleport")
TeleportTab:Section("Locations")
for _, place in ipairs(TELEPORTS) do
	local placeName, position = place[1], place[2]
	TeleportTab:Button({
		Name = placeName,
		Callback = function()
			local _, root = getCharacter()
			if not root then
				notify("Brineland", "Character not found.")
				return
			end
			root.CFrame = CFrame.new(position + Vector3.new(0, 3, 0))
			notify("Brineland", "Teleported to " .. placeName .. ".", 2)
		end,
	})
end

local PlayerTab = createTab("Player")
PlayerTab:Section("Movement & Stats")
PlayerTab:Slider({
	Name = "WalkSpeed",
	Min = 16, Max = 150, Increment = 5, Default = 16,
	Flag = "WalkSpeed",
	Callback = function(v) state.walkSpeed = v applyStats() end,
})
PlayerTab:Slider({
	Name = "JumpPower",
	Min = 50, Max = 200, Increment = 10, Default = 50,
	Flag = "JumpPower",
	Callback = function(v) state.jumpPower = v applyStats() end,
})
PlayerTab:Toggle({
	Name = "Noclip",
	Flag = "Noclip",
	Callback = function(v) state.noclip = v end,
})

local ESPTab = createTab("ESP")
ESPTab:Section("ESP Categories")
ESPTab:Toggle({ Name = "Oven / Station ESP", Flag = "OvenESP", Callback = function(v) state.esp.ovens = v end })
ESPTab:Toggle({ Name = "Item / Cash ESP", Flag = "ItemESP", Callback = function(v) state.esp.items = v end })
ESPTab:Toggle({ Name = "Player ESP", Flag = "PlayerESP", Callback = function(v) state.esp.players = v end })
ESPTab:Section("ESP Options")
ESPTab:Toggle({ Name = "Show Names", Default = true, Flag = "ShowNames", Callback = function(v) state.esp.showNames = v end })
ESPTab:Toggle({ Name = "Show Distance", Default = true, Flag = "ShowDistance", Callback = function(v) state.esp.showDistance = v end })
ESPTab:Toggle({ Name = "Show Highlight", Default = true, Flag = "ShowHighlight", Callback = function(v) state.esp.showHighlight = v end })

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
	for _, conn in ipairs(connections) do
		pcall(function() conn:Disconnect() end)
	end
	table.clear(connections)
	clearESP()
	pcall(function() ESPFolder:Destroy() end)
	pcall(restoreStats)
	pcall(function() Gui:Destroy() end)
	if env.BrinelandHubUnload == cleanup then
		env.BrinelandHubUnload = nil
	end
end
env.BrinelandHubUnload = cleanup

loadConfig()
notify("Brineland Hub", "Bake or Die Hub Loaded Successfully!", 4)

end, function(e)
	return tostring(e) .. "\n" .. ((debug and debug.traceback and debug.traceback()) or "")
end)

if not brinelandOk then brinelandFatal(brinelandErr) end
