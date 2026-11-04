-- ==============================================================================
-- BRINELAND HUB: STEAL AN EGG V11.5 (ULTIMATE MASTER PRODUCTION EDITION)
-- Aesthetic: Brineland Cyber-Purple & Neon Cyan
-- ==============================================================================

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local TeleportService   = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace         = game:GetService("Workspace")
local Lighting          = game:GetService("Lighting")
local HttpService       = game:GetService("HttpService")
local Stats             = game:GetService("Stats")
local GuiService        = game:GetService("GuiService")

local LP = Players.LocalPlayer
local CFG_FILE = "BrinelandHub_StealAnEgg.json"

---------------------------------------------------------------- environment lookup (executor-safe)
local GENV = (type(getgenv) == "function" and getgenv()) or _G
local okEnv, SENV = pcall(function() return getfenv() end)
if not okEnv or type(SENV) ~= "table" then SENV = {} end
local function lookup(name) local v = GENV[name]; if v == nil then v = SENV[name] end; return v end
local function lookupFn(name) local v = lookup(name); if type(v) == "function" then return v end end
local function tableFn(tname, fname)
    local t = lookup(tname)
    if type(t) == "table" and type(t[fname]) == "function" then return t[fname] end
end

-- re-execute safe: tear down old instance
local prev = GENV.BrinelandHub
if type(prev) == "table" and type(prev.Destroy) == "function" then
    local okOld, errOld = pcall(prev.Destroy)
    if not okOld then warn("[Brineland] previous instance cleanup failed: " .. tostring(errOld)) end
end

local P = { Conns = {}, CharConns = {}, Guis = {}, Drawings = {}, Refresh = {}, Tasks = {}, Cleanups = {}, Clamp = {},
            Running = false, Stealing = false, Base = nil, BaseLocked = false, HookGen = 0,
            EggCache = {}, LastScan = 0, EggHistory = {}, Log = {}, Errors = {}, ErrorOrder = {}, ErrorOverflow = 0 }
GENV.BrinelandHub = P

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
}
P.Remotes = {
    Steal="StealEgg", Treadmill="Treadmill", Upgrade="UpgradeTreadmill", UpgradeBase="UpgradeBase",
    Hatch="HatchEgg", Place="PlaceEgg", SellEgg="SellEgg", SellPet="SellPet", Fuse="FusePet",
    EquipBest="EquipBestPets", Favorite="FavoritePet",
    Rift="RiftAction", Boss="BossAction", Butterfly="CatchButterfly", Event="EventAction", Claim="ClaimReward",
}
local VOLATILE = { Fly=1, Noclip=1, Invisible=1, GodMode=1, InfiniteJump=1, FPSBoost=1, UncapFPS=1, RemoteLog=1 }
local Orig = {} -- original values we change, so Destroy can restore them

