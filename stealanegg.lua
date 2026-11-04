-- ==============================================================================
-- BRINELAND HUB: STEAL AN EGG V10.2 (DEFINITIVE PRODUCTION MASTER)
-- Repository: https://github.com/DCBHEROBRINE/BRINELAND-HUB.git
-- ==============================================================================

local getenv = getgenv or function() return _G end
local env = getenv()

if env.PascuaHub and env.PascuaHub.Destroy then 
    pcall(env.PascuaHub.Destroy) 
end

local function cloneRef(obj)
    local ok, res = pcall(function()
        if cloneref then return cloneref(obj) end
        return obj
    end)
    return ok and res or obj
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

local okSettings, userGameSettings = pcall(function() return UserSettings():GetService("UserGameSettings") end)
local UserGameSettings = okSettings and userGameSettings or nil

local LP = Players.LocalPlayer
local CFG_FILE = "BrinelandHub_StealAnEgg.json"

local P = { 
    Conns = {}, Guis = {}, Drawings = {}, Refresh = {}, Tasks = {}, Cleanups = {},
    Running = false, Stealing = false, Base = nil, BaseLocked = false,
    EggCache = {}, LastScan = 0, EggHistory = {}, Log = {},
    Errors = {}, ErrorOrder = {}, LastSync = 0, EggCount = 0
}
env.PascuaHub = P

local DEFAULT_FLAGS = {
    AutoSteal=false, InstantSteal=false, AutoReturn=true, StealDelay=0.4,
    AutoHatch=false, AutoEquipBest=false, AutoPlace=false, AutoSellEgg=false,
    AutoSellPet=false, AutoFuse=false, AutoFavorite=false,
    TargetArea="", MinRarity="All", SpecificEgg="",
    EggPredictor=true, PreviewCard=true, ShowLearning=true, ResyncInterval=30, MaxPredictions=8,
    WebhookAlert=false, WebhookURL="",
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

P.Flags = {}
for k, v in pairs(DEFAULT_FLAGS) do P.Flags[k] = v end

P.Remotes = {
    Steal="StealEgg", Treadmill="Treadmill", Upgrade="UpgradeTreadmill", UpgradeBase="UpgradeBase",
    Hatch="HatchEgg", Place="PlaceEgg", SellEgg="SellEgg", SellPet="SellPet", Fuse="FusePet",
    EquipBest="EquipBestPets", Favorite="FavoritePet",
    Rift="RiftAction", Boss="BossAction", Butterfly="CatchButterfly", Event="EventAction", Claim="ClaimReward",
}

local VOLATILE = { Fly=1, Noclip=1, Invisible=1, GodMode=1, InfiniteJump=1, FPSBoost=1, UncapFPS=1, RemoteLog=1, KeySounds=1, LagReducer=1 }
local Orig = { SoundVolumes = {}, VisualStates = {}, Collisions = {}, LagReducerConn = nil, FpsCap = nil }

-- Compatibility & Safe Wrappers
local httpInvoke = (syn and syn.request) or (http and http.request) or request or function(t)
    if t.Method == "GET" then return { Body = game:HttpGet(t.Url) } end
    return nil
end

local function safeGet(url)
    local ok, res = pcall(function() return httpInvoke({ Url = url, Method = "GET" }) end)
    if ok and res then return res.Body or res end
    return nil
end

local function safeFpsCap(val)
    pcall(function() if setfpscap then setfpscap(val) end end)
end

local function safeGetFpsCap()
    local ok, res = pcall(function()
        if getfpscap then return getfpscap() end
        return 60
    end)
    return ok and res or 60
end

-- Diagnostics & Safe Execution (Rolling Queue for Max Errors)
local MAX_ERRORS = 50
local function report(tag, err)
    local message = tostring(err)
    local key = tostring(tag) .. "|" .. message
    if P.Errors[key] then P.Errors[key].Count += 1; return end
    if #P.ErrorOrder >= MAX_ERRORS then
        local oldestKey = table.remove(P.ErrorOrder, 1)
        P.Errors[oldestKey] = nil
    end
    P.Errors[key] = { Tag = tostring(tag), Message = message, Count = 1, Time = os.date("%H:%M:%S") }
    table.insert(P.ErrorOrder, key)
    warn("[Brineland V10.2] " .. tostring(tag) .. ": " .. message)
end

local function safe(tag, callback, ...)
    local ok, result = pcall(callback, ...)
    if not ok then report(tag, result) end
    return ok, result
end

local function args(s) if s == nil or s == "" then return end return s end

-- Sound Profiles Mapping
local SoundProfiles = {
    ["Water Drop"]          = "rbxassetid://403292408",
    ["Slime Jump"]          = "rbxassetid://344167846",
    ["Keyboard Chocolate"]  = "rbxassetid://125115489291773",
    ["Rain Sounds Lava"]    = "rbxassetid://104929259130147",
    ["Keyboard Typing SFX"] = "rbxassetid://9116157306"
}
local SelectedSoundName = "Water Drop"

local function connect(sig, fn) 
    local c = sig:Connect(function(...)
        local ok, err = pcall(fn, ...)
        if not ok then report("connection", err) end
    end)
    table.insert(P.Conns, c)
    return c 
end

local function spawnTask(name, interval, fn)
    local th = task.spawn(function()
        while P.Running do
            safe("loop:" .. name, fn)
            task.wait(interval)
        end
    end)
    table.insert(P.Tasks, th)
    return th
end

local function notify(title, text, dur)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", { Title=title, Text=text, Duration=dur or 3 })
    end)
end

