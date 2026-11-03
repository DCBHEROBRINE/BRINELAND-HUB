-- ==============================================================================
-- BRINELAND HUB: STEAL AN EGG V9 (ULTIMATE PASCUA MASTER EDITION)
-- Repository: https://github.com/DCBHEROBRINE/BRINELAND-HUB.git
-- ==============================================================================

local getenv = getgenv or function() return _G end
local env = getenv()

if env.PascuaHub and env.PascuaHub.Destroy then 
    pcall(env.PascuaHub.Destroy) 
end

local function cloneRef(obj)
    if cloneref then return cloneref(obj) end
    return obj
end

local function getService(name)
    local success, service = pcall(function() return game:GetService(name) end)
    if success and service then return cloneRef(service) end
    return nil
end

local Players           = getService("Players")
local RunService        = getService("RunService")
local TweenService      = getService("TweenService")
local UserInputService  = getService("UserInputService")
local TeleportService   = getService("TeleportService")
local ReplicatedStorage = getService("ReplicatedStorage")
local Workspace         = getService("Workspace")
local Lighting          = getService("Lighting")
local HttpService       = getService("HttpService")
local Stats             = getService("Stats")
local GuiService        = getService("GuiService")
local CoreGui           = getService("CoreGui")
local SoundService      = getService("SoundService")
local UserGameSettings  = UserSettings():GetService("UserGameSettings")

local LP = Players.LocalPlayer
local CFG_FILE = "BrinelandHub_StealAnEgg.json"

local P = { 
    Conns = {}, Guis = {}, Drawings = {}, Refresh = {}, Tasks = {}, Cleanups = {},
    Running = false, Stealing = false, Base = nil, BaseLocked = false,
    EggCache = {}, LastScan = 0, EggHistory = {}, Log = {} 
}
env.PascuaHub = P

P.Flags = {
    AutoSteal=false, InstantSteal=false, AutoReturn=true, StealDelay=0.4,
    AutoHatch=false, AutoEquipBest=false, AutoPlace=false, AutoSellEgg=false,
    AutoSellPet=false, AutoFuse=false, AutoFavorite=false,
    TargetArea="", MinRarity="All", SpecificEgg="",
    EggPredictor=false, PreviewCard=false, WebhookAlert=false, WebhookURL="",
    AutoRift=false, AutoRiftPlace=false, AutoRiftTrade=false, AutoBoss=false, WaitLastPity=false,
    AutoTreadmill=false, AutoUpgradeTread=false, AutoUpgradeBase=false, AutoTrail=false,
    AutoClaim=false, TreadmillTier=10,
    EggESP=false, PlayerESP=false, PenEggESP=false, EventESP=false, ESPDistance=5000,
    Speed=16, Fly=false, FlySpeed=50, Noclip=false, InfiniteJump=false, GodMode=false,
    Invisible=false, AntiTrap=true, AntiRagdoll=true, AntiKick=true, AntiAFK=true,
    FPSBoost=false, UncapFPS=false, FPSOverlay=false, PingOverlay=false,
    AutoReconnect=true, AutoHop=false, HopThreshold=1,
    RemoteLog=false, HatchArg="", EquipArg="", FavArg="",
    RiftFarmArg="Farm", RiftPlaceArg="Place", RiftTradeArg="Trade", BossFarmArg="Farm", PityArg="WaitPity",
    KeySounds=false, LagReducer=false, AutoHit=false, HitRange=12,
}

P.Remotes = {
    Steal="StealEgg", Treadmill="Treadmill", Upgrade="UpgradeTreadmill", UpgradeBase="UpgradeBase",
    Hatch="HatchEgg", Place="PlaceEgg", SellEgg="SellEgg", SellPet="SellPet", Fuse="FusePet",
    EquipBest="EquipBestPets", Favorite="FavoritePet",
    Rift="RiftAction", Boss="BossAction", Butterfly="CatchButterfly", Event="EventAction", Claim="ClaimReward",
}

local VOLATILE = { Fly=1, Noclip=1, Invisible=1, GodMode=1, InfiniteJump=1, FPSBoost=1, UncapFPS=1, RemoteLog=1, KeySounds=1, LagReducer=1 }
local Orig = {}

-- Custom Sound Profiles Mapping
local SoundProfiles = {
    ["Water Drop"]          = "rbxassetid://403292408",
    ["Slime Jump"]          = "rbxassetid://344167846",
    ["Keyboard Chocolate"]  = "rbxassetid://125115489291773",
    ["Rain Sounds Lava"]    = "rbxassetid://104929259130147",
    ["Keyboard Typing SFX"] = "rbxassetid://9116157306"
}
local SelectedSoundName = "Water Drop"

local function connect(sig, fn) local c = sig:Connect(fn); table.insert(P.Conns, c); return c end
local function spawnTask(fn) local th = task.spawn(fn); table.insert(P.Tasks, th); return th end
local function onCleanup(fn) table.insert(P.Cleanups, fn) end
local function args(s) if s == nil or s == "" then return end return s end

local function notify(title, text, dur)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", { Title=title, Text=text, Duration=dur or 3 })
    end)
end

local function getHum()  local c = LP.Character; return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot() local c = LP.Character; return c and c:FindFirstChild("HumanoidRootPart") end
local function alive()   local h = getHum(); return h and h.Health > 0 and getRoot() ~= nil end

local function every(t, fn)
    spawnTask(function()
        local lastErr
        while P.Running do
            local ok, err = pcall(fn)
            if not ok and err ~= lastErr then lastErr = err; warn("[Brineland] loop error: " .. tostring(err)) end
            task.wait(t)
        end
    end)
end

local function httpGet(url)
    if request then local r = request({ Url=url, Method="GET" }); return r and r.Body end
    return game:HttpGet(url)
end

local remoteCache = {}
local function resolveRemote(name)
    if name == "" then return nil end
    local c = remoteCache[name]
    if c and c.Parent then return c end
    local low, partial = name:lower(), nil
    for _, o in ipairs(ReplicatedStorage:GetDescendants()) do
        if o:IsA("RemoteEvent") or o:IsA("RemoteFunction") then
            local n = o.Name:lower()
            if n == low then remoteCache[name] = o; return o end
            if not partial and n:find(low, 1, true) then partial = o end
        end
    end
    remoteCache[name] = partial
    return partial
end

local function fireRemote(name, ...)
    local r, packed = resolveRemote(name), table.pack(...)
    if not r then return false end
    task.spawn(function()
        pcall(function()
            if r:IsA("RemoteEvent") then r:FireServer(table.unpack(packed, 1, packed.n))
            else r:InvokeServer(table.unpack(packed, 1, packed.n)) end
        end)
    end)
    return true
end

local function moveTo(pos, timeout)
    local hum = getHum(); if not hum then return end
    hum:MoveTo(pos)
    local t = tick()
    while P.Running and getRoot() and (getRoot().Position - pos).Magnitude > 5 and tick() - t < (timeout or 12) do
        task.wait(0.1)
    end
