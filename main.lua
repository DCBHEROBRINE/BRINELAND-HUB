-- ============================================================
-- BRINELAND MASTER MULTI-GAME HUB + PLATOBOOST KEY SYSTEM
-- Repository: https://github.com/DCBHEROBRINE/BRINELAND-HUB.git
-- Discord: https://discord.gg/epWMbuXSN5
-- YouTube: https://youtube.com/@dcb_herobrine?si=PN8mSo36sJFaySFQ
-- ============================================================

-------------------------------------------------------------------------------
--! json library
--! cryptography library
local a=2^32;local b=a-1;local function c(d,e)local f,g=0,1;while d~=0 or e~=0 do local h,i=d%2,e%2;local j=(h+i)%2;f=f+j*g;d=math.floor(d/2)e=math.floor(e/2)g=g*2 end;return f%a end;local function k(d,e,l,...)local m;if e then d=d%a;e=e%a;m=c(d,e)if l then m=k(m,l,...)end;return m elseif d then return d%a else return 0 end end;local function n(d,e,l,...)local m;if e then d=d%a;e=e%a;m=(d+e-c(d,e))/2;if l then m=n(m,l,...)end;return m elseif d then return d%a else return b end end;local function o(p)return b-p end;local lshift;local function q(d,r)if r<0 then return lshift(d,-r)end;return math.floor(d%2^32/2^r)end;local function s(p,r)if r>31 or r<-31 then return 0 end;return q(p%a,r)end;lshift=function(d,r)if r<0 then return s(d,-r)end;return d*2^r%2^32 end;local function t(p,r)p=p%a;r=r%32;local u=n(p,2^r-1)return s(p,r)+lshift(u,32-r)end;local v={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}local function w(x)return string.gsub(x,".",function(l)return string.format("%02x",string.byte(l))end)end;local function y(z,A)local x=""for B=1,A do local C=z%256;x=string.char(C)..x;z=(z-C)/256 end;return x end;local function D(x,B)local A=0;for B=B,B+3 do A=A*256+string.byte(x,B)end;return A end;local function E(F,G)local H=(64-(G+9)%64)%64;G=y(8*G,8)F=F.."\128"..string.rep("\0",H)..G;assert(#F%64==0)return F end;local function I(J)J[1]=0x6a09e667;J[2]=0xbb67ae85;J[3]=0x3c6ef372;J[4]=0xa54ff53a;J[5]=0x510e527f;J[6]=0x9b05688c;J[7]=0x1f83d9ab;J[8]=0x5be0cd19;return J end;local function K(F,B,J)local L={}for M=1,16 do L[M]=D(F,B+(M-1)*4)end;for M=17,64 do local N=L[M-15]local O=k(t(N,7),t(N,18),s(N,3))N=L[M-2]L[M]=(L[M-16]+O+L[M-7]+k(t(N,17),t(N,19),s(N,10)))%a end;local d,e,l,P,Q,R,S,T=J[1],J[2],J[3],J[4],J[5],J[6],J[7],J[8]for B=1,64 do local O=k(t(d,2),t(d,13),t(d,22))local U=k(n(d,e),n(d,l),n(e,l))local V=(O+U)%a;local W=k(t(Q,6),t(Q,11),t(Q,25))local X=k(n(Q,R),n(o(Q),S))local Y=(T+W+X+v[B]+L[B])%a;T=S;S=R;R=Q;Q=(P+Y)%a;P=l;l=e;e=d;d=(Y+V)%a end;J[1]=(J[1]+d)%a;J[2]=(J[2]+e)%a;J[3]=(J[3]+l)%a;J[4]=(J[4]+P)%a;J[5]=(J[5]+Q)%a;J[6]=(J[6]+R)%a;J[7]=(J[7]+S)%a;J[8]=(J[8]+T)%a end;local function Z(F)F=E(F,#F)local J=I({})for B=1,#F,64 do K(F,B,J)end;return w(y(J[1],4)..y(J[2],4)..y(J[3],4)..y(J[4],4)..y(J[5],4)..y(J[6],4)..y(J[7],4)..y(J[8],4))end;local e;local l={["\\"]="\\",["\""]="\"",["\b"]="b",["\f"]="f",["\n"]="n",["\r"]="r",["\t"]="t"}local P={["/"]="/"}for Q,R in pairs(l)do P[R]=Q end;local S=function(T)return"\\"..(l[T]or string.format("u%04x",T:byte()))end;local B=function(M)return"null"end;local v=function(M,z)local _={}z=z or{}if z[M]then error("circular reference")end;z[M]=true;if rawget(M,1)~=nil or next(M)==nil then local A=0;for Q in pairs(M)do if type(Q)~="number"then error("invalid table: mixed or invalid key types")end;A=A+1 end;if A~=#M then error("invalid table: sparse array")end;for a0,R in ipairs(M)do table.insert(_,e(R,z))end;z[M]=nil;return"["..table.concat(_,",").."]"else for Q,R in pairs(M)do if type(Q)~="string"then error("invalid table: mixed or invalid key types")end;table.insert(_,e(Q,z)..":"..e(R,z))end;z[M]=nil;return"{"..table.concat(_,",").."}"end end;local g=function(M)return'"'..M:gsub('[%z\1-\31\\"]',S)..'"'end;local a1=function(M)if M~=M or M<=-math.huge or M>=math.huge then error("unexpected number value '"..tostring(M).."'")end;return string.format("%.14g",M)end;local j={["nil"]=B,["table"]=v,["string"]=g,["number"]=a1,["boolean"]=tostring}e=function(M,z)local x=type(M)local a2=j[x]if a2 then return a2(M,z)end;error("unexpected type '"..x.."'")end;local a3=function(M)return e(M)end;local a4;local N=function(...)local _={}for a0=1,select("#",...)do _[select(a0,...)]=true end;return _ end;local L=N(" ","\t","\r","\n")local p=N(" ","\t","\r","\n","]","}",",")local a5=N("\\","/",'"',"b","f","n","r","t","u")local m=N("true","false","null")local a6={["true"]=true,["false"]=false,["null"]=nil}local a7=function(a8,a9,aa,ab)for a0=a9,#a8 do if aa[a8:sub(a0,a0)]~=ab then return a0 end end;return#a8+1 end;local ac=function(a8,a9,J)local ad=1;local ae=1;for a0=1,a9-1 do ae=ae+1;if a8:sub(a0,a0)=="\n"then ad=ad+1;ae=1 end end;error(string.format("%s at line %d col %d",J,ad,ae))end;local af=function(A)local a2=math.floor;if A<=0x7f then return string.char(A)elseif A<=0x7ff then return string.char(a2(A/64)+192,A%64+128)elseif A<=0xffff then return string.char(a2(A/4096)+224,a2(A%4096/64)+128,A%64+128,A%64+128)elseif A<=0x10ffff then return string.char(a2(A/262144)+240,a2(A%262144/4096)+128,a2(A%4096/64)+128,A%64+128)end;error(string.format("invalid unicode codepoint '%x'",A))end;local ag=function(ah)local ai=tonumber(ah:sub(1,4),16)local aj=tonumber(ah:sub(7,10),16)if aj then return af((ai-0xd800)*0x400+aj-0xdc00+0x10000)else return af(ai)end end;local ak=function(a8,a0)local _=""local al=a0+1;local Q=al;while al<=#a8 do local am=a8:byte(al)if am<32 then ac(a8,al,"control character in string")elseif am==92 then _=_..a8:sub(Q,al-1)al=al+1;local T=a8:sub(al,al)if T=="u"then local an=a8:match("^[dD][89aAbB]%x%x\\u%x%x%x%x",al+1)or a8:match("^%x%x%x%x",al+1)or ac(a8,al-1,"invalid unicode escape in string")_=_..ag(an)al=al+#an else if not a5[T]then ac(a8,al-1,"invalid escape char '"..T.."' in string")end;_=_..P[T]end;Q=al+1 elseif am==34 then _=_..a8:sub(Q,al-1)return _,al+1 end;al=al+1 end;ac(a8,a0,"expected closing quote for string")end;local ao=function(a8,a0)local am=a7(a8,a0,p)local ah=a8:sub(a0,am-1)local A=tonumber(ah)if not A then ac(a8,a0,"invalid number '"..ah.."'")end;return A,am end;local ap=function(a8,a0)local am=a7(a8,a0,p)local aq=a8:sub(a0,am-1)if not m[aq]then ac(a8,a0,"invalid literal '"..aq.."'")end;return a6[aq],am end;local ar=function(a8,a0)local _={}local A=1;a0=a0+1;while 1 do local am;a0=a7(a8,a0,L,true)if a8:sub(a0,a0)=="]" then a0=a0+1;break end;am,a0=a4(a8,a0)_[A]=am;A=A+1;a0=a7(a8,a0,L,true)local as=a8:sub(a0,a0)a0=a0+1;if as=="]" then break end;if as~="," then ac(a8,a0,"expected ']' or ','")end end;return _,a0 end;local at=function(a8,a0)local _={}a0=a0+1;while 1 do local au,M;a0=a7(a8,a0,L,true)if a8:sub(a0,a0)=="}" then a0=a0+1;break end;if a8:sub(a0,a0)~='"'then ac(a8,a0,"expected string for key")end;au,a0=a4(a8,a0)a0=a7(a8,a0,L,true)if a8:sub(a0,a0)~=":" then ac(a8,a0,"expected ':' after key")end;a0=a7(a8,a0+1,L,true)M,a0=a4(a8,a0)_[au]=M;a0=a7(a8,a0,L,true)local as=a8:sub(a0,a0)a0=a0+1;if as=="}" then break end;if as~="," then ac(a8,a0,"expected '}' or ','")end end;return _,a0 end;local av={['"']=ak,["0"]=ao,["1"]=ao,["2"]=ao,["3"]=ao,["4"]=ao,["5"]=ao,["6"]=ao,["7"]=ao,["8"]=ao,["9"]=ao,["-"]=ao,["t"]=ap,["f"]=ap,["n"]=ap,["["]=ar,["{"]=at}a4=function(a8,a9)local as=a8:sub(a9,a9)local a2=av[as]if a2 then return a2(a8,a9)end;ac(a8,a9,"unexpected character '"..as.."'")end;local aw=function(a8)if type(a8)~="string"then error("expected argument of type string, got "..type(a8))end;local _,a9=a4(a8,a7(a8,1,L,true))a9=a7(a8,a9,L,true)if a9<=#a8 then ac(a8,a9,"trailing garbage")end;return _ end;
-- Use Roblox's JSON library; keep the original SHA-256 digest for identifiers.
local jsonService = game:GetService("HttpService")
local lEncode = function(value) return jsonService:JSONEncode(value) end
local lDecode = function(value) return jsonService:JSONDecode(value) end
local lDigest = Z;
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--! PLATOBOOST & SOCIAL CONFIGURATION
local DISCORD_INVITE = "https://discord.gg/epWMbuXSN5"
local YOUTUBE_URL    = "https://youtube.com/@dcb_herobrine?si=PN8mSo36sJFaySFQ"
local service = 34545;
-- An unused client-side secret was removed: secrets cannot be hidden in client scripts.
local useNonce = true;

local onMessage = function(message) end;

repeat task.wait(1) until game:IsLoaded();

local requestSending = false;
local fSetClipboard, fRequest, fStringChar, fToString, fStringSub, fOsTime, fMathRandom, fMathFloor, fGetHwid = setclipboard or toclipboard, request or http_request or syn_request, string.char, tostring, string.sub, os.time, math.random, math.floor, gethwid or function() return tostring(game:GetService("Players").LocalPlayer.UserId) end
local cachedLink, cachedTime = "", 0;

local function safeRequest(options)
    if not fRequest then return { StatusCode = 500, Body = "" } end
    local ok, res = pcall(function()
        return fRequest(options)
    end)
    if ok and type(res) == "table" then
        return res
    else
        return { StatusCode = 500, Body = "" }
    end
end

local host = "https://api.platoboost.com";
local hostResponse = safeRequest({
    Url = host .. "/public/connectivity",
    Method = "GET"
});

if not hostResponse or (hostResponse.StatusCode ~= 200 and hostResponse.StatusCode ~= 429) then
    host = "https://api.platoboost.net";
end

local function cacheLink()
    if cachedTime + (10*60) < fOsTime() then
        local response = safeRequest({
            Url = host .. "/public/start",
            Method = "POST",
            Body = lEncode({
                service = service,
                identifier = lDigest(tostring(fGetHwid()))
            }),
            Headers = {
                ["Content-Type"] = "application/json"
            }
        });

        if response.StatusCode == 200 then
            local successDecode, decoded = pcall(function() return lDecode(response.Body) end)
            if successDecode and type(decoded) == "table" and decoded.success == true and type(decoded.data) == "table" and type(decoded.data.url) == "string" and decoded.data.url ~= "" then
                cachedLink = decoded.data.url;
                cachedTime = fOsTime();
                return true, cachedLink;
            else
                return false, decoded and decoded.message or "Decode error";
            end
        end
        return false, "Failed to cache link.";
    else
        return true, cachedLink;
    end
end

task.spawn(function() pcall(cacheLink) end);

local generateNonce = function()
    local str = ""
    for _ = 1, 16 do
        str = str .. fStringChar(fMathFloor(fMathRandom() * (122 - 97 + 1)) + 97)
    end
    return str
end

local copyLink = function()
    local success, link = cacheLink();
    if not success then return false, tostring(link) end
    if type(fSetClipboard) ~= "function" then return false, "Clipboard not supported." end
    local ok = pcall(fSetClipboard, link)
    return ok, ok and "PlatoBoost link copied to clipboard!" or "Clipboard failed."
end

local redeemKey = function(key)
    local nonce = generateNonce();
    local endpoint = host .. "/public/redeem/" .. fToString(service);
    local body = { identifier = lDigest(tostring(fGetHwid())), key = key }
    if useNonce then body.nonce = nonce; end

    local response = safeRequest({
        Url = endpoint,
        Method = "POST",
        Body = lEncode(body),
        Headers = { ["Content-Type"] = "application/json" }
    });

    if response.StatusCode == 200 then
        local successDecode, decoded = pcall(function() return lDecode(response.Body) end)
        if successDecode and type(decoded) == "table" and decoded.success == true and type(decoded.data) == "table" and decoded.data.valid == true then
            return true;
        end
    end
    return false;
end

local verifyKey = function(key)
    if requestSending == true then return false else requestSending = true; end
    local nonce = generateNonce();
    local endpoint = host .. "/public/whitelist/" .. fToString(service) .. "?identifier=" .. lDigest(tostring(fGetHwid())) .. "&key=" .. jsonService:UrlEncode(key);
    if useNonce then endpoint = endpoint .. "&nonce=" .. nonce; end

    local response = safeRequest({ Url = endpoint, Method = "GET" });
    requestSending = false;

    if response.StatusCode == 200 then
        local successDecode, decoded = pcall(function() return lDecode(response.Body) end)
        if successDecode and type(decoded) == "table" and decoded.success == true and type(decoded.data) == "table" then
            if decoded.data.valid == true then
                return true;
            else
                if fStringSub(key, 1, 4) == "KEY_" then
                    return redeemKey(key);
                end
                return false;
            end
        end
    end
    return false;
end
-------------------------------------------------------------------------------

-- ============================================================
-- CUSTOM ASSETS, HIDDEN MUSIC & MONOCHROME THEME
-- ============================================================
local CUSTOM_BANNER_FILE = "brineland_banner.png"
local CUSTOM_BANNER_ID   = ""

-- Hidden background audio (Asset ID 108997017247273)
local HIDDEN_MUSIC_ID     = "rbxassetid://108997017247273"
local HIDDEN_MUSIC_VOLUME = 0.45

local Theme = {
    Black      = Color3.fromRGB(10, 10, 12),
    DarkGray   = Color3.fromRGB(24, 24, 28),
    MidGray    = Color3.fromRGB(46, 46, 54),
    BorderGray = Color3.fromRGB(125, 125, 136),
    SubText    = Color3.fromRGB(180, 180, 190),
    White      = Color3.fromRGB(255, 255, 255),
}

local FANCY_FONT = Enum.Font.Fondamento
local BODY_FONT  = Enum.Font.GothamBold

local function addWhiteBoxStroke(parent, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.White
    stroke.Thickness = thickness or 1.25
    stroke.Transparency = transparency or 0
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = parent
    return stroke
end

local function resolveCustomBannerImage()
    if getcustomasset and isfile and CUSTOM_BANNER_FILE ~= "" and isfile(CUSTOM_BANNER_FILE) then
        local ok, asset = pcall(getcustomasset, CUSTOM_BANNER_FILE)
        if ok and asset then
            return asset
        end
    end
    if CUSTOM_BANNER_ID ~= "" then
        return CUSTOM_BANNER_ID
    end
    return ""
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer
local KEY_FILE_NAME = "BrinelandKey.txt"

local function EnsureHiddenMusic()
    if not HIDDEN_MUSIC_ID or HIDDEN_MUSIC_ID == "" then return end
    local existing = SoundService:FindFirstChild("BrinelandHiddenMusic")
    if existing and existing:IsA("Sound") then
        existing.SoundId = HIDDEN_MUSIC_ID
        existing.Volume = HIDDEN_MUSIC_VOLUME
        if not existing.IsPlaying then
            pcall(function() existing:Play() end)
        end
        return existing
    end

    local s = Instance.new("Sound")
    s.Name = "BrinelandHiddenMusic"
    s.SoundId = HIDDEN_MUSIC_ID
    s.Volume = HIDDEN_MUSIC_VOLUME
    s.Looped = true
    s.Parent = SoundService
    pcall(function() s:Play() end)
    return s
end

local function MakeDraggable(guiObject, dragHandle)
    local handle = dragHandle or guiObject
    local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
    local conns = {}
    local function bind(signal, fn) local c = signal:Connect(fn); conns[#conns+1] = c end
    bind(handle.InputBegan, function(input)
        if not dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true; dragInput = input; dragStart = input.Position; startPos = guiObject.Position
        end
    end)
    bind(UserInputService.InputChanged, function(input)
        if not dragging then return end
        local same = input == dragInput or (dragInput.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseMovement)
        if same then local d = input.Position - dragStart; guiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y) end
    end)
    bind(UserInputService.InputEnded, function(input)
        if input == dragInput then dragging = false; dragInput = nil end
    end)
    bind(guiObject.Destroying, function() for _, c in ipairs(conns) do c:Disconnect() end; table.clear(conns) end)
end

-- ============================================================
-- BRINELAND CUSTOM UI GATEWAY (MOVABLE KEY GUI)
-- ============================================================
local function VerifyAndLoadHub()
    EnsureHiddenMusic()

    if readfile and isfile and isfile(KEY_FILE_NAME) then
        local okRead, savedKey = pcall(readfile, KEY_FILE_NAME)
        if okRead and savedKey and savedKey ~= "" then
            savedKey = savedKey:gsub("%s+", "")
            if savedKey ~= "" then
                local ok, valid = pcall(verifyKey, savedKey)
                if not ok then requestSending = false end
                if ok and valid then return true end
            end
        end
    end

    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    if PlayerGui:FindFirstChild("BrineKeySystem") then
        PlayerGui.BrineKeySystem:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BrineKeySystem"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.fromOffset(420, 235)
    MainFrame.Position = UDim2.fromOffset(16, 48)
    MainFrame.BackgroundColor3 = Theme.Black
    MainFrame.BackgroundTransparency = 0.06
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    addWhiteBoxStroke(MainFrame, 1.5, 0)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.BackgroundTransparency = 1
    Title.Text = "Brineland"
    Title.TextColor3 = Theme.White
    Title.TextSize = 20
    Title.Font = FANCY_FONT
    Title.Parent = MainFrame

    MakeDraggable(MainFrame, Title)

    local headerLine = Instance.new("Frame")
    headerLine.Size = UDim2.new(1, -16, 0, 1)
    headerLine.Position = UDim2.new(0, 8, 0, 40)
    headerLine.BackgroundColor3 = Theme.White
    headerLine.BorderSizePixel = 0
    headerLine.Parent = MainFrame

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(0.9, 0, 0, 34)
    KeyInput.Position = UDim2.new(0.05, 0, 0, 48)
    KeyInput.PlaceholderText = "Paste your key here..."
    KeyInput.PlaceholderColor3 = Theme.SubText
    KeyInput.Text = ""
    KeyInput.TextColor3 = Theme.White
    KeyInput.BackgroundColor3 = Theme.DarkGray
    KeyInput.TextSize = 11
    KeyInput.Font = BODY_FONT
    KeyInput.Parent = MainFrame
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(1, 0)
    addWhiteBoxStroke(KeyInput, 1, 0.25)

    local WorkInkBtn = Instance.new("TextButton")
    WorkInkBtn.Size = UDim2.new(0.9, 0, 0, 32)
    WorkInkBtn.Position = UDim2.new(0.05, 0, 0, 88)
    WorkInkBtn.BackgroundColor3 = Theme.MidGray
    WorkInkBtn.Text = "GET KEY (WORK.INK)"
    WorkInkBtn.TextColor3 = Theme.White
    WorkInkBtn.TextSize = 10.5
    WorkInkBtn.Font = BODY_FONT
    WorkInkBtn.Parent = MainFrame
    Instance.new("UICorner", WorkInkBtn).CornerRadius = UDim.new(1, 0)
    addWhiteBoxStroke(WorkInkBtn, 1, 0.2)

    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Size = UDim2.new(0.43, 0, 0, 34)
    SubmitBtn.Position = UDim2.new(0.05, 0, 0, 128)
    SubmitBtn.BackgroundColor3 = Theme.DarkGray
    SubmitBtn.Text = "VERIFY KEY"
    SubmitBtn.TextColor3 = Theme.White
    SubmitBtn.TextSize = 11
    SubmitBtn.Font = BODY_FONT
    SubmitBtn.Parent = MainFrame
    Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(1, 0)
    addWhiteBoxStroke(SubmitBtn, 1, 0.2)

    local DiscordBtn = Instance.new("TextButton")
    DiscordBtn.Size = UDim2.new(0.43, 0, 0, 34)
    DiscordBtn.Position = UDim2.new(0.52, 0, 0, 128)
    DiscordBtn.BackgroundColor3 = Theme.DarkGray
    DiscordBtn.Text = "COPY DISCORD"
    DiscordBtn.TextColor3 = Theme.White
    DiscordBtn.TextSize = 10.5
    DiscordBtn.Font = BODY_FONT
    DiscordBtn.Parent = MainFrame
    Instance.new("UICorner", DiscordBtn).CornerRadius = UDim.new(1, 0)
    addWhiteBoxStroke(DiscordBtn, 1, 0.2)

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -16, 0, 48)
    StatusLabel.Position = UDim2.new(0, 8, 0, 170)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "Click Get Key to complete Work.ink verification!"
    StatusLabel.TextColor3 = Theme.SubText
    StatusLabel.TextSize = 10.5
    StatusLabel.Font = BODY_FONT
    StatusLabel.TextWrapped = true
    StatusLabel.Parent = MainFrame

    WorkInkBtn.MouseButton1Click:Connect(function()
        if fSetClipboard then
            local called, copied, message = pcall(copyLink)
            StatusLabel.Text = called and tostring(message) or "Could not get a key link. Check your connection."
            StatusLabel.TextColor3 = Theme.White
        else
            StatusLabel.Text = "Executor does not support clipboard."
            StatusLabel.TextColor3 = Theme.SubText
        end
    end)

    DiscordBtn.MouseButton1Click:Connect(function()
        if fSetClipboard then
            fSetClipboard(DISCORD_INVITE)
            StatusLabel.Text = "Discord invite copied!"
            StatusLabel.TextColor3 = Theme.White
        end
    end)

    local isVerified = false

    SubmitBtn.MouseButton1Click:Connect(function()
        local enteredKey = (KeyInput.Text or ""):gsub("%s+", "")
        if enteredKey == "" then
            StatusLabel.Text = "Please enter a key first!"
            StatusLabel.TextColor3 = Theme.SubText
            return
        end

        StatusLabel.Text = "Checking key..."
        StatusLabel.TextColor3 = Theme.White

        local checkOK, isValid = pcall(verifyKey, enteredKey)
        if not checkOK then requestSending = false end

        if isValid then
            StatusLabel.Text = "Key valid! Loading Brineland..."
            StatusLabel.TextColor3 = Theme.White
            if writefile then
                pcall(function() writefile(KEY_FILE_NAME, enteredKey) end)
            end
            task.wait(0.45)
            local outTween = TweenService:Create(MainFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                Size = UDim2.fromOffset(420, 0),
                BackgroundTransparency = 1
            })
            outTween:Play()
            outTween.Completed:Wait()
            ScreenGui:Destroy()
            isVerified = true
        else
            StatusLabel.Text = "Key check failed. Check the key, connection, and executor request support."
            StatusLabel.TextColor3 = Theme.SubText
        end
    end)

    repeat task.wait(0.2) until isVerified
    return true
