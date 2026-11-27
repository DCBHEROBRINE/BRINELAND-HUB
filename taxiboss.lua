-- ============================================================
-- BRINELAND TAXI BOSS - MOBILE HUB (UPDATED)
-- ============================================================

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace        = game:GetService("Workspace")
local RunService       = game:GetService("RunService")
local Players          = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
	warn("[Brineland] LocalPlayer is not ready.")
	return
end

local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 15)
if not PlayerGui then
	warn("[Brineland] PlayerGui was not found.")
	return
end

local env = (getgenv and getgenv()) or _G
if type(env.BrinelandTaxiBossCleanup) == "function" then
	pcall(env.BrinelandTaxiBossCleanup)
end

if PlayerGui:FindFirstChild("TaxiBossCustomHub") then
	PlayerGui.TaxiBossCustomHub:Destroy()
end
if PlayerGui:FindFirstChild("BrinelandTaxiUI") then
	PlayerGui.BrinelandTaxiUI:Destroy()
end

-- ============================================================
-- GAMEPLAY CONFIG & ENGINE
-- ============================================================
local Config = {
	AutoCollectItems = false,
	ClearAICars      = false,
	EnableCarSpeed   = false,
	TargetKMH        = 220,
	PlayerSpeed      = 16,
	ItemDelay        = 0.15,
	DefaultWalkSpeed = 16,
}

local activeToken = {}
env.BrinelandTaxiBossToken = activeToken
local connections = {}

local function isAlive()
	return env.BrinelandTaxiBossToken == activeToken
end

local function track(conn)
	table.insert(connections, conn)
	return conn
end

local function sanitizeNumber(val, minVal, maxVal, fallback)
	if type(val) ~= "number" or val ~= val or val == math.huge or val == -math.huge then
		return fallback
	end
	return math.clamp(val, minVal, maxVal)
end

local function GetPlayerVehicle()
	local char = LocalPlayer.Character
	if not char then
		return nil
	end
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	if humanoid and humanoid.SeatPart and humanoid.SeatPart:IsA("VehicleSeat") then
		return humanoid.SeatPart.Parent
	end
	return nil
end

local function CollectItemSpawns()
	local itemFolder = Workspace:FindFirstChild("ItemSpawnLocations")
	if not itemFolder then
		return
	end

	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then
		return
	end

	for _, zone in ipairs(itemFolder:GetChildren()) do
		if not isAlive() or not Config.AutoCollectItems then
			break
		end

		local spawnedItems = {}
		for _, child in ipairs(zone:GetChildren()) do
			if child:IsA("Model") or (child:IsA("BasePart") and child.Name ~= zone.Name) then
				table.insert(spawnedItems, child)
			end
		end

		for _, item in ipairs(spawnedItems) do
			if not isAlive() or not Config.AutoCollectItems then
				break
			end

			local targetPart = item:IsA("Model")
				and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart", true))
				or item
			local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)

			if targetPart and targetPart:IsA("BasePart") then
				pcall(function()
					char:PivotTo(targetPart.CFrame * CFrame.new(0, 2, 0))
				end)
				task.wait(0.08)

				if prompt and prompt.Enabled then
					pcall(function()
						fireproximityprompt(prompt)
					end)
				elseif firetouchinterest then
					pcall(function()
						firetouchinterest(hrp, targetPart, 0)
						task.wait(0.02)
						firetouchinterest(hrp, targetPart, 1)
					end)
				end

				task.wait(Config.ItemDelay)
			end
		end
	end
end

task.spawn(function()
	while isAlive() do
		if Config.AutoCollectItems then
			pcall(CollectItemSpawns)
		end
		task.wait(0.5)
	end
end)

task.spawn(function()
	while isAlive() do
		if Config.ClearAICars then
			local aiFolder = Workspace:FindFirstChild("AICars")
			if aiFolder then
				for _, car in ipairs(aiFolder:GetChildren()) do
					pcall(function()
						car:Destroy()
					end)
				end
			end
		end
		task.wait(1.5)
	end
end)

