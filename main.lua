-- ============================================================
-- BRINELAND MASTER MULTI-GAME HUB + PLATOBOOST KEY SYSTEM
-- Repository: https://github.com/DCBHEROBRINE/BRINELAND-HUB.git
-- Discord: https://discord.gg/epWMbuXSN5
-- ============================================================

-------------------------------------------------------------------------------
--! json library
--! cryptography library
local a=2^32;local b=a-1;local function c(d,e)local f,g=0,1;while d~=0 or e~=0 do local h,i=d%2,e%2;local j=(h+i)%2;f=f+j*g;d=math.floor(d/2)e=math.floor(e/2)g=g*2 end;return f%a end;local function k(d,e,l,...)local m;if e then d=d%a;e=e%a;m=c(d,e)if l then m=k(m,l,...)end;return m elseif d then return d%a else return 0 end end;local function n(d,e,l,...)local m;if e then d=d%a;e=e%a;m=(d+e-c(d,e))/2;if l then m=n(m,l,...)end;return m elseif d then return d%a else return b end end;local function o(p)return b-p end;local lshift;local function q(d,r)if r<0 then return lshift(d,-r)end;return math.floor(d%2^32/2^r)end;local function s(p,r)if r>31 or r<-31 then return 0 end;return q(p%a,r)end;lshift=function(d,r)if r<0 then return s(d,-r)end;return d*2^r%2^32 end;local function t(p,r)p=p%a;r=r%32;local u=n(p,2^r-1)return s(p,r)+lshift(u,32-r)end;local v={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}local function w(x)return string.gsub(x,".",function(l)return string.format("%02x",string.byte(l))end)end;local function y(z,A)local x=""for B=1,A do local C=z%256;x=string.char(C)..x;z=(z-C)/256 end;return x end;local function D(x,B)local A=0;for B=B,B+3 do A=A*256+string.byte(x,B)end;return A end;local function E(F,G)local H=64-(G+9)%64;G=y(8*G,8)F=F.."\128"..string.rep("\0",H)..G;assert(#F%64==0)return F end;local function I(J)J[1]=0x6a09e667;J[2]=0xbb67ae85;J[3]=0x3c6ef372;J[4]=0xa54ff53a;J[5]=0x510e527f;J[6]=0x9b05688c;J[7]=0x1f83d9ab;J[8]=0x5be0cd19;return J end;local function K(F,B,J)local L={}for M=1,16 do L[M]=D(F,B+(M-1)*4)end;for M=17,64 do local N=L[M-15]local O=k(t(N,7),t(N,18),s(N,3))N=L[M-2]L[M]=(L[M-16]+O+L[M-7]+k(t(N,17),t(N,19),s(N,10)))%a end;local d,e,l,P,Q,R,S,T=J[1],J[2],J[3],J[4],J[5],J[6],J[7],J[8]for B=1,64 do local O=k(t(d,2),t(d,13),t(d,22))local U=k(n(d,e),n(d,l),n(e,l))local V=(O+U)%a;local W=k(t(Q,6),t(Q,11),t(Q,25))local X=k(n(Q,R),n(o(Q),S))local Y=(T+W+X+v[B]+L[B])%a;T=S;S=R;R=Q;Q=(P+Y)%a;P=l;l=e;e=d;d=(Y+V)%a end;J[1]=(J[1]+d)%a;J[2]=(J[2]+e)%a;J[3]=(J[3]+l)%a;J[4]=(J[4]+P)%a;J[5]=(J[5]+Q)%a;J[6]=(J[6]+R)%a;J[7]=(J[7]+S)%a;J[8]=(J[8]+T)%a end;local function Z(F)F=E(F,#F)local J=I({})for B=1,#F,64 do K(F,B,J)end;return w(y(J[1],4)..y(J[2],4)..y(J[3],4)..y(J[4],4)..y(J[5],4)..y(J[6],4)..y(J[7],4)..y(J[8],4))end;local e;local l={["\\"]="\\",["\""]="\"",["\b"]="b",["\f"]="f",["\n"]="n",["\r"]="r",["\t"]="t"}local P={["/"]="/"}for Q,R in pairs(l)do P[R]=Q end;local S=function(T)return"\\"..(l[T]or string.format("u%04x",T:byte()))end;local B=function(M)return"null"end;local v=function(M,z)local _={}z=z or{}if z[M]then error("circular reference")end;z[M]=true;if rawget(M,1)~=nil or next(M)==nil then local A=0;for Q in pairs(M)do if type(Q)~="number"then error("invalid table: mixed or invalid key types")end;A=A+1 end;if A~=#M then error("invalid table: sparse array")end;for a0,R in ipairs(M)do table.insert(_,e(R,z))end;z[M]=nil;return"["..table.concat(_,",").."]"else for Q,R in pairs(M)do if type(Q)~="string"then error("invalid table: mixed or invalid key types")end;table.insert(_,e(Q,z)..":"..e(R,z))end;z[M]=nil;return"{"..table.concat(_,",").."}"end end;local g=function(M)return'"'..M:gsub('[%z\1-\31\\"]',S)..'"'end;local a1=function(M)if M~=M or M<=-math.huge or M>=math.huge then error("unexpected number value '"..tostring(M).."'")end;return string.format("%.14g",M)end;local j={["nil"]=B,["table"]=v,["string"]=g,["number"]=a1,["boolean"]=tostring}e=function(M,z)local x=type(M)local a2=j[x]if a2 then return a2(M,z)end;error("unexpected type '"..x.."'")end;local a3=function(M)return e(M)end;local a4;local N=function(...)local _={}for a0=1,select("#",...)do _[select(a0,...)]=true end;return _ end;local L=N(" ","\t","\r","\n")local p=N(" ","\t","\r","\n","]","}",",")local a5=N("\\","/",'"',"b","f","n","r","t","u")local m=N("true","false","null")local a6={["true"]=true,["false"]=false,["null"]=nil}local a7=function(a8,a9,aa,ab)for a0=a9,#a8 do if aa[a8:sub(a0,a0)]~=ab then return a0 end end;return#a8+1 end;local ac=function(a8,a9,J)local ad=1;local ae=1;for a0=1,a9-1 do ae=ae+1;if a8:sub(a0,a0)=="\n"then ad=ad+1;ae=1 end end;error(string.format("%s at line %d col %d",J,ad,ae))end;local af=function(A)local a2=math.floor;if A<=0x7f then return string.char(A)elseif A<=0x7ff then return string.char(a2(A/64)+192,A%64+128)elseif A<=0xffff then return string.char(a2(A/4096)+224,a2(A%4096/64)+128,A%64+128,A%64+128)elseif A<=0x10ffff then return string.char(a2(A/262144)+240,a2(A%262144/4096)+128,A%64+128,A%64+128)end;error(string.format("invalid unicode codepoint '%x'",A))end;local ag=function(ah)local ai=tonumber(ah:sub(1,4),16)local aj=tonumber(ah:sub(7,10),16)if aj then return af((ai-0xd800)*0x400+aj-0xdc00+0x10000)else return af(ai)end end;local ak=function(a8,a0)local _=""local al=a0+1;local Q=al;while al<=#a8 do local am=a8:byte(al)if am<32 then ac(a8,al,"control character in string")elseif am==92 then _=_..a8:sub(Q,al-1)al=al+1;local T=a8:sub(al,al)if T=="u"then local an=a8:match("^[dD][89aAbB]%x%x\\u%x%x%x%x",al+1)or a8:match("^%x%x%x%x",al+1)or ac(a8,al-1,"invalid unicode escape in string")_=_..ag(an)al=al+#an else if not a5[T]then ac(a8,al-1,"invalid escape char '"..T.."' in string")end;_=_..P[T]end;Q=al+1 elseif am==34 then _=_..a8:sub(Q,al-1)return _,al+1 end;al=al+1 end;ac(a8,a0,"expected closing quote for string")end;local ao=function(a8,a0)local am=a7(a8,a0,p)local ah=a8:sub(a0,am-1)local A=tonumber(ah)if not A then ac(a8,a0,"invalid number '"..ah.."'")end;return A,am end;local ap=function(a8,a0)local am=a7(a8,a0,p)local aq=a8:sub(a0,am-1)if not m[aq]then ac(a8,a0,"invalid literal '"..aq.."'")end;return a6[aq],am end;local ar=function(a8,a0)local _={}local A=1;a0=a0+1;while 1 do local am;a0=a7(a8,a0,L,true)if a8:sub(a0,a0)=="]" then a0=a0+1;break end;am,a0=a4(a8,a0)_[A]=am;A=A+1;a0=a7(a8,a0,L,true)local as=a8:sub(a0,a0)a0=a0+1;if as=="]" then break end;if as~="," then ac(a8,a0,"expected ']' or ','")end end;return _,a0 end;local at=function(a8,a0)local _={}a0=a0+1;while 1 do local au,M;a0=a7(a8,a0,L,true)if a8:sub(a0,a0)=="}" then a0=a0+1;break end;if a8:sub(a0,a0)~='"'then ac(a8,a0,"expected string for key")end;au,a0=a4(a8,a0)a0=a7(a8,a0,L,true)if a8:sub(a0,a0)~=":" then ac(a8,a0,"expected ':' after key")end;a0=a7(a8,a0+1,L,true)M,a0=a4(a8,a0)_[au]=M;a0=a7(a8,a0,L,true)local as=a8:sub(a0,a0)a0=a0+1;if as=="}" then break end;if as~="," then ac(a8,a0,"expected '}' or ','")end end;return _,a0 end;local av={['"']=ak,["0"]=ao,["1"]=ao,["2"]=ao,["3"]=ao,["4"]=ao,["5"]=ao,["6"]=ao,["7"]=ao,["8"]=ao,["9"]=ao,["-"]=ao,["t"]=ap,["f"]=ap,["n"]=ap,["["]=ar,["{"]=at}a4=function(a8,a9)local as=a8:sub(a9,a9)local a2=av[as]if a2 then return a2(a8,a9)end;ac(a8,a9,"unexpected character '"..as.."'")end;local aw=function(a8)if type(a8)~="string"then error("expected argument of type string, got "..type(a8))end;local _,a9=a4(a8,a7(a8,1,L,true))a9=a7(a8,a9,L,true)if a9<=#a8 then ac(a8,a9,"trailing garbage")end;return _ end;
local lEncode, lDecode, lDigest = a3, aw, Z;
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--! PLATOBOOST CONFIGURATION
local DISCORD_INVITE = "https://discord.gg/epWMbuXSN5"
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
-- MONOCHROME PALETTE (BLACK, DARK GRAY, GRAY, WHITE)
-- ============================================================
local Theme = {
    Black      = Color3.fromRGB(10, 10, 12),
    DarkGray   = Color3.fromRGB(26, 26, 30),
    MidGray    = Color3.fromRGB(45, 45, 52),
    BorderGray = Color3.fromRGB(110, 110, 122),
    SubText    = Color3.fromRGB(175, 175, 185),
    White      = Color3.fromRGB(255, 255, 255),
}

local FANCY_FONT = Enum.Font.Fondamento
local BODY_FONT  = Enum.Font.GothamBold

-- ============================================================
-- BRINELAND CUSTOM UI GATEWAY (PLATOBOOST INTEGRATED)
-- ============================================================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local KEY_FILE_NAME = "BrinelandKey.txt"

local function VerifyAndLoadHub()
    if readfile and isfile and isfile(KEY_FILE_NAME) then
        local savedKey = readfile(KEY_FILE_NAME)
        if savedKey and savedKey ~= "" then
            if verifyKey(savedKey) then
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
    MainFrame.Size = UDim2.fromOffset(380, 260)
    MainFrame.Position = UDim2.new(0.5, -190, 0.5, -130)
    MainFrame.BackgroundColor3 = Theme.Black
    MainFrame.BackgroundTransparency = 0.08
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

    local FrameStroke = Instance.new("UIStroke")
    FrameStroke.Color = Theme.BorderGray
    FrameStroke.Thickness = 1.5
    FrameStroke.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundTransparency = 1
    Title.Text = "Brineland"
    Title.TextColor3 = Theme.White
    Title.TextSize = 22
    Title.Font = FANCY_FONT
    Title.Parent = MainFrame

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(0.9, 0, 0, 38)
    KeyInput.Position = UDim2.new(0.05, 0, 0, 50)
    KeyInput.PlaceholderText = "Paste your key here..."
    KeyInput.PlaceholderColor3 = Theme.SubText
    KeyInput.Text = ""
    KeyInput.TextColor3 = Theme.White
    KeyInput.BackgroundColor3 = Theme.DarkGray
    KeyInput.BackgroundTransparency = 0.1
    KeyInput.TextSize = 12
    KeyInput.Font = BODY_FONT
    KeyInput.Parent = MainFrame
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(1, 0)

    local WorkInkBtn = Instance.new("TextButton")
    WorkInkBtn.Size = UDim2.new(0.9, 0, 0, 35)
    WorkInkBtn.Position = UDim2.new(0.05, 0, 0, 98)
    WorkInkBtn.BackgroundColor3 = Theme.MidGray
    WorkInkBtn.Text = "GET KEY (WORK.INK)"
    WorkInkBtn.TextColor3 = Theme.White
    WorkInkBtn.TextSize = 11
    WorkInkBtn.Font = BODY_FONT
    WorkInkBtn.Parent = MainFrame
    Instance.new("UICorner", WorkInkBtn).CornerRadius = UDim.new(1, 0)

    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Size = UDim2.new(0.43, 0, 0, 38)
    SubmitBtn.Position = UDim2.new(0.05, 0, 0, 142)
    SubmitBtn.BackgroundColor3 = Theme.DarkGray
    SubmitBtn.Text = "VERIFY KEY"
    SubmitBtn.TextColor3 = Theme.White
    SubmitBtn.TextSize = 12
    SubmitBtn.Font = BODY_FONT
    SubmitBtn.Parent = MainFrame
    Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(1, 0)
    local subStroke = Instance.new("UIStroke")
    subStroke.Color = Theme.BorderGray
    subStroke.Thickness = 1
    subStroke.Parent = SubmitBtn

    local DiscordBtn = Instance.new("TextButton")
    DiscordBtn.Size = UDim2.new(0.43, 0, 0, 38)
    DiscordBtn.Position = UDim2.new(0.52, 0, 0, 142)
    DiscordBtn.BackgroundColor3 = Theme.DarkGray
    DiscordBtn.Text = "COPY DISCORD"
    DiscordBtn.TextColor3 = Theme.White
    DiscordBtn.TextSize = 11
    DiscordBtn.Font = BODY_FONT
    DiscordBtn.Parent = MainFrame
    Instance.new("UICorner", DiscordBtn).CornerRadius = UDim.new(1, 0)
    local discStroke = Instance.new("UIStroke")
    discStroke.Color = Theme.BorderGray
    discStroke.Thickness = 1
    discStroke.Parent = DiscordBtn

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 0, 40)
    StatusLabel.Position = UDim2.new(0, 0, 0, 188)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "Click Get Key to complete Work.ink verification!"
    StatusLabel.TextColor3 = Theme.SubText
    StatusLabel.TextSize = 11
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
        local enteredKey = KeyInput.Text
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
            task.wait(0.5)
            local outTween = TweenService:Create(MainFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
                Size = UDim2.fromOffset(380, 0),
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
-- UNIVERSAL HUB (ANIMATED BLACK / DARK GRAY / GRAY / WHITE)
-- ============================================================
local function RunUniversalScript()
    local UserInputService = game:GetService("UserInputService")
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
            highlight.OutlineColor = Theme.BorderGray
            highlight.FillTransparency = 0.65
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
    ScreenGui.Name = "BrinelandUniversalHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.fromOffset(360, 0)
    MainFrame.Position = UDim2.new(0.5, -180, 0.5, -220)
    MainFrame.BackgroundColor3 = Theme.Black
    MainFrame.BackgroundTransparency = 0.08
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

    local FrameStroke = Instance.new("UIStroke")
    FrameStroke.Color = Theme.BorderGray
    FrameStroke.Thickness = 1.5
    FrameStroke.Parent = MainFrame

    -- Smooth open animation
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(360, 440)
    }):Play()

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 42)
    TopBar.BackgroundColor3 = Theme.DarkGray
    TopBar.BackgroundTransparency = 0.15
    TopBar.BorderSizePixel = 0
    TopBar.Parent = MainFrame
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 14)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -130, 1, 0)
    Title.Position = UDim2.new(0, 14, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Brineland"
    Title.TextColor3 = Theme.White
    Title.Font = FANCY_FONT
    Title.TextSize = 20
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    -- Oval Home button
    local HomeOvalBtn = Instance.new("TextButton")
    HomeOvalBtn.Size = UDim2.fromOffset(54, 26)
    HomeOvalBtn.Position = UDim2.new(1, -124, 0.5, -13)
    HomeOvalBtn.BackgroundColor3 = Theme.White
    HomeOvalBtn.Text = "Home"
    HomeOvalBtn.TextColor3 = Theme.Black
    HomeOvalBtn.Font = BODY_FONT
    HomeOvalBtn.TextSize = 10
    HomeOvalBtn.Parent = TopBar
    Instance.new("UICorner", HomeOvalBtn).CornerRadius = UDim.new(1, 0)

    -- Circular Arrow (collapse/expand) button
    local ArrowCircleBtn = Instance.new("TextButton")
    ArrowCircleBtn.Size = UDim2.fromOffset(28, 28)
    ArrowCircleBtn.Position = UDim2.new(1, -64, 0.5, -14)
    ArrowCircleBtn.BackgroundColor3 = Theme.MidGray
    ArrowCircleBtn.Text = "▼"
    ArrowCircleBtn.TextColor3 = Theme.White
    ArrowCircleBtn.Font = BODY_FONT
    ArrowCircleBtn.TextSize = 11
    ArrowCircleBtn.Parent = TopBar
    Instance.new("UICorner", ArrowCircleBtn).CornerRadius = UDim.new(1, 0)
    local arrowStroke = Instance.new("UIStroke")
    arrowStroke.Color = Theme.BorderGray
    arrowStroke.Thickness = 1
    arrowStroke.Parent = ArrowCircleBtn

    -- Circular Close button
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.fromOffset(28, 28)
    CloseBtn.Position = UDim2.new(1, -32, 0.5, -14)
    CloseBtn.BackgroundColor3 = Theme.MidGray
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Theme.White
    CloseBtn.Font = BODY_FONT
    CloseBtn.TextSize = 12
    CloseBtn.Parent = TopBar
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
    CloseBtn.MouseButton1Click:Connect(function()
        hubAlive = false
        for _, c in ipairs(hubConns) do pcall(function() c:Disconnect() end) end
        DisableFly()
        local closeTween = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Size = UDim2.fromOffset(360, 0),
            BackgroundTransparency = 1
        })
        closeTween:Play()
        closeTween.Completed:Wait()
        ScreenGui:Destroy()
    end)

    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1, -12, 0, 32)
    TabBar.Position = UDim2.new(0, 6, 0, 46)
    TabBar.BackgroundTransparency = 1
    TabBar.Parent = MainFrame

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.Padding = UDim.new(0, 3)
    TabLayout.Parent = TabBar

    local TabFrames = {}
    local function SelectTab(tabName)
        for name, data in pairs(TabFrames) do
            local active = (name == tabName)
            data.Container.Visible = active
            TweenService:Create(data.Button, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = active and Theme.White or Theme.DarkGray,
                TextColor3 = active and Theme.Black or Theme.SubText
            }):Play()
        end
    end

    local function CreateTab(tabName)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(0.16, 0, 1, 0)
        tabBtn.BackgroundColor3 = Theme.DarkGray
        tabBtn.Text = tabName
        tabBtn.TextColor3 = Theme.SubText
        tabBtn.Font = BODY_FONT
        tabBtn.TextSize = 9
        tabBtn.Parent = TabBar
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(1, 0)

        local container = Instance.new("ScrollingFrame")
        container.Size = UDim2.new(1, -12, 1, -88)
        container.Position = UDim2.new(0, 6, 0, 82)
        container.BackgroundTransparency = 1
        container.ScrollBarThickness = 3
        container.ScrollBarImageColor3 = Theme.BorderGray
        container.Visible = false
        container.Parent = MainFrame

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 6)
        listLayout.Parent = container

        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            container.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 16)
        end)

        TabFrames[tabName] = { Button = tabBtn, Container = container }
        tabBtn.MouseButton1Click:Connect(function()
            SelectTab(tabName)
        end)

        return container
    end

    local InfoTab      = CreateTab("Info")
    local TeleportsTab = CreateTab("TP")
    local PlayersTab   = CreateTab("Player")
    local PlayerTab    = CreateTab("Cheats")
    local VisualsTab   = CreateTab("Visuals")
    local KeyTab       = CreateTab("Key")

    SelectTab("Info")
    HomeOvalBtn.MouseButton1Click:Connect(function()
        SelectTab("Info")
    end)

    local isCollapsed = false
    ArrowCircleBtn.MouseButton1Click:Connect(function()
        isCollapsed = not isCollapsed
        if isCollapsed then
            for _, data in pairs(TabFrames) do data.Container.Visible = false end
            TabBar.Visible = false
            TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(360, 42)
            }):Play()
            TweenService:Create(ArrowCircleBtn, TweenInfo.new(0.2), { Rotation = 180 }):Play()
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.fromOffset(360, 440)
            }):Play()
            TweenService:Create(ArrowCircleBtn, TweenInfo.new(0.2), { Rotation = 0 }):Play()
            task.wait(0.15)
            TabBar.Visible = true
            for name, data in pairs(TabFrames) do
                if data.Button.BackgroundColor3 == Theme.White then
                    data.Container.Visible = true
                end
            end
        end
    end)

    local dragging, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        end
    end)
    trackConn(UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end))
    trackConn(UserInputService.InputEnded:Connect(function() dragging = false end))

    local function CreateButton(parentContainer, text, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -4, 0, 40)
        frame.BackgroundColor3 = Theme.DarkGray
        frame.Parent = parentContainer
        Instance.new("UICorner", frame).CornerRadius = UDim.new(1, 0)

        local stroke = Instance.new("UIStroke")
        stroke.Color = Theme.BorderGray
        stroke.Thickness = 1
        stroke.Parent = frame

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = text
        btn.TextColor3 = Theme.White
        btn.Font = BODY_FONT
        btn.TextSize = 11
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
        frame.Size = UDim2.new(1, -4, 0, 40)
        frame.BackgroundColor3 = Theme.DarkGray
        frame.Parent = parentContainer
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -60, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = Theme.White
        lbl.Font = BODY_FONT
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame

        local toggleBg = Instance.new("Frame")
        toggleBg.Size = UDim2.fromOffset(42, 22)
        toggleBg.Position = UDim2.new(1, -50, 0.5, -11)
        toggleBg.BackgroundColor3 = Theme.MidGray
        toggleBg.Parent = frame
        Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.fromOffset(18, 18)
        knob.Position = UDim2.new(0, 2, 0.5, -9)
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
                Position = active and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
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
        frame.Size = UDim2.new(1, -4, 0, 48)
        frame.BackgroundColor3 = Theme.DarkGray
        frame.Parent = parentContainer
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -20, 0, 20)
        lbl.Position = UDim2.new(0, 12, 0, 4)
        lbl.BackgroundTransparency = 1
        lbl.Text = showNumbers and (text .. ": " .. tostring(defaultVal)) or text
        lbl.TextColor3 = Theme.White
        lbl.Font = BODY_FONT
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame

        local track = Instance.new("Frame")
        track.Size = UDim2.new(1, -24, 0, 8)
        track.Position = UDim2.new(0, 12, 0, 29)
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

    -- TELEPORTS TAB
    local customTpCount = 0
    CreateButton(TeleportsTab, "Set Position", function()
        local char = LocalPlayer.Character
        local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart)
        if not hrp then return end

        customTpCount = customTpCount + 1
        local savedPos = hrp.CFrame
        local posName = string.format("TP #%d (%.0f, %.0f, %.0f)", customTpCount, savedPos.Position.X, savedPos.Position.Y, savedPos.Position.Z)

        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, -4, 0, 80)
        card.BackgroundColor3 = Theme.DarkGray
        card.Parent = TeleportsTab
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 10)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -35, 0, 26)
        label.Position = UDim2.new(0, 10, 0, 4)
        label.BackgroundTransparency = 1
        label.Text = posName
        label.TextColor3 = Theme.White
        label.Font = BODY_FONT
        label.TextSize = 10
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = card

        local deleteBtn = Instance.new("TextButton")
        deleteBtn.Size = UDim2.fromOffset(24, 24)
        deleteBtn.Position = UDim2.new(1, -28, 0, 4)
        deleteBtn.BackgroundColor3 = Theme.MidGray
        deleteBtn.Text = "X"
        deleteBtn.TextColor3 = Theme.White
        deleteBtn.Font = BODY_FONT
        deleteBtn.TextSize = 10
        deleteBtn.Parent = card
        Instance.new("UICorner", deleteBtn).CornerRadius = UDim.new(1, 0)
        deleteBtn.MouseButton1Click:Connect(function() card:Destroy() end)

        local function makeActionPill(labelText, xScale, xOffset, cb)
            local b = Instance.new("TextButton")
            b.Size = UDim2.new(0.32, -4, 0, 34)
            b.Position = UDim2.new(xScale, xOffset, 0, 38)
            b.BackgroundColor3 = Theme.MidGray
            b.Text = labelText
            b.TextColor3 = Theme.White
            b.Font = BODY_FONT
            b.TextSize = 11
            b.Parent = card
            Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
            b.MouseButton1Click:Connect(cb)
        end

        makeActionPill("TP", 0, 4, function() SafeTeleport(savedPos) end)
        makeActionPill("Walk", 0.34, 0, function() WalkToPosition(savedPos) end)
        makeActionPill("Tween", 0.68, -4, function() TweenToPosition(savedPos) end)
    end)

    -- PLAYERS TAB
    local selectedTarget = nil

    local selectorBtn = Instance.new("TextButton")
    selectorBtn.Size = UDim2.new(1, -4, 0, 38)
    selectorBtn.BackgroundColor3 = Theme.DarkGray
    selectorBtn.Text = "Selected Player: None (Click to choose)"
    selectorBtn.TextColor3 = Theme.White
    selectorBtn.Font = BODY_FONT
    selectorBtn.TextSize = 11
    selectorBtn.Parent = PlayersTab
    Instance.new("UICorner", selectorBtn).CornerRadius = UDim.new(1, 0)

    local dropdownContainer = Instance.new("ScrollingFrame")
    dropdownContainer.Size = UDim2.new(1, -4, 0, 140)
    dropdownContainer.BackgroundColor3 = Theme.Black
    dropdownContainer.ScrollBarThickness = 3
    dropdownContainer.Visible = false
    dropdownContainer.Parent = PlayersTab
    Instance.new("UICorner", dropdownContainer).CornerRadius = UDim.new(0, 10)

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
                pBtn.Size = UDim2.new(1, -6, 0, 32)
                pBtn.BackgroundColor3 = Theme.DarkGray
                pBtn.Text = plr.DisplayName .. " (@" .. plr.Name .. ")"
                pBtn.TextColor3 = Theme.White
                pBtn.Font = BODY_FONT
                pBtn.TextSize = 10
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
    actionCard.Size = UDim2.new(1, -4, 0, 48)
    actionCard.BackgroundColor3 = Theme.DarkGray
    actionCard.Parent = PlayersTab
    Instance.new("UICorner", actionCard).CornerRadius = UDim.new(1, 0)

    local function makePlayerPill(labelText, xScale, xOffset, cb)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0.32, -4, 1, -8)
        b.Position = UDim2.new(xScale, xOffset, 0, 4)
        b.BackgroundColor3 = Theme.MidGray
        b.Text = labelText
        b.TextColor3 = Theme.White
        b.Font = BODY_FONT
        b.TextSize = 11
        b.Parent = actionCard
        Instance.new("UICorner", b).CornerRadius = UDim.new(1, 0)
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

    -- CHEATS TAB CONTROLS
    CreateToggle(PlayerTab, "Enable Auto Aim (Lock)", function(state) Config.AutoAim = state end)
    CreateSlider(PlayerTab, "Auto Aim Lock Range", 10, 200, Config.AutoAimRange, true, function(val) Config.AutoAimRange = val end)
    CreateToggle(PlayerTab, "Enable WalkSpeed", function(state)
        Config.SpeedEnabled = state
        if not state and LocalPlayer.Character then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
    end)
    CreateSlider(PlayerTab, "Player Speed", 16, 300, Config.WalkSpeed, true, function(val) Config.WalkSpeed = val end)
    CreateToggle(PlayerTab, "Enable Fly", function(state)
        if state then EnableFly() else DisableFly() end
    end)
    CreateSlider(PlayerTab, "Fly Speed", 10, 300, Config.FlySpeed, true, function(val) Config.FlySpeed = val end)
    CreateToggle(PlayerTab, "Noclip", function(state) Config.Noclip = state end)
    CreateToggle(PlayerTab, "Fast Interact", function(state) Config.FastInteract = state end)

    -- VISUALS TAB CONTROLS
    CreateToggle(VisualsTab, "Player ESP", function(state) ToggleESPState(state) end)
    CreateToggle(VisualsTab, "Clean Vision (Fullbright & No Fog)", function(state) ToggleCleanVision(state) end)

    -- KEYBINDS TAB
    local bindableActions = {
        {Name = "Fly Toggle", Action = function() if Config.FlyEnabled then DisableFly() else EnableFly() end end},
        {Name = "Noclip Toggle", Action = function() Config.Noclip = not Config.Noclip end},
        {Name = "Player ESP Toggle", Action = function() ToggleESPState(not Config.PlayerESP) end},
        {Name = "Clean Vision Toggle", Action = function() ToggleCleanVision(not Config.CleanVision) end},
        {Name = "Speed Boost Toggle", Action = function() Config.SpeedEnabled = not Config.SpeedEnabled end}
    }

    for _, item in ipairs(bindableActions) do
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -4, 0, 40)
        frame.BackgroundColor3 = Theme.DarkGray
        frame.Parent = KeyTab
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -95, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = item.Name
        lbl.TextColor3 = Theme.White
        lbl.Font = BODY_FONT
        lbl.TextSize = 11
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame

        local bindBtn = Instance.new("TextButton")
        bindBtn.Size = UDim2.fromOffset(80, 26)
        bindBtn.Position = UDim2.new(1, -86, 0.5, -13)
        bindBtn.BackgroundColor3 = Theme.MidGray
        bindBtn.Text = "[ None ]"
        bindBtn.TextColor3 = Theme.White
        bindBtn.Font = BODY_FONT
        bindBtn.TextSize = 10
        bindBtn.Parent = frame
        Instance.new("UICorner", bindBtn).CornerRadius = UDim.new(1, 0)

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

    -- INFO TAB
    local MAX_LOGS = 200
    local LOG_KIND = {
        OUTPUT = { color = Theme.White,   hex = "#FFFFFF", label = "OUTPUT" },
        INFO   = { color = Theme.White,   hex = "#E5E5E5", label = "INFO" },
        WARN   = { color = Theme.SubText, hex = "#C8C8D2", label = "WARN" },
        ERROR  = { color = Theme.SubText, hex = "#A5A5B2", label = "ERROR" },
    }
    local LOG_FILTERS = { "ALL", "OUTPUT", "INFO", "WARN", "ERROR" }

    local topRowContainer = Instance.new("Frame")
    topRowContainer.Size = UDim2.new(1, -4, 0, 115)
    topRowContainer.BackgroundTransparency = 1
    topRowContainer.Parent = InfoTab

    local leftTelemetryCol = Instance.new("Frame")
    leftTelemetryCol.Size = UDim2.new(0.58, -4, 1, 0)
    leftTelemetryCol.BackgroundTransparency = 1
    leftTelemetryCol.Parent = topRowContainer

    local telemetryLayout = Instance.new("UIListLayout")
    telemetryLayout.Padding = UDim.new(0, 5)
    telemetryLayout.Parent = leftTelemetryCol

    local statusHeader = Instance.new("Frame")
    statusHeader.Size = UDim2.new(1, 0, 0, 32)
    statusHeader.BackgroundColor3 = Theme.DarkGray
    statusHeader.Parent = leftTelemetryCol
    Instance.new("UICorner", statusHeader).CornerRadius = UDim.new(0, 8)

    local serverTitleLbl = Instance.new("TextLabel")
    serverTitleLbl.Size = UDim2.new(0.55, 0, 1, 0)
    serverTitleLbl.Position = UDim2.new(0, 8, 0, 0)
    serverTitleLbl.BackgroundTransparency = 1
    serverTitleLbl.Text = "SERVER STATUS"
    serverTitleLbl.TextColor3 = Theme.White
    serverTitleLbl.Font = BODY_FONT
    serverTitleLbl.TextSize = 10
    serverTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    serverTitleLbl.Parent = statusHeader

    local connStatusLbl = Instance.new("TextLabel")
    connStatusLbl.Size = UDim2.new(0.45, -8, 1, 0)
    connStatusLbl.Position = UDim2.new(0.55, 0, 0, 0)
    connStatusLbl.BackgroundTransparency = 1
    connStatusLbl.Text = "CONNECTED"
    connStatusLbl.TextColor3 = Theme.White
    connStatusLbl.Font = BODY_FONT
    connStatusLbl.TextSize = 9
    connStatusLbl.TextXAlignment = Enum.TextXAlignment.Right
    connStatusLbl.Parent = statusHeader

    local miniGrid = Instance.new("Frame")
    miniGrid.Size = UDim2.new(1, 0, 0, 76)
    miniGrid.BackgroundTransparency = 1
    miniGrid.Parent = leftTelemetryCol

    local miniLayout = Instance.new("UIGridLayout")
    miniLayout.CellSize = UDim2.new(0.48, 0, 0, 35)
    miniLayout.CellPadding = UDim2.new(0.04, 0, 0, 6)
    miniLayout.Parent = miniGrid

    local function createMiniStatChip(titleText)
        local card = Instance.new("Frame")
        card.BackgroundColor3 = Theme.DarkGray
        card.Parent = miniGrid
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)

        local cap = Instance.new("TextLabel")
        cap.Size = UDim2.new(1, -8, 0, 12)
        cap.Position = UDim2.new(0, 6, 0, 2)
        cap.BackgroundTransparency = 1
        cap.Text = titleText
        cap.TextColor3 = Theme.SubText
        cap.Font = BODY_FONT
        cap.TextSize = 8
        cap.TextXAlignment = Enum.TextXAlignment.Left
        cap.Parent = card

        local val = Instance.new("TextLabel")
        val.Size = UDim2.new(1, -8, 0, 16)
        val.Position = UDim2.new(0, 6, 0, 15)
        val.BackgroundTransparency = 1
        val.Text = "--"
        val.TextColor3 = Theme.White
        val.Font = BODY_FONT
        val.TextSize = 10
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
    avatarCard.Size = UDim2.new(0.42, -2, 1, 0)
    avatarCard.Position = UDim2.new(0.58, 2, 0, 0)
    avatarCard.BackgroundColor3 = Theme.DarkGray
    avatarCard.Parent = topRowContainer
    Instance.new("UICorner", avatarCard).CornerRadius = UDim.new(0, 8)

    local avatarStroke = Instance.new("UIStroke")
    avatarStroke.Color = Theme.BorderGray
    avatarStroke.Thickness = 1
    avatarStroke.Parent = avatarCard

    local viewport = Instance.new("ViewportFrame")
    viewport.Size = UDim2.new(1, -8, 1, -22)
    viewport.Position = UDim2.new(0, 4, 0, 4)
    viewport.BackgroundTransparency = 1
    viewport.Ambient = Color3.fromRGB(200, 200, 200)
    viewport.LightColor = Theme.White
    viewport.LightDirection = Vector3.new(-1, -1, -1)
    viewport.Parent = avatarCard

    local avatarNameLbl = Instance.new("TextLabel")
    avatarNameLbl.Size = UDim2.new(1, 0, 0, 16)
    avatarNameLbl.Position = UDim2.new(0, 0, 1, -18)
    avatarNameLbl.BackgroundTransparency = 1
    avatarNameLbl.Text = string.sub(LocalPlayer.DisplayName, 1, 12)
    avatarNameLbl.TextColor3 = Theme.White
    avatarNameLbl.Font = BODY_FONT
    avatarNameLbl.TextSize = 9
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
    bottomStatsRow.Size = UDim2.new(1, -4, 0, 32)
    bottomStatsRow.BackgroundColor3 = Theme.DarkGray
    bottomStatsRow.Parent = InfoTab
    Instance.new("UICorner", bottomStatsRow).CornerRadius = UDim.new(1, 0)

    local playersValLbl = Instance.new("TextLabel")
    playersValLbl.Size = UDim2.new(0.45, 0, 1, 0)
    playersValLbl.Position = UDim2.new(0, 10, 0, 0)
    playersValLbl.BackgroundTransparency = 1
    playersValLbl.Text = "PLAYERS: --"
    playersValLbl.TextColor3 = Theme.White
    playersValLbl.Font = BODY_FONT
    playersValLbl.TextSize = 9
    playersValLbl.TextXAlignment = Enum.TextXAlignment.Left
    playersValLbl.Parent = bottomStatsRow

    local jobIdValLbl = Instance.new("TextLabel")
    jobIdValLbl.Size = UDim2.new(0.55, -10, 1, 0)
    jobIdValLbl.Position = UDim2.new(0.45, 0, 0, 0)
    jobIdValLbl.BackgroundTransparency = 1
    local jobId = game.JobId
    local jobShown = (jobId == "") and "STUDIO" or (string.sub(jobId, 1, 10) .. "...")
    jobIdValLbl.Text = "JOB ID: " .. jobShown
    jobIdValLbl.TextColor3 = Theme.SubText
    jobIdValLbl.Font = BODY_FONT
    jobIdValLbl.TextSize = 9
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
                jobIdValLbl.Text = "JOB ID: " .. jobShown
                jobIdValLbl.TextColor3 = Theme.SubText
            end
        end)
    end)

    local filterBar = Instance.new("Frame")
    filterBar.Size = UDim2.new(1, -4, 0, 24)
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
        fBtn.TextSize = 8
        fBtn.Parent = filterBar
        Instance.new("UICorner", fBtn).CornerRadius = UDim.new(1, 0)
        filterBtns[fName] = fBtn

        fBtn.MouseButton1Click:Connect(function()
            activeFilter = fName
            updateFilterColors()
            rebuildConsole()
        end)
    end
    updateFilterColors()

    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -4, 0, 26)
    searchBox.BackgroundColor3 = Theme.DarkGray
    searchBox.PlaceholderText = "Search console logs..."
    searchBox.PlaceholderColor3 = Theme.SubText
    searchBox.Text = ""
    searchBox.TextColor3 = Theme.White
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 11
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.ClearTextOnFocus = false
    searchBox.Parent = InfoTab
    Instance.new("UICorner", searchBox).CornerRadius = UDim.new(1, 0)
    Instance.new("UIPadding", searchBox).PaddingLeft = UDim.new(0, 10)

    local consoleScroll = Instance.new("ScrollingFrame")
    consoleScroll.Size = UDim2.new(1, -4, 0, 125)
    consoleScroll.BackgroundColor3 = Theme.Black
    consoleScroll.BorderSizePixel = 0
    consoleScroll.ScrollBarThickness = 3
    consoleScroll.ScrollBarImageColor3 = Theme.BorderGray
    consoleScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    consoleScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    consoleScroll.Parent = InfoTab
    Instance.new("UICorner", consoleScroll).CornerRadius = UDim.new(0, 8)

    local consoleList = Instance.new("UIListLayout")
    consoleList.Padding = UDim.new(0, 2)
    consoleList.SortOrder = Enum.SortOrder.LayoutOrder
    consoleList.Parent = consoleScroll

    local consolePad = Instance.new("UIPadding")
    consolePad.PaddingTop = UDim.new(0, 4)
    consolePad.PaddingBottom = UDim.new(0, 4)
    consolePad.PaddingLeft = UDim.new(0, 5)
    consolePad.PaddingRight = UDim.new(0, 6)
    consolePad.Parent = consoleScroll

    local consoleControls = Instance.new("Frame")
    consoleControls.Size = UDim2.new(1, -4, 0, 26)
    consoleControls.BackgroundTransparency = 1
    consoleControls.Parent = InfoTab

    local clearConsoleBtn = Instance.new("TextButton")
    clearConsoleBtn.Size = UDim2.new(0.36, 0, 1, 0)
    clearConsoleBtn.Position = UDim2.new(0, 0, 0, 0)
    clearConsoleBtn.BackgroundColor3 = Theme.DarkGray
    clearConsoleBtn.Text = "CLEAR"
    clearConsoleBtn.TextColor3 = Theme.White
    clearConsoleBtn.Font = BODY_FONT
    clearConsoleBtn.TextSize = 9
    clearConsoleBtn.Parent = consoleControls
    Instance.new("UICorner", clearConsoleBtn).CornerRadius = UDim.new(1, 0)

    local autoScrollEnabled = true
    local autoScrollBtn = Instance.new("TextButton")
    autoScrollBtn.Size = UDim2.new(0.42, 0, 1, 0)
    autoScrollBtn.Position = UDim2.new(0.38, 0, 0, 0)
    autoScrollBtn.BackgroundColor3 = Theme.White
    autoScrollBtn.Text = "AUTO-SCROLL: ON"
    autoScrollBtn.TextColor3 = Theme.Black
    autoScrollBtn.Font = BODY_FONT
    autoScrollBtn.TextSize = 9
    autoScrollBtn.Parent = consoleControls
    Instance.new("UICorner", autoScrollBtn).CornerRadius = UDim.new(1, 0)

    local logCountLbl = Instance.new("TextLabel")
    logCountLbl.Size = UDim2.new(0.18, 0, 1, 0)
    logCountLbl.Position = UDim2.new(0.82, 0, 0, 0)
    logCountLbl.BackgroundTransparency = 1
    logCountLbl.Text = "0/" .. MAX_LOGS
    logCountLbl.TextColor3 = Theme.SubText
    logCountLbl.Font = BODY_FONT
    logCountLbl.TextSize = 9
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
        row.TextSize = 10
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
        autoScrollBtn.Text = autoScrollEnabled and "AUTO-SCROLL: ON" or "AUTO-SCROLL: OFF"
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

    pushConsoleLog("Brineland Server Info & Console initialized.", "INFO")
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
        local fn, err = loadstring(res)
        if fn then
            fn()
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
    LoadExternalScript("taxiboss.lua")
elseif nameLower:find("steal an egg") or nameLower:find("stealanegg") or PlaceId == 107778070777162 or PlaceId == 115049386348611 then
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
    print("[BRINELAND] Unrecognized game: " .. gameName .. " (PlaceId: " .. tostring(PlaceId) .. "). Running Universal Hub...")
    RunUniversalScript()
end