end

VerifyAndLoadHub()

-- ============================================================
-- BRINELAND IY-LITE  (command bar + lightweight Infinite-Yield-style commands)
-- Self-contained: uses its own copy of the Brineland monochrome theme.
-- Load it AFTER the key check (see the one-line hook in the notes).
-- ============================================================
local function BrinelandIYLite()
    local env = (getgenv and getgenv()) or _G
    if env.BrinelandIY and env.BrinelandIY.Destroy then pcall(env.BrinelandIY.Destroy) end

    local Players          = game:GetService("Players")
    local RunService       = game:GetService("RunService")
    local UserInputService = game:GetService("UserInputService")
    local TweenService     = game:GetService("TweenService")
    local Lighting         = game:GetService("Lighting")
    local HttpService      = game:GetService("HttpService")
    local TeleportService  = game:GetService("TeleportService")
    local Workspace        = game:GetService("Workspace")
    local LP = Players.LocalPlayer

    local Theme = {
        Black    = Color3.fromRGB(10, 10, 12),
        DarkGray = Color3.fromRGB(24, 24, 28),
        MidGray  = Color3.fromRGB(46, 46, 54),
        SubText  = Color3.fromRGB(180, 180, 190),
        White    = Color3.fromRGB(255, 255, 255),
    }
    local FANCY_FONT, BODY_FONT = Enum.Font.Fondamento, Enum.Font.GothamBold

    local IY = { Conns = {}, Guis = {}, Alive = true }
    env.BrinelandIY = IY

    local S = { FlySpeed = 50 }   -- runtime state
    local O = {}                  -- original values, captured once
    local say = function(_) end   -- replaced once the UI exists

    local function conn(sig, fn)
        local c = sig:Connect(function(...)
            local ok, err = pcall(fn, ...)
            if not ok then warn("[BrinelandIY] " .. tostring(err)) end
        end)
        table.insert(IY.Conns, c)
        return c
    end

    local function hum()  local c = LP.Character; return c and c:FindFirstChildOfClass("Humanoid") end
    local function root() local c = LP.Character; return c and (c:FindFirstChild("HumanoidRootPart") or c.PrimaryPart) end
    local function cam()  return Workspace.CurrentCamera end

    local function num(v, def, lo, hi)
        local n = tonumber(v)
        if n == nil then n = def end
        if n == nil then return nil end
        if lo then n = math.max(lo, n) end
        if hi then n = math.min(hi, n) end
        return n
    end

    local function teleport(cf)
        local c = LP.Character
        if c then pcall(function() c:PivotTo(cf) end) end
    end

    local function copy(text)
        local fn = setclipboard or toclipboard or set_clipboard
        if fn then pcall(fn, tostring(text)); say("Copied: " .. tostring(text)) else say("Clipboard not supported.") end
    end

    -- originals (captured once, at start)
    O.Light = {
        Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime, GlobalShadows = Lighting.GlobalShadows,
        FogEnd = Lighting.FogEnd, Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
    }
    O.Gravity = Workspace.Gravity
    O.Zoom = { Max = LP.CameraMaxZoomDistance, Min = LP.CameraMinZoomDistance }

    -- ------------------------------------------------------------
    -- Saved data (aliases + waypoints), per executor workspace
    -- ------------------------------------------------------------
    local SAVE_FILE = "BrinelandIY.json"
    local Save = { aliases = {}, waypoints = {} }
    pcall(function()
        if readfile and isfile and isfile(SAVE_FILE) then
            local d = HttpService:JSONDecode(readfile(SAVE_FILE))
            if type(d) == "table" then
                if type(d.aliases) == "table" then Save.aliases = d.aliases end
                if type(d.waypoints) == "table" then Save.waypoints = d.waypoints end
            end
        end
    end)
    local function persist()
        if writefile then pcall(function() writefile(SAVE_FILE, HttpService:JSONEncode(Save)) end) end
    end
    local function placeWaypoints()
        local key = tostring(game.PlaceId)
        Save.waypoints[key] = Save.waypoints[key] or {}
        return Save.waypoints[key]
    end

    -- ------------------------------------------------------------
    -- Player targeting: me / others / all / random / nearest / partial name
    -- ------------------------------------------------------------
    local function findPlayers(q)
        q = (q or "me"):lower()
        local out = {}
        if q == "me" then return { LP } end
        local others = {}
        for _, p in ipairs(Players:GetPlayers()) do if p ~= LP then others[#others + 1] = p end end
        if q == "others" then return others end
        if q == "all" then return Players:GetPlayers() end
        if q == "random" then
            if #others > 0 then out[1] = others[math.random(#others)] end
            return out
        end
        if q == "nearest" or q == "near" then
            local r, best, bestD = root(), nil, math.huge
            for _, p in ipairs(others) do
                local pr = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                if r and pr then
                    local d = (pr.Position - r.Position).Magnitude
                    if d < bestD then best, bestD = p, d end
                end
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

    -- ------------------------------------------------------------
    -- Fly (works with the mobile thumbstick; camera-relative like IY)
    -- ------------------------------------------------------------
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
        S.Fly = false
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

    local function startFly(speed)
        stopFly()
        local r, h = root(), hum()
        if not (r and h) then return false end
        if speed then S.FlySpeed = speed end

        local bv = Instance.new("BodyVelocity")
        bv.Name = "BrinelandFly"
        bv.MaxForce = Vector3.one * 9e9
        bv.Velocity = Vector3.zero
        bv.Parent = r
        local bg = Instance.new("BodyGyro")
        bg.Name = "BrinelandFlyGyro"
        bg.MaxTorque = Vector3.one * 9e9
        bg.P = 9e4
        bg.CFrame = r.CFrame
        bg.Parent = r

        h.PlatformStand = true
        S.Fly = true
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
            local vel = dir * S.FlySpeed + Vector3.new(0, up * S.FlySpeed, 0)
            if vel.Magnitude > S.FlySpeed then vel = vel.Unit * S.FlySpeed end
            bv.Velocity = vel
            bg.CFrame = c.CFrame
        end)
        return true
    end

    -- ------------------------------------------------------------
    -- Noclip (remembers exactly what it changed)
    -- ------------------------------------------------------------
    local noclipSet = setmetatable({}, { __mode = "k" })
    local function setNoclip(on)
        S.Noclip = on
        if not on then
            for p in pairs(noclipSet) do
                pcall(function() p.CanCollide = true end)
                noclipSet[p] = nil
            end
        end
    end
    conn(RunService.Stepped, function()
        if not S.Noclip then return end
        local c = LP.Character
        if not c then return end
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then
                noclipSet[p] = true
                p.CanCollide = false
            end
        end
    end)

    -- ------------------------------------------------------------
    -- One cheap loop enforces speed / jump / god / fov / view / tpwalk
    -- ------------------------------------------------------------
    conn(RunService.Heartbeat, function(dt)
        local h, r = hum(), root()
        if h then
            if S.Speed and h.WalkSpeed ~= S.Speed then h.WalkSpeed = S.Speed end
            if S.Jump then
                if not h.UseJumpPower then h.UseJumpPower = true end
                if h.JumpPower ~= S.Jump then h.JumpPower = S.Jump end
            end
            if S.Hip and h.HipHeight ~= S.Hip then h.HipHeight = S.Hip end
            if S.God and h.Health > 0 and h.Health < h.MaxHealth then h.Health = h.MaxHealth end
            if S.TPWalk and r and h.MoveDirection.Magnitude > 0 then
                r.CFrame = r.CFrame + h.MoveDirection * S.TPWalk * dt
            end
        end
        local c = cam()
        if c then
            if S.FOV and c.FieldOfView ~= S.FOV then c.FieldOfView = S.FOV end
            if S.View then
                local vc = S.View.Character
                local vh = vc and vc:FindFirstChildOfClass("Humanoid")
                if vh and c.CameraSubject ~= vh then c.CameraSubject = vh end
            end
        end
    end)

    conn(UserInputService.JumpRequest, function()
        if S.InfJump then
            local h = hum()
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end)

    conn(LP.Idled, function()
        if S.AntiAFK then
            pcall(function()
                local vu = game:GetService("VirtualUser")
                vu:CaptureController()
                vu:ClickButton2(Vector2.new())
            end)
        end
    end)

    -- Click / tap teleport (Ctrl+click on PC, tap on phone)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    conn(UserInputService.InputBegan, function(input, gp)
        if gp or not S.ClickTP then return end
        local isTouch = input.UserInputType == Enum.UserInputType.Touch
        local isCtrlClick = input.UserInputType == Enum.UserInputType.MouseButton1
            and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
        if not (isTouch or isCtrlClick) then return end
        local c = cam()
        if not (c and root()) then return end
        local ray = c:ScreenPointToRay(input.Position.X, input.Position.Y)
        rayParams.FilterDescendantsInstances = { LP.Character }
        local hit = Workspace:Raycast(ray.Origin, ray.Direction * 2000, rayParams)
        if hit then teleport(CFrame.new(hit.Position + Vector3.new(0, 3, 0))) end
    end)

    -- ------------------------------------------------------------
    -- ESP (one highlight + one tag per player; text refreshed at 4 Hz)
    -- ------------------------------------------------------------
    local espData, espConns = {}, {}
    local function removeEsp(p)
        local d = espData[p]
        if d then
            pcall(function() d.hl:Destroy() end)
            pcall(function() d.bb:Destroy() end)
            espData[p] = nil
        end
    end
    local function addEsp(p)
        if p == LP then return end
        removeEsp(p)
        local c = p.Character
        local hrp = c and (c:FindFirstChild("HumanoidRootPart") or c:WaitForChild("HumanoidRootPart", 3))
        if not hrp then return end

        local hl = Instance.new("Highlight")
        hl.FillColor, hl.OutlineColor, hl.FillTransparency, hl.Adornee = Theme.White, Theme.White, 0.75, c
        hl.Parent = c

        local bb = Instance.new("BillboardGui")
        bb.Adornee, bb.Size, bb.StudsOffset, bb.AlwaysOnTop = hrp, UDim2.fromOffset(140, 30), Vector3.new(0, 3.2, 0), true
        local lbl = Instance.new("TextLabel")
        lbl.Size, lbl.BackgroundTransparency, lbl.TextColor3 = UDim2.new(1, 0, 1, 0), 1, Theme.White
        lbl.Font, lbl.TextSize, lbl.TextStrokeTransparency = BODY_FONT, 11, 0.4
        lbl.Text = p.DisplayName
        lbl.Parent = bb
        bb.Parent = hrp

        espData[p] = { hl = hl, bb = bb, lbl = lbl, hrp = hrp }
    end
    local function setEsp(on)
        if on == (S.Esp or false) then return end
        S.Esp = on
        for _, c in ipairs(espConns) do pcall(function() c:Disconnect() end) end
        table.clear(espConns)
        if on then
            local function hook(p)
                if p == LP then return end
                table.insert(espConns, p.CharacterAdded:Connect(function() task.wait(0.4); if S.Esp then addEsp(p) end end))
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
        while IY.Alive do
            if S.Esp then
                local r = root()
                for p, d in pairs(espData) do
                    local h = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
                    if d.hrp and d.hrp.Parent and r and h then
                        local dist = math.floor((d.hrp.Position - r.Position).Magnitude)
                        d.lbl.Text = string.format("%s\n%dm | %d HP", p.DisplayName, dist, math.floor(h.Health))
                    end
                end
            end
            task.wait(0.25)
        end
    end)

    -- ------------------------------------------------------------
    -- X-Ray (client-side transparency, scanned in chunks, fully restored)
    -- ------------------------------------------------------------
    local xrayOrig = setmetatable({}, { __mode = "k" })
    local xrayConn
    local function xrayPart(p)
        if not p:IsA("BasePart") or xrayOrig[p] ~= nil then return end
        local m = p:FindFirstAncestorOfClass("Model")
        if m and m:FindFirstChildOfClass("Humanoid") then return end   -- keep characters visible
        xrayOrig[p] = p.LocalTransparencyModifier
        p.LocalTransparencyModifier = 0.6
    end
    local function setXray(on)
        if on == (S.Xray or false) then return end
        S.Xray = on
        if xrayConn then xrayConn:Disconnect(); xrayConn = nil end
        if on then
            xrayConn = Workspace.DescendantAdded:Connect(function(d) if S.Xray then pcall(xrayPart, d) end end)
            task.spawn(function()
                local n = 0
                for _, d in ipairs(Workspace:GetDescendants()) do
                    if not S.Xray then return end
                    pcall(xrayPart, d)
                    n = n + 1
                    if n % 2000 == 0 then task.wait() end
                end
            end)
        else
            for p, v in pairs(xrayOrig) do
                pcall(function() p.LocalTransparencyModifier = v end)
                xrayOrig[p] = nil
            end
        end
    end

    -- ------------------------------------------------------------
    -- Server helpers
    -- ------------------------------------------------------------
    local function rejoin()
        say("Rejoining...")
        if #Players:GetPlayers() <= 1 then
            TeleportService:Teleport(game.PlaceId, LP)
        else
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
        end
    end

    env.BrinelandIYVisited = env.BrinelandIYVisited or {}
    local function serverHop()
        say("Searching for a server...")
        task.spawn(function()
            local visited = env.BrinelandIYVisited
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
            if #good == 0 then
                table.clear(visited)
                say("No new server found.")
                return
            end
            local pick = good[math.random(#good)]
            visited[pick] = true
            pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, pick, LP) end)
        end)
    end

    -- ------------------------------------------------------------
    -- Restore everything (used by unload, and by the un* commands)
    -- ------------------------------------------------------------
    local function restoreLight()
        for k, v in pairs(O.Light) do pcall(function() Lighting[k] = v end) end
        S.FB = false
    end
    local function restoreSpeed()
        local h = hum()
        if h and S.Speed then h.WalkSpeed = O.Walk or 16 end
        S.Speed, O.Walk = nil, nil
    end
    local function restoreJump()
        local h = hum()
        if h and S.Jump then
            h.JumpPower = O.JumpPower or 50
            h.UseJumpPower = (O.UseJumpPower ~= false)
        end
        S.Jump, O.JumpPower, O.UseJumpPower = nil, nil, nil
    end
    local function restoreView()
        S.View = nil
        local h, c = hum(), cam()
        if h and c then c.CameraSubject = h end
    end

    local function restoreAll()
        S.FlyWanted = false
        stopFly()
        setNoclip(false)
        restoreSpeed()
        restoreJump()
        S.TPWalk, S.God, S.InfJump, S.AntiAFK, S.ClickTP = nil, nil, nil, nil, nil
        if S.Hip then local h = hum(); if h and O.Hip then h.HipHeight = O.Hip end; S.Hip = nil end
        Workspace.Gravity = O.Gravity
        if S.FOV then S.FOV = nil; local c = cam(); if c and O.FOV then c.FieldOfView = O.FOV end end
        LP.CameraMaxZoomDistance, LP.CameraMinZoomDistance = O.Zoom.Max, O.Zoom.Min
        restoreLight()
        setEsp(false)
        setXray(false)
        restoreView()
    end

    -- ------------------------------------------------------------
    -- Command registry
    -- ------------------------------------------------------------
    local Cmds, Order = {}, {}
    local function reg(names, usage, desc, fn)
        if type(names) == "string" then names = { names } end
        local c = { name = names[1], names = names, usage = usage, desc = desc, fn = fn }
        table.insert(Order, c)
        for _, n in ipairs(names) do Cmds[n] = c end
    end

    -- movement
    reg("fly", "[speed]", "Fly (thumbstick / WASD, Space+E up, Shift+Q down)", function(a)
        S.FlyWanted = true
        if startFly(num(a[1], nil, 1, 500)) then say("Fly ON (speed " .. S.FlySpeed .. ")") else say("No character yet.") end
    end)
    reg("unfly", "", "Stop flying", function() S.FlyWanted = false; stopFly(); say("Fly OFF") end)
    reg("flyspeed", "[n]", "Change fly speed", function(a) S.FlySpeed = num(a[1], 50, 1, 500); say("Fly speed " .. S.FlySpeed) end)
    reg("noclip", "", "Walk through walls", function() setNoclip(true); say("Noclip ON") end)
    reg({ "clip", "unnoclip" }, "", "Turn noclip off", function() setNoclip(false); say("Noclip OFF") end)
    reg({ "speed", "ws", "walkspeed" }, "[n]", "Set walk speed", function(a)
        local h = hum(); if not h then return end
        if not S.Speed then O.Walk = h.WalkSpeed end
        S.Speed = num(a[1], 50, 0, 1000)
        say("Speed " .. S.Speed)
    end)
    reg({ "unspeed", "unws" }, "", "Restore walk speed", function() restoreSpeed(); say("Speed restored") end)
    reg("tpwalk", "[n]", "Speed that games can't reset", function(a) S.TPWalk = num(a[1], 3, 0.1, 100); say("TP-walk " .. S.TPWalk) end)
    reg("untpwalk", "", "Stop tp-walk", function() S.TPWalk = nil; say("TP-walk OFF") end)
    reg({ "jumppower", "jp" }, "[n]", "Set jump power", function(a)
        local h = hum(); if not h then return end
        if not S.Jump then O.JumpPower, O.UseJumpPower = h.JumpPower, h.UseJumpPower end
        S.Jump = num(a[1], 100, 0, 1000)
        say("Jump power " .. S.Jump)
    end)
    reg({ "unjumppower", "unjp" }, "", "Restore jump power", function() restoreJump(); say("Jump restored") end)
    reg("infjump", "", "Jump in mid-air", function() S.InfJump = true; say("Infinite jump ON") end)
    reg("uninfjump", "", "Stop infinite jump", function() S.InfJump = nil; say("Infinite jump OFF") end)
    reg({ "gravity", "grav" }, "[n]", "Set gravity (default 196.2)", function(a)
        Workspace.Gravity = num(a[1], 50, 0, 1000); say("Gravity " .. Workspace.Gravity)
    end)
    reg("ungravity", "", "Restore gravity", function() Workspace.Gravity = O.Gravity; say("Gravity restored") end)
    reg("hipheight", "[n]", "Set hip height", function(a)
        local h = hum(); if not h then return end
        if not S.Hip then O.Hip = h.HipHeight end
        S.Hip = num(a[1], 4, -5, 100); say("Hip height " .. S.Hip)
    end)
    reg("unhipheight", "", "Restore hip height", function()
        local h = hum(); if h and O.Hip then h.HipHeight = O.Hip end
        S.Hip = nil; say("Hip height restored")
    end)
    reg("god", "", "Keep HP full (client-side only)", function() S.God = true; say("God ON (client-side)") end)
    reg("ungod", "", "Stop keeping HP full", function() S.God = nil; say("God OFF") end)
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
    reg("antiafk", "", "Don't get kicked for idling", function() S.AntiAFK = true; say("Anti-AFK ON") end)
    reg("unantiafk", "", "Turn anti-AFK off", function() S.AntiAFK = nil; say("Anti-AFK OFF") end)

    -- teleport
    reg({ "goto", "to" }, "[player]", "Teleport to a player", function(a)
        local p = firstTarget(a); if not p then return end
        local tr = p.Character and (p.Character:FindFirstChild("HumanoidRootPart") or p.Character.PrimaryPart)
        if tr then teleport(tr.CFrame + Vector3.new(0, 3, 0)); say("Teleported to " .. p.Name) end
    end)
    reg("walkto", "[player]", "Walk to a player", function(a)
        local p = firstTarget(a); if not p then return end
        local tr, h = p.Character and p.Character:FindFirstChild("HumanoidRootPart"), hum()
        if tr and h then h:MoveTo(tr.Position); say("Walking to " .. p.Name) end
    end)
    reg({ "tweento", "tgoto" }, "[player]", "Glide to a player", function(a)
        local p = firstTarget(a); if not p then return end
        local tr, r = p.Character and p.Character:FindFirstChild("HumanoidRootPart"), root()
        if tr and r then
            local d = (tr.Position - r.Position).Magnitude
            TweenService:Create(r, TweenInfo.new(math.max(0.1, d / 80), Enum.EasingStyle.Linear), { CFrame = tr.CFrame + Vector3.new(0, 3, 0) }):Play()
            say("Gliding to " .. p.Name)
        end
    end)
    reg("clicktp", "", "Ctrl+click (PC) or tap (phone) to teleport", function() S.ClickTP = true; say("Click-TP ON") end)
    reg("unclicktp", "", "Turn click-TP off", function() S.ClickTP = nil; say("Click-TP OFF") end)
    reg({ "swp", "setwaypoint" }, "[name]", "Save your position", function(a)
        local r = root(); if not r then return end
        local name = a[1] or ("wp" .. tostring(os.time() % 10000))
        local p = r.Position
        placeWaypoints()[name:lower()] = { p.X, p.Y, p.Z }
        persist(); say("Waypoint '" .. name .. "' saved")
    end)
    reg({ "gwp", "gotowaypoint" }, "[name]", "Teleport to a waypoint", function(a)
        local wp = a[1] and placeWaypoints()[a[1]:lower()]
        if wp then teleport(CFrame.new(wp[1], wp[2], wp[3])); say("Went to '" .. a[1] .. "'") else say("No such waypoint.") end
    end)
    reg({ "dwp", "deletewaypoint" }, "[name]", "Delete a waypoint", function(a)
        local t = placeWaypoints()
        if a[1] and t[a[1]:lower()] then t[a[1]:lower()] = nil; persist(); say("Deleted '" .. a[1] .. "'") else say("No such waypoint.") end
    end)
    reg({ "cwp", "clearwaypoints" }, "", "Delete all waypoints here", function()
        Save.waypoints[tostring(game.PlaceId)] = {}; persist(); say("Waypoints cleared")
    end)
    reg({ "wps", "waypoints" }, "", "List waypoints", function()
        local names = {}
        for n in pairs(placeWaypoints()) do names[#names + 1] = n end
        table.sort(names)
        say(#names > 0 and ("Waypoints: " .. table.concat(names, ", ")) or "No waypoints saved here.")
    end)

    -- camera
    reg({ "view", "spectate" }, "[player]", "Watch a player", function(a)
        local p = firstTarget(a); if not p then return end
        S.View = p; say("Viewing " .. p.Name)
    end)
    reg("unview", "", "Stop watching", function() restoreView(); say("View reset") end)
    reg("fov", "[n]", "Set field of view", function(a)
        local c = cam(); if not c then return end
        if not S.FOV then O.FOV = c.FieldOfView end
        S.FOV = num(a[1], 100, 1, 120); say("FOV " .. S.FOV)
    end)
    reg("unfov", "", "Restore field of view", function()
        S.FOV = nil; local c = cam(); if c and O.FOV then c.FieldOfView = O.FOV end; say("FOV restored")
    end)
    reg("zoom", "[n]", "Allow zooming out further", function(a)
        LP.CameraMaxZoomDistance = num(a[1], 1000, 1, 100000); say("Max zoom " .. LP.CameraMaxZoomDistance)
    end)
    reg("unzoom", "", "Restore zoom limits", function()
        LP.CameraMaxZoomDistance, LP.CameraMinZoomDistance = O.Zoom.Max, O.Zoom.Min; say("Zoom restored")
    end)

    -- visuals
    reg("esp", "", "Highlight players with name + distance", function() setEsp(true); say("ESP ON") end)
    reg("unesp", "", "Turn ESP off", function() setEsp(false); say("ESP OFF") end)
    reg("xray", "", "See through walls (client-side)", function() setXray(true); say("X-Ray ON") end)
    reg("unxray", "", "Turn X-Ray off", function() setXray(false); say("X-Ray OFF") end)
    reg({ "fullbright", "fb" }, "", "Bright, no shadows or fog", function()
        local L = Lighting
        L.Brightness, L.ClockTime, L.GlobalShadows, L.FogEnd = 2, 14, false, 100000
        L.Ambient, L.OutdoorAmbient = Color3.new(1, 1, 1), Color3.new(1, 1, 1)
        S.FB = true; say("Fullbright ON")
    end)
    reg({ "unfullbright", "unfb" }, "", "Restore lighting", function() restoreLight(); say("Lighting restored") end)
    reg("time", "[0-24]", "Set time of day", function(a) Lighting.ClockTime = num(a[1], 14, 0, 24); say("Time " .. Lighting.ClockTime) end)
    reg("day", "", "Set daytime", function() Lighting.ClockTime = 14 end)
    reg("night", "", "Set night", function() Lighting.ClockTime = 0 end)
    reg("resettime", "", "Restore time of day", function() Lighting.ClockTime = O.Light.ClockTime end)

    -- utility
    reg("rejoin", "", "Rejoin this server", rejoin)
    reg({ "serverhop", "shop" }, "", "Join a different server", serverHop)
    reg("copyplaceid", "", "Copy the place ID", function() copy(game.PlaceId) end)
    reg("copyjobid", "", "Copy the server job ID", function() copy(game.JobId) end)
    reg("copypos", "", "Copy your position", function()
        local r = root(); if r then local p = r.Position; copy(string.format("%.1f, %.1f, %.1f", p.X, p.Y, p.Z)) end
    end)
    reg("pos", "", "Show your position", function()
        local r = root(); if r then local p = r.Position; say(string.format("Position: %.1f, %.1f, %.1f", p.X, p.Y, p.Z)) end
    end)
    reg("copyname", "[player]", "Copy a player's username", function(a) local p = firstTarget(a); if p then copy(p.Name) end end)
    reg("copyid", "[player]", "Copy a player's user ID", function(a) local p = firstTarget(a); if p then copy(p.UserId) end end)

    -- aliases
    reg("alias", "[name] [command...]", "Make a shortcut, e.g. alias f fly 80", function(a, rest)
        local name = a[1] and a[1]:lower()
        local value = rest:match("^%S+%s+(.+)$")
        if not (name and value) then say("Usage: alias [name] [command...]") return end
        if Cmds[name] then say("'" .. name .. "' is already a command.") return end
        Save.aliases[name] = value; persist(); say("Alias '" .. name .. "' = " .. value)
    end)
    reg("unalias", "[name]", "Delete an alias", function(a)
        local name = a[1] and a[1]:lower()
        if name and Save.aliases[name] then Save.aliases[name] = nil; persist(); say("Alias removed") else say("No such alias.") end
    end)
    reg("aliases", "", "List aliases", function()
        local out = {}
        for n, v in pairs(Save.aliases) do out[#out + 1] = n .. "=" .. v end
        table.sort(out)
        say(#out > 0 and table.concat(out, " | ") or "No aliases yet.")
    end)

    reg({ "cmds", "help" }, "", "Show all commands (clear the box to list them)", function() say(#Order .. " commands. Clear the box to browse them all.") end)
    reg({ "unload", "closecmd" }, "", "Turn everything off and close IY-Lite", function() IY.Destroy() end)

    table.sort(Order, function(x, y) return x.name < y.name end)

    -- ------------------------------------------------------------
    -- Command runner (several commands per line with &&, aliases supported)
    -- ------------------------------------------------------------
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

    -- ------------------------------------------------------------
    -- UI (Brineland monochrome style, touch friendly)
    -- ------------------------------------------------------------
    local function mk(class, props, parent)
        local o = Instance.new(class)
        for k, v in pairs(props) do o[k] = v end
        o.Parent = parent
        return o
    end
    local function round(o, r) mk("UICorner", { CornerRadius = UDim.new(0, r or 8) }, o) end
    local function stroke(o, t) mk("UIStroke", { Color = Theme.White, Thickness = 1.25, Transparency = t or 0.25, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, o) end
    local function isPointer(i) return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch end

    local function viewport()
        local c = cam()
        return c and c.ViewportSize or Vector2.new(800, 600)
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "BrinelandIYLite"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 50
    pcall(function() gui.Parent = (gethui and gethui()) or LP:WaitForChild("PlayerGui") end)
    if not gui.Parent then gui.Parent = LP:WaitForChild("PlayerGui") end
    table.insert(IY.Guis, gui)

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

    -- drag by one specific input; onTap runs when it wasn't dragged
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

    local W = math.clamp(viewport().X - 24, 280, 360)
    local Main = mk("Frame", {
        Size = UDim2.fromOffset(W, 262), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 48),
        BackgroundColor3 = Theme.Black, BackgroundTransparency = 0.06, BorderSizePixel = 0, Active = true,
    }, gui)
    round(Main, 12); stroke(Main, 0)

    local Top = mk("Frame", { Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = Theme.DarkGray, BackgroundTransparency = 0.1, BorderSizePixel = 0, Active = true }, Main)
    round(Top, 12)
    mk("TextLabel", {
        Size = UDim2.new(1, -50, 1, 0), Position = UDim2.fromOffset(12, 0), BackgroundTransparency = 1, Text = "Brineland CMD",
        TextColor3 = Theme.White, Font = FANCY_FONT, TextSize = 18, TextXAlignment = Enum.TextXAlignment.Left,
    }, Top)
    local HideBtn = mk("TextButton", {
        Size = UDim2.fromOffset(28, 26), Position = UDim2.new(1, -34, 0.5, -13), BackgroundColor3 = Theme.MidGray,
        Text = "–", TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 14,
    }, Top)
    round(HideBtn, 13); stroke(HideBtn)
    conn(HideBtn.Activated, function() Main.Visible = false end)
    makeDraggable(Top, Main)

    local Box = mk("TextBox", {
        Size = UDim2.new(1, -80, 0, 32), Position = UDim2.fromOffset(8, 40), BackgroundColor3 = Theme.DarkGray,
        PlaceholderText = "Type a command (e.g. fly 60)", PlaceholderColor3 = Theme.SubText, Text = "",
        TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 12, ClearTextOnFocus = false, TextXAlignment = Enum.TextXAlignment.Left,
    }, Main)
    round(Box, 16); stroke(Box)
    mk("UIPadding", { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 8) }, Box)

    local RunBtn = mk("TextButton", {
        Size = UDim2.fromOffset(58, 32), Position = UDim2.new(1, -66, 0, 40), BackgroundColor3 = Theme.White,
        Text = "RUN", TextColor3 = Theme.Black, Font = BODY_FONT, TextSize = 11,
    }, Main)
    round(RunBtn, 16)

    local List = mk("ScrollingFrame", {
        Size = UDim2.new(1, -16, 0, 124), Position = UDim2.fromOffset(8, 78), BackgroundColor3 = Theme.Black,
        BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.White,
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, Main)
    round(List, 8); stroke(List)
    mk("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder }, List)
    mk("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 6) }, List)

    local Status = mk("TextLabel", {
        Size = UDim2.new(1, -16, 0, 50), Position = UDim2.fromOffset(8, 206), BackgroundTransparency = 1, Text = "",
        TextColor3 = Theme.SubText, Font = BODY_FONT, TextSize = 10, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
    }, Main)

    local lines = {}
    say = function(msg)
        table.insert(lines, tostring(msg))
        while #lines > 3 do table.remove(lines, 1) end
        Status.Text = table.concat(lines, "\n")
    end

    -- pooled suggestion rows (no per-keystroke instance churn)
    local MAX_ROWS = 90
    local rows, rowEntry = {}, {}
    for i = 1, MAX_ROWS do
        local b = mk("TextButton", {
            Size = UDim2.new(1, 0, 0, 24), BackgroundColor3 = Theme.DarkGray, Text = "", RichText = true,
            TextColor3 = Theme.White, Font = Enum.Font.Gotham, TextSize = 10.5, TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd, Visible = false, LayoutOrder = i, AutoButtonColor = true,
        }, List)
        round(b, 6)
        mk("UIPadding", { PaddingLeft = UDim.new(0, 8) }, b)
        rows[i] = b
        conn(b.Activated, function()
            local e = rowEntry[b]
            if not e then return end
            Box.Text = e.name .. " "
            Box:CaptureFocus()
            Box.CursorPosition = #Box.Text + 1
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
                    if typed == "" or n:sub(1, #typed) == typed then
                        entries[#entries + 1] = c
                        break
                    end
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
                b.Visible = true
                rowEntry[b] = c
                b.Text = string.format('<b>%s</b> %s  <font color="#B4B4BE">%s</font>', c.name, c.usage or "", c.desc or "")
            else
                b.Visible = false
                rowEntry[b] = nil
            end
        end
    end
    conn(Box:GetPropertyChangedSignal("Text"), refreshSuggestions)

    -- history (Up / Down on PC) + submit
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
        if not Box:IsFocused() then return end
        if i.KeyCode == Enum.KeyCode.Up and #history > 0 then
            histIdx = math.max(1, histIdx - 1); Box.Text = history[histIdx]; Box.CursorPosition = #Box.Text + 1
        elseif i.KeyCode == Enum.KeyCode.Down and #history > 0 then
            histIdx = math.min(#history + 1, histIdx + 1); Box.Text = history[histIdx] or ""; Box.CursorPosition = #Box.Text + 1
        end
    end)

    -- ";" opens and focuses the bar on PC
    conn(UserInputService.InputBegan, function(i, gp)
        if gp or i.KeyCode ~= Enum.KeyCode.Semicolon then return end
        Main.Visible = true
        Box:CaptureFocus()
        task.defer(function() Box.Text = "" end)
    end)

    -- floating CMD button (drag to move, tap to show/hide)
    local Float = mk("TextButton", {
        Size = UDim2.fromOffset(46, 46), Position = UDim2.new(0, 12, 0.5, 44), BackgroundColor3 = Theme.Black, BackgroundTransparency = 0.06,
        Text = "CMD", TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 11, AutoButtonColor = false,
    }, gui)
    round(Float, 23); stroke(Float, 0)
    makeDraggable(Float, Float, function() Main.Visible = not Main.Visible end)

    -- mobile fly pad (up / down), shown only while flying on touch devices
    local Pad = mk("Frame", {
        Size = UDim2.fromOffset(56, 116), Position = UDim2.new(1, -76, 1, -210), BackgroundTransparency = 1, Visible = false,
    }, gui)
    S.FlyPad = Pad
    local function holdButton(text, y, key)
        local b = mk("TextButton", {
            Size = UDim2.fromOffset(56, 54), Position = UDim2.fromOffset(0, y), BackgroundColor3 = Theme.Black, BackgroundTransparency = 0.15,
            Text = text, TextColor3 = Theme.White, Font = BODY_FONT, TextSize = 20, AutoButtonColor = false,
        }, Pad)
        round(b, 27); stroke(b, 0.1)
        local held
        conn(b.InputBegan, function(i) if isPointer(i) and not held then held = i; S[key] = true end end)
        conn(UserInputService.InputEnded, function(i) if held and i == held then held = nil; S[key] = false end end)
    end
    holdButton("▲", 0, "UpHeld")
    holdButton("▼", 62, "DownHeld")

    -- respawn: reset per-character state, then restore what the user had on
    conn(LP.CharacterAdded, function(char)
        table.clear(noclipSet)
        O.Walk, O.JumpPower, O.UseJumpPower, O.Hip = nil, nil, nil, nil
        char:WaitForChild("HumanoidRootPart", 10)
        task.wait(0.8)
        local h = hum()
        if h then
            if S.Speed then O.Walk = h.WalkSpeed end
            if S.Jump then O.JumpPower, O.UseJumpPower = h.JumpPower, h.UseJumpPower end
            if S.Hip then O.Hip = h.HipHeight end
        end
        if S.FlyWanted then startFly() end
    end)

    function IY.Destroy()
        IY.Alive = false
        pcall(restoreAll)
        for _, c in ipairs(IY.Conns) do pcall(function() c:Disconnect() end) end
        table.clear(IY.Conns)
        for _, g in ipairs(IY.Guis) do pcall(function() g:Destroy() end) end
        table.clear(IY.Guis)
        env.BrinelandIY = nil
    end

    refreshSuggestions()
    say("Brineland CMD ready. Clear the box to browse commands.")
end


local cmdOK, cmdError = pcall(BrinelandIYLite)
if not cmdOK then warn("[BRINELAND] Command bar failed: " .. tostring(cmdError)) end

-- ============================================================
-- UNIVERSAL HUB (WIDER SIDEWAYS + CLEAN HOME LAYOUT + HIDDEN AUDIO)
-- ============================================================
local function RunUniversalScript()
    EnsureHiddenMusic()

    local Workspace        = game:GetService("Workspace")
    local RunService       = game:GetService("RunService")
    local Lighting         = game:GetService("Lighting")
    local Stats            = game:GetService("Stats")
    local LogService       = game:GetService("LogService")
    local Camera           = Workspace.CurrentCamera

    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    if PlayerGui:FindFirstChild("BrinelandUniversalHub") then
        PlayerGui.BrinelandUniversalHub:Destroy()
    end

    local hubAlive = true
    local hubConns = {}
    local function trackConn(c)
        table.insert(hubConns, c)
        return c
    end

    local Config = {
        WalkSpeed    = 16,
        SpeedEnabled = false,
        FlyEnabled   = false,
        FlySpeed     = 50,
        Noclip       = false,
        PlayerESP    = false,
        CleanVision  = false,
        AutoAim      = false,
        AutoAimRange = 60,
        FastInteract = false
    }

    local Keybinds = {}
    local moveConnections = {}
    local flightPad
    local collisionOriginal = setmetatable({}, {__mode = "k"})
    local promptOriginal = setmetatable({}, {__mode = "k"})
    local promptGeneration = 0
    local savedSpeedHumanoid, savedWalkSpeed
    local function restoreCollisions()
        for p, v in pairs(collisionOriginal) do pcall(function() p.CanCollide = v end); collisionOriginal[p] = nil end
    end
    local function restoreSpeed()
        if savedSpeedHumanoid and savedWalkSpeed ~= nil then pcall(function() savedSpeedHumanoid.WalkSpeed = savedWalkSpeed end) end
        savedSpeedHumanoid, savedWalkSpeed = nil, nil
    end
    local function setFastInteract(on)
        Config.FastInteract = on
        promptGeneration += 1
        local generation = promptGeneration
        local function change(p)
            if p:IsA("ProximityPrompt") and promptOriginal[p] == nil then
                promptOriginal[p] = p.HoldDuration
                p.HoldDuration = 0
            end
        end
        if moveConnections.PromptAdded then moveConnections.PromptAdded:Disconnect(); moveConnections.PromptAdded = nil end
        if on then
            moveConnections.PromptAdded = Workspace.DescendantAdded:Connect(function(p) if Config.FastInteract then pcall(change, p) end end)
            task.spawn(function()
                for i, p in ipairs(Workspace:GetDescendants()) do
                    if not hubAlive or not Config.FastInteract or generation ~= promptGeneration then return end
                    pcall(change, p)
                    if i % 500 == 0 then task.wait() end
                end
            end)
        else
            for p, duration in pairs(promptOriginal) do pcall(function() p.HoldDuration = duration end); promptOriginal[p] = nil end
        end
    end
    local mobileInputs = { Forward = false, Backward = false, Left = false, Right = false, Up = false, Down = false }

    local function SafeTeleport(targetCFrame)
        local char = LocalPlayer.Character
        if not char then return end
        pcall(function()
            if char.PrimaryPart then
                char:PivotTo(targetCFrame)
            else
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.CFrame = targetCFrame end
            end
        end)
    end

    local function TweenToPosition(targetCFrame)
        local char = LocalPlayer.Character
        local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart)
        if not hrp then return end
        pcall(function()
            local dist = (hrp.Position - targetCFrame.Position).Magnitude
            local duration = math.max(0.1, dist / 80)
            local tween = TweenService:Create(hrp, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
            tween:Play()
        end)
    end

    local function WalkToPosition(targetCFrame)
        local char = LocalPlayer.Character
        local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart)
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        pcall(function()
            hum:MoveTo(targetCFrame.Position)
        end)
    end

    local function GetNearestEnemyTarget(maxRange)
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end

        local closestPart = nil
        local shortestDist = maxRange or math.huge

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local targetHrp = player.Character:FindFirstChild("HumanoidRootPart")
                local targetHead = player.Character:FindFirstChild("Head")
                local hum = player.Character:FindFirstChildOfClass("Humanoid")

                if targetHrp and hum and hum.Health > 0 then
                    local dist = (targetHrp.Position - hrp.Position).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestPart = targetHead or targetHrp
                    end
                end
            end
        end
        return closestPart
    end

    local function GetFlightVector()
        local vector = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) or mobileInputs.Forward then vector = vector + Vector3.new(0, 0, -1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) or mobileInputs.Backward then vector = vector + Vector3.new(0, 0, 1) end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) or mobileInputs.Left then vector = vector + Vector3.new(-1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) or mobileInputs.Right then vector = vector + Vector3.new(1, 0, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) or mobileInputs.Up then vector = vector + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or mobileInputs.Down then vector = vector + Vector3.new(0, -1, 0) end
        if UserInputService.TouchEnabled then
            local h = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            local camera = Workspace.CurrentCamera
            if h and camera then
                local mv = camera.CFrame:VectorToObjectSpace(h.MoveDirection)
                vector = vector + Vector3.new(mv.X, 0, mv.Z)
            end
        end
        return vector
    end

    local function EnableFly()
        local char = LocalPlayer.Character
        if not char then return end
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not rootPart or not humanoid then return end

        Config.FlyEnabled = true
        if flightPad and UserInputService.TouchEnabled then flightPad.Visible = true end
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)

        if moveConnections.FlightLoop then
            moveConnections.FlightLoop:Disconnect()
        end

        moveConnections.FlightLoop = RunService.Heartbeat:Connect(function(deltaTime)
            if not Config.FlyEnabled or not rootPart or not char:IsDescendantOf(Workspace) then return end
            rootPart.Velocity = Vector3.new(0, 0.1, 0)

            local flightVector = GetFlightVector()
            if flightVector.Magnitude > 0 then
                local camera = Workspace.CurrentCamera
                if not camera then return end
                local cf = camera.CFrame
                local worldDirection = cf.RightVector * flightVector.X - cf.LookVector * flightVector.Z + Vector3.new(0, flightVector.Y, 0)
                if worldDirection.Magnitude > 0 then rootPart.CFrame = rootPart.CFrame + (worldDirection.Unit * Config.FlySpeed * deltaTime) end
            end
        end)
    end

    local function DisableFly()
        Config.FlyEnabled = false
        mobileInputs.Up, mobileInputs.Down = false, false
        if flightPad then flightPad.Visible = false end
        if moveConnections.FlightLoop then
            moveConnections.FlightLoop:Disconnect()
            moveConnections.FlightLoop = nil
        end
        local char = LocalPlayer.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end

    trackConn(RunService.Stepped:Connect(function()
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            if Config.SpeedEnabled then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then
                    if savedSpeedHumanoid ~= hum then savedSpeedHumanoid, savedWalkSpeed = hum, hum.WalkSpeed end
                    hum.WalkSpeed = Config.WalkSpeed
                end
            end
            if Config.Noclip then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then collisionOriginal[part] = true; part.CanCollide = false end
                end
            end
        end)
    end))

    local ESPStorage = {}
    local function RemovePlayerESP(player)
        if ESPStorage[player] then
            if ESPStorage[player].Connection then ESPStorage[player].Connection:Disconnect() end
            if ESPStorage[player].Highlight then ESPStorage[player].Highlight:Destroy() end
            if ESPStorage[player].Billboard then ESPStorage[player].Billboard:Destroy() end
            ESPStorage[player] = nil
        end
    end

    local function CreatePlayerESP(player)
        if player == LocalPlayer then return end
        local function CharacterAdded(char)
            RemovePlayerESP(player)
            if not char then return end
            local hrp = char:WaitForChild("HumanoidRootPart", 5)
            local hum = char:WaitForChild("Humanoid", 5)
            if not hrp or not hum or not hubAlive then return end

            local highlight = Instance.new("Highlight")
            highlight.FillColor = Theme.White
            highlight.OutlineColor = Theme.White
            highlight.FillTransparency = 0.7
            highlight.Adornee = char
            highlight.Enabled = Config.PlayerESP
            highlight.Parent = char

            local billboard = Instance.new("BillboardGui")
            billboard.Adornee = hrp
            billboard.Size = UDim2.fromOffset(160, 40)
            billboard.StudsOffset = Vector3.new(0, 3.5, 0)
            billboard.AlwaysOnTop = true

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = "<b>" .. player.DisplayName .. "</b>"
            nameLabel.TextColor3 = Theme.White
            nameLabel.Font = BODY_FONT
            nameLabel.TextSize = 11
            nameLabel.RichText = true
            nameLabel.Parent = billboard

            local infoLabel = Instance.new("TextLabel")
            infoLabel.Size = UDim2.new(1, 0, 0.5, 0)
            infoLabel.Position = UDim2.new(0, 0, 0.5, 0)
            infoLabel.BackgroundTransparency = 1
            infoLabel.TextColor3 = Theme.SubText
            infoLabel.Font = BODY_FONT
            infoLabel.TextSize = 10
            infoLabel.RichText = true
            infoLabel.Parent = billboard
            billboard.Parent = hrp

            local updateConn = RunService.Heartbeat:Connect(function()
                pcall(function()
                    if not char.Parent or not hum or hum.Health <= 0 or not Config.PlayerESP then
                        billboard.Enabled = false; highlight.Enabled = false
                        return
                    end
                    local myChar = LocalPlayer.Character
                    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    local dist = myHrp and math.floor((hrp.Position - myHrp.Position).Magnitude) or 0
                    billboard.Enabled = true; highlight.Enabled = true
                    infoLabel.Text = string.format("<b>HP: %d/%d | Dist: %dm</b>", math.floor(hum.Health), math.floor(hum.MaxHealth), dist)
                end)
            end)

            ESPStorage[player] = { Highlight = highlight, Billboard = billboard, Connection = updateConn }
        end
        if player.Character then CharacterAdded(player.Character) end
        trackConn(player.CharacterAdded:Connect(CharacterAdded))
    end

    for _, p in ipairs(Players:GetPlayers()) do CreatePlayerESP(p) end
    trackConn(Players.PlayerAdded:Connect(CreatePlayerESP))
    trackConn(Players.PlayerRemoving:Connect(RemovePlayerESP))

    local function ToggleESPState(state)
        Config.PlayerESP = state
        for _, data in pairs(ESPStorage) do
            if data.Highlight then data.Highlight.Enabled = state end
            if data.Billboard then data.Billboard.Enabled = state end
        end
    end

    local originalLighting = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        GlobalShadows = Lighting.GlobalShadows,
        FogEnd = Lighting.FogEnd
    }
    local effectStates = {}

    local function ToggleCleanVision(state)
        Config.CleanVision = state
        pcall(function()
            if state then
                Lighting.Brightness = 2
                Lighting.ClockTime = 14
                Lighting.GlobalShadows = false
                Lighting.FogEnd = 100000
                for _, desc in ipairs(Lighting:GetDescendants()) do
                    if desc:IsA("PostEffect") then
                        effectStates[desc] = desc.Enabled
                        desc.Enabled = false
                    elseif desc:IsA("Atmosphere") then
                        effectStates[desc] = desc.Density
                        desc.Density = 0
                    end
                end
            else
                Lighting.Brightness = originalLighting.Brightness
                Lighting.ClockTime = originalLighting.ClockTime
                Lighting.GlobalShadows = originalLighting.GlobalShadows
                Lighting.FogEnd = originalLighting.FogEnd
                for _, desc in ipairs(Lighting:GetDescendants()) do
                    if effectStates[desc] ~= nil then
                        if desc:IsA("PostEffect") then desc.Enabled = effectStates[desc]
                        elseif desc:IsA("Atmosphere") then desc.Density = effectStates[desc] end
                        effectStates[desc] = nil
                    end
                end
            end
        end)
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BrinelandUniversalHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    flightPad = Instance.new("Frame")
    flightPad.Name = "FlyPad"
    flightPad.Size = UDim2.fromOffset(54, 110)
    flightPad.Position = UDim2.new(1, -75, 1, -210)
    flightPad.BackgroundTransparency = 1
    flightPad.Visible = false
    flightPad.Parent = ScreenGui
    local function flyButton(label, y, key)
        local button = Instance.new("TextButton")
        button.Size = UDim2.fromOffset(52, 50); button.Position = UDim2.fromOffset(0, y)
        button.BackgroundColor3 = Theme.DarkGray; button.Text = label; button.TextColor3 = Theme.White
        button.Font = BODY_FONT; button.TextSize = 18; button.Parent = flightPad
        Instance.new("UICorner", button).CornerRadius = UDim.new(1, 0)
        local held
        trackConn(button.InputBegan:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) and not held then held = input; mobileInputs[key] = true end
        end))
        trackConn(UserInputService.InputEnded:Connect(function(input) if input == held then held = nil; mobileInputs[key] = false end end))
    end
    flyButton("▲", 0, "Up"); flyButton("▼", 56, "Down")

    local HUB_WIDTH = 420
    local HUB_HEIGHT = 315

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.fromOffset(HUB_WIDTH, 0)
    MainFrame.Position = UDim2.fromOffset(16, 48)
    MainFrame.BackgroundColor3 = Theme.Black
    MainFrame.BackgroundTransparency = 0.06
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
    addWhiteBoxStroke(MainFrame, 1.5, 0)

    TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(HUB_WIDTH, HUB_HEIGHT)
    }):Play()

    -- Allow RightShift on PC to hide/show the panel
    trackConn(UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
            MainFrame.Visible = not MainFrame.Visible
        end
    end))

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Theme.DarkGray
    TopBar.BackgroundTransparency = 0.1
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 12)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -130, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Brineland"
    Title.TextColor3 = Theme.White
    Title.Font = FANCY_FONT
    Title.TextSize = 19
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    MakeDraggable(MainFrame, TopBar)

    -- Top-right Home button (opens Home view; no Home button in the tab bar)
    local HomeOvalBtn = Instance.new("TextButton")
    HomeOvalBtn.Size = UDim2.fromOffset(50, 24)
    HomeOvalBtn.Position = UDim2.new(1, -120, 0.5, -12)
    HomeOvalBtn.BackgroundColor3 = Theme.White
    HomeOvalBtn.Text = "Home"
    HomeOvalBtn.TextColor3 = Theme.Black
    HomeOvalBtn.Font = BODY_FONT
    HomeOvalBtn.TextSize = 9.5
    HomeOvalBtn.Parent = TopBar
    Instance.new("UICorner", HomeOvalBtn).CornerRadius = UDim.new(1, 0)

    local ArrowCircleBtn = Instance.new("TextButton")
    ArrowCircleBtn.Size = UDim2.fromOffset(26, 26)
    ArrowCircleBtn.Position = UDim2.new(1, -62, 0.5, -13)
    ArrowCircleBtn.BackgroundColor3 = Theme.MidGray
    ArrowCircleBtn.Text = "▼"
    ArrowCircleBtn.TextColor3 = Theme.White
    ArrowCircleBtn.Font = BODY_FONT
    ArrowCircleBtn.TextSize = 10
    ArrowCircleBtn.Parent = TopBar
    Instance.new("UICorner", ArrowCircleBtn).CornerRadius = UDim.new(1, 0)
    addWhiteBoxStroke(ArrowCircleBtn, 1, 0.2)

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.fromOffset(26, 26)
    CloseBtn.Position = UDim2.new(1, -32, 0.5, -13)
    CloseBtn.BackgroundColor3 = Theme.MidGray
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Theme.White
    CloseBtn.Font = BODY_FONT
    CloseBtn.TextSize = 11
    CloseBtn.Parent = TopBar
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
    addWhiteBoxStroke(CloseBtn, 1, 0.2)
    CloseBtn.MouseButton1Click:Connect(function()
        hubAlive = false
        DisableFly()
        Config.Noclip = false; restoreCollisions(); restoreSpeed(); setFastInteract(false)
        if Config.CleanVision then ToggleCleanVision(false) end
        for p in pairs(ESPStorage) do RemovePlayerESP(p) end
        for _, c in ipairs(hubConns) do pcall(function() c:Disconnect() end) end
        local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Size = UDim2.fromOffset(HUB_WIDTH, 0),
            BackgroundTransparency = 1
        })
        closeTween:Play()
        closeTween.Completed:Wait()
        ScreenGui:Destroy()
    end)

    local topDivider = Instance.new("Frame")
    topDivider.Size = UDim2.new(1, -14, 0, 1)
    topDivider.Position = UDim2.new(0, 7, 0, 40)
    topDivider.BackgroundColor3 = Theme.White
    topDivider.BorderSizePixel = 0
    topDivider.Parent = MainFrame

    local TabBar = Instance.new("ScrollingFrame")
    TabBar.Size = UDim2.new(1, -14, 0, 28)
    TabBar.Position = UDim2.new(0, 7, 0, 44)
    TabBar.BackgroundTransparency = 1
    TabBar.ScrollBarThickness = 2
    TabBar.ScrollBarImageColor3 = Theme.White
    TabBar.CanvasSize = UDim2.new(0, 420, 0, 0)
    TabBar.Parent = MainFrame

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.Padding = UDim.new(0, 4)
    TabLayout.Parent = TabBar

    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabBar.CanvasSize = UDim2.new(0, TabLayout.AbsoluteContentSize.X + 8, 0, 0)
    end)

    local tabDivider = Instance.new("Frame")
    tabDivider.Size = UDim2.new(1, -14, 0, 1)
    tabDivider.Position = UDim2.new(0, 7, 0, 75)
    tabDivider.BackgroundColor3 = Theme.White
    tabDivider.BorderSizePixel = 0
    tabDivider.Parent = MainFrame

    local TabFrames = {}
    local activeTabName = "Home"
    local isCollapsed = false

    local function SelectTab(tabName)
        activeTabName = tabName
        for name, data in pairs(TabFrames) do
            local active = (name == tabName)
            data.Container.Visible = active
            if data.Button then
                TweenService:Create(data.Button, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundColor3 = active and Theme.White or Theme.DarkGray,
                    TextColor3 = active and Theme.Black or Theme.SubText
                }):Play()
            end
        end
        TweenService:Create(HomeOvalBtn, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = (tabName == "Home") and Theme.White or Theme.MidGray,
            TextColor3 = (tabName == "Home") and Theme.Black or Theme.White
        }):Play()
    end

    -- Create a container for a view; pass showInTabBar = false for Home (accessed via top-right Home button)
    local function CreateTab(tabName, widthPx, showInTabBar, customScroll)
        local tabBtn = nil
        if showInTabBar ~= false then
            tabBtn = Instance.new("TextButton")
            tabBtn.Size = UDim2.fromOffset(widthPx or 56, 23)
            tabBtn.BackgroundColor3 = Theme.DarkGray
            tabBtn.Text = tabName
            tabBtn.TextColor3 = Theme.SubText
            tabBtn.Font = BODY_FONT
            tabBtn.TextSize = 8.5
            tabBtn.Parent = TabBar
            Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(1, 0)
            addWhiteBoxStroke(tabBtn, 1, 0.35)

            tabBtn.MouseButton1Click:Connect(function()
                SelectTab(tabName)
            end)
        end

        local container
        if customScroll == false then
            container = Instance.new("Frame")
            container.Size = UDim2.new(1, -14, 1, -83)
            container.Position = UDim2.new(0, 7, 0, 80)
            container.BackgroundTransparency = 1
            container.Visible = false
            container.Parent = MainFrame
        else
            container = Instance.new("ScrollingFrame")
            container.Size = UDim2.new(1, -14, 1, -83)
            container.Position = UDim2.new(0, 7, 0, 80)
            container.BackgroundTransparency = 1
            container.ScrollBarThickness = 3
            container.ScrollBarImageColor3 = Theme.White
            container.Visible = false
            container.Parent = MainFrame

            local listLayout = Instance.new("UIListLayout")
            listLayout.Padding = UDim.new(0, 6)
            listLayout.Parent = container

            listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                container.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 12)
            end)
        end

        TabFrames[tabName] = { Button = tabBtn, Container = container }
        return container
    end

    -- Home view is NOT in the tab bar; opened by pressing the top-right Home button
    local HomeTab      = CreateTab("Home", 52, false, false)
    local InfoTab      = CreateTab("Info", 52, true)
    local TeleportsTab = CreateTab("TP", 46, true)
    local PlayersTab   = CreateTab("Player", 62, true)
    local CheatsTab    = CreateTab("Cheats", 62, true)
    local VisualsTab   = CreateTab("Visuals", 66, true)
    local KeyTab       = CreateTab("Key", 48, true)

    SelectTab("Home")
    HomeOvalBtn.MouseButton1Click:Connect(function()
        if isCollapsed then
            isCollapsed = false
            TweenService:Create(MainFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(HUB_WIDTH, HUB_HEIGHT)
            }):Play()
            TweenService:Create(ArrowCircleBtn, TweenInfo.new(0.2), { Rotation = 0 }):Play()
            topDivider.Visible = true
            tabDivider.Visible = true
            TabBar.Visible = true
        end
        SelectTab("Home")
    end)

    ArrowCircleBtn.MouseButton1Click:Connect(function()
        isCollapsed = not isCollapsed
        if isCollapsed then
            for _, data in pairs(TabFrames) do data.Container.Visible = false end
            TabBar.Visible = false
            topDivider.Visible = false
            tabDivider.Visible = false
            TweenService:Create(MainFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(HUB_WIDTH, 40)
            }):Play()
            TweenService:Create(ArrowCircleBtn, TweenInfo.new(0.2), { Rotation = 180 }):Play()
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(HUB_WIDTH, HUB_HEIGHT)
            }):Play()
            TweenService:Create(ArrowCircleBtn, TweenInfo.new(0.2), { Rotation = 0 }):Play()
            task.wait(0.14)
            topDivider.Visible = true
            tabDivider.Visible = true
            TabBar.Visible = true
            if TabFrames[activeTabName] then
                TabFrames[activeTabName].Container.Visible = true
            end
        end
    end)

    local function CreateButton(parentContainer, text, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -2, 0, 34)
        frame.BackgroundColor3 = Theme.DarkGray
        frame.Parent = parentContainer
        Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)
        addWhiteBoxStroke(frame, 1, 0.25)

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = text
        btn.TextColor3 = Theme.White
        btn.Font = BODY_FONT
        btn.TextSize = 10.5
        btn.Parent = frame

        btn.MouseButton1Click:Connect(function()
            TweenService:Create(frame, TweenInfo.new(0.1), { BackgroundColor3 = Theme.MidGray }):Play()
            task.delay(0.12, function()
                if frame.Parent then
                    TweenService:Create(frame, TweenInfo.new(0.15), { BackgroundColor3 = Theme.DarkGray }):Play()
                end
            end)
            callback()
        end)
    end

    local function CreateToggle(parentContainer, text, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -2, 0, 36)
        frame.BackgroundColor3 = Theme.DarkGray
        frame.Parent = parentContainer
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
        addWhiteBoxStroke(frame, 1, 0.25)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -56, 1, 0)
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Theme.White
        lbl.Font = BODY_FONT
        lbl.TextSize = 10.5
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame

        local toggleBg = Instance.new("Frame")
        toggleBg.Size = UDim2.fromOffset(38, 20)
        toggleBg.Position = UDim2.new(1, -46, 0.5, -10)
        toggleBg.BackgroundColor3 = Theme.MidGray
        toggleBg.Parent = frame
        Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)
        addWhiteBoxStroke(toggleBg, 1, 0.3)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.fromOffset(16, 16)
        knob.Position = UDim2.new(0, 2, 0.5, -8)
        knob.BackgroundColor3 = Theme.White
        knob.Parent = toggleBg
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.Parent = frame

        local active = false
        btn.MouseButton1Click:Connect(function()
            active = not active
            TweenService:Create(knob, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Position = active and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                BackgroundColor3 = active and Theme.Black or Theme.White
            }):Play()
            TweenService:Create(toggleBg, TweenInfo.new(0.2), {
                BackgroundColor3 = active and Theme.White or Theme.MidGray
            }):Play()
            callback(active)
        end)
    end

    local function CreateSlider(parentContainer, text, minVal, maxVal, defaultVal, showNumbers, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -2, 0, 42)
        frame.BackgroundColor3 = Theme.DarkGray
        frame.Parent = parentContainer
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
        addWhiteBoxStroke(frame, 1, 0.25)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -16, 0, 18)
        lbl.Position = UDim2.new(0, 10, 0, 3)
        lbl.BackgroundTransparency = 1
        lbl.Text = showNumbers and (text .. ": " .. tostring(defaultVal)) or text
        lbl.TextColor3 = Theme.White
        lbl.Font = BODY_FONT
        lbl.TextSize = 10
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame

        local track = Instance.new("Frame")
        track.Size = UDim2.new(1, -20, 0, 7)
        track.Position = UDim2.new(0, 10, 0, 25)
        track.BackgroundColor3 = Theme.MidGray
        track.Parent = frame
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

        local fill = Instance.new("Frame")
        local startPct = math.clamp((defaultVal - minVal) / (maxVal - minVal), 0, 1)
        fill.Size = UDim2.new(startPct, 0, 1, 0)
        fill.BackgroundColor3 = Theme.White
        fill.Parent = track
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local sliding = false
        local function UpdateValue(input)
            local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            TweenService:Create(fill, TweenInfo.new(0.06), { Size = UDim2.new(pos, 0, 1, 0) }):Play()
            local val = math.floor(minVal + (maxVal - minVal) * pos)
            if showNumbers then
                lbl.Text = text .. ": " .. tostring(val)
            end
            callback(val)
        end

        track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                sliding = true; UpdateValue(input)
            end
        end)

        trackConn(UserInputService.InputChanged:Connect(function(input)
            if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                UpdateValue(input)
            end
        end))

        trackConn(UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                sliding = false
            end
        end))
    end

    -- ============================================================
    -- HOME VIEW (MATCHING WHITE-CIRCLED REFERENCE LAYOUT)
    -- ============================================================
    -- 1. Left Welcome Text Block
    local welcomeHeading = Instance.new("TextLabel")
    welcomeHeading.Size = UDim2.new(0.62, 0, 0, 34)
    welcomeHeading.Position = UDim2.new(0, 6, 0, 2)
    welcomeHeading.BackgroundTransparency = 1
    welcomeHeading.Text = "Welcome back to\nBRINELAND HUB"
    welcomeHeading.TextColor3 = Theme.White
    welcomeHeading.Font = BODY_FONT
    welcomeHeading.TextSize = 13
    welcomeHeading.TextWrapped = true
    welcomeHeading.TextXAlignment = Enum.TextXAlignment.Left
    welcomeHeading.TextYAlignment = Enum.TextYAlignment.Top
    welcomeHeading.Parent = HomeTab

    local welcomeDesc = Instance.new("TextLabel")
    welcomeDesc.Size = UDim2.new(0.62, 0, 0, 56)
    welcomeDesc.Position = UDim2.new(0, 6, 0, 38)
    welcomeDesc.BackgroundTransparency = 1
    welcomeDesc.Text = "Fast, clean and always up to date.\nTeleports, player warp, combat & ESP.\nWorks on PC, phone and every executor.\nPress RightShift to hide the panel."
    welcomeDesc.TextColor3 = Theme.SubText
    welcomeDesc.Font = Enum.Font.Gotham
    welcomeDesc.TextSize = 9.5
    welcomeDesc.TextWrapped = true
    welcomeDesc.TextXAlignment = Enum.TextXAlignment.Left
    welcomeDesc.TextYAlignment = Enum.TextYAlignment.Top
    welcomeDesc.Parent = HomeTab

    -- Right-side compact status badge
    local rightBadge = Instance.new("Frame")
    rightBadge.Size = UDim2.new(0.35, -6, 0, 88)
    rightBadge.Position = UDim2.new(0.65, 2, 0, 4)
    rightBadge.BackgroundColor3 = Theme.DarkGray
    rightBadge.Parent = HomeTab
    Instance.new("UICorner", rightBadge).CornerRadius = UDim.new(0, 10)
    addWhiteBoxStroke(rightBadge, 1, 0.25)

    local badgeTitle = Instance.new("TextLabel")
    badgeTitle.Size = UDim2.new(1, -10, 0, 26)
    badgeTitle.Position = UDim2.new(0, 5, 0, 8)
    badgeTitle.BackgroundTransparency = 1
    badgeTitle.Text = "BRINELAND"
    badgeTitle.TextColor3 = Theme.White
    badgeTitle.Font = FANCY_FONT
    badgeTitle.TextSize = 16
    badgeTitle.Parent = rightBadge

    local badgeSub = Instance.new("TextLabel")
    badgeSub.Size = UDim2.new(1, -10, 0, 44)
    badgeSub.Position = UDim2.new(0, 5, 0, 36)
    badgeSub.BackgroundTransparency = 1
    badgeSub.Text = "UNIVERSAL\nEDITION\n@" .. LocalPlayer.Name
    badgeSub.TextColor3 = Theme.SubText
    badgeSub.Font = BODY_FONT
    badgeSub.TextSize = 8.5
    badgeSub.TextWrapped = true
    badgeSub.Parent = rightBadge

    -- 2. Discord & YouTube Link Buttons Row
    local socialRow = Instance.new("Frame")
    socialRow.Size = UDim2.new(1, -8, 0, 32)
    socialRow.Position = UDim2.new(0, 4, 0, 100)
    socialRow.BackgroundTransparency = 1
    socialRow.Parent = HomeTab

    local discordSocialBtn = Instance.new("TextButton")
    discordSocialBtn.Size = UDim2.new(0.49, -2, 1, 0)
    discordSocialBtn.Position = UDim2.new(0, 0, 0, 0)
    discordSocialBtn.BackgroundColor3 = Theme.DarkGray
    discordSocialBtn.Text = "DISCORD"
    discordSocialBtn.TextColor3 = Theme.White
    discordSocialBtn.Font = BODY_FONT
    discordSocialBtn.TextSize = 10
    discordSocialBtn.Parent = socialRow
    Instance.new("UICorner", discordSocialBtn).CornerRadius = UDim.new(0, 8)
    addWhiteBoxStroke(discordSocialBtn, 1, 0.25)

    discordSocialBtn.MouseButton1Click:Connect(function()
        if fSetClipboard then
            pcall(fSetClipboard, DISCORD_INVITE)
            discordSocialBtn.Text = "COPIED DISCORD!"
            discordSocialBtn.BackgroundColor3 = Theme.White
            discordSocialBtn.TextColor3 = Theme.Black
            task.delay(1.4, function()
                if hubAlive and discordSocialBtn.Parent then
                    discordSocialBtn.Text = "DISCORD"
                    discordSocialBtn.BackgroundColor3 = Theme.DarkGray
                    discordSocialBtn.TextColor3 = Theme.White
                end
            end)
        end
    end)

    local youtubeSocialBtn = Instance.new("TextButton")
    youtubeSocialBtn.Size = UDim2.new(0.49, -2, 1, 0)
    youtubeSocialBtn.Position = UDim2.new(0.51, 2, 0, 0)
    youtubeSocialBtn.BackgroundColor3 = Theme.DarkGray
    youtubeSocialBtn.Text = "YOUTUBE"
    youtubeSocialBtn.TextColor3 = Theme.White
    youtubeSocialBtn.Font = BODY_FONT
    youtubeSocialBtn.TextSize = 10
    youtubeSocialBtn.Parent = socialRow
    Instance.new("UICorner", youtubeSocialBtn).CornerRadius = UDim.new(0, 8)
    addWhiteBoxStroke(youtubeSocialBtn, 1, 0.25)

    youtubeSocialBtn.MouseButton1Click:Connect(function()
        if fSetClipboard then
            pcall(fSetClipboard, YOUTUBE_URL)
            youtubeSocialBtn.Text = "COPIED YOUTUBE!"
            youtubeSocialBtn.BackgroundColor3 = Theme.White
            youtubeSocialBtn.TextColor3 = Theme.Black
            task.delay(1.4, function()
                if hubAlive and youtubeSocialBtn.Parent then
                    youtubeSocialBtn.Text = "YOUTUBE"
                    youtubeSocialBtn.BackgroundColor3 = Theme.DarkGray
                    youtubeSocialBtn.TextColor3 = Theme.White
                end
            end)
        end
    end)

    -- 3. Bottom Two Feature Cards (matching white-circled 2-card bottom row)
    local cardsRow = Instance.new("Frame")
    cardsRow.Size = UDim2.new(1, -8, 0, 84)
    cardsRow.Position = UDim2.new(0, 4, 0, 140)
    cardsRow.BackgroundTransparency = 1
    cardsRow.Parent = HomeTab

    local function createHomeFeatureCard(xScale, xOffset, titleText, descText, targetTabName)
        local cardBtn = Instance.new("TextButton")
        cardBtn.Size = UDim2.new(0.49, -2, 1, 0)
        cardBtn.Position = UDim2.new(xScale, xOffset, 0, 0)
        cardBtn.BackgroundColor3 = Theme.DarkGray
        cardBtn.Text = ""
        cardBtn.AutoButtonColor = false
        cardBtn.Parent = cardsRow
        Instance.new("UICorner", cardBtn).CornerRadius = UDim.new(0, 10)
        addWhiteBoxStroke(cardBtn, 1, 0.25)

        local cTitle = Instance.new("TextLabel")
        cTitle.Size = UDim2.new(1, -16, 0, 22)
        cTitle.Position = UDim2.new(0, 10, 0, 8)
        cTitle.BackgroundTransparency = 1
        cTitle.Text = titleText
        cTitle.TextColor3 = Theme.White
        cTitle.Font = BODY_FONT
        cTitle.TextSize = 12
        cTitle.TextXAlignment = Enum.TextXAlignment.Left
        cTitle.Parent = cardBtn

        local cDesc = Instance.new("TextLabel")
        cDesc.Size = UDim2.new(1, -16, 0, 44)
        cDesc.Position = UDim2.new(0, 10, 0, 32)
        cDesc.BackgroundTransparency = 1
        cDesc.Text = descText
        cDesc.TextColor3 = Theme.SubText
        cDesc.Font = Enum.Font.Gotham
        cDesc.TextSize = 9.5
        cDesc.TextWrapped = true
        cDesc.TextXAlignment = Enum.TextXAlignment.Left
        cDesc.TextYAlignment = Enum.TextYAlignment.Top
        cDesc.Parent = cardBtn

        cardBtn.MouseButton1Click:Connect(function()
            TweenService:Create(cardBtn, TweenInfo.new(0.1), { BackgroundColor3 = Theme.MidGray }):Play()
            task.delay(0.12, function()
                if cardBtn.Parent then
                    TweenService:Create(cardBtn, TweenInfo.new(0.15), { BackgroundColor3 = Theme.DarkGray }):Play()
                end
            end)
            SelectTab(targetTabName)
        end)
    end

    createHomeFeatureCard(
        0, 0,
        "Move & TP",
        "Saved locations, instant teleport, walk & tween navigation",
        "TP"
    )

    createHomeFeatureCard(
        0.51, 2,
        "Combat & ESP",
        "Auto aim lock, walk speed, flight, noclip & player ESP",
        "Cheats"
    )

    -- ============================================================
    -- TP TAB
    -- ============================================================
    local customTpCount = 0
    CreateButton(TeleportsTab, "Set Position", function()
        local char = LocalPlayer.Character
        local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart)
        if not hrp then return end

        customTpCount = customTpCount + 1
        local savedPos = hrp.CFrame
        local posName = string.format("TP #%d (%.0f, %.0f, %.0f)", customTpCount, savedPos.Position.X, savedPos.Position.Y, savedPos.Position.Z)

        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -2, 0, 72)
        card.BackgroundColor3 = Theme.DarkGray
        card.Parent = TeleportsTab
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
        addWhiteBoxStroke(card, 1, 0.25)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -32, 0, 24)
        label.Position = UDim2.new(0, 8, 0, 3)
        label.BackgroundTransparency = 1
        label.Text = posName
        label.TextColor3 = Theme.White
        label.Font = BODY_FONT
        label.TextSize = 9.5
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = card

        local deleteBtn = Instance.new("TextButton")
        deleteBtn.Size = UDim2.fromOffset(22, 22)
        deleteBtn.Position = UDim2.new(1, -26, 0, 4)
        deleteBtn.BackgroundColor3 = Theme.MidGray
        deleteBtn.Text = "X"
        deleteBtn.TextColor3 = Theme.White
        deleteBtn.Font = BODY_FONT
        deleteBtn.TextSize = 9.5
        deleteBtn.Parent = card
        Instance.new("UICorner", deleteBtn).CornerRadius = UDim.new(1, 0)
        addWhiteBoxStroke(deleteBtn, 1, 0.25)
        deleteBtn.MouseButton1Click:Connect(function() card:Destroy() end)

        local function makeActionPill(labelText, xScale, xOffset, cb)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(0.32, -4, 0, 30)
            b.Position = UDim2.new(xScale, xOffset, 0, 34)
            b.BackgroundColor3 = Theme.MidGray
            b.Text = labelText
            b.TextColor3 = Theme.White
            b.Font = BODY_FONT
            b.TextSize = 10
            b.Parent = card
            Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
            addWhiteBoxStroke(b, 1, 0.3)
            b.MouseButton1Click:Connect(cb)
        end

        makeActionPill("TP", 0, 4, function() SafeTeleport(savedPos) end)
        makeActionPill("Walk", 0.34, 0, function() WalkToPosition(savedPos) end)
        makeActionPill("Tween", 0.68, -4, function() TweenToPosition(savedPos) end)
    end)

    -- ============================================================
    -- PLAYER TAB
    -- ============================================================
    local selectedTarget = nil

    local selectorBtn = Instance.new("TextButton")
    selectorBtn.Size = UDim2.new(1, -2, 0, 34)
    selectorBtn.BackgroundColor3 = Theme.DarkGray
    selectorBtn.Text = "Selected Player: None (Click to choose)"
    selectorBtn.TextColor3 = Theme.White
    selectorBtn.Font = BODY_FONT
    selectorBtn.TextSize = 10
    selectorBtn.Parent = PlayersTab
    Instance.new("UICorner", selectorBtn).CornerRadius = UDim.new(1, 0)
    addWhiteBoxStroke(selectorBtn, 1, 0.25)

    local dropdownContainer = Instance.new("ScrollingFrame")
    dropdownContainer.Size = UDim2.new(1, -2, 0, 110)
    dropdownContainer.BackgroundColor3 = Theme.Black
    dropdownContainer.ScrollBarThickness = 3
    dropdownContainer.Visible = false
    dropdownContainer.Parent = PlayersTab
    Instance.new("UICorner", dropdownContainer).CornerRadius = UDim.new(0, 8)
    addWhiteBoxStroke(dropdownContainer, 1, 0.25)

    local dropLayout = Instance.new("UIListLayout")
    dropLayout.Padding = UDim.new(0, 4)
    dropLayout.Parent = dropdownContainer

    dropLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        dropdownContainer.CanvasSize = UDim2.new(0, 0, 0, dropLayout.AbsoluteContentSize.Y + 8)
    end)

    local function RefreshPlayerDropdown()
        for _, child in ipairs(dropdownContainer:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local pBtn = Instance.new("TextButton")
                pBtn.Size = UDim2.new(1, -6, 0, 28)
                pBtn.BackgroundColor3 = Theme.DarkGray
                pBtn.Text = plr.DisplayName .. " (@" .. plr.Name .. ")"
                pBtn.TextColor3 = Theme.White
                pBtn.Font = BODY_FONT
                pBtn.TextSize = 9.5
                pBtn.Parent = dropdownContainer
                Instance.new("UICorner", pBtn).CornerRadius = UDim.new(1, 0)

                pBtn.MouseButton1Click:Connect(function()
                    selectedTarget = plr
                    selectorBtn.Text = "Selected Player: " .. plr.Name
                    dropdownContainer.Visible = false
                end)
            end
        end
    end

    RefreshPlayerDropdown()
    trackConn(Players.PlayerAdded:Connect(RefreshPlayerDropdown))
    trackConn(Players.PlayerRemoving:Connect(RefreshPlayerDropdown))

    selectorBtn.MouseButton1Click:Connect(function()
        dropdownContainer.Visible = not dropdownContainer.Visible
        RefreshPlayerDropdown()
    end)

    local actionCard = Instance.new("Frame")
    actionCard.Size = UDim2.new(1, -2, 0, 40)
    actionCard.BackgroundColor3 = Theme.DarkGray
    actionCard.Parent = PlayersTab
    Instance.new("UICorner", actionCard).CornerRadius = UDim.new(1, 0)
    addWhiteBoxStroke(actionCard, 1, 0.25)

    local function makePlayerPill(labelText, xScale, xOffset, cb)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0.32, -4, 1, -8)
        b.Position = UDim2.new(xScale, xOffset, 0, 4)
        b.BackgroundColor3 = Theme.MidGray
        b.Text = labelText
        b.TextColor3 = Theme.White
        b.Font = BODY_FONT
        b.TextSize = 10
        b.Parent = actionCard
        Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
        addWhiteBoxStroke(b, 1, 0.3)
        b.MouseButton1Click:Connect(cb)
    end

    makePlayerPill("TP", 0, 4, function()
        if selectedTarget and selectedTarget.Character then
            local targetRoot = selectedTarget.Character:FindFirstChild("HumanoidRootPart") or selectedTarget.Character.PrimaryPart
            if targetRoot then SafeTeleport(targetRoot.CFrame + Vector3.new(0, 3, 0)) end
        end
    end)

    makePlayerPill("Walk", 0.34, 0, function()
        if selectedTarget and selectedTarget.Character then
            local targetRoot = selectedTarget.Character:FindFirstChild("HumanoidRootPart") or selectedTarget.Character.PrimaryPart
            if targetRoot then WalkToPosition(targetRoot.CFrame + Vector3.new(0, 3, 0)) end
        end
    end)

    makePlayerPill("Tween", 0.68, -4, function()
        if selectedTarget and selectedTarget.Character then
            local targetRoot = selectedTarget.Character:FindFirstChild("HumanoidRootPart") or selectedTarget.Character.PrimaryPart
            if targetRoot then TweenToPosition(targetRoot.CFrame + Vector3.new(0, 3, 0)) end
        end
    end)

    -- ============================================================
    -- CHEATS TAB CONTROLS
    -- ============================================================
    CreateToggle(CheatsTab, "Enable Auto Aim (Lock)", function(state) Config.AutoAim = state end)
    CreateSlider(CheatsTab, "Auto Aim Lock Range", 10, 200, Config.AutoAimRange, true, function(val) Config.AutoAimRange = val end)
    CreateToggle(CheatsTab, "Enable WalkSpeed", function(state)
        Config.SpeedEnabled = state
        if not state then restoreSpeed() end
    end)
    CreateSlider(CheatsTab, "Player Speed", 16, 300, Config.WalkSpeed, true, function(val) Config.WalkSpeed = val end)
    CreateToggle(CheatsTab, "Enable Fly", function(state)
        if state then EnableFly() else DisableFly() end
    end)
    CreateSlider(CheatsTab, "Fly Speed", 10, 300, Config.FlySpeed, true, function(val) Config.FlySpeed = val end)
    CreateToggle(CheatsTab, "Noclip", function(state) Config.Noclip = state; if not state then restoreCollisions() end end)
    CreateToggle(CheatsTab, "Fast Interact", setFastInteract)

    -- ============================================================
    -- VISUALS TAB CONTROLS (WITH OPTIONAL CUSTOM IMAGE BANNER)
    -- ============================================================
    local resolvedImg = resolveCustomBannerImage()
    if resolvedImg ~= "" then
        local customBannerBox = Instance.new("Frame")
        customBannerBox.Size = UDim2.new(1, -2, 0, 70)
        customBannerBox.BackgroundColor3 = Theme.DarkGray
        customBannerBox.ClipsDescendants = true
        customBannerBox.Parent = VisualsTab
        Instance.new("UICorner", customBannerBox).CornerRadius = UDim.new(0, 8)
        addWhiteBoxStroke(customBannerBox, 1, 0.2)

        local customImg = Instance.new("ImageLabel")
        customImg.Size = UDim2.new(1, 0, 1, 0)
        customImg.BackgroundTransparency = 1
        customImg.Image = resolvedImg
        customImg.ScaleType = Enum.ScaleType.Crop
        customImg.Parent = customBannerBox
    end

    CreateToggle(VisualsTab, "Player ESP", function(state) ToggleESPState(state) end)
    CreateToggle(VisualsTab, "Clean Vision (Fullbright & No Fog)", function(state) ToggleCleanVision(state) end)

    -- ============================================================
    -- KEY TAB
    -- ============================================================
    local bindableActions = {
        {Name = "Fly Toggle", Action = function() if Config.FlyEnabled then DisableFly() else EnableFly() end end},
        {Name = "Noclip Toggle", Action = function() Config.Noclip = not Config.Noclip; if not Config.Noclip then restoreCollisions() end end},
        {Name = "Player ESP Toggle", Action = function() ToggleESPState(not Config.PlayerESP) end},
        {Name = "Clean Vision Toggle", Action = function() ToggleCleanVision(not Config.CleanVision) end},
        {Name = "Speed Boost Toggle", Action = function() Config.SpeedEnabled = not Config.SpeedEnabled; if not Config.SpeedEnabled then restoreSpeed() end end}
    }

    for _, item in ipairs(bindableActions) do
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -2, 0, 34)
        frame.BackgroundColor3 = Theme.DarkGray
        frame.Parent = KeyTab
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
        addWhiteBoxStroke(frame, 1, 0.25)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -90, 1, 0)
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = item.Name
        lbl.TextColor3 = Theme.White
        lbl.Font = BODY_FONT
        lbl.TextSize = 10
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame

        local bindBtn = Instance.new("TextButton")
        bindBtn.Size = UDim2.fromOffset(74, 22)
        bindBtn.Position = UDim2.new(1, -80, 0.5, -11)
        bindBtn.BackgroundColor3 = Theme.MidGray
        bindBtn.Text = "[ None ]"
        bindBtn.TextColor3 = Theme.White
        bindBtn.Font = BODY_FONT
        bindBtn.TextSize = 9.5
        bindBtn.Parent = frame
        Instance.new("UICorner", bindBtn).CornerRadius = UDim.new(1, 0)
        addWhiteBoxStroke(bindBtn, 1, 0.3)

        local listening = false
        bindBtn.MouseButton1Click:Connect(function()
            listening = true
            bindBtn.Text = "[...]"
        end)

        trackConn(UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                listening = false
                Keybinds[item.Name] = input.KeyCode
                bindBtn.Text = "[" .. input.KeyCode.Name .. "]"
            elseif not gameProcessed and Keybinds[item.Name] and input.KeyCode == Keybinds[item.Name] then
                pcall(item.Action)
            end
        end))
    end

    -- ============================================================
    -- INFO TAB
    -- ============================================================
    local MAX_LOGS = 200
    local LOG_KIND = {
        OUTPUT = { color = Theme.White,   hex = "#FFFFFF", label = "OUTPUT" },
        INFO   = { color = Theme.White,   hex = "#E5E5E5", label = "INFO" },
        WARN   = { color = Theme.SubText, hex = "#C8C8D2", label = "WARN" },
        ERROR  = { color = Theme.SubText, hex = "#A5A5B2", label = "ERROR" },
    }
    local LOG_FILTERS = { "ALL", "OUTPUT", "INFO", "WARN", "ERROR" }

    local topRowContainer = Instance.new("Frame")
    topRowContainer.Size = UDim2.new(1, -2, 0, 92)
    topRowContainer.BackgroundTransparency = 1
    topRowContainer.Parent = InfoTab

    local leftTelemetryCol = Instance.new("Frame")
    leftTelemetryCol.Size = UDim2.new(0.60, -4, 1, 0)
    leftTelemetryCol.BackgroundTransparency = 1
    leftTelemetryCol.Parent = topRowContainer

    local telemetryLayout = Instance.new("UIListLayout")
    telemetryLayout.Padding = UDim.new(0, 4)
    telemetryLayout.Parent = leftTelemetryCol

    local statusHeader = Instance.new("Frame")
    statusHeader.Size = UDim2.new(1, 0, 0, 26)
    statusHeader.BackgroundColor3 = Theme.DarkGray
    statusHeader.Parent = leftTelemetryCol
    Instance.new("UICorner", statusHeader).CornerRadius = UDim.new(0, 7)
    addWhiteBoxStroke(statusHeader, 1, 0.25)

    local serverTitleLbl = Instance.new("TextLabel")
    serverTitleLbl.Size = UDim2.new(0.55, 0, 1, 0)
    serverTitleLbl.Position = UDim2.new(0, 7, 0, 0)
    serverTitleLbl.BackgroundTransparency = 1
    serverTitleLbl.Text = "SERVER"
    serverTitleLbl.TextColor3 = Theme.White
    serverTitleLbl.Font = BODY_FONT
    serverTitleLbl.TextSize = 9.5
    serverTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    serverTitleLbl.Parent = statusHeader

    local connStatusLbl = Instance.new("TextLabel")
    connStatusLbl.Size = UDim2.new(0.45, -7, 1, 0)
    connStatusLbl.Position = UDim2.new(0.55, 0, 0, 0)
    connStatusLbl.BackgroundTransparency = 1
    connStatusLbl.Text = "CONNECTED"
    connStatusLbl.TextColor3 = Theme.White
    connStatusLbl.Font = BODY_FONT
    connStatusLbl.TextSize = 8.5
    connStatusLbl.TextXAlignment = Enum.TextXAlignment.Right
    connStatusLbl.Parent = statusHeader

    local miniGrid = Instance.new("Frame")
    miniGrid.Size = UDim2.new(1, 0, 0, 62)
    miniGrid.BackgroundTransparency = 1
    miniGrid.Parent = leftTelemetryCol

    local miniLayout = Instance.new("UIGridLayout")
    miniLayout.CellSize = UDim2.new(0.48, 0, 0, 29)
    miniLayout.CellPadding = UDim2.new(0.04, 0, 0, 4)
    miniLayout.Parent = miniGrid

    local function createMiniStatChip(titleText)
        local card = Instance.new("Frame")
        card.BackgroundColor3 = Theme.DarkGray
        card.Parent = miniGrid
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 7)
        addWhiteBoxStroke(card, 1, 0.25)

        local cap = Instance.new("TextLabel")
        cap.Size = UDim2.new(1, -6, 0, 10)
        cap.Position = UDim2.new(0, 5, 0, 2)
        cap.BackgroundTransparency = 1
        cap.Text = titleText
        cap.TextColor3 = Theme.SubText
        cap.Font = BODY_FONT
        cap.TextSize = 7.5
        cap.TextXAlignment = Enum.TextXAlignment.Left
        cap.Parent = card

        local val = Instance.new("TextLabel")
        val.Size = UDim2.new(1, -6, 0, 14)
        val.Position = UDim2.new(0, 5, 0, 13)
        val.BackgroundTransparency = 1
        val.Text = "--"
        val.TextColor3 = Theme.White
        val.Font = BODY_FONT
        val.TextSize = 9.5
        val.TextXAlignment = Enum.TextXAlignment.Left
        val.TextTruncate = Enum.TextTruncate.AtEnd
        val.Parent = card

        return val
    end

    local pingValLbl   = createMiniStatChip("PING")
    local fpsValLbl    = createMiniStatChip("FPS")
    local memValLbl    = createMiniStatChip("MEMORY")
    local uptimeValLbl = createMiniStatChip("UPTIME")

    local avatarCard = Instance.new("Frame")
    avatarCard.Size = UDim2.new(0.40, -2, 1, 0)
    avatarCard.Position = UDim2.new(0.60, 2, 0, 0)
    avatarCard.BackgroundColor3 = Theme.DarkGray
    avatarCard.Parent = topRowContainer
    Instance.new("UICorner", avatarCard).CornerRadius = UDim.new(0, 7)
    addWhiteBoxStroke(avatarCard, 1, 0.2)

    local viewport = Instance.new("ViewportFrame")
    viewport.Size = UDim2.new(1, -6, 1, -18)
    viewport.Position = UDim2.new(0, 3, 0, 3)
    viewport.BackgroundTransparency = 1
    viewport.Ambient = Color3.fromRGB(200, 200, 200)
    viewport.LightColor = Theme.White
    viewport.LightDirection = Vector3.new(-1, -1, -1)
    viewport.Parent = avatarCard

    local avatarNameLbl = Instance.new("TextLabel")
    avatarNameLbl.Size = UDim2.new(1, 0, 0, 14)
    avatarNameLbl.Position = UDim2.new(0, 0, 1, -15)
    avatarNameLbl.BackgroundTransparency = 1
    avatarNameLbl.Text = string.sub(LocalPlayer.DisplayName, 1, 12)
    avatarNameLbl.TextColor3 = Theme.White
    avatarNameLbl.Font = BODY_FONT
    avatarNameLbl.TextSize = 8.5
    avatarNameLbl.TextXAlignment = Enum.TextXAlignment.Center
    avatarNameLbl.Parent = avatarCard

    local activeViewportModel = nil
    local activeViewportConn = nil

    local function Render3DCharacter(char)
        if not char or not hubAlive then return end
        pcall(function()
            if activeViewportConn then
                activeViewportConn:Disconnect()
                activeViewportConn = nil
            end
            if activeViewportModel then
                activeViewportModel:Destroy()
                activeViewportModel = nil
            end

            char:WaitForChild("HumanoidRootPart", 5)
            local prevArchivable = char.Archivable
            char.Archivable = true
            local model = char:Clone()
            char.Archivable = prevArchivable

            if not model then return end

            for _, desc in ipairs(model:GetDescendants()) do
                if desc:IsA("Script") or desc:IsA("LocalScript") or desc:IsA("Humanoid") or desc:IsA("BillboardGui") or desc:IsA("Highlight") then
                    pcall(function() desc:Destroy() end)
                elseif desc:IsA("BasePart") then
                    desc.Anchored = true
                end
            end

            local hrp = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart
            if hrp then
                model:PivotTo(CFrame.new(0, 0, 0))
                if not viewport.CurrentCamera then
                    local vpCam = Instance.new("Camera")
                    vpCam.Parent = viewport
                    viewport.CurrentCamera = vpCam
                end
                viewport.CurrentCamera.CFrame = CFrame.new(Vector3.new(0, 1.5, 4.8), Vector3.new(0, 0.5, 0))
                model.Parent = viewport
                activeViewportModel = model

                local rotAngle = 0
                activeViewportConn = trackConn(RunService.RenderStepped:Connect(function(dt)
                    if hubAlive and model.Parent then
                        rotAngle = rotAngle + (dt * 45)
                        model:PivotTo(CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(rotAngle), 0))
                    end
                end))
            end
        end)
    end

    if LocalPlayer.Character then
        task.spawn(Render3DCharacter, LocalPlayer.Character)
    end
    trackConn(LocalPlayer.CharacterAdded:Connect(function(newChar)
        task.wait(0.5)
        Render3DCharacter(newChar)
    end))

    local bottomStatsRow = Instance.new("Frame")
    bottomStatsRow.Size = UDim2.new(1, -2, 0, 26)
    bottomStatsRow.BackgroundColor3 = Theme.DarkGray
    bottomStatsRow.Parent = InfoTab
    Instance.new("UICorner", bottomStatsRow).CornerRadius = UDim.new(1, 0)
    addWhiteBoxStroke(bottomStatsRow, 1, 0.25)

    local playersValLbl = Instance.new("TextLabel")
    playersValLbl.Size = UDim2.new(0.45, 0, 1, 0)
    playersValLbl.Position = UDim2.new(0, 8, 0, 0)
    playersValLbl.BackgroundTransparency = 1
    playersValLbl.Text = "PLAYERS: --"
    playersValLbl.TextColor3 = Theme.White
    playersValLbl.Font = BODY_FONT
    playersValLbl.TextSize = 8.5
    playersValLbl.TextXAlignment = Enum.TextXAlignment.Left
    playersValLbl.Parent = bottomStatsRow

    local jobIdValLbl = Instance.new("TextLabel")
    jobIdValLbl.Size = UDim2.new(0.55, -8, 1, 0)
    jobIdValLbl.Position = UDim2.new(0.45, 0, 0, 0)
    jobIdValLbl.BackgroundTransparency = 1
    local jobId = game.JobId
    local jobShown = (jobId == "") and "STUDIO" or (string.sub(jobId, 1, 8) .. "...")
    jobIdValLbl.Text = "JOB: " .. jobShown
    jobIdValLbl.TextColor3 = Theme.SubText
    jobIdValLbl.Font = BODY_FONT
    jobIdValLbl.TextSize = 8.5
    jobIdValLbl.TextXAlignment = Enum.TextXAlignment.Right
    jobIdValLbl.Parent = bottomStatsRow

    local copyJobBtn = Instance.new("TextButton")
    copyJobBtn.Size = UDim2.new(1, 0, 1, 0)
    copyJobBtn.BackgroundTransparency = 1
    copyJobBtn.Text = ""
    copyJobBtn.Parent = bottomStatsRow
    copyJobBtn.MouseButton1Click:Connect(function()
        local copier = setclipboard or toclipboard
        if jobId ~= "" and copier then
            local ok = pcall(copier, jobId)
            jobIdValLbl.Text = ok and "COPIED!" or "FAILED"
            jobIdValLbl.TextColor3 = Theme.White
        else
            jobIdValLbl.Text = (jobId == "") and "NO ID" or "NO CLIP"
        end
        task.delay(1.2, function()
            if hubAlive then
                jobIdValLbl.Text = "JOB: " .. jobShown
                jobIdValLbl.TextColor3 = Theme.SubText
            end
        end)
    end)

    local filterBar = Instance.new("Frame")
    filterBar.Size = UDim2.new(1, -2, 0, 20)
    filterBar.BackgroundTransparency = 1
    filterBar.Parent = InfoTab

    local filterLayout = Instance.new("UIListLayout")
    filterLayout.FillDirection = Enum.FillDirection.Horizontal
    filterLayout.Padding = UDim.new(0, 3)
    filterLayout.Parent = filterBar

    local activeFilter = "ALL"
    local filterBtns = {}
    local rebuildConsole = function() end

    local function updateFilterColors()
        for _, fName in ipairs(LOG_FILTERS) do
            local isOn = (fName == activeFilter)
            filterBtns[fName].BackgroundColor3 = isOn and Theme.White or Theme.DarkGray
            filterBtns[fName].TextColor3 = isOn and Theme.Black or Theme.SubText
        end
    end

    for _, fName in ipairs(LOG_FILTERS) do
        local fBtn = Instance.new("TextButton")
        fBtn.Size = UDim2.new(0.192, 0, 1, 0)
        fBtn.BackgroundColor3 = Theme.DarkGray
        fBtn.Text = fName
        fBtn.TextColor3 = Theme.SubText
        fBtn.Font = BODY_FONT
        fBtn.TextSize = 7.5
        fBtn.Parent = filterBar
        Instance.new("UICorner", fBtn).CornerRadius = UDim.new(1, 0)
        addWhiteBoxStroke(fBtn, 1, 0.35)
        filterBtns[fName] = fBtn

        fBtn.MouseButton1Click:Connect(function()
            activeFilter = fName
            updateFilterColors()
            rebuildConsole()
        end)
    end
    updateFilterColors()

    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -2, 0, 24)
    searchBox.BackgroundColor3 = Theme.DarkGray
    searchBox.PlaceholderText = "Search logs..."
    searchBox.PlaceholderColor3 = Theme.SubText
    searchBox.Text = ""
    searchBox.TextColor3 = Theme.White
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 10
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.ClearTextOnFocus = false
    searchBox.Parent = InfoTab
    Instance.new("UICorner", searchBox).CornerRadius = UDim.new(1, 0)
    addWhiteBoxStroke(searchBox, 1, 0.25)
    Instance.new("UIPadding", searchBox).PaddingLeft = UDim.new(0, 8)

    local consoleScroll = Instance.new("ScrollingFrame")
    consoleScroll.Size = UDim2.new(1, -2, 0, 82)
    consoleScroll.BackgroundColor3 = Theme.Black
    consoleScroll.BorderSizePixel = 0
    consoleScroll.ScrollBarThickness = 3
    consoleScroll.ScrollBarImageColor3 = Theme.White
    consoleScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    consoleScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    consoleScroll.Parent = InfoTab
    Instance.new("UICorner", consoleScroll).CornerRadius = UDim.new(0, 7)
    addWhiteBoxStroke(consoleScroll, 1, 0.25)

    local consoleList = Instance.new("UIListLayout")
    consoleList.Padding = UDim.new(0, 2)
    consoleList.SortOrder = Enum.SortOrder.LayoutOrder
    consoleList.Parent = consoleScroll

    local consolePad = Instance.new("UIPadding")
    consolePad.PaddingTop = UDim.new(0, 3)
    consolePad.PaddingBottom = UDim.new(0, 3)
    consolePad.PaddingLeft = UDim.new(0, 5)
    consolePad.PaddingRight = UDim.new(0, 5)
    consolePad.Parent = consoleScroll

    local consoleControls = Instance.new("Frame")
    consoleControls.Size = UDim2.new(1, -2, 0, 22)
    consoleControls.BackgroundTransparency = 1
    consoleControls.Parent = InfoTab

    local clearConsoleBtn = Instance.new("TextButton")
    clearConsoleBtn.Size = UDim2.new(0.36, 0, 1, 0)
    clearConsoleBtn.Position = UDim2.new(0, 0, 0, 0)
    clearConsoleBtn.BackgroundColor3 = Theme.DarkGray
    clearConsoleBtn.Text = "CLEAR"
    clearConsoleBtn.TextColor3 = Theme.White
    clearConsoleBtn.Font = BODY_FONT
    clearConsoleBtn.TextSize = 8.5
    clearConsoleBtn.Parent = consoleControls
    Instance.new("UICorner", clearConsoleBtn).CornerRadius = UDim.new(1, 0)
    addWhiteBoxStroke(clearConsoleBtn, 1, 0.25)

    local autoScrollEnabled = true
    local autoScrollBtn = Instance.new("TextButton")
    autoScrollBtn.Size = UDim2.new(0.42, 0, 1, 0)
    autoScrollBtn.Position = UDim2.new(0.38, 0, 0, 0)
    autoScrollBtn.BackgroundColor3 = Theme.White
    autoScrollBtn.Text = "AUTO: ON"
    autoScrollBtn.TextColor3 = Theme.Black
    autoScrollBtn.Font = BODY_FONT
    autoScrollBtn.TextSize = 8.5
    autoScrollBtn.Parent = consoleControls
    Instance.new("UICorner", autoScrollBtn).CornerRadius = UDim.new(1, 0)

    local logCountLbl = Instance.new("TextLabel")
    logCountLbl.Size = UDim2.new(0.18, 0, 1, 0)
    logCountLbl.Position = UDim2.new(0.82, 0, 0, 0)
    logCountLbl.BackgroundTransparency = 1
    logCountLbl.Text = "0/" .. MAX_LOGS
    logCountLbl.TextColor3 = Theme.SubText
    logCountLbl.Font = BODY_FONT
    logCountLbl.TextSize = 8.5
    logCountLbl.TextXAlignment = Enum.TextXAlignment.Right
    logCountLbl.Parent = consoleControls

    local logEntries = {}
    local pendingLogs = {}
    local pendingHead = 1
    local logCounter = 0
    local searchQuery = ""
    local scrollQueued = 0

    local function escapeRichText(str)
        str = string.gsub(str, "&", "&amp;")
        str = string.gsub(str, "<", "&lt;")
        str = string.gsub(str, ">", "&gt;")
        return str
    end

    local function createLogRow(entry)
        local info = LOG_KIND[entry.kind]
        local row = Instance.new("TextLabel")
        row.LayoutOrder = entry.id
        row.Size = UDim2.new(1, 0, 0, 0)
        row.AutomaticSize = Enum.AutomaticSize.Y
        row.BackgroundColor3 = Theme.DarkGray
        row.BackgroundTransparency = (entry.id % 2 == 0) and 0.85 or 1
        row.BorderSizePixel = 0
        row.RichText = true
        row.TextWrapped = true
        row.Font = Enum.Font.Code
        row.TextSize = 9.5
        row.TextColor3 = info.color
        row.TextXAlignment = Enum.TextXAlignment.Left
        row.TextYAlignment = Enum.TextYAlignment.Top
        row.Text = string.format(
            '<font color="#8A8A98">[%s]</font> <font color="%s"><b>[%s]</b></font> %s',
            entry.time, info.hex, info.label, escapeRichText(entry.text)
        )
        row.Parent = consoleScroll
        entry.row = row
    end

    local function pushConsoleLog(msg, kind, ts)
        if not hubAlive then return end
        kind = LOG_KIND[kind] and kind or "OUTPUT"
        logCounter = logCounter + 1
        local cleanText = string.sub(tostring(msg), 1, 500)
        local entry = {
            id = logCounter,
            kind = kind,
            text = cleanText,
            lower = string.lower(cleanText),
            time = os.date("%H:%M:%S", ts),
        }
        table.insert(logEntries, entry)

        while #logEntries > MAX_LOGS do
            local old = table.remove(logEntries, 1)
            old.removed = true
            if old.row then
                old.row:Destroy()
                old.row = nil
            end
        end

        local matchesFilter = (activeFilter == "ALL" or activeFilter == kind)
        local matchesSearch = (searchQuery == "" or string.find(entry.lower, searchQuery, 1, true) ~= nil)
        if matchesFilter and matchesSearch then
            table.insert(pendingLogs, entry)
        end
    end

    rebuildConsole = function()
        for _, entry in ipairs(logEntries) do
            if entry.row then
                entry.row:Destroy()
                entry.row = nil
            end
        end
        pendingLogs = {}
        pendingHead = 1
        for _, entry in ipairs(logEntries) do
            local matchesFilter = (activeFilter == "ALL" or activeFilter == entry.kind)
            local matchesSearch = (searchQuery == "" or string.find(entry.lower, searchQuery, 1, true) ~= nil)
            if matchesFilter and matchesSearch then
                table.insert(pendingLogs, entry)
            end
        end
        if autoScrollEnabled then scrollQueued = 2 end
    end

    local searchToken = 0
    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        searchQuery = string.lower(searchBox.Text)
        searchToken = searchToken + 1
        local currentToken = searchToken
        task.delay(0.15, function()
            if hubAlive and currentToken == searchToken then
                rebuildConsole()
            end
        end)
    end)

    clearConsoleBtn.MouseButton1Click:Connect(function()
        for _, entry in ipairs(logEntries) do
            entry.removed = true
            if entry.row then entry.row:Destroy() end
        end
        logEntries = {}
        pendingLogs = {}
        pendingHead = 1
        pushConsoleLog("Console cleared.", "INFO")
    end)

    autoScrollBtn.MouseButton1Click:Connect(function()
        autoScrollEnabled = not autoScrollEnabled
        autoScrollBtn.Text = autoScrollEnabled and "AUTO: ON" or "AUTO: OFF"
        autoScrollBtn.BackgroundColor3 = autoScrollEnabled and Theme.White or Theme.DarkGray
        autoScrollBtn.TextColor3 = autoScrollEnabled and Theme.Black or Theme.SubText
        if autoScrollEnabled then scrollQueued = 2 end
    end)

    local function mapMsgType(msgType)
        if msgType == Enum.MessageType.MessageWarning then return "WARN"
        elseif msgType == Enum.MessageType.MessageError then return "ERROR"
        elseif msgType == Enum.MessageType.MessageInfo then return "INFO"
        end
        return "OUTPUT"
    end

    pcall(function()
        local history = LogService:GetLogHistory()
        local startIdx = math.max(1, #history - 80 + 1)
        for i = startIdx, #history do
            local item = history[i]
            pushConsoleLog(item.message, mapMsgType(item.messageType), item.timestamp)
        end
    end)

    pcall(function()
        trackConn(LogService.MessageOut:Connect(function(msg, msgType)
            pushConsoleLog(msg, mapMsgType(msgType))
        end))
    end)

    local frameCounter = 0
    local lastStatsClock = os.clock()
    local isDisconnected = false

    pcall(function()
        local netClient = game:GetService("NetworkClient")
        trackConn(netClient.ChildRemoved:Connect(function()
            isDisconnected = true
            pushConsoleLog("Disconnected from server.", "ERROR")
        end))
    end)

    local function fetchPing()
        local ok, val = pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
        if ok and type(val) == "number" then return math.floor(val + 0.5) end
        local okP, ms = pcall(function() return LocalPlayer:GetNetworkPing() * 1000 end)
        if okP and type(ms) == "number" then return math.floor(ms + 0.5) end
        return nil
    end

    local function fmtTime(sec)
        sec = math.floor(sec)
        return string.format("%d:%02d:%02d", math.floor(sec / 3600), math.floor(sec / 60) % 60, sec % 60)
    end

    task.spawn(function()
        while hubAlive and ScreenGui.Parent do
            local now = os.clock()
            local dt = now - lastStatsClock
            if dt > 0 then
                local fps = frameCounter / dt
                frameCounter = 0
                lastStatsClock = now

                local ping = fetchPing()
                local okMem, mem = pcall(function() return Stats:GetTotalMemoryUsageMb() end)
                local okPlr, pList = pcall(function() return #Players:GetPlayers() end)

                pingValLbl.Text = ping and (ping .. " ms") or "N/A"
                local rFps = math.floor(fps + 0.5)
                fpsValLbl.Text = tostring(rFps)
                memValLbl.Text = (okMem and type(mem) == "number") and string.format("%.0f MB", mem) or "N/A"
                playersValLbl.Text = string.format("PLAYERS: %s/%d", okPlr and tostring(pList) or "?", Players.MaxPlayers)
                uptimeValLbl.Text = fmtTime(workspace.DistributedGameTime)

                if isDisconnected or not LocalPlayer:IsDescendantOf(game) then
                    connStatusLbl.Text = "DISCONNECTED"
                    connStatusLbl.TextColor3 = Theme.SubText
                elseif (ping and ping >= 400) or rFps < 8 then
                    connStatusLbl.Text = "UNSTABLE"
                    connStatusLbl.TextColor3 = Theme.SubText
                elseif ping and ping >= 200 then
                    connStatusLbl.Text = "SLOW LINK"
                    connStatusLbl.TextColor3 = Theme.SubText
                else
                    connStatusLbl.Text = "CONNECTED"
                    connStatusLbl.TextColor3 = Theme.White
                end
            end
            task.wait(0.5)
        end
    end)

    trackConn(RunService.RenderStepped:Connect(function()
        frameCounter = frameCounter + 1

        pcall(function()
            if Config.AutoAim then
                local target = GetNearestEnemyTarget(Config.AutoAimRange)
                local cam = Workspace.CurrentCamera
                if target and cam then cam.CFrame = CFrame.lookAt(cam.CFrame.Position, target.Position) end
            end
        end)

        local avail = #pendingLogs - pendingHead + 1
        if avail > 0 then
            local created = 0
            while pendingHead <= #pendingLogs and created < 30 do
                local entry = pendingLogs[pendingHead]
                pendingLogs[pendingHead] = false
                pendingHead = pendingHead + 1
                if entry and not entry.removed and not entry.row then
                    createLogRow(entry)
                    created = created + 1
                end
            end
            if pendingHead > #pendingLogs then
                pendingLogs = {}
                pendingHead = 1
            end
            if autoScrollEnabled then scrollQueued = 2 end
        end

        if scrollQueued > 0 then
            scrollQueued = scrollQueued - 1
            if scrollQueued == 0 then
                consoleScroll.CanvasPosition = Vector2.new(0, 1000000)
            end
        end

        local countStr = #logEntries .. "/" .. MAX_LOGS
        if logCountLbl.Text ~= countStr then logCountLbl.Text = countStr end
    end))

    pushConsoleLog("Brineland Hub initialized.", "INFO")
    rebuildConsole()
end

-- ============================================================
-- GAME ROUTER EXECUTION (EXTERNAL FILES + BUILT-IN UNIVERSAL)
-- ============================================================
local MarketplaceService = game:GetService("MarketplaceService")
local PlaceId = game.PlaceId
local GameId = game.GameId
local REPO_BASE = "https://raw.githubusercontent.com/DCBHEROBRINE/BRINELAND-HUB/main/"

local function LoadExternalScript(fileName)
    local ok, res = pcall(function()
        return game:HttpGet(REPO_BASE .. fileName)
    end)
    if ok and type(res) == "string" and res ~= "" and not res:match("^404:") and not res:find("<!DOCTYPE html>", 1, true) then
        if fileName == "stealanegg.lua" and res:find("PARTIALLY DEOBFUSCATED CHILLI HUB", 1, true) then warn("[BRINELAND] Egg file is an inspection-only fragment, not runnable."); return false end
        if type(loadstring) ~= "function" then warn("[BRINELAND] This executor has no loadstring."); return false end
        local fn, err = loadstring(res)
        if fn then
            local ran, runtimeError = pcall(fn)
            if not ran then warn("[BRINELAND] Runtime error in " .. fileName .. ": " .. tostring(runtimeError)); return false end
            return true
        else
            warn("[BRINELAND] Compile error in " .. fileName .. ": " .. tostring(err))
        end
    else
        warn("[BRINELAND] Could not load " .. fileName .. " from repository.")
    end
    return false
end

local success, info = pcall(function()
    return MarketplaceService:GetProductInfo(PlaceId)
end)
local gameName = (success and info and info.Name) or ""
local nameLower = gameName:lower()

if nameLower:find("taxi boss") or PlaceId == 7305826609 then
    print("[BRINELAND] Detected Taxi Boss. Loading taxiboss.lua...")
    if not LoadExternalScript("taxiboss.lua") then warn("[BRINELAND] Opening universal hub instead."); RunUniversalScript() end
elseif nameLower:find("steal an egg") or nameLower:find("stealanegg") or PlaceId == 107778070777162 or PlaceId == 115049386348611 or GameId == 10563114921 then
    print("[BRINELAND] Detected Steal An Egg. Loading stealanegg.lua...")
    if not LoadExternalScript("stealanegg.lua") then warn("[BRINELAND] Opening universal hub instead."); RunUniversalScript() end
elseif nameLower:find("throw food for animals") or PlaceId == 120219252362013 or GameId == 10766972131 then
    print("[BRINELAND] Detected Throw Food for Animals. Loading throwfood.lua...")
    if not LoadExternalScript("throwfood.lua") then warn("[BRINELAND] Opening universal hub instead."); RunUniversalScript() end
elseif nameLower:find("speed keyboard escape") or nameLower:find("+1 speed") then
    print("[BRINELAND] Detected +1 Speed Keyboard Escape. Loading SpeedKeyboardEscape.lua...")
    if not LoadExternalScript("SpeedKeyboardEscape.lua") then warn("[BRINELAND] Opening universal hub instead."); RunUniversalScript() end
elseif nameLower:find("bake or die") or nameLower:find("bakeordie") or PlaceId == 86479448397834 or GameId == 7488668004 then
    print("[BRINELAND] Detected Bake or Die. Loading bakeordie.lua...")
    if not LoadExternalScript("bakeordie.lua") then warn("[BRINELAND] Opening universal hub instead."); RunUniversalScript() end
else
    print("[BRINELAND] Unrecognized game: " .. gameName .. " (PlaceId: " .. tostring(PlaceId) .. "). Running Universal Hub...")
    RunUniversalScript()
end