track(RunService.Heartbeat:Connect(function()
	if not isAlive() then
		return
	end

	local char = LocalPlayer.Character
	if char then
		local hum = char:FindFirstChildOfClass("Humanoid")
		local targetWalk = sanitizeNumber(Config.PlayerSpeed, 4, 250, Config.DefaultWalkSpeed)
		if hum and hum.WalkSpeed ~= targetWalk then
			hum.WalkSpeed = targetWalk
		end
	end

	if Config.EnableCarSpeed then
		local veh = GetPlayerVehicle()
		if veh then
			local seat = veh:FindFirstChildOfClass("VehicleSeat") or veh:FindFirstChild("SEAT", true)
			if seat and seat:IsA("VehicleSeat") then
				local kmh = sanitizeNumber(Config.TargetKMH, 10, 600, 220)
				local speedStuds = kmh / 1.008
				seat.MaxSpeed = speedStuds
				seat.Torque = 90000

				if seat.Throttle > -1 then
					local root = seat.AssemblyRootPart or seat
					local lookVector = seat.CFrame.LookVector
					root.AssemblyLinearVelocity = Vector3.new(
						lookVector.X * speedStuds,
						root.AssemblyLinearVelocity.Y,
						lookVector.Z * speedStuds
					)
				end
			end
		end
	end
end))

local function CleanupTaxiBoss()
	env.BrinelandTaxiBossToken = nil
	Config.AutoCollectItems = false
	Config.ClearAICars = false
	Config.EnableCarSpeed = false

	for _, conn in ipairs(connections) do
		pcall(function()
			conn:Disconnect()
		end)
	end
	table.clear(connections)

	local char = LocalPlayer.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if hum then
		pcall(function()
			hum.WalkSpeed = Config.DefaultWalkSpeed
		end)
	end
end

env.BrinelandTaxiBossCleanup = CleanupTaxiBoss

