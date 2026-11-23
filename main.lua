-- ============================================================
-- BRINELAND MASTER MULTI-GAME HUB + PLATOBOOST KEY SYSTEM
-- Repository: https://github.com/DCBHEROBRINE/BRINELAND-HUB.git
-- Discord: https://discord.gg/epWMbuXSN5
-- YouTube: https://youtube.com/@dcb_herobrine?si=PN8mSo36sJFaySFQ
-- ============================================================

-------------------------------------------------------------------------------
--! json library
--! cryptography library
local a=2^32;local b=a-1;local function c(d,e)local f,g=0,1;while d~=0 or e~=0 do local h,i=d%2,e%2;local j=(h+i)%2;f=f+j*g;d=math.floor(d/2)e=math.floor(e/2)g=g*2 end;return f%a end;local function k(d,e,l,...)local m;if e then d=d%a;e=e%a;m=c(d,e)if l then m=k(m,l,...)end;return m elseif d then return d%a else return 0 end end;local function n(d,e,l,...)local m;if e then d=d%a;e=e%a;m=(d+e-c(d,e))/2;if l then m=n(m,l,...)end;return m elseif d then return d%a else return b end end;local function o(p)return b-p end;local lshift;local function q(d,r)if r<0 then return lshift(d,-r)end;return math.floor(d%2^32/2^r)end;local function s(p,r)if r>31 or r<-31 then return 0 end;return q(p%a,r)end;lshift=function(d,r)if r<0 then return s(d,-r)end;return d*2^r%2^32 end;local function t(p,r)p=p%a;r=r%32;local u=n(p,2^r-1)return s(p,r)+lshift(u,32-r)end;local v={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}local function w(x)return string.gsub(x,".",function(l)return string.format("%02x",string.byte(l))end)end;local function y(z,A)local x=""for B=1,A do local C=z%256;x=string.char(C)..x;z=(z-C)/256 end;return x end;local function D(x,B)local A=0;for B=B,B+3 do A=A*256+string.byte(x,B)end;return A end;local function E(F,G)local H=64-(G+9)%64;G=y(8*G,8)F=F.."\128"..string.rep("\0",H)..G;assert(#F%64==0)return F end;local function I(J)J[1]=0x6a09e667;J[2]=0xbb67ae85;J[3]=0x3c6ef372;J[4]=0xa54ff53a;J[5]=0x510e527f;J[6]=0x9b05688c;J[7]=0x1f83d9ab;J[8]=0x5be0cd19;return J end;local function K(F,B,J)local L={}for M=1,16 do L[M]=D(F,B+(M-1)*4)end;for M=17,64 do local N=L[M-15]local O=k(t(N,7),t(N,18),s(N,3))N=L[M-2]L[M]=(L[M-16]+O+L[M-7]+k(t(N,17),t(N,19),s(N,10)))%a end;local d,e,l,P,Q,R,S,T=J[1],J[2],J[3],J[4],J[5],J[6],J[7],J[8]for B=1,64 do local O=k(t(d,2),t(d,13),t(d,22))local U=k(n(d,e),n(d,l),n(e,l))local V=(O+U)%a;local W=k(t(Q,6),t(Q,11),t(Q,25))local X=k(n(Q,R),n(o(Q),S))local Y=(T+W+X+v[B]+L[B])%a;T=S;S=R;R=Q;Q=(P+Y)%a;P=l;l=e;e=d;d=(Y+V)%a end;J[1]=(J[1]+d)%a;J[2]=(J[2]+e)%a;J[3]=(J[3]+l)%a;J[4]=(J[4]+P)%a;J[5]=(J[5]+Q)%a;J[6]=(J[6]+R)%a;J[7]=(J[7]+S)%a;J[8]=(J[8]+T)%a end;local function Z(F)F=E(F,#F)local J=I({})for B=1,#F,64 do K(F,B,J)end;return w(y(J[1],4)..y(J[2],4)..y(J[3],4)..y(J[4],4)..y(J[5],4)..y(J[6],4)..y(J[7],4)..y(J[8],4))end;local e;local l={["\\"]="\\",["\""]="\"",["\b"]="b",["\f"]="f",["\n"]="n",["\r"]="r",["\t"]="t"}local P={["/"]="/"}for Q,R in pairs(l)do P[R]=Q end;local S=function(T)return"\\"..(l[T]or string.format("u%04x",T:byte()))end;local B=function(M)return"null"end;local v=function(M,z)local _={}z=z or{}if z[M]then error("circular reference")end;z[M]=true;if rawget(M,1)~=nil or next(M)==nil then local A=0;for Q in pairs(M)do if type(Q)~="number"then error("invalid table: mixed or invalid key types")end;A=A+1 end;if A~=#M then error("invalid table: sparse array")end;for a0,R in ipairs(M)do table.insert(_,e(R,z))end;z[M]=nil;return"["..table.concat(_,",").."]"else for Q,R in pairs(M)do if type(Q)~="string"then error("invalid table: mixed or invalid key types")end;table.insert(_,e(Q,z)..":"..e(R,z))end;z[M]=nil;return"{"..table.concat(_,",").."}"end end;local g=function(M)return'"'..M:gsub('[%z\1-\31\\"]',S)..'"'end;local a1=function(M)if M~=M or M<=-math.huge or M>=math.huge then error("unexpected number value '"..tostring(M).."'")end;return string.format("%.14g",M)end;local j={["nil"]=B,["table"]=v,["string"]=g,["number"]=a1,["boolean"]=tostring}e=function(M,z)local x=type(M)local a2=j[x]if a2 then return a2(M,z)end;error("unexpected type '"..x.."'")end;local a3=function(M)return e(M)end;local a4;local N=function(...)local _={}for a0=1,select("#",...)do _[select(a0,...)]=true end;return _ end;local L=N(" ","\t","\r","\n")local p=N(" ","\t","\r","\n","]","}",",")local a5=N("\\","/",'"',"b","f","n","r","t","u")local m=N("true","false","null")local a6={["true"]=true,["false"]=false,["null"]=nil}local a7=function(a8,a9,aa,ab)for a0=a9,#a8 do if aa[a8:sub(a0,a0)]~=ab then return a0 end end;return#a8+1 end;local ac=function(a8,a9,J)local ad=1;local ae=1;for a0=1,a9-1 do ae=ae+1;if a8:sub(a0,a0)=="\n"then ad=ad+1;ae=1 end end;error(string.format("%s at line %d col %d",J,ad,ae))end;local af=function(A)local a2=math.floor;if A<=0x7f then return string.char(A)elseif A<=0x7ff then return string.char(a2(A/64)+192,A%64+128)elseif A<=0xffff then return string.char(a2(A/4096)+224,a2(A%4096/64)+128,A%64+128,A%64+128)elseif A<=0x10ffff then return string.char(a2(A/262144)+240,a2(A%262144/4096)+128,a2(A%4096/64)+128,A%64+128)end;error(string.format("invalid unicode codepoint '%x'",A))end;local ag=function(ah)local ai=tonumber(ah:sub(1,4),16)local aj=tonumber(ah:sub(7,10),16)if aj then return af((ai-0xd800)*0x400+aj-0xdc00+0x10000)else return af(ai)end end;local ak=function(a8,a0)local _=""local al=a0+1;local Q=al;while al<=#a8 do local am=a8:byte(al)if am<32 then ac(a8,al,"control character in string")elseif am==92 then _=_..a8:sub(Q,al-1)al=al+1;local T=a8:sub(al,al)if T=="u"then local an=a8:match("^[dD][89aAbB]%x%x\\u%x%x%x%x",al+1)or a8:match("^%x%x%x%x",al+1)or ac(a8,al-1,"invalid unicode escape in string")_=_..ag(an)al=al+#an else if not a5[T]then ac(a8,al-1,"invalid escape char '"..T.."' in string")end;_=_..P[T]end;Q=al+1 elseif am==34 then _=_..a8:sub(Q,al-1)return _,al+1 end;al=al+1 end;ac(a8,a0,"expected closing quote for string")end;local ao=function(a8,a0)local am=a7(a8,a0,p)local ah=a8:sub(a0,am-1)local A=tonumber(ah)if not A then ac(a8,a0,"invalid number '"..ah.."'")end;return A,am end;local ap=function(a8,a0)local am=a7(a8,a0,p)local aq=a8:sub(a0,am-1)if not m[aq]then ac(a8,a0,"invalid literal '"..aq.."'")end;return a6[aq],am end;local ar=function(a8,a0)local _={}local A=1;a0=a0+1;while 1 do local am;a0=a7(a8,a0,L,true)if a8:sub(a0,a0)=="]" then a0=a0+1;break end;am,a0=a4(a8,a0)_[A]=am;A=A+1;a0=a7(a8,a0,L,true)local as=a8:sub(a0,a0)a0=a0+1;if as=="]" then break end;if as~="," then ac(a8,a0,"expected ']' or ','")end end;return _,a0 end;local at=function(a8,a0)local _={}a0=a0+1;while 1 do local au,M;a0=a7(a8,a0,L,true)if a8:sub(a0,a0)=="}" then a0=a0+1;break end;if a8:sub(a0,a0)~='"'then ac(a8,a0,"expected string for key")end;au,a0=a4(a8,a0)a0=a7(a8,a0,L,true)if a8:sub(a0,a0)~=":" then ac(a8,a0,"expected ':' after key")end;a0=a7(a8,a0+1,L,true)M,a0=a4(a8,a0)_[au]=M;a0=a7(a8,a0,L,true)local as=a8:sub(a0,a0)a0=a0+1;if as=="}" then break end;if as~="," then ac(a8,a0,"expected '}' or ','")end end;return _,a0 end;local av={['"']=ak,["0"]=ao,["1"]=ao,["2"]=ao,["3"]=ao,["4"]=ao,["5"]=ao,["6"]=ao,["7"]=ao,["8"]=ao,["9"]=ao,["-"]=ao,["t"]=ap,["f"]=ap,["n"]=ap,["["]=ar,["{"]=at}a4=function(a8,a9)local as=a8:sub(a9,a9)local a2=av[as]if a2 then return a2(a8,a9)end;ac(a8,a9,"unexpected character '"..as.."'")end;local aw=function(a8)if type(a8)~="string"then error("expected argument of type string, got "..type(a8))end;local _,a9=a4(a8,a7(a8,1,L,true))a9=a7(a8,a9,L,true)if a9<=#a8 then ac(a8,a9,"trailing garbage")end;return _ end;
local lEncode, lDecode, lDigest = a3, aw, Z;
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--! PLATOBOOST & SOCIAL CONFIGURATION
local DISCORD_INVITE = "https://discord.gg/epWMbuXSN5"
local YOUTUBE_URL    = "https://youtube.com/@dcb_herobrine?si=PN8mSo36sJFaySFQ"
local service = 34545;
local secret = "8ad7b367-0fc1-442d-9c99-02298ea45d0c";
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
    if ok and res then
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

function cacheLink()
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
            if successDecode and decoded and decoded.success == true then
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

pcall(cacheLink);

local generateNonce = function()
    local str = ""
    for _ = 1, 16 do
        str = str .. fStringChar(fMathFloor(fMathRandom() * (122 - 97 + 1)) + 97)
    end
    return str
end

local copyLink = function()
    local success, link = cacheLink();
    if success and fSetClipboard then
        fSetClipboard(link);
    end
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
        if successDecode and decoded and decoded.success == true and decoded.data.valid == true then
            return true;
        end
    end
    return false;
end

local verifyKey = function(key)
    if requestSending == true then return false else requestSending = true; end
    local nonce = generateNonce();
    local endpoint = host .. "/public/whitelist/" .. fToString(service) .. "?identifier=" .. lDigest(tostring(fGetHwid())) .. "&key=" .. key;
    if useNonce then endpoint = endpoint .. "&nonce=" .. nonce; end

    local response = safeRequest({ Url = endpoint, Method = "GET" });
    requestSending = false;

    if response.StatusCode == 200 then
        local successDecode, decoded = pcall(function() return lDecode(response.Body) end)
        if successDecode and decoded and decoded.success == true then
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
    local dragging = false
    local dragStart = Vector2.zero
    local startPos = guiObject.Position

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
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
            if savedKey ~= "" and verifyKey(savedKey) then
                return true
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
            copyLink()
            StatusLabel.Text = "PlatoBoost link copied to clipboard!"
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

        local isValid = verifyKey(enteredKey)

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
            StatusLabel.Text = "Invalid key. Please try again."
            StatusLabel.TextColor3 = Theme.SubText
        end
    end)

    repeat task.wait(0.2) until isVerified
    return true