local function getHum()  local c = LP.Character; return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot() local c = LP.Character; return c and c:FindFirstChild("HumanoidRootPart") end
local function alive()   local h = getHum(); return h and h.Health > 0 and getRoot() ~= nil end

local remoteCache = {}
local function resolveRemote(name)
    if name == "" then return nil end
    if remoteCache[name] and remoteCache[name].Parent then return remoteCache[name] end
    
    local low = name:lower()
    for _, o in ipairs(ReplicatedStorage:GetDescendants()) do
        if (o:IsA("RemoteEvent") or o:IsA("RemoteFunction")) and o.Name:lower() == low then
            remoteCache[name] = o
            return o
        end
    end
    return nil
end

local function fireRemote(name, ...)
    local r, packed = resolveRemote(name), table.pack(...)
    if not r then return false end
    local success, res = pcall(function()
        if r:IsA("RemoteEvent") then
            r:FireServer(table.unpack(packed, 1, packed.n))
            return true
        else
            return r:InvokeServer(table.unpack(packed, 1, packed.n))
        end
    end)
    if P.Flags.RemoteLog then
        table.insert(P.Log, { Time = os.date("%H:%M:%S"), Remote = name, Success = success })
        if #P.Log > 200 then table.remove(P.Log, 1) end
    end
    return success, res
end

local function moveTo(pos, timeout)
    local hum = getHum(); if not hum then return end
    hum:MoveTo(pos)
    local t = tick()
    while P.Running and getRoot() and (getRoot().Position - pos).Magnitude > 5 and tick() - t < (timeout or 12) do
        task.wait(0.1)
    end
end

-- Feature Handlers
local SoundMuteConnections = {}
local ToggleGameSoundMute = function(enable)
    for _, conn in ipairs(SoundMuteConnections) do if conn then conn:Disconnect() end end
    SoundMuteConnections = {}

    local function muteObj(obj)
        if obj:IsA("Sound") then
            local n = obj.Name:lower()
            if n:find("keyboard") or n:find("type") or n:find("typing") or n:find("key") or n:find("click") then
                pcall(function()
                    if enable then
                        if Orig.SoundVolumes[obj] == nil then Orig.SoundVolumes[obj] = obj.Volume end
                        obj.Volume = 0
                    else
                        if Orig.SoundVolumes[obj] ~= nil then
                            obj.Volume = Orig.SoundVolumes[obj]
                            Orig.SoundVolumes[obj] = nil
                        end
                    end
                end)
            end
        end
    end

    for _, v in ipairs(Workspace:GetDescendants()) do muteObj(v) end
    for _, v in ipairs(SoundService:GetDescendants()) do muteObj(v) end
    if LP.Character then for _, v in ipairs(LP.Character:GetDescendants()) do muteObj(v) end end

    if enable then
        table.insert(SoundMuteConnections, Workspace.DescendantAdded:Connect(muteObj))
        table.insert(SoundMuteConnections, SoundService.DescendantAdded:Connect(muteObj))
        table.insert(SoundMuteConnections, LP.CharacterAdded:Connect(function(char)
            table.insert(SoundMuteConnections, char.DescendantAdded:Connect(muteObj))
            for _, v in ipairs(char:GetDescendants()) do muteObj(v) end
        end))
    else
        Orig.SoundVolumes = {}
    end
end

local setFpsBoost = function(on)
    pcall(function()
        if Orig.LagReducerConn then
            Orig.LagReducerConn:Disconnect()
            Orig.LagReducerConn = nil
        end

        if on then
            if UserGameSettings then
                if Orig.VisualStates.Quality == nil then Orig.VisualStates.Quality = UserGameSettings.SavedQualityLevel end
                UserGameSettings.SavedQualityLevel = Enum.SavedQualityLevel.Level01
            end
            if Orig.VisualStates.Shadows == nil then Orig.VisualStates.Shadows = Lighting.GlobalShadows end
            if Orig.VisualStates.Brightness == nil then Orig.VisualStates.Brightness = Lighting.Brightness end
            Lighting.GlobalShadows = false
            Lighting.Brightness = 2

            local function optimizeObj(v)
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Smoke") then
                    if Orig.VisualStates[v] == nil then Orig.VisualStates[v] = v.Enabled end
                    v.Enabled = false
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    if Orig.VisualStates[v] == nil then Orig.VisualStates[v] = v.Transparency end
                    v.Transparency = 1
                end
            end

            for _, v in ipairs(Workspace:GetDescendants()) do optimizeObj(v) end
            Orig.LagReducerConn = Workspace.DescendantAdded:Connect(optimizeObj)
        else
            if UserGameSettings and Orig.VisualStates.Quality then UserGameSettings.SavedQualityLevel = Orig.VisualStates.Quality end
            if Orig.VisualStates.Shadows ~= nil then Lighting.GlobalShadows = Orig.VisualStates.Shadows end
            if Orig.VisualStates.Brightness ~= nil then Lighting.Brightness = Orig.VisualStates.Brightness else Lighting.Brightness = 1 end

            for k, originalState in pairs(Orig.VisualStates) do
                if typeof(k) == "Instance" and k.Parent then
                    if k:IsA("ParticleEmitter") or k:IsA("Trail") or k:IsA("Fire") or k:IsA("Sparkles") or k:IsA("Smoke") then
                        pcall(function() k.Enabled = originalState end)
                    elseif k:IsA("Decal") or k:IsA("Texture") then
                        pcall(function() k.Transparency = originalState end)
                    end
                end
            end
            Orig.VisualStates = {}
        end
    end)
end

local setUncap = function(on)
    if on then
        if Orig.FpsCap == nil then Orig.FpsCap = safeGetFpsCap() end
        safeFpsCap(999)
    else
        safeFpsCap(Orig.FpsCap or 60)
        Orig.FpsCap = nil
    end
