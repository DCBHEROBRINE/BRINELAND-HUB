-- ============================================================
-- BRINELAND MASTER MULTI-GAME HUB + PLATOBOOST KEY SYSTEM
-- Repository: https://github.com/DCBHEROBRINE/BRINELAND-HUB.git
-- Discord: https://discord.gg/epWMbuXSN5
-- ============================================================

-------------------------------------------------------------------------------
--! json library
--! cryptography library
local a=2^32;local b=a-1;local function c(d,e)local f,g=0,1;while d~=0 or e~=0 do local h,i=d%2,e%2;local j=(h+i)%2;f=f+j*g;d=math.floor(d/2)e=math.floor(e/2)g=g*2 end;return f%a end;local function k(d,e,l,...)local m;if e then d=d%a;e=e%a;m=c(d,e)if l then m=k(m,l,...)end;return m elseif d then return d%a else return 0 end end;local function n(d,e,l,...)local m;if e then d=d%a;e=e%a;m=(d+e-c(d,e))/2;if l then m=n(m,l,...)end;return m elseif d then return d%a else return b end end;local function o(p)return b-p end;local function q(d,r)if r<0 then return lshift(d,-r)end;return math.floor(d%2^32/2^r)end;local function s(p,r)if r>31 or r<-31 then return 0 end;return q(p%a,r)end;local function lshift(d,r)if r<0 then return s(d,-r)end;return d*2^r%2^32 end;local function t(p,r)p=p%a;r=r%32;local u=n(p,2^r-1)return s(p,r)+lshift(u,32-r)end;local v={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}local function w(x)return string.gsub(x,".",function(l)return string.format("%02x",string.byte(l))end)end;local function y(z,A)local x=""for B=1,A do local C=z%256;x=string.char(C)..x;z=(z-C)/256 end;return x end;local function D(x,B)local A=0;for B=B,B+3 do A=A*256+string.byte(x,B)end;return A end;local function E(F,G)local H=64-(G+9)%64;G=y(8*G,8)F=F.."\128"..string.rep("\0",H)..G;assert(#F%64==0)return F end;local function I(J)J[1]=0x6a09e667;J[2]=0xbb67ae85;J[3]=0x3c6ef372;J[4]=0xa54ff53a;J[5]=0x510e527f;J[6]=0x9b05688c;J[7]=0x1f83d9ab;J[8]=0x5be0cd19;return J end;local function K(F,B,J)local L={}for M=1,16 do L[M]=D(F,B+(M-1)*4)end;for M=17,64 do local N=L[M-15]local O=k(t(N,7),t(N,18),s(N,3))N=L[M-2]L[M]=(L[M-16]+O+L[M-7]+k(t(N,17),t(N,19),s(N,10)))%a end;local d,e,l,P,Q,R,S,T=J[1],J[2],J[3],J[4],J[5],J[6],J[7],J[8]for B=1,64 do local O=k(t(d,2),t(d,13),t(d,22))local U=k(n(d,e),n(d,l),n(e,l))local V=(O+U)%a;local W=k(t(Q,6),t(Q,11),t(Q,25))local X=k(n(Q,R),n(o(Q),S))local Y=(T+W+X+v[B]+L[B])%a;T=S;S=R;R=Q;Q=(P+Y)%a;P=l;l=e;e=d;d=(Y+V)%a end;J[1]=(J[1]+d)%a;J[2]=(J[2]+e)%a;J[3]=(J[3]+l)%a;J[4]=(J[4]+P)%a;J[5]=(J[5]+Q)%a;J[6]=(J[6]+R)%a;J[7]=(J[7]+S)%a;J[8]=(J[8]+T)%a end;local function Z(F)F=E(F,#F)local J=I({})for B=1,#F,64 do K(F,B,J)end;return w(y(J[1],4)..y(J[2],4)..y(J[3],4)..y(J[4],4)..y(J[5],4)..y(J[6],4)..y(J[7],4)..y(J[8],4))end;local e;local l={["\\"]="\\",["\""]="\"",["\b"]="b",["\f"]="f",["\n"]="n",["\r"]="r",["\t"]="t"}local P={["/"]="/"}for Q,R in pairs(l)do P[R]=Q end;local S=function(T)return"\\"..(l[T]or string.format("u%04x",T:byte()))end;local B=function(M)return"null"end;local v=function(M,z)local _={}z=z or{}if z[M]then error("circular reference")end;z[M]=true;if rawget(M,1)~=nil or next(M)==nil then local A=0;for Q in pairs(M)do if type(Q)~="number"then error("invalid table: mixed or invalid key types")end;A=A+1 end;if A~=#M then error("invalid table: sparse array")end;for a0,R in ipairs(M)do table.insert(_,e(R,z))end;z[M]=nil;return"["..table.concat(_,",").."]"else for Q,R in pairs(M)do if type(Q)~="string"then error("invalid table: mixed or invalid key types")end;table.insert(_,e(Q,z)..":"..e(R,z))end;z[M]=nil;return"{"..table.concat(_,",").."}"end end;local g=function(M)return'"'..M:gsub('[%z\1-\31\\"]',S)..'"'end;local a1=function(M)if M~=M or M<=-math.huge or M>=math.huge then error("unexpected number value '"..tostring(M).."'")end;return string.format("%.14g",M)end;local j={["nil"]=B,["table"]=v,["string"]=g,["number"]=a1,["boolean"]=tostring}e=function(M,z)local x=type(M)local a2=j[x]if a2 then return a2(M,z)end;error("unexpected type '"..x.."'")end;local a3=function(M)return e(M)end;local a4;local N=function(...)local _={}for a0=1,select("#",...)do _[select(a0,...)]=true end;return _ end;local L=N(" ","\t","\r","\n")local p=N(" ","\t","\r","\n","]","}",",")local a5=N("\\","/",'"',"b","f","n","r","t","u")local m=N("true","false","null")local a6={["true"]=true,["false"]=false,["null"]=nil}local a7=function(a8,a9,aa,ab)for a0=a9,#a8 do if aa[a8:sub(a0,a0)]~=ab then return a0 end end;return#a8+1 end;local ac=function(a8,a9,J)local ad=1;local ae=1;for a0=1,a9-1 do ae=ae+1;if a8:sub(a0,a0)=="\n"then ad=ad+1;ae=1 end end;error(string.format("%s at line %d col %d",J,ad,ae))end;local af=function(A)local a2=math.floor;if A<=0x7f then return string.char(A)elseif A<=0x7ff then return string.char(a2(A/64)+192,A%64+128)elseif A<=0xffff then return string.char(a2(A/4096)+224,a2(A%4096/64)+128,A%64+128,A%64+128)elseif A<=0x10ffff then return string.char(a2(A/262144)+240,a2(A%262144/4096)+128,A%64+128,A%64+128)end;error(string.format("invalid unicode codepoint '%x'",A))end;local ag=function(ah)local ai=tonumber(ah:sub(1,4),16)local aj=tonumber(ah:sub(7,10),16)if aj then return af((ai-0xd800)*0x400+aj-0xdc00+0x10000)else return af(ai)end end;local ak=function(a8,a0)local _=""local al=a0+1;local Q=al;while al<=#a8 do local am=a8:byte(al)if am<32 then ac(a8,al,"control character in string")elseif am==92 then _=_..a8:sub(Q,al-1)al=al+1;local T=a8:sub(al,al)if T=="u"then local an=a8:match("^[dD][89aAbB]%x%x\\u%x%x%x%x",al+1)or a8:match("^%x%x%x%x",al+1)or ac(a8,al-1,"invalid unicode escape in string")_=_..ag(an)al=al+#an else if not a5[T]then ac(a8,al-1,"invalid escape char '"..T.."' in string")end;_=_..P[T]end;Q=al+1 elseif am==34 then _=_..a8:sub(Q,al-1)return _,al+1 end;al=al+1 end;ac(a8,a0,"expected closing quote for string")end;local ao=function(a8,a0)local am=a7(a8,a0,p)local ah=a8:sub(a0,am-1)local A=tonumber(ah)if not A then ac(a8,a0,"invalid number '"..ah.."'")end;return A,am end;local ap=function(a8,a0)local am=a7(a8,a0,p)local aq=a8:sub(a0,am-1)if not m[aq]then ac(a8,a0,"invalid literal '"..aq.."'")end;return a6[aq],am end;local ar=function(a8,a0)local _={}local A=1;a0=a0+1;while 1 do local am;a0=a7(a8,a0,L,true)if a8:sub(a0,a0)=="]" then a0=a0+1;break end;am,a0=a4(a8,a0)_[A]=am;A=A+1;a0=a7(a8,a0,L,true)local as=a8:sub(a0,a0)a0=a0+1;if as=="]" then break end;if as~="," then ac(a8,a0,"expected ']' or ','")end end;return _,a0 end;local at=function(a8,a0)local _={}a0=a0+1;while 1 do local au,M;a0=a7(a8,a0,L,true)if a8:sub(a0,a0)=="}" then a0=a0+1;break end;if a8:sub(a0,a0)~='"'then ac(a8,a0,"expected string for key")end;au,a0=a4(a8,a0)a0=a7(a8,a0,L,true)if a8:sub(a0,a0)~=":" then ac(a8,a0,"expected ':' after key")end;a0=a7(a8,a0+1,L,true)M,a0=a4(a8,a0)_[au]=M;a0=a7(a8,a0,L,true)local as=a8:sub(a0,a0)a0=a0+1;if as=="}" then break end;if as~="," then ac(a8,a0,"expected '}' or ','")end end;return _,a0 end;local av={['"']=ak,["0"]=ao,["1"]=ao,["2"]=ao,["3"]=ao,["4"]=ao,["5"]=ao,["6"]=ao,["7"]=ao,["8"]=ao,["9"]=ao,["-"]=ao,["t"]=ap,["f"]=ap,["n"]=ap,["["]=ar,["{"]=at}a4=function(a8,a9)local as=a8:sub(a9,a9)local a2=av[as]if a2 then return a2(a8,a9)end;ac(a8,a9,"unexpected character '"..as.."'")end;local aw=function(a8)if type(a8)~="string"then error("expected argument of type string, got "..type(a8))end;local _,a9=a4(a8,a7(a8,1,L,true))a9=a7(a8,a9,L,true)if a9<=#a8 then ac(a8,a9,"trailing garbage")end;return _ end;
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

-- Safe HTTP Request wrapper to prevent DnsResolve crashes on Delta
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
-- BRINELAND CUSTOM UI GATEWAY (PLATOBOOST INTEGRATED)
-- ============================================================
local Players = game:GetService("Players")
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
    MainFrame.BackgroundColor3 = Color3.fromRGB(14, 11, 25)
    MainFrame.BackgroundTransparency = 0.18
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

    local FrameStroke = Instance.new("UIStroke")
    FrameStroke.Color = Color3.fromRGB(0, 229, 255)
    FrameStroke.Thickness = 1.5
    FrameStroke.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 45)
    Title.BackgroundTransparency = 1
    Title.Text = "<b>BRINELAND</b> <font color=\"#00E5FF\">HUB</font>"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.RichText = true
    Title.Parent = MainFrame

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(0.9, 0, 0, 38)
    KeyInput.Position = UDim2.new(0.05, 0, 0, 50)
    KeyInput.PlaceholderText = "Paste your key here..."
    KeyInput.Text = ""
    KeyInput.TextColor3 = Color3.fromRGB(0, 229, 255)
    KeyInput.BackgroundColor3 = Color3.fromRGB(22, 18, 45)
    KeyInput.BackgroundTransparency = 0.25
    KeyInput.TextSize = 12
    KeyInput.Font = Enum.Font.GothamBold
    KeyInput.Parent = MainFrame
    Instance.new("UICorner", KeyInput).CornerRadius = UDim.new(0, 6)

    local WorkInkBtn = Instance.new("TextButton")
    WorkInkBtn.Size = UDim2.new(0.9, 0, 0, 35)
    WorkInkBtn.Position = UDim2.new(0.05, 0, 0, 98)
    WorkInkBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 220)
    WorkInkBtn.BackgroundTransparency = 0.15
    WorkInkBtn.Text = "<b>GET KEY (WORK.INK)</b>"
    WorkInkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    WorkInkBtn.TextSize = 11
    WorkInkBtn.Font = Enum.Font.GothamBold
    WorkInkBtn.RichText = true
    WorkInkBtn.Parent = MainFrame
    Instance.new("UICorner", WorkInkBtn).CornerRadius = UDim.new(0, 6)

    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Size = UDim2.new(0.43, 0, 0, 38)
    SubmitBtn.Position = UDim2.new(0.05, 0, 0, 142)
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(45, 180, 80)
    SubmitBtn.BackgroundTransparency = 0.15
    SubmitBtn.Text = "<b>VERIFY KEY</b>"
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.TextSize = 12
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.RichText = true
    SubmitBtn.Parent = MainFrame
    Instance.new("UICorner", SubmitBtn).CornerRadius = UDim.new(0, 6)

    local DiscordBtn = Instance.new("TextButton")
    DiscordBtn.Size = UDim2.new(0.43, 0, 0, 38)
    DiscordBtn.Position = UDim2.new(0.52, 0, 0, 142)
    DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    DiscordBtn.BackgroundTransparency = 0.15
    DiscordBtn.Text = "<b>COPY DISCORD</b>"
    DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    DiscordBtn.TextSize = 11
    DiscordBtn.Font = Enum.Font.GothamBold
    DiscordBtn.RichText = true
    DiscordBtn.Parent = MainFrame
    Instance.new("UICorner", DiscordBtn).CornerRadius = UDim.new(0, 6)

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 0, 40)
    StatusLabel.Position = UDim2.new(0, 0, 0, 188)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "Click Get Key to complete Work.ink verification!"
    StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 200)
    StatusLabel.TextSize = 11
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextWrapped = true
    StatusLabel.Parent = MainFrame

    WorkInkBtn.MouseButton1Click:Connect(function()
        if fSetClipboard then
            copyLink()
            StatusLabel.Text = "PlatoBoost link copied to clipboard!"
            StatusLabel.TextColor3 = Color3.fromRGB(0, 229, 255)
        else
            StatusLabel.Text = "Executor does not support clipboard."
            StatusLabel.TextColor3 = Color3.fromRGB(220, 35, 70)
        end
    end)

    DiscordBtn.MouseButton1Click:Connect(function()
        if fSetClipboard then
            fSetClipboard(DISCORD_INVITE)
            StatusLabel.Text = "Discord invite copied!"
            StatusLabel.TextColor3 = Color3.fromRGB(88, 101, 242)
        end
    end)

    local isVerified = false

    SubmitBtn.MouseButton1Click:Connect(function()
        local enteredKey = KeyInput.Text
        if enteredKey == "" then
            StatusLabel.Text = "Please enter a key first!"
            StatusLabel.TextColor3 = Color3.fromRGB(220, 35, 70)
            return
        end
        
        StatusLabel.Text = "Checking key..."
        StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        
        local isValid = verifyKey(enteredKey)
        
        if isValid then
            StatusLabel.Text = "Key valid! Loading BRINELAND..."
            StatusLabel.TextColor3 = Color3.fromRGB(45, 200, 80)
            if writefile then
                pcall(function() writefile(KEY_FILE_NAME, enteredKey) end)
            end
            task.wait(0.6)
            ScreenGui:Destroy()
            isVerified = true
        else
            StatusLabel.Text = "Invalid key. Please try again."
            StatusLabel.TextColor3 = Color3.fromRGB(220, 35, 70)
        end
    end)

    repeat task.wait(0.2) until isVerified
    return true