end

-- Absolute Game Sound Eraser & Replacement Engine
local SoundMuteConnections = {}
local function ToggleGameSoundMute(enable)
    for _, conn in ipairs(SoundMuteConnections) do
        if conn then conn:Disconnect() end
    end
    SoundMuteConnections = {}

    local function muteObj(obj)
        if obj:IsA("Sound") then
            local n = obj.Name:lower()
            if n:find("keyboard") or n:find("type") or n:find("typing") or n:find("key") or n:find("click") then
                pcall(function() obj.Volume = enable and 0 or 0.5 end)
            end
        end
    end

    for _, v in ipairs(Workspace:GetDescendants()) do muteObj(v) end
    for _, v in ipairs(SoundService:GetDescendants()) do muteObj(v) end
    if LP.Character then
        for _, v in ipairs(LP.Character:GetDescendants()) do muteObj(v) end
    end

    if enable then
        table.insert(SoundMuteConnections, Workspace.DescendantAdded:Connect(muteObj))
        table.insert(SoundMuteConnections, SoundService.DescendantAdded:Connect(muteObj))
        table.insert(SoundMuteConnections, LP.CharacterAdded:Connect(function(char)
            table.insert(SoundMuteConnections, char.DescendantAdded:Connect(muteObj))
            for _, v in ipairs(char:GetDescendants()) do muteObj(v) end
        end))
    end
end

local function PlayMatchedSound(currentSpeed)
    if not P.Flags.KeySounds then return end
    local soundId = SoundProfiles[SelectedSoundName] or SoundProfiles["Water Drop"]
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Volume = 0.95
    
    local speedRatio = math.clamp(currentSpeed / 16, 0.8, 3.5)
    sound.Pitch = math.clamp(0.9 + (speedRatio * 0.12), 0.8, 1.5)
    sound.Parent = SoundService
    sound:Play()

    task.spawn(function()
        sound.Ended:Wait()
        sound:Destroy()
    end)
end

local soundTimer = 0
connect(RunService.Heartbeat, function(dt)
    if not P.Flags.KeySounds then return end
    local char = LP.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then return end

    if humanoid.MoveDirection.Magnitude > 0 and humanoid.FloorMaterial ~= Enum.Material.Air then
        local currentSpeed = math.max(16, humanoid.WalkSpeed)
        local interval = math.clamp(2.2 / (currentSpeed ^ 0.7), 0.05, 0.28)

        soundTimer = soundTimer + dt
        if soundTimer >= interval then
            soundTimer = 0
            PlayMatchedSound(currentSpeed)
        end
    else
        soundTimer = 0
    end
end)

-- Eggs / Stealing Logic
local RARITY = { common=1, uncommon=2, rare=3, epic=4, legendary=5, divine=6, secret=7, mythic=8 }
local function rarityRank(name)
    local low, best = name:lower(), 0
    for r, rank in pairs(RARITY) do if low:find(r, 1, true) and rank > best then best = rank end end
    return best
end