---------------------------------------------------------------- diagnostics (no silent failures)
local MAX_ERRORS = 150
local function report(tag, err, quiet)
    local msg = tostring(err)
    local key = tag .. "|" .. msg
    local e = P.Errors[key]
    if e then e.n += 1; return end
    if #P.ErrorOrder >= MAX_ERRORS then
        local oldKey = table.remove(P.ErrorOrder, 1)
        P.Errors[oldKey] = nil
        P.ErrorOverflow += 1
    end
    P.Errors[key] = { tag = tag, err = msg, n = 1, quiet = quiet and true or false }
    P.ErrorOrder[#P.ErrorOrder + 1] = key
    if not quiet then warn(("[Brineland] %s: %s"):format(tag, msg)) end
end

local function try(tag, fn, ...)
    local ok, res = pcall(fn, ...)
    if not ok then report(tag, res) end
    return ok, res
end

local function tryQuiet(tag, fn, ...)
    local ok, res = pcall(fn, ...)
    if not ok then report(tag, res, true) end
    return ok, res
end

---------------------------------------------------------------- executor capabilities
local Cap = {}
do
    Cap.request     = lookupFn("request") or lookupFn("http_request") or tableFn("syn", "request")
                      or tableFn("http", "request") or tableFn("fluxus", "request")
    Cap.gethui      = lookupFn("gethui")
    Cap.setfpscap   = lookupFn("setfpscap")
    Cap.getfpscap   = lookupFn("getfpscap")
    Cap.hookmeta    = lookupFn("hookmetamethod")
    Cap.getnamecall = lookupFn("getnamecallmethod")
    Cap.hasNewC     = lookupFn("newcclosure") ~= nil
    Cap.newcclosure = lookupFn("newcclosure") or function(f) return f end
    Cap.checkcaller = lookupFn("checkcaller")
    Cap.hook        = (Cap.hookmeta ~= nil and Cap.getnamecall ~= nil)
    Cap.writefile   = lookupFn("writefile")
    Cap.readfile    = lookupFn("readfile")
    Cap.isfile      = lookupFn("isfile")
    Cap.fireprompt  = lookupFn("fireproximityprompt")
    Cap.fireclick   = lookupFn("fireclickdetector")
    Cap.clipboard   = lookupFn("setclipboard") or lookupFn("toclipboard")

    local D = lookup("Drawing")
    if D ~= nil and type(D.new) == "function" then
        local ok, err = pcall(function()
            local d = D.new("Text")
            d.Visible = false; d.Size = 14; d.Center = true; d.Outline = true; d.Text = ""
            d:Remove()
        end)
        if ok then Cap.drawing = D else report("capability:Drawing", err, true) end
    end
end

local function capLines()
    local function yn(v) return v and "yes" or "NO" end
    return {
        ("Drawing (ESP): %s"):format(yn(Cap.drawing)),
        ("gethui: %s (falls back to CoreGui/PlayerGui)"):format(yn(Cap.gethui)),
        ("hookmetamethod: %s (Anti Kick, Remote Logger)"):format(yn(Cap.hook)),
        ("request: %s (webhook, server hop)"):format(yn(Cap.request)),
        ("setfpscap: %s"):format(yn(Cap.setfpscap)),
        ("File I/O: %s"):format(yn(Cap.writefile and Cap.readfile)),
        ("fireproximityprompt: %s"):format(yn(Cap.fireprompt)),
    }
end

---------------------------------------------------------------- helpers
local function connect(sig, fn) local c = sig:Connect(fn); table.insert(P.Conns, c); return c end
local function spawnTask(fn) local th = task.spawn(fn); table.insert(P.Tasks, th); return th end
local function onCleanup(fn) table.insert(P.Cleanups, fn) end
local function args(s) if s == nil or s == "" then return end return s end
local function notify(title, text, dur)
    tryQuiet("notify", function()
        game:GetService("StarterGui"):SetCore("SendNotification", { Title=title, Text=text, Duration=dur or 3 })
    end)
end
local function getHum()  local c = LP.Character; return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot() local c = LP.Character; return c and c:FindFirstChild("HumanoidRootPart") end
local function alive()   local h = getHum(); return h and h.Health > 0 end
local function every(label, t, fn)
    spawnTask(function()
        while P.Running do
            local ok, err = pcall(fn)
            if not ok then report("loop:" .. label, err) end
            task.wait(t)
        end
    end)
end
local function httpGet(url)
    if Cap.request then
        local r = Cap.request({ Url = url, Method = "GET" })
        if not r then error("empty response") end
        if r.StatusCode and (r.StatusCode < 200 or r.StatusCode >= 300) then error("HTTP " .. tostring(r.StatusCode)) end
        return r.Body
    end
    return game:HttpGet(url)
end

local remoteCache, missCache = {}, {}
local function resolveRemote(name)
    if name == "" then return nil end
    local c = remoteCache[name]
    if c and c.Parent then return c end
    if missCache[name] and tick() - missCache[name] < 5 then return nil end
    local low = name:lower()
    local exact, strictPartial = nil, nil
    for _, o in ipairs(ReplicatedStorage:GetDescendants()) do
        if o:IsA("RemoteEvent") or o:IsA("RemoteFunction") then
            local n = o.Name:lower()
            if n == low then
                exact = o
                break
            elseif not strictPartial and (n:find("^" .. low) or n:find(low .. "$") or n:find("_" .. low .. "_") or n == low) then
                strictPartial = o
            end
        end
    end
    local found = exact or strictPartial
    remoteCache[name] = found
    missCache[name] = (not found) and tick() or nil
    return found
end

local function fireRemote(name, ...)
    local r, packed = resolveRemote(name), table.pack(...)
    if not r then report("remote", "not found in ReplicatedStorage: " .. tostring(name)); return false end
    task.spawn(function()
        try("remote:" .. r.Name, function()
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

---------------------------------------------------------------- eggs
local RARITY = { common=1, uncommon=2, rare=3, epic=4, legendary=5, divine=6, secret=7, mythic=8 }
local function rarityRank(name)
    local low, best = name:lower(), 0
    for r, rank in pairs(RARITY) do if low:find(r, 1, true) and rank > best then best = rank end end
    return best
end

local function isEggInstance(inst)
    if not (inst:IsA("Model") or inst:IsA("BasePart")) then return false end
    if not inst.Name:lower():find("egg", 1, true) then return false end
    if inst:IsA("BasePart") and inst.Parent and inst.Parent:IsA("Model") and inst.Parent.Name:lower():find("egg", 1, true) then
        return false
    end
    if LP.Character and inst:IsDescendantOf(LP.Character) then return false end
    return true
end

local function scanEggs(force)
    if not force and tick() - P.LastScan < 1 then return P.EggCache end
    local out = {}
    for _, o in ipairs(Workspace:GetDescendants()) do
        if isEggInstance(o) then
            local part = o:IsA("Model") and (o.PrimaryPart or o:FindFirstChildWhichIsA("BasePart", true)) or o
            if part then out[#out+1] = { object=o, part=part, name=o.Name, rarity=rarityRank(o.Name) } end
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
    if not Cap.request then report("webhook", "executor has no request function"); return end
    if not url:find("^https://") then report("webhook", "Webhook URL must start with https://"); return end
    task.spawn(function()
        try("webhook", function()
            local r = Cap.request({ Url=url, Method="POST", Headers={ ["Content-Type"]="application/json" },
                Body=HttpService:JSONEncode({ content=msg }) })
            if r and r.StatusCode and r.StatusCode >= 400 then error("HTTP " .. r.StatusCode) end
        end)
    end)
end

local function stealEgg(egg)
    if not egg or P.Stealing then return end
    local root = getRoot(); if not root then return end
    P.Stealing = true
    try("stealEgg", function()
        local home = P.Base or root.CFrame
        if P.Flags.InstantSteal then root.CFrame = egg.part.CFrame + Vector3.new(0, 3, 0); task.wait(0.15)
        else moveTo(egg.part.Position, 15) end
        local prompt = egg.object:FindFirstChildWhichIsA("ProximityPrompt", true)
        if prompt then
            if Cap.fireprompt then Cap.fireprompt(prompt)
            else prompt:InputHoldBegin(); task.wait(prompt.HoldDuration + 0.05); prompt:InputHoldEnd() end
        end
        local cd = egg.object:FindFirstChildWhichIsA("ClickDetector", true)
        if cd and Cap.fireclick then Cap.fireclick(cd) end
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

---------------------------------------------------------------- predictors / server
local function entry(name)
    local h = P.EggHistory[name]
    if not h then h = { spawn = {}, despawn = {}, present = 0 }; P.EggHistory[name] = h end
    return h
end

local function pushTime(list, t)
    if #list > 0 and t - list[#list] < 2 then return end
    list[#list+1] = t
    if #list > 12 then table.remove(list, 1) end
end

local function recordEgg(inst)  if isEggInstance(inst) then pushTime(entry(inst.Name).spawn, os.clock()) end end
local function recordGone(inst) if isEggInstance(inst) then pushTime(entry(inst.Name).despawn, os.clock()) end end

local function seedEggs()
    for _, h in pairs(P.EggHistory) do h.present = 0 end
    for _, e in ipairs(scanEggs(true)) do entry(e.name).present += 1 end
end

local function avgInterval(list)
    if #list < 3 then return nil end
    local sum = 0
    for i = 2, #list do sum += list[i] - list[i-1] end
    return sum / (#list - 1)
end

local function predictEggs()
    local ready, learning, now = {}, {}, os.clock()
    for name, h in pairs(P.EggHistory) do
        local avg, series, src = avgInterval(h.spawn), h.spawn, "spawn"
        if not avg then avg, series, src = avgInterval(h.despawn), h.despawn, "despawn" end
        if avg then
            ready[#ready+1] = { name = name, eta = math.max(0, series[#series] + avg - now), avg = avg, src = src }
        else
            learning[#learning+1] = ("%s: learning (%d seen, %d present)"):format(name, math.max(#h.spawn, #h.despawn), h.present)
        end
    end
    table.sort(ready, function(a, b) return a.eta < b.eta end)
    table.sort(learning)
    local lines = {}
    for _, o in ipairs(ready) do
        lines[#lines+1] = ("%s in ~%ds (every ~%ds, by %s)"):format(o.name, math.floor(o.eta), math.floor(o.avg), o.src)
    end
    for _, l in ipairs(learning) do lines[#lines+1] = l end
    while #lines > 6 do table.remove(lines) end
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
    local ok, body = try("serverHop:http", httpGet,
        ("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId))
    if ok and body then
        local okJ, data = try("serverHop:json", function() return HttpService:JSONDecode(body) end)
        if okJ and type(data) == "table" then
            local good = {}
            for _, s in ipairs(data.data or {}) do
                if s.id ~= game.JobId and s.playing < s.maxPlayers then good[#good+1] = s.id end
            end
            if #good > 0 then
                try("serverHop:teleport", TeleportService.TeleportToPlaceInstance, TeleportService,
                    game.PlaceId, good[math.random(#good)], LP)
                return
            end
        end
    end
    notify("Brineland", "No server found (see F9 for details).")
end

---------------------------------------------------------------- config & validation
local RANGE_VALIDATORS = {
    StealDelay = function(v) return math.clamp(v, 0.1, 3.0) end,
    FlySpeed = function(v) return math.clamp(v, 10, 300) end,
    ESPDistance = function(v) return math.clamp(v, 500, 10000) end,
    Speed = function(v) return math.clamp(v, 16, 300) end,
    HopThreshold = function(v) return math.clamp(v, 0, 10) end,
    TreadmillTier = function(v) return math.clamp(v, 1, 20) end,
}

local VALID_DROPDOWNS = {
    MinRarity = { "All", "Common", "Uncommon", "Rare", "Epic", "Legendary", "Divine", "Secret", "Mythic" }
}

local function saveCfg()
    if not Cap.writefile then notify("Brineland", "Save not supported by this executor."); return end
    local flags = {}
    for k, v in pairs(P.Flags) do if not VOLATILE[k] then flags[k] = v end end
    local ok = try("saveCfg", function()
        Cap.writefile(CFG_FILE, HttpService:JSONEncode({ Flags=flags, Remotes=P.Remotes }))
    end)
    notify("Brineland", ok and "Config saved." or "Save failed (see F9).")
end

local function loadCfg(silent)
    if not Cap.readfile then
        if not silent then notify("Brineland", "Load not supported by this executor.") end
        return
    end
    if Cap.isfile then
        local okF, exists = pcall(Cap.isfile, CFG_FILE)
        if okF and not exists then
            if not silent then notify("Brineland", "No config found.") end
            return
        end
    end
    local ok, data = try("loadCfg", function() return HttpService:JSONDecode(Cap.readfile(CFG_FILE)) end)
    if not ok or type(data) ~= "table" then
        if not silent then notify("Brineland", "Config unreadable (see F9).") end
        return
    end
    for k, v in pairs(data.Flags or {}) do
        if P.Flags[k] ~= nil and type(v) == type(P.Flags[k]) and not VOLATILE[k] then
            if RANGE_VALIDATORS[k] and type(v) == "number" then
                P.Flags[k] = RANGE_VALIDATORS[k](v)
            elseif VALID_DROPDOWNS[k] and type(v) == "string" then
                if table.find(VALID_DROPDOWNS[k], v) then
                    P.Flags[k] = v
                end
            else
                P.Flags[k] = v
            end
        end
    end
    for k, v in pairs(data.Remotes or {}) do
        if P.Remotes[k] ~= nil and type(v) == "string" then P.Remotes[k] = v end
    end
    table.clear(remoteCache); table.clear(missCache)
    for key, fn in pairs(P.Refresh) do try("refresh:" .. key, fn) end
    if P.Flags.EggPredictor and P.Running then seedEggs() end
    if not silent then notify("Brineland", "Config loaded.") end
end

---------------------------------------------------------------- UI library (Brineland Cyber-Purple Theme)
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
local function isPointer(i) return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch end
local function isMove(i) return i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch end

local function parentCandidates()
    local list = {}
    if Cap.gethui then
        local ok, h = pcall(Cap.gethui)
        if ok and typeof(h) == "Instance" then list[#list+1] = h end
    end
    list[#list+1] = game:GetService("CoreGui")
    local pg = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 10)
    if pg then list[#list+1] = pg end
    return list
end

local function makeGui(name, order)
    local g = Instance.new("ScreenGui")
    g.Name, g.ResetOnSpawn, g.DisplayOrder = name, false, order
    g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    g.IgnoreGuiInset = true
    local placed = false
    for _, parent in ipairs(parentCandidates()) do
        local ok = tryQuiet("gui:parent", function() g.Parent = parent end)
        if ok and g.Parent == parent then placed = true; break end
    end
    if not placed then g:Destroy(); error("no usable GUI parent") end
    table.insert(P.Guis, g)
    return g
end

local function clampOnScreen(f)
    local gui = f:FindFirstAncestorOfClass("ScreenGui")
    if not gui then return end
    local view, ap, as = gui.AbsoluteSize, f.AbsolutePosition, f.AbsoluteSize
    if view.X <= 0 or view.Y <= 0 or as.X <= 0 or as.Y <= 0 then return end
    local m = 6
    local x = math.clamp(ap.X, m, math.max(m, view.X - as.X - m))
    local y = math.clamp(ap.Y, m, math.max(m, view.Y - as.Y - m))
    if x == ap.X and y == ap.Y then return end
    local sc = f:FindFirstChildOfClass("UIScale")
    local s = sc and sc.Scale or 1
    local p = f.Position
    f.Position = UDim2.new(p.X.Scale, p.X.Offset + (x - ap.X) / s, p.Y.Scale, p.Y.Offset + (y - ap.Y) / s)
end

local function registerClamp(f) P.Clamp[#P.Clamp+1] = f end
local function reclampAll()
    for _, f in ipairs(P.Clamp) do
        if f.Parent then tryQuiet("clamp", clampOnScreen, f) end
    end
end

local function makeDraggable(handle, target)
    registerClamp(target)
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
    local gui = makeGui("BrinelandHub", 999)
    local main = new("Frame", { Size=UDim2.fromOffset(540, 380), Position=UDim2.new(0.5,-270,0.5,-190),
        BackgroundColor3=T.bg, BorderSizePixel=0 }, gui)
    round(main, 10)
    new("UIStroke", { Color=T.accent, Thickness=1.5 }, main)

    local uiScale = new("UIScale", {}, main)
    local function viewSize()
        local s = gui.AbsoluteSize
        if s.X > 0 and s.Y > 0 then return s end
        local cam = Workspace.CurrentCamera
        return cam and cam.ViewportSize or Vector2.new(1280, 720)
    end
    local function applyScale()
        local v = viewSize()
        uiScale.Scale = math.clamp(math.min(v.X / 560, v.Y / 400), 0.5, 1)
    end
    local pending = false
    local function onViewport()
        applyScale()
        if pending then return end
        pending = true
        task.wait()
        pending = false
        reclampAll()
    end
    applyScale()
    connect(gui:GetPropertyChangedSignal("AbsoluteSize"), onViewport)
    local camConn
    local function bindCam()
        if camConn then camConn:Disconnect() end
        local cam = Workspace.CurrentCamera
        if cam then camConn = connect(cam:GetPropertyChangedSignal("ViewportSize"), onViewport) end
    end
    bindCam()
    connect(Workspace:GetPropertyChangedSignal("CurrentCamera"), function() bindCam(); onViewport() end)

    local top = new("Frame", { Size=UDim2.new(1,0,0,40), BackgroundColor3=T.side, BorderSizePixel=0 }, main)
    round(top, 10)
    new("TextLabel", { Size=UDim2.new(1,-200,1,0), Position=UDim2.fromOffset(14,0), BackgroundTransparency=1, Text=title,
        TextColor3=T.accent, Font=Enum.Font.GothamBold, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left }, top)
    local overlay = new("TextLabel", { Size=UDim2.fromOffset(150,40), Position=UDim2.new(1,-196,0,0), BackgroundTransparency=1,
        Text="", TextColor3=T.dim, Font=Enum.Font.Code, TextSize=11, TextXAlignment=Enum.TextXAlignment.Right }, top)
    local function topBtn(txt, x, fn)
        local b = new("TextButton", { Size=UDim2.fromOffset(28,28), Position=UDim2.new(1,x,0,6), BackgroundColor3=T.card,
            Text=txt, TextColor3=T.text, Font=Enum.Font.GothamBold, TextSize=15, AutoButtonColor=true }, top)
        round(b, 6); connect(b.MouseButton1Click, fn)
    end
    topBtn("×", -34, function() P.Destroy() end)
    topBtn("–", -64, function() main.Visible = not main.Visible end)
    makeDraggable(top, main)

    local tgui = makeGui("BrinelandToggle", 998)
    local tb = new("TextButton", { Size=UDim2.fromOffset(45,45), Position=UDim2.new(0,15,0.5,-22), BackgroundColor3=T.side,
        Text="<b><font color=\"#00E5FF\">BRINE</font></b>", TextColor3=T.text, Font=Enum.Font.GothamBold, TextSize=11, RichText=true, AutoButtonColor=true }, tgui)
    round(tb, 22); new("UIStroke", { Color=T.accent, Thickness=1.5 }, tb)
    registerClamp(tb)
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

    local side = new("ScrollingFrame", { Size=UDim2.new(0,120,1,-48), Position=UDim2.fromOffset(4,44), BackgroundColor3=T.side,
        BorderSizePixel=0, ScrollBarThickness=0, CanvasSize=UDim2.new(), AutomaticCanvasSize=Enum.AutomaticSize.Y }, main)
    round(side, 8)
    new("UIListLayout", { Padding=UDim.new(0,3), SortOrder=Enum.SortOrder.LayoutOrder }, side)
    new("UIPadding", { PaddingTop=UDim.new(0,5), PaddingLeft=UDim.new(0,5), PaddingRight=UDim.new(0,5) }, side)
    local holder = new("Frame", { Size=UDim2.new(1,-134,1,-52), Position=UDim2.fromOffset(128,46), BackgroundTransparency=1 }, main)

    local win, tabs, active = { overlay = overlay, main = main }, {}, nil
    local function selectTab(t)
        active = t
        for _, o in pairs(tabs) do
            o.page.Visible = (o == t)
            o.btn.BackgroundColor3 = (o == t) and T.hover or T.card
            o.btn.TextColor3 = (o == t) and T.accent or T.dim
        end
    end

    function win:Tab(name)
        local btn = new("TextButton", { Size=UDim2.new(1,0,0,28), BackgroundColor3=T.card, Text=name, TextColor3=T.dim,
            Font=Enum.Font.GothamMedium, TextSize=12, LayoutOrder=#tabs + 1 }, side)
        round(btn, 5)
        local page = new("ScrollingFrame", { Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, BorderSizePixel=0,
            ScrollBarThickness=3, ScrollBarImageColor3=T.accent, CanvasSize=UDim2.new(),
            AutomaticCanvasSize=Enum.AutomaticSize.Y, Visible=false }, holder)
        new("UIListLayout", { Padding=UDim.new(0,5), SortOrder=Enum.SortOrder.LayoutOrder }, page)
        new("UIPadding", { PaddingRight=UDim.new(0,6) }, page)
        local t = { btn = btn, page = page }
        table.insert(tabs, t)
        connect(btn.MouseButton1Click, function() selectTab(t) end)
        if not active then selectTab(t) end
        local order = 0
        local function nxt() order += 1; return order end

        local function row(h) local f = new("Frame", { Size=UDim2.new(1,0,0,h), BackgroundColor3=T.card, BorderSizePixel=0, LayoutOrder=nxt() }, page); round(f, 6); return f end
        local function label(parent, txt, size, color, align)
            return new("TextLabel", { Size=UDim2.new(1,-20,1,0), Position=UDim2.fromOffset(10,0), BackgroundTransparency=1, Text=txt,
                TextColor3=color or T.text, Font=Enum.Font.Gotham, TextSize=size or 12, TextXAlignment=align or Enum.TextXAlignment.Left }, parent)
        end

        function t:Section(txt)
            local f = new("TextLabel", { Size=UDim2.new(1,0,0,20), BackgroundTransparency=1, Text=string.upper(txt), LayoutOrder=nxt(), TextColor3=T.accent,
                Font=Enum.Font.GothamBold, TextSize=11, TextXAlignment=Enum.TextXAlignment.Left }, page)
            new("UIPadding", { PaddingLeft=UDim.new(0,4) }, f)
        end
        function t:Label(txt) local r = row(26); label(r, txt, 11, T.dim) end
        function t:Toggle(txt, key, cb)
            local r = row(30)
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
                if cb then try("toggle:" .. key, cb, P.Flags[key]) end
            end)
        end
        function t:Button(txt, cb, color)
            local b = new("TextButton", { Size=UDim2.new(1,0,0,32), BackgroundColor3=color or T.hover, LayoutOrder=nxt(), Text=txt,
                TextColor3=T.text, Font=Enum.Font.GothamBold, TextSize=12 }, page)
            round(b, 6); connect(b.MouseButton1Click, function() try("button:" .. txt, cb) end)
        end
        function t:Slider(txt, key, min, max, step, cb)
            local r = row(44)
            local lbl = new("TextLabel", { Size=UDim2.new(1,-20,0,20), Position=UDim2.fromOffset(10,3), BackgroundTransparency=1,
                TextColor3=T.text, Font=Enum.Font.Gotham, TextSize=11, TextXAlignment=Enum.TextXAlignment.Left }, r)
            local track = new("Frame", { Size=UDim2.new(1,-20,0,6), Position=UDim2.fromOffset(10,30), BackgroundColor3=T.off }, r); round(track, 3)
            local fill = new("Frame", { Size=UDim2.new(0,0,1,0), BackgroundColor3=T.accent }, track); round(fill, 3)
            local function show()
                local v = P.Flags[key] or min
                fill.Size = UDim2.new(math.clamp((v - min) / (max - min), 0, 1), 0, 1, 0)
                lbl.Text = txt .. ": " .. tostring(math.floor(v * 100 + 0.5) / 100)
            end
            P.Refresh["s_" .. key] = show; show()
            local dragging = false
            local function set(x)
                local rel = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
                local v = min + (max - min) * rel
                v = math.clamp(math.floor(v / step + 0.5) * step, min, max)
                if RANGE_VALIDATORS[key] then v = RANGE_VALIDATORS[key](v) end
                P.Flags[key] = v; show()
                if cb then try("slider:" .. key, cb, v) end
            end
            connect(r.InputBegan, function(i) if isPointer(i) then dragging = true; set(i.Position.X) end end)
            connect(UserInputService.InputChanged, function(i) if dragging and isMove(i) then set(i.Position.X) end end)
            connect(UserInputService.InputEnded, function(i) if isPointer(i) then dragging = false end end)
        end
        function t:Dropdown(txt, key, options, cb)
            local b = new("TextButton", { Size=UDim2.new(1,0,0,32), BackgroundColor3=T.card, Text="", AutoButtonColor=true, LayoutOrder=nxt() }, page)
            round(b, 6)
            local l = label(b, "")
            local function show() l.Text = txt .. ":  " .. tostring(P.Flags[key]) end
            P.Refresh["d_" .. key] = show; show()
            connect(b.MouseButton1Click, function()
                local idx = table.find(options, P.Flags[key]) or 0
                P.Flags[key] = options[idx % #options + 1]; show()
                if cb then try("dropdown:" .. key, cb, P.Flags[key]) end
            end)
        end
        function t:Input(txt, get, set)
            local box = new("TextBox", { Size=UDim2.new(1,0,0,32), BackgroundColor3=T.card, PlaceholderText=txt, LayoutOrder=nxt(), Text=tostring(get()),
                TextColor3=T.text, PlaceholderColor3=T.dim, Font=Enum.Font.Gotham, TextSize=11, ClearTextOnFocus=false }, page)
            round(box, 6)
            P.Refresh["i_" .. txt] = function() box.Text = tostring(get()) end
            connect(box.FocusLost, function() try("input:" .. txt, set, box.Text) end)
        end
        return t
    end
    return win
end

---------------------------------------------------------------- player features
local invisCache = setmetatable({}, { __mode = "k" })
local invisConn
local function applyInvisible(d, on)
    if (d:IsA("BasePart") and d.Name ~= "HumanoidRootPart") or d:IsA("Decal") then
        if on then
            if invisCache[d] == nil then invisCache[d] = d.Transparency end
            d.Transparency = 1
        elseif invisCache[d] ~= nil then
            d.Transparency = invisCache[d]; invisCache[d] = nil
        end
    end
end

local function setInvisible(on)
    if invisConn then invisConn:Disconnect(); invisConn = nil end
    local c = LP.Character; if not c then return end
    for _, d in ipairs(c:GetDescendants()) do applyInvisible(d, on) end
    if on then
        invisConn = c.DescendantAdded:Connect(function(d)
            if P.Flags.Invisible then tryQuiet("invisible:add", applyInvisible, d, true) end
        end)
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
    for part, o in pairs(collideCache) do
        tryQuiet("collide:restore", function() part.CanCollide = o end)
        collideCache[part] = nil
    end
end

local fpsState
local function setFpsBoost(on)
    if on then
        if fpsState then return end
        local s = { prevShadows = Lighting.GlobalShadows, shadowsOwned = true, owned = {}, conns = {} }
        fpsState = s
        Lighting.GlobalShadows = false
        s.conns[#s.conns+1] = Lighting:GetPropertyChangedSignal("GlobalShadows"):Connect(function()
            if Lighting.GlobalShadows then s.shadowsOwned = false end
        end)
        local function take(d)
            if s.owned[d] ~= nil or not (d:IsA("PostEffect") and d.Enabled) then return end
            s.owned[d] = d.Enabled
            d.Enabled = false
            s.conns[#s.conns+1] = d:GetPropertyChangedSignal("Enabled"):Connect(function()
                if d.Enabled then s.owned[d] = nil end
            end)
        end
        for _, d in ipairs(Lighting:GetDescendants()) do take(d) end
        local cam = Workspace.CurrentCamera
        if cam then
            for _, d in ipairs(cam:GetChildren()) do take(d) end
            s.conns[#s.conns+1] = cam.ChildAdded:Connect(function(d) tryQuiet("fps:cam_child", take, d) end)
        end
        s.conns[#s.conns+1] = Lighting.DescendantAdded:Connect(function(d) tryQuiet("fps:take", take, d) end)
    else
        local s = fpsState; if not s then return end
        fpsState = nil
        for _, c in ipairs(s.conns) do c:Disconnect() end
        if s.shadowsOwned and Lighting.GlobalShadows == false then Lighting.GlobalShadows = s.prevShadows end
        for d, origEnabled in pairs(s.owned) do
            if d.Parent then d.Enabled = origEnabled end
        end
    end
end

local function setUncap(on)
    if not Cap.setfpscap then
        notify("Brineland", "Uncap FPS: executor has no setfpscap.")
        P.Flags.UncapFPS = false
        if P.Refresh.t_UncapFPS then P.Refresh.t_UncapFPS() end
        return
    end
    if on then
        if Orig.FpsCap == nil then Orig.FpsCap = (Cap.getfpscap and Cap.getfpscap()) or 60 end
        Cap.setfpscap(999)
    else
        Cap.setfpscap(Orig.FpsCap or 60); Orig.FpsCap = nil
    end
end

local function clearCharConns()
    for _, c in ipairs(P.CharConns) do tryQuiet("charconn:disconnect", function() c:Disconnect() end) end
    table.clear(P.CharConns)
end

local function restoreCharacter()
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    local bv = root and root:FindFirstChild("BrinelandFly"); if bv then bv:Destroy() end
    restoreCollide()
    setInvisible(false)
    local h = getHum()
    if h then
        if P.SpeedTouched then h.WalkSpeed = Orig.WalkSpeed or 16 end
        h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        if Orig.MaxHealth ~= nil then h.MaxHealth = Orig.MaxHealth end
        if Orig.Health ~= nil then h.Health = Orig.Health end
        if Orig.JumpPower ~= nil then h.JumpPower = Orig.JumpPower end
        if Orig.JumpHeight ~= nil then h.JumpHeight = Orig.JumpHeight end
        if Orig.AutoRotate ~= nil then h.AutoRotate = Orig.AutoRotate end
        if Orig.PlatformStand ~= nil then h.PlatformStand = Orig.PlatformStand end
    end
    P.SpeedTouched = false
    P.RagdollOff = false
end

local function hookHumanoid(char)
    clearCharConns()
    P.HookGen += 1
    local gen = P.HookGen
    char = char or LP.Character
    if not char then return end
    local h = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 10)
    if gen ~= P.HookGen or char ~= LP.Character then return end
    if not h then report("hookHumanoid", "Humanoid not found on character"); return end
    Orig.MaxHealth = h.MaxHealth
    Orig.Health = h.Health
    Orig.WalkSpeed = h.WalkSpeed
    Orig.JumpPower = h.JumpPower
    Orig.JumpHeight = h.JumpHeight
    Orig.AutoRotate = h.AutoRotate
    Orig.PlatformStand = h.PlatformStand
    table.insert(P.CharConns, h.HealthChanged:Connect(function(hp)
        if P.Flags.GodMode and hp > 0 and hp < h.MaxHealth then h.Health = h.MaxHealth end
    end))
    table.insert(P.CharConns, h.StateChanged:Connect(function(_, state)
        if P.Flags.AntiRagdoll and (state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown) then
            h:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end))
end

local function logCall(inst, method, packed)
    local ok, line = pcall(function()
        if typeof(inst) ~= "Instance" then return nil end
        local parts = {}
        for i = 1, packed.n do
            local v = packed[i]
            parts[i] = typeof(v) == "Instance" and v:GetFullName() or tostring(v)
        end
        return ("%s:%s(%s)"):format(inst.Name, method, table.concat(parts, ", "))
    end)
    if not ok then report("remotelog", line); return end
    if not line then return end
    P.Log[#P.Log+1] = line
    if #P.Log > 40 then table.remove(P.Log, 1) end
    warn("[Brineland log] " .. line)
end

local function installNamecallHook()
    if not Cap.hook then
        report("capability:hook", "hookmetamethod/getnamecallmethod unavailable: Anti Kick and Remote Logger are disabled", true)
        return
    end
    local old
    local ok, err = pcall(function()
        old = Cap.hookmeta(game, "__namecall", Cap.newcclosure(function(self, ...)
            if P.Running then
                local m = Cap.getnamecall()
                if m then
                    if P.Flags.AntiKick and self == LP and m:lower() == "kick" then return end
                    if P.Flags.RemoteLog and (m == "FireServer" or m == "InvokeServer")
                        and not (Cap.checkcaller and Cap.checkcaller()) then
                        local packed = table.pack(...)
                        task.defer(logCall, self, m, packed)
                    end
                end
            end
            return old(self, ...)
        end))
    end)
    if not ok or not old then
        report("hookmetamethod", ok and "returned no original function" or err)
        return
    end
    onCleanup(function() try("unhook:namecall", Cap.hookmeta, game, "__namecall", old) end)
end

local function installPlayerHooks()
    connect(RunService.RenderStepped, function()
        local root, hum = getRoot(), getHum()
        if not root then return end
        local bv = root:FindFirstChild("BrinelandFly")
        if P.Flags.Fly and hum then
            bv = bv or new("BodyVelocity", { Name="BrinelandFly", MaxForce=Vector3.one * 1e5, Velocity=Vector3.zero }, root)
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
            try("antiafk", function()
                local vu = game:GetService("VirtualUser"); vu:CaptureController(); vu:ClickButton2(Vector2.new())
            end)
        end
    end)
    connect(LP.CharacterAdded, function(char)
        Orig.WalkSpeed = nil; P.SpeedTouched = false; P.RagdollOff = false
        local r = char:WaitForChild("HumanoidRootPart", 10)
        if not r then report("respawn", "HumanoidRootPart missing after respawn"); return end
        if P.Flags.Invisible then setInvisible(true) end
        try("hookHumanoid", hookHumanoid, char)
        task.wait(1)
        if not P.BaseLocked then P.Base = r.CFrame end
    end)

    local reconnecting = false
    local function rejoin(why)
        if reconnecting or not (P.Flags.AutoReconnect and P.Running) then return end
        reconnecting = true
        notify("Brineland", "Reconnecting (" .. why .. ")...", 4)
        task.wait(2)
        if P.Running then try("rejoin", TeleportService.TeleportToPlaceInstance, TeleportService, game.PlaceId, game.JobId, LP) end
        task.wait(10); reconnecting = false
    end
    connect(GuiService.ErrorMessageChanged, function(msg) if msg ~= "" then rejoin("error message") end end)
    tryQuiet("reconnect:prompt", function()
        local overlay = game:GetService("CoreGui").RobloxPromptGui.promptOverlay
        connect(overlay.ChildAdded, function(c) if c.Name == "ErrorPrompt" then rejoin("disconnect prompt") end end)
    end)
    connect(TeleportService.TeleportInitFailed, function()
        if P.Flags.AutoReconnect and P.Running then try("reconnect:teleport", TeleportService.Teleport, TeleportService, game.PlaceId, LP) end
    end)
    installNamecallHook()
end

---------------------------------------------------------------- ESP
local function drawing(key)
    local d = P.Drawings[key]
    if not d then
        d = Cap.drawing.new("Text"); d.Size = 14; d.Center = true; d.Outline = true; d.OutlineColor = Color3.new()
        P.Drawings[key] = d
    end
    return d
end

local function espStep()
    if not Cap.drawing then return end
    local f, used = P.Flags, {}
    local root = getRoot()
    local cam = Workspace.CurrentCamera
    if root and cam and (f.EggESP or f.PlayerESP or f.PenEggESP or f.EventESP) then
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
        if not used[key] then tryQuiet("drawing:remove", function() dr:Remove() end); P.Drawings[key] = nil end
    end
end

---------------------------------------------------------------- hub
local function openHub()
    P.Running = true
    local win = createWindow("BRINELAND HUB  |  STEAL AN EGG V11.5")
    local Farm, Pred, Rift = win:Tab("Farm"), win:Tab("Predict"), win:Tab("Rift")
    local Vis, Ply, Srv, Cfg = win:Tab("Visuals"), win:Tab("Player"), win:Tab("Server"), win:Tab("Config")

    Farm:Section("Eggs")
    Farm:Toggle("Auto Steal", "AutoSteal"); Farm:Toggle("Instant Steal (teleport)", "InstantSteal")
    Farm:Toggle("Auto Return to Base", "AutoReturn")
    Farm:Slider("Steal Delay (s)", "StealDelay", 0.1, 3, 0.05)
    Farm:Button("⚡ Steal Nearest Now", function() local e = closestEgg(); if e then stealEgg(e) end end, Color3.fromRGB(0, 160, 240))
    Farm:Button("🏠 Set Base Here (lock)", function()
        local r = getRoot(); if r then P.Base = r.CFrame; P.BaseLocked = true; notify("Brineland", "Base locked here.") end
    end)
    Farm:Button("🏠 Auto Base (use spawn)", function()
        P.BaseLocked = false; local r = getRoot(); if r then P.Base = r.CFrame end; notify("Brineland", "Base follows spawn.")
    end)
    Farm:Section("Pets & Inventory")
    for _, p in ipairs({ {"Auto Hatch","AutoHatch"}, {"Auto Equip Best","AutoEquipBest"}, {"Auto Place","AutoPlace"},
        {"Auto Sell Egg","AutoSellEgg"}, {"Auto Sell Pet","AutoSellPet"}, {"Auto Fuse","AutoFuse"}, {"Auto Favorite","AutoFavorite"} }) do
        Farm:Toggle(p[1], p[2])
    end
    Farm:Section("Progression")
    Farm:Toggle("Auto Treadmill", "AutoTreadmill"); Farm:Toggle("Auto Upgrade Treadmill", "AutoUpgradeTread")
    Farm:Slider("Treadmill Tier", "TreadmillTier", 1, 20, 1)
    Farm:Toggle("Auto Upgrade Base", "AutoUpgradeBase"); Farm:Toggle("Auto Buy Trail", "AutoTrail"); Farm:Toggle("Auto Claim Rewards", "AutoClaim")

    Pred:Toggle("Egg Spawn Predictor", "EggPredictor", function(on) if on then seedEggs() end end)
    Pred:Toggle("Egg Preview Card", "PreviewCard")
    Pred:Toggle("Webhook Alerts", "WebhookAlert")
    if not Cap.request then Pred:Label("Webhooks need an executor with request().") end
    Pred:Input("Webhook URL", function() return P.Flags.WebhookURL end, function(v) P.Flags.WebhookURL = v end)
    Pred:Button("🔮 Show Egg Predictions", function()
        local e = predictEggs()
        notify("Egg Predictor", #e > 0 and table.concat(e, "\n") or "Turn on Egg Spawn Predictor and wait for a few spawns/despawns.", 6)
    end, Color3.fromRGB(0, 160, 240))
    Pred:Button("🌀 Show Rift Predictions", function()
        local out = {}
        for i, r in ipairs(predictRifts()) do if i > 5 then break end; out[#out+1] = ("%s (%dm)"):format(r.name, math.floor(r.d)) end
        notify("Rift Predictor", #out > 0 and table.concat(out, " | ") or "None", 5)
    end, Color3.fromRGB(0, 160, 240))

    Rift:Toggle("Auto Rift Farm", "AutoRift"); Rift:Toggle("Auto Rift Place", "AutoRiftPlace"); Rift:Toggle("Auto Rift Trade", "AutoRiftTrade")
    Rift:Toggle("Auto Boss Farm", "AutoBoss"); Rift:Toggle("Wait at Last Pity", "WaitLastPity")
    Rift:Button("🔥 Enter Rift Now", function() fireRemote(P.Remotes.Rift, "Enter") end, Color3.fromRGB(0, 160, 240))
    Rift:Button("👑 Fight Boss Now", function() fireRemote(P.Remotes.Boss, "Fight") end, Color3.fromRGB(0, 160, 240))

    if Cap.drawing then
        Vis:Toggle("Egg ESP", "EggESP"); Vis:Toggle("Player ESP", "PlayerESP")
        Vis:Toggle("Pen Egg ESP", "PenEggESP"); Vis:Toggle("Event ESP", "EventESP")
        Vis:Slider("ESP Distance", "ESPDistance", 500, 10000, 100)
    else
        Vis:Label("ESP needs a working Drawing API (not available here).")
    end
    Vis:Dropdown("Min Rarity", "MinRarity", { "All", "Common", "Uncommon", "Rare", "Epic", "Legendary", "Divine", "Secret", "Mythic" })

    Ply:Slider("WalkSpeed", "Speed", 16, 300, 1)
    Ply:Toggle("Fly", "Fly"); Ply:Slider("Fly Speed", "FlySpeed", 10, 300, 5)
    Ply:Toggle("Noclip", "Noclip"); Ply:Toggle("Infinite Jump", "InfiniteJump"); Ply:Toggle("Keep HP Full (local only)", "GodMode")
    Ply:Toggle("Invisible (local)", "Invisible", setInvisible)
    Ply:Toggle("Trap Collision Off (local only)", "AntiTrap"); Ply:Toggle("Anti Ragdoll (state based)", "AntiRagdoll")

    if Cap.hook then Srv:Toggle("Anti Kick (client)", "AntiKick") else Srv:Label("Anti Kick needs hookmetamethod.") end
    Srv:Toggle("Anti AFK", "AntiAFK")
    Srv:Toggle("FPS Boost", "FPSBoost", setFpsBoost)
    if Cap.setfpscap then Srv:Toggle("Uncap FPS", "UncapFPS", setUncap) else Srv:Label("Uncap FPS needs setfpscap.") end
    Srv:Toggle("FPS Overlay", "FPSOverlay"); Srv:Toggle("Ping Overlay", "PingOverlay")
    Srv:Toggle("Auto Reconnect", "AutoReconnect"); Srv:Toggle("Auto Server Hop", "AutoHop")
    Srv:Slider("Hop if players ≤", "HopThreshold", 0, 10, 1)
    Srv:Button("🔄 Server Hop", serverHop, Color3.fromRGB(0, 160, 240))
    Srv:Button("📋 Copy Job ID", function()
        if not Cap.clipboard then notify("Brineland", "No clipboard function in this executor."); return end
        Cap.clipboard(game.JobId); notify("Brineland", "Job ID copied.")
    end)
    Srv:Input("Job ID to join (Enter)", function() return "" end, function(v)
        if v ~= "" then try("joinJob", TeleportService.TeleportToPlaceInstance, TeleportService, game.PlaceId, v, LP) end
    end)

    Cfg:Section("Profile")
    Cfg:Button("💾 Save Config", saveCfg, Color3.fromRGB(0, 160, 240)); Cfg:Button("📂 Load Config", loadCfg, Color3.fromRGB(35, 28, 65))
    Cfg:Section("Filters")
    Cfg:Input("Target Area contains", function() return P.Flags.TargetArea end, function(v) P.Flags.TargetArea = v end)
    Cfg:Input("Specific Egg contains", function() return P.Flags.SpecificEgg end, function(v) P.Flags.SpecificEgg = v end)
    Cfg:Section("Remote arguments (sent with the call; blank = none)")
    for _, a in ipairs({ { "Hatch arg", "HatchArg" }, { "Equip Best arg", "EquipArg" }, { "Favorite arg", "FavArg" },
        { "Rift Farm arg", "RiftFarmArg" }, { "Rift Place arg", "RiftPlaceArg" }, { "Rift Trade arg", "RiftTradeArg" },
        { "Boss Farm arg", "BossFarmArg" }, { "Pity arg", "PityArg" } }) do
        Cfg:Input(a[1], function() return P.Flags[a[2]] end, function(v) P.Flags[a[2]] = v end)
    end
    Cfg:Section("Remote discovery")
    if Cap.hook then
        Cfg:Toggle("Remote Logger (do the action in-game, then print)", "RemoteLog")
        Cfg:Button("🖨 Print Logged Calls (F9 console)", function()
            for _, l in ipairs(P.Log) do print("[Brineland log] " .. l) end
            notify("Brineland", #P.Log .. " calls logged. Open the console (F9).")
        end)
    else
        Cfg:Label("Remote Logger needs hookmetamethod.")
    end
    Cfg:Button("🔎 Check Remote Names", function()
        local ok, bad = {}, {}
        for k, v in pairs(P.Remotes) do table.insert(resolveRemote(v) and ok or bad, k) end
        table.sort(ok); table.sort(bad)
        notify("Remotes", ("Found: %s\nMissing: %s"):format(table.concat(ok, ", "), #bad > 0 and table.concat(bad, ", ") or "none"), 8)
    end)
    Cfg:Section("Remote names")
    local names = {}
    for k in pairs(P.Remotes) do names[#names+1] = k end
    table.sort(names)
    for _, k in ipairs(names) do
        Cfg:Input(k .. " remote", function() return P.Remotes[k] end, function(v)
            P.Remotes[k] = v; table.clear(remoteCache); table.clear(missCache)
        end)
    end
    Cfg:Button("Rescan remotes", function() table.clear(remoteCache); table.clear(missCache); notify("Brineland", "Remote cache cleared.") end)
    Cfg:Section("Diagnostics")
    for _, line in ipairs(capLines()) do Cfg:Label(line) end
    Cfg:Button("🐞 Print Errors (F9 console)", function()
        for _, key in ipairs(P.ErrorOrder) do
            local e = P.Errors[key]
            print(("[Brineland error] %s x%d%s: %s"):format(e.tag, e.n, e.quiet and " (expected)" or "", e.err))
        end
        notify("Brineland", ("%d distinct errors recorded (+%d dropped). See console (F9)."):format(#P.ErrorOrder, P.ErrorOverflow))
    end, Color3.fromRGB(220, 35, 70))

    local r = getRoot(); if r then P.Base = r.CFrame end
    installPlayerHooks()
    spawnTask(function() try("hookHumanoid", hookHumanoid, LP.Character) end)
    if P.Flags.EggPredictor then try("seedEggs", seedEggs) end
    connect(Workspace.DescendantAdded, function(inst) if P.Flags.EggPredictor then tryQuiet("predictor:add", recordEgg, inst) end end)
    connect(Workspace.DescendantRemoving, function(inst) if P.Flags.EggPredictor then tryQuiet("predictor:gone", recordGone, inst) end end)

    every("autosteal", 0.4, function()
        if P.Flags.AutoSteal and alive() and not P.Stealing then local e = closestEgg(); if e then stealEgg(e) end end
    end)
    every("progress", 1, function()
        local f, R = P.Flags, P.Remotes
        if f.AutoTreadmill then fireRemote(R.Treadmill) end
        if f.AutoUpgradeTread then for i = 1, f.TreadmillTier do fireRemote(R.Upgrade, i) end end
        if f.AutoUpgradeBase then fireRemote(R.UpgradeBase) end
    end)
    every("pets", 1.5, function()
        local f, R = P.Flags, P.Remotes
        if f.AutoHatch then fireRemote(R.Hatch, args(f.HatchArg)) end
        if f.AutoPlace then fireRemote(R.Place) end
        if f.AutoSellEgg then fireRemote(R.SellEgg) end
        if f.AutoSellPet then fireRemote(R.SellPet) end
        if f.AutoFuse then fireRemote(R.Fuse) end
        if f.AutoFavorite then fireRemote(R.Favorite, args(f.FavArg)) end
    end)
    every("equipbest", 5, function()
        if P.Flags.AutoEquipBest then fireRemote(P.Remotes.EquipBest, args(P.Flags.EquipArg)) end
    end)
    every("rift", 2, function()
        local f, R = P.Flags, P.Remotes
        if f.AutoRift then fireRemote(R.Rift, args(f.RiftFarmArg)) end
        if f.AutoRiftPlace then fireRemote(R.Rift, args(f.RiftPlaceArg)) end
        if f.AutoRiftTrade then fireRemote(R.Rift, args(f.RiftTradeArg)) end
        if f.AutoBoss then fireRemote(R.Boss, args(f.BossFarmArg)) end
        if f.WaitLastPity then fireRemote(R.Rift, args(f.PityArg)) end
    end)
    every("claim", 5, function()
        if P.Flags.AutoTrail then fireRemote(P.Remotes.Treadmill, "BuyTrail") end
        if P.Flags.AutoClaim then fireRemote(P.Remotes.Claim, "All") end
    end)
    every("autohop", 10, function()
        if P.Flags.AutoHop and #Players:GetPlayers() - 1 <= P.Flags.HopThreshold and tick() - (P.LastHop or 0) > 30 then
            P.LastHop = tick(); serverHop()
        end
    end)
    every("character", 0.2, function()
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
                local char = LP.Character
                if char then
                    for _, n in ipairs({ "Ragdoll", "Ragdolled" }) do
                        if char:GetAttribute(n) then char:SetAttribute(n, false) end
                    end
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
    every("esp", 0.25, espStep)

    local frames, last, fps = 0, tick(), 0
    connect(RunService.RenderStepped, function()
        frames += 1
        if tick() - last >= 1 then fps, frames, last = frames, 0, tick() end
    end)

    local ogui = makeGui("BrinelandOverlay", 998)
    local ov = new("TextLabel", { Size=UDim2.fromOffset(110,34), Position=UDim2.new(0,15,0,75), BackgroundColor3=T.bg,
        BackgroundTransparency=0.2, Text="", TextColor3=T.accent, Font=Enum.Font.Code, TextSize=13, Visible=false, Active=true }, ogui)
    round(ov, 6); new("UIStroke", { Color=T.accent, Thickness=1 }, ov); makeDraggable(ov, ov)
    every("overlay", 0.5, function()
        local parts = {}
        if P.Flags.FPSOverlay then parts[#parts+1] = "FPS  " .. fps end
        if P.Flags.PingOverlay then
            local ping = 0
            tryQuiet("overlay:ping", function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
            parts[#parts+1] = "PING " .. ping .. "ms"
        end
        ov.Visible = #parts > 0
        ov.Text = table.concat(parts, "\n")
        ov.Size = UDim2.fromOffset(110, 10 + 16 * math.max(#parts, 1))
    end)

    local cgui = makeGui("BrinelandPreview", 997)
    local card = new("Frame", { Size=UDim2.fromOffset(250,80), Position=UDim2.new(1,-270,0,60), BackgroundColor3=T.bg,
        BorderSizePixel=0, Visible=false, Active=true }, cgui)
    round(card, 8); new("UIStroke", { Color=T.accent, Thickness=1 }, card); makeDraggable(card, card)
    new("TextLabel", { Size=UDim2.new(1,-16,0,20), Position=UDim2.fromOffset(8,4), BackgroundTransparency=1, Text="EGG PREVIEW",
        TextColor3=T.accent, Font=Enum.Font.GothamBold, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left }, card)
    local cardBody = new("TextLabel", { Size=UDim2.new(1,-16,1,-28), Position=UDim2.fromOffset(8,26), BackgroundTransparency=1,
        Text="", TextColor3=T.text, Font=Enum.Font.Gotham, TextSize=11, TextWrapped=true,
        TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top }, card)
    every("preview", 1, function()
        if not P.Flags.PreviewCard then card.Visible = false; return end
        card.Visible = true
        local lines, root, e = {}, getRoot(), closestEgg()
        if e and root then
            lines[1] = ("Nearest: %s (rarity %d, %dm)"):format(e.name, e.rarity, math.floor((e.part.Position - root.Position).Magnitude))
        else lines[1] = "Nearest: none" end
        local pr = predictEggs()
        if #pr == 0 then lines[#lines+1] = P.Flags.EggPredictor and "Learning spawn timings..." or "Enable Egg Spawn Predictor" end
        for _, l in ipairs(pr) do lines[#lines+1] = l end
        while #lines > 6 do table.remove(lines) end
        cardBody.Text = table.concat(lines, "\n")
        card.Size = UDim2.fromOffset(250, 34 + 16 * #lines)
        clampOnScreen(card)
    end)
    notify("Brineland Hub V11.5", "Loaded. RightShift toggles the menu.", 4)
end

---------------------------------------------------------------- lifecycle
function P.Destroy()
    P.Running = false
    for _, th in ipairs(P.Tasks) do tryQuiet("destroy:task", task.cancel, th) end
    table.clear(P.Tasks)
    for _, c in ipairs(P.Conns) do tryQuiet("destroy:disconnect", function() c:Disconnect() end) end
    table.clear(P.Conns)
    clearCharConns()
    for _, d in pairs(P.Drawings) do tryQuiet("destroy:drawing", function() d:Remove() end) end
    table.clear(P.Drawings)
    for _, g in ipairs(P.Guis) do tryQuiet("destroy:gui", function() g:Destroy() end) end
    table.clear(P.Guis); table.clear(P.Clamp)
    table.clear(P.Refresh)
    try("destroy:restoreCharacter", restoreCharacter)
    if fpsState then try("destroy:fps", setFpsBoost, false) end
    if Orig.FpsCap ~= nil then try("destroy:uncap", setUncap, false) end
    for _, fn in ipairs(P.Cleanups) do try("destroy:cleanup", fn) end
    table.clear(P.Cleanups)
    P.Stealing, P.Base, P.BaseLocked, P.SpeedTouched, P.RagdollOff = false, nil, false, false, false
    table.clear(P.EggCache); table.clear(P.EggHistory); table.clear(P.Log)
    if GENV.BrinelandHub == P then GENV.BrinelandHub = nil end
end

loadCfg(true)
local okStart, errStart = pcall(openHub)
if not okStart then
    warn("[Brineland] startup failed: " + tostring(errStart))
    notify("Brineland", "Startup failed - see the F9 console.", 6)
    tryQuiet("startup:destroy", P.Destroy)
end