end

VerifyAndLoadHub()

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
    if PlayerGui:FindFirstChild("BrinelandClassicHub") then
        PlayerGui.BrinelandClassicHub:Destroy()
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
        return vector
    end

    local function EnableFly()
        local char = LocalPlayer.Character
        if not char then return end
        local rootPart = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not rootPart or not humanoid then return end

        Config.FlyEnabled = true
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)

        if moveConnections.FlightLoop then
            moveConnections.FlightLoop:Disconnect()
        end

        moveConnections.FlightLoop = RunService.Heartbeat:Connect(function(deltaTime)
            if not Config.FlyEnabled or not rootPart or not char:IsDescendantOf(Workspace) then return end
            rootPart.Velocity = Vector3.new(0, 0.1, 0)

            local flightVector = GetFlightVector()
            if flightVector.Magnitude > 0 then
                local camCFrame = Camera.CFrame
                local worldDirection = camCFrame:VectorToWorldSpace(flightVector)
                if flightVector.Z ~= 0 then
                    worldDirection = camCFrame.LookVector * -flightVector.Z
                end
                if flightVector.X ~= 0 then
                    worldDirection = worldDirection + (camCFrame.RightVector * flightVector.X)
                end
                if flightVector.Y ~= 0 then
                    worldDirection = worldDirection + Vector3.new(0, flightVector.Y, 0)
                end
                rootPart.CFrame = rootPart.CFrame + (worldDirection.Unit * Config.FlySpeed * deltaTime)
            end
        end)
    end

    local function DisableFly()
        Config.FlyEnabled = false
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
                if hum then hum.WalkSpeed = Config.WalkSpeed end
            end
            if Config.Noclip then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
                end
            end
            if Config.FastInteract then
                for _, prompt in ipairs(Workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then prompt.HoldDuration = 0 end
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
            if not hrp or not hum then return end

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
        player.CharacterAdded:Connect(CharacterAdded)
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
                    if desc:IsA("Atmosphere") or desc:IsA("PostEffect") or desc:IsA("Sky") then
                        effectStates[desc] = desc.Enabled
                        desc.Enabled = false
                    end
                end
            else
                Lighting.Brightness = originalLighting.Brightness
                Lighting.ClockTime = originalLighting.ClockTime
                Lighting.GlobalShadows = originalLighting.GlobalShadows
                Lighting.FogEnd = originalLighting.FogEnd
                for _, desc in ipairs(Lighting:GetDescendants()) do
                    if (desc:IsA("Atmosphere") or desc:IsA("PostEffect") or desc:IsA("Sky")) and effectStates[desc] ~= nil then
                        desc.Enabled = effectStates[desc]
                    end
                end
            end
        end)
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BrinelandClassicHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

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
        for _, c in ipairs(hubConns) do pcall(function() c:Disconnect() end) end
        DisableFly()
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
        if not state and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
    end)
    CreateSlider(CheatsTab, "Player Speed", 16, 300, Config.WalkSpeed, true, function(val) Config.WalkSpeed = val end)
    CreateToggle(CheatsTab, "Enable Fly", function(state)
        if state then EnableFly() else DisableFly() end
    end)
    CreateSlider(CheatsTab, "Fly Speed", 10, 300, Config.FlySpeed, true, function(val) Config.FlySpeed = val end)
    CreateToggle(CheatsTab, "Noclip", function(state) Config.Noclip = state end)
    CreateToggle(CheatsTab, "Fast Interact", function(state) Config.FastInteract = state end)

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
        {Name = "Noclip Toggle", Action = function() Config.Noclip = not Config.Noclip end},
        {Name = "Player ESP Toggle", Action = function() ToggleESPState(not Config.PlayerESP) end},
        {Name = "Clean Vision Toggle", Action = function() ToggleCleanVision(not Config.CleanVision) end},
        {Name = "Speed Boost Toggle", Action = function() Config.SpeedEnabled = not Config.SpeedEnabled end}
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
                playersValLbl.Text = string.format("PLAYERS: %d/%d", okPlr and pList or "?", Players.MaxPlayers)
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
-- MERGED UNIVERSAL V2 (the original hub remains available in Misc)
-- ============================================================
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
        UISection(MiscT, "Classic")
        UILabel(MiscT, "Classic hub has separate controls. Avoid enabling the same feature in both hubs.")
        UIButton(MiscT, "Open Original Classic Hub", function() RunUniversalScript() end)
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
        if fileName == "stealanegg.lua" and res:find("PARTIALLY DEOBFUSCATED CHILLI HUB", 1, true) then
            warn("[BRINELAND] stealanegg.lua is an inspection-only fragment, not a working script. Replace it with a working module.")
            return false
        end
        local fn, err = loadstring(res)
        if fn then
            local ran, runtimeError = pcall(fn)
            if not ran then
                warn("[BRINELAND] Runtime error in " .. fileName .. ": " .. tostring(runtimeError))
                return false
            end
            return true
        else
            warn("[BRINELAND] Compile error in " .. fileName .. ": " .. tostring(err))
        end
    else
        warn("[BRINELAND] Could not load " .. fileName .. " from repository.")
    end
    return false