end

VerifyAndLoadHub()

-- ============================================================
-- SCRIPT 1: TAXI BOSS HUB
-- ============================================================
local function RunTaxiBoss()
    local TweenService     = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local Workspace        = game:GetService("Workspace")
    local RunService       = game:GetService("RunService")

    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    if PlayerGui:FindFirstChild("TaxiBossCustomHub") then
        PlayerGui.TaxiBossCustomHub:Destroy()
    end

    local Config = {
        AutoCollectItems = false,
        ClearAICars      = false,
        EnableCarSpeed   = false,
        TargetKMH        = 220,
        PlayerSpeed      = 16,
        ItemDelay        = 0.15,
        TweenSpeed       = 260
    }

    local function GetPlayerVehicle()
        local char = LocalPlayer.Character
        if not char then return nil end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid and humanoid.SeatPart and humanoid.SeatPart:IsA("VehicleSeat") then
            return humanoid.SeatPart.Parent
        end
        return nil
    end

    local function CollectItemSpawns()
        local itemFolder = Workspace:FindFirstChild("ItemSpawnLocations")
        if not itemFolder then return end

        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        for _, zone in ipairs(itemFolder:GetChildren()) do
            if not Config.AutoCollectItems then break end

            local spawnedItems = {}
            for _, child in ipairs(zone:GetChildren()) do
                if child:IsA("Model") or (child:IsA("BasePart") and child.Name ~= zone.Name) then
                    table.insert(spawnedItems, child)
                end
            end

            for _, item in ipairs(spawnedItems) do
                if not Config.AutoCollectItems then break end

                local targetPart = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart", true)) or item
                local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)

                if targetPart then
                    char:PivotTo(targetPart.CFrame * CFrame.new(0, 2, 0))
                    task.wait(0.08)

                    if prompt and prompt.Enabled then
                        fireproximityprompt(prompt)
                    else
                        firetouchinterest(hrp, targetPart, 0)
                        task.wait(0.02)
                        firetouchinterest(hrp, targetPart, 1)
                    end

                    task.wait(Config.ItemDelay)
                end
            end
        end
    end

    task.spawn(function()
        while task.wait(0.5) do
            if Config.AutoCollectItems then pcall(CollectItemSpawns) end
        end
    end)

    task.spawn(function()
        while task.wait(1.5) do
            if Config.ClearAICars then
                local aiFolder = Workspace:FindFirstChild("AICars")
                if aiFolder then
                    for _, car in ipairs(aiFolder:GetChildren()) do car:Destroy() end
                end
            end
        end
    end)

    RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.WalkSpeed ~= Config.PlayerSpeed then hum.WalkSpeed = Config.PlayerSpeed end
        end

        if Config.EnableCarSpeed then
            local veh = GetPlayerVehicle()
            if veh then
                local seat = veh:FindFirstChildOfClass("VehicleSeat") or veh:FindFirstChild("SEAT", true)
                if seat and seat:IsA("VehicleSeat") then
                    local speedStuds = Config.TargetKMH / 1.008
                    seat.MaxSpeed = speedStuds
                    seat.Torque = 90000

                    if seat.Throttle > -1 then
                        local root = seat.AssemblyRootPart or seat
                        local lookVector = seat.CFrame.LookVector
                        root.AssemblyLinearVelocity = Vector3.new(lookVector.X * speedStuds, root.AssemblyLinearVelocity.Y, lookVector.Z * speedStuds)
                    end
                end
            end
        end
    end)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TaxiBossCustomHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.fromOffset(340, 320)
    MainFrame.Position = UDim2.new(0.5, -170, 0.5, -160)
    MainFrame.BackgroundColor3 = Color3.fromRGB(14, 11, 25)
    MainFrame.BackgroundTransparency = 0.18
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(150, 85, 255)
    Stroke.Thickness = 1.5
    Stroke.Parent = MainFrame

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(10, 8, 18)
    TopBar.BackgroundTransparency = 0.25
    TopBar.Parent = MainFrame
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -85, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "<b>BRINELAND</b> <font color=\"#00E5FF\">TAXI BOSS HUB</font>"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 13
    Title.RichText = true
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.fromOffset(28, 28)
    MinimizeBtn.Position = UDim2.new(1, -64, 0.5, -14)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 40, 80)
    MinimizeBtn.Text = "<b>–</b>"
    MinimizeBtn.TextColor3 = Color3.fromRGB(0, 229, 255)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.TextSize = 16
    MinimizeBtn.RichText = true
    MinimizeBtn.Parent = TopBar
    Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.fromOffset(28, 28)
    CloseBtn.Position = UDim2.new(1, -32, 0.5, -14)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 35, 70)
    CloseBtn.Text = "<b>X</b>"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 13
    CloseBtn.RichText = true
    CloseBtn.Parent = TopBar
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

    local Container = Instance.new("ScrollingFrame")
    Container.Size = UDim2.new(1, -12, 1, -48)
    Container.Position = UDim2.new(0, 6, 0, 44)
    Container.BackgroundTransparency = 1
    Container.ScrollBarThickness = 4
    Container.ScrollBarImageColor3 = Color3.fromRGB(0, 229, 255)
    Container.Parent = MainFrame

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 6)
    Layout.Parent = Container

    local isMinimized = false
    MinimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            Container.Visible = false
            TweenService:Create(MainFrame, TweenInfo.new(0.25), {Size = UDim2.fromOffset(340, 40)}):Play()
            MinimizeBtn.Text = "<b>+</b>"
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.25), {Size = UDim2.fromOffset(340, 320)}):Play()
            task.wait(0.15)
            Container.Visible = true
            MinimizeBtn.Text = "<b>–</b>"
        end
    end)

    local dragging, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function() dragging = false end)

    local function CreateToggle(text, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -4, 0, 40)
        frame.BackgroundColor3 = Color3.fromRGB(22, 18, 45)
        frame.BackgroundTransparency = 0.25
        frame.Parent = Container
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -55, 1, 0)
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "<b>" .. text .. "</b>"
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.RichText = true
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame

        local toggleBg = Instance.new("Frame")
        toggleBg.Size = UDim2.fromOffset(40, 20)
        toggleBg.Position = UDim2.new(1, -46, 0.5, -10)
        toggleBg.BackgroundColor3 = Color3.fromRGB(40, 35, 65)
        toggleBg.Parent = frame
        Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.fromOffset(16, 16)
        knob.Position = UDim2.new(0, 2, 0.5, -8)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
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
            TweenService:Create(knob, TweenInfo.new(0.2), {Position = active and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
            TweenService:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = active and Color3.fromRGB(0, 229, 255) or Color3.fromRGB(40, 35, 65)}):Play()
            callback(active)
        end)
    end

    local function CreateInput(text, defaultVal, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -4, 0, 40)
        frame.BackgroundColor3 = Color3.fromRGB(22, 18, 45)
        frame.BackgroundTransparency = 0.25
        frame.Parent = Container
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.65, 0, 1, 0)
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "<b>" .. text .. "</b>"
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.RichText = true
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame

        local textBox = Instance.new("TextBox")
        textBox.Size = UDim2.fromOffset(65, 24)
        textBox.Position = UDim2.new(1, -72, 0.5, -12)
        textBox.BackgroundColor3 = Color3.fromRGB(35, 28, 65)
        textBox.Text = tostring(defaultVal)
        textBox.TextColor3 = Color3.fromRGB(0, 229, 255)
        textBox.Font = Enum.Font.GothamBold
        textBox.TextSize = 11
        textBox.Parent = frame
        Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 4)

        textBox.FocusLost:Connect(function()
            local n = tonumber(textBox.Text)
            if n then callback(n) end
        end)
    end

    CreateToggle("collect part", function(state) Config.AutoCollectItems = state end)
    CreateToggle("clear ai car", function(state) Config.ClearAICars = state end)
    CreateToggle("car boost", function(state) Config.EnableCarSpeed = state end)
    CreateInput("Target Speed (KM/H)", Config.TargetKMH, function(val) Config.TargetKMH = val end)
    CreateInput("Player WalkSpeed", Config.PlayerSpeed, function(val) Config.PlayerSpeed = val end)
