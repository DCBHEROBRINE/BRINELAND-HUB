-- ============================================================
-- BRINELAND UNIVERSAL HUB V2
-- Your hub tabs + Infinite-Yield-style commands as ONE system:
-- every feature has one state, so the toggle, slider, command,
-- keybind and quick chip always stay in sync.
-- Load it AFTER the key check (replaces RunUniversalScript + iylite).
-- ============================================================
local function BrinelandUniversal()
    local env = (getgenv and getgenv()) or _G
    for _, k in ipairs({ "BrinelandUniversal", "BrinelandIY" }) do
        if env[k] and env[k].Destroy then pcall(env[k].Destroy) end
    end

    local Players                = game:GetService("Players")
    local RunService             = game:GetService("RunService")
    local UserInputService       = game:GetService("UserInputService")
    local TweenService           = game:GetService("TweenService")
    local Lighting               = game:GetService("Lighting")
    local HttpService            = game:GetService("HttpService")
    local TeleportService        = game:GetService("TeleportService")
    local SoundService           = game:GetService("SoundService")
    local LogService             = game:GetService("LogService")
    local Stats                  = game:GetService("Stats")
    local Workspace              = game:GetService("Workspace")
    local ProximityPromptService = game:GetService("ProximityPromptService")
    local LP = Players.LocalPlayer
    local PlayerGui = LP:WaitForChild("PlayerGui")
    local setclip = setclipboard or toclipboard or set_clipboard

    -- ---- links / media (same as your main script) ----
    local DISCORD_INVITE = "https://discord.gg/epWMbuXSN5"
    local YOUTUBE_URL    = "https://youtube.com/@dcb_herobrine?si=PN8mSo36sJFaySFQ"
    local HIDDEN_MUSIC_ID, HIDDEN_MUSIC_VOLUME = "rbxassetid://108997017247273", 0.45
    local CUSTOM_BANNER_FILE, CUSTOM_BANNER_ID = "brineland_banner.png", ""

    local Theme = {
        Black    = Color3.fromRGB(10, 10, 12),
        DarkGray = Color3.fromRGB(24, 24, 28),
        MidGray  = Color3.fromRGB(46, 46, 54),
        SubText  = Color3.fromRGB(180, 180, 190),
        White    = Color3.fromRGB(255, 255, 255),
    }
    local FANCY_FONT, BODY_FONT = Enum.Font.Fondamento, Enum.Font.GothamBold

    local U = { Alive = true, Conns = {}, Guis = {} }
    env.BrinelandUniversal = U

    -- forward declarations (filled in once the UI exists)
    local say, pushLog, SelectTab, focusBar, wpRefresh =
        function() end, function() end, function() end, function() end, function() end

    ---------------------------------------------------------------------
    -- 1. SMALL HELPERS
    ---------------------------------------------------------------------
    local function conn(sig, fn)
        local c = sig:Connect(function(...)
            local ok, err = pcall(fn, ...)
            if not ok then warn("[BrinelandHub] " .. tostring(err)) end
        end)
        table.insert(U.Conns, c)
        return c
    end
    local function hum()  local c = LP.Character; return c and c:FindFirstChildOfClass("Humanoid") end
    local function root() local c = LP.Character; return c and (c:FindFirstChild("HumanoidRootPart") or c.PrimaryPart) end
    local function cam()  return Workspace.CurrentCamera end

    local function clampNum(v, lo, hi, int)
        v = tonumber(v)
        if not v or v ~= v then return nil end
        if lo then v = math.max(lo, v) end
        if hi then v = math.min(hi, v) end
        if int then v = math.floor(v + 0.5) end
        return v
    end
    local function copyText(t)
        if setclip then pcall(setclip, tostring(t)); say("Copied: " .. tostring(t)) else say("Clipboard not supported.") end
    end

    local function mk(class, props, parent)
        local o = Instance.new(class)
        for k, v in pairs(props) do o[k] = v end
        o.Parent = parent
        return o
    end
    local function round(o, r) mk("UICorner", { CornerRadius = UDim.new(0, r or 8) }, o) end
    local function stroke(o, t, th)
        return mk("UIStroke", { Color = Theme.White, Thickness = th or 1.25, Transparency = t or 0.25, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, o)
    end
    local function isPointer(i) return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch end
    local function viewport() local c = cam(); return c and c.ViewportSize or Vector2.new(800, 600) end

    local orderCount = setmetatable({}, { __mode = "k" })
    local function LO(parent) orderCount[parent] = (orderCount[parent] or 0) + 1; return orderCount[parent] end

    local function clampOnScreen(target)
        local vp = viewport()
        local pos, size = target.AbsolutePosition, target.AbsoluteSize
        local dx, dy = 0, 0
        if pos.X + size.X < 60 then dx = 60 - (pos.X + size.X) elseif pos.X > vp.X - 60 then dx = (vp.X - 60) - pos.X end
        if pos.Y < 0 then dy = -pos.Y elseif pos.Y > vp.Y - 40 then dy = (vp.Y - 40) - pos.Y end
        if dx ~= 0 or dy ~= 0 then
            local p = target.Position
            target.Position = UDim2.new(p.X.Scale, p.X.Offset + dx, p.Y.Scale, p.Y.Offset + dy)
        end
    end

    -- drag by one specific input (a second finger can't hijack it); onTap runs when it wasn't dragged
    local function makeDraggable(handle, target, onTap)
        local dragInput, dragStart, startPos, moved
        conn(handle.InputBegan, function(i)
            if isPointer(i) and not dragInput then dragInput, dragStart, startPos, moved = i, i.Position, target.Position, false end
        end)
        conn(UserInputService.InputChanged, function(i)
            if not dragInput then return end
            local same = i == dragInput or (dragInput.UserInputType == Enum.UserInputType.MouseButton1 and i.UserInputType == Enum.UserInputType.MouseMovement)
            if not same then return end
            local d = i.Position - dragStart
            if not moved and d.Magnitude > 6 then moved = true end
            if moved then target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y) end
        end)
        conn(UserInputService.InputEnded, function(i)
            if dragInput and (i == dragInput or (dragInput.UserInputType == Enum.UserInputType.MouseButton1 and i.UserInputType == Enum.UserInputType.MouseButton1)) then
                local wasMoved = moved
                dragInput = nil
                if wasMoved then clampOnScreen(target) elseif onTap then onTap() end
            end
        end)
    end

    local function EnsureHiddenMusic()
        local existing = SoundService:FindFirstChild("BrinelandHiddenMusic")
        if existing and existing:IsA("Sound") then
            if not existing.IsPlaying then pcall(function() existing:Play() end) end
            return existing
        end
        local s = mk("Sound", { Name = "BrinelandHiddenMusic", SoundId = HIDDEN_MUSIC_ID, Volume = HIDDEN_MUSIC_VOLUME, Looped = true }, SoundService)
        pcall(function() s:Play() end)
        return s
    end

    local function resolveBanner()
        if getcustomasset and isfile and CUSTOM_BANNER_FILE ~= "" and isfile(CUSTOM_BANNER_FILE) then
            local ok, asset = pcall(getcustomasset, CUSTOM_BANNER_FILE)
            if ok and asset then return asset end
        end
        return CUSTOM_BANNER_ID
    end

    ---------------------------------------------------------------------
    -- 2. SAVED DATA (settings, keybinds, aliases, waypoints)
    ---------------------------------------------------------------------
    local SAVE_FILE = "BrinelandHub.json"
    local Save = { vals = {}, keys = {}, aliases = {}, waypoints = {} }
    pcall(function()
        if readfile and isfile and isfile(SAVE_FILE) then
            local d = HttpService:JSONDecode(readfile(SAVE_FILE))
            if type(d) == "table" then
                for _, k in ipairs({ "vals", "keys", "aliases", "waypoints" }) do
                    if type(d[k]) == "table" then Save[k] = d[k] end
                end
            end
        end
    end)
    local dirty = false
    local function markDirty() dirty = true end
    local function persistNow()
        dirty = false
        if writefile then pcall(function() writefile(SAVE_FILE, HttpService:JSONEncode(Save)) end) end
    end

    ---------------------------------------------------------------------
    -- 3. FEATURES: one state table drives UI, commands and keybinds
    ---------------------------------------------------------------------
    local St, Defs, DefById, Bind, Apply, Over, O = {}, {}, {}, {}, {}, {}, {}
    local S = {}   -- misc runtime (fly flags, view target, last position...)

    local c0 = Workspace.CurrentCamera
    O.Gravity = Workspace.Gravity
    O.FOV = c0 and c0.FieldOfView or 70
    O.ZoomMax, O.ZoomMin = LP.CameraMaxZoomDistance, LP.CameraMinZoomDistance
    O.Light = {
        Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime, GlobalShadows = Lighting.GlobalShadows,
        FogEnd = Lighting.FogEnd, Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
    }

    local function def(d) Defs[#Defs + 1] = d; DefById[d.id] = d; St[d.id] = d.default end
    local function defT(id, label, persist, default) def({ id = id, kind = "toggle", label = label, default = default or false, persist = persist }) end
    local function defN(id, label, lo, hi, default, step, extra)
        local d = { id = id, kind = "number", label = label, min = lo, max = hi, default = default, step = step or 1 }
        for k, v in pairs(extra or {}) do d[k] = v end
        def(d)
    end

    defT("fly", "Enable Fly");              defN("flySpeed", "Fly Speed", 10, 300, 50, 1, { persist = true })
    defT("noclip", "Noclip")
    defT("speedOn", "Enable WalkSpeed");    defN("walkSpeed", "Player Speed", 16, 300, 16, 1, { persist = true })
    defT("tpwalkOn", "Enable TP-Walk");     defN("tpwalkSpeed", "TP-Walk Speed", 1, 60, 3, 1, { persist = true })
    defT("jumpOn", "Enable Jump Power");    defN("jumpPower", "Jump Power", 0, 400, 100, 1, { persist = true })
    defT("infjump", "Infinite Jump")
    defT("god", "Keep HP Full (client-side)")
    defT("antiafk", "Anti-AFK", true)
    defT("clicktp", "Click / Tap Teleport")
    defT("esp", "Player ESP")
    defT("xray", "X-Ray (see through walls)")
    defT("clean", "Clean Vision (Fullbright & No Fog)")
    defT("aim", "Enable Auto Aim (Lock)");  defN("aimRange", "Auto Aim Lock Range", 10, 200, 60, 1, { persist = true })
    defT("fastinteract", "Fast Interact")
    defT("lowgfx", "Low Graphics (FPS boost)")
    defT("music", "Background Music", true, true); defN("musicVolume", "Music Volume", 0, 100, 45, 1, { persist = true })
    defN("gravity", "Gravity", 0, 400, math.floor(O.Gravity + 0.5), 1, { reset = true })
    defN("hipHeight", "Hip Height", -2, 20, 2, 1, { reset = true })
    defN("fov", "Field of View", 30, 120, math.floor(O.FOV + 0.5), 1, { reset = true })
    defN("zoom", "Max Zoom Distance", 20, 2000, math.clamp(math.floor(O.ZoomMax), 20, 2000), 10, { reset = true })
    defN("timeOfDay", "Time of Day", 0, 24, math.floor(O.Light.ClockTime * 2 + 0.5) / 2, 0.5, { reset = true })

    -- restore saved values
    for _, d in ipairs(Defs) do
        local v = Save.vals[d.id]
        if d.persist and v ~= nil then
            if d.kind == "number" and type(v) == "number" then St[d.id] = math.clamp(v, d.min, d.max)
            elseif d.kind == "toggle" and type(v) == "boolean" then St[d.id] = v end
        end
    end

    local function bindRefresh(id, fn)
        Bind[id] = Bind[id] or {}
        table.insert(Bind[id], fn)
    end
    local function refreshFeature(id)
        for _, fn in ipairs(Bind[id] or {}) do pcall(fn) end
    end
    local function Set(id, value)
        local d = DefById[id]
        if not d then return end
        if d.kind == "number" then
            value = clampNum(value, d.min, d.max, d.step >= 1)
            if value == nil then return end
            if d.step < 1 then value = math.floor(value / d.step + 0.5) * d.step end
        else
            value = value and true or false
        end
        St[id] = value
        local fn = Apply[id]
        if fn then
            local ok, err = pcall(fn, value)
            if not ok then warn("[BrinelandHub] " .. id .. ": " .. tostring(err)) end
        end
        refreshFeature(id)
        if d.persist then Save.vals[id] = value; markDirty() end
    end

    ---------------------------------------------------------------------
    -- 4. ENGINE
    ---------------------------------------------------------------------
    -- 4a. teleports + waypoints (the TP tab, swp/gwp commands and keybinds all share these)
    local activeTween
    local function Teleport(cf)
        local c, r = LP.Character, root()
        if not (c and r) then return false end
        S.lastCF = r.CFrame
        return pcall(function() c:PivotTo(cf) end)
    end
    local function WalkTo(pos) local h = hum(); if h then h:MoveTo(pos) end end
    local function TweenTo(cf)
        local r = root(); if not r then return end
        if activeTween then activeTween:Cancel() end
        S.lastCF = r.CFrame
        local d = (r.Position - cf.Position).Magnitude
        activeTween = TweenService:Create(r, TweenInfo.new(math.max(0.1, d / 80), Enum.EasingStyle.Linear), { CFrame = cf })
        activeTween:Play()
    end
    local function TeleportBack()
        local r = root()
        if r and S.lastCF then local here = r.CFrame; Teleport(S.lastCF); S.lastCF = here; say("Went back.") else say("Nothing to go back to.") end
    end
    local function TeleportSpawn()
        local sp = Workspace:FindFirstChildWhichIsA("SpawnLocation", true)
        if sp then Teleport(sp.CFrame + Vector3.new(0, 5, 0)); say("Teleported to spawn.") else say("No spawn found.") end
    end
    local function targetCF(p)
        local tr = p and p.Character and (p.Character:FindFirstChild("HumanoidRootPart") or p.Character.PrimaryPart)
        return tr and (tr.CFrame + Vector3.new(0, 3, 0)) or nil
    end

    local function wpList()
        local k = tostring(game.PlaceId)
        Save.waypoints[k] = Save.waypoints[k] or {}
        return Save.waypoints[k]
    end
    local function wpIndex(name)
        for i, w in ipairs(wpList()) do if w.name:lower() == name:lower() then return i, w end end
    end
    local function wpCF(w) return CFrame.new(w.x, w.y, w.z) end
    local function addWaypoint(name)
        local r = root()
        if not r then say("No character yet.") return end
        local list = wpList()
        if not name or name == "" then
            local n = #list + 1
            while wpIndex("TP #" .. n) do n = n + 1 end
            name = "TP #" .. n
        end
        local p = r.Position
        local entry = { name = name, x = p.X, y = p.Y, z = p.Z }
        local idx = wpIndex(name)
        if idx then list[idx] = entry else list[#list + 1] = entry end
        markDirty(); wpRefresh(); say("Saved '" .. name .. "'")
    end
    local function deleteWaypoint(name)
        local idx = wpIndex(name)
        if idx then table.remove(wpList(), idx); markDirty(); wpRefresh(); return true end
        return false
    end

    -- 4b. fly (thumbstick friendly, camera-relative like IY)
    local controls
    task.spawn(function()
        pcall(function()
            local pm = LP:WaitForChild("PlayerScripts", 5):WaitForChild("PlayerModule", 5)
            controls = require(pm):GetControls()
        end)
    end)
    local function moveVec()
        if controls then
            local ok, v = pcall(function() return controls:GetMoveVector() end)
            if ok and typeof(v) == "Vector3" then return v end
        end
        local h, c = hum(), cam()
        if h and c then return c.CFrame:VectorToObjectSpace(h.MoveDirection) end
        return Vector3.zero
    end
    local function stopFly()
        if S.FlyConn then S.FlyConn:Disconnect(); S.FlyConn = nil end
        local r = root()
        if r then
            for _, n in ipairs({ "BrinelandFly", "BrinelandFlyGyro" }) do
                local o = r:FindFirstChild(n)
                if o then o:Destroy() end
            end
        end
        local h = hum()
        if h then h.PlatformStand = false end
        if S.FlyPad then S.FlyPad.Visible = false end
    end
    local function startFly()
        stopFly()
        local r, h = root(), hum()
        if not (r and h) then return false end
        local bv = mk("BodyVelocity", { Name = "BrinelandFly", MaxForce = Vector3.one * 9e9, Velocity = Vector3.zero }, r)
        local bg = mk("BodyGyro", { Name = "BrinelandFlyGyro", MaxTorque = Vector3.one * 9e9, P = 9e4, CFrame = r.CFrame }, r)
        h.PlatformStand = true
        if S.FlyPad and UserInputService.TouchEnabled then S.FlyPad.Visible = true end
        S.FlyConn = RunService.RenderStepped:Connect(function()
            local c, rr = cam(), root()
            if not (c and rr and bv.Parent) then return end
            local mv = moveVec()
            local dir = c.CFrame:VectorToWorldSpace(Vector3.new(mv.X, 0, mv.Z))
            local up = 0
            if not UserInputService:GetFocusedTextBox() then
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) or UserInputService:IsKeyDown(Enum.KeyCode.E) then up = up + 1 end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.Q) then up = up - 1 end
            end
            if S.UpHeld then up = up + 1 end
            if S.DownHeld then up = up - 1 end
            local speed = St.flySpeed
            local vel = dir * speed + Vector3.new(0, up * speed, 0)
            if vel.Magnitude > speed then vel = vel.Unit * speed end
            bv.Velocity = vel
            bg.CFrame = c.CFrame
        end)
        return true
    end

    -- 4c. noclip (remembers exactly which parts it changed)
    local noclipSet = setmetatable({}, { __mode = "k" })
    local function restoreNoclip()
        for p in pairs(noclipSet) do pcall(function() p.CanCollide = true end); noclipSet[p] = nil end
    end
    conn(RunService.Stepped, function()
        if not St.noclip then return end
        local c = LP.Character
        if not c then return end
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then noclipSet[p] = true; p.CanCollide = false end
        end
    end)

    -- 4d. speed / jump
    local function applySpeed()
        local h = hum(); if not h then return end
        if St.speedOn then
            if O.Walk == nil then O.Walk = h.WalkSpeed end
            h.WalkSpeed = St.walkSpeed
        elseif O.Walk ~= nil then
            h.WalkSpeed = O.Walk; O.Walk = nil
        end
    end
    local function applyJump()
        local h = hum(); if not h then return end
        if St.jumpOn then
            if O.Jump == nil then O.Jump, O.UseJump = h.JumpPower, h.UseJumpPower end
            h.UseJumpPower = true
            h.JumpPower = St.jumpPower
        elseif O.Jump ~= nil then
            h.JumpPower = O.Jump; h.UseJumpPower = O.UseJump; O.Jump, O.UseJump = nil, nil
        end
    end

    -- 4e. ESP (one highlight + one tag per player; text refreshed at 4 Hz)
    local espData, espConns = {}, {}
    local function removeEsp(p)
        local d = espData[p]
        if d then pcall(function() d.hl:Destroy() end); pcall(function() d.bb:Destroy() end); espData[p] = nil end
    end
    local function addEsp(p)
        if p == LP then return end
        removeEsp(p)
        local c = p.Character
        local hrp = c and (c:FindFirstChild("HumanoidRootPart") or c:WaitForChild("HumanoidRootPart", 3))
        if not hrp then return end
        local hl = mk("Highlight", { FillColor = Theme.White, OutlineColor = Theme.White, FillTransparency = 0.75, Adornee = c }, c)
        local bb = mk("BillboardGui", { Adornee = hrp, Size = UDim2.fromOffset(140, 30), StudsOffset = Vector3.new(0, 3.2, 0), AlwaysOnTop = true }, nil)
        local lbl = mk("TextLabel", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 11, TextStrokeTransparency = 0.4, Text = p.DisplayName }, bb)
        bb.Parent = hrp
        espData[p] = { hl = hl, bb = bb, lbl = lbl, hrp = hrp }
    end
    local function setEsp(on)
        for _, c in ipairs(espConns) do pcall(function() c:Disconnect() end) end
        table.clear(espConns)
        if on then
            local function hook(p)
                if p == LP then return end
                table.insert(espConns, p.CharacterAdded:Connect(function() task.wait(0.4); if St.esp then addEsp(p) end end))
                addEsp(p)
            end
            for _, p in ipairs(Players:GetPlayers()) do hook(p) end
            table.insert(espConns, Players.PlayerAdded:Connect(hook))
            table.insert(espConns, Players.PlayerRemoving:Connect(removeEsp))
        else
            for p in pairs(espData) do removeEsp(p) end
        end
    end
    task.spawn(function()
        while U.Alive do
            if St.esp then
                local r = root()
                for p, d in pairs(espData) do
                    local h = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
                    if d.hrp and d.hrp.Parent and r and h then
                        d.lbl.Text = string.format("%s\n%dm | %d HP", p.DisplayName, math.floor((d.hrp.Position - r.Position).Magnitude), math.floor(h.Health))
                    end
                end
            end
            task.wait(0.25)
        end
    end)

    -- 4f. X-Ray (client-side, chunked scan, fully restored)
    local xrayOrig = setmetatable({}, { __mode = "k" })
    local xrayConn
    local function xrayPart(p)
        if not p:IsA("BasePart") or xrayOrig[p] ~= nil then return end
        local m = p:FindFirstAncestorOfClass("Model")
        if m and m:FindFirstChildOfClass("Humanoid") then return end
        xrayOrig[p] = p.LocalTransparencyModifier
        p.LocalTransparencyModifier = 0.6
    end
    local function setXray(on)
        if xrayConn then xrayConn:Disconnect(); xrayConn = nil end
        if on then
            xrayConn = Workspace.DescendantAdded:Connect(function(d) if St.xray then pcall(xrayPart, d) end end)
            task.spawn(function()
                local n = 0
                for _, d in ipairs(Workspace:GetDescendants()) do
                    if not St.xray then return end
                    pcall(xrayPart, d)
                    n = n + 1
                    if n % 2000 == 0 then task.wait() end
                end
            end)
        else
            for p, v in pairs(xrayOrig) do pcall(function() p.LocalTransparencyModifier = v end); xrayOrig[p] = nil end
        end
    end

    -- 4g. clean vision (fixed: PostEffects are disabled, Atmosphere density is lowered; nothing errors on Sky)
    local effectOrig = setmetatable({}, { __mode = "k" })
    local function restoreLight()
        for k, v in pairs(O.Light) do
            if not (k == "ClockTime" and Over.timeOfDay) then pcall(function() Lighting[k] = v end) end
        end
        for e, st in pairs(effectOrig) do
            pcall(function()
                if st.kind == "post" then e.Enabled = st.v else e.Density, e.Haze = st.d, st.h end
            end)
            effectOrig[e] = nil
        end
    end
    local function setClean(on)
        if not on then restoreLight() return end
        pcall(function()
            Lighting.Brightness, Lighting.GlobalShadows, Lighting.FogEnd = 2, false, 100000
            Lighting.Ambient, Lighting.OutdoorAmbient = Color3.new(1, 1, 1), Color3.new(1, 1, 1)
            if not Over.timeOfDay then Lighting.ClockTime = 14 end
        end)
        for _, e in ipairs(Lighting:GetDescendants()) do
            pcall(function()
                if e:IsA("PostEffect") and effectOrig[e] == nil then
                    effectOrig[e] = { kind = "post", v = e.Enabled }; e.Enabled = false
                elseif e:IsA("Atmosphere") and effectOrig[e] == nil then
                    effectOrig[e] = { kind = "atmo", d = e.Density, h = e.Haze }; e.Density = 0; e.Haze = 0
                end
            end)
        end
    end

    -- 4h. fast interact (event-driven; no per-frame workspace scan)
    local promptOrig = setmetatable({}, { __mode = "k" })
    local fiConn
    local function fastPrompt(p)
        if p:IsA("ProximityPrompt") and promptOrig[p] == nil then promptOrig[p] = p.HoldDuration; p.HoldDuration = 0 end
    end
    local function setFastInteract(on)
        if fiConn then fiConn:Disconnect(); fiConn = nil end
        if on then
            fiConn = Workspace.DescendantAdded:Connect(function(d) if St.fastinteract then pcall(fastPrompt, d) end end)
            task.spawn(function()
                local n = 0
                for _, d in ipairs(Workspace:GetDescendants()) do
                    if not St.fastinteract then return end
                    pcall(fastPrompt, d)
                    n = n + 1
                    if n % 2000 == 0 then task.wait() end
                end
            end)
        else
            for p, v in pairs(promptOrig) do pcall(function() p.HoldDuration = v end); promptOrig[p] = nil end
        end
    end

    -- 4i. low graphics (recorded + restored)
    local gfxOrig = setmetatable({}, { __mode = "k" })
    local gfxLight, gfxConn
    local function gfxObj(v)
        pcall(function()
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Smoke") then
                if gfxOrig[v] == nil then gfxOrig[v] = { "Enabled", v.Enabled } end
                v.Enabled = false
            elseif v:IsA("Decal") or v:IsA("Texture") then
                if gfxOrig[v] == nil then gfxOrig[v] = { "Transparency", v.Transparency } end
                v.Transparency = 1
            end
        end)
    end
    local function setLowGfx(on)
        if gfxConn then gfxConn:Disconnect(); gfxConn = nil end
        if on then
            gfxLight = gfxLight or { Lighting.GlobalShadows }
            Lighting.GlobalShadows = false
            gfxConn = Workspace.DescendantAdded:Connect(gfxObj)
            task.spawn(function()
                local n = 0
                for _, v in ipairs(Workspace:GetDescendants()) do
                    if not St.lowgfx then return end
                    gfxObj(v)
                    n = n + 1
                    if n % 2500 == 0 then task.wait() end
                end
            end)
        else
            if gfxLight then pcall(function() Lighting.GlobalShadows = gfxLight[1] end); gfxLight = nil end
            for v, st in pairs(gfxOrig) do pcall(function() v[st[1]] = st[2] end); gfxOrig[v] = nil end
        end
    end

    -- 4j. immediate-number features + their resets
    local Restore = {
        gravity = function() Workspace.Gravity = O.Gravity end,
        fov = function() local c = cam(); if c then c.FieldOfView = O.FOV end end,
        zoom = function() LP.CameraMaxZoomDistance, LP.CameraMinZoomDistance = O.ZoomMax, O.ZoomMin end,
        timeOfDay = function() Lighting.ClockTime = O.Light.ClockTime end,
        hipHeight = function() local h = hum(); if h and O.Hip ~= nil then h.HipHeight = O.Hip end; O.Hip = nil end,
    }
    local function resetNumber(id)
        local fn = Restore[id]
        if fn then pcall(fn) end
        Over[id] = nil
        St[id] = DefById[id].default
        refreshFeature(id)
    end

    -- 4k. view / spectate
    local function setView(p)
        S.View = p
        if not p then
            local h, c = hum(), cam()
            if h and c then c.CameraSubject = h end
        end
    end

    -- 4l. anti-afk, infinite jump, click-tp, fast loops
    conn(UserInputService.JumpRequest, function()
        if St.infjump then local h = hum(); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end
    end)
    conn(LP.Idled, function()
        if St.antiafk then
            pcall(function()
                local vu = game:GetService("VirtualUser")
                vu:CaptureController(); vu:ClickButton2(Vector2.new())
            end)
        end
    end)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    conn(UserInputService.InputBegan, function(input, gp)
        if gp or not St.clicktp then return end
        local isTouch = input.UserInputType == Enum.UserInputType.Touch
        local isCtrlClick = input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
        if not (isTouch or isCtrlClick) then return end
        local c = cam()
        if not (c and root()) then return end
        local ray = c:ScreenPointToRay(input.Position.X, input.Position.Y)
        rayParams.FilterDescendantsInstances = { LP.Character }
        local hit = Workspace:Raycast(ray.Origin, ray.Direction * 2000, rayParams)
        if hit then Teleport(CFrame.new(hit.Position + Vector3.new(0, 3, 0))) end
    end)

    -- one cheap loop enforces everything games like to reset
    conn(RunService.Heartbeat, function(dt)
        local h, r = hum(), root()
        if h then
            if St.speedOn and h.WalkSpeed ~= St.walkSpeed then h.WalkSpeed = St.walkSpeed end
            if St.jumpOn then
                if not h.UseJumpPower then h.UseJumpPower = true end
                if h.JumpPower ~= St.jumpPower then h.JumpPower = St.jumpPower end
            end
            if Over.hipHeight and h.HipHeight ~= St.hipHeight then h.HipHeight = St.hipHeight end
            if St.god and h.Health > 0 and h.Health < h.MaxHealth then h.Health = h.MaxHealth end
            if St.tpwalkOn and r and h.MoveDirection.Magnitude > 0 then r.CFrame = r.CFrame + h.MoveDirection * St.tpwalkSpeed * dt end
        end
        local c = cam()
        if c then
            if Over.fov and c.FieldOfView ~= St.fov then c.FieldOfView = St.fov end
            if S.View then
                local vc = S.View.Character
                local vh = vc and vc:FindFirstChildOfClass("Humanoid")
                if vh and c.CameraSubject ~= vh then c.CameraSubject = vh end
            end
        end
    end)

    -- auto aim (nearest non-teammate within range; team check added)
    local function nearestEnemyPart(range)
        local r = root()
        if not r then return nil end
        local best, bestD = nil, range or math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            local ch = p.Character
            if p ~= LP and ch and not (p.Team ~= nil and p.Team == LP.Team) then
                local hrp, head, h = ch:FindFirstChild("HumanoidRootPart"), ch:FindFirstChild("Head"), ch:FindFirstChildOfClass("Humanoid")
                if hrp and h and h.Health > 0 then
                    local d = (hrp.Position - r.Position).Magnitude
                    if d < bestD then best, bestD = head or hrp, d end
                end
            end
        end
        return best
    end
    conn(RunService.RenderStepped, function()
        if not St.aim then return end
        local target, c = nearestEnemyPart(St.aimRange), cam()
        if target and c then c.CFrame = CFrame.lookAt(c.CFrame.Position, target.Position) end
    end)

    -- 4m. appliers used by Set()
    Apply.fly = function(on) if on then startFly() else stopFly() end end
    Apply.noclip = function(on) if not on then restoreNoclip() end end
    Apply.speedOn, Apply.walkSpeed = applySpeed, applySpeed
    Apply.jumpOn, Apply.jumpPower = applyJump, applyJump
    Apply.god = function(on) if on then local h = hum(); if h and h.Health > 0 then h.Health = h.MaxHealth end end end
    Apply.esp, Apply.xray, Apply.clean = setEsp, setXray, setClean
    Apply.fastinteract, Apply.lowgfx = setFastInteract, setLowGfx
    Apply.gravity = function(v) Over.gravity = true; Workspace.Gravity = v end
    Apply.fov = function(v) Over.fov = true; local c = cam(); if c then c.FieldOfView = v end end
    Apply.zoom = function(v) Over.zoom = true; LP.CameraMaxZoomDistance = v end
    Apply.timeOfDay = function(v) Over.timeOfDay = true; Lighting.ClockTime = v end
    Apply.hipHeight = function(v)
        Over.hipHeight = true
        local h = hum()
        if h then if O.Hip == nil then O.Hip = h.HipHeight end; h.HipHeight = v end
    end
    local function applyMusic()
        local s = SoundService:FindFirstChild("BrinelandHiddenMusic")
        if St.music then
            s = s or EnsureHiddenMusic()
            s.Volume = St.musicVolume / 100
            if not s.IsPlaying then pcall(function() s:Play() end) end
        elseif s then
            pcall(function() s:Pause() end)
        end
    end
    Apply.music, Apply.musicVolume = applyMusic, applyMusic

    local function applyCharacter()
        if St.fly then startFly() end
        applySpeed(); applyJump()
        if Over.hipHeight then Apply.hipHeight(St.hipHeight) end
        if St.god then Apply.god(true) end
    end

    local function restoreAll()
        for _, d in ipairs(Defs) do
            if d.kind == "toggle" and d.id ~= "music" and d.id ~= "antiafk" and St[d.id] then
                St[d.id] = false
                pcall(Apply[d.id], false)
                refreshFeature(d.id)
            end
        end
        for id in pairs(Over) do resetNumber(id) end
        stopFly(); restoreNoclip(); restoreLight(); setView(nil)
    end

    -- 4n. server helpers
    local function rejoin()
        say("Rejoining...")
        if #Players:GetPlayers() <= 1 then
            LP:Kick("\nRejoining...")
            task.wait()
            TeleportService:Teleport(game.PlaceId, LP)
        else
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
        end
    end
    env.BrinelandVisited = env.BrinelandVisited or {}
    local function serverHop()
        say("Searching for a server...")
        task.spawn(function()
            local visited = env.BrinelandVisited
            visited[game.JobId] = true
            local ok, body = pcall(function()
                return game:HttpGet(("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100&excludeFullGames=true"):format(game.PlaceId))
            end)
            local data = ok and select(2, pcall(function() return HttpService:JSONDecode(body) end))
            local good = {}
            if type(data) == "table" and type(data.data) == "table" then
                for _, s in ipairs(data.data) do
                    if s.id ~= game.JobId and not visited[s.id] and s.playing < s.maxPlayers then good[#good + 1] = s.id end
                end
            end
            if #good == 0 then table.clear(visited); say("No new server found."); return end
            local pick = good[math.random(#good)]
            visited[pick] = true
            pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, pick, LP) end)
        end)
    end

    ---------------------------------------------------------------------
    -- 5. COMMANDS (generated from the same features + extras)
    ---------------------------------------------------------------------
    local Cmds, Order = {}, {}
    local function reg(names, usage, desc, fn)
        if type(names) == "string" then names = { names } end
        local c = { name = names[1], names = names, usage = usage, desc = desc, fn = fn }
        table.insert(Order, c)
        for _, n in ipairs(names) do Cmds[n] = c end
    end

    local function findPlayers(q)
        q = (q or "me"):lower()
        if q == "me" then return { LP } end
        local others, out = {}, {}
        for _, p in ipairs(Players:GetPlayers()) do if p ~= LP then others[#others + 1] = p end end
        if q == "others" then return others end
        if q == "all" then return Players:GetPlayers() end
        if q == "random" then if #others > 0 then out[1] = others[math.random(#others)] end return out end
        if q == "nearest" or q == "near" then
            local r, best, bestD = root(), nil, math.huge
            for _, p in ipairs(others) do
                local pr = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                if r and pr and (pr.Position - r.Position).Magnitude < bestD then best, bestD = p, (pr.Position - r.Position).Magnitude end
            end
            if best then out[1] = best end
            return out
        end
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Name:lower():sub(1, #q) == q or p.DisplayName:lower():sub(1, #q) == q then out[#out + 1] = p end
        end
        if #out == 0 then
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Name:lower():find(q, 1, true) or p.DisplayName:lower():find(q, 1, true) then out[#out + 1] = p end
            end
        end
        return out
    end
    local function firstTarget(a)
        local list = findPlayers(a[1])
        if #list == 0 then say("No player matches '" .. tostring(a[1]) .. "'.") return nil end
        return list[1]
    end

    -- toggle features -> "on" and "off" commands (id, on names, off names, linked number, default arg, description)
    local TOGGLE_CMDS = {
        { "fly", { "fly" }, { "unfly" }, "flySpeed", nil, "Fly (thumbstick/WASD, Space+E up, Shift+Q down)" },
        { "noclip", { "noclip" }, { "clip", "unnoclip" }, nil, nil, "Walk through walls" },
        { "speedOn", { "speed", "ws", "walkspeed" }, { "unspeed", "unws" }, "walkSpeed", 50, "Set walk speed" },
        { "tpwalkOn", { "tpwalk" }, { "untpwalk" }, "tpwalkSpeed", nil, "Speed that games can't reset" },
        { "jumpOn", { "jumppower", "jp" }, { "unjumppower", "unjp" }, "jumpPower", nil, "Set jump power" },
        { "infjump", { "infjump" }, { "uninfjump" }, nil, nil, "Jump in mid-air" },
        { "god", { "god" }, { "ungod" }, nil, nil, "Keep HP full (client-side only)" },
        { "antiafk", { "antiafk" }, { "unantiafk" }, nil, nil, "Don't get kicked for idling" },
        { "clicktp", { "clicktp" }, { "unclicktp" }, nil, nil, "Ctrl+click (PC) / tap (phone) to teleport" },
        { "esp", { "esp" }, { "unesp" }, nil, nil, "Highlight players with name + distance" },
        { "xray", { "xray" }, { "unxray" }, nil, nil, "See through walls (client-side)" },
        { "clean", { "fullbright", "fb", "clean" }, { "unfullbright", "unfb", "unclean" }, nil, nil, "Bright, no shadows or fog" },
        { "aim", { "aim", "autoaim" }, { "unaim", "unautoaim" }, "aimRange", nil, "Lock camera on nearest enemy" },
        { "fastinteract", { "fastinteract", "fi" }, { "unfastinteract", "unfi" }, nil, nil, "Instant proximity prompts" },
        { "lowgfx", { "lowgfx", "fpsboost" }, { "unlowgfx", "unfpsboost" }, nil, nil, "Low graphics for more FPS" },
        { "music", { "music" }, { "unmusic", "mute" }, "musicVolume", nil, "Background music on" },
    }
    for _, t in ipairs(TOGGLE_CMDS) do
        local id, onNames, offNames, numId, defArg, desc = t[1], t[2], t[3], t[4], t[5], t[6]
        local label = DefById[id].label
        reg(onNames, numId and "[n]" or "", desc, function(a)
            if numId then
                if a[1] then Set(numId, a[1])
                elseif defArg and St[numId] == DefById[numId].default then Set(numId, defArg) end
            end
            Set(id, true)
            say(label .. " ON" .. (numId and (" (" .. tostring(St[numId]) .. ")") or ""))
        end)
        reg(offNames, "", "Stop: " .. label, function() Set(id, false); say(label .. " OFF") end)
    end

    -- number features -> set / reset commands
    local function numberCmd(names, resetNames, id, desc)
        reg(names, "[n]", desc, function(a)
            local d = DefById[id]
            Set(id, a[1] and a[1] or d.default)
            say(d.label .. " = " .. tostring(St[id]))
        end)
        reg(resetNames, "", "Restore " .. DefById[id].label, function() resetNumber(id); say(DefById[id].label .. " restored") end)
    end
    numberCmd({ "gravity", "grav" }, { "ungravity" }, "gravity", "Set gravity")
    numberCmd({ "hipheight" }, { "unhipheight" }, "hipHeight", "Set hip height")
    numberCmd({ "fov" }, { "unfov" }, "fov", "Set field of view")
    numberCmd({ "zoom" }, { "unzoom" }, "zoom", "Allow zooming out further")
    numberCmd({ "time" }, { "resettime" }, "timeOfDay", "Set time of day (0-24)")
    reg("day", "", "Set daytime", function() Set("timeOfDay", 14) end)
    reg("night", "", "Set night", function() Set("timeOfDay", 0) end)

    -- character
    reg("sit", "", "Sit down", function() local h = hum(); if h then h.Sit = true end end)
    reg("jump", "", "Jump once", function() local h = hum(); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end)
    reg({ "reset", "respawn" }, "", "Reset your character", function() local h = hum(); if h then h.Health = 0 end end)
    reg({ "refresh", "re" }, "", "Respawn in the same spot", function()
        local r, h = root(), hum()
        if not (r and h) then return end
        local cf = r.CFrame
        task.spawn(function()
            h.Health = 0
            local newChar = LP.CharacterAdded:Wait()
            local nr = newChar:WaitForChild("HumanoidRootPart", 10)
            if nr then task.wait(0.15); nr.CFrame = cf end
        end)
    end)

    -- teleport + waypoints (shared with the TP tab)
    reg({ "goto", "to" }, "[player]", "Teleport to a player", function(a)
        local p = firstTarget(a); if not p then return end
        local cf = targetCF(p)
        if cf then Teleport(cf); say("Teleported to " .. p.Name) end
    end)
    reg("walkto", "[player]", "Walk to a player", function(a)
        local p = firstTarget(a); if not p then return end
        local cf = targetCF(p)
        if cf then WalkTo(cf.Position); say("Walking to " .. p.Name) end
    end)
    reg({ "tweento", "tgoto" }, "[player]", "Glide to a player", function(a)
        local p = firstTarget(a); if not p then return end
        local cf = targetCF(p)
        if cf then TweenTo(cf); say("Gliding to " .. p.Name) end
    end)
    reg("back", "", "Return to where you were before the last teleport", TeleportBack)
    reg("spawn", "", "Teleport to the spawn point", TeleportSpawn)
    reg({ "swp", "setwaypoint" }, "[name]", "Save your position as a waypoint", function(a) addWaypoint(a[1]) end)
    reg({ "gwp", "gotowaypoint" }, "[name]", "Teleport to a waypoint", function(a)
        local _, w = wpIndex(a[1] or "")
        if w then Teleport(wpCF(w)); say("Went to '" .. w.name .. "'") else say("No such waypoint.") end
    end)
    reg({ "dwp", "deletewaypoint" }, "[name]", "Delete a waypoint", function(a)
        if a[1] and deleteWaypoint(a[1]) then say("Deleted '" .. a[1] .. "'") else say("No such waypoint.") end
    end)
    reg({ "cwp", "clearwaypoints" }, "", "Delete all waypoints here", function()
        Save.waypoints[tostring(game.PlaceId)] = {}; markDirty(); wpRefresh(); say("Waypoints cleared")
    end)
    reg({ "wps", "waypoints" }, "", "List waypoints", function()
        local names = {}
        for _, w in ipairs(wpList()) do names[#names + 1] = w.name end
        say(#names > 0 and ("Waypoints: " .. table.concat(names, ", ")) or "No waypoints saved here.")
    end)

    -- players / camera
    reg({ "view", "spectate" }, "[player]", "Watch a player", function(a)
        local p = firstTarget(a); if p then setView(p); say("Viewing " .. p.Name) end
    end)
    reg("unview", "", "Stop watching", function() setView(nil); say("View reset") end)

    -- utility
    reg("rejoin", "", "Rejoin this server", rejoin)
    reg({ "serverhop", "shop" }, "", "Join a different server", serverHop)
    reg("copyplaceid", "", "Copy the place ID", function() copyText(game.PlaceId) end)
    reg("copyjobid", "", "Copy the server job ID", function() copyText(game.JobId) end)
    reg("copypos", "", "Copy your position", function()
        local r = root(); if r then local p = r.Position; copyText(string.format("%.1f, %.1f, %.1f", p.X, p.Y, p.Z)) end
    end)
    reg("pos", "", "Show your position", function()
        local r = root(); if r then local p = r.Position; say(string.format("Position: %.1f, %.1f, %.1f", p.X, p.Y, p.Z)) end
    end)
    reg("copyname", "[player]", "Copy a player's username", function(a) local p = firstTarget(a); if p then copyText(p.Name) end end)
    reg("copyid", "[player]", "Copy a player's user ID", function(a) local p = firstTarget(a); if p then copyText(p.UserId) end end)
    reg("tab", "[name]", "Open a hub tab (home, info, tp, player, cheats, visuals, cmd, keys, misc)", function(a)
        if a[1] then SelectTab(a[1]) end
    end)
    reg("save", "", "Save settings now", function() persistNow(); say("Settings saved.") end)
    reg("restoreall", "", "Turn every feature off and restore the game", function() restoreAll(); say("Everything restored.") end)

    -- aliases
    reg("alias", "[name] [command...]", "Make a shortcut, e.g. alias f fly 80", function(a, rest)
        local name = a[1] and a[1]:lower()
        local value = rest:match("^%S+%s+(.+)$")
        if not (name and value) then say("Usage: alias [name] [command...]") return end
        if Cmds[name] then say("'" .. name .. "' is already a command.") return end
        Save.aliases[name] = value; markDirty(); say("Alias '" .. name .. "' = " .. value)
    end)
    reg("unalias", "[name]", "Delete an alias", function(a)
        local name = a[1] and a[1]:lower()
        if name and Save.aliases[name] then Save.aliases[name] = nil; markDirty(); say("Alias removed") else say("No such alias.") end
    end)
    reg("aliases", "", "List aliases", function()
        local out = {}
        for n, v in pairs(Save.aliases) do out[#out + 1] = n .. "=" .. v end
        table.sort(out)
        say(#out > 0 and table.concat(out, " | ") or "No aliases yet.")
    end)
    reg({ "cmds", "help" }, "", "Show all commands (clear the box to browse)", function() SelectTab("CMD"); say(#Order .. " commands. Clear the box to browse them all.") end)
    reg({ "unload", "closehub" }, "", "Turn everything off and close the hub", function() U.Destroy() end)

    table.sort(Order, function(x, y) return x.name < y.name end)

    local runLine
    local function runOne(part, depth)
        part = part:gsub("^;", "")
        local tokens = {}
        for tkn in part:gmatch("%S+") do tokens[#tokens + 1] = tkn end
        if #tokens == 0 then return end
        local name = table.remove(tokens, 1):lower()
        local rest = table.concat(tokens, " ")
        local aliasValue = Save.aliases[name]
        if aliasValue and not Cmds[name] then
            runLine(aliasValue .. (rest ~= "" and (" " .. rest) or ""), depth + 1)
            return
        end
        local cmd = Cmds[name]
        if not cmd then say("Unknown command: " .. name) return end
        local ok, err = pcall(cmd.fn, tokens, rest)
        if not ok then say("Error in '" .. name .. "': " .. tostring(err)) end
    end
    runLine = function(line, depth)
        depth = depth or 0
        if depth > 4 then say("Alias loop stopped.") return end
        for part in (line .. "&&"):gmatch("(.-)&&") do
            part = part:match("^%s*(.-)%s*$")
            if part ~= "" then runOne(part, depth) end
        end
    end

    ---------------------------------------------------------------------
    -- 6. UI CORE
    ---------------------------------------------------------------------
    for _, n in ipairs({ "BrinelandUniversalHub", "BrinelandIYLite" }) do
        local old = PlayerGui:FindFirstChild(n)
        if old then old:Destroy() end
    end
    local gui = mk("ScreenGui", { Name = "BrinelandUniversalHub", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 50 }, PlayerGui)
    table.insert(U.Guis, gui)

    local vp0 = viewport()
    local HUB_W = math.clamp(vp0.X - 24, 300, 420)
    local HUB_H = math.clamp(vp0.Y - 24, 230, 315)

    local Main = mk("Frame", {
        Size = UDim2.fromOffset(HUB_W, 0), Position = UDim2.fromOffset(16, 48), BackgroundColor3 = Theme.Black,
        BackgroundTransparency = 0.06, BorderSizePixel = 0, Active = true, ClipsDescendants = true,
    }, gui)
    round(Main, 12); stroke(Main, 0, 1.5)
    TweenService:Create(Main, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(HUB_W, HUB_H) }):Play()

    local TopBar = mk("Frame", { Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = Theme.DarkGray, BackgroundTransparency = 0.1, BorderSizePixel = 0 }, Main)
    round(TopBar, 12)
    mk("TextLabel", {
        Size = UDim2.new(1, -140, 1, 0), Position = UDim2.fromOffset(12, 0), BackgroundTransparency = 1, Text = "Brineland",
        TextColor3 = Theme.White, Font = FANCY_FONT, TextSize = 19, TextXAlignment = Enum.TextXAlignment.Left,
    }, TopBar)
    makeDraggable(TopBar, Main)

    local HomeBtn = mk("TextButton", {
        Size = UDim2.fromOffset(50, 24), Position = UDim2.new(1, -120, 0.5, -12), BackgroundColor3 = Theme.White,
        Text = "Home", TextColor3 = Theme.Black, Font = BODY_FONT, TextSize = 9.5,
    }, TopBar)
    round(HomeBtn, 12)
    local ArrowBtn = mk("TextButton", {
        Size = UDim2.fromOffset(26, 26), Position = UDim2.new(1, -62, 0.5, -13), BackgroundColor3 = Theme.MidGray,
        Text = "▼", TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 10,
    }, TopBar)
    round(ArrowBtn, 13); stroke(ArrowBtn, 0.2)
    local CloseBtn = mk("TextButton", {
        Size = UDim2.fromOffset(26, 26), Position = UDim2.new(1, -32, 0.5, -13), BackgroundColor3 = Theme.MidGray,
        Text = "X", TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 11,
    }, TopBar)
    round(CloseBtn, 13); stroke(CloseBtn, 0.2)

    local topDivider = mk("Frame", { Size = UDim2.new(1, -14, 0, 1), Position = UDim2.new(0, 7, 0, 40), BackgroundColor3 = Theme.White, BorderSizePixel = 0 }, Main)
    local TabBar = mk("ScrollingFrame", {
        Size = UDim2.new(1, -14, 0, 28), Position = UDim2.new(0, 7, 0, 44), BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 2, ScrollBarImageColor3 = Theme.White, ScrollingDirection = Enum.ScrollingDirection.X,
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.X,
    }, Main)
    mk("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4) }, TabBar)
    local tabDivider = mk("Frame", { Size = UDim2.new(1, -14, 0, 1), Position = UDim2.new(0, 7, 0, 75), BackgroundColor3 = Theme.White, BorderSizePixel = 0 }, Main)

    local TabMeta, Tabs = {}, {}
    local activeTab, collapsed = "Home", false

    SelectTab = function(name)
        local key
        for n in pairs(TabMeta) do if n:lower() == tostring(name):lower() then key = n break end end
        if not key then say("No tab called '" .. tostring(name) .. "'.") return end
        activeTab = key
        Main.Visible = true
        for n, m in pairs(TabMeta) do
            local on = (n == key)
            m.Container.Visible = on
            if m.Button then
                TweenService:Create(m.Button, TweenInfo.new(0.16), { BackgroundColor3 = on and Theme.White or Theme.DarkGray, TextColor3 = on and Theme.Black or Theme.SubText }):Play()
            end
        end
        TweenService:Create(HomeBtn, TweenInfo.new(0.16), { BackgroundColor3 = (key == "Home") and Theme.White or Theme.MidGray, TextColor3 = (key == "Home") and Theme.Black or Theme.White }):Play()
    end

    -- kind: "list" (auto-stacked, scrolls) | "canvas" (manual layout, scrolls) | "frame" (manual layout, fixed)
    local function CreateTab(name, width, inBar, kind)
        local btn
        if inBar then
            btn = mk("TextButton", { Size = UDim2.fromOffset(width or 56, 24), BackgroundColor3 = Theme.DarkGray, Text = name, TextColor3 = Theme.SubText, Font = BODY_FONT, TextSize = 9 }, TabBar)
            round(btn, 12); stroke(btn, 0.35)
            conn(btn.Activated, function() SelectTab(name) end)
        end
        local container
        if kind == "frame" then
            container = mk("Frame", { Size = UDim2.new(1, -14, 1, -83), Position = UDim2.new(0, 7, 0, 80), BackgroundTransparency = 1, Visible = false }, Main)
        else
            container = mk("ScrollingFrame", {
                Size = UDim2.new(1, -14, 1, -83), Position = UDim2.new(0, 7, 0, 80), BackgroundTransparency = 1, BorderSizePixel = 0,
                ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.White, CanvasSize = UDim2.new(), Visible = false,
            }, Main)
            if kind == "canvas" then
                container.CanvasSize = UDim2.new(0, 0, 0, 400)
            else
                local layout = mk("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, container)
                conn(layout:GetPropertyChangedSignal("AbsoluteContentSize"), function()
                    container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 12)
                end)
            end
        end
        Tabs[name] = container
        TabMeta[name] = { Button = btn, Container = container }
        return container
    end

    -- builders (all bound to the shared feature state)
    local function UISection(parent, text)
        local f = mk("TextLabel", { Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, Text = string.upper(text), TextColor3 = Theme.SubText, Font = BODY_FONT, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = LO(parent) }, parent)
        mk("UIPadding", { PaddingLeft = UDim.new(0, 4), PaddingTop = UDim.new(0, 4) }, f)
    end
    local function UIButton(parent, text, cb, color)
        local frame = mk("Frame", { Size = UDim2.new(1, -2, 0, 34), BackgroundColor3 = color or Theme.DarkGray, LayoutOrder = LO(parent) }, parent)
        round(frame, 17); stroke(frame)
        local btn = mk("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = text, TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 10.5 }, frame)
        conn(btn.Activated, function()
            TweenService:Create(frame, TweenInfo.new(0.1), { BackgroundColor3 = Theme.MidGray }):Play()
            task.delay(0.14, function()
                if frame.Parent then TweenService:Create(frame, TweenInfo.new(0.15), { BackgroundColor3 = color or Theme.DarkGray }):Play() end
            end)
            local ok, err = pcall(cb)
            if not ok then say("Error: " .. tostring(err)) end
        end)
        return btn
    end
    local function UILabel(parent, text)
        local f = mk("Frame", { Size = UDim2.new(1, -2, 0, 28), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Theme.DarkGray, LayoutOrder = LO(parent) }, parent)
        round(f, 8); stroke(f)
        mk("UIPadding", { PaddingTop = UDim.new(0, 6), PaddingBottom = UDim.new(0, 6), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }, f)
        return mk("TextLabel", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Text = text, TextColor3 = Theme.SubText, Font = BODY_FONT, TextSize = 10, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top }, f)
    end
    local function UIToggle(parent, id, labelOverride)
        local d = DefById[id]
        local frame = mk("Frame", { Size = UDim2.new(1, -2, 0, 36), BackgroundColor3 = Theme.DarkGray, LayoutOrder = LO(parent) }, parent)
        round(frame, 8); stroke(frame)
        mk("TextLabel", { Size = UDim2.new(1, -60, 1, 0), Position = UDim2.fromOffset(10, 0), BackgroundTransparency = 1, Text = labelOverride or d.label, TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 10.5, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd }, frame)
        local bg = mk("Frame", { Size = UDim2.fromOffset(38, 20), Position = UDim2.new(1, -46, 0.5, -10), BackgroundColor3 = Theme.MidGray }, frame)
        round(bg, 10); stroke(bg, 0.3)
        local knob = mk("Frame", { Size = UDim2.fromOffset(16, 16), Position = UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = Theme.White }, bg)
        round(knob, 8)
        local btn = mk("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "" }, frame)
        local function refresh()
            local on = St[id]
            TweenService:Create(knob, TweenInfo.new(0.18, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Position = on and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8), BackgroundColor3 = on and Theme.Black or Theme.White }):Play()
            TweenService:Create(bg, TweenInfo.new(0.18), { BackgroundColor3 = on and Theme.White or Theme.MidGray }):Play()
        end
        bindRefresh(id, refresh); refresh()
        conn(btn.Activated, function() Set(id, not St[id]) end)
    end
    local function UISlider(parent, id)
        local d = DefById[id]
        local frame = mk("Frame", { Size = UDim2.new(1, -2, 0, 44), BackgroundColor3 = Theme.DarkGray, LayoutOrder = LO(parent) }, parent)
        round(frame, 8); stroke(frame)
        local lbl = mk("TextLabel", { Size = UDim2.new(1, -52, 0, 18), Position = UDim2.fromOffset(10, 3), BackgroundTransparency = 1, TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left }, frame)
        local track = mk("Frame", { Size = UDim2.new(1, -20, 0, 8), Position = UDim2.new(0, 10, 0, 28), BackgroundColor3 = Theme.MidGray }, frame)
        round(track, 4)
        local fill = mk("Frame", { Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Theme.White }, track)
        round(fill, 4)
        local function show()
            local v = St[id]
            fill.Size = UDim2.new(math.clamp((v - d.min) / (d.max - d.min), 0, 1), 0, 1, 0)
            lbl.Text = d.label .. ": " .. tostring(math.floor(v * 10 + 0.5) / 10)
        end
        bindRefresh(id, show); show()
        if d.reset then
            local rb = mk("TextButton", { Size = UDim2.fromOffset(40, 18), Position = UDim2.new(1, -46, 0, 3), BackgroundColor3 = Theme.MidGray, Text = "RESET", TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 8 }, frame)
            round(rb, 9)
            conn(rb.Activated, function() resetNumber(id) end)
        end
        local sliding
        local function setFrom(x)
            local rel = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
            Set(id, d.min + (d.max - d.min) * rel)
        end
        conn(track.InputBegan, function(i)
            if isPointer(i) and not sliding then
                sliding = i
                parent.ScrollingEnabled = false   -- don't scroll the page while sliding
                setFrom(i.Position.X)
            end
        end)
        conn(UserInputService.InputChanged, function(i)
            if sliding and (i == sliding or (sliding.UserInputType == Enum.UserInputType.MouseButton1 and i.UserInputType == Enum.UserInputType.MouseMovement)) then setFrom(i.Position.X) end
        end)
        conn(UserInputService.InputEnded, function(i)
            if sliding and (i == sliding or (sliding.UserInputType == Enum.UserInputType.MouseButton1 and i.UserInputType == Enum.UserInputType.MouseButton1)) then
                sliding = nil
                parent.ScrollingEnabled = true
            end
        end)
    end
    local function UIInput(parent, placeholder)
        local box = mk("TextBox", { Size = UDim2.new(1, -2, 0, 32), BackgroundColor3 = Theme.DarkGray, PlaceholderText = placeholder, PlaceholderColor3 = Theme.SubText, Text = "", TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 11, ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = LO(parent) }, parent)
        round(box, 16); stroke(box)
        mk("UIPadding", { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 8) }, box)
        return box
    end
    local function fillPills(frame, defs, y, h)
        local n = #defs
        for i, p in ipairs(defs) do
            local b = mk("TextButton", { Size = UDim2.new(1 / n, -4, 0, h), Position = UDim2.new((i - 1) / n, 2, 0, y), BackgroundColor3 = Theme.MidGray, Text = p[1], TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 10 }, frame)
            round(b, h / 2); stroke(b, 0.3)
            conn(b.Activated, function() local ok, err = pcall(p[2]); if not ok then say("Error: " .. tostring(err)) end end)
        end
    end
    local function UIPillRow(parent, defs)
        local f = mk("Frame", { Size = UDim2.new(1, -2, 0, 40), BackgroundColor3 = Theme.DarkGray, LayoutOrder = LO(parent) }, parent)
        round(f, 20); stroke(f)
        fillPills(f, defs, 4, 32)
        return f
    end

    -- tabs (bar order); Home is opened from the top-right Home button
    local HomeT   = CreateTab("Home", 0, false, "canvas")
    local InfoT   = CreateTab("Info", 50, true, "list")
    local TPT     = CreateTab("TP", 44, true, "list")
    local PlayerT = CreateTab("Player", 60, true, "list")
    local CheatsT = CreateTab("Cheats", 60, true, "list")
    local VisualT = CreateTab("Visuals", 64, true, "list")
    local CmdT    = CreateTab("CMD", 48, true, "frame")
    local KeysT   = CreateTab("Keys", 48, true, "list")
    local MiscT   = CreateTab("Misc", 48, true, "list")

    ---------------------------------------------------------------------
    -- 7. TABS
    ---------------------------------------------------------------------
    -- HOME ------------------------------------------------------------
    do
        local function text(props) props.BackgroundTransparency = 1; props.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left; return mk("TextLabel", props, HomeT) end
        text({ Size = UDim2.new(0.62, 0, 0, 34), Position = UDim2.new(0, 6, 0, 2), Text = "Welcome back to\nBRINELAND HUB", TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 13, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top })
        text({ Size = UDim2.new(0.62, 0, 0, 56), Position = UDim2.new(0, 6, 0, 38), Text = "Teleports, waypoints, player warp, fly & ESP.\nType commands in the CMD tab (try: fly 80).\nWorks on PC and phone.\nRightShift hides the panel.", TextColor3 = Theme.SubText, Font = Enum.Font.Gotham, TextSize = 9.5, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top })

        local badge = mk("Frame", { Size = UDim2.new(0.35, -6, 0, 88), Position = UDim2.new(0.65, 2, 0, 4), BackgroundColor3 = Theme.DarkGray }, HomeT)
        round(badge, 10); stroke(badge)
        mk("TextLabel", { Size = UDim2.new(1, -10, 0, 26), Position = UDim2.new(0, 5, 0, 8), BackgroundTransparency = 1, Text = "BRINELAND", TextColor3 = Theme.White, Font = FANCY_FONT, TextSize = 16 }, badge)
        mk("TextLabel", { Size = UDim2.new(1, -10, 0, 44), Position = UDim2.new(0, 5, 0, 36), BackgroundTransparency = 1, Text = "UNIVERSAL V2\n@" .. LP.Name, TextColor3 = Theme.SubText, Font = BODY_FONT, TextSize = 8.5, TextWrapped = true }, badge)

        local social = mk("Frame", { Size = UDim2.new(1, -8, 0, 32), Position = UDim2.new(0, 4, 0, 100), BackgroundTransparency = 1 }, HomeT)
        local function socialBtn(xs, xo, label, link, copied)
            local b = mk("TextButton", { Size = UDim2.new(0.49, -2, 1, 0), Position = UDim2.new(xs, xo, 0, 0), BackgroundColor3 = Theme.DarkGray, Text = label, TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 10 }, social)
            round(b, 8); stroke(b)
            conn(b.Activated, function()
                if not setclip then return end
                pcall(setclip, link)
                b.Text, b.BackgroundColor3, b.TextColor3 = copied, Theme.White, Theme.Black
                task.delay(1.4, function()
                    if U.Alive and b.Parent then b.Text, b.BackgroundColor3, b.TextColor3 = label, Theme.DarkGray, Theme.White end
                end)
            end)
        end
        socialBtn(0, 0, "DISCORD", DISCORD_INVITE, "COPIED DISCORD!")
        socialBtn(0.51, 2, "YOUTUBE", YOUTUBE_URL, "COPIED YOUTUBE!")

        local function card(y, xs, xo, title, desc, target)
            local b = mk("TextButton", { Size = UDim2.new(0.49, -2, 0, 80), Position = UDim2.new(xs, xo, 0, y), BackgroundColor3 = Theme.DarkGray, Text = "", AutoButtonColor = false }, HomeT)
            round(b, 10); stroke(b)
            mk("TextLabel", { Size = UDim2.new(1, -16, 0, 22), Position = UDim2.new(0, 10, 0, 8), BackgroundTransparency = 1, Text = title, TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left }, b)
            mk("TextLabel", { Size = UDim2.new(1, -16, 0, 44), Position = UDim2.new(0, 10, 0, 32), BackgroundTransparency = 1, Text = desc, TextColor3 = Theme.SubText, Font = Enum.Font.Gotham, TextSize = 9.5, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top }, b)
            conn(b.Activated, function() SelectTab(target) end)
        end
        card(140, 0, 0, "Move & TP", "Saved waypoints, spawn, back, walk & tween", "TP")
        card(140, 0.51, 2, "Combat & ESP", "Auto aim, speed, fly, noclip & player ESP", "Cheats")
        card(228, 0, 0, "Commands", "Infinite-Yield style bar with autocomplete", "CMD")
        card(228, 0.51, 2, "Keybinds", "Bind any feature to a key, saved for next time", "Keys")

        mk("TextLabel", { Size = UDim2.new(1, -8, 0, 16), Position = UDim2.new(0, 8, 0, 316), BackgroundTransparency = 1, Text = "QUICK TOGGLES", TextColor3 = Theme.SubText, Font = BODY_FONT, TextSize = 9, TextXAlignment = Enum.TextXAlignment.Left }, HomeT)
        local chips = { { "Fly", "fly" }, { "Noclip", "noclip" }, { "ESP", "esp" }, { "Speed", "speedOn" } }
        for i, c in ipairs(chips) do
            local b = mk("TextButton", { Size = UDim2.new(0.25, -4, 0, 30), Position = UDim2.new((i - 1) * 0.25, 2, 0, 336), BackgroundColor3 = Theme.DarkGray, Text = c[1], TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 10 }, HomeT)
            round(b, 15); stroke(b)
            bindRefresh(c[2], function()
                local on = St[c[2]]
                b.BackgroundColor3 = on and Theme.White or Theme.DarkGray
                b.TextColor3 = on and Theme.Black or Theme.White
            end)
            refreshFeature(c[2])
            conn(b.Activated, function() Set(c[2], not St[c[2]]) end)
        end
        HomeT.CanvasSize = UDim2.new(0, 0, 0, 380)
    end

    -- TP ---------------------------------------------------------------
    do
        UISection(TPT, "Saved positions")
        local nameBox = UIInput(TPT, "Name (optional)")
        UIButton(TPT, "Set Position", function() addWaypoint(nameBox.Text); nameBox.Text = "" end, Theme.MidGray)
        UIPillRow(TPT, {
            { "Spawn", TeleportSpawn }, { "Back", TeleportBack },
            { "Copy Pos", function() local r = root(); if r then local p = r.Position; copyText(string.format("%.1f, %.1f, %.1f", p.X, p.Y, p.Z)) end end },
        })
        UIToggle(TPT, "clicktp")
        local holder = mk("Frame", { Size = UDim2.new(1, -2, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = LO(TPT) }, TPT)
        mk("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, holder)

        wpRefresh = function()
            for _, ch in ipairs(holder:GetChildren()) do if ch:IsA("Frame") then ch:Destroy() end end
            for i, w in ipairs(wpList()) do
                local cardF = mk("Frame", { Size = UDim2.new(1, 0, 0, 72), BackgroundColor3 = Theme.DarkGray, LayoutOrder = i }, holder)
                round(cardF, 8); stroke(cardF)
                mk("TextLabel", { Size = UDim2.new(1, -36, 0, 24), Position = UDim2.new(0, 8, 0, 3), BackgroundTransparency = 1, Text = string.format("%s  (%.0f, %.0f, %.0f)", w.name, w.x, w.y, w.z), TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 9.5, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd }, cardF)
                local del = mk("TextButton", { Size = UDim2.fromOffset(24, 24), Position = UDim2.new(1, -28, 0, 3), BackgroundColor3 = Theme.MidGray, Text = "X", TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 9.5 }, cardF)
                round(del, 12); stroke(del)
                conn(del.Activated, function() deleteWaypoint(w.name) end)
                fillPills(cardF, {
                    { "TP", function() Teleport(wpCF(w)) end },
                    { "Walk", function() WalkTo(wpCF(w).Position) end },
                    { "Tween", function() TweenTo(wpCF(w)) end },
                }, 34, 30)
            end
        end
        wpRefresh()
    end

    -- PLAYER -----------------------------------------------------------
    do
        local selected
        local selBtn = mk("TextButton", { Size = UDim2.new(1, -2, 0, 34), BackgroundColor3 = Theme.DarkGray, Text = "Selected Player: None (tap to choose)", TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 10, LayoutOrder = LO(PlayerT) }, PlayerT)
        round(selBtn, 17); stroke(selBtn)
        local dropdown = mk("ScrollingFrame", { Size = UDim2.new(1, -2, 0, 110), BackgroundColor3 = Theme.Black, BorderSizePixel = 0, ScrollBarThickness = 3, Visible = false, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, LayoutOrder = LO(PlayerT) }, PlayerT)
        round(dropdown, 8); stroke(dropdown)
        mk("UIListLayout", { Padding = UDim.new(0, 4) }, dropdown)
        mk("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4) }, dropdown)

        local infoLbl = UILabel(PlayerT, "Pick a player to see their info.")

        local function refreshDropdown()
            for _, ch in ipairs(dropdown:GetChildren()) do if ch:IsA("TextButton") then ch:Destroy() end end
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP then
                    local b = mk("TextButton", { Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = Theme.DarkGray, Text = plr.DisplayName .. " (@" .. plr.Name .. ")", TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 9.5 }, dropdown)
                    round(b, 14)
                    conn(b.Activated, function()
                        selected = plr
                        selBtn.Text = "Selected Player: " .. plr.Name
                        dropdown.Visible = false
                    end)
                end
            end
        end
        refreshDropdown()
        conn(Players.PlayerAdded, refreshDropdown)
        conn(Players.PlayerRemoving, function(p) if selected == p then selected = nil; selBtn.Text = "Selected Player: None (tap to choose)" end; refreshDropdown() end)
        conn(selBtn.Activated, function() dropdown.Visible = not dropdown.Visible; refreshDropdown() end)

        local function withTarget(fn) return function() if selected then fn(selected) else say("Select a player first.") end end end
        UIPillRow(PlayerT, {
            { "TP", withTarget(function(p) local cf = targetCF(p); if cf then Teleport(cf) end end) },
            { "Walk", withTarget(function(p) local cf = targetCF(p); if cf then WalkTo(cf.Position) end end) },
            { "Tween", withTarget(function(p) local cf = targetCF(p); if cf then TweenTo(cf) end end) },
        })
        UIPillRow(PlayerT, {
            { "View", withTarget(function(p) setView(p); say("Viewing " .. p.Name) end) },
            { "Unview", function() setView(nil) end },
            { "Copy ID", withTarget(function(p) copyText(p.UserId) end) },
        })

        task.spawn(function()
            while U.Alive do
                if selected and TabMeta.Player.Container.Visible and Main.Visible then
                    local h = selected.Character and selected.Character:FindFirstChildOfClass("Humanoid")
                    local r, tr = root(), selected.Character and selected.Character:FindFirstChild("HumanoidRootPart")
                    infoLbl.Text = string.format("%s (@%s)\nID %d | Age %d days\nHP %s | Dist %s | Team %s",
                        selected.DisplayName, selected.Name, selected.UserId, selected.AccountAge,
                        h and (math.floor(h.Health) .. "/" .. math.floor(h.MaxHealth)) or "--",
                        (r and tr) and (math.floor((tr.Position - r.Position).Magnitude) .. "m") or "--",
                        selected.Team and selected.Team.Name or "none")
                end
                task.wait(0.5)
            end
        end)
    end

    -- CHEATS -----------------------------------------------------------
    do
        UISection(CheatsT, "Combat")
        UIToggle(CheatsT, "aim"); UISlider(CheatsT, "aimRange")
        UISection(CheatsT, "Movement")
        UIToggle(CheatsT, "speedOn"); UISlider(CheatsT, "walkSpeed")
        UIToggle(CheatsT, "fly"); UISlider(CheatsT, "flySpeed")
        UIToggle(CheatsT, "noclip")
        UIToggle(CheatsT, "tpwalkOn"); UISlider(CheatsT, "tpwalkSpeed")
        UIToggle(CheatsT, "jumpOn"); UISlider(CheatsT, "jumpPower")
        UIToggle(CheatsT, "infjump")
        UISlider(CheatsT, "gravity"); UISlider(CheatsT, "hipHeight")
        UISection(CheatsT, "World")
        UIToggle(CheatsT, "fastinteract")
        UIToggle(CheatsT, "god")
    end

    -- VISUALS ----------------------------------------------------------
    do
        local img = resolveBanner()
        if img ~= "" then
            local box = mk("Frame", { Size = UDim2.new(1, -2, 0, 70), BackgroundColor3 = Theme.DarkGray, ClipsDescendants = true, LayoutOrder = LO(VisualT) }, VisualT)
            round(box, 8); stroke(box, 0.2)
            mk("ImageLabel", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Image = img, ScaleType = Enum.ScaleType.Crop }, box)
        end
        UIToggle(VisualT, "esp"); UIToggle(VisualT, "clean"); UIToggle(VisualT, "xray"); UIToggle(VisualT, "lowgfx")
        UISlider(VisualT, "fov"); UISlider(VisualT, "zoom"); UISlider(VisualT, "timeOfDay")
    end

    -- MISC -------------------------------------------------------------
    do
        UISection(MiscT, "Server")
        UIButton(MiscT, "Rejoin Server", rejoin)
        UIButton(MiscT, "Server Hop", serverHop)
        UIPillRow(MiscT, { { "Copy Place ID", function() copyText(game.PlaceId) end }, { "Copy Job ID", function() copyText(game.JobId) end } })
        UISection(MiscT, "Options")
        UIToggle(MiscT, "antiafk")
        UIToggle(MiscT, "music"); UISlider(MiscT, "musicVolume")
        UISection(MiscT, "Settings")
        UIButton(MiscT, "Save Settings Now", function() persistNow(); say("Settings saved.") end)
        UIButton(MiscT, "Turn Everything Off", function() restoreAll(); say("Everything restored.") end)
        UIButton(MiscT, "Unload Hub", function() U.Destroy() end, Theme.MidGray)
    end

    -- CMD --------------------------------------------------------------
    do
        local Box = mk("TextBox", { Size = UDim2.new(1, -66, 0, 30), Position = UDim2.fromOffset(0, 0), BackgroundColor3 = Theme.DarkGray, PlaceholderText = "Type a command (e.g. fly 60)", PlaceholderColor3 = Theme.SubText, Text = "", TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 12, ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left }, CmdT)
        round(Box, 15); stroke(Box)
        mk("UIPadding", { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 8) }, Box)
        local RunBtn = mk("TextButton", { Size = UDim2.fromOffset(58, 30), Position = UDim2.new(1, -58, 0, 0), BackgroundColor3 = Theme.White, Text = "RUN", TextColor3 = Theme.Black, Font = BODY_FONT, TextSize = 11 }, CmdT)
        round(RunBtn, 15)

        local List = mk("ScrollingFrame", { Size = UDim2.new(1, 0, 1, -92), Position = UDim2.fromOffset(0, 36), BackgroundColor3 = Theme.Black, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.White, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y }, CmdT)
        round(List, 8); stroke(List)
        mk("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder }, List)
        mk("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 6) }, List)

        local Status = mk("TextLabel", { Size = UDim2.new(1, 0, 0, 52), Position = UDim2.new(0, 0, 1, -52), BackgroundTransparency = 1, Text = "", TextColor3 = Theme.SubText, Font = BODY_FONT, TextSize = 10, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top }, CmdT)
        local lines = {}
        say = function(msg)
            table.insert(lines, tostring(msg))
            while #lines > 3 do table.remove(lines, 1) end
            Status.Text = table.concat(lines, "\n")
            pushLog(msg, "INFO")
        end

        local MAX_ROWS = 100
        local rows, rowEntry = {}, {}
        for i = 1, MAX_ROWS do
            local b = mk("TextButton", { Size = UDim2.new(1, 0, 0, 24), BackgroundColor3 = Theme.DarkGray, Text = "", RichText = true, TextColor3 = Theme.White, Font = Enum.Font.Gotham, TextSize = 10.5, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Visible = false, LayoutOrder = i }, List)
            round(b, 6)
            mk("UIPadding", { PaddingLeft = UDim.new(0, 8) }, b)
            rows[i] = b
            conn(b.Activated, function()
                local e = rowEntry[b]
                if e then Box.Text = e.name .. " "; Box:CaptureFocus(); Box.CursorPosition = #Box.Text + 1 end
            end)
        end

        local function refreshSuggestions()
            local text = Box.Text
            local typed = (text:match("^%s*;?%s*(%S*)") or ""):lower()
            local hasSpace = text:find("^%s*;?%s*%S+%s") ~= nil
            local entries = {}
            if hasSpace then
                local c = Cmds[typed]
                if c then entries[1] = c
                elseif Save.aliases[typed] then entries[1] = { name = typed, names = { typed }, usage = "", desc = "alias -> " .. Save.aliases[typed] } end
            else
                local pool = {}
                for _, c in ipairs(Order) do pool[#pool + 1] = c end
                for n, v in pairs(Save.aliases) do pool[#pool + 1] = { name = n, names = { n }, usage = "", desc = "alias -> " .. v } end
                for _, c in ipairs(pool) do
                    for _, n in ipairs(c.names) do
                        if typed == "" or n:sub(1, #typed) == typed then entries[#entries + 1] = c break end
                    end
                end
                if #entries == 0 then
                    for _, c in ipairs(pool) do
                        if c.name:find(typed, 1, true) or c.desc:lower():find(typed, 1, true) then entries[#entries + 1] = c end
                    end
                end
            end
            for i, b in ipairs(rows) do
                local c = entries[i]
                if c then
                    b.Visible = true; rowEntry[b] = c
                    b.Text = string.format('<b>%s</b> %s  <font color="#B4B4BE">%s</font>', c.name, c.usage or "", c.desc or "")
                else
                    b.Visible = false; rowEntry[b] = nil
                end
            end
        end
        conn(Box:GetPropertyChangedSignal("Text"), refreshSuggestions)

        local history, histIdx = {}, 1
        local function submit()
            local line = Box.Text
            if line:match("^%s*$") then return end
            table.insert(history, line)
            histIdx = #history + 1
            Box.Text = ""
            runLine(line)
        end
        conn(Box.FocusLost, function(enter) if enter then submit() end end)
        conn(RunBtn.Activated, submit)
        conn(UserInputService.InputBegan, function(i)
            if not Box:IsFocused() or #history == 0 then return end
            if i.KeyCode == Enum.KeyCode.Up then histIdx = math.max(1, histIdx - 1); Box.Text = history[histIdx]; Box.CursorPosition = #Box.Text + 1
            elseif i.KeyCode == Enum.KeyCode.Down then histIdx = math.min(#history + 1, histIdx + 1); Box.Text = history[histIdx] or ""; Box.CursorPosition = #Box.Text + 1 end
        end)

        focusBar = function()
            SelectTab("CMD")
            Box:CaptureFocus()
            task.defer(function() Box.Text = "" end)
        end
        refreshSuggestions()
        say("Brineland ready. Clear the box to browse all commands.")
    end

    -- KEYS -------------------------------------------------------------
    local Keybinds, Actions, listening, bindBtns = {}, {}, nil, {}
    do
        local order = {}
        local function addAction(label, fn) Actions[label] = fn; order[#order + 1] = label end
        for _, d in ipairs(Defs) do
            if d.kind == "toggle" then addAction(d.label, function() Set(d.id, not St[d.id]) end) end
        end
        addAction("Teleport Back", TeleportBack)
        addAction("Teleport to Spawn", TeleportSpawn)
        addAction("Show/Hide Hub", function() Main.Visible = not Main.Visible end)
        addAction("Focus Command Bar", function() focusBar() end)

        for label, keyName in pairs(Save.keys) do
            local ok, kc = pcall(function() return Enum.KeyCode[keyName] end)
            if ok and kc and Actions[label] then Keybinds[label] = kc end
        end
        if Keybinds["Show/Hide Hub"] == nil and Save.keys["Show/Hide Hub"] == nil then Keybinds["Show/Hide Hub"] = Enum.KeyCode.RightShift end
        if Keybinds["Focus Command Bar"] == nil and Save.keys["Focus Command Bar"] == nil then Keybinds["Focus Command Bar"] = Enum.KeyCode.Semicolon end

        UILabel(KeysT, "Tap a button, then press a key. Press Escape to clear a bind. Binds are saved.")
        for _, label in ipairs(order) do
            local frame = mk("Frame", { Size = UDim2.new(1, -2, 0, 34), BackgroundColor3 = Theme.DarkGray, LayoutOrder = LO(KeysT) }, KeysT)
            round(frame, 8); stroke(frame)
            mk("TextLabel", { Size = UDim2.new(1, -96, 1, 0), Position = UDim2.fromOffset(10, 0), BackgroundTransparency = 1, Text = label, TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd }, frame)
            local b = mk("TextButton", { Size = UDim2.fromOffset(82, 22), Position = UDim2.new(1, -88, 0.5, -11), BackgroundColor3 = Theme.MidGray, Text = "", TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 9.5 }, frame)
            round(b, 11); stroke(b, 0.3)
            bindBtns[label] = b
            local function show() b.Text = Keybinds[label] and ("[" .. Keybinds[label].Name .. "]") or "[ None ]" end
            show()
            conn(b.Activated, function() listening = label; b.Text = "[...]" end)
        end

        conn(UserInputService.InputBegan, function(input, gp)
            if listening then
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    local label = listening
                    listening = nil
                    if input.KeyCode == Enum.KeyCode.Escape then Keybinds[label] = nil; Save.keys[label] = false
                    else Keybinds[label] = input.KeyCode; Save.keys[label] = input.KeyCode.Name end
                    markDirty()
                    bindBtns[label].Text = Keybinds[label] and ("[" .. Keybinds[label].Name .. "]") or "[ None ]"
                end
                return
            end
            if gp or input.UserInputType ~= Enum.UserInputType.Keyboard or UserInputService:GetFocusedTextBox() then return end
            for label, kc in pairs(Keybinds) do
                if kc == input.KeyCode and Actions[label] then pcall(Actions[label]) end
            end
        end)
    end

    -- INFO (your telemetry + avatar + console, same look) ----------------
    do
        local MAX_LOGS = 200
        local LOG_KIND = {
            OUTPUT = { color = Theme.White, hex = "#FFFFFF", label = "OUTPUT" },
            INFO   = { color = Theme.White, hex = "#E5E5E5", label = "INFO" },
            WARN   = { color = Theme.SubText, hex = "#C8C8D2", label = "WARN" },
            ERROR  = { color = Theme.SubText, hex = "#A5A5B2", label = "ERROR" },
        }
        local LOG_FILTERS = { "ALL", "OUTPUT", "INFO", "WARN", "ERROR" }

        local topRow = mk("Frame", { Size = UDim2.new(1, -2, 0, 92), BackgroundTransparency = 1, LayoutOrder = LO(InfoT) }, InfoT)
        local left = mk("Frame", { Size = UDim2.new(0.60, -4, 1, 0), BackgroundTransparency = 1 }, topRow)
        mk("UIListLayout", { Padding = UDim.new(0, 4) }, left)

        local header = mk("Frame", { Size = UDim2.new(1, 0, 0, 26), BackgroundColor3 = Theme.DarkGray }, left)
        round(header, 7); stroke(header)
        mk("TextLabel", { Size = UDim2.new(0.55, 0, 1, 0), Position = UDim2.new(0, 7, 0, 0), BackgroundTransparency = 1, Text = "SERVER", TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 9.5, TextXAlignment = Enum.TextXAlignment.Left }, header)
        local connLbl = mk("TextLabel", { Size = UDim2.new(0.45, -7, 1, 0), Position = UDim2.new(0.55, 0, 0, 0), BackgroundTransparency = 1, Text = "CONNECTED", TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 8.5, TextXAlignment = Enum.TextXAlignment.Right }, header)

        local grid = mk("Frame", { Size = UDim2.new(1, 0, 0, 62), BackgroundTransparency = 1 }, left)
        mk("UIGridLayout", { CellSize = UDim2.new(0.48, 0, 0, 29), CellPadding = UDim2.new(0.04, 0, 0, 4) }, grid)
        local function chip(title)
            local c = mk("Frame", { BackgroundColor3 = Theme.DarkGray }, grid)
            round(c, 7); stroke(c)
            mk("TextLabel", { Size = UDim2.new(1, -6, 0, 10), Position = UDim2.new(0, 5, 0, 2), BackgroundTransparency = 1, Text = title, TextColor3 = Theme.SubText, Font = BODY_FONT, TextSize = 7.5, TextXAlignment = Enum.TextXAlignment.Left }, c)
            return mk("TextLabel", { Size = UDim2.new(1, -6, 0, 14), Position = UDim2.new(0, 5, 0, 13), BackgroundTransparency = 1, Text = "--", TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 9.5, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd }, c)
        end
        local pingL, fpsL, memL, upL = chip("PING"), chip("FPS"), chip("MEMORY"), chip("UPTIME")

        local avatarCard = mk("Frame", { Size = UDim2.new(0.40, -2, 1, 0), Position = UDim2.new(0.60, 2, 0, 0), BackgroundColor3 = Theme.DarkGray }, topRow)
        round(avatarCard, 7); stroke(avatarCard, 0.2)
        local vpf = mk("ViewportFrame", { Size = UDim2.new(1, -6, 1, -18), Position = UDim2.new(0, 3, 0, 3), BackgroundTransparency = 1, Ambient = Color3.fromRGB(200, 200, 200), LightColor = Theme.White, LightDirection = Vector3.new(-1, -1, -1) }, avatarCard)
        mk("TextLabel", { Size = UDim2.new(1, 0, 0, 14), Position = UDim2.new(0, 0, 1, -15), BackgroundTransparency = 1, Text = string.sub(LP.DisplayName, 1, 12), TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 8.5 }, avatarCard)

        local avatarModel, avatarAngle = nil, 0
        local function renderAvatar(char)
            if not char or not U.Alive then return end
            pcall(function()
                if avatarModel then avatarModel:Destroy(); avatarModel = nil end
                char:WaitForChild("HumanoidRootPart", 5)
                local prev = char.Archivable
                char.Archivable = true
                local model = char:Clone()
                char.Archivable = prev
                if not model then return end
                for _, d in ipairs(model:GetDescendants()) do
                    if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("Humanoid") or d:IsA("BillboardGui") or d:IsA("Highlight") then
                        pcall(function() d:Destroy() end)
                    elseif d:IsA("BasePart") then d.Anchored = true end
                end
                if not (model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart) then return end
                model:PivotTo(CFrame.new(0, 0, 0))
                if not vpf.CurrentCamera then vpf.CurrentCamera = mk("Camera", {}, vpf) end
                vpf.CurrentCamera.CFrame = CFrame.new(Vector3.new(0, 1.5, 4.8), Vector3.new(0, 0.5, 0))
                model.Parent = vpf
                avatarModel = model
            end)
        end
        if LP.Character then task.spawn(renderAvatar, LP.Character) end
        conn(LP.CharacterAdded, function(ch) task.wait(0.5); renderAvatar(ch) end)

        local statsRow = mk("Frame", { Size = UDim2.new(1, -2, 0, 26), BackgroundColor3 = Theme.DarkGray, LayoutOrder = LO(InfoT) }, InfoT)
        round(statsRow, 13); stroke(statsRow)
        local playersL = mk("TextLabel", { Size = UDim2.new(0.45, 0, 1, 0), Position = UDim2.new(0, 8, 0, 0), BackgroundTransparency = 1, Text = "PLAYERS: --", TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 8.5, TextXAlignment = Enum.TextXAlignment.Left }, statsRow)
        local jobId = game.JobId
        local jobShown = (jobId == "") and "STUDIO" or (string.sub(jobId, 1, 8) .. "...")
        local jobL = mk("TextLabel", { Size = UDim2.new(0.55, -8, 1, 0), Position = UDim2.new(0.45, 0, 0, 0), BackgroundTransparency = 1, Text = "JOB: " .. jobShown, TextColor3 = Theme.SubText, Font = BODY_FONT, TextSize = 8.5, TextXAlignment = Enum.TextXAlignment.Right }, statsRow)
        local jobBtn = mk("TextButton", { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "" }, statsRow)
        conn(jobBtn.Activated, function()
            if jobId ~= "" and setclip then
                local ok = pcall(setclip, jobId)
                jobL.Text = ok and "COPIED!" or "FAILED"; jobL.TextColor3 = Theme.White
            else
                jobL.Text = (jobId == "") and "NO ID" or "NO CLIP"
            end
            task.delay(1.2, function() if U.Alive then jobL.Text = "JOB: " .. jobShown; jobL.TextColor3 = Theme.SubText end end)
        end)

        local filterBar = mk("Frame", { Size = UDim2.new(1, -2, 0, 20), BackgroundTransparency = 1, LayoutOrder = LO(InfoT) }, InfoT)
        mk("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 3) }, filterBar)
        local activeFilter, filterBtns = "ALL", {}
        local rebuildConsole = function() end
        local function colorFilters()
            for _, n in ipairs(LOG_FILTERS) do
                local on = (n == activeFilter)
                filterBtns[n].BackgroundColor3 = on and Theme.White or Theme.DarkGray
                filterBtns[n].TextColor3 = on and Theme.Black or Theme.SubText
            end
        end
        for _, n in ipairs(LOG_FILTERS) do
            local b = mk("TextButton", { Size = UDim2.new(0.192, 0, 1, 0), BackgroundColor3 = Theme.DarkGray, Text = n, TextColor3 = Theme.SubText, Font = BODY_FONT, TextSize = 7.5 }, filterBar)
            round(b, 10); stroke(b, 0.35)
            filterBtns[n] = b
            conn(b.Activated, function() activeFilter = n; colorFilters(); rebuildConsole() end)
        end
        colorFilters()

        local searchBox = mk("TextBox", { Size = UDim2.new(1, -2, 0, 24), BackgroundColor3 = Theme.DarkGray, PlaceholderText = "Search logs...", PlaceholderColor3 = Theme.SubText, Text = "", TextColor3 = Theme.White, Font = Enum.Font.Gotham, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, LayoutOrder = LO(InfoT) }, InfoT)
        round(searchBox, 12); stroke(searchBox)
        mk("UIPadding", { PaddingLeft = UDim.new(0, 8) }, searchBox)

        local console = mk("ScrollingFrame", { Size = UDim2.new(1, -2, 0, 82), BackgroundColor3 = Theme.Black, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.White, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), LayoutOrder = LO(InfoT) }, InfoT)
        round(console, 7); stroke(console)
        mk("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, console)
        mk("UIPadding", { PaddingTop = UDim.new(0, 3), PaddingBottom = UDim.new(0, 3), PaddingLeft = UDim.new(0, 5), PaddingRight = UDim.new(0, 5) }, console)

        local controlsRow = mk("Frame", { Size = UDim2.new(1, -2, 0, 22), BackgroundTransparency = 1, LayoutOrder = LO(InfoT) }, InfoT)
        local clearBtn = mk("TextButton", { Size = UDim2.new(0.36, 0, 1, 0), BackgroundColor3 = Theme.DarkGray, Text = "CLEAR", TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 8.5 }, controlsRow)
        round(clearBtn, 11); stroke(clearBtn)
        local autoScroll = true
        local autoBtn = mk("TextButton", { Size = UDim2.new(0.42, 0, 1, 0), Position = UDim2.new(0.38, 0, 0, 0), BackgroundColor3 = Theme.White, Text = "AUTO: ON", TextColor3 = Theme.Black, Font = BODY_FONT, TextSize = 8.5 }, controlsRow)
        round(autoBtn, 11)
        local countL = mk("TextLabel", { Size = UDim2.new(0.18, 0, 1, 0), Position = UDim2.new(0.82, 0, 0, 0), BackgroundTransparency = 1, Text = "0/" .. MAX_LOGS, TextColor3 = Theme.SubText, Font = BODY_FONT, TextSize = 8.5, TextXAlignment = Enum.TextXAlignment.Right }, controlsRow)

        local entries, pending, pendingHead, logCounter, searchQuery, scrollQueued = {}, {}, 1, 0, "", 0
        local function esc(s) s = s:gsub("&", "&amp;"); s = s:gsub("<", "&lt;"); s = s:gsub(">", "&gt;"); return s end
        local function createRow(e)
            local info = LOG_KIND[e.kind]
            e.row = mk("TextLabel", {
                LayoutOrder = e.id, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Theme.DarkGray,
                BackgroundTransparency = (e.id % 2 == 0) and 0.85 or 1, BorderSizePixel = 0, RichText = true, TextWrapped = true, Font = Enum.Font.Code,
                TextSize = 9.5, TextColor3 = info.color, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
                Text = string.format('<font color="#8A8A98">[%s]</font> <font color="%s"><b>[%s]</b></font> %s', e.time, info.hex, info.label, esc(e.text)),
            }, console)
        end
        local function matches(e)
            return (activeFilter == "ALL" or activeFilter == e.kind) and (searchQuery == "" or string.find(e.lower, searchQuery, 1, true) ~= nil)
        end
        pushLog = function(msg, kind, ts)
            if not U.Alive then return end
            kind = LOG_KIND[kind] and kind or "OUTPUT"
            logCounter = logCounter + 1
            local clean = string.sub(tostring(msg), 1, 500)
            local e = { id = logCounter, kind = kind, text = clean, lower = string.lower(clean), time = os.date("%H:%M:%S", ts) }
            table.insert(entries, e)
            while #entries > MAX_LOGS do
                local old = table.remove(entries, 1)
                old.removed = true
                if old.row then old.row:Destroy(); old.row = nil end
            end
            if matches(e) then table.insert(pending, e) end
        end
        rebuildConsole = function()
            for _, e in ipairs(entries) do if e.row then e.row:Destroy(); e.row = nil end end
            pending, pendingHead = {}, 1
            for _, e in ipairs(entries) do if matches(e) then table.insert(pending, e) end end
            if autoScroll then scrollQueued = 2 end
        end
        local searchToken = 0
        conn(searchBox:GetPropertyChangedSignal("Text"), function()
            searchQuery = string.lower(searchBox.Text)
            searchToken = searchToken + 1
            local mine = searchToken
            task.delay(0.15, function() if U.Alive and mine == searchToken then rebuildConsole() end end)
        end)
        conn(clearBtn.Activated, function()
            for _, e in ipairs(entries) do e.removed = true; if e.row then e.row:Destroy() end end
            entries, pending, pendingHead = {}, {}, 1
            pushLog("Console cleared.", "INFO")
        end)
        conn(autoBtn.Activated, function()
            autoScroll = not autoScroll
            autoBtn.Text = autoScroll and "AUTO: ON" or "AUTO: OFF"
            autoBtn.BackgroundColor3 = autoScroll and Theme.White or Theme.DarkGray
            autoBtn.TextColor3 = autoScroll and Theme.Black or Theme.SubText
            if autoScroll then scrollQueued = 2 end
        end)

        local function mapType(t)
            if t == Enum.MessageType.MessageWarning then return "WARN"
            elseif t == Enum.MessageType.MessageError then return "ERROR"
            elseif t == Enum.MessageType.MessageInfo then return "INFO" end
            return "OUTPUT"
        end
        pcall(function()
            local history = LogService:GetLogHistory()
            for i = math.max(1, #history - 79), #history do pushLog(history[i].message, mapType(history[i].messageType), history[i].timestamp) end
        end)
        pcall(function() conn(LogService.MessageOut, function(msg, t) pushLog(msg, mapType(t)) end) end)

        local frames, lastClock, disconnected = 0, os.clock(), false
        pcall(function()
            conn(game:GetService("NetworkClient").ChildRemoved, function() disconnected = true; pushLog("Disconnected from server.", "ERROR") end)
        end)
        local function getPing()
            local ok, v = pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
            if ok and type(v) == "number" then return math.floor(v + 0.5) end
            local ok2, ms = pcall(function() return LP:GetNetworkPing() * 1000 end)
            if ok2 and type(ms) == "number" then return math.floor(ms + 0.5) end
        end
        local function fmtTime(s) s = math.floor(s); return string.format("%d:%02d:%02d", math.floor(s / 3600), math.floor(s / 60) % 60, s % 60) end

        task.spawn(function()
            while U.Alive do
                local now = os.clock()
                local dt = now - lastClock
                if dt > 0 then
                    local fps = math.floor(frames / dt + 0.5)
                    frames, lastClock = 0, now
                    local ping = getPing()
                    local okM, mem = pcall(function() return Stats:GetTotalMemoryUsageMb() end)
                    pingL.Text = ping and (ping .. " ms") or "N/A"
                    fpsL.Text = tostring(fps)
                    memL.Text = (okM and type(mem) == "number") and string.format("%.0f MB", mem) or "N/A"
                    upL.Text = fmtTime(Workspace.DistributedGameTime)
                    playersL.Text = string.format("PLAYERS: %d/%d", #Players:GetPlayers(), Players.MaxPlayers)
                    if disconnected or not LP:IsDescendantOf(game) then connLbl.Text, connLbl.TextColor3 = "DISCONNECTED", Theme.SubText
                    elseif (ping and ping >= 400) or fps < 8 then connLbl.Text, connLbl.TextColor3 = "UNSTABLE", Theme.SubText
                    elseif ping and ping >= 200 then connLbl.Text, connLbl.TextColor3 = "SLOW LINK", Theme.SubText
                    else connLbl.Text, connLbl.TextColor3 = "CONNECTED", Theme.White end
                end
                task.wait(0.5)
            end
        end)

        conn(RunService.RenderStepped, function(dt)
            frames = frames + 1
            local visible = Main.Visible and TabMeta.Info.Container.Visible and not collapsed
            if not visible then return end

            if avatarModel and avatarModel.Parent then
                avatarAngle = avatarAngle + dt * 45
                avatarModel:PivotTo(CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(avatarAngle), 0))
            end

            if pendingHead <= #pending then
                local created = 0
                while pendingHead <= #pending and created < 30 do
                    local e = pending[pendingHead]
                    pending[pendingHead] = false
                    pendingHead = pendingHead + 1
                    if e and not e.removed and not e.row then createRow(e); created = created + 1 end
                end
                if pendingHead > #pending then pending, pendingHead = {}, 1 end
                if autoScroll then scrollQueued = 2 end
            end
            if scrollQueued > 0 then
                scrollQueued = scrollQueued - 1
                if scrollQueued == 0 then console.CanvasPosition = Vector2.new(0, 1000000) end
            end
            local c = #entries .. "/" .. MAX_LOGS
            if countL.Text ~= c then countL.Text = c end
        end)
        pushLog("Brineland Hub initialized.", "INFO")
        rebuildConsole()
    end

    ---------------------------------------------------------------------
    -- 8. WIRING
    ---------------------------------------------------------------------
    HomeBtn.Activated:Connect(function() end)  -- (placeholder removed below)
    conn(HomeBtn.Activated, function()
        if collapsed then
            collapsed = false
            TweenService:Create(Main, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(HUB_W, HUB_H) }):Play()
            TweenService:Create(ArrowBtn, TweenInfo.new(0.2), { Rotation = 0 }):Play()
            topDivider.Visible, tabDivider.Visible, TabBar.Visible = true, true, true
        end
        SelectTab("Home")
    end)
    conn(ArrowBtn.Activated, function()
        collapsed = not collapsed
        if collapsed then
            for _, m in pairs(TabMeta) do m.Container.Visible = false end
            TabBar.Visible, topDivider.Visible, tabDivider.Visible = false, false, false
            TweenService:Create(Main, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(HUB_W, 40) }):Play()
            TweenService:Create(ArrowBtn, TweenInfo.new(0.2), { Rotation = 180 }):Play()
        else
            TweenService:Create(Main, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.fromOffset(HUB_W, HUB_H) }):Play()
            TweenService:Create(ArrowBtn, TweenInfo.new(0.2), { Rotation = 0 }):Play()
            task.wait(0.14)
            topDivider.Visible, tabDivider.Visible, TabBar.Visible = true, true, true
            if TabMeta[activeTab] then TabMeta[activeTab].Container.Visible = true end
        end
    end)
    conn(CloseBtn.Activated, function() U.Destroy() end)

    -- floating button (drag to move, tap to show/hide) + mobile fly pad
    local Float = mk("TextButton", { Size = UDim2.fromOffset(44, 44), Position = UDim2.new(0, 12, 0.5, 44), BackgroundColor3 = Theme.Black, BackgroundTransparency = 0.06, Text = "B", TextColor3 = Theme.White, Font = FANCY_FONT, TextSize = 20, AutoButtonColor = false }, gui)
    round(Float, 22); stroke(Float, 0, 1.5)
    makeDraggable(Float, Float, function() Main.Visible = not Main.Visible end)

    local Pad = mk("Frame", { Size = UDim2.fromOffset(56, 116), Position = UDim2.new(1, -76, 1, -210), BackgroundTransparency = 1, Visible = false }, gui)
    S.FlyPad = Pad
    local function holdButton(txt, y, key)
        local b = mk("TextButton", { Size = UDim2.fromOffset(56, 54), Position = UDim2.fromOffset(0, y), BackgroundColor3 = Theme.Black, BackgroundTransparency = 0.15, Text = txt, TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 20, AutoButtonColor = false }, Pad)
        round(b, 27); stroke(b, 0.1)
        local held
        conn(b.InputBegan, function(i) if isPointer(i) and not held then held = i; S[key] = true end end)
        conn(UserInputService.InputEnded, function(i) if held and i == held then held = nil; S[key] = false end end)
    end
    holdButton("▲", 0, "UpHeld"); holdButton("▼", 62, "DownHeld")

    -- respawn: reset per-character state, then re-apply what is on
    conn(LP.CharacterAdded, function(char)
        table.clear(noclipSet)
        O.Walk, O.Jump, O.UseJump, O.Hip = nil, nil, nil, nil
        char:WaitForChild("HumanoidRootPart", 10)
        task.wait(0.8)
        if U.Alive then applyCharacter() end
    end)

    -- autosave
    task.spawn(function()
        while U.Alive do
            task.wait(2)
            if dirty then persistNow() end
        end
    end)

    function U.Destroy()
        U.Alive = false
        pcall(restoreAll)
        pcall(persistNow)
        for _, c in ipairs(U.Conns) do pcall(function() c:Disconnect() end) end
        table.clear(U.Conns)
        for _, g in ipairs(U.Guis) do pcall(function() g:Destroy() end) end
        table.clear(U.Guis)
        env.BrinelandUniversal = nil
    end

    -- start
    EnsureHiddenMusic()
    applyMusic()
    SelectTab("Home")
end

BrinelandUniversal()