end

local invisCache = setmetatable({}, { __mode = "k" })
local setInvisible = function(on)
    local c = LP.Character; if not c then return end
    for _, d in ipairs(c:GetDescendants()) do
        if (d:IsA("BasePart") and d.Name ~= "HumanoidRootPart") or d:IsA("Decal") then
            if on then
                if invisCache[d] == nil then invisCache[d] = d.Transparency end
                d.Transparency = 1
            else
                if invisCache[d] ~= nil then
                    d.Transparency = invisCache[d]
                    invisCache[d] = nil
                end
            end
        end
    end
end

local PlayMatchedSound = function(currentSpeed)
    if not P.Flags.KeySounds then return end
    local soundId = SoundProfiles[SelectedSoundName] or SoundProfiles["Water Drop"]
    local sound = Instance.new("Sound")
    sound.SoundId = soundId
    sound.Volume = 0.95
    sound.Pitch = math.clamp(0.9 + ((math.clamp(currentSpeed / 16, 0.8, 3.5)) * 0.12), 0.8, 1.5)
    sound.Parent = SoundService
    sound:Play()
    task.spawn(function() sound.Ended:Wait(); sound:Destroy() end)
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
        soundTimer += dt
        if soundTimer >= interval then soundTimer = 0; PlayMatchedSound(currentSpeed) end
    else
        soundTimer = 0
    end
end)

-- Egg Tracking & Predictor (Incremental Resync to Preserve History)
local RARITY = { common=1, uncommon=2, rare=3, epic=4, legendary=5, divine=6, secret=7, mythic=8 }
local function rarityRank(name)
    local low, best = name:lower(), 0
    for r, rank in pairs(RARITY) do if low:find(r, 1, true) and rank > best then best = rank end end
    return best
end

local function nameHasEgg(name) return name:lower():find("egg", 1, true) ~= nil end

local function isInsideCharacter(inst)
    for _, plr in ipairs(Players:GetPlayers()) do
        local character = plr.Character
        if character and inst:IsDescendantOf(character) then return true end
    end
    return false
end

local function insideEggModel(inst)
    local parent = inst.Parent
    while parent and parent ~= Workspace do
        if parent:IsA("Model") and nameHasEgg(parent.Name) then return true end
        parent = parent.Parent
    end
    return false
end

local function isEgg(inst)
    if not (inst:IsA("Model") or inst:IsA("BasePart")) then return false end
    if not nameHasEgg(inst.Name) then return false end
    if inst:IsA("Model") and Players:GetPlayerFromCharacter(inst) then return false end
    if insideEggModel(inst) or isInsideCharacter(inst) then return false end
    return true
end

local function getHistory(name)
    local history = P.EggHistory[name]
    if not history then
        history = { Spawn = {}, Despawn = {}, Present = 0 }
        P.EggHistory[name] = history
    end
    return history
end

local function addTimestamp(list)
    local now = os.clock()
    if #list > 0 and now - list[#list] < 1.5 then return end
    table.insert(list, now)
    if #list > 12 then table.remove(list, 1) end
end

local function recordSpawn(inst)
    if not isEgg(inst) then return end
    local history = getHistory(inst.Name)
    history.Present += 1
    P.EggCount += 1
    addTimestamp(history.Spawn)
end

local function recordDespawn(inst)
    if not isEgg(inst) then return end
    local history = getHistory(inst.Name)
    history.Present = math.max(0, history.Present - 1)
    P.EggCount = math.max(0, P.EggCount - 1)
    addTimestamp(history.Despawn)
end

local function resyncEggs()
    P.EggCache = {}
    local count = 0
    for _, inst in ipairs(Workspace:GetDescendants()) do
        if isEgg(inst) then
            count += 1
        end
    end
    P.EggCount = count
    P.LastSync = os.clock()
end