local function scanEggs()
    if tick() - P.LastScan < 1 then return P.EggCache end
    local out = {}
    for _, o in ipairs(Workspace:GetDescendants()) do
        if (o:IsA("Model") or o:IsA("BasePart")) and o.Name:lower():find("egg", 1, true)
            and not (LP.Character and o:IsDescendantOf(LP.Character)) then
            local skip = o:IsA("BasePart") and o.Parent and o.Parent:IsA("Model") and o.Parent.Name:lower():find("egg", 1, true)
            if not skip then
                local part = o:IsA("Model") and (o.PrimaryPart or o:FindFirstChildWhichIsA("BasePart", true)) or o
                if part then out[#out+1] = { object=o, part=part, name=o.Name, rarity=rarityRank(o.Name) } end
            end
        end
    end
    P.EggCache, P.LastScan = out, tick()
    return out
end

local function passesFilter(e)
    local n, f = e.name:lower(), P.Flags
    if f.TargetArea ~= "" and not n:find(f.TargetArea:lower(), 1, true) then return false end
    if f.SpecificEgg ~= "" and not n:find(f.SpecificEgg:lower(), 1, true) then return false end
    if f.MinRarity ~= "All" and e.rarity < (RARITY[f.MinRarity:lower()] or 0) then return false end
    return true
end

local function closestEgg()
    local root = getRoot(); if not root then return nil end
    local best, bestD = nil, math.huge
    for _, e in ipairs(scanEggs()) do
        if e.part.Parent and passesFilter(e) then
            local d = (e.part.Position - root.Position).Magnitude
            if d < bestD then best, bestD = e, d end
        end
    end
    return best
end

local function sendWebhook(msg)
    local url = P.Flags.WebhookURL
    if not (request and url:find("^https://")) then return end
    task.spawn(function()
        pcall(request, { Url=url, Method="POST", Headers={ ["Content-Type"]="application/json" },
            Body=HttpService:JSONEncode({ content=msg }) })
    end)
end

local function GetMyPlot()
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return nil end

    for _, plot in ipairs(plots:GetChildren()) do
        local owner = plot:FindFirstChild("Owner") or plot:FindFirstChild("OwnerValue") or plot:FindFirstChild("Player")
        if owner and owner:IsA("ValueBase") then
            local val = owner.Value
            if LP and (val == LP or val == LP.Name or val == LP.UserId or (typeof(val) == "Instance" and (val == LP or (val:IsA("Player") and val.Name == LP.Name)))) then
                return plot
            end
        end
        for _, desc in ipairs(plot:GetDescendants()) do
            if desc:IsA("TextLabel") and LP then
                local txt = desc.Text
                local descName = desc.Name:lower()
                if (descName:find("owner") or descName:find("name") or descName:find("title")) and (txt == LP.Name or txt == LP.DisplayName or txt:lower() == (LP.Name:lower() .. "'s plot")) then
                    return plot
                end
            end
        end
    end
    return nil
end

local function GetSafeZoneCFrame()
    if P.Base then return P.Base end
    local myPlot = GetMyPlot()
    if myPlot then
        local treadmill = myPlot:FindFirstChild("TreadmillUpgrade") or myPlot:FindFirstChild("Treadmill")
        if treadmill then
            local base = treadmill:FindFirstChildWhichIsA("BasePart", true)
            if base then 
                P.Base = base.CFrame + Vector3.new(0, 4, 0)
                return P.Base 
            end
        end
        local plotBase = myPlot:FindFirstChildWhichIsA("BasePart")
        if plotBase then 
            P.Base = plotBase.CFrame + Vector3.new(0, 5, 0)
            return P.Base 
        end
    end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        P.Base = root.CFrame
        return P.Base
    end
    return CFrame.new(0, 10, 0)
end

local function stealEgg(egg)
    if not egg or P.Stealing then return end
    local root = getRoot(); if not root then return end
    P.Stealing = true
    pcall(function()
        local home = GetSafeZoneCFrame()
        if P.Flags.InstantSteal then root.CFrame = egg.part.CFrame + Vector3.new(0, 3, 0); task.wait(0.15)
        else moveTo(egg.part.Position, 15) end
        local prompt = egg.object:FindFirstChildWhichIsA("ProximityPrompt", true)
        if prompt then
            if fireproximityprompt then fireproximityprompt(prompt)
            else prompt:InputHoldBegin(); task.wait(prompt.HoldDuration + 0.05); prompt:InputHoldEnd() end
        end
        local cd = egg.object:FindFirstChildWhichIsA("ClickDetector", true)
        if cd and fireclickdetector then fireclickdetector(cd) end
        fireRemote(P.Remotes.Steal, egg.object)
        if P.Flags.WebhookAlert then sendWebhook(("**Brineland Hub** stole `%s` (rarity %d)"):format(egg.name, egg.rarity)) end
        if P.Flags.AutoReturn then
            local r2 = getRoot()
            if r2 then
                if P.Flags.InstantSteal then r2.CFrame = home else moveTo(home.Position, 20) end
            end
        end
        task.wait(P.Flags.StealDelay)
    end)
    P.Stealing = false
end

-- Predictors
local function recordEgg(inst)
    if not (inst:IsA("Model") or inst:IsA("BasePart")) then return end
    local n = inst.Name
    if not n:lower():find("egg", 1, true) then return end
    if inst:IsA("BasePart") and inst.Parent and inst.Parent:IsA("Model") and inst.Parent.Name:lower():find("egg", 1, true) then return end
    local h = P.EggHistory[n]
    if not h then h = {}; P.EggHistory[n] = h end
    local now = os.clock()
    if #h > 0 and now - h[#h] < 2 then return end
    h[#h+1] = now
    if #h > 12 then table.remove(h, 1) end
end

local function predictEggs()
    local out, now = {}, os.clock()
    for name, h in pairs(P.EggHistory) do
        if #h >= 3 then
            local sum = 0
            for i = 2, #h do sum += h[i] - h[i-1] end
            local avg = sum / (#h - 1)
            out[#out+1] = { name = name, eta = math.max(0, h[#h] + avg - now), avg = avg }
        end
    end
    table.sort(out, function(a, b) return a.eta < b.eta end)
    local lines = {}
    for i, o in ipairs(out) do
        if i > 6 then break end
        lines[#lines+1] = ("%s in ~%ds (every ~%ds)"):format(o.name, math.floor(o.eta), math.floor(o.avg))
    end
    return lines
end

local function predictRifts()
    local root, hints = getRoot(), {}
    for _, o in ipairs(Workspace:GetDescendants()) do
        local n = o.Name:lower()
        if n:find("rift", 1, true) or n:find("portal", 1, true) then
            local part = o:IsA("BasePart") and o or (o:IsA("Model") and o.PrimaryPart)
            if part then hints[#hints+1] = { name=o.Name, d = root and (part.Position - root.Position).Magnitude or 0 } end
        end
    end
    table.sort(hints, function(a, b) return a.d < b.d end)
    return hints
end

local function serverHop()
    local ok, body = pcall(httpGet, ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId))
    if ok and body then
        local good = {}
        for _, s in ipairs(HttpService:JSONDecode(body).data or {}) do
            if s.id ~= game.JobId and s.playing < s.maxPlayers then good[#good+1] = s.id end
        end
        if #good > 0 then
            pcall(TeleportService.TeleportToPlaceInstance, TeleportService, game.PlaceId, good[math.random(#good)], LP)
            return
        end
    end
    notify("Brineland", "No server found.")
end

local function saveCfg()
    local flags = {}
    for k, v in pairs(P.Flags) do if not VOLATILE[k] then flags[k] = v end end
    local ok = pcall(function() writefile(CFG_FILE, HttpService:JSONEncode({ Flags=flags, Remotes=P.Remotes })) end)
    notify("Brineland", ok and "Config saved." or "Save not supported.")
end

local function loadCfg(silent)
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile(CFG_FILE)) end)
    if not ok or type(data) ~= "table" then if not silent then notify("Brineland", "No config found.") end return end
    for k, v in pairs(data.Flags or {}) do if P.Flags[k] ~= nil and type(v) == type(P.Flags[k]) and not VOLATILE[k] then P.Flags[k] = v end end
    for k, v in pairs(data.Remotes or {}) do if P.Remotes[k] ~= nil and type(v) == "string" then P.Remotes[k] = v end end
    for _, fn in pairs(P.Refresh) do pcall(fn) end
    if not silent then notify("Brineland", "Config loaded.") end
end

-- UI Construction matching Brineland Standard Style
local T = {
    bg=Color3.fromRGB(14, 11, 25), side=Color3.fromRGB(10, 8, 18), card=Color3.fromRGB(22, 18, 45),
    hover=Color3.fromRGB(35, 28, 65), accent=Color3.fromRGB(0, 229, 255), text=Color3.fromRGB(255, 255, 255),
    dim=Color3.fromRGB(180, 180, 210), on=Color3.fromRGB(0, 229, 255), off=Color3.fromRGB(40, 35, 65),
}

local function new(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props) do o[k] = v end
    o.Parent = parent
    return o
end

local function round(o, r) new("UICorner", { CornerRadius = UDim.new(0, r or 6) }, o) end
local function guiParent() return (gethui and gethui()) or CoreGui or LP:WaitForChild("PlayerGui") end
local function isPointer(i) return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch end
local function isMove(i) return i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch end

local function makeGui(name, order)
    local g = new("ScreenGui", { Name=name, ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling, DisplayOrder=order }, guiParent())
    table.insert(P.Guis, g)
    return g
end

local function makeDraggable(handle, target)
    local dragging, start, orig
    connect(handle.InputBegan, function(i)
        if isPointer(i) then dragging, start, orig = true, i.Position, target.Position end
    end)
    connect(UserInputService.InputChanged, function(i)
        if dragging and isMove(i) then
            local sc = target:FindFirstChildOfClass("UIScale")
            local d = (i.Position - start) / (sc and sc.Scale or 1)
            target.Position = UDim2.new(orig.X.Scale, orig.X.Offset + d.X, orig.Y.Scale, orig.Y.Offset + d.Y)
        end
    end)
    connect(UserInputService.InputEnded, function(i) if isPointer(i) then dragging = false end end)
end

local function createWindow(title)
    local gui = makeGui("BrinelandStealAnEggHub", 999)
    local main = new("Frame", { Size=UDim2.fromOffset(360, 430), Position=UDim2.new(0.5,-180,0.5,-215),
        BackgroundColor3=T.bg, BackgroundTransparency=0.18, BorderSizePixel=0 }, gui)
    round(main, 10)
    new("UIStroke", { Color=T.accent, Thickness=1.5 }, main)
    local vp = Workspace.CurrentCamera.ViewportSize
    new("UIScale", { Scale = math.clamp(math.min(vp.X / 420, vp.Y / 480), 0.6, 1) }, main)

    local top = new("Frame", { Size=UDim2.new(1,0,0,40), BackgroundColor3=T.side, BackgroundTransparency=0.25, BorderSizePixel=0 }, main)
    round(top, 10)
    
    new("TextLabel", { Size=UDim2.new(1,-85,1,0), Position=UDim2.fromOffset(10,0), BackgroundTransparency=1,
        Text="<b>BRINELAND</b> <font color=\"#00E5FF\">STEAL AN EGG</font>",
        TextColor3=T.text, Font=Enum.Font.GothamBold, TextSize=12, RichText=true, TextXAlignment=Enum.TextXAlignment.Left }, top)

    local function topBtn(txt, x, fn, col)
        local b = new("TextButton", { Size=UDim2.fromOffset(28,28), Position=UDim2.new(1,x,0.5,-14), BackgroundColor3=col,
            Text=txt, TextColor3=T.text, Font=Enum.Font.GothamBold, TextSize=13, RichText=true, AutoButtonColor=true }, top)
        round(b, 6); connect(b.MouseButton1Click, fn)
    end
    topBtn("<b>X</b>", -32, function() P.Destroy() end, Color3.fromRGB(220,35,70))
    topBtn("<b>–</b>", -64, function() main.Visible = not main.Visible end, Color3.fromRGB(45,40,80))
    makeDraggable(top, main)

    -- Floating Toggle Hub Button
    local tgui = makeGui("BrinelandToggleBtn", 998)
    local tb = new("TextButton", { Size=UDim2.fromOffset(45,45), Position=UDim2.new(0,15,0.5,-22), BackgroundColor3=T.side,
        Text="<b><font color=\"#00E5FF\">HUB</font></b>", TextColor3=T.text, Font=Enum.Font.GothamBold, TextSize=12, RichText=true, AutoButtonColor=true }, tgui)
    round(tb, 22); new("UIStroke", { Color=T.accent, Thickness=1.5 }, tb)
    
    local tDrag, tMoved, tStart, tOrig
    connect(tb.InputBegan, function(i) if isPointer(i) then tDrag, tMoved, tStart, tOrig = true, false, i.Position, tb.Position end end)
    connect(UserInputService.InputChanged, function(i)
        if tDrag and isMove(i) then
            local d = i.Position - tStart
            if d.Magnitude > 6 then tMoved = true end
            if tMoved then tb.Position = UDim2.new(tOrig.X.Scale, tOrig.X.Offset + d.X, tOrig.Y.Scale, tOrig.Y.Offset + d.Y) end
        end
    end)
    connect(UserInputService.InputEnded, function(i)
        if tDrag and isPointer(i) then tDrag = false; if not tMoved then main.Visible = not main.Visible end end
    end)
    connect(UserInputService.InputBegan, function(i, gp)
        if not gp and i.KeyCode == Enum.KeyCode.RightShift then main.Visible = not main.Visible end
    end)

    local tabbar = new("Frame", { Size=UDim2.new(1,-12,0,32), Position=UDim2.new(0,6,0,44), BackgroundTransparency=1 }, main)
    new("UIListLayout", { FillDirection=Enum.FillDirection.Horizontal, Padding=UDim.new(0,3), SortOrder=Enum.SortOrder.LayoutOrder }, tabbar)

    local holder = new("ScrollingFrame", { Size=UDim2.new(1,-12,1,-86), Position=UDim2.fromOffset(6,80), BackgroundTransparency=1,
        BorderSizePixel=0, ScrollBarThickness=3, ScrollBarImageColor3=T.accent, CanvasSize=UDim2.new(), AutomaticCanvasSize=Enum.AutomaticSize.Y }, main)
    new("UIListLayout", { Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder }, holder)

    local win, tabs, active = { main = main }, {}, nil
    local function selectTab(t)
        active = t
        for _, o in pairs(tabs) do
            o.container.Visible = (o == t)
            o.btn.BackgroundColor3 = (o == t) and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(24, 18, 42)
            o.btn.TextColor3 = (o == t) and Color3.fromRGB(255, 255, 255) or T.dim
        end
    end

    function win:Tab(name)
        local btn = new("TextButton", { Size=UDim2.new(0.24,0,1,0), BackgroundColor3=Color3.fromRGB(24, 18, 42), BackgroundTransparency=0.3,
            Text="<b>" .. name .. "</b>", TextColor3=T.dim, Font=Enum.Font.GothamBold, TextSize=10, RichText=true, LayoutOrder=#tabs + 1 }, tabbar)
        round(btn, 6)

        local container = new("ScrollingFrame", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, BorderSizePixel=0,
            ScrollBarThickness=3, ScrollBarImageColor3=T.accent, CanvasSize=UDim2.new(),
            AutomaticCanvasSize=Enum.AutomaticSize.Y, Visible=false }, holder)
        new("UIListLayout", { Padding=UDim.new(0,6), SortOrder=Enum.SortOrder.LayoutOrder }, container)
        new("UIPadding", { PaddingRight=UDim.new(0,4) }, container)

        local t = { btn = btn, container = container }
        table.insert(tabs, t)
        connect(btn.MouseButton1Click, function() selectTab(t) end)
        if not active then selectTab(t) end
        local order = 0
        local function nxt() order += 1; return order end

        local function row(h) local f = new("Frame", { Size=UDim2.new(1,-4,0,h), BackgroundColor3=T.card, BackgroundTransparency=0.25, BorderSizePixel=0, LayoutOrder=nxt() }, container); round(f, 6); return f end
        local function label(parent, txt, size, color, align)
            return new("TextLabel", { Size=UDim2.new(1,-10,1,0), Position=UDim2.fromOffset(10,0), BackgroundTransparency=1, Text="<b>" .. txt .. "</b>",
                TextColor3=color or T.text, Font=Enum.Font.GothamBold, TextSize=size or 11, RichText=true, TextXAlignment=align or Enum.TextXAlignment.Left }, parent)
        end

        function t:Section(txt)
            local f = new("TextLabel", { Size=UDim2.new(1,0,0,22), BackgroundTransparency=1, Text="<b>" .. string.upper(txt) .. "</b>", LayoutOrder=nxt(), TextColor3=T.accent,
                Font=Enum.Font.GothamBold, TextSize=11, RichText=true, TextXAlignment=Enum.TextXAlignment.Left }, container)
            new("UIPadding", { PaddingLeft=UDim.new(0,4) }, f)
        end
        function t:Label(txt) local r = row(28); label(r, txt, 11, T.dim) end
        function t:Toggle(txt, key, cb)
            local r = row(40)
            local b = new("TextButton", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="" }, r)
            label(r, txt)
            local pill = new("Frame", { Size=UDim2.fromOffset(40,20), Position=UDim2.new(1,-46,0.5,-10), BackgroundColor3=T.off }, r); round(pill, 10)
            local dot = new("Frame", { Size=UDim2.fromOffset(16,16), Position=UDim2.fromOffset(2,2), BackgroundColor3=Color3.fromRGB(255,255,255) }, pill); round(dot, 8)
            local function refresh()
                local on = P.Flags[key]
                TweenService:Create(pill, TweenInfo.new(0.2), { BackgroundColor3 = on and T.on or T.off }):Play()
                TweenService:Create(dot, TweenInfo.new(0.2), { Position = on and UDim2.fromOffset(22,2) or UDim2.fromOffset(2,2) }):Play()
            end
            P.Refresh["t_" .. key] = refresh; refresh()
            connect(b.MouseButton1Click, function()
                P.Flags[key] = not P.Flags[key]; refresh()
                if cb then pcall(cb, P.Flags[key]) end
            end)
        end
        function t:Button(txt, cb, color)
            local b = new("TextButton", { Size=UDim2.new(1,-4,0,38), BackgroundColor3=color or Color3.fromRGB(35,28,65), LayoutOrder=nxt(), Text="<b>" .. txt .. "</b>",
                TextColor3=T.text, Font=Enum.Font.GothamBold, TextSize=11, RichText=true }, container)
            round(b, 6); connect(b.MouseButton1Click, function() pcall(cb) end)
        end
        function t:Slider(txt, key, min, max, step, cb)
            local r = row(44)
            local lbl = new("TextLabel", { Size=UDim2.new(1,-20,0,20), Position=UDim2.fromOffset(10,3), BackgroundTransparency=1,
                TextColor3=T.text, Font=Enum.Font.GothamBold, TextSize=11, RichText=true, TextXAlignment=Enum.TextXAlignment.Left }, r)
            local track = new("Frame", { Size=UDim2.new(1,-20,0,6), Position=UDim2.fromOffset(10,30), BackgroundColor3=T.off }, r); round(track, 3)
            local fill = new("Frame", { Size=UDim2.new(0,0,1,0), BackgroundColor3=T.accent }, track); round(fill, 3)
            local function show()
                local v = P.Flags[key]
                fill.Size = UDim2.new(math.clamp((v - min) / (max - min), 0, 1), 0, 1, 0)
                lbl.Text = "<b>" .. txt .. ": <font color=\"#00E5FF\">" .. tostring(math.floor(v * 100 + 0.5) / 100) .. "</font></b>"
            end
            P.Refresh["s_" .. key] = show; show()
            local dragging = false
            local function set(x)
                local rel = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
                local v = min + (max - min) * rel
                v = math.clamp(math.floor(v / step + 0.5) * step, min, max)
                P.Flags[key] = v; show()
                if cb then pcall(cb, v) end
            end
            connect(r.InputBegan, function(i) if isPointer(i) then dragging = true; set(i.Position.X) end end)
            connect(UserInputService.InputChanged, function(i) if dragging and isMove(i) then set(i.Position.X) end end)
            connect(UserInputService.InputEnded, function(i) if isPointer(i) then dragging = false end end)
        end
        function t:Dropdown(txt, key, options, cb)
            local b = new("TextButton", { Size=UDim2.new(1,-4,0,38), BackgroundColor3=T.card, BackgroundTransparency=0.25, Text="", AutoButtonColor=true, LayoutOrder=nxt() }, container)
            round(b, 6)
            local l = label(b, "")
            local function show() l.Text = "<b>" .. txt .. ': <font color="#00E5FF">' .. tostring(P.Flags[key]) .. "</font></b>" end
            P.Refresh["d_" .. key] = show; show()
            connect(b.MouseButton1Click, function()
                local idx = table.find(options, P.Flags[key]) or 0
                P.Flags[key] = options[idx % #options + 1]; show()
                if cb then pcall(cb, P.Flags[key]) end
            end)
        end
        function t:Input(txt, get, set)
            local r = row(40)
            local lbl = new("TextLabel", { Size=UDim2.new(0.5,0,1,0), Position=UDim2.fromOffset(10,0), BackgroundTransparency=1,
                Text="<b>" .. txt .. "</b>", TextColor3=T.text, Font=Enum.Font.GothamBold, TextSize=11, RichText=true, TextXAlignment=Enum.TextXAlignment.Left }, r)
            local box = new("TextBox", { Size=UDim2.fromOffset(90,24), Position=UDim2.new(1,-96,0.5,-12), BackgroundColor3=Color3.fromRGB(35,28,65),
                Text=tostring(get()), TextColor3=T.accent, Font=Enum.Font.GothamBold, TextSize=11, ClearTextOnFocus=false }, r)
            round(box, 4)
            P.Refresh["i_" .. txt] = function() box.Text = tostring(get()) end
            connect(box.FocusLost, function() set(box.Text) end)
        end
        return t
    end
    return win
end

-- Features Implementation
local function setFpsBoost(on)
    pcall(function()
        if on then
            UserGameSettings.SavedQualityLevel = Enum.SavedQualityLevel.Level01
            Lighting.GlobalShadows = false
            Lighting.Brightness = 2
            for _, v in ipairs(Workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Smoke") then
                    v.Enabled = false
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v.Transparency = 1
                end
            end
        else
            UserGameSettings.SavedQualityLevel = Enum.SavedQualityLevel.Level21
            Lighting.GlobalShadows = true
        end
    end)
end

local function setUncap(on)
    if not setfpscap then return end
    if on then
        if Orig.FpsCap == nil then Orig.FpsCap = (getfpscap and getfpscap()) or 60 end
        setfpscap(999)
    else
        setfpscap(Orig.FpsCap or 60); Orig.FpsCap = nil
    end
end

local invisCache = setmetatable({}, { __mode = "k" })
local function setInvisible(on)
    local c = LP.Character; if not c then return end
    for _, d in ipairs(c:GetDescendants()) do
        if d:IsA("BasePart") and d.Name ~= "HumanoidRootPart" then
            if on then invisCache[d] = invisCache[d] or d.Transparency; d.Transparency = 1
            elseif invisCache[d] then d.Transparency = invisCache[d]; invisCache[d] = nil end
        elseif d:IsA("Decal") then
            if on then invisCache[d] = invisCache[d] or d.Transparency; d.Transparency = 1
            elseif invisCache[d] then d.Transparency = invisCache[d]; invisCache[d] = nil end
        end
    end
end

local collideCache = setmetatable({}, { __mode = "k" })
local function setCollide(part, on)
    if on then
        local o = collideCache[part]
        if o ~= nil then part.CanCollide = o; collideCache[part] = nil end
    else
        if collideCache[part] == nil then collideCache[part] = part.CanCollide end
        part.CanCollide = false
    end
end
local function restoreCollide()
    for part, o in pairs(collideCache) do pcall(function() part.CanCollide = o end); collideCache[part] = nil end
end

local function restoreCharacter()
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    local bv = root and root:FindFirstChild("PascuaFly"); if bv then bv:Destroy() end
    restoreCollide()
    setInvisible(false)
    local h = getHum()
    if h then
        if P.SpeedTouched then h.WalkSpeed = Orig.WalkSpeed or 16 end
        pcall(function()
            h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        end)
    end
end

local function hookHumanoid()
    local h = getHum(); if not h then return end
    connect(h.HealthChanged, function(hp)
        if P.Flags.GodMode and hp > 0 and hp < h.MaxHealth then h.Health = h.MaxHealth end
    end)
    connect(h.StateChanged, function(_, new)
        if P.Flags.AntiRagdoll and (new == Enum.HumanoidStateType.Ragdoll or new == Enum.HumanoidStateType.FallingDown) then
            h:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end)
end

local function installPlayerHooks()
    connect(RunService.RenderStepped, function()
        local root, hum = getRoot(), getHum()
        if not root then return end
        local bv = root:FindFirstChild("PascuaFly")
        if P.Flags.Fly and hum then
            bv = bv or new("BodyVelocity", { Name="PascuaFly", MaxForce=Vector3.one * 1e5, Velocity=Vector3.zero }, root)
            local up = (UserInputService:IsKeyDown(Enum.KeyCode.Space) and 1 or 0) - (UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and 1 or 0)
            bv.Velocity = (hum.MoveDirection + Vector3.yAxis * up) * P.Flags.FlySpeed
        elseif bv then bv:Destroy() end
    end)
    local noclipWas = false
    connect(RunService.Stepped, function()
        if P.Flags.Noclip and LP.Character then
            noclipWas = true
            for _, p in ipairs(LP.Character:GetDescendants()) do if p:IsA("BasePart") then setCollide(p, false) end end
        elseif noclipWas then
            noclipWas = false; restoreCollide()
        end
    end)
    connect(UserInputService.JumpRequest, function()
        if P.Flags.InfiniteJump then local h = getHum(); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end
    end)
    connect(LP.Idled, function()
        if P.Flags.AntiAFK then
            pcall(function()
                local vu = game:GetService("VirtualUser"); vu:CaptureController(); vu:ClickButton2(Vector2.new())
            end)
        end
    end)
    connect(LP.CharacterAdded, function(char)
        Orig.WalkSpeed = nil; P.SpeedTouched = false; P.RagdollOff = false
        local r = char:WaitForChild("HumanoidRootPart", 10); if not r then return end
        task.wait(1)
        if not P.BaseLocked then P.Base = r.CFrame end
        if P.Flags.Invisible then setInvisible(true) end
        hookHumanoid()
    end)

    local reconnecting = false
    local function rejoin(why)
        if reconnecting or not (P.Flags.AutoReconnect and P.Running) then return end
        reconnecting = true
        notify("Brineland", "Reconnecting (" .. why .. ")...", 4)
        task.wait(2)
        if P.Running then pcall(TeleportService.TeleportToPlaceInstance, TeleportService, game.PlaceId, game.JobId, LP) end
        task.wait(10); reconnecting = false
    end
    connect(GuiService.ErrorMessageChanged, function(msg) if msg ~= "" then rejoin("error message") end end)
    pcall(function()
        local overlay = CoreGui.RobloxPromptGui.promptOverlay
        connect(overlay.ChildAdded, function(c) if c.Name == "ErrorPrompt" then rejoin("disconnect prompt") end end)
    end)
    connect(TeleportService.TeleportInitFailed, function()
        if P.Flags.AutoReconnect and P.Running then pcall(TeleportService.Teleport, TeleportService, game.PlaceId, LP) end
    end)
end

-- ESP Drawings
local function drawing(key)
    local d = P.Drawings[key]
    if not d then
        d = Drawing.new("Text"); d.Size = 14; d.Center = true; d.Outline = true; d.OutlineColor = Color3.new()
        P.Drawings[key] = d
    end
    return d
end

local function espStep()
    local f, used = P.Flags, {}
    local root = getRoot()
    local cam = Workspace.CurrentCamera
    if root and Drawing and (f.EggESP or f.PlayerESP or f.PenEggESP or f.EventESP) then
        local targets = {}
        if f.EggESP then
            for _, e in ipairs(scanEggs()) do
                if e.part.Parent and passesFilter(e) then targets[#targets+1] = { e.part, e.name, Color3.fromRGB(255,200,70) } end
            end
        end
        if f.PlayerESP then
            for _, pl in ipairs(Players:GetPlayers()) do
                local hrp = pl ~= LP and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
                if hrp then targets[#targets+1] = { hrp, pl.Name, Color3.fromRGB(255,80,80) } end
            end
        end
        if f.PenEggESP or f.EventESP then
            if tick() - (P.EspScan or 0) > 2 then
                P.EspScan, P.EspCache = tick(), {}
                for _, o in ipairs(Workspace:GetDescendants()) do
                    local n = o.Name:lower()
                    local pen = o:IsA("Model") and n:find("pen", 1, true)
                    local ev = n:find("rift", 1, true) or n:find("boss", 1, true) or n:find("event", 1, true)
                    if pen or ev then
                        local part = o:IsA("BasePart") and o or (o:IsA("Model") and (o.PrimaryPart or o:FindFirstChildWhichIsA("BasePart")))
                        if part then P.EspCache[#P.EspCache+1] = { part, o.Name, pen and "pen" or "ev" } end
                    end
                end
            end
            for _, c in ipairs(P.EspCache or {}) do
                if c[1].Parent and ((c[3] == "pen" and f.PenEggESP) or (c[3] == "ev" and f.EventESP)) then
                    targets[#targets+1] = { c[1], c[2], c[3] == "pen" and Color3.fromRGB(80,200,255) or Color3.fromRGB(200,100,255) }
                end
            end
        end
        for _, t in ipairs(targets) do
            local d = (t[1].Position - root.Position).Magnitude
            if d <= f.ESPDistance then
                local dr = drawing(t[1])
                local sp, on = cam:WorldToViewportPoint(t[1].Position)
                dr.Visible = on
                if on then
                    dr.Position = Vector2.new(sp.X, sp.Y); dr.Text = ("%s [%d]"):format(t[2], math.floor(d)); dr.Color = t[3]
                end
                used[t[1]] = true
            end
        end
    end
    for key, dr in pairs(P.Drawings) do
        if not used[key] then pcall(function() dr:Remove() end); P.Drawings[key] = nil end
    end
end

-- Hub Initializer & UI Layout
local function openHub()
    P.Running = true
    local win = createWindow("Brineland Hub | Steal an Egg")
    local Farm, Pred, Rift = win:Tab("Farm"), win:Tab("Predict"), win:Tab("Rift")
    local Vis, Ply, Srv, Cfg = win:Tab("Visuals"), win:Tab("Player"), win:Tab("Server"), win:Tab("Config")

    Farm:Section("Eggs")
    Farm:Toggle("Auto Steal", "AutoSteal")
    Farm:Toggle("Instant Steal (Teleport)", "InstantSteal")
    Farm:Toggle("Auto Return to Base", "AutoReturn")
    Farm:Slider("Steal Delay (s)", "StealDelay", 0.1, 3, 0.05)
    Farm:Button("⚡ Steal Nearest Now", function() local e = closestEgg(); if e then stealEgg(e) end end, Color3.fromRGB(0, 160, 240))
    Farm:Button("🏠 Set Base Here (Lock)", function()
        local r = getRoot(); if r then P.Base = r.CFrame; P.BaseLocked = true; notify("Brineland", "Base locked here.") end
    end)
    
    Farm:Section("Pets & Inventory")
    for _, p in ipairs({ {"Auto Hatch","AutoHatch"}, {"Auto Equip Best","AutoEquipBest"}, {"Auto Place","AutoPlace"},
        {"Auto Sell Egg","AutoSellEgg"}, {"Auto Sell Pet","AutoSellPet"}, {"Auto Fuse","AutoFuse"}, {"Auto Favorite","AutoFavorite"} }) do
        Farm:Toggle(p[1], p[2])
    end

    Farm:Section("Progression")
    Farm:Toggle("Auto Treadmill", "AutoTreadmill")
    Farm:Toggle("Auto Upgrade Treadmill", "AutoUpgradeTread")
    Farm:Slider("Treadmill Tier", "TreadmillTier", 1, 20, 1)
    Farm:Toggle("Auto Upgrade Base", "AutoUpgradeBase")
    Farm:Toggle("Auto Buy Trail", "AutoTrail")
    Farm:Toggle("Auto Claim Rewards", "AutoClaim")

    Pred:Toggle("Egg Spawn Predictor", "EggPredictor")
    Pred:Toggle("Egg Preview Card", "PreviewCard")
    Pred:Toggle("Webhook Alerts", "WebhookAlert")
    Pred:Input("Webhook URL", function() return P.Flags.WebhookURL end, function(v) P.Flags.WebhookURL = v end)
    Pred:Button("🔮 Show Egg Predictions", function()
        local e = predictEggs()
        notify("Egg Predictor", #e > 0 and table.concat(e, "\n") or "Needs 3+ observed spawns per egg", 6)
    end, Color3.fromRGB(0, 160, 240))

    Rift:Toggle("Auto Rift Farm", "AutoRift")
    Rift:Toggle("Auto Rift Place", "AutoRiftPlace")
    Rift:Toggle("Auto Rift Trade", "AutoRiftTrade")
    Rift:Toggle("Auto Boss Farm", "AutoBoss")
    Rift:Toggle("Wait at Last Pity", "WaitLastPity")

    if Drawing then
        Vis:Toggle("Egg ESP", "EggESP")
        Vis:Toggle("Player ESP", "PlayerESP")
        Vis:Toggle("Pen Egg ESP", "PenEggESP")
        Vis:Toggle("Event ESP", "EventESP")
        Vis:Slider("ESP Distance", "ESPDistance", 500, 10000, 100)
    else
        Vis:Label("ESP requires Drawing API.")
    end
    Vis:Dropdown("Min Rarity", "MinRarity", { "All", "Common", "Uncommon", "Rare", "Epic", "Legendary", "Divine", "Secret", "Mythic" })

    Ply:Slider("WalkSpeed", "Speed", 16, 300, 1)
    Ply:Toggle("Fly", "Fly")
    Ply:Slider("Fly Speed", "FlySpeed", 10, 300, 5)
    Ply:Toggle("Noclip", "Noclip")
    Ply:Toggle("Infinite Jump", "InfiniteJump")
    Ply:Toggle("Keep HP Full", "GodMode")
    Ply:Toggle("Invisible", "Invisible", setInvisible)
    Ply:Toggle("Anti Ragdoll", "AntiRagdoll")

    -- Player Sound Replacement & Combat Tabs
    Ply:Section("Custom Sound & Combat Engine")
    Ply:Toggle("Custom Key Sounds", "KeySounds", function(state)
        ToggleGameSoundMute(state)
    end)

    -- Sound Selector Dropdown
    local soundSelectorBtn = new("TextButton", { Size=UDim2.new(1,-4,0,38), BackgroundColor3=T.card, BackgroundTransparency=0.25, Text="<b>Sound Select: <font color=\"#00E5FF\">" .. SelectedSoundName .. "</font></b>", TextColor3=T.text, Font=Enum.Font.GothamBold, TextSize=11, RichText=true }, Ply.container)
    round(soundSelectorBtn, 6)

    local soundDropdownContainer = new("ScrollingFrame", { Size=UDim2.new(1,-4,0,110), BackgroundColor3=Color3.fromRGB(18, 14, 35), BackgroundTransparency=0.2, ScrollBarThickness=3, Visible=false }, Ply.container)
    round(soundDropdownContainer, 6)
    local soundDropLayout = new("UIListLayout", { Padding=UDim.new(0, 4) }, soundDropdownContainer)

    for profileName, _ in pairs(SoundProfiles) do
        local sBtn = new("TextButton", { Size=UDim2.new(1,-6,0,30), BackgroundColor3=Color3.fromRGB(35, 28, 65), Text="<b>" .. profileName .. "</b>", TextColor3=Color3.fromRGB(220, 220, 240), Font=Enum.Font.GothamBold, TextSize=10, RichText=true }, soundDropdownContainer)
        round(sBtn, 4)
        connect(sBtn.MouseButton1Click, function()
            SelectedSoundName = profileName
            soundSelectorBtn.Text = "<b>Sound Select: <font color=\"#00E5FF\">" .. profileName .. "</font></b>"
            soundDropdownContainer.Visible = false
        end)
    end
    connect(soundSelectorBtn.MouseButton1Click, function() soundDropdownContainer.Visible = not soundDropdownContainer.Visible end)

    Ply:Toggle("Auto Hit (Equipped Bat)", "AutoHit")
    Ply:Slider("Hit Range (Studs)", "HitRange", 1, 50, 1)

    Srv:Toggle("Anti AFK", "AntiAFK")
    Srv:Toggle("Lag Reducer (FPS Boost)", "LagReducer", function(on) pcall(setFpsBoost, on) end)
    Srv:Toggle("Uncap FPS", "UncapFPS", function(on) pcall(setUncap, on) end)
    Srv:Toggle("FPS Overlay", "FPSOverlay")
    Srv:Toggle("Ping Overlay", "PingOverlay")
    Srv:Toggle("Auto Reconnect", "AutoReconnect")
    Srv:Toggle("Auto Server Hop", "AutoHop")
    Srv:Slider("Hop if players ≤", "HopThreshold", 0, 10, 1)
    Srv:Button("🔄 Server Hop", serverHop, Color3.fromRGB(0, 160, 240))

    Cfg:Section("Profile & Remotes")
    Cfg:Button("💾 Save Config", saveCfg, Color3.fromRGB(0, 160, 240))
    Cfg:Button("📂 Load Config", loadCfg, Color3.fromRGB(35, 28, 65))
    Cfg:Input("Target Area", function() return P.Flags.TargetArea end, function(v) P.Flags.TargetArea = v end)
    Cfg:Input("Specific Egg", function() return P.Flags.SpecificEgg end, function(v) P.Flags.SpecificEgg = v end)

    -- Setup Loops & Background Tasks
    local r = getRoot(); if r then P.Base = r.CFrame end
    installPlayerHooks()
    hookHumanoid()
    connect(Workspace.DescendantAdded, function(inst) if P.Flags.EggPredictor then recordEgg(inst) end end)

    every(0.4, function()
        if P.Flags.AutoSteal and alive() and not P.Stealing then local e = closestEgg(); if e then stealEgg(e) end end
    end)
    every(1, function()
        local f, R = P.Flags, P.Remotes
        if f.AutoTreadmill then fireRemote(R.Treadmill) end
        if f.AutoUpgradeTread then for i = 1, f.TreadmillTier do fireRemote(R.Upgrade, i) end end
        if f.AutoUpgradeBase then fireRemote(R.UpgradeBase) end
    end)
    every(1.5, function()
        local f, R = P.Flags, P.Remotes
        if f.AutoHatch then fireRemote(R.Hatch, args(f.HatchArg)) end
        if f.AutoPlace then fireRemote(R.Place) end
        if f.AutoSellEgg then fireRemote(R.SellEgg) end
        if f.AutoSellPet then fireRemote(R.SellPet) end
        if f.AutoFuse then fireRemote(R.Fuse) end
        if f.AutoFavorite then fireRemote(R.Favorite, args(f.FavArg)) end
    end)
    every(5, function()
        if P.Flags.AutoEquipBest then fireRemote(P.Remotes.EquipBest, args(P.Flags.EquipArg)) end
    end)
    every(2, function()
        local f, R = P.Flags, P.Remotes
        if f.AutoRift then fireRemote(R.Rift, args(f.RiftFarmArg)) end
        if f.AutoRiftPlace then fireRemote(R.Rift, args(f.RiftPlaceArg)) end
        if f.AutoRiftTrade then fireRemote(R.Rift, args(f.RiftTradeArg)) end
        if f.AutoBoss then fireRemote(R.Boss, args(f.BossFarmArg)) end
        if f.WaitLastPity then fireRemote(R.Rift, args(f.PityArg)) end
    end)
    every(5, function()
        if P.Flags.AutoTrail then fireRemote(P.Remotes.Treadmill, "BuyTrail") end
        if P.Flags.AutoClaim then fireRemote(P.Remotes.Claim, "All") end
    end)
    every(10, function()
        if P.Flags.AutoHop and #Players:GetPlayers() - 1 <= P.Flags.HopThreshold and tick() - (P.LastHop or 0) > 30 then
            P.LastHop = tick(); serverHop()
        end
    end)

    -- Auto Hit Combat Loop
    every(0.08, function()
        if P.Flags.AutoHit then
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local tool = char and char:FindFirstChildOfClass("Tool")
            if hrp and tool then
                local targetFound = false
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if (obj:IsA("Model") and obj ~= char and obj:FindFirstChildOfClass("Humanoid")) or (obj.Name == "Hitbox" and obj.Parent ~= char and not obj:IsDescendantOf(char)) then
                        local targetPart = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")) or obj
                        if targetPart and targetPart:IsA("BasePart") then
                            if (targetPart.Position - hrp.Position).Magnitude <= P.Flags.HitRange then
                                targetFound = true
                                break
                            end
                        end
                    end
                end
                if targetFound then tool:Activate() end
            end
        end
    end)

    every(0.2, function()
        local h, f = getHum(), P.Flags
        if h then
            if f.Speed > 16 then
                if h.WalkSpeed ~= f.Speed then
                    if not P.SpeedTouched then Orig.WalkSpeed = h.WalkSpeed end
                    h.WalkSpeed = f.Speed; P.SpeedTouched = true
                end
            elseif P.SpeedTouched then
                h.WalkSpeed = Orig.WalkSpeed or 16; P.SpeedTouched = false
            end
            if f.GodMode and h.Health > 0 then h.Health = h.MaxHealth end
            if f.AntiRagdoll then
                P.RagdollOff = true
                h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                for _, n in ipairs({ "Ragdoll", "Ragdolled" }) do
                    if LP.Character:GetAttribute(n) then LP.Character:SetAttribute(n, false) end
                end
            elseif P.RagdollOff then
                P.RagdollOff = false
                h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
            end
        end
        if f.AntiTrap and LP.Character then
            for _, o in ipairs(LP.Character:GetDescendants()) do
                if o:IsA("BasePart") and o.Name:lower():find("trap", 1, true) then setCollide(o, false) end
            end
        end
    end)
    every(0.25, espStep)

    local frames, last, fps = 0, tick(), 0
    connect(RunService.RenderStepped, function()
        frames += 1
        if tick() - last >= 1 then fps, frames, last = frames, 0, tick() end
    end)

    -- Floating Overlay (FPS/Ping)
    local ogui = makeGui("BrinelandOverlay", 998)
    local ov = new("TextLabel", { Size=UDim2.fromOffset(110,34), Position=UDim2.new(0,15,0,75), BackgroundColor3=T.bg,
        BackgroundTransparency=0.2, Text="", TextColor3=T.accent, Font=Enum.Font.Code, TextSize=13, Visible=false, Active=true }, ogui)
    round(ov, 6); new("UIStroke", { Color=T.accent, Thickness=1 }, ov); makeDraggable(ov, ov)
    every(0.5, function()
        local parts = {}
        if P.Flags.FPSOverlay then parts[#parts+1] = "FPS  " .. fps end
        if P.Flags.PingOverlay then
            local ping = 0
            pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
            parts[#parts+1] = "PING " .. ping .. "ms"
        end
        ov.Visible = #parts > 0
        ov.Text = table.concat(parts, "\n")
        ov.Size = UDim2.fromOffset(110, 10 + 16 * math.max(#parts, 1))
    end)

    notify("Brineland Hub", "Steal an Egg loaded successfully!", 4)
end

function P.Destroy()
    P.Running = false
    ToggleGameSoundMute(false)
    for _, th in ipairs(P.Tasks) do pcall(task.cancel, th) end
    table.clear(P.Tasks)
    for _, c in ipairs(P.Conns) do pcall(function() c:Disconnect() end) end
    table.clear(P.Conns)
    for _, d in pairs(P.Drawings) do pcall(function() d:Remove() end) end
    table.clear(P.Drawings)
    for _, g in ipairs(P.Guis) do pcall(function() g:Destroy() end) end
    table.clear(P.Guis)
    table.clear(P.Refresh)
    pcall(restoreCharacter)
    pcall(function() if P.Flags.FPSBoost then setFpsBoost(false) end end)
    pcall(function() if P.Flags.UncapFPS then setUncap(false) end end)
    for _, fn in ipairs(P.Cleanups) do pcall(fn) end
    table.clear(P.Cleanups)
    env.PascuaHub = nil
end

loadCfg(true)
openHub()