end

-- ============================================================
-- SCRIPT 2: STEAL AN EGG HUB
-- ============================================================
local function RunStealAnEgg()
    local TweenService     = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local Workspace        = game:GetService("Workspace")
    local RunService       = game:GetService("RunService")
    local Players          = game:GetService("Players")
    local LocalPlayer      = Players.LocalPlayer

    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    if PlayerGui:FindFirstChild("StealAnEggHubV7") then
        PlayerGui.StealAnEggHubV7:Destroy()
    end

    local Config = {
        AutoSteal            = false,
        StealMethod          = "Tween",
        TweenSpeed           = 80,
        StealWalkSpeed       = 28,
        AutoHit              = false,
        HitRange             = 12,
        AutoPlaceEgg         = false,
        AutoHatch            = false,
        AutoUpgradeTreadmill = false,
        AutoUpgradePen       = false,
        EnableSpeed          = false,
        PlayerSpeed          = 24
    }

    local function BindClick(button, callback)
        button.Active = true
        local lastClick = 0
        local function trigger()
            local now = tick()
            if now - lastClick > 0.08 then
                lastClick = now
                callback()
            end
        end
        button.MouseButton1Click:Connect(trigger)
        button.Activated:Connect(trigger)
    end

    local function GetMyPlot()
        local plots = Workspace:FindFirstChild("Plots")
        if not plots then return nil end

        for _, plot in ipairs(plots:GetChildren()) do
            local owner = plot:FindFirstChild("Owner") or plot:FindFirstChild("OwnerValue") or plot:FindFirstChild("Player")
            if owner and (owner.Value == LocalPlayer or owner.Value == LocalPlayer.Name) then
                return plot
            end
            for _, desc in ipairs(plot:GetDescendants()) do
                if desc:IsA("TextLabel") and (desc.Text:find(LocalPlayer.Name) or desc.Text:find(LocalPlayer.DisplayName)) then
                    return plot
                end
            end
        end
        return plots:FindFirstChild("1") or plots:GetChildren()[1]
    end

    local function GetSafeZoneCFrame()
        local myPlot = GetMyPlot()
        if myPlot then
            local treadmill = myPlot:FindFirstChild("TreadmillUpgrade") or myPlot:FindFirstChild("Treadmill")
            if treadmill then
                local base = treadmill:FindFirstChildWhichIsA("BasePart", true)
                if base then return base.CFrame + Vector3.new(0, 4, 0) end
            end
            local plotBase = myPlot:FindFirstChildWhichIsA("BasePart")
            if plotBase then return plotBase.CFrame + Vector3.new(0, 5, 0) end
        end
        local char = LocalPlayer.Character
        return char and char:FindFirstChild("HumanoidRootPart") and char.HumanoidRootPart.CFrame or CFrame.new(0, 10, 0)
    end

    local function TouchPart(part)
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and part and part:IsA("BasePart") then
            pcall(function()
                if firetouchinterest then
                    firetouchinterest(hrp, part, 0)
                    task.wait(0.02)
                    firetouchinterest(hrp, part, 1)
                end
            end)
        end
    end

    local function ClickButton(button)
        pcall(function()
            if firesignal then
                firesignal(button.MouseButton1Click)
                firesignal(button.Activated)
            else
                for _, conn in ipairs(getconnections(button.MouseButton1Click)) do conn:Fire() end
                for _, conn in ipairs(getconnections(button.Activated)) do conn:Fire() end
            end
        end)
    end

    local function MoveToTarget(targetCFrame)
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp then return end

        local distance = (hrp.Position - targetCFrame.Position).Magnitude
        if distance < 3 then return end

        if Config.StealMethod == "Tween" then
            local duration = math.max(0.05, distance / math.max(10, Config.TweenSpeed))
            local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
            local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
            tween:Play()
            tween.Completed:Wait()
        elseif Config.StealMethod == "Walk" then
            if hum then
                local prevSpeed = hum.WalkSpeed
                hum.WalkSpeed = Config.StealWalkSpeed
                hum:MoveTo(targetCFrame.Position)
                local timeout = 0
                repeat
                    task.wait(0.1)
                    timeout = timeout + 0.1
                until (hrp.Position - targetCFrame.Position).Magnitude <= 4 or timeout >= (distance / math.max(5, Config.StealWalkSpeed))
                if not Config.EnableSpeed then hum.WalkSpeed = prevSpeed end
            end
        end
    end

    local function GetEggTargets()
        local targets = {}
        local myPlot = GetMyPlot()

        local areaSlots = Workspace:FindFirstChild("AreaEggSlotsClient")
        if areaSlots then
            for _, model in ipairs(areaSlots:GetChildren()) do
                local hitbox = model:FindFirstChild("Hitbox") or model:FindFirstChildWhichIsA("BasePart", true)
                if hitbox then table.insert(targets, {Part = hitbox, Model = model}) end
            end
        end

        local sammyMap = Workspace:FindFirstChild("SammyEventMap")
        if sammyMap then
            for _, model in ipairs(sammyMap:GetChildren()) do
                local hitbox = model:FindFirstChild("Hitbox", true) or model:FindFirstChildWhichIsA("BasePart", true)
                if hitbox then table.insert(targets, {Part = hitbox, Model = model}) end
            end
        end

        local plots = Workspace:FindFirstChild("Plots")
        if plots then
            for _, plot in ipairs(plots:GetChildren()) do
                if plot ~= myPlot then
                    for _, obj in ipairs(plot:GetDescendants()) do
                        if obj:IsA("Model") and obj.Name:lower():find("egg") then
                            local hitbox = obj:FindFirstChild("Hitbox") or obj:FindFirstChildWhichIsA("BasePart", true)
                            if hitbox then table.insert(targets, {Part = hitbox, Model = obj}) end
                        end
                    end
                end
            end
        end
        return targets
    end

    RunService.Stepped:Connect(function()
        for _, prompt in ipairs(Workspace:GetDescendants()) do
            if prompt:IsA("ProximityPrompt") then prompt.HoldDuration = 0 end
        end
        if Config.EnableSpeed then
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = Config.PlayerSpeed end
        end
    end)

    task.spawn(function()
        while true do
            task.wait(0.1)
            if Config.AutoSteal then
                local targets = GetEggTargets()
                for _, target in ipairs(targets) do
                    if not Config.AutoSteal then break end
                    local hitboxPart = target.Part
                    if hitboxPart and hitboxPart.Parent then
                        MoveToTarget(hitboxPart.CFrame + Vector3.new(0, 2, 0))
                        TouchPart(hitboxPart)
                        local prompt = target.Model:FindFirstChildWhichIsA("ProximityPrompt", true) or hitboxPart:FindFirstChildWhichIsA("ProximityPrompt")
                        if prompt then
                            prompt.HoldDuration = 0
                            pcall(function() fireproximityprompt(prompt) end)
                        end
                        task.wait(0.15)
                        MoveToTarget(GetSafeZoneCFrame())
                        task.wait(0.2)
                    end
                end
            end
        end
    end)

    task.spawn(function()
        while task.wait(0.08) do
            if Config.AutoHit then
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local tool = char and char:FindFirstChildOfClass("Tool")
                if hrp and tool then
                    local targetFound = false
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if (obj:IsA("Model") and obj ~= char and obj:FindFirstChildOfClass("Humanoid")) or (obj.Name == "Hitbox" and obj.Parent ~= char and not obj:IsDescendantOf(char)) then
                            local targetPart = obj:IsA("Model") and (obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")) or obj
                            if targetPart and targetPart:IsA("BasePart") then
                                if (targetPart.Position - hrp.Position).Magnitude <= Config.HitRange then
                                    targetFound = true
                                    break
                                end
                            end
                        end
                    end
                    if targetFound then tool:Activate() end
                end
            end
        end
    end)

    task.spawn(function()
        while task.wait(0.25) do
            if Config.AutoPlaceEgg then
                local char = LocalPlayer.Character
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                if char and backpack then
                    local eggTool = nil
                    for _, tool in ipairs(backpack:GetChildren()) do
                        if tool:IsA("Tool") and (tool.Name:lower():find("egg") or tool.Name:lower():find("steal")) then
                            eggTool = tool
                            tool.Parent = char
                            break
                        end
                    end
                    if not eggTool then
                        for _, tool in ipairs(char:GetChildren()) do
                            if tool:IsA("Tool") and (tool.Name:lower():find("egg") or tool.Name:lower():find("steal")) then
                                eggTool = tool
                                break
                            end
                        end
                    end
                    if eggTool then
                        local myPlot = GetMyPlot()
                        if myPlot then
                            MoveToTarget(GetSafeZoneCFrame())
                            task.wait(0.1)
                            eggTool:Activate()
                            for _, desc in ipairs(myPlot:GetDescendants()) do
                                if desc:IsA("ProximityPrompt") then
                                    desc.HoldDuration = 0
                                    pcall(function() fireproximityprompt(desc) end)
                                elseif desc:IsA("BasePart") and (desc.Name:lower():find("place") or desc.Name:lower():find("slot") or desc.Name:lower():find("hatch")) then
                                    TouchPart(desc)
                                end
                            end
                        end
                    end
                end
            end
        end
    end)

    task.spawn(function()
        while task.wait(0.25) do
            if Config.AutoHatch then
                for _, descendant in ipairs(PlayerGui:GetDescendants()) do
                    if descendant:IsA("TextButton") or descendant:IsA("ImageButton") then
                        local name = descendant.Name:lower()
                        local text = (descendant:IsA("TextButton") and descendant.Text or ""):lower()
                        if name:find("hatch") or text:find("hatch") or name:find("claim") or text:find("claim") or text:find("open") then
                            ClickButton(descendant)
                        end
                    end
                end
                local myPlot = GetMyPlot()
                if myPlot then
                    for _, desc in ipairs(myPlot:GetDescendants()) do
                        if desc:IsA("ProximityPrompt") then
                            local actText = desc.ActionText:lower()
                            local objText = desc.ObjectText:lower()
                            if actText:find("hatch") or objText:find("hatch") or actText:find("open") then
                                desc.HoldDuration = 0
                                pcall(function() fireproximityprompt(desc) end)
                            end
                        end
                    end
                end
            end
        end
    end)

    task.spawn(function()
        while task.wait(0.3) do
            local myPlot = GetMyPlot()
            if myPlot then
                if Config.AutoUpgradeTreadmill then
                    local treadmillModel = myPlot:FindFirstChild("TreadmillUpgrade") or myPlot:FindFirstChild("Treadmill")
                    if treadmillModel then
                        for _, part in ipairs(treadmillModel:GetDescendants()) do
                            if part:IsA("BasePart") then TouchPart(part)
                            elseif part:IsA("TextButton") or part:IsA("ImageButton") then ClickButton(part) end
                        end
                    end
                end
                if Config.AutoUpgradePen then
                    local penModel = myPlot:FindFirstChild("PlotUpgrade") or myPlot:FindFirstChild("PenUpgrade") or myPlot:FindFirstChild("Plot")
                    if penModel then
                        for _, part in ipairs(penModel:GetDescendants()) do
                            if part:IsA("BasePart") then TouchPart(part)
                            elseif part:IsA("TextButton") or part:IsA("ImageButton") then ClickButton(part) end
                        end
                    end
                end
            end
        end
    end)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "StealAnEggHubV7"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    local OpenToggleBtn = Instance.new("TextButton")
    OpenToggleBtn.Size = UDim2.fromOffset(50, 50)
    OpenToggleBtn.Position = UDim2.new(0, 15, 0.5, -25)
    OpenToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 240)
    OpenToggleBtn.BackgroundTransparency = 0.15
    OpenToggleBtn.Text = "<b>HUB</b>"
    OpenToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenToggleBtn.Font = Enum.Font.GothamBold
    OpenToggleBtn.TextSize = 13
    OpenToggleBtn.RichText = true
    OpenToggleBtn.Active = true
    OpenToggleBtn.Parent = ScreenGui
    Instance.new("UICorner", OpenToggleBtn).CornerRadius = UDim.new(1, 0)

    local ToggleStroke = Instance.new("UIStroke")
    ToggleStroke.Color = Color3.fromRGB(255, 255, 255)
    ToggleStroke.Thickness = 2
    ToggleStroke.Parent = OpenToggleBtn

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.fromOffset(360, 430)
    MainFrame.Position = UDim2.new(0.5, -180, 0.5, -215)
    MainFrame.BackgroundColor3 = Color3.fromRGB(14, 12, 26)
    MainFrame.BackgroundTransparency = 0.18
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

    local FrameStroke = Instance.new("UIStroke")
    FrameStroke.Color = Color3.fromRGB(0, 210, 255)
    FrameStroke.Thickness = 2
    FrameStroke.Parent = MainFrame

    local isGuiOpen = true
    local function SetGuiState(state)
        isGuiOpen = state
        if isGuiOpen then
            MainFrame.Visible = true
            MainFrame:TweenSizeAndPosition(UDim2.fromOffset(360, 430), UDim2.new(0.5, -180, 0.5, -215), Enum.EasingDirection.Out, Enum.EasingStyle.Back, 0.3, true)
        else
            MainFrame:TweenSizeAndPosition(UDim2.fromOffset(0, 0), UDim2.new(0.5, 0, 0.5, 0), Enum.EasingDirection.In, Enum.EasingStyle.Back, 0.25, true, function()
                if not isGuiOpen then MainFrame.Visible = false end
            end)
        end
    end

    BindClick(OpenToggleBtn, function() SetGuiState(not isGuiOpen) end)

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(10, 8, 18)
    TopBar.BackgroundTransparency = 0.25
    TopBar.Parent = MainFrame

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -70, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "<b>BRINELAND</b> <font color=\"#00E5FF\">STEAL AN EGG</font>"
    Title.TextColor3 = Color3.fromRGB(0, 225, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 13
    Title.RichText = true
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.fromOffset(26, 26)
    CloseBtn.Position = UDim2.new(1, -32, 0.5, -13)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(225, 35, 75)
    CloseBtn.Text = "<b>X</b>"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 13
    CloseBtn.RichText = true
    CloseBtn.Parent = TopBar
    Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

    BindClick(CloseBtn, function() SetGuiState(false) end)

    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1, -12, 0, 32)
    TabBar.Position = UDim2.new(0, 6, 0, 44)
    TabBar.BackgroundTransparency = 1
    TabBar.Parent = MainFrame

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.Padding = UDim.new(0, 4)
    TabLayout.Parent = TabBar

    local TabFrames = {}
    local function CreateTab(tabName)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(0.24, 0, 1, 0)
        tabBtn.BackgroundColor3 = Color3.fromRGB(24, 18, 42)
        tabBtn.BackgroundTransparency = 0.3
        tabBtn.Text = "<b>" .. tabName .. "</b>"
        tabBtn.TextColor3 = Color3.fromRGB(180, 180, 210)
        tabBtn.Font = Enum.Font.GothamBold
        tabBtn.TextSize = 10
        tabBtn.RichText = true
        tabBtn.Parent = TabBar
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

        local container = Instance.new("ScrollingFrame")
        container.Size = UDim2.new(1, -12, 1, -86)
        container.Position = UDim2.new(0, 6, 0, 80)
        container.BackgroundTransparency = 1
        container.ScrollBarThickness = 3
        container.ScrollBarImageColor3 = Color3.fromRGB(0, 210, 255)
        container.Visible = false
        container.Parent = MainFrame

        local listLayout = Instance.new("UIListLayout")
        listLayout.Padding = UDim.new(0, 6)
        listLayout.Parent = container

        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            container.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 12)
        end)

        TabFrames[tabName] = { Button = tabBtn, Container = container }

        BindClick(tabBtn, function()
            for _, data in pairs(TabFrames) do
                data.Container.Visible = false
                data.Button.BackgroundColor3 = Color3.fromRGB(24, 18, 42)
                data.Button.TextColor3 = Color3.fromRGB(180, 180, 210)
            end
            container.Visible = true
            tabBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 240)
            tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        return container
    end

    local StealTab    = CreateTab("Steal")
    local CombatTab   = CreateTab("Combat")
    local UpgradesTab = CreateTab("Upgrades")
    local PlayerTab   = CreateTab("Player")

    TabFrames["Steal"].Container.Visible = true
    TabFrames["Steal"].Button.BackgroundColor3 = Color3.fromRGB(0, 160, 240)
    TabFrames["Steal"].Button.TextColor3 = Color3.fromRGB(255, 255, 255)

    local dragging, dragStart, startPos
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function() dragging = false end)

    local function CreateToggle(parent, text, configKey)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -4, 0, 38)
        frame.BackgroundColor3 = Color3.fromRGB(22, 18, 38)
        frame.BackgroundTransparency = 0.25
        frame.Parent = parent
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -55, 1, 0)
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "<b>" .. text .. "</b>"
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.RichText = true
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame

        local toggleBg = Instance.new("Frame")
        toggleBg.Size = UDim2.fromOffset(40, 20)
        toggleBg.Position = UDim2.new(1, -46, 0.5, -10)
        toggleBg.BackgroundColor3 = Config[configKey] and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(45, 35, 65)
        toggleBg.Parent = frame
        Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.fromOffset(16, 16)
        knob.Position = Config[configKey] and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        knob.Parent = toggleBg
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.Parent = frame

        BindClick(btn, function()
            Config[configKey] = not Config[configKey]
            local state = Config[configKey]
            TweenService:Create(knob, TweenInfo.new(0.18), {Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
            TweenService:Create(toggleBg, TweenInfo.new(0.18), {BackgroundColor3 = state and Color3.fromRGB(0, 190, 255) or Color3.fromRGB(45, 35, 65)}):Play()
        end)
    end

    local function CreateSelector(parent, text, options, configKey)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -4, 0, 38)
        frame.BackgroundColor3 = Color3.fromRGB(22, 18, 38)
        frame.BackgroundTransparency = 0.25
        frame.Parent = parent
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.5, 0, 1, 0)
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "<b>" .. text .. "</b>"
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.RichText = true
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.fromOffset(100, 24)
        btn.Position = UDim2.new(1, -106, 0.5, -12)
        btn.BackgroundColor3 = Color3.fromRGB(35, 28, 58)
        btn.Text = "<b>" .. tostring(Config[configKey]) .. "</b>"
        btn.TextColor3 = Color3.fromRGB(0, 225, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.RichText = true
        btn.Parent = frame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

        BindClick(btn, function()
            local currentVal = Config[configKey]
            local idx = 1
            for i, option in ipairs(options) do
                if option == currentVal then idx = i break end
            end
            idx = (idx % #options) + 1
            Config[configKey] = options[idx]
            btn.Text = "<b>" .. tostring(options[idx]) .. "</b>"
        end)
    end

    local function CreateInput(parent, text, configKey)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -4, 0, 38)
        frame.BackgroundColor3 = Color3.fromRGB(22, 18, 38)
        frame.BackgroundTransparency = 0.25
        frame.Parent = parent
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.65, 0, 1, 0)
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "<b>" .. text .. "</b>"
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.RichText = true
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame

        local textBox = Instance.new("TextBox")
        textBox.Size = UDim2.fromOffset(60, 24)
        textBox.Position = UDim2.new(1, -66, 0.5, -12)
        textBox.BackgroundColor3 = Color3.fromRGB(35, 28, 58)
        textBox.Text = tostring(Config[configKey])
        textBox.TextColor3 = Color3.fromRGB(0, 225, 255)
        textBox.Font = Enum.Font.GothamBold
        textBox.TextSize = 11
        textBox.Parent = frame
        Instance.new("UICorner", textBox).CornerRadius = UDim.new(0, 6)

        textBox.FocusLost:Connect(function()
            local val = tonumber(textBox.Text)
            if val then Config[configKey] = val end
        end)
    end

    CreateToggle(StealTab, "Auto Steal & Safe Zone Return", "AutoSteal")
    CreateSelector(StealTab, "Steal Method", {"Tween", "Walk"}, "StealMethod")
    CreateInput(StealTab, "Tween Speed Value", "TweenSpeed")
    CreateInput(StealTab, "Steal Walk Speed", "StealWalkSpeed")
    CreateToggle(StealTab, "Auto Place Egg", "AutoPlaceEgg")
    CreateToggle(StealTab, "Auto Hatch Egg", "AutoHatch")

    CreateToggle(CombatTab, "Auto Hit (Equipped Bat)", "AutoHit")
    CreateInput(CombatTab, "Hit Range (Studs)", "HitRange")

    CreateToggle(UpgradesTab, "Auto Upgrade Treadmill", "AutoUpgradeTreadmill")
    CreateToggle(UpgradesTab, "Auto Upgrade Pen", "AutoUpgradePen")

    CreateToggle(PlayerTab, "Enable Speed Boost", "EnableSpeed")
    CreateInput(PlayerTab, "Player WalkSpeed", "PlayerSpeed")