-- ============================================================
-- BRINELAND UI (HOME + CONTROLS)
-- ============================================================
local function createHub(handlers)
	handlers = handlers or {}

	local function make(class, properties, parent)
		local obj = Instance.new(class)
		for key, value in pairs(properties) do
			obj[key] = value
		end
		obj.Parent = parent
		return obj
	end

	local bg = Color3.fromRGB(12, 12, 14)
	local panelColor = Color3.fromRGB(24, 24, 28)
	local white = Color3.fromRGB(245, 245, 245)
	local muted = Color3.fromRGB(170, 170, 180)
	local mid = Color3.fromRGB(50, 50, 56)

	local function round(obj, radius)
		make("UICorner", { CornerRadius = UDim.new(0, radius) }, obj)
	end

	local function stroke(obj)
		make("UIStroke", {
			Color = white,
			Transparency = 0.55,
			Thickness = 1,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		}, obj)
	end

	local gui = make("ScreenGui", {
		Name = "TaxiBossCustomHub",
		ResetOnSpawn = false,
		IgnoreGuiInset = true,
		DisplayOrder = 900,
	}, PlayerGui)

	local camera = Workspace.CurrentCamera
	local v = camera and camera.ViewportSize or Vector2.new(800, 450)
	local width = math.min(420, math.max(200, v.X - 24))
	local height = math.min(315, math.max(160, v.Y - 30))

	local main = make("Frame", {
		Name = "Main",
		Size = UDim2.fromOffset(width, height),
		Position = UDim2.new(0.5, -width / 2, 0.5, -height / 2),
		BackgroundColor3 = bg,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Active = true,
	}, gui)
	round(main, 12)
	stroke(main)

	local top = make("Frame", {
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundColor3 = panelColor,
		BorderSizePixel = 0,
		Active = true,
	}, main)
	round(top, 12)

	make("TextLabel", {
		Size = UDim2.new(1, -135, 1, 0),
		Position = UDim2.fromOffset(12, 0),
		BackgroundTransparency = 1,
		Text = "Brineland",
		TextColor3 = white,
		Font = Enum.Font.Fondamento,
		TextSize = 19,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, top)

	local content = make("Frame", {
		Position = UDim2.fromOffset(7, 44),
		Size = UDim2.new(1, -14, 1, -51),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
	}, main)

	local views = {}
	local function view(name)
		local frame = make("ScrollingFrame", {
			Name = name,
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 3,
			CanvasSize = UDim2.fromOffset(0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Visible = false,
		}, content)
		make("UIListLayout", { Padding = UDim.new(0, 7), SortOrder = Enum.SortOrder.LayoutOrder }, frame)
		make("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 8) }, frame)
		views[name] = frame
		return frame
	end

	local home, controls = view("Home"), view("Controls")
	local function selectView(name)
		for key, frame in pairs(views) do
			frame.Visible = (key == name)
		end
	end

	local function label(parent, text, h, order, color)
		return make("TextLabel", {
			Size = UDim2.new(1, 0, 0, h),
			BackgroundTransparency = 1,
			Text = text,
			TextColor3 = color or white,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			LayoutOrder = order,
		}, parent)
	end

	local function button(parent, text, size, pos, callback)
		local b = make("TextButton", {
			Size = size,
			Position = pos,
			BackgroundColor3 = panelColor,
			BorderSizePixel = 0,
			Text = text,
			TextColor3 = white,
			Font = Enum.Font.GothamBold,
			TextSize = 11,
			TextWrapped = true,
		}, parent)
		round(b, 8)
		stroke(b)
		b.Activated:Connect(callback)
		return b
	end

	label(home, "Welcome back to\nBRINELAND HUB", 42, 1, white)
	label(home, "Taxi Boss edition\nHome and controls in a mobile-friendly layout.", 42, 2, muted)
	label(home, "Status: Connected to Taxi Boss features.", 32, 3, muted)
	local open = button(home, "Taxi Boss controls", UDim2.new(1, 0, 0, 38), UDim2.new(), function()
		selectView("Controls")
	end)
	open.LayoutOrder = 4

	label(controls, "TAXI BOSS CONTROLS", 22, 1, white)
	local order = 1

	local function toggle(title, key, initialState)
		order = order + 1
		local available = type(handlers[key]) == "function"
		local active = initialState == true

		local row = make("Frame", {
			Size = UDim2.new(1, 0, 0, 40),
			BackgroundColor3 = panelColor,
			BorderSizePixel = 0,
			LayoutOrder = order,
		}, controls)
		round(row, 8)
		stroke(row)

		make("TextLabel", {
			Position = UDim2.fromOffset(10, 0),
			Size = UDim2.new(1, -70, 1, 0),
			BackgroundTransparency = 1,
			Text = title .. (available and "" or " (not connected)"),
			TextColor3 = available and white or muted,
			Font = Enum.Font.GothamBold,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
		}, row)

		local b = make("TextButton", {
			Position = UDim2.new(1, -58, 0.5, -12),
			Size = UDim2.fromOffset(48, 24),
			BackgroundColor3 = active and white or mid,
			Text = active and "ON" or "OFF",
			TextColor3 = active and bg or white,
			Font = Enum.Font.GothamBold,
			TextSize = 10,
			BorderSizePixel = 0,
			Active = available,
			AutoButtonColor = available,
		}, row)
		round(b, 12)

		b.Activated:Connect(function()
			if not available then
				return
			end
			local nextState = not active
			local ok, err = pcall(handlers[key], nextState)
			if not ok then
				warn("[Brineland UI] " .. title .. ": " .. tostring(err))
				return
			end
			active = nextState
			b.Text = active and "ON" or "OFF"
			b.BackgroundColor3 = active and white or mid
			b.TextColor3 = active and bg or white
		end)
	end

	local function input(title, key, default)
		order = order + 1
		local available = type(handlers[key]) == "function"
		local currentVal = default

		local row = make("Frame", {
			Size = UDim2.new(1, 0, 0, 40),
			BackgroundColor3 = panelColor,
			BorderSizePixel = 0,
			LayoutOrder = order,
		}, controls)
		round(row, 8)
		stroke(row)

		make("TextLabel", {
			Position = UDim2.fromOffset(10, 0),
			Size = UDim2.new(1, -90, 1, 0),
			BackgroundTransparency = 1,
			Text = title .. (available and "" or " (not connected)"),
			TextColor3 = available and white or muted,
			Font = Enum.Font.GothamBold,
			TextSize = 11,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
		}, row)

		local box = make("TextBox", {
			Position = UDim2.new(1, -72, 0.5, -12),
			Size = UDim2.fromOffset(62, 24),
			BackgroundColor3 = mid,
			Text = tostring(currentVal),
			TextColor3 = white,
			Font = Enum.Font.GothamBold,
			TextSize = 11,
			BorderSizePixel = 0,
			ClearTextOnFocus = false,
			TextEditable = available,
		}, row)
		round(box, 5)

		box.FocusLost:Connect(function()
			if not available then
				return
			end
			local n = tonumber(box.Text)
			if not n or n ~= n or n == math.huge or n == -math.huge then
				box.Text = tostring(currentVal)
				return
			end
			local ok, err = pcall(handlers[key], n)
			if ok then
				currentVal = n
				box.Text = tostring(n)
			else
				box.Text = tostring(currentVal)
				warn("[Brineland UI] " .. tostring(err))
			end
		end)
	end

	toggle("Collect part", "collect", Config.AutoCollectItems)
	toggle("Clear AI car", "clearAI", Config.ClearAICars)
	toggle("Car boost", "carBoost", Config.EnableCarSpeed)
	input("Target speed (KM/H)", "targetSpeed", Config.TargetKMH)
	input("Player WalkSpeed", "walkSpeed", Config.PlayerSpeed)

	local collapsed = false
	local uiConnections = {}

	button(top, "Home", UDim2.fromOffset(50, 26), UDim2.new(1, -120, 0, 7), function()
		collapsed = false
		main.Size = UDim2.fromOffset(width, height)
		content.Visible = true
		selectView("Home")
	end)

	button(top, "-", UDim2.fromOffset(26, 26), UDim2.new(1, -66, 0, 7), function()
		collapsed = not collapsed
		content.Visible = not collapsed
		main.Size = UDim2.fromOffset(width, collapsed and 40 or height)
	end)

	button(top, "X", UDim2.fromOffset(26, 26), UDim2.new(1, -35, 0, 7), function()
		gui:Destroy()
	end)

	local dragging = false
	local dragStart = Vector2.zero
	local startPos = main.Position
	local activeInputObj = nil

	uiConnections[#uiConnections + 1] = top.InputBegan:Connect(function(inputObj)
		if dragging then
			return
		end
		if inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			activeInputObj = inputObj
			dragStart = inputObj.Position
			startPos = main.Position
		end
	end)

	uiConnections[#uiConnections + 1] = UserInputService.InputChanged:Connect(function(inputObj)
		if not dragging or inputObj ~= activeInputObj then
			return
		end
		if inputObj.UserInputType == Enum.UserInputType.MouseMovement or inputObj.UserInputType == Enum.UserInputType.Touch then
			local d = inputObj.Position - dragStart
			main.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + d.X,
				startPos.Y.Scale,
				startPos.Y.Offset + d.Y
			)
		end
	end)

	uiConnections[#uiConnections + 1] = UserInputService.InputEnded:Connect(function(inputObj)
		if inputObj == activeInputObj then
			dragging = false
			activeInputObj = nil
		end
	end)

	gui.Destroying:Connect(function()
		for _, conn in ipairs(uiConnections) do
			pcall(function()
				conn:Disconnect()
			end)
		end
		table.clear(uiConnections)
		if type(handlers.close) == "function" then
			pcall(handlers.close)
		end
	end)

	selectView("Home")
	return gui
end

createHub({
	collect = function(enabled)
		Config.AutoCollectItems = enabled == true
	end,
	clearAI = function(enabled)
		Config.ClearAICars = enabled == true
	end,
	carBoost = function(enabled)
		Config.EnableCarSpeed = enabled == true
	end,
	targetSpeed = function(value)
		Config.TargetKMH = sanitizeNumber(value, 10, 600, Config.TargetKMH)
	end,
	walkSpeed = function(value)
		Config.PlayerSpeed = sanitizeNumber(value, 4, 250, Config.PlayerSpeed)
	end,
	close = CleanupTaxiBoss,
})