local function scanEggs()
    if tick() - P.LastScan < 1 then return P.EggCache end
    local out = {}
    for _, o in ipairs(Workspace:GetDescendants()) do
        if isEgg(o) then
            local skip = o:IsA("BasePart") and o.Parent and o.Parent:IsA("Model") and nameHasEgg(o.Parent.Name)
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
    if not (url and url:find("^https://")) then return end
    task.spawn(function()
        pcall(httpInvoke, { Url=url, Method="POST", Headers={ ["Content-Type"]="application/json" },
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
            if base then P.Base = base.CFrame + Vector3.new(0, 4, 0); return P.Base end
        end
    end
    local root = getRoot()
    if root then P.Base = root.CFrame; return P.Base end
    return CFrame.new(0, 10, 0)
end

local function stealEgg(egg)
    if not egg or P.Stealing then return end
    local root = getRoot(); if not root then return end
    P.Stealing = true
    local ok, err = pcall(function()
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
        if P.Flags.WebhookAlert then sendWebhook(("**Brineland Hub V10.2** stole `%s` (rarity %d)"):format(egg.name, egg.rarity)) end
        if P.Flags.AutoReturn then
            local r2 = getRoot()
            if r2 then
                if P.Flags.InstantSteal then r2.CFrame = home else moveTo(home.Position, 20) end
            end
        end
        task.wait(P.Flags.StealDelay)
    end)
    if not ok then report("stealEgg", err) end
    P.Stealing = false
end

local function averageInterval(list)
    if #list < 3 then return nil end
    local total = 0
    for i = 2, #list do total += list[i] - list[i - 1] end
    return total / (#list - 1)
end

local function getPredictions()
    local results, learning = {}, {}
    local now = os.clock()
    for name, history in pairs(P.EggHistory) do
        local series = history.Spawn
        local average = averageInterval(series)
        if not average then
            series = history.Despawn
            average = averageInterval(series)
        end
        if average then
            table.insert(results, { Name = name, ETA = math.max(0, series[#series] + average - now), Average = average })
        else
            table.insert(learning, { Name = name, Seen = math.max(#history.Spawn, #history.Despawn) })
        end
    end
    table.sort(results, function(a, b) return a.ETA < b.ETA end)
    table.sort(learning, function(a, b) return a.Name < b.Name end)
    return results, learning
end

local function predictionText()
    local ready, learning = getPredictions()
    local lines = {}
    for i, item in ipairs(ready) do
        if i > P.Flags.MaxPredictions then break end
        table.insert(lines, ("%s: ~%ds (every ~%ds) (Est)"):format(item.Name, math.floor(item.ETA), math.floor(item.Average)))
    end
    if P.Flags.ShowLearning then
        for _, item in ipairs(learning) do
            table.insert(lines, ("%s: learning (%d seen)"):format(item.Name, item.Seen))
        end
    end
    return #lines > 0 and table.concat(lines, "\n") or "Collecting observations..."
end

local function serverHop()
    local body = safeGet(("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId))
    if body then
        local ok, data = pcall(function() return HttpService:JSONDecode(body) end)
        if ok and data and data.data then
            local good = {}
            for _, s in ipairs(data.data) do
                if s.id ~= game.JobId and s.playing < s.maxPlayers then good[#good+1] = s.id end
            end
            if #good > 0 then
                pcall(TeleportService.TeleportToPlaceInstance, TeleportService, game.PlaceId, good[math.random(#good)], LP)
                return
            end
        end
    end
    notify("Brineland", "No server found.")
end

local function validateConfig(data)
    if type(data) ~= "table" then return nil end
    local result = {}
    for key, default in pairs(DEFAULT_FLAGS) do
        local val = data[key]
        if type(val) == type(default) then
            if type(default) == "number" then
                if key == "ESPDistance" then result[key] = math.clamp(val, 100, 20000)
                elseif key == "MaxPredictions" then result[key] = math.clamp(math.floor(val), 1, 15)
                elseif key == "ResyncInterval" then result[key] = math.clamp(math.floor(val), 5, 300)
                elseif key == "HitRange" then result[key] = math.clamp(val, 1, 100)
                elseif key == "Speed" then result[key] = math.clamp(val, 16, 500)
                elseif key == "FlySpeed" then result[key] = math.clamp(val, 5, 500)
                elseif key == "TreadmillTier" then result[key] = math.clamp(math.floor(val), 1, 50)
                elseif key == "HopThreshold" then result[key] = math.clamp(math.floor(val), 0, 30)
                elseif key == "StealDelay" then result[key] = math.clamp(val, 0.05, 10)
                else result[key] = val end
            elseif type(default) == "string" then
                if key == "WebhookURL" then
                    result[key] = (type(val) == "string" and val:find("^https://")) and val or ""
                else
                    result[key] = tostring(val)
                end
            else
                result[key] = val
            end
        else
            result[key] = default
        end
    end
    return result
end

local setStatus = function(_) end

local function saveConfig()
    if type(writefile) ~= "function" then setStatus("Saving not supported."); return false end
    local flags = {}
    for k, v in pairs(P.Flags) do if not VOLATILE[k] then flags[k] = v end end
    local ok = safe("config:save", function() writefile(CFG_FILE, HttpService:JSONEncode({ Flags=flags, Remotes=P.Remotes })) end)
    setStatus(ok and "Config saved." or "Save failed.")
    return ok
end

local function loadConfig(silent)
    if type(readfile) ~= "function" then return false end
    if type(isfile) == "function" and not isfile(CFG_FILE) then return false end
    local ok, data = safe("config:read", function() return HttpService:JSONDecode(readfile(CFG_FILE)) end)
    if not ok or type(data) ~= "table" then if not silent then notify("Brineland", "No config found.") end return false end
    local flags = validateConfig(data.Flags)
    if flags then P.Flags = flags end
    for k, v in pairs(data.Remotes or {}) do if P.Remotes[k] ~= nil and type(v) == "string" then P.Remotes[k] = v end end
    
    pcall(function() setFpsBoost(P.Flags.LagReducer) end)
    pcall(function() setUncap(P.Flags.UncapFPS) end)
    pcall(function() setInvisible(P.Flags.Invisible) end)
    pcall(function() ToggleGameSoundMute(P.Flags.KeySounds) end)

    for _, fn in pairs(P.Refresh) do pcall(fn) end
    if not silent then notify("Brineland", "Config loaded & applied.") end
    return true
end

-- UI Construction
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
local function guiParent() 
    local ok, res = pcall(function() return gethui and gethui() end)
    if ok and res then return res end
    return CoreGui or LP:WaitForChild("PlayerGui") 
end

local function isPointer(i) return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch end
local function isMove(i) return i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch end

local function makeGui(name, order)
    local g = new("ScreenGui", { Name=name, ResetOnSpawn=false, ZIndexBehavior=Enum.ZIndexBehavior.Sibling, DisplayOrder=order, IgnoreGuiInset=true }, guiParent())
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
    local gui = makeGui("BrinelandStealAnEggHubV10_2", 999)
    local main = new("Frame", { Size=UDim2.fromOffset(560, 420), Position=UDim2.new(0.5,-280,0.5,-210),
        BackgroundColor3=T.bg, BackgroundTransparency=0.18, BorderSizePixel=0 }, gui)
    round(main, 10)
    new("UIStroke", { Color=T.accent, Thickness=1.5 }, main)
    local vp = Workspace.CurrentCamera.ViewportSize
    new("UIScale", { Scale = math.clamp(math.min(vp.X / 600, vp.Y / 450), 0.5, 1) }, main)

    local top = new("Frame", { Size=UDim2.new(1,0,0,40), BackgroundColor3=T.side, BackgroundTransparency=0.25, BorderSizePixel=0 }, main)
    round(top, 10)
    
    new("TextLabel", { Size=UDim2.new(1,-85,1,0), Position=UDim2.fromOffset(10,0), BackgroundTransparency=1,
        Text="<b>BRINELAND & PASCUA</b> <font color=\"#00E5FF\">V10.2 PRODUCTION</font>",
        TextColor3=T.text, Font=Enum.Font.GothamBold, TextSize=12, RichText=true, TextXAlignment=Enum.TextXAlignment.Left }, top)

    local function topBtn(txt, x, fn, col)
        local b = new("TextButton", { Size=UDim2.fromOffset(28,28), Position=UDim2.new(1,x,0.5,-14), BackgroundColor3=col,
            Text=txt, TextColor3=T.text, Font=Enum.Font.GothamBold, TextSize=13, RichText=true, AutoButtonColor=true }, top)
        round(b, 6); connect(b.MouseButton1Click, fn)
    end
    topBtn("<b>X</b>", -32, function() P.Destroy() end, Color3.fromRGB(220,35,70))
    topBtn("<b>–</b>", -64, function() main.Visible = not main.Visible end, Color3.fromRGB(45,40,80))
    makeDraggable(top, main)

    local tgui = makeGui("BrinelandToggleBtnV10_2", 998)
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

    local holder = new("Frame", { Size=UDim2.new(1,-12,1,-86), Position=UDim2.fromOffset(6,80), BackgroundTransparency=1, BorderSizePixel=0 }, main)

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
        local btn = new("TextButton", { Size=UDim2.new(0, 75, 1, 0), BackgroundColor3=Color3.fromRGB(24, 18, 42), BackgroundTransparency=0.3,
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
        t.nxt = nxt

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
        function t:Label(txt)
            local r = new("Frame", { Size=UDim2.new(1,-4,0,28), AutomaticSize=Enum.AutomaticSize.Y, BackgroundColor3=T.card,
                BackgroundTransparency=0.25, BorderSizePixel=0, LayoutOrder=nxt() }, container)
            round(r, 6)
            new("UIPadding", { PaddingTop=UDim.new(0,6), PaddingBottom=UDim.new(0,6), PaddingLeft=UDim.new(0,10), PaddingRight=UDim.new(0,10) }, r)
            return new("TextLabel", { Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y, BackgroundTransparency=1, Text=txt,
                TextColor3=T.dim, Font=Enum.Font.GothamBold, TextSize=11, RichText=false, TextWrapped=true,
                TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top }, r)
        end
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
            round(b, 6); connect(b.MouseButton1Click, function() safe("btn:"..txt, cb) end)
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
            new("TextLabel", { Size=UDim2.new(0.5,0,1,0), Position=UDim2.fromOffset(10,0), BackgroundTransparency=1,
                Text="<b>" .. txt .. "</b>", TextColor3=T.text, Font=Enum.Font.GothamBold, TextSize=11, RichText=true, TextXAlignment=Enum.TextXAlignment.Left }, r)
            local box = new("TextBox", { Size=UDim2.fromOffset(110,24), Position=UDim2.new(1,-116,0.5,-12), BackgroundColor3=Color3.fromRGB(35,28,65),
                Text=tostring(get()), TextColor3=T.accent, Font=Enum.Font.GothamBold, TextSize=11, ClearTextOnFocus=false }, r)
            round(box, 4)
            P.Refresh["i_" .. txt] = function() box.Text = tostring(get()) end
            connect(box.FocusLost, function() set(box.Text) end)
        end
        return t
    end
    return win
end

local function restoreCharacter()
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    local bv = root and root:FindFirstChild("PascuaFly"); if bv then bv:Destroy() end
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
    connect(h.StateChanged, function(_, newState)
        if P.Flags.AntiRagdoll and (newState == Enum.HumanoidStateType.Ragdoll or newState == Enum.HumanoidStateType.FallingDown) then
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
    
    -- Robust Noclip hook with original collision caching & restoration
    connect(RunService.Stepped, function()
        if LP.Character then
            for _, p in ipairs(LP.Character:GetDescendants()) do
                if p:IsA("BasePart") then
                    if P.Flags.Noclip then
                        if Orig.Collisions[p] == nil then Orig.Collisions[p] = p.CanCollide end
                        p.CanCollide = false
                    else
                        if Orig.Collisions[p] ~= nil then
                            p.CanCollide = Orig.Collisions[p]
                            Orig.Collisions[p] = nil
                        end
                    end
                end
            end
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
        Orig.WalkSpeed = nil; P.SpeedTouched = false
        Orig.Collisions = {}
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
    connect(GuiService.ErrorMessageChanged, function(msg)
        if msg ~= "" then
            local low = msg:lower()
            if low:find("disconnected") or low:find("shutdown") or low:find("kick") or low:find("teleport") then
                rejoin("error prompt (" .. msg .. ")")
            end
        end
    end)
    pcall(function()
        local overlay = CoreGui.RobloxPromptGui.promptOverlay
        connect(overlay.ChildAdded, function(c)
            if c.Name == "ErrorPrompt" then
                if P.Flags.AntiKick then
                    pcall(function() c:Destroy() end)
                else
                    rejoin("disconnect prompt")
                end
            end
        end)
    end)
end

-- ESP (Drawing API guarded)
local function drawing(key)
    local d = P.Drawings[key]
    if not d and Drawing then
        pcall(function()
            d = Drawing.new("Text"); d.Size = 14; d.Center = true; d.Outline = true; d.OutlineColor = Color3.new()
            P.Drawings[key] = d
        end)
    end
    return d
end

local function espStep()
    if not Drawing then return end
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
            for _, o in ipairs(Workspace:GetChildren()) do
                local n = o.Name:lower()
                local isPen = f.PenEggESP and n:find("pen", 1, true)
                local isEv = f.EventESP and (n:find("rift", 1, true) or n:find("boss", 1, true) or n:find("event", 1, true))
                if isPen or isEv then
                    local part = o:IsA("BasePart") and o or (o:IsA("Model") and (o.PrimaryPart or o:FindFirstChildWhichIsA("BasePart")))
                    if part then targets[#targets+1] = { part, o.Name, isPen and Color3.fromRGB(80,200,255) or Color3.fromRGB(200,100,255) } end
                end
            end
        end
        for _, t in ipairs(targets) do
            local d = (t[1].Position - root.Position).Magnitude
            if d <= f.ESPDistance then
                local dr = drawing(t[1])
                if dr then
                    local sp, on = cam:WorldToViewportPoint(t[1].Position)
                    dr.Visible = on
                    if on then
                        dr.Position = Vector2.new(sp.X, sp.Y); dr.Text = ("%s [%d]"):format(t[2], math.floor(d)); dr.Color = t[3]
                    end
                    used[t[1]] = true
                end
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
    local win = createWindow("Brineland Hub V10.2")
    local Farm = win:Tab("Farm")
    local Pred = win:Tab("Predict")
    local Rift = win:Tab("Rift")
    local Vis  = win:Tab("Visuals")
    local Ply  = win:Tab("Player")
    local Srv  = win:Tab("Server")
    local Cfg  = win:Tab("Config")
    local Diag = win:Tab("Diag")

    Farm:Section("Eggs & Automation")
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

    Pred:Section("Predictor & Tracking")
    Pred:Toggle("Egg Spawn Predictor", "EggPredictor")
    Pred:Toggle("Egg Preview Card", "PreviewCard")
    Pred:Toggle("Show Learning Entries", "ShowLearning")
    Pred:Slider("Resync Interval (s)", "ResyncInterval", 5, 120, 5)
    Pred:Slider("Max Predictions", "MaxPredictions", 1, 8, 1)
    Pred:Toggle("Webhook Alerts", "WebhookAlert")
    Pred:Input("Webhook URL", function() return P.Flags.WebhookURL end, function(v) P.Flags.WebhookURL = v end)
    Pred:Button("🔮 Show Egg Predictions", function() notify("Egg Predictor", predictionText(), 6) end, Color3.fromRGB(0, 160, 240))
    Pred:Button("Recount Eggs Now", function() resyncEggs(); notify("Predictor", "Recounted " .. P.EggCount .. " eggs.", 3) end)

    Rift:Section("Rifts & Bosses")
    Rift:Toggle("Auto Rift Farm", "AutoRift")
    Rift:Toggle("Auto Rift Place", "AutoRiftPlace")
    Rift:Toggle("Auto Rift Trade", "AutoRiftTrade")
    Rift:Toggle("Auto Boss Farm", "AutoBoss")
    Rift:Toggle("Wait at Last Pity", "WaitLastPity")

    if Drawing then
        Vis:Section("ESP Settings")
        Vis:Toggle("Egg ESP", "EggESP")
        Vis:Toggle("Player ESP", "PlayerESP")
        Vis:Toggle("Pen ESP", "PenEggESP")
        Vis:Toggle("Event/Rift ESP", "EventESP")
        Vis:Slider("ESP Distance", "ESPDistance", 500, 10000, 100)
    else
        Vis:Label("ESP requires Drawing API.")
    end
    Vis:Dropdown("Min Rarity", "MinRarity", { "All", "Common", "Uncommon", "Rare", "Epic", "Legendary", "Divine", "Secret", "Mythic" })

    Ply:Section("Movement & Character")
    Ply:Slider("WalkSpeed", "Speed", 16, 300, 1)
    Ply:Toggle("Fly", "Fly")
    Ply:Slider("Fly Speed", "FlySpeed", 10, 300, 5)
    Ply:Toggle("Noclip", "Noclip")
    Ply:Toggle("Infinite Jump", "InfiniteJump")
    Ply:Toggle("Keep HP Full", "GodMode")
    Ply:Toggle("Invisible", "Invisible", setInvisible)
    Ply:Toggle("Anti Ragdoll", "AntiRagdoll")
    Ply:Toggle("Anti Kick Protection", "AntiKick")

    Ply:Section("Custom Sound & Combat Engine")
    Ply:Toggle("Custom Key Sounds", "KeySounds", function(state) ToggleGameSoundMute(state) end)

    local soundSelectorBtn = new("TextButton", { Size=UDim2.new(1,-4,0,38), BackgroundColor3=T.card, BackgroundTransparency=0.25,
        Text="<b>Sound Select: <font color=\"#00E5FF\">" .. SelectedSoundName .. "</font></b>", TextColor3=T.text,
        Font=Enum.Font.GothamBold, TextSize=11, RichText=true, LayoutOrder=Ply.nxt() }, Ply.container)
    round(soundSelectorBtn, 6)

    local soundDropdownContainer = new("ScrollingFrame", { Size=UDim2.new(1,-4,0,110), BackgroundColor3=Color3.fromRGB(18, 14, 35),
        BackgroundTransparency=0.2, BorderSizePixel=0, ScrollBarThickness=3, CanvasSize=UDim2.new(),
        AutomaticCanvasSize=Enum.AutomaticSize.Y, Visible=false, LayoutOrder=Ply.nxt() }, Ply.container)
    round(soundDropdownContainer, 6)
    new("UIListLayout", { Padding=UDim.new(0, 4), SortOrder=Enum.SortOrder.Name }, soundDropdownContainer)

    for profileName, _ in pairs(SoundProfiles) do
        local sBtn = new("TextButton", { Name=profileName, Size=UDim2.new(1,-6,0,30), BackgroundColor3=Color3.fromRGB(35, 28, 65),
            Text="<b>" .. profileName .. "</b>", TextColor3=Color3.fromRGB(220, 220, 240), Font=Enum.Font.GothamBold, TextSize=10, RichText=true }, soundDropdownContainer)
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

    Srv:Section("Server & Performance")
    Srv:Toggle("Anti AFK", "AntiAFK")
    Srv:Toggle("Lag Reducer (FPS Boost)", "LagReducer", function(on) pcall(setFpsBoost, on) end)
    Srv:Toggle("Uncap FPS", "UncapFPS", function(on) pcall(setUncap, on) end)
    Srv:Toggle("FPS Overlay", "FPSOverlay")
    Srv:Toggle("Ping Overlay", "PingOverlay")
    Srv:Toggle("Auto Reconnect", "AutoReconnect")
    Srv:Toggle("Auto Server Hop", "AutoHop")
    Srv:Slider("Hop if players ≤", "HopThreshold", 0, 10, 1)
    Srv:Toggle("Remote Call Logging", "RemoteLog")
    Srv:Button("🔄 Server Hop", serverHop, Color3.fromRGB(0, 160, 240))

    Cfg:Section("Configuration Management")
    local ConfigStatus = Cfg:Label("Ready.")
    setStatus = function(text) ConfigStatus.Text = text end
    Cfg:Button("💾 Save Config", saveConfig, Color3.fromRGB(0, 160, 240))
    Cfg:Button("📂 Load Config", function()
        if loadConfig() then
            for _, fn in pairs(P.Refresh) do pcall(fn) end
        end
    end, Color3.fromRGB(35, 28, 65))
    Cfg:Button("🔄 Reset Config", function()
        for k, v in pairs(DEFAULT_FLAGS) do P.Flags[k] = v end
        ToggleGameSoundMute(false)
        setFpsBoost(false)
        setUncap(false)
        setInvisible(false)
        for _, fn in pairs(P.Refresh) do pcall(fn) end
        setStatus("Reset to absolute defaults & cleared state.")
    end, Color3.fromRGB(220,35,70))
    Cfg:Input("Target Area", function() return P.Flags.TargetArea end, function(v) P.Flags.TargetArea = v end)
    Cfg:Input("Specific Egg", function() return P.Flags.SpecificEgg end, function(v) P.Flags.SpecificEgg = v end)

    Diag:Section("Runtime Diagnostics & Errors")
    local ErrorOutput = Diag:Label("No errors recorded.")
    local function refreshDiagnostics()
        local lines = {}
        for _, key in ipairs(P.ErrorOrder) do
            local e = P.Errors[key]
            if e then table.insert(lines, ("[%s] %s x%d: %s"):format(e.Time, e.Tag, e.Count, e.Message)) end
        end
        ErrorOutput.Text = #lines > 0 and table.concat(lines, "\n") or "No errors recorded."
    end
    Diag:Button("Refresh Diagnostics", refreshDiagnostics)
    Diag:Button("Clear Diagnostics", function() table.clear(P.Errors); table.clear(P.ErrorOrder); refreshDiagnostics() end)

    local r = getRoot(); if r then P.Base = r.CFrame end
    installPlayerHooks()
    hookHumanoid()

    connect(Workspace.DescendantAdded, function(inst) if P.Flags.EggPredictor then safe("predictor:spawn", recordSpawn, inst) end end)
    connect(Workspace.DescendantRemoving, function(inst) if P.Flags.EggPredictor then safe("predictor:despawn", recordDespawn, inst) end end)

    spawnTask("autosteal", 0.4, function()
        if P.Flags.AutoSteal and alive() and not P.Stealing then local e = closestEgg(); if e then stealEgg(e) end end
    end)
    spawnTask("treadmill", 1, function()
        local f, R = P.Flags, P.Remotes
        if f.AutoTreadmill then fireRemote(R.Treadmill) end
        if f.AutoUpgradeTread then for i = 1, f.TreadmillTier do fireRemote(R.Upgrade, i) end end
        if f.AutoUpgradeBase then fireRemote(R.UpgradeBase) end
    end)
    spawnTask("inventory", 1.5, function()
        local f, R = P.Flags, P.Remotes
        if f.AutoHatch then fireRemote(R.Hatch, args(f.HatchArg)) end
        if f.AutoPlace then fireRemote(R.Place) end
        if f.AutoSellEgg then fireRemote(R.SellEgg) end
        if f.AutoSellPet then fireRemote(R.SellPet) end
        if f.AutoFuse then fireRemote(R.Fuse) end
        if f.AutoFavorite then fireRemote(R.Favorite, args(f.FavArg)) end
    end)
    spawnTask("equipbest", 5, function() if P.Flags.AutoEquipBest then fireRemote(P.Remotes.EquipBest, args(P.Flags.EquipArg)) end end)
    spawnTask("rifts", 2, function()
        local f, R = P.Flags, P.Remotes
        if f.AutoRift then fireRemote(R.Rift, args(f.RiftFarmArg)) end
        if f.AutoRiftPlace then fireRemote(R.Rift, args(f.RiftPlaceArg)) end
        if f.AutoRiftTrade then fireRemote(R.Rift, args(f.RiftTradeArg)) end
        if f.AutoBoss then fireRemote(R.Boss, args(f.BossFarmArg)) end
        if f.WaitLastPity then fireRemote(R.Rift, args(f.PityArg)) end
    end)
    spawnTask("trails_claims", 5, function()
        if P.Flags.AutoTrail then fireRemote(P.Remotes.Treadmill, "BuyTrail") end
        if P.Flags.AutoClaim then fireRemote(P.Remotes.Claim, "All") end
    end)
    spawnTask("autohop", 10, function()
        if P.Flags.AutoHop and #Players:GetPlayers() - 1 <= P.Flags.HopThreshold and tick() - (P.LastHop or 0) > 30 then
            P.LastHop = tick(); serverHop()
        end
    end)
    spawnTask("autohit", 0.15, function()
        if P.Flags.AutoHit then
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local tool = char and char:FindFirstChildOfClass("Tool")
            if hrp and tool then
                for _, obj in ipairs(Workspace:GetChildren()) do
                    local hum = obj:FindFirstChildOfClass("Humanoid")
                    local part = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart"))
                    if hum and part and obj ~= char and (part.Position - hrp.Position).Magnitude <= P.Flags.HitRange then
                        tool:Activate()
                        break
                    end
                end
            end
        end
    end)
    spawnTask("humanoid_updates", 0.2, function()
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
        end
    end)
    spawnTask("esp", 0.25, espStep)
    spawnTask("predictor_resync", 1, function()
        if os.clock() - P.LastSync >= P.Flags.ResyncInterval then resyncEggs() end
    end)

    local frames, last, fps = 0, tick(), 0
    connect(RunService.RenderStepped, function()
        frames += 1
        if tick() - last >= 1 then fps, frames, last = frames, 0, tick() end
    end)

    -- Floating Overlay
    local ogui = makeGui("BrinelandOverlayV10_2", 998)
    local ov = new("TextLabel", { Size=UDim2.fromOffset(110,34), Position=UDim2.new(0,15,0,75), BackgroundColor3=T.bg,
        BackgroundTransparency=0.2, Text="", TextColor3=T.accent, Font=Enum.Font.Code, TextSize=13, Visible=false, Active=true }, ogui)
    round(ov, 6); new("UIStroke", { Color=T.accent, Thickness=1 }, ov); makeDraggable(ov, ov)
    
    spawnTask("overlay", 0.5, function()
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

    -- Preview Card
    local PreviewGui = makeGui("PascuaPreviewV10_2", 998)
    local PreviewCard = new("Frame", { Size=UDim2.fromOffset(245, 100), Position=UDim2.new(1, -260, 0, 60), BackgroundColor3=T.bg, Visible=false }, PreviewGui)
    round(PreviewCard, 8)
    new("UIStroke", { Color = T.accent, Transparency = 0.5 }, PreviewCard)
    makeDraggable(PreviewCard, PreviewCard)

    new("TextLabel", { Size=UDim2.new(1, -15, 0, 25), Position=UDim2.fromOffset(8, 3), BackgroundTransparency=1, Text="EGG PREVIEW CARD", TextColor3=T.accent, Font=Enum.Font.GothamBold, TextSize=11, TextXAlignment=Enum.TextXAlignment.Left }, PreviewCard)
    local PreviewText = new("TextLabel", { Size=UDim2.new(1, -16, 1, -32), Position=UDim2.fromOffset(8, 28), BackgroundTransparency=1, Text="Waiting...", TextColor3=T.text, Font=Enum.Font.Gotham, TextSize=11, TextWrapped=true, TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top }, PreviewCard)

    spawnTask("preview", 1, function()
        PreviewCard.Visible = P.Flags.PreviewCard
        if not P.Flags.PreviewCard then return end
        local ready, learning = getPredictions()
        local lines = {
            "Eggs detected: " .. tostring(P.EggCount),
            "Predictions: " .. tostring(#ready),
            "Learning: " .. tostring(#learning),
        }
        if ready[1] then table.insert(lines, string.format("Next: %s (~%ds)", ready[1].Name, math.floor(ready[1].ETA))) end
        PreviewText.Text = table.concat(lines, "\n")
    end)

    notify("Brineland Hub V10.2", "Production Edition Active!", 4)
end

function P.Destroy()
    P.Running = false
    ToggleGameSoundMute(false)
    setFpsBoost(false)
    setUncap(false)
    setInvisible(false)
    
    for _, conn in ipairs(SoundMuteConnections) do if conn then conn:Disconnect() end end
    SoundMuteConnections = {}

    for _, th in ipairs(P.Tasks) do pcall(task.cancel, th) end
    table.clear(P.Tasks)
    
    for _, c in ipairs(P.Conns) do pcall(function() c:Disconnect() end) end
    table.clear(P.Conns)
    
    for _, d in pairs(P.Drawings) do pcall(function() d:Remove() end) end
    table.clear(P.Drawings)
    
    for _, g in ipairs(P.Guis) do pcall(function() g:Destroy() end) end
    table.clear(P.Guis)
    
    table.clear(P.Refresh)
    table.clear(P.EggHistory)
    table.clear(P.EggCache)
    table.clear(remoteCache)
    table.clear(invisCache)
    
    pcall(restoreCharacter)
    table.clear(P.Cleanups)
    env.PascuaHub = nil
end

loadConfig(true)
resyncEggs()
openHub()