end

-- ============================================================
-- SCRIPT 3: UNIVERSAL HUB (WITH INTEGRATED INFO & 3D BODY PREVIEW)
-- ============================================================
local function RunUniversalScript()
    local TweenService     = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local Workspace        = game:GetService("Workspace")
    local RunService       = game:GetService("RunService")
    local Lighting         = game:GetService("Lighting")
    local Players          = game:GetService("Players")
    local Stats            = game:GetService("Stats")
    local LogService       = game:GetService("LogService")
    local LocalPlayer      = Players.LocalPlayer
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

    -- Universal Bypassed Fly Engine (No floating buttons)
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
            highlight.FillColor = Color3.fromRGB(0, 229, 255)
            highlight.OutlineColor = Color3.fromRGB(150, 85, 255)
            highlight.FillTransparency = 0.5
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
            nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            nameLabel.Font = Enum.Font.GothamBold
            nameLabel.TextSize = 11
            nameLabel.RichText = true
            nameLabel.Parent = billboard

            local infoLabel = Instance.new("TextLabel")
            infoLabel.Size = UDim2.new(1, 0, 0.5, 0)
            infoLabel.Position = UDim2.new(0, 0, 0.5, 0)
            infoLabel.BackgroundTransparency = 1
            infoLabel.TextColor3 = Color3.fromRGB(0, 229, 255)
            infoLabel.Font = Enum.Font.Gotham
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

    -- ============================================================
    -- MAIN GUI (DIMENSIONS: 360x440)
    -- ============================================================
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BrinelandUniversalHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.fromOffset(360, 440)
    MainFrame.Position = UDim2.new(0.5, -180, 0.5, -220)
    MainFrame.BackgroundColor3 = Color3.fromRGB(14, 11, 25)
    MainFrame.BackgroundTransparency = 0.18
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

    local FrameStroke = Instance.new("UIStroke")
    FrameStroke.Color = Color3.fromRGB(0, 229, 255)
    FrameStroke.Thickness = 1.5
    FrameStroke.Parent = MainFrame

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 40)
    TopBar.BackgroundColor3 = Color3.fromRGB(10, 8, 18)
    TopBar.BackgroundTransparency = 0.25
    TopBar.Parent = MainFrame
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -85, 1, 0)
    Title.Position = UDim2.new(0, 10, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "<b>BRINELAND</b> <font color=\"#00E5FF\">UNIVERSAL HUB</font>"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 13
    Title.RichText = true
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.fromOffset(28, 28)
    MinimizeBtn.Position = UDim2.new(1, -64, 0.5, -14)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 40, 80)
    MinimizeBtn.Text = "<b>–</b>"
    MinimizeBtn.TextColor3 = Color3.fromRGB(0, 229, 255)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.TextSize = 16
    MinimizeBtn.RichText = true
    MinimizeBtn.Parent = TopBar
    Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0, 6)

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.fromOffset(28, 28)
    CloseBtn.Position = UDim2.new(1, -32, 0.5, -14)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 35, 70)
    CloseBtn.Text = "<b>X</b>"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.TextSize = 13
    CloseBtn.RichText = true
    CloseBtn.Parent = TopBar
    CloseBtn.MouseButton1Click:Connect(function()
        hubAlive = false
        for _, c in ipairs(hubConns) do pcall(function() c:Disconnect() end) end
        DisableFly()
        ScreenGui:Destroy()
    end)

    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1, -12, 0, 32)
    TabBar.Position = UDim2.new(0, 6, 0, 44)
    TabBar.BackgroundTransparency = 1
    TabBar.Parent = MainFrame

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.Padding = UDim.new(0, 2)
    TabLayout.Parent = TabBar

    local TabFrames = {}
    local function CreateTab(tabName)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(0.162, 0, 1, 0)
        tabBtn.BackgroundColor3 = Color3.fromRGB(24, 18, 42)
        tabBtn.BackgroundTransparency = 0.3
        tabBtn.Text = "<b>" .. tabName .. "</b>"
        tabBtn.TextColor3 = Color3.fromRGB(180, 180, 210)
        tabBtn.Font = Enum.Font.GothamBold
        tabBtn.TextSize = 9
        tabBtn.RichText = true
        tabBtn.Parent = TabBar
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 6)

        local container = Instance.new("ScrollingFrame")
        container.Size = UDim2.new(1, -12, 1, -86)
        container.Position = UDim2.new(0, 6, 0, 80)
        container.BackgroundTransparency = 1
        container.ScrollBarThickness = 4
        container.ScrollBarImageColor3 = Color3.fromRGB(0, 229, 255)
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
            for _, data in pairs(TabFrames) do
                data.Container.Visible = false
                data.Button.BackgroundColor3 = Color3.fromRGB(24, 18, 42)
                data.Button.TextColor3 = Color3.fromRGB(180, 180, 210)
            end
            container.Visible = true
            tabBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 240)
            tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        end)

        return container
    end

    -- INFO TAB CREATED FIRST (LEFT SIDE)
    local InfoTab      = CreateTab("Info")
    local TeleportsTab = CreateTab("Teleports")
    local PlayersTab   = CreateTab("Player")
    local PlayerTab    = CreateTab("Cheats")
    local VisualsTab   = CreateTab("Visuals")
    local KeyTab       = CreateTab("Key")

    TabFrames["Info"].Container.Visible = true
    TabFrames["Info"].Button.BackgroundColor3 = Color3.fromRGB(0, 160, 240)
    TabFrames["Info"].Button.TextColor3 = Color3.fromRGB(255, 255, 255)

    local isMinimized = false
    MinimizeBtn.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            for _, data in pairs(TabFrames) do data.Container.Visible = false end
            TabBar.Visible = false
            TweenService:Create(MainFrame, TweenInfo.new(0.25), {Size = UDim2.fromOffset(360, 40)}):Play()
            MinimizeBtn.Text = "<b>+</b>"
        else
            TweenService:Create(MainFrame, TweenInfo.new(0.25), {Size = UDim2.fromOffset(360, 440)}):Play()
            task.wait(0.15)
            TabBar.Visible = true
            for _, data in pairs(TabFrames) do
                if data.Button.BackgroundColor3 == Color3.fromRGB(0, 160, 240) then
                    data.Container.Visible = true
                end
            end
            MinimizeBtn.Text = "<b>–</b>"
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
        frame.BackgroundColor3 = Color3.fromRGB(22, 18, 45)
        frame.BackgroundTransparency = 0.25
        frame.Parent = parentContainer
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = "<b>" .. text .. "</b>"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.RichText = true
        btn.Parent = frame

        btn.MouseButton1Click:Connect(callback)
    end

    local function CreateToggle(parentContainer, text, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -4, 0, 40)
        frame.BackgroundColor3 = Color3.fromRGB(22, 18, 45)
        frame.BackgroundTransparency = 0.25
        frame.Parent = parentContainer
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -55, 1, 0)
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "<b>" .. text .. "</b>"
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.RichText = true
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame

        local toggleBg = Instance.new("Frame")
        toggleBg.Size = UDim2.fromOffset(40, 20)
        toggleBg.Position = UDim2.new(1, -46, 0.5, -10)
        toggleBg.BackgroundColor3 = Color3.fromRGB(40, 35, 65)
        toggleBg.Parent = frame
        Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

        local knob = Instance.new("Frame")
        knob.Size = UDim2.fromOffset(16, 16)
        knob.Position = UDim2.new(0, 2, 0.5, -8)
        knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
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
            TweenService:Create(knob, TweenInfo.new(0.2), {Position = active and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
            TweenService:Create(toggleBg, TweenInfo.new(0.2), {BackgroundColor3 = active and Color3.fromRGB(0, 229, 255) or Color3.fromRGB(40, 35, 65)}):Play()
            callback(active)
        end)
    end

    local function CreateSlider(parentContainer, text, minVal, maxVal, defaultVal, showNumbers, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -4, 0, 48)
        frame.BackgroundColor3 = Color3.fromRGB(22, 18, 45)
        frame.BackgroundTransparency = 0.25
        frame.Parent = parentContainer
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -20, 0, 20)
        lbl.Position = UDim2.new(0, 10, 0, 4)
        lbl.BackgroundTransparency = 1
        
        if showNumbers then
            lbl.Text = "<b>" .. text .. ": <font color=\"#00E5FF\">" .. tostring(defaultVal) .. "</font></b>"
        else
            lbl.Text = "<b>" .. text .. "</b>"
        end

        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.RichText = true
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame

        local track = Instance.new("Frame")
        track.Size = UDim2.new(1, -20, 0, 8)
        track.Position = UDim2.new(0, 10, 0, 28)
        track.BackgroundColor3 = Color3.fromRGB(35, 28, 65)
        track.Parent = frame
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

        local fill = Instance.new("Frame")
        local startPct = math.clamp((defaultVal - minVal) / (maxVal - minVal), 0, 1)
        fill.Size = UDim2.new(startPct, 0, 1, 0)
        fill.BackgroundColor3 = Color3.fromRGB(0, 229, 255)
        fill.Parent = track
        Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

        local sliding = false
        local function UpdateValue(input)
            local pos = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(pos, 0, 1, 0)
            local val = math.floor(minVal + (maxVal - minVal) * pos)
            if showNumbers then
                lbl.Text = "<b>" .. text .. ": <font color=\"#00E5FF\">" .. tostring(val) .. "</font></b>"
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
        card.BackgroundColor3 = Color3.fromRGB(28, 22, 55)
        card.BackgroundTransparency = 0.25
        card.Parent = TeleportsTab
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -35, 0, 26)
        label.Position = UDim2.new(0, 8, 0, 4)
        label.BackgroundTransparency = 1
        label.Text = "<b>" .. posName .. "</b>"
        label.TextColor3 = Color3.fromRGB(0, 229, 255)
        label.Font = Enum.Font.GothamBold
        label.TextSize = 10
        label.RichText = true
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = card

        local deleteBtn = Instance.new("TextButton")
        deleteBtn.Size = UDim2.fromOffset(24, 24)
        deleteBtn.Position = UDim2.new(1, -28, 0, 4)
        deleteBtn.BackgroundColor3 = Color3.fromRGB(220, 35, 70)
        deleteBtn.Text = "<b>X</b>"
        deleteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        deleteBtn.Font = Enum.Font.GothamBold
        deleteBtn.TextSize = 10
        deleteBtn.RichText = true
        deleteBtn.Parent = card
        Instance.new("UICorner", deleteBtn).CornerRadius = UDim.new(0, 4)
        deleteBtn.MouseButton1Click:Connect(function() card:Destroy() end)

        local tpBtn = Instance.new("TextButton")
        tpBtn.Size = UDim2.new(0.32, -4, 0, 36)
        tpBtn.Position = UDim2.new(0, 4, 0, 36)
        tpBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 220)
        tpBtn.Text = "<b>TP</b>"
        tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tpBtn.Font = Enum.Font.GothamBold
        tpBtn.TextSize = 11
        tpBtn.RichText = true
        tpBtn.Parent = card
        Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)
        tpBtn.MouseButton1Click:Connect(function() SafeTeleport(savedPos) end)

        local walkBtn = Instance.new("TextButton")
        walkBtn.Size = UDim2.new(0.32, -4, 0, 36)
        walkBtn.Position = UDim2.new(0.34, 0, 0, 36)
        walkBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 90)
        walkBtn.Text = "<b>Walk</b>"
        walkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        walkBtn.Font = Enum.Font.GothamBold
        walkBtn.TextSize = 11
        walkBtn.RichText = true
        walkBtn.Parent = card
        Instance.new("UICorner", walkBtn).CornerRadius = UDim.new(0, 6)
        walkBtn.MouseButton1Click:Connect(function() WalkToPosition(savedPos) end)

        local tweenBtn = Instance.new("TextButton")
        tweenBtn.Size = UDim2.new(0.32, -4, 0, 36)
        tweenBtn.Position = UDim2.new(0.68, -4, 0, 36)
        tweenBtn.BackgroundColor3 = Color3.fromRGB(150, 60, 220)
        tweenBtn.Text = "<b>Tween</b>"
        tweenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tweenBtn.Font = Enum.Font.GothamBold
        tweenBtn.TextSize = 11
        tweenBtn.RichText = true
        tweenBtn.Parent = card
        Instance.new("UICorner", tweenBtn).CornerRadius = UDim.new(0, 6)
        tweenBtn.MouseButton1Click:Connect(function() TweenToPosition(savedPos) end)
    end)

    -- PLAYERS TAB
    local selectedTarget = nil

    local selectorBtn = Instance.new("TextButton")
    selectorBtn.Size = UDim2.new(1, -4, 0, 38)
    selectorBtn.BackgroundColor3 = Color3.fromRGB(28, 22, 55)
    selectorBtn.BackgroundTransparency = 0.25
    selectorBtn.Text = "<b>Selected Player: <font color=\"#00E5FF\">None (Click to choose)</font></b>"
    selectorBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    selectorBtn.Font = Enum.Font.GothamBold
    selectorBtn.TextSize = 11
    selectorBtn.RichText = true
    selectorBtn.Parent = PlayersTab
    Instance.new("UICorner", selectorBtn).CornerRadius = UDim.new(0, 6)

    local dropdownContainer = Instance.new("ScrollingFrame")
    dropdownContainer.Size = UDim2.new(1, -4, 0, 140)
    dropdownContainer.BackgroundColor3 = Color3.fromRGB(18, 14, 35)
    dropdownContainer.BackgroundTransparency = 0.3
    dropdownContainer.ScrollBarThickness = 3
    dropdownContainer.Visible = false
    dropdownContainer.Parent = PlayersTab
    Instance.new("UICorner", dropdownContainer).CornerRadius = UDim.new(0, 6)

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
                pBtn.BackgroundColor3 = Color3.fromRGB(35, 28, 65)
                pBtn.Text = "<b>" .. plr.DisplayName .. " (@" .. plr.Name .. ")</b>"
                pBtn.TextColor3 = Color3.fromRGB(220, 220, 240)
                pBtn.Font = Enum.Font.GothamBold
                pBtn.TextSize = 10
                pBtn.RichText = true
                pBtn.Parent = dropdownContainer
                Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 4)

                pBtn.MouseButton1Click:Connect(function()
                    selectedTarget = plr
                    selectorBtn.Text = "<b>Selected Player: <font color=\"#00E5FF\">" .. plr.Name .. "</font></b>"
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
    actionCard.Size = UDim2.new(1, -4, 0, 50)
    actionCard.BackgroundColor3 = Color3.fromRGB(22, 18, 45)
    actionCard.BackgroundTransparency = 0.25
    actionCard.Parent = PlayersTab
    Instance.new("UICorner", actionCard).CornerRadius = UDim.new(0, 6)

    local tpBtn = Instance.new("TextButton")
    tpBtn.Size = UDim2.new(0.32, -4, 1, -8)
    tpBtn.Position = UDim2.new(0, 4, 0, 4)
    tpBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 220)
    tpBtn.Text = "<b>Tp</b>"
    tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tpBtn.Font = Enum.Font.GothamBold
    tpBtn.TextSize = 11
    tpBtn.RichText = true
    tpBtn.Parent = actionCard
    Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)

    tpBtn.MouseButton1Click:Connect(function()
        if selectedTarget and selectedTarget.Character then
            local targetRoot = selectedTarget.Character:FindFirstChild("HumanoidRootPart") or selectedTarget.Character.PrimaryPart
            if targetRoot then SafeTeleport(targetRoot.CFrame + Vector3.new(0, 3, 0)) end
        end
    end)

    local walkBtn = Instance.new("TextButton")
    walkBtn.Size = UDim2.new(0.32, -4, 1, -8)
    walkBtn.Position = UDim2.new(0.34, 0, 0, 4)
    walkBtn.BackgroundColor3 = Color3.fromRGB(50, 180, 90)
    walkBtn.Text = "<b>Walk</b>"
    walkBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    walkBtn.Font = Enum.Font.GothamBold
    walkBtn.TextSize = 11
    walkBtn.RichText = true
    walkBtn.Parent = actionCard
    Instance.new("UICorner", walkBtn).CornerRadius = UDim.new(0, 6)

    walkBtn.MouseButton1Click:Connect(function()
        if selectedTarget and selectedTarget.Character then
            local targetRoot = selectedTarget.Character:FindFirstChild("HumanoidRootPart") or selectedTarget.Character.PrimaryPart
            if targetRoot then WalkToPosition(targetRoot.CFrame + Vector3.new(0, 3, 0)) end
        end
    end)

    local tweenBtn = Instance.new("TextButton")
    tweenBtn.Size = UDim2.new(0.32, -4, 1, -8)
    tweenBtn.Position = UDim2.new(0.68, -4, 0, 4)
    tweenBtn.BackgroundColor3 = Color3.fromRGB(150, 60, 220)
    tweenBtn.Text = "<b>Tween</b>"
    tweenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tweenBtn.Font = Enum.Font.GothamBold
    tweenBtn.TextSize = 11
    tweenBtn.RichText = true
    tweenBtn.Parent = actionCard
    Instance.new("UICorner", tweenBtn).CornerRadius = UDim.new(0, 6)

    tweenBtn.MouseButton1Click:Connect(function()
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
        frame.BackgroundColor3 = Color3.fromRGB(22, 18, 45)
        frame.BackgroundTransparency = 0.25
        frame.Parent = KeyTab
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, -95, 1, 0)
        lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = "<b>" .. item.Name .. "</b>"
        lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 11
        lbl.RichText = true
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame

        local bindBtn = Instance.new("TextButton")
        bindBtn.Size = UDim2.fromOffset(80, 26)
        bindBtn.Position = UDim2.new(1, -86, 0.5, -13)
        bindBtn.BackgroundColor3 = Color3.fromRGB(35, 28, 65)
        bindBtn.Text = "<b>[ None ]</b>"
        bindBtn.TextColor3 = Color3.fromRGB(0, 229, 255)
        bindBtn.Font = Enum.Font.GothamBold
        bindBtn.TextSize = 10
        bindBtn.RichText = true
        bindBtn.Parent = frame
        Instance.new("UICorner", bindBtn).CornerRadius = UDim.new(0, 4)

        local listening = false
        bindBtn.MouseButton1Click:Connect(function()
            listening = true
            bindBtn.Text = "<b>[...]</b>"
        end)

        trackConn(UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                listening = false
                Keybinds[item.Name] = input.KeyCode
                bindBtn.Text = "<b>[" .. input.KeyCode.Name .. "]</b>"
            elseif not gameProcessed and Keybinds[item.Name] and input.KeyCode == Keybinds[item.Name] then
                pcall(item.Action)
            end
        end))
    end

    -- ============================================================
    -- INFO TAB: SERVER TELEMETRY, 3D PLAYER PREVIEW & LIVE CONSOLE
    -- ============================================================
    local MAX_LOGS = 200
    local LOG_KIND = {
        OUTPUT = { color = Color3.fromRGB(245, 247, 255), hex = "#E6EAFF", label = "OUTPUT" },
        INFO   = { color = Color3.fromRGB(0, 229, 255),   hex = "#38E1FF", label = "INFO" },
        WARN   = { color = Color3.fromRGB(255, 200, 75),  hex = "#FFC84B", label = "WARN" },
        ERROR  = { color = Color3.fromRGB(255, 85, 110),  hex = "#FF5570", label = "ERROR" },
    }
    local LOG_FILTERS = { "ALL", "OUTPUT", "INFO", "WARN", "ERROR" }

    -- Top row split: Left = Live Connection Badge, Right = 3D Player Body Preview Card
    local topRowContainer = Instance.new("Frame")
    topRowContainer.Size = UDim2.new(1, -4, 0, 115)
    topRowContainer.BackgroundTransparency = 1
    topRowContainer.Parent = InfoTab

    -- Left Column (Connection & Telemetry Chips)
    local leftTelemetryCol = Instance.new("Frame")
    leftTelemetryCol.Size = UDim2.new(0.58, -4, 1, 0)
    leftTelemetryCol.BackgroundTransparency = 1
    leftTelemetryCol.Parent = topRowContainer

    local telemetryLayout = Instance.new("UIListLayout")
    telemetryLayout.Padding = UDim.new(0, 5)
    telemetryLayout.Parent = leftTelemetryCol

    local statusHeader = Instance.new("Frame")
    statusHeader.Size = UDim2.new(1, 0, 0, 32)
    statusHeader.BackgroundColor3 = Color3.fromRGB(22, 18, 45)
    statusHeader.BackgroundTransparency = 0.25
    statusHeader.Parent = leftTelemetryCol
    Instance.new("UICorner", statusHeader).CornerRadius = UDim.new(0, 6)

    local serverTitleLbl = Instance.new("TextLabel")
    serverTitleLbl.Size = UDim2.new(0.55, 0, 1, 0)
    serverTitleLbl.Position = UDim2.new(0, 8, 0, 0)
    serverTitleLbl.BackgroundTransparency = 1
    serverTitleLbl.Text = "<b>SERVER STATUS</b>"
    serverTitleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    serverTitleLbl.Font = Enum.Font.GothamBold
    serverTitleLbl.TextSize = 10
    serverTitleLbl.RichText = true
    serverTitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    serverTitleLbl.Parent = statusHeader

    local connStatusLbl = Instance.new("TextLabel")
    connStatusLbl.Size = UDim2.new(0.45, -8, 1, 0)
    connStatusLbl.Position = UDim2.new(0.55, 0, 0, 0)
    connStatusLbl.BackgroundTransparency = 1
    connStatusLbl.Text = "<b>CONNECTED</b>"
    connStatusLbl.TextColor3 = Color3.fromRGB(70, 225, 150)
    connStatusLbl.Font = Enum.Font.GothamBold
    connStatusLbl.TextSize = 9
    connStatusLbl.RichText = true
    connStatusLbl.TextXAlignment = Enum.TextXAlignment.Right
    connStatusLbl.Parent = statusHeader

    -- 2x2 Mini Stat Chips under connection header
    local miniGrid = Instance.new("Frame")
    miniGrid.Size = UDim2.new(1, 0, 0, 76)
    miniGrid.BackgroundTransparency = 1
    miniGrid.Parent = leftTelemetryCol

    local miniLayout = Instance.new("UIGridLayout")
    miniLayout.CellSize = UDim2.new(0.48, 0, 0, 35)
    miniLayout.CellPadding = UDim2.new(0.04, 0, 0, 6)
    miniLayout.Parent = miniGrid

    local infoStatChips = {}
    local function createMiniStatChip(titleText)
        local card = Instance.new("Frame")
        card.BackgroundColor3 = Color3.fromRGB(22, 18, 45)
        card.BackgroundTransparency = 0.25
        card.Parent = miniGrid
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)

        local cap = Instance.new("TextLabel")
        cap.Size = UDim2.new(1, -8, 0, 12)
        cap.Position = UDim2.new(0, 6, 0, 2)
        cap.BackgroundTransparency = 1
        cap.Text = titleText
        cap.TextColor3 = Color3.fromRGB(150, 162, 200)
        cap.Font = Enum.Font.GothamBold
        cap.TextSize = 8
        cap.TextXAlignment = Enum.TextXAlignment.Left
        cap.Parent = card

        local val = Instance.new("TextLabel")
        val.Size = UDim2.new(1, -8, 0, 16)
        val.Position = UDim2.new(0, 6, 0, 15)
        val.BackgroundTransparency = 1
        val.Text = "--"
        val.TextColor3 = Color3.fromRGB(255, 255, 255)
        val.Font = Enum.Font.GothamBold
        val.TextSize = 10
        val.TextXAlignment = Enum.TextXAlignment.Left
        val.TextTruncate = Enum.TextTruncate.AtEnd
        val.Parent = card

        infoStatChips[titleText] = { card = card, val = val }
        return val
    end

    local pingValLbl    = createMiniStatChip("PING")
    local fpsValLbl     = createMiniStatChip("FPS")
    local memValLbl     = createMiniStatChip("MEMORY")
    local uptimeValLbl  = createMiniStatChip("UPTIME")

    -- Right Column (3D Player Body Preview Card)
    local avatarCard = Instance.new("Frame")
    avatarCard.Size = UDim2.new(0.42, -2, 1, 0)
    avatarCard.Position = UDim2.new(0.58, 2, 0, 0)
    avatarCard.BackgroundColor3 = Color3.fromRGB(22, 18, 45)
    avatarCard.BackgroundTransparency = 0.25
    avatarCard.Parent = topRowContainer
    Instance.new("UICorner", avatarCard).CornerRadius = UDim.new(0, 6)

    local avatarStroke = Instance.new("UIStroke")
    avatarStroke.Color = Color3.fromRGB(0, 229, 255)
    avatarStroke.Thickness = 1
    avatarStroke.Transparency = 0.6
    avatarStroke.Parent = avatarCard

    local viewport = Instance.new("ViewportFrame")
    viewport.Size = UDim2.new(1, -8, 1, -22)
    viewport.Position = UDim2.new(0, 4, 0, 4)
    viewport.BackgroundTransparency = 1
    viewport.Ambient = Color3.fromRGB(180, 190, 210)
    viewport.LightColor = Color3.fromRGB(255, 255, 255)
    viewport.LightDirection = Vector3.new(-1, -1, -1)
    viewport.Parent = avatarCard

    local avatarNameLbl = Instance.new("TextLabel")
    avatarNameLbl.Size = UDim2.new(1, 0, 0, 16)
    avatarNameLbl.Position = UDim2.new(0, 0, 1, -18)
    avatarNameLbl.BackgroundTransparency = 1
    avatarNameLbl.Text = "<b>" .. string.sub(LocalPlayer.DisplayName, 1, 12) .. "</b>"
    avatarNameLbl.TextColor3 = Color3.fromRGB(0, 229, 255)
    avatarNameLbl.Font = Enum.Font.GothamBold
    avatarNameLbl.TextSize = 9
    avatarNameLbl.RichText = true
    avatarNameLbl.TextXAlignment = Enum.TextXAlignment.Center
    avatarNameLbl.Parent = avatarCard

    -- Setup 3D Character Model inside ViewportFrame (with Archivable fix)
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

    -- Extra bottom stats (Players & Job ID strip)
    local bottomStatsRow = Instance.new("Frame")
    bottomStatsRow.Size = UDim2.new(1, -4, 0, 32)
    bottomStatsRow.BackgroundColor3 = Color3.fromRGB(22, 18, 45)
    bottomStatsRow.BackgroundTransparency = 0.25
    bottomStatsRow.Parent = InfoTab
    Instance.new("UICorner", bottomStatsRow).CornerRadius = UDim.new(0, 6)

    local playersValLbl = Instance.new("TextLabel")
    playersValLbl.Size = UDim2.new(0.45, 0, 1, 0)
    playersValLbl.Position = UDim2.new(0, 8, 0, 0)
    playersValLbl.BackgroundTransparency = 1
    playersValLbl.Text = "<b>PLAYERS:</b> --"
    playersValLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    playersValLbl.Font = Enum.Font.GothamBold
    playersValLbl.TextSize = 9
    playersValLbl.RichText = true
    playersValLbl.TextXAlignment = Enum.TextXAlignment.Left
    playersValLbl.Parent = bottomStatsRow

    local jobIdValLbl = Instance.new("TextLabel")
    jobIdValLbl.Size = UDim2.new(0.55, -8, 1, 0)
    jobIdValLbl.Position = UDim2.new(0.45, 0, 0, 0)
    jobIdValLbl.BackgroundTransparency = 1
    local jobId = game.JobId
    local jobShown = (jobId == "") and "STUDIO" or (string.sub(jobId, 1, 10) .. "...")
    jobIdValLbl.Text = "<b>JOB ID:</b> " .. jobShown
    jobIdValLbl.TextColor3 = Color3.fromRGB(0, 229, 255)
    jobIdValLbl.Font = Enum.Font.GothamBold
    jobIdValLbl.TextSize = 9
    jobIdValLbl.RichText = true
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
            jobIdValLbl.Text = ok and "<b>COPIED!</b>" or "<b>FAILED</b>"
            jobIdValLbl.TextColor3 = ok and Color3.fromRGB(70, 225, 150) or Color3.fromRGB(255, 85, 110)
        else
            jobIdValLbl.Text = (jobId == "") and "<b>NO ID</b>" or "<b>NO CLIP</b>"
        end
        task.delay(1.2, function()
            if hubAlive then
                jobIdValLbl.Text = "<b>JOB ID:</b> " .. jobShown
                jobIdValLbl.TextColor3 = Color3.fromRGB(0, 229, 255)
            end
        end)
    end)

    -- Console filter bar
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
            filterBtns[fName].BackgroundColor3 = isOn and Color3.fromRGB(0, 160, 240) or Color3.fromRGB(28, 22, 55)
            filterBtns[fName].TextColor3 = isOn and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 170, 200)
        end
    end

    for _, fName in ipairs(LOG_FILTERS) do
        local fBtn = Instance.new("TextButton")
        fBtn.Size = UDim2.new(0.192, 0, 1, 0)
        fBtn.BackgroundColor3 = Color3.fromRGB(28, 22, 55)
        fBtn.Text = "<b>" .. fName .. "</b>"
        fBtn.TextColor3 = Color3.fromRGB(160, 170, 200)
        fBtn.Font = Enum.Font.GothamBold
        fBtn.TextSize = 8
        fBtn.RichText = true
        fBtn.Parent = filterBar
        Instance.new("UICorner", fBtn).CornerRadius = UDim.new(0, 5)
        filterBtns[fName] = fBtn

        fBtn.MouseButton1Click:Connect(function()
            activeFilter = fName
            updateFilterColors()
            rebuildConsole()
        end)
    end
    updateFilterColors()

    -- Console Search Box
    local searchBox = Instance.new("TextBox")
    searchBox.Size = UDim2.new(1, -4, 0, 26)
    searchBox.BackgroundColor3 = Color3.fromRGB(22, 18, 45)
    searchBox.PlaceholderText = "Search console logs..."
    searchBox.PlaceholderColor3 = Color3.fromRGB(130, 140, 175)
    searchBox.Text = ""
    searchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    searchBox.Font = Enum.Font.Gotham
    searchBox.TextSize = 11
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.ClearTextOnFocus = false
    searchBox.Parent = InfoTab
    Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 6)
    Instance.new("UIPadding", searchBox).PaddingLeft = UDim.new(0, 8)

    -- Console Output Scroll Frame
    local consoleScroll = Instance.new("ScrollingFrame")
    consoleScroll.Size = UDim2.new(1, -4, 0, 125)
    consoleScroll.BackgroundColor3 = Color3.fromRGB(8, 10, 22)
    consoleScroll.BorderSizePixel = 0
    consoleScroll.ScrollBarThickness = 3
    consoleScroll.ScrollBarImageColor3 = Color3.fromRGB(150, 70, 255)
    consoleScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    consoleScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    consoleScroll.Parent = InfoTab
    Instance.new("UICorner", consoleScroll).CornerRadius = UDim.new(0, 6)

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

    -- Console bottom controls (Clear, Auto-Scroll, Counter)
    local consoleControls = Instance.new("Frame")
    consoleControls.Size = UDim2.new(1, -4, 0, 26)
    consoleControls.BackgroundTransparency = 1
    consoleControls.Parent = InfoTab

    local clearConsoleBtn = Instance.new("TextButton")
    clearConsoleBtn.Size = UDim2.new(0.36, 0, 1, 0)
    clearConsoleBtn.Position = UDim2.new(0, 0, 0, 0)
    clearConsoleBtn.BackgroundColor3 = Color3.fromRGB(28, 22, 55)
    clearConsoleBtn.Text = "<b>CLEAR</b>"
    clearConsoleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearConsoleBtn.Font = Enum.Font.GothamBold
    clearConsoleBtn.TextSize = 9
    clearConsoleBtn.RichText = true
    clearConsoleBtn.Parent = consoleControls
    Instance.new("UICorner", clearConsoleBtn).CornerRadius = UDim.new(0, 5)

    local autoScrollEnabled = true
    local autoScrollBtn = Instance.new("TextButton")
    autoScrollBtn.Size = UDim2.new(0.42, 0, 1, 0)
    autoScrollBtn.Position = UDim2.new(0.38, 0, 0, 0)
    autoScrollBtn.BackgroundColor3 = Color3.fromRGB(150, 70, 255)
    autoScrollBtn.Text = "<b>AUTO-SCROLL: ON</b>"
    autoScrollBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoScrollBtn.Font = Enum.Font.GothamBold
    autoScrollBtn.TextSize = 9
    autoScrollBtn.RichText = true
    autoScrollBtn.Parent = consoleControls
    Instance.new("UICorner", autoScrollBtn).CornerRadius = UDim.new(0, 5)

    local logCountLbl = Instance.new("TextLabel")
    logCountLbl.Size = UDim2.new(0.18, 0, 1, 0)
    logCountLbl.Position = UDim2.new(0.82, 0, 0, 0)
    logCountLbl.BackgroundTransparency = 1
    logCountLbl.Text = "0/" .. MAX_LOGS
    logCountLbl.TextColor3 = Color3.fromRGB(150, 162, 200)
    logCountLbl.Font = Enum.Font.GothamBold
    logCountLbl.TextSize = 9
    logCountLbl.TextXAlignment = Enum.TextXAlignment.Right
    logCountLbl.Parent = consoleControls

    -- Console Log Engine
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
        row.BackgroundColor3 = Color3.fromRGB(22, 18, 45)
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
            '<font color="#7F8BB8">[%s]</font> <font color="%s"><b>[%s]</b></font> %s',
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
        autoScrollBtn.Text = autoScrollEnabled and "<b>AUTO-SCROLL: ON</b>" or "<b>AUTO-SCROLL: OFF</b>"
        autoScrollBtn.BackgroundColor3 = autoScrollEnabled and Color3.fromRGB(150, 70, 255) or Color3.fromRGB(28, 22, 55)
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

    -- Live Server Stats Updater
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

                if ping then
                    pingValLbl.Text = ping .. " ms"
                    pingValLbl.TextColor3 = (ping < 100 and Color3.fromRGB(70, 225, 150)) or (ping < 200 and Color3.fromRGB(255, 200, 75)) or Color3.fromRGB(255, 85, 110)
                else
                    pingValLbl.Text = "N/A"
                    pingValLbl.TextColor3 = Color3.fromRGB(150, 162, 200)
                end

                local rFps = math.floor(fps + 0.5)
                fpsValLbl.Text = tostring(rFps)
                fpsValLbl.TextColor3 = (rFps >= 45 and Color3.fromRGB(70, 225, 150)) or (rFps >= 25 and Color3.fromRGB(255, 200, 75)) or Color3.fromRGB(255, 85, 110)

                memValLbl.Text = (okMem and type(mem) == "number") and string.format("%.0f MB", mem) or "N/A"
                playersValLbl.Text = string.format("<b>PLAYERS:</b> %d/%d", okPlr and pList or "?", Players.MaxPlayers)
                uptimeValLbl.Text = fmtTime(workspace.DistributedGameTime)

                if isDisconnected or not LocalPlayer:IsDescendantOf(game) then
                    connStatusLbl.Text = "<b>DISCONNECTED</b>"
                    connStatusLbl.TextColor3 = Color3.fromRGB(255, 85, 110)
                elseif (ping and ping >= 400) or rFps < 8 then
                    connStatusLbl.Text = "<b>UNSTABLE</b>"
                    connStatusLbl.TextColor3 = Color3.fromRGB(255, 85, 110)
                elseif ping and ping >= 200 then
                    connStatusLbl.Text = "<b>SLOW LINK</b>"
                    connStatusLbl.TextColor3 = Color3.fromRGB(255, 200, 75)
                else
                    connStatusLbl.Text = "<b>CONNECTED</b>"
                    connStatusLbl.TextColor3 = Color3.fromRGB(70, 225, 150)
                end
            end
            task.wait(0.5)
        end
    end)

    -- Combined RenderStepped loop (AutoAim + Console Row Batching + FPS Counter)
    trackConn(RunService.RenderStepped:Connect(function()
        frameCounter = frameCounter + 1

        pcall(function()
            if Config.AutoAim then
                local target = GetNearestEnemyTarget(Config.AutoAimRange)
                local cam = Workspace.CurrentCamera
                if target and cam then cam.CFrame = CFrame.lookAt(cam.CFrame.Position, target.Position) end
            end
        end)

        -- Flush console rows in batches
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
-- GAME ROUTER EXECUTION
-- ============================================================
local MarketplaceService = game:GetService("MarketplaceService")
local PlaceId = game.PlaceId
local GameId = game.GameId

local success, info = pcall(function()
    return MarketplaceService:GetProductInfo(PlaceId)
end)
local gameName = (success and info and info.Name) or ""
local nameLower = gameName:lower()

if nameLower:find("taxi boss") or PlaceId == 7305826609 then
    print("[BRINELAND] Detected Taxi Boss. Executing script...")
    RunTaxiBoss()
elseif nameLower:find("steal an egg") or nameLower:find("stealanegg") or PlaceId == 115049386348611 then
    print("[BRINELAND] Detected Steal An Egg. Executing script...")
    RunStealAnEgg()
elseif nameLower:find("throw food for animals") or PlaceId == 120219252362013 or GameId == 10766972131 then
    print("[BRINELAND] Detected Throw Food for Animals. Loading throwfood.lua...")
    local ok, res = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/DCBHEROBRINE/BRINELAND-HUB/main/throwfood.lua") end)
    if ok and res then loadstring(res)() end
elseif nameLower:find("speed keyboard escape") or nameLower:find("+1 speed") then
    print("[BRINELAND] Detected +1 Speed Keyboard Escape. Loading SpeedKeyboardEscape.lua...")
    local ok, res = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/DCBHEROBRINE/BRINELAND-HUB/main/SpeedKeyboardEscape.lua") end)
    if ok and res then loadstring(res)() end
elseif nameLower:find("bake or die") or nameLower:find("bakeordie") or PlaceId == 86479448397834 or GameId == 7488668004 then
    print("[BRINELAND] Detected Bake or Die. Loading bakeordie.lua...")
    local ok, res = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/DCBHEROBRINE/BRINELAND-HUB/main/bakeordie.lua") end)
    if ok and res then loadstring(res)() end
else
    print("[BRINELAND] Unrecognized game: " .. gameName .. " (PlaceId: " .. tostring(PlaceId) .. "). Running Universal Hub...")
    RunUniversalScript()
end