end

local universalOK, universalError = pcall(BrinelandUniversal)
if not universalOK then warn("[BRINELAND] Universal hub error: " .. tostring(universalError)) end

local success, info = pcall(function()
    return MarketplaceService:GetProductInfo(PlaceId)
end)
local gameName = (success and info and info.Name) or ""
local nameLower = gameName:lower()

if nameLower:find("taxi boss") or PlaceId == 7305826609 then
    print("[BRINELAND] Detected Taxi Boss. Loading taxiboss.lua...")
    LoadExternalScript("taxiboss.lua")
elseif nameLower:find("steal an egg") or nameLower:find("stealanegg") or PlaceId == 107778070777162 or PlaceId == 115049386348611 or GameId == 10563114921 then
    print("[BRINELAND] Detected Steal An Egg. Loading stealanegg.lua...")
    LoadExternalScript("stealanegg.lua")
elseif nameLower:find("throw food for animals") or PlaceId == 120219252362013 or GameId == 10766972131 then
    print("[BRINELAND] Detected Throw Food for Animals. Loading throwfood.lua...")
    LoadExternalScript("throwfood.lua")
elseif nameLower:find("speed keyboard escape") or nameLower:find("+1 speed") then
    print("[BRINELAND] Detected +1 Speed Keyboard Escape. Loading SpeedKeyboardEscape.lua...")
    LoadExternalScript("SpeedKeyboardEscape.lua")
elseif nameLower:find("bake or die") or nameLower:find("bakeordie") or PlaceId == 86479448397834 or GameId == 7488668004 then
    print("[BRINELAND] Detected Bake or Die. Loading bakeordie.lua...")
    LoadExternalScript("bakeordie.lua")
else
    print("[BRINELAND] Unrecognized game: " .. gameName .. " (PlaceId: " .. tostring(PlaceId) .. "). Universal Hub is available.")
end
