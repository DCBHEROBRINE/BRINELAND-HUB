-- PARTIALLY DEOBFUSCATED CHILLI HUB: STEAL AN EGG
-- Inspection only: this fragment is not standalone. VM calls remain unresolved.
-- Original names are preserved to avoid altering behavior or guessing semantics.
--
-- Verified references in the Z table:
-- Z[1]  = local player                  Z[8]  = get character humanoid
-- Z[9]  = invoke networking remote with timeout
-- Z[15] = get HumanoidRootPart         Z[18] = read field egg records
-- Z[20] = shared runtime state/helpers Z[21] = check carried egg
-- Z[22] = safely call loaded module method
-- Z[23] = wait for Heartbeat           Z[25] = feature settings
-- Z[26] = reposition root part         Z[27] = CFrame.new
-- Z[28] = Vector3.new                  Z[33] = zero Vector3
-- Z[34] = lazy-loaded game modules      Z[39] = Packages.Networking
-- Z[44] = get movement speed           Z[46] = action statistics
-- Z[47] = safe-zone position           Z[54] = find object under World/__OBJECTS
-- Z[61] = RunService                   Z[66] = resolve plot
-- Z[67] = read saved client state      Z[75] = invoke remote and check result
--
-- Important limits: C:FH and other C methods are virtual-machine helpers.
-- Their effects and bytecode have not been fully recovered. This code cannot
-- be represented honestly as the original or a complete deobfuscation.
--
-- Extracted from Chilli Hub unpacked layer for review only.
-- This fragment depends on omitted obfuscator VM variables and is not standalone.
local function extracted_game_logic()
	local Z = {}
	pcall(makefolder, "ChilliLibrary")
	local n, d, q = 45, 0, 0
	local P, r = os.clock(), {}
	local function w(b, T)
		pcall(writefile, "ChilliLibrary/SAE_LoadPart.txt", b)
		local y, l = xpcall(T, function(T)
			return tostring(T) .. " | " .. tostring(debug.traceback()):sub(1, 400)
		end)
		if not y then
			r[#r + 1] = b .. ": " .. tostring(l)
		end
		d += 1
		y = math.floor(d / n * 9)
		if y > q then
			q = y
			pcall(getgenv().ChilliHubLoadStep, y)
			P = os.clock()
		end
		if os.clock() - P > 0.05 then
			task.wait()
			P = os.clock()
		end
	end
	local n = game
	local function d(q)
		return n:GetService(q)
	end
	local q = d("Players")
	local P = d("ReplicatedStorage")
	local b = d("RunService")
	Z[61] = b
	local b = d("TeleportService")
	local T = d("HttpService")
	local y = q.LocalPlayer
	Z[1] = y
	local y = P:WaitForChild("Packages"):WaitForChild("Networking")
	Z[39] = y
	local y = Vector3.new
	Z[28] = y
	local y = CFrame.new
	Z[27] = y
	local y = Vector3.new(0.0, 0.0, 0.0)
	Z[33] = y
	local y = Z[61].Heartbeat
	local l = getgenv and getgenv() or _G
	if l.ChilliHubSaeCleanup then
		pcall(l.ChilliHubSaeCleanup)
	end
	local W, E, F = true, {}, { cleanup = {}, agFlash = function() end }
	Z[56] = W
	Z[20] = F
	local function W(F, s)
		local a = F:Connect(s)
		E[#E + 1] = a
		return a
	end
	Z[23] = function()
		return y:Wait()
	end
	local function F(s, a)
		local J = Instance.new(s)
		J.Name = T:GenerateGUID(false):gsub("-", ""):sub(1, 14)
		for s, Y in next, a, nil do
			if s ~= "Parent" then
				J[s] = Y
			end
		end
		J.Parent = a.Parent
		return J
	end
	local s = {
		Egg = "Client.EggState",
		Assets = "Data.Assets",
		Mut = "Shared.Modules.Mutations",
		Save = "Shared.Save",
		Cycle = "Shared.Util.AreaEggCycle",
		Wall = "Client.AreaEggResetWall",
		Plot = "Client.PlotState",
		Rec = "Shared.Util.EggRecords",
		Fuse = "Shared.Util.FuseKernel",
		Bases = "Data.Bases",
		Tread = "Data.Treadmills",
		Trails = "Data.Trails",
		Gears = "Data.Gears",
		Areas = "Data.Areas",
		Wisp = "Data.WispQuests",
		Cat = "Shared.Modules.ButterflyCatalog",
		Fmt = "Packages.FormatNumber.Simple",
	}
	local a = setmetatable({}, {
		__index = function(J, Y)
			local R = P
			for e in s[Y]:gmatch("[^.]+") do
				R = R and (R:FindFirstChild(e))
			end
			local s, e = pcall(require, R)
			if s then
				if e then
					rawset(J, Y, e)
					return e
				end
			end
		end,
	})
	Z[34] = a
	Z[9] = function(s, ...)
		local a = Z[39]
		local J = a:FindFirstChild(s)
		if not J then
			return false
		end
		local s = coroutine.running()
		local a = table.pack(...)
		local Y, R
		local e = false
		local function f(Q)
			if Y then
				return
			end
			Y = Q or { false, "timeout", n = 2 }
			if Q then
				if R then
					task.cancel(R)
				end
			end
			if e then
				task.spawn(s)
			end
		end
		task.spawn(function()
			f(table.pack(pcall(J.InvokeServer, J, table.unpack(a, 1, a.n))))
		end)
		if not Y then
			R, e = task.delay(15, f), true
			coroutine.yield()
		else
		end
		local s, a, J = table.unpack, Y, Y.n
		return s(a, 1, J)
	end
	local function s(a, ...)
		local J = Z[39]
		local Y = J:FindFirstChild(a)
		if Y then
			pcall(Y.FireServer, Y, ...)
		end
	end
	Z[22] = function(a, J, ...)
		local Y = Z[34]
		local R = Y[a]
		if R then
			if not R[J] then
				return nil
			end
		else
			return nil
		end
		local a, Y, e = pcall(R[J], ...)
		if a then
			return Y, e
		end
		return nil
	end
	Z[8] = function()
		local a = Z[1]
		local J, Y = a.Character
		if J then
			a = Z[1]
			Y = a.Character:FindFirstChildOfClass("Humanoid")
		else
			Y = J
		end
		return Y
	end
	Z[15] = function()
		local a = Z[1]
		local J, Y = a.Character
		if J then
			a = Z[1]
			Y = a.Character:FindFirstChild("HumanoidRootPart")
		else
			Y = J
		end
		return Y
	end
	local function a()
		local J = Z[8]
		local Y = J()
		local J, R = Y ~= nil and Y.Health > 0
		if J then
			Y = Z[15]
			R = Y() ~= nil
		else
			R = J
		end
		return R
	end
	local function J()
		return workspace:GetServerTimeNow()
	end
	Z[32] = function()
		local Y, Y, Y, R = Z[1], Z[1], pcall(Z[1].GetNetworkPing, Z[1])
		return Y and math.clamp(tonumber(R) or 0.2, 0, 1) or 0.2
	end
	local Y
	Z[13] = Y
	Z[26] = function(Y)
		local R = Z[15]
		local e = R()
		if e then
			if e.Anchored then
				R = Z[20]
				if (R.hold or 0) == 0 then
					if not (Z[13](function()
						local e = Z[56]
						return e
					end)) then
						return
					end
				end
			end
		else
			return
		end
		R = Z[15]
		local e = R()
		if not e then
			return
		end
		pcall(function()
			e.CFrame = Y
			local Y = Z[33]
			e.AssemblyLinearVelocity = Y
			Y = Z[33]
			e.AssemblyAngularVelocity = Y
		end)
	end
	Z[44] = function()
		local Y = Z[8]
		local R = Y()
		return math.max(R and R.WalkSpeed or 16, 16)
	end
	Z[54] = function(...)
		local Y, R = { ... }, workspace:FindFirstChild("World") or workspace:FindFirstChild("__OBJECTS")
		for e, e in ipairs(Y) do
			R = R and (R:FindFirstChild(e))
		end
		return R
	end
	local Y
	Z[24] = function()
		if not (Y and Y.Parent) then
			local R = Z[54]
			local e = R("Areas", "SeparationLine")
			Y = e and e:IsA("BasePart") and e or nil
		end
		local R, e = Y and Y.Position
		if R then
			e = R
		else
			local Y = Z[28]
			e = (Y(552.2, 67.67, 0))
		end
		return e
	end
	Z[47] = function()
		local Y = Z[54]
		local R = Y("Machines", "RiftMachine", "Rift", "Meshes/VoidPortal_Cube.003")
		local e, f = R and (R:IsA("BasePart"))
		if e then
			Y = nil
			Y, f = Z[28], R.CFrame:PointToWorldSpace(Z[28](-26.776, 1.75, 18.665))
		else
			f = e
		end
		R = nil
		if f then
			R = f
		else
			Y = Z[28]
			R = (Y(528.7, 70.57, -364.11))
		end
		return R
	end
	Z[16] = function(Y)
		local R, R = Z[24], Y.X < Z[24]().X and Y.Y < 1000
		return R
	end
	Z[66] = function()
		local Y = Z[22]
		local R = Y("Plot", "ResolvePlot")
		if type(R) == "table" then
			if R.PlotFolder then
				return R
			end
		end
	end
	local function Y(R, e)
		pcall(firetouchinterest, R, e, 0)
		pcall(firetouchinterest, R, e, 1)
	end
	Z[29] = function()
		local R, R = Z[1], tonumber(Z[1]:GetAttribute("RagdollEndTime")) or 0
		return R > J()
	end
	Z[75] = function(R, ...)
		local e = Z[9]
		local f, Q = e(R, ...)
		return f and Q ~= false
	end
	local function R(e)
		e = math.max(math.floor(e), 0)
		return e >= 3600 and ("%dh %02dm"):format(e // 3600, e % 3600 // 60) or ("%dm %02ds"):format(e // 60, e % 60)
	end
	local e, f =
		{ "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Cosmic", "Secret", "Eternal", "Divine" }, {}
	for Q = #e, 1, -1 do
		f[#f + 1] = e[Q]
	end
	local Q, u =
		{
			Scrambled = "Scrambled",
			Golden = "Golden",
			Rainbow = "Rainbow",
			Silver = "Silver",
			Sakura = "Bloom",
			GreatBloom = "Spirit Bloom",
			Boss = "Fractured",
			Enchanted = "Enchanted",
			Monstrous = "Parasite",
			Nitro = "Nitro",
			Spectral = "Spectral",
			Alien = "Abducted",
			Musical = "Musical",
			DarkMatter = "Dark Matter",
			Thunderous = "Thunderous",
			Blacklisted = "Blacklisted",
			Copper = "Copper",
		},
		{ "K", "M", "B", "T", "Qa", "Qi" }
	local function A(h)
		h = tonumber(h) or 0
		local m = 0
		while h >= 1000 and m < #u do
			h, m = h / 1000, m + 1
		end
		local k, L = m == 0 and tostring(math.floor(h))
		if k then
			L = k
		else
			local k, g = string.format, h < 10 and "%.2f" or h < 100 and "%.1f"
			L = k(g or "%.0f", h)
		end
		return L .. (u[m] or "")
	end
	local function h(m)
		local k = Z[34]
		local L = k.Assets
		return L and L.Directory and L.Directory[m]
	end
	local function m(k)
		local L = h(k)
		k = L and L.Rarity
		return k and tonumber(k.RarityNumber or k.Rank) or 0
	end
	Z[74] = function(k)
		local L = h(k)
		return L and L.DisplayName or tostring(k)
	end
	local function k(L)
		local g, i = {}, {}
		local function t(x)
			if type(x) == "string" then
				if x ~= "" then
					if x ~= "Normal" then
						if x ~= "None" then
							if not i[x] then
								i[x] = true
								g[#g + 1] = x
							end
						end
					end
				end
			end
		end
		t(L.BaseMutation)
		if type(L.Mutations) == "table" then
			for x, S in next, L.Mutations, nil do
				t(type(x) == "string" and S == true and x or S)
			end
		end
		return g, i
	end
	local function L(g, i, t)
		local x = h(g)
		if not x then
			return 0
		end
		i = tonumber(i) or 1
		local S, H = i > 5 and (i / 5) ^ 1.2 * 19.637875755794113 or i ^ 1.85, Z[34]
		local i = H.Mut
		g, H = pcall(function()
			return i.EarningsFor(t or {})
		end)
		return (tonumber(x.EarningRate) or 0) * S * (g and tonumber(H) or 1)
	end
	local function g(i, t)
		t = t or i.AssetCategory or i.Category
		local x, S = k(i)
		local H = i.AssetScale or i.Scale
		local _, o = { cat = t, r = m(t), v = L(t, H, x), s = tonumber(H) or 1, m = x, ms = S }, Z[74]
		_.n = o(t)
		_.a = i.AreaId
		return _
	end
	local i, i =
		{
			Color3.fromRGB(190, 196, 220),
			Color3.fromRGB(120, 230, 140),
			Color3.fromRGB(110, 170, 255),
			Color3.fromRGB(190, 130, 255),
			Color3.fromRGB(255, 200, 90),
			Color3.fromRGB(255, 120, 150),
			Color3.fromRGB(110, 235, 255),
			Color3.fromRGB(240, 240, 255),
			Color3.fromRGB(255, 150, 90),
			Color3.fromRGB(255, 230, 140),
		},
		{
			money = "rbxassetid://119640363267627",
			night = "rbxassetid://123238464128459",
			egg = "rbxassetid://97499770821177",
			pet = "rbxassetid://112223455192501",
			scrambled = "rbxassetid://91260564167870",
			tread = "rbxassetid://137134884810647",
			essence = "rbxassetid://114750647204247",
			net = "rbxassetid://131116540264095",
			Golden = "rbxassetid://98126365702697",
			Purple = "rbxassetid://121235713836098",
			Blue = "rbxassetid://89995151383384",
			Green = "rbxassetid://107744695034799",
			star = "rbxassetid://79133579432887",
			timer = "rbxassetid://132534369464516",
			check = "rbxassetid://104873662023098",
			arrow = "rbxassetid://94178052551280",
			trap = "rbxassetid://113747761726323",
			pin = "rbxassetid://74684257299345",
			wisp = "rbxassetid://115565045229337",
			wisp3 = "rbxassetid://135449361680117",
			potion = "rbxassetid://98847011195862",
			luck = "rbxassetid://108988481469824",
			x2 = "rbxassetid://128234882192727",
			medal = "rbxassetid://116272961700800",
			trophy = "rbxassetid://119210375463488",
			spectral = "rbxassetid://108054256583165",
			fractured = "rbxassetid://74755693699202",
			scramble = "rbxassetid://134710848063255",
			nitro = "rbxassetid://134287739122547",
		}
	Z[67] = function()
		local t = Z[34]
		local x = t.Save
		local t, S = pcall(function()
			return x.Peek()
		end)
		return t and type(S) == "table" and S or nil
	end
	local t = {
		k = 1000,
		m = 1000000,
		b = 1000000000,
		t = 1000000000000,
		qa = 1000000000000000,
		qi = 1000000000000000000,
		sx = 1.0E21,
		sp = 1.0E24,
		oc = 1.0E27,
		no = 1.0E30,
		dc = 1.0E33,
	}
	local function x(S)
		local H = Z[1]
		local _ = H:FindFirstChild("leaderstats")
		H = _ and (_:FindFirstChild(S))
		H = H and H.Value
		if type(H) ~= "string" then
			return tonumber(H)
		end
		_, S = H:gsub("[^%w%.]", ""):match("^([%d%.]+)(%a*)")
		return tonumber(_) and tonumber(_) * (S == "" and 1 or t[S:lower()] or 0)
	end
	Z[18] = function()
		local t, S = pcall(function()
			local H = Z[34]
			return H.Egg.ReadFieldEggs()
		end)
		return t and type(S) == "table" and S.Records or {}
	end
	local function t()
		local S = Z[1]
		return S:FindFirstChildOfClass("Backpack")
	end
	local function S()
		local H, _ = pcall(function()
			local o, B = Z[34], Z[1]
			return o.Egg.ReadOwnerEggs(B.UserId)
		end)
		return H and type(_) == "table" and _ or {}
	end
	local H, _ = 0, 99
	local function o()
		local B = os.clock()
		if B - H < 0.2 then
			local v, z = _, B - H
			return v - z
		end
		local v = J()
		H = B
		B = Z[22]
		if B("Cycle", "IsNightPhase", v) then
			_ = 0
			return 0
		else
			local H = Z[22]
			if H("Wall", "IsSealed") then
				_ = 0
				return 0
			end
		end
		B = Z[22]
		local H = B("Cycle", "NextResetTime", v)
		_ = H and H - 10 - v or 99
		H = _
		return H
	end
	local H = { "None" }
	for _, _ in next, Q, nil do
		H[#H + 1] = _
	end
	table.sort(H, function(_, B)
		return _ == "None" or B ~= "None" and _ < B
	end)
	local function _(B, v)
		if B then
			if #B == 0 then
				return nil
			end
		else
			return nil
		end
		local z = {}
		for c, c in ipairs(B) do
			z[v and v[c] or c] = true
		end
		return z
	end
	local B, v = {}, { None = "None" }
	for z, c in ipairs(e) do
		B[c] = z
	end
	for z, c in next, Q, nil do
		v[c] = z
	end
	Z[70] = function(z, c)
		if z.rar then
			if not z.rar[c.r] then
				return false
			end
		end
		if z.sp then
			local D, N, V = z.sp, c.n
			if N then
				V = N
			else
				local N = Z[74]
				V = N(c.cat)
			end
			if not D[V] then
				return false
			end
		end
		if z.no then
			local D, N, V = z.no, c.n
			if N then
				V = N
			else
				local N = Z[74]
				V = N(c.cat)
			end
			if D[V] then
				return false
			end
		end
		local D = z.rmin and z.rmin[c.r]
		if c.v < (D or z.minV or 0) then
			return false
		elseif z.maxV then
			if c.v >= z.maxV then
				return false
			end
		end
		if z.mut then
			if #c.m == 0 then
				return z.mut.None == true
			end
			for D, D in ipairs(c.m) do
				if z.mut[D] then
					return true
				end
			end
			return false
		end
		return true
	end
	local z =
		M.Window({ Title = "Chilli Hub", Game = n.GameId ~= 0 and n.GameId or n.PlaceId, Key = Enum.KeyCode.LeftControl })
	l.ChilliHubSaeCleanup = function()
		Z[56] = false
		local c = Z[20]
		for D, D in ipairs(c.cleanup) do
			pcall(D)
		end
		for c, c in ipairs(E) do
			pcall(c.Disconnect, c)
		end
		pcall(z.Destroy, z)
		l.ChilliHubSaeCleanup = nil
	end
	local c = {}
	local function D(N, V)
		c[N] = V
	end
	W(y, function()
		if next(c) then
			local N = c
			c = {}
			for c, c in next, N, nil do
				pcall(c)
			end
		end
	end)
	Z[20].press = function(c)
		return c.UserInputType == Enum.UserInputType.MouseButton1 or c.UserInputType == Enum.UserInputType.Touch
	end
	Z[20].log = {}
	Z[11] = function(c, N)
		local V, I = Z[20], Z[20]
		V.noteAt = os.clock()
		I.status = c
		V = Z[20]
		if V.lastNote ~= c then
			I = Z[20]
			I.lastNote = c
			local j, K = Z[20]
			K, j.log[#Z[20].log + 1] = Z[20], ("%.1f %s"):format(os.clock(), tostring(c))
			j = Z[20]
			if #j.log > 40 then
				table.remove(Z[20].log, 1)
			end
		end
		V, I = Z[20], Z[20]
		V.warned = I.warned or {}
		if N == "warn" or N == "err" then
			if not z.open then
				V, I = Z[20], os.clock() - (Z[20].warned[c] or -1000000000)
				if I > 60 then
					local N = Z[20]
					N.warned[c] = os.clock()
					M.Notify("Chilli Hub", c)
				end
			end
		end
	end
	local function c(N, V)
		M.Notify(N, V)
	end
	local function N(V, I)
		return function(j)
			D(V, function()
				I:Set(j)
			end)
		end
	end
	local function V(I, j, K)
		D(I, function()
			for I, X in next, K, nil do
				j:Set(I, X)
			end
		end)
	end
	local function I()
		local j = Z[20]
		if j.poke then
			local j = Z[20]
			j.poke()
		end
	end
	w("00_core#1", function()
		local j = {}
		pcall(function()
			local K = Z[34]
			for X, U in next, K.Assets.Directory, nil do
				X = type(U) == "table" and U.Rarity
				U = X and tonumber(X.RarityNumber or X.Rank)
				if U then
					j[U] = j[U] or tostring(X.DisplayName or X._id or U)
				end
			end
		end)
		if not (next(j)) then
			for K, X in ipairs(e) do
				j[K] = X
			end
		end
		local K = Z[20]
		K.AREAS = {
			"Forest",
			"Desert",
			"Snow",
			"Lake",
			"Jungle",
			"Volcano",
			"Prehistoric",
			"Stormlands",
			"Cosmic",
			"Abyss Ocean",
			"Cherry Blossom",
			"Light Dark",
			"Titan Temple",
			"Enchanted Forest",
			"Alien",
		}
		local X = Z[20]
		X.allAreas = function(X)
			local U = Z[20]
			for G, G in ipairs(U.AREAS) do
				if G ~= "Alien" then
					if G ~= "Stormlands" then
						if not (table.find(X, G)) then
							return false
						end
					end
				end
			end
			return true
		end
		local X, U, G = Z[20], Z[20], Z[20]
		X.RANY = { "Any" }
		U.RNUM = {}
		G.RIDX = {}
		K = #e + 2
		for CI = 1, K, 1 do
			if j[CI] then
				X, G = Z[20]
				G, X.RANY[#Z[20].RANY + 1] = Z[20], j[CI]
				local K, X = Z[20]
				X, K.RNUM[#Z[20].RNUM + 1] = Z[20], CI .. " - " .. j[CI]
				U = Z[20]
				U.RIDX[j[CI]] = CI
				K = Z[20]
				K.RIDX[CI .. " - " .. j[CI]] = CI
			end
		end
		local j
		local K = Z[20]
		K.eggList = function()
			if j then
				local K = j
				return K
			end
			local K, X = {}, {}
			pcall(function()
				local G = Z[34]
				for CI, OI in next, G.Assets.Directory, nil do
					local G = type(OI) == "table" and OI.Rarity
					local pI = G and tonumber(G.RarityNumber or G.Rank)
					if pI then
						K[#K + 1] = {
							n = tostring(OI.DisplayName or CI),
							r = pI,
							rn = tostring(G.DisplayName or G._id or pI),
							c = tostring(CI),
						}
					end
				end
			end)
			table.sort(K, function(G, CI)
				return G.r > CI.r or G.r == CI.r and G.n < CI.n
			end)
			j = {}
			for G, CI in ipairs(K) do
				G = CI.n .. " [" .. CI.rn .. "]"
				G = if X[G] then G .. " (" .. CI.c .. ")" else G
				X[G] = true
				CI = j
				CI[#CI + 1] = G
			end
			X = j
			return X
		end
		U = Z[20]
		U.nostat = { Set = function() end, Icon = function() end }
		local j = Z[20]
		j.minRar = function(j)
			local K = Z[20]
			local X = K.RIDX[tostring(j)]
			if not X then
				return nil
			end
			K = {}
			for j = X, 12, 1 do
				K[j] = true
			end
			return K
		end
		local j = Z[20]
		j.maxRar = function(j)
			local K = Z[20]
			local X = K.RIDX[tostring(j)]
			if not X then
				return nil
			end
			j = {}
			for K = 1, X, 1 do
				j[K] = true
			end
			return j
		end
		local j = Z[20]
		j.names = function(j)
			local K
			for X, X in ipairs(type(j) == "table" and j or {}) do
				K = K or {}
				K[tostring(X):gsub(" %(.-%)$", ""):gsub(" %[[^%]]*%]$", "")] = true
			end
			return K
		end
	end)
	local j = {}
	Z[25] = j
	local function j(K, X, U, G, CI, OI, pI)
		local MI = Z[25]
		MI[U] = G or false
		local function MI(ZI)
			local nI = Z[25]
			nI[U] = ZI
			if CI then
				CI(ZI)
			end
			I()
		end
		return K:Toggle(X, G, MI, OI, pI)
	end
	local function K(X, U, G, CI, OI, pI, MI, ZI, nI)
		local dI = Z[25]
		dI[G] = OI
		local function dI(qI)
			local PI = Z[25]
			PI[G] = qI
			if pI then
				pI(qI)
			end
			I()
		end
		return X:Dropdown(U, CI, OI, dI, MI, ZI, nI)
	end
	local function X(U, G, CI, OI, pI, MI, ZI, nI, dI, qI, PI)
		local rI = Z[25]
		rI[CI] = ZI == "log" and M.s2v(MI) or MI
		local function rI(wI)
			local bI = Z[25]
			bI[CI] = wI
			if dI then
				dI(wI)
			end
		end
		return U:Slider(G, OI, pI, MI, rI, ZI, nI, qI, PI)
	end
	local U, G = {}
	Z[4] = G
	local function G(CI)
		CI.at, CI.tok, CI.i = CI.at or 0, 0, #U + 1
		U[CI.i] = CI
		return CI
	end
	Z[20].poke = function()
		for CI, CI in ipairs(U) do
			if CI.info then
				if not CI.busy then
					CI.at = 0
				end
			end
		end
	end
	local function CI(OI)
		OI.tok = OI.tok + 1
		OI.at = 0
	end
	local OI = os.clock()
	W(Z[1].CharacterAdded, function()
		OI = os.clock()
	end)
	local pI, MI = { on = false }, { stolen = 0, last = "-", placed = 0, hatched = 0 }
	Z[46] = MI
	Z[21] = function(MI)
		local ZI, nI = pI.on
		if ZI then
			local dI, qI = MI == nil
			if dI then
				local PI = Z[20]
				qI = not PI.rag
			else
				qI = dI
			end
			nI = qI or pI.uid == MI
		else
			nI = ZI
		end
		return nI
	end
	task.spawn(function()
		local MI = Z[34]
		local ZI = MI.Egg
		if ZI then
			if ZI.CarryChanged then
				W(ZI.CarryChanged, function(MI)
					if type(MI) == "table" then
						pI.on = MI.IsCarrying == true
						pI.uid = MI.Uid
					end
				end)
			end
		end
	end)
	Z[53] = function(pI, MI, ZI)
		local nI = Z[20]
		if nI.ready then
			local dI = Z[20]
			dI.ready(MI)
		end
		if ZI then
		else
			nI = Z[44]
			ZI = nI() * 0.92
		end
		nI = Z[15]
		local dI, qI = nI(), Z[20]
		if qI.hideTread then
			if dI then
				nI = Z[47]
				if (pI - nI()).Magnitude < 30 then
					local PI = Z[20]
					PI.hideTread((pI - dI.Position).Magnitude / ZI + 2)
				end
			end
		end
		qI, nI = os.clock, 1 / 0
		local PI, rI, wI = qI(), false, 0.016666666666666666
		while MI() do
			dI = Z[15]
			qI = dI()
			if not qI then
				return false
			end
			if qI.Anchored then
				if not (Z[13](MI)) then
					return false
				end
			end
			local MI = pI - qI.Position
			if MI.Magnitude < 3 then
				local dI, bI = Z[26], Z[27]
				dI(bI(pI) * qI.CFrame.Rotation)
				return true
			end
			if MI.Magnitude < nI - 3 then
				nI, PI = MI.Magnitude, os.clock()
			else
				local pI, nI = os.clock() - PI > 4
				if pI then
					local dI = Z[20]
					nI = dI.respawn
				else
					nI = pI
				end
				if nI then
					local nI, nI = Z[20], os.clock() - (Z[20].respawnAt or -99)
					if nI < 10 then
						return false
					end
					nI = Z[11]
					nI("Stuck in place, resetting the character")
					nI = Z[20]
					nI.respawn()
					return false
				elseif os.clock() - PI > 1 then
					if rI then
					else
						pI = Z[9]
						pI("RF/Treadmill/AskDoff")
						local pI, nI, dI = Z[26], Z[27], Z[47]
						pI(nI(dI() + Z[28](0, 3, 0)))
						rI = true
					end
				else
				end
			end
			local pI, nI = Z[26], Z[27]
			pI(nI(qI.Position + MI.Unit * math.min(ZI * wI, MI.Magnitude)) * qI.CFrame.Rotation)
			MI = nil
			MI, wI = Z[23], math.clamp(Z[23](), 0.004166666666666667, 0.05)
		end
		return false
	end
	Z[13] = function(pI)
		for MI = 1, 4, 1 do
			MI = Z[15]
			local ZI = MI()
			if not ZI then
				return false
			end
			if not ZI.Anchored then
				MI = Z[20]
				if not MI.onAdmin then
					return true
				end
			end
			MI = Z[20]
			local nI, dI = MI.onAdmin, Z[9]
			local qI, PI, rI = dI("RF/Treadmill/AskDoff")
			dI = Z[20]
			dI.onAdmin = false
			if nI and not ZI.Anchored then
				dI = os.clock() + 0.4
				while os.clock() < dI and (pI()) do
					MI = Z[23]
					MI()
				end
				return pI()
			end
			if qI then
				if PI == false then
					if not (tostring(rI):lower():find("wait")) then
						pcall(function()
							ZI.Anchored = false
						end)
					end
				end
			end
			PI, dI = Z[32], os.clock() + 0.6 + Z[32]() * 2
			while ZI.Parent and ZI.Anchored and os.clock() < dI and (pI()) do
				nI = Z[23]
				nI()
			end
			if not (pI()) then
				return false
			end
		end
		pI = Z[15]
		local MI = pI()
		return MI ~= nil and not MI.Anchored
	end
	Z[14] = function(pI, MI)
		local ZI = Z[20]
		if ZI.inFuse then
			local nI = Z[20]
			if nI.inFuse() then
				local nI = Z[20]
				if not (nI.leaveFuse()) then
					return false
				end
			end
		end
		ZI = Z[1]
		local nI = ZI:GetAttribute("InEnchantedTree")
		ZI = nil
		if nI then
			local dI = Z[20]
			ZI = dI.leaveTree
		else
			ZI = nI
		end
		if ZI then
			nI = Z[11]
			nI("Leaving the Enchanted Tree")
			local dI = Z[20]
			dI.leaveTree()
			dI = os.clock() + 3
			while true do
				local qI, PI = os.clock() < dI and pI()
				if qI then
					local dI = Z[1]
					PI = (dI:GetAttribute("InEnchantedTree"))
				else
					PI = qI
				end
				if not PI then
					break
				end
				qI = Z[23]
				qI()
			end
		end
		ZI = Z[15]
		local dI, qI = ZI(), Z[47]
		nI = qI()
		if not dI then
			return false
		end
		ZI = Z[20]
		if ZI.hideTread then
			if not MI then
				qI = Z[16]
				if qI(dI.Position) then
					local PI = Z[20]
					PI.hideTread(3)
				end
			end
		end
		ZI, qI = not MI
		if MI then
			qI = ZI
		else
			local PI = Z[16]
			qI = PI(dI.Position)
		end
		if qI and (dI.Position - nI).Magnitude > 69 then
			ZI = Z[11]
			ZI("Moving to the safe zone")
			local ZI, qI = Z[53], Z[28]
			if not (ZI(nI + qI(0, 3, 0), pI, 250)) then
				return false
			end
			qI = os.clock() + 0.25
			while os.clock() < qI and (pI()) do
				ZI = Z[15]
				dI = ZI()
				if dI then
					MI = Z[33]
					dI.AssemblyLinearVelocity = MI
				end
				local pI = Z[23]
				pI()
			end
		end
		return true
	end
	local function pI(MI, ZI)
		if not (Z[13](ZI)) then
			return false
		end
		local nI = Z[15]
		local dI = nI()
		if not dI then
			return false
		end
		nI = Z[16]
		if nI(dI.Position) then
			local qI = Z[16]
			if not (qI(MI)) then
				local qI = Z[14]
				if not (qI(ZI)) then
					return false
				end
			end
		else
			if dI.Position.Y > 1000 then
				local qI = Z[14]
				if not (qI(ZI)) then
					return false
				end
			else
				local qI = Z[1]
				if qI:GetAttribute("InEnchantedTree") then
					local qI = Z[14]
					if not (qI(ZI)) then
						return false
					end
				end
			end
			local qI = Z[15]
			dI = qI()
			if dI then
				qI = Z[16]
				if not (qI(dI.Position)) then
					local qI = Z[16]
					if qI(MI) then
						local qI = Z[47]
						local PI, PI = Z[28], qI() + Z[28](0, 3, 0)
						if (dI.Position - PI).Magnitude > 1500 then
							if o() > 0 then
								qI = Z[21]
								if not (qI()) then
									local dI = Z[20]
									if dI.ragTo then
										local dI = Z[20]
										dI.ragTo(PI, ZI)
									end
								end
							end
						end
						qI = Z[53]
						if not (qI(PI, ZI, 400)) then
							return false
						end
					end
				end
			end
		end
		nI = Z[53]
		return nI(MI, ZI)
	end
	local function MI()
		local ZI, nI = J(), Z[22]
		if nI("Cycle", "IsNightPhase", ZI) then
			local dI = Z[22]
			local qI, PI = dI("Cycle", "NextResetTime", ZI), Z[20]
			local dI, rI = qI and qI + 5
			if dI then
				rI = dI
			else
				qI = Z[20]
				rI = qI.fieldAt
			end
			PI.fieldAt = rI
		end
		nI = Z[22]
		if nI("Wall", "IsSealed") then
			local dI = Z[20]
			return math.max((dI.fieldAt or ZI) - ZI, 0.3)
		end
		nI = Z[20]
		local dI = (nI.fieldAt or 0) - ZI
		return dI > 0 and dI or 0
	end
	local function ZI()
		local nI = workspace:GetAttribute("AdminBoost_Treadmill")
		if type(nI) == "number" then
			if nI > 1 then
				return true
			end
		end
		nI = Z[1]
		local dI = nI:FindFirstChild("PlayerGui")
		nI = dI and (dI:FindFirstChild("BottomUI"))
		nI = nI and (nI:FindFirstChild("BottomFrame"))
		nI = nI and (nI:FindFirstChild("Holder"))
		nI = nI and (nI:FindFirstChild("List"))
		nI = nI and (nI:FindFirstChild("AdminTreadmill"))
		return nI ~= nil and nI:IsA("GuiObject") and nI.Visible
	end
	Z[17] = function(nI, dI, qI)
		local PI, rI = false
		while nI() do
			local wI = MI()
			if wI <= 0 then
				if PI then
					local MI = os.clock() + (qI or 5)
					while os.clock() < MI do
						if not (nI()) then
							return false
						end
						local MI = Z[23]
						MI()
					end
				end
				return true
			end
			PI = true
			local MI = Z[15]
			local nI = MI()
			if nI then
				rI = rI or nI.Position
				if (nI.Position - rI).Magnitude > 4 then
					local qI, PI = Z[26], Z[27]
					qI(PI(rI))
				else
					MI = Z[33]
					nI.AssemblyLinearVelocity = MI
				end
			else
			end
			MI = Z[11]
			MI((dI or "Waiting") .. " - field opens in " .. math.ceil(wI) .. "s")
			MI = Z[23]
			MI()
		end
		return false
	end
	local function MI(nI)
		local dI = Z[54]
		local qI = dI("Areas", "GuardAreas", tostring(nI), "Guard")
		dI = qI and (qI:FindFirstChild("HumanoidRootPart", true))
		return dI and dI:IsA("BasePart") and dI or nil
	end
	local function nI(dI, qI)
		local PI = Z[1]
		local rI, wI, bI = "FirstAreaEgg_" .. PI.UserId, pairs, Z[18]
		PI = C[20](bI())
		local TI, yI
		for lI, WI in wI(C:QH(PI)) do
			bI = type(WI) == "table" and (WI.Uid or lI)
			lI = type(bI) == "string"
				and not qI[bI]
				and typeof(WI.BottomCFrame) == "CFrame"
				and (WI.State == nil or WI.State == "Slot" or WI.State == "Dropped")
			if lI then
				local qI = bI:sub(1, #rI) == rI
				local PI = if bI:sub(1, 13) == "FirstAreaEgg_"
					then qI and bI:match("_([%w ]+:Slot_%d+)$")
					else if type(WI.AreaId) == "string"
						then if type(WI.NestId) == "string" then WI.AreaId .. ":" .. WI.NestId else nil
						else nil
				local rI = qI and PI and PI:match("^([%w ]+):Slot_%d+$")
				local wI = PI and (MI(WI.AreaId) or rI and MI(rI) or qI and (MI("Forest")))
				if wI then
					rI, qI = WI.BottomCFrame.Position, Z[28]
					local MI = qI(rI.X - dI.X, 0, rI.Z - dI.Z).Magnitude
					if MI <= 600 and (if TI then MI < TI else not TI) then
						TI, yI = MI, { uid = bI, slot = PI, guard = wI, at = rI }
					else
					end
				else
				end
			else
			end
		end
		return yI
	end
	local function MI(dI, qI)
		local PI = Z[39]
		local rI, wI = PI:FindFirstChild("RE/GuardPatrol/ForestStrike"), Z[15]
		PI = wI()
		if rI then
			if PI then
				wI = Z[34]
				if wI.Egg then
					local bI = Z[21]
					if bI() then
						return false
					else
						local bI = Z[29]
						if bI() then
							return false
						end
					end
				else
					return false
				end
			else
				return false
			end
		else
			return false
		end
		local bI = type(dI) == "function" and dI or function()
			return dI
		end
		if not (Z[13](qI)) then
			return false
		end
		local dI, TI = {}, Z[20]
		TI.rag = true
		TI = nil
		for yI = 1, 3, 1 do
			yI = Z[15]
			wI = nI((yI() or PI).Position, dI)
			if wI then
				if not (qI()) then
					break
				end
			else
				break
			end
			yI = 0
			while true do
				local nI = Z[21]
				local lI = nI(wI.uid)
				if not ((if lI then not lI else yI < 2.5) and qI()) then
					break
				end
				nI = Z[15]
				lI = nI()
				nI = nil
				if lI then
					local WI = lI.Anchored
					if WI then
						nI = WI
					else
						local WI = Z[20]
						nI = WI.onAdmin
					end
				else
					nI = lI
				end
				if nI then
					if not (Z[13](qI)) then
						lI = Z[20]
						lI.rag = false
						return false
					end
				end
				lI, nI = Z[26], Z[27]
				lI(nI(wI.at + Z[28](0, 3, 0)))
				local nI, nI, nI, WI = Z[34], pcall(Z[34].Egg.CarryFieldEgg, wI.uid, wI.slot)
				if nI ~= true then
					if type(WI) == "string" then
						if WI:lower():find("full") then
							lI = Z[20]
							lI.rag = false
							return false
						end
					end
				end
				if nI ~= true then
					if type(WI) == "string" then
						if yI > 0.4 then
							if not (WI:lower():find("closer")) then
								break
							end
						end
					end
				end
				nI = Z[23]
				yI += nI()
			end
			yI = Z[21]
			if yI(wI.uid) then
				TI = wI
				break
			end
			dI[wI.uid] = true
		end
		if not TI then
			dI = Z[20]
			dI.rag = false
			return false
		end
		local nI, yI = false, Z[1]
		local lI, WI, EI, FI =
			yI:GetAttributeChangedSignal("RagdollEndTime"):Connect(function()
				if nI then
					return
				else
					local sI = Z[29]
					if not (sI()) then
						return
					end
				end
				local sI = bI()
				if sI then
					nI = true
					local aI, JI = Z[26], Z[27]
					aI(JI(sI))
				end
			end), pcall, rI.FireServer, { EggUid = TI.uid }
		FI.GuardCFrame = TI.guard.CFrame
		WI(EI, rI, FI)
		yI = 0
		while true do
			rI = not nI and yI < 3
			if not (rI and qI()) then
				break
			end
			wI = Z[23]
			yI += wI()
		end
		lI:Disconnect()
		lI = Z[21]
		if lI(TI.uid) then
			PI = Z[22]
			PI("Egg", "DropFieldEgg", "PlayerRequest")
		end
		lI = Z[20]
		lI.rag = false
		if nI then
			rI = Z[20]
			if rI.burst then
				PI = Z[20]
				PI.burst()
			end
			task.spawn(function()
				local qI = Z[8]
				local PI, rI, wI =
					qI(),
					os.clock() + 1.5,
					{
						[Enum.HumanoidStateType.Freefall] = true,
						[Enum.HumanoidStateType.Physics] = true,
						[Enum.HumanoidStateType.Ragdoll] = true,
						[Enum.HumanoidStateType.FallingDown] = true,
						[Enum.HumanoidStateType.None] = true,
					}
				while PI and PI.Parent and os.clock() < rI do
					if wI[PI:GetState()] then
						pcall(PI.ChangeState, PI, Enum.HumanoidStateType.GettingUp)
					end
					if PI.PlatformStand then
						if not Z[4] then
							PI.PlatformStand = false
						end
					end
					qI = Z[23]
					qI()
				end
			end)
		end
		TI, WI = bI(), Z[15]
		dI = WI()
		WI = nI and TI ~= nil and dI ~= nil and (dI.Position - TI).Magnitude <= 30
		return WI
	end
	Z[20].ragTo = MI
	local function nI(dI, qI, PI, rI, wI)
		local bI = Z[20]
		if bI.ready then
			local TI = Z[20]
			TI.ready(qI)
		end
		local TI, yI, lI = os.clock() + (rI or 30), os.clock, 1 / 0
		rI, bI = yI(), 1
		while qI() and os.clock() < TI do
			yI = Z[15]
			local WI = yI()
			if not WI then
				return false
			end
			if WI.Anchored then
				if not (Z[13](qI)) then
					return false
				end
			end
			local yI = Z[28]
			local EI = yI(dI.X - WI.Position.X, 0, dI.Z - WI.Position.Z)
			if EI.Magnitude <= (PI or 6) then
				yI = Z[33]
				WI.AssemblyLinearVelocity = yI
				return true
			end
			if WI.Anchored then
				Z[13](qI)
			end
			if EI.Magnitude < lI - 5 then
				lI, rI = EI.Magnitude, os.clock()
			else
			end
			yI = EI.Unit
			if os.clock() - rI > 2 then
				local dI = Z[8]
				local qI = dI()
				if qI then
					qI.Jump = true
				end
				qI = Z[28]
				yI = (yI + qI(-yI.Z, 0, yI.X) * bI).Unit
				if os.clock() - rI > 3.5 then
					rI, bI = (os.clock()), -bI
				else
				end
			else
			end
			local dI, qI
			dI, qI, WI.AssemblyLinearVelocity =
				Z[44],
				Z[28],
				yI * math.min(Z[44]() * (wI or 0.95), EI.Magnitude / 0.05) + Z[28](0, WI.AssemblyLinearVelocity.Y, 0)
			qI = Z[23]
			qI()
		end
		TI = Z[15]
		rI = TI()
		if rI then
			PI = Z[33]
			rI.AssemblyLinearVelocity = PI
		end
		return false
	end
	local dI = {}
	local function qI(PI, rI, wI)
		if dI[PI] then
			dI[PI]:Disconnect()
			dI[PI] = nil
		end
		if rI then
			dI[PI] = W(rI, wI)
		end
	end
	local dI, PI, rI =
		{},
		{},
		{
			{
				"Farm",
				nil,
				{
					"+Auto Steal",
					"Auto Progression",
					"Auto Mutation",
					"Auto Place Egg",
					"Auto Treadmill",
					"Auto Hatch & Equip",
					"Keep Eggs",
					"Auto Sell",
					"Auto Fuse Machine",
					"Auto Favorite",
					"Priority Rotation",
					"Priority",
				},
			},
			{ "Event", nil, { "Alien Biome", "Shooting Star", "Skyfall", "Black Market", "Butterfly Bloom" } },
			{
				"Admin Abuse",
				"Right",
				{ "Capture The Egg", "Admin Treadmill", "Instant Steal V3", "Minigame Eggs", "Cursed Island Wars" },
			},
			{ "Player", nil, { "ESP", "+Movement", "+Character", "+Combat" } },
			{ "Predictor", nil, { "Discord Webhook", "+Egg Predictor", "Fuse Predictor" } },
			{ "Server", nil, { "+Server" } },
			{ "Misc", nil, { "+Performance", "+Utility" } },
			{ "Auto Hop", nil, { "+Egg Finder" } },
			{ "Discord", "Right", { "+Community" } },
			{ "Venyx", "Right", { "+Venyx" } },
		}
	for wI, bI in ipairs(rI) do
		wI = z:Tab(bI[1], bI[2])
		PI[bI[1]] = wI
		for rI, TI in ipairs(bI[3]) do
			rI = TI:sub(1, 1) == "+"
			TI = rI and TI:sub(2) or TI
			dI[TI] = wI:Section(TI, rI)
		end
	end
	local function rI(wI)
		return z.open and z.Cur == PI[wI]
	end
	w("02_admin#1", function()
		local wI = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold)
		local bI, TI, yI, lI, WI, EI, FI, sI, aI, JI =
			Font.new("rbxassetid://12187365977", Enum.FontWeight.Bold),
			0.7,
			2.1,
			5.6,
			0.95,
			0.0909,
			1.35,
			"#9AA3B5",
			"rbxassetid://116524274262912",
			3.3
		local YI, RI =
			{ live = { "LIVE", "#4DFF7A" }, active = { "ACTIVE", "#4DFF7A" }, wait = { "WAITING", "#FFC24D" }, off = {
				"OFF",
				sI,
			} },
			{
				Treadmill = "rbxassetid://84421204509494",
				["Sci-FiTreadmill"] = "rbxassetid://81563639782445",
				FlameTreadmill = "rbxassetid://103122274001487",
				CelebrityTreadmill = "rbxassetid://75188836342954",
				GoldenTreadmill = "rbxassetid://99555941892079",
				["The FreezeTreadmill"] = "rbxassetid://97611802500180",
				["Lucky BlockTreadmill"] = "rbxassetid://85546442623094",
				HackerTreadmill = "rbxassetid://114661675379027",
				DemonicTreadmill = "rbxassetid://99849961715962",
				AngelicTreadmill = "rbxassetid://104277706019985",
				AstralTreadmill = "rbxassetid://118444572497588",
			}
		local function eI(fI)
			return workspace:GetAttribute(fI)
		end
		local function fI(QI)
			local uI = game
			if not (QI:IsDescendantOf(uI)) then
				return false
			end
			while QI do
				if QI:IsA("GuiObject") then
					if not QI.Visible then
						return false
					end
				end
				if QI:IsA("LayerCollector") then
					return QI.Enabled
				end
				QI = QI.Parent
			end
			return false
		end
		local function QI(uI)
			local AI = uI.Set
			uI.Set = function(hI)
				local mI
				for kI, LI in next, hI, nil do
					if uI.Spec[kI] ~= LI then
						mI = mI or {}
						mI[kI] = LI
					else
					end
				end
				if mI then
					AI(mI)
				end
			end
			return uI
		end
		local function uI(AI)
			return (tostring(AI):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
		end
		local function AI(hI, mI)
			local kI, LI, gI, iI, tI, xI, SI, HI, _I, oI, BI, vI, zI, cI, DI
			local function NI()
				local VI, II = math.max(1, oI - JI - 0.5), zI and cI
				local jI = II and math.max(1, VI - FI - 0.3) or VI
				iI.Set({ Visible = zI })
				local KI, XI = tI.Set, { Visible = zI }
				XI.Width = math.max(1, VI - lI - 0.3)
				KI(XI)
				XI, KI = xI.Set, { Visible = zI }
				KI.X = JI + VI - lI
				XI(KI)
				HI.Set({ Visible = zI, Width = jI })
				XI = nil
				if II then
					local VI, KI, UI, GI = math.min, HI.Get().TextBounds.X, math.max, BI
					XI = JI + VI(jI, KI / UI(GI / math.max(oI, 1), 1)) + 0.25
				else
					XI = JI
				end
				_I.Set({ Visible = II, X = XI })
				XI = 0.2 + (zI and 2.6 or 0) + 0.15
				LI.Set({ Width = oI, Height = XI })
				gI.Set({ Height = XI })
				if XI ~= vI then
					vI = XI
					kI:SetContentLines(XI)
				end
			end
			local function vI()
				local VI, II, jI, KI, XI, UI = mI()
				local mI, GI = YI[jI], UI ~= nil
				gI.Set({ Background = mI[2] })
				iI.Set({ Image = KI, StrokeColor = mI[2] })
				jI, KI = tI.Set, {}
				KI.Text = "<b>" .. uI(VI) .. "</b>"
				jI(KI)
				xI.Set({ StrokeColor = mI[2] })
				KI, VI = SI.Set, { Text = uI(XI or mI[1]) }
				VI.Color = Color3.fromHex(mI[2])
				KI(VI)
				KI, jI = HI.Set, {}
				jI.Text = '<font color="' .. sI .. '">' .. uI(II) .. "</font>"
				KI(jI)
				if GI then
					_I.Set({ Image = UI })
				end
				if cI ~= GI then
					cI, zI, DI = GI, true, true
				elseif GI then
					cI, zI, DI = GI, true, true
				elseif not zI then
					cI, zI, DI = GI, true, true
				end
			end
			hI:Surface({
				Name = "Status",
				ShowTitle = false,
				Layout = "free",
				Style = {
					TextScale = 1,
					LineHeight = 1.1,
					MinLines = 2,
					MaxLines = 24,
					BackgroundTransparency = 0.5,
					TextColor = Color3.new(1, 1, 1),
					TextStrokeTransparency = 0.7,
				},
				Build = function(YI)
					kI = YI
					LI = QI(YI:Frame({ Width = 1, Height = 2, Corner = 0.35 }))
					gI = QI(YI:Frame({ Parent = LI, Width = 0.22, Height = 2, Corner = 0.11, Background = sI }))
					iI = QI(
						YI:Image({
							Parent = LI,
							X = TI,
							Y = 0.45,
							Width = yI,
							Height = yI,
							Corner = 0.35,
							BackgroundTransparency = 0.45,
							StrokeThickness = EI,
							Visible = false,
						})
					)
					tI = QI(
						YI:Text({
							Parent = LI,
							X = JI,
							Y = 0.5,
							Height = 1.1,
							Scale = 1.05,
							Wrap = false,
							Font = wI,
							TextStrokeTransparency = 1,
							Visible = false,
						})
					)
					xI = QI(
						YI:Frame({
							Parent = LI,
							Y = 0.55,
							Width = lI,
							Height = WI,
							Corner = 0.3,
							BackgroundTransparency = 0.35,
							StrokeThickness = EI,
							Visible = false,
						})
					)
					SI = QI(
						YI:Text({
							Parent = xI,
							Width = lI,
							Height = WI,
							Scale = 0.78,
							Wrap = false,
							Align = "Center",
							VAlign = "center",
							Font = bI,
							TextStrokeTransparency = 1,
						})
					)
					HI = QI(
						YI:Text({ Parent = LI, X = JI, Y = 1.5999999999999999, Height = 1, Scale = 0.92, Wrap = false, Visible = false })
					)
					_I = QI(
						YI:Image({
							Parent = LI,
							Y = 1.5999999999999999 + (1 - FI) / 2,
							Width = FI,
							Height = FI,
							Corner = 0.25,
							Visible = false,
						})
					)
					tI.Get().TextTruncate = Enum.TextTruncate.AtEnd
					HI.Get().TextTruncate = Enum.TextTruncate.AtEnd
					YI:OnResize(function(wI, bI, TI)
						if bI ~= BI then
							wI = nil
							wI, BI = bI / math.max(TI, 1), bI
							oI, DI = wI, true
						end
					end)
				end,
			})
			local wI = 1
			W(y, function(bI)
				if kI then
					if not (fI(kI:Root())) then
						return
					end
				else
					return
				end
				wI += bI
				if wI >= 0.5 then
					wI = 0
					pcall(vI)
				end
				if DI then
					DI = false
					pcall(NI)
				end
			end)
		end
		local function wI()
			local bI = eI("AdminBoost_Treadmill")
			return type(bI) == "number" and bI > 1 and "x" .. bI or nil
		end
		AI(dI["Capture The Egg"], function()
			local bI = Z[25]
			local TI, yI = bI.capture
			if TI then
				bI = Z[20]
				yI = bI.capSt or "Waiting for Capture The Egg"
			else
				yI = TI
			end
			bI = yI or "Off"
			return "Capture The Egg",
				bI == "Off" and "Turn on Capture The Egg below to join the event" or bI,
				(eI("Event_CaptureTheEgg") or eI("Event_CaptureTheEggGameplay")) and "live"
					or bI == "Off" and "off"
					or "wait",
				aI
		end)
		AI(dI["Admin Treadmill"], function()
			local bI, TI, yI, lI, WI = wI(), workspace:FindFirstChild("AdminTreadmill"), Z[25]
			if yI.adminTread then
				if if bI then not bI else not TI then
					lI, WI = "Waiting for the Admin Treadmill", "wait"
				else
					local EI = Z[20]
					if EI.onAdmin then
						lI, WI = "Running on the Admin Treadmill " .. (bI or "on"), "active"
					else
						lI, WI = "Going to the Admin Treadmill " .. (bI or "on"), "live"
					end
				end
			else
				lI, WI = "Turn on Use Admin Treadmill below", "off"
			end
			yI = RI.AngelicTreadmill
			for bI, bI in ipairs(TI and TI:GetChildren() or {}) do
				if RI[bI.Name] then
					yI = RI[bI.Name]
					break
				end
			end
			return "Admin Treadmill", lI, WI, yI
		end)
		AI(dI["Instant Steal V3"], function()
			local bI, TI = wI(), Z[25]
			local wI = TI.adminSteal
			local yI, lI = (if wI then not wI else "Toggle is off")
				or (if bI then not bI else "Needs Admin Treadmill to work")
			if yI then
				lI = yI
			else
				TI = Z[25]
				wI = TI.steal
				lI = if wI then not wI else "Turn on Auto Steal in the Farm tab"
			end
			wI, TI = lI or "Ready, waiting for an egg, " .. bI, Z[25]
			if TI.adminSteal then
				if bI ~= nil then
					yI = Z[25]
					if yI.steal == true then
						return "Instant Steal V3", wI, "active", i.tread, utf8.char(128994) .. " ACTIVE"
					end
				end
			end
			lI = Z[25]
			return "Instant Steal V3",
				wI,
				"off",
				i.tread,
				utf8.char(128308) .. " INACTIVE",
				lI.adminSteal and not bI and i.tread or nil
		end)
		AI(dI["Minigame Eggs"], function()
			local wI, bI =
				eI("Event_RedLightGreenLight") == true and "Red Light Green Light"
					or eI("Event_TrexRun") == true and "T-Rex Run",
				Z[20]
			local TI, yI, lI = bI.mgSt or "Off", wI or "Minigame Egg", Z[25]
			local bI, WI = lI.minigame and TI or "Turn on Auto Steal Minigame Egg below", Z[25]
			lI = WI.minigame
			return yI,
				bI,
				(if lI then not lI else "off")
					or (TI == "Carrying the egg home" or TI:find("^Going for")) and "active"
					or wI and "live"
					or "wait",
				aI
		end)
	end)
	local wI, bI = { links = {}, rig = 0, body = 0, at = 0 }, {}
	Z[3] = wI
	Z[5] = bI
	Z[5][Enum.HumanoidStateType.Running] = true
	Z[5][Enum.HumanoidStateType.RunningNoPhysics] = true
	Z[5][Enum.HumanoidStateType.Landed] = true
	local wI = {}
	C:EH(wI, 0, Enum.HumanoidStateType.FallingDown, Enum.HumanoidStateType.Ragdoll, Enum.HumanoidStateType.Physics)
	Z[6] = function(bI)
		workspace.CurrentCamera.CameraSubject = bI
		pcall(function()
			local TI
			TI, require(Z[1].PlayerScripts.PlayerModule):GetControls().humanoid = Z[1], bI
		end)
		local bI = Z[1]
		local TI, yI = bI.Character
		if TI then
			bI = Z[1]
			yI = bI.Character:FindFirstChild("Animate")
		else
			yI = TI
		end
		if yI then
			task.spawn(function()
				yI.Enabled = false
				task.wait()
				yI.Enabled = true
			end)
		end
	end
	Z[7] = function()
		local bI = Z[3]
		for TI, TI in ipairs(bI.links) do
			TI:Disconnect()
		end
		table.clear(Z[3].links)
		local bI, TI = Z[3], Z[3]
		bI.o = nil
		TI.c = nil
	end
	Z[2] = function()
		local bI = Z[3]
		local TI, yI = bI.c ~= nil
		if TI then
			local bI, lI = Z[3]
			lI, yI = Z[1], bI.c.Parent == Z[1].Character
		else
			yI = TI
		end
		return yI
	end
	local function bI()
		local TI = Z[3]
		local yI, lI = TI.o, Z[3]
		local WI, EI = lI.c, Z[1]
		TI, lI = EI.Character, Z[7]
		lI()
		if yI then
			if WI then
				if TI then
					if WI.Parent == TI then
						yI.Parent = TI
						lI = Z[6]
						lI(yI)
						WI:Destroy()
					end
				end
			end
		end
	end
	local TI = C:FH(1, 2, { [1] = Z, [2] = Z, [3] = Z, [4] = Z, [5] = Z, [6] = Z, [7] = Z }, O, p, nil)
	local function yI(lI)
		local WI = ipairs
		for EI, EI in WI(wI) do
			local wI, FI, sI = pcall, lI.SetStateEnabled, Z[25]
			local aI, JI = sI.god
			if aI then
				JI = aI
			else
				sI = Z[20]
				JI = sI.godHunt
			end
			wI(FI, lI, EI, not JI)
		end
		WI = Z[25]
		if WI.god then
			if lI.Health > 0 then
				if lI.Health < lI.MaxHealth then
					lI.Health = lI.MaxHealth
				end
			end
		end
	end
	w("05_swap#1", function()
		local wI, lI = false, false
		local function WI(EI)
			wI = false
			if not EI then
				return
			end
			local function FI(sI)
				if sI:IsA("Humanoid") then
					sI.Died:Once(function()
						wI = true
					end)
				end
			end
			for sI, sI in ipairs(EI:GetChildren()) do
				FI(sI)
			end
			EI.ChildAdded:Connect(FI)
		end
		local EI = Z[1]
		WI(EI.Character)
		EI = Z[1]
		W(EI.CharacterRemoving, function()
			lI = not wI
		end)
		EI = Z[1]
		W(EI.CharacterAdded, function(wI)
			local FI = Z[7]
			FI()
			WI(wI)
			local wI, WI, FI, sI = Z[3], Z[3], Z[3], lI
			wI.gate, WI.body, FI.at = sI, os.clock(), os.clock() + 1
			lI = false
		end)
		EI = Z[39]
		local wI = EI:FindFirstChild("RE/RigSync/Refresh")
		if wI then
			W(wI.OnClientEvent, function()
				local wI = Z[3]
				wI.rig = os.clock()
			end)
		end
	end)
	local function wI()
		local lI = Z[20]
		local WI, EI = lI.invisBusy
		if WI then
			EI = WI
		else
			lI = Z[25]
			local FI = lI.moveTo == "Teleport"
			if FI then
				local sI = Z[25]
				EI = sI.steal
			else
				EI = FI
			end
		end
		lI = nil
		if EI then
			lI = EI
		else
			WI = Z[20]
			local EI = WI.realHum ~= nil
			if EI then
				local WI = Z[20]
				lI = WI.realHum()
			else
				lI = EI
			end
		end
		return lI
	end
	Z[20].ready = function(lI, WI)
		local EI = os.clock() + (WI or 1.5)
		while true do
			WI = Z[2]
			local FI = WI()
			if not ((if FI then not FI else not wI()) and os.clock() < EI and lI()) then
				break
			end
			TI()
			FI = Z[2]
			if FI() then
				return true
			end
			FI = Z[23]
			FI()
		end
		return true
	end
	local lI = G({ name = "Shield", gap = 0.25 })
	lI.on = function()
		return true
	end
	lI.fn = function()
		local lI = Z[20]
		if lI.agBusy then
			return
		end
		D("swap", function()
			if wI() then
				local wI = Z[2]
				if wI() then
					bI()
				end
			else
				TI()
			end
			local wI = Z[8]
			local TI = wI()
			if TI then
				yI(TI)
			end
		end)
	end
	local wI = G({ name = "Steal", mover = true, gap = 0.5, pri = 2, hold = true })
	wI.on = function()
		local TI = Z[25]
		local lI, WI = TI.steal
		if lI then
			WI = lI
		else
			TI = Z[20]
			local lI = TI.wispSteals ~= nil
			if lI then
				local TI = Z[20]
				WI = TI.wispSteals()
			else
				WI = lI
			end
		end
		return WI
	end
	w("10_steal#1", function()
		local TI = {}
		local lI, WI = 0, Z[39]
		TI[48] = lI
		local lI = WI:FindFirstChild("RE/EggWorld/FieldEggRedeemVerdict")
		if lI then
			W(lI.OnClientEvent, function(EI)
				TI[48] = os.clock()
				local FI = Z[46]
				FI.stolen = FI.stolen + 1
				if wI.cv then
					FI = Z[46]
					if wI.cv > (FI.best or 0) then
						local sI, aI = Z[46], Z[46]
						sI.best, aI.bestCat = wI.cv, type(EI) == "table" and EI.AssetCategory or nil
					end
				end
				local sI, aI, JI = Z[46], type(EI) == "table"
				if aI then
					FI = EI.DisplayName
					if FI then
						JI = FI
					else
						local YI = Z[74]
						JI = YI(EI.AssetCategory)
					end
				else
					JI = aI
				end
				sI.last = JI or "Egg"
				FI = Z[46]
				FI.lastCat = type(EI) == "table" and EI.AssetCategory or nil
				aI = Z[20]
				if aI.onSteal then
					FI = Z[20]
					FI.onSteal(EI)
				end
			end)
		end
		local EI, FI, sI, aI = Z[25], Z[25], Z[25], Z[25]
		EI.runK = 1.14
		FI.pullSpd = 3300
		sI.thief = true
		aI.carryK = 1
		WI, lI = dI["Auto Steal"], Z[20]
		lI.stealSec = WI
		local JI = Z[20]
		JI.stopSteal = function()
			local JI, YI = Z[4] == wI and wI.plan, Z[20]
			local RI = YI.curUid or type(JI) == "table" and not JI.carry and JI.Uid
			if RI then
				YI = Z[20]
				YI.skip[RI] = true
			end
			CI(wI)
			JI = Z[20]
			JI.curUid = nil
		end
		local JI = Z[20]
		JI.retarget = function()
			local JI = Z[20]
			JI.fresh()
			JI = Z[20]
			if JI.curUid then
				local JI = Z[21]
				if not (JI()) then
					CI(wI)
					local JI = Z[20]
					JI.curUid = nil
				end
			end
		end
		sI = Z[20]
		sI.autoSteal = j(WI, "Auto Steal", "steal", false, function(JI)
			if JI then
				local YI = Z[20]
				if YI.unblock then
					local YI = Z[20]
					YI.unblock()
				end
			else
				CI(wI)
				local YI = Z[20]
				YI.curUid = nil
				table.clear(Z[20].pick)
			end
			JI = Z[20]
			if JI.hud then
				local JI = Z[20]
				JI.hud.Sync()
				JI = Z[20]
				JI.hud.Refresh()
			end
		end)
		local JI, YI = _({ "Alien", "Enchanted Forest", "Light Dark", "Titan Temple" }), Z[20]
		YI.cmode = function(YI)
			local RI = Z[25]
			if RI.moveTo == "Teleport" then
				local eI = Z[20]
				if eI.tpNow then
					return YI and "Teleport" or "Tween"
				end
			end
			YI = Z[20]
			if YI.lagoonSteal then
				RI = Z[25]
				if RI.moveTo ~= "Teleport" then
					local eI = Z[25]
					local fI, QI = eI.insDel == "Fast Tween"
					if fI then
						QI = fI
					else
						eI = Z[25]
						QI = eI.insDel == "Instant Steps"
					end
					return QI and "Instant steps" or "Tween"
				end
			end
			YI = Z[25]
			local eI, fI = YI.insDel == "Fast Tween" and "Fast tween"
			if eI then
				fI = eI
			else
				RI = Z[25]
				fI = RI.insDel == "Instant Steps" and "Instant steps"
			end
			return fI or "Tween"
		end
		aI = Z[20]
		aI.TZ = { "Prehistoric", "Cosmic", "Cherry Blossom", "Titan Temple", "Light Dark", "Enchanted Forest", "Alien" }
		aI = Z[20]
		aI.TPM = { "Walk", "Quick Steps", "Fast Tween" }
		local YI = Z[20]
		YI.tpDel = function()
			local YI = Z[20]
			local RI, eI = YI.tpOv
			if RI then
				eI = RI
			else
				YI = Z[25]
				eI = YI.tpDel
			end
			return eI
		end
		local YI = Z[20]
		YI.tpCodium = function()
			local YI = Z[20]
			local RI, eI = YI.tpDel() == "Quick Steps"
			if RI then
				eI = RI
			else
				YI = Z[20]
				eI = YI.tpDel() == "Fast Tween"
			end
			return eI
		end
		local YI = Z[20]
		YI.tpRapid = function()
			local YI = Z[20]
			return YI.tpDel() == "Fast Tween"
		end
		function z.pre(YI)
			local function RI(eI)
				for fI, QI in next, YI, nil do
					fI = type(QI) == "table" and QI["Auto Steal"]
					QI = type(fI) == "table" and fI[eI]
					if type(QI) == "table" then
						return QI, fI
					end
				end
			end
			local YI, eI = RI("Instant Steal V2")
			if YI then
				if YI.Value == true then
					eI["Instant Steal"], eI.Delivery = { Value = true }, { Value = "Fast Tween" }
				end
			end
			local fI, QI, QI = RI("Fast Delivery"), RI("Instant Steal")
			if fI then
				if fI.Value == true then
					if QI then
						if not QI.Delivery then
							QI.Delivery = { Value = "Fast Tween" }
						end
					end
				end
			end
			fI = RI("V2 Tween Speed")
			if fI then
				if eI then
					if not eI["Fast Tween Speed"] then
						eI["Fast Tween Speed"] = fI
					end
				end
			end
			QI, eI = RI("Tween Speed")
			if QI then
				fI = tonumber(QI.Value)
				if fI then
					if fI > 120 then
						eI["Fast Tween Speed"] = eI["Fast Tween Speed"] or QI
					end
				end
			end
			YI, fI = RI("Carry Speed")
			if YI then
				fI["Delivery Speed"] = fI["Delivery Speed"] or YI
			end
			QI, eI = RI("Instant Steal Steps")
			if QI then
				eI["Step Count"] = eI["Step Count"] or QI
			end
			fI, QI = RI("Instant Steal")
			if QI and fI.Value ~= true then
				QI.Delivery = { Value = "Walk" }
			elseif QI then
				if not QI.Delivery then
					QI.Delivery = { Value = "Instant Steps" }
				end
			end
			eI, fI = RI("Delivery")
			if eI and (eI.Value == "Codium Steps" or eI.Value == "Quick Steps") then
				fI["Teleport Delivery"] = fI["Teleport Delivery"] or { Value = "Quick Steps" }
				eI.Value = "Walk"
			end
			if eI then
				if eI.Value == "Tween" then
					eI.Value = "Walk"
				end
			end
			YI = RI("Teleport Delivery")
			if YI then
				if YI.Value == "Rapid Carry" then
					YI.Value = "Fast Tween"
				end
			end
		end
		local function YI(RI)
			return function(eI)
				return eI == RI
			end
		end
		FI = K(WI, "Move To Egg", "moveTo", { "Walk", "Teleport" }, "Walk")
		local RI, eI =
			K(WI, "Delivery", "insDel", { "Walk", "Instant Steps", "Fast Tween" }, "Walk"):When(FI, (YI("Walk"))),
			K(WI, "Teleport Delivery", "tpDel", { "Walk", "Quick Steps", "Fast Tween" }, "Walk"):When(
				FI,
				(YI("Teleport"))
			)
		pcall(function()
			eI.row.lb.Text = "Delivery"
		end)
		aI = Z[20]
		K(
			WI,
			"Teleport Zones",
			"tpZones",
			aI.TZ,
			{ "Titan Temple", "Light Dark", "Enchanted Forest", "Alien" },
			nil,
			true
		):When(FI, (YI("Teleport")))
		WI:Slider("Delivery Speed", 80, 110, 100, function(eI)
			local fI = Z[25]
			fI.carryK = eI / 100
		end, "%", 1):When(RI, (YI("Walk")))
		X(WI, "Step Count", "stepsN", 1, 6, 3, nil, 1):When(RI, (YI("Instant Steps")))
		X(WI, "Fast Tween Speed", "pullSpd", 3000, 4500, 3300, nil, 50):When(RI, (YI("Fast Tween")))
		local eI, fI = {}, Z[20]
		fI.stealFilter = eI
		local QI, uI =
			{
				["Best Rarity"] = "Best rarity",
				["Biggest Weight"] = "Biggest",
				["Best Mutation"] = "Best mutation",
				["Highest Value"] = "Best value",
				["Lowest Value"] = "Lowest value",
			},
			Z[25]
		uI.order = "Best value"
		WI:Dropdown(
			"Steal Priority",
			{ "Best Rarity", "Biggest Weight", "Best Mutation", "Highest Value", "Lowest Value" },
			"Highest Value",
			function(AI)
				local hI = Z[25]
				hI.order = QI[AI] or "Best value"
				I()
			end
		)
		aI = Z[20]
		lI, FI, RI =
			aI.AREAS, Z[20], function(FI)
				local QI = Z[25]
				QI.zones = nil
				QI = Z[20]
				if not (QI.allAreas(FI)) then
					local QI = ipairs
					for AI, hI in QI(FI) do
						local FI, QI = Z[25], Z[25]
						FI.zones = QI.zones or {}
						AI = Z[25]
						AI.zones[hI:gsub("%s", "")] = true
					end
					local FI, QI = Z[25], Z[25]
					FI.zones = QI.zones or {}
				end
				I()
			end
		WI:Dropdown("Target Areas", lI, Z[20].AREAS, RI, true)
		fI = Z[20]
		local function FI(QI)
			local AI = Z[20]
			eI.rar = AI.minRar(QI)
			I()
		end
		WI:Dropdown("Min Rarity", fI.RANY, "Any", FI, false)
		WI:Slider("Min Steal Value", 0, 0, 0, function(QI)
			eI.minV = QI > 0 and QI or nil
			I()
		end, "log")
		local QI, AI, hI = {}, {}, Z[20]
		FI = #hI.RANY
		for mI = 2, FI, 1 do
			EI = Z[20]
			fI, aI, lI = Z[20], EI.RIDX[Z[20].RANY[mI]] or 0, Z[20]
			if aI >= (lI.RIDX.Cosmic or 7) then
				hI = nil
				hI, AI[#AI + 1] = Z[20], Z[20].RANY[mI]
			end
		end
		sI, YI =
			WI:Dropdown(
				"Rarity Min Value",
				AI,
				AI[#AI],
				function() end,
				false,
				"Pick a rarity to set its own min value"
			),
			ipairs
		for fI, fI in YI(AI) do
			uI, lI, aI =
				fI .. " Min Value", function(mI)
					local kI = Z[20]
					QI[kI.RIDX[fI]] = mI > 0 and mI or nil
					eI.rmin = next(QI) and QI or nil
					I()
				end, function(QI)
					return QI == fI
				end
			WI:Slider(uI, 0, 0, 0, lI, "log", nil, "0 = use Min Steal Value"):When(sI, aI)
		end
		YI = Z[20]
		local function sI(aI)
			local fI = Z[20]
			eI.sp = fI.names(aI)
			I()
		end
		WI:Dropdown("Target Specific Eggs", YI.eggList, {}, sI, true)
		j(WI, "Steal Missing Index Eggs", "index", false)
		FI = dI["Instant Steal V3"]
		FI:Text("Instant Steal V3 Note", "Needs Admin Treadmill")
		j(FI, "Use Instant Steal V3", "adminSteal", true)
		TI[43] = function()
			local FI = Z[25]
			return FI.dropSafe == true
		end
		TI[19] = function(FI, sI)
			local aI = Z[20]
			aI.ready(sI)
			aI = Z[8]
			local fI, QI = aI(), Z[44]
			local uI, mI, kI, LI = QI(), os.clock() + 60, os.clock, 1 / 0
			local gI, iI, tI, xI = kI(), false, false, 0
			while sI() and os.clock() < mI do
				QI = Z[15]
				kI, aI = QI(), Z[8]
				local SI = aI()
				if kI then
					if not SI then
						break
					end
				else
					break
				end
				if kI.Anchored then
					if not (Z[13](sI)) then
						break
					end
				end
				local aI = Z[28]
				local HI = aI(FI.X - kI.Position.X, 0, FI.Z - kI.Position.Z)
				aI = HI.Magnitude
				if aI < LI - 5 then
					LI, gI = aI, os.clock()
				else
					if if iI then not iI else os.clock() - gI > 0.8 then
						local LI = Z[9]
						LI("RF/Treadmill/AskDoff")
						iI = true
					else
						if os.clock() - gI > 3 then
							local LI = Z[20]
							if LI.respawn then
								local LI = Z[11]
								LI("Stuck in place, resetting the character")
								LI = Z[20]
								LI.respawn(true)
								break
							end
						end
					end
				end
				if aI <= 2.5 and kI.Position.Y - FI.Y < 4 then
					tI = true
					break
				end
				local LI, LI = Z[25], math.max(math.min(uI * Z[25].runK, aI / 0.1), 16)
				SI.WalkSpeed = LI
				if os.clock() - gI > 1 then
					if SI.FloorMaterial ~= Enum.Material.Air then
						SI.Jump = true
					end
				end
				if os.clock() >= xI then
					xI = os.clock() + 0.25
					aI = Z[28]
					SI:MoveTo(aI(FI.X, kI.Position.Y, FI.Z))
				else
				end
				aI = nil
				aI, kI.AssemblyLinearVelocity = Z[28], HI.Unit * LI + Z[28](0, kI.AssemblyLinearVelocity.Y, 0)
				SI = Z[23]
				SI()
			end
			sI = Z[8]
			QI = sI()
			if QI then
				QI:MoveTo(QI.RootPart and QI.RootPart.Position or FI)
				if QI == fI then
					QI.WalkSpeed = uI
				end
			end
			fI = Z[15]
			mI = fI()
			if mI then
				if tI then
					xI = Z[28]
					mI.AssemblyLinearVelocity = xI(0, mI.AssemblyLinearVelocity.Y, 0)
				end
			end
			return tI
		end
		local FI, sI = {}, Z[20]
		sI.camScr = false
		local function aI()
			local fI, QI = workspace.CurrentCamera, Z[8]
			local uI = QI()
			if not (fI and uI) then
				return
			end
			pcall(function()
				if fI.CameraType ~= Enum.CameraType.Custom then
					fI.CameraType = Enum.CameraType.Custom
				end
				if fI.CameraSubject ~= uI then
					fI.CameraSubject = uI
				end
			end)
		end
		WI = Z[20]
		WI.camHome = aI
		TI[41] = function(fI)
			if fI then
				if fI.done then
					return
				end
			else
				return
			end
			fI.done = true
			FI[fI] = nil
			local QI, QI = Z[61], Z[61]
			pcall(Z[61].UnbindFromRenderStep, Z[61], fI.n)
			aI()
		end
		TI[40] = function(fI)
			local QI, uI = workspace.CurrentCamera, Z[1]
			local mI, kI = uI.Character, Z[15]
			uI = kI()
			if QI and mI then
				if not uI then
					return
				end
			else
				return
			end
			local LI = {}
			LI.n = T:GenerateGUID(false)
			LI.t = os.clock() + 15
			LI.ch = mI
			FI[LI] = true
			local mI, gI, iI = QI.CFrame, fI and fI - uI.Position
			if gI then
				iI = gI
			else
				uI = Z[28]
				iI = (uI())
			end
			local fI = mI + iI
			pcall(function()
				QI.CameraType = Enum.CameraType.Scriptable
				QI.CFrame = fI
			end)
			kI, iI = Z[61], Z[61]
			pcall(Z[61].BindToRenderStep, Z[61], LI.n, Enum.RenderPriority.Last.Value + 50, function()
				if os.clock() > LI.t then
					local uI = TI[41]
					return uI(LI)
				else
					local uI = Z[1]
					if uI.Character ~= LI.ch then
						local uI = TI[41]
						return uI(LI)
					end
				end
				if QI.CameraType ~= Enum.CameraType.Scriptable then
					QI.CameraType = Enum.CameraType.Scriptable
				end
				QI.CFrame = fI
			end)
			return LI
		end
		local fI = G({ name = "CamGuard", gap = 0.3 })
		fI.on = function()
			return true
		end
		fI.fn = function()
			if next(FI) and not (Z[4] and Z[4].name == "Steal") then
				local fI = pairs
				for QI in fI(FI) do
					local fI = TI[41]
					fI(QI)
				end
			end
			if next(FI) then
				return
			else
				local fI = Z[20]
				if fI.agBusy then
					return
				end
			end
			local fI = workspace.CurrentCamera
			local QI = fI and fI.CameraSubject
			if fI then
				local uI = Z[8]
				if not (uI()) then
					return
				end
			else
				return
			end
			local uI, mI = (if QI then not QI.Parent else not QI)
				or QI:IsA("Humanoid") and not QI:IsDescendantOf(workspace)
			if uI then
				mI = uI
			else
				QI = Z[20]
				mI = QI.camScr and fI.CameraType == Enum.CameraType.Scriptable
			end
			if mI then
				fI = Z[20]
				fI.camScr = false
				aI()
			end
		end
		lI = Z[1]
		W(lI.CharacterAdded, function()
			local fI = pairs
			for QI in fI(FI) do
				local fI = TI[41]
				fI(QI)
			end
			task.delay(0.5, function()
				if not (next(FI)) then
					aI()
				end
			end)
		end)
		local function FI()
			local aI = Z[54]
			local fI = aI("Build", "FuseBiomeZone")
			return fI and (fI:FindFirstChild("ExitPart", true))
		end
		local function aI(fI)
			pcall(function()
				firetouchinterest(Z[15](), fI, 0)
				firetouchinterest(Z[15](), fI, 1)
			end)
		end
		local function fI()
			local QI = Z[1]
			local uI, mI = QI:GetAttribute("InEnchantedTree") == true
			if uI then
				mI = uI
			else
				QI = Z[1]
				mI = QI:GetAttribute("InBossArena") == true
			end
			uI = nil
			if mI then
				uI = mI
			else
				QI = Z[20]
				local mI = QI.highOk ~= nil
				if mI then
					local QI = Z[20]
					uI = QI.highOk()
				else
					uI = mI
				end
			end
			return uI
		end
		TI[10] = function()
			local QI = Z[15]
			local uI = QI()
			QI = nil
			if uI then
				local mI = Z[15]
				QI = mI().Position.Y > 1000
			else
				QI = uI
			end
			return QI and not fI()
		end
		TI[12] = function(QI)
			local uI, mI = FI(), Z[1]
			local kI, LI = mI.Character, os.clock() + 12
			while true do
				local gI, iI = uI and Z[56]
				if gI then
					mI = Z[1]
					iI = mI.Character == kI
				else
					iI = gI
				end
				local mI, kI = iI and os.clock() < LI
				if mI then
					gI = TI[10]
					kI = (gI())
				else
					kI = mI
				end
				if not kI then
					break
				end
				gI, kI = Z[26], Z[27]
				gI(kI(uI.Position))
				aI(uI)
				task.wait(QI or 0.1)
			end
			LI = TI[10]
			return not LI()
		end
		YI, RI = Z[20], Z[20]
		YI.inFuse = TI[10]
		RI.leaveFuse = TI[12]
		local aI = Z[20]
		aI.fuseZone = function()
			local aI, QI = FI(), Z[15]
			local FI = QI()
			return FI ~= nil and aI ~= nil and (FI.Position - aI.Position).Magnitude < 1200
		end
		local FI = G({ name = "FuseGuard", gap = 0.3 })
		local aI
		FI.on = function()
			return true
		end
		FI.fn = function()
			local FI = Z[20]
			if FI.fuseZone() then
				aI = aI or os.clock()
				if Z[4] then
					CI(Z[4])
				end
				if os.clock() - aI > 600 then
					local FI = Z[11]
					FI("Leaving the portal zone")
					FI = TI[12]
					FI()
				end
				return
			end
			aI = nil
		end
		local FI = G({ name = "NightHome", mover = true, soft = true, pri = 40, gap = 1, aux = true })
		FI.on = function()
			local aI = Z[25]
			local QI, uI = aI.steal
			if QI then
				uI = QI
			else
				aI = Z[25]
				uI = aI.bloom
			end
			QI = nil
			if uI then
				QI = uI
			else
				aI = Z[25]
				QI = aI.star
			end
			uI = nil
			if QI then
				uI = QI
			else
				aI = Z[25]
				uI = aI.wisp
			end
			return uI and o() <= 0
		end
		FI.want = function()
			local aI = Z[15]
			local QI, uI = aI(), Z[22]
			if FI.night == uI("Cycle", "NextResetTime", J()) then
				return
			elseif QI then
				aI = Z[21]
				if aI() then
					return
				end
			else
				return
			end
			aI = Z[16]
			if not (aI(QI.Position)) then
				if not (fI()) then
					local aI, fI = Z[47], Z[28]
					return aI() + fI(0, 3, 0)
				end
			end
		end
		FI.run = function(aI, fI)
			local QI = Z[22]
			FI.night = QI("Cycle", "NextResetTime", J())
			QI = Z[11]
			QI("Night, back to the safe zone")
			pI(aI, fI)
		end
		local FI = Z[20]
		FI.legs = function()
			local FI, aI = Z[54], Z[20]
			local fI = FI("Areas", "GuardAreas", aI.curArea or "")
			fI = fI and (fI:GetAttribute("GuardEscapeSpeeds"))
			aI = Z[20]
			local QI, uI = JI[aI.curArea or ""] and 4
			if QI then
				uI = QI
			else
				FI, aI = typeof(fI) == "Vector2"
				if FI then
					local JI = Z[44]
					aI = JI() * 0.9 < fI.Y * 1.05
				else
					aI = FI
				end
				uI = aI and 2
			end
			return uI or 1
		end
		local FI = C:FH(
			3,
			4,
			{ [8] = Z, [9] = Z, [10] = TI, [11] = Z, [12] = TI, [13] = Z, [14] = Z, [15] = Z, [16] = Z, [17] = Z, [18] = Z, [19] = TI },
			O,
			p,
			nil
		)
		TI[31] = function(aI)
			local JI, fI, QI, uI = ipairs, C[20](workspace:GetChildren()), 12
			for mI, kI in JI(C:QH(fI)) do
				local JI, fI = kI.Name == "SmartPromptPart" and kI:IsA("BasePart") and kI:FindFirstChild("CarryAreaEgg")
				if JI then
					mI = Z[28]
					fI = mI(kI.Position.X - aI.X, 0, kI.Position.Z - aI.Z).Magnitude
				else
					fI = JI
				end
				if fI then
					if fI < QI then
						QI, uI = fI, JI
					else
					end
				else
				end
			end
			return uI
		end
		TI[30] = function(aI)
			local JI, JI, fI = Z[34], pcall(Z[34].Egg.ReadFieldEgg, aI)
			return not (JI and type(fI) == "table" and fI.State == "GuardCarried")
		end
		local aI, JI, fI =
			C:FH(
				5,
				6,
				{
					[20] = Z,
					[21] = Z,
					[22] = Z,
					[23] = Z,
					[15] = Z,
					[24] = Z,
					[25] = Z,
					[26] = Z,
					[27] = Z,
					[28] = Z,
					[1] = Z,
					[29] = Z,
					[30] = TI,
					[31] = TI,
					[8] = Z,
				},
				O,
				p,
				nil
			),
			{}
		TI[36] = JI
		TI[35] = fI
		EI = Z[27]
		local JI, fI, QI = EI(5846, 17010.1, 15699.4), 0, 2
		TI[42] = JI
		local function EI(JI)
			local uI, mI = type(JI) == "table" and rawget(JI, "SampleHistory") ~= nil
			if uI then
				local kI
				kI, mI = Z[1], rawget(JI, "Player") == Z[1]
			else
				mI = uI
			end
			uI = mI and rawget(JI, "Character") == TI[35]
			return uI
		end
		TI[37] = function()
			local JI, JI = Z[1], TI[35] == Z[1].Character and #TI[36] > 0
			if JI then
				return
			elseif os.clock() < fI then
				return
			end
			local uI, mI = {}, Z[1]
			local kI, LI = mI.Character, os.clock() + QI
			TI[36], TI[35], fI = uI, kI, LI
			kI, LI, JI = Z[61], pcall(getconnections, Z[61].PostSimulation)
			mI, uI = ipairs, LI and JI or {}
			for kI, gI in mI(uI) do
				kI, JI = pcall(debug.getupvalues, gI.Function)
				LI, gI = next, kI and JI or {}
				for JI, JI in LI, gI, nil do
					if EI(JI) then
						if not (table.find(TI[36], JI)) then
							TI[36][#TI[36] + 1] = JI
						end
					end
				end
			end
			if #TI[36] == 0 then
				mI, uI = ipairs, C[20](getgc(true))
				for JI, kI in mI(C:QH(uI)) do
					if EI(kI) then
						TI[36][#TI[36] + 1] = kI
					end
					if JI % 40000 == 0 then
						kI = Z[23]
						kI()
					end
				end
			end
			QI = #TI[36] > 0 and 2 or math.min(QI * 2, 120)
		end
		local EI = {
			"CandidateGroundedSample",
			"CandidateGroundedStartedAt",
			"HighestYSinceGround",
			"LastConfirmedGroundSample",
			"LastGameplayTrustedSample",
			"LastGoodSample",
			"LastObservedSample",
			"LastSample",
			"LastSupportedAt",
			"LastValidatedGroundedSample",
			"LastValidatedSample",
			"SupportStartedAt",
			"ValidationStartedAt",
			"PreMovementSafeSample",
			"CorrectionContext",
			"FirstSuspiciousAt",
		}
		local function JI()
			local QI = TI[36]
			for uI, mI in ipairs(QI) do
				uI = rawget(mI, "Evidence")
				if type(uI) == "table" then
					uI.Speed = 0
					uI.Teleport = 0
					uI.Flight = 0
				end
				for QI, QI in ipairs(EI) do
					rawset(mI, QI, nil)
				end
				if rawget(mI, "ThreatLevel") == "Observing" then
					rawset(mI, "ThreatLevel", "Trusted")
				end
				if rawget(mI, "MovementMode") == "Correcting" then
					rawset(mI, "MovementMode", "Grounded")
				end
			end
		end
		AI = Z[20]
		AI.trust = JI
		local EI
		local function QI()
			local uI = Z[25]
			if uI.moveTo == "Teleport" then
				local uI = Z[25]
				if not uI.steal then
					local uI = Z[25]
					if not uI.boostOn then
						return
					end
				end
			else
				local uI = Z[25]
				if not uI.boostOn then
					return
				end
			end
			local uI, uI = Z[1], TI[35] ~= Z[1].Character or #TI[36] == 0
			if uI then
				if not EI then
					if os.clock() >= fI then
						EI = true
						task.spawn(function()
							local fI = TI[37]
							pcall(fI)
							EI = false
						end)
					end
				end
				return
			end
			JI()
		end
		sI = Z[61]
		W(sI.Heartbeat, QI)
		AI = Z[61]
		W(AI.Stepped, QI)
		YI = Z[61]
		W(YI.PreSimulation, QI)
		RI = Z[20]
		RI.tpFails = {}
		local EI = { Prehistoric = 2300, Cosmic = 4840, ["Cherry Blossom"] = 4840 }
		TI[38] = EI
		local EI, JI, RI, fI =
			C:FH(
				7,
				8,
				{
					[13] = Z,
					[14] = Z,
					[32] = Z,
					[15] = Z,
					[33] = Z,
					[23] = Z,
					[34] = Z,
					[18] = Z,
					[28] = Z,
					[35] = TI,
					[1] = Z,
					[36] = TI,
					[37] = TI,
					[38] = TI,
					[27] = Z,
					[39] = Z,
					[40] = TI,
					[41] = TI,
					[26] = Z,
					[11] = Z,
					[42] = TI,
					[19] = TI,
					[21] = Z,
					[22] = Z,
					[31] = TI,
					[24] = Z,
					[43] = TI,
					[44] = Z,
				},
				O,
				p,
				nil
			),
			Z[20],
			Z[20],
			Z[20]
		TI[45] = EI
		JI.tpFail = fI.tpFail or {}
		RI.gotAt = {}
		local EI = Z[20]
		EI.tpLost = function(EI)
			local JI = Z[20]
			local RI = JI.tpFail[EI]
			if RI then
				if os.clock() - RI[2] > 120 then
					JI = Z[20]
					JI.tpFail[EI] = nil
					RI = nil
				else
				end
			else
			end
			return RI and RI[1] or 0
		end
		task.spawn(function()
			local EI = Z[34]
			local JI = EI.Egg
			if JI then
				if JI.CarryChanged then
					W(JI.CarryChanged, function(EI)
						if type(EI) == "table" then
							if EI.IsCarrying == true then
								if EI.Uid then
									local JI = Z[20]
									JI.gotAt[EI.Uid] = os.clock()
								end
							end
						end
					end)
				end
			end
		end)
		local EI, JI =
			C:FH(
				9,
				10,
				{
					[20] = Z,
					[45] = TI,
					[13] = Z,
					[14] = Z,
					[34] = Z,
					[11] = Z,
					[23] = Z,
					[37] = TI,
					[36] = TI,
					[15] = Z,
					[16] = Z,
					[27] = Z,
					[28] = Z,
					[38] = TI,
					[1] = Z,
					[18] = Z,
					[19] = TI,
					[39] = Z,
					[42] = TI,
					[41] = TI,
					[26] = Z,
					[40] = TI,
					[21] = Z,
					[22] = Z,
					[30] = TI,
				},
				O,
				p,
				nil
			),
			Z[20]
		JI.stepTo = function(JI, RI)
			local QI = Z[15]
			local uI = QI()
			if not uI then
				return false
			end
			local AI, AI, mI = Z[44], math.max(Z[44]() * 1.515, 40), Z[28]
			QI = mI(uI.Position.X, math.max(uI.Position.Y, JI.Y), uI.Position.Z)
			while RI() do
				mI = Z[28]
				uI = mI(JI.X - QI.X, 0, JI.Z - QI.Z)
				if uI.Magnitude <= AI then
					break
				end
				QI += uI.Unit * AI
				local AI = 0
				while AI < 0.1 and (RI()) do
					local kI, LI = Z[26], Z[27]
					kI(LI(QI))
					LI = Z[23]
					AI += LI()
				end
			end
			if not (RI()) then
				return false
			end
			QI, mI, uI = Z[26], Z[27], Z[28]
			QI(mI(JI + uI(0, 3, 0)))
			return true
		end
		TI[50] = function(JI, RI, QI, uI, AI, mI)
			local kI
			if mI then
				kI = mI
			else
				local LI = Z[20]
				kI = LI.cmode()
			end
			local LI, gI = kI == "Tween"
			if LI then
				mI = Z[20]
				local iI = mI.agBusy
				if iI then
					gI = iI
				else
					local iI
					iI, gI = Z[20], os.clock() - (Z[20].agAt or -99) < 3
				end
			else
				gI = LI
			end
			while true do
				LI = Z[20]
				local iI, tI = LI.agBusy
				if iI then
					mI = Z[21]
					tI = (mI(JI))
				else
					tI = iI
				end
				if not (tI and (RI())) then
					break
				end
				tI = Z[23]
				tI()
			end
			mI = Z[15]
			local iI, tI = mI(), 0
			if not iI then
				return
			end
			local xI, SI, HI = QI.X <= iI.Position.X and 1 or -1, Z[20], Z[20]
			mI, LI = HI.flyY
			if mI then
				LI = mI
			else
				local _I, oI = kI == "Tween"
				if _I then
					HI = Z[24]
					oI = HI().Y
				else
					oI = _I
				end
				LI = oI or iI.Position.Y - 3
			end
			SI.flyY = LI
			SI = Z[20]
			HI = SI.flyY
			if gI then
				LI, SI = 0, 0
				while true do
					local gI, _I = LI < 10
					if gI then
						mI = Z[21]
						_I = (mI(JI))
					else
						_I = gI
					end
					if not (_I and (RI())) then
						break
					end
					_I = Z[29]
					gI = _I()
					_I = nil
					if gI then
						_I = gI
					else
						local oI = Z[20]
						_I = oI.agBusy
					end
					if _I then
						gI = Z[23]
						SI, LI = 0, LI + gI()
					else
						local gI = Z[23]
						SI += gI()
						if SI >= 0.25 then
							break
						end
					end
				end
				local gI, _I = HI + 3, 0
				while true do
					local oI, BI = _I < 0.8
					if oI then
						local vI = Z[21]
						BI = (vI(JI))
					else
						BI = oI
					end
					if not (BI and (RI())) then
						break
					end
					BI = Z[15]
					iI = BI()
					if not iI then
						return
					end
					local oI, BI, vI, zI = gI - iI.Position.Y, Z[28]
					vI, zI, iI.AssemblyLinearVelocity =
						Z[44],
						Z[25],
						BI(
							-xI * Z[44]() * 0.57 * Z[25].carryK,
							_I < 0.6 and math.clamp(oI / math.max(0.6 - _I, 0.1), -120, 120)
								or math.clamp(oI / 0.2, -30, 30),
							0
						)
					BI = Z[23]
					_I = _I + BI()
				end
				tI = os.clock() + 1
			else
			end
			LI = uI
			if kI == "Instant steps" then
				uI = math.clamp(iI.Position.Z, -415, -305)
				local gI, _I, oI, oI, BI, vI =
					iI.Position.X, iI.Position.Y + 42, Z[44], math.max(Z[44]() * 1.515, 40), math.max, Z[20]
				mI, SI = vI.lagoonSteal
				if mI then
					vI = Z[25]
					SI = vI.moveTo ~= "Teleport"
				else
					SI = mI
				end
				local zI, cI = SI and 1
				if zI then
					cI = zI
				else
					vI = Z[25]
					cI = vI.stepsN
				end
				vI, zI = BI(cI or 3, 1), {}
				for DI = 1, vI - 1, 1 do
					zI[DI] = gI - (gI - QI.X) * DI / vI
				end
				BI = 1
				while true do
					vI = Z[21]
					if not (vI(JI) and (RI()) and (gI - QI.X) * xI > oI) then
						break
					end
					gI -= oI * xI
					if zI[BI] then
						if (gI - zI[BI]) * xI <= 0 then
							local vI, DI, NI = BI + 1, Z[26], Z[27]
							DI(NI(gI, QI.Y, uI) * AI)
							cI = 0
							while true do
								DI = Z[32]
								local VI, II = cI < 0.19 + DI()
								if VI then
									NI = Z[21]
									II = (NI(JI))
								else
									II = VI
								end
								if not II then
									break
								end
								II = Z[23]
								cI += II()
							end
							DI = Z[22]
							DI("Egg", "DropFieldEgg", "PlayerRequest")
							cI = 0
							while true do
								NI = Z[21]
								if not (NI(JI) and cI < 1.5) then
									break
								end
								DI = Z[23]
								cI += DI()
							end
							NI = Z[21]
							if not (NI(JI)) then
								DI = Z[20]
								if not (DI.stealChase(JI, RI)) then
									return
								end
							end
							DI = Z[15]
							NI = DI()
							gI, cI = if NI then NI.Position.X else gI, 0
							while cI < 0.1 do
								NI = Z[23]
								cI += NI()
							end
							BI = vI
						else
						end
					else
					end
					local BI = Z[27]
					local vI, cI = BI(gI, _I, uI) * AI, 0
					while true do
						local gI, DI = cI < 0.1
						if gI then
							BI = Z[21]
							DI = (BI(JI))
						else
							DI = gI
						end
						if not DI then
							break
						end
						DI = Z[26]
						DI(vI)
						gI = Z[23]
						cI += gI()
					end
				end
				_I = Z[21]
				if _I(JI) then
					zI, oI = Z[26], Z[27]
					zI(oI(QI) * AI)
				end
				return
			end
			uI = if kI ~= "Fast tween" then math.clamp(iI.Position.Z, -415, -305) else LI
			mI = {}
			if kI == "Fast tween" then
				LI = Z[20]
				SI = LI.legs()
				for gI = 1, SI - 1, 1 do
					mI[gI] = iI.Position.X - (iI.Position.X - QI.X) * gI / SI
				end
			end
			LI, SI = 1, 0.016666666666666666
			while true do
				local gI = Z[21]
				if not (gI(JI) and (RI())) then
					break
				end
				gI = Z[15]
				iI = gI()
				if not iI then
					return
				end
				local _I, oI = Z[20], iI
				if _I.agBusy then
					gI = Z[23]
					gI()
				else
					if kI == "Tween" then
						if (oI.Position.X - QI.X) * xI <= 36 then
							iI = oI
							break
						end
						local gI = HI + 3
						if math.abs(oI.Position.Y - gI) > 2 then
							local _I, _I, _I = Z[1], Z[1], Z[27]
							pcall(
								Z[1].Character.PivotTo,
								Z[1].Character,
								Z[27](oI.Position.X, gI, oI.Position.Z) * oI.CFrame.Rotation
							)
						end
						local gI, _I, BI = Z[28]
						_I, BI, oI.AssemblyLinearVelocity =
							Z[44],
							Z[25],
							gI(-xI, 0, math.clamp((uI - oI.Position.Z) * 0.03, -0.3, 0.3)).Unit
								* Z[44]()
								* 0.95
								* Z[25].carryK
								* (os.clock() < tI and 0.6 or 1)
						_I = Z[23]
						_I()
					else
						local gI = oI.Position
						if (gI.X - QI.X) * xI <= 36 then
							iI = oI
							break
						end
						local tI = SI
						if mI[LI] and (gI.X - mI[LI]) * xI <= 0 then
							LI += 1
							local mI, LI = Z[26], Z[27]
							mI(LI(gI.X, QI.Y, gI.Z) * AI)
							local _I, BI, vI, zI = false, false, 0, 0
							while true do
								LI, mI = zI < 0.1
								if LI then
									local cI = Z[21]
									mI = (cI(JI))
								else
									mI = LI
								end
								if not mI then
									break
								end
								local cI = Z[23]
								zI += cI()
							end
							LI = Z[34]
							mI = LI.Egg.CarryChanged:Connect(function(cI)
								if type(cI) == "table" then
									if cI.IsCarrying then
										if _I then
											BI = true
										end
									else
										_I = true
									end
								end
							end)
							task.spawn(Z[22], "Egg", "DropFieldEgg", "PlayerRequest")
							zI = 0
							LI = false
							iI = oI
							while true do
								local cI = not BI and zI < 1.5
								if not (cI and RI()) then
									break
								end
								if _I and not LI then
									local _I, DI = pairs, Z[18]
									cI = C[20](DI())
									for NI, NI in _I(C:QH(cI)) do
										if
											type(NI) == "table"
											and NI.Uid == JI
											and NI.State == "Dropped"
											and typeof(NI.BottomCFrame) == "CFrame"
										then
											LI = true
											DI = Z[15]
											iI = DI()
											if iI then
												if (NI.BottomCFrame.Position - iI.Position).Magnitude > 6 then
													local _I, DI = Z[26], Z[27]
													_I(DI(NI.BottomCFrame.Position + Z[28](0, 3, 0)) * AI)
												end
											end
											break
										end
									end
								else
								end
								if vI < 3 then
									vI += 1
									task.spawn(function()
										local _I = Z[22]
										_I("Egg", "CarryFieldEgg", JI)
										vI -= 1
									end)
								else
								end
								cI = Z[23]
								zI = zI + cI()
							end
							mI:Disconnect()
							mI = nil
							if BI then
								LI = Z[21]
								mI = (LI(JI))
							else
								mI = BI
							end
							if not mI then
								LI = Z[20]
								if not (LI.stealChase(JI, RI)) then
									return
								end
							end
							mI = Z[23]
							SI = (mI())
							continue
						end
						local JI, RI, mI = Z[25], Z[26], Z[27]
						RI(
							mI(
								gI.X - xI * math.min(JI.pullSpd * tI, 250, (gI.X - QI.X) * xI),
								HI,
								gI.Z + (uI - gI.Z) * 0.03
							) * AI
						)
						tI = Z[23]
						SI = (tI())
					end
				end
				iI = oI
			end
			if kI == "Tween" then
				if iI then
					HI = Z[33]
					iI.AssemblyLinearVelocity = HI
				end
			end
		end
		TI[51] = function(JI, RI)
			local QI = Z[1]
			local uI, AI, mI = QI.Character, os.clock() + 10, 0
			while true do
				QI = RI()
				local RI
				if QI then
					local kI = Z[1]
					RI = kI.Character == uI
				else
					RI = QI
				end
				local QI, kI = RI and os.clock() < AI
				if QI then
					RI = Z[21]
					kI = not RI(JI)
				else
					kI = QI
				end
				if not kI then
					break
				end
				QI, RI = workspace:FindFirstChild(JI), Z[15]
				kI = RI()
				if QI then
					if QI:IsA("Model") then
						if not kI then
							return false
						end
					else
						return false
					end
				else
					return false
				end
				local AI, LI = QI:GetPivot().Position, Z[28]
				RI = LI(AI.X - kI.Position.X, 0, AI.Z - kI.Position.Z)
				if RI.Magnitude > 600 then
					return false
				end
				QI, LI = pairs, Z[18]
				local gI = C[20](LI())
				for LI, iI in QI(C:QH(gI)) do
					if type(iI) == "table" then
						if iI.Uid == JI then
							if iI.State == "Carried" then
								LI = Z[1]
								if (tonumber(iI.CarrierUserId) or 0) ~= LI.UserId then
									return false
								end
							end
							break
						end
					end
				end
				gI = Z[29]
				if gI() and RI.Magnitude > 8 then
					local LI, gI, iI = Z[26], Z[27], Z[28]
					LI(gI(AI + iI(0, 3, 0)))
				elseif RI.Magnitude > 2 then
					QI = Z[20]
					if not QI.agBusy then
						local QI, AI
						QI, AI, kI.AssemblyLinearVelocity =
							Z[44],
							Z[28],
							RI.Unit * math.min(Z[44]() * 0.95, RI.Magnitude / 0.05) + Z[28](
								0,
								kI.AssemblyLinearVelocity.Y,
								0
							)
					end
				end
				if RI.Magnitude < 12 and mI < 2 then
					mI += 1
					task.spawn(function()
						local RI = Z[22]
						RI("Egg", "CarryFieldEgg", JI)
						mI -= 1
					end)
				else
				end
				kI = Z[23]
				kI()
			end
			uI = Z[21]
			return uI(JI)
		end
		hI = Z[20]
		hI.stealChase = TI[51]
		local JI
		TI[52] = JI
		local JI = C:FH(
			11,
			12,
			{ [11] = Z, [46] = Z, [26] = Z, [27] = Z, [47] = Z, [19] = TI, [21] = Z, [32] = Z, [48] = TI, [23] = Z },
			O,
			p,
			nil
		)
		TI[49] = JI
		local JI = C:FH(
			13,
			14,
			{
				[20] = Z,
				[21] = Z,
				[23] = Z,
				[1] = Z,
				[24] = Z,
				[15] = Z,
				[47] = Z,
				[28] = Z,
				[43] = TI,
				[16] = Z,
				[49] = TI,
				[11] = Z,
				[46] = Z,
				[50] = TI,
				[26] = Z,
				[27] = Z,
				[51] = TI,
				[32] = Z,
				[22] = Z,
				[40] = TI,
				[52] = TI,
				[41] = TI,
			},
			O,
			p,
			nil
		)
		local function RI(QI)
			local uI = Z[18]
			for AI, AI in pairs(uI()) do
				if type(AI) == "table" then
					if AI.Uid == QI then
						return AI.State
					end
				end
			end
		end
		TI[52] = function(QI, uI, AI, mI, kI)
			if RI(QI) == "Slot" then
				return false, "Egg went back to its nest"
			end
			local LI = Z[11]
			LI("Taking the egg back")
			local gI, iI, tI, xI, SI, HI, _I = os.clock() + 25, os.clock() + 1, 0, 0, 0, 0, mI
			LI = 0
			while true do
				local oI = Z[21]
				local BI = oI(QI)
				if not ((if BI then not BI else os.clock() < gI) and uI()) then
					break
				end
				oI = Z[1]
				if oI.Character ~= AI then
					return false
				end
				if os.clock() >= HI then
					HI = os.clock() + 0.2
					BI = RI(QI)
					if BI == "Slot" then
						return false, "Egg went back to its nest"
					end
					if BI == "GuardCarried" then
						return false, "Guard is bringing it back"
					end
				else
				end
				BI = workspace:FindFirstChild(QI)
				if BI then
					if BI:IsA("Model") then
						local RI, HI, vI = pcall(BI.GetBoundingBox, BI)
						if RI then
							oI = Z[28]
							_I = oI(HI.X, HI.Y - vI.Y / 2, HI.Z)
						else
						end
					else
					end
				else
				end
				oI = Z[28]
				if oI(_I.X - mI.X, 0, _I.Z - mI.Z).Magnitude > 400 then
					return false, "Egg went back to its nest"
				end
				oI = Z[15]
				BI = oI()
				if BI and BI.Anchored then
					Z[13](uI)
				else
					if SI > 0 and os.clock() - SI > 0.6 then
						SI = 0
						nI(_I, function()
							local RI = uI()
							local uI
							if RI then
								local HI = Z[21]
								uI = not HI(QI)
							else
								uI = RI
							end
							return uI
						end, 3, 3, 0.95)
					else
						if BI then
							oI = Z[8]
							local RI, uI, HI, vI = oI(), Z[26], Z[27], Z[28]
							uI(HI(_I + vI(0, (RI and RI.HipHeight or 2) + 1, 0)) * kI)
						end
					end
				end
				if os.clock() >= LI then
					LI = os.clock() + 0.15
					local RI, uI = fireproximityprompt
					if RI then
						oI = TI[31]
						uI = (oI(_I))
					else
						uI = RI
					end
					if uI then
						pcall(function()
							uI.HoldDuration = 0
							fireproximityprompt(uI)
						end)
					end
				else
				end
				if tI < 3 then
					tI += 1
					task.spawn(function()
						local RI = Z[22]
						local uI, uI = RI("Egg", "CarryFieldEgg", QI)
						tI -= 1
						uI = type(uI) == "string" and uI:lower() or ""
						if uI:find("gameplay area") then
							if SI == 0 then
								SI = os.clock()
							end
						else
							SI = 0
						end
						if uI:find("trusted") or uI:find("closer") then
							if xI == 0 then
								xI = os.clock()
							end
						else
							xI = 0
						end
					end)
				else
				end
				if xI > 0 then
					if os.clock() - xI > 4 then
						return false, "Server pulled you back"
					end
				end
				if os.clock() >= iI then
					iI = os.clock() + 1
					BI, oI = Z[18], false
					for RI, RI in pairs(BI()) do
						oI = if type(RI) == "table" then if RI.Uid == QI then RI.State ~= "Slot" else oI else oI
					end
					if not oI then
						return false, "Egg went back to its nest"
					end
				else
				end
				oI = Z[23]
				oI()
			end
			LI = Z[21]
			if not (LI(QI)) then
				return false
			end
			LI = Z[11]
			LI("Crossing into base")
			for RI = 1, 2, 1 do
				LI, RI, _I, gI = os.clock(), Z[26], Z[27], Z[47]
				RI(_I(gI()) * kI)
				while true do
					local uI, uI, gI = Z[32], os.clock() - LI < 1.5 + Z[32]() * 3 and TI[48] < LI
					if uI then
						RI = Z[21]
						gI = (RI(QI))
					else
						gI = uI
					end
					if not gI then
						break
					end
					uI = Z[23]
					uI()
				end
				if TI[48] >= LI then
					return true
				end
				AI = Z[21]
				if not (AI(QI)) then
					return nil
				end
				RI = Z[11]
				RI("Not counted yet, crossing again")
				local QI, uI = Z[26], Z[27]
				QI(uI(mI) * kI)
				QI = 0
				while true do
					RI = Z[32]
					if not (QI < 0.3 + RI()) then
						break
					end
					uI = Z[23]
					QI += uI()
				end
			end
			return false
		end
		local RI, QI, uI, AI, mI, kI, LI, gI, iI, tI, xI =
			C:FH(
				15,
				16,
				{
					[1] = Z,
					[15] = Z,
					[20] = Z,
					[16] = Z,
					[13] = Z,
					[10] = TI,
					[12] = TI,
					[11] = Z,
					[26] = Z,
					[27] = Z,
					[23] = Z,
					[28] = Z,
					[53] = Z,
					[34] = Z,
					[21] = Z,
					[22] = Z,
					[43] = TI,
					[24] = Z,
					[32] = Z,
					[54] = Z,
				},
				O,
				p,
				nil
			),
			{},
			{},
			{},
			0,
			{},
			0,
			false,
			{},
			0,
			Z[20]
		xI.indexMissing = function()
			if os.clock() > tI then
				tI, iI = os.clock() + 30, {}
				local tI, xI, xI, SI = next, Z[34], type(Z[34].Areas) == "table"
				if xI then
					local HI = Z[34]
					SI = HI.Areas.Directory
				else
					SI = xI
				end
				xI = SI or {}
				for HI, _I in tI, xI, nil do
					HI, SI = ipairs, type(_I) == "table" and type(_I.DropTable) == "table" and _I.DropTable or {}
					for tI, xI in HI(SI) do
						tI = type(xI) == "table" and (xI[1] or xI.Category)
						local SI = tI and (h(tI))
						if SI then
							if (tonumber(xI[2] or xI.Weight) or 1) > 0 then
								if SI.DontRoll then
									if _I.IndexIncludeDontRoll then
										iI[tI] = true
									end
								else
									iI[tI] = true
								end
							end
						end
					end
				end
				pcall(function()
					local tI, xI = ipairs, C[20](require(P.Data.HalloweenIndex).GetSections())
					for SI, HI in tI(C:QH(xI)) do
						local tI, xI = ipairs, HI.Entries or {}
						for HI, HI in tI(xI) do
							SI = iI
							SI[HI.AssetId] = true
						end
					end
				end)
			end
			local tI = Z[67]
			local xI, SI = tI(), {}
			local tI, HI = xI and type(xI.Index) == "table" and xI.Index or {}, iI
			for iI in next, HI, nil do
				if tI[iI] ~= true then
					SI[iI] = true
				end
			end
			return SI
		end
		local function iI()
			if os.clock() < LI then
				local tI = kI
				return tI
			end
			LI, kI = os.clock() + 5, {}
			local LI = Z[67]
			local tI = LI()
			if not tI then
				LI = kI
				return LI
			end
			local xI, SI, HI = type(tI.Index) == "table" and tI.Index or {}, {}, { "Inventory", "EggInventory" }
			for _I, _I in ipairs(HI) do
				for oI, oI in next, type(tI[_I]) == "table" and tI[_I] or {}, nil do
					if type(oI) == "table" then
						SI[oI.Category or oI.AssetCategory or ""] = true
					end
				end
			end
			tI = Z[34]
			HI, LI = tI.Areas, next
			tI = type(HI) == "table" and HI.Directory or {}
			for _I, oI in LI, tI, nil do
				_I, HI = ipairs, type(oI) == "table" and type(oI.DropTable) == "table" and oI.DropTable or {}
				for LI, tI in _I(HI) do
					LI = type(tI) == "table" and (tI[1] or tI.Category)
					local HI = LI and (h(LI))
					local _I, BI = HI and (tonumber(tI[2] or tI.Weight) or 1) > 0
					if _I then
						tI = HI.DontRoll
						BI = if tI then oI.IndexIncludeDontRoll else not tI
					else
						BI = _I
					end
					if BI then
						if xI[LI] ~= true then
							if not SI[LI] then
								kI[LI] = true
							end
						end
					end
				end
			end
			xI = kI
			return xI
		end
		YI = Z[20]
		YI.indexNeeds = iI
		fI = Z[20]
		fI.pick = {}
		YI = Z[20]
		YI.skip = {}
		local fI, kI =
			{ ["Lowest value"] = "lo", ["Best rarity"] = "r", ["Best mutation"] = "mv", Biggest = "s", Closest = "near" },
			{}
		local LI = workspace:FindFirstChild("AreaEggSlotsClient")
		local function tI(xI)
			if xI.State == "Dropped" or xI.State == "Carried" then
				local SI = workspace:FindFirstChild(xI.Uid) or LI and LI:FindFirstChild(xI.Uid)
				local LI, HI = pcall(function()
					return SI:GetPivot().Position
				end)
				if LI then
					if HI then
						return HI
					end
				end
			end
			return xI.BottomCFrame.Position
		end
		local function LI(xI, SI, HI, _I, oI, BI)
			local vI = kI[SI]
			if if vI then vI.r ~= xI else not vI then
				vI = { r = xI, e = g(xI) }
				kI[SI] = vI
			else
			end
			local zI, cI, cI = vI.e, Z[20], table.find(Z[20].pick, SI)
			local vI, DI = cI and "pick" or HI and HI[zI.cat] and "index" or _I and (_I(zI))
			if vI then
				DI = vI
			else
				HI = Z[70]
				DI = HI(eI, zI) and "filter"
			end
			HI, _I = cI ~= nil
			if HI then
				_I = HI
			else
				vI = Z[20]
				local eI = vI.skip[SI]
				local NI = if eI then not eI else DI
				if NI then
					eI = Z[25]
					local VI = eI.zones
					local eI = not VI
					if VI then
						local VI = Z[25]
						_I = VI.zones[tostring(xI.AreaId):gsub("%s", "")]
					else
						_I = eI
					end
				else
					_I = NI
				end
			end
			zI.tg = _I or false
			zI.kind = zI.tg and DI or nil
			vI, HI = xI.State == "Carried" and tonumber(xI.CarrierUserId)
			if vI then
				_I = Z[1]
				HI = vI ~= _I.UserId
			else
				HI = vI
			end
			zI.held = HI and q:GetPlayerByUserId(vI) or nil
			local eI, HI, _I, vI = tI(xI), zI.n, zI.tg
			if _I then
				xI = Z[20]
				vI = (100 - (xI.rank["Steal:" .. DI] or 9)) * 1000 - (cI or 0)
			else
				vI = _I
			end
			_I, DI = vI or 0, -zI.v
			zI.Uid = SI
			zI.Pos = eI
			zI.Name = HI
			zI.b = _I
			zI.lo = DI
			if oI == "near" then
				_I = nil
				if BI then
					cI = Z[28]
					_I = -cI(zI.Pos.X - BI.X, 0, zI.Pos.Z - BI.Z).Magnitude
				else
					_I = BI
				end
				zI.near = _I or 0
			end
			if oI == "mv" then
				if not zI.mv then
					zI.mv = #zI.m > 0 and zI.v / math.max(L(zI.cat, zI.s, {}), 1) or 1
				end
			end
			return zI
		end
		local eI = Z[20]
		eI.atSafe = function(eI)
			local xI = Z[25]
			if xI.dropSafe ~= true then
				return false
			elseif type(eI) ~= "table" then
				return false
			elseif eI.State == "Carried" then
				return false
			end
			xI = workspace:FindFirstChild("AreaEggSlotsClient")
			local SI = xI and xI:FindFirstChild(tostring(eI.Uid)) or workspace:FindFirstChild(tostring(eI.Uid))
			xI = SI and SI:IsA("Model") and SI:GetPivot().Position
				or typeof(eI.BottomCFrame) == "CFrame" and eI.BottomCFrame.Position
			SI, eI = xI ~= nil
			if SI then
				local HI
				HI, eI = Z[24], xI.X < Z[24]().X + 50
			else
				eI = SI
			end
			return eI
		end
		local function eI(xI, SI)
			local HI, _I = {}, os.clock()
			if if xI then not xI else o() <= 0 then
				mI = _I
				local oI = gI
				local BI, vI = not oI
				if oI then
					vI = BI
				else
					local zI = Z[22]
					vI = zI("Cycle", "IsNightPhase", J())
				end
				if vI then
					gI, AI = true, {}
					BI, oI = pairs, Z[18]
					local vI = C[20](oI())
					for oI, zI in BI(C:QH(vI)) do
						if type(zI) == "table" then
							if zI.Uid then
								oI = AI
								oI[zI.Uid] = true
							end
						end
					end
				end
				if not SI then
					return HI
				end
			end
			if _I - mI > 8 then
				gI = false
			end
			local gI = Z[25]
			local oI, BI = gI.index and iI(), Z[20]
			local iI, vI = BI.wantEgg, Z[25]
			local zI = fI[vI.order] or "v"
			vI, BI, gI = _I - mI > 8, {}, Z[15]
			local mI = gI()
			gI = nil
			if mI then
				local cI = Z[15]
				gI = cI().Position
			else
				gI = mI
			end
			local cI, DI = pairs, Z[18]
			local NI, VI = C[20](DI()), 0
			for II, jI in cI(C:QH(NI)) do
				mI = type(jI) == "table" and jI.Uid
				DI, II = type(mI) == "string"
				if DI then
					local cI, KI = jI.State == "Slot" or jI.State == "Dropped" or jI.State == "GuardCarried"
					if cI then
						KI = cI
					else
						local XI = Z[20]
						KI = mI == XI.mgUid and jI.State ~= "Carried" and jI.State ~= "Claimed"
					end
					cI = nil
					if KI then
						cI = KI
					else
						local XI
						if xI then
							local UI = Z[20]
							XI = mI == UI.curUid
						else
							XI = xI
						end
						cI = XI and jI.State == "Carried"
					end
					if cI then
						II = cI
					else
						local cI, XI = jI.State == "Carried"
						if cI then
							KI = tonumber(jI.CarrierUserId)
							local UI
							if KI then
								UI = KI
							else
								local KI = Z[1]
								UI = KI.UserId
							end
							local KI = Z[1]
							XI = UI ~= KI.UserId
						else
							XI = cI
						end
						if XI then
							cI = nil
							if xI then
								cI = xI
							else
								local KI = Z[25]
								cI = KI.thief
							end
							local KI
							if cI then
								KI = cI
							else
								local cI
								cI, KI = Z[20], table.find(Z[20].pick, mI)
							end
							if KI then
								II = KI
							else
								local cI = Z[20]
								local KI = mI == cI.chaseUid
								if KI then
									cI = nil
									cI, II = Z[20], os.clock() - (Z[20].chaseAt or 0) < 120
								else
									II = KI
								end
							end
						else
							II = XI
						end
					end
				else
					II = DI
				end
				local cI, DI = II and not mI:find("^FirstAreaEgg") and typeof(jI.BottomCFrame) == "CFrame"
				if cI then
					if xI then
						DI = xI
					else
						II = Z[20]
						DI = not II.atSafe(jI)
					end
				else
					DI = cI
				end
				if DI then
					BI[mI] = true
					VI = if AI[mI] then VI + 1 else VI
					cI, II = Z[20], table.find(Z[20].pick, mI)
					local cI
					if xI then
						cI = xI
					else
						local DI
						if II then
							DI = II
						else
							local KI = (QI[mI] or 0) < _I
							if KI then
								local XI = Z[25]
								DI = not (XI.dropSafe == true and (uI[mI] or 0) >= _I)
							else
								DI = KI
							end
						end
						cI = DI and (vI or not AI[mI] or II)
					end
					if cI then
						local AI = LI(jI, mI, oI, iI, zI, gI)
						if xI then
							HI[#HI + 1] = AI
						elseif AI.tg then
							local mI = Z[25]
							if mI.steal then
								HI[#HI + 1] = AI
							elseif AI.kind == "wisp" then
								HI[#HI + 1] = AI
							elseif AI.kind == "pick" then
								HI[#HI + 1] = AI
							end
						end
					end
				else
				end
			end
			if SI then
				_I = Z[20]
				_I.fieldFresh = VI <= 2
			end
			for AI in next, kI, nil do
				if not BI[AI] then
					kI[AI] = nil
				end
			end
			_I = Z[20]
			SI = #_I.pick
			for AI = SI, 1, -1 do
				xI = Z[20]
				if not BI[xI.pick[AI]] then
					table.remove(Z[20].pick, AI)
				end
			end
			NI, oI = next, Z[20]
			vI = oI.skip
			for AI in NI, vI, nil do
				if not BI[AI] then
					oI = Z[20]
					oI.skip[AI] = nil
				end
			end
			table.sort(HI, function(AI, mI)
				if AI.b ~= mI.b then
					return AI.b > mI.b
				end
				if AI[zI] ~= mI[zI] then
					return AI[zI] > mI[zI]
				end
				return AI.v > mI.v
			end)
			return HI
		end
		local AI = Z[20]
		AI.sortKey = function()
			local AI = Z[25]
			return fI[AI.order] or "v"
		end
		local AI = Z[20]
		AI.stealSort = function(AI)
			local mI = Z[25]
			local kI = fI[mI.order] or "v"
			table.sort(AI, function(mI, LI)
				if mI.b ~= LI.b then
					return mI.b > LI.b
				end
				if (mI[kI] or 0) ~= (LI[kI] or 0) then
					return (mI[kI] or 0) > (LI[kI] or 0)
				end
				return mI.v > LI.v
			end)
			return AI
		end
		local AI
		local mI = 0
		local function kI()
			if AI then
				if os.clock() - mI < 0.3 then
					local LI = AI
					return LI
				end
			end
			local LI, gI, iI = eI(false), os
			iI, AI = gI.clock(), LI
			mI = iI
			iI = AI
			return iI
		end
		local mI = Z[20]
		mI.fresh = function()
			AI = nil
		end
		local AI = Z[20]
		AI.targetsSoon = function()
			return eI(false, true)
		end
		local AI = Z[20]
		AI.allEggs = function()
			return eI(true)
		end
		WI = Z[20]
		WI.reach = FI
		local WI = 115
		pcall(function()
			WI = tonumber(require(P.Shared.Types.Eggs).MAX_INVENTORY) or WI
		end)
		hI = Z[20]
		hI.bagMax = WI
		local eI = 0
		local function AI()
			local hI = 0
			for mI in pairs(S()) do
				hI += 1
			end
			local mI = WI
			return hI >= mI
		end
		local function WI(hI)
			if os.clock() - eI < 1 then
				return true
			end
			local mI, LI = pairs, C[20](S())
			local gI
			for iI, xI in mI(C:QH(LI)) do
				if type(xI) == "table" then
					if xI.Placement then
					else
						local mI = Z[20]
						if mI.reserved[iI] then
						else
							local mI = Z[20]
							local SI, HI = mI.protect
							if SI then
								mI = Z[20]
								HI = mI.protect(iI, xI)
							else
								HI = SI
							end
							if HI then
							else
								mI = g(xI)
								if #mI.m == 0 then
									if mI.v < hI then
										SI = Z[25]
										if mI.v < (SI.bagMax or 1 / 0) then
											local xI = mI.v
											hI, gI = xI, iI
										else
										end
									else
									end
								else
								end
							end
						end
					end
				else
				end
			end
			if not gI then
				return false
			end
			s("RE/PetSatchel/SellSelection", { Eggs = { gI }, Assets = {} })
			eI = os.clock()
			LI = Z[11]
			LI("Sold a cheap egg to make room", "ok")
			return true
		end
		local eI
		local hI = Z[20]
		hI.bagCheck = function()
			eI = nil
			local hI = Z[25]
			if hI.bagSell then
				if AI() then
					WI(1 / 0)
				end
			end
		end
		lI = Z[34]
		if lI.Egg then
			YI = Z[34]
			if YI.Egg.OwnerRefreshed then
				sI = Z[34]
				W(sI.Egg.OwnerRefreshed, function(lI)
					local sI = Z[1]
					if lI == sI.UserId then
						local lI = Z[25]
						if lI.bagSell then
							if not eI then
								eI = true
								task.defer(Z[20].bagCheck)
							end
						end
					end
				end)
			end
		end
		function wI.ready()
			if o() <= 0 then
				return nil
			elseif (wI.full or 0) > os.clock() then
				return nil
			end
			local lI = kI()[1]
			if not lI then
				return nil
			end
			local sI = Z[20]
			sI.stealNext = lI.kind
			sI = Z[20]
			return sI.rank["Steal:" .. lI.kind] or 9
		end
		local lI = Z[20]
		lI.stealWants = function()
			local lI = wI.inq == true or Z[4] == wI
			return lI
		end
		function wI.want()
			local lI = Z[20]
			lI.curUid = nil
			lI = o()
			if lI <= 0 then
				kI()
				local sI = Z[11]
				return sI("Waiting for daytime")
			end
			if os.clock() - OI < 1.5 then
				return "wait"
			end
			if (wI.full or 0) > os.clock() then
				lI = Z[11]
				return lI(wI.fullTx or "Bag full, retrying soon", "warn")
			end
			lI = kI()
			wI.empty = #lI == 0 and (wI.empty or os.clock()) or nil
			if #lI == 0 then
				local OI = Z[11]
				return OI("No egg matches your targets")
			end
			local OI, sI = ipairs
			for YI, eI in OI(lI) do
				if eI.held then
					YI = Z[20]
					if YI.bat() then
						sI = eI
						break
					end
				else
					sI = eI
					break
				end
			end
			if not sI then
				OI = Z[11]
				return OI("Matching eggs are in other players' hands")
			end
			if AI() then
				OI = Z[25]
				if OI.bagSell then
					if WI(sI.v) then
						return "wait"
					end
				end
				wI.full = os.clock() + 30
				local YI, eI = Z[11], Z[25]
				return YI(
					eI.bagSell and "Bag is full, no cheaper egg to sell" or "Bag full, place or sell eggs",
					"warn"
				)
			end
			lI, OI = Z[20]
			OI, lI.rank.Steal = Z[20], Z[20].rank["Steal:" .. sI.kind] or 9
			return sI
		end
		local function OI(lI)
			local sI = Z[18]
			local YI = sI()
			if type(YI[lI]) == "table" then
				return YI[lI]
			end
			for sI, sI in pairs(YI) do
				if type(sI) == "table" then
					if sI.Uid == lI then
						return sI
					end
				end
			end
		end
		local function lI(sI)
			local YI = OI(sI)
			local eI, AI = YI and YI.State == "Carried" and q:GetPlayerByUserId(tonumber(YI.CarrierUserId) or 0)
			if eI then
				YI = Z[1]
				AI = eI ~= YI
			else
				AI = eI
			end
			YI = AI and eI.Character and eI.Character:FindFirstChild("HumanoidRootPart")
			if YI then
				return YI, eI
			end
			YI = workspace:FindFirstChild(sI)
			if not YI then
				return
			end
			sI, eI = ipairs, C[20](YI:GetDescendants())
			for hI, mI in sI(C:QH(eI)) do
				if mI:IsA("JointInstance") or mI:IsA("WeldConstraint") or mI:IsA("RigidConstraint") then
					hI, AI = ipairs, { mI.Part0, mI.Part1 }
					for eI, mI in hI(AI) do
						local hI, LI = mI and not mI:IsDescendantOf(YI) and mI:FindFirstAncestorOfClass("Model")
						if hI then
							eI = Z[1]
							LI = hI ~= eI.Character
						else
							LI = hI
						end
						eI = LI and (q:GetPlayerFromCharacter(hI))
						if eI then
							return hI:FindFirstChild("HumanoidRootPart") or mI, eI
						end
					end
				end
			end
			AI = YI:FindFirstChild("Hitbox", true)
			local eI, hI, mI, LI, gI = AI and AI.Position or YI:GetPivot().Position, ipairs, C[20](q:GetPlayers()), 40
			for iI, iI in hI(C:QH(mI)) do
				AI = Z[1]
				sI = iI ~= AI and iI.Character and iI.Character:FindFirstChild("HumanoidRootPart")
				if sI then
					if (sI.Position - eI).Magnitude < LI then
						YI = (sI.Position - eI).Magnitude
						LI, gI = YI, iI
					else
					end
				else
				end
			end
			if gI then
				return gI.Character.HumanoidRootPart, gI
			end
		end
		local function sI(YI)
			local eI = OI(YI)
			local AI, hI = eI and eI.State == "Carried"
			if AI then
				YI = nil
				YI, hI = Z[1], (tonumber(eI.CarrierUserId) or 0) ~= Z[1].UserId
			else
				hI = AI
			end
			return hI
		end
		local YI, eI = {}, Z[20]
		eI.unblock = function()
			for eI, AI in next, QI, nil do
				if AI - os.clock() <= 20 then
					QI[eI] = nil
				end
			end
			table.clear(YI)
		end
		local function eI(AI, hI, mI)
			local LI, gI = AI.Uid, Z[1]
			local iI, xI = gI.Character, Z[8]
			local SI, HI = xI(), Z[25]
			gI, xI = HI.thief or AI.kind == "pick"
			if gI then
				xI = gI
			else
				HI = Z[20]
				xI = LI == HI.chaseUid
			end
			if xI then
				if (YI[LI] or 0) > os.clock() then
					return false, "Taken by someone"
				end
			else
				return false, "Taken by someone"
			end
			HI = Z[20]
			if not (HI.bat()) then
				return false, "No bat to take it back"
			end
			gI = Z[20]
			if gI.invisible() then
				HI = Z[11]
				HI("Turning visible to take " .. AI.Name .. " back")
				xI = Z[20]
				xI.keepVis = os.clock() + 120
				local _I = Z[20]
				if _I.body(false) then
					if not (hI()) then
						return false, "visible"
					end
				else
					return false, "visible"
				end
			end
			if Z[13](hI) then
				gI = Z[14]
				if not (gI(hI)) then
					return false, "Stuck on treadmill"
				end
			else
				return false, "Stuck on treadmill"
			end
			HI, gI = lI(LI), Z[15]
			xI = gI()
			if HI then
				if xI then
					if (HI.Position - xI.Position).Magnitude > 700 then
						gI = Z[11]
						gI("Ragdoll jump to the carrier")
						MI(function()
							local _I = lI(LI)
							local oI
							if _I then
								local BI
								BI, oI = Z[28], _I.Position + Z[28](0, 3, 0)
							else
								oI = _I
							end
							return oI
						end, hI)
					end
				end
			end
			xI = Z[20]
			xI.godHunt = true
			local _I
			gI = Z[61]
			local function oI(BI)
				if _I then
					pcall(Z[20].huntStep, _I[1], _I[2], BI)
				end
			end
			local BI, vI, zI = gI.PreSimulation:Connect(oI), os.clock(), false
			gI, oI = 0, 0
			while true do
				xI = hI()
				local cI
				if xI then
					local DI = Z[1]
					cI = DI.Character == iI
				else
					cI = xI
				end
				if not (cI and os.clock() - vI < 90) then
					break
				end
				local DI, NI = Z[21], zI
				if DI(LI) then
					zI = true
					break
				end
				DI = OI(LI)
				if if DI then DI.State ~= "Carried" else not DI then
					zI = DI ~= nil and (DI.State == "Slot" or DI.State == "Dropped")
					break
				end
				DI, cI = lI(LI)
				local lI, VI = DI and cI
				if lI then
					local II = Z[16]
					VI = not II(DI.Position)
				else
					VI = lI
				end
				_I = VI and { cI, DI } or nil
				if not _I and SI then
					SI.PlatformStand = false
				end
				gI = DI and 0 or gI
				lI = Z[11]
				lI(
					DI
							and (_I and ("Chasing %s for %s"):format(cI.DisplayName, AI.Name) or "The carrier reached their base")
						or "Looking for the egg carrier"
				)
				cI = Z[23]
				lI = cI()
				if DI then
				else
					gI += lI
					if gI >= 3 then
						zI, HI = NI, DI
						break
					end
				end
				oI = DI and not _I and oI + lI or 0
				if oI > 1.5 then
					YI[LI] = os.clock() + 60
					zI, HI = NI, DI
					break
				end
				HI = DI
			end
			_I = nil
			BI:Disconnect()
			gI = Z[20]
			gI.godHunt = false
			if SI then
				SI.PlatformStand = false
			end
			BI, gI = zI and (hI())
			if BI then
				HI = Z[1]
				gI = HI.Character == iI
			else
				gI = BI
			end
			if gI then
				local function lI(gI)
					local _I = Z[11]
					_I(AI.Name .. " went back to its nest, going for it")
					AI.Pos = gI.BottomCFrame.Position
					gI, _I = FI(AI, hI)
					if gI then
						return aI(LI, hI, AI.Pos)
					end
					return gI, _I
				end
				xI = Z[21]
				vI, oI = xI(LI), OI(LI)
				if (if vI then not vI else oI) and oI.State == "Slot" then
					vI = (lI(oI))
				else
					if vI then
					else
						if oI then
							HI = Z[11]
							HI("The egg fell, taking it")
							local gI, xI, HI, _I = tI(oI), Z[26], Z[27], Z[28]
							xI(HI(gI + _I(0, 3, 0)))
							vI = (aI(LI, hI, gI))
						else
						end
					end
					if vI then
						BI = Z[22]
						BI("Egg", "DropFieldEgg", "PlayerRequest")
						SI = 0
						while true do
							iI = Z[23]
							SI += iI()
							oI = OI(LI)
							local gI = Z[32]
							if SI > 1 + gI() or not oI or oI.State ~= "Carried" then
								break
							end
						end
						if oI then
							if oI.State == "Dropped" then
								local gI
								vI, gI = aI(LI, hI, tI(oI)), OI(LI)
								oI = gI
							else
							end
						else
						end
						local gI = Z[21]
						vI = if gI(LI) then vI else if oI then if oI.State == "Slot" then lI(oI) else vI else vI
					else
					end
				end
				if vI then
					local lI, gI = JI(LI, hI)
					if not lI then
						if hI() then
							if (mI or 0) < 4 then
								if sI(LI) then
									return eI(AI, hI, (mI or 0) + 1)
								end
							end
						end
					end
					return lI, gI
				end
			end
			YI[LI] = math.max(YI[LI] or 0, os.clock() + 0.5)
			return false, zI and "Could not take the fallen egg" or "The carrier got away with the egg"
		end
		function wI.run(lI, YI)
			local AI = Z[20]
			AI.stealKind = lI.kind
			AI = Z[20]
			AI.flyY = nil
			AI = Z[20]
			AI.curArea = tostring(lI.a)
			wI.cv = lI.v
			AI = Z[20]
			AI.curUid = lI.Uid
			AI = Z[20]
			if AI.hud then
				local hI = Z[20]
				hI.hud.Refresh()
			end
			AI = Z[21]
			local hI = AI()
			AI = nil
			if hI then
				local mI = Z[21]
				AI = not mI(lI.Uid)
			else
				AI = hI
			end
			if AI then
				hI = Z[22]
				hI("Egg", "DropFieldEgg", "PlayerRequest")
				local mI = 0
				while true do
					local LI = Z[21]
					if not (LI() and mI < 1.5) then
						break
					end
					LI = Z[23]
					mI += LI()
				end
			end
			AI = Z[46]
			AI.cur = lI.Name
			AI = Z[20]
			if AI.greenLight then
				hI = Z[20]
				hI.greenLight(lI.Uid, YI)
			end
			hI = Z[1]
			local mI, LI, gI, iI, tI, xI = hI.Character, YI, false
			AI = Z[25]
			local SI, HI = fI[AI.order] or "v"
			local function fI()
				if not HI then
					local _I = Z[21]
					if not (_I()) then
						if os.clock() >= (wI.bcAt or 0) then
							wI.bcAt = os.clock() + 0.3
							local _I = kI()[1]
							if _I then
								if _I.Uid ~= lI.Uid then
									if not _I.held then
										if _I.b > lI.b then
											HI = _I
										elseif _I.b == lI.b then
											if SI ~= "near" then
												if (_I[SI] or 0) > (lI[SI] or 0) then
													HI = _I
												elseif _I[SI] == lI[SI] then
													if _I.v > lI.v then
														HI = _I
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end
				local kI = if HI then not HI else YI()
				return kI
			end
			AI = Z[25]
			local kI, SI = AI.adminSteal
			if kI then
				SI = kI
			else
				AI = nil
				AI, SI = Z[20], lI.Uid == Z[20].mgUid
			end
			if SI and (ZI()) then
				iI = RI(lI, YI)
				if iI then
					AI = TI[43]
					if AI() then
						uI[lI.Uid] = os.clock() + 300
					end
					hI, kI = Z[11], TI[43]
					hI(kI() and "Dropped " .. lI.Name .. " at the safe zone" or "Stole " .. lI.Name, "ok")
					return
				end
				local RI = Z[21]
				if RI() then
					local _I = Z[22]
					_I("Egg", "DropFieldEgg", "PlayerRequest")
				end
				if YI() then
					RI = Z[1]
					if RI.Character ~= mI then
						return
					end
				else
					return
				end
			else
				local RI = Z[25]
				if RI.adminSteal then
					YI = function()
						local RI = Z[21]
						if not (RI()) then
							if ZI() then
								gI = true
								return false
							end
						end
						return LI()
					end
				else
				end
			end
			kI = Z[20]
			kI.tpOv = nil
			hI = Z[20]
			SI, kI = hI.tpLost(lI.Uid), Z[20]
			local RI, _I, oI, BI = kI.tpCodium(), os.clock(), Z[20], Z[25]
			kI, hI = BI.moveTo == "Teleport"
			if kI then
				BI = nil
				BI, hI = Z[20], table.find(Z[20].TZ, tostring(lI.a)) ~= nil
			else
				hI = kI
			end
			AI = nil
			if hI then
				kI = nil
				kI, AI = Z[25], table.find(Z[25].tpZones or {}, tostring(lI.a)) ~= nil
			else
				AI = hI
			end
			BI = nil
			if AI then
				hI = Z[15]
				BI = hI() ~= nil
			else
				BI = AI
			end
			oI.tpNow = BI and not (RI and SI >= 6)
			hI, BI, kI = Z[20], Z[20], Z[20]
			oI, AI = kI.tpNow and RI and SI >= 2
			if oI then
				local vI, zI = SI >= 5
				if vI then
					kI = Z[20]
					zI = kI.TPM[1]
				else
					zI = vI
				end
				vI = nil
				if zI then
					vI = zI
				else
					local cI = Z[20]
					local DI = cI.tpRapid()
					if DI then
						cI = Z[20]
						vI = cI.TPM[2]
					else
						vI = DI
					end
				end
				if vI then
					AI = vI
				else
					zI = Z[20]
					AI = zI.TPM[3]
				end
			else
				AI = oI
			end
			hI.tpOv, BI.agForce = AI or nil, RI and SI >= 5
			kI, BI = RI and SI >= 2
			if kI then
				hI = Z[20]
				BI = hI.tpOv or SI >= 6
			else
				BI = kI
			end
			if BI then
				kI, oI, AI = Z[11], SI >= 6 and "Walk"
				if oI then
					AI = oI
				else
					hI = Z[20]
					AI = hI.tpOv
				end
				local vI = Z[20]
				kI("Lost " .. SI .. " times, trying " .. AI .. (vI.agForce and " with Anti Guard" or ""))
			end
			if RI then
				if SI >= 6 then
					AI = Z[20]
					AI.tpFail[lI.Uid][2] = os.clock()
				end
			end
			if lI.held then
				tI = "Taken by someone"
			else
				kI = Z[20]
				if kI.tpNow then
					xI = true
					AI, hI = EI(lI, fI)
					if hI == "grabbed" then
						iI, tI = JI(lI.Uid, YI)
					else
						iI, tI = AI, hI
					end
					if iI then
					else
						if YI() then
							oI = Z[1]
							if oI.Character == mI then
								if sI(lI.Uid) then
									local EI, vI = Z[20], Z[20]
									EI.chaseUid, vI.chaseAt = lI.Uid, os.clock()
									iI, tI = eI(lI, YI)
								else
									if tI == "Dropped on the way" then
										BI = TI[51]
										if BI(lI.Uid, YI) then
											iI, tI = JI(lI.Uid, YI)
										else
										end
									else
									end
								end
							else
							end
						else
						end
					end
					local EI = Z[20]
					EI.tpOv = nil
					local vI, zI = if iI then not iI else RI
					if vI then
						EI = Z[20]
						zI = (EI.gotAt[lI.Uid] or 0) >= _I
					else
						zI = vI
					end
					EI = zI and OI(lI.Uid)
					zI = EI and (EI.State == "GuardCarried" or EI.State == "Slot")
					if zI then
						vI = Z[20]
						vI.tpFail[lI.Uid] = { SI + 1, os.clock() }
					end
				else
					for EI = 1, 2, 1 do
						local vI, zI = FI(lI, fI)
						if vI then
							iI, tI = vI, zI
							break
						elseif zI == "Taken by someone" then
							iI, tI = vI, zI
							break
						else
							EI = Z[1]
							if EI.Character ~= mI then
								iI, tI = vI, zI
								break
							elseif YI() then
								local FI = Z[29]
								if not (FI()) then
									iI, tI = vI, zI
									break
								end
							else
								iI, tI = vI, zI
								break
							end
						end
						EI = Z[11]
						EI("Knocked down, trying again")
						iI, tI = vI, zI
					end
					if iI then
						local EI = Z[18]
						for FI, FI in pairs(EI()) do
							if type(FI) == "table" then
								if FI.Uid == lI.Uid then
									if FI.State ~= "Slot" then
										if FI.State ~= "Dropped" then
											local EI, FI = false, "Taken by someone"
											iI, tI = EI, FI
										else
										end
									else
									end
								else
								end
							else
							end
						end
					else
					end
				end
			end
			SI = nil
			if HI then
				_I = Z[21]
				SI = not _I()
			else
				SI = HI
			end
			if SI then
				fI = Z[11]
				fI("Better egg: " .. tostring(HI.Name) .. ", switching")
				return
			end
			if tI == "Taken by someone" then
				BI, SI = Z[20], Z[20]
				BI.chaseUid, SI.chaseAt = lI.Uid, os.clock()
				iI, tI = eI(lI, YI)
			else
				if iI then
					if xI then
					else
						RI, oI = aI(lI.Uid, YI, lI.Pos, true)
						hI, kI = nil
						if RI then
							hI, kI = JI(lI.Uid, YI)
						else
							hI, kI = RI, oI
						end
						if hI then
							iI, tI = hI, kI
						else
							if YI() then
								if sI(lI.Uid) then
									_I, AI = Z[20], Z[20]
									_I.chaseUid, AI.chaseAt = lI.Uid, os.clock()
									iI, tI = eI(lI, YI)
								else
									iI, tI = hI, kI
								end
							else
								iI, tI = hI, kI
							end
						end
					end
				else
				end
			end
			kI = nil
			if gI then
				AI = Z[21]
				kI = not AI()
			else
				kI = gI
			end
			if kI then
				if LI() then
					oI = Z[1]
					if oI.Character == mI then
						BI = Z[11]
						BI("Admin treadmill is up, switching to Instant steal")
						return wI.run(lI, LI)
					end
				end
			end
			SI = Z[21]
			if SI() then
				kI = Z[1]
				if kI.Character == mI then
					if not iI then
						oI = TI[43]
						if not (oI()) then
							AI = Z[22]
							AI("Egg", "DropFieldEgg", "PlayerRequest")
						end
					end
				end
			end
			if iI then
				fI = Z[20]
				if fI.chaseUid == lI.Uid then
					AI = Z[20]
					AI.chaseUid = nil
				end
			end
			if not iI then
				oI, AI, SI = OI(lI.Uid), 0
				if xI then
					BI = nil
					BI, SI = Z[25], tostring(Z[25].tpDel):lower() ~= "walk"
				else
					SI = xI
				end
				if SI then
					AI = 12
				else
					if oI then
						if oI.State == "GuardCarried" then
							hI = Z[11]
							hI("Waiting for the guard to bring " .. lI.Name .. " back")
						end
					end
				end
				while YI() and AI < 12 do
					_I = OI(lI.Uid)
					if _I then
						if not (_I.State == "GuardCarried") then
							break
						end
					else
						break
					end
					kI = Z[23]
					AI += kI()
				end
			end
			if tI == "visible" then
				return
			end
			oI, BI, SI = tI == "Egg went back to its nest", Z[20], table.find(Z[20].pick, lI.Uid)
			if iI then
				if SI then
					table.remove(Z[20].pick, SI)
				end
				RI, AI = Z[11], TI[43]
				RI(AI() and "Dropped " .. lI.Name .. " at the safe zone" or "Stole " .. lI.Name, "ok")
				kI = TI[43]
				fI = kI() and YI() and OI(lI.Uid)
				if fI then
					if fI.State == "Dropped" then
						uI[lI.Uid] = os.clock() + 300
					end
				end
			elseif tI == nil and iI == nil then
				_I = Z[11]
				_I("Sent " .. lI.Name .. " home", "ok")
			else
				hI = YI()
				local OI
				if hI then
					local TI = Z[1]
					OI = TI.Character == mI
				else
					OI = hI
				end
				if OI and (a()) then
					if tI == "The carrier got away with the egg" then
						local OI = Z[20]
						OI.chaseUid = nil
					elseif tI == "No bat to take it back" then
						local OI = Z[20]
						OI.chaseUid = nil
					end
					if tI == "No bat to take it back" then
						QI[lI.Uid] = os.clock() + 20
					end
					wI.fullTx = nil
					if tI == "Pet bag is full" then
						wI.full = os.clock() + 30
						wI.fullTx = "Pet bag is full, sell or fuse pets to steal again"
					elseif tI == "Bag is full" then
						local OI = Z[25]
						if OI.bagSell and WI(lI.v) then
							QI[lI.Uid] = nil
						else
							wI.full = os.clock() + 30
						end
					end
					local OI = Z[11]
					OI((tI or "Steal failed") .. " - " .. lI.Name, "warn")
					if oI and os.clock() >= (wI.pingAt or 0) then
						OI = 0
						for TI = 1, 10, 1 do
							TI = Z[23]
							OI += TI()
						end
						local TI, lI, WI =
							10 / math.max(OI, 0.001), pcall(function()
								return d("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
							end)
						local OI = lI and WI
						if OI then
							WI = OI
						else
							lI = Z[32]
							WI = lI() * 1000
						end
						if WI > 300 then
							wI.pingAt = os.clock() + 60
							c(
								"High ping: egg went back to nest",
								("Your ping is %d ms. Hop to a server with lower ping."):format(WI),
								"err"
							)
						elseif TI < 15 then
							wI.pingAt = os.clock() + 60
							c(
								"Low FPS: egg went back to nest",
								("You run at %d FPS. Turn on Low graphics or close other apps."):format(TI),
								"err"
							)
						end
					end
				end
			end
		end
	end)
	w("10_steal#2", function()
		local OI = {}
		local TI = Z[20]
		local lI, WI, EI = TI.stealSec, z:State("Anti Guard Enabled", false), Z[25]
		EI.antiGuard = WI.Value == true
		EI, TI = WI.Value, function(FI)
			if WI.Value == true ~= FI then
				WI:Set(FI)
			end
		end
		local FI = lI:Toggle("Anti Guard", EI == true, TI)
		WI.ls = {
			function(EI)
				local sI = Z[25]
				sI.antiGuard = EI == true
				sI = Z[25]
				if FI.Value ~= sI.antiGuard then
					EI = Z[25]
					FI:Set(EI.antiGuard)
				end
				sI = Z[20]
				if sI.hud then
					EI = Z[20]
					EI.hud.Sync()
				end
			end,
		}
		TI = Z[20]
		TI.agT = WI
		local TI
		TI = j(lI, "Drop Eggs At Safe Zone", "dropSafe", false, function(lI)
			if lI then
				if z.busy then
					return
				elseif not z.ready then
					return
				end
			else
				return
			end
			z:Dialog({
				Title = "Drop Eggs At Safe Zone",
				Warn = "WARNING",
				Body = "Eggs will be dropped in front of the safe zone. They will NOT be stolen into your base.",
				Cancel = "Cancel",
				Accept = "Turn On",
				no = function()
					TI:Set(false)
				end,
			})
		end)
		local function TI(lI)
			return lI > 0 and (math.random() * 2 - 1) * lI or 0
		end
		local lI, WI = {}, Z[33]
		lI.off = WI
		lI.freeze = true
		lI.hop = 0
		lI.hold = 0
		lI.steps = { { 0 }, { 1.27, true } }
		lI.rel = 1.52
		lI.busy = 2.5
		local WI, EI, FI = false, false, { since = 0 }
		OI[62] = WI
		OI[60] = function()
			local WI, sI, aI, JI = ipairs, {}, {}, Z[28]
			C:EH(aI, 0, "GearGiver_Slap", "Podium", JI(-16.415, 21.072, -6.106))
			local JI, YI = {}, Z[28]
			C:EH(
				JI,
				0,
				"World",
				"Machines",
				"RiftMachine",
				"Rift",
				"Meshes/VoidPortal_Cube.003",
				YI(-26.776, 1.75, 18.665)
			)
			C:EH(sI, 0, aI, JI)
			for aI, aI in WI(sI) do
				JI = workspace
				for WI = 1, #aI - 1, 1 do
					JI = JI and JI:FindFirstChild(aI[WI])
				end
				if JI then
					if JI:IsA("BasePart") then
						return JI.CFrame:PointToWorldSpace(aI[#aI])
					end
				end
			end
			sI = Z[28]
			return sI(528.7, 70.57, -364.11)
		end
		OI[59] = function(WI)
			local sI = Z[54]
			local aI = sI("Areas", "SeparationLine")
			if aI then
				if not (aI:IsA("BasePart")) then
					return
				end
			else
				return
			end
			local JI, YI = aI.CFrame, Z[28]
			local RI, RI =
				Z[28], YI(0, 1, 0):Cross(aI.Size.X >= aI.Size.Z and JI.RightVector or JI.LookVector) * Z[28](1, 0, 1)
			if RI.Magnitude <= 0.001 then
				return
			end
			RI = RI.Unit
			sI, aI = JI.Position + ((WI - JI.Position):Dot(RI) >= 0 and -RI or RI) * 8, Z[28]
			return aI(sI.X, WI.Y + 0.5, sI.Z)
		end
		OI[57] = function()
			return lI
		end
		OI[58] = function(lI)
			if lI.hop <= 0 then
				if lI.hold <= 0 then
					return lI.steps, lI.rel
				end
			end
			local WI, sI, aI = {}, 0, 0
			for JI, YI in ipairs(lI.steps) do
				sI, aI = math.max(sI + math.max(YI[1] - aI, 0) + TI(YI[2] and lI.hold or lI.hop), 0), YI[1]
				WI[JI] = { sI, YI[2] }
			end
			return WI, sI + math.max(lI.rel - aI, 0)
		end
		local TI
		OI[63] = TI
		local TI = Z[20]
		TI.place = function(...)
			local TI = OI[63]
			return TI(...)
		end
		OI[63] = function(TI, lI, WI, sI)
			pcall(TI.PivotTo, TI, Z[27](WI))
			if (lI.Position - WI).Magnitude > 3 then
				pcall(function()
					local aI = Z[27]
					lI.CFrame = aI(WI)
				end)
			end
			if not sI then
				return
			end
			local lI, WI = ipairs, C[20](TI:GetDescendants())
			for TI, TI in lI(C:QH(WI)) do
				if TI:IsA("BasePart") then
					pcall(function()
						local lI, WI = Z[33], Z[33]
						TI.AssemblyLinearVelocity = lI
						TI.AssemblyAngularVelocity = WI
					end)
				end
			end
		end
		OI[65] = function()
			local TI = Z[15]
			local lI = TI()
			for TI, TI in ipairs(lI and workspace:GetChildren() or {}) do
				if TI:IsA("Model") and TI:FindFirstChild("Hitbox") then
					for WI, WI in ipairs(TI:GetDescendants()) do
						if WI:IsA("JointInstance") or WI:IsA("WeldConstraint") or WI:IsA("RigidConstraint") then
							if WI.Part0 == lI then
								return TI
							elseif WI.Part1 == lI then
								return TI
							end
						end
					end
				end
			end
		end
		local function TI()
			local lI = FI.dis
			if not lI then
				return
			end
			FI.dis = nil
			local WI, WI = Z[61], Z[61]
			pcall(Z[61].UnbindFromRenderStep, Z[61], "VenyxAG")
			lI.beat:Disconnect()
			pcall(function()
				lI.cam.CameraType = lI.type == Enum.CameraType.Scriptable and Enum.CameraType.Custom or lI.type
			end)
			local lI = Z[20]
			lI.camScr = false
			lI = Z[20]
			lI.camHome()
		end
		OI[64] = function()
			local lI = workspace.CurrentCamera
			if not lI or FI.dis then
				return
			end
			local WI = { cam = lI }
			WI.type = lI.CameraType
			WI.cf = lI.CFrame
			local sI = Z[20]
			FI.dis = WI
			sI.camScr = true
			local function aI()
				pcall(function()
					lI.CameraType = Enum.CameraType.Scriptable
					lI.CFrame = WI.cf
				end)
			end
			aI()
			local lI, lI = Z[61], Z[61]
			pcall(Z[61].BindToRenderStep, Z[61], "VenyxAG", Enum.RenderPriority.Last.Value + 1, aI)
			sI = Z[61]
			WI.beat = sI.Heartbeat:Connect(aI)
		end
		OI[55] = function()
			TI()
			local TI = Z[8]
			local lI = TI()
			if lI and lI.PlatformStand then
				pcall(function()
					lI.PlatformStand = false
				end)
			end
			TI = Z[20]
			TI.agBusy = false
		end
		local TI, lI =
			C:FH(
				17,
				18,
				{
					[1] = Z,
					[15] = Z,
					[8] = Z,
					[20] = Z,
					[55] = OI,
					[56] = Z,
					[57] = OI,
					[58] = OI,
					[59] = OI,
					[60] = OI,
					[61] = Z,
					[33] = Z,
					[62] = OI,
					[63] = OI,
					[64] = OI,
					[54] = Z,
					[65] = OI,
				},
				O,
				p,
				nil
			),
			Z[20]
		lI.agKick = function()
			local lI = Z[20]
			if lI.agBusy then
				return
			elseif not Z[56] then
				return
			end
			local lI, WI = Z[20], Z[20]
			lI.agBusy, FI.since, WI.agAt = true, os.clock(), os.clock()
			task.spawn(function()
				if not (pcall(TI, os.clock())) then
					local TI = OI[55]
					TI()
				end
			end)
		end
		local TI, lI, WI = false, false, false
		local function sI()
			local aI = Z[25]
			local JI, YI = aI.antiGuard
			if JI then
				YI = JI
			else
				aI = Z[20]
				YI = aI.agForce and Z[4] == wI
			end
			aI = nil
			if YI then
				JI = Z[20]
				local RI, eI = JI.tpNow
				if RI then
					local fI = Z[25]
					eI = fI.steal
				else
					eI = RI
				end
				RI = nil
				if eI then
					local fI = Z[20]
					RI = fI.tpCodium()
				else
					RI = eI
				end
				aI = not RI
			else
				aI = YI
			end
			JI = nil
			if aI then
				YI = Z[20]
				JI = not YI.agBusy
			else
				JI = aI
			end
			YI = nil
			if JI then
				aI = Z[20]
				YI = not aI.rag
			else
				YI = JI
			end
			aI = nil
			if YI then
				local RI, eI = Z[4]
				if RI then
					JI = Z[4].name ~= "Steal"
					if JI then
						eI = JI
					else
						local JI = Z[20]
						local fI = JI.cmode(true) ~= "Tween"
						if fI then
							JI = Z[20]
							eI = JI.cmode(true) ~= "Teleport"
						else
							eI = fI
						end
					end
				else
					eI = RI
				end
				aI = not eI
			else
				aI = YI
			end
			return aI
		end
		local function aI()
			local JI = WI
			WI = TI or lI
			if WI then
				if not JI then
					if sI() then
						local JI = Z[20]
						JI.agKick()
					end
				end
			end
		end
		local JI, JI = Z[1], tostring(Z[1].UserId)
		local function YI()
			local RI, eI = FI.area
			if RI then
				local fI = Z[54]
				eI = fI("Areas", "GuardAreas", FI.area)
			else
				eI = RI
			end
			RI = eI and (eI:FindFirstChild("Guard"))
			return RI
				and RI:GetAttribute("GuardState") ~= "Sleeping"
				and (RI:GetAttribute("TargetPlayer") == JI or RI:GetAttribute("WakeTargetPlayer") == JI)
		end
		task.spawn(function()
			local JI = Z[34]
			local RI = JI.Egg
			if RI then
				if not RI.CarryChanged then
					return
				end
			else
				return
			end
			W(RI.CarryChanged, function(JI)
				TI = type(JI) == "table" and JI.IsCarrying == true and JI.GuardDisabled ~= true
				FI.area = TI and type(JI.AreaId) == "string" and JI.AreaId or nil
				FI.dirty = true
				JI = OI[62]
				if JI then
					FI.dirty = nil
					aI()
				end
			end)
		end)
		local TI, JI = 0, Z[61]
		W(JI.Heartbeat, function(JI)
			local RI = Z[20]
			if RI.agBusy then
				local eI, fI, fI, fI = os.clock() - FI.since, OI[57], OI[57], math.max(OI[57]().busy, OI[57]().rel + 1)
				if eI > fI then
					local eI = OI[55]
					eI()
				end
			end
			if FI.dirty then
				FI.dirty = nil
				aI()
			end
			if EI then
				if WI then
					if os.clock() - (FI.kAt or 0) > 0.3 then
						if sI() then
							if YI() then
								FI.kAt = os.clock()
								RI = Z[20]
								RI.agKick()
							end
						end
					end
				end
			end
			TI += JI
			RI = Z[25]
			if RI.antiGuard then
				if TI < 0.03 then
					return
				end
			else
				JI = Z[20]
				if JI.agForce then
					if Z[4] == wI then
						if TI < 0.03 then
							return
						end
					else
						return
					end
				else
					return
				end
			end
			TI = 0
			RI = OI[65]
			JI = RI() ~= nil
			if JI ~= lI then
				lI = JI
				aI()
			end
		end)
		table.insert(Z[20].cleanup, OI[55])
	end)
	B = {
		Golden = Color3.fromRGB(255, 206, 84),
		Silver = Color3.fromRGB(205, 216, 236),
		Rainbow = Color3.fromRGB(255, 120, 220),
		Scrambled = Color3.fromRGB(186, 120, 255),
		Boss = Color3.fromRGB(255, 104, 104),
		Enchanted = Color3.fromRGB(104, 236, 255),
		Sakura = Color3.fromRGB(255, 166, 214),
		GreatBloom = Color3.fromRGB(176, 255, 166),
		Monstrous = Color3.fromRGB(150, 255, 110),
		Nitro = Color3.fromRGB(255, 150, 64),
		Spectral = Color3.fromRGB(110, 235, 220),
		Alien = Color3.fromRGB(181, 255, 165),
		Musical = Color3.fromRGB(255, 130, 210),
		DarkMatter = Color3.fromRGB(150, 110, 255),
	}
	w("12_hud#1", function()
		local B = d("TweenService")
		local OI = Color3.fromRGB
		local TI = UDim2.fromScale
		local lI = UDim2.fromOffset
		local WI = Vector2.new
		local EI = M.q
		local FI = TweenInfo.new
		local sI = Enum.EasingStyle
		local aI = Enum.EasingDirection
		local JI, YI, RI =
			gethui and gethui() or d("CoreGui"),
			{ "Best Rarity", "Biggest Weight", "Best Mutation", "Highest Value", "Lowest Value" },
			{}
		RI[YI[1]] = "Rarity"
		RI[YI[2]] = "Weight"
		RI[YI[3]] = "Mutation"
		RI[YI[4]] = "Value"
		RI[YI[5]] = "Lowest"
		RI.Index = "Index"
		local eI = z.ByPath["Farm > Auto Steal > Steal Priority"]
		local fI, QI = eI and eI.Value or YI[4], false
		if eI then
			table.insert(eI.ls, function(uI)
				fI = uI
			end)
		end
		local function uI()
			return T:GenerateGUID(false):gsub("-", ""):sub(1, 14)
		end
		local function AI(hI, mI)
			return hI and (hI:FindFirstChild(mI))
		end
		local function hI(mI)
			return mI:FindFirstChildOfClass("UIGradient")
		end
		local function mI(kI)
			return (kI and kI.Value) == true
		end
		local function kI()
			local LI, gI, iI, tI = {}, {}, 0, Z[20]
			for xI, xI in ipairs(tI.pick) do
				if not gI[xI] then
					gI[xI] = true
					LI[#LI + 1] = xI
				end
			end
			tI = Z[25]
			if tI.steal then
				local tI, xI = Z[20], Z[20]
				for SI, HI in ipairs(tI.stealSort(xI.allEggs())) do
					if HI.tg then
						if gI[HI.Uid] then
						else
							if iI < 8 then
								SI = iI + 1
								gI[HI.Uid] = true
								LI[#LI + 1] = HI.Uid
								iI = SI
							else
							end
						end
					else
					end
				end
			end
			gI = Z[20]
			return LI, gI.curUid
		end
		local function LI()
			local gI = Z[20]
			gI.rank.Steal = 0
			gI = Z[20]
			if gI.order then
				local gI = Z[20]
				gI.order()
			end
		end
		local function gI(iI)
			local tI, tI = Z[20], table.find(Z[20].pick, iI)
			if tI then
				table.remove(Z[20].pick, tI)
			end
		end
		local function iI(tI)
			gI(tI)
			table.insert(Z[20].pick, 1, tI)
			local xI = Z[20]
			xI.skip[tI] = nil
			LI()
			xI = Z[20]
			xI.retarget()
		end
		local function tI(xI)
			gI(xI)
			local gI = Z[20]
			if gI.curUid == xI then
				local gI = Z[20]
				gI.stopSteal()
			end
		end
		local function gI()
			local xI = Z[25]
			if not xI.steal then
				local xI = Z[20]
				if xI.autoSteal then
					local xI = Z[20]
					xI.autoSteal:Set(true)
				end
			end
		end
		local function xI(SI, HI)
			local _I = kI()
			local oI = table.find(_I, SI)
			SI = oI and oI + HI
			if SI then
				if not _I[SI] then
					return
				end
			else
				return
			end
			_I[oI], _I[SI] = _I[SI], _I[oI]
			local BI, vI = math.max(oI, SI), #_I
			for SI = 1, vI, 1 do
				HI = nil
				HI, BI = Z[20], if table.find(Z[20].pick, _I[SI]) then math.max(BI, SI) else BI
			end
			table.clear(Z[20].pick)
			table.move(_I, 1, BI, 1, Z[20].pick)
			LI()
		end
		local function SI()
			pcall(function()
				local HI = AI(d("SoundService"), "Gameplay")
				local _I = F(
					"Sound",
					{
						SoundId = "rbxassetid://100671636189844",
						Volume = 3.4,
						PlaybackSpeed = 0.93 + math.random() * 0.13,
						SoundGroup = HI and HI:IsA("SoundGroup") and HI or nil,
						Parent = JI,
					}
				)
				_I:Play()
				d("Debris"):AddItem(_I, 3)
			end)
		end
		local HI = FI(0.3, sI.Back, aI.Out)
		local _I = FI(0.24, sI.Quad, aI.In)
		local oI = FI(0.22, sI.Quad, aI.In)
		local BI = FI(0.16, sI.Quad, aI.Out)
		local function vI(zI, cI, DI)
			local NI = B:Create(zI, cI, DI)
			NI:Play()
			return NI
		end
		local function B(...)
			local zI, cI = { ... }, {}
			for DI = 1, #zI, 2 do
				cI[#cI + 1] = ColorSequenceKeypoint.new(zI[DI], zI[DI + 1])
			end
			return ColorSequence.new(cI)
		end
		local function zI(cI, DI, NI, VI, II)
			return { Color = ColorSequence.new(cI, DI), Rotation = NI, Stroke = VI, Light = II }
		end
		local cI = {}
		cI.Hud = zI(OI(0, 118, 255), OI(72, 204, 255), -90, OI(0, 28, 76), OI(172, 226, 255))
		cI.Steal = zI(OI(60, 255, 0), OI(136, 255, 0), -90, OI(11, 72, 0), OI(190, 255, 180))
		cI.Queued = zI(OI(118, 118, 132), OI(172, 172, 186), -90, OI(28, 28, 34), OI(214, 214, 226))
		cI.Pri = zI(OI(255, 247, 0), OI(255, 136, 0), 90, OI(0, 0, 0), OI(132, 112, 0))
		cI.Cancel = zI(OI(214, 17, 17), OI(253, 20, 20), -90, OI(72, 0, 0), OI(255, 103, 103))
		cI.Chilli = {
			Color = B(
				0,
				OI(132, 74, 255),
				0.34,
				OI(178, 74, 255),
				0.6,
				OI(255, 104, 206),
				0.78,
				OI(255, 168, 232),
				1,
				OI(146, 66, 255)
			),
			Rotation = -115,
			Stroke = OI(44, 10, 80),
			Light = OI(226, 178, 255),
		}
		local zI, DI =
			B(
				0,
				OI(255, 255, 255),
				0.2,
				OI(206, 212, 224),
				0.42,
				OI(74, 80, 94),
				0.58,
				OI(42, 46, 56),
				0.78,
				OI(158, 166, 182),
				1,
				OI(250, 252, 255)
			),
			{ "", "K", "M", "B", "T", "Qa", "Qi", "Sx" }
		local NI, VI, II = "  " .. utf8.char(183) .. "  ", {}
		local function jI(KI)
			if VI[KI] then
				return VI[KI]
			end
			local XI = h(KI)
			XI = type(XI) == "table" and XI or {}
			local UI = type(XI.Rarity) == "table" and XI.Rarity or nil
			local GI = UI and UI.RarityGradient
			if UI then
				if typeof(GI) ~= "Instance" then
					if II == nil then
						II = AI(AI(AI(P, "Assets"), "UI"), "RarityGradients") or false
					end
					local C7 = AI(II, tostring(UI._id or UI.DisplayName or ""))
					GI = (AI(C7, "RarityGradient"))
				else
				end
			else
			end
			local II, C7 = ColorSequence.new(UI and typeof(UI.Color) == "Color3" and UI.Color or OI(255, 255, 255)), 90
			if UI and tostring(UI.DisplayName or UI._id or ""):upper() == "SECRET" then
				II = zI
			else
				if typeof(GI) == "Instance" then
					if GI:IsA("UIGradient") then
						local zI, O7 = GI.Color, GI.Rotation
						II, C7 = zI, O7
					else
					end
				else
				end
			end
			local zI = XI.Icon
			zI = if tonumber(zI) then "rbxassetid://" .. tostring(zI) else zI
			local GI = {
				Name = tostring(XI.DisplayName or KI),
				Icon = zI and tostring(zI) or "",
				RarityNumber = UI and tonumber(UI.RarityNumber or UI.Rank) or 0,
				GradientColor = II,
				GradientRotation = C7,
				EarningRate = tonumber(XI.EarningRate) or 0,
			}
			if GI.Icon ~= "" then
				VI[KI] = GI
			end
			return GI
		end
		local function zI(VI, II)
			local KI, XI = tonumber(VI.AssetScale) or 1, type(VI.Mutations) == "table" and VI.Mutations or {}
			XI = if #XI == 0
				then if type(VI.BaseMutation) == "string"
					then if VI.BaseMutation ~= "" then { VI.BaseMutation } else XI
					else XI
				else XI
			local UI, GI = pcall, Z[34]
			local C7, O7 = GI.Mut
			if C7 then
				VI = Z[34]
				O7 = VI.Mut.EarningsFor
			else
				O7 = C7
			end
			GI, C7 = UI(O7, XI)
			return II.EarningRate
				* (KI > 5 and (KI / 5) ^ 1.2 * 19.637875755794113 or KI ^ 1.85)
				* (GI and type(C7) == "number" and C7 or 1)
		end
		local function VI(II)
			local KI = 1
			while II >= 1000 and KI < #DI do
				II, KI = II / 1000, KI + 1
			end
			return "$"
				.. (KI == 1 and tostring(math.floor(II)) or ("%.1f"):format(math.floor(II * 10) / 10)):gsub("%.0$", "")
				.. DI[KI]
				.. "/s"
		end
		local function DI(II, KI)
			if II then
				if II.Text ~= KI then
					II.Text = KI
				end
			end
		end
		local function II(KI, XI)
			if KI.Visible ~= XI then
				KI.Visible = XI
			end
		end
		local KI, XI, UI, GI, C7, O7, p7, M7, Z7, n7, d7, q7, P7, r7, w7, b7, T7, y7, l7, W7, E7, F7, s7 =
			false, 0, false, false, false, 0, {}, {}, {}
		local a7, J7, Y7, R7, e7, f7 = z:State("Steal Panel Open", true), false, false, false
		local function Q7(u7, A7)
			p7[#p7 + 1] = u7:Connect(A7)
		end
		local function u7()
			local A7 = Z[1]
			local h7 = A7:FindFirstChildOfClass("PlayerGui")
			local m7, k7 = AI(h7, "HUD"), AI(h7, "ActivePets")
			A7 = AI(m7, "GameHUD")
			local L7 = AI(A7, "RightButtons")
			local g7, i7 = AI(L7, "EggsButton"), AI(L7, "PetsButton")
			if g7 then
				if i7 then
					if AI(k7, "Frame") then
						return {
							Hud = m7,
							GameHud = A7,
							Column = L7,
							Eggs = g7,
							Pets = i7,
							ActivePets = k7,
							GrowingEggs = AI(h7, "GrowingEggs"),
						}
					end
				end
			end
		end
		local function A7(h7)
			local m7, k7 = pcall(h7.Clone, h7)
			if m7 then
				if not k7 then
					return nil
				end
			else
				return nil
			end
			for h7, h7 in ipairs(k7:GetDescendants()) do
				if h7:IsA("LuaSourceContainer") then
					h7:Destroy()
				end
			end
			return k7
		end
		local function h7(m7)
			m7.Name = uI()
			for k7, k7 in ipairs(m7:GetDescendants()) do
				k7.Name = uI()
			end
		end
		local uI, m7, k7 = 2.3120369911193848, setmetatable, { __mode = "k" }
		local L7 = m7({}, k7)
		local m7, g7
		local function i7(t7, x7, S7)
			local H7, _7 = 0, 86.24
			if S7 then
				H7, _7 = w7 and w7.AbsoluteSize.X or 0, 556
			else
				H7 = if q7 then q7.Button.Size.X.Offset else H7
			end
			if H7 > 0 then
				if t7.Parent then
					t7.Thickness = x7 * (uI * H7 / _7)
				end
			end
		end
		local function t7()
			for x7, S7 in pairs(L7) do
				i7(x7, S7[1], S7[2])
			end
		end
		local function x7(S7, H7)
			local _7 = H7 and m7 or g7
			_7 = if _7 <= 0 then uI else _7
			for o7, B7 in ipairs(S7:GetDescendants()) do
				if B7:IsA("UIStroke") then
					if B7.StrokeSizingMode ~= Enum.StrokeSizingMode.ScaledSize then
						o7 = B7.Thickness / _7
						L7[B7] = { o7, H7 }
						i7(B7, o7, H7)
					end
				end
			end
		end
		local function L7(i7)
			return {
				Button = i7,
				Gradient = hI(i7),
				Stroke = AI(i7, "UIStroke"),
				Light = AI(i7, "UIStrokeClr"),
				Label = AI(i7, "Label") or AI(i7, "TextLabel"),
				Scale = AI(i7, "BtnScale"),
			}
		end
		local function i7(S7, H7)
			if S7.Style == H7 then
				return
			end
			S7.Style = H7
			if S7.Gradient then
				S7.Gradient.Color, S7.Gradient.Rotation = H7.Color, H7.Rotation
			end
			if S7.Stroke then
				S7.Stroke.Color = H7.Stroke
			end
			if S7.Light then
				S7.Light.Color = H7.Light
			end
		end
		local function S7(H7)
			local _7 = H7.Button
			local o7 = H7.Scale or F("UIScale", { Parent = _7 })
			local function H7(B7)
				return function()
					vI(o7, BI, { Scale = B7 })
				end
			end
			_7.MouseEnter:Connect((H7(1.08)))
			_7.MouseLeave:Connect((H7(1)))
			_7.MouseButton1Down:Connect((H7(0.94)))
			_7.MouseButton1Up:Connect((H7(1.08)))
		end
		local BI = {}
		local function H7(_7)
			for o7, o7 in ipairs(BI) do
				pcall(o7.Cancel, o7)
			end
			table.clear(BI)
			if not _7 then
				return
			end
			local function o7(B7, v7, z7)
				BI[#BI + 1] = vI(B7, FI(v7, sI.Sine, aI.InOut, -1, true), z7)
			end
			local FI = _7.Gradient
			if FI then
				FI.Offset = WI(-0.3, 0)
				o7(FI, 2.4, { Offset = WI(0.3, 0) })
				o7(FI, 6, { Rotation = -65 })
			end
			if _7.Light then
				o7(_7.Light, 1.6, { Color = OI(255, 245, 255) })
			end
		end
		local function FI(sI, aI)
			return sI and type(aI) == "table" and type(aI.Records) == "table" and aI.Records
		end
		local function sI()
			local aI = Z[34]
			local BI, _7 = aI.Egg
			local o7, B7 = false
			if BI then
				task.spawn(function()
					_7 = FI(pcall(BI.ReadFieldEggs))
				end)
				aI = setthreadidentity or set_thread_identity
				if aI then
					pcall(aI, 8)
				end
			end
			if _7 and next(_7) ~= nil then
				return _7
			end
			task.spawn(function()
				local BI = Z[9]
				B7, o7 = FI(BI("RF/EggWorld/AskFieldEggSnapshot")), true
			end)
			aI = os.clock()
			while true do
				local FI = not o7 and os.clock() - aI < 4
				if not FI then
					break
				end
				FI = Z[23]
				FI()
			end
			return B7
		end
		local function FI(aI)
			local BI, _7 = AI(AI(aI, "Frame"), "Close"), 0
			if BI then
				if getconnections then
					local o7, B7 = pcall(getconnections, BI.Activated)
					local BI = _7
					for _7, _7 in ipairs(o7 and type(B7) == "table" and B7 or {}) do
						BI = if pcall(function()
								_7:Fire()
							end)
							then BI + 1
							else BI
					end
					if BI == 0 then
						aI.Enabled = false
					end
				else
					aI.Enabled = false
				end
			else
				aI.Enabled = false
			end
		end
		local function aI()
			local BI, _7, o7 = ipairs, {}, n7.ActivePets
			C:EH(_7, 0, o7, n7.GrowingEggs)
			o7 = false
			for B7, B7 in BI(_7) do
				if B7.Enabled then
					FI(B7)
					o7 = true
				else
				end
			end
			return o7
		end
		local function FI(BI, _7)
			local o7 = n7.Column
			if not o7.Parent then
				return
			end
			if F7 then
				F7:Cancel()
				F7 = nil
			end
			local B7 = o7.Position
			local v7 = UDim2.new(B7.X.Scale, BI and math.ceil(o7.AbsoluteSize.X * 1.03) or 0, B7.Y.Scale, B7.Y.Offset)
			if _7 then
				o7.Position = v7
				return
			end
			F7 = vI(o7, BI and oI or HI, { Position = v7 })
		end
		local oI = 0.849
		local function BI(F7, _7, o7, B7)
			local v7 = _7 ~= nil
			F7.Rank = _7
			II(F7.Steal.Button, not v7)
			II(F7.Up.Button, v7)
			II(F7.Down.Button, v7)
			II(F7.Cancel.Button, v7)
			II(F7.Badge, v7)
			i7(F7.Star, _7 == 1 and cI.Pri or cI.Queued)
			if v7 then
				i7(F7.Up, _7 > 1 and cI.Hud or cI.Queued)
				i7(F7.Down, _7 < B7 and cI.Hud or cI.Queued)
				DI(F7.Badge, "#" .. _7)
				local _7 = o7 and cI.Steal or cI.Pri
				if F7.BadgeStyle ~= _7 then
					F7.BadgeStyle, F7.BadgeG.Color, F7.BadgeG.Rotation = _7, _7.Color, 90
				end
			end
		end
		local function F7(_7, o7, B7, v7)
			if _7.v ~= o7 then
				_7.v = o7
				i7(_7, B7)
				DI(_7.Label, v7)
			end
		end
		local function _7()
			local o7 = s7
			if not o7 then
				return
			end
			local B7 = Z[20]
			local v7, z7 = mI(B7.autoSteal), Z[20]
			B7 = mI(z7.agT)
			F7(o7.Toggle, v7, v7 and cI.Steal or cI.Cancel, v7 and "Auto Steal: ON" or "Auto Steal: OFF")
			F7(o7.Guard, B7, B7 and cI.Steal or cI.Cancel, B7 and "Anti Guard: ON" or "Anti Guard: OFF")
			z7 = QI and "Index" or fI
			if y7 then
				if o7.Sort ~= z7 then
					o7.Sort = z7
					DI(y7.Label, "Sort: " .. (RI[z7] or tostring(z7)))
				end
			end
		end
		local mI, F7, o7 = {}, {}, {}
		local function B7()
			if not l7 then
				return
			end
			_7()
			local v7, z7, c7 = {}, {}
			task.spawn(function()
				local D7, N7, V7 = pcall(kI)
				if D7 then
					z7, c7 = N7, V7
				end
			end)
			local kI, D7 = QI
			if kI then
				local N7 = Z[20]
				D7 = N7.indexNeeds()
			else
				D7 = kI
			end
			for N7, N7 in pairs(Z7) do
				v7[#v7 + 1] = N7
			end
			local N7, V7, I7 = {}, {}, {}
			local function j7(K7)
				if not V7[K7] then
					V7[K7] = true
					N7[#N7 + 1] = K7
				end
			end
			if c7 then
				j7(c7)
			end
			kI = z7
			for z7, z7 in ipairs(kI) do
				j7(z7)
			end
			for z7, V7 in ipairs(N7) do
				I7[V7] = z7
			end
			o7 = N7
			local z7, V7 = #N7, fI
			table.sort(v7, function(N7, K7)
				if D7 then
					if D7[N7.Category] == true ~= (D7[K7.Category] == true) then
						return D7[N7.Category] == true
					end
				end
				local D7, X7 = I7[N7.Uid], I7[K7.Uid]
				if D7 ~= nil ~= (X7 ~= nil) then
					return D7 ~= nil
				end
				if D7 then
					return D7 < X7
				end
				X7, D7 = N7.Style.RarityNumber, K7.Style.RarityNumber
				if V7 == YI[1] then
					if X7 ~= D7 then
						return X7 > D7
					end
				end
				if V7 == YI[2] then
					if N7.Weight ~= K7.Weight then
						return N7.Weight > K7.Weight
					end
				end
				if V7 == YI[5] then
					if N7.Value ~= K7.Value then
						return N7.Value < K7.Value
					end
				end
				if N7.Value ~= K7.Value then
					return N7.Value > K7.Value
				end
				return N7.Uid < K7.Uid
			end)
			local D7, N7, V7 = os.clock(), {}, {}
			for K7, X7 in ipairs(v7) do
				j7 = mI
				K7 = j7[X7.Uid]
				if K7 and K7 > D7 and F7[X7.Uid] then
					V7[#V7 + 1] = X7
				else
					kI = mI
					kI[X7.Uid] = nil
					N7[#N7 + 1] = X7
				end
			end
			table.sort(V7, function(v7, D7)
				return F7[v7.Uid] < F7[D7.Uid]
			end)
			for v7, v7 in ipairs(V7) do
				table.insert(N7, math.clamp(F7[v7.Uid], 1, #N7 + 1), v7)
			end
			table.clear(F7)
			for v7, D7 in ipairs(N7) do
				F7[D7.Uid] = v7
				kI = M7[D7.Uid]
				if kI then
					if kI.Frame.LayoutOrder ~= v7 then
						kI.Frame.LayoutOrder = v7
					end
					BI(kI, I7[D7.Uid], D7.Uid == c7, z7)
				end
			end
		end
		local function kI()
			if not l7 then
				return
			end
			local BI = math.max(1, math.floor(l7.AbsoluteSize.X / 4.426229508196721 + 0.5))
			if BI == O7 then
				return
			end
			O7 = BI
			for F7, F7 in pairs(M7) do
				F7.Frame.Size = UDim2.new(1, 0, 0, BI)
			end
		end
		local function BI(F7, v7)
			local z7, c7 = F7.Button, function()
				v7()
				EI(B7)
			end
			z7.Activated:Connect(c7)
		end
		local function F7(v7)
			local z7 = W7:Clone()
			local c7 = z7.Spacer
			local D7 = c7.TextLabel
			local function N7(V7)
				local I7 = L7(c7[V7])
				S7(I7)
				return I7
			end
			local V7 = { Frame = z7 }
			V7.Icon = AI(c7, "Icon")
			V7.Label = D7
			V7.ValueLabel = c7.Value
			V7.DetailLabel = c7.Detail
			V7.Badge = c7.Rank
			V7.BadgeG = hI(c7.Rank)
			V7.Gradient = hI(D7) or F("UIGradient", { Parent = D7 })
			V7.Steal = N7("Unequip")
			V7.Cancel = N7("Cancel")
			V7.Star = N7("Star")
			V7.Up = N7("Up")
			V7.Down = N7("Down")
			local function c7(D7)
				local function N7()
					local I7 = table.find(o7, v7)
					local j7
					if I7 then
						local K7 = o7
						j7 = K7[I7 + D7]
					else
						j7 = I7
					end
					if j7 ~= nil then
						xI(v7, D7)
					elseif Z7[v7] then
						xI(v7, D7)
					end
				end
				return N7
			end
			BI(V7.Up, (c7(-1)))
			BI(V7.Down, (c7(1)))
			BI(V7.Steal, function()
				if V7.Rank == nil then
					local xI = Z[20]
					xI.skip[v7] = nil
					xI = Z[20]
					if not (table.find(xI.pick, v7)) then
						table.insert(Z[20].pick, v7)
					end
					LI()
					gI()
				end
			end)
			BI(V7.Cancel, function()
				local LI = mI
				LI[v7] = os.clock() + 4
				tI(v7)
			end)
			BI(V7.Star, function()
				iI(v7)
				gI()
			end)
			x7(z7, true)
			h7(z7)
			z7.Size = UDim2.new(1, 0, 0, math.max(O7, 1))
			z7.Visible = true
			z7.Parent = l7
			return V7
		end
		local function LI(gI, iI)
			if C7 then
				if not l7 then
					return
				end
			else
				return
			end
			local tI, xI = M7[gI] or F7(gI), iI.Style
			M7[gI] = tI
			if tI.Icon then
				if tI.Icon.Image ~= xI.Icon then
					tI.Icon.Image = xI.Icon
				end
			end
			if tI.Category ~= iI.Category then
				tI.Category = iI.Category
				tI.Gradient.Color, tI.Gradient.Rotation = xI.GradientColor, xI.GradientRotation
			end
			DI(tI.Label, xI.Name)
			DI(tI.ValueLabel, VI(iI.Value))
			DI(tI.DetailLabel, iI.Detail)
		end
		local function gI(iI)
			local tI = (iI >= 1000 and "%.0f" or "%.2f"):format(iI)
			local iI, xI = tI:match("^(%-?%d+)(%.%d+)$")
			local BI, VI = 1, iI or tI
			while BI > 0 do
				VI, BI = VI:gsub("^(%-?%d+)(%d%d%d)", "%1,%2")
			end
			return VI .. (xI or "") .. " Kg"
		end
		local function iI(tI, xI)
			local BI, VI, VI = ("x%.2f"):format(xI), Z[22], tonumber((Z[22]("Rec", "WeightKgForScale", tI, xI)))
			return VI and BI .. NI .. gI(VI) or BI, VI or 0
		end
		local function gI(tI)
			local xI = sI()
			if xI then
				if tI == XI then
					if not KI then
						return
					end
				else
					return
				end
			else
				return
			end
			local sI, BI, NI, VI, F7 = {}, os.clock, pairs, -1
			local o7 = BI()
			for v7, v7 in NI(xI) do
				local xI, NI, z7 = v7.Uid, v7.State, v7.AssetCategory
				if
					type(xI) == "string" and (
						NI == "Slot"
						or NI == "Dropped"
						or NI == "Carried"
						or NI == "GuardCarried"
					)
				then
					if type(z7) == "string" then
						sI[xI] = true
						local c7, D7, N7 = jI(z7), Z7[xI], tonumber(v7.AssetScale) or 1
						if D7 then
						else
							D7 = { Uid = xI }
							Z7[xI] = D7
						end
						if D7.Detail == nil or D7.Scale ~= N7 or D7.Category ~= z7 then
							D7.Scale = N7
							D7.Detail, D7.Weight = iI(z7, N7)
						end
						D7.Category, D7.Style, D7.Value = z7, c7, zI(v7, c7)
						if NI ~= "Carried" then
							if c7.Icon ~= "" then
								if D7.Value > VI then
									BI = D7.Value
									VI, F7 = BI, D7
								else
								end
							else
							end
						else
						end
						LI(xI, D7)
					else
					end
				else
				end
				if os.clock() - o7 > 0.006 then
					xI = Z[23]
					xI()
					o7 = os.clock()
					if tI ~= XI then
						return
					elseif not KI then
						return
					end
				else
				end
			end
			for LI in pairs(Z7) do
				if not sI[LI] then
					Z7[LI] = nil
					if M7[LI] then
						M7[LI].Frame:Destroy()
						M7[LI] = nil
					end
				end
			end
			if P7 then
				if F7 then
					if P7.Image ~= F7.Style.Icon then
						BI = P7
						BI.Image = F7.Style.Icon
					end
				end
			end
			B7()
		end
		local sI = 0
		local function LI(iI)
			if Y7 then
				if os.clock() - sI < 10 then
					R7 = true
					return
				end
			end
			local tI
			tI, Y7 = os.clock(), true
			sI = tI
			tI = sI
			pcall(gI, iI)
			if sI == tI then
				Y7 = false
			end
			if R7 then
				R7 = false
				f7()
			end
		end
		f7 = function()
			if J7 then
				return
			elseif not KI then
				return
			end
			J7 = true
			local sI = XI
			task.delay(C7 and 0.08 or 1, function()
				J7 = false
				if KI then
					if sI == XI then
						task.spawn(pcall, LI, sI)
					end
				end
			end)
		end
		local function sI()
			local gI, iI, tI, xI, BI =
				UDim2.new, b7.X.Scale, math.ceil(w7.AbsoluteSize.X * 1.392), b7.Y.Scale, b7.Y.Offset
			return gI(iI, tI, xI, BI)
		end
		local function gI(iI)
			if C7 then
				return
			elseif not w7 then
				return
			end
			C7 = true
			if l.ChilliFinderPanelClose then
				pcall(l.ChilliFinderPanelClose, true)
			end
			if iI then
				a7:Set(true)
			end
			if aI() then
				iI = Z[23]
				iI()
				if C7 then
					if not w7 then
						return
					end
				else
					return
				end
			end
			FI(true)
			r7.Enabled = true
			if E7 then
				E7:Cancel()
			end
			iI = w7
			iI.Position = sI()
			E7 = vI(w7, HI, { Position = b7 })
			t7()
			kI()
			task.spawn(pcall, LI, XI)
		end
		local function aI(iI, tI, xI)
			if C7 then
				if not w7 then
					return
				end
			else
				return
			end
			C7 = false
			if tI then
				a7:Set(false)
			end
			if E7 then
				E7:Cancel()
			end
			if xI then
				r7.Enabled = false
				return
			end
			local tI = vI(w7, _I, { Position = sI() })
			E7 = tI
			tI.Completed:Connect(function(sI)
				if sI == Enum.PlaybackState.Completed then
					if E7 == tI then
						if not C7 then
							if r7 then
								local sI, tI
								sI, tI, r7.Enabled = w7, b7, false
								sI.Position = tI
							end
						end
					end
				end
			end)
			if iI then
				FI(false)
			end
		end
		function l.ChilliStealPanelClose(sI)
			aI(false, false, sI)
		end
		function l.ChilliStealPanelFrame()
			local sI, iI = w7, T7
			return sI, iI
		end
		local function sI(iI)
			local tI = F(
				"ScreenGui",
				{
					Archivable = false,
					ResetOnSpawn = false,
					IgnoreGuiInset = iI.IgnoreGuiInset,
					ZIndexBehavior = iI.ZIndexBehavior,
					DisplayOrder = iI.DisplayOrder,
				}
			)
			pcall(function()
				tI.ScreenInsets = iI.ScreenInsets
			end)
			return tI
		end
		local function iI()
			if d7 then
				if d7.Parent then
					return true
				end
			end
			local tI = A7(n7.Pets)
			if not tI then
				return false
			end
			local xI = { "Notification", "ReadyNotification", "NightImage", "NightText", "ConsoleButton", "Badge" }
			for HI, _I in ipairs(xI) do
				HI = AI(tI, _I)
				if HI then
					HI:Destroy()
				end
			end
			local xI, HI = L7(tI), AI(tI, "ImageLabel")
			q7, P7 = xI, HI
			if q7.Scale then
				q7.Scale.Scale = 1
			end
			i7(q7, cI.Chilli)
			S7(q7)
			H7(q7)
			tI.AnchorPoint = WI(0.5, 0.5)
			tI.Visible = false
			tI.LayoutOrder = 0
			tI.Activated:Connect(function()
				SI()
				EI(function()
					if if r7 then not r7.Parent else not r7 then
						pcall(e7)
						EI(function()
							if r7 then
								if not C7 then
									pcall(gI, true)
								end
							end
						end)
					elseif C7 then
						aI(true, true)
					else
						gI(true)
					end
				end)
			end)
			x7(tI)
			h7(tI)
			d7 = sI(n7.Hud)
			tI.Parent = d7
			d7.Parent = JI
			return true
		end
		local tI, xI
		local function HI(_I, BI, vI)
			if _I.Position ~= BI then
				_I.Position = BI
			end
			if _I.Size ~= vI then
				_I.Size = vI
				t7()
			end
		end
		local function _I()
			local BI, vI, zI = q7.Button, n7.Eggs, n7.Pets
			if vI.Parent then
				if not zI.Parent then
					return
				end
			else
				return
			end
			local NI = vI.AbsoluteSize.X > 0
			local VI = n7.Hud.Enabled and n7.GameHud.Visible and n7.Column.Visible and vI.Visible and zI.Visible and NI
				or (if tI then not tI else NI) and zI.AbsoluteSize.X > 0
			if VI then
				NI = vI:FindFirstChildOfClass("UIScale")
				local VI = NI and NI.Scale or 1
				VI = if VI <= 0 then 1 else VI
				local NI, jI, F7, Y7 =
					vI.AbsolutePosition + vI.AbsoluteSize / 2,
					zI.AbsolutePosition + zI.AbsoluteSize / 2,
					vI.AbsoluteSize / VI,
					d7.AbsolutePosition
				local vI, zI = lI(NI.X - Y7.X, NI.Y - (jI.Y - NI.Y) - Y7.Y), lI(F7.X, F7.Y)
				if not C7 then
					tI, xI = vI, zI
				end
				HI(BI, vI, zI)
			elseif if C7 then not C7 else tI then
				HI(BI, tI, xI)
			elseif not tI then
				return II(BI, false)
			end
			II(BI, true)
		end
		local function lI()
			local tI = n7.ActivePets.Frame
			local xI = A7(tI)
			if not xI then
				return false
			end
			local HI, BI = AI(xI, "Header"), AI(xI, "ScrollingFrame")
			local vI, zI = AI(xI, "Close"), AI(BI, "Template")
			local NI = AI(zI, "Spacer")
			local VI = NI and (NI:FindFirstChild("Unequip", true))
			if VI and VI.Parent ~= NI then
				local II = VI.Parent
				VI.Parent, VI.AnchorPoint = NI, WI(1, 0.5)
				II:Destroy()
			end
			local II = AI(NI, "TextLabel")
			if HI and BI then
				if vI then
					if VI then
						if not II then
							xI:Destroy()
							return false
						end
					else
						xI:Destroy()
						return false
					end
				else
					xI:Destroy()
					return false
				end
			else
				xI:Destroy()
				return false
			end
			for jI, jI in ipairs(BI:GetChildren()) do
				if jI ~= zI then
					if jI:IsA("GuiObject") then
						if jI.Name ~= "EmptyLast" then
							jI:Destroy()
						end
					end
				end
			end
			local jI = AI(xI, "EquipBest")
			if jI then
				jI:Destroy()
			end
			jI = xI:FindFirstChildOfClass("UIAspectRatioConstraint")
			local F7, Y7 = jI and jI.AspectRatio or 1.25, d("UserInputService").MouseEnabled
			local A7 = not Y7
			local o7, v7 = (if Y7 then A7 else 1.2) or 1, (if Y7 then A7 else 1.15) or 1
			A7 = 0.86 / v7
			local z7 = A7 / F7
			xI.Size = TI(0.3 * o7, 0.62 * o7 * v7)
			jI = jI or F("UIAspectRatioConstraint", { Parent = xI })
			jI.AspectRatio, jI.AspectType = A7, Enum.AspectType.FitWithinMaxSize
			local function c7(D7)
				return UDim2.new(D7.X, UDim.new(D7.Y.Scale * z7, D7.Y.Offset))
			end
			HI.Size, HI.Position, vI.Size = c7(HI.Size), c7(HI.Position), c7(vI.Size)
			local D7 = BI.AnchorPoint.Y
			local function N7(V7, I7)
				BI.Size, BI.Position =
					UDim2.new(BI.Size.X, UDim.new(I7 - V7, 0)),
					UDim2.new(BI.Position.X, UDim.new(V7 + (I7 - V7) * D7, 0))
			end
			jI, o7 = BI.Size.Y.Scale, BI.Position.Y.Scale
			N7((o7 - jI * D7) * z7, 1 - (1 - (o7 + jI * (1 - D7))) * z7)
			jI = BI.Size.Y.Scale
			F7, o7, c7 = BI.Position.Y.Scale - jI * D7, 0.1 * z7, 0.02 * z7
			local z7 = F(
				"Frame",
				{
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					AnchorPoint = WI(0.5, 0),
					Position = TI(0.5, F7 + c7),
					Size = TI(0.9, o7),
					Parent = xI,
				}
			)
			N7(F7 + c7 * 1.5 + o7, F7 + jI)
			local function jI(D7)
				if D7 then
					pcall(D7.Set, D7, D7.Value ~= true)
				end
				EI(_7)
			end
			local function D7(V7, I7)
				local j7 = VI:Clone()
				j7.Size = TI(0.48, 1)
				j7.LayoutOrder = V7
				j7.Parent = z7
				j7.Activated:Connect(I7)
				return L7(j7)
			end
			s7 = {
				Toggle = D7(1, function()
					local V7 = Z[20]
					jI(V7.autoSteal)
				end),
				Guard = D7(2, function()
					local V7 = Z[20]
					jI(V7.agT)
				end),
			}
			D7 = s7.Toggle.Button
			D7.AnchorPoint, D7.Position = WI(0, 0.5), TI(0, 0.5)
			F(
				"UIListLayout",
				{
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0.03, 0),
					Parent = z7,
				}
			)
			c7 = hI(HI)
			if c7 then
				c7.Color = B(0, OI(200, 18, 24), 0.53, OI(255, 88, 90), 1, OI(214, 28, 34))
			end
			T7 = AI(HI, "Title")
			DI(T7, "Steal Panel")
			local B = AI(HI, "PlusEquip")
			y7 = B and L7(B)
			if y7 then
				c7, v7, N7 = B.Size, B.Position, B.AnchorPoint.X
				B.AnchorPoint, B.Position, B.Size =
					WI(1, B.AnchorPoint.Y),
					UDim2.new(
						v7.X.Scale + c7.X.Scale * (1 - N7),
						v7.X.Offset + c7.X.Offset * (1 - N7),
						v7.Y.Scale,
						v7.Y.Offset
					),
					UDim2.new(c7.X.Scale * 0.6, c7.X.Offset * 0.6, c7.Y.Scale, c7.Y.Offset)
				i7(y7, cI.Steal)
				DI(y7.Label, "Sort: " .. (RI[QI and "Index" or fI] or tostring(fI)))
				S7(y7)
				local OI = 0
				local function RI()
					if os.clock() - OI < 0.25 then
						return
					end
					OI = os.clock()
					local OI = { YI[4], "Index", YI[1], YI[2], YI[3], YI[5] }
					local jI = OI[(table.find(OI, QI and "Index" or fI) or 1) % #OI + 1]
					QI = jI == "Index"
					jI = QI and YI[4] or jI
					if QI then
						mI = {}
					end
					if eI then
						pcall(eI.Set, eI, jI)
					end
					if fI ~= jI then
						fI = jI
						I()
					end
					EI(B7)
				end
				pcall(function()
					B.Active = true
					B.Interactable = true
					B.AutoButtonColor = true
				end)
				for OI, OI in ipairs(B:GetDescendants()) do
					if OI:IsA("GuiObject") then
						OI.Active = false
					end
				end
				B.Activated:Connect(RI)
				local function OI(YI)
					local eI = Z[20]
					if eI.press(YI) then
						RI()
					end
				end
				B.InputBegan:Connect(OI)
			end
			for B, B in ipairs(vI:GetDescendants()) do
				if B:IsA("ImageLabel") then
					B:Destroy()
				elseif B:IsA("ImageButton") then
					B:Destroy()
				end
			end
			o7 = L7(vI)
			HI = o7.Label
			if HI then
				if HI:IsA("TextLabel") then
					HI.Visible = true
					HI.RichText = false
					HI.Text = ">"
				end
			end
			S7(o7)
			local function B()
				SI()
				EI(function()
					aI(true, true)
				end)
			end
			vI.Activated:Connect(B)
			F7 = VI:Clone()
			F7.Name = "Cancel"
			F7.Parent = NI
			F("UIAspectRatioConstraint", { AspectRatio = 1, DominantAxis = Enum.DominantAxis.Height, Parent = F7 })
			o7 = AI(NI, "Icon")
			if o7 then
				o7.AnchorPoint, o7.Size, o7.Position = WI(0.5, 0.5), TI(0.2, 1.3), TI(0.1, 0.5)
			end
			II.AnchorPoint, II.Size, II.Position = WI(II.AnchorPoint.X, 0.5), TI(0.38, 0.3), TI(0.415, 0.2)
			II.Text = ""
			local function OI(YI, RI, eI, fI)
				local QI = YI:Clone()
				QI.Name = RI
				QI.Size = eI
				QI.Position = fI
				return QI
			end
			D7 = OI(II, "Value", TI(0.38, 0.23), TI(0.415, 0.48))
			II = hI(D7) or F("UIGradient", { Parent = D7 })
			II.Color, II.Rotation = cI.Steal.Color, cI.Steal.Rotation
			D7.Parent = NI
			B = OI(D7, "Detail", TI(0.4, 0.3), TI(0.415, 0.78))
			v7 = hI(B)
			v7.Color, v7.Rotation = cI.Hud.Color, cI.Hud.Rotation
			B.Parent = NI
			HI, N7 = L7(VI), L7(F7)
			DI(HI.Label, "Steal")
			i7(HI, cI.Steal)
			DI(N7.Label, "X")
			i7(N7, cI.Cancel)
			F7.Visible, VI.Position, VI.Size = false, TI(oI, 0.6), TI(0.2, 0.56)
			HI, Y7 =
				ipairs,
				{ { "Star", 9733, 0.955, true, cI.Queued }, { "Up", 9650, oI - 0.106, false, cI.Hud }, {
					"Down",
					9660,
					oI,
					false,
					cI.Hud,
				} }
			for B, B in HI(Y7) do
				A7 = OI(F7, B[1], TI(0.1, 0.56), TI(B[3], 0.6))
				A7.AnchorPoint, A7.Visible = WI(1, 0.5), B[4]
				A7.Parent = NI
				II = L7(A7)
				DI(II.Label, utf8.char(B[2]))
				i7(II, B[5])
			end
			F7.AnchorPoint, F7.Position, F7.Size = WI(1, 0), TI(0.99, 0.04), TI(0.06, 0.28)
			F7.ZIndex = 8
			for B, B in ipairs(F7:GetDescendants()) do
				if B:IsA("GuiObject") then
					B.ZIndex = B.ZIndex + 8
				end
			end
			II = OI(D7, "Rank", TI(0.1, 0.36), TI(0.012, 0.03))
			II.AnchorPoint, II.TextXAlignment = WI(0, 0), Enum.TextXAlignment.Left
			II.ZIndex = 6
			II.Visible = false
			II.Text = "#1"
			vI = hI(II)
			vI.Color = cI.Pri.Color
			vI.Rotation = 90
			II.Parent = NI
			zI.Visible = false
			zI.Parent = nil
			c7 = nil
			c7, W7, l7, w7 = tI.Position, zI, BI, xI
			b7 = c7
			xI.Position = b7
			x7(xI, true)
			h7(xI)
			r7 = sI(n7.ActivePets)
			r7.Enabled = false
			xI.Parent = r7
			r7.Parent = JI
			Q7(BI:GetPropertyChangedSignal("AbsoluteSize"), kI)
			Q7(xI:GetPropertyChangedSignal("AbsoluteSize"), t7)
			return true
		end
		local function B()
			if not KI then
				return
			end
			KI, J7, R7 = false, false, false
			XI += 1
			if C7 then
				C7 = false
				if not n7.ActivePets.Enabled then
					if n7.GrowingEggs then
						if not n7.GrowingEggs.Enabled then
							FI(false, true)
						end
					else
						FI(false, true)
					end
				end
			end
			if E7 then
				E7:Cancel()
				E7 = nil
			end
			for OI, OI in ipairs(p7) do
				pcall(function()
					OI:Disconnect()
				end)
			end
			table.clear(p7)
			table.clear(M7)
			table.clear(Z7)
			if r7 then
				r7:Destroy()
			end
			if W7 then
				W7:Destroy()
			end
			r7, w7, b7, T7, y7, l7, W7, s7, n7, O7 = nil, nil, nil, nil, nil, nil, nil, nil, nil, 0
		end
		e7 = function()
			if KI then
				return
			end
			local OI = u7()
			if not OI then
				if not UI then
					UI = true
					task.delay(2, function()
						UI = false
						e7()
					end)
				end
				return
			end
			n7, KI = OI, true
			XI += 1
			local TI = XI
			local WI, FI = OI.ActivePets.Frame:FindFirstChildOfClass("UIStroke"), AI(OI.Pets, "UIStrokeClr")
			local sI, JI = WI and WI.Thickness or uI, FI and (FI:IsA("UIStroke")) and FI.Thickness or uI
			m7, g7 = sI, JI
			if iI() then
				if not (lI()) then
					B()
					return
				end
			else
				B()
				return
			end
			if GI then
				GI = false
				task.spawn(gI)
			end
			local lI
			local JI, YI = 0, Z[61]
			Q7(YI.RenderStepped, function(RI)
				JI += RI
				RI = n7.Eggs.AbsolutePosition
				if RI ~= lI then
					lI, JI = RI, 0
					_I()
				elseif JI >= 0.25 then
					lI, JI = RI, 0
					_I()
				end
			end)
			if WI then
				Q7(WI:GetPropertyChangedSignal("Thickness"), t7)
			end
			sI, WI = ipairs, { OI.ActivePets, OI.GrowingEggs }
			for lI, lI in sI(WI) do
				Q7(lI:GetPropertyChangedSignal("Enabled"), function()
					if lI.Enabled then
						if C7 then
							aI(false)
						end
					end
				end)
			end
			WI = Z[34]
			YI = WI.Egg
			for lI, lI in
				ipairs(
					YI and { "FieldRefreshed", "FieldShifted", "FieldGone", "FieldClaimed", "SnapshotRefreshed" } or {}
				)
			do
				FI = YI[lI]
				if type(FI) == "table" then
					lI, OI = pcall(FI.Connect, FI, f7)
					if lI then
						if OI then
							p7[#p7 + 1] = OI
						end
					end
				end
			end
			YI = AI(workspace, "AreaEggSlotsClient")
			if YI then
				Q7(YI.ChildAdded, f7)
				Q7(YI.ChildRemoved, f7)
			end
			task.spawn(function()
				local OI = 0
				while true do
					OI += task.wait(0.5)
					if KI then
						if TI ~= XI then
							break
						end
					else
						break
					end
					local lI, WI = n7, game
					if not (lI.Eggs:IsDescendantOf(WI) and n7.ActivePets:IsDescendantOf(game)) then
						task.defer(function()
							B()
							e7()
						end)
						break
					end
					if OI >= 2 then
						f7()
						OI = 0
					else
						if C7 then
							B7()
						end
					end
				end
			end)
			task.spawn(pcall, LI, TI)
		end
		table.insert(Z[20].cleanup, function()
			B()
			if d7 then
				d7:Destroy()
			end
			H7()
			d7, q7, P7 = nil, nil, nil
		end)
		task.defer(e7)
		k7 = Z[20]
		k7.hud = {
			Sync = function()
				EI(_7)
			end,
			Refresh = f7,
		}
		task.delay(1, function()
			if a7:Get() ~= true then
				return
			end
			if KI then
				if r7 then
					if C7 then
						GI = true
					else
						task.spawn(gI)
					end
				else
					GI = true
				end
			else
				GI = true
			end
		end)
	end)
	w("14_pred#1", function()
		local B, OI =
			{ EggState = "Egg", EggRecords = "Rec", Assets = "Assets", FuseKernel = "Fuse", Mutations = "Mut" }, {}
		local TI, lI, WI = Color3.fromRGB(255, 255, 255), {}
		local EI, FI, sI, aI, JI =
			Z[20], Z[20], setmetatable, {
				__index = function(YI, RI)
					if RI == "Save" then
						YI = Z[34]
						local eI = YI.Save
						return eI and setmetatable({
							Get = function(...)
								return eI.Peek(...)
							end,
						}, { __index = eI })
					end
					local eI, fI = B[RI]
					if eI then
						YI = Z[34]
						fI = YI[B[RI]]
					else
						fI = eI
					end
					return fI
				end,
			}
		JI, EI.PS = sI({}, aI), OI
		FI.GM = JI
		OI.Seq = function(...)
			local B, EI = { ... }, {}
			for FI = 1, #B, 4 do
				EI[#EI + 1] = ColorSequenceKeypoint.new(B[FI], Color3.fromRGB(B[FI + 1], B[FI + 2], B[FI + 3]))
			end
			return ColorSequence.new(EI)
		end
		OI.NameFont, OI.RarityFont =
			Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold),
			Font.new("rbxassetid://12187365977", Enum.FontWeight.Bold)
		OI.SecretGradient = OI.Seq(
			0,
			255,
			255,
			255,
			0.2,
			206,
			212,
			224,
			0.42,
			74,
			80,
			94,
			0.58,
			42,
			46,
			56,
			0.78,
			158,
			166,
			182,
			1,
			250,
			252,
			255
		)
		OI.SecretRotation = 90
		OI.Paint = function(B, EI)
			return ('<font color="%s">%s</font>'):format(B, EI)
		end
		OI.Bold = function(B)
			return "<b>" .. tostring(B) .. "</b>"
		end
		OI.Escape = function(B)
			return (tostring(B):gsub("[<>&]", { ["<"] = "&lt;", [">"] = "&gt;", ["&"] = "&amp;" }))
		end
		local B = OI.Paint("#7A8CC0", "  " .. utf8.char(8226) .. "  ")
		OI.Separator = function()
			return B
		end
		OI.FormatRate = function(B)
			B = tonumber(B) or 0
			return B >= 1000000000000 and ("%.2fT/s"):format(B / 1000000000000)
				or B >= 1000000000 and ("%.2fB/s"):format(B / 1000000000)
				or B >= 1000000 and ("%.2fM/s"):format(B / 1000000)
				or B >= 1000 and ("%.1fK/s"):format(B / 1000)
				or ("%d/s"):format(math.floor(B))
		end
		OI.FormatWeight = function(B)
			B = tonumber(B) or 0
			local EI = (B >= 1000 and "%.0f" or "%.2f"):format(B)
			local B, FI, sI = EI:match("^(%-?%d+)(%.%d+)$")
			B = B or EI
			repeat
				B, sI = B:gsub("^(%-?%d+)(%d%d%d)", "%1,%2")
			until sI == 0
			return B .. (FI or "") .. " Kg"
		end
		OI.FormatClock = function(B)
			B = math.max(0, math.floor(tonumber(B) or 0))
			return ("%02dh %02dm %02ds"):format(B // 3600, B % 3600 // 60, B % 60)
		end
		OI.ScaleFactor = function(B)
			return B > 5 and (B / 5) ^ 1.2 * 19.637875755794113 or B ^ 1.85
		end
		OI.MutationMultiplier = function(B)
			local EI, FI = pcall(function()
				local sI = Z[34]
				return sI.Mut.EarningsFor(type(B) == "table" and B or {})
			end)
			return EI and type(FI) == "number" and FI or 1
		end
		local B, EI =
			{
				Golden = "#FFD34D",
				Silver = "#E6EEF7",
				Sakura = "#FF9ED8",
				GreatBloom = "#7CFFC4",
				Boss = "#FF7A7A",
				Monstrous = "#C08BFF",
			},
			{ "#FF6B6B", "#FFB36B", "#FFF06B", "#6BFF8A", "#6BC8FF", "#B96BFF" }
		OI.MutationText = function(FI)
			local sI = {}
			for aI, JI in ipairs(type(FI) == "table" and FI or {}) do
				local FI = string.upper(Q[JI] or JI)
				if JI == "Rainbow" or JI == "Prismatic" then
					local YI = {}
					for RI = 1, #FI, 1 do
						YI[RI] = OI.Paint(EI[(RI - 1) % 6 + 1], FI:sub(RI, RI))
					end
					sI[aI] = OI.Bold(table.concat(YI))
				else
					sI[aI] = OI.Bold(OI.Paint(B[JI] or "#8FE3FF", OI.Escape(FI)))
				end
			end
			return table.concat(sI, " ")
		end
		local function B(EI)
			if type(EI) == "table" then
				if typeof(EI.RarityGradient) == "Instance" then
					return EI.RarityGradient
				end
			end
			if WI == nil then
				local FI = P:FindFirstChild("Assets")
				local sI = FI and (FI:FindFirstChild("UI"))
				WI = sI and sI:FindFirstChild("RarityGradients") or false
			end
			if WI then
				if type(EI) ~= "table" then
					return nil
				end
			else
				return nil
			end
			local FI = WI
			local WI = FI:FindFirstChild(tostring(EI._id or EI.DisplayName or ""))
			return WI and WI:FindFirstChild("RarityGradient") or nil
		end
		local function WI(EI)
			return EI:lower():gsub("[^%a%d]", "")
		end
		local function EI(FI, sI)
			sI = WI(sI)
			for aI, JI in pairs(FI) do
				if type(JI) == "table" then
					local FI, YI =
						ipairs,
						{ aI, JI._id or "", JI.DisplayName or "", type(JI.Egg) == "table" and JI.Egg.ModelName or "" }
					for aI, aI in FI(YI) do
						aI = tostring(aI)
						if aI ~= "" then
							if WI(aI) == sI then
								return JI
							end
						end
					end
				end
			end
		end
		OI.AssetInfo = function(WI)
			local FI = tostring(WI)
			if lI[FI] then
				return lI[FI]
			end
			WI = Z[34]
			local sI, aI = WI.Assets
			if sI then
				WI = Z[34]
				aI = WI.Assets.Directory
			else
				aI = sI
			end
			aI = type(aI) == "table" and aI or {}
			sI = aI[FI] or EI(aI, FI)
			sI = type(sI) == "table" and sI or {}
			WI = type(sI.Rarity) == "table" and sI.Rarity or nil
			local EI, aI =
				WI and tostring(WI.DisplayName or WI._id or "Common") or "Common",
				WI and typeof(WI.Color) == "Color3" and WI.Color or TI
			local TI = {
				Name = tostring(sI.DisplayName or FI),
				Category = FI,
				Rarity = EI,
				Up = EI:upper(),
				RarityNumber = WI and tonumber(WI.RarityNumber or WI.Rank) or 0,
				Color = aI,
				Hex = "#" .. aI:ToHex():upper(),
				Gradient = B(WI),
				EarningRate = tonumber(sI.EarningRate) or 0,
				Icon = type(sI.Icon) == "string" and sI.Icon ~= "" and sI.Icon or nil,
			}
			lI[FI] = TI
			return TI
		end
		OI.Income = function(B, TI, lI)
			if type(TI) ~= "number" then
				return 0
			elseif TI <= 0 then
				return 0
			end
			return math.max(math.round(B.EarningRate * OI.ScaleFactor(TI) * OI.MutationMultiplier(lI)), 1)
		end
		OI.IsShown = function(B)
			if typeof(B) ~= "Instance" then
				return false
			elseif not (B:IsDescendantOf(n)) then
				return false
			end
			while B do
				if B:IsA("GuiObject") then
					if not B.Visible then
						return false
					end
				end
				if B:IsA("LayerCollector") then
					return B.Enabled
				end
				B = B.Parent
			end
			return false
		end
	end)
	w("15_hop#1", function()
		local B = "ChilliLibrary/SAE_AutoHop.json"
		local OI = M.dec(M.rd(B)) or {}
		OI.Visited = type(OI.Visited) == "table" and OI.Visited or {}
		local TI = OI.Visited
		local function lI()
			M.wr(B, M.enc(OI) or "{}")
		end
		local B = J() - 1800
		for WI, EI in next, TI, nil do
			if EI < B then
				TI[WI] = nil
			end
		end
		TI[n.JobId] = J()
		lI()
		local WI, EI, FI, sI, aI, JI = {}, 0, false
		W(b.TeleportInitFailed, function(YI)
			local RI = Z[1]
			if YI == RI then
				local YI = Z[20]
				if YI.hopping then
					FI = false
					if aI then
						WI[aI] = true
					end
					task.spawn(JI, Z[20].hopping)
				end
			end
		end)
		B = Z[1]
		W(B.OnTeleport, function(YI)
			if YI == Enum.TeleportState.Started then
				FI = true
			elseif YI == Enum.TeleportState.InProgress then
				FI = true
			end
		end)
		local function YI(RI)
			if sI then
				if os.clock() - EI < 60 then
					local eI = sI
					return eI
				end
			end
			local eI, fI, QI = {}, RI == "Random" and 3 or 6, ""
			for uI = 1, fI, 1 do
				local AI, hI = pcall(
					n.HttpGet,
					n,
					("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=%s&excludeFullGames=true&limit=100%s"):format(
						n.PlaceId,
						RI == "Most Players" and "Desc" or "Asc",
						QI
					)
				)
				uI = M.dec(AI and hI)
				if type(uI) ~= "table" then
					break
				end
				for AI, AI in ipairs(uI.data or {}) do
					if AI.id ~= n.JobId then
						eI[#eI + 1] = AI
					end
				end
				if #eI > 0 then
					if RI ~= "Random" then
						break
					elseif not uI.nextPageCursor then
						break
					end
				elseif not uI.nextPageCursor then
					break
				end
				QI = "&cursor=" .. uI.nextPageCursor
			end
			fI = nil
			fI, sI = os.clock(), eI
			EI = fI
			return eI
		end
		JI = function(EI)
			for RI = 1, 2, 1 do
				local eI, fI = ipairs, { 2, 1 }
				for QI, uI in eI(fI) do
					local eI, fI, AI = {}, ipairs, C[20](YI(EI))
					for YI, YI in fI(C:QH(AI)) do
						if (YI.maxPlayers or 0) - (YI.playing or 0) >= uI then
							QI = WI
							if not QI[YI.id] then
								if RI == 1 then
									if not TI[YI.id] then
										eI[#eI + 1] = YI
									end
								else
									eI[#eI + 1] = YI
								end
							end
						end
					end
					if #eI > 0 then
						table.sort(eI, function(YI, RI)
							if EI == "Most Players" then
								return YI.playing > RI.playing
							end
							return YI.playing < RI.playing
						end)
						local YI = eI[math.random(1, EI == "Random" and #eI or math.min(#eI, 100))]
						AI, fI, QI = YI.id, J(), YI.id
						TI[AI] = fI
						aI, FI = QI, false
						lI()
						uI = Z[20]
						uI.beforeTeleport()
						c("Server Hop", ("Joining a server with %d players"):format(YI.playing or 0))
						pcall(b.TeleportToPlaceInstance, b, n.PlaceId, YI.id, Z[1])
						task.delay(6, function()
							local TI = Z[20]
							if TI.hopping then
								local TI = aI
								if TI == YI.id then
									if not FI then
										local TI = WI
										TI[YI.id] = true
										JI(EI)
									end
								end
							end
						end)
						return true
					end
				end
				WI, sI = {}, nil
			end
			local TI = Z[20]
			TI.hopping = nil
			return false
		end
		local TI = Z[20]
		TI.hop = function(TI)
			local WI = Z[20]
			if WI.hopping then
				return true
			end
			local EI, FI = Z[20]
			if TI then
				FI = TI
			else
				WI = Z[25]
				FI = WI.hopMode
			end
			EI.hopping = FI or "Least Players"
			WI = Z[20]
			return JI(WI.hopping)
		end
		local TI, WI, EI, FI, sI, aI, JI, YI = dI["Egg Finder"], "Idle", "idle", {}
		local function RI(eI, fI)
			WI, EI = eI, fI
		end
		YI = j(TI, "Auto Hop", "autoHop", false, function(eI)
			if not eI then
				RI("Idle", "idle")
				return
			end
			if z.busy then
				return
			elseif not z.ready then
				return
			end
			z:Dialog({
				Title = "Auto Hop",
				Warn = "WARNING",
				Body = "Auto Hop keeps joining new servers to find eggs that match its filters. Turn it off to stop.",
				Tip = '"Steal Then Hop" and "After A Rare Spawns" stop at night.',
				Cancel = "Cancel",
				Accept = "Turn On",
				no = function()
					YI:Set(false)
				end,
			})
		end, "Joins new servers to find eggs that match the filters below")
		B = Z[20]
		local eI = B.PS
		local fI = eI.Paint
		local QI = eI.Bold
		local uI = eI.Escape
		local AI, hI, mI, kI, LI, gI, iI, tI, xI, SI, HI, _I, oI, BI, vI, zI, cI, DI, NI, VI, II, jI =
			Color3.new(1, 1, 1),
			3.8,
			1.2,
			"No egg matches here",
			"After stealing a match",
			{
				idle = { "IDLE", "#9AA3B5" },
				scan = { "SCANNING", "#7FD8FF" },
				found = { "FILTER EGG HERE", "#4DFF7A" },
				night = { "NIGHT", "#9C8CFF" },
				rare = { "WAITING", "#FF7AE0" },
				steal = { "AUTO STEAL BUSY", "#FFC24D" },
				joining = { "JOINING SERVER", "#FF9A3D" },
				race = { "RACING EVENT", "#FFD452" },
				star = { "SHOOTING STAR", "#FFEE8C" },
			},
			{ Slot = { "ON NEST", "#4DFF7A" }, Dropped = { "DROPPED", "#FFC24D" }, Carried = {
				"BEING CARRIED",
				"#FF8A5C",
			} },
			{},
			{},
			0,
			0,
			1,
			false
		local function KI(XI)
			local UI = tostring(XI.Spec.Text or "")
			local GI = cI .. "|" .. UI:gsub("%d", "0")
			if XI.WK == GI then
				return XI.WU
			end
			local C7 = XI.Get()
			if C7.Text ~= UI then
				return
			end
			local O7, p7 = C7.Size, C7.TextWrapped
			C7.TextWrapped, C7.Size = false, UDim2.fromOffset(100000, math.max(1, O7.Y.Offset))
			UI = C7.TextBounds.X
			C7.Size = O7
			C7.TextWrapped = p7
			if UI <= 0 then
				return
			end
			XI.WK, XI.WU = GI, UI / cI
			return XI.WU
		end
		local function XI()
			if sI then
				local UI = Z[25]
				if UI.autoHop ~= true then
					jI, HI, SI = nil, 0, 2
					return
				end
			else
				jI, HI, SI = nil, 0, 2
				return
			end
			local UI = sI.Record
			local GI, C7, O7 =
				eI.AssetInfo(UI.AssetCategory),
				tonumber(UI.AssetScale) or 1,
				type(UI.Mutations) == "table" and UI.Mutations or {}
			O7 = if #O7 == 0
				then if type(UI.BaseMutation) == "string"
					then if UI.BaseMutation ~= "" then { UI.BaseMutation } else O7
					else O7
				else O7
			jI, HI, SI =
				{
					i = GI,
					m = O7,
					a = sI.Area,
					s = iI[sI.State] or iI.Slot,
					v = GI.EarningRate * eI.ScaleFactor(C7) * eI.MutationMultiplier(O7),
				},
				aI,
				2
		end
		local function iI()
			local UI = Z[25]
			local GI = UI.autoHop == true
			UI = GI and EI or "idle"
			local EI, C7, O7 = gI[UI], GI and WI or "Turn on Auto Hop to start hunting", jI ~= nil
			local WI = Color3.fromHex(EI[2])
			if GI then
				if UI ~= "night" then
					local gI = Z[25]
					if gI.hopWhen ~= kI then
						local gI = math.max(0, (OI.Window or 0) - J())
						C7 = if gI > 0 then C7 .. ("  |  hop run %s left"):format(eI.FormatClock(gI)) else C7
					else
					end
				else
				end
			else
			end
			tI.a({ Background = EI[2] })
			tI.t({ Text = EI[1], Color = WI })
			UI, GI = tI.v, {}
			GI.Text = fI("#9AA3B5", "Players ") .. QI(fI("#FFFFFF", #q:GetPlayers() .. "/" .. q.MaxPlayers))
			UI(GI)
			UI, GI = tI.d, {}
			GI.Text = fI("#E6ECF5", uI(C7))
			UI(GI)
			tI.b({ FillColor = WI })
			if O7 ~= oI then
				oI, SI = O7, 2
				GI = vI
				for gI, gI in ipairs(GI) do
					gI({ Visible = O7 })
				end
			end
			if not O7 then
				return
			end
			WI, UI = jI.i, jI.s
			local gI, C7, p7, M7 = WI.Icon, Color3.fromHex(UI[2]), WI.Rarity:upper(), WI.Gradient
			EI = p7 == "SECRET"
			gI = gI and (if tonumber(gI) then "rbxassetid://" .. gI else gI)
			O7 = EI and eI.SecretGradient or M7
			tI.i({ Visible = gI ~= nil, Image = gI or "", StrokeColor = WI.Color })
			tI.n({
				Text = uI(WI.Name),
				Color = O7 ~= nil and AI or WI.Color,
				Gradient = O7,
				GradientRotation = EI and eI.SecretRotation
					or typeof(M7) == "Instance" and M7:IsA("UIGradient") and M7.Rotation
					or 0,
			})
			tI.h({ StrokeColor = C7 })
			tI.x({ Text = UI[1], Color = C7 })
			M7, O7, GI = {}, QI(fI("#4DFF7A", "$" .. eI.FormatRate(jI.v))), QI(fI(EI and "#D0D6E2" or WI.Hex, uI(p7)))
			C:EH(M7, 0, O7, GI, fI("#CDE7FF", uI(jI.a)))
			O7 = eI.MutationText(jI.m)
			if O7 ~= "" then
				M7[#M7 + 1] = O7
			end
			if HI > 1 then
				M7[#M7 + 1] = fI("#9FB8FF", HI .. " matches")
			end
			GI, EI = tI.f, {}
			EI.Text = table.concat(M7, eI.Separator())
			GI(EI)
		end
		local function WI()
			II = false
			local EI, fI, QI = math.max(1, zI - 0.7 - 0.5), KI(xI.v), 2.6
			if fI then
				tI.su = fI + 0.1
			else
				II = true
			end
			fI = math.min(tI.su or 4, EI * 0.45)
			local uI, gI = tI.t, {}
			gI.Width = math.max(1, EI - fI - 0.3)
			uI(gI)
			tI.v({ X = 0.7 + EI - fI, Width = math.max(0.5, fI) })
			tI.d({ Width = EI })
			if oI then
				gI, uI = KI(xI.x), math.max(1, zI - hI - 0.5)
				if gI then
					tI.cu = gI + 0.9
				else
					II = true
				end
				gI = math.min(tI.cu or 4, uI * 0.5)
				tI.l({ Width = EI })
				local EI, fI = tI.n, {}
				fI.Width = math.max(1, uI - gI - 0.3)
				EI(fI)
				EI, fI = tI.h, {}
				fI.X, fI.Width = hI + uI - gI, gI
				EI(fI)
				tI.x({ Width = gI })
				tI.f({ Width = uI })
				QI = 5.9
			else
			end
			tI.c({ Width = zI, Height = QI })
			tI.a({ Height = QI })
			if QI ~= VI then
				VI = QI
				BI:SetContentLines(QI)
			end
		end
		TI:Surface({
			Name = "Finder Status",
			ShowTitle = false,
			Layout = "free",
			Style = {
				TextScale = 1,
				LineHeight = 1.1,
				MinLines = 2,
				MaxLines = 7,
				BackgroundTransparency = 0.5,
				TextColor = AI,
				TextStrokeTransparency = 0.7,
			},
			Build = function(EI)
				BI = EI
				local function fI(QI, uI, AI)
					AI.Parent = AI.Parent or xI.c
					AI.Wrap = false
					local gI = EI[uI](EI, AI)
					xI[QI] = gI
					tI[QI] = function(QI)
						local uI
						for HI, oI in next, QI, nil do
							if AI[HI] ~= oI then
								uI = uI or {}
								uI[HI] = oI
							else
							end
						end
						if uI then
							gI.Set(uI)
						end
					end
				end
				fI("c", "Frame", { Height = 2.6, Corner = 0.35 })
				fI("a", "Frame", { Width = 0.22, Height = 2.6, Corner = 0.11, Background = "#9AA3B5" })
				fI(
					"t",
					"Text",
					{ X = 0.7, Y = 0.3, Height = mI, Scale = 1.2, Font = eI.RarityFont, TextStrokeTransparency = 1 }
				)
				fI("v", "Text", { Y = 0.3, Height = mI, Align = "Right" })
				fI("d", "Text", { X = 0.7, Y = 0.3 + mI, Height = 1 })
				fI(
					"b",
					"Bar",
					{ X = 0.7, Y = 2.6, Width = 1, Height = 0.3, Corner = 0.15, Background = "#2A2F3A", Visible = false }
				)
				fI(
					"l",
					"Frame",
					{ X = 0.7, Y = 2.6, Height = 0.06, Background = "#FFFFFF", BackgroundTransparency = 0.85, Visible = false }
				)
				fI(
					"i",
					"Image",
					{
						X = 0.7,
						Y = 2.9,
						Width = 2.6,
						Height = 2.6,
						Corner = 0.35,
						BackgroundTransparency = 0.45,
						StrokeThickness = 0.0909,
						Visible = false,
					}
				)
				fI(
					"n",
					"Text",
					{
						X = hI,
						Y = 2.9,
						Height = mI,
						Scale = 1.2,
						Font = eI.NameFont,
						TextStrokeTransparency = 1,
						StrokeTransparency = 0.2,
						Visible = false,
					}
				)
				fI(
					"h",
					"Frame",
					{
						Y = 2.9 + (mI - 0.95) / 2,
						Height = 0.95,
						Corner = 0.3,
						BackgroundTransparency = 0.35,
						StrokeThickness = 0.0909,
						Visible = false,
					}
				)
				fI(
					"x",
					"Text",
					{ Parent = xI.h, Height = 0.95, Scale = 0.78, Align = "Center", Font = eI.RarityFont, TextStrokeTransparency = 1 }
				)
				fI("f", "Text", { X = hI, Y = 2.9 + mI, Height = 1, Visible = false })
				vI = { tI.l, tI.n, tI.h, tI.f, tI.i }
				EI:OnResize(function(fI, QI, uI)
					if QI == DI then
						if uI == NI then
							return
						end
					end
					fI = nil
					fI, DI, NI = QI / math.max(uI, 1), QI, uI
					zI, cI, SI = fI, uI, 2
					uI, fI = tI.n, {}
					fI.StrokeThickness = 0.9 / math.max(EI:TextSize(), 1)
					uI(fI)
				end)
			end,
		})
		W(y, function(EI)
			if BI then
				if not (eI.IsShown(BI:Root())) then
					return
				end
			else
				return
			end
			_I += EI
			if _I >= 1 then
				_I = 0
				pcall(XI)
			end
			pcall(iI)
			if SI > 0 or II then
				SI = math.max(SI - 1, 0)
				pcall(WI)
			end
		end)
		local WI, EI =
			{ ["Until An Egg Matches"] = kI, ["Steal Then Hop"] = LI, ["After A Rare Spawns"] = "A rare egg spawned" },
			Z[25]
		EI.hopWhen = LI
		TI:Dropdown(
			"Hop Mode",
			{ "Until An Egg Matches", "Steal Then Hop", "After A Rare Spawns" },
			"Steal Then Hop",
			function(eI)
				local fI, QI, uI = Z[25], WI[eI]
				if QI then
					uI = QI
				else
					eI = Z[25]
					uI = eI.hopWhen
				end
				fI.hopWhen = uI
			end,
			false,
			"When to move on to the next server",
			YI
		)
		B, EI = {}, Z[20]
		C:EH(B, 0, table.unpack(EI.RANY, 2))
		K(
			TI,
			"Rarity To Wait For",
			"hopRare",
			B,
			"Cosmic",
			nil,
			false,
			"For After A Rare Spawns: this rarity or higher",
			YI
		)
		local WI, eI =
			j(
				TI,
				"Sync With Auto Steal Filters",
				"hopSync",
				true,
				nil,
				"Changing a filter here also changes it in Auto Steal, and back",
				YI
			),
			{}
		local function fI(QI, uI)
			local AI = z.ByPath["Farm > Auto Steal > " .. uI]
			if not AI then
				return
			end
			local uI
			table.insert(QI.ls, function(hI)
				local mI = Z[25]
				if mI.hopSync then
					if not uI then
						if not z.busy then
							uI = true
							AI:Set(hI)
							uI = false
						end
					end
				end
			end)
			table.insert(AI.ls, function(hI)
				local mI = Z[25]
				if mI.hopSync then
					if not uI then
						uI = true
						QI:Set(hI)
						uI = false
					end
				end
			end)
			eI[#eI + 1] = { QI, AI }
		end
		B = Z[20]
		fI(
			TI:Dropdown("Min Rarity", B.RANY, "Any", function(QI)
				local uI = Z[20]
				FI.rar = uI.minRar(QI)
			end, false, "Find eggs of the chosen rarity and every rarity above it", YI),
			"Min Rarity"
		)
		B = Z[20]
		fI(
			TI:Dropdown("Target Areas", B.AREAS, Z[20].AREAS, function(B)
				JI = nil
				local QI = Z[20]
				if not (QI.allAreas(B)) then
					JI = {}
					for QI, uI in ipairs(B) do
						QI = JI
						QI[uI:gsub("%s", "")] = true
					end
				end
			end, true, nil, YI),
			"Target Areas"
		)
		EI = Z[20]
		local B, QI = EI.eggList, function(uI)
			local AI = Z[20]
			FI.sp = AI.names(uI)
		end
		fI(
			TI:Dropdown("Target Specific Eggs", B, {}, QI, true, "Only look for these eggs (empty = all)", YI),
			"Target Specific Eggs"
		)
		fI(
			TI:Slider("Min Value To Find", 0, 0, 0, function(B)
				FI.minV = B > 0 and B or nil
			end, "log", nil, "Skip eggs worth less than this. Drag or type 250k, 50m, 1.5b", YI),
			"Min Steal Value"
		)
		table.insert(WI.ls, function(B)
			if B and not z.busy then
				for B, B in ipairs(eI) do
					B[1]:Set(B[2].Value)
				end
			end
		end)
		X(
			TI,
			"First Hop Delay",
			"hopDelay",
			3,
			10,
			5,
			"s",
			0.5,
			nil,
			"Wait after the script loads before the first hop",
			YI
		)
		local function B()
			local TI = Z[25]
			local WI, YI = TI.hopSync
			if WI then
				TI = Z[20]
				YI = TI.stealFilter
			else
				YI = WI
			end
			return YI or FI
		end
		EI = Z[25]
		if EI.autoHop then
			task.delay(1, z.Select, z, "Auto Hop")
		end
		local TI, WI = os.clock()
		local function EI()
			local FI = Z[22]
			OI.Window = FI("Cycle", "NextNightTime", J()) or J() + 300
		end
		fI = Z[20]
		local FI, YI = fI.onSteal, Z[20]
		YI.onSteal = function(YI)
			local eI = Z[25]
			if eI.hopWhen == LI then
				if type(YI) == "table" then
					local eI, fI = { cat = YI.AssetCategory, r = m(YI.AssetCategory), v = 1 / 0, m = {} }, Z[70]
					if fI(B(), eI) then
						EI()
						lI()
					end
				end
			end
			if FI then
				FI(YI)
			end
		end
		local m = G({ name = "Hopper", gap = 0.5 })
		m.on = function()
			local lI = Z[25]
			return lI.autoHop
		end
		m.fn = function()
			local m = o()
			if m <= 0 then
				return RI("Night, waiting for the field to reset", "night")
			end
			local lI = Z[25]
			if os.clock() - TI < lI.hopDelay then
				return RI("Looking around this server", "scan")
			end
			lI = Z[21]
			if lI() then
				return RI("Busy stealing", "steal")
			elseif Z[4] then
				if Z[4].name == "Steal" then
					return RI("Busy stealing", "steal")
				end
			end
			lI = Z[20]
			if lI.lock() then
				return RI("Busy with an event, hop waits", "race")
			end
			lI = Z[20]
			if lI.starWants then
				local TI = Z[20]
				if TI.starWants() then
					return RI("Catching a Shooting Star, hop waits", "star")
				end
			end
			local TI, FI, FI, YI = B(), Z[25], table.find(e, Z[25].hopRare) or 7, Z[25]
			local B, eI = YI.hopSync
			if B then
				YI = Z[25]
				eI = YI.zones
			else
				eI = B
			end
			YI = nil
			if eI then
				YI = eI
			else
				B = Z[25]
				lI = B.hopSync
				YI = if lI then not lI else JI
			end
			eI, lI = pairs, Z[18]
			local JI, fI, QI, uI, AI = C[20](lI()), false, 0, 0
			for hI, mI in eI(C:QH(JI)) do
				if type(mI) == "table" then
					if mI.State ~= "Claimed" then
						if mI.Uid then
							if mI.Uid:find("^FirstAreaEgg") then
							else
								lI = g(mI)
								fI = if lI.r >= FI then true else fI
								B = Z[70]
								if B(TI, lI) and (if YI then YI[tostring(mI.AreaId):gsub("%s", "")] else not YI) then
									if mI.State == "Carried" then
										hI = QI + 1
										QI = hI
									else
										local eI = uI + 1
										uI = eI
									end
									AI = if if AI then lI.v > AI.v else not AI
										then { v = lI.v, Record = mI, Area = tostring(mI.AreaId), State = mI.State }
										else AI
								else
								end
							end
						else
						end
					else
					end
				else
				end
			end
			TI = nil
			TI, sI = uI + QI, AI
			aI = TI
			if fI then
				FI = Z[25]
				if FI.hopWhen == "A rare egg spawned" then
					EI()
				end
			end
			FI, TI = uI > 0
			if FI then
				YI = Z[25]
				JI = YI.steal
				if JI then
					TI = JI
				else
					lI = Z[25]
					TI = lI.hopWhen == kI
				end
			else
				TI = FI
			end
			if TI then
				return RI(uI .. " matching egg(s) here", "found")
			end
			if QI > 0 then
				if os.clock() - (WI or os.clock()) < 20 then
					WI = WI or os.clock()
					return RI("Someone is carrying a match, waiting", "found")
				end
			end
			WI = nil
			if m < 12 then
				return RI("Night is close, staying", "night")
			end
			B = Z[25]
			if B.hopWhen ~= kI then
				if J() > (OI.Window or 0) then
					return RI("Waiting for a reason to hop", "rare")
				end
			end
			RI("Hopping", "joining")
			B = Z[20]
			if not (B.hop("Least Players")) then
				task.wait(1.5)
			end
		end
	end)
	Z[20].reserved = {}
	local function m(B)
		local OI = {}
		for TI, TI in ipairs(type(B.EquippedAssets) == "table" and B.EquippedAssets or {}) do
			OI[TI] = true
		end
		return OI
	end
	local function B()
		local OI = Z[1]
		local TI = OI.Character
		OI = TI and (TI:FindFirstChildOfClass("Tool"))
		return OI and (OI:GetAttribute("UID"))
	end
	local function OI(TI)
		local lI, WI = workspace:FindFirstChild("PlacedEggRenders"), Z[1]
		local EI = WI.UserId .. "_" .. TI
		TI, WI = lI and (lI:FindFirstChild(EI))
		if TI then
			WI = TI
		else
			lI = Z[20]
			local TI = lI.hidden
			if TI then
				local lI = Z[20]
				WI = lI.hidden:FindFirstChild(EI)
			else
				WI = TI
			end
		end
		return WI
	end
	Z[20].eggPos = function(TI)
		local lI, WI = OI(TI), Z[66]
		local EI, FI = WI(), S()[TI]
		TI = type(FI) == "table" and type(FI.Placement) == "table" and FI.Placement.LocalCFrame
		return lI and lI:GetPivot().Position
			or EI and EI.CenterPoint and typeof(TI) == "CFrame" and (EI.CenterPoint.CFrame * TI).Position
			or nil
	end
	local function TI(lI)
		local WI = Z[75]
		if not (WI("RF/EggWorld/AskHatch", lI)) then
			return false
		end
		task.wait(0.35)
		WI = Z[9]
		WI("RF/EggWorld/AskFinishHatch", lI)
		return true
	end
	local function lI(WI, EI)
		local FI = ({ Biggest = "s", ["Best rarity"] = "r" })[EI] or "v"
		local sI = ({ Smallest = "s", ["Lowest value"] = "v" })[EI]
		table.sort(WI, function(EI, aI)
			if sI then
				return EI[sI] < aI[sI]
			end
			if EI[FI] ~= aI[FI] then
				return EI[FI] > aI[FI]
			end
			return EI.v > aI.v
		end)
		return WI
	end
	w("20_farm#1", function()
		local WI = G({ name = "Place", mover = true, gap = 8, pri = 4, soft = true, bad = {} })
		local EI = dI["Auto Place Egg"]
		local FI = N("pen", EI:Text("Pen Status", "Pen status unknown"))
		local sI = j(EI, "Auto Place Egg", "place", false, function(aI)
			if not aI then
				CI(WI)
			end
		end)
		j(EI, "Place And Hatch Missing Index Eggs", "placeIdx")
		local aI, JI, YI, RI =
			{
				Always = "Always",
				["Steal Idle"] = "Steal is idle",
				["After Steal"] = "Right after a steal",
				["Night Only"] = "Only at night",
			},
			{
				["Biggest Size"] = "Biggest",
				["Highest Value"] = "Best value",
				["Smallest Size"] = "Smallest",
				["Lowest Value"] = "Lowest value",
				["Backpack Order"] = "Backpack",
			},
			Z[25],
			Z[25]
		YI.placeWhen = "Always"
		RI.placeFirst = "Best value"
		EI:Dropdown("Place Egg Rule", { "Always", "Steal Idle", "After Steal", "Night Only" }, "Always", function(eI)
			local fI = Z[25]
			fI.placeWhen = aI[eI] or "Always"
		end, false, nil, sI)
		EI:Dropdown(
			"Place Egg Order",
			{ "Biggest Size", "Highest Value", "Smallest Size", "Lowest Value", "Backpack Order" },
			"Highest Value",
			function(aI)
				local eI = Z[25]
				eI.placeFirst = JI[aI] or "Best value"
			end,
			false,
			nil,
			sI
		)
		local aI, JI, eI = {}, {}, Z[20]
		RI = #eI.RANY
		for fI = 2, RI, 1 do
			eI = nil
			eI, JI[#JI + 1] = Z[20], Z[20].RANY[fI]
		end
		local function eI(fI)
			local QI, uI = ipairs
			for AI, hI in QI(fI) do
				uI = uI or {}
				AI = Z[20]
				uI[AI.RIDX[hI] or 0] = true
			end
			aI.rar = uI
		end
		EI:Dropdown("Place Rarities", JI, {}, eI, true, "Only place eggs of the picked rarities (empty = all)", sI)
		YI = Z[20]
		local function JI(eI)
			local fI = Z[20]
			aI.sp = fI.names(eI)
		end
		EI:Dropdown("Place Specific Eggs", YI.eggList, {}, JI, true, "Only place these eggs (empty = all)", sI)
		EI:Slider("Min Place Value", 0, 0, 0, function(JI)
			aI.minV = JI > 0 and JI or nil
		end, "log", nil, "Skip eggs worth less than this (0 = off)", sI)
		EI:Slider("Max Place Value", 0, 0, 1000, function(EI)
			aI.maxV = EI > 0 and EI < 1000000000000 and EI or nil
		end, "log", nil, "Only place eggs worth less than this, keep the better ones (far right = no limit)", sI)
		local EI, sI = 0, Z[20]
		local JI, YI = sI.onSteal, Z[20]
		YI.onSteal = function(sI)
			EI = os.clock()
			if JI then
				JI(sI)
			end
		end
		local function sI()
			local JI = Z[66]
			local YI, eI, fI, QI, uI = JI(), Z[33], next, {}, Z[20]
			C:EH(QI, 0, workspace:FindFirstChild("PlacedEggRenders"), uI.hidden)
			JI = 0
			for AI, hI in fI, QI, nil do
				AI, uI = ipairs, C[20](hI:GetChildren())
				for fI, QI in AI(C:QH(uI)) do
					if QI:IsA("Model") then
						hI, fI = Z[1], QI.Name:find(Z[1].UserId .. "_", 1, true)
						if fI == 1 then
							local fI, uI = JI + 1, eI + QI:GetPivot().Position
							JI, eI = fI, uI
						else
						end
					else
					end
				end
			end
			if JI > 0 then
				return eI / JI
			end
			return YI and YI.PetArea and YI.PetArea.Position
		end
		local JI = C:FH(19, 20, { [66] = Z, [28] = Z, [27] = Z }, O, p, nil)
		local function YI(eI)
			local fI = Z[22]
			if fI("Egg", "WearEggTool", eI) == false then
				return false
			end
			fI = os.clock() + 2
			while os.clock() < fI do
				if B() == eI then
					return true
				end
				if os.clock() > fI - 1.3 then
					local fI, QI = ipairs, t() and t():GetChildren() or {}
					for uI, uI in fI(QI) do
						if uI:GetAttribute("UID") == eI then
							local eI, eI = Z[8], Z[8]
							pcall(Z[8]().EquipTool, Z[8](), uI)
						end
					end
				end
				task.wait(0.1)
			end
			return false
		end
		RI = Z[20]
		RI.wear = YI
		local function RI()
			local eI = Z[25]
			local fI = eI.placeWhen
			if fI == "Steal is idle" then
				eI = Z[25]
				local QI = eI.steal
				return if QI then wI.empty ~= nil else not QI
			end
			if fI == "Right after a steal" then
				eI = os.clock() - EI
				return eI < 12
			end
			if fI == "Only at night" then
				return o() < 14
			end
			return true
		end
		local function wI()
			local EI, eI, fI, QI = S(), {}, {}, Z[25]
			local uI, AI = QI.placeIdx
			if uI then
				QI = Z[20]
				AI = QI.indexMissing()
			else
				AI = uI
			end
			local hI, mI, kI = AI or {}, {}, 0
			for LI, LI in pairs(EI) do
				if type(LI) == "table" then
					if LI.Placement then
						AI = kI + 1
						mI[LI.AssetCategory or LI.Category or ""] = true
						kI = AI
					else
					end
				else
				end
			end
			uI = pairs
			for LI, gI in uI(EI) do
				if type(gI) == "table" then
					if not gI.Placement then
						if (WI.bad[LI] or 0) < os.clock() then
							AI = Z[20]
							if not AI.reserved[LI] then
								QI = Z[20]
								if not (QI.protect(LI, gI)) then
									local QI = g(gI)
									QI.uid = LI
									if hI[QI.cat] and not mI[QI.cat] then
										mI[QI.cat] = true
										fI[#fI + 1] = QI
									else
										local uI = Z[25]
										if uI.place then
											local uI = Z[70]
											if uI(aI, QI) then
												eI[#eI + 1] = QI
											end
										end
									end
								end
							end
						end
					end
				end
			end
			mI = Z[67]
			local QI, uI = mI(), 0
			for LI in next, QI and type(QI.EquippedAssets) == "table" and QI.EquippedAssets or {}, nil do
				uI += 1
			end
			AI = 0
			for LI, LI in pairs(EI) do
				AI = if type(LI) == "table" then if LI.Placement then AI else AI + 1 else AI
			end
			mI, hI = pcall(function()
				local LI = Z[34]
				return LI.Bases.GetAssetEquipCapacity(QI and tonumber(QI.BaseUpgradeLevel) or 0)
			end)
			FI(
				aI.maxV
						and aI.maxV <= (aI.minV or 0)
						and "Max Place Value must be above Min Place Value, nothing will be placed"
					or ("Eggs placed %d/%d  -  %d/%d pets equipped, %d in bag"):format(
						kI,
						30,
						uI,
						mI and tonumber(hI) or 0,
						AI
					)
			)
			return kI, eI, EI, fI
		end
		local EI = G({ name = "PlaceInfo", gap = 2, info = true })
		EI.on = function()
			return rI("Farm")
		end
		EI.fn = wI
		WI.want = function()
			local EI, FI, aI, eI = wI()
			if EI >= 30 then
				return
			elseif #FI + #eI == 0 then
				return
			elseif #eI == 0 then
				if not (RI()) then
					return
				end
			end
			local wI = Z[25]
			if wI.placeFirst ~= "Backpack" then
				local wI = Z[25]
				lI(FI, wI.placeFirst)
			end
			for wI, RI in ipairs(eI) do
				table.insert(FI, wI, RI)
			end
			return { list = FI, room = 30 - EI, recs = aI }
		end
		WI.run = function(wI, EI)
			local FI = sI()
			if not FI then
				return
			end
			local sI = Z[11]
			sI("Walking to your pen")
			sI = Z[28]
			if not (pI(FI + sI(0, 3, 0), EI)) then
				return
			end
			local aI, RI, eI, fI = JI(wI.recs), math.min(wI.room, #wI.list), 0, 0
			for JI = 1, RI, 1 do
				if not (EI()) then
					break
				end
				sI = wI.list[JI]
				if YI(sI.uid) then
					FI = false
					for YI = 1, 8, 1 do
						eI += 1
						JI = aI[eI]
						if not JI then
							break
						end
						YI = Z[75]
						if YI("RF/EggWorld/AskPlaceEgg", { Uid = sI.uid, LocalCFrame = JI[1] }) then
							fI += 1
							local aI = Z[46]
							aI.placed = aI.placed + 1
							FI = true
							break
						end
					end
					if not FI then
						WI.bad[sI.uid] = os.clock() + 60
					end
					task.wait(0.25)
				else
					WI.bad[sI.uid] = os.clock() + 20
				end
			end
			EI = Z[22]
			EI("Egg", "DoffEggTool")
			if fI > 0 then
				wI = Z[11]
				wI("Placed " .. fI .. " egg(s)", "ok")
			end
		end
		WI.on = function()
			local wI = Z[25]
			local WI, EI = wI.place
			if WI then
				EI = WI
			else
				wI = Z[25]
				EI = wI.placeIdx
			end
			return EI
		end
	end)
	w("20_farm#2", function()
		local wI = G({ name = "Hatch", gap = 2, bad = {}, info = true })
		local WI = dI["Auto Hatch & Equip"]
		local EI, FI = j(WI, "Auto Hatch", "hatch", false), Z[20]
		local sI, aI, JI = FI.nostat, {}, Z[20]
		local function FI(YI)
			local RI = Z[20]
			aI.rar = RI.minRar(YI)
		end
		WI:Dropdown(
			"Hatch Min Rarity",
			JI.RANY,
			"Any",
			FI,
			false,
			"Hatch eggs of the chosen rarity and every rarity above it",
			EI
		)
		WI:Slider("Min Hatch Value", 0, 0, 0, function(FI)
			aI.minV = FI > 0 and FI or nil
		end, "log", nil, "Skip eggs worth less than this (0 = off)", EI)
		WI:Slider("Max Hatch Value", 0, 0, 1000, function(FI)
			aI.maxV = FI > 0 and FI < 1000000000000 and FI or nil
		end, "log", nil, "Only hatch eggs worth less than this, keep the better ones (far right = no limit)", EI)
		JI = Z[20]
		local function FI(YI)
			local RI = Z[20]
			aI.sp = RI.names(YI)
		end
		WI:Dropdown("Hatch Specific Eggs", JI.eggList, {}, FI, true, "Only hatch these eggs (empty = all)", EI)
		j(WI, "Auto Equip Best", "equip", false, nil, "Equip Best when a better pet appears")
		wI.on = function()
			local WI = Z[25]
			local EI, FI = WI.hatch
			if EI then
				FI = EI
			else
				WI = Z[25]
				FI = WI.placeIdx
			end
			return FI or (rI("Farm"))
		end
		wI.fn = function()
			local WI, EI, FI = {}, pairs, C[20](S())
			for JI, YI in EI(C:QH(FI)) do
				if type(YI) == "table" then
					if YI.Placement then
						local RI = Z[22]
						if RI("Egg", "IsReadyToHatch", JI) == true then
							WI[#WI + 1] = { JI, YI }
						end
					end
				end
			end
			FI, EI = { ["Ready now"] = tostring(#WI) }
			EI, FI.Hatched = Z[46], tostring(Z[46].hatched)
			V("hs", sI, FI)
			FI = Z[25]
			if not FI.hatch then
				EI = Z[25]
				if not EI.placeIdx then
					return
				end
			end
			FI = Z[25]
			if FI.hatch then
				if aI.maxV then
					if aI.maxV <= (aI.minV or 0) then
						EI = Z[11]
						EI("Max Hatch Value must be above Min Hatch Value, nothing will hatch", "warn")
					end
				end
			end
			EI = Z[25]
			local sI, JI = EI.placeIdx
			if sI then
				EI = Z[20]
				JI = EI.indexMissing()
			else
				JI = sI
			end
			sI, FI, EI = JI or {}, ipairs, 0
			for YI, RI in FI(WI) do
				if EI >= 4 then
					break
				end
				YI, JI = RI[1], g(RI[2])
				local WI, FI = (wI.bad[YI] or 0) < os.clock()
				if WI then
					local eI = Z[25]
					local fI, QI = eI.hatch
					if fI then
						eI = Z[70]
						QI = (eI(aI, JI))
					else
						QI = fI
					end
					FI = QI or sI[JI.cat]
				else
					FI = WI
				end
				if FI then
					WI = Z[20]
					if WI.protect(YI, RI[2]) then
					else
						local WI = EI + 1
						if TI(YI) then
							local TI = Z[46]
							TI.hatched = TI.hatched + 1
						else
							wI.bad[YI] = os.clock() + 10
						end
						task.wait(0.2)
						EI = WI
					end
				else
				end
			end
		end
		local wI = G({ name = "Equip", gap = 8 })
		wI.on = function()
			local TI = Z[25]
			return TI.equip
		end
		wI.fn = function()
			local wI = Z[9]
			local TI, WI = wI("RF/Haul/FetchWearBestStatus")
			if TI then
				if WI then
					wI = Z[9]
					wI("RF/Haul/WearBest")
				end
			end
		end
	end)
	w("20_farm#3", function()
		local wI, TI, WI = dI["Keep Eggs"]
		local EI, FI = {}, Z[20]
		local sI = #FI.RANY
		for aI = sI, 2, -1 do
			FI = nil
			FI, EI[#EI + 1] = Z[20], Z[20].RANY[aI]
		end
		wI:Text("Keep Eggs Info", "Kept eggs are never placed, hatched or sold, in your bag or your pen.")
		FI = j(wI, "Keep Matching Eggs", "keepOn", true)
		local function sI(aI)
			local JI, YI = ipairs
			for RI, eI in JI(aI) do
				YI = YI or {}
				RI = Z[20]
				YI[RI.RIDX[eI] or 0] = true
			end
			TI = YI
			I()
		end
		wI:Dropdown("Keep Rarities", EI, {}, sI, true, nil, FI)
		wI:Slider("Keep Min Value", 0, 0, 0, function(wI)
			WI = wI > 0 and wI or nil
			I()
		end, "log", nil, nil, FI)
		local wI = Z[20]
		wI.protect = function(wI, EI)
			wI = Z[25]
			if wI.keepOn then
				if type(EI) ~= "table" then
					return false
				elseif not TI then
					if not WI then
						return false
					end
				end
			else
				return false
			end
			local FI, sI, aI = g(EI), TI ~= nil
			if sI then
				wI = TI
				aI = wI[FI.r] == true
			else
				aI = sI
			end
			EI = aI or WI ~= nil and FI.v >= WI
			return EI
		end
	end)
	w("20_farm#4", function()
		local wI, TI, WI =
			{
				Boss = "Fractured",
				Scrambled = "Scrambled",
				Enchanted = "Enchanted",
				Nitro = "Nitro",
				Spectral = "Spectral",
				Alien = "Abducted",
				DarkMatter = "Dark Matter",
				Thunderous = "Thunderous",
				Blacklisted = "Blacklisted",
				Copper = "Copper",
				GreatBloom = "Spirit Bloom",
			},
			{
				"Fractured",
				"Scrambled",
				"Enchanted",
				"Nitro",
				"Spectral",
				"Abducted",
				"Dark Matter",
				"Thunderous",
				"Blacklisted",
				"Copper",
				"Spirit Bloom",
			},
			{ Thunderous = true, Blacklisted = true, Copper = true, GreatBloom = true }
		local EI = G({ name = "Mutate", mover = true, gap = 1, pri = 3, soft = true, bad = {} })
		local FI = dI["Auto Mutation"]
		local sI = j(FI, "Auto Mutate", "mutate", false, function(aI)
			if not aI then
				CI(EI)
			end
		end)
		local aI, JI = N("mst", FI:Text("Mutate Status", "Off", sI)), {}
		for YI in next, wI, nil do
			JI[YI] = true
		end
		local YI = FI:Dropdown("Mutations To Use", TI, TI, function(RI)
			for eI, fI in next, wI, nil do
				JI[eI] = table.find(RI, fI) ~= nil
			end
		end, true, nil, sI)
		task.delay(5, function()
			local RI = "ChilliLibrary/SAE_alien.txt"
			if Z[56] and not (pcall(isfile, RI) and isfile(RI)) then
				local eI = JI.Alien
				if if eI then not eI else next(JI) then
					local eI = table.clone(YI.Value or {})
					eI[#eI + 1] = "Abducted"
					D("addAlien", function()
						YI:Set(eI)
					end)
				end
				pcall(writefile, RI, "1")
			end
			RI = "ChilliLibrary/SAE_darkmatter.txt"
			if Z[56] and not (pcall(isfile, RI) and isfile(RI)) then
				local eI = JI.DarkMatter
				if if eI then not eI else next(JI) then
					local eI = table.clone(YI.Value or {})
					eI[#eI + 1] = "Dark Matter"
					D("addDM", function()
						YI:Set(eI)
					end)
				end
				pcall(writefile, RI, "1")
			end
			RI = "ChilliLibrary/SAE_storm.txt"
			if Z[56] and not (pcall(isfile, RI) and isfile(RI)) then
				local eI = table.clone(YI.Value or {})
				for fI in next, WI, nil do
					if not (table.find(eI, wI[fI])) then
						eI[#eI + 1] = wI[fI]
					end
				end
				if next(JI) then
					D("addStorm", function()
						YI:Set(eI)
					end)
				end
				pcall(writefile, RI, "1")
			end
		end)
		local WI, YI, RI = {}, {}, Z[20]
		local function eI(fI)
			local QI = Z[20]
			WI.rar = QI.minRar(fI)
			I()
		end
		FI:Dropdown(
			"Mutate Min Rarity",
			RI.RANY,
			"Any",
			eI,
			false,
			"Only eggs of this rarity and above get mutated",
			sI
		)
		FI:Slider("Mutate Min Value", 0, 0, 0, function(RI)
			WI.minV = RI > 0 and RI or nil
			I()
		end, "log", nil, "Skip eggs worth less than this (0 = off)", sI)
		TI = Z[20]
		local function RI(fI)
			local QI = Z[20]
			WI.sp = QI.names(fI)
			I()
		end
		FI:Dropdown("Mutate Target Eggs", TI.eggList, {}, RI, true, "Only mutate these eggs (empty = all)", sI)
		local RI, fI =
			{ ["Highest Value"] = "Best value", ["Best Rarity"] = "Best rarity", ["Biggest Size"] = "Biggest" }, Z[25]
		fI.mutFirst = "Best value"
		FI:Dropdown("Mutate Priority", { "Highest Value", "Best Rarity", "Biggest Size" }, "Highest Value", function(FI)
			local fI = Z[25]
			fI.mutFirst = RI[FI] or "Best value"
		end, false, "Which egg gets mutated first", sI)
		TI = Z[20]
		local FI = TI.nostat
		local function TI()
			local sI, RI, fI, QI, uI, AI =
				{},
				{ Boss = 0, Scrambled = 0, Enchanted = 0, Nitro = 0, Spectral = 0, Alien = 0, DarkMatter = 0 },
				ipairs,
				{},
				Z[1],
				Z[1]
			C:EH(QI, 0, uI.Character or (t()), AI.Character and (t()))
			for AI, AI in fI(QI) do
				for fI, fI in ipairs(AI and AI:GetChildren() or {}) do
					if fI:IsA("Tool") then
						if fI:GetAttribute("ItemType") == "MutationConsumable" then
							uI = fI:GetAttribute("MutationId") or fI:GetAttribute("MutationTemplate") or "Boss"
							sI[uI] = sI[uI] or fI
							RI[uI] = (RI[uI] or 0)
								+ (tonumber(fI:GetAttribute("Uses")) or tonumber(fI.Name:match("%[X(%d+)%]")) or 1)
						end
					end
				end
			end
			return sI, RI
		end
		eI = Z[20]
		eI.mutItems = TI
		local sI = G({ name = "Bag", gap = 2, info = true })
		sI.on = function()
			return rI("Farm")
		end
		sI.fn = function()
			local sI, sI = TI()
			V(
				"bag",
				FI,
				{
					Fractured = tostring(sI.Boss),
					Scrambled = tostring(sI.Scrambled),
					Enchanted = tostring(sI.Enchanted),
					Nitro = tostring(sI.Nitro),
					Spectral = tostring(sI.Spectral),
					Abducted = tostring(sI.Alien),
					["Dark Matter"] = tostring(sI.DarkMatter),
				}
			)
		end
		local function FI(sI)
			sI = sI or (TI())
			if not (next(sI)) then
				aI("No consumables in your bag")
				return
			end
			local RI, eI, fI = {}, pairs, C[20](S())
			for QI, uI in eI(C:QH(fI)) do
				local fI, AI = type(uI) == "table" and uI.Placement
				if fI then
					local hI = Z[20]
					AI = not hI.reserved[QI]
				else
					AI = fI
				end
				if AI then
					local AI, hI = g(uI), false
					for uI, uI in ipairs(AI.m) do
						hI = hI or YI[uI] == true
					end
					fI = Z[70]
					if fI(WI, AI) and not hI then
						for WI, YI in next, sI, nil do
							if JI[WI] then
								if not AI.ms[WI] then
									if (EI.bad[QI .. WI] or 0) < os.clock() then
										AI.uid = QI
										AI.k = WI
										AI.tool = YI
										RI[#RI + 1] = AI
										break
									end
								end
							end
						end
					end
				end
			end
			if #RI == 0 then
				aI("Waiting  |  No egg to mutate")
				return
			end
			aI(#RI .. " egg(s) can be mutated")
			eI = Z[25]
			return lI(RI, eI.mutFirst)[1]
		end
		local lI = G({ name = "MutateInfo", gap = 2, info = true })
		lI.on = function()
			return rI("Farm")
		end
		lI.fn = function()
			FI()
		end
		EI.want = function()
			local lI = Z[20]
			local WI = lI.mutPick
			if WI then
				local sI, JI = S()[WI.uid], TI()
				lI = type(sI) == "table" and sI.Placement and g(sI)
				for sI, sI in ipairs(lI and WI.ks or {}) do
					if JI[sI] then
						if not lI.ms[sI] then
							if (EI.bad[WI.uid .. sI] or 0) < os.clock() then
								lI.uid, lI.k, lI.tool = WI.uid, sI, JI[sI]
								lI.pick = true
								return lI
							end
						end
					end
				end
				JI = Z[20]
				JI.mutPick = nil
				EI.urgent = nil
				EI.soft = true
				aI(lI and "Done with " .. lI.n or "The chosen egg is gone")
			end
			WI = Z[25]
			if not WI.mutate then
				return
			end
			WI = FI(TI())
			if not WI then
				EI.at = os.clock() + 5
			end
			return WI
		end
		local TI = {
			Boss = 10,
			Scrambled = 10,
			Nitro = 10,
			Enchanted = 100,
			Spectral = 25,
			Alien = 15,
			DarkMatter = 30,
			Thunderous = 100,
			Blacklisted = 25,
			Copper = 30,
			GreatBloom = 100,
		}
		pcall(function()
			local lI, WI =
				P.Shared:FindFirstChild("BossMasteryFlags", true),
				P.Shared:FindFirstChild("ScrambleMutationFlags", true)
			TI.Boss = require(lI).MutationConsumableSuccessPercent:Get()
			TI.Nitro = TI.Boss
			TI.Scrambled = require(WI).SuccessPercent:Get()
		end)
		local function lI(WI, sI)
			local JI, YI = OI(WI.uid), Z[20]
			local RI = YI.eggPos(WI.uid)
			if JI then
			else
				if RI then
					aI("Going to " .. WI.n)
					YI = Z[28]
					if not (pI(RI + YI(0, 3, 4), sI)) then
						return
					end
					local eI = JI
					for fI = 1, 15, 1 do
						eI = OI(WI.uid)
						if eI then
							break
						end
						task.wait(0.2)
					end
					JI = eI
				else
				end
			end
			if not JI then
				EI.bad[WI.uid .. WI.k] = os.clock() + 30
				return aI(WI.n .. " is not in your pen")
			end
			YI = Z[20]
			if not (YI.needBody()) then
				return aI("Turning visible to use " .. wI[WI.k])
			end
			aI("Mutating " .. WI.n .. " with " .. wI[WI.k])
			YI = Z[11]
			YI("Mutating " .. WI.n)
			RI, YI = Z[28], JI:GetPivot().Position + Z[28](0, 3, 4)
			if not (pI(YI, sI)) then
				return
			end
			YI = Z[8]
			sI = YI()
			if sI then
				pcall(sI.EquipTool, sI, WI.tool)
			end
			YI = Z[1]
			if WI.tool.Parent ~= YI.Character then
				pcall(function()
					local OI
					OI, WI.tool.Parent = Z[1], Z[1].Character
				end)
			end
			task.wait(0.3)
			local OI, JI = os.clock(), Z[9]
			local YI, RI = JI("RF/BossMastery/AskUseMutationConsumable", WI.uid)
			if YI and type(RI) == "table" and RI.Success then
				if RI.Mutated then
					aI(WI.n .. " got " .. wI[WI.k])
					c("Mutated", WI.n .. " got " .. wI[WI.k], "ok")
				else
					aI(("%s roll missed on %s (%s%% chance)"):format(wI[WI.k], WI.n, tostring(TI[WI.k] or "?")))
				end
			else
				EI.bad[WI.uid .. WI.k] = os.clock() + 600
				aI(
					("%s refused on %s: %s"):format(
						wI[WI.k],
						WI.n,
						type(RI) == "table" and tostring(RI.Message or "no reason") or "no answer"
					)
				)
			end
			task.wait(math.max(0, 1 - (os.clock() - OI)))
			if sI then
				pcall(sI.UnequipTools, sI)
			end
			return true
		end
		EI.run = function(OI, wI)
			if OI.pick then
				return lI(OI, wI)
			end
			local TI
			while OI and (wI()) do
				TI = lI(OI, wI)
				OI = TI and wI() and FI()
			end
			return TI
		end
		EI.on = function()
			local OI = Z[25]
			local wI, TI = OI.mutate
			if wI then
				TI = wI
			else
				OI = Z[20]
				TI = OI.mutPick ~= nil
			end
			return TI
		end
	end)
	w("20_farm#5", function()
		local OI, wI = G({ name = "Treadmill", mover = true, gap = 2, pri = 9, soft = true }), Z[20]
		wI.treadT = j(dI["Auto Treadmill"], "Auto Treadmill", "tread", false, function(TI)
			if not TI then
				CI(OI)
			end
		end)
		j(dI["Admin Treadmill"], "Use Admin Treadmill", "adminTread", false, function(TI)
			if not TI then
				CI(OI)
			end
		end)
		j(dI["Auto Treadmill"], "Auto Watch Ads", "watchAds", false)
		wI = Z[20]
		local TI, lI, WI, EI, FI = wI.nostat, 0, 0, 0
		local function sI()
			lI = os.clock()
			local aI = Z[20]
			aI.treadAt = lI
			aI = Z[20]
			if aI.onAdmin then
				EI = 0
			end
		end
		local aI = G({ name = "SpeedInfo", gap = 1, info = true })
		aI.on = function()
			return true
		end
		aI.fn = function()
			local aI = Z[67]
			local JI = aI()
			aI = JI and tonumber(JI.Money)
			V("tst", TI, { ["Speed power"] = JI and A(JI.SpeedPower) or "--", Cash = aI and "$" .. A(aI) or "--" })
			JI = x("Speed")
			if JI then
				if FI then
					if JI > FI then
						sI()
					end
				end
			end
			FI = JI
		end
		local function x()
			local TI, FI = workspace:FindFirstChild("AdminTreadmill"), Z[25]
			local aI = FI.adminTread and (TI or ZI())
			if aI then
				FI = TI and (TI:FindFirstChild("Pad") or TI:FindFirstChildWhichIsA("BasePart", true))
				local JI, YI = FI and FI.Position
				if JI then
					YI = JI
				else
					local JI = Z[28]
					YI = (JI(540.05, 68.6, -369.7))
				end
				return YI, true
			end
			aI = Z[66]
			FI, TI = aI(), Z[25]
			local aI, JI = TI.tread and FI and FI.PlotFolder:FindFirstChild("TreadmillBottom")
			if aI then
				FI = Z[28]
				JI = FI(aI.Position.X, 72, aI.Position.Z)
			else
				JI = aI
			end
			return JI
		end
		wI = Z[39]
		local TI, FI = wI:FindFirstChild("RE/Treadmill/SpeedGained"), Z[39]
		wI = FI:FindFirstChild("RE/Treadmill/AssignedBeltShifted")
		if TI then
			W(TI.OnClientEvent, sI)
		end
		if wI then
			W(wI.OnClientEvent, function(wI, TI, FI, sI, sI, aI)
				TI = Z[20]
				sI, FI = TI.onAdmin, Z[20]
				FI.onAdmin = wI ~= nil and aI == true
				if sI then
					FI = Z[20]
					if not FI.onAdmin then
						TI = Z[25]
						if not TI.tread then
							if not (ZI()) then
								task.spawn(Z[9], "RF/Treadmill/AskDoff")
							end
						end
					end
				end
			end)
		end
		OI.want = function()
			local wI = Z[15]
			local TI, FI, sI = wI(), x()
			if TI then
				if not FI then
					return
				end
			else
				return
			end
			if sI then
				wI = Z[20]
				local sI = wI.onAdmin
				local wI = (if sI then os.clock() - lI > 5 else not sI) and FI or nil
				return wI
			end
			if TI.Anchored then
				return "wait"
			elseif os.clock() - lI < 3 then
				return "wait"
			end
			return FI
		end
		OI.run = function(wI, TI)
			local FI, FI = x()
			if FI then
				local x = Z[20]
				if x.onAdmin then
					EI += 1
					if EI >= 3 then
						local x = Z[20]
						if x.respawn then
							EI = 0
							local x = Z[11]
							x("Admin treadmill will not take you, respawning", "warn")
							x = Z[20]
							return x.respawn()
						end
					end
					local x = Z[11]
					x("Admin treadmill speed is not going up, getting back on", "warn")
					if not (Z[13](TI)) then
						return
					end
				end
			end
			local x = Z[11]
			x(FI and "Going to the admin treadmill" or "Going to the treadmill")
			x = Z[28]
			if not (pI(wI + x(0, 1, 0), TI)) then
				return
			end
			wI, x = Z[20], Z[20]
			wI.hold = (x.hold or 0) + 1
			wI = os.clock() + (FI and 2.5 or 3)
			lI = 0
			x = false
			while os.clock() < wI and (TI()) and not x do
				if FI then
					local EI = Z[20]
					x = EI.onAdmin == true
					if x then
					else
						if os.clock() > wI - 0.1 then
							EI = Z[9]
							local sI, aI, JI = EI("RF/Treadmill/AskWearStill")
							local YI, RI, eI =
								sI and (aI == true or type(JI) == "string" and JI:lower():find("already")) and true
									or false,
								Z[20],
								Z[20]
							RI.onAdmin = eI.onAdmin or YI
							x = YI
						else
						end
					end
					if not x then
						EI = Z[23]
						EI()
					end
				else
					local EI = Z[9]
					local sI, aI, JI = EI("RF/Treadmill/AskWearStill")
					EI = Z[15]
					local YI = EI()
					EI = YI and YI.Anchored
						or sI and (aI == true or type(JI) == "string" and JI:lower():find("already"))
					x = EI or os.clock() - lI < 3
					if not x then
						task.wait(0.3)
					end
				end
			end
			wI = Z[20]
			wI.hold = wI.hold - 1
			if not (TI()) then
				wI = Z[13]
				return wI(function()
					return true
				end)
			end
			if x then
				WI = 0
				if FI then
					lI = os.clock()
				end
				wI = Z[11]
				return wI(FI and "Training on the admin treadmill" or "Training speed", "ok")
			end
			WI += 1
			if WI >= 2 then
				FI = Z[20]
				if FI.respawn then
					WI = 0
					TI = Z[11]
					TI("Treadmill will not take you, respawning", "warn")
					x = Z[20]
					x.respawn()
				end
			end
		end
		local x = Z[20]
		x.treadOn = function()
			return OI.on()
		end
		OI.on = function()
			local x = Z[25]
			local OI, wI = x.tread
			if OI then
				wI = OI
			else
				x = Z[25]
				wI = x.adminTread and (ZI() or workspace:FindFirstChild("AdminTreadmill") ~= nil)
			end
			return wI
		end
		local x, OI = dI["Auto Progression"], {}
		j(x, "Auto Buy Trail", "trails", false)
		j(x, "Auto Upgrade Base", "upBase", false)
		j(x, "Auto Upgrade Treadmill", "upTread", false)
		local ZI = z.pre
		function z.pre(wI)
			if ZI then
				ZI(wI)
			end
			for ZI, ZI in next, wI, nil do
				local wI, TI =
					type(ZI) == "table" and ZI["Auto Progression"], type(ZI) == "table" and ZI["Auto Treadmill"]
				if type(wI) == "table" then
					if wI["Auto Claim"] then
						if not wI["Auto Claim Money"] then
							wI["Auto Claim Money"] = wI["Auto Claim"]
						end
					end
				end
				if type(wI) == "table" then
					if type(TI) == "table" then
						if wI["Auto Watch Ads"] ~= nil then
							if TI["Auto Watch Ads"] == nil then
								TI["Auto Watch Ads"] = wI["Auto Watch Ads"]
							end
						end
					end
				end
			end
		end
		j(x, "Auto Claim Money", "claimCash", false, function(ZI)
			OI[1] = ZI
			ZI = Z[25]
			ZI.claimIndex = OI[1] or OI[2]
		end)
		x:Toggle("Auto Claim Index", false, function(x)
			OI[2] = x
			x = Z[25]
			x.claimIndex = OI[1] or OI[2]
		end)
		task.spawn(function()
			local x, OI = game:GetService("AdService"), { egg = 0, cash = 0 }
			local function ZI()
				local wI, TI = pcall(x.GetAdAvailabilityNowAsync, x, Enum.AdFormat.RewardedVideo)
				return wI and TI and TI.AdAvailabilityResult == Enum.AdAvailabilityResult.IsAvailable
			end
			local function x(wI, TI)
				local lI
				local WI, EI, FI =
					wI.OnClientEvent:Connect(function(sI)
						lI = sI == nil and true or sI
					end), pcall(TI), os.clock()
				while true do
					wI, TI = EI and lI == nil and Z[56]
					if wI then
						local sI = Z[25]
						TI = sI.watchAds
					else
						TI = wI
					end
					if not (TI and os.clock() - FI < 120) then
						break
					end
					task.wait(0.2)
				end
				WI:Disconnect()
				TI = EI and lI
				return TI
			end
			while true do
				local wI = Z[56]
				if not wI then
					break
				end
				task.wait(3)
				wI = Z[25]
				if wI.watchAds and ZI() then
					local wI, TI = os.clock(), P:FindFirstChild("AdEggBoostRemotes")
					local lI = TI and (TI:FindFirstChild("AskAdGrowthBoost"))
					local WI = TI and (TI:FindFirstChild("AdGrowthBoostResult"))
					if lI and WI then
						if wI >= OI.egg then
							TI = x(WI, function()
								local EI, FI = lI:InvokeServer()
								if EI == false then
									error(tostring(FI))
								end
							end)
							OI.egg = os.clock() + (type(TI) == "table" and TI.completed == true and 30 or 120)
							if type(TI) == "table" then
								if TI.completed == true then
									c("Ads", "Egg growth +5 min", "ok")
								end
							end
						end
					end
					WI = workspace:FindFirstChild("RVBillboard_Cash_Reward")
					wI = WI and (WI:FindFirstChild("Remotes"))
					local lI = wI and (wI:FindFirstChild("ShowAd"))
					TI, WI = wI and (wI:FindFirstChild("AdResult")), Z[25]
					if WI.watchAds then
						if lI then
							if TI then
								if os.clock() >= OI.cash then
									if ZI() then
										wI = x(TI, function()
											lI:FireServer()
										end)
										OI.cash = os.clock() + (wI and 30 or 120)
										if wI then
											c("Ads", "Cash ad watched", "ok")
										end
									end
								end
							end
						end
					end
				end
			end
		end)
		local x = G({ name = "Progress", gap = 5, fail = {} })
		x.on = function()
			local OI = Z[25]
			local ZI, wI = OI.claimCash
			if ZI then
				wI = ZI
			else
				OI = Z[25]
				wI = OI.claimIndex
			end
			OI = nil
			if wI then
				OI = wI
			else
				ZI = Z[25]
				OI = ZI.upBase
			end
			ZI = nil
			if OI then
				ZI = OI
			else
				wI = Z[25]
				ZI = wI.upTread
			end
			wI = nil
			if ZI then
				wI = ZI
			else
				OI = Z[25]
				wI = OI.trails
			end
			return wI
		end
		local OI = {
			{ "LimitedEgg", "GravityDisruptor", "LimitedEgg", "MechaReroll" },
			{ "BrainrotEgg", "BeeLauncher", "BrainrotEgg" },
			{ "MonsterEgg", "BeeLauncher", "MonsterEgg", "Mecha" },
		}
		x.fn = function()
			local ZI = Z[67]
			local wI = ZI()
			if not wI then
				return
			end
			local TI, lI = tonumber(wI.Money) or 0, Z[25]
			if lI.claimCash then
				ZI = Z[9]
				local WI, EI = ZI("RF/AwayEarnings/FetchSummary")
				if WI then
					if type(EI) == "table" then
						local WI = tonumber(EI.ClaimableAmount)
						if WI then
							if WI > 0 then
								local WI = Z[9]
								WI("RF/AwayEarnings/AskCollect", { Kind = "Claim" })
							end
						end
					end
				end
			end
			lI = Z[25]
			if lI.claimIndex then
				local WI, EI, FI =
					type(wI.Index) == "table" and wI.Index or {},
					type(wI.IndexClaimedCategories) == "table" and wI.IndexClaimedCategories or {},
					next
				for sI, aI in FI, WI, nil do
					if aI == true then
						if EI[sI] ~= true then
							ZI = Z[9]
							ZI("RF/Codex/AskRedeemAll")
							break
						end
					end
				end
				FI, EI = type(wI.GearInventory) == "table" and wI.GearInventory or {}, ipairs
				for sI, aI in EI(OI) do
					if (x.fail[aI[1]] or 0) < os.clock() and (tonumber(FI[aI[2]]) or 0) <= 0 then
						sI = P.Data:FindFirstChild(aI[3])
						local OI, EI = pcall(require, sI)
						local FI, sI = true, false
						if OI then
							if type(EI) == "table" then
								local OI, JI, YI, RI =
									ipairs,
									{},
									EI.Entries,
									aI[4] and (
											EI[aI[4] .. "Entries"]
											or type(EI[aI[4]]) == "table" and EI[aI[4]].Entries
										)
								C:EH(JI, 0, YI, RI)
								RI, YI = sI, FI
								for EI, EI in OI(JI) do
									for OI, OI in ipairs(type(EI) == "table" and EI or {}) do
										RI, YI = true, if WI[OI.AssetId] then YI else false
									end
								end
								if RI then
									if YI then
										x.fail[aI[1]] = os.clock() + 60
										JI = Z[9]
										JI("RF/Codex/AskRedeemLimitedEgg", aI[1])
									end
								end
							end
						end
					end
				end
			end
			lI = Z[25]
			if lI.upBase then
				ZI = Z[34]
				local OI, WI = ZI.Bases, tonumber(wI.BaseUpgradeLevel) or 1
				local EI, FI = OI and OI.BASES and OI.BASES[WI + 1], Z[22]
				OI = FI("Bases", "GetMaxBaseLevel")
				if EI then
					if TI >= (tonumber(EI.Cost) or 1 / 0) then
						if OI then
							if WI < OI then
								s("RE/Homestead/AskBaseTierRaise")
								return
							end
						else
							s("RE/Homestead/AskBaseTierRaise")
							return
						end
					end
				end
			end
			ZI = Z[25]
			if ZI.upTread then
				lI = Z[22]
				local OI = lI("Tread", "GetByUpgradeLevel", (tonumber(wI.TreadmillUpgradeLevel) or 0) + 1)
				if type(OI) == "table" then
					if OI._id then
						if TI >= (tonumber(OI.Price) or 1 / 0) then
							local ZI = Z[9]
							ZI("RF/Treadmill/AskTierRaise", OI._id)
							return
						end
					end
				end
			end
			lI = Z[25]
			if lI.trails then
				local OI, ZI, lI = type(wI.TrailInventory) == "table" and wI.TrailInventory or {}, next, Z[34]
				local wI, WI = lI.Trails
				if wI then
					lI = Z[34]
					WI = lI.Trails.Directory
				else
					WI = wI
				end
				lI = nil
				for EI, FI in ZI, WI or {}, nil do
					wI = type(FI) == "table" and tonumber(FI.Price)
					EI = type(FI) == "table" and FI._id or EI
					lI = if wI
						then if wI <= TI
							then if OI[EI] ~= true
								then if x.fail[EI]
									then lI
									else if lI then if wI < lI[2] then { EI, wI } else lI else { EI, wI }
								else lI
							else lI
						else lI
				end
				if lI then
					wI = Z[75]
					if not (wI("RF/Trailwear/AskPurchase", lI[1])) then
						x.fail[lI[1]] = true
					end
				end
			end
		end
	end)
	Z[68] = function(x, OI)
		local ZI, wI, TI, lI = m(x), B(), {}, {}
		for B, WI in next, type(x.Inventory) == "table" and x.Inventory or {}, nil do
			if type(WI) == "table" then
				if not WI.InFuse then
					if not WI.IsFavorite then
						if not ZI[B] then
							local EI = g(WI)
							EI.uid = B
							TI[#TI + 1] = EI
						end
					end
				end
			end
		end
		x, ZI = pairs, OI and {} or S()
		for B, WI in x(ZI) do
			if type(WI) == "table" then
				if not WI.Placement then
					if B ~= wI then
						OI = Z[20]
						if not OI.reserved[B] then
							local x = Z[20]
							if not (x.protect(B, WI)) then
								local x = g(WI)
								x.uid = B
								lI[#lI + 1] = x
							end
						end
					end
				end
			end
		end
		return TI, lI
	end
	w("20_farm#6", function()
		local x, B, OI =
			G({ name = "Sell", gap = 5, info = true }),
			dI["Auto Sell"],
			{ "Rarity Only", "Value Only", "Rarity And Value", "Rarity Or Value" }
		local function ZI(wI, TI, lI, WI)
			local EI = { rule = "Rarity And Value", mx = lI }
			local FI, sI =
				B:Text(wI .. " Sell Preview", wI .. " matches  -  0 " .. wI:lower() .. "s"),
				j(B, "Auto Sell " .. wI, TI, false, nil, WI)
			B:Button("Sell " .. wI .. "s Now", "Sell", function()
				task.spawn(function()
					local aI = Z[20]
					local JI, YI = aI.sellRun(TI == "sellPets" and "pets" or "eggs")
					c("Sold", (TI == "sellPets" and JI or YI) .. " " .. wI:lower() .. "(s)")
				end)
			end, wI == "Egg" and "Sell matching eggs once" or nil, "Sold!", sI)
			local aI, JI = wI .. " Rule", function(YI)
				EI.rule = YI
			end
			B:Dropdown("Sell " .. aI, OI, "Rarity And Value", JI, false, "Which checks must pass to sell", sI)
			JI, aI = wI .. " Max Rarity", Z[20]
			local OI, YI = aI.RNUM, Z[20]
			aI, WI = YI.RNUM[lI]
			if aI then
				WI = aI
			else
				YI = Z[20]
				WI = YI.RNUM[1]
			end
			local function aI(RI)
				local eI = Z[20]
				EI.mx = eI.RIDX[RI] or lI
			end
			YI = wI:lower() .. "s at or below this rarity"
			B:Dropdown(JI, OI, WI, aI, false, "Sell " .. YI, sI)
			B:Slider(wI .. " Sell Value", 0, 0, 0, function(lI)
				EI.v = lI
			end, "log", nil, "Sell " .. wI:lower() .. "s worth less than this (0 = off)", sI)
			j(
				B,
				"Keep Mutated " .. wI .. "s",
				TI .. "Keep",
				wI ~= "Egg",
				nil,
				"Never sell mutated " .. wI:lower() .. "s",
				sI
			)
			WI, JI, YI, OI, aI =
				"Blacklist Sell " .. wI .. "s", Z[20], Z[20].eggList, function(TI)
					local lI = Z[20]
					EI.no = lI.names(TI)
				end, wI:lower() .. "s are never sold"
			B:Dropdown(WI, YI, {}, OI, true, "These " .. aI, sI)
			return EI, FI
		end
		local B, OI = ZI("Pet", "sellPets", 3)
		local wI, TI = ZI("Egg", "sellEggs", 7, "Sell bag eggs matching the rules below")
		local function lI(WI, EI, FI)
			local sI, aI = {}, ipairs
			for JI, YI in aI(WI) do
				local WI, aI = YI.r <= (EI.mx or 0), (EI.v or 0) > 0 and YI.v < EI.v
				JI = EI.rule == "Value Only" and aI
					or EI.rule == "Rarity And Value" and WI and (aI or (EI.v or 0) <= 0)
					or EI.rule == "Rarity Or Value" and (WI or aI)
					or EI.rule == "Rarity Only" and WI
				if JI then
					if not (EI.no and EI.no[YI.n]) then
						aI = Z[25]
						if aI[FI] then
							if not (#YI.m > 0) then
								sI[#sI + 1] = YI.uid
							end
						else
							sI[#sI + 1] = YI.uid
						end
					end
				end
			end
			return sI
		end
		local function WI(EI)
			local FI = Z[67]
			local sI = FI()
			if not sI then
				return 0, 0
			end
			FI = Z[68]
			local aI, JI = FI(sI)
			local YI, RI = lI(aI, B, "sellPetsKeep"), lI(JI, wI, "sellEggsKeep")
			local B = #YI
			local wI, lI, eI, fI = #RI, 0, 0
			JI = S()
			pcall(function()
				fI = require(P.Shared.Util.AssetItems)
			end)
			for QI, QI in ipairs(YI) do
				FI = sI.Inventory[QI]
				aI, QI = pcall(fI.SalePrice, FI)
				lI += aI and tonumber(QI) or g(FI).v * 100
			end
			sI = ipairs
			for fI, QI in sI(RI) do
				FI, aI, fI = Z[34], pcall(Z[34].Rec.SellPrice, JI[QI])
				eI += aI and tonumber(fI) or 0
			end
			local function FI(aI)
				local fI = { "", "K", "M", "B", "T", "Qa", "Qi" }
				local QI = 1
				while math.abs(aI) >= 1000 and QI < #fI do
					aI, QI = aI / 1000, QI + 1
				end
				return (QI == 1 and "$%.0f%s" or "$%.2f%s"):format(aI, fI[QI])
			end
			D("sellTx", function()
				OI:Set(("Pet matches  -  %d pets for %s"):format(B, FI(lI)))
				TI:Set(("Egg matches  -  %d eggs for %s"):format(wI, FI(eI)))
			end)
			if EI then
				if EI == "pets" then
					RI = {}
				else
					YI = {}
				end
			else
				JI, sI = Z[25], Z[25]
				YI, RI = if JI.sellPets then YI else {}, if sI.sellEggs then RI else {}
			end
			for B = 1, math.max(#YI, #RI), 50 do
				s(
					"RE/PetSatchel/SellSelection",
					{ Eggs = { table.unpack(RI, B, math.min(B + 49, #RI)) }, Assets = {
						table.unpack(YI, B, math.min(B + 49, #YI)),
					} }
				)
				task.wait(0.3)
			end
			return #YI, #RI
		end
		x.on = function()
			local B = Z[25]
			local OI, wI = B.sellPets
			if OI then
				wI = OI
			else
				B = Z[25]
				wI = B.sellEggs
			end
			return wI or (rI("Farm"))
		end
		x.fn = WI
		ZI = Z[20]
		ZI.sellRun = WI
	end)
	w("20_farm#7", function()
		local x = G({ name = "Favorite", gap = 3, pend = {} })
		local B = dI["Auto Favorite"]
		local OI, ZI, wI = N("favTx", B:Text("Favorite Preview", "Favorite matches  -  0 pets")), {}, {}
		local TI = j(B, "Auto Favorite Pet", "fav", false, nil, "Favorite pets matching the rules below")
		B:Button("Favorite Pets Now", "Favorite", function()
			local lI = Z[20]
			lI.favNow = "rules"
			x.at = 0
		end, "Favorite matching pets once", "Done!", TI)
		local lI = Z[25]
		lI.favMatch = "All picked rules"
		B:Dropdown("Favorite Rule", { "Match Any", "Match All" }, "Match All", function(WI)
			local EI = Z[25]
			EI.favMatch = WI == "Match Any" and "Any picked rule" or "All picked rules"
		end, false, "Pass any check or all checks", TI)
		local WI, EI = { "Off" }, Z[20]
		for FI, FI in ipairs(EI.RNUM) do
			WI[#WI + 1] = FI
		end
		B:Dropdown("Favorite Min Rarity", WI, "Off", function(WI)
			local FI = Z[20]
			ZI.rar = FI.minRar(WI)
		end, false, "Favorite pets of the chosen rarity and every rarity above it (Off = skip)", TI)
		EI = { "Any Mutation" }
		for WI = 2, #H, 1 do
			EI[#EI + 1] = H[WI]
		end
		local function H(WI)
			ZI.any = table.find(WI, "Any Mutation") ~= nil
			ZI.mut = _(WI, v)
			if ZI.mut then
				ZI.mut["Any Mutation"] = nil
				if not (next(ZI.mut)) then
					ZI.mut = nil
				end
			end
		end
		B:Dropdown("Favorite Mutations", EI, {}, H, true, "Mutation check (empty = skip)", TI)
		B:Slider("Min Favorite Value", 0, 0, 0, function(v)
			ZI.minV = v > 0 and v or nil
		end, "log", nil, "Value check (0 = skip)", TI)
		EI = Z[20]
		H, lI = EI.eggList, function(v)
			local WI = Z[20]
			wI = WI.names(v) or {}
		end
		B:Dropdown("Always Favorite Species", H, {}, lI, true, "Always favorite these species", TI)
		j(B, "Auto Favorite Equipped", "favEq", false, nil, "Keep equipped pets favorited")
		j(B, "Auto Unfavorite Equipped", "unfav", false, nil, "Unfavorite equipped pets not in the rules")
		B:Button("Favorite Equipped Now", "Favorite", function()
			local H = Z[20]
			H.favNow = "eq"
			x.at = 0
		end, "Favorite all equipped pets once", "Done!")
		B:Button("Unfavorite Equipped Now", "Unfavorite", function()
			local H = Z[20]
			H.favNow = "uneq"
			x.at = 0
		end, "Unfavorite all equipped pets once", "Done!")
		x.on = function()
			local H = Z[25]
			local B, v = H.fav
			if B then
				v = B
			else
				H = Z[25]
				v = H.favEq
			end
			B = nil
			if v then
				B = v
			else
				H = Z[25]
				B = H.unfav
			end
			H = nil
			if B then
				H = B
			else
				v = Z[20]
				H = v.favNow ~= nil
			end
			return H or (rI("Farm"))
		end
		local function H(B)
			local v, TI, lI = wI, B.n
			if TI then
				lI = TI
			else
				local WI = Z[74]
				lI = WI(B.cat)
			end
			if v[lI] then
				return true
			end
			TI, lI = 0, 0
			if ZI.rar then
				TI, lI = 1, lI + (ZI.rar[B.r] and 1 or 0)
			else
			end
			if ZI.mut or ZI.any then
				TI += 1
				local WI, EI = ZI.any and #B.m > 0
				if WI then
					EI = WI
				else
					v = ZI.mut
					if v then
						local WI = Z[70]
						EI = WI({ mut = ZI.mut }, B)
					else
						EI = v
					end
				end
				lI = lI + (EI and 1 or 0)
			else
			end
			v = ZI.minV
			if v then
				if v > 0 then
					local WI, EI = TI + 1, lI + (B.v >= ZI.minV and 1 or 0)
					TI, lI = WI, EI
				else
				end
			else
			end
			B, v = TI > 0
			if B then
				local WI = Z[25]
				v = WI.favMatch == "Any picked rule" and lI > 0 or lI == TI
			else
				v = B
			end
			return v
		end
		x.fn = function()
			local B = Z[67]
			local v = B()
			if not v then
				return
			end
			local TI, lI, WI = m(v), ZI.rar or ZI.mut or ZI.any or (ZI.minV or 0) > 0 or next(wI) ~= nil, Z[20]
			local ZI, wI = WI.favNow, Z[20]
			wI.favNow = nil
			local EI, FI, sI, aI, JI, YI = next, type(v.Inventory) == "table" and v.Inventory or {}, 0, 0, 0, 0
			for RI, eI in EI, FI, nil do
				if type(eI) == "table" then
					if H(g(eI)) then
						WI = sI + 1
						sI, aI = WI, if eI.IsFavorite then aI else aI + 1
					else
					end
				else
				end
				JI = if type(eI) == "table" then if eI.IsFavorite then JI + 1 else JI else JI
				if YI >= 25 then
					break
				end
				if type(eI) == "table" then
					if (x.pend[RI] or 0) < os.clock() then
						v = Z[25]
						wI, B = (v.favEq or ZI == "eq") and TI[RI]
						if wI then
							B = wI
						else
							local v = Z[25]
							local wI, WI = v.fav
							if wI then
								WI = wI
							else
								v = Z[25]
								WI = v.unfav
							end
							B = (WI or ZI == "rules") and H(g(eI))
						end
						local H
						local v = eI.IsFavorite
						local wI, WI = not v
						if v then
							WI = wI
						else
							local EI = Z[25]
							local FI = (EI.favEq or ZI == "eq") and TI[RI]
							if FI then
								WI = FI
							else
								EI = Z[25]
								WI = (EI.fav or ZI == "rules") and B
							end
						end
						if WI then
							H = true
						else
							if eI.IsFavorite then
								if TI[RI] then
									if ZI == "uneq" then
										H = false
									else
										wI = Z[25]
										H = if wI.unfav then if lI then if B then H else false else H else H
									end
								else
								end
							else
							end
						end
						if H ~= nil then
							v = YI + 1
							x.pend[RI] = os.clock() + 4
							s("RE/PetSatchel/WriteFavourite", RI, H)
							task.wait(0.12)
							YI = v
						else
						end
					else
					end
				else
				end
			end
			OI(("Favorite matches  -  %d pets, %d to mark  |  %d favorited"):format(sI, aI, JI))
		end
	end)
	w("20_farm#8", function()
		local x = {}
		local H = G({ name = "Fuse", gap = 2, bad = {}, info = true })
		x[69] = H
		local H = dI["Auto Fuse Machine"]
		local B = N("fuseTx", H:Text("Fuse Preview", "Fuse status unknown"))
		x[73] = B
		local B, v, OI, ZI =
			j(H, "Auto Fuse Machine", "fuse", false, nil, "Fuse 3 same pets into an egg, nonstop"),
			{
				["Lowest Rarity First"] = "Lowest rarity",
				["Highest Rarity First"] = "Highest rarity",
				["Most Copies First"] = "Most copies",
				["Lowest Value First"] = "Lowest value",
			},
			Z[25],
			Z[25]
		OI.fuseFirst = "Lowest rarity"
		ZI.fuseUse = "Lowest value first"
		H:Dropdown(
			"Fuse Priority Mode",
			{ "Lowest Rarity First", "Highest Rarity First", "Most Copies First", "Lowest Value First" },
			"Lowest Rarity First",
			function(OI)
				local ZI = Z[25]
				ZI.fuseFirst = v[OI] or "Lowest rarity"
			end,
			false,
			nil,
			B
		)
		H:Dropdown("Pets To Use", { "Lowest To Highest", "Highest To Lowest" }, "Lowest To Highest", function(v)
			local OI = Z[25]
			OI.fuseUse = v == "Highest To Lowest" and "Highest value first" or "Lowest value first"
		end, false, nil, B)
		local v, OI, ZI = {}, Z[20]
		x[71] = v
		ZI, x[71].rar = Z[20], OI.maxRar(Z[20].RNUM[6])
		OI = Z[20]
		local v, wI, wI, TI =
			OI.RNUM, Z[20], Z[20].RNUM, function(OI)
				local lI, WI = x[71], Z[20]
				lI.rar = WI.maxRar(OI)
			end
		H:Dropdown("Max Rarity to Fuse", v, wI[6], TI, false, nil, B)
		ZI = Z[20]
		local function v(OI)
			local wI, TI = x[71], Z[20]
			wI.sp = TI.names(OI)
		end
		H:Dropdown("Specific Species to Fuse", ZI.eggList, {}, v, true, "Only fuse these species (empty = all)", B)
		j(H, "Skip Mutated Pets", "fuseKeep", true, nil, nil, B)
		j(H, "Eject Incomplete Slots", "fuseEject", true, nil, "Take out pets that can't make a set", B)
		local H = {
			["Lowest rarity"] = function(B)
				return -B.r * 1000 + #B
			end,
			["Highest rarity"] = function(B)
				return B.r * 1000 + #B
			end,
			["Most copies"] = function(B)
				return #B
			end,
			["Lowest value"] = function(B)
				return -B.v
			end,
		}
		x[72] = H
		x[69].on = function()
			local H = Z[25]
			return H.fuse or rI("Farm")
		end
		x[69].fn = C:FH(
			21,
			22,
			{ [67] = Z, [25] = Z, [20] = Z, [9] = Z, [68] = Z, [69] = x, [70] = Z, [71] = x, [72] = x, [73] = x, [74] = Z, [22] = Z, [75] = Z },
			O,
			p,
			nil
		)
	end)
	w("21_eggs#1", function()
		local O = Color3.fromRGB
		local x = UDim2.fromScale
		local H = UDim2.fromOffset
		local B = Vector2.new
		local v = UDim2.new
		local OI = UDim.new
		local ZI = ColorSequence.new
		local wI = math.max
		local TI, lI, WI = math.floor, Enum, Z[20]
		local EI = WI.PS
		local WI = Color3.new(1, 1, 1)
		local FI
		local sI, aI, JI = true
		local YI, RI = EI.Seq, EI.FormatRate
		local eI = EI.FormatWeight
		local fI = EI.Income
		local QI = EI.AssetInfo
		local uI = G({ name = "GoTo", mover = true, gap = 0.5, pri = 0, soft = true })
		uI.on = function()
			local AI = FI
			return AI ~= nil
		end
		uI.want = function()
			local AI = FI
			return AI
		end
		uI.run = function(uI, AI)
			local hI = Z[28]
			pI(uI + hI(0, 3, 4), AI)
			FI = nil
		end
		local function pI(uI)
			return type(uI) == "table" and uI or {}
		end
		local function uI(AI, hI, mI, kI, LI, gI)
			return ZI(O(AI, hI, mI), O(kI, LI, gI))
		end
		local function AI(hI)
			return {
				TextScale = 0.84,
				LineHeight = 1.1,
				MinLines = 16,
				MaxLines = hI,
				BackgroundTransparency = 0.5,
				ScrollBarColor = O(170, 174, 184),
				TextColor = WI,
				TextStrokeTransparency = 0.7,
			}
		end
		do
			local hI = Color3.new(0, 0, 0)
			local mI = O(18, 18, 26)
			local kI = O(214, 218, 236)
			local LI = O(62, 64, 84)
			local gI = ZI(WI)
			local iI = uI(170, 255, 140, 40, 230, 90)
			local tI = lI.TextXAlignment.Left
			local xI = lI.TextTruncate.None
			local SI = lI.AutomaticSize.X
			local HI = lI.AutomaticSize.Y
			local _I, oI, BI = lI.SortOrder.LayoutOrder, { "Value", "Rarity", "Time Left" }, {}
			C:EH(
				BI,
				0,
				{ "All", "ALL", uI(255, 255, 255, 176, 188, 220) },
				{ "Ready", "READY", uI(170, 255, 150, 40, 220, 90) },
				{ "Growing", "GROWING", uI(255, 232, 150, 255, 150, 40) },
				{ "Inventory", "IN BAG", uI(180, 232, 255, 70, 160, 255) }
			)
			local vI = {}
			vI.Ready = { uI(170, 255, 150, 30, 205, 85), "HATCH NOW" }
			vI.Growing = { uI(255, 225, 120, 255, 130, 40), "FLY TO EGG" }
			vI.Inventory = { uI(160, 225, 255, 60, 140, 255), "HOLD EGG" }
			local zI, cI =
				YI(
					0,
					255,
					110,
					110,
					0.2,
					255,
					190,
					90,
					0.4,
					255,
					245,
					110,
					0.6,
					120,
					255,
					150,
					0.8,
					110,
					200,
					255,
					1,
					200,
					120,
					255
				),
				{}
			cI.Golden = uI(255, 246, 170, 255, 184, 0)
			cI.Silver = uI(255, 255, 255, 160, 176, 200)
			cI.Sakura = uI(255, 214, 236, 255, 110, 190)
			cI.GreatBloom = uI(205, 255, 230, 60, 225, 150)
			cI.Boss = uI(255, 190, 190, 255, 70, 70)
			cI.Monstrous = uI(228, 204, 255, 150, 90, 255)
			cI.Scrambled = uI(215, 255, 160, 40, 215, 170)
			cI.Rainbow = zI
			cI.Prismatic = zI
			local zI, DI = uI(215, 245, 255, 80, 190, 255), {}
			DI.ETERNAL = YI(0, 196, 222, 255, 0.45, 246, 242, 255, 1, 214, 180, 255)
			DI.SECRET =
				YI(0, 240, 243, 250, 0.3, 120, 128, 146, 0.52, 30, 32, 42, 0.74, 110, 118, 136, 1, 248, 250, 255)
			local NI = uI(255, 255, 255, 236, 240, 248)
			local VI = uI(255, 244, 190, 255, 196, 60)
			local II, jI = uI(235, 250, 255, 110, 200, 255), {}
			jI.Sort = oI[1]
			jI.Spot = true
			jI.Filter = "All"
			local KI, XI, UI, GI, C7, O7, p7, M7, Z7, n7, d7, q7, P7, r7, w7, b7, T7, y7, l7, W7, E7, F7, s7, a7 =
				{}, {}, {}, {}, {}, 0, false, 0, 0, 0, 0
			local function J7(Y7, R7)
				F("UICorner", { Parent = Y7, CornerRadius = OI(R7, 0) })
				return Y7
			end
			local function Y7(R7, e7, f7, Q7)
				return F(
					"UIStroke",
					{ Parent = R7, Color = e7, Thickness = f7, Transparency = Q7 or 0, ApplyStrokeMode = lI.ApplyStrokeMode.Border }
				)
			end
			local function R7(e7, f7, Q7)
				return F("UIGradient", { Parent = e7, Color = f7, Rotation = Q7 or 90 })
			end
			local function e7(f7, Q7, u7, A7, h7, m7, k7, L7)
				L7 = L7 or {}
				L7.Parent, L7.BackgroundTransparency, L7.Position, L7.Size = f7, u7 or 0, x(A7, h7), x(m7, k7)
				if Q7 then
					L7.BackgroundColor3 = Q7
					L7.BorderSizePixel = 0
				end
				return F("Frame", L7)
			end
			local function f7(Q7, u7, A7, h7, m7, k7, L7, g7, i7)
				i7 = i7 or {}
				i7.Parent, i7.AnchorPoint, i7.BackgroundTransparency, i7.Position, i7.Size, i7.ScaleType =
					Q7, B(u7, A7), 1, x(h7, m7), x(k7, L7), i7.ScaleType or lI.ScaleType.Fit
				i7.Image = g7
				return F("ImageLabel", i7)
			end
			local function Q7(u7, A7)
				A7.Parent = u7
				A7.AutoButtonColor = false
				A7.Text = ""
				return F("TextButton", A7)
			end
			local function u7(A7, h7, m7, k7, L7, g7)
				local i7 = F(
					"TextLabel",
					{
						Parent = A7,
						BackgroundTransparency = 1,
						TextColor3 = WI,
						TextTruncate = lI.TextTruncate.AtEnd,
						Text = "",
						FontFace = EI.RarityFont,
						Position = x(h7, m7),
						Size = x(k7, L7),
					}
				)
				for A7, h7 in next, g7 or {}, nil do
					i7[A7] = h7
				end
				F("UIStroke", { Parent = i7, Thickness = 1.5 })
				return i7
			end
			local function A7(h7, m7, k7)
				return F(
					"UIListLayout",
					{
						Parent = h7,
						FillDirection = lI.FillDirection.Horizontal,
						VerticalAlignment = m7 and lI.VerticalAlignment.Center,
						HorizontalAlignment = k7,
						SortOrder = _I,
						Padding = m7 and OI(0, m7),
					}
				)
			end
			local function h7(m7, k7)
				if m7.Text ~= k7 then
					m7.Text = k7
				end
			end
			local function m7(k7, L7)
				if k7.Visible ~= L7 then
					k7.Visible = L7
				end
			end
			local function k7(L7, g7)
				g7 = wI(6, TI(g7 + 0.5))
				if L7.TextSize ~= g7 then
					L7.TextSize = g7
					L7:FindFirstChildOfClass("UIStroke").Thickness = wI(1, g7 * 0.09)
				end
				if L7.AutomaticSize == lI.AutomaticSize.None then
					local i7 = L7:FindFirstChildOfClass("UITextSizeConstraint")
					if i7 then
					else
						i7 = F("UITextSizeConstraint", { Parent = L7, MinTextSize = 1 })
						L7.TextScaled = true
					end
					if i7.MaxTextSize ~= g7 then
						i7.MaxTextSize = g7
					end
				end
			end
			local function L7(g7, i7)
				for t7 = 1, #i7, 2 do
					k7(i7[t7], g7 * i7[t7 + 1])
				end
			end
			local function g7(i7)
				if GI[i7] == nil then
					GI[i7] = false
					pcall(function()
						local t7 = P.Assets.UI.RarityGradients:FindFirstChild(i7)
						local x7 = t7 and (t7:IsA("UIGradient") and t7 or t7:FindFirstChildWhichIsA("UIGradient", true))
						if x7 then
							GI[i7] = x7.Color
						end
					end)
				end
				return GI[i7]
			end
			local function GI(i7, t7)
				local x7, S7 = g7(t7), i7:FindFirstChild("EdgePaint")
				if not x7 then
					if S7 then
						S7:Destroy()
					end
					i7.Color = LI
					return
				end
				i7.Color = WI
				i7.Transparency = 0
				(S7 or F("UIGradient", { Parent = i7, Name = "EdgePaint", Rotation = 45 })).Color = x7
			end
			local function g7(i7, t7, x7)
				local S7 = i7:FindFirstChild("RarityPaint")
				if S7 then
					S7:Destroy()
				end
				F("UIGradient", { Parent = i7, Name = "RarityPaint", Color = t7, Rotation = x7 })
			end
			local function i7(t7)
				local x7 = DI[t7.Up] or t7.Tint
				if x7 then
					return x7
				end
				local DI, S7, H7, _7 = t7.Gradient, {}, {}, {}
				if DI and (DI:IsA("UIGradient")) then
					for o7, o7 in ipairs(DI.Color.Keypoints) do
						x7 = o7.Value
						if x7.R * 0.299 + x7.G * 0.587 + x7.B * 0.114 >= 0.45 then
							S7[#S7 + 1] = x7
						end
					end
				end
				if #S7 == 0 then
					S7[1] = t7.Color
				end
				DI = math.min(#S7, 8)
				for x7 = 1, DI, 1 do
					H7[x7] = S7[math.clamp(TI((x7 - 1) * (#S7 - 1) / wI(DI - 1, 1) + 1.5), 1, #S7)]:Lerp(WI, 0.36)
				end
				if DI == 1 then
					H7[2] = H7[1]
				end
				for DI, x7 in ipairs(H7) do
					_7[DI] = ColorSequenceKeypoint.new((DI - 1) / (#H7 - 1), x7)
				end
				t7.Tint = ZI(_7)
				return t7.Tint
			end
			local function DI(t7, x7)
				local S7 = t7.Keypoints
				if x7 <= S7[1].Time then
					return S7[1].Value
				end
				for H7 = 2, #S7, 1 do
					local _7, o7 = S7[H7 - 1], S7[H7]
					if x7 <= o7.Time then
						t7 = o7.Time - _7.Time
						return _7.Value:Lerp(o7.Value, t7 > 0 and (x7 - _7.Time) / t7 or 0)
					end
				end
				return S7[#S7].Value
			end
			local function t7(x7, S7, H7)
				local _7, o7, B7 = 90, S7.Gradient
				if S7.Up == "SECRET" then
					B7 = H7 and NI or EI.SecretGradient
				else
					if o7 and (o7:IsA("UIGradient")) then
						B7, _7 = o7.Color, o7.Rotation
					else
						B7 = ZI(S7.Color:Lerp(WI, 0.35), S7.Color)
					end
					local NI = H7 == (math.cos(math.rad(_7)) < -0.3 or math.sin(math.rad(_7)) < -0.3) and 0.5 or 0
					local S7, H7 = NI + 0.5, { ColorSequenceKeypoint.new(0, DI(B7, NI)) }
					for o7, o7 in ipairs(B7.Keypoints) do
						if o7.Time > NI + 0.001 then
							if o7.Time < S7 - 0.001 then
								H7[#H7 + 1] = ColorSequenceKeypoint.new((o7.Time - NI) / (S7 - NI), o7.Value)
							end
						end
					end
					H7[#H7 + 1] = ColorSequenceKeypoint.new(1, DI(B7, S7))
					B7 = (ZI(H7))
				end
				g7(x7, B7, _7)
			end
			local function ZI(DI, NI)
				local x7, S7 = pcall(function()
					local H7 = Z[34]
					return H7.Rec.EggIcon(DI)
				end)
				if x7 then
					if type(S7) == "string" then
						if S7 ~= "" then
							return S7
						end
					end
				end
				S7 = h(tostring(DI.AssetCategory))
				return type(S7) == "table" and type(S7.Egg) == "table" and S7.Egg.Icon and tostring(S7.Egg.Icon)
					or NI.Icon
					or ""
			end
			local function DI(NI, ...)
				local x7 = Z[22]
				local S7 = x7("Rec", NI, ...)
				return type(S7) == "number" and S7 or nil
			end
			local function NI()
				local x7 = Z[34]
				local S7 = x7.Egg
				local H7, _7 = pcall(function()
					local o7 = Z[1]
					return S7.ReadOwnerEggs(o7.UserId)
				end)
				if H7 then
					if type(_7) ~= "table" then
						return
					end
				else
					return
				end
				local o7, B7, v7 = J(), {}, pairs
				for z7, c7 in v7(_7) do
					if type(c7) == "table" then
						local _7, v7, D7 = QI(c7.AssetCategory), tonumber(c7.AssetScale) or 0, pI(c7.Mutations)
						x7 = {
							Id = z7,
							Info = _7,
							Scale = v7,
							Weight = DI("WeightKg", c7) or 0,
							Mutations = D7,
							Income = fI(_7, v7, D7),
							Status = "Inventory",
							Remaining = 1 / 0,
							Percent = 0,
							EggIcon = ZI(c7, _7),
						}
						if c7.Placement ~= nil then
							D7, _7 = pcall(S7.IsReadyToHatch, z7)
							if D7 and _7 then
								x7.Status = "Ready"
								x7.Remaining = 0
								x7.Percent = 100
							else
								x7.Status = "Growing"
								v7 = Z[34]
								if v7.Rec then
									H7 = Z[34]
									if H7.Rec.GrowthSecondsRemaining then
										local ZI, S7 =
											DI("GrowthSecondsRemaining", c7, o7, DI("GrowthSpeedMultiplier", c7) or 1)
												or 0,
											DI("GrowthDuration", c7) or 0
										x7.Remaining = ZI
										if S7 > 0 then
											x7.Percent = math.clamp(TI((1 - ZI / S7) * 100), 0, 100)
										end
									end
								end
							end
						end
						B7[#B7 + 1] = x7
					end
				end
				return B7
			end
			local function ZI(DI, x7)
				if x7 == "" then
					return true
				end
				local S7 = ((DI.Info.Name .. " " .. DI.Info.Rarity .. " " .. DI.Status):lower())
				for H7, H7 in ipairs(DI.Mutations) do
					S7 ..= " " .. tostring(H7):lower()
				end
				return S7:find(x7, 1, true) ~= nil
			end
			local function DI(x7, S7, H7)
				local _7, o7 = ""
				if #S7 > 0 then
					local B7 = {}
					for v7, z7 in ipairs(S7) do
						B7[v7] = tostring(Q[z7] or z7):gsub("%s*[Mm]utation$", ""):upper()
					end
					_7, o7 = table.concat(B7, H7 or " + "), cI[tostring(S7[1])] or zI
				else
				end
				h7(x7, _7)
				if o7 then
					if x7:GetAttribute("MutationKey") ~= _7 then
						x7:SetAttribute("MutationKey", _7);
						(x7:FindFirstChild("MutationPaint") or F(
							"UIGradient",
							{ Parent = x7, Name = "MutationPaint", Rotation = 90 }
						)).Color =
							o7
					end
				end
				return _7 ~= ""
			end
			local function zI(cI, x7, S7, H7, _7, o7)
				local B7 = e7(cI, nil, 1, x7, S7, H7, _7)
				local function cI(x7, S7)
					local H7 = u7(B7, 0, 0, 0, 1, { AutomaticSize = SI, LayoutOrder = x7, TextTruncate = xI })
					R7(H7, S7)
					return H7
				end
				return { Layout = A7(B7, 8, o7), Size = cI(1, VI), Weight = cI(2, II) }
			end
			local function cI(VI, II, x7, S7, H7)
				local _7 = J7(e7(VI, O(8, 8, 12), 0.15, II, x7, S7, H7, { ClipsDescendants = true }), 0.5)
				Y7(_7, hI, 1.5)
				II = J7(e7(_7, WI, 0, 0, 0, 0, 1), 0.5)
				VI = R7(II, gI, 0)
				J7(e7(II, WI, 0.78, 0, 0.08, 1, 0.34), 0.5)
				return { Fill = II, Gradient = VI, Text = u7(_7, 0, 0, 1, 1, { ZIndex = 3 }), Alpha = -1 }
			end
			local function VI(II, x7, S7)
				return NumberSequence.new({
					NumberSequenceKeypoint.new(0, 1),
					NumberSequenceKeypoint.new(II, x7),
					NumberSequenceKeypoint.new(1, S7),
				})
			end
			local function II(x7, S7, H7, _7, o7, B7)
				local v7 = F(
					"UIGradient",
					{ Parent = J7(e7(x7, mI, 0, 0, 0, 1, 1), S7), Rotation = 90, Transparency = VI(H7, _7, o7) }
				)
				f7(
					x7,
					0,
					0,
					0,
					0,
					1,
					1,
					"rbxassetid://90325592797235",
					{ ImageColor3 = O(40, 40, 60), ImageTransparency = 0.88, ScaleType = lI.ScaleType.Tile, TileSize = x(
						0.34,
						B7
					) }
				)
				return v7
			end
			local function x7(S7, H7, _7, o7, B7, v7)
				local z7 = e7(H7, mI, 0.45, 1, _7, o7, B7, { AnchorPoint = B(1, 1) })
				if v7 then
					F("UIAspectRatioConstraint", { Parent = z7 })
				end
				S7.CornerBack, S7.CornerStroke = J7(z7, 0.5), Y7(z7, LI, 1, 0.5)
				S7.Corner = f7(z7, 0.5, 0.5, 0.5, 0.5, 0.94, 0.94)
			end
			local function S7(H7)
				local _7 = {}
				local o7 = J7(e7(w7, mI, 0.04, 0, 0, 0, 0, { LayoutOrder = H7, Visible = false }), 0.07)
				_7.Frame, _7.Stroke = o7, Y7(o7, LI, 1.5)
				_7.Art = J7(e7(o7, WI, 0.1, 0, 0, 1, 0.55), 0.12)
				II(_7.Art, 0.12, 0.45, 0.86, 0, 0.42)
				_7.Image = f7(o7, 0.5, 0, 0.5, 0.025, 0.92, 0.52)
				x7(_7, o7, 0.555, 0.27, 0.19, true)
				H7 = J7(e7(o7, mI, 0.1, 0.04, 0.03, 0.25, 0.09), 0.35)
				F("UIStroke", { Parent = H7, Thickness = 1.5 })
				_7.Rank = u7(H7, 0, 0, 1, 1)
				_7.Mutation =
					u7(o7, 0.96, 0.035, 0.64, 0.08, { AnchorPoint = B(1, 0), TextXAlignment = lI.TextXAlignment.Right })
				_7.Name = u7(o7, 0.04, 0.565, 0.92, 0.085)
				_7.Rarity = u7(o7, 0.04, 0.648, 0.92, 0.062)
				_7.Value = u7(o7, 0.04, 0.712, 0.92, 0.088)
				R7(_7.Value, iI)
				_7.Stats = zI(o7, 0.04, 0.8, 0.92, 0.075, lI.HorizontalAlignment.Center)
				_7.Progress = cI(o7, 0.06, 0.888, 0.88, 0.085)
				_7.Select = e7(o7, nil, 1, 0, 0, 1, 1, { Visible = false })
				J7(_7.Select, 0.07)
				_7.SelectStroke = Y7(_7.Select, LI, 3)
				GI(_7.SelectStroke, "Divine")
				Q7(o7, { BackgroundTransparency = 1, Size = x(1, 1), ZIndex = 20 }).Activated:Connect(function()
					if _7.Id ~= nil then
						q7, sI = _7.Id, true
					end
				end)
				return _7
			end
			local function H7(_7)
				local o7 = _7.Stats
				L7(
					n7,
					{
						_7.Rank,
						0.062,
						_7.Mutation,
						0.06,
						_7.Name,
						0.078,
						_7.Rarity,
						0.056,
						_7.Value,
						0.082,
						o7.Size,
						0.062,
						o7.Weight,
						0.062,
						_7.Progress.Text,
						0.062,
					}
				)
				o7.Layout.Padding = OI(0, wI(4, TI(n7 * 0.03)))
				_7.Stroke.Thickness, _7.SelectStroke.Thickness, _7.CornerStroke.Thickness =
					wI(1.4, n7 * 0.007), wI(2.8, n7 * 0.014), wI(1, n7 * 0.0035)
			end
			local function _7(o7, B7)
				local v7, z7, c7 = B7.Info, tostring(B7.Id) .. "|" .. B7.Info.Category, false
				if o7.Key ~= z7 then
					o7.Key = z7
					g7(o7.Art, i7(v7), 90)
					t7(o7.Name, v7, true)
					t7(o7.Rarity, v7, false)
					GI(o7.Stroke, v7.Up == "DIVINE" and "Divine" or "Secret")
					o7.Image.Image, o7.Corner.Image = v7.Icon or B7.EggIcon, B7.EggIcon
					h7(o7.Name, v7.Name)
					h7(o7.Rarity, v7.Up)
					c7 = true
				else
				end
				m7(o7.CornerBack, B7.EggIcon ~= "" and v7.Icon ~= nil)
				return c7
			end
			local function GI(g7, i7)
				local t7, o7, B7 =
					g7.Progress, vI[i7.Status], i7.Status == "Growing" and math.clamp(i7.Percent / 100, 0.04, 1) or 1
				h7(g7.Value, "$" .. RI(i7.Income))
				h7(g7.Stats.Size, ("x%.2f"):format(i7.Scale))
				h7(g7.Stats.Weight, eI(i7.Weight))
				if t7.Style ~= o7 then
					t7.Style = o7
					t7.Gradient.Color = o7[1]
				end
				if math.abs(B7 - t7.Alpha) > 0.001 then
					t7.Alpha = B7
					t7.Fill.Size = x(B7, 1)
				end
				g7, B7 = t7.Text, i7.Status == "Ready" and "READY" or i7.Status ~= "Growing" and "IN BAG"
				h7(g7, B7 or i7.Remaining == 1 / 0 and "GROWING" or R(i7.Remaining) .. "  " .. i7.Percent .. "%")
			end
			local function g7(i7, t7, o7)
				i7.Id = t7.Id
				m7(i7.Frame, true)
				_7(i7, t7)
				h7(i7.Rank, "#" .. o7)
				DI(i7.Mutation, t7.Mutations, "\10")
				o7 = x(0.64, 0.07 * wI(1, #t7.Mutations))
				if i7.Mutation.Size ~= o7 then
					i7.Mutation.Size = o7
				end
				GI(i7, t7)
				m7(i7.Select, t7.Id == q7)
			end
			local function i7()
				local t7 = l7.Focus
				if not t7 or a7 then
					return
				end
				a7 = true
				local o7 = tostring(t7.Id)
				pcall(function()
					if t7.Status == "Inventory" then
						if
							not (
								pcall(function()
									local B7 = Z[34]
									return B7.Egg.WearEggTool(o7)
								end)
							)
						then
							local B7 = Z[9]
							B7("RF/EggWorld/AskWearTool", o7)
						end
					elseif t7.Status == "Ready" then
						local t7 = Z[75]
						if t7("RF/EggWorld/AskHatch", o7) then
							task.wait(0.35)
							local t7 = Z[9]
							t7("RF/EggWorld/AskFinishHatch", o7)
						end
					else
						local t7 = workspace:FindFirstChild("PlacedEggRenders")
						local B7
						local v7, z7 = ipairs, t7 and t7:GetChildren() or {}
						for c7, c7 in v7(z7) do
							if c7.Name:find(o7, 1, true) or c7:GetAttribute("Uid") == o7 then
								B7 = c7
								break
							end
						end
						v7, t7 = pcall(function()
							return B7:IsA("Model") and B7:GetPivot() or B7.CFrame
						end)
						if v7 then
							FI = t7.Position
						end
					end
				end)
				a7, sI = false, true
			end
			local function FI(a7)
				l7 = {}
				local t7, o7, B7 = J7(e7(nil, mI, 0.04, 0, 0, 1, 1, { Visible = false }), 0.1), l7, l7
				local v7 = Y7(t7, LI, 1.5)
				o7.Frame = t7
				B7.Stroke = v7
				o7 = e7(t7, WI, 0.1, 0, 0, 0.3, 1)
				l7.Art = o7
				F("UIAspectRatioConstraint", { Parent = o7, DominantAxis = lI.DominantAxis.Height })
				B7 = l7
				B7.Shade = II(J7(o7, 0.1), 0.1, 0.5, 0.82, 0.25, 0.34)
				B7 = l7
				B7.Rays = f7(o7, 0.5, 0.5, 0.5, 0.46, 1.9, 1.9, "rbxassetid://109516122757226")
				f7(
					o7,
					0.5,
					0.5,
					0.5,
					0.9,
					0.62,
					0.14,
					"rbxassetid://10822615828",
					{ ImageColor3 = O(20, 18, 34), ImageTransparency = 0.55, ScaleType = lI.ScaleType.Stretch }
				)
				B7 = l7
				B7.Image = f7(o7, 0.5, 0.5, 0.5, 0.47, 0.9, 0.9)
				x7(l7, o7, 1, 0.31, 0.31)
				o7 = e7(t7, nil, 1, 0, 0, 0.6, 1)
				v7, B7 = e7(o7, nil, 1, 0, 0.03, 0.72, 0.2, { ClipsDescendants = true }), l7
				B7.Body, B7.NameRow = o7, v7
				A7(v7, 10)
				B7 = l7
				B7.Name = u7(v7, 0, 0, 0, 1, { AutomaticSize = SI, LayoutOrder = 1, TextXAlignment = tI })
				B7 = l7
				B7.NameLimit = F("UISizeConstraint", { Parent = B7.Name, MaxSize = B(400, 400) })
				B7 = l7
				B7.Rarity = u7(
					v7,
					0,
					0.235,
					0,
					1,
					{ AutomaticSize = SI, LayoutOrder = 2, TextTruncate = xI, TextXAlignment = tI }
				)
				B7 = l7
				B7.Mutation = u7(o7, 0, 0.235, 1, 0.12, { TextTruncate = xI, TextXAlignment = tI })
				v7 = l7
				v7.Value = u7(o7, 0, 0.36, 1, 0.2, { TextXAlignment = tI })
				R7(l7.Value, iI)
				v7 = l7
				v7.Stats = zI(o7, 0, 0.57, 1, 0.14)
				B7 = l7
				B7.Progress = cI(o7, 0, 0.74, 1, 0.13)
				v7 = l7
				v7.Rank = u7(o7, 0, 0.885, 1, 0.11, { TextColor3 = kI, TextXAlignment = tI })
				B7 = Q7(
					o7,
					{
						AnchorPoint = B(1, 0),
						BackgroundColor3 = WI,
						BorderSizePixel = 0,
						Position = x(1, 0.03),
						Size = x(0.26, 0.2),
						ZIndex = 20,
					}
				)
				J7(B7, 0.24)
				Y7(B7, hI, 1.5, 0.2)
				v7 = l7
				v7.ActionGradient = R7(B7, gI)
				v7 = l7
				v7.ActionText =
					u7(B7, 0.5, 0.5, 1.02, 1.12, { AnchorPoint = B(0.5, 0.5), TextTruncate = xI, ZIndex = 21 })
				local function lI()
					task.spawn(i7)
				end
				B7.Activated:Connect(lI)
				P7:Attach(t7, a7)
			end
			local function lI(gI, xI, SI)
				local zI = jI.Spot and gI ~= nil
				m7(l7.Frame, zI)
				l7.Focus = zI and gI or nil
				local cI = zI and 7.6 or 0
				if l7.Dock ~= cI then
					l7.Dock = cI
					P7:SetDock(cI, { Gap = 0.35, Divider = false })
				end
				if not zI then
					return
				end
				if _7(l7, gI) then
					cI = gI.Info.Up == "SECRET"
					l7.Shade.Transparency = VI(0.5, cI and 0.92 or 0.82, cI and 0.72 or 0.25)
				end
				zI, cI = DI(l7.Mutation, gI.Mutations), l7.Rarity
				m7(l7.Mutation, zI)
				local DI = zI and l7.NameRow or l7.Body
				if cI.Parent ~= DI then
					cI.Parent, cI.Size = DI, x(0, zI and 1 or 0.12)
				end
				GI(l7, gI)
				zI = vI[gI.Status]
				if l7.ActionStyle ~= zI then
					DI = l7
					DI.ActionStyle, DI.ActionGradient.Color = zI, zI[1]
					h7(l7.ActionText, zI[2])
				end
				h7(l7.Rank, ("#%d of %d eggs  by %s"):format(xI, SI, jI.Sort:lower()))
			end
			local function gI(xI, SI)
				if xI <= 0 then
					return
				elseif SI <= 0 then
					return
				elseif M7 == xI then
					if Z7 == SI then
						return
					end
				end
				M7, Z7 = xI, SI
				local vI, zI, cI, DI =
					wI(8, TI(SI * 0.7)), wI(6, TI(SI * 0.45)), wI(4, TI(SI * 0.25)), wI(6, TI(xI * 0.012))
				local VI, II, GI, M7, Z7, a7, i7 = cI * 2 + DI, xI - cI * 2 - DI, r7, r7, l7.Frame, l7.Frame, H(cI, cI)
				local t7, x7, _7 = v(1, -VI, 0, 0), H(cI, cI), v(1, -VI, 1, -cI * 2)
				GI.Position = i7
				M7.Size = t7
				Z7.Position = x7
				a7.Size = _7
				i7 = math.clamp(TI((wI(1, II) + vI) / (SI * 8.2 + vI)), 4, 6)
				xI = TI((wI(1, II) - vI * (i7 - 1)) / i7)
				n7 = TI(xI * 1.42)
				a7, M7, DI, i7, _7, VI = W7, W7, E7, H(xI, n7), H(vI, vI), OI(0, vI)
				a7.CellSize = i7
				M7.CellPadding = _7
				DI.Padding = VI
				Z7, a7, GI, i7 = b7, F7, T7, s7
				Z7.Size, a7.Padding, GI.Size, i7.Padding =
					v(1, 0, 0, TI(SI * 2.9)), OI(0, zI), v(1, 0, 0, TI(SI * 2.1)), OI(0, zI)
				for vI, vI in ipairs(XI) do
					vI.Frame.Size, vI.Limit.MaxTextSize, vI.Value:FindFirstChildOfClass("UIStroke").Thickness =
						v(vI.Share, -math.ceil(zI * 4 / 5), 1, 0), wI(8, TI(SI * 1.25)), wI(1, SI * 1.25 * 0.08)
					k7(vI.Caption, SI * 0.74)
				end
				for vI, vI in ipairs(UI) do
					vI.Button.Size = v(0.25, -math.ceil(zI * 3 / 4), 1, 0)
					k7(vI.Text, SI * 0.92)
				end
				k7(y7, SI * 0.72)
				DI = y7
				DI.Size = v(1, 0, 0, TI(SI * 1.5))
				for vI, vI in ipairs(KI) do
					H7(vI)
				end
				zI, GI, DI = 7.6 * SI - cI * 2, l7.Stats, l7.ActionText
				M7 = wI(1, II - zI - SI * 1.1)
				l7.Body.Position, l7.Body.Size, l7.NameLimit.MaxSize =
					H(zI + SI * 0.7, 0), v(1, -(zI + SI * 1.1), 1, 0), B(wI(40, M7 * 0.72 * 0.62), zI)
				_7, x7, xI, t7, a7, SI, VI, i7 =
					{}, l7.Name, l7.Mutation, l7.Rarity, l7.Value, GI.Size, GI.Weight, l7.Progress.Text
				C:EH(_7, 0, x7, 0.16, xI, 0.1, t7, 0.1, a7, 0.18, SI, 0.105, VI, 0.105, i7, 0.105, l7.Rank, 0.105)
				L7(zI, _7)
				GI.Layout.Padding = OI(0, wI(6, TI(zI * 0.05)))
				k7(DI, math.min(zI * 0.2 * 0.52, M7 * 0.26 / 7))
				DI:FindFirstChildOfClass("UIStroke").Thickness = wI(1, DI.TextSize * 0.07)
				l7.Stroke.Thickness, l7.CornerStroke.Thickness = wI(1.2, zI * 0.008), wI(1, zI * 0.0045)
			end
			local function B(v)
				P7 = v
				r7 = F("Frame", { AutomaticSize = HI, BackgroundTransparency = 1, Size = x(1, 0) })
				E7 = F("UIListLayout", { Parent = r7, SortOrder = _I })
				b7 = e7(r7, nil, 1, 0, 0, 0, 0, { LayoutOrder = 1 })
				F7 = A7(b7)
				T7 = e7(r7, nil, 1, 0, 0, 0, 0, { LayoutOrder = 2 })
				s7 = A7(T7)
				w7 = e7(r7, nil, 1, 0, 0, 1, 0, { AutomaticSize = HI, LayoutOrder = 3 })
				W7 = F("UIGridLayout", { Parent = w7, SortOrder = _I })
				y7 = u7(r7, 0, 0, 0, 0, { LayoutOrder = 4, TextColor3 = kI })
				local x, OI =
					ipairs,
					{
						{ i.egg, uI(255, 255, 255, 190, 200, 225), "EGGS" },
						{ i.egg, BI[2][3], "READY" },
						{ i.night, BI[3][3], "GROWING" },
						{ "rbxassetid://70598530577515", BI[4][3], "IN BAG" },
						{ i.money, iI, "TOTAL / S" },
					}
				for uI, iI in x(OI) do
					local xI = J7(e7(b7, mI, 0.12, 0, 0, 0, 0, { LayoutOrder = uI }), 0.22)
					Y7(xI, LI, 1.2)
					f7(xI, 0, 0.5, 0.04, 0.5, 0.28, 0.78, iI[1])
					local SI = u7(xI, 0.33, 0.06, 0.65, 0.54, { TextScaled = true, TextXAlignment = tI })
					R7(SI, iI[2])
					XI[uI] = {
						Frame = xI,
						Value = SI,
						Caption = u7(
							xI,
							0.33,
							0.58,
							0.65,
							0.36,
							{ TextColor3 = kI, TextXAlignment = tI, Text = iI[3] }
						),
						Share = uI == 5 and 0.28 or 0.18,
						Limit = F("UITextSizeConstraint", { Parent = SI, MinTextSize = 6 }),
					}
				end
				for uI, iI in ipairs(BI) do
					x = Q7(T7, { BackgroundColor3 = WI, BorderSizePixel = 0, LayoutOrder = uI })
					J7(x, 0.3)
					OI =
						{ Key = iI[1], Title = iI[2], Button = x, Stroke = Y7(x, LI, 1.2), Gradient = R7(x, iI[3]), Text = u7(
							x,
							0,
							0,
							1,
							1
						) }
					x.Activated:Connect(function()
						jI.Filter = iI[1]
						sI = true
					end)
					UI[uI] = OI
				end
				FI(v:Dock())
				v:Attach(r7, v:Root())
				v:OnResize(function(x, x, v)
					pcall(gI, x, v)
				end)
			end
			local function x()
				local v
				task.spawn(function()
					local OI, FI = pcall(NI)
					if OI then
						v = FI
					end
				end)
				if v then
					C7, v = v, v
				else
					v = C7
				end
				local OI, FI, uI, gI, iI = { All = #v, Ready = 0, Growing = 0, Inventory = 0 }, jI.Sort, v, 0
				for tI, tI in ipairs(uI) do
					OI[tI.Status] += 1
					gI, iI = gI + tI.Income, if iI then if tI.Income > iI.Income then tI else iI else tI
				end
				for tI, xI in ipairs(BI) do
					h7(XI[tI].Value, tostring(OI[xI[1]]))
				end
				h7(XI[5].Value, "$" .. RI(gI))
				for gI, gI in ipairs(UI) do
					uI = jI.Filter == gI.Key
					h7(gI.Text, gI.Title .. "  " .. OI[gI.Key])
					if gI.Active ~= uI then
						gI.Active, gI.Gradient.Enabled, gI.Button.BackgroundColor3, gI.Button.BackgroundTransparency, gI.Text.TextColor3, gI.Stroke.Color =
							uI, uI, uI and WI or mI, uI and 0 or 0.15, uI and WI or kI, uI and hI or LI
					end
				end
				table.sort(v, function(hI, mI)
					if FI == oI[2] then
						if hI.Info.RarityNumber ~= mI.Info.RarityNumber then
							return hI.Info.RarityNumber > mI.Info.RarityNumber
						end
					end
					if FI == oI[3] then
						if hI.Remaining ~= mI.Remaining then
							return hI.Remaining < mI.Remaining
						end
					end
					if hI.Income ~= mI.Income then
						return hI.Income > mI.Income
					end
					return tostring(hI.Id) < tostring(mI.Id)
				end)
				local FI, hI, mI = P7:Query():lower(), {}, v
				for kI, kI in ipairs(mI) do
					if jI.Filter == "All" or kI.Status == jI.Filter then
						if ZI(kI, FI) then
							hI[#hI + 1] = kI
						end
					end
				end
				mI, OI = v
				uI = 0
				for ZI, kI in ipairs(mI) do
					if kI.Id == q7 then
						OI, uI = kI, ZI
						break
					end
					if kI == iI then
						OI, uI = kI, ZI
					else
					end
				end
				lI(OI, uI, #v)
				mI, uI = #hI, 0
				for ZI = 1, mI, 1 do
					OI = KI[ZI]
					if OI then
					else
						if uI >= 12 then
							sI = true
							mI = ZI - 1
							break
						end
						uI += 1
						OI = S7(ZI)
						KI[ZI] = OI
						if n7 > 0 then
							H7(OI)
						end
					end
					g7(OI, hI[ZI], ZI)
				end
				for ZI = mI + 1, #KI, 1 do
					m7(KI[ZI].Frame, false)
					KI[ZI].Id = nil
				end
				mI, OI = y7, #v == 0 and "No eggs yet" or #hI > 0 and ""
				h7(mI, OI or FI ~= "" and ('No eggs match "%s"'):format(FI) or "No eggs in this filter")
				m7(y7, y7.Text ~= "")
			end
			local v, OI = dI["Egg Predictor"], PI.Predictor.page
			v:Dropdown("Sort By", oI, oI[1], function(ZI)
				if table.find(oI, ZI) then
					jI.Sort = ZI
					sI = true
				end
			end)
			v:Toggle("Preview Card", true, function(ZI)
				jI.Spot = ZI == true
				sI = true
			end)
			v:Surface({
				Name = "Egg Predictor",
				Search = true,
				SearchPlaceholder = "Search eggs...",
				Layout = "free",
				OnSearch = function()
					sI = true
				end,
				Style = AI(34),
				Build = function(v)
					B(v)
					sI = true
				end,
			})
			W(y, function(B)
				local v = EI.IsShown(OI) and OI.AbsoluteSize.X > 0
				local OI = v and r7 ~= nil and EI.IsShown(r7)
				if OI then
					if not p7 then
						sI = true
					end
				end
				p7 = OI
				if not v then
					return
				end
				if OI then
					if l7.Frame.Visible then
						d7 += B
						if d7 >= 0.05 then
							l7.Rays.Rotation = (l7.Rays.Rotation + d7 * 6) % 360
							d7 = 0
						end
					end
				end
				O7 += B
				if OI and sI or O7 >= 1 then
					O7 = 0
					if OI then
						sI = false
						pcall(x)
					end
					pcall(aI)
				end
				JI()
			end)
		end
		do
			local x, B, v, OI, ZI, PI, lI, FI =
				"#9FB8FF", "#4DFF7A", "#FFC24D", "#FFFFFF", "#CDE7FF", "#FFDF8A", 2.9, 0.0909
			local uI = EI.Paint
			local hI = EI.Bold
			local mI = EI.Escape
			local kI = EI.MutationText
			local LI = EI.Separator()
			local gI, iI, tI, xI =
				YI(0, 255, 255, 255, 0.5, 222, 238, 255, 1, 255, 255, 255),
				3.15,
				{
					0,
					"#8F98A8",
					0.3,
					"#C6CDDA",
					0.85,
					"#FFFFFF",
					1.45,
					"#7CFF9E",
					1.9,
					"#4FE0FF",
					2.85,
					"#6FA0FF",
					3.8,
					"#C08BFF",
					5.8,
					"#FF9A3D",
					9.5,
					"#FF5C5C",
					12,
					"#FFD34D",
					20,
					"#FF4DE8",
				}
			local YI, SI, HI, _I, oI, BI, vI = {}, {}, {}, {}, 0, 0, 0.06
			local zI = -1
			local cI = -1
			local DI, NI, VI, II, jI, KI = -1, 4, 3, false, 0
			local XI, UI = 0.01, 150
			local function GI(C7, O7)
				return hI(uI(C7, O7))
			end
			local function hI(C7)
				return ("%.2fx"):format(C7)
			end
			local function C7(O7)
				return ("%.2fx - %.2fx"):format(O7.Min, O7.Max)
			end
			local function O7(p7, M7)
				local Z7 = Z[22]
				local n7 = Z7("Rec", "WeightKgForScale", p7, M7)
				return type(n7) == "number" and n7 > 0 and n7 or nil
			end
			local function p7(M7)
				return M7 and LI .. uI(ZI, eI(M7)) or ""
			end
			local function M7(Z7)
				local n7 = "#FFFFFF"
				for d7 = 1, #tI, 2 do
					n7 = if Z7 + 0.001 >= tI[d7] then tI[d7 + 1] else n7
				end
				return n7
			end
			local function tI()
				if KI then
					local Z7 = KI
					return Z7
				end
				local Z7, n7 = pcall(function()
					local d7 = Z[34]
					return (debug.getupvalues or getupvalues)(d7.Rec.DrawAssetScale)
				end)
				local d7, q7 = pairs, Z7 and type(n7) == "table" and n7 or {}
				for P7, r7 in d7(q7) do
					if type(r7) == "table" then
						if type(r7.SCALE_BANDS) == "table" then
							P7, n7, Z7 =
								r7.SCALE_BANDS,
								tonumber(r7.SCALE_DOUBLING_ODDS) or XI,
								tonumber(r7.SCALE_HARD_CAP) or UI
							KI, XI, UI = P7, n7, Z7
							break
						end
						if type(r7[1]) == "table" then
							if r7[1].min then
								if r7[1].weight then
									KI = r7
									break
								end
							end
						end
					end
				end
				if not KI then
					n7 = {
						0.85,
						1.05,
						2000,
						1.45,
						1.55,
						250,
						1.9,
						2.1,
						125,
						2.85,
						3.15,
						62.5,
						3.8,
						4.2,
						31.25,
						0.3,
						0.45,
						18,
						0.1,
						0.2,
						5,
						5.8,
						6.2,
						15.625,
						9.5,
						12.5,
						3,
						12,
						17,
						0.05,
						20,
						35,
						1.0E-4,
					}
					KI = {}
					q7 = #n7
					for Z7 = 1, q7, 3 do
						d7 = KI
						d7[#d7 + 1] = { min = n7[Z7], max = n7[Z7 + 1], weight = n7[Z7 + 2] }
					end
				end
				q7 = KI
				return q7
			end
			local function KI(Z7, n7, d7)
				local q7 = Z[22]
				local P7 = q7("Fuse", "BandWeightBias", Z7, n7, d7)
				if type(P7) == "number" then
					return P7
				end
				P7 = 0.6931471805599453
				return math.exp(math.log((Z7[1] + Z7[2] + Z7[3]) / 3) / P7 * (math.log((n7 + d7) / 2) / P7) * 0.6)
			end
			local function Z7()
				local n7 = Z[67]
				local d7 = n7()
				if not d7 then
					return
				end
				local q7, P7, r7, w7 = pI(d7.FusionSlots), pI(d7.Inventory), {}, d7.FusionEggReward
				for b7 = 1, 3, 1 do
					n7 = P7[q7[b7]]
					if type(n7) == "table" then
						r7[#r7 + 1] = {
							Category = n7.Category,
							Scale = tonumber(n7.Scale) or 1,
							Mutations = pI(n7.Mutations),
							Raw = n7,
						}
					end
				end
				return {
					Items = r7,
					Locked = d7.FusionLocked == true,
					Duration = tonumber(d7.FusionDuration) or 0,
					Reward = w7,
					Result = type(w7) == "table" and type(w7.Egg) == "table" and w7.Egg or nil,
				}
			end
			local function n7(d7)
				local q7 = d7.Get()
				if BI > 0 then
					if q7.Text == tostring(d7.Spec.Text or "") then
						return q7
					end
				end
				II = true
			end
			local function d7(q7)
				local P7 = n7(q7)
				if not P7 then
					return
				end
				local r7, w7 = P7.Size, P7.TextWrapped
				P7.TextWrapped = false
				P7.Size = H(100000, wI(1, r7.Y.Offset))
				q7 = P7.TextBounds.X
				P7.Size = r7
				P7.TextWrapped = w7
				if q7 > 0 then
					P7 = BI
					return q7 / P7
				end
				II = true
			end
			local function q7(P7, r7)
				local w7 = n7(P7)
				if not w7 then
					return
				end
				P7 = w7.Size
				w7.Size = H(wI(1, TI(r7 * BI + 0.5)), 100000)
				r7 = w7.TextBounds.Y
				w7.Size = P7
				if r7 > 0 then
					P7 = BI
					return r7 / P7
				end
				II = true
			end
			local function H(TI, n7, P7, r7, w7)
				local b7, T7 =
					xI,
					{
						Parent = TI,
						X = n7,
						Width = P7,
						Height = P7,
						Corner = 0.35,
						Background = "#000000",
						BackgroundTransparency = r7,
						StrokeThickness = FI,
						StrokeTransparency = 0,
						ZIndex = w7,
					}
				return b7:Image(T7)
			end
			local function TI(FI, n7, P7, r7)
				local w7, b7 =
					xI,
					{
						Parent = FI,
						X = n7,
						Width = P7,
						Height = 1.2,
						Scale = 1.2,
						Wrap = false,
						Gradient = gI,
						TextStrokeTransparency = 1,
						ZIndex = r7,
					}
				return w7:Text(b7)
			end
			local function FI(gI, n7, P7, r7, w7)
				local b7, T7 =
					xI,
					{
						Parent = gI,
						X = n7,
						Width = P7,
						Height = 1.2,
						Scale = 0.936,
						Wrap = false,
						Font = EI.RarityFont,
						TextStrokeTransparency = 1,
						StrokeTransparency = 0.08,
						StrokeThickness = w7,
						ZIndex = r7,
					}
				return b7:Text(T7)
			end
			local function gI(n7, P7)
				n7.Set({ Visible = P7.Icon ~= nil, Image = P7.Icon or "", StrokeColor = P7.Color })
			end
			local function n7(P7, r7)
				local w7 = r7.Up == "SECRET" and EI.SecretGradient or r7.Gradient
				P7.Set({
					Text = r7.Up,
					Color = w7 ~= nil and WI or r7.Color,
					Gradient = w7,
					GradientRotation = r7.Up == "SECRET" and EI.SecretRotation or nil,
				})
			end
			local function WI(P7)
				local r7 = xI:Frame({
					Name = "Slot",
					Background = "#000000",
					BackgroundTransparency = 0.74,
					Corner = 0.35,
					Width = 1,
					Height = 1,
					Visible = false,
				})
				local w7, b7 =
					{ Frame = r7, Icon = H(r7, 0.25, 2.3, 0.45), Name = TI(r7, iI, 1), Rarity = FI(r7, iI, 1, nil, vI) },
					xI
				w7.Detail =
					b7:Text({ Parent = r7, X = iI, Y = 1.2, Width = wI(1, oI - lI - 0.5), Height = 1, Wrap = true })
				w7.Status = xI:Text({ Parent = r7, Width = 1, Height = 1.2, Wrap = false, Align = "Right", Color = x })
				SI[P7] = w7
				return w7
			end
			local function P7()
				if oI <= 0 then
					return
				end
				II = false
				local r7, w7 = wI(1, oI - 5.8), d7(YI.Rarity)
				if w7 then
					VI = w7 + 0.1
				end
				w7 = d7(YI.Name)
				if w7 then
					NI = math.min(w7 + 0.1, wI(1, r7 - VI - 0.24))
				end
				YI.Name.Set({ Width = NI })
				local b7, T7 = YI.Rarity.Set, { X = 5.8 + NI + 0.24 }
				T7.Width = wI(0.5, math.min(VI, r7 - NI - 0.24))
				b7(T7)
				YI.Info.Set({ Width = r7 })
				T7, b7 = wI(1, oI - lI - 0.5), 0
				for lI, NI in ipairs(_I) do
					if NI.Handle then
						r7 = NI.Gap and 0.5 or 0
						w7 = q7(NI.Handle, oI)
						if w7 then
							NI.Height = w7
						end
						lI = wI(1, NI.Height or 1)
						NI.Handle.Set({ Y = b7 + r7, Width = oI, Height = lI })
						b7 += lI + 0.11 + r7
					else
						local lI = NI.Slot
						w7 = q7(lI.Detail, T7)
						if w7 then
							lI.DU = w7
						end
						local NI = math.clamp(lI.DU or 1, 1, 4)
						w7 = d7(lI.Status)
						if w7 then
							lI.SU = w7 + 0.23
						end
						local VI = math.min(T7 * 0.42, wI(2.73, lI.SU or 2.73))
						local q7 = wI(1, T7 - VI - 0.24)
						w7 = d7(lI.Rarity)
						if w7 then
							lI.RU = w7 + 0.1
						end
						local r7 = math.min(lI.RU or 3, q7 * 0.5)
						w7 = d7(lI.Name)
						if w7 then
							lI.NU = w7 + 0.1
						end
						local d7, w7 = math.min(wI(1, lI.NU or 4), wI(1, q7 - r7 - 0.24)), wI(NI + 1.2, 2.3) + 0.36
						q7 = (w7 - NI - 1.2) / 2
						lI.Frame.Set({ Y = b7, Width = oI, Height = w7 })
						local y7, l7 = lI.Icon.Set, {}
						l7.Y = (w7 - 2.3) / 2
						y7(l7)
						lI.Name.Set({ Y = q7, Width = d7 })
						lI.Rarity.Set({ X = iI + d7 + 0.24, Y = q7, Width = wI(0.5, r7) })
						lI.Detail.Set({ Y = q7 + 1.2, Width = T7, Height = NI })
						lI.Status.Set({ X = iI + T7 - VI, Y = q7, Width = wI(0.5, VI) })
						b7 += w7 + 0.22
					end
				end
				b7 = wI(1, b7)
				if math.abs(b7 - DI) > 0.01 then
					DI = b7
					xI:SetContentLines(b7)
				end
			end
			local function lI(iI, DI)
				local NI = iI ~= nil
				xI:SetDock(NI and 5 or 0, { Gap = 0.22 })
				for VI, VI in next, YI, nil do
					VI.Set({ Visible = NI })
				end
				if not NI then
					return
				end
				gI(YI.Icon, iI)
				local VI, d7 = YI.Name.Set, {}
				d7.Text = mI(iI.Name)
				VI(d7)
				n7(YI.Rarity, iI)
				d7, VI = DI.Result, #DI.Items
				NI = uI(OI, ("Fusing %d of 3 pets"):format(VI))
				if d7 then
					NI = (GI(B, "Result locked in, claim it at the machine"))
				else
					if DI.Reward then
						NI = (GI(B, "Fuse finished, claim your egg"))
					else
						if DI.Locked then
							local q7 = DI.Duration > 1000000000 and DI.Duration - J() or 0
							NI = GI(v, q7 > 0 and "Fusing" .. LI .. EI.FormatClock(q7) or "Fusing")
						else
						end
					end
				end
				local EI, q7, r7 = d7 and (tonumber(d7.AssetScale) or 1), YI.Info.Set, {}
				r7.Text = GI(B, RI(d7 and fI(iI, EI, d7.Mutations) or fI(iI, DI.Items[1].Scale, DI.Items[1].Mutations)))
					.. "\10"
					.. uI(OI, d7 and ("%.2fx fused egg"):format(EI) or ("%d/3 loaded"):format(VI))
					.. "\10"
					.. NI
				q7(r7)
			end
			aI = function()
				if not xI then
					return
				end
				jI = 2
				table.clear(_I)
				local EI, aI = 0, 0
				local function iI(DI, NI)
					EI += 1
					local VI = HI[EI]
					if VI then
					else
						VI = xI:Text({ Name = "Line", Width = 1, Height = 1, Wrap = true, Visible = false })
						HI[EI] = VI
					end
					VI.Set({ Visible = true, Text = DI })
					_I[#_I + 1] = { Handle = VI, Gap = NI }
				end
				local function DI(NI, VI)
					iI(GI(VI, NI), #_I > 0)
				end
				local function NI(VI)
					iI(uI(x, VI))
				end
				local function VI(d7, q7)
					iI(uI(x, d7) .. "  " .. q7)
				end
				local function d7(q7)
					VI("Species", GI(q7.Hex, "[" .. q7.Up .. "]") .. " " .. GI(OI, mI(q7.Name)))
				end
				local q7 = Z7()
				if q7 then
					if q7.Result then
						local Z7 = q7.Result
						local r7, w7, b7 = QI(Z7.AssetCategory), tonumber(Z7.AssetScale) or 1, pI(Z7.Mutations)
						lI(r7, q7)
						DI("FUSE RESULT (CONFIRMED)", B)
						d7(r7)
						VI("Size", GI(M7(w7), hI(w7)) .. p7(O7(Z7.AssetCategory, w7)))
						Z7 = kI(b7)
						VI("Mutation", Z7 ~= "" and Z7 or uI(OI, "Normal"))
						VI("Income", GI(B, RI(fI(r7, w7, b7))))
						NI("The server picks this egg when the fuse starts, it will not change")
					else
						if #q7.Items == 0 then
							lI()
							iI(GI(OI, "Machine is empty"))
							NI("Load 3 pets of the same species to see the result odds")
						else
							local pI = q7.Items
							local Z7, r7 = pI[1].Category, QI(pI[1].Category)
							lI(r7, q7)
							DI(("FUSE MACHINE STATUS (%d/3 PETS)"):format(#pI), OI)
							d7(r7)
							for QI = 1, 3, 1 do
								local d7, w7 = pI[QI], SI[QI] or WI(QI)
								w7.Frame.Set({ Visible = true })
								w7.Status.Set({ Text = "SLOT " .. QI })
								if d7 then
									gI(w7.Icon, r7)
									local WI, gI = w7.Name.Set, {}
									gI.Text = mI(r7.Name)
									WI(gI)
									n7(w7.Rarity, r7)
									local WI, mI, gI = kI(d7.Mutations), w7.Detail.Set, {}
									gI.Text = GI(PI, hI(d7.Scale))
										.. p7(O7(d7.Category, d7.Scale))
										.. LI
										.. GI(B, RI(fI(r7, d7.Scale, d7.Mutations)))
										.. LI
										.. (WI ~= "" and WI or uI(x, "Normal"))
									mI(gI)
								else
									w7.Icon.Set({ Visible = false })
									w7.Name.Set({ Text = uI(x, "Empty") })
									w7.Rarity.Set({ Text = "" })
									w7.Detail.Set({ Text = uI(x, "Add a pet to this slot") })
								end
								_I[#_I + 1] = { Slot = w7 }
								aI = QI
							end
							local WI = 0
							for QI, QI in ipairs(pI) do
								WI += QI.Scale
							end
							local QI = WI / #pI
							VI("Average Scale", GI(PI, hI(QI)) .. p7(O7(Z7, QI)))
							DI("PREDICTED SIZE PROBABILITIES", B)
							if #pI == 3 then
								local PI, WI, hI, mI = { pI[1].Scale, pI[2].Scale, pI[3].Scale }, {}, {}, 0
								for kI, gI in ipairs(tI()) do
									kI = gI.weight * KI(PI, gI.min, gI.max)
									mI += kI
									local tI, _I = #WI + 1, { Min = gI.min, Max = gI.max, Weight = kI }
									_I.Color, WI[tI] = M7(gI.min), _I
								end
								table.sort(WI, function(kI, gI)
									return kI.Weight > gI.Weight
								end)
								for kI, gI in ipairs(WI) do
									local tI, _I, KI =
										mI > 0 and gI.Weight / mI * 100 or 0, O7(Z7, gI.Min), O7(Z7, gI.Max)
									kI, PI = GI(gI.Color, C7(gI)), _I and KI
									local gI, O7 =
										PI and LI .. uI(ZI, eI(_I) .. " - " .. eI(KI)) or "",
										tI >= 10 and B or tI >= 1 and v
									iI(kI .. gI .. LI .. GI(O7 or x, (tI >= 1 and "%.1f%%" or "%.3f%%"):format(tI)))
								end
								VI(
									"Size Doubling",
									GI(v, ("%.2f%%"):format(XI * 100))
										.. uI(x, (" per roll, x2 again and again up to %dx"):format(UI))
								)
								local ZI, eI = 0, 0
								for kI, gI in ipairs(WI) do
									PI, kI = mI > 0 and gI.Weight / mI or 0, wI(gI.Max - gI.Min, 1.0E-9)
									local mI, tI = math.clamp((gI.Max - QI) / kI, 0, 1), XI
									ZI += PI * (mI + tI * (math.clamp((gI.Max - QI / 2) / kI, 0, 1) - mI))
									tI = (gI.Min + gI.Max) / 2
									kI, mI = (1 - XI) * fI(r7, tI), XI
									gI = mI * fI(r7, math.min(tI * 2, UI))
									eI = eI + PI * (kI + gI)
								end
								DI("RESULT PREDICTION", OI)
								VI("Bigger Than Average Input", GI(ZI >= 0.5 and B or v, ("%.1f%%"):format(ZI * 100)))
								VI("Expected Income", GI(B, RI(eI)))
								VI("Mutation", uI(OI, "Normal, input mutations are not kept"))
								for OI, ZI in ipairs(pI) do
									hI[OI] = ZI.Raw
								end
								PI = Z[22]
								local OI = PI("Fuse", "PriceFor", hI)
								if type(OI) == "number" then
									VI("Fuse Cost", GI(v, (RI(OI):gsub("/s$", ""))))
								end
								hI = WI[1]
								if hI then
									VI(
										"Estimated Value",
										GI(B, RI(fI(r7, hI.Min)) .. " ~ " .. RI(fI(r7, hI.Max)))
											.. LI
											.. uI(x, "at ")
											.. GI(hI.Color, C7(hI))
									)
									for v, v in ipairs(WI) do
										hI = if v.Max > hI.Max then v else hI
									end
									VI("Best Case", GI(hI.Color, C7(hI)) .. "  " .. GI(B, RI(fI(r7, hI.Max))))
								end
							else
								NI(("Load %d more of the same species to see the odds"):format(3 - #pI))
							end
						end
					end
				else
					lI()
					iI(GI(x, "Fuse machine data is not available yet"))
				end
				q7 = EI + 1
				for x = q7, #HI, 1 do
					HI[x].Set({ Visible = false })
				end
				for x = aI + 1, #SI, 1 do
					SI[x].Frame.Set({ Visible = false })
				end
				P7()
				jI = 2
			end
			JI = function()
				if jI > 0 or II then
					if jI > 0 then
						jI -= 1
					end
					pcall(P7)
				end
			end
			dI["Fuse Predictor"]:Surface({
				Name = "Fuse Predictor",
				Layout = "free",
				Style = AI(42),
				Build = function(x)
					xI = x
					x:SetDock(5, { Gap = 0.22, DividerColor = O(170, 174, 184) })
					local O = x:Dock()
					YI.Icon, YI.Name, YI.Rarity, YI.Info =
						H(O, nil, 5, 0.26, 8),
						TI(O, 5.8, nil, 9),
						FI(O, 5.8, nil, 9),
						x:Text({ Parent = O, X = 5.8, Y = 1.2, Height = 3.8, Wrap = false, ZIndex = 9 })
					x:OnResize(function(O, O, H)
						if O == zI then
							if H == cI then
								return
							end
						end
						local B, v = O / wI(H, 1), 0.9 / wI(x:TextSize(), 1)
						zI, cI, oI, BI, jI, vI = O, H, B, H, 2, v
						YI.Rarity.Set({ StrokeThickness = vI })
						for O, O in ipairs(SI) do
							O.Rarity.Set({ StrokeThickness = vI })
						end
					end)
					sI = true
				end,
			})
		end
	end)
	w("22_prio#1", function()
		local O = Color3.fromRGB
		local x = UDim2.fromOffset
		local H = UDim2.fromScale
		local B, v = UDim2.new, Enum
		local OI = Color3.new(1, 1, 1)
		local pI = Color3.new(0, 0, 0)
		local ZI = O(62, 64, 84)
		local PI = Vector2.new(0.5, 0.5)
		local wI = Vector2.new(0, 0.5)
		local TI = Vector2.new(1, 0.5)
		local lI, WI = v.TextXAlignment.Center, {}
		C:EH(WI, 0, O(150, 255, 110), O(40, 200, 60))
		local EI = {}
		C:EH(EI, 0, O(70, 72, 90), O(46, 48, 62))
		local FI = {}
		C:EH(FI, 0, O(96, 100, 124), O(52, 54, 70))
		local sI = {}
		C:EH(
			sI,
			0,
			{ O(255, 240, 150), O(255, 176, 30) },
			{ O(245, 248, 255), O(160, 170, 190) },
			{ O(255, 200, 150), O(190, 110, 50) }
		)
		local aI = {}
		aI.TextColor3 = O(196, 202, 222)
		aI.TextTruncate = v.TextTruncate.AtEnd
		local JI = Font.new("rbxassetid://12187365977", v.FontWeight.Bold)
		local YI, RI = Font.new("rbxasset://fonts/families/GothamSSm.json", v.FontWeight.Medium), {}
		local eI, fI, QI =
			{ "StealFilter", "Steal Filter Eggs", i.egg, 77, 255, 122, "Steal:filter" },
			{ "Butterfly", "Butterfly Bloom", i.net, 120, 230, 255, "Bloom" },
			{ "Place", "Auto Place Egg", i.pet, 255, 194, 77 }
		C:EH(
			RI,
			0,
			eI,
			{ "Star", "Shooting Star", "rbxassetid://118070800707365", 255, 238, 140 },
			{ "Skyfall", "Skyfall", "rbxassetid://83094668121358", 120, 160, 255 },
			{ "Storm", "Storm Rush", "rbxassetid://83094668121358", 150, 200, 255 },
			{ "Market", "Black Market", "rbxassetid://110752639580758", 255, 90, 90 },
			{ "Eclipse", "Cosmic Eclipse", "rbxassetid://93377699933947", 199, 125, 255 },
			{ "Relic", "Alien Relics", "rbxassetid://99395515128275", 181, 255, 165 },
			fI,
			{ "StealWisp", "Steal Wisp Quest Eggs", "rbxassetid://117266037162644", 150, 255, 220, "Steal:wisp" },
			{ "StealIndex", "Steal Missing Index Eggs", "rbxassetid://72512465543867", 127, 216, 255, "Steal:index" },
			QI,
			{ "Essence", "Auto Mutate", i.essence, 90, 235, 255, "Mutate" },
			{ "Fish", "Alien Fishing", "rbxassetid://99395515128275", 120, 200, 255 },
			{ "Treadmill", "Treadmill", "rbxassetid://116351329433541", 255, 140, 70 }
		)
		local eI, fI, uI, AI, hI, mI, kI, LI, gI, iI, tI, xI, SI, HI, _I, oI, BI, vI, zI =
			{}, {}, "ChilliLibrary/SAE_Priority.json", {}, false, 0
		for cI, DI in ipairs(RI) do
			eI[cI], fI[DI[1]] = DI[1], DI
		end
		local cI, DI = {}, Z[20]
		DI.rank = cI
		local function DI(NI)
			for VI, II in ipairs(NI) do
				cI[fI[II][7] or II] = VI
			end
			cI["Steal:pick"], cI.Combat = 0, cI.Treadmill - 0.5
			cI.Machine, cI.WispGo = cI.Bloom + 0.1, cI["Steal:wisp"] + 0.1
			NI = Z[20]
			cI.Steal = #NI.pick > 0 and 0 or math.min(cI["Steal:index"], cI["Steal:wisp"], cI["Steal:filter"])
		end
		local function cI(NI, VI, II)
			local jI = Instance.new(NI)
			for NI, KI in next, II, nil do
				jI[NI] = KI
			end
			jI.Parent = VI
			return jI
		end
		local function NI(VI, II, jI)
			local KI = VI:FindFirstChild("Paint") or cI("UIGradient", VI, { Name = "Paint" })
			KI.Color, KI.Rotation = ColorSequence.new(II[1], II[2]), jI or 90
			return KI
		end
		local function VI(II, jI, KI)
			KI.BorderSizePixel = 0
			return cI(II, jI, KI)
		end
		local function II(jI, KI)
			cI("UICorner", jI, { CornerRadius = UDim.new(KI, 0) })
		end
		local function jI(KI, XI, UI, GI)
			return cI(
				"UIStroke",
				KI,
				{ Color = XI or pI, Thickness = UI or 1.5, Transparency = GI or 0, ApplyStrokeMode = v.ApplyStrokeMode.Border }
			)
		end
		local function KI(XI, UI)
			cI("UIStroke", XI, { Color = pI, Thickness = UI, LineJoinMode = v.LineJoinMode.Round })
		end
		local function pI(XI, UI, GI)
			local C7 = cI(
				"TextLabel",
				XI,
				{
					BackgroundTransparency = 1,
					TextColor3 = OI,
					TextXAlignment = v.TextXAlignment.Left,
					TextYAlignment = v.TextYAlignment.Center,
					TextScaled = true,
					Text = "",
					FontFace = UI,
				}
			)
			for XI, UI in next, GI, nil do
				C7[XI] = UI
			end
			cI("UITextSizeConstraint", C7, { MaxTextSize = 18, MinTextSize = 1 })
			return C7
		end
		local function XI(UI, GI)
			UI:FindFirstChildOfClass("UITextSizeConstraint").MaxTextSize = GI
		end
		local function UI(GI)
			for C7, O7 in next, AI, nil do
				local p7 = LI[C7]
				NI(O7.Badge, sI[p7] or FI)
				O7.Number.Text, O7.Title.Text = tostring(p7), fI[C7][2]
				O7.Stroke.Color, O7.Stroke.Transparency, O7.Paint.Enabled =
					p7 == 1 and OI or ZI, p7 == 1 and 0 or 0.2, p7 == 1
				O7.Glow.BackgroundTransparency = C7 == zI and os.clock() < mI and 0.55 or 0.82
				local FI, M7 = ipairs, O7.Btn
				for Z7, n7 in FI(M7) do
					local d7 = Z7 == 1 and p7 > 1 or Z7 == 2 and p7 < #kI
					n7.b.Active, n7.b.BackgroundTransparency = d7, d7 and 0 or 0.55
					NI(n7.b, d7 and WI or EI)
					for EI, EI in ipairs(n7) do
						EI.BackgroundColor3 = d7 and OI or O(128, 132, 150)
					end
					n7.s.Visible = d7
				end
				M7 = BI
				FI = x(vI, M7 + (p7 - 1) * (_I + oI))
				if GI then
					if hI then
						d("TweenService"):Create(
							O7.Frame,
							TweenInfo.new(0.22, v.EasingStyle.Quad, v.EasingDirection.Out),
							{ Position = FI }
						):Play()
					else
						O7.Frame.Position = FI
					end
				else
					O7.Frame.Position = FI
				end
				O7.Frame.ZIndex = C7 == zI and 2 or 1
			end
		end
		local function EI(FI, GI, C7)
			local function O7(p7)
				return math.floor(C7 * p7)
			end
			local p7, M7, Z7, n7, d7, q7 = math.max(160, GI), O7(3.1), O7(5.2), math.max(6, O7(0.45)), O7(2.9), O7(0.45)
			vI, _I, oI = n7, d7, q7
			BI = vI + M7 + oI
			d7, q7, GI, n7 = p7 - vI * 2 - math.max(4, O7(0.3)), iI, iI, x(vI, vI)
			p7 = x(d7, M7)
			q7.Position = n7
			GI.Size = p7
			p7 = SI
			p7.Size = x(Z7, O7(1.9))
			n7 = tI
			n7.Size = B(0, d7 - Z7 - vI, 0, math.floor(M7 * 0.56))
			q7, n7, p7, GI = xI, xI, x(0, math.floor(M7 * 0.58)), B(0, d7 - Z7 - vI, 0, math.floor(M7 * 0.36))
			q7.Position = p7
			n7.Size = GI
			XI(tI, O7(1.45))
			XI(xI, O7(0.82))
			XI(HI, O7(0.95))
			Z7, GI, q7, n7 = math.floor(_I * 0.56), math.floor(_I * 0.74), math.floor(_I * 0.6), O7(0.6)
			M7 = n7 + Z7 + GI + O7(1.1)
			p7 = math.max(20, d7 - M7 - q7 * 2 - O7(1.5))
			for P7, P7 in next, AI, nil do
				P7.Frame.Size, P7.Badge.Size, P7.Badge.Position = x(d7, _I), x(Z7, Z7), B(0, n7, 0.5, 0)
				P7.IconBack.Size, P7.IconBack.Position = x(GI, GI), B(0, n7 + Z7 + O7(0.5), 0.5, 0)
				P7.Title.Position, P7.Title.Size = B(0, M7, 0.14, 0), B(0, p7, 0.42, 0)
				P7.Sub.Position, P7.Sub.Size = B(0, M7, 0.56, 0), B(0, p7, 0.3, 0)
				XI(P7.Title, O7(1.1))
				XI(P7.Sub, O7(0.78))
				XI(P7.Number, math.floor(Z7 * 0.7))
				P7.Holder.Position = B(1, -n7, 0.5, 0)
				P7.Holder:FindFirstChildOfClass("UIListLayout").Padding = UDim.new(0, O7(0.4))
				for XI, XI in ipairs(P7.Btn) do
					XI.b.Size = x(q7, q7)
				end
			end
			UI(false)
			hI = true
			d7 = BI
			GI, O7 = d7 + #kI * (_I + oI) + vI, gI
			O7.Size = B(1, 0, 0, GI)
			FI:SetContentLines(GI / C7)
		end
		local function FI(hI, _I)
			local oI, BI = {}, {}
			for vI, vI in ipairs(type(hI) == "table" and hI or {}) do
				if fI[vI] then
					if not BI[vI] then
						BI[vI] = true
						oI[#oI + 1] = vI
					end
				end
			end
			for vI, XI in ipairs(eI) do
				if not BI[XI] then
					hI = 1
					for BI = vI - 1, 1, -1 do
						local vI = table.find(oI, eI[BI])
						if vI then
							hI = vI + 1
							break
						end
					end
					table.insert(oI, hI, XI)
				end
			end
			kI, LI = oI, {}
			for hI, BI in ipairs(oI) do
				LI[BI] = hI
			end
			if _I then
				return
			end
			M.wr(uI, M.enc({ Version = 2, Order = oI, Fish2 = true, Ecl2 = true }))
			if gI then
				pcall(UI, true)
			end
			pcall(function()
				DI(oI)
				local hI = Z[20]
				if hI.order then
					local hI = Z[20]
					hI.order()
				end
			end)
		end
		local function hI(_I)
			local oI, BI = fI[_I], { Btn = {} }
			local fI = O(oI[4], oI[5], oI[6])
			BI.Frame = VI("Frame", gI, { BackgroundColor3 = O(18, 18, 26), BackgroundTransparency = 0.05 })
			II(BI.Frame, 0.22)
			BI.Stroke = jI(BI.Frame, ZI)
			BI.Paint = NI(BI.Stroke, sI[1], 45)
			BI.Glow = VI("Frame", BI.Frame, { BackgroundColor3 = fI, BackgroundTransparency = 0.82, Size = H(1, 1) })
			II(BI.Glow, 0.22)
			local ZI, sI = BI.Glow, {}
			sI.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(0.45, 0.7),
				NumberSequenceKeypoint.new(1, 1),
			})
			cI("UIGradient", ZI, sI)
			cI(
				"ImageLabel",
				BI.Frame,
				{
					BackgroundTransparency = 1,
					Image = "rbxassetid://90325592797235",
					ImageTransparency = 0.94,
					ScaleType = v.ScaleType.Tile,
					TileSize = x(46, 46),
					Size = H(1, 1),
				}
			)
			BI.Badge = VI("Frame", BI.Frame, { AnchorPoint = wI, BackgroundColor3 = OI })
			II(BI.Badge, 0.3)
			jI(BI.Badge)
			BI.Number = pI(BI.Badge, JI, { Size = H(1, 1), TextXAlignment = lI })
			KI(BI.Number, 1.6)
			BI.IconBack =
				VI("Frame", BI.Frame, { AnchorPoint = wI, BackgroundColor3 = fI, BackgroundTransparency = 0.72 })
			II(BI.IconBack, 0.28)
			jI(BI.IconBack, fI, 1, 0.45)
			cI(
				"ImageLabel",
				BI.IconBack,
				{
					AnchorPoint = PI,
					BackgroundTransparency = 1,
					Image = oI[3],
					Position = H(0.5, 0.5),
					ScaleType = v.ScaleType.Fit,
					Size = H(0.82, 0.82),
				}
			)
			BI.Title = pI(BI.Frame, JI, {})
			KI(BI.Title, 1.5)
			BI.Sub = pI(BI.Frame, YI, aI)
			BI.Holder = cI(
				"Frame",
				BI.Frame,
				{ AnchorPoint = TI, AutomaticSize = v.AutomaticSize.XY, BackgroundTransparency = 1 }
			)
			cI(
				"UIListLayout",
				BI.Holder,
				{
					FillDirection = v.FillDirection.Horizontal,
					VerticalAlignment = v.VerticalAlignment.Center,
					SortOrder = v.SortOrder.LayoutOrder,
				}
			)
			for x = 1, 2, 1 do
				local v = VI(
					"TextButton",
					BI.Holder,
					{ AutoButtonColor = false, BackgroundColor3 = OI, LayoutOrder = x, Text = "" }
				)
				fI = { b = v }
				II(v, 0.32)
				jI(v)
				for wI = 1, 2, 1 do
					ZI = wI == 1
					sI = cI(
						"Frame",
						v,
						{
							AnchorPoint = PI,
							BackgroundTransparency = 1,
							Position = B(0.5, 0, 0.5, ZI and 2 or 0),
							Size = H(0.56, 0.56),
							ZIndex = ZI and 2 or 3,
						}
					)
					for oI = 1, 2, 1 do
						wI = VI(
							"Frame",
							sI,
							{
								AnchorPoint = PI,
								BackgroundColor3 = ZI and O(18, 92, 30) or OI,
								Position = H(oI == 1 and 0.31 or 0.69, 0.5),
								Rotation = (oI == 1 and -45 or 45) * (x == 1 and 1 or -1),
								Size = B(0.64, 0, 0.22, 0),
								ZIndex = ZI and 2 or 3,
							}
						)
						II(wI, 1)
						if not ZI then
							fI[oI] = wI
						end
					end
					if ZI then
						fI.s = sI
					end
				end
				BI.Btn[x] = fI
				v.Activated:Connect(function()
					local B = LI[_I]
					local ZI = x == 1 and B - 1 or B + 1
					if v.Active then
						if not kI[ZI] then
							return
						end
					else
						return
					end
					local x = table.clone(kI)
					x[B] = x[ZI]
					x[ZI] = _I
					FI(x)
					x = nil
					x, zI = os.clock() + 0.7, _I
					mI = x
					UI(true)
					task.delay(0.75, function()
						if zI == _I then
							if os.clock() >= mI then
								pcall(UI, false)
							end
						end
					end)
				end)
			end
			AI[_I] = BI
		end
		RI = M.dec(M.rd(uI))
		local x, B = type(RI) == "table" and RI.Version == 2 and type(RI.Order) == "table", Z[20]
		B.treadLast = function()
			local B = table.clone(kI)
			local v = table.find(B, "Treadmill")
			if v then
				if v < #B then
					table.remove(B, v)
					B[#B + 1] = "Treadmill"
					FI(B)
				end
			end
		end
		local function B(v, ZI, PI, wI)
			local sI = table.find(v, ZI)
			if sI then
				table.remove(v, sI)
				local sI = table.find(v, PI)
				local PI, fI = table.insert, sI and (wI and sI + 1 or sI)
				PI(v, fI or #v + 1, ZI)
			end
		end
		if x and not (RI.Fish2 and RI.Ecl2) then
			QI = table.clone(RI.Order)
			if not RI.Fish2 then
				B(QI, "Fish", "Treadmill")
			end
			B(QI, "Eclipse", "Star", true)
			FI(QI)
		else
			FI(x and RI.Order, true)
		end
		dI.Priority:Surface({
			Name = "Task Priority",
			ShowTitle = false,
			Layout = "free",
			Style = {
				TextScale = 1,
				LineHeight = 1.1,
				MinLines = 6,
				MaxLines = 40,
				BackgroundTransparency = 1,
				TextColor = OI,
				TextStrokeTransparency = 0.7,
			},
			Build = function(x)
				gI = cI("Frame", nil, { BackgroundTransparency = 1, Size = H(1, 0) })
				iI = cI("Frame", gI, { BackgroundTransparency = 1 })
				tI = pI(iI, JI, { Text = "TASK PRIORITY" })
				NI(tI, WI)
				KI(tI, 2)
				xI = pI(iI, YI, aI)
				xI.Text = "Top goes first. A carried egg is always delivered first."
				SI = VI(
					"TextButton",
					iI,
					{ AnchorPoint = TI, AutoButtonColor = false, BackgroundColor3 = OI, Position = H(1, 0.5), Text = "" }
				)
				II(SI, 0.35)
				jI(SI)
				NI(SI, { O(255, 196, 60), O(255, 60, 40) })
				HI = pI(SI, JI, { Text = "RESET", Size = H(1, 1), TextXAlignment = lI })
				KI(HI, 1.5)
				SI.Activated:Connect(function()
					zI, mI = nil, 0
					FI(eI)
				end)
				local O = kI
				for H, H in ipairs(O) do
					hI(H)
				end
				x:Attach(gI, x:Root())
				x:OnResize(function(O, x, H)
					EI(O, x, math.max(8, H))
				end)
			end,
		})
		local O, x =
			{ pick = "picked egg", index = "missing index egg", wisp = "wisp egg", filter = "filter egg", wait = "egg at daybreak" },
			{
				Skyfall = "Skyfall",
				Storm = "Storm Rush",
				Market = "Black Market",
				Relic = "Alien Relics",
				Fish = "Alien Fishing",
				Star = "Shooting Star",
				Place = "Auto Place Egg",
				Mutate = "Auto Mutate",
				Bloom = "Butterfly Bloom",
				WispGo = "Wisp quest",
				Machine = "Butterfly machine",
				IslandWars = "Cursed Island Wars",
				Capture = "Capture The Egg",
				Stage = "Wait for the field",
				NightHome = "Night, safe zone",
				GoTo = "Go to egg",
				Combat = "Auto hit",
				Banjo = "Banjo cricket",
			}
		local H = N("prio", dI.Priority:Text("Task Queue", "Idle"))
		local function B(v, OI)
			if v.name == "Steal" then
				local pI
				if OI then
					pI = OI
				else
					local OI = Z[20]
					pI = OI.stealKind
				end
				return "Steal " .. (O[pI] or "egg")
			end
			return x[v.name] or v.name
		end
		local O = G({ name = "PrioInfo", gap = 1, info = true })
		O.on = function()
			local x = rI("Farm")
			local v
			if x then
				v = x
			else
				local x = Z[25]
				v = x.farmHud
			end
			return v
		end
		O.fn = function()
			local O = Z[20]
			local x, v, OI, pI = O.queue or {}, {}, Z[4]
			if OI then
				pI = OI
			else
				local ZI, ZI = Z[20], os.clock() - (Z[20].mvEnd or 0) < 2
				if ZI then
					O = Z[20]
					pI = O.lastMV
				else
					pI = ZI
				end
			end
			OI, O = pI or nil, ipairs
			for ZI, PI in O(x) do
				if PI ~= OI then
					if PI.name ~= "Stage" then
						if PI.name ~= "NightHome" then
							local wI, TI, lI = #v + 1, PI.name == "Steal"
							if TI then
								ZI = Z[20]
								lI = ZI.stealNext
							else
								lI = TI
							end
							v[wI] = B(PI, lI or nil)
						end
					end
				end
			end
			x, pI = OI
				and B(OI, OI.name == "Steal" and type(OI.plan) == "table" and OI.plan.kind or nil)
					.. (OI.idle and " (waiting)" or "")
			if x then
				pI = x
			else
				OI = nil
				OI, pI = Z[20], os.clock() - (Z[20].treadAt or 0) < 3 and "Treadmill"
			end
			O, OI, x = pI or "Idle", Z[20], Z[20]
			OI.doing = O
			x.next = v
			H(
				"Doing now: "
					.. O
					.. " | Next 1: "
					.. (v[1] or "Nothing")
					.. " | Next 2: "
					.. (v[2] or "--")
					.. " | Next 3: "
					.. (v[3] or "--")
					.. (#v > 3 and " +" .. #v - 3 or "")
			)
		end
		DI(kI)
	end)
	local function O(x)
		local H, B, v = ipairs, {}, Z[1]
		C:EH(B, 0, v.Character or (t()), t())
		for v, v in H(B) do
			for H, H in ipairs(v and v:GetChildren() or {}) do
				if H:IsA("Tool") then
					if x(H) then
						return H
					end
				end
			end
		end
	end
	local x, H = {}, {}
	local B, v = -1000000000, false
	Z[20].weaponId, Z[20].weaponName = {}, {}
	Z[20].wVer = 0
	local function OI(pI, ZI, PI)
		if x[pI] == nil then
			H[#H + 1] = pI
		end
		x[pI] = ZI
		local ZI, wI = Z[20]
		wI, ZI.weaponName[pI], Z[20].weaponId[PI] = Z[20], PI, pI
		wI = Z[20]
		wI.wVer = wI.wVer + 1
	end
	local function pI()
		if v then
			return
		elseif os.clock() - B < 5 then
			return
		end
		B = os.clock()
		local B = Z[34]
		local ZI, PI = B.Gears
		if ZI then
			B = Z[34]
			PI = B.Gears.Directory
		else
			PI = ZI
		end
		if type(PI) ~= "table" then
			return
		end
		for B, wI in next, PI, nil do
			ZI = type(wI) == "table" and wI.BatControllerData
			if ZI or type(wI) == "table" and wI.ToolController == "Slap" or tostring(B):lower():find("scrambl") then
				OI(B, ZI and tonumber(ZI.RangeBonus) or -1, type(wI) == "table" and wI.DisplayName or B)
			end
		end
		table.sort(H, function(B, ZI)
			return x[B] > x[ZI] or x[B] == x[ZI] and B < ZI
		end)
		v = #H > 0
	end
	pI()
	local function B(v)
		return v:GetAttribute("GearName") or v.Name
	end
	Z[20].ownedWeapons = function()
		pI()
		local v = Z[67]
		local ZI = v()
		local v, PI, wI, TI, lI =
			type(ZI) == "table" and type(ZI.GearInventory) == "table" and table.clone(ZI.GearInventory) or {},
			{},
			ipairs,
			{},
			Z[1]
		C:EH(TI, 0, lI.Character, t())
		for ZI, ZI in wI(TI) do
			for TI, TI in ipairs(ZI and ZI:GetChildren() or {}) do
				if TI:IsA("Tool") then
					lI = B(TI)
					v[lI] = true
					if x[lI] == nil then
						if TI:GetAttribute("IsBat") == true then
							OI(lI, 0, lI)
						end
					end
				end
			end
		end
		lI = ipairs
		for OI, OI in lI(H) do
			if v[OI] then
				wI = nil
				wI, PI[#PI + 1] = Z[20], Z[20].weaponName[OI]
			end
		end
		return PI
	end
	local function v(OI)
		local ZI, PI = x[B(OI)] ~= nil or OI:GetAttribute("IsBat") == true
		if ZI then
			PI = ZI
		else
			local ZI = OI:GetAttribute("ItemType")
			PI = (if ZI then not ZI else not OI:GetAttribute("GearName"))
				and (OI.Name:lower():find("bat") or OI.Name:lower():find("sword") or OI.Name:lower():find("hammer"))
		end
		return PI
	end
	Z[20].scrambler = function(OI)
		return OI and x[B(OI)] == -1
	end
	local function OI(ZI)
		return J() >= (tonumber(ZI:GetAttribute("CooldownEndTime")) or 0)
	end
	local ZI = { i = 1, at = 0 }
	Z[20].bat = function()
		pI()
		local pI, PI, wI, TI = {}, ipairs, {}, Z[1]
		C:EH(wI, 0, TI.Character or (t()), t())
		TI = nil
		local lI = -2
		for WI, EI in PI(wI) do
			local FI, sI = ipairs, EI and EI:GetChildren() or {}
			for aI, JI in FI(sI) do
				if JI:IsA("Tool") then
					if v(JI) then
						WI, aI = x[B(JI)] or 0, Z[25]
						if aI.weap then
							EI = Z[25]
							if EI.weap[B(JI)] then
								if not pI[B(JI)] then
									pI[B(JI)] = JI
								end
							end
						end
						if WI >= 0 then
							if TI then
								if WI > lI then
									TI, lI = JI, WI
								else
								end
							else
								TI, lI = JI, WI
							end
						else
						end
					else
					end
				else
				end
			end
		end
		PI = {}
		for v, v in ipairs(H) do
			if pI[v] then
				PI[#PI + 1] = pI[v]
			end
		end
		if #PI == 0 then
			return TI, math.max(lI, 0)
		end
		if #PI > 1 then
			if ZI.i > #PI then
				ZI.i = 1
			end
			local H, v, lI, WI = ZI.i % #PI + 1, os.clock() - ZI.at, ZI.i == 2
			if lI then
				TI = Z[25]
				WI = TI.swapT2
			else
				WI = lI
			end
			lI = nil
			if WI then
				lI = WI
			else
				wI = Z[25]
				lI = wI.swapT
			end
			WI, pI = v >= (lI or 0.35)
			if WI then
				pI = WI
			else
				v = OI(PI[ZI.i])
				pI = if v then not v else OI(PI[H])
			end
			if pI then
				ZI.i, ZI.at = H, os.clock()
			end
		else
			ZI.i = 1
		end
		wI = PI[ZI.i]
		return wI, math.max(x[B(wI)] or 0, 0)
	end
	w("31_bloom#1", function()
		local x, H =
			{ Radiant = "Golden", Amethyst = "Purple", Sapphire = "Blue", Emerald = "Green" },
			{ Green = 1, Blue = 2, Purple = 3, Golden = 4 }
		local B = G({ name = "Bloom", mover = true, gap = 1, pri = 5, soft = true })
		local v, OI, pI =
			dI["Butterfly Bloom"],
			{
				{ "Green", "rbxassetid://107744695034799", "#5BE873" },
				{ "Blue", "rbxassetid://89995151383384", "#5FA2FF" },
				{ "Purple", "rbxassetid://121235713836098", "#C27BFF" },
				{ "Golden", "rbxassetid://98126365702697", "#FFD452" },
				{ "Essence", "rbxassetid://114750647204247", "#6FF0FF" },
			},
			{ texts = {}, shown = {} }
		v:Surface({
			Name = "Butterflies",
			ShowTitle = false,
			Layout = "free",
			Style = {
				TextScale = 1,
				LineHeight = 1.1,
				MinLines = 3.3,
				MaxLines = 3.3,
				AutoHeight = true,
				BackgroundTransparency = 0.35,
				TextColor = Color3.fromRGB(255, 255, 255),
				TextStrokeTransparency = 0.7,
			},
			Build = function(ZI)
				pI.st = ZI:Text({
					X = 0.7,
					Y = 0.15,
					Width = 1,
					Height = 1.1,
					Scale = 1,
					Wrap = false,
					Text = "Off",
					Color = "#FFFFFF",
					TextStrokeTransparency = 0.6,
				})
				local PI, wI = {}, 24
				for TI, lI in ipairs(OI) do
					local WI = 0.7 + (TI - 1) * 4.7
					PI[TI] =
						ZI:Image({ X = WI, Y = 1.35, Width = 1.85, Height = 1.85, Image = lI[2], BackgroundTransparency = 1 })
					pI.texts[lI[1]] = ZI:Text({
						X = WI + 2.05,
						Y = 1.6,
						Width = 3,
						Height = 1.35,
						Scale = 1.2,
						Wrap = false,
						Text = "0",
						Color = lI[3],
						TextStrokeTransparency = 0.6,
					})
				end
				ZI:SetContentLines(3.3)
				function pI.lay()
					local TI, lI = {}, 0
					for WI, EI in ipairs(OI) do
						TI[WI] = 2.05 + #(pI.shown[EI[1]] or "0") * 0.62
						lI += TI[WI]
					end
					local WI, EI = math.max(0.5, (wI - 1.4 - lI) / (#OI - 1)), 0.7
					for lI, FI in ipairs(OI) do
						PI[lI].Set({ X = EI })
						local OI, PI = pI.texts, FI[1]
						local FI, sI = OI[PI].Set, { X = EI + 2.05 }
						sI.Width = TI[lI] - 2.05 + 0.3
						FI(sI)
						EI += TI[lI] + WI
					end
				end
				local OI
				ZI:OnResize(function(ZI, ZI, PI)
					if ZI ~= OI then
						OI = ZI
						wI = ZI / math.max(PI, 1)
						pI.lay()
					end
				end)
			end,
		})
		local OI = j(v, "Auto Butterfly Bloom", "bloom", false, function(ZI)
			if not ZI then
				CI(B)
			end
		end)
		K(v, "Catch Mode", "bfMode", { "Stand", "Chase", "Circle", "Patrol" }, "Stand", nil, false, nil, OI)
		K(v, "Catch Priority", "bfPri", { "Rarest", "Nearest" }, "Rarest", nil, false, "Only for Chase mode", OI)
		local ZI = { Golden = true, Purple = true, Blue = true, Green = true }
		v:Dropdown(
			"Catch Butterflies",
			{ "Radiant Butterfly", "Amethyst Butterfly", "Sapphire Butterfly", "Emerald Butterfly" },
			{ "Radiant Butterfly", "Amethyst Butterfly", "Sapphire Butterfly", "Emerald Butterfly" },
			function(PI)
				ZI = {}
				for wI, TI in ipairs(PI) do
					wI = x[TI:match("^(%a+)")]
					if wI then
						ZI[wI] = true
					end
				end
			end,
			true,
			"Only for Chase mode",
			OI
		)
		X(v, "Tween Speed  ", "bfSpeed", 100, 600, 320, "studs/s", 10, nil, nil, OI)
		local PI, wI, TI = {}, ipairs, { "Spawned", "Escaped" }
		for lI, WI in wI(TI) do
			v = Z[39]
			lI = v:FindFirstChild("RE/Butterflies/" .. WI)
			if lI then
				W(lI.OnClientEvent, function(lI, WI)
					local EI = type(lI) == "table" and lI or type(WI) == "table" and WI
					if EI then
						if EI.Id then
							PI[EI.Id] = EI
						end
					end
				end)
			end
		end
		OI = Z[39]
		v = OI:FindFirstChild("RE/Butterflies/Removed")
		if v then
			W(v.OnClientEvent, function(lI)
				PI[lI] = nil
			end)
		end
		local lI, WI = 14, 0
		pcall(function()
			lI = tonumber(require(P.Shared.Flags.ButterflyFlags).NetReach:Get()) or lI
		end)
		local function EI()
			local FI = tonumber(workspace:GetAttribute("ButterflyBloomEndsAt"))
			return workspace:GetAttribute("Event_ButterflyBloom") == true and (if FI then J() < FI else not FI)
		end
		local function FI()
			local sI = tonumber(workspace:GetAttribute("ButterflyBloomEndsAt"))
			return math.min(sI and sI - J() or 1 / 0, o())
		end
		local function sI()
			local aI = Z[15]
			local JI, YI, RI = aI(), FI() > 25
			if YI then
				RI = YI
			else
				if JI then
					aI = nil
					aI, RI = Z[28], (JI.Position - Z[28](7240, 74, -364)).Magnitude < 300
				else
					RI = JI
				end
			end
			return RI
		end
		local function aI()
			local JI = Z[54]
			return JI("Areas", "ButterflyBloom", "Bounds")
		end
		local function JI()
			local YI = Z[67]
			local RI = YI()
			return RI and type(RI.Butterflies) == "table" and RI.Butterflies or {}
		end
		local function YI()
			local RI, eI = JI().NetClaimed == true
			if RI then
				eI = RI
			else
				local RI = Z[1]
				eI = RI:GetAttribute("EnchantedTreeUnlocked") == true
			end
			return eI
		end
		local RI = Z[20]
		RI.bloomWants = function()
			local RI = Z[25]
			return RI.bloom and EI() and sI() and YI()
		end
		local function RI(eI)
			local fI = Z[20]
			fI.bfSay = eI
		end
		local function eI(fI)
			return fI:GetAttribute("ButterflyNet") == true
				or fI:GetAttribute("ItemType") == "ButterflyNet"
				or fI.Name == "Butterfly Net"
		end
		local fI = RaycastParams.new()
		fI.FilterType = Enum.RaycastFilterType.Exclude
		local function QI(uI)
			local AI, hI = {}, Z[1]
			C:EH(AI, 0, hI.Character, workspace:FindFirstChild("ButterflyBloomSwarm"))
			fI.FilterDescendantsInstances = AI
			local mI, mI, mI, kI = Z[28], Z[28], workspace:Raycast(uI + Z[28](0, 25, 0), Z[28](0, -120, 0), fI), Z[8]
			AI = kI()
			kI = nil
			if mI then
				hI = Z[28]
				kI = hI(uI.X, mI.Position.Y + (AI and AI.HipHeight or 2) + 1, uI.Z)
			else
				kI = mI
			end
			return kI or uI
		end
		local function fI(uI)
			local AI = Z[54]
			local hI = AI("Machines", "ButterflyStation", uI)
			uI = hI and (hI:FindFirstChild("Anchor") or hI)
			return uI and (uI:IsA("BasePart") and uI.Position or uI:IsA("Model") and uI:GetPivot().Position)
		end
		local function uI(AI, hI)
			local mI, mI = Z[1], Z[1]
			pcall(Z[1].RequestStreamAroundAsync, Z[1], AI)
			local mI, kI, LI = Z[26], Z[27], Z[28]
			mI(kI(AI + LI(0, 3, 4)))
			kI = os.clock() + 0.6
			while os.clock() < kI and (hI()) do
				local hI, mI, kI = Z[26], Z[27], Z[28]
				hI(mI(AI + kI(0, 3, 4)))
				LI = Z[23]
				LI()
			end
		end
		local function AI(hI)
			local mI = Z[20]
			if mI.hideTread then
				local kI = Z[20]
				kI.hideTread(20)
			end
			if Z[13](hI) then
				mI = Z[14]
				if not (mI(hI)) then
					return false
				end
			else
				return false
			end
			mI = Z[15]
			local kI, LI = mI(), Z[47]
			local gI, gI = Z[28], LI() + Z[28](0, 3, 0)
			if kI then
				mI = Z[16]
				if mI(kI.Position) then
					if (kI.Position - gI).Magnitude > 6 then
						LI = Z[53]
						return LI(gI, hI, 250)
					end
				end
			end
			return true
		end
		local function hI(mI, kI)
			local LI = Z[1]
			local gI = LI.Character
			local function iI()
				local tI = kI()
				local kI
				if tI then
					local xI = Z[1]
					kI = xI.Character == gI
				else
					kI = tI
				end
				return kI
			end
			LI = Z[15]
			local kI = LI()
			if kI then
				LI = Z[16]
				if LI(kI.Position) then
					if not (AI(iI)) then
						return false
					end
				end
			end
			kI = Z[20]
			return kI.reach(mI, iI)
		end
		local function mI(kI)
			local LI = fI("NetStand")
			if LI then
				local gI = Z[20]
				if not (gI.enterTree(kI)) then
					return false
				end
			else
				return false
			end
			local gI = false
			for iI = 1, 5, 1 do
				if not (kI()) then
					break
				end
				uI(LI, kI)
				iI = Z[9]
				local kI, tI = iI("RF/Butterflies/AskClaimNet")
				gI = kI and tI == true
				if gI then
					break
				end
				task.wait(0.8)
			end
			LI = Z[20]
			LI.leaveTree()
			return gI or JI().NetClaimed == true
		end
		local kI
		pcall(function()
			kI = require(P.Controllers.Game.AdminAbuseClientController.Events.ButterflyBloom.Swarm)
		end)
		local function LI(gI, iI)
			local tI, xI
			local SI = Z[34]
			local HI, _I, oI = SI.Cat, J(), {}
			local function BI(vI, zI, cI)
				if typeof(cI) ~= "Vector3" then
					return
				else
					local DI = ZI
					if not DI[zI.Tier] then
						return
					end
				end
				local ZI, ZI, ZI =
					Z[25],
					Z[25],
					(cI - gI).Magnitude / Z[25].bfSpeed
						- (Z[25].bfPri ~= "Nearest" and (H[zI.Tier] or 0) * 1000 or 0)
						- (vI == iI and 1 or 0)
				if if tI then ZI < xI else not tI then
					tI, xI = { id = vI, p = cI, f = zI }, ZI
				end
			end
			if kI then
				if kI.Each then
					pcall(function()
						local H = kI
						for ZI, kI in H.Each() do
							local H, gI = type(kI) == "table" and kI.Flight, type(kI) == "table" and kI.Body
							if type(H) == "table" then
								if typeof(gI) == "Instance" then
									kI = H.Id or ZI
									oI[kI] = true
									BI(
										kI,
										H,
										gI:IsA("BasePart") and gI.Position or gI:IsA("Model") and gI:GetPivot().Position
									)
								end
							end
						end
					end)
				end
			end
			if HI and not next(oI) then
				for H, ZI in next, PI, nil do
					if not oI[H] then
						local PI, kI = pcall(HI.PositionAt, ZI, _I)
						if PI then
							BI(H, ZI, kI)
						end
					end
				end
			end
			if tI then
				local H, ZI = pcall(HI and HI.VelocityAt, tI.f, _I)
				local PI, kI = H and typeof(ZI) == "Vector3"
				if PI then
					SI = Z[28]
					kI = SI(ZI.X, 0, ZI.Z)
				else
					kI = PI
				end
				PI = nil
				if kI then
					PI = kI
				else
					H = Z[33]
					PI = H
				end
				tI.v = PI
			end
			return tI
		end
		B.want = function()
			if not (EI()) then
				return RI("Waiting for the next Butterfly Bloom")
			end
			if not (YI()) then
				return RI("Needs the Enchanted Tree for the net, finish the wisp quest")
			end
			if o() <= 0 then
				return RI("Night, waiting")
			end
			if not (sI()) then
				local H = C[20](math.max(FI(), 0))
				return RI(("Bloom ends in %ds, not worth the trip"):format(C:QH(H)))
			end
			return aI() or true
		end
		B.run = function(H, ZI)
			local PI = Z[20]
			if not (PI.needBody()) then
				local FI = Z[20]
				if FI.hideTread then
					local FI = Z[20]
					FI.hideTread(20)
				end
				return
			end
			PI = Z[8]
			local FI = PI()
			if not JI().NetClaimed then
				RI("Claiming the butterfly net")
				if Z[13](ZI) then
					if not (mI(ZI)) then
						return RI("Could not claim the net")
					end
				else
					return RI("Could not claim the net")
				end
			end
			local sI, aI = typeof(H) == "Instance" and H.Position
			if sI then
				aI = sI
			else
				H = Z[28]
				aI = (H(7240, 74, -364))
			end
			PI = Z[15]
			local YI = PI()
			local mI
			if YI and (YI.Position - aI).Magnitude > 300 then
				if os.clock() < WI then
					return RI("Ragdoll TP did not land, trying again soon")
				end
				pcall(FI.UnequipTools, FI)
				if not (AI(ZI)) then
					return RI("Stuck on treadmill")
				end
				PI = Z[15]
				YI = PI()
				if YI then
					sI = Z[16]
					if sI(YI.Position) then
						H = Z[17]
						if not (H(ZI, "Butterfly bloom")) then
							return
						end
					end
				end
				if not (AI(ZI)) then
					return RI("Stuck on treadmill")
				end
				local kI = Z[28]
				local gI, iI = QI(aI + kI(0, 0, 6)), Z[1]
				local kI = iI.Character
				local function tI()
					local xI = ZI()
					local SI
					if xI then
						local HI = Z[1]
						SI = HI.Character == kI
					else
						SI = xI
					end
					return SI
				end
				iI = false
				for xI = 1, 2, 1 do
					RI(("Ragdoll TP to the bloom (try %d/2)"):format(xI))
					iI = MI(function()
						return gI
					end, tI)
					if iI then
						break
					elseif not (tI()) then
						break
					end
					task.wait(0.5)
				end
				tI = Z[1]
				if tI.Character ~= kI then
					return RI("Reset, going back to the safe zone")
				end
				iI = iI or (if ZI() then if hI({ Pos = gI, Name = "the bloom" }, ZI) then true else iI else iI)
				tI = Z[1]
				if tI.Character ~= kI then
					return RI("Reset, going back to the safe zone")
				end
				if not iI then
					WI = os.clock() + 10
					return RI("Ragdoll TP did not land, trying again soon")
				end
				mI = YI
			else
				mI = YI
			end
			local WI, YI, kI, gI = os.clock(), os.clock(), 0, Z[61]
			local iI, tI =
				W(gI.Stepped, function()
					local xI = Z[25]
					if xI.bfMode ~= "Stand" then
						return
					elseif os.clock() - kI < 0.5 then
						return
					end
					kI = os.clock()
					local kI, SI = ipairs, C[20](q:GetPlayers())
					for HI, HI in kI(C:QH(SI)) do
						xI = Z[1]
						for kI, kI in ipairs(HI ~= xI and HI.Character and HI.Character:GetChildren() or {}) do
							if kI:IsA("BasePart") then
								if kI.CanCollide then
									kI.CanCollide = false
								end
							end
						end
					end
				end), math.huge
			local kI = os.clock()
			local function xI(SI)
				if SI.Magnitude < tI - 2 or SI.Magnitude < 8 then
					local HI, _I, oI = SI.Magnitude, os
					oI, tI = _I.clock(), HI
					kI = oI
					return
				end
				if os.clock() - kI > 1.5 then
					tI = 1 / 0
					local kI, tI = Z[26], Z[27]
					kI(tI(mI.Position + SI.Unit * math.min(30, SI.Magnitude) + Z[28](0, 6, 0)))
				end
			end
			PI, gI = 0
			local kI, tI, SI = 0
			sI, H = 0
			while ZI() and (EI()) and o() > 0 do
				local HI = Z[15]
				mI = HI()
				HI = Z[8]
				FI = HI()
				if mI and FI then
					if (mI.Position - aI).Magnitude > 600 then
						break
					end
				else
					break
				end
				if mI.Anchored then
					if not (Z[13](ZI)) then
						break
					end
				end
				if os.clock() >= PI or not (gI and gI.Parent) then
					PI, gI = os.clock() + 0.5, (O(eI))
				else
				end
				if gI then
					HI = Z[1]
					if gI.Parent ~= HI.Character then
						pcall(FI.EquipTool, FI, gI)
					end
				end
				HI = Z[25]
				local ZI, PI = HI.bfMode == "Chase"
				if ZI then
					PI = ZI
				else
					HI = Z[25]
					PI = HI.bfMode == "Stick"
				end
				if PI or os.clock() >= kI then
					kI, SI = os.clock() + 0.1, LI(mI.Position, tI)
				else
				end
				tI = SI and SI.id
				HI = Z[25]
				ZI, PI = HI.bfMode == "Stick" and "Chase"
				if ZI then
					PI = ZI
				else
					HI = Z[25]
					PI = HI.bfMode
				end
				if os.clock() >= sI then
					sI = os.clock() + 0.5
					RI(PI == "Chase" and "Chasing butterflies" or "Catching butterflies")
				else
				end
				if PI == "Chase" then
					FI.PlatformStand = false
					ZI, HI = SI and SI.p
					if ZI then
						HI = ZI
					else
						local sI = Z[28]
						HI = QI(aI + sI(0, 0, 6))
					end
					local sI = Z[28]
					local RI, eI = sI(HI.X - mI.Position.X, 0, HI.Z - mI.Position.Z), mI.AssemblyLinearVelocity
					if H then
					else
						sI = Z[20]
						local kI, LI = sI.normalWalk
						if kI then
							local gI = Z[20]
							LI = gI.normalWalk(FI)
						else
							LI = kI
						end
						H = LI or math.max(FI.WalkSpeed, 16)
					end
					if SI and RI.Magnitude <= 40 then
						sI = Z[28]
						local kI, LI, gI =
							sI(HI.X, math.max(QI(HI).Y, HI.Y - lI + 4), HI.Z),
							SI.v.Magnitude > 1 and SI.v.Unit or RI.Magnitude > 0.5 and RI.Unit
						if LI then
							gI = LI
						else
							local lI = Z[28]
							gI = lI(mI.CFrame.LookVector.X, 0, mI.CFrame.LookVector.Z)
						end
						local lI, sI = Z[26], Z[27]
						lI(sI(kI, kI + gI))
						mI.AssemblyLinearVelocity = SI.v
						FI.WalkSpeed = math.max(SI.v.Magnitude, 16)
						FI:MoveTo(kI + SI.v)
						YI = os.clock()
					else
						if RI.Magnitude > 2 then
							local lI, lI = Z[25], math.clamp(RI.Magnitude * 8, 16, Z[25].bfSpeed)
							FI.WalkSpeed = lI
							FI:MoveTo(mI.Position + RI)
							local sI
							sI, mI.AssemblyLinearVelocity = Z[28], RI.Unit * lI + Z[28](0, eI.Y, 0)
							sI = Z[28]
							YI = if sI(eI.X, 0, eI.Z).Magnitude > lI * 0.3 then os.clock() else YI
						else
							FI:MoveTo(mI.Position)
							YI = os.clock()
						end
					end
					if os.clock() - YI > 0.5 then
						YI = os.clock()
						FI.Jump = true
					else
					end
					xI(RI)
					eI = Z[23]
					eI()
					continue
				end
				FI.PlatformStand = true
				ZI = Z[28]
				local lI, sI = QI(aI + ZI(0, 0, 6)), os.clock() - WI
				if PI == "Patrol" then
					ZI, HI = Z[28]
					HI, lI = Z[25], QI(aI + ZI(math.sin(sI * Z[25].bfSpeed / 180) * 170, 0, 0))
				else
					if PI == "Circle" then
						local YI, RI, eI = Z[28]
						RI, eI, lI =
							Z[25],
							Z[25],
							QI(
								aI + YI(
										math.cos(sI * Z[25].bfSpeed / 25 / 4) * 25,
										0,
										math.sin(sI * Z[25].bfSpeed / 25 / 4) * 25
									)
							)
					else
					end
				end
				HI = lI - mI.Position
				if PI == "Stand" then
					xI(HI)
				end
				if HI.Magnitude > 8 then
					sI = nil
					sI, mI.AssemblyLinearVelocity = Z[25], HI.Unit * math.min(Z[25].bfSpeed, HI.Magnitude / 0.05)
				else
					ZI, PI = Z[26], Z[27]
					ZI(PI(lI))
				end
				PI = Z[23]
				PI()
			end
			iI:Disconnect()
			if FI then
				FI.PlatformStand = false
				WI = Z[33]
				FI:Move(WI)
				if H then
					FI.WalkSpeed = H
				end
			end
		end
		B.on = function()
			local H = Z[25]
			return H.bloom
		end
		B.ready = function()
			local H = Z[20]
			return H.bloomWants() and o() > 0
		end
		local H = G({ name = "BloomInfo", gap = 1 })
		H.on = function()
			return rI("Event")
		end
		H.fn = function()
			local H = JI()
			local ZI, PI = H.Counts or {}, Z[20]
			local lI = PI.bfRec or {}
			local function WI(FI)
				FI = math.max(0, math.floor(FI + 0.5))
				return ("%d:%02d"):format(FI // 60, FI % 60)
			end
			local FI, sI = tonumber(workspace:GetAttribute("ButterflyBloomEndsAt")), J()
			local aI, YI =
				workspace:GetAttribute("Event_ButterflyBloom") == true and (FI and "Butterfly Bloom live, " .. WI(
					FI - sI
				) .. " left" or "Butterfly Bloom live") or "Waiting for Butterfly Bloom",
				Z[25]
			FI = YI.bloom
			YI, sI = if FI then not FI else "Off  |  " .. aI
			if YI then
				sI = YI
			else
				FI, PI = Z[4] == B
				if FI then
					WI = Z[20]
					PI = WI.bfSay
				else
					PI = FI
				end
				if PI then
					local B = Z[20]
					sI = B.bfSay .. "  |  " .. aI
				else
					sI = PI
				end
			end
			local B, PI = sI or aI, {}
			PI.Green = ZI.Green
			PI.Blue = ZI.Blue
			PI.Purple = ZI.Purple
			PI.Golden = ZI.Golden
			PI.Essence = H.Essence
			D("bst", function()
				if not pI.st then
					return
				end
				pI.st.Set({ Text = B })
				local H
				for B, ZI in next, pI.texts, nil do
					local WI = lI[B] and ("%d/%d"):format(PI[B] or 0, lI[B]) or tostring(PI[B] or 0)
					if pI.shown[B] ~= WI then
						pI.shown[B] = WI
						ZI.Set({ Text = WI })
						H = true
					else
					end
				end
				if H then
					pI.lay()
				end
			end)
		end
		local H, B, pI = dI["Butterfly Bloom"], false, false
		local function ZI()
			local PI, lI = Z[25], Z[25]
			PI.bfTrade, lI.bfSmart = B and not pI, B and pI
			I()
		end
		local PI, lI = H:Toggle("Auto Trade Up", false, function(WI)
			B = WI
			ZI()
		end), {}
		TI, wI =
			{ "Emerald To Sapphire", "Sapphire To Amethyst", "Amethyst To Radiant" }, function(B)
				lI = {}
				for WI, FI in ipairs(B) do
					WI = lI
					WI[#WI + 1] = x[FI:match("^(%a+)")]
				end
			end
		H:Dropdown("Trade Up Tiers", TI, {}, wI, true, nil, PI)
		H:Toggle("Smart Trade For Essence", false, function(x)
			pI = x
			ZI()
		end, nil, PI)
		j(H, "Auto Craft Essence", "bfCraft", false)
		local x, H = { Green = 10, Blue = 10, Purple = 50 }, { Green = 240, Blue = 115, Purple = 40, Golden = 1 }
		pcall(function()
			local B, pI =
				require(P.Shared.Flags.ButterflyFlags),
				{ Green = "GreenToBlueCost", Blue = "BlueToPurpleCost", Purple = "PurpleToGoldenCost" }
			for ZI, PI in next, pI, nil do
				x[ZI] = tonumber(B[PI]:Get()) or x[ZI]
			end
			for pI in next, H, nil do
				H[pI] = tonumber(B["Essence" .. pI]:Get()) or H[pI]
			end
		end)
		v = Z[20]
		v.bfRec = H
		local function B(v)
			for pI, ZI in next, H, nil do
				if (v[pI] or 0) < ZI then
					return false
				end
			end
			return true
		end
		local function v(pI)
			local ZI, PI, wI, TI = pI.Green or 0, pI.Blue or 0, pI.Purple or 0, pI.Golden or 0
			for WI = 60, 1, -1 do
				pI = math.max(0, WI * H.Golden - TI)
				local TI = math.max(0, WI * H.Purple + x.Purple * pI - wI)
				local wI = math.max(0, WI * H.Blue + x.Blue * TI - PI)
				if ZI >= WI * H.Green + x.Green * wI then
					return { Green = wI, Blue = TI, Purple = pI }
				end
			end
		end
		local pI = G({ name = "Machine", mover = true, gap = 20, pri = 6, soft = true })
		pI.on = function()
			local ZI = Z[25]
			local PI, wI = ZI.bfTrade
			if PI then
				wI = PI
			else
				ZI = Z[25]
				wI = ZI.bfSmart
			end
			PI = nil
			if wI then
				PI = wI
			else
				ZI = Z[25]
				PI = ZI.bfCraft
			end
			return PI
		end
		pI.want = function()
			if EI() then
				return
			else
				local ZI = Z[1]
				if ZI:GetAttribute("EnchantedTreeUnlocked") ~= true then
					return
				end
			end
			local ZI, PI = JI().Counts or {}, Z[25]
			if PI.bfCraft then
				if B(ZI) then
					return true
				end
			end
			PI = Z[25]
			if PI.bfSmart then
				local wI = v(ZI)
				return wI and wI.Green + wI.Blue + wI.Purple > 0 or nil
			end
			local wI, TI = ipairs, lI
			for WI, WI in wI(TI) do
				PI = Z[25]
				if PI.bfTrade then
					local PI, PI = Z[25], (ZI[WI] or 0) - (Z[25].bfCraft and H[WI] or 0)
					if PI >= x[WI] then
						return true
					end
				end
			end
		end
		local function ZI(PI)
			local wI = Z[1]
			if wI:GetAttribute("InEnchantedTree") then
				return true
			end
			wI = Z[54]
			local TI = wI(
				"Build",
				"EnchantedTreeInterior",
				"Markers",
				"EnterTrigger",
				"EnchantedTreeEntrance",
				"EnchantedTreePrompt"
			)
			wI = TI and TI.Parent
			local WI = wI and (wI:IsA("Attachment") and wI.WorldPosition or wI:IsA("BasePart") and wI.Position)
			if not WI then
				return false
			end
			wI = Z[1]
			local EI = wI.Character
			local function FI()
				local sI = PI()
				local PI
				if sI then
					local aI = Z[1]
					PI = aI.Character == EI
				else
					PI = sI
				end
				return PI
			end
			if not (AI(FI)) then
				return false
			end
			wI = Z[15]
			local PI = wI()
			if PI then
				wI = Z[16]
				if wI(PI.Position) then
					local sI = Z[17]
					if not (sI(FI, "Enchanted Tree", 0.3)) then
						return false
					end
				end
			end
			if not (AI(FI)) then
				return false
			end
			wI = Z[28]
			PI = WI + wI(0, 0, -12)
			for sI = 1, 2, 1 do
				wI = Z[15]
				sI = wI()
				if sI then
					if FI() then
						if o() > 0 then
							if not ((sI.Position - PI).Magnitude > 500) then
								break
							end
						else
							break
						end
					else
						break
					end
				else
					break
				end
				sI = Z[11]
				sI("Ragdoll TP to the Enchanted Tree")
				sI = Z[28]
				MI(PI + sI(0, 3, 0), FI)
			end
			wI = Z[1]
			if wI.Character ~= EI then
				return false
			end
			wI = Z[15]
			local EI = wI()
			if EI then
				if (EI.Position - PI).Magnitude > 60 then
					if not (hI({ Pos = PI, Name = "the tree" }, FI)) then
						return false
					end
				end
			end
			for sI = 1, 4, 1 do
				wI, PI, sI = Z[26], Z[27], Z[28]
				wI(PI(WI + sI(0, 3, -6)))
				pcall(fireproximityprompt, TI)
				FI = os.clock() + 4
				while true do
					EI, sI = os.clock() < FI
					if EI then
						local PI = Z[1]
						sI = not PI:GetAttribute("InEnchantedTree")
					else
						sI = EI
					end
					if not sI then
						break
					end
					local PI = Z[23]
					PI()
				end
				sI = Z[1]
				if sI:GetAttribute("InEnchantedTree") then
					return true
				end
			end
			return false
		end
		OI = Z[20]
		OI.enterTree = ZI
		local OI = Z[20]
		OI.leaveTree = function()
			local OI = Z[54]
			local PI = OI("Build", "EnchantedTreeInterior", "Markers", "ExitTrigger")
			if PI then
				if PI:IsA("BasePart") then
					OI = Z[1]
					if not (OI:GetAttribute("InEnchantedTree")) then
						return
					end
				else
					return
				end
			else
				return
			end
			local wI, TI = Z[26], Z[27]
			wI(TI(PI.Position + PI.CFrame.LookVector * (PI.Size.Z / 2 + 3)))
			OI = Z[23]
			OI()
			OI = Z[26]
			OI(PI.CFrame)
			OI = os.clock() + 1.5
			while true do
				TI = Z[1]
				if not (TI:GetAttribute("InEnchantedTree") and os.clock() < OI) then
					break
				end
				wI = Z[23]
				wI()
			end
			wI = Z[1]
			if wI:GetAttribute("InEnchantedTree") then
				OI = Z[15]
				Y(OI(), PI)
			end
		end
		local function Y(OI, PI, wI, ...)
			local TI = fI(PI)
			if not TI then
				return false
			end
			for WI = 1, 3, 1 do
				uI(TI, wI)
				PI = Z[9]
				local wI, TI, WI = PI(OI, ...)
				if wI then
					if TI ~= false then
						return true
					end
				end
				if not (tostring(WI):lower():find("closer")) then
					return false
				end
			end
			return false
		end
		pI.run = function(OI, pI)
			OI = Z[20]
			if not (OI.needBody()) then
				return
			end
			if Z[13](pI) then
				if not (ZI(pI)) then
					OI = Z[11]
					return OI("Could not enter the tree", "warn")
				end
			else
				local ZI = Z[11]
				return ZI("Could not enter the tree", "warn")
			end
			OI = Z[25]
			local ZI, PI = OI.bfSmart and v(JI().Counts or {}), ipairs
			OI = ZI and { "Green", "Blue", "Purple" } or {}
			for v, wI in PI(OI) do
				v = ZI[wI]
				for TI = 1, v, 1 do
					TI = Z[25]
					if TI.bfSmart then
						if pI() then
							if not (Y("RF/Butterflies/AskTradeUp", "ButterflyMachine", pI, wI)) then
								break
							end
						else
							break
						end
					else
						break
					end
					task.wait(0.15)
				end
			end
			ZI, OI = ipairs, Z[25]
			PI = OI.bfSmart and {} or lI
			for v, wI in ZI(PI) do
				while true do
					OI = Z[25]
					local TI, lI = OI.bfTrade and pI() and (JI().Counts or {})[wI]
					if TI then
						v = nil
						v, lI = Z[25], JI().Counts[wI] - (Z[25].bfCraft and H[wI] or 0) >= x[wI]
					else
						lI = TI
					end
					if not lI then
						break
					end
					if not (Y("RF/Butterflies/AskTradeUp", "ButterflyMachine", pI, wI)) then
						break
					end
					task.wait(0.15)
				end
			end
			for x = 1, 50, 1 do
				ZI = Z[25]
				if ZI.bfCraft then
					if pI() then
						if not (B(JI().Counts or {})) then
							break
						end
					else
						break
					end
				else
					break
				end
				if not (Y("RF/Butterflies/AskCraftEssence", "MutationShrine", pI)) then
					break
				end
				task.wait(0.3)
			end
			PI = Z[20]
			PI.leaveTree()
		end
	end)
	w("31_bloom#2", function()
		local Y, x = G({ name = "Wisp", gap = 3 }), dI["Butterfly Bloom"]
		local H = N("wt", x:Text("Wisp Status", "Off"))
		j(x, "Auto Wisp", "wisp", false)
		j(x, "Auto Banjo Cricket", "banjo", false)
		x = Z[20]
		x.wispSay = H
		x = Z[20]
		local B = x.nostat
		Y.on = function()
			local v = Z[25]
			return v.wisp or rI("Event")
		end
		x = Z[34]
		local v = x.Wisp
		local function OI()
			local pI = Z[67]
			local ZI = pI()
			pI = ZI and ZI.WispCompanion
			return ZI, type(pI) == "table" and pI or nil
		end
		local function pI(ZI)
			if ZI then
				if ZI.Accepted then
					if ZI.Unlocked then
						return
					end
				else
					return
				end
			else
				return
			end
			return (type(v) == "table" and v.List or {})[tonumber(ZI.Stage) or 1]
		end
		local function ZI(PI, wI)
			return type(PI.Progress) == "table" and tonumber(PI.Progress[wI.Id]) or 0
		end
		local function PI(wI, TI)
			return type(wI.Claimed) == "table" and wI.Claimed[TI.Id]
		end
		local wI = {}
		local function TI(lI)
			if not wI[lI] then
				local WI = {}
				pcall(function()
					for EI, EI in ipairs(require(P.Data.Areas.Configs[lI]).DropTable) do
						WI[tostring(EI[1] or EI.Category)] = true
					end
				end)
				wI[lI] = WI
			end
			return wI[lI]
		end
		local wI = { at = 0 }
		local function lI(WI)
			if wI.q == WI then
				if os.clock() - wI.at < 2 then
					local EI = wI
					return EI
				end
			end
			local EI = Z[67]
			local FI, sI = EI(), TI(type(WI.Match) == "table" and WI.Match.AreaId)
			local TI, aI, JI = m(FI or {}), {}, {}
			for m, YI in next, FI and type(FI.Inventory) == "table" and FI.Inventory or {}, nil do
				EI = type(YI) == "table" and tostring(YI.AssetCategory)
				if EI then
					if sI[EI] then
						if not YI.IsFavorite then
							if not YI.InFuse then
								if not TI[m] then
									aI[EI] = aI[EI] or {}
									table.insert(aI[EI], m)
									JI[EI] = (JI[EI] or 0) + 1
								end
							end
						end
					end
				end
			end
			for m, TI in pairs(S()) do
				m = type(TI) == "table" and tostring(TI.AssetCategory)
				if m then
					if sI[m] then
						JI[m] = (JI[m] or 0) + 1
					end
				end
			end
			wI = { q = WI, at = os.clock(), supply = 0 }
			for m, TI in next, aI, nil do
				if #TI >= 3 then
					FI, EI = wI, wI
					FI.ready = { TI[1], TI[2], TI[3] }
					EI.cat = m
				end
			end
			for m, m in next, JI, nil do
				FI = wI
				FI.supply = math.max(wI.supply, m)
			end
			aI = wI
			return aI
		end
		local function m(TI)
			local WI, WI = OI()
			local EI = pI(WI)
			if EI then
				if PI(WI, EI) then
					return false
				end
			else
				return false
			end
			local FI = type(EI.Match) == "table" and EI.Match or {}
			if EI.Event == "PetFused" then
				return TI.a == FI.AreaId and lI(EI).supply < 3
			end
			if EI.Event ~= "EggSecured" then
				return false
			elseif ZI(WI, EI) >= (tonumber(EI.Target) or 1) then
				return false
			end
			for EI, sI in next, FI, nil do
				if EI == "AreaId" then
					if sI ~= TI.a then
						return false
					end
				elseif EI == "Rarity" then
					WI = h(TI.cat)
					WI = WI and WI.Rarity
					if WI then
						if not (WI.DisplayName == sI) then
							if not (WI._id == sI) then
								return false
							end
						end
					else
						return false
					end
				else
					return false
				end
			end
			return true
		end
		local TI = Z[20]
		TI.wispSteals = function()
			local TI = Z[25]
			if not TI.wisp then
				return false
			end
			local WI, WI = OI()
			TI = pI(WI)
			if TI then
				if PI(WI, TI) then
					return false
				end
			else
				return false
			end
			if TI.Event == "EggSecured" then
				return ZI(WI, TI) < (tonumber(TI.Target) or 1)
			end
			return TI.Event == "PetFused" and lI(TI).supply < 3
		end
		x = Z[20]
		local TI, WI = x.wantEgg, Z[20]
		WI.wantEgg = function(x)
			local WI = Z[25]
			if WI.wisp then
				if m(x) then
					return "wisp"
				end
			end
			return TI and (TI(x))
		end
		local function m(...)
			local x = Z[54]
			local TI = x("Build", ...)
			return TI and (TI:IsA("BasePart") and TI.Position or TI:IsA("Model") and TI:GetPivot().Position)
		end
		local function x(TI)
			local WI = Z[67]
			local EI = WI()
			if not EI then
				return
			end
			if EI.FusionLocked then
				if type(EI.FusionEggReward) == "table" then
					WI = Z[9]
					WI("RF/Fusery/FinishReveal")
				end
				return H("Fusing for the wisp quest")
			end
			WI = lI(TI)
			if not WI.ready then
				return H(WI.supply >= 3 and "Hatching eggs for the fuse quest" or "Stealing eggs for the fuse quest")
			end
			local lI, FI = {}, {}
			for sI, sI in ipairs(WI.ready) do
				lI[sI] = true
			end
			local sI, aI = ipairs, type(EI.FusionSlots) == "table" and EI.FusionSlots or {}
			for JI, YI in sI(aI) do
				if lI[YI] then
					FI[YI] = true
				else
					JI = Z[9]
					JI("RF/Fusery/EjectPet", YI)
					task.wait(0.35)
				end
			end
			if EI.FusionInfoAcknowledged == false then
				sI = Z[9]
				sI("RF/Fusery/ConfirmBriefing")
				task.wait(0.35)
			end
			TI, sI = ipairs, WI.ready
			for lI, lI in TI(sI) do
				if not FI[lI] then
					EI = Z[9]
					EI("RF/Fusery/LoadPet", lI)
					task.wait(0.35)
				end
			end
			EI = Z[9]
			EI("RF/Fusery/BeginFuse")
			wI.at = 0
			sI = Z[74]
			H("Fusing 3 " .. sI(WI.cat) .. " for the wisp quest")
		end
		Y.fn = function()
			local Y, wI = OI()
			if not wI then
				return H("Reading quest")
			end
			local OI = type(v) == "table" and tonumber(v.StageCount) or 4
			if wI.Unlocked then
				V("wst", B, { Stage = ("%d / %d"):format(OI, OI), Progress = "Complete" })
				return H("Done, the Enchanted Tree is open")
			end
			if not wI.Accepted then
				V("wst", B, { Stage = ("0 / %d"):format(OI), Progress = "Not accepted" })
			end
			local TI = pI(wI)
			if TI then
				V(
					"wst",
					B,
					{
						Stage = ("%d / %d"):format(tonumber(wI.Stage) or 1, OI),
						Progress = ("%d / %d"):format(ZI(wI, TI), tonumber(TI.Target) or 1),
					}
				)
			end
			TI = Z[25]
			if not TI.wisp then
				return H("Off")
			end
			if Y.FusionLocked then
				if type(Y.FusionEggReward) == "table" then
					TI = Z[9]
					TI("RF/Fusery/FinishReveal")
				end
			end
			if not wI.Accepted then
				TI = type(v) == "table" and tonumber(v.RequiredSpeedPower) or 50000000000
				if (tonumber(Y.SpeedPower) or 0) < TI then
					return H("Needs " .. A(TI) .. " speed power to meet the wisp")
				end
				local B = Z[54]
				local v = B("Build")
				if v then
					if not (v:GetAttribute("EnchantedForestZoneRevealed")) then
						return H("Waiting for the Enchanted Forest to open")
					end
				else
					return H("Waiting for the Enchanted Forest to open")
				end
				B = Z[20]
				B.wispGo = { m("EnchantedForestZone", "WispSpawn"), "Accept" }
				return H("Going to accept the quest")
			end
			TI = pI(wI)
			if TI then
				if not (PI(wI, TI)) then
					if ZI(wI, TI) >= (tonumber(TI.Target) or 1) then
						Y = Z[9]
						Y("RF/WispCompanion/Request", "Claim", TI.Id)
						return H("Claimed " .. tostring(TI.Title))
					end
				end
			end
			if (tonumber(wI.Stage) or 1) >= OI then
				if not wI.Returning then
					Y = Z[9]
					Y("RF/WispCompanion/Request", "BeginReturn")
				end
				local Y = Z[20]
				Y.wispGo = {
					m("EnchantedForestZone", "Zone13Props", "EnchantedTree", "WispAnchor")
						or m("EnchantedForestZone", "WispAnchor"),
					"Return",
				}
				return H("Returning the wisp")
			end
			if not TI then
				return H("Reading quest")
			end
			if TI.Event == "PetFused" then
				return x(TI)
			end
			H(
				tostring(TI.Title)
					.. (
						type(TI.Match) == "table" and TI.Match.Rarity and " - waiting for that egg in this server" or ""
					)
			)
		end
		local Y = G({ name = "WispGo", mover = true, gap = 3, pri = 4 })
		Y.on = function()
			local m = Z[25]
			return m.wisp
		end
		Y.want = function()
			local m = Z[20]
			local x, H = m.wispGo
			if x then
				m = Z[20]
				H = m.wispGo[1]
			else
				H = x
			end
			x = nil
			if H then
				m = Z[20]
				x = m.wispGo
			else
				x = H
			end
			return x or nil
		end
		Y.run = function(Y, m)
			local x = Y[1]
			if Z[13](m) then
				local H = Z[14]
				if not (H(m)) then
					return
				end
			else
				return
			end
			local H = Z[15]
			local B = H()
			if B then
				H = Z[16]
				if H(B.Position) then
					local v = Z[17]
					if not (v(m, "Wisp", 0.3)) then
						return
					end
				end
			end
			B, H = Z[1], Z[1]
			pcall(Z[1].RequestStreamAroundAsync, Z[1], x)
			local H = Z[15]
			local B = H()
			if not B then
				return
			end
			if (B.Position - x).Magnitude > 1200 then
				if o() > 0 then
					H = Z[28]
					MI(x + H(0, 3, 3), m)
				end
			end
			H = Z[15]
			B = H()
			if B then
				if (B.Position - x).Magnitude > 40 then
					local B, v = Z[20], Z[28]
					if not (B.stepTo(x + v(0, 0, 3), m)) then
						return
					end
				end
			end
			H = Z[8]
			local B, v = H(), 0
			while true do
				local OI, pI = B and m() and v < 3
				if OI then
					H = Z[15]
					pI = (H())
				else
					pI = OI
				end
				OI = nil
				if pI then
					local m = Z[15]
					OI = (m().Position - x).Magnitude > 6
				else
					OI = pI
				end
				if not OI then
					break
				end
				B:MoveTo(x)
				v += task.wait(0.2)
			end
			task.wait(0.5)
			x = Z[9]
			x("RF/WispCompanion/Request", Y[2])
			x = Z[20]
			x.wispGo = nil
		end
	end)
	w("34_star#1", function()
		local Y, m = { pay = nil, caught = 0, slipped = 0, askAt = 0, jumped = {} }, Z[20]
		m.SS = Y
		local x = G({ name = "Star", mover = true, gap = 0.5, pri = 2 })
		m = dI["Shooting Star"]
		local H = m:Text("Shooting Star Status", "Off")
		local B = {
			Set = function(v, v, OI)
				if v == "Status" then
					H:Set(OI)
				end
			end,
		}
		j(m, "Auto Catch Shooting Star", "star", false, function(m)
			if not m then
				CI(x)
			end
		end)
		local function m(H)
			if type(H) == "table" then
				if H.Id ~= nil then
					if Y.pay then
						if not (Y.pay.Id == H.Id) then
							Y.slipped = 0
						end
					else
						Y.slipped = 0
					end
					Y.pay = H
				end
			end
		end
		local function H()
			Y.askAt = os.clock() + 15
			task.spawn(function()
				local v = Z[9]
				local OI, pI = v("RF/ShootingStar/AskState")
				if OI then
					m(pI)
				end
			end)
		end
		local function v(OI, pI)
			local ZI = Z[39]
			local PI = ZI:FindFirstChild(OI)
			if PI then
				if PI:IsA("RemoteEvent") then
					W(PI.OnClientEvent, pI)
				end
			end
		end
		v("RE/ShootingStar/Fall", m)
		v("RE/ShootingStar/Wander", function(m, OI)
			if Y.pay then
				if Y.pay.Id == m then
					if type(OI) == "table" then
						Y.pay.Leg = OI
					end
				end
			end
		end)
		v("RE/ShootingStar/Slipped", function(m)
			if Y.pay then
				if Y.pay.Id == m then
					Y.slipped = Y.slipped + 1
					Y.hold = nil
				end
			end
		end)
		v("RE/ShootingStar/Claimed", function(m)
			if Y.pay then
				if Y.pay.Id == m then
					Y.caught = Y.caught + 1
					Y.pay = nil
					CI(x)
					c("Shooting Star", "Caught a star", "ok")
				end
			end
		end)
		v("RE/ShootingStar/Expired", function(m)
			if Y.pay then
				if Y.pay.Id == m then
					Y.pay = nil
					CI(x)
				end
			end
		end)
		H()
		local function m(v)
			local OI = workspace:FindFirstChild("ShootingStarClient")
			local pI = OI and (OI:FindFirstChild("Buddy"))
			OI = pI and (pI:FindFirstChild("RootPart"))
			if OI then
				if OI:IsA("BasePart") then
					return OI.Position
				end
			end
			OI, pI = J(), v.Leg
			if type(pI) == "table" then
				if typeof(pI.From) == "Vector3" then
					if typeof(pI.To) == "Vector3" then
						local ZI = tonumber(pI.StartAt) or OI
						local PI = (tonumber(pI.ArriveAt) or ZI) - ZI
						local wI, TI = PI > 0 and math.clamp((OI - ZI) / PI, 0, 1) or 1, pI.To - pI.From
						local ZI, lI, WI = pI.From:Lerp(pI.To, wI), wI < 1 and TI.Magnitude > 0.5
						if lI then
							PI = Z[28]
							WI = PI(TI.X, 0, TI.Z).Unit
						else
							WI = lI
						end
						return ZI, WI or nil
					end
				end
			end
			OI = v.Landing
			if typeof(OI) == "CFrame" then
				return OI.Position
			end
			return typeof(OI) == "Vector3" and OI or nil
		end
		local function v(OI)
			local pI = J()
			return OI and pI >= (tonumber(OI.LandAt) or pI) and (tonumber(OI.ExpiresAt) or 1 / 0) > pI
		end
		local OI = Z[20]
		OI.starWants = function()
			local OI = Z[25]
			return OI.star and v(Y.pay)
		end
		x.on = function()
			if os.clock() >= Y.askAt then
				H()
			end
			if Y.pay then
				if (tonumber(Y.pay.ExpiresAt) or 1 / 0) <= J() then
					Y.pay = nil
				end
			end
			local OI = Z[25]
			return OI.star and v(Y.pay)
		end
		x.want = function()
			local v = Z[21]
			if v() then
				return
			end
			return Y.pay
		end
		x.run = function(v, OI)
			local pI = Z[1]
			local ZI = pI.Character
			local function PI()
				local wI, TI = OI() and Y.pay == v
				if wI then
					local OI = Z[1]
					TI = OI.Character == ZI
				else
					TI = wI
				end
				return TI
			end
			if Z[13](PI) then
				pI = Z[14]
				if not (pI(PI)) then
					return
				end
			else
				return
			end
			pI = Z[15]
			local OI = pI()
			pI = nil
			if OI then
				local ZI = Z[16]
				pI = ZI(OI.Position)
			else
				pI = OI
			end
			if pI then
				local ZI = Z[17]
				if not (ZI(PI, "Shooting Star")) then
					return
				end
			end
			local function ZI()
				local wI = m(v)
				local TI
				if wI then
					local lI = Z[28]
					TI = wI + lI(0, 3, 3)
				else
					TI = wI
				end
				return TI
			end
			local function wI()
				local TI, lI = ZI(), Z[15]
				local WI = lI()
				return TI and WI and (WI.Position - TI).Magnitude or 1 / 0
			end
			if wI() > 40 then
				if not Y.jumped[v.Id] then
					Y.jumped[v.Id] = true
					pI = Z[11]
					pI("Ragdoll jump to the star")
					MI(ZI, PI)
				end
			end
			if PI() then
				if wI() > 40 then
					pI = Z[11]
					pI("Running to the star")
					local TI = ZI()
					local ZI
					if TI then
						ZI = TI
					else
						local TI = Z[33]
						ZI = TI
					end
					nI(ZI, PI, 30, 40)
				end
			end
			pI, wI = (tonumber(v.HoldSeconds) or 1.6) + 0.3, Z[32]
			local ZI, TI = 0.5 + wI() * 2, os.clock()
			wI = false
			local lI
			local WI = 0
			while PI() do
				local EI, FI = m(v)
				local m = Z[15]
				OI = m()
				m = Z[8]
				local sI = m()
				if EI then
					if OI then
						if not sI then
							return
						end
					else
						return
					end
				else
					return
				end
				if OI.Anchored then
					Z[13](PI)
				end
				m = Z[28]
				local PI, aI, JI = EI + m(0, 3, 0), FI and FI * 2
				if aI then
					JI = aI
				else
					m = Z[28]
					JI = (m(0, 0, 3))
				end
				m = PI + JI - OI.Position
				if m.Magnitude > 60 then
					return
				end
				sI.PlatformStand = true
				local PI, FI = m * 10, Z[28]
				local sI = FI(EI.X - OI.Position.X, 0, EI.Z - OI.Position.Z)
				if PI.Magnitude > 200 then
					PI = PI.Unit * 200
				else
				end
				pcall(function()
					if sI.Magnitude > 0.05 then
						local aI
						aI, OI.CFrame = Z[27], Z[27](OI.Position, OI.Position + sI.Unit)
					end
					local sI
					sI, OI.AssemblyLinearVelocity, OI.AssemblyAngularVelocity = Z[33], PI, Z[33]
				end)
				if wI then
					if Y.hold then
						if if lI then not lI else os.clock() - Y.hold >= pI then
							WI += 1
							lI = os.clock()
							s("RE/ShootingStar/Catch", v.Id)
							FI = Z[11]
							FI("Catching the star (try " .. WI .. ")")
						else
							if lI then
								if os.clock() - lI >= 2 then
									Y.hold = nil
									s("RE/ShootingStar/Hold", v.Id, false)
									if WI % 3 == 0 then
										H()
									end
								end
							end
						end
					else
						lI, Y.hold = nil, os.clock()
						s("RE/ShootingStar/Hold", v.Id, true)
						EI = Z[11]
						EI("Holding the star" .. (Y.slipped > 0 and " (slipped " .. Y.slipped .. ")" or ""))
					end
				else
					TI = if m.Magnitude > 8 then os.clock() else TI
					wI = os.clock() - TI >= ZI
					if not wI then
						JI = Z[11]
						JI("At the star, letting the server catch up")
					end
				end
				m = Z[23]
				m()
			end
			if Y.pay == v then
				s("RE/ShootingStar/Hold", v.Id, false)
			end
			Y.hold = nil
		end
		local m = G({ name = "StarInfo", gap = 1 })
		m.on = function()
			local H = rI("Event")
			local v
			if H then
				v = H
			else
				local H = Z[25]
				v = H.farmHud
			end
			return v
		end
		m.fn = function()
			local m, H = Y.pay, J()
			local v, OI, pI = m and (tonumber(m.LandAt) or H) - H, m and tonumber(m.ExpiresAt), {}
			local ZI = Z[4] == x and (OI and "Catching, " .. R(math.max(OI - H, 0)) .. " left" or "Catching")
			H, OI = ZI or m and v > 0 and "Lands in " .. math.ceil(v) .. "s" or m and "Landed"
			if H then
				OI = H
			else
				m = Z[25]
				OI = m.star and "Waiting for a shooting star" .. (Y.caught > 0 and " (caught " .. Y.caught .. ")" or "")
			end
			pI.Status = OI or "Off"
			pI.Caught = tostring(Y.caught)
			V("star", B, pI)
		end
	end)
	w("35_stage#1", function()
		local Y = G({ name = "Stage", mover = true, gap = 0.5, pri = 50, soft = true, aux = true })
		local function m()
			local x = Z[20]
			local H, B = x.starWants
			if H then
				x = Z[20]
				B = x.starWants()
			else
				B = H
			end
			if B then
				return "field"
			else
				H = Z[20]
				if H.bloomWants then
					x = Z[20]
					if x.bloomWants() then
						return "field"
					end
				end
			end
			x, B, H = Z[20], pcall(Z[20].targetsSoon)
			local x = Z[25]
			local v, OI = x.steal and B and type(H) == "table"
			if v then
				x = Z[20]
				OI = x.fieldFresh
			else
				OI = v
			end
			return (OI and H[1] or nil) and "field" or nil
		end
		Y.on = function()
			local x = Z[22]
			local H = x("Cycle", "IsNightPhase", J())
			local B, v = not H
			if H then
				v = B
			else
				x = Z[22]
				v = x("Wall", "IsSealed") == true
			end
			x, H = v and 0.5 or 50, Z[20]
			if H.rank.Stage ~= x then
				B = Z[20]
				B.rank.Stage = x
			end
			return v and m() ~= nil
		end
		Y.want = function()
			local x = Z[21]
			if not (x()) then
				local x = Z[15]
				if x() then
					return m()
				end
			end
		end
		Y.run = function(Y, m)
			Y = Z[20]
			if Y.inFuse then
				local x = Z[20]
				if x.inFuse() then
					local x = Z[11]
					x("Leaving the portal zone before the field opens")
					x = Z[20]
					x.leaveFuse()
				end
			end
			if not (Z[13](m)) then
				return
			end
			Y = Z[15]
			local x, H = Y(), Z[47]
			local B, B = Z[28], H() + Z[28](0, 3, 0)
			if x then
				Y = Z[16]
				if Y(x.Position) then
					if (x.Position - B).Magnitude > 8 then
						H = Z[11]
						H("To the safe zone before the field opens")
						local Y = Z[53]
						if not (Y(B, m, 250)) then
							return
						end
					end
				end
			end
			B = Z[17]
			B(m, "Ready in the safe zone", 0)
			B = Z[11]
			B("Field open, the top task goes first")
		end
	end)
	w("36_admin#1", function()
		local function Y(m)
			local x, H = pcall(function()
				local B = Z[34]
				return B.Egg.ReadFieldEgg(m)
			end)
			if x then
				if type(H) == "table" then
					return H
				end
			end
			x = Z[18]
			H = x()
			if type(H[m]) == "table" then
				return H[m]
			end
			for x, x in pairs(H) do
				if type(x) == "table" then
					if x.Uid == m then
						return x
					end
				end
			end
		end
		local function m(x)
			return x and x:IsA("Model") and x:GetPivot().Position
		end
		local function x()
			local H, B = ipairs, { "CaptureTheEggSpawn", "AdminAbuseEggSpawn" }
			for v, OI in H(B) do
				v = Z[54]
				local H = v("Areas", OI)
				if H then
					if H:IsA("BasePart") then
						return H.Position
					end
				end
			end
		end
		local function H(B, v)
			local OI = workspace:FindFirstChild("AreaEggSlotsClient")
			return m(OI and OI:FindFirstChild(B))
				or m(workspace:FindFirstChild(B))
				or v and typeof(v.BottomCFrame) == "CFrame" and v.BottomCFrame.Position
				or (x())
		end
		local function x(B)
			local v = tonumber(B and B.CarrierUserId)
			return v and v > 0 and v or nil
		end
		local function B(v, OI)
			local pI = Z[21]
			local ZI = pI(v)
			pI = nil
			if ZI then
				pI = ZI
			else
				v = nil
				v, pI = Z[1], x(OI) == Z[1].UserId
			end
			return pI
		end
		local function v(OI, pI, ZI)
			local PI = Z[15]
			local wI, TI = PI(), Z[8]
			PI = TI()
			if not wI then
				return
			end
			if PI then
				PI.PlatformStand = true
			end
			TI = OI - wI.Position
			local PI, lI = TI.Magnitude > pI * ZI and wI.Position + TI.Unit * pI * ZI or OI, Z[28]
			ZI, pI = lI(TI.X, 0, TI.Z), Z[26]
			wI, OI = ZI.Magnitude > 0.5 and CFrame.lookAt(PI, PI + ZI)
			if wI then
				OI = wI
			else
				TI = Z[27]
				OI = (TI(PI))
			end
			pI(OI)
		end
		local function OI(pI, ZI)
			local PI, wI, TI, lI, WI = ipairs, C[20](workspace:GetChildren()), 14
			for EI, FI in PI(C:QH(wI)) do
				EI = FI.Name == "SmartPromptPart" and FI:IsA("BasePart") and FI:FindFirstChild("CarryAreaEgg")
				if EI then
					if EI:IsA("ProximityPrompt") then
						local sI = Z[28]
						local aI = sI(FI.Position.X - ZI.X, 0, FI.Position.Z - ZI.Z).Magnitude
						if aI < TI then
							TI, lI, WI = aI, EI, FI
						else
						end
					else
					end
				else
				end
			end
			wI, PI = lI and workspace:FindFirstChild("AreaEggSlotsClient"), ipairs
			ZI = wI and wI:GetChildren() or {}
			for wI, EI in PI(ZI) do
				wI = EI.Name ~= pI and m(EI)
				if wI then
					EI = Z[28]
					if EI(wI.X - WI.Position.X, 0, wI.Z - WI.Position.Z).Magnitude + 1.5 < TI then
						return
					end
				end
			end
			return lI
		end
		local function m(pI, ZI)
			local PI = Z[8]
			local wI, TI = PI(), Z[1]
			PI = TI.Character
			if wI then
				if PI then
					if PI:FindFirstChildWhichIsA("Tool") then
						pcall(wI.UnequipTools, wI)
					end
				end
			end
			wI, TI = os.clock() + 1.4, 0
			while os.clock() < wI and (ZI()) do
				PI = Y(pI)
				if B(pI, PI) then
					return true
				end
				if x(PI) then
					return false
				end
				local ZI = H(pI, PI)
				if ZI then
					local wI, lI, WI = Z[26], Z[27], Z[28]
					wI(lI(ZI + WI(0, 2.5, 0)))
					if os.clock() >= TI then
						TI = os.clock() + 0.08
						local wI = fireproximityprompt and OI(pI, ZI)
						if wI then
							pcall(function()
								wI.HoldDuration = 0
								fireproximityprompt(wI)
							end)
						else
							task.spawn(
								Z[22],
								"Egg",
								"CarryFieldEgg",
								pI,
								PI and PI.AreaId and PI.NestId and PI.AreaId .. ":" .. PI.NestId
							)
						end
					else
					end
				else
				end
				ZI = Z[23]
				ZI()
			end
			return B(pI, Y(pI))
		end
		local OI = dI["Capture The Egg"]
		local function pI(ZI)
			local PI = Z[20]
			PI.capSt = ZI
		end
		local ZI = G({
			name = "Capture",
			mover = true,
			gap = 0.25,
			pri = -1,
			urgent = true,
			ev = function()
				return true
			end,
		})
		local PI = j(OI, "Auto Capture Event Egg", "capture", false, function(wI)
			if not wI then
				CI(ZI)
			end
		end)
		j(OI, "Take It From The Holder", "capTake", true, nil, nil, PI)
		X(OI, "Hold Height", "capH", 20, 120, 45, "studs", 1, nil, nil, PI)
		X(OI, "Keep Away Distance", "capAway", 20, 150, 45, "studs", 1, nil, nil, PI)
		local function wI()
			local TI = workspace:GetAttribute("Event_CaptureTheEggUid")
			return type(TI) == "string" and TI ~= "" and TI or nil
		end
		local TI = {}
		local lI = -9
		local function WI()
			if os.clock() - lI < 5 then
				local EI = TI
				return EI
			end
			local EI
			EI, TI = os.clock(), {}
			lI = EI
			EI = Z[54]
			local lI, FI = EI("Areas", "EggCarryBounds"), ipairs
			EI = lI and lI:GetChildren() or {}
			for sI, aI in FI(EI) do
				if
					aI:IsA("BasePart")
					and aI.Name ~= "SafeZone"
					and aI.Position.Y > 0
					and aI.Size.X > 60
					and aI.Size.Z > 60
				then
					sI = Z[28]
					local FI, JI = sI(1000000000, 0, 1000000000), Z[28]
					local sI, YI, RI, eI = JI(-1000000000, 0, -1000000000), aI.Size / 2, ipairs, { -1, 1 }
					for fI, QI in RI(eI) do
						fI, lI = ipairs, { -1, 1 }
						for eI, uI in fI(lI) do
							JI, eI = Z[28], aI.CFrame:PointToWorldSpace(Z[28](YI.X * QI, 0, YI.Z * uI))
							FI, sI = (FI:Min(eI)), (sI:Max(eI))
						end
					end
					RI = TI
					local lI, JI = #RI + 1, { lo = FI, hi = sI }
					JI.y, RI[lI] = aI.Position.Y + YI.Y, JI
				end
			end
			EI = TI
			return EI
		end
		local function TI(lI, EI)
			EI = EI or 0
			for FI, FI in ipairs(WI()) do
				if lI.X >= FI.lo.X + EI then
					if lI.X <= FI.hi.X - EI then
						if lI.Z >= FI.lo.Z + EI then
							if lI.Z <= FI.hi.Z - EI then
								return FI
							end
						end
					end
				end
			end
		end
		local function lI(EI)
			local FI, sI, aI = ipairs, C[20](q:GetPlayers()), 1 / 0
			for JI, YI in FI(C:QH(sI)) do
				JI = Z[1]
				local sI, RI =
					YI ~= JI and YI.Character and YI.Character:FindFirstChild("HumanoidRootPart"),
					YI.Character and YI.Character:FindFirstChildOfClass("Humanoid")
				aI = if sI
					then if RI then if RI.Health > 0 then math.min(aI, (sI.Position - EI).Magnitude) else aI else aI
					else aI
			end
			FI = Z[54]
			local sI, JI = FI("Areas", "GuardAreas"), ipairs
			FI = sI and sI:GetChildren() or {}
			for YI, RI in JI(FI) do
				sI = RI:FindFirstChild("Guard") and RI.Guard:FindFirstChild("HumanoidRootPart", true)
				if sI then
					RI, YI = nil
					RI, YI, aI =
						Z[28],
						Z[25],
						math.min(
							aI,
							Z[28](sI.Position.X - EI.X, 0, sI.Position.Z - EI.Z).Magnitude * Z[25].capAway / 32
						)
				else
				end
			end
			return aI
		end
		local function EI(FI)
			local sI, aI, JI, YI = ipairs, C[20](WI()), 1 / 0
			local WI, RI = -1
			for eI, fI in sI(C:QH(aI)) do
				local sI, aI = (fI.lo.Z + fI.hi.Z) / 2, (fI.hi.Z - fI.lo.Z) / 2
				local QI, uI, AI = math.min(40, math.max(0, aI - 14)), fI.lo.X + 14, fI.hi.X - 14
				for hI = uI, AI, 50 do
					eI, aI = ipairs, { sI - QI, sI, sI + QI }
					for sI, QI in eI(aI) do
						sI = Z[28]
						local aI, aI = Z[25], sI(hI, fI.y + Z[25].capH, QI)
						local sI, eI, fI = lI(aI), (aI - FI).Magnitude, Z[25]
						if sI >= fI.capAway + 10 then
							if eI < JI then
								JI, YI = eI, aI
							else
							end
						else
						end
						if sI > WI then
							WI, RI = sI, aI
						else
							if sI == WI then
								if RI then
									if eI < (RI - FI).Magnitude then
										WI, RI = sI, aI
									else
									end
								else
								end
							else
							end
						end
					end
				end
			end
			return YI or RI
		end
		local WI
		local FI, sI, aI = 0, "", Z[39]
		OI = aI:FindFirstChild("RE/EggCapture/StandingsRefreshed")
		if OI then
			W(OI.OnClientEvent, function(OI)
				local aI = type(OI) == "table" and (OI.Entries or OI.Standings or OI)
				if type(aI) ~= "table" then
					return
				end
				sI = ""
				OI = ipairs
				for JI, YI in OI(aI) do
					if type(YI) == "table" then
						local OI = Z[1]
						if tonumber(YI.UserId) == OI.UserId then
							sI = ("  %.1fs  #%d"):format(tonumber(YI.Seconds) or 0, tonumber(YI.Rank) or JI)
							break
						end
					end
				end
			end)
		end
		ZI.on = function()
			local OI = Z[25]
			return OI.capture and wI() ~= nil
		end
		ZI.want = function()
			local OI = wI()
			return OI and Y(OI) and OI
		end
		ZI.run = function(OI, ZI)
			if not (Z[13](ZI)) then
				return
			end
			local aI = Z[20]
			aI.ready(ZI, 3)
			local JI, YI = 0.016666666666666666, 0
			while ZI() do
				local RI, eI = Y(OI), Z[15]
				aI = eI()
				if RI then
					if not aI then
						break
					end
				else
					break
				end
				local fI, QI = x(RI), Z[20]
				QI.godHunt = false
				if B(OI, RI) then
					QI = WI
					local uI, AI = not QI
					if QI then
						eI = os.clock() >= FI
						if eI then
							local QI = TI(WI, 13)
							local hI = not QI
							if QI then
								local QI
								QI, AI = Z[25], lI(WI) < Z[25].capAway
							else
								AI = hI
							end
						else
							AI = eI
						end
					else
						AI = uI
					end
					if AI then
						WI = EI(aI.Position)
					end
					FI = os.clock() + 0.25
					local lI, EI, FI = TI(aI.Position), WI
					if EI then
						FI = EI
					else
						uI, AI = Z[28]
						AI, FI = Z[25], uI(aI.Position.X, (lI and lI.y or aI.Position.Y) + Z[25].capH, aI.Position.Z)
					end
					v(FI, 220, JI)
					pI("Holding the event egg" .. sI)
				else
					if fI then
						WI = nil
						local lI = q:GetPlayerByUserId(fI)
						local EI
						if lI then
							local FI = Z[25]
							EI = FI.capTake
						else
							EI = lI
						end
						local FI
						if EI then
							local sI = Z[20]
							FI = sI.bat()
						else
							FI = EI
						end
						EI = nil
						if FI then
							local sI = Z[20]
							EI = sI.chase(lI, true)
						else
							EI = FI
						end
						if EI then
							FI = Z[20]
							FI.godHunt = true
							pI("Taking the event egg from " .. lI.DisplayName)
						else
							local EI = H(OI, RI)
							if EI then
								if TI(EI) then
									local FI = Z[28]
									v(EI + FI(0, 25, 0), 400, JI)
								end
							end
							local EI, FI = lI and lI.DisplayName or "Someone", Z[25]
							local lI, sI = FI.capTake
							if lI then
								FI = Z[20]
								sI = not FI.bat()
							else
								sI = lI
							end
							pI(EI .. " has the event egg" .. (sI and ", get a bat to take it" or ""))
						end
					else
						if RI.State == "Carried" then
							pI("Someone has the event egg")
						else
							local lI = H(OI, RI)
							if not lI then
								break
							end
							local EI = Z[28]
							local FI, sI = EI(lI.X - aI.Position.X, 0, lI.Z - aI.Position.Z).Magnitude, Z[16]
							EI = sI(aI.Position)
							sI = nil
							if EI then
								local eI = Z[16]
								sI = not eI(lI)
							else
								sI = EI
							end
							EI = nil
							if sI then
								local eI = Z[22]
								local fI = eI("Wall", "IsSealed")
								if fI then
									EI = fI
								else
									eI = Z[22]
									EI = eI("Cycle", "IsNightPhase", J())
								end
							else
								EI = sI
							end
							if EI then
								pI("Field wall is up, waiting to go out")
							else
								if FI > 220 and os.clock() >= YI then
									pI("Ragdoll jump to the event egg")
									YI = os.clock() + 4
									if
										MI(function()
											local EI = H(OI, Y(OI))
											local H
											if EI then
												local eI = Z[28]
												H = EI + eI(0, 3, 0)
											else
												H = EI
											end
											return H
										end, ZI)
									then
										YI = os.clock() + 2
										pI("Landed, grabbing the event egg")
										local H = os.clock() + 8
										while os.clock() < H and (ZI()) do
											local H = Y(OI)
											if H then
												if B(OI, H) then
													break
												elseif x(H) then
													break
												end
											else
												break
											end
											m(OI, ZI)
										end
									else
									end
								else
									if sI then
										pI("Leaving the base for the event egg")
										local x, H = Z[53], Z[28]
										x(lI + H(0, 2.5, 0), function()
											return ZI() and not B(OI, Y(OI))
										end, 400)
									elseif FI <= 220 then
										pI("Grabbing the event egg")
										m(OI, ZI)
									else
										local m = Z[28]
										v(lI + m(0, 2.5, 0), 400, JI)
										pI(("Going for the event egg  %d studs"):format(FI))
									end
								end
							end
						end
					end
				end
				RI = nil
				RI, JI = Z[23], math.clamp(Z[23](), 0.004166666666666667, 0.05)
			end
			local m = Z[20]
			WI = nil
			m.godHunt = false
			aI = Z[15]
			m = aI()
			aI = m and TI(m.Position, -4)
			if aI and m.Position.Y > aI.y + 8 then
				local x = Z[28]
				local H, B = x(m.Position.X, aI.y + 3.5, m.Position.Z), os.clock() + 1.5
				while true do
					local OI, ZI = os.clock() < B
					if OI then
						x = Z[15]
						ZI = (x())
					else
						ZI = OI
					end
					OI = nil
					if ZI then
						local x = Z[15]
						OI = (x().Position - H).Magnitude > 1
					else
						OI = ZI
					end
					if not OI then
						break
					end
					v(H, 160, JI)
					ZI = nil
					ZI, JI = Z[23], math.clamp(Z[23](), 0.004166666666666667, 0.05)
				end
			end
			aI = Z[8]
			m = aI()
			if m then
				m.PlatformStand = false
			end
		end
		local m = G({ name = "CaptureInfo", gap = 1 })
		m.on = function()
			return rI("Admin Abuse")
		end
		m.fn = function()
			local m, x =
				wI() or workspace:GetAttribute("Event_CaptureTheEgg") or workspace:GetAttribute(
					"Event_CaptureTheEggGameplay"
				),
				Z[25]
			if x.capture then
				if m then
					if Z[4] then
						if Z[4].name ~= "Capture" then
							if wI() then
								pI("Waiting for " .. Z[4].name .. " to finish")
							elseif not Z[4] then
								pI("Looking for the event egg")
							end
						elseif not Z[4] then
							pI("Looking for the event egg")
						end
					elseif not Z[4] then
						pI("Looking for the event egg")
					end
				else
					pI("Waiting for Capture The Egg")
				end
			else
				pI("Off")
			end
		end
		PI = dI["Minigame Eggs"]
		local function m(x)
			local H = Z[20]
			H.mgSt = x
		end
		j(PI, "Auto Steal Minigame Egg", "minigame", true, nil, "Red Light Green Light, T-Rex Run")
		local x = { { "RedLightGreenLight", "RLGL" }, { "TrexRun", "TrexRun" } }
		local H, B, v = G({ name = "Minigame", gap = 0.5 }), false, 0
		local function OI()
			local pI = Z[20]
			if pI.mgUid then
				local ZI, ZI, ZI = Z[20], Z[20], table.find(Z[20].pick, Z[20].mgUid)
				if ZI then
					table.remove(Z[20].pick, ZI)
				end
				ZI = Z[20]
				ZI.mgUid = nil
			end
			if B then
				pI = Z[21]
				if not (pI()) then
					local pI = Z[20]
					if pI.autoSteal then
						B = false
						D("mgSteal", function()
							local pI = Z[20]
							pI.autoSteal:Set(false)
						end)
					end
				end
			end
		end
		H.on = function()
			local pI = Z[25]
			local ZI, PI = pI.minigame
			if ZI then
				PI = ZI
			else
				pI = Z[20]
				PI = pI.mgUid ~= nil
			end
			return PI
		end
		H.fn = function()
			local H
			for pI, pI in ipairs(x) do
				if
					workspace:GetAttribute("Event_" .. pI[1]) == true
					or typeof(workspace:GetAttribute(pI[2] .. "_EggPosition")) == "Vector3"
				then
					H = pI[2]
					break
				end
			end
			local x = Z[25]
			if not (x.minigame and H) then
				OI()
				local pI = Z[25]
				return m(pI.minigame and "Waiting for Red Light Green Light or T-Rex Run" or "Off")
			end
			local pI, ZI, PI =
				workspace:GetAttribute(H .. "_CarrierUserId"), workspace:GetAttribute(H .. "_EggPosition"), Z[1]
			if pI == PI.UserId then
				return m("Carrying the egg home")
			end
			if type(pI) == "number" then
				if pI > 0 then
					PI = Z[20]
					PI.mgUid = nil
					return m("Another player has the egg")
				end
			end
			if typeof(ZI) ~= "Vector3" then
				OI()
				return m("Waiting for the egg to land")
			end
			PI, pI = pairs, Z[18]
			local wI, TI, lI = C[20](pI()), 40
			for WI, EI in PI(C:QH(wI)) do
				WI = type(EI) == "table"
					and EI.State ~= "Carried"
					and EI.State ~= "Claimed"
					and (EI.BottomCFrame or EI.BoundsCFrame)
				pI, x = typeof(WI) == "CFrame"
				if pI then
					local FI = Z[28]
					x = FI(WI.Position.X - ZI.X, 0, WI.Position.Z - ZI.Z).Magnitude
				else
					x = pI
				end
				if x then
					if x < TI then
						WI = EI.Uid
						TI, lI = x, WI
					else
					end
				else
				end
			end
			if not lI then
				OI()
				return m("Egg landed, looking for it")
			end
			ZI = Z[20]
			if ZI.atSafe then
				wI = Z[20]
				if wI.atSafe(Y(lI)) then
					OI()
					return m("The egg is at the safe zone")
				end
			end
			wI = Z[20]
			if lI ~= wI.mgUid or os.clock() - v > 2 then
				x, ZI = Z[20], os.clock()
				x.mgUid = lI
				v = ZI
				PI, pI = Z[20], table.find(Z[20].pick, lI)
				if pI ~= 1 then
					if pI then
						table.remove(Z[20].pick, pI)
					end
					table.insert(Z[20].pick, 1, lI)
					local Y = Z[20]
					Y.rank.Steal = 0
					Y = Z[20]
					Y.order()
				end
				if Z[4] then
					if Z[4].name == "Steal" then
						local Y = Z[20]
						if Y.curUid ~= lI then
							local Y = Z[21]
							if not (Y()) then
								CI(Z[4])
							end
						end
					end
				end
				local Y = Z[25]
				if not Y.steal then
					local Y = Z[20]
					if Y.autoSteal then
						B = true
						D("mgSteal", function()
							local Y = Z[20]
							Y.autoSteal:Set(true)
						end)
					end
				end
			end
			m("Going for the " .. (H == "RLGL" and "Red Light Green Light" or "T-Rex Run") .. " egg")
		end
		local Y = Z[20]
		Y.greenLight = function(Y, m)
			local x = os.clock() + 20
			while true do
				local H = Z[20]
				if
					not (
						Y == H.mgUid
						and workspace:GetAttribute("Event_RedLightGreenLight") == true
						and workspace:GetAttribute("RLGL_Light") ~= "Green"
						and os.clock() < x
						and (m())
					)
				then
					break
				end
				H = Z[11]
				H("Waiting for the green light")
				H = Z[23]
				H()
			end
		end
	end)
	w("37_banjo#1", function()
		local Y, m, x, H, B, v, OI =
			{ listen = 0, wrong = 0, acks = {}, next = 0 }, {}, Z[28], Z[28], Z[28], Z[28], Z[28]
		C:EH(
			m,
			0,
			x(6218.93, 17159.02, 16903.8),
			H(6257.93, 17159.02, 16912.8),
			B(6270.93, 17159.02, 16903.8),
			v(6244.93, 17159.02, 16918.8),
			OI(6231.93, 17159.02, 16912.8)
		)
		x = Z[28]
		local H, B = x(6244.93, 17159.02, 16880), Z[28]
		local x, v = B(6272.46, 17164.04, 16958.18), Z[28]
		local OI, pI = v(6246.9, 17161, 16887), Z[28]
		local v, ZI = pI(6246.9, 17165, 16881.6), Z[28]
		local pI, PI = ZI(5905.63, 17027.3, 15610.83), Z[28]
		local wI, TI = PI(6248.72, 17163, 16928), Z[28]
		local PI = TI(6248.72, 17163, 16944)
		local TI = d("CollectionService")
		local function lI()
			local WI = Z[67]
			local EI = WI()
			return EI and type(EI.BanjoCricket) == "table" and EI.BanjoCricket or {}
		end
		local function WI(EI)
			local FI, sI = pcall(function()
				return require(P.Data.BanjoCricket).PlaybackSeconds(EI)
			end)
			return FI and tonumber(sI) or EI * 0.65 + 0.5
		end
		B = Z[39]
		ZI = B:FindFirstChild("RE/BanjoCricket/Effect")
		if ZI then
			W(ZI.OnClientEvent, function(B)
				if type(B) ~= "table" then
					return
				end
				if B.Kind == "Playback" and type(B.Notes) == "table" then
					Y.notes, Y.listen = B.Notes, os.clock() + WI(#B.Notes)
				elseif B.Kind == "Note" then
					table.insert(Y.acks, { B.Mushroom, os.clock() })
					if #Y.acks > 40 then
						table.remove(Y.acks, 1)
					end
				elseif B.Kind == "Wrong" then
					Y.wrong = os.clock()
					Y.notes = nil
				elseif B.Kind == "Reset" then
					Y.notes = nil
				elseif B.Kind == "Solved" then
					Y.solved = true
				end
			end)
		end
		local function B(ZI)
			for WI, WI in ipairs(TI:GetTagged("BanjoCricketMushroom")) do
				if WI:GetAttribute("MushroomIndex") == ZI then
					local EI = WI:FindFirstChild("Hitbox") or WI:FindFirstChild("Hitbox Part")
					local FI, sI = pcall(function()
						return EI and EI.Position or WI:GetPivot().Position
					end)
					if FI then
						if sI then
							return sI
						end
					end
				end
			end
			return m[ZI]
		end
		local function m()
			local ZI, WI = pcall(function()
				return TI:GetTagged("BanjoCricketNpc")[1]:GetPivot().Position
			end)
			return ZI and WI or x
		end
		local function x(...)
			local ZI = Z[54]
			local TI = ZI("Build", "EnchantedTreeInterior", "Markers", ...)
			return TI and TI:IsA("BasePart") and TI.Position
		end
		local function ZI()
			local TI = Z[15]
			local WI = TI()
			return WI ~= nil
				and (WI.Position - (x("Passages", "SecretRoomSpawn") or x("SecretRoomSpawn") or OI)).Magnitude < 120
		end
		local function OI(TI)
			local WI, EI, FI = RaycastParams.new(), {}, Z[1]
			C:EH(EI, 0, FI.Character)
			WI.FilterDescendantsInstances, WI.FilterType = EI, Enum.RaycastFilterType.Exclude
			local sI, sI, sI = Z[28], Z[28], workspace:Raycast(TI + Z[28](0, 20, 0), Z[28](0, -80, 0), WI)
			EI = nil
			if sI then
				FI = nil
				FI, EI = Z[28], sI.Position + Z[28](0, 3, 0)
			else
				EI = sI
			end
			return EI or TI
		end
		local function TI(WI)
			local EI = Z[15]
			local FI = EI()
			if FI then
				EI = Z[26]
				EI(CFrame.lookAt(FI.Position, Z[28](WI.X, FI.Position.Y, WI.Z)))
			end
		end
		local function WI(EI, FI)
			local sI, aI = B(EI), Z[28]
			local B = aI(sI.X - H.X, 0, sI.Z - H.Z)
			aI = B.Magnitude > 0.1 and B.Unit
			if aI then
				B = aI
			else
				local H = Z[28]
				B = (H(0, 0, 1))
			end
			aI = Z[53]
			if not (aI(OI(sI + B * 6.5), FI, 60)) then
				return false
			end
			TI(sI)
			FI = Z[20]
			sI, aI = FI.bat(), Z[8]
			FI = aI()
			if sI then
				if not FI then
					return false
				end
			else
				return false
			end
			aI = Z[1]
			if sI.Parent ~= aI.Character then
				pcall(FI.EquipTool, FI, sI)
				task.wait(0.25)
			end
			s("RE/BanjoCricket/Aim", EI)
			EI = os.clock() + 2
			while
				os.clock() < EI
				and sI:GetAttribute("CooldownActive") == true
				and J() < (tonumber(sI:GetAttribute("CooldownEndTime")) or 0)
			do
				task.wait(0.05)
			end
			pcall(sI.Activate, sI)
			return true
		end
		local function H(B, EI, FI)
			local sI = os.clock() + FI
			while os.clock() < sI do
				if Y.wrong > EI then
					return "wrong"
				end
				for FI, FI in ipairs(Y.acks) do
					if FI[1] == B then
						if FI[2] > EI then
							return "ok"
						end
					end
				end
				task.wait(0.05)
			end
		end
		local function B(EI)
			local FI = os.clock() + 300
			Y.notes = nil
			local sI, aI = 0, 0
			while EI() and os.clock() < FI do
				local FI = Z[1]
				if FI:GetAttribute("InEnchantedTree") then
					if not (ZI()) then
						return false
					end
				else
					return false
				end
				if Y.solved then
					return true
				elseif lI().Solved == true then
					return true
				end
				FI = Y.notes
				if FI then
					if os.clock() < Y.listen then
						task.wait(0.05)
					else
						aI = 0
						Y.notes = nil
						local JI = Z[11]
						JI(("Playing back %d notes"):format(#FI))
						JI = ipairs
						for YI, RI in JI(FI) do
							YI = nil
							for FI = 1, 2, 1 do
								FI = os.clock()
								if not (WI(RI, EI)) then
									break
								end
								YI = H(RI, FI, 1.6)
								if YI then
									break
								end
							end
							if YI ~= "ok" then
								RI = Z[11]
								RI("Missed a note, starting over", "warn")
								break
							end
						end
						sI = os.clock()
					end
				else
					if os.clock() - sI > 4 then
						aI += 1
						if aI > 12 then
							local H = Z[11]
							H("The mushrooms do not answer", "warn")
							return false
						end
						local H = Z[11]
						H("Waking the mushrooms")
						WI(4, EI)
						sI = os.clock()
					else
					end
					task.wait(0.1)
				end
			end
			return false
		end
		local function H(WI)
			if ZI() then
				return true
			end
			for EI = 1, 2, 1 do
				EI = Z[54]
				local FI = EI("Build", "EnchantedTreeInterior", "SecretLeapHint", "Streaks")
				local sI, aI = FI and FI:IsA("BasePart") and FI.Position or pI, Z[15]
				EI = aI()
				if not EI then
					return false
				end
				aI = Z[11]
				aI("Flying to the Secret Leap")
				aI, FI = Z[53], Z[28]
				if aI(FI(EI.Position.X, sI.Y + 18, EI.Position.Z), WI, 120) then
					local pI, EI = Z[53], Z[28]
					if not (pI(sI + EI(0, 18, 0), WI, 120)) then
						return false
					end
				else
					return false
				end
				sI = Z[11]
				sI("Taking the Secret Leap")
				aI = os.clock() + 8
				while os.clock() < aI and (WI()) and not ZI() do
					task.wait(0.1)
				end
				if ZI() then
					task.wait(1)
					return true
				end
			end
			return false
		end
		local function pI(WI)
			task.wait(5)
			for EI = 1, 3, 1 do
				local FI, sI = m(), Z[15]
				EI = sI()
				if EI and (EI.Position - FI).Magnitude > 9 then
					sI = Z[11]
					sI("Going to Jitterbug")
					local m = Z[28]
					local aI = m(PI.X - FI.X, 0, PI.Z - FI.Z)
					m = aI.Magnitude > 0.1 and aI.Unit
					if m then
						aI = m
					else
						local JI = Z[28]
						aI = (JI(0, 0, -1))
					end
					local JI, YI = ipairs, { OI(wI), OI(PI), OI(FI + aI * 6) }
					for OI, OI in JI(YI) do
						m = Z[53]
						if not (m(OI, WI, 60)) then
							return false
						end
					end
					TI(FI)
				end
				FI = Z[11]
				FI("Claiming Cricket's Banjo")
				EI = Z[9]
				sI, FI = EI("RF/BanjoCricket/AskClaim")
				if FI == true then
					return true
				elseif lI().Claimed == true then
					return true
				end
				task.wait(1)
			end
			return lI().Claimed == true
		end
		local function m()
			local OI = Z[8]
			local PI = OI()
			local function wI()
				return true
			end
			if PI then
				pcall(PI.UnequipTools, PI)
			end
			if ZI() then
				OI, PI = x("Passages", "SecretRoomExit") or v, Z[53]
				PI(OI, wI, 60)
				local x = os.clock() + 5
				while os.clock() < x and (ZI()) do
					local x, v = Z[26], Z[27]
					x(v(OI))
					task.wait(0.1)
				end
			end
			wI = Z[20]
			wI.leaveTree()
		end
		local x = G({ name = "Banjo", mover = true, gap = 3, pri = 6, soft = true })
		x.on = function()
			local v = Z[25]
			return v.banjo and not Y.done
		end
		local function v(OI)
			local ZI = Z[20]
			if ZI.wispSay then
				local ZI = Z[20]
				ZI.wispSay("Banjo cricket: " .. OI)
			end
		end
		x.want = function()
			if lI().Claimed == true then
				Y.done = true
				return v("done, Cricket's Banjo is yours")
			end
			local OI = Z[1]
			if OI:GetAttribute("EnchantedTreeUnlocked") ~= true then
				return v("needs the Enchanted Tree open (finish the wisp quest)")
			end
			OI = Z[20]
			if not (OI.bat()) then
				return v("needs a bat in your bag")
			end
			if os.clock() < Y.next then
				return
			end
			return true
		end
		x.run = function(x, OI)
			x = Z[20]
			if not (x.needBody()) then
				return v("leaving invisibility first")
			end
			Y.next = os.clock() + 15
			if Z[13](OI) then
				x = Z[20]
				if not (x.enterTree(OI)) then
					return v("could not get into the Enchanted Tree")
				end
			else
				return v("could not get into the Enchanted Tree")
			end
			if not (H(OI)) then
				m()
				return v("could not take the Secret Leap")
			end
			if lI().Solved ~= true then
				if not Y.solved then
					if not (B(OI)) then
						m()
						return v("puzzle not solved, trying again")
					end
				end
			end
			if pI(OI) then
				Y.done = true
				c("Banjo", "Cricket's Banjo claimed", "ok")
				v("done, Cricket's Banjo is yours")
			end
			m()
		end
	end)
	w("38_world#1", function()
		local Y, m, x, H, B =
			{ cd = {}, shot = 0, at = 0 },
			{ Prep = true, Match = true, SuddenDeath = true },
			{ Intro = true, Reveal = true, Prep = true, Match = true, SuddenDeath = true, Win = true, Outro = true }
		local v = G({ name = "Dawn", gap = 1 })
		v.on = function()
			local v = o() > 0
			if v then
				if H == false then
					B = os.clock()
				end
			end
			H = v
			return false
		end
		local H = Z[20]
		H.dawnNow = function()
			local H = os.clock() - (B or -99)
			return H < 20
		end
		local H = Z[20]
		H.stealDawn = function(H, v)
			local OI, pI = os.clock() - (B or -99), Z[25]
			local B, ZI = pI.steal
			if B then
				pI = v and o() <= 0
				if pI then
					ZI = pI
				else
					local v = OI < 20
					if v then
						local pI = OI < 10
						if pI then
							ZI = pI
						else
							local pI = Z[20]
							ZI = pI.stealWants()
						end
					else
						ZI = v
					end
				end
			else
				ZI = B
			end
			B = nil
			if ZI then
				OI = Z[20]
				B = (OI.rank["Steal:filter"] or 9) < H
			else
				B = ZI
			end
			return B
		end
		local function H(B)
			local v = Z[28]
			return v(B.X, 0, B.Z)
		end
		local function B(v)
			if typeof(v) ~= "Instance" then
				return nil
			end
			if v:IsA("BasePart") then
				return v.Position
			elseif v:IsA("Attachment") then
				return v.WorldPosition
			elseif v:IsA("Model") then
				return v:GetPivot().Position
			end
			return v.Parent and B(v.Parent)
		end
		local v = Z[20]
		v.normalWalk = function(v)
			if v.WalkSpeed >= 16 then
				return v.WalkSpeed
			end
			local v, OI = pcall(function()
				local pI = Z[67]
				return require(P.Shared.Util.TreadmillUtil).SpeedPowerToWalkSpeed(pI().SpeedPower)
			end)
			return v and tonumber(OI) and OI >= 16 and OI or 16
		end
		local function v(OI)
			local pI = Z[8]
			local ZI = pI()
			if OI then
				if ZI then
					pI = Z[1]
					if OI.Parent ~= pI.Character then
						pcall(ZI.EquipTool, ZI, OI)
					end
				end
			end
			return OI
		end
		local function OI(pI)
			local ZI = Z[15]
			local PI = ZI()
			if PI and pI then
				local ZI = H(pI - PI.Position)
				if ZI.Magnitude > 0.1 then
					pcall(function()
						local pI = Z[27]
						PI.CFrame = pI(PI.Position, PI.Position + ZI.Unit)
					end)
				end
			end
		end
		local function pI(ZI, PI)
			local wI = Z[39]
			local TI = wI:FindFirstChild(ZI)
			if TI then
				if TI:IsA("RemoteEvent") then
					W(TI.OnClientEvent, PI)
				end
			end
		end
		local function ZI(PI)
			if type(PI) == "table" then
				Y.snap, Y.at = PI, os.clock()
			end
		end
		Y.me = function()
			local PI, wI = Y.snap, ipairs
			local TI = PI and type(PI.Entries) == "table" and PI.Entries or {}
			for lI, lI in wI(TI) do
				if type(lI) == "table" then
					PI = Z[1]
					if lI.UserId == PI.UserId then
						return lI
					end
				end
			end
		end
		Y.held = function()
			local PI = Y.snap
			return PI ~= nil and x[PI.Phase] == true and os.clock() - Y.at < 30 and Y.me() ~= nil
		end
		local PI, wI = { Liftoff = true, Launch = true, Chase = true, Boss = true, Finale = true }, Z[20]
		wI.peteRaid = function()
			return workspace:GetAttribute("PeteRaidLockdown") == true
				or workspace:GetAttribute("Event_PeteSpaceRaid") == true
					and PI[workspace:GetAttribute("PeteRaidPhase") or ""] == true
		end
		local PI = Z[20]
		PI.lock = function()
			local PI = Z[20]
			if PI.peteRaid() then
				return "PeteRaid"
			end
			PI = Z[20]
			if PI.fuseZone then
				local PI = Z[20]
				if PI.fuseZone() then
					return "FuseZone"
				end
			end
			if Y.held() then
				return "IslandWars"
			end
		end
		local PI = Z[20]
		PI.realHum = function()
			local PI = Z[20]
			local wI, TI = PI.peteRaid() or Y.held()
			if wI then
				TI = wI
			else
				PI = Z[1]
				TI = PI:GetAttribute("RaceId") ~= nil
			end
			return TI
		end
		local PI = Z[20]
		PI.highOk = function()
			local PI = Z[20]
			return (PI.lock() or "FuseZone") ~= "FuseZone"
		end
		local PI
		local wI, TI = 0, Z[20]
		TI.hideTread = function(TI)
			wI = math.max(wI, os.clock() + TI)
			if PI then
				return
			end
			local TI = {}
			PI = TI
			for lI, WI in ipairs(workspace:FindFirstChild("Plots") and workspace.Plots:GetChildren() or {}) do
				lI = { "TreadmillBottom", "TreadmillUpgrade" }
				for EI, FI in ipairs(lI) do
					EI = WI:FindFirstChild(FI)
					for lI, lI in ipairs(EI and (EI:IsA("BasePart") and { EI } or EI:GetDescendants()) or {}) do
						if lI:IsA("BasePart") then
							TI[#TI + 1] = { lI, lI.CanTouch, lI.CanCollide }
							lI.CanTouch = false
							lI.CanCollide = false
						end
					end
				end
			end
			task.spawn(function()
				while true do
					local lI, WI = os.clock(), wI
					if not (lI < WI) then
						break
					end
					task.wait(0.2)
				end
				for wI, wI in ipairs(TI) do
					if wI[1].Parent then
						wI[1].CanTouch, wI[1].CanCollide = wI[2], wI[3]
					end
				end
				PI = nil
			end)
		end
		local PI = Z[1]
		W(PI.CharacterAdded, function()
			local wI = Z[20]
			wI.hideTread(6)
		end)
		local function wI()
			local TI = Z[9]
			local lI, lI = TI("RF/IslandWars/Fetch")
			ZI(lI)
		end
		pI("RE/LiveEvents/Began", function(TI)
			if TI == "CursedIslandWars" then
				Y.sd = false
				Y.col = nil
				task.spawn(wI)
			end
		end)
		pI("RE/LiveEvents/Ended", function(TI)
			if TI == "CursedIslandWars" then
				Y.snap = nil
				Y.sd = false
				Y.col = nil
			end
		end)
		local TI = G({ name = "IslandWarsInfo", gap = 5 })
		TI.on = function()
			return Y.snap ~= nil and x[Y.snap.Phase] == true
		end
		TI.fn = wI
		pI("RE/IslandWars/State", ZI)
		pI("RE/IslandWars/Moment", function(x, ZI, TI)
			if x == "Cooldown" and type(ZI) == "string" then
				Y.cd[ZI] = tonumber(TI) or 0
			elseif
				x == "SuddenDeath"
				or x == "EarlySuddenDeath"
				or x == "Warning" and tonumber(ZI) and tonumber(ZI) <= 15
			then
				Y.sd = true
			elseif x == "CollapseWarn" and type(ZI) == "table" then
				Y.col, Y.colAt = ZI, os.clock()
			elseif x == "Win" then
				Y.sd = false
			elseif x == "Outro" then
				Y.sd = false
			end
		end)
		task.spawn(function()
			local x = Z[9]
			local ZI, ZI = x("RF/LiveEvents/FetchRunning")
			if type(ZI) == "table" then
				if ZI.CursedIslandWars then
					wI()
				end
			end
		end)
		local function x(ZI)
			pcall(function()
				local wI = require(P.Controllers.Game.AdminAbuseClientController.Events.CursedIslandWars.Input)
				Y.k0 = Y.k0 or wI.Knock
				wI.Knock = ZI and function() end or Y.k0
			end)
		end
		table.insert(Z[20].cleanup, function()
			x(false)
		end)
		local function ZI()
			local wI = Z[15]
			local TI = wI()
			if TI then
				if Y.col then
					if not (os.clock() - Y.colAt < 8) then
						return false
					end
				else
					return false
				end
			else
				return false
			end
			wI = RaycastParams.new()
			wI.FilterType = Enum.RaycastFilterType.Include
			wI.FilterDescendantsInstances = Y.col
			local lI, lI = Z[28], workspace:Raycast(TI.Position, Z[28](0, -14, 0), wI)
			return lI ~= nil
		end
		local function wI(TI)
			return O(function(O)
				return O.Name == TI
			end)
		end
		local O =
			G({ name = "IslandWars", mover = true, gap = 0.3, pri = -2, urgent = true, hold = true, where = "any" })
		O.on = function()
			local TI, lI, WI = Y.snap, Y.me(), Z[25]
			return WI.ciw
				and TI ~= nil
				and m[TI.Phase] == true
				and lI ~= nil
				and lI.State == "Alive"
				and os.clock() - Y.at < 30
		end
		O.want = function()
			return true
		end
		O.run = function(TI, lI)
			x(true)
			while lI() do
				local lI, WI, EI = Y.snap, Y.me(), Z[15]
				TI = EI()
				if lI then
					if WI then
						if TI then
							if WI.State == "Alive" then
								if not m[lI.Phase] then
									break
								end
							else
								break
							end
						else
							break
						end
					else
						break
					end
				else
					break
				end
				local m, FI, sI =
					WI.Team == "Red" and "Blue" or "Red", J(), lI.Island and lI.Island:FindFirstChild("Centre")
				WI = B(sI and (sI:FindFirstChild("Top")))
				EI = WI and (Y.sd or lI.Phase == "SuddenDeath" or ZI())
				if EI then
					if H(TI.Position - WI).Magnitude > 18 then
						local ZI = Z[11]
						ZI("Island Wars: moving to the centre")
						local ZI, sI
						ZI, sI, TI.AssemblyLinearVelocity =
							Z[44],
							Z[28],
							H(WI - TI.Position).Unit * math.max(Z[44](), 30) + Z[28](0, TI.AssemblyLinearVelocity.Y, 0)
					end
				end
				EI, WI = 25
				for H, ZI in ipairs(type(lI.Entries) == "table" and lI.Entries or {}) do
					H = type(ZI) == "table"
						and ZI.Team == m
						and ZI.State == "Alive"
						and typeof(ZI.Model) == "Instance"
						and ZI.Model:FindFirstChild("HumanoidRootPart")
					ZI = H and (H.Position - TI.Position).Magnitude
					if ZI then
						if ZI < EI then
							EI, WI = ZI, H
						else
						end
					else
					end
				end
				local H = Z[25]
				WI = if H.ciwT == "Walls and crystal" then nil else WI
				if lI.Phase ~= "Prep" then
					local ZI, sI = wI("Bat"), wI("PumpkinLauncher")
					if WI and EI <= 10 and ZI and FI >= (Y.cd.Bat or 0) then
						H = Z[11]
						H("Island Wars: hitting an enemy")
						v(ZI)
						OI(WI.Position)
						s("RE/IslandWars/Use", "Swing", WI)
						Y.cd.Bat = math.max(Y.cd.Bat or 0, FI + 0.75)
					elseif sI then
						if FI >= (Y.cd.PumpkinLauncher or 0) then
							local H, ZI =
								type(lI.Barriers) == "table" and lI.Barriers[m],
								type(lI.Crystals) == "table" and lI.Crystals[m]
							local m = WI and WI.Position + WI.AssemblyLinearVelocity * (EI / 110)
								or H and (tonumber(H.Health) or 0) > 0 and typeof(H.Model) == "Instance" and B(
									H.Model:FindFirstChild("Hitbox") or H.Model
								)
								or ZI
									and (tonumber(ZI.Health) or 0) > 0
									and typeof(ZI.Model) == "Instance"
									and B(ZI.Model:FindFirstChild("Pivot", true) or ZI.Model)
							if m then
								H = Z[11]
								H(WI and "Island Wars: shooting an enemy" or "Island Wars: shooting the enemy base")
								v(sI)
								OI(m)
								ZI = sI:FindFirstChild("Handle") and sI.Handle:FindFirstChild("Muzzle")
								local H, B = ZI and ZI:IsA("Attachment") and ZI.WorldPosition
								if H then
									B = H
								else
									local H
									H, B = Z[28], TI.Position + Z[28](0, 1.5, 0)
								end
								if (m - B).Magnitude > 1 then
									Y.shot = Y.shot + 1
									s("RE/IslandWars/Use", "Launch", Y.shot, B, (m - B).Unit)
									Y.cd.PumpkinLauncher = math.max(Y.cd.PumpkinLauncher or 0, FI + 1.25)
								end
							end
						end
					end
				end
				WI = Z[23]
				WI()
			end
			return true
		end
		pI = dI["Cursed Island Wars"]
		local m = N("ciw", pI:Text("Cursed Island Wars Status", "Waiting for Cursed Island Wars"))
		j(pI, "Auto Play Cursed Island Wars", "ciw", true, function(H)
			x(H and Y.held())
			if not H then
				CI(O)
			end
		end)
		PI = Z[25]
		PI.ciwT = "Enemies and base"
		pI:Dropdown("Island Wars Target", { "Enemies And Base", "Walls And Crystal" }, "Enemies And Base", function(O)
			local x = Z[25]
			x.ciwT = O == "Walls And Crystal" and "Walls and crystal" or "Enemies and base"
		end)
		local O = G({ name = "WarsInfo", gap = 1 })
		O.on = function()
			return rI("Admin Abuse") or rI("Event")
		end
		O.fn = function()
			local O, x, H = Y.snap, Y.me(), Z[25]
			local Y = H.ciw
			m(
				(if Y then not Y else "Off")
					or O and x and O.Phase .. " | Team " .. tostring(x.Team) .. " | " .. tostring(x.State)
					or O and "Watching, you are not on a team"
					or "Waiting for Cursed Island Wars"
			)
		end
	end)
	w("39_sky#1", function()
		local O = select(2, pcall(require, P.Shared.Util.StormheartCave))
		local Y = select(2, pcall(require, P.Shared.Util.BlackMarket))
		local m, x = select(2, pcall(require, P.Data.BlackMarket)), Z[39]
		local H, B = x:FindFirstChild("RE/StormheartCave/Rockfall"), Z[39]
		local x, v = B:FindFirstChild("RE/StormheartCave/Rush"), Z[28]
		local OI, pI = v(3200, 73, -365), Z[28]
		local v, ZI = pI(3032, 70, -417), Z[28]
		local PI, wI, TI, lI = ZI(8455, 71, -385), {}, {}
		local WI = G({ name = "Skyfall", mover = true, gap = 0.3, pri = 2 })
		local EI = G({ name = "Storm", mover = true, gap = 0.5, pri = 3 })
		local FI, sI, aI = G({ name = "Market", mover = true, gap = 1, pri = 3 }), {}, {}
		for JI, YI in ipairs(type(m) == "table" and m.Items or {}) do
			JI, ZI = YI.StockMin or 1, YI.StockMax or 1
			B = (
				tostring(YI.DisplayName or YI.Id):gsub(" Mutation$", "")
				.. ((YI.Kind == "Mutation" or YI.Kind == "Item") and " Mutation" or "")
			)
				.. " ("
				.. ((ZI > 1 and "x" .. (JI < ZI and JI .. "-" or "") .. ZI .. " - " or "") .. math.floor(
					YI.PriceHours * 10 + 0.5
				) / 10 .. "h of income")
				.. ")"
			sI[#sI + 1] = B
			aI[B] = YI
		end
		local function B()
			local JI, YI = {}, Z[25]
			for RI, eI in ipairs(YI.bmItems or {}) do
				RI = aI[eI]
				if RI then
					JI[RI.Id] = RI
				end
			end
			return JI
		end
		local JI, YI =
			{
				{ "Thunderstones", "rbxassetid://88230767796973", "#9EC2FF" },
				{ "Sparks", "rbxassetid://130172726226674", "#FFE066" },
				{ "Stormglass", "rbxassetid://114978474800693", "#7FD8FF" },
				{ "Thunderous", "rbxassetid://83094668121358", "#6C8CFF" },
			},
			"Off"
		local RI, eI, fI = dI.Skyfall, dI["Black Market"], { texts = {}, shown = {} }
		RI:Surface({
			Name = "Skyfall Counters",
			ShowTitle = false,
			Layout = "free",
			Style = {
				TextScale = 1,
				LineHeight = 1.1,
				MinLines = 4.4,
				MaxLines = 4.4,
				AutoHeight = true,
				BackgroundTransparency = 0.35,
				TextColor = Color3.fromRGB(255, 255, 255),
				TextStrokeTransparency = 0.6,
			},
			Build = function(QI)
				fI.st = QI:Text({
					X = 0.7,
					Y = 0.2,
					Width = 1,
					Height = 1.5,
					Scale = 1.35,
					Wrap = false,
					Text = YI,
					Color = "#FFFFFF",
					TextStrokeTransparency = 0.6,
				})
				local uI, AI = {}, 24
				for hI, mI in ipairs(JI) do
					uI[hI] = QI:Image({
						X = 0.7 + (hI - 1) * 5,
						Y = 1.95,
						Width = 2.2,
						Height = 2.2,
						Image = mI[2],
						BackgroundTransparency = 1,
					})
					fI.texts[mI[1]] = QI:Text({
						X = 3.1 + (hI - 1) * 5,
						Y = 2.2,
						Width = 2.5,
						Height = 1.7,
						Scale = 1.45,
						Wrap = false,
						Text = "0",
						Color = mI[3],
						TextStrokeTransparency = 0.6,
					})
				end
				QI:SetContentLines(4.4)
				function fI.lay()
					local hI, mI = {}, 0
					for kI, LI in ipairs(JI) do
						hI[kI] = 2.5 + #(fI.shown[LI[1]] or "0") * 0.8
						mI += hI[kI]
					end
					local kI, LI = math.max(0.5, (AI - 1.4 - mI) / (#JI - 1)), 0.7
					for mI, gI in ipairs(JI) do
						uI[mI].Set({ X = LI })
						local JI, uI = fI.texts, gI[1]
						local gI, iI = JI[uI].Set, { X = LI + 2.5 }
						iI.Width = hI[mI] - 2.5 + 0.4
						gI(iI)
						LI += hI[mI] + kI
					end
				end
				local JI
				QI:OnResize(function(QI, QI, uI)
					if QI ~= JI then
						JI = QI
						AI = QI / math.max(uI, 1)
						fI.lay()
					end
				end)
			end,
		})
		local function JI(QI)
			YI = QI
			D("skySt", function()
				if fI.st then
					fI.st.Set({ Text = QI })
				end
			end)
		end
		j(RI, "Auto Skyfall", "sky", false, function(YI)
			if not YI then
				CI(WI)
			end
		end)
		j(RI, "Auto Start Storm Rush", "skyStart", false, function(YI)
			if not YI then
				local YI = Z[25]
				if not YI.skyJoin then
					CI(EI)
				end
			end
		end, "Starts it with your Stormglass, then collects Sparks")
		j(RI, "Auto Join Storm Rush", "skyJoin", false, function(YI)
			if not YI then
				local YI = Z[25]
				if not YI.skyStart then
					CI(EI)
				end
			end
		end, "Joins others' rushes and collects Sparks")
		j(RI, "Auto Trade Sparks", "skyTrade", false)
		j(RI, "Auto Buy Stormy Egg", "skyGacha", false)
		m = Z[20]
		local YI, YI = Z[20], K(RI, "Switch Weapons", "skyW", m.ownedWeapons, Z[20].ownedWeapons(), nil, true)
		X(RI, "Tween Speed", "skySpd", 100, 700, 400, nil, 10)
		j(RI, "Teleport", "skyTp", false, nil, "Teleport between rocks and Sparks instead of tween")
		j(RI, "Fast Cave Trips", "skyFast", true, nil, "Enter and leave the Cave faster")
		RI = {}
		for m, QI in next, aI, nil do
			if QI.Id == "BlacklistedMutation" then
				RI[#RI + 1] = m
			elseif QI.Id == "SpiritBloomMutation" then
				RI[#RI + 1] = m
			end
		end
		local m = N("bm", eI:Text("Black Market Status", "Off"))
		j(eI, "Auto Buy Black Market", "bm", false, function(aI)
			if not aI then
				CI(FI)
			end
		end)
		K(eI, "Items To Buy", "bmItems", sI, RI, nil, true)
		X(eI, "Amount Per Item", "bmQty", 1, 5, 5, nil, 1)
		X(
			eI,
			"Max Price",
			"bmMaxH",
			0,
			25,
			0,
			"h",
			1,
			nil,
			"Skip items that cost more than this many hours of your pet income (0 = any price)"
		)
		j(eI, "Unequip Pets For Lower Prices", "bmPets", false, nil, "Unequip before buying, Equip Best after")
		j(eI, "Auto Use Free Rerolls", "bmRoll", false, nil, "Only uses rerolls you already have")
		if H then
			W(H.OnClientEvent, function(sI, aI, RI)
				if sI == "Drop" then
					wI[aI] = RI
				elseif sI == "Collected" then
					wI[aI] = nil
				elseif sI == "DropGone" then
					wI[aI] = nil
				elseif sI == "Clear" then
					table.clear(wI)
				end
			end)
		end
		if x then
			W(x.OnClientEvent, function(x, sI)
				if x == "Begin" and type(sI) == "table" and sI.Eligible == true then
					lI, TI = sI, {}
					local aI, RI = ipairs, type(sI.Sparks) == "table" and sI.Sparks or {}
					for QI, uI in aI(RI) do
						QI = O.DecodeSpark(uI)
						if QI then
							uI = TI
							uI[QI.Id] = QI
						end
					end
				elseif x == "Rejected" and lI then
					local aI = lI
					aI.taken = aI.taken or {}
					aI = nil
					aI, lI.taken[sI] = lI, nil
					aI.wait = nil
				elseif x == "Collected" and lI then
					if lI.wait then
						lI.taken[lI.wait] = true
					end
					lI.wait = nil
				elseif x == "End" then
					lI = nil
				elseif x == "Left" then
					lI = nil
				end
			end)
		end
		local function x()
			local sI, sI, aI = Z[34], pcall(Z[34].Save.Peek)
			return sI and type(aI) == "table" and aI or {}
		end
		local function sI(aI)
			return tonumber((x().Stormlands or {})[aI]) or 0
		end
		local function aI()
			return tonumber((x().GearInventory or {}).Stormglass) or 0
		end
		local RI = G({ name = "SkyInfo", gap = 1, info = true })
		RI.on = function()
			return rI("Event")
		end
		RI.fn = function()
			local RI, QI = x(), Z[20]
			local uI, AI = QI.mutItems
			if uI then
				QI = nil
				QI, AI = Z[20], select(2, Z[20].mutItems())
			else
				AI = uI
			end
			local QI, uI = AI or {}, {}
			uI.Thunderstones = A((RI.Stormlands or {}).Thunderstones or 0)
			uI.Sparks = A((RI.Stormlands or {}).Sparks or 0)
			uI.Stormglass = tostring((RI.GearInventory or {}).Stormglass or 0)
			uI.Thunderous = tostring(QI.Thunderous or 0)
			D("skyCnt", function()
				local RI
				for QI, AI in next, fI.texts, nil do
					if fI.shown[QI] ~= uI[QI] then
						fI.shown[QI] = uI[QI]
						AI.Set({ Text = uI[QI] })
						RI = true
					else
					end
				end
				if RI then
					if fI.lay then
						fI.lay()
					end
				end
			end)
		end
		local function RI(fI)
			return workspace:GetAttribute(fI)
		end
		local function fI()
			return J() < (tonumber(RI("StormheartRockfallEndsAt")) or 0) and o() > 0
		end
		local function QI()
			local uI = Z[1]
			return uI:GetAttribute("InStormheartCave") == true
		end
		local function uI(AI)
			return type(O) == "table" and O.Marker(O.LoadedMap(), AI)
		end
		local function AI(hI)
			local mI, kI, LI = ipairs, {}, Z[1]
			C:EH(kI, 0, LI.Character, t())
			for LI, LI in mI(kI) do
				for mI, mI in ipairs(LI and LI:GetChildren() or {}) do
					if mI:IsA("Tool") then
						if mI:GetAttribute("GearName") == hI then
							return mI
						end
					end
				end
			end
		end
		local hI = {}
		local mI = -1
		local kI, LI = -1, Z[25]
		local gI = LI.skyW
		task.defer(function()
			local LI = Z[20]
			for iI, iI in ipairs(LI.ownedWeapons()) do
				if type(gI) == "table" then
					if #gI > 0 then
						if not (table.find(gI, iI)) then
							hI[iI] = true
						end
					end
				end
			end
		end)
		local function LI()
			local gI = Z[20]
			local iI, tI = gI.ownedWeapons(), ipairs
			for xI, SI in tI(iI) do
				xI = Z[25]
				if table.find(xI.skyW or {}, SI) then
					hI[SI] = nil
				else
					gI = kI
					if gI == #iI then
						hI[SI] = true
					end
				end
			end
			tI, gI = #iI ~= kI
			if tI then
				gI = tI
			else
				local xI = Z[20]
				gI = xI.wVer ~= mI
			end
			if gI then
				local xI, SI = #iI, Z[20]
				tI = SI.wVer
				kI, mI = xI, tI
				local mI = {}
				for kI, kI in ipairs(iI) do
					if not hI[kI] then
						mI[#mI + 1] = kI
					end
				end
				xI = Z[25]
				xI.skyW = mI
				pcall(function()
					YI:Set(mI, true)
				end)
			end
			iI, tI = ipairs, Z[25]
			local YI, hI = tI.skyW or {}
			for mI, mI in iI(YI) do
				tI = Z[20]
				gI = AI(tI.weaponId[mI] or mI)
				if gI then
					if J() >= (tonumber(gI:GetAttribute("CooldownEndTime")) or 0) then
						return gI
					end
				end
				hI = hI or gI
			end
			tI = nil
			if hI then
				tI = hI
			else
				gI = Z[20]
				tI = gI.bat()
			end
			return tI
		end
		local function YI(hI)
			local mI = Z[8]
			local kI = mI()
			if hI then
				if kI then
					mI = Z[1]
					if hI.Parent ~= mI.Character then
						pcall(kI.EquipTool, kI, hI)
					end
				end
			end
			return hI
		end
		local function hI(mI, kI, gI)
			local iI = Z[8]
			local tI, xI = iI(), os.clock()
			if tI then
				tI.PlatformStand = true
			end
			repeat
				iI = Z[26]
				iI(mI)
				tI = Z[23]
				tI()
			until os.clock() - xI >= kI or gI and gI()
			iI = Z[8]
			xI = iI()
			if xI then
				xI.PlatformStand = false
			end
		end
		local function mI(kI, gI, iI, tI)
			local xI = Z[28]
			kI += xI(0, 3, 0)
			xI = Z[15]
			local SI = xI()
			xI = nil
			if not tI then
				if SI then
					if (SI.Position - kI).Magnitude > 300 then
						MI(kI, gI)
					end
				end
				local HI = Z[15]
				xI = HI()
				if xI then
					if (xI.Position - kI).Magnitude > 30 then
						local _I, oI = Z[26]
						if iI then
							HI = Z[27]
							oI = (HI(kI, iI))
						else
							oI = iI
						end
						local HI
						if oI then
							HI = oI
						else
							local oI = Z[27]
							HI = (oI(kI))
						end
						_I(HI)
					end
				end
				return gI()
			end
			tI = Z[25]
			if tI.skyTp then
				local HI, _I = Z[26]
				if iI then
					local oI = Z[27]
					_I = (oI(kI, iI))
				else
					_I = iI
				end
				local oI
				if _I then
					oI = _I
				else
					local _I = Z[27]
					oI = (_I(kI))
				end
				HI(oI)
				return gI()
			end
			xI = SI
			while xI and (gI()) and (xI.Position - kI).Magnitude > 2 do
				local HI, _I, oI, BI, BI = kI - xI.Position, Z[26], Z[27], Z[25], Z[23]
				_I(
					oI(
						xI.Position
							+ HI.Unit
								* math.min(HI.Magnitude, math.min(Z[25].skySpd or 400, 700) * math.min(Z[23](), 0.1))
					)
				)
				tI = Z[15]
				xI = (tI())
			end
			if iI then
				tI, SI = Z[26], Z[27]
				tI(SI(kI, iI))
			end
			return gI()
		end
		local function kI(gI, iI)
			local tI = Z[15]
			local xI = tI()
			tI = nil
			if xI then
				local SI = Z[16]
				tI = SI(xI.Position)
			else
				tI = xI
			end
			local SI, HI = not tI
			if tI then
				xI = Z[17]
				HI = (xI(gI, iI))
			else
				HI = SI
			end
			return HI
		end
		local function gI(iI)
			if iI and fireproximityprompt then
				pcall(function()
					iI.HoldDuration = 0
					fireproximityprompt(iI)
				end)
			end
		end
		local function iI()
			local tI = workspace:FindFirstChild("StormheartRockfallLocal")
			tI = tI and (tI:FindFirstChild("Rocks"))
			local xI = Z[15]
			local SI = xI()
			local HI, _I
			for oI, BI in ipairs(tI and tI:GetChildren() or {}) do
				if SI then
					if BI:IsA("BasePart") then
						xI = tonumber(BI:GetAttribute("Health"))
						if xI then
							if xI > 0 then
								if BI:GetAttribute("Locked") then
								else
									oI = (BI:FindFirstChild("InfusedCracks") and 100000 or 0)
										- (BI.Position - SI.Position).Magnitude
									if HI then
										if oI > HI then
											HI, _I = oI, BI
										else
										end
									else
										HI, _I = oI, BI
									end
								end
							else
							end
						else
						end
					else
					end
				else
				end
			end
			return _I
		end
		WI.on = function()
			local tI = Z[25]
			if not tI.sky then
				return false
			end
			if fI() then
				if Z[4] ~= WI then
					JI(
						("Skyfall now, ends in %ds"):format(
							math.floor((tonumber(RI("StormheartRockfallEndsAt")) or 0) - J())
						)
					)
				end
				return true
			end
			if J() < (tonumber(RI("StormheartRockfallEndsAt")) or 0) then
				JI("Night, Skyfall waits for the day")
				return false
			end
			tI = math.max((tonumber(RI("StormheartRockfallNextAt")) or 0) - J(), 0)
			JI(("Next Skyfall in %d:%02d"):format(math.floor(tI / 60), math.floor(tI % 60)))
			return false
		end
		WI.want = function()
			local tI = Z[21]
			if not (tI()) then
				return true
			end
		end
		WI.run = function(WI, tI)
			if Z[13](tI) then
				if kI(tI, "Skyfall") then
					if not (mI(OI, tI)) then
						return
					end
				else
					return
				end
			else
				return
			end
			WI = Z[1]
			local OI = WI.Character
			local function xI()
				local SI = tI()
				local tI
				if SI then
					local HI = Z[1]
					tI = HI.Character == OI
				else
					tI = SI
				end
				return tI
			end
			while xI() and (fI()) do
				local tI, SI = next(wI)
				if tI and typeof(SI) == "Vector3" then
					JI("Picking up Stormglass")
					local HI, _I = Z[27], Z[28]
					hI(HI(SI + _I(0, 2, 0)), 0.3)
					if H then
						H:FireServer("Pickup", tI)
					end
					wI[tI] = nil
				else
					local H = iI()
					if H then
						JI(H:FindFirstChild("InfusedCracks") and "Smashing the lightning rock" or "Smashing rocks")
						local iI = 0
						local tI, tI = Z[28], H.Position + Z[28](0, 0, 6)
						if not (mI(tI, xI, H.Position, true)) then
							break
						end
						tI = Z[27]
						hI(tI(H.Position + Z[28](0, 3, 6), H.Position), 4, function()
							if os.clock() - iI > 0.2 then
								iI = os.clock()
								local iI = YI(LI())
								if iI then
									pcall(iI.Activate, iI)
								end
							end
							local LI = xI()
							return (if LI then not H.Parent else not LI)
								or (tonumber(H:GetAttribute("Health")) or 0) <= 0
								or next(wI) ~= nil
						end)
					else
						JI("Waiting for rocks")
						WI = Z[23]
						WI()
					end
				end
			end
			WI = Z[1]
			if WI.Character ~= OI then
				JI("Respawned, going back the normal way")
				return
			end
			JI("Skyfall over")
			return true
		end
		local function H()
			local OI, wI, WI, LI =
				RI("StormheartState"), tonumber(RI("StormheartPool")) or 0, tonumber(RI("StormheartCost")) or 3, Z[25]
			local iI, tI = LI.skyStart and OI == "Idle" and aI() > 0 and wI + aI() >= WI
			if iI then
				tI = iI
			else
				WI, wI = OI == "Charging"
				if WI then
					wI = WI
				else
					LI = OI == "Rush"
					if LI then
						local OI = Z[1]
						wI = OI:GetAttribute("StormRushEligible") == true
					else
						wI = LI
					end
				end
				if wI then
					local OI = Z[25]
					local WI = OI.skyStart and QI()
					if WI then
						tI = WI
					else
						OI = Z[25]
						local WI = OI.skyJoin
						if WI then
							local OI = QI()
							if OI then
								tI = OI
							else
								local OI = Z[1]
								tI = OI:GetAttribute("StormRushEligible") == true
							end
						else
							tI = WI
						end
					end
				else
					tI = wI
				end
			end
			return tI
		end
		local OI, wI = 0
		ZI = Z[39]
		pI, eI = ZI:FindFirstChild("RE/StormheartCave/Travel"), Z[39]
		local ZI, WI = eI:FindFirstChild("RF/StormheartCave/Arrive"), Z[39]
		local eI = WI:FindFirstChild("RF/StormheartCave/Leave")
		if pI then
			W(pI.OnClientEvent, function(pI, WI)
				if pI ~= "Enter" then
					if pI ~= "Exit" then
						return
					end
				end
				OI = os.clock()
				local LI, iI = pI == "Exit" and eI or ZI, Z[25]
				if iI.skyFast then
					if LI then
						if type(WI) == "number" then
							if wI then
								if wI[1] == pI then
									if not (os.clock() - wI[2] < 25) then
										return
									end
								else
									return
								end
							else
								return
							end
						else
							return
						end
					else
						return
					end
				else
					return
				end
				wI = nil
				task.spawn(function()
					for ZI = 1, 12, 1 do
						local ZI, eI = pcall(LI.InvokeServer, LI, WI)
						if ZI and eI == true then
							return
						elseif QI() == (pI == "Enter") then
							return
						end
						task.wait(0.25)
					end
				end)
			end)
		end
		local function pI(ZI)
			if QI() then
				return true
			end
			JI("Entering the Stormheart Cave")
			local WI = workspace.World.Build.Props:FindFirstChild("EnterZone", true)
			local eI, LI = WI and WI:IsA("BasePart") and WI.Position
			if eI then
				LI = eI
			else
				WI = Z[28]
				LI = (WI(3055, 76, -420))
			end
			eI = Z[28]
			local iI, tI = eI(LI.X, 70.7, LI.Z), Z[28]
			if not (mI(iI - tI(0, 3, 0), ZI)) then
				return false
			end
			eI = workspace.World.Build.Props:FindFirstChild("StormheartCaveEnterPrompt", true)
			eI = eI and (if eI:IsA("ProximityPrompt") then eI else (eI:FindFirstChildWhichIsA("ProximityPrompt", true)))
			WI = OI
			wI = { "Enter", os.clock() }
			LI = 0
			while true do
				tI = QI()
				local xI = (if tI then not tI else LI < 6) and OI == WI
				if not (xI and ZI()) then
					break
				end
				local SI, HI = Z[26], Z[27]
				SI(HI(iI))
				if LI % 1 < 0.05 then
					gI(eI)
				end
				xI = Z[23]
				LI += xI()
			end
			LI = 0
			while true do
				tI = QI()
				eI = (if tI then not tI else OI ~= WI) and LI < 10
				if not (eI and ZI()) then
					break
				end
				iI = Z[23]
				LI += iI()
			end
			if not (QI()) then
				JI("Could not enter the cave")
				return false
			end
			LI = 0
			while ZI() and LI < 2 do
				tI = Z[23]
				LI += tI()
			end
			return true
		end
		local function ZI(WI)
			if not (QI()) then
				return true
			end
			JI("Leaving the cave")
			local eI = uI("ExitZone")
			if not eI then
				return false
			end
			local LI = Z[28]
			local iI, tI = LI(eI.Position.X, eI.Position.Y - eI.Size.Y / 2 + 3, eI.Position.Z), Z[15]
			eI = (tI())
			while eI and (QI()) and (eI.Position - iI).Magnitude > 2 and (WI()) do
				local xI, SI, HI, _I, _I = iI - eI.Position, Z[26], Z[27], Z[25], Z[23]
				SI(
					HI(
						eI.Position
							+ xI.Unit
								* math.min(xI.Magnitude, math.min(Z[25].skySpd or 400, 700) * math.min(Z[23](), 0.1))
					)
				)
				HI = Z[15]
				eI = (HI())
			end
			tI = OI
			wI = { "Exit", os.clock() }
			LI = 0
			while true do
				local wI = QI() and LI < 20 and OI == tI
				if not (wI and (WI())) then
					break
				end
				local wI, xI = Z[26], Z[27]
				wI(xI(iI))
				xI = Z[23]
				LI += xI()
			end
			LI = 0
			while true do
				iI = QI() and OI ~= tI and LI < 10
				if not (iI and (WI())) then
					break
				end
				local OI = Z[23]
				LI += OI()
			end
			if QI() then
				return false
			end
			LI = 0
			while LI < 1 and (WI()) do
				tI = Z[23]
				LI += tI()
			end
			LI = Z[47]
			local OI, OI, wI = Z[28], LI() + Z[28](0, 3, 0), Z[15]
			eI = wI()
			if eI then
				tI = Z[16]
				if tI(eI.Position) then
				else
					if (eI.Position - OI).Magnitude > 300 then
						JI("Going home")
						MI(OI, WI)
						iI = Z[15]
						eI = (iI())
					else
					end
				end
			else
			end
			iI = nil
			if eI then
				wI = Z[16]
				iI = not wI(eI.Position)
			else
				iI = eI
			end
			if iI then
				JI("Going home")
				while eI and (WI()) and (eI.Position - OI).Magnitude > 3 do
					local wI, WI, LI, iI, iI = OI - eI.Position, Z[26], Z[27], Z[25], Z[23]
					WI(
						LI(
							eI.Position
								+ wI.Unit
									* math.min(
										wI.Magnitude,
										math.min(Z[25].skySpd or 400, 700) * math.min(Z[23](), 0.1)
									)
						)
					)
					LI = Z[15]
					eI = (LI())
				end
			end
			return true
		end
		local OI = Z[20]
		OI.caveGate = function(OI, wI)
			if OI == EI then
				return true
			elseif not (QI()) then
				return true
			end
			return ZI(wI)
		end
		EI.on = function()
			local OI = Z[25]
			if not OI.skyStart then
				local wI = Z[25]
				if not wI.skyJoin then
					local wI = Z[25]
					if not wI.skyTrade then
						local wI = Z[25]
						if not wI.skyGacha then
							return false
						end
					end
				end
			end
			OI = Z[25]
			local wI, WI = OI.skyStart
			if wI then
				WI = wI
			else
				OI = Z[25]
				WI = OI.skyJoin
			end
			wI, OI = WI and (H() or lI ~= nil)
			if wI then
				OI = wI
			else
				WI = Z[25]
				OI = WI.skyTrade and sI("Sparks") >= 150
			end
			wI = nil
			if OI then
				wI = OI
			else
				WI = Z[25]
				wI = WI.skyGacha and sI("Thunderstones") >= 200 and (type(O) ~= "table" or O.GachaOpen())
			end
			return wI
		end
		EI.want = function()
			local OI = Z[21]
			if not (OI()) then
				local OI = Z[25]
				if OI.sky then
					if not (fI()) then
						return true
					end
				else
					return true
				end
			end
		end
		EI.run = function(OI, wI)
			if Z[13](wI) then
				if not (QI()) then
					if not (kI(wI, "Storm Rush")) then
						return
					end
				end
			else
				return
			end
			OI = Z[25]
			local WI, EI = OI.skyStart
			if WI then
				EI = WI
			else
				OI = Z[25]
				EI = OI.skyJoin
			end
			WI = EI and (H() or lI)
			if WI then
				if not (pI(wI)) then
					return
				end
				OI = uI("Conductor")
				while true do
					EI = wI()
					local H
					if EI then
						local eI = Z[25]
						H = eI.skyStart
					else
						H = EI
					end
					if not (H and RI("StormheartState") == "Idle" and aI() > 0 and OI) then
						break
					end
					JI("Inserting Stormglass")
					YI(AI("Stormglass"))
					hI(OI.CFrame + Z[28](0, 3, 6), 0.6)
					gI(OI:FindFirstChild("InsertPrompt", true))
					hI(OI.CFrame + Z[28](0, 3, 6), 0.6)
				end
				local H = os.clock() + 90
				while true do
					local aI = wI() and os.clock() < H and (RI("StormheartState") == "Charging" or lI)
					if not aI then
						break
					end
					local H, YI = uI("FlightCenter"), J()
					local RI, eI
					if lI and H and YI <= (tonumber(lI.EndsAt) or 0) then
						aI = lI
						aI.taken = aI.taken or {}
						local fI = Z[15]
						local uI, AI = fI(), TI
						for TI, LI in next, AI, nil do
							fI = lI.taken[TI]
							if if fI then not fI else YI - LI.Born >= 0.85 then
								TI = (uI and (O.SparkPosition(LI, H.Position, YI) - uI.Position).Magnitude or 0)
									- (LI.Tier == "Golden" and 400 or LI.Tier == "Purple" and 120 or 0)
								if if eI then TI < eI else not eI then
									RI = LI
									eI = TI
								else
								end
							else
							end
						end
					else
					end
					if RI then
						JI("Catching Sparks (" .. sI("Sparks") .. ")")
						aI = Z[15]
						local TI, fI, uI = aI(), os.clock(), Z[25]
						if not uI.skyTp then
							YI = Z[8]
							eI = YI()
							if eI then
								eI.PlatformStand = true
							end
						end
						while true do
							uI = Z[25]
							local aI = uI.skyTp
							local YI = (if aI then not aI else TI) and lI and wI()
							if not (YI and os.clock() - fI < 3) then
								break
							end
							aI = O.SparkPosition(RI, H.Position, J()) - TI.Position
							if aI.Magnitude <= 4 then
								break
							end
							local YI, eI, AI, AI = Z[26], Z[27], Z[25], Z[23]
							YI(
								eI(
									TI.Position
										+ aI.Unit
											* math.min(
												aI.Magnitude,
												math.min(Z[25].skySpd or 400, 700) * math.min(Z[23](), 0.1)
											)
								)
							)
							eI = Z[15]
							TI = (eI())
						end
						if not lI then
							continue
						end
						uI = lI
						uI.wait = RI.Id
						fI = Z[27]
						hI(fI(O.SparkPosition(RI, H.Position, J())), 0.6, function()
							local O = if lI then lI.wait ~= RI.Id else not lI
							return O
						end)
						if lI then
							if lI.wait == RI.Id then
								fI = nil
								fI, lI.taken[RI.Id] = lI, true
								fI.wait = nil
							end
						end
					else
						JI(lI and "Waiting for Sparks" or "Stormheart charging")
						local O = Z[23]
						O()
					end
				end
			end
			OI = Z[25]
			if OI.skyTrade and sI("Sparks") >= 150 and pI(wI) then
				WI = nil
				for O, O in ipairs(workspace:GetDescendants()) do
					if O:IsA("ProximityPrompt") then
						if O.Name == "TalkPrompt" then
							if O:FindFirstAncestor("Rumble") then
								WI = O
								break
							end
						end
					end
				end
				EI = WI and WI.Parent and WI.Parent:IsA("BasePart") and WI.Parent.Position
				if EI then
					local O, H = Z[27], Z[28]
					hI(O(EI + H(0, 2, 5), EI), 0.4)
				end
				while sI("Sparks") >= 150 and (wI()) do
					JI("Trading Sparks")
					local O = Z[9]
					local H, H = O("RF/StormheartCave/Trade")
					if not H then
						break
					end
				end
			end
			if wI() then
				ZI(wI)
			end
			while true do
				WI = Z[25]
				if not (WI.skyGacha and not QI() and sI("Thunderstones") >= 200 and (wI())) then
					break
				end
				JI("Buying a Stormy Egg")
				if not (mI(v, wI)) then
					return
				end
				EI, OI = Z[27], Z[28]
				hI(EI(v + OI(0, 3, 4)), 0.3)
				local O = Z[9]
				local H, H = O("RF/StormheartCave/GachaBuy")
				if not H then
					return true
				end
			end
			return true
		end
		local function O()
			return type(Y) == "table" and Y.LiveVisit()
		end
		local H, v = {}, Z[1]
		local OI, pI = "ChilliLibrary/SAE_BMPets_" .. v.UserId .. ".txt", 0
		local function v()
			local ZI, wI = pcall(isfile, OI)
			return ZI and wI
		end
		local function ZI()
			for wI = 1, 5, 1 do
				wI = Z[9]
				wI("RF/Haul/WearBest")
				task.wait(1)
				wI = Z[9]
				local TI, TI = wI("RF/Haul/FetchWearBestStatus")
				if not TI then
					break
				end
			end
			pcall(delfile, OI)
		end
		task.spawn(function()
			while true do
				local wI = Z[56]
				if not wI then
					break
				end
				if os.clock() > pI then
					if v() then
						ZI()
					end
				end
				task.wait(10)
			end
		end)
		local function wI(TI)
			local lI = B()[TI.Id]
			local B, WI = lI and (TI.Stock or 0) > 0
			if B then
				local EI
				EI, WI = Z[25], (H[TI.Id] or 0) < (Z[25].bmQty or 5)
			else
				WI = B
			end
			B = nil
			if WI then
				local EI = Z[25]
				local sI = (EI.bmMaxH or 0) == 0
				if sI then
					B = sI
				else
					EI = nil
					EI, B = Z[25], lI.PriceHours <= Z[25].bmMaxH
				end
			else
				B = WI
			end
			return B and (tonumber(x().Money) or 0) >= (TI.Price or 1 / 0)
		end
		local function B()
			local TI, lI = O()
			local WI, EI = x().BlackMarket, Z[25]
			return EI.bmRoll
				and TI
				and type(WI) == "table"
				and WI.VisitId == TI
				and (tonumber(WI.RerollCredits) or 0) > 0
				and Y.CanReroll(lI)
		end
		local function TI()
			local lI = x().BlackMarket
			if type(lI) ~= "table" then
				return true
			elseif lI.VisitId ~= O() then
				return true
			end
			for WI, WI in ipairs(lI.Offer or {}) do
				if wI(WI) then
					return true
				end
			end
			return B()
		end
		FI.on = function()
			local lI = Z[25]
			if not lI.bm then
				return false
			end
			local lI, WI = O()
			if not lI then
				m("Waiting for Slick Rick")
				return false
			end
			if lI ~= H.v then
				table.clear(H)
				H.v = lI
			end
			m(("Slick Rick is here, leaves in %ds"):format(math.max(0, math.floor((WI or 0) - J()))))
			return (tonumber(x().SpeedPower) or 0) >= 250000000000 and TI()
		end
		FI.want = function()
			local TI = Z[21]
			if not (TI()) then
				return true
			end
		end
		FI.run = function(TI, lI)
			if Z[13](lI) then
				if not (kI(lI, "Black Market")) then
					return
				end
			else
				return
			end
			TI = Y.Station and Y.Station()
			local Y = TI and TI.Position or PI
			m("Going to Slick Rick")
			if not (mI(Y, lI)) then
				return
			end
			local PI, WI = Z[27], Z[28]
			hI(PI(Y + WI(0, 3, 6)), 0.4)
			Y, WI, TI = x().BlackMarket, O(), Z[25]
			PI = TI.bmPets and type(Y) == "table" and Y.VisitId ~= WI and table.clone(x().EquippedAssets or {}) or {}
			if #PI > 0 then
				pI = os.clock() + 120
				pcall(writefile, OI, tostring(os.time()))
				m("Taking pets out of the pen")
				TI = ipairs
				for O, OI in TI(PI) do
					O = Z[9]
					O("RF/PenRoster/AskDoff", OI)
				end
			end
			Y = Z[9]
			TI, WI, PI = Y("RF/BlackMarket/AskOpen")
			if not WI then
				m(tostring(PI or "Slick Rick closed"))
				FI.at = os.clock() + 30
				if v() then
					ZI()
				end
				pI = 0
				return
			end
			repeat
				WI, Y = ipairs, (x().BlackMarket or {}).Offer or {}
				for O, OI in WI(Y) do
					while lI() and (wI(OI)) do
						O = Z[9]
						local Y, Y, wI = O("RF/BlackMarket/AskBuy", OI.Id)
						PI = Z[11]
						PI(tostring(wI or OI.Id), Y and "ok" or "warn")
						if not Y then
							break
						end
						H[OI.Id] = (H[OI.Id] or 0) + 1
						Y = 0
						while Y < 0.5 do
							wI = Z[23]
							Y += wI()
						end
						for O, O in ipairs((x().BlackMarket or {}).Offer or {}) do
							OI = if O.Id == OI.Id then O else OI
						end
					end
				end
				if lI() then
					if not (B()) then
						break
					end
				else
					break
				end
				local O = Z[9]
				local Y, Y, x = O("RF/BlackMarket/AskReroll")
				O = Z[11]
				O(tostring(x or "Rerolled"), Y and "ok" or "warn")
				if not Y then
					break
				end
				Y = H.v
				table.clear(H)
				H.v = Y
				x = 0
				while x < 0.5 do
					O = Z[23]
					x += O()
				end
			until false
			if v() then
				m("Equipping best pets")
				ZI()
			end
			pI = 0
			return true
		end
	end)
	w("40_esp#1", function()
		local O = dI.ESP
		local Y = gethui and gethui() or d("CoreGui")
		local m = Color3.fromRGB
		local x = UDim2.fromScale
		local H = UDim2.fromOffset
		local B = Vector2.new
		local v = ColorSequenceKeypoint.new
		local OI = ColorSequence.new
		local pI = math.floor
		local ZI = math.max
		local PI = Color3.new(1, 1, 1)
		local wI = Color3.new(0, 0, 0)
		local TI = 1 / 0
		local lI = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold)
		local WI = Font.new("rbxasset://fonts/families/FredokaOne.json", Enum.FontWeight.Regular)
		j(O, "Inventory Values", "espInv", true)
		local function EI(...)
			local FI, sI = { ... }, {}
			for aI = 1, #FI, 4 do
				sI[#sI + 1] = v(FI[aI], m(FI[aI + 1], FI[aI + 2], FI[aI + 3]))
			end
			return OI(sI)
		end
		local FI, sI, aI =
			EI(0, 8, 8, 8, 1, 8, 8, 8),
			{ t = EI(0, 255, 231, 158, 0.4, 255, 196, 66, 1, 214, 142, 12), s = EI(
				0,
				122,
				76,
				0,
				0.55,
				62,
				38,
				0,
				1,
				20,
				12,
				0
			), o = m(
				255,
				232,
				152
			) },
			{}
		aI.t = EI(0, 255, 198, 132, 0.4, 255, 146, 40, 1, 206, 92, 0)
		aI.s = EI(0, 112, 54, 0, 0.55, 56, 27, 0, 1, 18, 8, 0)
		aI.o = m(255, 194, 112)
		local JI, YI, RI =
			{ t = EI(0, 255, 105, 105, 0.4, 255, 28, 40, 1, 184, 0, 18), s = EI(
				0,
				124,
				0,
				15,
				0.55,
				61,
				0,
				9,
				1,
				18,
				0,
				3
			), o = m(
				255,
				128,
				138
			) },
			{ t = EI(0, 170, 255, 160, 0.45, 58, 255, 55, 1, 20, 109, 0), s = EI(0, 10, 52, 6, 1, 3, 16, 0), o = m(
				58,
				255,
				55
			) },
			{}
		RI.t = EI(0, 255, 255, 255, 0.5, 222, 222, 222, 1, 255, 255, 255)
		RI.s = FI
		local function eI(fI)
			return {
				t = OI({ v(0, fI:Lerp(PI, 0.5)), v(0.4, fI:Lerp(PI, 0.1)), v(1, fI:Lerp(wI, 0.25)) }),
				s = OI({ v(0, fI:Lerp(wI, 0.55)), v(0.55, fI:Lerp(wI, 0.75)), v(1, fI:Lerp(wI, 0.92)) }),
			}
		end
		local function v()
			local OI = workspace.CurrentCamera
			return OI and OI.ViewportSize.Y or 1080
		end
		local function OI(fI)
			return ZI(6, pI(math.clamp(v() * 0.014, 13, 19) * fI))
		end
		local function fI(QI, uI)
			return ZI(30, pI(QI * uI))
		end
		local function QI()
			return F(
				"ScreenGui",
				{
					Parent = Y,
					Archivable = false,
					ResetOnSpawn = false,
					IgnoreGuiInset = true,
					ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
					DisplayOrder = 48,
				}
			)
		end
		local function Y(uI)
			return uI and uI.Parent and uI or QI()
		end
		local function uI(AI)
			local hI = F("BillboardGui", { Parent = AI, AlwaysOnTop = true, LightInfluence = 0, MaxDistance = TI })
			AI = F("Frame", { Parent = hI, BackgroundTransparency = 1, BorderSizePixel = 0, Size = x(1, 1) })
			F(
				"UIListLayout",
				{
					Parent = AI,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder,
				}
			)
			return hI, AI
		end
		local function AI(hI)
			hI.BackgroundTransparency = 1
			hI.Text = ""
			hI.TextScaled = true
			return F("TextLabel", hI)
		end
		local function hI(mI, kI, LI, gI, iI, tI)
			local xI = F(
				"UIStroke",
				{
					ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
					LineJoinMode = Enum.LineJoinMode.Round,
					Color = PI,
					Transparency = kI,
				}
			)
			xI.Thickness = pcall(function()
				xI.StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
			end) and LI or gI
			xI.Parent = mI
			return F("UIGradient", { Parent = xI, Rotation = 90, Color = iI }),
				F("UIGradient", { Parent = mI, Rotation = 90, Color = tI })
		end
		local function mI(kI, LI, gI, iI)
			local tI = F(
				"Frame",
				{ Parent = kI, BackgroundTransparency = 1, BorderSizePixel = 0, Size = x(1, iI), LayoutOrder = gI }
			)
			kI, gI =
				AI({ Parent = tI, Size = x(1, 1), ZIndex = 2, FontFace = LI, Position = H(1, 1), TextColor3 = wI, TextTransparency = 0.1 }),
				AI({ Parent = tI, Size = x(1, 1), ZIndex = 3, FontFace = LI, TextColor3 = PI })
			iI, LI = hI(gI, 0.05, 0.05, 1.2)
			return { h = tI, sh = kI, l = gI, sg = iI, tg = LI }
		end
		local function kI(LI, gI, iI)
			if LI.l.Text ~= gI then
				LI.l.Text, LI.sh.Text = gI, gI
			end
			if LI.p ~= iI then
				LI.p, LI.tg.Color, LI.tg.Rotation, LI.sg.Color = iI, iI.t, iI.r or 90, iI.s
			end
		end
		local function LI(gI, iI, tI, xI)
			return F(
				"Highlight",
				{
					Adornee = gI,
					Parent = iI,
					DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
					FillTransparency = 0.76,
					OutlineTransparency = 0.02,
					FillColor = tI,
					OutlineColor = xI,
				}
			)
		end
		local function gI(iI)
			for tI, tI in ipairs(iI) do
				pcall(function()
					tI:Disconnect()
				end)
			end
			table.clear(iI)
		end
		local function iI(tI, xI, SI)
			local HI, _I, oI = false, false, false
			local function BI()
				if oI then
					return
				elseif HI == _I then
					return
				end
				_I = HI
				if HI then
					xI()
				else
					SI()
				end
			end
			table.insert(Z[20].cleanup, function()
				oI = true
				SI()
			end)
			local function xI(SI)
				HI = SI
				BI()
				task.delay(0.35, BI)
			end
			return O:Toggle(tI, false, xI)
		end
		local function tI(xI, SI, HI)
			O:Slider(xI, 50, 200, 75, function(xI)
				HI(xI / 100)
			end, "%", 5, nil, SI)
		end
		do
			local xI = { 3.2, 1.35, 1.2, 1, 1.1, 1 }
			local SI = Font.new("rbxassetid://12187365977", Enum.FontWeight.Bold)
			local HI, _I =
				EI(
					0,
					255,
					255,
					255,
					0.2,
					206,
					212,
					224,
					0.42,
					74,
					80,
					94,
					0.58,
					42,
					46,
					56,
					0.78,
					158,
					166,
					182,
					1,
					250,
					252,
					255
				),
				{}
			_I.t = EI(0, 255, 255, 255, 0.5, 222, 238, 255, 1, 255, 255, 255)
			_I.s = FI
			local oI = eI(m(77, 255, 122))
			local BI, vI = eI(m(143, 227, 255)), { Golden = sI }
			vI.Sakura = eI(m(255, 158, 216))
			vI.GreatBloom = eI(m(124, 255, 196))
			vI.Boss = eI(m(255, 122, 122))
			vI.Monstrous = eI(m(192, 139, 255))
			vI.Silver = { t = EI(0, 255, 255, 255, 0.45, 214, 222, 232, 1, 150, 160, 175), s = EI(
				0,
				60,
				66,
				78,
				0.55,
				30,
				33,
				40,
				1,
				10,
				11,
				14
			) }
			vI.Rainbow = {
				t = EI(
					0,
					255,
					107,
					107,
					0.2,
					255,
					179,
					107,
					0.4,
					255,
					240,
					107,
					0.6,
					107,
					255,
					138,
					0.8,
					107,
					200,
					255,
					1,
					185,
					107,
					255
				),
				s = EI(0, 20, 20, 30, 1, 8, 8, 12),
				r = 0,
			}
			local zI = Z[39]
			local cI, DI, NI, VI, II, jI, KI, XI, UI, GI, C7, O7, p7 =
				zI:FindFirstChild("RF/EggWorld/AskFieldEggSnapshot"),
				0,
				5,
				0,
				{ Icon = true, Name = true, Value = true },
				0.75,
				false,
				true,
				false,
				{},
				{},
				{}
			local M7, Z7, n7, d7, q7 = false, 0, 0, false
			local P7, r7 = false, false
			local function w7(b7)
				local T7 = C7[b7]
				if T7 then
					return T7
				end
				local y7 = h(b7)
				y7 = type(y7) == "table" and y7 or nil
				local l7 = y7 and type(y7.Rarity) == "table" and y7.Rarity or nil
				local W7, E7 = eI(l7 and typeof(l7.Color) == "Color3" and l7.Color or PI), l7 and l7.RarityGradient
				if l7 then
					if typeof(E7) ~= "Instance" then
						local eI, F7, s7 =
							ipairs,
							{ "Assets", "UI", "RarityGradients", tostring(l7._id or l7.DisplayName or ""), "RarityGradient" },
							P
						for a7, a7 in eI(F7) do
							s7 = s7 and (s7:FindFirstChild(a7))
						end
						E7 = s7
					else
					end
				else
				end
				if typeof(E7) == "Instance" then
					if E7:IsA("UIGradient") then
						W7.t, W7.r = E7.Color, E7.Rotation
					end
				end
				local eI = l7 and tostring(l7.DisplayName or l7._id or "") or ""
				T7 = {
					n = l7 and tonumber(l7.RarityNumber or l7.Rank) or 0,
					nm = eI,
					rp = eI:upper() == "SECRET" and { t = HI, s = W7.s, r = 90 } or W7,
					dn = tostring(y7 and y7.DisplayName or b7),
					ic = y7 and y7.Icon or nil,
				}
				C7[b7] = T7
				return T7
			end
			local function eI(HI)
				local C7, b7 = HI.Model
				if typeof(C7) == "Instance" then
					b7 = C7:FindFirstChild("Hitbox", true) or C7:FindFirstChildWhichIsA("BasePart", true)
				else
					local T7 = workspace:FindFirstChild("AreaEggSlotsClient")
					C7 = T7 and T7:FindFirstChild(HI.Uid)
					b7 = C7 and C7:IsA("Model") and C7:FindFirstChild("Hitbox")
				end
				return b7 and b7:IsA("BasePart") and b7 or nil
			end
			local function HI(C7)
				C7 = tonumber(C7) or 0
				local b7 = 0
				while math.abs(C7) >= 1000 and b7 < #u do
					C7, b7 = C7 / 1000, b7 + 1
				end
				return (b7 == 0 and "%.0f" or "%.2f"):format(C7) .. (u[b7] or "")
			end
			local function C7(b7)
				local T7 = workspace.CurrentCamera
				return T7 and b7 * T7.ViewportSize.Y / (40 * math.tan(math.rad(T7.FieldOfView) * 0.5)) or TI
			end
			local function b7(T7)
				local y7, l7 = T7.v, 0
				for W7, E7 in ipairs(xI) do
					l7 = if y7[W7] then l7 + E7 else l7
				end
				l7 = ZI(l7, 1)
				for W7, E7 in ipairs(T7.hs) do
					E7.Visible, E7.Size = y7[W7], x(1, y7[W7] and xI[W7] / l7 or 0)
				end
				local xI, W7, E7 = fI(120, jI), ZI(1, pI(OI(jI) * l7)), 4.5 * jI
				if T7.w ~= xI or T7.ht ~= W7 or T7.f ~= KI then
					y7 = nil
					y7, T7.w, T7.ht = KI, xI, W7
					T7.f = y7
					T7.b.Size, T7.b.MaxDistance = KI and x(E7, E7 * W7 / xI) or H(xI, W7), KI and C7(E7) or TI
				end
			end
			local function xI()
				local C7, T7 = uI(q7)
				local y7 = F("Frame", { Parent = T7, BackgroundTransparency = 1, BorderSizePixel = 0 })
				local l7 = F(
					"ImageLabel",
					{
						Parent = y7,
						AnchorPoint = B(0.5, 1),
						BackgroundTransparency = 1,
						Position = x(0.5, 1),
						Size = x(1, 1),
						ScaleType = Enum.ScaleType.Fit,
					}
				)
				F("UIAspectRatioConstraint", { Parent = l7, DominantAxis = Enum.DominantAxis.Height })
				local W7, E7 =
					{ b = C7, ic = l7, r = {}, hs = { y7 }, v = { false, true, false, false, false, false } },
					{ lI, SI, lI, lI, lI }
				for SI, C7 in ipairs(E7) do
					W7.r[SI] = mI(T7, C7, SI, 0)
					W7.hs[SI + 1] = W7.r[SI].h
				end
				b7(W7)
				return W7
			end
			local function SI(C7)
				return L(C7.AssetCategory, C7.AssetScale, type(C7.Mutations) == "table" and C7.Mutations)
			end
			local function C7(T7, y7, l7)
				local W7, E7 = {}, workspace:FindFirstChild("PlacedEggRenders")
				local F7
				if E7 then
					local s7 = Z[22]
					F7 = s7("Egg", "ReadOwnerEggs", T7.UserId)
				else
					F7 = E7
				end
				if type(F7) ~= "table" then
					return W7
				end
				local s7, a7 = tostring(T7.UserId), {}
				for J7, J7 in ipairs(E7:GetChildren()) do
					if J7.Name:find(s7, 1, true) then
						a7[#a7 + 1] = J7
					end
				end
				for J7, Y7 in next, F7, nil do
					if type(Y7) == "table" and Y7.Placement ~= nil and type(Y7.AssetCategory) == "string" then
						local F7, R7 = tostring(J7)
						for J7, J7 in ipairs(a7) do
							if J7.Name:find(F7, 1, true) or J7:GetAttribute("Uid") == F7 then
								R7 = J7
								break
							end
						end
						if R7 then
							T7, s7 = pcall(function()
								return R7:IsA("Model") and R7:GetPivot() or R7.CFrame
							end)
							E7 = type(Y7.Mutations) == "table" and Y7.Mutations or {}
							W7[#W7 + 1] = {
								Uid = l7 .. F7,
								AssetCategory = Y7.AssetCategory,
								AssetScale = Y7.AssetScale,
								Mutations = E7,
								BaseMutation = Y7.BaseMutation or E7[1],
								State = "Base",
								AreaId = y7,
								BottomCFrame = T7 and s7 or nil,
								Model = R7,
							}
						end
					end
				end
				return W7
			end
			local function T7(y7, l7)
				local W7 = y7.State ~= "Claimed" and l7.n >= NI and not (VI > 0 and SI(y7) < VI)
				return W7
			end
			local function y7(l7, W7, E7)
				local F7, s7, a7, J7, Y7, R7 = eI(W7), W7.BottomCFrame, l7.r, {}, {}, {}
				local eI = typeof(s7) == "CFrame"
				if eI then
					local e7 = F7 or workspace.Terrain
					if l7.a ~= e7 or l7.cf ~= s7 then
						l7.a, l7.cf, l7.b.Adornee = e7, s7, e7
						local f7
						f7, l7.b.StudsOffsetWorldSpace =
							Z[28],
							s7.Position - e7.Position + Z[28](0, (F7 and F7.Position.Y - s7.Position.Y or 1) + 0.8, 0)
					end
				end
				local function e7(f7)
					if type(f7) == "string" then
						if f7 ~= "" then
							if f7 ~= "Normal" then
								if not Y7[f7] then
									Y7[f7] = true
									J7[#J7 + 1] = f7
								end
							end
						end
					end
				end
				e7(W7.BaseMutation)
				for Y7, f7 in next, type(W7.Mutations) == "table" and W7.Mutations or {}, nil do
					e7(type(Y7) == "string" and f7 == true and Y7 or f7)
				end
				local Y7, f7, Q7, u7, A7, h7, m7 =
					tonumber(W7.AssetScale) or 1,
					{},
					II.Icon == true and E7.ic ~= nil,
					II.Name == true,
					II.Rarity == true and E7.nm ~= "",
					II.Mutation == true and J7[1] ~= nil,
					II.Value
				C:EH(f7, 0, Q7, u7, A7, h7, m7 == true, false)
				if f7[1] then
					if l7.ic.Image ~= tostring(E7.ic) then
						l7.ic.Image = tostring(E7.ic)
					end
				end
				if f7[2] then
					kI(a7[1], E7.dn, _I)
				end
				if f7[3] then
					kI(a7[2], E7.nm:upper(), E7.rp)
				end
				if f7[4] then
					m7 = {}
					for _I, u7 in ipairs(J7) do
						m7[_I] = (Q[u7] or u7):gsub("%s*[Mm]utation$", ""):upper()
					end
					kI(a7[3], table.concat(m7, " + "), vI[J7[1]] or BI)
				end
				if f7[5] then
					kI(a7[4], "$" .. HI(SI(W7)) .. "/s", oI)
				end
				m7, F7 = II.Weight
				if m7 then
					E7 = Z[22]
					F7 = E7("Rec", "WeightKgForScale", W7.AssetCategory, Y7)
				else
					F7 = m7
				end
				if tonumber(F7) then
					R7[#R7 + 1] = HI(F7) .. " kg"
				end
				if II.Size then
					R7[#R7 + 1] = ("x%.2f"):format(Y7)
				end
				A7 = II["Sell Price"]
				if A7 then
					e7 = Z[22]
					F7 = (e7("Rec", "SellPrice", W7))
				else
					F7 = A7
				end
				if tonumber(F7) then
					R7[#R7 + 1] = "$" .. HI(F7)
				end
				F7, Q7 = II.Distance and eI
				if F7 then
					e7 = Z[15]
					Q7 = (e7())
				else
					Q7 = F7
				end
				if Q7 then
					R7[#R7 + 1] = ("%dm"):format(pI((Q7.Position - s7.Position).Magnitude + 0.5))
				end
				if II.Area then
					if W7.AreaId ~= nil then
						R7[#R7 + 1] = tostring(W7.AreaId)
					end
				end
				if II.State then
					if W7.State ~= nil then
						if W7.State ~= "Slot" then
							R7[#R7 + 1] = tostring(W7.State)
						end
					end
				end
				f7[6] = #R7 > 0
				if f7[6] then
					kI(a7[5], table.concat(R7, "  |  "), RI)
				end
				for eI, SI in ipairs(l7.v) do
					if SI ~= f7[eI] then
						l7.v = f7
						b7(l7)
						break
					end
				end
			end
			local function eI(SI, HI, _I)
				q7 = Y(q7)
				local oI = {}
				local BI = os.clock()
				local function vI(l7)
					local W7 = w7(l7.AssetCategory)
					if M7 then
						if T7(l7, W7) then
							oI[l7.Uid] = true
							local w7, T7, E7 = GI, l7.Uid, GI
							w7[T7] = E7[l7.Uid] or (xI())
							w7 = GI
							y7(w7[l7.Uid], l7, W7)
						end
					end
				end
				local function xI(w7, T7, y7)
					for l7, l7 in ipairs(C7(w7, T7, y7)) do
						vI(l7)
					end
				end
				local C7 = next
				for w7, T7 in C7, SI, nil do
					if type(T7) == "table" then
						if type(T7.Uid) == "string" then
							if type(T7.AssetCategory) == "string" then
								vI(T7)
							end
						end
					end
					if os.clock() - BI > 0.002 then
						w7 = Z[23]
						w7()
						BI = os.clock()
						if HI ~= n7 then
							return
						elseif _I ~= Z7 then
							return
						elseif not M7 then
							return
						end
					else
					end
				end
				if M7 then
					if XI then
						HI = Z[1]
						xI(HI, "Your Base", "base:")
					end
				end
				if M7 and UI then
					_I, C7 = ipairs, C[20](q:GetPlayers())
					for HI, HI in _I(C:QH(C7)) do
						SI = Z[1]
						if HI ~= SI then
							xI(HI, HI.DisplayName .. " Base", "base" .. HI.UserId .. ":")
						end
					end
				end
				_I = GI
				for xI, SI in next, _I, nil do
					if not oI[xI] then
						GI[xI] = nil
						SI.b:Destroy()
					end
				end
				return true
			end
			local function xI()
				if M7 then
					if not p7 then
						return
					end
				else
					return
				end
				P7 = true
				if r7 then
					return
				end
				r7 = true
				task.defer(function()
					while true do
						local SI = M7 and p7 and P7
						if not SI then
							break
						end
						P7 = false
						n7 += 1
						local SI, HI = pcall(eI, p7, n7, Z7)
						if SI then
							if HI ~= true then
								P7 = true
							end
						end
						SI = Z[23]
						SI()
					end
					r7 = false
				end)
			end
			local function eI(SI)
				return type(SI) == "table" and type(SI.Records) == "table" and SI.Records or nil
			end
			local function SI()
				local HI = Z7
				if p7 then
					if next(GI) == nil then
						xI()
					end
				end
				local _I = Z[22]
				local oI = eI(_I("Egg", "ReadFieldEggs"))
				if oI then
				else
					if cI then
						if os.clock() >= DI then
							DI = os.clock() + 30
							local _I, BI = pcall(cI.InvokeServer, cI)
							oI = _I and eI(BI) or nil
						else
						end
					else
					end
				end
				if HI ~= Z7 then
					return
				elseif not M7 then
					return
				end
				if oI then
					p7 = {}
					for eI, HI in next, oI, nil do
						p7[eI] = HI
					end
				end
				if p7 then
					xI()
				end
			end
			local function eI()
				if d7 then
					return
				end
				d7 = true
				task.delay(0.5, function()
					d7 = false
					if M7 then
						task.spawn(pcall, SI)
					end
				end)
			end
			local function HI()
				local _I = GI
				for oI, oI in next, _I, nil do
					oI.w = nil
					b7(oI)
				end
			end
			local function _I()
				M7 = true
				local oI, BI = Z7, Z[34]
				local vI = BI.Egg or {}
				local function cI(DI, C7)
					task.spawn(function()
						while true do
							local p7 = Z7
							if not (oI == p7) then
								break
							end
							task.wait(DI)
							if oI == Z7 then
								C7()
							end
						end
					end)
				end
				BI = { "FieldRefreshed", "FieldShifted", "FieldGone", "FieldClaimed", "SnapshotRefreshed" }
				for oI, DI in ipairs(BI) do
					oI = vI[DI]
					if type(oI) == "table" then
						if oI.Connect then
							local DI, C7 = pcall(oI.Connect, oI, eI)
							if DI then
								if C7 then
									O7[#O7 + 1] = C7
								end
							end
						end
					end
				end
				vI = { "AreaEggSlotsClient", "PlacedEggRenders" }
				for oI, oI in ipairs(vI) do
					BI = workspace:FindFirstChild(oI)
					if BI then
						O7[#O7 + 1] = BI.ChildAdded:Connect(eI)
						O7[#O7 + 1] = BI.ChildRemoved:Connect(eI)
					end
				end
				cI(10, eI)
				cI(1, function()
					if II.Distance then
						xI()
					end
				end)
				task.spawn(pcall, SI)
			end
			local function eI()
				M7 = false
				Z7 += 1
				n7 += 1
				gI(O7)
				local SI, oI = GI, q7
				local BI = os.clock()
				GI, q7 = {}, nil
				task.spawn(function()
					local vI = next
					for cI, DI in vI, SI, nil do
						DI.b:Destroy()
						if os.clock() - BI > 0.002 then
							cI = Z[23]
							cI()
							BI = os.clock()
						end
					end
					if oI then
						oI:Destroy()
					end
				end)
			end
			zI = iI("ESP Eggs", _I, eI)
			O:Toggle("ESP Fixed Size", false, function(SI)
				if KI ~= SI then
					KI = SI
					HI()
				end
			end, nil, zI)
			O:Toggle("ESP Own Base Eggs", true, function(SI)
				XI = SI
				xI()
			end, "Also show the eggs placed in your own base", zI)
			O:Toggle("ESP Other Base Eggs", false, function(SI)
				UI = SI
				xI()
			end, "Also show the eggs placed in other players bases", zI)
			local SI, oI, BI, vI, cI, DI = { "Any" }, { Any = 0 }, {}, {}, next, Z[34]
			_I, eI = DI.Assets
			if _I then
				DI = Z[34]
				eI = DI.Assets.Directory
			else
				eI = _I
			end
			for KI, KI in cI, eI or {}, nil do
				_I = type(KI) == "table" and KI.Rarity
				KI = type(_I) == "table" and tonumber(_I.RarityNumber or _I.Rank)
				if KI then
					if not BI[KI] then
						BI[KI] = tostring(_I.DisplayName or _I._id or KI)
						vI[#vI + 1] = KI
					end
				end
			end
			table.sort(vI)
			DI = "Any"
			for _I, _I in ipairs(vI) do
				eI = ("%d - %s"):format(_I, BI[_I])
				SI[#SI + 1] = eI
				oI[eI] = _I
				DI = if _I == 5 then eI else DI
			end
			O:Dropdown("ESP Min Rarity", SI, DI, function(eI)
				NI = oI[eI] or 0
				xI()
			end, false, "Show eggs of the chosen rarity and every rarity above it", zI)
			O:Dropdown(
				"ESP Show Info",
				{ "Icon", "Name", "Rarity", "Mutation", "Value", "Weight", "Size", "Sell Price", "Distance", "Area", "State" },
				{ "Icon", "Name", "Value" },
				function(eI)
					II = _(eI) or {}
					xI()
				end,
				true,
				nil,
				zI
			)
			O:Slider("Min ESP Value", 0, 0, 0, function(eI)
				VI = ZI(0, pI(eI / 1000)) * 1000
				xI()
			end, "log", nil, nil, zI)
			tI("ESP Egg Size", zI, function(eI)
				jI = eI
				HI()
			end)
		end
		do
			local eI, xI, SI, HI = { Sleeping = YI, Waking = sI, Chasing = JI }, {}, {}
			local sI = 0.75
			local function JI(_I)
				local oI, BI = _I:GetAttribute("GuardState"), _I:GetAttribute("TargetPlayer")
				if oI == "Waking" then
					return "Waking Up"
				end
				if oI == "Chasing" then
					local _I, _I = Z[1], tostring(Z[1].UserId)
					if BI == _I then
						return "Chasing You"
					end
					_I = tonumber(BI) and q:GetPlayerByUserId(tonumber(BI))
					return _I and "Chasing " .. _I.DisplayName or "Chasing"
				end
				return oI and tostring(oI) or "Awake"
			end
			local function _I(oI, BI)
				local vI = eI[BI:GetAttribute("GuardState")] or aI
				oI.hl.FillColor, oI.hl.OutlineColor = vI.o, vI.o
				kI(oI.sr, JI(BI), vI)
			end
			local function aI(JI)
				JI.b.Size = H(fI(115, sI), pI(OI(sI) * 1.6))
			end
			local function OI(JI)
				local eI = xI[JI]
				if not eI then
					return
				end
				xI[JI] = nil
				gI(eI.cs)
				eI.hl:Destroy()
				eI.b:Destroy()
			end
			local function JI(eI, fI)
				if xI[fI] then
					return
				end
				local oI = fI:FindFirstChild("HumanoidRootPart")
				oI = oI and oI:IsA("BasePart") and oI or fI.PrimaryPart or fI:FindFirstChildWhichIsA("BasePart", true)
				if not oI then
					return
				end
				HI = Y(HI)
				local BI, vI, zI, cI = LI(fI, HI), pcall(fI.GetBoundingBox, fI)
				local DI, NI, VI =
					if vI
						then if typeof(zI) == "CFrame" then zI.Position.Y + cI.Y * 0.5 - oI.Position.Y + 1 else 6
						else 6,
					uI(HI)
				cI = Z[28]
				NI.Adornee, NI.StudsOffsetWorldSpace = oI, cI(0, DI, 0)
				cI, zI = mI(VI, WI, 1, 0.45), mI(VI, WI, 2, 0.55)
				kI(cI, tostring(eI) .. " Guard", RI)
				local WI = { hl = BI, b = NI, sr = zI, cs = {} }
				xI[fI] = WI
				aI(WI)
				_I(WI, fI)
				local function RI()
					_I(WI, fI)
				end
				WI.cs[1], WI.cs[2] =
					fI:GetAttributeChangedSignal("GuardState"):Connect(RI),
					fI:GetAttributeChangedSignal("TargetPlayer"):Connect(RI)
				WI.cs[3] = fI.AncestryChanged:Connect(function()
					local WI = workspace
					if not (fI:IsDescendantOf(WI)) then
						OI(fI)
					end
				end)
			end
			FI = iI("ESP Guards", function()
				local WI = Z[54]
				local RI = WI("Areas", "GuardAreas")
				if not RI then
					return
				end
				local function WI(eI)
					local function fI(uI)
						if uI then
							if uI.Name == "Guard" then
								if uI:IsA("Model") then
									JI(eI.Name, uI)
								end
							end
						end
					end
					fI(eI:FindFirstChild("Guard"))
					SI[#SI + 1] = eI.ChildAdded:Connect(fI)
				end
				for JI, JI in ipairs(RI:GetChildren()) do
					WI(JI)
				end
				SI[#SI + 1] = RI.ChildAdded:Connect(WI)
			end, function()
				gI(SI)
				for WI in next, xI, nil do
					OI(WI)
				end
				if HI then
					HI:Destroy()
					HI = nil
				end
			end)
			tI("ESP Guard Size", FI, function(OI)
				sI = OI
				for OI, OI in next, xI, nil do
					aI(OI)
				end
			end)
		end
		do
			local OI = d("TextService")
			local WI = EI(0, 138, 255, 205, 0.5, 125, 225, 255, 1, 210, 135, 255)
			local FI, sI, aI, JI = EI(0, 7, 73, 66, 1, 35, 17, 79), false, 0
			local EI, RI, eI, fI, uI, mI = {}, {}, {}, {}, 0.75, { Name = true, Tool = true }
			local function kI(xI)
				xI = tostring(xI or "")
				return xI:match("^%d+$") and "rbxassetid://" .. xI or xI
			end
			local function xI(SI)
				if not SI then
					return ""
				end
				local HI = kI(SI.TextureId)
				if HI ~= "" then
					return HI
				end
				local _I = { "Icon", "Image", "Thumbnail", "TextureId" }
				for oI, BI in ipairs(_I) do
					oI = SI:GetAttribute(BI)
					if type(oI) == "string" then
						if kI(oI) ~= "" then
							return kI(oI)
						end
					end
				end
				for _I, _I in ipairs(SI:GetDescendants()) do
					HI = if _I:IsA("Decal")
						then kI(_I.Texture)
						else if _I:IsA("Texture")
							then kI(_I.Texture)
							else if _I:IsA("ImageLabel")
								then kI(_I.Image)
								else if _I:IsA("ImageButton") then kI(_I.Image) else HI
					if HI ~= "" then
						return HI
					end
				end
				return ""
			end
			local function kI(SI, HI)
				local _I = SI .. "@" .. HI
				if fI[_I] then
					return fI[_I]
				end
				local oI = F("GetTextBoundsParams", { Text = SI, Font = lI, Size = HI, Width = 1000 })
				local BI, vI = pcall(OI.GetTextBoundsAsync, OI, oI)
				oI:Destroy()
				fI[_I] = BI and vI.X or (utf8.len(SI) or #SI) * HI * 0.56
				return fI[_I]
			end
			local function OI(fI, SI, HI, _I)
				return AI({ Parent = fI, AnchorPoint = B(0, 0.5), FontFace = lI, ZIndex = SI, TextColor3 = HI, TextTransparency = _I })
			end
			local function lI(fI, AI)
				local SI = F(
					"ImageLabel",
					{ Parent = fI, AnchorPoint = B(0, 0.5), BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Fit, ZIndex = AI }
				)
				F("UIAspectRatioConstraint", { Parent = SI })
				return SI
			end
			local function B(fI)
				local AI, SI, HI, _I =
					ZI(1, pI(math.clamp(v() * 0.024, 26, 35) * uI)),
					mI.Name == true or mI.Username == true,
					mI.Avatar == true,
					mI.Tool == true and fI.ti.Image ~= ""
				local v, oI, BI, vI, zI =
					HI and pI(AI * 0.72) or 0,
					_I and pI(AI * 0.82) or 0,
					pI(AI * 0.7),
					ZI(1, pI(AI * 0.04)),
					mI.Username == true and fI.pl.Name or fI.pl.DisplayName
				fI.n.Text, fI.s.Text = zI, zI
				local cI, DI = SI and pI(math.clamp(kI(zI, BI) + 4, BI, 230)) or 0, v > 0 and v + vI or 0
				zI = SI and DI + cI or v
				local pI = zI > 0 and zI + vI or 0
				vI = ZI(_I and pI + oI or zI, 1)
				local ZI, kI, zI, NI = 1 / vI, 1 / AI, x(cI / vI, BI / AI), x(oI / vI, oI / AI)
				fI.b.Size, fI.a.Visible, fI.n.Visible, fI.s.Visible, fI.ti.Visible, fI.ts.Visible =
					H(vI, AI), HI, SI, SI, _I, _I
				fI.a.Position, fI.a.Size = x(0, 0.5), x(v / vI, v / AI)
				fI.n.Position, fI.n.Size = x(DI / vI, 0.5), zI
				fI.s.Position, fI.s.Size = x(DI / vI + ZI, 0.5 + kI), zI
				fI.ti.Position, fI.ti.Size = x(pI / vI, 0.5), NI
				fI.ts.Position, fI.ts.Size = x(pI / vI + ZI, 0.5 + kI), NI
			end
			local function v(pI, ZI, fI, AI)
				local kI, SI = LI(ZI, JI, m(0, 67, 148), m(72, 207, 255)), AI or fI
				ZI, AI =
					{ Parent = JI, Adornee = SI, AlwaysOnTop = true, LightInfluence = 0, MaxDistance = TI, Size = H(
						1,
						1
					) },
					Z[28]
				ZI.StudsOffsetWorldSpace =
					AI(0, SI ~= fI and math.clamp(fI.Position.Y - SI.Position.Y + 3.1, 3.8, 6) or 3.1, 0)
				SI = F("BillboardGui", ZI)
				fI = F("Frame", { Parent = SI, Size = x(1, 1), BackgroundTransparency = 1 })
				ZI = lI(fI, 2)
				ZI.ScaleType = Enum.ScaleType.Crop
				F("UICorner", { Parent = ZI, CornerRadius = UDim.new(1, 0) })
				local x, H = OI(fI, 1, m(7, 19, 34), 0.05), OI(fI, 2, PI)
				hI(H, 0, 0.044, 1.4, FI, WI)
				AI = lI(fI, 1)
				AI.ImageColor3 = wI
				AI.ImageTransparency = 0.35
				local m = { pl = pI, hl = kI, b = SI, a = ZI, s = x, n = H, ts = AI, ti = lI(fI, 2) }
				B(m)
				return m
			end
			local function m(x)
				if x.nh then
					if x.nh.Parent then
						x.nh.NameDisplayDistance = x.nd
					end
				end
				x.nh = nil
				x.nd = nil
			end
			local function x(H, OI)
				local pI = OI:FindFirstChildOfClass("Humanoid")
				if not pI then
					return
				end
				if H.nh ~= pI then
					m(H)
					H.nh, H.nd = pI, pI.NameDisplayDistance
				end
				pI.NameDisplayDistance = 0
			end
			local function H(OI)
				gI(OI.cc)
				if OI.t then
					OI.t.hl:Destroy()
					OI.t.b:Destroy()
					OI.t = nil
				end
				m(OI)
				OI.ch = nil
			end
			local function m(OI)
				OI.v = OI.v + 1
				H(OI)
			end
			local function H(OI)
				if OI.t then
					if not OI.ch then
						return
					end
				else
					return
				end
				local pI = xI(OI.ch:FindFirstChildOfClass("Tool"))
				OI.t.ti.Image, OI.t.ts.Image = pI, pI
				B(OI.t)
			end
			local function OI(pI, ZI, PI)
				m(pI)
				local wI = pI.v
				if sI then
					if not PI then
						return
					end
				else
					return
				end
				pI.ch = PI
				task.spawn(function()
					local TI = PI:FindFirstChild("Head") or PI:WaitForChild("Head", 5)
					if sI then
						if pI.v ~= wI then
							return
						elseif TI then
							if TI:IsA("BasePart") then
								local lI = workspace
								if not (PI:IsDescendantOf(lI)) then
									return
								end
							else
								return
							end
						else
							return
						end
					else
						return
					end
					JI = Y(JI)
					local Y = PI:FindFirstChild("HumanoidRootPart")
					pI.t = v(ZI, PI, TI, Y and Y:IsA("BasePart") and Y or nil)
					x(pI, PI)
					TI = pI.cc
					local function v()
						task.defer(function()
							if sI then
								if pI.v == wI then
									H(pI)
								end
							end
						end)
					end
					TI[#TI + 1] = PI.ChildAdded:Connect(function(lI)
						if lI:IsA("Tool") then
							v()
						elseif lI:IsA("Humanoid") then
							x(pI, PI)
						end
					end)
					TI[#TI + 1] = PI.ChildRemoved:Connect(function(x)
						if x:IsA("Tool") then
							v()
						end
					end)
					TI[#TI + 1] = PI.AncestryChanged:Connect(function()
						if pI.v == wI then
							local x = workspace
							if not (PI:IsDescendantOf(x)) then
								m(pI)
							end
						end
					end)
					H(pI)
					Y, TI = ZI.UserId, eI[ZI.UserId]
					if TI == nil then
						local x, H = pcall(
							q.GetUserThumbnailAsync,
							q,
							Y,
							Enum.ThumbnailType.HeadShot,
							Enum.ThumbnailSize.Size100x100
						)
						TI = x and H or ""
						eI[Y] = TI
					else
					end
					if sI then
						if pI.v == wI then
							if pI.t then
								pI.t.a.Image = TI
							end
						end
					end
				end)
			end
			local function Y(x)
				local H = EI[x]
				if not H then
					return
				end
				m(H)
				gI(H.pc)
				EI[x] = nil
			end
			local function x(H)
				local v = Z[1]
				if H == v then
					return
				elseif EI[H] then
					return
				end
				local v = { v = 0, cc = {}, pc = {} }
				EI[H] = v
				v.pc[1] = H.CharacterAdded:Connect(function(pI)
					OI(v, H, pI)
				end)
				v.pc[2] = H.CharacterRemoving:Connect(function(pI)
					if v.ch == pI then
						m(v)
					end
				end)
				OI(v, H, H.Character)
			end
			local function m()
				for H, H in next, EI, nil do
					if H.t then
						B(H.t)
					end
				end
			end
			YI = iI("ESP Players", function()
				sI = true
				aI += 1
				local H = aI
				JI = QI()
				for B, B in ipairs(q:GetPlayers()) do
					x(B)
				end
				RI[#RI + 1] = q.PlayerAdded:Connect(x)
				RI[#RI + 1] = q.PlayerRemoving:Connect(Y)
				local x = workspace.CurrentCamera
				if x then
					RI[#RI + 1] = x:GetPropertyChangedSignal("ViewportSize"):Connect(m)
				end
				task.spawn(function()
					while true do
						local x = aI
						if not (H == x) then
							break
						end
						task.wait(1)
						if H == aI then
							for H, B in next, EI, nil do
								local v, pI = H.Character, B.t and B.t.b
								x = pI and pI.Parent and pI.Adornee and pI.Adornee:IsDescendantOf(workspace)
								if v then
									pI = workspace
									if v:IsDescendantOf(pI) then
										if B.ch ~= v then
											OI(B, H, v)
										elseif x then
										else
											OI(B, H, v)
										end
									end
								end
							end
						end
					end
				end)
			end, function()
				sI = false
				aI += 1
				gI(RI)
				for x in next, EI, nil do
					Y(x)
				end
				if JI then
					JI:Destroy()
					JI = nil
				end
			end)
			O:Dropdown("ESP Player Info", { "Name", "Username", "Avatar", "Tool" }, { "Name", "Tool" }, function(O)
				mI = _(O) or {}
				m()
			end, true, nil, YI)
			tI("ESP Player Size", YI, function(O)
				uI = O
				m()
			end)
		end
	end)
	w("40_esp#2", function()
		local O = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold)
		local Y, m, x
		local function H()
			Y = F(
				"ScreenGui",
				{
					Parent = gethui and gethui() or d("CoreGui"),
					ResetOnSpawn = false,
					ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
					DisplayOrder = 49,
					Enabled = false,
				}
			)
			m, x = F("Frame", { Parent = Y, BackgroundTransparency = 1, ClipsDescendants = true }), {}
		end
		H()
		local B = false
		table.insert(Z[20].cleanup, function()
			B = true
			Y:Destroy()
		end)
		local v, OI = setmetatable, { __mode = "k" }
		local pI = v({}, OI)
		local ZI
		local PI, wI = 0, { "K", "M", "B", "T", "Qa", "Qi" }
		local function TI(lI)
			local WI = 0
			while lI >= 1000 and WI < #wI do
				lI, WI = lI / 1000, WI + 1
			end
			return (lI >= 100 and tostring(math.floor(lI + 0.5)) or ("%.1f"):format(lI):gsub("%.0$", ""))
				.. (wI[WI] or "")
				.. "/s"
		end
		OI, v = setmetatable, { __mode = "k" }
		local wI = OI({}, v)
		local function OI(lI, WI, EI, FI)
			if EI > 4 then
				return
			elseif FI[lI] then
				return
			end
			FI[lI] = true
			if type(lI) == "function" then
				if islclosure then
					if not (islclosure(lI)) then
						return
					end
				end
				local sI, aI = pcall(debug.getupvalues, lI)
				for JI, YI in next, sI and aI or {}, nil do
					JI = OI(YI, WI, EI + 1, FI)
					if JI then
						return JI
					end
				end
			elseif type(lI) == "table" then
				if rawget(lI, "Frame") == WI then
					return lI
				end
				for sI, aI in next, lI, nil do
					if type(aI) == "table" or type(aI) == "function" then
						sI = OI(aI, WI, EI + 1, FI)
						if sI then
							return sI
						end
					end
				end
			end
		end
		local function lI()
			local WI = Z[1]
			local EI = WI.PlayerGui:FindFirstChild("BackpackGui")
			WI = EI and (EI:FindFirstChild("Backpack"))
			if WI then
				if getconnections then
					if debug then
						if not debug.getupvalues then
							return
						end
					else
						return
					end
				else
					return
				end
			else
				return
			end
			local EI, FI = {}, WI:FindFirstChild("Main")
			FI = FI and (FI:FindFirstChild("Inventory"))
			FI = FI and (FI:FindFirstChild("ScrollingFrame"))
			local sI, aI = ipairs, { WI:FindFirstChild("Hotbar"), FI }
			for FI, JI in sI(aI) do
				for sI, aI in ipairs(JI and JI:GetChildren() or {}) do
					if aI:IsA("GuiButton") then
						FI = wI[aI]
						if FI == nil or type(FI) == "number" and os.clock() - FI > 30 then
							WI, sI = pcall(getconnections, aI.Activated)
							for JI, JI in ipairs(WI and sI or {}) do
								FI = JI.Function and OI(JI.Function, aI, 0, {})
								if FI then
									break
								end
							end
							wI[aI] = FI or os.clock()
						else
						end
						if type(FI) == "table" then
							EI[#EI + 1] = FI
						end
					end
				end
			end
			return EI
		end
		local function OI(wI, WI)
			local EI, FI = pcall(wI.GetAttribute, wI, WI)
			return EI and FI or nil
		end
		local function wI(WI)
			local EI, FI =
				("%s|%s|%s|%s"):format(
					tostring(OI(WI, "Category")),
					tostring(OI(WI, "Scale")),
					tostring(OI(WI, "BaseMutation")),
					tostring(OI(WI, "Mutations"))
				),
				pI[WI]
			if FI then
				if FI[1] == EI then
					return FI[2]
				end
			end
			local sI, aI = {}, {}
			local function JI(YI)
				YI = type(YI) == "string" and YI:match("^%s*(.-)%s*$") or ""
				if YI ~= "" then
					if YI ~= "Normal" then
						if YI ~= "None" then
							if not aI[YI] then
								aI[YI] = true
								sI[#sI + 1] = YI
							end
						end
					end
				end
			end
			JI(OI(WI, "BaseMutation"))
			for aI in tostring(OI(WI, "Mutations") or ""):gmatch("[^,]+") do
				JI(aI)
			end
			JI = OI(WI, "Scale")
			if JI then
			else
				local aI, YI, YI =
					tonumber(OI(WI, "Weight")), Z[22], tonumber(Z[22]("Rec", "WeightKgForScale", OI(WI, "Category"), 1))
				JI = aI and YI and YI > 0 and (aI / YI) ^ 0.3333333333333333 or 1
			end
			FI = L(OI(WI, "Category"), JI, sI)
			pI[WI] = { EI, FI }
			return FI
		end
		local function pI()
			local WI = F(
				"TextLabel",
				{ BackgroundTransparency = 1, FontFace = O, TextScaled = true, TextColor3 = Color3.new(1, 1, 1), Text = "", ZIndex = 5 }
			)
			F(
				"UIGradient",
				{
					Parent = WI,
					Rotation = 90,
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0, Color3.fromRGB(196, 255, 176)),
						ColorSequenceKeypoint.new(0.5, Color3.fromRGB(88, 255, 74)),
						ColorSequenceKeypoint.new(1, Color3.fromRGB(32, 176, 14)),
					}),
				}
			)
			local O = F(
				"UIStroke",
				{
					Parent = WI,
					Color = Color3.new(1, 1, 1),
					Thickness = 1.6,
					Transparency = 0.05,
					LineJoinMode = Enum.LineJoinMode.Round,
				}
			)
			F(
				"UIGradient",
				{ Parent = O, Rotation = 90, Color = ColorSequence.new(
					Color3.fromRGB(10, 70, 0),
					Color3.fromRGB(2, 22, 0)
				) }
			)
			return { l = WI, k = O }
		end
		local function O(WI, EI)
			while WI and WI ~= EI do
				if WI:IsA("GuiObject") then
					if not WI.Visible then
						return false
					end
				end
				WI = WI.Parent
			end
			return WI == EI
		end
		v = Z[61]
		W(v.RenderStepped, function()
			if B then
				return
			end
			if Y.Parent == nil or m.Parent ~= Y then
				pcall(Y.Destroy, Y)
				H()
			end
			local H = Z[1]
			local B = H:FindFirstChildOfClass("PlayerGui")
			local v, WI = B and (B:FindFirstChild("BackpackGui")), Z[25]
			if not (WI.espInv and v and v:IsA("ScreenGui") and v.Enabled) then
				if Y.Enabled then
					Y.Enabled = false
				end
				return
			end
			if os.clock() > PI then
				PI = os.clock() + 2
				ZI = lI() or ZI
			end
			if not ZI then
				return
			end
			local PI, lI, EI, FI, sI, aI, JI = Y, Y, Y, Y, v.IgnoreGuiInset, v.ScreenInsets, v.DisplayOrder + 1
			PI.Enabled = true
			lI.IgnoreGuiInset = sI
			EI.ScreenInsets = aI
			FI.DisplayOrder = JI
			lI = v:FindFirstChild("Backpack")
			lI = lI and (lI:FindFirstChild("Main"))
			lI = lI and (lI:FindFirstChild("Inventory"))
			lI = lI and (lI:FindFirstChild("ScrollingFrame"))
			aI, B = lI ~= nil and O(lI, v), Y.AbsolutePosition
			m.Visible = aI
			if aI then
				sI, JI, EI, WI = lI.AbsolutePosition - B, lI.AbsoluteSize, m, m
				FI, PI = UDim2.fromOffset(sI.X, sI.Y), UDim2.fromOffset(JI.X, JI.Y)
				EI.Position = FI
				WI.Size = PI
			end
			H, FI = {}, ZI
			for ZI, ZI in next, FI, nil do
				PI, JI = type(ZI) == "table" and rawget(ZI, "Frame"), type(ZI) == "table" and rawget(ZI, "Tool")
				sI = typeof(PI) == "Instance"
					and (
						typeof(JI) == "Instance" and JI.Parent ~= nil
						or type(JI) == "table" and type(rawget(JI, "GetAttribute")) == "function"
					)
				if sI and (OI(JI, "ItemType") or "Asset"):sub(1, 5) == "Asset" and OI(JI, "Category") then
					EI = lI ~= nil and PI:IsDescendantOf(lI)
					WI = (if EI then aI else not EI) and O(PI, v) and wI(JI) or 0
					if WI > 0 then
						local O = x[ZI] or pI()
						x[ZI] = O
						H[ZI] = true
						local v = EI and m or Y
						if O.l.Parent ~= v then
							if not (pcall(function()
								O.l.Parent = v
							end)) then
								x[ZI] = nil
								continue
							end
						end
						local Y, m = PI.AbsolutePosition - (EI and lI.AbsolutePosition or B), PI.AbsoluteSize
						O.l.Position, O.l.Size =
							UDim2.fromOffset(Y.X + m.X * 0.06, Y.Y + m.Y * 0.05),
							UDim2.fromOffset(m.X * 0.88, m.Y * 0.23)
						O.k.Thickness = math.clamp(m.Y / 52, 1, 2.2)
						m = TI(WI)
						if O.l.Text ~= m then
							O.l.Text = m
						end
						O.l.Visible = true
					end
				end
			end
			EI = x
			for O, Y in next, EI, nil do
				if not H[O] then
					if Y.l.Visible then
						Y.l.Visible = false
					end
				end
			end
		end)
	end)
	w("41_move#1", function()
		local O, Y = dI.Movement, false
		j(O, "Speed Boost", "boostOn", false, function(m)
			qI("boost", m and y, function()
				local m = Z[8]
				local x, H = m(), Z[15]
				m = H()
				if Z[4] then
					Y = false
					return
				elseif x then
					if m then
						if m.Anchored then
							Y = false
							return
						elseif x.Sit then
							Y = false
							return
						elseif x.PlatformStand then
							Y = false
							return
						else
							H = Z[29]
							if H() then
								Y = false
								return
							end
						end
					else
						Y = false
						return
					end
				else
					Y = false
					return
				end
				local B, v = x.MoveDirection, m.AssemblyLinearVelocity.Y
				if B.Magnitude > 0.1 then
					local OI, pI, ZI, ZI, ZI = Z[28], B.X, Z[25], Z[28]
					ZI, Y = OI(pI, 0, B.Z).Unit * Z[25].boost + Z[28](0, v, 0), true
					m.AssemblyLinearVelocity = ZI
				elseif Y then
					H, x = Z[28]
					x, Y = H(0, v, 0), false
					m.AssemblyLinearVelocity = x
				end
			end)
		end)
		X(O, "Boost Speed", "boost", 20, 1000, 350, "studs/s", 5)
		local Y, m = false, 0
		W(y, function()
			local x = Z[8]
			local H, B = x(), Z[15]
			local v, OI = B(), H and H.Jump or false
			x, B = OI and v
			if x then
				local pI = Y
				local ZI = not pI
				if pI then
					local pI = Z[25]
					B = pI.jump and os.clock() > m
				else
					B = ZI
				end
			else
				B = x
			end
			if B then
				m = os.clock() + 0.25
				local m, B = v.Anchored and not Z[4]
				if m then
					x = Z[20]
					B = (x.hold or 0) == 0
				else
					B = m
				end
				m = nil
				if B then
					local x
					x, m = Z[20], os.clock() > (Z[20].doffAt or 0) + 0.6
				else
					m = B
				end
				if m then
					B = Z[20]
					B.doffAt = os.clock()
					task.spawn(Z[9], "RF/Treadmill/AskDoff")
				else
					local m = Z[25]
					if m.jump then
						if not v.Anchored then
							H:ChangeState(Enum.HumanoidStateType.Jumping)
						end
					end
				end
			end
			Y = OI
		end)
		j(O, "Infinite Jump", "jump", false)
		O = Z[25]
		O.god = false
		local Y, m = pcall(require, P.Shared.Modules.Ragdoll)
		local x = {}
		x[Enum.HumanoidStateType.Physics] = true
		x[Enum.HumanoidStateType.Ragdoll] = true
		x[Enum.HumanoidStateType.FallingDown] = true
		local function H()
			local B = Z[1]
			local v, OI = B.Character, Z[8]
			local pI, ZI = OI(), Z[15]
			B = ZI()
			if v then
				if pI then
					if B then
						OI = Z[20]
						if OI.agBusy then
							return
						end
					else
						return
					end
				else
					return
				end
			else
				return
			end
			ZI, OI = B.AssemblyLinearVelocity, Z[28]
			local PI, wI = OI(ZI.X, 0, ZI.Z), Z[44]
			OI = wI() + 5
			PI = if PI.Magnitude > OI then PI.Unit * OI else PI
			wI = Z[28]
			B.AssemblyLinearVelocity = wI(PI.X, math.min(ZI.Y, 0), PI.Z)
			if Y then
				pcall(m.ClearClientRagdoll)
				pcall(m.Unragdoll, v)
			end
			for B, B in ipairs(v:GetDescendants()) do
				if B:IsA("BallSocketConstraint") then
					B:Destroy()
				elseif B:IsA("NoCollisionConstraint") then
					B:Destroy()
				elseif B:IsA("HingeConstraint") then
					B:Destroy()
				elseif B:IsA("Motor6D") then
					if not B.Enabled then
						B.Enabled = true
					end
				elseif B:IsA("AnimationConstraint") then
					if not B.Enabled then
						B.Enabled = true
					end
				end
			end
			if x[pI:GetState()] then
				pI:ChangeState(Enum.HumanoidStateType.Running)
			end
			if not Z[4] then
				pI.PlatformStand = false
			end
			workspace.CurrentCamera.CameraSubject = pI
		end
		local function x()
			local B = Z[20]
			if B.rag then
				return
			end
			task.spawn(function()
				for B = 1, 15, 1 do
					pcall(H)
					task.wait(0.033)
				end
			end)
		end
		O = Z[20]
		O.burst = x
		local H, B = dI.Character, Z[20]
		B.prot = H
		j(H, "Invisibility", "invis", false, function(B)
			local v = Z[20]
			if v.invPin then
				local v = Z[20]
				v.invPin(B)
			end
		end, "Makes you invisible to other players")
		j(H, "Anti Ragdoll", "antiRag", true, function(B)
			local v
			if B then
				local OI = Z[1]
				v = (OI:GetAttributeChangedSignal("RagdollEndTime"))
			else
				v = B
			end
			qI("ragAttr", v, function()
				local v = Z[29]
				if v() then
					x()
				end
			end)
			qI("ragRemote", B and Y and m.ClientRagdollRemote and m.ClientRagdollRemote.OnClientEvent, x)
		end)
		local Y = {}
		local function m(x)
			local B = Z[1]
			if x:GetAttribute("Owner") == B.Name then
				return
			end
			local B, v = ipairs, { x, table.unpack(x:GetDescendants()) }
			for x, x in B(v) do
				if x:IsA("BasePart") then
					if x.CanTouch then
						Y[x] = true
						x.CanTouch = false
					end
				end
			end
		end
		local x = d("CollectionService")
		j(H, "Anti Trap", "traps", true, function(B)
			qI("trap", B and x:GetInstanceAddedSignal("PlacedTrap"), function(v)
				task.defer(pcall, m, v)
			end)
			if B then
				for B, B in ipairs(x:GetTagged("PlacedTrap")) do
					pcall(m, B)
				end
			else
				local m = Y
				for x in next, m, nil do
					if x.Parent then
						x.CanTouch = true
					end
				end
				Y = {}
			end
		end, "Traps from other players cannot catch you")
		local Y, m, x, B = {}, { ClaimLostPart = true, CatchPrompt = true }, {}, false
		local function v(OI)
			if not (OI:IsA("ProximityPrompt")) then
				return
			end
			if OI.Name == "CatchPrompt" then
				local pI, ZI = ipairs, getconnections and getconnections(OI.PromptButtonHoldEnded) or {}
				for PI, PI in pI(ZI) do
					if not x[PI] then
						x[PI] = true
						pcall(PI.Disable, PI)
					end
				end
			elseif OI.HoldDuration > 0 then
				if not m[OI.Name] then
					local m = Y
					m[OI] = m[OI] or OI.HoldDuration
					OI.HoldDuration = 0
				end
			end
		end
		local function m(OI)
			if OI.Name ~= "CatchPrompt" then
				return
			elseif B then
				return
			end
			v(OI)
			B = true
			task.spawn(function()
				local pI = Z[9]
				local ZI, PI = pI("RF/ShootingStar/AskState")
				if ZI and type(PI) == "table" and PI.Id then
					local ZI, wI = os.clock(), true
					while true do
						local TI, lI = os.clock() - ZI, tonumber
						if not (TI < (lI(PI.HoldSeconds) or 1.6) + 0.3) then
							break
						end
						pI = Z[15]
						TI, lI = pI(), OI.Parent
						local pI = TI and lI and lI:IsA("BasePart")
						if
							if pI then (TI.Position - lI.Position).Magnitude > OI.MaxActivationDistance + 2 else not pI
						then
							wI = false
							break
						end
						task.wait(0.1)
					end
					if wI then
						s("RE/ShootingStar/Catch", PI.Id)
					else
						s("RE/ShootingStar/Hold", PI.Id, false)
					end
				end
				B = false
			end)
		end
		j(H, "Instant Prompts", "prompts", true, function(H)
			local B = d("ProximityPromptService")
			qI("prompt", H and B.PromptShown, v)
			qI("starTap", H and B.PromptButtonHoldBegan, m)
			if not H then
				B = Y
				for m, H in next, B, nil do
					if m.Parent then
						m.HoldDuration = H
					end
				end
				local m = x
				for H in next, m, nil do
					pcall(H.Enable, H)
				end
				Y, x = {}, {}
			end
		end)
		local Y = { idle = {} }
		local function m()
			Y.act = {}
			local x, x, H = Z[1], pcall(getconnections, Z[1].Idled)
			for B, B in ipairs(x and H or {}) do
				local v, OI = pcall(debug.getupvalues, B.Function)
				for B, B in next, v and OI or {}, nil do
					if typeof(B) == "Instance" then
						if B.ClassName == "TeleportService" then
							return
						end
					end
				end
			end
			x, H = pcall(getgc, false)
			for B, v in ipairs(x and H or {}) do
				if B % 120 == 0 then
					task.wait()
				end
				if type(v) == "function" then
					if islclosure(v) then
						local x, H = pcall(debug.info, v, "s")
						if x then
							if type(H) == "string" then
								if H:find("AntiAFK", 1, true) then
									local x, x = pcall(debug.info, v, "n")
									if x == "markActive" or x == "reportActiveFromInput" then
										Y.act[#Y.act + 1] = v
									end
								end
							end
						end
					end
				end
			end
		end
		local function x(H)
			if H then
				local H, B, v = ipairs, getconnections
				if B then
					local OI
					OI, v = Z[1], getconnections(Z[1].Idled)
				else
					v = B
				end
				for B, B in H(v or {}) do
					if pcall(B.Disable, B) then
						Y.idle[#Y.idle + 1] = B
					end
				end
				return
			end
			for H, H in ipairs(Y.idle) do
				pcall(H.Enable, H)
			end
			Y.idle = {}
			Y.act = nil
		end
		j(dI.Utility, "Anti AFK", "afk", true, x)
		table.insert(Z[20].cleanup, function()
			x(false)
		end)
		local H = G({ name = "Afk", gap = 120, at = os.clock() + 60 })
		H.on = function()
			local B = Z[25]
			return B.afk
		end
		H.fn = function()
			x(true)
			if not Y.act then
				m()
			end
			for m, m in ipairs(Y.act) do
				pcall(m)
			end
		end
		O = Z[1]
		W(O.CharacterAdded, function()
			local O = Z[25]
			if O.afk then
				task.delay(1, x, true)
			end
		end)
	end)
	w("41_move#2", function()
		local O = Z[20]
		local Y, Y = O.prot
		local m, x = false
		local H = Z[20]
		H.invPin = function(H)
			qI("invisPin", H and y, Y)
		end
		local function H()
			local B = Z[1]
			local v = B.Character
			return v ~= nil and v:GetAttribute("InvisApplied") == true
		end
		local B, v = Z[20], Z[20]
		B.invisible = H
		v.keepVis = 0
		local function v(OI)
			local pI = Z[8]
			local ZI = pI()
			if ZI then
				pcall(ZI.UnequipTools, ZI)
			end
			for pI, pI in ipairs(OI:GetChildren()) do
				if pI:IsA("Tool") then
					if t() then
						pI.Parent = t()
					end
				end
			end
			for OI = 1, 3, 1 do
				OI = Z[23]
				OI()
			end
		end
		local function OI()
			local pI = Z[1]
			local ZI, PI = pI.Character, Z[8]
			local wI = PI()
			if not (ZI and wI) then
				return
			end
			PI, pI = Z[20], Z[20]
			PI.invisBusy, pI.respawnAt = true, os.clock()
			bI()
			v(ZI)
			pI = Z[9]
			pI("RF/Treadmill/AskDoff")
			pcall(function()
				wI:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
				wI.BreakJointsOnDeath = true
				wI.RequiresNeck = true
				wI.Health = 0
				wI:ChangeState(Enum.HumanoidStateType.Dead)
				ZI:BreakJoints()
			end)
			pI = os.clock() + 60
			while true do
				PI = Z[1]
				if not (PI.Character == ZI and os.clock() < pI) then
					break
				end
				s("RE/RigSync/AskRigWipe", ZI)
				local v = os.clock() + 8
				while true do
					local PI = Z[1]
					if not (PI.Character == ZI and os.clock() < v) then
						break
					end
					task.wait(0.2)
				end
			end
			pI = Z[20]
			pI.invisBusy = m
		end
		O = Z[20]
		O.respawn = OI
		local O = false
		local function v()
			if O then
				return
			end
			O = true
			local O, pI =
				ipairs,
				{
					"RE/GearSatchel/Lost",
					"RE/GearSatchel/Gained",
					"RE/RigSync/ProbeSatchel",
					"RE/RigSync/SeedSatchel",
					"RE/RigSync/CorrectionBegan",
					"RE/RigSync/Refresh",
					"RE/ToolTrigger/Trigger",
					"RE/BatSwing/Trigger",
				}
			for ZI, PI in O(pI) do
				ZI = Z[39]
				local O = ZI:FindFirstChild(PI)
				if O then
					W(O.OnClientEvent, function() end)
				end
			end
			pI = t()
			if pI then
				W(pI.ChildAdded, function() end)
				W(pI.ChildRemoved, function() end)
			end
		end
		local function O(t)
			local pI = Z[20]
			pI.invisBusy = true
			local ZI, PI = t:WaitForChild("Humanoid", 10), t:WaitForChild("HumanoidRootPart", 10)
			t:WaitForChild("Head", 10)
			if ZI then
				if not PI then
					pI = Z[20]
					m = false
					pI.invisBusy = false
					return
				end
			else
				local wI = Z[20]
				m = false
				wI.invisBusy = false
				return
			end
			task.wait(0.05)
			pcall(ZI.UnequipTools, ZI)
			pcall(ZI.UnequipTools, ZI)
			for wI = 1, 2, 1 do
				pcall(replicatesignal, ZI.ServerBreakJoints)
			end
			local wI, TI = ZI.HipHeight, PI.CFrame
			PI.Anchored = true
			ZI.HipHeight = 999
			for lI, lI in ipairs(t:GetDescendants()) do
				if lI:IsA("Accessory") then
					lI.Parent = nil
				elseif lI:IsA("BasePart") then
					if lI ~= PI then
						if not (lI:FindFirstAncestorOfClass("Accessory")) then
							lI.Parent = nil
						end
					end
				end
			end
			task.wait(0.12)
			ZI, pI = Instance.new("Part"), Z[28]
			ZI.Name, ZI.Size = "RightHand", pI(0.2, 0.2, 0.2)
			ZI.Transparency = 1
			ZI.CanCollide = false
			ZI.CanTouch = false
			ZI.CanQuery = false
			ZI.Massless = true
			ZI.Parent = t
			local lI, WI = Instance.new("Motor6D"), Z[27]
			lI.Name, lI.C0 = "RightWrist", WI(1.2, 0, 0)
			lI.Part0 = PI
			lI.Part1 = ZI
			lI.Parent = PI
			PI.CanCollide = false
			task.delay(0.2, function()
				if PI.Parent then
					PI.CanCollide = true
				end
			end)
			for ZI, ZI in ipairs(t:GetChildren()) do
				if ZI:IsA("Humanoid") then
					ZI.AutomaticScalingEnabled = false
					ZI.HipHeight = wI
				end
			end
			t:SetAttribute("InvisHip", wI)
			if PI.Position.Y > TI.Y + 5 then
				PI.CFrame = TI
			end
			TI = Z[33]
			PI.AssemblyLinearVelocity = TI
			PI.Anchored = false
			t:SetAttribute("InvisApplied", true)
			pI = Z[20]
			pI.invisSettle = os.clock() + 1
			pI = Z[20]
			m = false
			pI.invisBusy = false
			task.delay(1, v)
		end
		local function t()
			local v, pI = Z[4]
			if v then
				pI = v
			else
				local ZI = Z[20]
				local PI = ZI.queue
				if PI then
					ZI = Z[20]
					pI = ZI.queue[1]
				else
					pI = PI
				end
			end
			local ZI, PI = pI ~= nil
			if ZI then
				v = Z[20]
				PI = v.needVis ~= nil
			else
				PI = ZI
			end
			v = nil
			if PI then
				ZI = Z[20]
				v = ZI.needVis(pI, pI.plan)
			else
				v = PI
			end
			return v
		end
		local function v()
			local pI = Z[25]
			local ZI, PI = pI.invis
			if ZI then
				pI = nil
				pI, PI = Z[20], os.clock() >= Z[20].keepVis
			else
				PI = ZI
			end
			pI = nil
			if PI then
				ZI = nil
				ZI, pI = Z[20], os.clock() - (Z[20].flipAt or -99) > 20
			else
				pI = PI
			end
			ZI = nil
			if pI then
				PI = Z[20]
				local wI, TI = PI.lock
				if wI then
					local PI = Z[20]
					TI = PI.lock()
				else
					TI = wI
				end
				ZI = not TI
			else
				ZI = pI
			end
			return ZI and not t()
		end
		B = Z[20]
		B.invisWant = v
		local pI = Z[20]
		pI.needBody = function()
			local pI, ZI = Z[20]
			ZI, pI.keepVis = Z[20], math.max(Z[20].keepVis, os.clock() + (H() and 25 or 5))
			return not H()
		end
		local pI, ZI = {}, Z[20]
		ZI.body = function(ZI)
			if H() == ZI then
				return true
			end
			local PI = os.clock()
			while pI[1] and PI - pI[1] > 60 do
				table.remove(pI, 1)
			end
			local wI
			if ZI then
				local TI = Z[25]
				wI = not TI.invis
			else
				wI = ZI
			end
			if wI then
				return false
			else
				local TI = Z[21]
				if TI() then
					return false
				elseif #pI >= 6 then
					return false
				end
			end
			wI = nil
			wI, pI[#pI + 1] = Z[20], PI
			x = ZI
			wI.flipAt = PI
			wI = Z[11]
			wI(ZI and "Turning invisible" or "Turning visible")
			OI()
			wI = os.clock() + 15
			while true do
				local OI, pI = Z[56] and os.clock() < wI
				if OI then
					PI = Z[20]
					local wI = PI.invisBusy or m
					if wI then
						pI = wI
					else
						local PI
						PI, pI = Z[20], os.clock() < (Z[20].invisSettle or 0)
					end
				else
					pI = OI
				end
				if not pI then
					break
				end
				task.wait(0.1)
			end
			return H() == ZI
		end
		B = Z[1]
		W(B.CharacterAdded, function(B)
			local OI, pI = Z[20]
			pI, OI.invisSettle = Z[20], math.max(Z[20].invisSettle or 0, os.clock() + 1)
			pI = x
			x = nil
			pI = if pI == nil then (v()) else pI
			if pI then
				OI = Z[20]
				m = true
				OI.invisBusy = true
				task.defer(function()
					if not (pcall(O, B)) then
						local O = Z[20]
						m = false
						O.invisBusy = false
					end
				end)
			end
		end)
		Y = function()
			local O = Z[1]
			local Y = O.Character
			if Y then
				if not (Y:GetAttribute("InvisApplied")) then
					return
				end
			else
				return
			end
			local x, B = Y:FindFirstChild("RightHand"), Y:FindFirstChildOfClass("Tool")
			Y = B and (B:FindFirstChild("Handle"))
			if x and Y then
				for OI, OI in ipairs(x:GetChildren()) do
					if OI:IsA("JointInstance") then
						if OI.Name == "RightGrip" then
							OI.Enabled = false
						end
					end
				end
				Y.CFrame = x.CFrame
				O = Z[33]
				Y.AssemblyLinearVelocity = O
			end
			B = Z[8]
			x, Y = B(), Z[15]
			O = Y()
			if x then
				if O then
					if Z[4] then
						if x then
							x.AutoRotate = true
						end
					elseif O.Anchored then
						if x then
							x.AutoRotate = true
						end
					elseif x.MoveDirection.Magnitude > 0.1 then
						x.AutoRotate = false
						O.CFrame = CFrame.lookAt(O.Position, O.Position + x.MoveDirection)
					elseif x then
						x.AutoRotate = true
					end
				elseif x then
					x.AutoRotate = true
				end
			elseif x then
				x.AutoRotate = true
			end
		end
		local O = G({ name = "Invis", gap = 1 })
		O.on = function()
			local Y = Z[25]
			return Y.invis or H()
		end
		O.fn = function()
			local O, Y = Z[4]
			if O then
				Y = O
			else
				local x = Z[20]
				Y = x.invisBusy
			end
			local x, B = Y or m or carrying()
			if x then
				B = x
			else
				Y = Z[20]
				O = Y.lock
				if O then
					local m = Z[20]
					B = m.lock()
				else
					B = O
				end
			end
			if B then
				return
			else
				O, Y = Z[20], os.clock() - (Z[20].mvEnd or 0)
				if Y < 1 then
					return
				else
					local O, m = Z[20], Z[20]
					if (O.queueAt or 0) < (m.mvEnd or 0) + 0.2 then
						return
					end
				end
			end
			if H() then
				B = Z[25]
				if B.invis then
					x = Z[20]
					if os.clock() < x.keepVis then
						Y = Z[20]
						Y.body(false)
					elseif t() then
						local O = Z[20]
						O.body(false)
					end
				else
					local O = Z[20]
					O.body(false)
				end
			elseif v() then
				local O = Z[20]
				O.body(true)
			end
		end
	end)
	w("42_combat#1", function()
		local O, Y, m, t, x, H = dI.Combat, Z[25], Z[25], Z[25], Z[25], Z[25]
		Y.skipFr = true
		m.hitLead = -275
		t.hitSweep = 60
		x.hitMax = 750
		H.chase = 400
		local Y, m, B = 0, 0, 0
		local function v(OI, pI)
			local ZI = Z[1]
			if OI == ZI then
				return
			elseif OI.Parent ~= q then
				return
			end
			ZI = OI.Character
			local PI, wI = ZI and (ZI:FindFirstChildOfClass("Humanoid")), ZI and (ZI:FindFirstChild("HumanoidRootPart"))
			if PI then
				if wI then
					if PI.Health <= 0 then
						return
					elseif ZI:GetAttribute("IsTrapped") then
						return
					elseif OI:GetAttribute("InBossArena") then
						return
					else
						local ZI = Z[16]
						if ZI(wI.Position) then
							return
						end
					end
				else
					return
				end
			else
				return
			end
			if not pI then
				if (tonumber(OI:GetAttribute("RagdollEndTime")) or 0) > J() then
					return
				end
			end
			return wI
		end
		local function OI(pI)
			if pI then
			else
				local ZI = Z[20]
				local PI, PI = ZI.bat()
				pI = PI
			end
			return (17 + (pI or 0)) * (workspace:GetAttribute("DragonEggEventActive") and 2.5 or 1) - 1
		end
		local function pI(ZI, PI)
			if workspace:GetAttribute("PvPDisabled") then
				return
			end
			local wI = Z[20]
			local TI, lI = wI.bat()
			wI = Z[15]
			local WI, EI = wI(), OI(lI)
			if TI then
				if WI then
					wI = Z[20]
					if not (wI.needBody()) then
						return
					end
				else
					return
				end
			else
				return
			end
			wI = Z[8]
			local FI, sI = wI(), Z[1]
			if TI.Parent ~= sI.Character then
				if FI then
					pcall(FI.EquipTool, FI, TI)
				end
			end
			wI = Z[1]
			if TI.Parent ~= wI.Character then
				return
			end
			wI = Z[20]
			if wI.scrambler(TI) then
				if os.clock() - B > 0.3 then
					B = os.clock()
					pcall(TI.Activate, TI)
				end
				return
			end
			wI = Z[32]
			sI, lI = wI(), WI.Position - WI.AssemblyLinearVelocity * 0.18
			if (PI.Position + PI.AssemblyLinearVelocity * sI - lI).Magnitude > EI then
				if (PI.Position - lI).Magnitude > EI then
					return
				end
			end
			if J() < (tonumber(TI:GetAttribute("CooldownEndTime")) or 0) - sI * 0.5 then
				return
			end
			if os.clock() - m < math.max(0.12, sI * 1.5) then
				return
			end
			m = os.clock()
			Y += 1
			PI = Z[1]
			s("RE/BatSwing/Trigger", ZI, ("%d:%d:%d"):format(PI.UserId, Y, math.floor(J() * 1000)))
			pcall(TI.Activate, TI)
		end
		local Y = Z[20]
		Y.chase = function(Y, m)
			local B, ZI = v(Y, m), Z[15]
			local PI, wI = ZI(), Z[8]
			ZI = wI()
			if B then
				if PI then
					if not ZI then
						return false
					end
				else
					return false
				end
			else
				return false
			end
			ZI.PlatformStand = true
			wI, m, ZI = Z[32], Z[28], B.Position + B.AssemblyLinearVelocity * (Z[32]() + 0.2) + Z[28](0, 1.5, 0)
			local m, wI = B.AssemblyLinearVelocity + (ZI - PI.Position) / 0.12, Z[25]
			if m.Magnitude > wI.chase * 1.8 then
				ZI = nil
				ZI, m = Z[25], m.Unit * Z[25].chase * 1.8
			else
			end
			wI = nil
			wI, PI.CFrame = Z[28], CFrame.lookAt(PI.Position, Z[28](B.Position.X, PI.Position.Y, B.Position.Z))
			wI = Z[33]
			PI.AssemblyLinearVelocity = m
			PI.AssemblyAngularVelocity = wI
			pI(Y, B)
			return true
		end
		x, H = setmetatable, { __mode = "k" }
		local Y, m = x({}, H), Z[20]
		m.huntStep = function(m, B, ZI)
			local PI = Z[15]
			local wI, TI = PI(), Z[8]
			PI = TI()
			if wI then
				if not PI then
					return
				end
			else
				return
			end
			PI.PlatformStand = true
			PI = Y[m] or {}
			Y[m] = PI
			local Y, Y = Z[28], B.AssemblyLinearVelocity * Z[28](1, 0, 1)
			PI.s = PI.s and PI.s:Lerp(Y, 0.25) or Y
			if PI.s.Magnitude > 1 then
				PI.hd = (PI.hd and PI.hd:Lerp(PI.s.Unit, 0.25) or PI.s.Unit).Unit
			end
			local lI, WI, WI, EI, FI = PI.s.Magnitude, Z[28], (wI.Position - B.Position) * Z[28](1, 0, 1), PI.hd
			if EI then
				FI = EI
			else
				TI = WI.Magnitude > 0.1 and WI.Unit
				if TI then
					FI = TI
				else
					Y = Z[28]
					FI = (Y(0, 0, 1))
				end
			end
			Y, TI = Z[32], Z[25]
			local sI, aI, JI = B.Position + PI.s * (Y() + 0.38 + TI.hitLead / 1000), lI > 1 and PI.s.Unit * 3.6
			if aI then
				JI = aI
			else
				EI = Z[33]
				JI = EI
			end
			Y, TI = sI + JI, Z[28]
			sI = TI(-FI.Z, 0, FI.X)
			sI = if sI:Dot(wI.Position - Y) < 0 then -sI else sI
			EI = os.clock() * 2 * 3.141592653589793
			local TI, TI, TI, YI =
				Z[25],
				Z[28],
				Y
					+ FI * (math.sin(EI / 1.1) * 0.5 + 0.5) * math.max(5, math.min(OI() * 0.7, 6 + lI * 0.07)) * Z[25].hitSweep / 100
					+ sI * (lI < 35 and 3 or 1.5)
					+ Z[28](0, math.sin(EI / 0.8) * 2.5, 0),
				Z[29]
			sI, JI = YI() and 1500 or WI.Magnitude > 60 and 1000
			if sI then
				JI = sI
			else
				aI, FI, WI = nil
				aI, FI, WI, JI = Z[25], Z[25], Z[25], math.min(Z[25].chase + lI, math.max(Z[25].chase, Z[25].hitMax))
			end
			sI = PI.s + (TI - wI.Position) / math.max(0.12, ZI)
			sI = if sI.Magnitude > JI then sI.Unit * JI else sI
			PI, FI = Z[28], (B.Position - wI.Position) * Z[28](1, 0, 1)
			if FI.Magnitude > 0.05 then
				wI.CFrame = CFrame.lookAt(wI.Position, wI.Position + FI.Unit)
			end
			TI, FI = Z[28]
			FI, wI.AssemblyLinearVelocity = Z[33], sI + TI(0, workspace.Gravity * ZI * 0.5, 0)
			wI.AssemblyAngularVelocity = FI
			pI(m, B)
		end
		H, t = setmetatable, { __mode = "k" }
		local Y = H({}, t)
		local function m(H)
			task.spawn(function()
				local B, B, B, ZI = Z[1], Z[1], pcall(Z[1].IsFriendsWith, Z[1], H.UserId)
				Y[H] = B and ZI
			end)
		end
		qI("friends", q.PlayerAdded, m)
		for H, H in ipairs(q:GetPlayers()) do
			m(H)
		end
		local function H(B)
			local ZI = Z[25]
			return not (ZI.skipFr and Y[B])
		end
		local function Y(B, ZI)
			local PI = Z[15]
			local wI, TI = PI(), B or 1 / 0
			if not wI then
				return
			end
			B, PI = nil
			for lI, WI in ipairs(q:GetPlayers()) do
				lI = (if ZI then ZI[WI] else not ZI) and H(WI) and v(WI)
				if lI then
					if (lI.Position - wI.Position).Magnitude < TI then
						local H = (lI.Position - wI.Position).Magnitude
						TI, B, PI = H, WI, lI
					else
					end
				else
				end
			end
			return B, PI
		end
		local H = 0
		local B = G({ name = "Combat", mover = true, gap = 0.5, pri = 7, soft = true })
		local v, ZI, PI = N("hitSt", O:Text("Hit Status", "Idle")), {}
		local function wI(TI, lI)
			if TI.Value then
				local WI = Z[25]
				if WI.invis then
					D("hg" .. lI, function()
						TI:Set(false)
					end)
					c(lI, "Turn off Invisibility first, both cannot be on at the same time")
					return true
				end
			end
		end
		local function TI(lI)
			for WI, WI in ipairs(ZI) do
				if WI ~= lI then
					if WI.Value then
						WI:Set(false)
					end
				end
			end
		end
		local lI = { "Nearest player", "Egg holders", "Chosen player" }
		local function WI()
			local EI, FI = Z[25], Z[25]
			EI.combat = false
			FI.hitWho = nil
			FI = ipairs
			for sI, aI in FI(ZI) do
				if aI.Value then
					if sI <= 3 then
						local FI, aI = Z[25], Z[25]
						FI.combat, aI.hitWho = true, lI[sI]
					end
				end
			end
			EI = Z[25]
			if not EI.combat then
				CI(B)
			end
			I()
		end
		t = { "Auto Hit Nearest Player", "Auto Hit Egg Holders", "Auto Hit Specific Player" }
		for I, lI in ipairs(t) do
			local t
			t = O:Toggle(lI, false, function(EI)
				if wI(t, lI) then
					return
				end
				if EI then
					TI(t)
				end
				WI()
			end)
			ZI[I] = t
		end
		local function t()
			local I, lI, WI = {}, ipairs, C[20](q:GetPlayers())
			for EI, FI in lI(C:QH(WI)) do
				EI = Z[1]
				if FI ~= EI then
					I[#I + 1] = FI.Name
				end
			end
			table.sort(I)
			return #I > 0 and I or { "No Players" }
		end
		O:Dropdown("Hit Player", t, nil, function(I)
			PI = I
		end, false, nil, ZI[3])
		local I
		I = O:Toggle("Hit Aura", false, function(lI)
			if wI(I, "Hit Aura") then
				return
			end
			if lI then
				TI(I)
			end
			local wI = Z[25]
			wI.aura = lI
			qI("aura", lI and y, function()
				if os.clock() - H < 0.05 then
					return
				elseif Z[4] then
					if Z[4].name == "Steal" then
						return
					elseif Z[4].name == "Bloom" then
						return
					end
				end
				H = os.clock()
				local H, wI = Y(OI() + 6)
				if H then
					pI(H, wI)
				end
			end)
		end)
		ZI[4] = I
		x = Z[20]
		local function H(OI)
			local pI = Z[25]
			pI.weap = nil
			pI = ipairs
			for wI, TI in pI(OI) do
				if wI <= 2 then
					local OI, pI = Z[25], Z[25]
					OI.weap = pI.weap or {}
					pI, OI = Z[25]
					OI, pI.weap[Z[20].weaponId[TI] or TI] = Z[20], true
				end
			end
		end
		m, t =
			O:Dropdown(
				"Swap Weapons",
				x.ownedWeapons,
				{},
				H,
				true,
				"Pick up to 2 weapons you own to switch between while hitting (empty = best bat only)"
			),
			Z[25]
		t.swapT = 0.35
		O:Slider("Weapon 1 Hold", 0.2, 1.5, 0.3, function(t)
			local x = Z[25]
			x.swapT = t
		end, "s", 0.01, nil, m)
		O:Slider("Weapon 2 Hold", 0.2, 1.5, 0.4, function(t)
			local x = Z[25]
			x.swapT2 = t
		end, "s", 0.01, nil, m)
		m = O:Label("Chase Settings", "Chase Settings")
		X(O, "Hit Tween Speed", "chase", 100, 1000, 400, "studs/s", 10, nil, nil, m)
		X(O, "Hit Max Speed", "hitMax", 100, 1000, 750, "studs/s", 10, nil, nil, m)
		X(
			O,
			"Hit Lead",
			"hitLead",
			-400,
			100,
			-275,
			nil,
			1,
			nil,
			"Stand further ahead of the target (+) or closer to them (-)",
			m
		)
		X(
			O,
			"Hit Sweep",
			"hitSweep",
			0,
			250,
			60,
			"%",
			1,
			nil,
			"How far you move back and forth in front of the target",
			m
		)
		O:Button("Add/Remove Hits On Quick Bar 2", "Add", function()
			local O, m = z:State("Quick Pinned Features", {}), z:State("Quick Pin Groups", {})
			local t, x, H, OI, pI, wI =
				table.clone(type(O.Value) == "table" and O.Value or {}),
				table.clone(type(m.Value) == "table" and m.Value or {}),
				{},
				ipairs,
				{ ZI[1], ZI[2], I },
				true
			for I, I in OI(pI) do
				H[#H + 1] = I.Path
				wI = if table.find(t, I.Path) then if tonumber(x[I.Path]) == 2 then wI else false else false
			end
			for I, I in ipairs(H) do
				pI = table.find(t, I)
				if wI then
					if pI then
						table.remove(t, pI)
					end
					x[I] = nil
				else
					if not pI then
						t[#t + 1] = I
					end
					x[I] = 2
				end
			end
			m.Value = x
			O:Set(t)
		end, "Pin or unpin the hit toggles on Quick Bar 2", "Done!")
		local O = G({ name = "HitInfo", gap = 1, info = true })
		O.on = function()
			return rI("Player")
		end
		O.fn = function()
			local O, m = Z[4] == B and "Chasing"
			if O then
				m = O
			else
				local t = Z[25]
				m = t.combat and "Looking for a target"
			end
			O = nil
			if m then
				O = m
			else
				local m = Z[25]
				O = m.aura and "Hit Aura on"
			end
			v(O or "Idle")
		end
		local function O()
			local m, t, x = {}, pairs, Z[18]
			local H = C[20](x())
			for v, I in t(C:QH(H)) do
				x, v = type(I) == "table" and I.State == "Carried" and tonumber(I.CarrierUserId)
				if x then
					I = Z[1]
					v = x ~= I.UserId
				else
					v = x
				end
				I = v and (q:GetPlayerByUserId(x))
				if I then
					m[I] = true
				end
			end
			return m
		end
		local function m()
			local t = Z[25]
			if t.hitWho == "Egg holders" then
				return Y(nil, O())
			end
			t = Z[25]
			if t.hitWho == "Chosen player" then
				local O = PI and q:FindFirstChild(PI)
				return O and Y(nil, { [O] = true })
			end
			return Y()
		end
		B.on = function()
			local O = Z[25]
			return O.combat
		end
		B.want = function()
			return m()
		end
		B.run = function(O, Y)
			local t = Z[20]
			if t.needBody() then
				if Z[13](Y) then
					local x = Z[14]
					if not (x(Y)) then
						return
					end
				else
					return
				end
			else
				return
			end
			t = os.clock()
			while Y() do
				if os.clock() - t > 0.3 then
					t, O = os.clock(), m()
					if not O then
						break
					end
				else
				end
				local m = Z[20]
				if not (m.chase(O)) then
					break
				end
				m = Z[23]
				m()
			end
			Y = Z[8]
			t = Y()
			if t then
				t.PlatformStand = false
			end
		end
	end)
	w("43_alien#1", function()
		local O, Y = {}, Z[20]
		Y.Alien = O
		local function m(t)
			local x = P
			for H in t:gmatch("[^.]+") do
				x = x and (x:FindFirstChild(H))
			end
			local t, H = pcall(require, x)
			return t and H or nil
		end
		local t = m("Shared.Util.Fishing")
		local x = m("Shared.Util.AlienRods")
		local H = m("Shared.Util.AlienLagoon")
		local B = m("Shared.Util.AlienGate")
		local v = m("Data.FishingMastery")
		local I = m("Shared.Flags.AlienLagoonFlags")
		local OI = G({ name = "Fish", mover = true, gap = 1, pri = 12, soft = true, vis = true })
		local pI = G({ name = "Relic", mover = true, gap = 3, pri = 11, vis = true })
		local ZI, ZI =
			{
				{ "Fish", "rbxassetid://96888243646490" },
				{ "Pearls", H and H.VoidPearl and H.VoidPearl.Icon or "rbxassetid://71951635524856" },
				{ "Relics", "rbxassetid://80751573593122" },
			},
			dI["Alien Biome"]
		local PI = N("alien", ZI:Text("Alien Status", "Off"))
		j(
			ZI,
			"Auto Cosmic Eclipse",
			"alEclipse",
			false,
			nil,
			"Goes into the Lagoon and fishes whenever the Kraken shows up"
		)
		O.fishT = j(ZI, "Auto Fishing", "fish", false, function(rI)
			if not rI then
				CI(OI)
			end
		end)
		K(ZI, "Cast Luck", "alLuck", { "x1.5 Perfect", "x1.2", "x1.1", "x1.0 Fastest" }, "x1.5 Perfect")
		O.dd = K(
			ZI,
			"Fishing Spot",
			"alSpot",
			{ "Alien Dock", "Alien Lagoon", "Spot 1", "Spot 2", "Spot 3" },
			"Alien Dock",
			function()
				O.sp = nil
			end
		)
		ZI:Button("Save Spot Here", "Save", function()
			O.save()
		end, nil, "")
		j(ZI, "Auto Claim Mastery", "alClaim", false)
		j(ZI, "Auto Trade Pearls", "alTrade", false)
		j(ZI, "Auto Socket Relics", "alRelic", false, function(rI)
			if not rI then
				CI(pI)
			end
		end)
		j(ZI, "Auto Get Alien Rod", "alRod", false)
		j(ZI, "Fast Lagoon Trips", "alFast", true, nil, "Enter and leave the Lagoon faster")
		ZI = dI["Priority Rotation"]
		local rI = N("alRot", ZI:Text("Rotation Status", "Off"))
		j(ZI, "Rotate Fishing And Treadmill", "rot", false, function(N)
			if N then
				O.ask()
			else
				O.off()
			end
		end)
		K(ZI, "Rotation Switch", "rotMode", { "Timer", "Every Day" }, "Timer")
		X(ZI, "Fishing Minutes", "rotFishMin", 1, 120, 5, " min", 1)
		X(ZI, "Treadmill Minutes", "rotTreadMin", 1, 120, 5, " min", 1)
		O.t0 = os.clock()
		local N = {
			"Auto Fishing and Auto Treadmill are off. Turn both on now so Priority Rotation can start?",
			"Auto Fishing is off. Turn it on now so Priority Rotation can start?",
			"Auto Treadmill is off. Turn it on now so Priority Rotation can start?",
		}
		O.off = function()
			if O.t0 then
				if os.clock() - O.t0 >= 8 then
					local wI = Z[20]
					if wI.treadLast then
						local wI = Z[20]
						wI.treadLast()
					end
				end
			end
		end
		O.ask = function()
			local wI = Z[25]
			local TI, lI = not wI.fish, Z[20]
			local wI, WI = lI.treadOn
			if wI then
				lI = Z[20]
				WI = lI.treadOn()
			else
				WI = wI
			end
			local wI = not WI
			if os.clock() - O.t0 < 8 then
				return
			elseif not (TI or wI) then
				return
			end
			local function WI()
				if TI then
					if O.fishT then
						O.fishT:Set(true)
					end
				end
				if wI then
					local EI = Z[20]
					if EI.treadT then
						local EI = Z[20]
						EI.treadT:Set(true)
					end
				end
			end
			lI = N[TI and wI and 1 or TI and 2 or 3]
			z:Dialog({ Title = "Priority Rotation", Warn = "Not ready yet", Body = lI, Cancel = "Not Now", Accept = "Turn On", ok = WI })
		end
		local function N()
			return tostring(workspace:GetAttribute("LiveEventFlag_AlienBiomeOpen")) == "true"
		end
		local function wI(TI, lI)
			local WI = I and I[TI]
			return type(WI) == "table" and tonumber(WI.Value) or lI
		end
		local function I()
			local TI = Z[67]
			local lI = TI()
			return lI ~= nil and (tonumber(lI.SpeedPower) or 0) >= wI("MinSpeedPower", 250000000000)
		end
		local function TI()
			local lI = Z[67]
			local WI = lI()
			return x ~= nil and WI ~= nil and (x.OwnedTier(WI.GearInventory or {}) or 0) >= 1
		end
		local function lI(WI)
			local EI, FI, sI, aI, JI = {}, ipairs, {}, Z[1], Z[1]
			C:EH(sI, 0, aI.Character, JI:FindFirstChildOfClass("Backpack"))
			for aI, aI in FI(sI) do
				for FI, FI in ipairs(aI and aI:GetChildren() or {}) do
					if FI:IsA("Tool") then
						if WI(FI) then
							EI[#EI + 1] = FI
						end
					end
				end
			end
			return EI
		end
		ZI = Z[1]
		local WI, EI, FI = "SAE_AlienFishLog_" .. ZI.UserId .. ".json"
		local function ZI()
			pcall(writefile, WI, T:JSONEncode(EI))
			if O.onLog then
				pcall(O.onLog, EI)
			end
		end
		local function sI()
			if EI then
				local aI = EI
				return aI
			end
			local aI, JI = pcall(function()
				local YI = C[20](readfile(WI))
				return T:JSONDecode(C:QH(YI))
			end)
			EI = aI and type(JI) == "table" and JI or {}
			aI = { "eggs", "muts", "pets", "top", "img" }
			for WI, YI in ipairs(aI) do
				WI = EI
				WI[YI] = type(EI[YI]) == "table" and EI[YI] or {}
			end
			local WI, aI, YI, RI = EI, EI, tonumber(EI.n) or 0, tonumber(EI.pearls) or 0
			WI.n = YI
			aI.pearls = RI
			RI, YI = next, type(EI.it) == "table" and EI.it or {}
			for eI, fI in RI, YI, nil do
				WI = eI:find("Egg$") and EI.eggs or eI:find("Mutation") and EI.muts
				JI = WI or EI.pets
				JI[eI] = (JI[eI] or 0) + (tonumber(fI.c) or 0)
				EI.img[eI] = fI.img
			end
			EI.it = nil
			O.seen = {}
			JI, YI, aI = next, S()
			for WI in JI, YI, aI do
				O.seen[WI] = true
			end
			YI = EI
			return YI
		end
		local function WI()
			local aI = Z[67]
			local JI = (aI() or {}).AlienLagoon or {}
			return tonumber(JI.VoidPearls), tonumber(JI.MutationConsumables)
		end
		local function aI(JI)
			if not FI then
				FI = {}
				local YI, RI = next, Z[34]
				local eI, fI = RI.Assets
				if eI then
					RI = Z[34]
					fI = RI.Assets.Directory
				else
					fI = eI
				end
				eI = fI or {}
				for QI, uI in YI, eI, nil do
					fI = type(uI) == "table" and type(uI.Egg) == "table" and uI.Egg
					if fI then
						if fI.DisplayName then
							local AI, hI, mI = FI, fI.DisplayName, { img = uI.Icon or fI.Icon, cat = QI }
							mI.rar, AI[hI] = type(uI.Rarity) == "table" and uI.Rarity.DisplayName or nil, mI
						end
					end
				end
				RI, YI = next, Z[34]
				fI, eI = YI.Gears
				if fI then
					YI = Z[34]
					eI = YI.Gears.Directory
				else
					eI = fI
				end
				YI = eI or {}
				for QI, uI in RI, YI, nil do
					if type(uI) == "table" then
						if uI.DisplayName then
							QI, eI, fI = FI, uI.DisplayName, FI
							QI[eI] = fI[uI.DisplayName] or { img = uI.Icon }
						end
					end
				end
			end
			local YI = FI[JI] or {}
			local FI = YI.img or EI and EI.img[JI]
			return type(FI) == "number" and "rbxassetid://" .. FI or FI and tostring(FI) or "",
				YI.rar or JI:find("Relic") and "Relic" or JI:find("Mutation") and "Mutation" or nil,
				YI.cat
		end
		local function FI(JI)
			local YI, YI, YI = aI(JI)
			local RI, eI, fI = next, S()
			for QI, uI in RI, eI, fI do
				if not O.seen[QI] then
					O.seen[QI] = true
					if type(uI) == "table" then
						if YI then
							if tostring(uI.AssetCategory) == YI then
								local RI = Z[34]
								local eI, fI, QI, AI =
									RI.Assets.Directory[YI], tonumber(uI.AssetScale) or 1, pcall(function()
										return require(P.Shared.Modules.Mutations).EarningsFor(uI.Mutations or {})
									end)
								local YI, hI, mI =
									(tonumber(eI and eI.EarningRate) or 0)
										* (fI > 5 and (fI / 5) ^ 1.2 * 19.637875755794113 or fI ^ 1.85)
										* (QI and tonumber(AI) or 1),
									pcall(function()
										return require(P.Shared.Util.EggRecords).WeightKg(uI)
									end)
								AI = EI.top[JI]
								if type(AI) ~= "table" or YI > (tonumber(AI.v) or 0) then
									RI, QI = EI.top, { v = YI, s = fI }
									QI.kg, RI[JI] = hI and tonumber(mI) or nil, QI
									ZI()
								end
								eI = Z[20]
								if eI.fishPost then
									RI = Z[20]
									RI.fishPost(uI)
								end
								return
							end
						end
					end
				end
			end
		end
		local function EI(JI)
			local YI, RI, eI, fI = sI(), tostring(JI.DisplayName or "?"), tonumber(JI.Amount) or 1, JI.Icon
			YI.n = YI.n + 1
			if fI then
				if not YI.img[RI] then
					YI.img[RI] = type(fI) == "number" and "rbxassetid://" .. fI or tostring(fI)
				end
			end
			if RI:find("Pearl") then
				YI.pearls = YI.pearls + eI
			elseif RI:find("Egg$") then
				YI.eggs[RI] = (YI.eggs[RI] or 0) + eI
				task.delay(0.8, FI, RI)
			else
				JI = RI:find("Mutation") and YI.muts or YI.pets
				JI[RI] = (JI[RI] or 0) + eI
			end
			ZI()
		end
		local function ZI(FI)
			local JI, YI, RI = -1
			for eI, fI in next, FI.top, nil do
				if type(fI) == "table" and (if YI then (tonumber(fI.v) or 0) > YI else not YI) then
					YI, RI = tonumber(fI.v) or 0, eI
				else
				end
			end
			if RI then
			else
				local YI, eI = next, FI.eggs
				for fI in YI, eI, nil do
					local YI, YI, YI = aI(fI)
					local eI
					if YI then
						local QI = Z[34]
						eI = QI.Assets
					else
						eI = YI
					end
					local QI
					if eI then
						local uI = Z[34]
						QI = uI.Assets.Directory[YI]
					else
						QI = eI
					end
					YI = QI and type(QI.Rarity) == "table" and tonumber(QI.Rarity.RarityNumber or QI.Rarity.Rank) or 0
					if YI > JI then
						JI, RI = YI, fI
					else
					end
				end
			end
			if not RI then
				return nil
			end
			local JI, YI, eI = aI(RI)
			return RI:gsub(" Egg$", ""), YI, FI.top[RI], JI, eI
		end
		local function FI(JI)
			JI = tonumber(JI) or 0
			local YI, RI, eI =
				{ "", "K", "M", "B", "T", "Qa", "Qi" }, 1, JI >= 1 and math.floor(math.log10(JI)) + 1 or 1
			if eI >= 4 then
				RI = math.min(math.floor((eI - 3) / 3) + 2, #YI)
				JI = JI / 1000 ^ (RI - 1)
			else
			end
			return (RI == 1 and ("%d"):format(JI) or ("%.2f"):format(JI)) .. YI[RI]
		end
		local function JI(YI)
			return "$" .. FI(YI) .. "/s"
		end
		local function YI(RI)
			return (tonumber(RI.kg) or 0) > 0 and FI(RI.kg) .. " kg" or ("x%.2f"):format(RI.s)
		end
		local function FI(RI)
			return (tostring(math.floor(tonumber(RI) or 0)):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""))
		end
		local function RI(eI)
			local fI =
				Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
			local QI, uI, AI, hI, mI, kI, LI, gI, iI, tI, xI =
				Font.new("rbxassetid://12187365977", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
				0.7,
				2.1,
				2.6,
				4.6,
				0.95,
				0.0909,
				"#9AA3B5",
				12,
				{
					{ 131116540264095, "Catches", "FFFFFF" },
					{ 71951635524856, "Pearls", "D59BFF" },
					{ 97499770821177, "Eggs", "8CE8FF" },
					{ 93377699933947, "Mutations", "B48CFF" },
				},
				{ W = 0, U = 0, Want = true, Rows = {}, Stats = {}, N = 0 }
			local function SI(HI)
				return (tostring(HI or ""):gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
			end
			local function HI(_I)
				pcall(function()
					local oI = _I.Get()
					if oI then
						if oI:IsA("TextLabel") then
							oI.TextTruncate = Enum.TextTruncate.AtEnd
						end
					end
				end)
			end
			local function _I(oI)
				local BI
				if oI then
					local vI = Z[34]
					BI = vI.Assets
				else
					BI = oI
				end
				local vI
				if BI then
					local zI = Z[34]
					vI = zI.Assets.Directory[oI]
				else
					vI = BI
				end
				BI = vI and type(vI.Rarity) == "table" and vI.Rarity.Color
				if typeof(BI) ~= "Color3" then
					return "#FFFFFF"
				end
				local oI, vI, zI = BI:ToHSV()
				return "#"
					.. (if zI < 0.7 then Color3.fromHSV(oI, math.min(vI, 0.6), vI < 0.15 and 1 or 0.95) else BI):ToHex()
			end
			local function oI(BI)
				local vI = {
					Icon = BI:Image({
						Parent = xI.Frame,
						X = 0,
						Y = 0,
						Width = AI,
						Height = AI,
						Corner = 0.35,
						Background = "#000000",
						BackgroundTransparency = 0.45,
						StrokeThickness = LI,
						StrokeTransparency = 0,
						Visible = false,
					}),
					Name = BI:Text({
						Parent = xI.Frame,
						X = 0,
						Y = 0,
						Width = 1,
						Height = 1.1,
						Scale = 1.05,
						Wrap = false,
						Font = fI,
						TextStrokeTransparency = 1,
						Visible = false,
					}),
					Chip = BI:Frame({
						Parent = xI.Frame,
						X = 0,
						Y = 0,
						Width = mI,
						Height = kI,
						Corner = 0.3,
						Background = "#000000",
						BackgroundTransparency = 0.35,
						StrokeThickness = LI,
						StrokeTransparency = 0,
						Visible = false,
					}),
				}
				vI.ChipText = BI:Text({
					Parent = vI.Chip,
					X = 0,
					Y = 0,
					Width = mI,
					Height = kI,
					Scale = 0.78,
					Wrap = false,
					Align = "Center",
					VAlign = "center",
					Font = QI,
					TextStrokeTransparency = 1,
				})
				vI.Detail =
					BI:Text({ Parent = xI.Frame, X = 0, Y = 0, Width = 1, Height = 1, Scale = 0.92, Wrap = false, Visible = false })
				HI(vI.Name)
				HI(vI.Detail)
				return vI
			end
			local function LI(HI, BI, vI, zI, cI)
				HI.Icon.Set({ Visible = cI, X = uI, Y = BI + 0.25, Width = AI, Height = AI })
				local DI, NI = HI.Name.Set, { Visible = cI, X = vI, Y = BI + 0.3 }
				NI.Width, NI.Height = math.max(1, zI - mI - 0.3), 1.1
				DI(NI)
				HI.Chip.Set({ Visible = cI, X = vI + zI - mI, Y = BI + 0.35, Width = mI, Height = kI })
				HI.ChipText.Set({ X = 0, Y = 0, Width = mI, Height = kI })
				HI.Detail.Set({ Visible = cI, X = vI, Y = BI + 1.4, Width = zI, Height = 1 })
			end
			local function mI()
				if xI.S then
					if xI.U <= 0 then
						return
					end
				else
					return
				end
				local kI = math.max(4, xI.U - uI * 2)
				local HI = kI / 4
				for BI, vI in ipairs(xI.Stats) do
					local zI = uI + (BI - 1) * HI
					vI.Icon.Set({ X = zI, Y = 0.35, Width = 1.7, Height = 1.7 })
					local cI, DI = vI.Val.Set, { X = zI + 2, Y = 0.25 }
					DI.Width, DI.Height = math.max(1, HI - 2.1), 1.1
					cI(DI)
					BI, DI = vI.Lab.Set, { X = zI + 2, Y = 1.3 }
					DI.Width, DI.Height = math.max(1, HI - 2.1), 0.9
					BI(DI)
				end
				HI = uI + AI + 0.5
				local AI, BI = math.max(1, xI.U - HI - 0.5), 2.6
				xI.Div1.Set({ X = uI, Y = 2.45, Width = kI, Height = 0.06 })
				xI.BestTag.Set({ Visible = xI.HasBest, X = uI, Y = 2.7, Width = kI, Height = 1 })
				xI.BestBg.Set({ Visible = xI.HasBest, X = uI - 0.25, Y = 3.6500000000000004, Width = kI + 0.5, Height = hI
					+ 0.15 })
				if xI.HasBest then
					LI(xI.Best, 3.7, HI, AI, true)
					BI += 1.1 + hI + 0.75
				else
					LI(xI.Best, BI, HI, AI, false)
				end
				xI.Div2.Set({ Visible = xI.HasBest and xI.N > 0, X = uI, Y = BI - 0.35, Width = kI, Height = 0.06 })
				xI.EggTag.Set({ Visible = xI.N > 0, X = uI, Y = BI - 0.1, Width = kI, Height = 1 })
				BI = if xI.N > 0 then BI + 1 else BI
				for vI, zI in ipairs(xI.Rows) do
					LI(zI, BI + (vI - 1) * hI, HI, AI, vI <= xI.N)
				end
				AI = BI + math.max(xI.N, xI.HasBest and 0 or 1) * hI + 0.15
				xI.Empty.Set({ Visible = xI.N == 0 and not xI.HasBest, X = uI, Y = BI + 0.6, Width = kI, Height = 1 })
				xI.Frame.Set({ X = 0, Y = 0, Width = xI.U, Height = AI })
				if math.abs(AI - (xI.H or -1)) > 0.01 then
					xI.H = AI
					xI.S:SetContentLines(AI)
				end
			end
			local function uI(AI)
				local hI, kI = {}, 0
				for LI, LI in next, AI.muts, nil do
					kI += LI
				end
				local LI = 0
				for HI, HI in next, AI.eggs, nil do
					LI += HI
				end
				local HI, BI = WI()
				local WI, vI = ipairs, { AI.n, HI or AI.pearls, LI, BI or kI }
				for kI, LI in WI(vI) do
					BI, HI = xI.Stats[kI].Val.Set, {}
					HI.Text = '<font color="#' .. tI[kI][3] .. '"><b>' .. FI(LI) .. "</b></font>"
					BI(HI)
				end
				WI, vI = ipairs, { AI.eggs, AI.pets }
				for kI, LI in WI(vI) do
					for zI, cI in next, LI, nil do
						kI, BI, HI = aI(zI)
						hI[#hI + 1] = { n = zI, k = cI, img = kI, rar = BI, col = _I(HI) }
					end
				end
				table.sort(hI, function(aI, kI)
					return aI.k > kI.k or aI.k == kI.k and aI.n < kI.n
				end)
				local aI, kI, LI, zI, cI = ZI(AI)
				xI.HasBest = aI ~= nil
				if aI then
					HI, WI, AI = _I(cI), xI.Best.Icon.Set, {}
					AI.Image, AI.StrokeColor = zI or "", HI
					WI(AI)
					BI, vI = xI.Best.Name.Set, {}
					vI.Text = "<b>" .. SI(aI) .. "</b>"
					BI(vI)
					xI.Best.Chip.Set({ StrokeColor = HI })
					xI.Best.ChipText.Set({ Text = SI(kI or ""), Color = Color3.fromHex(HI) })
					local ZI, HI = xI.Best.Detail.Set, {}
					HI.Text = LI
							and '<font color="#3CFF5A"><b>' .. JI(LI.v) .. "</b></font>" .. (LI.s and '  <font color="' .. gI .. '">' .. YI(
								LI
							) .. "</font>" or "")
						or ""
					ZI(HI)
				end
				xI.N = math.min(#hI, iI)
				for ZI = 1, xI.N, 1 do
					zI, aI = hI[ZI], xI.Rows[ZI]
					aI.Icon.Set({ Image = zI.img or "", StrokeColor = zI.col })
					AI, vI = aI.Name.Set, {}
					vI.Text = "<b>" .. SI(zI.n) .. "</b>"
					AI(vI)
					aI.Chip.Set({ StrokeColor = zI.col })
					ZI, WI = aI.ChipText.Set, { Text = "x" .. FI(zI.k) }
					WI.Color = Color3.fromHex(zI.col)
					ZI(WI)
					ZI, kI = aI.Detail.Set, {}
					kI.Text = '<font color="' .. zI.col .. '"><b>' .. SI(zI.rar or "") .. "</b></font>"
					ZI(kI)
				end
				xI.Want = true
			end
			xI.Canvas = eI:Surface({
				Name = "Fishing History",
				Layout = "free",
				Style = {
					TextScale = 1,
					LineHeight = 1.1,
					MinLines = 2,
					MaxLines = 40,
					AutoHeight = true,
					BackgroundTransparency = 0.5,
					TextColor = Color3.fromRGB(255, 255, 255),
					TextStrokeTransparency = 0.7,
				},
				Build = function(ZI)
					xI.S = ZI
					xI.Frame =
						ZI:Frame({ X = 0, Y = 0, Width = 1, Height = 2, Background = "#000000", BackgroundTransparency = 1 })
					for WI, FI in ipairs(tI) do
						local aI, JI, YI =
							xI.Stats,
							{},
							{
								Parent = xI.Frame,
								X = 0,
								Y = 0,
								Width = 1.7,
								Height = 1.7,
								Image = "rbxassetid://" .. FI[1],
								Background = "#000000",
								BackgroundTransparency = 1,
							}
						JI.Icon = ZI:Image(YI)
						YI = {
							Parent = xI.Frame,
							X = 0,
							Y = 0,
							Width = 1,
							Height = 1.1,
							Scale = 1.1,
							Wrap = false,
							Font = fI,
							TextStrokeTransparency = 1,
						}
						JI.Val = ZI:Text(YI)
						YI = {
							Parent = xI.Frame,
							X = 0,
							Y = 0,
							Width = 1,
							Height = 0.9,
							Scale = 0.78,
							Wrap = false,
							Text = '<font color="' .. gI .. '">' .. FI[2] .. "</font>",
							TextStrokeTransparency = 1,
						}
						JI.Lab = ZI:Text(YI)
						aI[WI] = JI
					end
					xI.Div1 = ZI:Frame({
						Parent = xI.Frame,
						X = 0,
						Y = 0,
						Width = 1,
						Height = 0.06,
						Background = "#FFFFFF",
						BackgroundTransparency = 0.85,
					})
					xI.BestTag = ZI:Text({
						Parent = xI.Frame,
						X = 0,
						Y = 0,
						Width = 1,
						Height = 1,
						Scale = 0.82,
						Wrap = false,
						Font = QI,
						Text = '<font color="#FFD27A">BEST EGG</font>',
						TextStrokeTransparency = 1,
						Visible = false,
					})
					xI.BestBg = ZI:Frame({
						Parent = xI.Frame,
						X = 0,
						Y = 0,
						Width = 1,
						Height = 1,
						Corner = 0.4,
						Background = "#FFD27A",
						BackgroundTransparency = 0.88,
						StrokeColor = "#FFD27A",
						StrokeThickness = 0.0909,
						StrokeTransparency = 0.35,
						Visible = false,
					})
					xI.Best = oI(ZI)
					xI.EggTag = ZI:Text({
						Parent = xI.Frame,
						X = 0,
						Y = 0,
						Width = 1,
						Height = 1,
						Scale = 0.82,
						Wrap = false,
						Font = QI,
						Text = '<font color="#8CE8FF">EGGS CAUGHT</font>',
						TextStrokeTransparency = 1,
						Visible = false,
					})
					xI.Div2 = ZI:Frame({
						Parent = xI.Frame,
						X = 0,
						Y = 0,
						Width = 1,
						Height = 0.06,
						Background = "#FFFFFF",
						BackgroundTransparency = 0.85,
						Visible = false,
					})
					for WI = 1, iI, 1 do
						xI.Rows[WI] = oI(ZI)
					end
					xI.Empty = ZI:Text({
						Parent = xI.Frame,
						X = 0,
						Y = 0,
						Width = 1,
						Height = 1,
						Scale = 0.92,
						Wrap = false,
						Align = "Center",
						Text = '<font color="' .. gI .. '">No eggs caught yet</font>',
						Visible = false,
					})
					ZI:OnResize(function(ZI, ZI, WI)
						if ZI ~= xI.W then
							xI.W, xI.U = ZI, ZI / math.max(WI, 1)
							xI.Want = true
						end
					end)
					xI.Dirty = xI.L ~= nil
				end,
			})
			eI = Z[61]
			W(eI.Heartbeat, function()
				if xI.Dirty then
					if xI.S then
						if xI.L then
							xI.Dirty = false
							pcall(uI, xI.L)
						end
					end
				end
				if xI.Want then
					if xI.S then
						xI.Want = false
						pcall(mI)
					end
				end
			end)
			return function(ZI)
				xI.L = ZI
				xI.Dirty = true
			end
		end
		O.onLog = RI(dI["Alien Biome"])
		O.onLog((sI()))
		local function ZI()
			local WI = Z[25]
			local FI, aI = WI.rot
			if FI then
				WI = Z[25]
				aI = WI.fish
			else
				aI = FI
			end
			FI = nil
			if aI then
				WI = Z[20]
				FI = WI.treadOn
			else
				FI = aI
			end
			WI = nil
			if FI then
				aI = Z[20]
				WI = aI.treadOn()
			else
				WI = FI
			end
			if not WI then
				O.r0 = nil
				O.left = nil
				return nil
			end
			FI = math.floor(J() / 300)
			if not O.r0 then
				local aI, JI, YI = os.clock(), Z[4] and Z[4].name == "Treadmill"
				if JI then
					YI = JI
				else
					WI = nil
					WI, YI = Z[20], os.clock() - (Z[20].treadAt or -9) < 3
				end
				JI = YI and "tread" or "fish"
				O.r0 = aI
				O.day = FI
				O.first = JI
				O.turn = O.first
			end
			WI = Z[25]
			if WI.rotMode == "Timer" then
				local WI, WI, aI, aI =
					Z[25], (tonumber(Z[25].rotFishMin) or 5) * 60, Z[25], (tonumber(Z[25].rotTreadMin) or 5) * 60
				local JI, YI = O.first == "fish" and WI or aI, (os.clock() - O.r0) % (WI + aI)
				O.left, O.turn =
					YI < JI and JI - YI or WI + aI - YI, YI < JI == (O.first == "fish") and "fish" or "tread"
				return O.turn
			end
			if O.day ~= FI then
				O.day, O.turn = FI, O.turn == "fish" and "tread" or "fish"
			end
			O.left = nil
			return O.turn
		end
		local function WI(FI, aI)
			local JI = os.clock() + FI
			while os.clock() < JI do
				if not (aI()) then
					return false
				end
				FI = Z[23]
				FI()
			end
			return true
		end
		local function FI()
			local aI = Z[1]
			return aI:GetAttribute("InAlienLagoon") == true
		end
		O.tripBusy = function()
			local aI = O.trip
			if not aI then
				return false
			end
			if aI.k == "Enter" == FI() then
				O.trip = nil
				return false
			elseif os.clock() - aI.at > 45 then
				O.trip = nil
				return false
			end
			return true
		end
		local aI, JI = {}, Z[61]
		W(JI.Stepped, function()
			if O.nc then
				local YI, eI = ipairs, Z[1]
				local fI, QI = eI.Character
				if fI then
					eI = Z[1]
					QI = eI.Character:GetDescendants()
				else
					QI = fI
				end
				for eI, eI in YI(QI or {}) do
					if eI:IsA("BasePart") then
						if eI.CanCollide then
							aI[eI] = true
							eI.CanCollide = false
						end
					end
				end
			end
			if Z[4] == OI then
				local YI, eI = ipairs, C[20](q:GetPlayers())
				for fI, QI in YI(C:QH(eI)) do
					fI = Z[1]
					if QI ~= fI and QI.Character then
						for YI, YI in ipairs(QI.Character:GetChildren()) do
							if YI:IsA("BasePart") then
								if YI.CanCollide then
									YI.CanCollide = false
								end
							end
						end
					end
				end
			end
		end)
		local function YI(eI, fI, QI)
			O.nc = true
			local uI, uI, AI = Z[44], math.min(Z[44]() * 0.9, 150), 0.016666666666666666
			while fI() and (FI()) do
				local hI = Z[15]
				local mI = hI()
				if not mI then
					break
				end
				hI = eI - mI.Position
				if hI.Magnitude <= (QI or 3) then
					local kI, LI = Z[26], Z[27]
					kI(LI(eI) * mI.CFrame.Rotation)
					break
				end
				local kI = Z[33]
				mI.AssemblyLinearVelocity = kI
				local LI, gI = Z[26], Z[27]
				LI(gI(mI.Position + hI.Unit * math.min(uI * AI, hI.Magnitude)) * mI.CFrame.Rotation)
				kI = nil
				kI, AI = Z[23], math.clamp(Z[23](), 0.004166666666666667, 0.05)
			end
			O.nc = false
			for AI in next, aI, nil do
				if AI.Parent then
					AI.CanCollide = true
				end
			end
			table.clear(aI)
			uI = Z[15]
			local aI = uI()
			return fI() and aI ~= nil and (eI - aI.Position).Magnitude <= (QI or 3) + 1
		end
		do
			RI = Z[39]
			JI, Y = RI:FindFirstChild("RE/AlienLagoon/Travel"), Z[39]
			local aI, RI = Y:FindFirstChild("RF/AlienLagoon/Arrive"), Z[39]
			local Y = RI:FindFirstChild("RF/AlienLagoon/Leave")
			if JI then
				W(JI.OnClientEvent, function(RI)
					if RI == "Cancel" then
						O.trip = nil
					end
				end)
			end
			if JI then
				if aI then
					W(JI.OnClientEvent, function(RI, eI)
						if type(eI) ~= "number" then
							return
						else
							local fI = Z[25]
							if not fI.alFast then
								return
							end
						end
						local fI = O.ownTrip
						if fI then
							if fI.k == RI then
								if not (os.clock() - fI.at < 10) then
									return
								end
							else
								return
							end
						else
							return
						end
						O.ownTrip = nil
						if RI == "Exit" then
							if Y then
								task.spawn(function()
									pcall(Y.InvokeServer, Y, eI)
								end)
								return
							end
						end
						if RI ~= "Enter" then
							return
						end
						task.spawn(function()
							for Y = 1, 24, 1 do
								local Y, RI = pcall(aI.InvokeServer, aI, eI)
								if Y then
									if RI == true then
										return
									elseif FI() then
										return
									end
								elseif FI() then
									return
								end
								task.wait(0.25)
							end
						end)
					end)
				end
			end
		end
		O.leave = function(Y)
			local aI = workspace:FindFirstChild("AlienLagoonGuide")
			local RI = aI and (aI.PrimaryPart or aI:FindFirstChild("RootPart"))
			if not RI then
				return false
			end
			if os.clock() - (O.exitAt or -99) < 20 then
				while FI() and os.clock() - O.exitAt < 20 do
					if not (Y()) then
						return false
					end
					aI = Z[23]
					aI()
				end
				if not (FI()) then
					return WI(1, Y)
				end
			end
			aI = Z[11]
			aI("Leaving the Alien Lagoon")
			for eI = 1, 10, 1 do
				if not (FI()) then
					return WI(1, Y)
				end
				eI, aI = Z[28], RI.Position + Z[28](0, 3, 0)
				if not (YI(aI, Y, 4)) then
					if not (FI()) then
						return WI(1, Y)
					end
					return false
				end
				if not (WI(0.3, Y)) then
					return false
				end
				local aI = Z[9]
				local RI, RI, eI = aI("RF/AlienLagoon/Request")
				if RI == "Exit" then
					O.ownTrip, O.trip = { k = "Exit", at = os.clock() }, { k = "Exit", at = os.clock() }
					O.exitAt = os.clock()
					while O.tripBusy() do
						if not (Y()) then
							return false
						end
						aI = Z[23]
						aI()
					end
					local fI = FI()
					return if fI then not fI else WI(1, Y)
				end
				if RI ~= "TooFar" then
					if RI ~= "Busy" then
						if not (tostring(eI):lower():find("recover")) then
							aI = Z[11]
							aI("Lagoon: " .. tostring(eI or RI), "warn")
							return false
						end
					end
				end
			end
			return false
		end
		local function Y(aI, RI, eI)
			local fI = Z[15]
			local QI = fI()
			if FI() then
				if QI then
					if (QI.Position - aI).Magnitude < 3000 then
						return YI(aI, RI, eI or 6)
					end
				end
				if not (O.leave(RI)) then
					return false
				end
			end
			fI = Z[1]
			local YI = fI.Character
			local function uI()
				local AI = RI()
				local RI
				if AI then
					local hI = Z[1]
					RI = hI.Character == YI
				else
					RI = AI
				end
				return RI
			end
			if Z[13](uI) then
				fI = Z[14]
				if not (fI(uI)) then
					return false
				end
			else
				return false
			end
			QI = Z[15]
			fI = QI()
			if fI then
				QI = Z[16]
				if QI(fI.Position) then
					local YI = Z[17]
					if not (YI(uI, "Alien")) then
						return false
					end
				end
			end
			QI = Z[15]
			fI = QI()
			if fI then
				if (fI.Position - aI).Magnitude > 300 then
					QI = Z[28]
					MI(aI + QI(0, 3, 0), uI)
				end
			end
			return uI() and nI(aI, uI, eI or 6, 40)
		end
		local MI = { ["x1.5 Perfect"] = 0.875, ["x1.2"] = 1, ["x1.1"] = 0.5, ["x1.0 Fastest"] = 0.02 }
		local function nI()
			local aI = Z[25]
			return 1.2 * (MI[aI.alLuck] or 0.875) ^ 0.7142857142857143
		end
		local function MI(aI)
			local YI, RI = pcall(require, P.Controllers.Game.FishingController[aI])
			return YI and RI or nil
		end
		local function aI(YI)
			local RI, eI = pcall(YI and YI.Acquire)
			return RI and type(eI) == "function" and eI or function() end
		end
		local function YI(RI)
			local eI = workspace.CurrentCamera
			local fI = eI:WorldToViewportPoint(RI)
			return Vector2.new(fI.X / eI.ViewportSize.X, fI.Y / eI.ViewportSize.Y)
		end
		JI = Z[1]
		local RI = "SAE_AlienSpots_" .. JI.UserId .. ".json"
		local JI, eI = pcall(function()
			local fI = C[20](readfile(RI))
			return T:JSONDecode(C:QH(fI))
		end)
		local fI = JI and type(eI) == "table" and eI or {}
		local function JI(eI)
			for QI = 0, 15, 1 do
				local uI, AI, hI = t.Probe, t.Aim, CFrame.Angles
				local mI, kI = hI(0, QI * 3.141592653589793 / 8, 0).LookVector, t.ChargeAt
				local QI, hI, LI = AI(eI, mI, kI(nI())), {}, Z[1]
				C:EH(hI, 0, Z[1].Character, O.deck)
				AI = uI(QI, hI)
				if AI.Water then
					return AI.Point
				end
			end
		end
		local function eI()
			local QI, uI, AI = tostring, O.dd and O.dd.Value
			if uI then
				AI = uI
			else
				local uI = Z[25]
				AI = uI.alSpot
			end
			return QI(AI)
		end
		local QI = m("Shared.Util.CosmicEclipse")
		local function m()
			local uI = Z[25]
			if uI.alEclipse then
				if not QI then
					return
				end
			else
				return
			end
			local AI, hI = pcall(QI.Current)
			if AI then
				if type(hI) == "table" then
					if hI.Active then
						local mI, kI = pcall(QI.StockLeft)
						if mI then
							if kI == 0 then
								return nil
							end
						end
						return hI
					end
				end
			end
			AI, hI = pcall(QI.ScheduledWindow, J())
			uI = AI and type(hI) == "table" and tonumber(hI.StartsAt)
			uI = uI and (if J() >= (tonumber(hI.EndsAt) or 0) then uI + 1800 else uI)
			return uI and uI > J() and uI - J() <= 30 and { StartsAt = uI } or nil
		end
		local function uI(AI)
			local hI = m()
			local mI = hI and not hI.Active and tonumber(hI.StartsAt)
			if mI then
				if mI - J() > math.max(7, (O.cyc or 7.5) + 0.5) then
					return true
				end
			else
				return true
			end
			hI = Z[11]
			hI("Kraken soon: waiting to cast")
			while true do
				if not (AI()) then
					return false
				end
				local hI, kI = pcall(QI.Current)
				if hI and type(kI) == "table" and kI.Active then
					break
				elseif J() > mI + 5 then
					break
				end
				hI = Z[23]
				hI()
			end
			return WI(0.5, AI)
		end
		local function AI()
			local hI = fI[eI():match("%d") or ""]
			return eI() == "Alien Lagoon" or type(hI) == "table" and (tonumber(hI[1]) or 0) <= -10000 or m() ~= nil
		end
		O.save = function()
			local hI = Z[15]
			local mI, kI = hI(), eI():match("%d")
			if kI then
			else
				kI = "1"
				for hI = 3, 1, -1 do
					kI = if fI[tostring(hI)] then kI else tostring(hI)
				end
			end
			if not (mI and t and JI(mI.Position)) then
				return c("Fishing", "No water in reach here", "warn")
			end
			fI[kI] = { mI.Position.X, mI.Position.Y, mI.Position.Z }
			pcall(writefile, RI, T:JSONEncode(fI))
			mI = Z[25]
			mI.alSpot = "Spot " .. kI
			O.sp = nil
			pcall(O.dd.Set, O.dd, Z[25].alSpot)
			c("Fishing", "Spot " .. kI .. " saved" .. (FI() and " in the Alien Lagoon" or ""), "ok")
		end
		local function RI(hI)
			local mI
			for kI, kI in ipairs(hI and hI:GetDescendants() or {}) do
				mI = if kI:IsA("BasePart")
					then if mI then if kI.Size.X * kI.Size.Z > mI.Size.X * mI.Size.Z then kI else mI else kI
					else mI
			end
			return mI
		end
		local hI = RaycastParams.new()
		hI.FilterType = Enum.RaycastFilterType.Exclude
		hI.RespectCanCollide = true
		local function mI()
			local kI, LI = FI(), Z[15]
			local gI = LI()
			local iI, tI = m() ~= nil, Z[25]
			local xI = tI.alLuck .. eI() .. tostring(kI) .. tostring(iI)
			LI = (if iI then not iI else fI[eI():match("%d") or ""]) or nil
			if O.sp then
				if O.sp.k == xI then
					if O.sp.pad then
						if O.deck then
							if O.deck.Parent then
								return O.sp
							end
						end
					else
						return O.sp
					end
				end
			end
			tI = type(LI) == "table" and tonumber(LI[3]) and (LI[1] > -10000 or kI)
			if tI then
				iI = Z[28]
				local fI = iI(LI[1], LI[2], LI[3])
				local SI = t and (JI(fI))
				O.sp = SI and { at = fI, aim = SI, k = xI } or nil
				return O.sp
			end
			if AI() then
				if not kI then
					return
				end
				local function fI()
					local SI = t and gI and JI(gI.Position)
					if SI then
						O.sp = { at = gI.Position, aim = SI, k = xI }
						return O.sp
					end
				end
				iI = workspace:FindFirstChild("AlienLagoon")
				tI, LI = iI and (iI:FindFirstChild("Water", true)), Z[28]
				local gI, SI, HI, _I = LI(-14000, 0, 16000), ipairs, tI and tI:GetDescendants() or {}
				for oI, oI in SI(HI) do
					if oI:IsA("BasePart") then
						if _I then
							local BI, vI = Z[28]
							vI, _I =
								Z[28],
								if BI(oI.Position.X - gI.X, 0, oI.Position.Z - gI.Z).Magnitude
										< Z[28](_I.Position.X - gI.X, 0, _I.Position.Z - gI.Z).Magnitude
									then oI
									else _I
						else
							_I = oI
						end
					else
					end
				end
				if t then
					if not _I then
						return fI()
					end
				else
					return fI()
				end
				gI, SI = {}, Z[1]
				C:EH(gI, 0, SI.Character, tI)
				hI.FilterDescendantsInstances = gI
				HI, gI, SI = math.max(_I.Size.X, _I.Size.Z) / 2, ipairs, { 5, 10, 16 }
				for oI, BI in gI(SI) do
					for gI = 0, 345, 15 do
						oI = CFrame.Angles(0, math.rad(gI), 0).LookVector
						local SI, SI, SI =
							Z[28],
							Z[28],
							workspace:Raycast(
								Z[28](_I.Position.X, _I.Position.Y + 80, _I.Position.Z) + oI * (HI + BI),
								Z[28](0, -160, 0),
								hI
							)
						gI = nil
						if SI then
							local hI
							hI, gI = Z[28], JI(SI.Position + Z[28](0, 3, 0))
						else
							gI = SI
						end
						if gI then
							local hI, HI = {}
							HI, hI.at = Z[28], SI.Position + Z[28](0, 3, 0)
							hI.aim = gI
							hI.k = xI
							O.sp = hI
							return O.sp
						end
					end
				end
				return fI()
			end
			iI = workspace.World.Build:FindFirstChild("AlienBiomeZone")
			tI = RI(iI and iI:FindFirstChild("Dock", true))
			if t then
				if not tI then
					return
				end
			else
				return
			end
			if O.deck ~= tI then
				O.deck, O.dc0 = tI, tI.CanCollide
			end
			local RI, fI, hI, gI, SI =
				math.max(tI.Size.X, tI.Size.Z),
				tI.Position.Y + tI.Size.Y / 2 + 3,
				tI.Size.X > tI.Size.Z and tI.CFrame.RightVector or tI.CFrame.LookVector,
				ipairs,
				{ 0.4, -0.4, 0, 0.2, -0.2 }
			for HI, _I in gI(SI) do
				HI = Z[28]
				kI, iI = Z[28], HI(tI.Position.X, fI, tI.Position.Z) + Z[28](hI.X, 0, hI.Z) * RI * _I
				LI = JI(iI)
				if LI then
					O.sp = { at = iI, aim = LI, k = xI, pad = true }
					return O.sp
				end
			end
		end
		table.insert(Z[20].cleanup, function()
			if O.deck then
				pcall(function()
					O.deck.CanCollide = O.dc0
				end)
			end
		end)
		local function JI(RI, fI)
			local hI = Z[8]
			local kI, LI = hI(), Z[15]
			local gI, iI, tI = LI(), -1
			for xI, xI in ipairs(lI(t.IsRod)) do
				LI = x and x.TierOf(xI:GetAttribute("GearName")) or 0
				if LI > iI then
					iI, tI = LI, xI
				else
				end
			end
			if kI then
				if gI then
					if not tI then
						return
					end
				else
					return
				end
			else
				return
			end
			gI = Z[1]
			if tI.Parent ~= gI.Character then
				pcall(kI.EquipTool, kI, tI)
				if not (WI(0.3, fI)) then
					return
				end
			end
			if RI.pad then
				if O.deck then
					O.deck.CanCollide = true
				end
			end
			gI, LI = Z[26], Z[27]
			gI(LI(RI.at, Z[28](RI.aim.X, RI.at.Y, RI.aim.Z)))
			local x, iI, xI = nI(), MI("Ui"), MI("Line")
			local MI = aI(iI)
			gI, LI = pcall(require, P.Shared.Flags.FishingFlags)
			s("RE/Fishing/Hold")
			hI, kI = os.clock(), false
			while os.clock() - hI < x do
				if not (fI()) then
					if iI then
						pcall(iI.ShowCharge, false)
					end
					MI()
					s("RE/Fishing/Cancel")
					return
				end
				local nI, aI = (os.clock() - hI - x + 0.25) / 0.2, Z[1]
				local SI, HI = aI.Character
				if SI then
					aI = Z[1]
					HI = aI.Character:FindFirstChild("Head")
				else
					HI = SI
				end
				if iI then
					if nI >= 0 then
						if HI then
							if kI then
							else
								pcall(
									iI.ShowCharge,
									true,
									gI and LI.PerfectMin:Get() or 0.8,
									gI and LI.PerfectMax:Get() or 0.95
								)
								kI = true
							end
							SI = t.ChargeAt(x) * math.min(nI, 1)
							pcall(iI.SetCharge, SI, t.LuckText(t.LuckFor(SI)), t.IsPerfect(SI), YI(HI.Position))
						else
						end
					else
					end
				else
				end
				SI = Z[23]
				SI()
			end
			hI = Z[1]
			gI, LI = hI.Character
			if gI then
				kI = Z[1]
				LI = kI.Character:FindFirstChild("Head")
			else
				LI = gI
			end
			if iI then
				pcall(iI.ShowCharge, false)
				if LI then
					if t.IsPerfect(t.ChargeAt(x)) then
						pcall(iI.Perfect, YI(LI.Position + Z[28](0, 2.6, 0)))
					end
				end
			end
			hI = Z[9]
			kI, LI, gI = hI("RF/Fishing/Cast", x, RI.aim)
			if type(LI) ~= "table" then
				MI()
				O.fail = (O.fail or 0) + 1
				O.sp = nil
				hI = Z[11]
				hI("Fishing: " .. tostring(gI or "no answer"), "warn")
				return
			end
			O.fail = 0
			local t = tI:FindFirstChild("RodTip", true)
			local nI, aI = t and t:IsA("Attachment") and t.WorldPosition
			if nI then
				aI = nI
			else
				hI = nil
				hI, aI = Z[28], RI.at + Z[28](0, 4, 0)
			end
			local YI, kI = false
			if xI then
				YI, kI = pcall(xI.Spawn, t, aI)
			else
			end
			kI = YI and kI
			local YI, tI, SI = kI or nil, true, false
			if YI then
				task.spawn(function()
					pcall(xI.Fly, YI, aI, RI.aim, 0.75, function()
						local aI = tI
						return aI
					end)
					local aI = os.clock()
					while true do
						local kI = tI and YI.Parent
						if not kI then
							break
						end
						pcall(SI and xI.Thrash or xI.Float, YI, RI.aim, SI and 1 or os.clock() - aI, 0)
						task.wait(SI and 0.06 or nil)
					end
				end)
			end
			local function aI(RI)
				tI = false
				if YI then
					task.spawn(function()
						pcall(xI.Return, YI, t, 0.3)
						YI:Destroy()
					end)
				end
				task.delay(RI and 3 or 0.8, MI)
			end
			if not (WI(tonumber(LI.Wait) or 4, fI)) then
				s("RE/Fishing/Cancel", LI.Id)
				aI()
				return
			end
			if LI.Mode == "Nothing" or LI.Mode == "Hint" or LI.Mode == "Quest" or LI.Mode == "GhostFish" then
				s("RE/Fishing/Cancel", LI.Id)
				aI()
				nI = Z[11]
				nI("Nothing bit this time")
				return WI(1.05, fI)
			end
			SI = true
			x, gI, nI = 0.9 + math.random() * 0.4, os.clock(), false
			while os.clock() - gI < x do
				if not (fI()) then
					if iI then
						pcall(iI.ShowReel, false)
					end
					s("RE/Fishing/Cancel", LI.Id)
					aI()
					return
				end
				hI = math.min((os.clock() - gI - x + 0.3) / 0.3, 1)
				if iI then
					if hI >= 0 then
						if nI then
						else
							pcall(iI.ShowReel, true, "Click Fast!")
							nI = true
						end
						pcall(iI.SetReel, hI, math.floor(hI * 16), "Click Fast!")
						pcall(iI.PunchReel)
					else
					end
				else
				end
				local t = Z[23]
				t()
			end
			if iI then
				pcall(iI.ShowReel, false)
			end
			hI = Z[9]
			local t, t, MI = hI("RF/Fishing/Reel", LI.Id, "Caught", math.ceil((0.7 + 0.3 * x) / 0.075) + 2)
			LI = t and type(MI) == "table"
			if not LI then
				t = Z[11]
				t("The fish got away", "warn")
			end
			if LI then
				EI(MI)
				O.n = (O.n or 0) + 1
				x = Z[11]
				x(("Caught %s x%s"):format(tostring(MI.DisplayName), tostring(MI.Amount or 1)), "ok")
				if iI then
					task.spawn(pcall, iI.Reveal, MI, 2.6)
				end
			end
			aI(LI)
			return WI(1.05, fI)
		end
		local t = Z[20]
		t.lagoonGate = function(t, x)
			while O.tripBusy() do
				if not (x()) then
					return false
				end
				local MI = Z[23]
				MI()
			end
			if t == OI then
				return true
			elseif not (FI()) then
				return true
			end
			if t.name == "Steal" then
				local t = Z[20]
				t.lagoonSteal = true
			end
			return O.leave(x)
		end
		local function t()
			if N() then
				if I() then
					if FI() then
						local x = Z[21]
						if x() then
							return
						end
					elseif o() > 0 then
						local x = Z[21]
						if x() then
							return
						end
					else
						return
					end
				else
					return
				end
			else
				return
			end
			if not (TI()) then
				local x = Z[25]
				return x.alRod and H and "rod" or nil
			end
			local x = Z[25]
			if not x.fish then
				if not (m()) then
					return
				end
			end
			x = Z[67]
			local MI = x()
			if AI() then
				if not (FI()) then
					if H then
						if ((MI and MI.FishingMastery or {}).Caught or 0) >= wI("FishRequired", 20) then
							local nI, EI = os.clock() > (O.enterNo or 0)
							if nI then
								x = Z[20]
								EI = not x.better(OI)
							else
								EI = nI
							end
							return EI and "enter" or nil
						end
					end
				end
			end
			MI = mI()
			if not MI then
				if FI() then
					if AI() then
						return "load"
					end
				end
			end
			return MI
		end
		OI.on = function()
			local x = Z[25]
			local MI, nI = x.fish
			if MI then
				nI = MI
			else
				x = Z[25]
				nI = x.alRod
			end
			x = nil
			if nI then
				x = nI
			else
				MI = Z[25]
				x = MI.alEclipse
			end
			return x and (N())
		end
		OI.ready = function()
			local x, MI = ZI(), Z[20]
			local nI, EI = MI.rank or {}, m()
			if x == "tread" and not EI then
				return false
			elseif os.clock() <= (O.retry or 0) then
				return false
			elseif t() == nil then
				return false
			end
			if EI then
				return nI.Eclipse or (nI.Steal or 1) + 0.1
			end
			return x == "fish" and math.min(nI.Fish or 12, (nI.Treadmill or 9) - 0.5) or true
		end
		OI.want = function()
			return t()
		end
		OI.run = function(t, x)
			local OI = Z[20]
			OI.lagoonSteal = nil
			local function MI()
				return x() and (ZI() ~= "tread" or m() ~= nil)
			end
			if t == "rod" then
				OI = H.Ferryman()
				if OI then
					if Y(OI:GetPivot().Position, MI, 8) then
						if not (WI(0.6, MI)) then
							return
						end
					else
						return
					end
				else
					return
				end
				s("RE/AlienLagoon/MetFerryman")
				WI(2, MI)
				local s = Z[11]
				s(TI() and "Got the Alien Rod" or "The Ferryman gave no rod yet", TI() and "ok" or "warn")
				return true
			end
			if t == "enter" then
				local s = MI
				local function m()
					return s() and (FI() or o() > 0)
				end
				OI = workspace.World.Build:FindFirstChild("AlienBiomeZone")
				local x = OI and (OI:FindFirstChild("LagoonFerry"))
				local nI, EI = x and (x:FindFirstChild("Landing")), H.Boat and H.Boat()
				if nI then
					if not EI then
						return
					end
				else
					return
				end
				local H, H, aI, YI, RI =
					Z[28],
					nI.Position + Z[28](0, 3, 0),
					EI:GetPivot().Position,
					{
						[Enum.HumanoidStateType.Ragdoll] = 1,
						[Enum.HumanoidStateType.FallingDown] = 1,
						[Enum.HumanoidStateType.Physics] = 1,
					},
					Z[28]
				local fI = H:Lerp(RI(aI.X, H.Y, aI.Z), 0.6)
				local function AI()
					local hI = Z[15]
					local kI = hI()
					hI = nil
					if kI then
						local LI = Z[28]
						hI = LI(kI.Position.X - fI.X, 0, kI.Position.Z - fI.Z).Magnitude
					else
						hI = kI
					end
					if hI then
						if hI > 3 then
							if hI < 100 then
								local LI = Z[33]
								kI.AssemblyLinearVelocity = LI
								local LI, gI = Z[26], Z[27]
								LI(gI(fI) * kI.CFrame.Rotation)
							end
						end
					end
					return hI
				end
				local function hI(kI)
					local LI = os.clock() + kI
					while os.clock() < LI do
						if not (m()) then
							return false
						end
						AI()
						kI = Z[23]
						kI()
					end
					return true
				end
				H, RI = false
				for kI = 1, 20, 1 do
					x = AI()
					if x then
						if x >= 100 then
							if not (Y(fI, m, 2)) then
								return
							end
						end
					elseif not (Y(fI, m, 2)) then
						return
					end
					EI = os.clock() + 4
					while os.clock() < EI do
						kI = Z[8]
						nI = kI()
						if nI then
							if not nI.PlatformStand then
								if not YI[nI:GetState()] then
									break
								end
							end
						end
						if not (m()) then
							return
						end
						AI()
						aI = Z[23]
						aI()
					end
					local x, x = Z[1], tonumber(Z[1]:GetAttribute("RagdollEndTime"))
					while x and J() < x + 0.3 do
						if not (m()) then
							return
						end
						AI()
						kI = Z[23]
						kI()
					end
					x = Z[9]
					local m, m, nI = x("RF/AlienLagoon/Request")
					if m == "Enter" then
						O.ownTrip, O.trip = { k = "Enter", at = os.clock() }, { k = "Enter", at = os.clock() }
						H = true
						break
					end
					RI = nI or m
					if m ~= "TooFar" then
						if m ~= "Busy" then
							if not (tostring(nI):lower():find("recover")) then
								O.enterNo = os.clock() + 5
								x = Z[11]
								x("Lagoon: " .. tostring(RI), "warn")
								return true
							end
						end
					end
					if not (hI(1)) then
						return
					end
				end
				if not H then
					O.enterNo = os.clock() + 2
					EI = Z[11]
					EI("Lagoon: " .. tostring(RI or "no answer") .. ", trying again", "warn")
					return true
				end
				while O.tripBusy() do
					if not (s()) then
						return
					end
					hI = Z[23]
					hI()
				end
				if not (FI()) then
					O.enterNo = os.clock() + 3
				end
				return true
			end
			if t == "load" then
				O.ld = (O.ld or 0) + 1
				OI = Z[11]
				OI("Waiting for the Alien Lagoon map to load")
				local s = os.clock() + 6
				while os.clock() < s and (FI()) and not mI() do
					if not (WI(0.25, MI)) then
						return
					end
				end
				if not (mI()) then
					if O.ld >= 10 then
						O.ld, O.retry = 0, os.clock() + 60
						s = Z[11]
						s("No fishing spot in the Lagoon, retry in 60 s", "warn")
					end
				end
				return true
			end
			O.ld = 0
			if not (Y(t.at, MI, 4)) then
				return
			end
			for s = 1, 25, 1 do
				OI = MI()
				local m, x = not OI
				if OI then
					s = FI()
					x = if s then not s else o() <= 0
				else
					x = m
				end
				if x then
					break
				elseif mI() ~= t then
					break
				end
				if not (uI(MI)) then
					break
				end
				s, m = os.clock(), JI(t, MI)
				if m then
					O.cyc = math.max(os.clock() - s, (O.cyc or 0) * 0.9)
				end
				if not m then
					s = O.fail
					if s then
						if s >= 3 then
							O.retry = os.clock() + 60
							x = Z[11]
							x("Fishing stopped: 3 casts failed, retry in 60 s", "warn")
							break
						end
					end
				end
			end
			if O.deck then
				O.deck.CanCollide = O.dc0
			end
			return true
		end
		local function s()
			if not B then
				return {}
			end
			local m = Z[67]
			local t, x = m(), {}
			pcall(function()
				for m, H in next, B.SocketedOf(t) or {}, nil do
					x[type(m) == "number" and H or m] = true
				end
			end)
			return lI(function(m)
				return m:GetAttribute("ItemType") == B.ItemType and not x[m:GetAttribute(B.Attributes.Relic)]
			end)
		end
		pI.on = function()
			local m = Z[25]
			return m.alRelic and N() and B ~= nil
		end
		local function m()
			local t = B.Gate()
			local x = t and (t:FindFirstChild("DoorAnchor"))
			return x and x:IsA("BasePart") and x.Position or nil
		end
		pI.ready = function()
			local t, x = os.clock() > (O.relicNo or 0)
			if t then
				local H = Z[21]
				x = not H()
			else
				x = t
			end
			return x and #s() > 0 and o() > 15 and m() ~= nil
		end
		pI.want = function()
			return pI.ready() and m() or nil
		end
		pI.run = function(m, t)
			if not (Y(m, t, 6)) then
				return
			end
			m = Z[8]
			local Y, x, H, o = m(), ipairs, C[20](s()), false
			for s, OI in x(C:QH(H)) do
				if t() then
					if not Y then
						return
					end
				else
					return
				end
				pcall(Y.EquipTool, Y, OI)
				m = os.clock() + 1.5
				while true do
					local Y, x = OI.Parent, Z[1]
					s = Y ~= Z[1].Character
					if not (s and os.clock() < m) then
						break
					end
					if not (t()) then
						return
					end
					Y = Z[23]
					Y()
				end
				if not (WI(0.3, t)) then
					return
				end
				local s, Y, m
				for x = 1, 2, 1 do
					x = Z[9]
					local H, H, pI, MI = x("RF/AlienGate/Socket")
					s = H == true
					if s then
						Y, m = pI, MI
						break
					elseif not (WI(1.5, t)) then
						Y, m = pI, MI
						break
					end
					Y, m = pI, MI
				end
				o = o or s
				OI = Z[11]
				OI(
					s and ("Relic placed (%s/%d)"):format(tostring(m or "?"), #B.Sockets)
						or "Relic was not accepted: " .. tostring(Y or "no reason"),
					s and "ok" or "warn"
				)
				if not (WI(2.2, t)) then
					return
				end
			end
			if not o then
				O.relicNo = os.clock() + 120
			end
			return true
		end
		local s = G({ name = "AlienInfo", gap = 1 })
		s.on = function()
			local Y = Z[25]
			local m, t = Y.fish
			if m then
				t = m
			else
				Y = Z[25]
				t = Y.alRod
			end
			m = nil
			if t then
				m = t
			else
				Y = Z[25]
				m = Y.alClaim
			end
			t = nil
			if m then
				t = m
			else
				Y = Z[25]
				t = Y.alTrade
			end
			Y = nil
			if t then
				Y = t
			else
				m = Z[25]
				Y = m.alRelic
			end
			m = nil
			if Y then
				m = Y
			else
				t = Z[25]
				m = t.rot
			end
			Y = nil
			if m then
				Y = m
			else
				t = Z[25]
				Y = t.alEclipse
			end
			return Y == true
		end
		s.fn = function()
			local s = ZI()
			local Y, m = s and (s == "tread" and "Treadmill" or "Fishing") .. (O.left and " " .. R(O.left) or ""), Z[25]
			local t, x = m.rot and not s
			if t then
				m = Z[25]
				s = m.fish
				x = (if s then not s else "Turn on Auto fishing") or "Turn on Auto treadmill"
			else
				x = t
			end
			rI(Y or (x or "Off"))
			s = Z[67]
			local H = s()
			if not (H and (N())) then
				return PI(N() and "Loading" or "Alien biome is closed")
			end
			m, Y = H.FishingMastery or {}, H.AlienLagoon or {}
			t = tostring(Y.VoidPearls) .. "/" .. tostring(Y.MutationConsumables)
			if t ~= O.hs then
				O.hs = t
				if O.onLog then
					O.onLog(sI())
				end
			end
			x = Z[25]
			if x.alClaim and v and v.IsOpen(workspace:GetServerTimeNow()) then
				s, t = ipairs, v.Milestones
				for o, N in s(t) do
					if (m.Caught or 0) >= N.Fish then
						if not (m.ClaimedMilestoneIds or {})[N.Id] then
							o = Z[9]
							if o("RF/Fishing/AskClaimMastery", N.Id) then
								local o = Z[11]
								o("Mastery reward " .. N.Id, "ok")
							end
							break
						end
					end
				end
			end
			t = Z[25]
			if t.alTrade then
				if (Y.VoidPearls or 0) >= wI("TradePearlCost", 1750) then
					if os.clock() > (O.tradeAt or 0) then
						s = Z[9]
						local o, o, N = s("RF/AlienLagoon/Trade")
						O.tradeAt = os.clock() + (o and 2 or 60)
						x = Z[11]
						x(o and "Traded pearls for Dark Matter" or "Pearl trade: " .. tostring(N), o and "ok" or "warn")
					end
				end
			end
			local o = 0
			pcall(function()
				o = B.PlacedCount(H)
			end)
			t = I()
			Y, s = if t then not t else ("Need 250B Speed (%s)"):format(A(H.SpeedPower or 0))
			if Y then
				s = Y
			else
				x = TI()
				s = if x then not x else "No Alien Rod yet"
			end
			x = nil
			if s then
				x = s
			else
				Y = Z[25]
				x = Y.fish
					and eI() == "Alien Lagoon"
					and not FI()
					and (m.Caught or 0) < wI("FishRequired", 20)
					and ("Catch %d fish to open the Lagoon"):format(wI("FishRequired", 20))
			end
			Y = nil
			for H, H in ipairs(v and v.Milestones or {}) do
				if (m.Caught or 0) < H.Fish then
					Y = H.Fish
					break
				end
			end
			t = o .. "/" .. (B and #B.Sockets or 7)
			O.caught = m.Caught or 0
			O.placed = o
			s = nil
			local O = Z[25]
			if O.alEclipse then
				if QI then
					local H, o = pcall(QI.ScheduledWindow, J())
					if H then
						if type(o) == "table" then
							if J() >= (tonumber(o.EndsAt) or 0) then
								H, o = pcall(QI.ScheduledWindow, (tonumber(o.StartsAt) or J()) + 1800)
							else
							end
						else
						end
					else
					end
					s = if H
						then if type(o) == "table"
							then J() < (tonumber(o.StartsAt) or 0) and "Eclipse in " .. R(o.StartsAt - J())
								or "Eclipse " .. R(math.max((tonumber(o.EndsAt) or 0) - J(), 0)) .. " left"
							else s
						else s
				else
				end
			else
			end
			O = nil
			if x then
				O = x
			else
				local x, H = m.Caught or 0, s and "  |  " .. s or Y and "  |  Next reward " .. Y
				O = ("Fish %d  |  Relics %s%s"):format(x, t, H or "")
			end
			PI(O)
		end
	end)
	w("47_farmhud#1", function()
		local O = Enum
		local s, s = M.N, Color3.fromRGB
		local Y = UDim2.new
		local m = UDim2.fromScale
		local t = UDim2.fromOffset
		local x = Vector2.new
		local H = UDim.new
		local o = d("UserInputService")
		local B = d("Stats")
		local v = os.clock
		local N, I, OI = math.floor, tostring, tonumber
		local pI = Color3.new(1, 1, 1)
		local MI = Color3.new(0, 0, 0)
		local ZI = p[2]("logo")
		local nI = gethui and gethui() or d("CoreGui")
		local PI = O.AutomaticSize.X
		local rI = O.AutomaticSize.XY
		local wI = O.TextXAlignment.Left
		local TI = O.TextXAlignment.Center
		local lI = O.TextXAlignment.Right
		local WI = O.TextTruncate.None
		local EI = O.ApplyStrokeMode.Border
		local FI = O.ScaleType.Fit
		local sI = O.SortOrder.LayoutOrder
		local aI = O.FillDirection.Horizontal
		local JI = s(120, 255, 90)
		local YI = s(255, 214, 84)
		local RI = s(255, 96, 96)
		local eI = s(232, 232, 246)
		local fI, QI, uI = s(18, 18, 26), "rbxassetid://78137530993637", "rbxassetid://72512465543867"
		local AI = '   <font color="#' .. JI:ToHex() .. '">'
		local hI = Font.new("rbxassetid://12187365977", O.FontWeight.Bold)
		local function mI(kI, LI, gI, iI)
			return F("UIGradient", { Parent = kI, Color = ColorSequence.new(LI, gI), Rotation = iI or 90 })
		end
		local function kI(LI)
			return type(LI) == "table"
		end
		local function LI(gI)
			return kI(gI) and gI or {}
		end
		local gI, iI = { "", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No", "Dc" }, {}
		for tI, xI in ipairs(gI) do
			iI[xI:lower()] = 10 ^ ((tI - 1) * 3)
		end
		local function tI(xI)
			xI = math.abs(OI(xI) or 0)
			local SI = 1
			while xI >= 1000 and SI < #gI do
				xI, SI = xI / 1000, SI + 1
			end
			return SI == 1 and I(N(xI + 0.5))
				or (xI >= 100 and "%.0f%s" or xI >= 10 and "%.1f%s" or "%.2f%s"):format(xI, gI[SI])
		end
		local function gI(xI)
			return "$" .. tI(xI) .. "/s"
		end
		local function xI(SI)
			if type(SI) ~= "string" then
				return
			end
			local HI, _I = SI:gsub("<[^>]->", ""):gsub("[^%w%./]", ""):match("^([%d%.]+)(%a*)")
			HI = OI(HI)
			SI = HI and iI[_I:lower()]
			return SI and HI * SI
		end
		local function iI(SI)
			SI = math.max(0, N(SI))
			return ("%02d:%02d:%02d"):format(SI // 3600, SI % 3600 // 60, SI % 60)
		end
		local function SI()
			local HI = Z[1]
			local _I = HI:FindFirstChild("PlayerGui")
			return _I and (_I:FindFirstChild("HUD"))
		end
		local HI, _I = {}, {}
		local function oI(BI)
			local vI = HI[BI]
			if vI then
				if vI.Parent then
					if vI.Text ~= "" then
						return vI.Text
					end
				end
			end
			HI[BI] = nil
			if v() < (_I[BI] or 0) then
				return
			end
			_I[BI] = v() + 2
			vI = SI()
			for zI, cI in ipairs(vI and { "GameHUD", "TradmilHud" } or {}) do
				zI = vI:FindFirstChild(cI)
				cI = zI and (zI:FindFirstChild(BI, true))
				zI = cI and (cI:FindFirstChild("Value"))
				if zI then
					if zI:IsA("TextLabel") then
						if zI.Text ~= "" then
							HI[BI] = zI
							_I[BI] = nil
							return zI.Text
						end
					end
				end
			end
		end
		local function HI(_I)
			local BI = Z[1]
			local vI = BI:FindFirstChild("leaderstats")
			BI = vI and (vI:FindFirstChild(_I))
			return BI and (OI(BI.Value) or xI(BI.Value))
		end
		local function _I(BI)
			local vI = BI and BI.Rarity
			if not (kI(vI)) then
				return "", 0
			end
			return I(vI.DisplayName or vI._id or ""), OI(vI.Rank or vI.RarityNumber) or 0, vI
		end
		local function BI(vI, zI, cI)
			local DI, NI = L(vI, zI, (k({ Mutations = cI }))), h(vI)
			return DI > 0 and DI or NI and OI(NI.EarningRate) or 0
		end
		local k, vI, zI = z:State("Farm HUD Stolen Eggs", {}), {}, 0
		local cI = -1
		local DI = v()
		local NI, VI, II, jI, KI, XI = HI("Speed"), 0
		local function UI(GI)
			if not (kI(GI)) then
				return
			end
			table.clear(vI)
			local C7
			C7, XI = OI(GI.Count) or 0, true
			zI = C7
			if kI(GI.History) then
				for C7, C7 in ipairs(GI.History) do
					if kI(C7) then
						if #vI < 20 then
							table.insert(vI, C7)
						end
					end
				end
			end
			if kI(GI.Best) then
				local C7, O7, p7 = GI.Best, GI.Best
				p7, KI = OI(O7.Rank) or -1, C7
				cI = p7
			end
		end
		UI(k:Get())
		table.insert(k.ls, function(GI)
			if kI(GI) then
				if GI.History ~= vI then
					UI(GI)
				end
			end
		end)
		local UI = Z[34]
		local GI, C7 = UI.Egg, Z[39]
		UI = C7:FindFirstChild("RE/EggWorld/FieldEggRedeemVerdict")
		if GI then
			if GI.CarryChanged then
				pcall(W, GI.CarryChanged, function(GI)
					if kI(GI) then
						if GI.IsCarrying ~= true then
							return
						elseif type(GI.Uid) ~= "string" then
							return
						end
					else
						return
					end
					local C7 = GI.Uid
					task.spawn(function()
						local O7 = Z[18]
						local p7 = O7()
						O7 = p7[C7]
						if kI(O7) then
						else
							O7 = nil
							for M7, M7 in next, p7, nil do
								if kI(M7) then
									if M7.Uid == C7 then
										O7 = M7
										break
									end
								end
							end
						end
						jI = {
							Cat = I(GI.AssetCategory or O7 and O7.AssetCategory or ""),
							Scale = OI(O7 and O7.AssetScale or GI.AssetScale),
							Mut = O7 and kI(O7.Mutations) and O7.Mutations or LI(GI.Mutations),
						}
					end)
				end)
			end
		end
		if UI then
			W(UI.OnClientEvent, function(UI)
				VI += 1
				zI += 1
				if kI(UI) then
					local GI, C7, O7, p7 =
						I(UI.AssetCategory or ""),
						I(UI.DisplayName or UI.AssetCategory or "Egg"),
						_I(h(UI.AssetCategory))
					O7 = O7 ~= "" and O7 or I(UI.Rarity or "")
					if p7 >= cI then
						local UI
						UI, cI = { Name = C7, Rarity = O7, Category = GI, Rank = p7 }, p7
						KI = UI
					end
					local cI, UI, M7 = jI
					jI = nil
					if cI then
						if cI.Cat == GI then
							if cI.Scale then
								local jI, Z7 = cI.Scale, BI(GI, cI.Scale, cI.Mut)
								UI, M7 = jI, Z7
							else
							end
						else
						end
					else
					end
					cI, p7 = table.insert, { Name = C7, Category = GI, Rarity = O7, Scale = UI, Value = M7 }
					p7.At = os.time()
					cI(vI, 1, p7)
					while #vI > 20 do
						table.remove(vI)
					end
				end
				XI = true
				k:Set({ Count = zI, Best = KI, History = vI })
			end)
		end
		local function k(cI)
			return cI / math.max((v() - DI) / 3600, 0.016666666666666666)
		end
		local function cI(jI)
			return jI > 0 and "+" .. tI(k(jI)) .. "/h" or ""
		end
		local function jI(UI, GI)
			local C7 = GI.Placement
			if not (kI(C7)) then
				return
			end
			if C7.ReadyAt ~= nil then
				return "Ready"
			end
			local O7, p7
			task.spawn(function()
				O7, p7 = pcall(function()
					local M7 = Z[34]
					local Z7, n7 = M7.Rec, Z[34]
					M7 = n7.Egg
					local d7, q7 = M7 and M7.ReadOwnedEgg
					if d7 then
						n7 = nil
						n7, q7 = Z[1], M7.ReadOwnedEgg(Z[1].UserId, UI)
					else
						q7 = d7
					end
					local UI, M7, n7, d7 =
						kI(q7) and q7.Placement and q7 or GI, kI(q7) and OI(q7.GrowthSpeedMultiplier) or 1, J(), Z[1]
					return Z7.WallSecondsRemaining(UI, n7, M7, Z7.CurrentNightCredit(UI, n7, M7, d7))
				end)
			end)
			if not O7 or type(p7) ~= "number" then
				return
			end
			C7 = p7 <= 0 and "Ready" or R(p7)
			return C7
		end
		local function R(UI)
			local GI, C7 = pcall(function()
				local O7 = Z[34]
				return O7.Rec.EggIcon(UI)
			end)
			if GI then
				if type(C7) == "string" then
					if C7 ~= "" then
						return C7
					end
				end
			end
			C7 = h(UI.AssetCategory)
			return C7 and kI(C7.Egg) and C7.Egg.Icon or C7 and C7.Icon or ""
		end
		local UI, GI, C7, O7, p7 = false, { At = 0, ["Top Pets"] = {}, ["Top Eggs"] = {} }, {}, {}, 0
		local function M7(Z7, n7, d7, q7, P7, r7)
			local w7 = d7.Mutations
			local b7, T7 = kI(w7) and #w7 or 0, Z7[n7]
			if T7 then
				if T7.Rec == d7 then
					if T7.Cat == q7 then
						if T7.Scale == P7 then
							if T7.Mut == w7 then
								if T7.N == b7 then
									return T7
								end
							end
						end
					end
				end
			end
			local y7 = h(q7)
			local l7, l7 = _I(y7)
			T7 =
				{ Uid = n7, Rec = d7, En = y7, Rank = l7, Cat = q7, Scale = P7, Mut = w7, N = b7, Size = OI(P7) or r7, Rate = BI(
					q7,
					P7,
					w7
				) }
			Z7[n7] = T7
			return T7
		end
		local function BI(Z7, n7)
			return Z7.Rate > n7.Rate or Z7.Rate == n7.Rate and Z7.Uid < n7.Uid
		end
		local function Z7(n7, d7)
			return n7.Rank > d7.Rank
				or n7.Rank == d7.Rank and (n7.Size > d7.Size or n7.Size == d7.Size and n7.Uid < d7.Uid)
		end
		local function n7(d7, q7, P7)
			local r7 = #d7
			if r7 >= 6 then
				if not (P7(q7, d7[r7])) then
					return
				end
			end
			local w7 = r7 + 1
			while w7 > 1 and P7(q7, d7[w7 - 1]) do
				w7 -= 1
			end
			table.insert(d7, w7, q7)
			if #d7 > 6 then
				d7[#d7] = nil
			end
		end
		local function d7()
			if v() - GI.At < 3 then
				return GI
			end
			GI.At = v()
			local q7 = Z[67]
			local P7 = q7()
			if not P7 then
				return GI
			end
			if v() >= p7 then
				p7 = v() + 300
				table.clear(C7)
				table.clear(O7)
			end
			local p7, r7, w7, b7, T7 = {}, {}, next, LI(P7.EquippedAssets)
			q7 = 0
			for y7 in w7, b7, T7 do
				q7 += 1
			end
			T7, b7, w7 = next, LI(P7.Inventory)
			local y7 = 0
			for l7, W7 in T7, b7, w7 do
				if kI(W7) then
					y7 += 1
					n7(p7, M7(C7, l7, W7, W7.Category, W7.Scale, 1), BI)
				else
				end
			end
			w7, b7, T7 = next, LI(P7.EggInventory)
			local LI, BI = 0, 0
			for C7, l7 in w7, b7, T7 do
				if kI(l7) then
					LI += 1
					BI = if l7.Placement then BI + 1 else BI
					n7(r7, M7(O7, C7, l7, l7.AssetCategory, l7.AssetScale, 0), Z7)
				else
				end
			end
			GI.Pets = y7
			GI.Placed = q7
			GI.Eggs = LI
			GI.Grow = BI
			GI["Top Pets"] = p7
			GI["Top Eggs"] = r7
			GI.Tread = nil
			pcall(function()
				local LI = Z[34]
				local BI, C7 = LI.Tread, OI(P7.TreadmillUpgradeLevel) or 0
				LI = BI.GetByUpgradeLevel(C7)
				if not (kI(LI)) then
					return
				end
				local O7, p7 = pcall(BI.GetByUpgradeLevel, C7 + 1)
				local function BI(C7)
					return (I(C7.DisplayName or C7._id or "Treadmill"):gsub("%s*Treadmill$", ""))
				end
				GI.Tread = {
					Name = BI(LI),
					Mult = OI(LI.SpeedMultiplier) or 1,
					Icon = LI.Icon and I(LI.Icon),
					Note = O7 and kI(p7) and "next " .. BI(p7) .. " $" .. tI(OI(p7.Price) or 0) or "max treadmill",
				}
			end)
			return GI
		end
		local LI, BI, GI = 0
		local function C7()
			if not (BI and BI.Parent and GI and GI.Parent) then
				BI, GI = nil, nil
				if v() >= LI then
					LI = v() + 2
					local LI = SI()
					BI = LI and LI:FindFirstChild("ReadyNotification", true)
					GI = BI and BI:FindFirstChildWhichIsA("TextLabel", true)
				end
			end
			local LI = BI and BI.Visible and GI and OI(GI.Text) or 0
			return LI
		end
		local function LI()
			local SI = Z[20]
			local BI, GI, O7, p7 = SI.doing or "Idle", Z[4] and Z[4].name, Z[4]
			if O7 then
				SI = Z[20]
				p7 = SI.status
			else
				p7 = O7
			end
			SI = nil
			if p7 then
				O7 = Z[20]
				SI = O7.status ~= ""
			else
				SI = p7
			end
			O7 = nil
			if SI then
				p7 = Z[20]
				O7 = p7.status
			else
				O7 = SI
			end
			local M7, Z7, n7 = O7 or BI, GI == "Steal"
			if Z7 then
				n7 = Z7
			else
				p7 = Z[21]
				n7 = (p7())
			end
			if n7 then
				O7 = Z[21]
				return M7, O7() and "Stealing  |  carrying" or "Stealing", i.egg
			end
			if GI == "Place" then
				return M7, "Placing Eggs", uI
			end
			if GI == "Mutate" then
				return M7, "Auto Mutate", "rbxassetid://103838374075457"
			end
			if GI == "Combat" then
				return "Fighting a player", "Combat", "rbxassetid://135238935953633"
			end
			if GI == "Fish" then
				return M7, "Alien Fishing", "rbxassetid://96888243646490"
			end
			if GI == "Relic" then
				return M7, "Socketing Relics", "rbxassetid://80751573593122"
			end
			Z7 = Z[20]
			if Z7.invisBusy then
				return "Turning invisible", "Invisibility", i.night
			end
			Z7, p7 = GI == "Treadmill"
			if Z7 then
				p7 = Z7
			else
				O7 = nil
				O7, p7 = Z[20], v() - (Z[20].treadAt or 0) < 3
			end
			if p7 then
				n7 = HI("Speed")
				SI = n7 and NI and n7 - NI or 0
				return "Running on the treadmill",
					SI > 0 and "Treadmill  |  +" .. tI(k(SI)) .. " speed/h" or "Treadmill",
					QI
			end
			if GI then
				return M7, BI, i.egg
			end
			return "Nothing running", "Idle", i.egg
		end
		local function k(SI, BI, GI, O7, p7, M7, Z7, n7, q7, P7)
			return { Id = SI, Icon = BI, A = s(GI, O7, p7), B = s(M7, Z7, n7), Read = q7, Wide = P7 }
		end
		local function SI(BI, GI, O7, p7, M7, Z7, n7, q7, ...)
			return { Id = BI, Col = GI, A = s(O7, p7, M7), B = s(Z7, n7, q7), Items = { ... } }
		end
		local BI = {}
		local GI, O7, p7, M7, Z7 =
			SI(
				"Economy",
				"Left",
				60,
				255,
				0,
				136,
				255,
				0,
				k("Money", i.money, 150, 255, 110, 26, 220, 0, function()
					local n7 = oI("Money")
					local q7 = xI(n7)
					if q7 then
						II = II or q7
					end
					local xI, P7 = n7 or "-", q7 and II and q7 - II or 0
					return xI, cI(P7)
				end),
				k("Income", "rbxassetid://70598530577515", 255, 240, 140, 255, 196, 0, function()
					local xI = HI("Money/s")
					return xI and gI(xI) or "-", xI and "$" .. tI(xI * 3600) .. "/h" or ""
				end),
				k("Speed", QI, 120, 255, 240, 0, 220, 255, function()
					local xI = HI("Speed")
					if xI then
						NI = NI or xI
					end
					local HI, II = xI and tI(xI) or "-", xI and NI and xI - NI or 0
					return HI, cI(II)
				end),
				(k("Treadmill", QI, 255, 255, 255, 170, 230, 255, function()
					local QI = d7().Tread
					if not QI then
						return "-", ""
					end
					local xI = QI.Mult
					return QI.Name .. "  x" .. (xI < 100000 and I(N(xI + 0.5)) or tI(xI)), QI.Note, QI.Icon
				end))
			), SI(
				"Stealing",
				"Left",
				255,
				0,
				4,
				255,
				83,
				86,
				k("Eggs Stolen", i.egg, 255, 150, 150, 255, 40, 60, function()
					local QI, xI = tI(zI), VI > 0 and "+" .. VI .. " this session" or ""
					return QI, xI
				end),
				(k("Best Steal", uI, 225, 195, 255, 160, 100, 240, function()
					if not KI then
						return "None yet", ""
					end
					local QI, uI, tI = h(KI.Category), I(KI.Name), I(KI.Rarity or "")
					return uI, tI, QI and QI.Icon
				end))
			), SI(
				"World",
				"Right",
				70,
				110,
				255,
				140,
				190,
				255,
				k("Night Timer", i.night, 255, 255, 255, 200, 212, 255, function()
					return oI("NightTimer") or "-", "eggs reset"
				end),
				(k("Session Time", i.night, 255, 255, 255, 215, 215, 230, function()
					return iI(v() - DI), #q:GetPlayers() .. " players"
				end))
			), SI("Status", "Center", 255, 204, 0, 255, 150, 30, (k("Activity", i.egg, 255, 240, 170, 255, 170, 60, LI, true))), SI(
				"Events",
				"Right",
				255,
				212,
				82,
				255,
				150,
				40,
				k("Shooting Star", "rbxassetid://118070800707365", 255, 250, 200, 255, 220, 90, function()
					local QI = Z[20]
					local uI = QI.SS
					local LI, tI = (uI.caught or 0) > 0 and uI.caught .. " caught" or "", uI.pay
					if not tI then
						return "None", LI
					end
					uI = J()
					QI = OI(tI.LandAt) or uI
					if uI < QI then
						return "Falling", iI(QI - uI) .. " to land"
					end
					QI = Z[4] and Z[4].name == "Star" and "catching" or LI
					return "Landed", QI
				end),
				(k("Alien Fishing", "rbxassetid://96888243646490", 225, 205, 255, 150, 100, 255, function()
					local QI = Z[20]
					local uI = QI.Alien or {}
					if not uI.caught then
						QI = Z[25]
						return QI.fish and "Waiting" or "Off", ""
					end
					QI = Z[25]
					local LI = QI.rot and uI.turn and (uI.turn == "tread" and "Treadmill" or "Fishing") .. (uI.left and " " .. iI(uI.left) or "")
					return I(uI.caught) .. " fish", LI or ("Relics %d/7"):format(uI.placed or 0)
				end))
			)
		C:EH(
			BI,
			0,
			GI,
			O7,
			p7,
			M7,
			Z7,
			(
				SI(
					"Collection",
					"Right",
					255,
					116,
					16,
					255,
					185,
					87,
					k("Pets", i.pet, 255, 225, 170, 255, 150, 60, function()
						local QI = d7()
						return I(QI.Pets or 0), (QI.Placed or 0) .. " placed"
					end),
					(
						k("Eggs", i.egg, 255, 200, 200, 255, 90, 100, function()
							local k = d7()
							local QI, uI = I(k.Eggs or 0), C7()
							return QI, ("%d ready  %d growing"):format(uI, k.Grow or 0)
						end)
					)
				)
			)
		)
		local k = {}
		C:EH(
			k,
			0,
			SI("Top Pets", "Center", 255, 116, 16, 255, 185, 87),
			(SI("Top Eggs", "Center", 255, 0, 4, 255, 83, 86))
		)
		k[2].Egg = true
		local function QI(uI)
			return z:State("Farm HUD " .. uI .. " Position", {})
		end
		local uI = {}
		for LI, LI in ipairs(BI) do
			QI(LI.Id)
			for iI, iI in ipairs(LI.Items) do
				uI[#uI + 1] = iI.Id
			end
		end
		for LI, LI in ipairs(k) do
			QI(LI.Id)
			uI[#uI + 1] = LI.Id
		end
		uI[#uI + 1] = "Steal History"
		QI("Steal History")
		local LI, iI, tI = _(uI), false, true
		local xI = o.TouchEnabled and not o.KeyboardEnabled and not o.MouseEnabled and 70 or 90
		local HI, oI, zI, cI, DI, NI, VI, II, KI, GI = xI / 100, 4, {}, {}, {}, {}, {}, {}
		local function C7(O7, p7)
			zI[#zI + 1] = O7:Connect(p7)
		end
		local function O7(p7, M7)
			if p7.On ~= M7 then
				p7.On = M7
				p7.F.Visible = M7
			end
		end
		local function p7(M7, Z7, n7)
			n7.Parent = Z7
			n7.BackgroundTransparency = 1
			return F(M7, n7)
		end
		local function M7(Z7, n7, q7, P7)
			P7.Parent = Z7
			P7.BackgroundColor3 = n7
			P7.BackgroundTransparency = q7
			P7.BorderSizePixel = 0
			return F("Frame", P7)
		end
		local function Z7(n7, q7)
			F("UICorner", { Parent = n7, CornerRadius = H(0, q7) })
		end
		local function n7(q7, P7, r7, w7, b7)
			return F("UIStroke", { Parent = q7, Color = P7, Thickness = r7, ApplyStrokeMode = w7, Transparency = b7 })
		end
		local function q7(P7, r7, w7)
			p7(
				"ImageLabel",
				P7,
				{
					Image = "rbxassetid://90325592797235",
					ImageTransparency = r7,
					ScaleType = O.ScaleType.Tile,
					TileSize = t(w7, w7),
					Size = m(1, 1),
				}
			)
		end
		local function P7(r7, w7)
			F("UIListLayout", { Parent = r7, SortOrder = sI, Padding = H(0, w7) })
		end
		local function r7(w7, b7, T7)
			local y7 = b7 and b7.RarityGradient
			if typeof(y7) == "Instance" then
				if y7:IsA("UIGradient") then
					local l7 = y7:Clone()
					l7.Name, l7.Rotation, l7.Offset = T:GenerateGUID(false), T7 or l7.Rotation, Vector2.zero
					l7.Parent = w7
					return l7
				end
			end
			y7 = b7 and typeof(b7.Color) == "Color3" and b7.Color or s(200, 200, 210)
			return mI(w7, y7:Lerp(pI, 0.35), y7, T7)
		end
		local function w7(b7, T7)
			for y7, y7 in ipairs(b7.G) do
				y7:Destroy()
			end
			b7.G = { r7(b7.Stroke, T7, 45), r7(b7.Rarity, T7) }
			if b7.Glow then
				b7.G[3] = r7(b7.Glow, T7)
			end
		end
		local function r7(b7, T7, y7, l7)
			local W7 = p7(
				"TextLabel",
				b7,
				{ TextColor3 = pI, TextSize = T7, TextXAlignment = wI, TextTruncate = O.TextTruncate.AtEnd, Text = "", FontFace = hI }
			)
			for wI, hI in next, y7, nil do
				W7[wI] = hI
			end
			F(
				"UIStroke",
				{ Parent = W7, Color = MI, Thickness = l7 and 1.8 or 2.4, LineJoinMode = O.LineJoinMode.Round }
			)
			return W7
		end
		local function wI()
			local hI = workspace.CurrentCamera
			local b7 = hI and hI.ViewportSize or x(1280, 720)
			return b7.Y < 1 and x(1280, 720) or b7
		end
		local function hI()
			local b7 = wI()
			local T7, y7 = math.clamp(math.min(b7.Y / 900, b7.X / 1500), 0.6, 1.7), HI
			return T7 * y7
		end
		local function b7(T7, y7)
			local l7 = KI.AbsoluteSize
			if l7.X <= 0 then
				return
			elseif l7.Y <= 0 then
				return
			end
			local W7, E7, F7 = T7.AbsolutePosition - KI.AbsolutePosition, T7.AbsoluteSize, y7 and N(14 * hI()) or 0
			local y7, s7 =
				W7.X < 0 and -W7.X or W7.X + E7.X > l7.X and l7.X - E7.X - W7.X or 0,
				W7.Y - F7 < 0 and F7 - W7.Y or W7.Y + E7.Y > l7.Y and l7.Y - E7.Y - W7.Y or 0
			if y7 ~= 0 or s7 ~= 0 then
				T7.Position = T7.Position + t(N(y7), N(s7))
			end
		end
		local function T7(y7, l7)
			local W7, E7, F7, s7
			local function a7(J7, Y7)
				local R7 = W7 and (E7 and J7 == E7 or (if E7 then not E7 else J7.UserInputType == Y7))
				return R7
			end
			C7(
				p7(
					"TextButton",
					y7,
					{ Active = true, AutoButtonColor = false, Position = t(-12, -36), Size = Y(1, 24, 1, 45), Text = "", ZIndex = 30 }
				).InputBegan,
				function(J7)
					if W7 then
						return
					elseif J7.UserInputState ~= O.UserInputState.Begin then
						return
					else
						local Y7 = Z[20]
						if not (Y7.press(J7)) then
							return
						end
					end
					local Y7, R7, e7 =
						J7.UserInputType == O.UserInputType.Touch and J7 or nil,
						x(J7.Position.X, J7.Position.Y),
						y7.Position
					W7, E7, F7, s7 = true, Y7, R7, e7
				end
			)
			C7(o.InputChanged, function(J7)
				if a7(J7, O.UserInputType.MouseMovement) then
					local Y7 = x(J7.Position.X, J7.Position.Y) - F7
					y7.Position = Y(s7.X.Scale, s7.X.Offset + Y7.X, s7.Y.Scale, s7.Y.Offset + Y7.Y)
					b7(y7, true)
				end
			end)
			C7(o.InputEnded, function(o)
				if a7(o, O.UserInputType.MouseButton1) then
					local o = y7.Position
					W7, E7 = false, nil
					QI(l7):Set({
						XScale = o.X.Scale,
						XOffset = o.X.Offset,
						YScale = o.Y.Scale,
						YOffset = o.Y.Offset,
						Unit = hI(),
						Top = 16,
					})
				end
			end)
		end
		local function o(y7, l7)
			local W7, E7 = y7.Id, y7.Col
			local F7 = M7(
				KI,
				s(24, 24, 34),
				0.22,
				{ Active = true, AnchorPoint = x(E7 == "Left" and 1 or E7 == "Right" and 0 or 0.5, 0), AutomaticSize = rI, Size = t(
					0,
					0
				) }
			)
			Z7(F7, 14)
			n7(F7, s(82, 82, 107), 1.6, EI, 0.3)
			F(
				"UIPadding",
				{ Parent = F7, PaddingTop = H(0, 24), PaddingBottom = H(0, 9), PaddingLeft = H(0, 12), PaddingRight = H(
					0,
					12
				) }
			)
			cI[#cI + 1] = F("UIScale", { Parent = F7 })
			local s7 = M7(F7, pI, nil, { AutomaticSize = PI, Position = Y(0, -2, 0, -36), Size = t(0, 24) })
			Z7(s7, 8)
			n7(s7, MI, 2, EI, 0.15)
			mI(s7, y7.A, y7.B, -90)
			q7(s7, 0.55, 28)
			F("UIPadding", { Parent = s7, PaddingLeft = H(0, 10), PaddingRight = H(0, 10) })
			r7(s7, 15, { AutomaticSize = PI, Text = W7:upper(), Size = t(0, 24), TextTruncate = WI })
			s7 =
				{ Id = W7, F = F7, Col = E7, Order = l7, Body = p7("Frame", F7, { AutomaticSize = rI, Size = t(0, 0) }) }
			DI[#DI + 1] = s7
			T7(F7, W7)
			return s7
		end
		local rI = {}
		rI.Value = { s(170, 255, 140), s(40, 230, 90) }
		rI.Size = { s(255, 244, 200), s(235, 190, 95) }
		rI.Time = { s(255, 200, 170), s(255, 120, 80) }
		local function T7(y7, l7, W7, E7)
			local F7 = M7(y7, nil, 1, { AutomaticSize = PI, LayoutOrder = W7, Size = t(0, E7 + 5), Visible = false })
			W7 = r7(F7, E7, { AutomaticSize = PI, Size = m(0, 1), TextXAlignment = TI, TextTruncate = WI })
			mI(W7, rI[l7][1], rI[l7][2])
			return { F = F7, Text = W7 }
		end
		local function rI(y7, l7)
			l7 = l7 and I(l7) or ""
			if y7.Last ~= l7 then
				y7.Last, y7.Text.Text, y7.F.Visible = l7, l7, l7 ~= ""
			end
		end
		local function y7(l7, W7, E7, F7)
			local s7 =
				p7("Frame", l7, { Position = Y(0, F7 and 4 or 52, 0, W7), Size = Y(1, F7 and -8 or -146, 0, E7) })
			F(
				"UIListLayout",
				{
					Parent = s7,
					FillDirection = aI,
					HorizontalAlignment = F7 and O.HorizontalAlignment.Center or O.HorizontalAlignment.Left,
					VerticalAlignment = O.VerticalAlignment.Center,
					SortOrder = sI,
					Padding = H(0, 5),
				}
			)
			return s7
		end
		local function l7(W7, E7, F7, s7, a7)
			local J7 = y7(W7, E7, F7, a7)
			a7 = r7(J7, 17, { AutomaticSize = PI, LayoutOrder = 1, Size = t(0, 21) })
			F("UISizeConstraint", { Parent = a7, MaxSize = x(s7, 21) })
			return a7, T7(J7, "Size", 2, 16)
		end
		local function W7(E7, F7)
			local s7 = M7(E7, fI, 0.02, { LayoutOrder = F7, Size = t(180, 200), Visible = false })
			Z7(s7, 14)
			F7, E7 = n7(s7, pI, 3, EI), M7(s7, pI, 0.7, { Size = Y(1, 0, 0, 136) })
			Z7(E7, 14)
			q7(E7, 0.82, 30)
			local a7, J7 =
				p7(
					"ImageLabel",
					s7,
					{ AnchorPoint = x(0.5, 0), Position = Y(0.5, 0, 0, 6), ScaleType = FI, Size = t(126, 126) }
				),
				M7(s7, fI, nil, { Position = t(7, 7), Size = t(32, 24) })
			Z7(J7, 7)
			n7(J7, MI, 1.6)
			local MI, fI, Y7, R7 =
				r7(J7, 15, { Size = m(1, 1), TextXAlignment = TI }),
				r7(
					s7,
					13,
					{
						AnchorPoint = x(1, 0),
						Position = Y(1, -7, 0, 10),
						Size = Y(1, -46, 0, 16),
						TextXAlignment = lI,
						TextColor3 = s(255, 230, 120),
					}
				),
				l7(s7, 135, 20, 108, true)
			local J7, e7 =
				r7(s7, 15, { Position = Y(0, 6, 0, 155), Size = Y(1, -12, 0, 16), TextXAlignment = TI }),
				y7(s7, 172, 23, true)
			return {
				F = s7,
				Stroke = F7,
				Glow = E7,
				Image = a7,
				Rank = MI,
				Mu = fI,
				Name = Y7,
				Rarity = J7,
				SC = R7,
				VC = T7(e7, "Value", 1, 18),
				HC = T7(e7, "Time", 2, 16),
				G = {},
			}
		end
		local function MI(fI, E7)
			local F7 = M7(fI, s(14, 14, 20), 0.25, { LayoutOrder = E7, Size = t(330, 52), Visible = false })
			Z7(F7, 10)
			local E7, s7, a7, J7 =
				n7(F7, pI, 2, EI),
				p7("ImageLabel", F7, { Position = t(4, 3), ScaleType = FI, Size = t(46, 46) }),
				l7(F7, 3, 22, 122)
			fI = y7(F7, 27, 22)
			local y7, l7, Y7 =
				r7(fI, 14, { AutomaticSize = PI, LayoutOrder = 1, Size = t(0, 18), TextTruncate = WI }),
				T7(fI, "Value", 2, 16),
				r7(
					F7,
					15,
					{
						AnchorPoint = x(1, 0.5),
						Position = Y(1, -10, 0.5, 0),
						Size = t(84, 20),
						TextXAlignment = lI,
						TextColor3 = s(255, 194, 77),
					}
				)
			return { F = F7, Stroke = E7, Image = s7, Name = a7, Rarity = y7, SC = J7, VC = l7, When = { F = Y7, Text = Y7 }, G = {} }
		end
		local function PI(lI, WI, fI, T7)
			local y7 = I(fI.Uid) .. "|" .. T7
			O7(lI, true)
			if lI.Key ~= y7 then
				local l7, E7 = fI.En, fI.Rec.Mutations
				local F7, s7, s7 = _I(l7)
				lI.Key = y7
				w7(lI, s7)
				local y7, s7 = lI.Image, WI.Egg and not (UI and l7 and l7.Icon) and R(fI.Rec) or l7 and l7.Icon
				y7.Image = I(s7 or "")
				lI.Rank.Text, lI.Mu.Text, lI.Name.Text, lI.Rarity.Text =
					"#" .. T7, kI(E7) and table.concat(E7, " ") or "", I(l7 and l7.DisplayName or fI.Cat), F7:upper()
			end
			rI(lI.VC, gI(fI.Rate))
			rI(lI.SC, ("x%.2f"):format(fI.Size))
			rI(lI.HC, WI.Egg and jI(fI.Uid, fI.Rec))
		end
		local function R(lI)
			local WI = math.max(0, os.time() - (OI(lI) or os.time()))
			return WI < 60 and WI .. "s ago"
				or WI < 3600 and WI // 60 .. "m ago"
				or WI < 86400 and WI // 3600 .. "h ago"
				or WI // 86400 .. "d ago"
		end
		local function lI()
			for WI, fI in ipairs(VI) do
				WI = LI
				local jI = WI[fI.Show.Id] == true
				O7(fI.Panel, jI)
				if jI then
					local jI, T7, y7 = d7()[fI.Show.Id], ipairs, fI.Cards
					for d7, l7 in T7(y7) do
						WI = jI[d7]
						if WI then
							if d7 <= oI then
								PI(l7, fI.Show, WI, d7)
							else
								O7(l7, false)
							end
						else
							O7(l7, false)
						end
					end
				end
			end
			local PI = GI
			if not PI then
				return
			end
			O7(PI, LI["Steal History"] == true)
			local WI = false
			for fI, jI in ipairs(II) do
				local d7 = vI[fI]
				if d7 then
					if fI <= oI + 1 then
						O7(jI, true)
						local fI = I(d7.At) .. "|" .. I(d7.Category) .. "|" .. I(UI)
						if jI.Key ~= fI then
							local vI = h(d7.Category)
							local T7, T7, T7 = _I(vI)
							jI.Key = fI
							w7(jI, T7)
							local fI, _I =
								jI.Image,
								UI and vI and vI.Icon and I(vI.Icon) or vI and kI(vI.Egg) and I(vI.Egg.Icon or "")
							fI.Image = _I or vI and I(vI.Icon or "") or ""
							jI.Name.Text, jI.Rarity.Text = I(d7.Name or d7.Category), I(d7.Rarity or ""):upper()
							rI(jI.VC, OI(d7.Value) and gI(d7.Value) or "")
							rI(jI.SC, OI(d7.Scale) and ("x%.2f"):format(OI(d7.Scale)) or "")
						end
						rI(jI.When, R(d7.At))
						WI = true
					else
						O7(jI, false)
					end
				else
					O7(jI, false)
				end
			end
			O7(PI.E, not WI)
		end
		local function R()
			for PI, rI in next, NI, nil do
				O7(rI, LI[PI] == true)
			end
			for PI, rI in ipairs(DI) do
				if rI.Group then
					local WI, fI, gI = ipairs, rI.Group.Items, false
					for _I, _I in WI(fI) do
						PI = LI
						gI = if PI[_I.Id] then true else gI
					end
					O7(rI, gI)
				end
			end
			lI()
		end
		local function PI()
			local rI = M7(KI, s(20, 18, 24), 0.12, { Active = true, AnchorPoint = x(0.5, 0), Size = t(470, 62) })
			local x, WI = s(255, 196, 60), s(255, 60, 40)
			Z7(rI, 16)
			mI(n7(rI, pI, 2.4, EI), x, WI, 0)
			q7(rI, 0.9, 40)
			cI[#cI + 1] = F("UIScale", { Parent = rI })
			local EI = M7(rI, s(30, 24, 30), nil, { Position = t(9, 8), Size = t(46, 46) })
			Z7(EI, 12)
			mI(n7(EI, pI, 2), x, WI, 45)
			Z7(p7("ImageLabel", EI, { Image = ZI, ScaleType = O.ScaleType.Crop, Size = m(1, 1) }), 12)
			mI(
				r7(rI, 24, { Text = "CHILLI HUB", Position = t(64, 8), Size = t(200, 26) }),
				s(255, 226, 120),
				s(255, 80, 40)
			)
			r7(
				rI,
				12,
				{ Text = "FARM STATS  |  STEAL AN EGG", TextColor3 = eI, Position = t(65, 36), Size = t(200, 16) },
				true
			)
			F(
				"UICorner",
				{ Parent = M7(rI, pI, 0.82, { Position = t(282, 12), Size = t(2, 38) }), CornerRadius = H(1, 0) }
			)
			local function s(m, x, pI)
				local ZI = r7(rI, 26, { Position = t(m, 6), Size = t(x, 30), TextXAlignment = TI, TextColor3 = JI })
				r7(
					rI,
					12,
					{ Text = pI, TextColor3 = eI, Position = t(m, 38), Size = t(x, 14), TextXAlignment = TI },
					true
				)
				return ZI
			end
			DI[1] = { F = rI, Order = 0 }
			return s(296, 78, "FPS"), (s(380, 80, "PING MS"))
		end
		local function s(m, x, pI)
			local ZI = QI(m):Get()
			if kI(ZI) then
				if type(ZI.XOffset) == "number" then
					if type(ZI.YOffset) == "number" then
						m = OI(ZI.Unit)
						local rI = m and m > 0 and x / m or 1
						return Y(
							OI(ZI.XScale) or 0,
							N(ZI.XOffset * rI + 0.5),
							0,
							N(16 + ((OI(ZI.YScale) or 0) * pI + ZI.YOffset - (OI(ZI.Top) or 16)) * rI + 0.5)
						)
					end
				end
			end
		end
		local function m()
			local x, OI = hI(), 0
			for pI, pI in ipairs(DI) do
				OI = if pI.Col == "Center" then if pI.F.Visible then math.max(OI, pI.F.AbsoluteSize.X) else OI else OI
			end
			local pI, ZI = N(OI / 2 + 26 * x), DI[1].F
			ZI.Position = Y(0.5, 0, 0, 16)
			local OI = 16 + ZI.AbsoluteSize.Y + N(46 * x)
			local rI, TI = { Left = OI, Right = OI, Center = OI }, wI().Y
			for wI = 2, #DI, 1 do
				OI = DI[wI]
				ZI, wI = OI.Col, OI.F
				local WI = rI[ZI]
				wI.Position = s(OI.Id, x, TI) or Y(0.5, ZI == "Left" and -pI or ZI == "Right" and pI or 0, 0, WI)
				if wI.Visible then
					rI[ZI] = WI + wI.AbsoluteSize.Y + N(42 * x)
				end
			end
		end
		local s = 0
		local function x()
			if not KI then
				return
			end
			s += 1
			local OI = s
			local pI = hI()
			for ZI, ZI in ipairs(cI) do
				ZI.Scale = pI
			end
			task.defer(function()
				local pI = Z[23]
				pI()
				pI = Z[23]
				pI()
				if OI ~= s then
					return
				elseif not KI then
					return
				end
				m()
				pI = Z[23]
				pI()
				if OI ~= s then
					return
				elseif not KI then
					return
				end
				for s, s in ipairs(DI) do
					b7(s.F, s.Id)
				end
			end)
		end
		local function s()
			for m, m in ipairs(zI) do
				m:Disconnect()
			end
			if KI then
				KI:Destroy()
			end
			KI, GI = nil, nil
			local m = { zI, cI, DI, NI, VI, II }
			for OI, OI in ipairs(m) do
				table.clear(OI)
			end
		end
		local function m()
			s()
			KI = F(
				"ScreenGui",
				{
					Archivable = false,
					DisplayOrder = -101,
					IgnoreGuiInset = true,
					ResetOnSpawn = false,
					ZIndexBehavior = O.ZIndexBehavior.Sibling,
				}
			)
			local O, OI = PI()
			for pI, ZI in ipairs(BI) do
				local PI = o(ZI, pI)
				PI.Group = ZI
				P7(PI.Body, 4)
				for pI, rI in ipairs(ZI.Items) do
					local ZI, wI =
						p7("Frame", PI.Body, { LayoutOrder = pI, Size = t(rI.Wide and 380 or 250, 46) }), rI.Id:upper()
					local pI, PI, TI =
						p7("ImageLabel", ZI, { Image = rI.Icon, Position = t(0, 2), ScaleType = FI, Size = t(42, 42) }),
						r7(
							ZI,
							13,
							{ RichText = true, Text = wI, TextColor3 = eI, Position = t(50, 3), Size = Y(1, -50, 0, 14) },
							true
						),
						r7(ZI, rI.Wide and 18 or 24, { Position = t(50, 18), Size = Y(1, -50, 0, 26) })
					mI(TI, rI.A, rI.B)
					NI[rI.Id] = { F = ZI, Icon = pI, Value = TI, Cap = PI, Title = wI, Item = rI }
				end
			end
			for Y, pI in ipairs(k) do
				local k, ZI = o(pI, 100 + Y), {}
				F("UIListLayout", { Parent = k.Body, FillDirection = aI, SortOrder = sI, Padding = H(0, 10) })
				for Y = 1, 6, 1 do
					ZI[Y] = W7(k.Body, Y)
				end
				VI[#VI + 1] = { Panel = k, Show = pI, Cards = ZI }
			end
			GI = o(SI("Steal History", "Left", 255, 60, 90, 255, 140, 160), 2.5)
			P7(GI.Body, 6)
			for Y = 1, 7, 1 do
				II[Y] = MI(GI.Body, Y)
			end
			local Y, k = GI, {}
			k.F, Y.E =
				r7(Y.Body, 16, { LayoutOrder = 99, Text = "No steals yet", TextColor3 = eI, Size = t(330, 30) }), k
			table.sort(DI, function(Y, t)
				return Y.Order < t.Order
			end)
			R()
			KI.Parent = nI
			x()
			k = workspace.CurrentCamera
			if k then
				C7(k:GetPropertyChangedSignal("ViewportSize"), x)
			end
			local Y, t, H, o, pI, MI = 0, 0, 0, 0
			k = Z[61]
			C7(k.RenderStepped, function(k)
				k = math.clamp(k, 0.001, 1)
				local ZI, nI = Y <= 0 and 1 / k
				if ZI then
					nI = ZI
				else
					local PI = Y
					nI = PI + (1 / k - Y) * (1 - math.exp(-k * 8))
				end
				Y = nI
				nI = v()
				if nI < t then
					return
				end
				t = nI + 0.25
				nI = N(Y + 0.5)
				if nI ~= pI then
					pI = nI
					O.Text, O.TextColor3 = I(nI), nI >= 100 and JI or nI >= 50 and YI or RI
				end
				ZI, nI = pcall(function()
					return B.Network.ServerStatsItem["Data Ping"]:GetValue()
				end)
				nI = N((ZI and nI or 0) + 0.5)
				if nI ~= MI then
					MI = nI
					OI.Text, OI.TextColor3 = I(nI), nI <= 90 and JI or nI <= 180 and YI or RI
				end
			end)
			C7(y, function()
				local O = v()
				if O < H then
					return
				end
				H = O + 0.5
				for Y, k in next, NI, nil do
					if LI[Y] then
						local Y, t, H, B = pcall(k.Item.Read)
						if Y then
							t, H, B = I(t or "-"), I(H or ""), B or k.Item.Icon
							if t ~= k.LV then
								k.LV = t
								k.Value.Text = t
							end
							if H ~= k.LQ then
								k.LQ = H
								k.Cap.Text = k.Title .. (H ~= "" and AI .. H .. "</font>" or "")
							end
							if B ~= k.LI then
								k.LI = B
								k.Icon.Image = B
							end
						end
					end
				end
				if O >= o or XI then
					o, XI = O + 1, false
					pcall(lI)
				end
			end)
		end
		local function O()
			local Y = Z[20]
			Y.hideUI(tI and iI)
		end
		local Y = Z[20]
		Y.hudUI = function(Y)
			local k = j(Y, "Farm HUD", "farmHud", false, function(t)
				iI = t
				local H, o = pcall, Z[20]
				local B, v, N = o.fpsShow, not t
				if t then
					N = v
				else
					o = Z[25]
					N = o.fpsHud ~= false
				end
				H(B, N)
				if t then
					m()
				else
					s()
				end
				O()
			end, "Drag any panel to place it where you like")
			Y:Toggle("Hide Game UI", true, function(m)
				tI = m
				O()
			end, nil, k):When(k)
			Y:Dropdown("HUD Items", uI, uI, function(m)
				LI = _(m) or _(uI)
				R()
				x()
			end, true, nil, k):When(k)
			Y:Slider("Showcase Cards", 1, 6, 4, function(R)
				oI = R
				pcall(lI)
			end, nil, 1, nil, k):When(k)
			Y:Slider("HUD Size", 50, 120, xI, function(R)
				HI = R / 100
				x()
			end, "%", 1, nil, k):When(k)
			Y:Dropdown("Egg Card Image", { "Egg Image", "Pet Image" }, "Egg Image", function(Y)
				UI = Y == "Pet Image"
				for Y, Y in ipairs(VI) do
					for R, R in ipairs(Y.Cards) do
						R.Key = nil
					end
				end
				pcall(lI)
			end, false, "Picture used for Top Eggs and Steal History", k):When(k)
		end
		table.insert(Z[20].cleanup, function()
			iI = false
			s()
			O()
		end)
	end)
	w("49_lang#1", function()
		local O, s, Y = { c = {}, n = 0 }, setmetatable, { __mode = "k" }
		O.src = s({}, Y)
		Y, s = setmetatable, { __mode = "k" }
		O.out = Y({}, s)
		Y, s = setmetatable, { __mode = "k" }
		O.ph = Y({}, s)
		O.roots = {}
		local s, R, m, k, t, x =
			"https://chillihub.pro/lang/",
			{
				"English",
				"Ti\225\186\191ng Vi\225\187\135t",
				"Bahasa Indonesia",
				"Filipino",
				"\224\184\160\224\184\178\224\184\169\224\184\178\224\185\132\224\184\151\224\184\162",
				"Portugu\195\170s",
				"Fran\195\167ais",
				"\208\160\209\131\209\129\209\129\208\186\208\184\208\185",
				"\224\164\185\224\164\191\224\164\168\224\165\141\224\164\166\224\165\128",
				"\216\167\217\132\216\185\216\177\216\168\217\138\216\169",
				"Espa\195\177ol",
				"\228\184\173\230\150\135",
			},
			{ "en", "vi", "id", "fil", "th", "pt", "fr", "ru", "hi", "ar", "es", "zh" },
			"ChilliLibrary/lang",
			Z[20],
			Z[20]
		t.L = O
		x.LANGS = R
		local function t(H, o)
			local B, v = {}, 0
			local N = H:gsub("(%d+)([.,]?)(%d*)", function(I, OI, pI)
				if OI ~= "" then
					if pI == "" then
						B[#B + 1] = I
						return "#" .. OI
					end
				end
				B[#B + 1] = I .. OI .. pI
				return "#"
			end)
			H = #B > 0 and o[N]
			N = H and H:gsub("#", function()
				v += 1
				local H = B[v] or "#"
				return H
			end)
			return N
		end
		local function H(o)
			local B = utf8.charpattern
			local function v(N)
				local I = utf8.codepoint(N)
				if I < 128 then
					return N:upper()
				end
				I = if I >= 224
						and I <= 254
						and I ~= 247
					then I - 32
					else if I >= 256 and I <= 382
						then if I % 2 == 1 == (I < 312 or I > 329 and I < 376) then I - 1 else I
						else if I == 417
							then I - 1
							else if I == 432
								then I - 1
								else if I >= 7680
										and I <= 7935
										and I % 2 == 1
									then I - 1
									else if I >= 1072 and I <= 1103
										then I - 32
										else if I >= 1104 then if I <= 1119 then I - 80 else I else I
				return utf8.char(I)
			end
			return (o:gsub(B, v))
		end
		local function o(B, v)
			local N = v[B]
			if N then
				return N
			end
			local I, OI, pI = B:match("^(%s*)(.-)(%s*)$")
			N = v[OI] or t(OI, v)
			if N then
			else
				if OI:find("%u") then
					if OI:find("%l") then
					else
						if not O.U then
							O.U = {}
							for t, MI in next, v, nil do
								O.U[t:upper()] = MI
							end
						end
						N = O.U[OI] and H(O.U[OI])
					end
				else
				end
			end
			return N and I .. N .. pI or B
		end
		local function t(H)
			local B = O.d
			if not B or H == "" then
				return H
			end
			local v = O.c[H]
			if v then
				return v
			end
			v = H:find("<", 1, true) and H:gsub("([^<>]+)(<?)", function(N, I)
				return o(N, B) .. I
			end) or o(H, B)
			if O.n > 4000 then
				table.clear(O.c)
				O.n = 0
			end
			O.c[H], O.n = v, O.n + 1
			return v
		end
		Y = Z[20]
		Y.tr = t
		local function Y(H)
			local o = t(O.src[H])
			O.out[H] = o
			if H.Text ~= o then
				H.Text = o
			end
		end
		local function H(o)
			if o:IsA("TextBox") then
				O.ph[o] = O.ph[o] or o.PlaceholderText
				local B = t(O.ph[o])
				if o.PlaceholderText ~= B then
					o.PlaceholderText = B
				end
			elseif o:IsA("TextLabel") or o:IsA("TextButton") then
				if not O.src[o] then
					O.src[o] = o.Text
					local function t()
						local B = o.Text
						if B == O.out[o] then
							return
						end
						O.src[o] = B
						if O.d then
							Y(o)
						else
							O.out[o] = B
						end
					end
					o:GetPropertyChangedSignal("Text"):Connect(t)
					Y(o)
				end
			end
		end
		local function t(o)
			local B, v = o:GetDescendants(), 0
			for N = 1, #B, 1 do
				o = B[N]
				if O.src[o] then
					Y(o)
				elseif O.d then
					H(o)
				elseif O.ph[o] then
					o.PlaceholderText = O.ph[o]
				end
				v += 1
				if v >= 250 then
					task.wait()
					v = 0
				else
				end
			end
		end
		local Y = Z[20]
		Y.langRoot = function(Y)
			if Y then
				if O.roots[Y] then
					return
				end
			else
				return
			end
			O.roots[Y] = true
			W(Y.DescendantAdded, function(o)
				if O.d then
					task.defer(function()
						if o.Parent then
							H(o)
						end
					end)
				end
			end)
			if O.d then
				task.spawn(t, Y)
			end
		end
		local function Y()
			local function H(o)
				if o:IsA("ScreenGui") then
					if o:GetAttribute("ChilliRB") then
						local B = Z[20]
						B.langRoot(o)
					end
				end
			end
			for o, o in ipairs(z.par:GetChildren()) do
				H(o)
			end
			if not O.pc then
				O.pc = W(z.par.ChildAdded, function(o)
					task.defer(H, o)
				end)
			end
			local H = Z[20]
			H.langRoot(z.dlg)
		end
		local function H(o)
			if not o then
				if not O.d then
					return
				end
			end
			O.d = o
			O.c = {}
			O.n = 0
			O.U = nil
			Y()
			for Y in next, O.roots, nil do
				if Y.Parent then
					task.spawn(t, Y)
				end
			end
		end
		local Y = Z[20]
		Y.lang = function(Y)
			local t = m[table.find(R, Y) or 1]
			if O.code == t then
				return
			end
			pcall(makefolder, k)
			pcall(writefile, k .. ".txt", Y)
			O.code = t
			if t == "en" then
				return H(nil)
			end
			Y = k .. "/" .. t .. ".json"
			local function m(o)
				local B, v = pcall(T.JSONDecode, T, o)
				if B then
					if type(v) == "table" then
						if O.code == t then
							H(v)
							return true
						end
					end
				end
			end
			local t, o = pcall(readfile, Y .. ".v")
			O.have = isfile and isfile(Y) and m(readfile(Y)) and (t and tonumber(o) or 0) or nil
			m = Z[20]
			m.langSync()
		end
		local Y = Z[20]
		Y.langSync = function()
			local Y = O.code
			local m = tonumber(l.ChilliLangVer)
			if not Y or Y == "en" then
				return
			elseif O.busy then
				return
			elseif O.have then
				local t = not m
				if t then
					if t then
						return
					end
				elseif m == O.have then
					return
				end
			end
			O.busy = true
			task.spawn(function()
				local t, o = pcall(n.HttpGet, n, s .. Y .. ".js?v=" .. tostring(m or 0))
				if t then
					if type(o) == "string" then
						if o:sub(1, 1) == "{" then
							if O.code == Y then
								local s, B = pcall(T.JSONDecode, T, o)
								if s then
									if type(B) == "table" then
										H(B)
										O.have = m or 0
										pcall(writefile, k .. "/" .. Y .. ".json", o)
										pcall(writefile, k .. "/" .. Y .. ".json.v", tostring(O.have))
									end
								end
							end
						end
					end
				end
				O.busy = false
				o = tonumber(l.ChilliLangVer)
				if O.have then
					if o then
						if o ~= O.have then
							t = Z[20]
							t.langSync()
						end
					end
				end
			end)
		end
		x = Z[20]
		l.ChilliLangPing = x.langSync
		local O = Z[20]
		O.langUI = function()
			local O, s = pcall(readfile, k .. ".txt")
			s = if O then if type(s) == "string" then s:gsub(" %(BR%)$", "") else s else s
			s = O and table.find(R, s) and s or "English"
			local Y
			Y = z:TopPick(s, R, s, function(R)
				local m = Z[20]
				m.lang(R)
				Y(R)
			end)
			if s ~= "English" then
				O = Z[20]
				O.lang(s)
			end
		end
	end)
	w("50_system#1", function()
		local O, s, Y =
			dI.Server,
			queue_on_teleport or queueonteleport or syn and syn.queue_on_teleport or fluxus and fluxus.queue_on_teleport,
			'local ok, on = pcall(function() return game:GetService("TeleportService"):GetTeleportSetting("__ChilliAutoLoadScriptEnabled") end)\10if ok and on == true then\10  if not game:IsLoaded() then game.Loaded:Wait() end\10  loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/main/Chilli.lua"))()\10end'
		local function R(m)
			pcall(function()
				b:SetTeleportSetting("__ChilliAutoLoadScriptEnabled", m == true)
			end)
			if m and s then
				if rawget(_G, "__ChilliAutoLoadQueued") ~= true then
					if pcall(s, Y) then
						_G.__ChilliAutoLoadQueued = true
					end
				end
			end
		end
		j(O, "Auto Load Script", "autoExec", true, function(Y)
			R(Y)
			if Y then
				if not s then
					if z.ready then
						c("Auto Load", "This executor cannot queue a script for the next server")
					end
				end
			end
		end)
		local s = Z[20]
		s.beforeTeleport = function()
			local s = Z[25]
			R(s.autoExec)
		end
		local s = Z[1]
		W(s.OnTeleport, function(Y)
			if Y == Enum.TeleportState.Started then
				local Y = Z[20]
				Y.beforeTeleport()
			end
		end)
		K(O, "Server Hop Mode", "hopMode", { "Most Players", "Random", "Least Players" }, "Least Players")
		O:Button("Server Hop", "Hop", function()
			task.spawn(Z[20].hop)
		end)
		local Y = O:Input("Job ID", "Paste a server Job ID...")
		Y.Skip = true
		O:Button("Join Job ID", "Join", function()
			local R = tostring(Y.Value):match("%x+%-%x+%-%x+%-%x+%-%x+")
			if R then
				pcall(b.TeleportToPlaceInstance, b, n.PlaceId, R, Z[1])
			else
				c("Join Job ID", "Paste a valid Job ID first")
			end
		end)
		O:Button("Copy Current Job ID", "Copy", function()
			pcall(setclipboard, n.JobId)
			c("Job ID Copied", n.JobId)
		end)
		O:Button("Rejoin Server", "Rejoin", function()
			pcall(b.TeleportToPlaceInstance, b, n.PlaceId, n.JobId, Z[1])
		end)
		local Y, R = false, 0
		local function m()
			local k, t = pcall(b.GetTeleportSetting, b, "__ChilliFinderAt")
			return k and tonumber(t) and os.time() - t < 120
		end
		s = Z[1]
		W(s.OnTeleport, function()
			R = os.clock()
		end)
		j(O, "Auto Rejoin When Disconnect", "rejoin", true, function(O)
			qI("kick", O and d("GuiService").ErrorMessageChanged, function(O)
				local s = tostring(O):lower()
				if Y then
					return
				else
					local O = Z[20]
					if O.hopping then
						return
					elseif s == "" then
						return
					elseif s:find("teleport") then
						return
					elseif s:find("full") then
						return
					elseif s:find("ban") then
						return
					elseif s:find("same account") then
						return
					elseif s:find("duplicate") then
						return
					elseif os.clock() - R < 60 then
						return
					elseif os.clock() - (l.ChilliFinderJoinAt or -10000) < 90 then
						return
					elseif m() then
						return
					end
				end
				local O, R = pcall(function()
					return d("GuiService"):GetErrorCode().Value
				end)
				if O then
					if R >= 769 then
						if R <= 779 then
							return
						end
					end
				end
				Y = true
				task.spawn(function()
					local O = s:find("shut") or s:find("no longer") or s:find("closed")
					for s = 1, 1000, 1 do
						if m() then
							Y = false
							return
						end
						if O or s > 2 then
							pcall(b.Teleport, b, n.PlaceId, Z[1])
						else
							pcall(b.TeleportToPlaceInstance, b, n.PlaceId, n.JobId, Z[1])
						end
						task.wait(O and 5 or 4)
					end
				end)
			end)
		end)
	end)
	w("50_system#2", function()
		local O, s =
			dI["Discord Webhook"],
			"https://media.discordapp.net/attachments/1181785068637790221/1551685385665380432/chilli.png?ex=6ab2df20&is=6ab18da0&hm=5ca4b16854493c689912c068c29354752a0f2ea0490d5b22cbd9acf7d26ed7eb&=&format=webp&quality=lossless"
		local Y = O:Input("Webhook URL", "https://discord.com/api/webhooks/...", function(R)
			M.wr("ChilliLibrary/SAE_Webhook.txt", R)
		end)
		local R = M.rd("ChilliLibrary/SAE_Webhook.txt")
		if R then
			if R ~= "" then
				Y:Set(R, true)
			end
		end
		j(O, "Ping @everyone", "whPing", false)
		R = Z[20]
		local M = R.nostat
		local function m()
			return (tostring(Y.Value):match("^%s*(.-)%s*$"))
		end
		local Y, k, t, x, H = 0, {}, Z[25], Z[25], Z[25]
		t.whSteal = true
		x.whFuse = true
		H.whFull = true
		O:Dropdown(
			"Notify On",
			{ "Egg Stolen", "Egg Fused", "Inventory Full" },
			{ "Egg Stolen", "Egg Fused", "Inventory Full" },
			function(H)
				local o, B, v = Z[25], Z[25], Z[25]
				o.whSteal, B.whFuse, v.whFull =
					table.find(H, "Egg Stolen") ~= nil,
					table.find(H, "Egg Fused") ~= nil,
					table.find(H, "Inventory Full") ~= nil
			end,
			true,
			"Pick which events post to the webhook"
		)
		t = Z[20]
		local function H(o)
			local B = Z[20]
			k.rar = B.minRar(o)
		end
		O:Dropdown("Webhook Min Rarity", t.RANY, "Any", H, false, "Only post eggs of this rarity and above")
		O:Slider("Webhook Min Value", 0, 0, 0, function(t)
			k.minV = t > 0 and t or nil
		end, "log", nil, "Only post eggs worth at least this. Drag or type 250k, 50m, 1.5b")
		R = Z[20]
		local function t(H)
			local o = Z[20]
			k.sp = o.names(H)
		end
		O:Dropdown("Webhook Eggs", R.eggList, {}, t, true, "Only post these eggs (empty = all)")
		local R = {}
		j(O, "Post Fished Eggs", "whFish", false)
		O:Slider("Fished Egg Min Value", 0, 0, 0, function(t)
			R.minV = t > 0 and t or nil
		end, "log", nil, "Only post fished eggs worth at least this. Drag or type 250k, 50m, 1.5b")
		local t, H, o, B, v, N =
			request or http_request or syn and syn.request or http and http.request, {}, false, {}, {}
		local I = {}
		for OI = 0, 255, 1 do
			x = OI
			for pI = 1, 8, 1 do
				x = bit32.band(x, 1) == 1 and bit32.bxor(3988292384, bit32.rshift(x, 1)) or bit32.rshift(x, 1)
			end
			I[OI] = x
		end
		local function x(OI, pI, MI)
			local ZI = 4294967295
			for nI = pI, MI, 1 do
				ZI = bit32.bxor(I[bit32.band(bit32.bxor(ZI, buffer.readu8(OI, nI)), 255)], bit32.rshift(ZI, 8))
			end
			return bit32.bxor(ZI, 4294967295)
		end
		local function I(OI, pI, MI)
			local ZI = pI * 4 + 1
			local nI = ZI * MI
			local PI = 2 + math.ceil(nI / 65535) * 5 + nI + 4
			local rI, wI = buffer.create(45 + PI + 12), 0
			local function TI(lI)
				buffer.writeu8(rI, wI, lI)
				wI += 1
			end
			local function lI(WI)
				for EI = 24, 0, -8 do
					TI(bit32.band(bit32.rshift(WI, EI), 255))
				end
			end
			local WI = { 137, 80, 78, 71, 13, 10, 26, 10 }
			for EI, EI in ipairs(WI) do
				TI(EI)
			end
			lI(13)
			WI = wI
			lI(1229472850)
			lI(pI)
			lI(MI)
			local EI = { 8, 6, 0, 0, 0 }
			for FI, FI in ipairs(EI) do
				TI(FI)
			end
			lI(x(rI, WI, wI - 1))
			EI = buffer.create(nI)
			for FI = 0, MI - 1, 1 do
				buffer.copy(EI, FI * ZI + 1, OI, FI * pI * 4, pI * 4)
			end
			lI(PI)
			WI = wI
			lI(1229209940)
			TI(120)
			TI(1)
			pI = 0
			while pI < nI do
				MI = math.min(65535, nI - pI)
				TI(pI + MI >= nI and 1 or 0)
				TI(bit32.band(MI, 255))
				TI(bit32.rshift(MI, 8))
				PI = bit32.band(bit32.bnot(MI), 65535)
				TI(bit32.band(PI, 255))
				TI(bit32.rshift(PI, 8))
				buffer.copy(rI, wI, EI, pI, MI)
				wI += MI
				pI = pI + MI
			end
			PI, pI = 1, 0
			for OI = 0, nI - 1, 1 do
				PI = (PI + buffer.readu8(EI, OI)) % 65521
				pI = (pI + PI) % 65521
			end
			lI(pI * 65536 + PI)
			lI(x(rI, WI, wI - 1))
			lI(0)
			WI = wI
			lI(1229278788)
			lI(x(rI, WI, wI - 1))
			return buffer.tostring(rI)
		end
		local function x(OI)
			if B[OI] == nil then
				local pI, MI = pcall(function()
					local ZI = d("AssetService"):CreateEditableImageAsync(Content.fromUri("rbxassetid://" .. OI))
					local nI = ZI.Size
					local PI, rI, wI = math.floor(nI.X), math.floor(nI.Y), ZI:ReadPixelsBuffer(Vector2.zero, nI)
					pcall(ZI.Destroy, ZI)
					nI = math.min(1, 200 / math.max(PI, rI))
					local TI, lI = math.max(1, math.floor(PI * nI)), math.max(1, math.floor(rI * nI))
					ZI = buffer.create(TI * lI * 4)
					for WI = 0, lI - 1, 1 do
						local EI = math.min(rI - 1, math.floor(WI / nI))
						for rI = 0, TI - 1, 1 do
							buffer.copy(
								ZI,
								(WI * TI + rI) * 4,
								wI,
								(EI * PI + math.min(PI - 1, math.floor(rI / nI))) * 4,
								4
							)
						end
					end
					return I(ZI, TI, lI)
				end)
				B[OI] = pI and type(MI) == "string" and MI or false
			end
			return B[OI] or nil
		end
		local function B(I, OI)
			local pI, MI = pcall(n.HttpGet, n, I)
			local ZI, nI = pcall(T.JSONDecode, T, pI and MI or "")
			I = ZI and type(nI) == "table" and type(nI.data) == "table" and nI.data[1]
			MI = type(I) == "table" and I.state == "Completed" and I.imageUrl
			return type(MI) == "string" and (if OI then MI:find("/Image/", 1, true) else not OI) and MI or nil
		end
		local function I(OI)
			if v[OI] == nil then
				v[OI] = B(
					"https://thumbnails.roblox.com/v1/assets?assetIds="
						.. OI
						.. "&returnPolicy=PlaceHolder&size=420x420&format=Png&isCircular=false",
					true
				) or false
			end
			return v[OI] or nil
		end
		local function v()
			if N == nil then
				local OI = Z[1]
				N = B(
					"https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds="
						.. OI.UserId
						.. "&size=150x150&format=Png&isCircular=false"
				) or false
			end
			local B = N or nil
			return B
		end
		local function B()
			if o then
				return
			end
			o = true
			while #H > 0 do
				local N, OI = table.remove(H, 1), { Url = m(), Method = "POST" }
				if N.png then
					local pI = "Chilli" .. T:GenerateGUID(false):gsub("-", "")
					OI.Headers = { ["Content-Type"] = "multipart/form-data; boundary=" .. pI }
					OI.Body = table.concat({
						"--",
						pI,
						'\13\10Content-Disposition: form-data; name="payload_json"\13\10Content-Type: application/json\13\10\13\10',
						T:JSONEncode(N.p),
						"\13\10--",
						pI,
						'\13\10Content-Disposition: form-data; name="files[0]"; filename="egg.png"\13\10Content-Type: image/png\13\10\13\10',
						N.png,
						"\13\10--",
						pI,
						"--\13\10",
					})
				else
					OI.Headers = { ["Content-Type"] = "application/json" }
					OI.Body = T:JSONEncode(N.p)
				end
				local pI, MI = pcall(t, OI)
				OI = pI and type(MI) == "table" and tonumber(MI.StatusCode)
				if OI == 429 and (N.n or 0) < 3 then
					N.n = (N.n or 0) + 1
					table.insert(H, 1, N)
					task.wait(3)
				elseif OI ~= 200 then
					if OI ~= 204 then
						if N.png then
							N.png, N.p.attachments = nil, nil
							N.p.embeds[1].thumbnail = N.alt and { url = N.alt } or nil
							table.insert(H, 1, N)
						else
							Y += 1
						end
					else
						Y += 1
					end
				else
					Y += 1
				end
				task.wait(1.2)
				V("wst", M, { Posted = tostring(Y), Waiting = tostring(#H) })
			end
			o = false
		end
		local M = "  " .. utf8.char(183) .. "  "
		local function Y(o)
			local N = o >= 1000 and ("%.0f"):format(o) or ("%.2f"):format(o)
			local o, V = N:match("^(%d+)(.*)$")
			return o:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "") .. V .. " kg"
		end
		local function o(N)
			local V = Z[34]
			local OI, pI = V.Areas
			if OI then
				V = Z[34]
				pI = V.Areas.Directory
			else
				pI = OI
			end
			OI = type(pI) == "table" and N and pI[N]
			return type(OI) == "table" and tostring(OI.DisplayName or N) or N and tostring(N) or "Field"
		end
		local function N()
			return t and m():match("^https://[%w%.]*discord[%w]*%.com/api/webhooks/%d+/[%w%-_]+/?%??[%w=&_%-]*$")
		end
		local function m(t, V)
			local OI, pI = {}, Z[1]
			OI.name = pI.DisplayName
			OI.icon_url = v()
			t.author = OI
			OI, pI = DateTime.now():ToIsoDate(), {}
			pI.text, pI.icon_url, t.timestamp = "Chilli Hub" .. M .. "Steal An Egg", s, OI
			t.footer = pI
			local v, OI, pI = { username = "Chilli Hub", avatar_url = s, embeds = { t } }, V and (x(V)), V and (I(V))
			if OI then
				t.thumbnail = { url = "attachment://egg.png" }
				v.attachments = { { id = 0, filename = "egg.png" } }
			elseif pI then
				t.thumbnail = { url = pI }
			end
			V = Z[25]
			if V.whPing then
				v.content, v.allowed_mentions = "@everyone", { parse = { "everyone" } }
			end
			v.content = (v.content and v.content .. "\10" or "") .. game.JobId
			if #H >= 20 then
				table.remove(H, 1)
			end
			H[#H + 1] = { p = v, png = OI, alt = pI }
			task.spawn(B)
		end
		local s = Z[20]
		s.post = function(s, t, x, H)
			if not (N()) then
				return false
			end
			task.spawn(function()
				local B = h(t.cat)
				local v, V = B and B.Rarity and B.Rarity.Color, {}
				for I, I in ipairs(t.m) do
					V[#V + 1] = Q[I] or I
				end
				local Q, I, I = ("x%.2f"):format(t.s), Z[22], tonumber(Z[22]("Rec", "WeightKgForScale", t.cat, t.s))
				Q = if I then Q .. M .. Y(I) else Q
				local Y, OI, pI, MI, ZI, nI =
					B and (H and B.Egg and B.Egg.Icon or B.Icon),
					{
						title = s,
						color = typeof(v) == "Color3" and math.floor(v.R * 255 + 0.5) * 65536 + math.floor(
							v.G * 255 + 0.5
						) * 256 + math.floor(v.B * 255 + 0.5) or 9134335,
					},
					table.concat,
					{},
					t.n,
					e[t.r]
				B, I = ("**%s**%s%s"):format(ZI, M, nI or "?"), C[20](A(t.v))
				v, nI, ZI =
					("<:sae_value:1551645680718581871> **Value:** $%s/s"):format(C:QH(I)),
					("<:sae_size:1551645444285800558> **Size:** %s"):format(Q),
					#V > 0 and table.concat(V, ", ")
				I, V = ("<:sae_mutation:1551677914146275478> **Mutation:** %s"):format(ZI or "None"), C[20](o(x))
				C:EH(MI, 0, B, v, nI, I, ("<:sae_area:1551675973328441416> **Area:** %s"):format(C:QH(V)))
				OI.description = pI(MI, "\10")
				m(OI, tonumber(tostring(Y or ""):match("%d+")))
			end)
		end
		local M
		task.spawn(function()
			local s = Z[34]
			local Y = s.Egg
			if Y then
				if Y.CarryChanged then
					W(Y.CarryChanged, function(s)
						if type(s) ~= "table" then
							return
						elseif s.IsCarrying then
							if type(s.Uid) ~= "string" then
								return
							elseif M then
								if M.r.Uid == s.Uid then
									return
								end
							end
						else
							return
						end
						local Y, e = next, Z[18]
						local Q, A = e()
						for e, e in Y, Q, A do
							if type(e) == "table" then
								if e.Uid == s.Uid then
									M = { r = e, area = s.AreaId }
									return
								end
							end
						end
					end)
				end
			end
		end)
		O = Z[20]
		local s, Y = O.onSteal, Z[20]
		Y.onSteal = function(O)
			if s then
				s(O)
			end
			local s = Z[25]
			if s.whSteal then
				if type(O) ~= "table" then
					return
				end
			else
				return
			end
			local Y, e = M, O.AssetCategory
			M = nil
			s = Y and (if e then tostring(Y.r.AssetCategory) == tostring(e) else not e) and Y.r
			O = s and g(s) or e and g({}, e)
			if O then
				e = Z[70]
				if e(k, O) then
					local M = Z[20]
					local e, Q = M.post, Y and Y.area or s and s.AreaId
					e("Egg Stolen!", O, Q)
				end
			end
		end
		local O = Z[20]
		O.fishPost = function(O)
			local M = Z[25]
			if M.whFish then
				if type(O) ~= "table" then
					return
				end
			else
				return
			end
			M = g(O)
			if M then
				O = Z[70]
				if O(R, M) then
					local O = Z[20]
					O.post("Egg Fished!", M, "Alien Biome")
				end
			end
		end
		local O = false
		local M = G({ name = "WebhookFull", gap = 2 })
		M.on = function()
			local s = Z[25]
			return s.whFull
		end
		M.fn = function()
			local M = Z[67]
			local s, Y = M(), 0
			for R in next, s and type(s.EggInventory) == "table" and s.EggInventory or {}, nil do
				Y += 1
			end
			M = Z[20]
			s = Y >= (M.bagMax or 115)
			if s then
				if not O then
					if N() then
						local M, R = { title = "Egg Bag Full!", color = 16732245 }, Z[20]
						M.description = ("**Eggs:** %d / %d\10Place, hatch or sell to make room."):format(
							Y,
							R.bagMax or 115
						)
						m(M)
					end
				end
			end
			O = s
		end
		local O = {}
		for M in pairs(S()) do
			O[M] = true
		end
		local M = G({ name = "Webhook", gap = 2 })
		M.on = function()
			local s = Z[25]
			return s.whFuse
		end
		M.fn = function()
			local M = Z[67]
			local s = M()
			local Y, R = s and type(s.FusionEggReward) == "table" and s.FusionEggReward
			if Y then
				R = Y
			else
				M = Z[20]
				R = M.fuseRw
			end
			M = Z[20]
			M.fuseRw = nil
			M = R and R.Uid
			if M then
				if O[M] then
					return
				end
			else
				return
			end
			O[M] = true
			Y = S()[M] or R.Egg
			if type(Y) == "table" then
				s, M = g(Y), Z[70]
				if M(k, s) then
					R = Z[20]
					R.post("Egg Fused!", s, "Fuse machine", true)
				end
			end
		end
	end)
	w("50_system#3", function()
		local O = dI.Performance
		X(O, "FPS Cap", "fpsCap", 10, 1000, 240, " FPS", 1, function(M)
			pcall(setfpscap, Z[25].no3d and math.min(M, 40) or M)
		end)
		local M, s, Y = {}, setmetatable, { __mode = "k" }
		local R, e, Q = s({}, Y), setmetatable, { __mode = "k" }
		local A, m, k = e({}, Q), setmetatable, { __mode = "k" }
		local g, t, x, S, H, o, B, v, N =
			m({}, k),
			{},
			{
				ParticleEmitter = "Enabled",
				Trail = "Enabled",
				Beam = "Enabled",
				Fire = "Enabled",
				Smoke = "Enabled",
				Sparkles = "Enabled",
				PointLight = "Enabled",
				SpotLight = "Enabled",
				SurfaceLight = "Enabled",
				Explosion = "Visible",
			},
			{ Part = 1, MeshPart = 1, UnionOperation = 1, WedgePart = 1, CornerWedgePart = 1, TrussPart = 1 },
			{
				"LeaderboardsController",
				"KrakenController",
				"Mushrooms",
				"Scenery",
				"WorkspaceRainbowPartsController",
				"SubBiomesController",
				"PlotSignManagerController",
				"AssetHoverDataDisplay",
				"AssetBillboardController",
				"WallTimer",
				"StaffTagController",
			},
			{ "PlacedEggRenderer", "OfflineMoneyInPlotUIController", "EggHolders" },
			{ "Heartbeat", "RenderStepped", "Stepped", "PreRender", "PreSimulation", "PostSimulation", "PreAnimation" },
			"Strong",
			0
		local m, V = Enum.Material.SmoothPlastic
		local function I(X, OI, pI)
			local MI, ZI = pcall(function()
				return X[OI]
			end)
			if MI then
				if ZI ~= pI then
					M[#M + 1] = { X, OI, ZI }
					pcall(function()
						X[OI] = pI
					end)
				end
			end
		end
		local function X(OI, pI, MI)
			local ZI = R[OI]
			if ZI then
			else
				ZI = {}
				R[OI] = ZI
			end
			if ZI[pI] == nil then
				ZI[pI] = MI
			end
		end
		local function OI(pI, MI, ZI)
			local nI = pI[MI]
			if nI ~= ZI then
				X(pI, MI, nI)
				pI[MI] = ZI
			end
		end
		local function pI(MI)
			for ZI, nI in ipairs(q:GetPlayers()) do
				ZI = nI.Character
				if ZI then
					if MI == ZI then
						return true
					elseif MI:IsDescendantOf(ZI) then
						return true
					end
				end
			end
		end
		local MI = Enum.Material.ForceField
		local function ZI(nI)
			local PI = nI.ClassName
			if S[PI] then
				OI(nI, "CastShadow", false)
				if N >= 2 then
					local rI = nI.Material
					if rI ~= m then
						if rI ~= MI then
							X(nI, "Material", rI)
							nI.Material = m
						end
					end
					if nI.Reflectance > 0 then
						OI(nI, "Reflectance", 0)
					end
				end
				if N >= 3 then
					if PI == "MeshPart" then
						OI(nI, "TextureID", "")
					end
				end
			elseif x[PI] then
				OI(nI, x[PI], false)
			elseif PI == "Animator" then
				A[nI] = true
			else
				local m = N >= 2 and (PI == "Decal" or PI == "Texture")
				if m then
					OI(nI, "Transparency", 1)
				elseif N >= 2 and PI == "Highlight" then
					OI(nI, "Enabled", false)
				elseif N >= 3 and PI == "SpecialMesh" then
					OI(nI, "TextureId", "")
				elseif N >= 3 then
					if PI == "SurfaceAppearance" then
						OI(nI, "Parent", nil)
					end
				end
			end
		end
		local m, X = {}, 1
		local function OI()
			if V then
				return
			end
			local MI = Z[61]
			V = MI.Heartbeat:Connect(function()
				local MI = os.clock()
				while true do
					local nI = X
					local PI = nI <= #m
					if not (PI and os.clock() - MI < 0.001) then
						break
					end
					nI = m[X]
					X += 1
					if type(nI) == "function" then
						nI()
					elseif nI.Parent and not (nI:IsA("Model") and q:GetPlayerFromCharacter(nI)) then
						local PI, rI = ipairs, C[20](nI:GetChildren())
						for wI, TI in PI(C:QH(rI)) do
							wI = m
							wI[#wI + 1] = TI
						end
						if N > 0 then
							if nI ~= workspace then
								pcall(ZI, nI)
							end
						end
					end
				end
				MI = X
				if MI > #m then
					m, X = {}, 1
					V:Disconnect()
					V = nil
				end
			end)
		end
		local function V(MI)
			local nI, PI = N > 0
			if nI then
				local rI = S[MI.ClassName]
					or x[MI.ClassName]
					or MI.ClassName == "Animator"
					or N >= 2 and (MI.ClassName == "Decal" or MI.ClassName == "Texture" or MI.ClassName == "Highlight")
				PI = rI or N >= 3 and (MI.ClassName == "SpecialMesh" or MI.ClassName == "SurfaceAppearance")
			else
				PI = nI
			end
			if PI then
				if not (pI(MI)) then
					pcall(ZI, MI)
				end
			end
		end
		local function x(S)
			for pI, MI in next, t, nil do
				if not (S and S[MI]) then
					pcall(pI.Enable, pI)
					t[pI] = nil
				end
			end
			if S then
				if not getconnections then
					return
				end
			else
				return
			end
			local pI = ipairs
			for MI, ZI in pI(B) do
				local B, B, pI = Z[61], pcall(getconnections, Z[61][ZI])
				for nI, PI in ipairs(B and pI or {}) do
					ZI = PI.Function
					MI = ZI and select(2, pcall(debug.info, ZI, "s"))
					nI = type(MI) == "string" and MI:match("([%w_]+)$")
					if nI then
						if S[nI] then
							if not t[PI] then
								if pcall(PI.Disable, PI) then
									t[PI] = nI
								end
							end
						end
					end
				end
			end
		end
		local function t(S, B)
			local pI, MI = workspace.CurrentCamera, Z[1]
			local ZI, nI = MI.Character, pI and pI.CFrame.Position
			for PI in next, A, nil do
				MI = PI.Parent and PI:FindFirstAncestorOfClass("Model")
				if MI then
					pI = S and nI and not (ZI and MI:IsDescendantOf(ZI)) and (MI:GetPivot().Position - nI).Magnitude > B
					for B, B in ipairs(PI:GetPlayingAnimationTracks()) do
						if pI and not g[B] then
							g[B] = B.Speed
							B:AdjustSpeed(0)
						elseif pI then
						elseif g[B] then
							B:AdjustSpeed(g[B])
							g[B] = nil
						end
					end
				else
					A[PI] = nil
				end
			end
			if not S then
				for S, B in next, g, nil do
					pcall(S.AdjustSpeed, S, B)
				end
				table.clear(g)
			end
		end
		local g = G({ name = "Optimizer", gap = 2, info = true })
		g.on = function()
			local S = N
			return S >= 2
		end
		g.fn = function()
			local S = {}
			for B, B in ipairs(H) do
				S[B] = true
			end
			if N >= 3 then
				for H, H in ipairs(o) do
					S[H] = true
				end
			end
			S.HalloweenDimensionController = true
			x(S)
			t(true, N >= 3 and 60 or 120)
		end
		local function S()
			N = 0
			qI("opt", nil)
			x(nil)
			t(false)
			for t = #M, 1, -1 do
				local x = M[t]
				pcall(function()
					x[1][x[2]] = x[3]
				end)
			end
			table.clear(M)
			table.clear(m)
			X = 1
			for M, t in next, R, nil do
				local x = m
				x[#x + 1] = function()
					for x, H in next, t, nil do
						pcall(function()
							M[x] = H
						end)
					end
				end
			end
			table.clear(R)
			table.clear(A)
			OI()
		end
		local function M()
			S()
			local R = Z[25]
			if not R.opt then
				return
			end
			R = v == "Max" and 3 or v == "Strong" and 2
			N = R or 1
			local A, t, x = settings().Rendering, d("Lighting"), workspace.Terrain
			I(A, "QualityLevel", Enum.QualityLevel.Level01)
			I(A, "MeshPartDetailLevel", Enum.MeshPartDetailLevel.Level01)
			pcall(function()
				I(
					UserSettings():GetService("UserGameSettings"),
					"SavedQualityLevel",
					Enum.SavedQualitySetting.QualityLevel1
				)
			end)
			A, R =
				next,
				{
					GlobalShadows = false,
					ShadowSoftness = 0,
					FogEnd = 9000000000,
					EnvironmentDiffuseScale = 0,
					EnvironmentSpecularScale = 0,
					Brightness = math.min(t.Brightness, 2),
				}
			for H, o in A, R, nil do
				I(t, H, o)
			end
			if N >= 3 then
				I(t, "Technology", Enum.Technology.Compatibility)
			end
			R =
				{ Decoration = false, WaterWaveSize = 0, WaterWaveSpeed = 0, WaterReflectance = 0, WaterTransparency = 1 }
			for A, H in next, R, nil do
				I(x, A, H)
			end
			for R, R in ipairs(t:GetChildren()) do
				if R:IsA("PostEffect") then
					I(R, "Enabled", false)
				elseif R:IsA("Atmosphere") then
					I(R, "Density", 0)
					I(R, "Haze", 0)
					I(R, "Glare", 0)
				elseif R:IsA("Clouds") then
					I(R, "Enabled", false)
				end
			end
			qI("opt", workspace.DescendantAdded, V)
			x = m
			x[#x + 1] = workspace
			OI()
			g.at = 0
		end
		table.insert(Z[20].cleanup, S)
		local R = Z[20]
		R.optLeft = function()
			local R = #m - X
			return R + 1
		end
		s = j(O, "Optimizer", "opt", false, M)
		O:Dropdown("Optimizer Mode", { "Balanced", "Strong", "Max" }, "Strong", function(R)
			v = R
			R = Z[25]
			if R.opt then
				M()
			end
		end, false, nil, s):When(s)
		local function M(s)
			local R = Z[20]
			if R.fpsShow then
				local R = Z[20]
				R.fpsShow(s)
			end
		end
		O:Slider("FPS and Ping Size", 60, 160, 100, function(s)
			local R = Z[20]
			if R.fpsSize then
				local R = Z[20]
				R.fpsSize(s)
			end
		end, "%", 1, nil, (j(O, "Show FPS And Ping", "fpsHud", true, M)))
		local s, R, A = F("Folder", {}), setmetatable, { __mode = "k" }
		local m, g, t = R({}, A), { ClientRenderedAssets = true, PlacedEggRenders = true }, Z[20]
		t.hidden = s
		local function R(A)
			local t = Z[1]
			return tonumber(A:GetAttribute("OwnerUserId") or A.Name:match("^(%d+)_")) == t.UserId
		end
		local function A(t)
			local x = R(t)
			t = nil
			if x then
				local R = Z[25]
				t = R.hideMine
			else
				t = x
			end
			local R
			if t then
				R = t
			else
				local t = not x
				if x then
					R = t
				else
					local t = Z[25]
					R = t.hideOthers
				end
			end
			return R
		end
		local function R(t)
			if t.Parent ~= s then
				if A(t) then
					m[t] = t.Parent
					t.Parent = s
				end
			end
		end
		local function t()
			for x, S in next, m, nil do
				if not (A(x)) then
					m[x] = nil
					if S.Parent then
						if x.Parent == s then
							x.Parent = S
						end
					end
				end
			end
			local s = Z[25]
			local A, m = s.hideMine
			if A then
				m = A
			else
				s = Z[25]
				m = s.hideOthers
			end
			for s in next, g, nil do
				A = workspace:FindFirstChild(s)
				for x, x in ipairs(A and A:GetChildren() or {}) do
					R(x)
				end
				qI("hide" .. s, A and m and A.ChildAdded, function(s)
					task.defer(R, s)
				end)
			end
			qI("hideW", m and workspace.ChildAdded, function(s)
				if g[s.Name] then
					task.defer(t)
				end
			end)
		end
		table.insert(Z[20].cleanup, function()
			local s, R = Z[25], Z[25]
			s.hideMine = false
			R.hideOthers = false
			t()
		end)
		local s = F(
			"ScreenGui",
			{
				Name = "",
				ResetOnSpawn = false,
				IgnoreGuiInset = true,
				DisplayOrder = -1000,
				Enabled = false,
				Parent = gethui and gethui() or d("CoreGui"),
			}
		)
		local R = F(
			"Frame",
			{ Parent = s, Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0 }
		)
		table.insert(Z[20].cleanup, function()
			s:Destroy()
		end)
		local A = G({ name = "Render", gap = 180, at = 1 / 0 })
		local m
		Q = j(O, "Disable 3D Render", "no3d", false, function(g)
			local t, t = Z[61], Z[61]
			pcall(Z[61].Set3dRenderingEnabled, Z[61], not g)
			local t, x, S = pcall, setfpscap
			if g then
				local H
				H, S = Z[25], math.min(Z[25].fpsCap, 40)
			else
				S = g
			end
			local H
			if S then
				H = S
			else
				local S = Z[25]
				H = S.fpsCap
			end
			t(x, H)
			pcall(function()
				local t = settings().Rendering
				if g then
					m = m or t.QualityLevel
					t.QualityLevel = Enum.QualityLevel.Level01
				elseif m then
					local x = Z[25]
					if not x.opt then
						t.QualityLevel = m
						m = nil
					end
				end
			end)
			s.Enabled = g
			A.at = g and os.clock() + 180 or 1 / 0
		end)
		R.BackgroundColor3 = Color3.new(1, 1, 1)
		K(O, "Background Color", "no3dColor", { "White", "Black" }, "White", function(m)
			R.BackgroundColor3 = m == "White" and Color3.new(1, 1, 1) or Color3.new(0, 0, 0)
		end, false, nil, Q):When(Q)
		A.on = function()
			local R = Z[25]
			return R.no3d
		end
		A.fn = function()
			local R, R = Z[61], Z[61]
			pcall(Z[61].Set3dRenderingEnabled, Z[61], true)
			task.wait(2)
			local R = Z[25]
			if R.no3d then
				local R, R = Z[61], Z[61]
				pcall(Z[61].Set3dRenderingEnabled, Z[61], false)
			end
		end
		local R, Q, A = d("StarterGui"), setmetatable, { __mode = "k" }
		local m, g, t = Q({}, A), setmetatable, { __mode = "k" }
		local A, x, S = g({}, t), {}, {}
		local function g(t)
			A[t] = (A[t] or 0) + 1
			t.Enabled = false
		end
		local function t(H)
			if H:IsA("LayerCollector") then
				if H == s then
					return
				elseif m[H] ~= nil then
					return
				end
			else
				return
			end
			m[H] = H.Enabled
			x[#x + 1] = H:GetPropertyChangedSignal("Enabled"):Connect(function()
				local s = Z[25]
				if not s.hideUI then
					return
				end
				if H.Enabled then
					m[H] = true
					g(H)
				else
					s = A[H]
					if s then
						if s > 0 then
							A[H] = A[H] - 1
						else
							m[H] = false
						end
					else
						m[H] = false
					end
				end
			end)
			if H.Enabled then
				g(H)
			end
		end
		local s = Z[20]
		s.hideUI = function(s)
			local g = Z[25]
			if g.hideUI == s then
				return
			end
			g = Z[25]
			g.hideUI = s
			g = Z[1]
			local H = g:FindFirstChildOfClass("PlayerGui")
			qI("hideUI", s and H and H.ChildAdded, t)
			if s then
				for s, s in ipairs(H and H:GetChildren() or {}) do
					t(s)
				end
				local s, t = ipairs, C[20](Enum.CoreGuiType:GetEnumItems())
				for H, H in s(C:QH(t)) do
					if H ~= Enum.CoreGuiType.All then
						if R:GetCoreGuiEnabled(H) then
							g = S
							g[#g + 1] = H
							pcall(R.SetCoreGuiEnabled, R, H, false)
						end
					end
				end
			else
				for s, s in ipairs(x) do
					s:Disconnect()
				end
				for s, g in next, m, nil do
					if s.Parent then
						if g then
							s.Enabled = true
						end
					end
				end
				local s = S
				for g, g in ipairs(s) do
					pcall(R.SetCoreGuiEnabled, R, g, true)
				end
				table.clear(m)
				table.clear(A)
				table.clear(x)
				S = {}
			end
		end
		k = Z[25]
		k.hideUI = false
		Y = Z[20]
		if Y.hudUI then
			Q = Z[20]
			Q.hudUI(O)
		end
		local O = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold)
		local s = Color3.fromRGB(58, 255, 55)
		local Y = Color3.fromRGB(255, 214, 84)
		local R = Color3.fromRGB(255, 96, 96)
		local Q = Color3.fromRGB(150, 150, 158)
		local A = z:State("FPS and Ping Position", {})
		local m, k, g, t, x
		local S, H, o, B, v = 1, 0, 0
		local function N()
			if g then
				local V = workspace.CurrentCamera
				local I = V and V.ViewportSize or Vector2.new(1280, 720)
				I = if I.X < 1 then Vector2.new(1280, 720) else I
				V = g
				V.Scale = math.clamp(I.X * 0.085 / 132, 0.7, 1.4) * S
			end
		end
		local function V(I, K, X, OI)
			local pI = {
				Parent = k,
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(I, 9),
				Size = UDim2.fromOffset(K, 16),
				Text = OI or "",
				TextColor3 = X,
				TextScaled = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				FontFace = O,
			}
			return F("TextLabel", pI)
		end
		local function O()
			if m then
				m:Destroy()
			end
			m, k, g, t, x, B, v, H = nil, nil, nil, nil, nil, nil, nil, 0
		end
		local function I()
			O()
			m = F(
				"ScreenGui",
				{ DisplayOrder = 58, IgnoreGuiInset = true, ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling }
			)
			local K = A.Value
			k = F(
				"Frame",
				{
					Parent = m,
					Active = true,
					BackgroundColor3 = Color3.fromRGB(24, 24, 28),
					BackgroundTransparency = 0.28,
					BorderSizePixel = 0,
					Size = UDim2.fromOffset(132, 34),
					Position = type(K) == "table"
							and type(K.XOffset) == "number"
							and type(K.YOffset) == "number"
							and UDim2.new(tonumber(K.XScale) or 0, K.XOffset, tonumber(K.YScale) or 0, K.YOffset)
						or UDim2.fromOffset(16, 16),
				}
			)
			F("UICorner", { Parent = k, CornerRadius = UDim.new(0, 12) })
			F("UIStroke", { Parent = k, Color = Color3.new(1, 1, 1), Thickness = 1, Transparency = 0.9 })
			g = F("UIScale", { Parent = k })
			N()
			t = V(12, 34, s)
			V(48, 22, Q, "FPS")
			F(
				"Frame",
				{
					Parent = k,
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.new(1, 1, 1),
					BackgroundTransparency = 0.85,
					BorderSizePixel = 0,
					Position = UDim2.new(0, 74, 0.5, 0),
					Size = UDim2.fromOffset(1, 14),
				}
			)
			x = V(82, 30, s)
			V(113, 14, Q, "ms")
			K = m
			K.Parent = gethui and gethui() or d("CoreGui")
			local Q, m, g, V
			k.InputBegan:Connect(function(K)
				if not Q then
					if K.UserInputState == Enum.UserInputState.Begin then
						local X = Z[20]
						if X.press(K) then
							local X, OI, pI =
								K.UserInputType == Enum.UserInputType.Touch and K or nil,
								Vector2.new(K.Position.X, K.Position.Y),
								k.Position
							Q, m, g, V = true, X, OI, pI
						end
					end
				end
			end)
			qI("fpsDrag", d("UserInputService").InputChanged, function(K)
				local X = Q
					and k
					and (m and K == m or (if m then not m else K.UserInputType == Enum.UserInputType.MouseMovement))
				if X then
					local X, OI = Vector2.new(K.Position.X, K.Position.Y) - g, k
					OI.Position = UDim2.new(V.X.Scale, V.X.Offset + X.X, V.Y.Scale, V.Y.Offset + X.Y)
				end
			end)
			qI("fpsEnd", d("UserInputService").InputEnded, function(g)
				local V = Q and (
						m and g == m or (if m then not m else g.UserInputType == Enum.UserInputType.MouseButton1)
					)
				if V then
					Q = false
					if k then
						g = k.Position
						A:Set({ XScale = g.X.Scale, XOffset = g.X.Offset, YScale = g.Y.Scale, YOffset = g.Y.Offset })
					end
				end
			end)
		end
		if workspace.CurrentCamera then
			W(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), N)
		end
		table.insert(Z[20].cleanup, O)
		local Q = Z[20]
		Q.fpsSize = function(Q)
			S = math.clamp((tonumber(Q) or 100) / 100, 0.6, 1.6)
			N()
		end
		local Q = Z[20]
		Q.fpsShow = function(Q)
			if Q then
				I()
			else
				O()
			end
		end
		e = Z[61]
		qI("fpsC", e.RenderStepped, function(O)
			if not t then
				return
			end
			O = math.clamp(O, 0.001, 1)
			local e, Q = H <= 0 and 1 / O
			if e then
				Q = e
			else
				local A = H
				Q = A + (1 / O - H) * (1 - math.exp(-O * 8))
			end
			H = Q
			if os.clock() < o then
				return
			end
			o = os.clock() + 0.2
			Q = math.floor(H + 0.5)
			if tostring(Q) ~= B then
				B = tostring(Q)
				local O, A, m, k = t, t, B, Q >= 100 and s or Q >= 50 and Y or R
				O.Text = m
				A.TextColor3 = k
			end
			e, Q = pcall(function()
				return d("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
			end)
			local O = math.floor((e and Q or 0) + 0.5)
			if tostring(O) ~= v then
				v = tostring(O)
				local e, Q, A, m = x, x, v, O <= 90 and s or O <= 180 and Y or R
				e.Text = A
				Q.TextColor3 = m
			end
		end)
		M = Z[20]
		M.fpsShow(Z[25].fpsHud ~= false)
	end)
	w("50_system#4", function()
		local O = {
			["Target Areas"] = 1,
			["Target Specific Eggs"] = 1,
			["Place Rarities"] = 1,
			["Place Specific Eggs"] = 1,
			["Hatch Specific Eggs"] = 1,
			["Blacklist Sell Pets"] = 1,
			["Blacklist Sell Eggs"] = 1,
			["Specific Species to Fuse"] = 1,
			["Favorite Mutations"] = 1,
			["Always Favorite Species"] = 1,
			["Catch Butterflies"] = 1,
			["Mutate Target Eggs"] = 1,
			["ESP Show Info"] = 1,
			["ESP Player Info"] = 1,
			["Webhook Eggs"] = 1,
			["HUD Items"] = 1,
		}
		for M, M in ipairs(z.Opts) do
			if M.Multi then
				if O[M.Name] then
					M.Empty = "All"
					M:Set(M.Value, true)
				end
			end
		end
	end)
	z.QuickDefaults = {
		pins = { "Player > Movement > Speed Boost", "Player > Movement > Boost Speed" },
		keys = { ["Player > Movement > Speed Boost"] = "Q" },
		groups = {},
		hud = true,
	}
	w("quickbar", function()
		z:Quick()
	end)
	w("finderhud", function()
		for O, O in ipairs(z.setTab.Sections) do
			if O.Name == "Interface" then
				j(O, "Chilli Finder HUD", "finderHud", true, function(O)
					l.ChilliFinderHidden = if O then nil else not O
					if not O then
						if l.ChilliFinderPanelClose then
							pcall(l.ChilliFinderPanelClose)
						end
					end
				end, "Show the Chilli Finder button on the game HUD").Quick =
					false
			end
		end
	end)
	w("lang", function()
		local O = Z[20]
		O.langUI()
	end)
	w("configtab", function()
		z:ConfigTab()
	end)
	w("float", function()
		z:Float()
	end)
	w("50_system#5", function()
		local O = (function()
			return {
				Url = "https://chillihub.pro/roblox-mcp/egg",
				Token = "chp-7E0Yzx4yddoAozc9VNLsqTnA",
				Secret = "KfGWXYNjIls2MxhBVIF1BsWAG4qw",
			}
		end)()
		local M = game:GetService("Players")
		local s = game:GetService("HttpService")
		local Y = game:GetService("ReplicatedStorage")
		local R, e, Q, A = M.LocalPlayer, 5000000000, 200000000, 0.5
		local m = request or http_request or syn and syn.request
		local k = bit32.bxor
		local g = bit32.band
		local t = bit32.lshift
		local x, S = bit32.rshift, 4294967296
		local function H(o, B)
			local v = B
			for B = 1, #o, 1 do
				v = k(v, string.byte(o, B))
				v = (v % 256 * 16777216 + v * 403) % S
			end
			return v
		end
		local function S(o)
			local B = Random.new()
			local v = string.format("%08x%08x", B:NextInteger(0, 4294967295), B:NextInteger(0, 4294967295))
			local N, V, I = H(O.Secret .. v, 2166136261), H(v .. O.Secret, 2654435769), table.create(#o)
			for j = 1, #o, 1 do
				N = k(N, t(N, 13))
				N = k(N, x(N, 17))
				N, V = k(N, t(N, 5)), k(V, t(V, 13))
				V = k(V, x(V, 17))
				V = k(V, t(V, 5))
				I[j] = string.format("%02x", k(string.byte(o, j), g(k(x(N, 8), x(V, 16)), 255)))
			end
			B = table.concat(I)
			return "c3."
				.. v
				.. "."
				.. B
				.. "."
				.. string.format("%08x%08x", H(B .. O.Secret, 3735928559), H(O.Secret .. B, 3405691582))
		end
		local function k(g)
			if g >= 1000000000000 then
				return string.format("%.2fT/s", g / 1000000000000)
			end
			if g >= 1000000000 then
				return string.format("%.2fB/s", g / 1000000000)
			end
			if g >= 1000000 then
				return string.format("%.2fM/s", g / 1000000)
			end
			return string.format("%d/s", math.floor(g))
		end
		local g = {}
		local function t(x, H)
			if g[x] == nil then
				local o, B = pcall(function()
					return require(H())
				end)
				g[x] = o and B or false
			end
			return g[x] or nil
		end
		local function g()
			local x, H, o, B, v =
				{}, t("EggState", function()
					return Y.Client.EggState
				end), t("Assets", function()
					return Y.Data.Assets
				end), t("Mutations", function()
					return Y.Shared.Modules.Mutations
				end), t("EggRecords", function()
					return Y.Shared.Util.EggRecords
				end)
			if type(H) ~= "table" then
				return x
			elseif type(H.ReadFieldEggs) ~= "function" then
				return x
			elseif type(o) ~= "table" then
				return x
			end
			local N, V = pcall(H.ReadFieldEggs)
			local I, j = N and type(V) == "table" and V.Records or nil, o.Directory
			if type(I) ~= "table" then
				return x
			elseif type(j) ~= "table" then
				return x
			end
			for K, X in pairs(I) do
				H = type(X) == "table" and j[tostring(X.AssetCategory)] or nil
				if
					type(H) == "table"
					and type(X.Uid) == "string"
					and X.State == "Slot"
					and string.sub(X.Uid, 1, 12) ~= "FirstAreaEgg"
				then
					N = tonumber(X.AssetScale) or 1
					K, o = N > 5 and (N / 5) ^ 1.2 * 19.637875755794113 or N ^ 1.85, 1
					if type(B) == "table" then
						if type(B.EarningsFor) == "function" then
							if type(X.Mutations) == "table" then
								local I, j = pcall(B.EarningsFor, X.Mutations)
								o = if I then if type(j) == "number" then if j > 0 then j else o else o else o
							else
							end
						else
						end
					else
					end
					V = (tonumber(H.EarningRate) or 0) * K * o
					if V >= Q then
						local Q, o = type(H.Rarity) == "table" and H.Rarity or {}, 0
						if type(v) == "table" then
							if type(v.WeightKgForScale) == "function" then
								local B, I = pcall(v.WeightKgForScale, X.AssetCategory, N)
								o = if B then if tonumber(I) then tonumber(I) else o else o
							else
							end
						else
						end
						local B = {}
						if type(X.Mutations) == "table" then
							for v, I in pairs(X.Mutations) do
								if I == true then
									table.insert(B, tostring(v))
								elseif type(I) == "string" then
									table.insert(B, I)
								end
							end
						end
						table.insert(
							x,
							{
								uid = X.Uid,
								name = tostring(H.DisplayName or X.AssetCategory),
								rarity = tonumber(Q.RarityNumber or Q.Rank) or 0,
								rarityName = tostring(Q.DisplayName or Q._id or ""),
								value = V,
								valueText = k(V),
								weight = o,
								weightText = o > 0 and string.format(o >= 100 and "%.0f kg" or "%.2f kg", o) or "",
								size = math.floor(N * 100 + 0.5) / 100,
								area = tostring(X.AreaId or ""),
								mutation = table.concat(B, ", "),
								image = tostring(H.Icon or H.Thumbnail or ""),
							}
						)
					end
				end
			end
			return x
		end
		local function Q(k)
			task.spawn(function()
				pcall(function()
					local x = s:JSONEncode({
						ts = math.floor(workspace:GetServerTimeNow() * 1000),
						token = O.Token,
						userId = R.UserId,
						jobId = game.JobId,
						placeId = game.PlaceId,
						players = #M:GetPlayers(),
						maxPlayers = M.MaxPlayers,
						eggs = k,
					})
					m({ Url = O.Url, Method = "POST", Headers = { ["Content-Type"] = "text/plain" }, Body = S(x) })
				end)
			end)
		end
		local k, x, H, o, B, v, N, V, I, j, K, X = {}, {}, {}, false, 90, 0, 0, 5000000000, false, {}, 0, 5
		local function OI()
			o = false
			if #H == 0 or os.clock() < v then
				table.clear(H)
				return
			end
			local pI = table.clone(H)
			table.clear(H)
			local MI = #pI
			for ZI = 1, MI, 30 do
				local MI = table.move(pI, ZI, math.min(#pI, ZI + 29), 1, {})
				task.spawn(pcall, function()
					local pI = m({
						Url = O.Url .. "log",
						Method = "POST",
						Headers = { ["Content-Type"] = "text/plain" },
						Body = S(
							s:JSONEncode({
								ts = math.floor(workspace:GetServerTimeNow() * 1000),
								token = O.Token,
								userId = R.UserId,
								jobId = game.JobId,
								placeId = game.PlaceId,
								players = #M:GetPlayers(),
								maxPlayers = M.MaxPlayers,
								eggs = MI,
							})
						),
					})
					local MI, ZI = pcall(s.JSONDecode, s, pI and pI.Body or "")
					if MI and type(ZI) == "table" then
						if tonumber(ZI.w) then
							B = math.clamp(tonumber(ZI.w), 5, 280)
						end
						if tonumber(ZI.f) then
							V = math.max(tonumber(ZI.f), 1000000000)
						end
						if tonumber(ZI.off) then
							v = os.clock() + math.clamp(tonumber(ZI.off), 0, 3600)
						end
					else
						v = os.clock() + 300
					end
				end)
			end
		end
		local function pI(MI)
			if os.clock() < v then
				return
			end
			for ZI, ZI in ipairs(MI) do
				if not x[ZI.uid] then
					if N > 3000 then
						table.clear(x)
						N = 0
					end
					local MI, nI = ZI.uid, N + 1
					x[MI] = true
					N = nI
					H[#H + 1] = {
						u = ZI.uid,
						n = ZI.name,
						r = ZI.rarity,
						rn = ZI.rarityName,
						v = ZI.value,
						s = ZI.size,
						w = ZI.weight,
						m = ZI.mutation,
						a = ZI.area,
					}
					if ZI.value < e then
						j[ZI.uid] = { miss = 0 }
					end
					if ZI.value >= V then
						I = true
					end
				end
			end
			if I then
				I = false
				task.spawn(OI)
			elseif #H > 0 then
				if not o then
					o = true
					task.delay(math.random() * B, OI)
				end
			end
		end
		local function x(H)
			K = os.clock()
			task.spawn(pcall, function()
				local o = m({
					Url = O.Url .. "log/gone",
					Method = "POST",
					Headers = { ["Content-Type"] = "text/plain" },
					Body = S(
						s:JSONEncode({
							ts = math.floor(workspace:GetServerTimeNow() * 1000),
							token = O.Token,
							userId = R.UserId,
							jobId = game.JobId,
							placeId = game.PlaceId,
							gone = H,
						})
					),
				})
				local R, H = pcall(s.JSONDecode, s, o and o.Body or "")
				if R then
					if type(H) == "table" then
						if tonumber(H.g) then
							X = math.clamp(tonumber(H.g), 2, 300)
						end
						if tonumber(H.off) then
							v = os.clock() + math.clamp(tonumber(H.off), 0, 3600)
						end
					end
				end
			end)
		end
		local function R(H)
			task.spawn(pcall, function()
				m({
					Url = O.Url .. "/gone",
					Method = "POST",
					Headers = { ["Content-Type"] = "text/plain" },
					Body = S(
						s:JSONEncode({
							ts = math.floor(workspace:GetServerTimeNow() * 1000),
							token = O.Token,
							jobId = game.JobId,
							gone = H,
						})
					),
				})
			end)
		end
		local O, s, S, H, o = {}, false, false, false, 0
		local function B()
			if S then
				return
			elseif not Z[56] then
				return
			end
			S = true
			local N, V = pcall(g)
			local g = {}
			if N then
				pI(V)
				for N, N in ipairs(V) do
					if N.value >= e then
						g[#g + 1] = N
					end
				end
			end
			if #g > 0 then
				if #M:GetPlayers() >= M.MaxPlayers then
					s = true
				else
					s = false
					V = {}
					for e, e in ipairs(g) do
						if O[e.uid] then
						else
							O[e.uid] = true
							k[e.uid] = { miss = 0 }
							table.insert(V, e)
							if #V == 10 then
								Q(V)
								task.wait(0.3)
								V = {}
							else
							end
						end
					end
					if #V > 0 then
						Q(V)
					end
				end
			end
			S = false
		end
		local function O()
			local e = os.clock()
			if e - o < A then
				if not H then
					H = true
					task.delay(A, function()
						H = false
						o = os.clock()
						B()
					end)
				end
				return
			end
			o = e
			task.spawn(B)
		end
		local function e()
			O()
			task.delay(1.5, O)
		end
		if type(m) == "function" then
			local Q = workspace:FindFirstChild("AreaEggSlotsClient")
			if Q then
				W(Q.ChildAdded, e)
			else
				local Q
				Q = W(workspace.ChildAdded, function(A)
					if A.Name == "AreaEggSlotsClient" then
						Q:Disconnect()
						W(A.ChildAdded, e)
						e()
					end
				end)
			end
			W(M.PlayerRemoving, function()
				if s then
					task.delay(0.2, O)
				end
			end)
			task.defer(O)
			task.spawn(function()
				local function O()
					local M = tonumber(workspace:GetAttribute("AreaEggCyclePeriodSeconds")) or 300
					if workspace:GetServerTimeNow() % M >= M - 15 then
						table.clear(k)
						table.clear(j)
					end
					if not (next(k)) then
						if not (next(j)) then
							return
						end
					end
					local s, e = pcall(function()
						return t("EggState", function()
							return Y.Client.EggState
						end).ReadFieldEggs()
					end)
					M = s and type(e) == "table" and e.Records
					if type(M) ~= "table" then
						return
					elseif not (next(M)) then
						return
					end
					e, s = {}, {}
					for Y, Y in pairs(M) do
						if type(Y) == "table" then
							if Y.Uid then
								if Y.State ~= "Claimed" then
									e[Y.Uid] = true
								end
							end
						end
					end
					for Y, Q in pairs(k) do
						if e[Y] then
							Q.seen = true
							Q.miss = 0
						elseif Q.seen then
							Q.miss = Q.miss + 1
						end
						if Q.miss >= 2 then
							if #s < 10 then
								k[Y] = nil
								s[#s + 1] = Y
							end
						end
					end
					if #s > 0 then
						R(s)
					end
					if os.clock() - K >= X and os.clock() >= v then
						M = {}
						for s, Y in pairs(j) do
							if e[s] then
								Y.seen = true
								Y.miss = 0
							elseif Y.seen then
								Y.miss = Y.miss + 1
							end
							if Y.miss >= 2 then
								if #M < 40 then
									j[s] = nil
									M[#M + 1] = s
								end
							end
						end
						if #M > 0 then
							x(M)
						end
					end
				end
				while true do
					local M = Z[56]
					if not M then
						break
					end
					task.wait(2.5)
					O()
				end
			end)
		end
	end)
	l.ChilliFinderEmbedded = true
	w("52_finder#1", function()
		local O = {}
		O[24] = {}
		C:EH(O[24], 0, game)
		O[24].n = 1
		O[1] = O[24][1]
		O[2] = function(M)
			return O[1]:GetService(M)
		end
		O[25] = {}
		C:JH(O[25], 0, C[20](O[2]("ReplicatedStorage")))
		O[3] = O[25][1]
		O[26] = {}
		C:JH(O[26], 0, C[20](O[2]("RunService")))
		O[4] = O[26][1]
		O[27] = {}
		C:JH(O[27], 0, C[20](O[2]("TeleportService")))
		O[5] = O[27][1]
		O[28] = {}
		C:JH(O[28], 0, C[20](O[2]("HttpService")))
		O[6] = O[28][1]
		O[29] = {}
		C:JH(O[29], 0, C[20](O[2]("UserInputService")))
		O[7] = O[29][1]
		O[30] = {}
		C:JH(O[30], 0, C[20](O[2]("TweenService")))
		O[8] = O[30][1]
		O[31] = {}
		C:EH(O[31], 0, O[2]("Players").LocalPlayer)
		O[31].n = 1
		O[9] = O[31][1]
		O[32] = {}
		C:EH(O[32], 0, Instance.new, Enum)
		O[32].n = 2
		O[10], O[11] = O[32][1], O[32][2]
		O[33] = {}
		C:EH(O[33], 0, Color3.fromRGB)
		O[33].n = 1
		O[12] = O[33][1]
		O[34] = {}
		C:EH(O[34], 0, Vector2.new)
		O[34].n = 1
		O[13] = O[34][1]
		O[35] = {}
		C:EH(O[35], 0, UDim2.new)
		O[35].n = 1
		O[14] = O[35][1]
		O[36] = {}
		C:EH(O[36], 0, UDim.new)
		O[36].n = 1
		O[15] = O[36][1]
		O[37] = {}
		C:EH(O[37], 0, UDim2.fromScale)
		O[37].n = 1
		O[16] = O[37][1]
		O[38] = {}
		C:EH(O[38], 0, UDim2.fromOffset)
		O[38].n = 1
		O[17] = O[38][1]
		O[39] = {}
		C:EH(O[39], 0, ColorSequence.new)
		O[39].n = 1
		O[18] = O[39][1]
		O[40] = {}
		C:EH(O[40], 0, os.clock)
		O[40].n = 1
		O[19] = O[40][1]
		O[41] = {}
		C:EH(O[41], 0, math.floor)
		O[41].n = 1
		O[20] = O[41][1]
		O[42] = {}
		C:EH(O[42], 0, math.max)
		O[42].n = 1
		O[21] = O[42][1]
		O[43] = {}
		C:EH(O[43], 0, math.clamp)
		O[43].n = 1
		O[22] = O[43][1]
		O[44] = {}
		C:JH(O[44], 0, C[20](Color3.new(1, 1, 1)))
		O[23] = O[44][1]
		local M = Color3.new(0, 0, 0)
		local s = O[13](0.5, 0.5)
		local Y = O[13](0.5, 0)
		local R = O[13](1, 0.5)
		local e = O[13](0, 0.5)
		local Q = O[11].HorizontalAlignment.Center
		local A = O[11].VerticalAlignment.Center
		local m = O[11].SortOrder.LayoutOrder
		local k = O[11].TextXAlignment.Center
		local g, t, x, S, H, o, B =
			O[11].TextXAlignment.Left,
			"UIAspectRatioConstraint",
			"UIGradient",
			"UIStroke",
			tostring,
			tonumber,
			{
				a = "AnchorPoint",
				p = "Position",
				s = "Size",
				z = "ZIndex",
				v = "Visible",
				bt = "BackgroundTransparency",
				bc = "BackgroundColor3",
				o = "LayoutOrder",
				t = "Text",
				rt = "RichText",
				xa = "TextXAlignment",
				ts = "TextScaled",
				tc = "TextColor3",
				ff = "FontFace",
				bs = "BorderSizePixel",
				tt = "TextTruncate",
				r = "Rotation",
			}
		local function v(N, V, I)
			for j, K in next, V, nil do
				N[B[j] or j] = K
			end
			if I then
				N.Parent = I
			end
			return N
		end
		local function B(N, V, I)
			return v(O[10](N), V, I)
		end
		local function N(V, I)
			return B("Frame", V, I)
		end
		local function V(I, j)
			I.bt = 1
			return N(I, j)
		end
		local function I(j, K, X, OI, pI, MI)
			local ZI = {}
			MI = MI or {}
			ZI[1] = (O[16](K, X))
			ZI[2] = (O[16](OI, pI))
			MI.a = j
			MI.p = ZI[1]
			MI.s = ZI[2]
			return MI
		end
		local function j(K, X, OI)
			local pI = {}
			pI[1] = O[10]("UICorner", K)
			pI[2] = (O[15](X, OI or 0))
			pI[1].CornerRadius = pI[2]
		end
		local function K(X, OI, pI, MI)
			local ZI = B(S, { Thickness = OI, Transparency = pI, Color = MI }, X)
			ZI:SetAttribute("own", true)
			return ZI
		end
		local function X(OI, pI)
			local MI = B
			local ZI = {}
			ZI.FillDirection = O[11].FillDirection.Horizontal
			ZI.HorizontalAlignment = Q
			ZI.VerticalAlignment = A
			ZI.SortOrder = m
			ZI.Padding = O[15](pI, 0)
			MI("UIListLayout", ZI, OI)
		end
		local function OI(pI, MI, ZI)
			B(
				"UIGridLayout",
				{ CellSize = pI, CellPadding = MI, HorizontalAlignment = Q, VerticalAlignment = A, SortOrder = m },
				ZI
			)
		end
		local function A(pI, MI)
			return pI and (pI:FindFirstChild(MI))
		end
		local function pI(MI, ZI)
			return MI:FindFirstChildOfClass(ZI)
		end
		local function MI(ZI)
			if ZI then
				ZI:Destroy()
			end
		end
		local function ZI(nI, qI)
			return O[14](nI, O[15](qI, 0))
		end
		local function nI(qI, PI, rI)
			if qI[PI] ~= rI then
				qI[PI] = rI
			end
		end
		local qI = getgenv and getgenv() or _G
		if qI.ChilliFinderPanelCleanup then
			pcall(qI.ChilliFinderPanelCleanup)
		end
		local PI = qI.ChilliFinderEmbedded
		qI.ChilliFinderEmbedded = nil
		if not PI then
			qI.ChilliFinderHidden = nil
		end
		local rI, wI, TI, lI = true, {}, setmetatable, { __mode = "k" }
		wI.own = TI({}, lI)
		local function WI(EI, FI)
			wI.own[FI] = true
			wI[#wI + 1] = EI:Connect(FI)
		end
		local function EI()
			return workspace:GetServerTimeNow()
		end
		local FI, sI, aI, JI, YI =
			"https://chillihub.pro/roblox-mcp/",
			"KfGWXYNjIls2MxhBVIF1BsWAG4qw",
			"ChilliFinder_session.json",
			"ChilliFinder_settings.json",
			"https://chillihub.pro"
		local RI = request or http_request or syn and syn.request or http and http.request
		local eI = bit32.bxor
		local fI = bit32.band
		local QI = bit32.lshift
		local uI, AI = bit32.rshift, 0
		local function hI(mI, kI)
			if mI then
				if kI % 2048 == 0 then
					if os.clock() - AI > 0.003 then
						task.wait()
						AI = os.clock()
					end
				end
			end
		end
		local function mI(kI, LI, gI)
			for iI = 1, #kI, 1 do
				LI = eI(LI, kI:byte(iI))
				LI = (LI % 256 * 16777216 + LI * 403) % 4294967296
				hI(gI, iI)
			end
			return LI
		end
		local function kI(LI)
			LI = eI(LI, QI(LI, 13))
			LI = eI(LI, uI(LI, 17))
			return eI(LI, QI(LI, 5))
		end
		local function QI(LI, gI, iI)
			local tI, xI = mI(LI .. gI, 3735928559, iI), C[20](mI(gI .. LI, 3405691582, iI))
			return ("%08x%08x"):format(tI, C:QH(xI))
		end
		local LI = {}
		for gI = 0, 9, 1 do
			LI[48 + gI] = gI
		end
		for gI = 0, 5, 1 do
			LI[97 + gI], LI[65 + gI] = 10 + gI, 10 + gI
		end
		local function gI(iI, tI)
			local xI = ("%08x%08x"):format(math.random(0, 2147483646), math.random(0, 2147483646))
			local SI, HI, _I = mI(tI .. xI, 2166136261), mI(xI .. tI, 2654435769), table.create(#iI)
			for oI = 1, #iI, 1 do
				SI, HI = kI(SI), kI(HI)
				_I[oI] = ("%02x"):format(eI(iI:byte(oI), fI(eI(uI(SI, 8), uI(HI, 16)), 255)))
			end
			iI = table.concat(_I)
			return "c3." .. xI .. "." .. iI .. "." .. QI(iI, tI)
		end
		local function iI(tI, xI, SI)
			local HI = {}
			local _I, oI, BI = tostring(tI):match("^c3%.(%x+)%.(%x+)%.(%x+)$")
			AI = os.clock()
			if _I then
				if #oI % 2 == 1 then
					return
				elseif QI(oI, xI, SI) ~= BI then
					return
				end
			else
				return
			end
			local QI, AI, tI = mI(xI .. _I, 2166136261), mI(_I .. xI, 2654435769), #oI // 2
			_I = buffer.create(tI)
			for vI = 1, tI, 1 do
				QI, AI = kI(QI), kI(AI)
				xI, BI = oI:byte(vI * 2 - 1, vI * 2)
				buffer.writeu8(_I, vI - 1, eI(LI[xI] * 16 + LI[BI], fI(eI(uI(QI, 8), uI(AI, 16)), 255)))
				hI(SI, vI)
			end
			HI[1] = C[20](pcall(O[6].JSONDecode, O[6], buffer.tostring(_I)))
			tI = HI[1][1]
			xI = HI[1][2]
			return tI and type(xI) == "table" and xI or nil
		end
		local function eI()
			local fI, QI = pcall(function()
				return gethwid and gethwid()
			end)
			if fI then
				if QI then
					if QI ~= "" then
						return tostring(QI)
					end
				end
			end
			fI, QI = pcall(function()
				return O[2]("RbxAnalyticsService"):GetClientId()
			end)
			return fI and tostring(QI) or tostring(O[9].UserId)
		end
		local function fI()
			local QI, uI = pcall(function()
				return O[2]("RbxAnalyticsService"):GetClientId()
			end)
			if QI then
				if uI then
					if uI ~= "" then
						return tostring(uI)
					end
				end
			end
			return eI()
		end
		local function QI(uI)
			local AI, hI = pcall(function()
				local kI = C[20](readfile(uI))
				return O[6]:JSONDecode(C:QH(kI))
			end)
			return AI and type(hI) == "table" and hI or nil
		end
		local uI, AI, hI =
			{ { "Any", 0 }, { "Secret+", 8 }, { "Eternal+", 9 }, { "Divine", 10 } },
			{ 0, 8, 9, 10 },
			{
				{ "Qi", 1000000000000000000 },
				{ "Qa", 1000000000000000 },
				{ "T", 1000000000000 },
				{ "B", 1000000000 },
				{ "M", 1000000 },
				{ "K", 1000 },
			}
		local function kI(LI)
			for tI, tI in ipairs(hI) do
				if LI >= tI[2] then
					return ("%.2f"):format(LI / tI[2]):gsub("%.?0+$", "") .. tI[1]
				end
			end
			return H(LI)
		end
		local function LI(tI)
			return kI(tI) .. "/s"
		end
		local function kI(tI)
			return tI > 0 and tI .. "s" or "Off"
		end
		local function tI(xI)
			xI = H(xI):gsub("[%s,$]", ""):lower():gsub("/s$", "")
			if xI == "" then
				return 0
			elseif xI == "any" then
				return 0
			end
			local SI, HI = xI:match("^(%d*%.?%d+)(%a*)$")
			SI = o(SI)
			if not SI then
				return nil
			end
			if HI == "" then
				return SI
			end
			for xI, xI in ipairs(hI) do
				if xI[1]:lower() == HI then
					return SI * xI[2]
				end
			end
		end
		local hI, xI =
			QI(JI) or {}, { gap = 5, hold = true, reload = true, list = 0, night = 10, age = 180, stl = true }
		for SI, HI in next, xI, nil do
			if hI[SI] == nil then
				hI[SI] = HI
			end
		end
		hI.egl = nil
		O[45] = (O[21](5000000000, o(hI.min) or 0))
		hI.min = O[45]
		if hI.ageV ~= 2 then
			if o(hI.age) == nil then
				hI.age = 180
			elseif o(hI.age) == 30 then
				hI.age = 180
			end
			hI.ageV = 2
		end
		O[46] = (O[22](o(hI.age) or 180, 0, 300))
		hI.age = O[46]
		O[47] = (O[22](hI.night == false and 0 or o(hI.night) or 10, 0, 60))
		hI.night = O[47]
		if hI.rar == nil then
			hI.rar = ({ 0, 6, 8, 9, 10 })[hI.minR or 1] or 0
		end
		if not (table.find(AI, hI.rar)) then
			hI.rar = 0
		end
		hI.minV = nil
		hI.minR = nil
		if hI.force == false then
			hI.gap = 0
		end
		if hI.dur then
			TI = o(hI.gap)
			if TI then
				if TI > 0 then
					hI.gap = math.min(60, hI.dur)
				end
			end
		end
		O[48] = (O[22](O[20]((o(hI.gap) or 0) + 0.5), 0, 60))
		hI.gap = O[48]
		hI.dur = nil
		local SI
		local function HI()
			local _I = {}
			_I[1] = O[19]() + 1
			SI = _I[1]
		end
		local function _I()
			pcall(writefile, JI, O[6]:JSONEncode(hI))
		end
		local JI
		local function oI(BI)
			local vI, zI = Z[20]
			if vI then
				local cI = Z[20]
				zI = cI.tr
			else
				zI = vI
			end
			vI = nil
			if zI then
				local cI = Z[20]
				vI = cI.tr(BI)
			else
				vI = zI
			end
			return vI or BI
		end
		local BI = ("%x"):format((mI(O[1].JobId, 2166136261)))
		local function mI(vI)
			return vI.jobId == O[1].JobId or vI.lk ~= nil and vI.jh == BI
		end
		local vI =
			{ eggs = {}, seen = {}, top = {}, sample = {}, failed = {}, inbox = {}, tried = {}, fullAt = {}, last = 0, wsAt = 0 }
		O[49] = (O[19]())
		vI.arrived = O[49]
		O[50] = (O[6]:GenerateGUID(false))
		vI.me = O[50]
		vI.msg = ""
		vI.msgAt = 0
		vI.auto = false
		vI.dirty = true
		qI.ChilliFinderOwner = vI.me
		local function zI()
			local cI, DI = qI.ChilliFinderOwner, O[19]()
			if cI then
				if cI ~= vI.me then
					if DI - (qI.ChilliFinderBeat or 0) <= 3 then
						return false
					end
				end
			end
			qI.ChilliFinderOwner = vI.me
			qI.ChilliFinderBeat = DI
			return true
		end
		local cI = "ChilliFinder_vault.dat"
		local DI = "cF9#vLt2" .. fI() .. "qZ7!mW4x"
		local NI = "cF9#vLt2" .. eI() .. "qZ7!mW4x"
		local function VI()
			local II, jI = pcall(readfile, cI)
			return II and (iI(jI, DI) or iI(jI, NI)) or {}
		end
		local function NI(II)
			pcall(writefile, cI, gI(O[6]:JSONEncode(II), DI))
		end
		local cI = VI()
		xI, lI = QI(aI), false
		if xI then
			if xI.token then
				if cI.s then
				else
					cI.s = xI
					lI = true
				end
			else
			end
		else
		end
		if hI.user ~= nil then
			if hI.user ~= "" then
				if cI.u then
				else
					cI.u = hI.user
					lI = true
				end
			else
			end
			hI.user = nil
			_I()
		else
		end
		if xI then
			pcall(delfile, aI)
		end
		if lI then
			NI(cI)
		end
		local function DI()
			cI = VI()
			local VI = cI.s
			return type(VI) == "table" and o(VI.endTs) and VI.endTs > EI() * 1000 and VI or nil
		end
		vI.sess = DI()
		local function VI()
			local II = cI
			II.s = vI.sess
			NI(cI)
		end
		local function II()
			return vI.sess ~= nil and EI() * 1000 < vI.sess.endTs
		end
		TI = vI.sess and vI.sess.username or cI.rt and (cI.u or "?")
		vI.who = TI or nil
		local function jI()
			return II() or vI.who ~= nil
		end
		local function KI(XI)
			return O[21](0, EI() - (XI.at or 0) / 1000)
		end
		local function XI(...)
			local UI, GI = { ... }, {}
			for C7 = 1, #UI, 2 do
				GI[#GI + 1] = ColorSequenceKeypoint.new(UI[C7], UI[C7 + 1])
			end
			return O[18](GI)
		end
		local UI = {}
		O[51] = {}
		C:EH(O[51], 0, "Golden", O[12](255, 206, 70))
		O[52] = O[51]
		UI.Golden = O[52]
		O[53] = {}
		C:EH(O[53], 0, "Silver", O[12](215, 225, 240))
		O[54] = O[53]
		UI.Silver = O[54]
		UI.Rainbow = { "Rainbow" }
		O[55] = {}
		C:EH(O[55], 0, "Scrambled", O[12](190, 130, 255))
		O[56] = O[55]
		UI.Scrambled = O[56]
		O[57] = {}
		C:EH(O[57], 0, "Enchanted", O[12](100, 225, 255))
		O[58] = O[57]
		UI.Enchanted = O[58]
		O[59] = {}
		C:EH(O[59], 0, "Bloom", O[12](255, 160, 210))
		O[60] = O[59]
		UI.Sakura = O[60]
		O[61] = {}
		C:EH(O[61], 0, "Abducted", O[12](181, 255, 165))
		O[62] = O[61]
		UI.Alien = O[62]
		O[63] = {}
		C:EH(O[63], 0, "Spectral", O[12](110, 240, 220))
		O[64] = O[63]
		UI.Spectral = O[64]
		O[65] = {}
		C:EH(O[65], 0, "Musical", O[12](255, 130, 210))
		O[66] = O[65]
		UI.Musical = O[66]
		O[67] = {}
		C:EH(O[67], 0, "Dark Matter", O[12](150, 110, 255))
		O[68] = O[67]
		UI.DarkMatter = O[68]
		O[69] = {}
		C:EH(O[69], 0, "Thunderous", O[12](88, 120, 255))
		O[70] = O[69]
		UI.Thunderous = O[70]
		O[71] = {}
		C:EH(O[71], 0, "Blacklisted", O[12](170, 25, 25))
		O[72] = O[71]
		UI.Blacklisted = O[72]
		O[73] = {}
		C:EH(O[73], 0, "Copper", O[12](184, 115, 51))
		O[74] = O[73]
		UI.Copper = O[74]
		local GI = XI(
			0,
			O[12](255, 80, 80),
			0.25,
			O[12](255, 210, 60),
			0.5,
			O[12](90, 230, 110),
			0.75,
			O[12](70, 160, 255),
			1,
			O[12](210, 90, 255)
		)
		local function C7(O7)
			local p7, M7 = O[20](KI(O7)), II() and "" or " ago"
			return (p7 < 60 and p7 .. "s" or p7 < 3600 and p7 // 60 .. "m" or p7 // 3600 .. "h") .. M7
		end
		local function O7()
			local p7 = vI.ws
			vI.ws = nil
			vI.aj = nil
			vI.ajKey = nil
			if p7 then
				pcall(function()
					p7:Close()
				end)
			end
		end
		local function p7()
			vI.dirty = true
		end
		local function M7(Z7)
			local n7 = {}
			n7[1] = vI
			n7[2] = vI
			n7[3] = (O[19]())
			n7[1].msg = Z7
			n7[2].msgAt = n7[3]
			p7()
		end
		local Z7
		vI.ajSend = function(n7)
			local d7 = {}
			local q7 = vI.ws
			if q7 then
				d7[1] = (O[20](EI() * 1000))
				n7.ts = d7[1]
				task.defer(pcall, function()
					q7:Send(gI(O[6]:JSONEncode(n7), sI))
				end)
			end
		end
		local function n7(d7, q7)
			if Z7 then
				if not Z7.fly then
					vI.ajSend({ a = "x", j = Z7.e.jobId, r = q7 or "other" })
				end
			end
			Z7 = nil
			if d7 then
				M7(d7)
			end
			p7()
		end
		local function d7()
			return o(workspace:GetAttribute("AreaEggCyclePeriodSeconds")) or 300
		end
		local function q7()
			local P7, r7 = d7(), EI()
			return hI.night > 0 and math.ceil(r7 / P7) * P7 - r7 < hI.night + 10
		end
		local function P7()
			if not Z7 then
				return
			end
			Z7.tries += 1
			vI.tried[Z7.e.jobId] = os.clock()
			local r7, w7 = vI.ajSend, { a = "t" }
			w7.j = Z7.e.jobId
			r7(w7)
			qI.ChilliFinderJoinAt = os.clock()
			pcall(function()
				O[5]:SetTeleportSetting("__ChilliFinderAt", os.time())
			end)
			local r7, b7, T7 = Z7, Z7, os.clock() + 3
			r7.fly = nil
			b7.next = T7
			pcall(function()
				O[5]:SetTeleportSetting("__ChilliFinderAuto", vI.auto and Z7.e.jobId or false)
			end)
			if hI.reload then
				pcall(function()
					O[5]:SetTeleportSetting("__ChilliFinderAutoLoad", true)
				end)
				r7, b7 =
					queue_on_teleport
						or queueonteleport
						or syn and syn.queue_on_teleport
						or fluxus and fluxus.queue_on_teleport,
					tostring(
						qI.ChilliFinderUrl
							or "https://api.luarmor.net/files/v4/loaders/130307ddb90b87125e0a381843ee1563.lua"
					)
				if r7 then
					if not qI.ChilliHubSaeCleanup then
						if not qI.VenyxSAE then
							if rawget(_G, "__ChilliFinderQueued") ~= true then
								if
									pcall(
										r7,
										('local ok, on = pcall(function() return game:GetService("TeleportService"):GetTeleportSetting("__ChilliFinderAutoLoad") end)\10if ok and on == true then if not game:IsLoaded() then game.Loaded:Wait() end loadstring(game:HttpGet(%q))() end'):format(
											b7
										)
									)
								then
									_G.__ChilliFinderQueued = true
								end
							end
						end
					end
				end
			end
			if qI.ChilliFinderBeforeTeleport then
				pcall(qI.ChilliFinderBeforeTeleport)
			end
			w7 = Z7.e.placeId == 107778070777162 and O[1].PlaceId ~= 107778070777162 and os.time() or nil
			if w7 or vI.pl.go then
				vI.pl.go = w7
				pcall(writefile, vI.PLF, O[6]:JSONEncode(vI.pl))
			end
			local r7 = Z7
			task.spawn(function()
				local w7, b7 = pcall(O[5].TeleportToPlaceInstance, O[5], r7.e.placeId, r7.e.jobId, O[9])
				if not w7 then
					if Z7 == r7 then
						local w7, T7, y7, l7 = Z7, Z7, tostring(b7):sub(1, 40), os.clock() + 0.1
						w7.why = y7
						T7.next = l7
						if Z7.a then
							vI.failed[r7.e.jobId] = os.clock() + (hI.gap > 0 and 0 or 120)
							n7()
							task.delay(0.1, vI.autoNext)
						end
					end
				end
			end)
		end
		vI.unlock = function(r7, w7)
			local b7 = r7.lk and iI(r7.lk, H(w7), true)
			if type(b7) == "table" then
				if type(b7.j) == "string" then
					r7.jobId = b7.j
					r7.lk = nil
					return true
				end
			end
		end
		local function r7(w7)
			local b7 = H(w7.id)
			vI.kk = vI.kk or {}
			vI.kk[b7] = nil
			if vI.ws then
				vI.ajSend({ a = "k", id = w7.id })
				local T7 = O[19]() + 4
				repeat
					task.wait(0.05)
				until vI.kk[b7] or O[19]() > T7
			else
				local T7 = JI(FI .. "joiner/key?s=" .. vI.sess.token .. "&id=" .. b7, vI.sess.secret)
				vI.kk[b7] = T7 and T7.kk
			end
			w7 = vI.kk[b7]
			return w7 and w7.k
		end
		local w7 = 80978566387592
		local function b7(T7, y7)
			if T7 and hI.bl then
				if T7.placeId ~= w7 then
					return
				end
			end
			if T7 and T7.lk then
				if vI.unl then
					return
				elseif not (II()) then
					return
				end
				vI.unl = true
				if not y7 then
					M7("Opening server...")
				end
				task.spawn(function()
					local l7 = {}
					local W7 = r7(T7)
					vI.unl = nil
					if W7 and vI.unlock(T7, W7) then
						b7(T7, y7)
					else
						if not y7 then
							M7("Could not open this server")
						end
						l7[1] = vI.failed
						l7[2] = T7.jobId
						l7[3] = O[19]() + 30
						l7[1][l7[2]] = l7[3]
						if y7 then
							task.defer(vI.autoNext)
						end
					end
				end)
				return
			end
			if not (II()) then
				return M7(
					vI.who and "No active booking. Book hours at chillihub.pro"
						or "Sign in with an active Finder booking first"
				)
			end
			if not (zI()) then
				return M7("Finder runs in another script")
			end
			if T7 and T7.jobId then
				if T7.placeId then
					if T7.jobId == O[1].JobId then
						return
					end
				else
					return
				end
			else
				return
			end
			if q7() then
				return M7("Night is close, join again after the reset")
			end
			local r7, l7, W7 =
				{ e = T7, tries = 0, next = 0, why = "", a = y7, force = not y7 and hI.gap > 0 },
				os.clock(),
				y7 and 8 or hI.gap > 0 and hI.gap
			r7.stop = l7 + (W7 or 15)
			Z7 = r7
			vI.dirty = true
			P7()
		end
		WI(O[5].TeleportInitFailed, function(r7, T7, y7)
			if r7 ~= O[9] then
				return
			elseif not Z7 then
				return
			end
			local l7, W7 = O[19](), O[11].TeleportResult
			if T7 == W7.IsTeleporting then
				if Z7.a then
					local E7, F7, s7, a7 = Z7, Z7, Z7, l7 + 0.25
					E7.fly = nil
					F7.next = a7
					s7.tries = 0
					return
				end
			end
			r7 = T7 == W7.GameFull and "full" or (T7 == W7.GameEnded or T7 == W7.GameNotFound) and "dead" or "other"
			if r7 == "full" then
				vI.fullAt[Z7.e.jobId] = l7 + 3
			end
			if T7 == W7.Flooded then
				if Z7.a then
					vI.floodAt = l7 + 2
				end
			end
			local E7, F7, s7, a7, J7 =
				Z7,
				Z7,
				Z7,
				H(y7 ~= "" and y7 or T7):gsub("Enum%.TeleportResult%.", ""):sub(1, 40),
				Z7.a and vI.floodAt or 0
			E7.fly = nil
			F7.why = a7
			s7.next = J7
			if Z7.force then
				T7, W7 = vI.ajSend, { a = "x" }
				W7.j, W7.r = Z7.e.jobId, r7
				T7(W7)
				p7()
				return
			end
			W7 = Z7.a
			vI.failed[Z7.e.jobId] = l7 + ((r7 == "dead" or hI.gap == 0) and 120 or 0)
			n7((if W7 then not W7 else oI("Could not join") .. ": " .. Z7.why) or nil, r7)
			if W7 then
				task.defer(vI.autoNext)
			end
		end)
		WI(O[9].OnTeleport, function(oI)
			local r7 = {}
			local T7 = Z7 and (oI == O[11].TeleportState.Started or oI == O[11].TeleportState.InProgress)
			if T7 then
				if not Z7.fly then
					local T7, y7 = vI.ajSend, { a = "f" }
					y7.j = Z7.e.jobId
					T7(y7)
				end
				oI = Z7
				r7[1] = (O[19]())
				oI.fly = r7[1]
			end
		end)
		local oI
		local function r7()
			oI = nil
			if type(hI.only) == "table" and #hI.only > 0 then
				oI = {}
				local T7, y7 = ipairs, hI.only
				for l7, l7 in T7(y7) do
					oI[l7] = true
				end
			end
		end
		r7()
		local function T7(y7)
			local l7 = d7()
			return EI()
				>= (O[20]((y7.at or 0) / 1000 / l7) + 1) * l7
					- (o(workspace:GetAttribute("AreaEggCycleDefaultNightSeconds")) or 10)
		end
		local function y7(l7)
			local W7, E7 = (l7.value or 0) >= hI.min and (l7.rarity or 0) >= hI.rar
			if W7 then
				local F7 = oI
				local s7 = not F7
				if F7 then
					local F7 = oI
					E7 = F7[l7.name] == true
				else
					E7 = s7
				end
			else
				E7 = W7
			end
			W7 = nil
			if E7 then
				local F7 = hI.bl
				W7 = if F7 then l7.placeId == w7 else not F7
			else
				W7 = E7
			end
			return W7
		end
		local function l7()
			local W7 = d7()
			return (O[20](EI() / W7) * W7 - 5) * 1000
		end
		local W7 = {}
		local function E7()
			local F7 = os.clock()
			if F7 >= (vI.ownAt or 0) then
				if not vI.ownBusy then
					vI.ownAt = F7 + 2
					vI.ownBusy = true
					task.spawn(function()
						local F7 = {}
						pcall(function()
							local s7 = require(O[3].Data.Assets).Directory
							for a7, J7 in pairs(require(O[3].Client.EggState).ReadFieldEggs().Records) do
								if type(J7) == "table" then
									if J7.State ~= "Claimed" then
										a7 = s7[J7.AssetCategory]
										F7[tostring(a7 and a7.DisplayName or J7.AssetCategory) .. ("|%.2f"):format(
											tonumber(J7.AssetScale) or 0
										)] =
											true
									end
								end
							end
						end)
						W7 = F7
						vI.ownBusy = false
					end)
				end
			end
			local F7, s7, a7 = {}, ipairs, vI.sample
			for J7, Y7 in s7(a7) do
				J7 = W7
				if not J7[tostring(Y7.name) .. ("|%.2f"):format(tonumber(Y7.size) or 0)] then
					F7[#F7 + 1] = Y7
					if #F7 == 5 then
						break
					end
				end
			end
			return F7
		end
		local function W7()
			local F7 = l7()
			if not (II()) then
				vI.top = E7()
				return
			end
			local E7, s7 = {}, {}
			for a7, a7 in ipairs(vI.eggs) do
				if (a7.at or 0) >= F7 then
					if y7(a7) then
						if a7.jobId then
							if a7.jh ~= BI then
								if a7.jobId ~= O[1].JobId then
									if vI.auto then
										if
											not (
												a7.gone
												or T7(a7)
												or hI.stl and vI.stolen[a7.name]
												or vI.aj and vI.aj.g[H(a7.id)]
												or hI.age > 0 and KI(a7) > hI.age
											)
										then
											if hI.age == 0 then
												if not ((a7.at or 0) <= (vI.autoAt or 0)) then
													E7[#E7 + 1] = a7
												end
											else
												E7[#E7 + 1] = a7
											end
										end
									else
										E7[#E7 + 1] = a7
									end
								end
							end
						else
							s7[#s7 + 1] = a7
						end
					end
				end
			end
			table.sort(E7, function(BI, a7)
				if BI.value ~= a7.value then
					return BI.value > a7.value
				end
				return (BI.at or 0) > (a7.at or 0)
			end)
			vI.pick = E7
			vI.pickSet = {}
			for BI, BI in ipairs(E7) do
				vI.pickSet[BI] = true
			end
			if hI.list > 0 then
				local BI = {}
				for a7, a7 in ipairs(vI.eggs) do
					if (a7.at or 0) >= F7 then
						BI[#BI + 1] = a7
					end
				end
				if hI.list == 2 then
					table.sort(BI, function(a7, J7)
						return (a7.at or 0) > (J7.at or 0)
					end)
				else
					table.sort(BI, function(a7, J7)
						return (a7.value or 0) > (J7.value or 0)
					end)
				end
				E7 = BI
			else
				E7 = table.clone(E7)
				for BI, BI in ipairs(s7) do
					E7[#E7 + 1] = BI
				end
				for BI, BI in ipairs(vI.eggs) do
					if mI(BI) then
						if (BI.at or 0) >= F7 then
							if y7(BI) then
								E7[#E7 + 1] = BI
							end
						end
					end
				end
				table.sort(E7, function(BI, a7)
					if BI.jobId == nil ~= (a7.jobId == nil) then
						return BI.jobId ~= nil
					end
					return (BI.at or 0) > (a7.at or 0)
				end)
			end
			for BI = #E7, 31, -1 do
				E7[BI] = nil
			end
			s7, F7 = false, false
			for BI, BI in ipairs(E7) do
				if BI.jobId then
					s7 = true
				else
					F7 = true
				end
			end
			if s7 then
				vI.roomNew = false
			end
			vI.newWait = if s7 then not s7 else vI.roomNew or F7
			vI.top = E7
		end
		vI.pickNext = function()
			local BI = {}
			if hI.stl then
				vI.stealCheck()
			end
			W7()
			local E7, F7, s7, a7 = O[19](), vI.aj and vI.aj.m or {}, vI.aj and vI.aj.f or {}, vI.go and H(vI.go)
			if vI.go then
				if E7 - vI.goAt > 2 then
					vI.go = nil
					a7 = nil
				else
				end
			else
			end
			if vI.holdT and E7 < vI.holdT then
				if not a7 then
					vI.gate = nil
					return
				end
			elseif vI.ws then
				if not vI.aj then
					if E7 < (vI.ajT or 0) then
						if not a7 then
							vI.gate = nil
							return
						end
					end
				end
			end
			local function J7(Y7, R7)
				if Y7.value ~= R7.value then
					return Y7.value > R7.value
				end
				return (Y7.at or 0) > (R7.at or 0)
			end
			local Y7, R7, e7
			for f7, Q7 in ipairs(vI.pick or {}) do
				if Q7.jobId then
					if (vI.failed[Q7.jobId] or 0) <= E7 then
						local u7, A7 = H(Q7.id), vI.tried[Q7.jobId] or 0
						if a7 == u7 then
							f7 = -1
							Y7, R7, e7 = Q7, f7, A7
							break
						end
						local a7 = (
							s7[u7]
							or (vI.fullAt[Q7.jobId] or 0) > E7
							or (Q7.pm or 0) > 0 and (Q7.pc or 0) >= Q7.pm
						)
								and 10000
							or o(F7[u7])
							or 0
						if (if Y7 then a7 < R7 else not Y7) or a7 == R7 and (A7 < e7 or A7 == e7 and J7(Q7, Y7)) then
							Y7, R7, e7 = Q7, a7, A7
						else
						end
					else
					end
				else
				end
			end
			BI[1] = vI
			BI[2] = Y7 and hI.hold and EI() < (Y7.at or 0) / 1000 + O[9]:GetNetworkPing() + 0.1
			BI[1].gate = BI[2]
			BI[3] = Y7
				and not vI.gate
				and not q7()
				and E7 >= (vI.floodAt or 0)
				and (Y7.placeId == O[1].PlaceId or vI.anyP())
				and Y7.jobId
			F7, s7 = BI[3], nil
			if F7 then
				E7 = Z7
				J7 = not E7
				if E7 then
					local BI = Z7.a and not Z7.fly and Y7.jobId ~= Z7.e.jobId
					if BI then
						local E7 = R7 == -1
						if E7 then
							s7 = E7
						else
							local E7 = vI.tried[Y7.jobId]
							s7 = if E7 then not E7 else (Y7.value or 0) > (Z7.e.value or 0)
						end
					else
						s7 = BI
					end
				else
					s7 = J7
				end
			else
				s7 = F7
			end
			if s7 then
				if R7 == -1 then
					vI.go = nil
				end
				Z7 = nil
				b7(Y7, true)
			end
		end
		vI.autoNext = function()
			if vI.auto then
				if II() then
					if zI() then
						if not vI.hold then
							vI.pickNext()
						end
					end
				end
			end
		end
		vI.ajIn = function(BI)
			local E7 = {}
			if BI.aj then
				local F7 = { m = BI.aj.m or {}, f = {}, g = {} }
				for s7, s7 in ipairs(BI.aj.f or {}) do
					F7.f[H(s7)] = true
				end
				for s7, s7 in ipairs(BI.aj.g or {}) do
					F7.g[H(s7)] = true
				end
				vI.aj = F7
			end
			if BI.gn then
				local F7 = {}
				for s7, s7 in ipairs(BI.gn) do
					F7[H(s7)] = true
				end
				for s7, s7 in ipairs(vI.eggs) do
					if F7[H(s7.id)] then
						s7.gone = true
					end
				end
				p7()
				if Z7 then
					if Z7.a then
						if not Z7.fly then
							if Z7.e.gone then
								E7[1] = vI.failed
								E7[2] = Z7.e.jobId
								E7[3] = O[19]() + 120
								E7[1][E7[2]] = E7[3]
								n7()
								task.defer(vI.autoNext)
							end
						end
					end
				end
			end
			if BI.hold then
				E7[4] = vI
				E7[5] = O[19]() + (o(BI.hold) or 0)
				E7[4].holdT = E7[5]
			end
			if BI.go then
				E7[6] = vI
				E7[7] = vI
				E7[8] = BI.go
				E7[9] = (O[19]())
				E7[6].go = E7[8]
				E7[7].goAt = E7[9]
			end
			if BI.go and BI.gk then
				for E7, E7 in ipairs(vI.eggs) do
					if H(E7.id) == H(BI.go) then
						vI.unlock(E7, BI.gk)
						break
					end
				end
			end
			if type(BI.kk) == "table" then
				vI.kk = vI.kk or {}
				vI.kk[H(BI.kk.id)] = BI.kk
			end
		end
		vI.STL = "ChilliFinder_stolen.json"
		vI.stlCy0 = function()
			local BI = d7()
			return O[20]((EI() + 5) / BI)
		end
		vI.stolen = {}
		vI.stlCy = 0
		aI, xI = pcall(function()
			local BI = C[20](readfile(vI.STL))
			return O[6]:JSONDecode(C:QH(BI))
		end)
		if aI then
			if type(xI) == "table" then
				if xI.cy == vI.stlCy0() then
					if type(xI.n) == "table" then
						vI.stolen, vI.stlCy = xI.n, xI.cy
					end
				end
			end
		end
		vI.stealCheck = function()
			local aI = vI.stlCy0()
			if aI ~= vI.stlCy then
				vI.stlCy = aI
				vI.stolen = {}
				W7()
				p7()
			end
		end
		vI.stlMark = function(aI)
			vI.stealCheck()
			if type(aI) ~= "string" then
				return
			elseif aI == "" then
				return
			elseif vI.stolen[aI] then
				return
			end
			vI.stolen[aI] = true
			pcall(writefile, vI.STL, O[6]:JSONEncode({ cy = vI.stlCy, n = vI.stolen }))
			W7()
			p7()
		end
		O[75] = (vI.STL:gsub("stolen", "place_" .. O[9].UserId))
		vI.PLF = O[75]
		lI, TI = pcall(function()
			local aI = C[20](readfile(vI.PLF))
			return O[6]:JSONDecode(C:QH(aI))
		end)
		vI.pl = lI and type(TI) == "table" and TI or {}
		if O[1].PlaceId == 107778070777162 then
			task.delay(25, function()
				if game.JobId == O[1].JobId then
					vI.pl.ok, vI.pl.go = true, nil
					pcall(writefile, vI.PLF, O[6]:JSONEncode(vI.pl))
					vI.anyP()
				end
			end)
		elseif vI.pl.go then
			if os.time() - vI.pl.go < 120 then
				vI.pl.ok, vI.pl.go = false, nil
				O[77] = pcall
				O[78] = writefile
				O[79] = vI.PLF
				O[76] = vI.pl
				O[77](O[78], O[79], O[6]:JSONEncode(O[76]))
			end
		end
		vI.anyP = function()
			qI.SAEFl = vI.pl.ok == true and 1 or vI.pl.ok == false and 2 or nil
			if O[1].PlaceId == 107778070777162 then
				return true
			end
			if vI.pl.ok == false then
				return false
			elseif qI.SAEFlSrv == 2 then
				return false
			end
			return vI.pl.ok == true or qI.SAEFlSrv == 1
		end
		vI.anyP()
		pcall(function()
			local TI = O[3].Packages.Networking:FindFirstChild("RE/EggWorld/FieldEggRedeemVerdict")
			if TI then
				WI(TI.OnClientEvent, function(TI)
					if type(TI) ~= "table" then
						return
					end
					local lI
					pcall(function()
						local aI = require(O[3].Data.Assets).Directory[TI.AssetCategory]
						lI = aI and aI.DisplayName
					end)
					local aI, xI =
						vI.stlMark, lI or (type(TI.DisplayName) == "string" and TI.DisplayName:gsub(" Egg$", "") or nil)
					aI(xI)
				end)
			end
		end)
		vI.hereCheck = function(TI)
			if TI < (vI.hereAt or 0) then
				return
			elseif II() then
				if vI.ws then
					if not (zI()) then
						return
					end
				else
					return
				end
			else
				return
			end
			vI.hereAt = TI + 3
			TI = d7()
			if EI() % TI >= TI - 15 then
				vI.hereIds = nil
				return
			end
			local lI, aI = l7(), false
			for xI, xI in ipairs(vI.eggs) do
				if mI(xI) and not xI.gone and (xI.at or 0) >= lI then
					aI = true
					break
				end
			end
			if not aI then
				return
			end
			local aI, xI, BI = {}, {}, false
			pcall(function()
				for d7, d7 in pairs(require(O[3].Client.EggState).ReadFieldEggs().Records) do
					if type(d7) == "table" then
						if d7.Uid then
							if d7.State ~= "Claimed" then
								aI[d7.Uid] = true
								xI[#xI + 1] = d7.Uid
							end
						end
					end
				end
			end)
			if #xI == 0 then
				return
			elseif #xI > 220 then
				return
			end
			lI = nil
			if vI.hereIds then
				for d7 in pairs(vI.hereIds) do
					if not aI[d7] then
						BI = true
						break
					end
				end
				lI = BI
			else
				lI = BI
			end
			BI = vI.hereIds
			if BI then
				TI = vI.hereSent
				lI = if TI then lI else not TI
			else
				lI = BI
			end
			vI.hereIds = aI
			if lI then
				vI.hereSent = true
				local TI = vI.ajSend
				local lI = {}
				lI.a = "h"
				lI.job = O[1].JobId
				lI.here = xI
				TI(lI)
			end
		end
		local function TI(lI, aI)
			local xI = {}
			for BI, d7 in ipairs(type(lI) == "table" and lI or {}) do
				BI = type(d7) == "table" and (d7.id or d7.uid or H(d7.name) .. H(d7.at))
				if BI then
					if not vI.seen[BI] then
						vI.seen[BI] = true
						xI[1] = vI
						xI[2] = (O[21](vI.last, o(d7.id) or 0))
						xI[1].last = xI[2]
						d7.value = o(d7.value) or 0
						if d7.jk then
							if not d7.jobId then
								d7.lk, d7.jobId = d7.jk, "#" .. H(d7.jh)
							end
						end
						vI.eggs[#vI.eggs + 1] = d7
						p7()
					end
				end
			end
			if not aI then
				lI = (EI() - 300) * 1000
				for aI = #vI.eggs, 1, -1 do
					if (vI.eggs[aI].at or 0) < lI then
						vI.seen[vI.eggs[aI].id or ""] = nil
						table.remove(vI.eggs, aI)
					end
				end
			end
			if #vI.eggs > 60 then
				local function lI(aI)
					return y7(aI) and KI(aI) <= 300 and 1 or 0
				end
				table.sort(vI.eggs, function(aI, xI)
					local BI, KI = lI(aI), lI(xI)
					if BI ~= KI then
						return BI > KI
					end
					return (aI.value or 0) > (xI.value or 0)
				end)
				for lI = 1, #vI.eggs - 60, 1 do
					vI.seen[table.remove(vI.eggs).id or ""] = nil
				end
			end
		end
		local function lI(aI)
			vI.who = vI.who or vI.sess and vI.sess.username
			O7()
			vI.sess = nil
			VI()
			n7()
			vI.auto = false
			table.clear(vI.eggs)
			table.clear(vI.seen)
			vI.last = 0
			vI.dirty = true
			vI.acct = aI
		end
		local aI
		local function xI(BI)
			if not aI then
				aI = {}
				pcall(function()
					local KI = {}
					local d7, y7, l7 =
						A(A(A(O[3], "Assets"), "UI"), "RarityGradients"), next, require(O[3].Data.Assets).Directory
					for E7, E7 in y7, l7, nil do
						if type(E7) == "table" then
							if E7.DisplayName then
								local y7, l7 = E7.Rarity, E7.Icon
								local F7, s7 = d7 and y7 and d7:FindFirstChild(H(y7._id or y7.DisplayName or "")), aI
								KI[1] = E7.DisplayName
								KI[2] = {}
								KI[2].icon = o(l7) and "rbxassetid://" .. l7 or type(l7) == "string" and l7 or ""
								KI[2].color = y7 and typeof(y7.Color) == "Color3" and y7.Color or O[23]
								KI[2].grad = F7 and (F7:IsA(x) and F7 or F7:FindFirstChildWhichIsA(x, true)) or nil
								KI[3] = KI[2]
								s7[KI[1]] = KI[3]
							end
						end
					end
				end)
			end
			local KI = aI[BI]
			if not KI then
				local aI = {}
				aI.icon = ""
				aI.color = O[23]
				KI = aI
			end
			local aI = KI
			return aI
		end
		local function aI(BI, KI, d7, y7, l7, E7, F7, s7, a7, J7, Y7, R7)
			local e7 = {}
			e7.Color = XI(0, O[12](BI, KI, d7), 1, O[12](y7, l7, E7))
			e7.Rotation = -90
			e7.Stroke = O[12](F7, s7, a7)
			e7.Light = O[12](J7, Y7, R7)
			return e7
		end
		local BI = {}
		BI.Hud = aI(255, 107, 2, 255, 238, 1, 60, 24, 0, 255, 222, 55)
		BI.Join = aI(22, 211, 22, 153, 255, 106, 8, 52, 8, 200, 255, 170)
		BI.Stop = aI(200, 15, 24, 255, 96, 96, 70, 6, 6, 255, 180, 180)
		BI.Off = aI(70, 76, 90, 128, 136, 152, 20, 22, 28, 190, 196, 210)
		BI.Blue = aI(41, 109, 211, 80, 217, 255, 10, 30, 70, 170, 225, 255)
		BI.Field = aI(78, 74, 100, 52, 49, 70, 18, 16, 28, 128, 122, 150)
		BI.Knob = aI(255, 255, 255, 200, 205, 218, 34, 34, 46, 255, 255, 255)
		BI.HudVip = aI(106, 31, 208, 230, 120, 255, 40, 8, 70, 225, 170, 255)
		O[80] = (XI(0, O[12](255, 92, 30), 0.53, O[12](255, 184, 60), 1, O[12](236, 96, 24)))
		BI.Head = O[80]
		O[81] = (
			XI(
				0,
				O[12](196, 0, 255),
				0.5,
				O[12](206, 36, 255),
				0.72,
				O[12](232, 130, 255),
				0.88,
				O[12](204, 0, 255),
				1,
				O[12](150, 0, 240)
			)
		)
		BI.HeadVip = O[81]
		local aI = BI.Join
		local KI = BI.Blue
		local d7 = BI.Off
		local y7 = BI.Hud
		local function l7()
			return O[6]:GenerateGUID(false):gsub("-", ""):sub(1, 14)
		end
		local function E7(F7)
			local s7, a7 = pcall(F7.Clone, F7)
			if s7 then
				if not a7 then
					return nil
				end
			else
				return nil
			end
			for F7, F7 in ipairs(a7:GetDescendants()) do
				if F7:IsA("LuaSourceContainer") then
					F7:Destroy()
				end
			end
			return a7
		end
		local function F7(s7)
			s7.Name = l7()
			for a7, a7 in ipairs(s7:GetDescendants()) do
				a7.Name = l7()
			end
		end
		local function s7(a7)
			if not a7 then
				return nil
			end
			return {
				b = a7,
				g = pI(a7, x),
				k = A(a7, S),
				h = A(a7, "UIStrokeClr"),
				l = A(a7, "Label") or A(a7, "TextLabel"),
				Scale = A(a7, "PressScale") or A(a7, "BtnScale"),
			}
		end
		local function a7(J7, Y7)
			if J7 then
				if J7.Style == Y7 then
					return
				end
			else
				return
			end
			J7.Style = Y7
			if J7.g then
				J7.g.Color, J7.g.Rotation = Y7.Color, Y7.Rotation
			end
			if J7.k then
				J7.k.Color = Y7.Stroke
			end
			if J7.h then
				J7.h.Color = Y7.Light
			end
		end
		vI.mk = {}
		vI.mask = function(J7)
			local Y7 = vI.mk[J7]
			if Y7 then
				return Y7
			end
			local R7 = {}
			for e7, f7 in (J7 .. "<>"):gmatch("([^<]*)(<[^>]*>)") do
				R7[#R7 + 1] = e7:gsub("%a", "%0\226\128\139")
				if f7 ~= "<>" then
					R7[#R7 + 1] = f7
				end
			end
			Y7 = table.concat(R7)
			vI.mk[J7] = Y7
			return Y7
		end
		vI.setF = function(J7, Y7)
			local R7 = vI.tx and vI.tx[J7]
			if R7 then
				R7[1] = Y7
			end
			J7, Y7 = vI.sw and vI.sw[J7] or J7, vI.mask(Y7)
			J7.RichText = true
			if J7.Text ~= Y7 then
				J7.Text = Y7
			end
		end
		local function J7(Y7, R7)
			if type(R7) == "string" then
				local e7 = Z[20]
				if e7 then
					local e7 = Z[20]
					if e7.tr then
						local e7 = Z[20]
						R7 = e7.tr(R7)
					else
					end
				else
				end
			else
			end
			if vI.fakeV then
				if Y7 then
					return vI.setF(Y7, R7)
				end
			end
			if Y7 then
				if Y7.Text ~= R7 then
					Y7.Text = R7
				end
			end
		end
		local function Y7(R7, e7, f7)
			J7(R7.l, e7)
			a7(R7, f7)
		end
		local R7 = TweenInfo.new(0.16, O[11].EasingStyle.Quad, O[11].EasingDirection.Out)
		local function e7(f7)
			local Q7 = f7.Scale or O[10]("UIScale")
			Q7.Scale, Q7.Parent = 1, f7.b
			f7.Scale = Q7
			local u7 = { MouseEnter = 1.06, MouseLeave = 1, MouseButton1Down = 0.94, MouseButton1Up = 1.06 }
			for A7, h7 in next, u7, nil do
				WI(f7.b[A7], function()
					O[8]:Create(Q7, R7, { Scale = h7 }):Play()
				end)
			end
		end
		local function R7()
			pcall(function()
				local f7 = {}
				local Q7, u7 = O[10]("Sound"), O[2]("SoundService")
				Q7.SoundId, Q7.Volume, Q7.PlaybackSpeed =
					"rbxassetid://100671636189844", 3.4, 0.93 + math.random() * 0.13
				local A7 = A(u7, "Gameplay")
				if A7 then
					if A7:IsA("SoundGroup") then
						Q7.SoundGroup = A7
					end
				end
				f7[1] = gethui and gethui() or O[2]("CoreGui")
				Q7.Parent = f7[1]
				Q7:Play()
				O[2]("Debris"):AddItem(Q7, 3)
			end)
		end
		local function f7(Q7)
			pcall(Q7)
		end
		local function Q7(u7, A7)
			WI(u7.Activated, function()
				R7()
				f7(A7)
				p7()
			end)
		end
		local u7 = O[11].UserInputType
		local function A7(h7)
			return h7.UserInputType == u7.MouseButton1 or h7.UserInputType == u7.Touch
		end
		local h7, m7, k7, L7 = 2.3120369911193848, 556, setmetatable, { __mode = "k" }
		local g7, i7 = k7({}, L7), {}
		local function L7()
			local t7 = i7.panel and i7.panel.AbsoluteSize.X or 0
			local x7 = h7 * t7 / m7
			if t7 > 0 then
				for m7, t7 in pairs(g7) do
					if m7.Parent then
						m7.Thickness = t7 * x7
					end
				end
			end
		end
		local m7, t7 = gethui and gethui() or O[2]("CoreGui")
		local function x7()
			local S7 = pI(O[9], "PlayerGui")
			local H7, _7 = A(S7, "HUD"), A(S7, "ActivePets")
			local o7 = A(H7, "GameHUD")
			local B7, v7 = A(o7, "RightButtons"), A(o7, "LeftControls")
			local z7 = {
				Hud = H7,
				GameHud = o7,
				Column = B7,
				Left = v7,
				Shop = A(v7, "ShopBTN"),
				Index = A(v7, "IndexBTN"),
				Slow = A(v7, "Slowmode"),
				Eggs = A(B7, "EggsButton"),
				Pets = A(B7, "PetsButton"),
				ActivePets = _7,
				Growing = A(S7, "GrowingEggs"),
			}
			if H7 then
				if o7 then
					if B7 then
						if z7.Eggs then
							if z7.Pets then
								if z7.Shop then
									if z7.Index then
										if z7.Slow then
											if _7 then
												if A(_7, "Frame") then
													return z7
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
		local S7 = TweenInfo.new(0.3, O[11].EasingStyle.Back, O[11].EasingDirection.Out)
		local H7, _7, o7, B7 = TweenInfo.new(0.24, O[11].EasingStyle.Quad, O[11].EasingDirection.In), false
		local function v7(z7)
			local c7 = {}
			local D7 = t7.Column
			if D7 then
				if not D7.Parent then
					return
				end
			else
				return
			end
			if B7 then
				B7:Cancel()
			end
			local N7 = D7.Position
			c7[2] = O[8]
			c7[3] = D7
			c7[4] = z7 and H7 or S7
			c7[1] = {}
			c7[1].Position = O[14](N7.X.Scale, z7 and math.ceil(D7.AbsoluteSize.X * 1.03) or 0, N7.Y.Scale, N7.Y.Offset)
			c7[5] = (c7[2]:Create(c7[3], c7[4], c7[1]))
			B7 = c7[5]
			B7:Play()
		end
		local function B7()
			local z7, c7, D7 = ipairs, {}, t7.ActivePets
			C:EH(c7, 0, D7, t7.Growing)
			for N7, V7 in z7(c7) do
				if V7 and V7.Enabled then
					D7, N7 = A(V7, "Frame") and A(V7.Frame, "Close"), false
					if D7 then
						if getconnections then
							local z7 = N7
							for c7, c7 in ipairs(getconnections(D7.Activated)) do
								z7 = if pcall(function()
										c7:Fire()
									end)
									then true
									else z7
							end
							if not z7 then
								V7.Enabled = false
							end
						else
							V7.Enabled = false
						end
					else
						V7.Enabled = false
					end
				end
			end
		end
		local function z7()
			local c7 = i7.home
			local D7, N7 = c7.X.Scale, math.ceil(i7.panel.AbsoluteSize.X * 1.392)
			return O[14](D7, N7, c7.Y.Scale, c7.Y.Offset)
		end
		local function c7(D7)
			local N7 = {}
			if _7 then
				return
			elseif not i7.panel then
				return
			end
			_7 = true
			p7()
			if qI.ChilliStealPanelClose then
				pcall(qI.ChilliStealPanelClose, D7)
			end
			B7()
			v7(true)
			i7.gui.Enabled = true
			if o7 then
				o7:Cancel()
			end
			L7()
			if D7 then
				i7.panel.Position = i7.home
				return
			end
			i7.panel.Position = z7()
			N7[1] = (O[8]:Create(i7.panel, S7, { Position = i7.home }))
			o7 = N7[1]
			o7:Play()
		end
		local function S7(B7, D7)
			if _7 then
				if not i7.panel then
					return
				end
			else
				return
			end
			_7 = false
			if not B7 then
				v7(false)
			end
			if o7 then
				o7:Cancel()
			end
			if D7 then
				i7.gui.Enabled = false
				return
			end
			local B7 = O[8]:Create(i7.panel, H7, { Position = z7() })
			o7 = B7
			B7.Completed:Connect(function(H7)
				if H7 == O[11].PlaybackState.Completed then
					if o7 == B7 then
						if not _7 then
							i7.gui.Enabled = false
						end
					end
				end
			end)
			B7:Play()
		end
		qI.ChilliFinderPanelClose = S7
		qI.ChilliFinderPanelOpen = c7
		local function H7()
			local o7 = { "btn", "gui" }
			for B7, v7 in ipairs(o7) do
				B7 = i7[v7]
				if B7 then
					pcall(B7.Destroy, B7)
				end
			end
		end
		local function o7()
			local B7 = E7(t7.Shop)
			if not B7 then
				return false
			end
			MI(A(B7, "GamepadGlyph"))
			for v7 in pairs(B7:GetAttributes()) do
				B7:SetAttribute(v7, nil)
			end
			local v7 = s7(B7)
			B7.AutoLocalize = false
			for z7, z7 in ipairs(B7:GetDescendants()) do
				if z7:IsA("GuiObject") then
					z7.AutoLocalize = false
				end
			end
			local z7, D7 = A(B7, "txt"), Z[20]
			if D7 then
				local N7 = Z[20]
				N7.fbL = z7
			end
			J7(z7, "Finder")
			a7(v7, BI.Hud)
			z7 = i7
			z7.badge = A(B7, "AlertBadge")
			D7 = i7
			D7.badgeT = D7.badge and i7.badge:FindFirstChildWhichIsA("TextLabel", true)
			D7 = i7
			D7.bIcon = A(B7, "ImageLabel")
			if i7.bIcon then
				i7.bIcon.Image = A(t7.Eggs, "ImageLabel") and t7.Eggs.ImageLabel.Image or i7.bIcon.Image
			end
			D7 = i7
			D7.bIcon0 = D7.bIcon and i7.bIcon.Image
			B7.Position = t7.Shop.Position
			B7.Visible = false
			F7(B7)
			B7.Parent = t7.Left
			local function D7()
				if _7 then
					S7()
				else
					c7()
				end
				p7()
			end
			local c7, N7, V7, I7, j7, K7 = pI(B7, "UIScale") or O[10]("UIScale", B7), 0, 1, 22, "Rest"
			local function X7(U7)
				local G7, Cu, Ou = c7.Scale - V7, math.exp(-I7 * U7), N7
				local pu = (Ou + I7 * G7) * U7
				Ou, U7 = (G7 + pu) * Cu, N7
				N7 = (U7 - I7 * pu) * Cu
				if math.abs(Ou) < 5.0E-4 then
					if math.abs(N7) < 5.0E-4 then
						c7.Scale = V7
						if K7 then
							K7:Disconnect()
							K7 = nil
						end
					else
						c7.Scale = V7 + Ou
					end
				else
					c7.Scale = V7 + Ou
				end
			end
			WI(B7:GetPropertyChangedSignal("GuiState"), function()
				local c7 = {}
				local N7 = B7.GuiState
				local U7 = N7 == O[11].GuiState.Press and "Sunk"
					or N7 == O[11].GuiState.Hover and O[7].MouseEnabled and "Raised"
					or "Rest"
				if U7 == j7 then
					return
				end
				N7 = U7 == "Sunk" and 42 or j7 == "Sunk" and 26
				I7 = N7 or 22
				N7 = nil
				N7, j7 = U7 == "Sunk" and 0.94 or U7 == "Raised" and 1.07 or 1, U7
				V7 = N7
				if U7 == "Sunk" then
					R7()
				end
				if not K7 then
					c7[1] = (O[4].PreRender:Connect(X7))
					K7 = c7[1]
					wI[#wI + 1] = K7
				end
			end)
			WI(B7.Activated, function()
				f7(D7)
			end)
			z7 = i7
			z7.btn, z7.hp = B7, v7
			return true
		end
		local function B7()
			local v7 = i7.btn
			if not v7 then
				return
			end
			local z7 = A(t7.Hud, "TradmilHud")
			local c7 = A(z7, "LeftControls")
			local D7, N7, V7, I7, j7, K7 =
				A(c7, "ShopBTN"), A(c7, "SpeedMulti"), zI() and not qI.ChilliFinderHidden, t7.Shop, t7.Index, t7.Left
			if D7 then
				if N7 then
					if z7.Visible then
						if t7.GameHud.Visible then
						else
							I7, j7, K7 = D7, N7, c7
						end
					else
					end
				else
				end
			else
			end
			nI(v7, "Parent", K7)
			c7 = j7.Position - I7.Position
			nI(v7, "Position", I7.Position - O[14](0, 0, c7.Y.Scale, c7.Y.Offset))
			nI(v7, "AnchorPoint", I7.AnchorPoint)
			nI(v7, "Size", I7.Size)
			nI(v7, "Visible", V7)
			N7 = Z[20]
			if N7 then
				D7 = Z[20]
				if D7.fake then
					vI.fbFix(v7, K7)
				end
			end
		end
		local function v7()
			local z7 = i7.cS and qI.ChilliStealPanelFrame and qI.ChilliStealPanelFrame()
			if z7 then
				local c7, D7 = ipairs, C[20](z7:GetChildren())
				for N7, V7 in c7(C:QH(D7)) do
					if
						V7:IsA("GuiButton")
						and V7.AbsoluteSize.X > 0
						and V7.AbsoluteSize.X < z7.AbsoluteSize.X * 0.3
					then
						local z7, c7 = 0, ipairs
						N7 = C[20](V7:GetDescendants())
						for D7, D7 in c7(C:QH(N7)) do
							if D7:IsA(S) then
								z7 += 1
								if i7.cS[z7] then
									pcall(function()
										i7.cS[z7].StrokeSizingMode = D7.StrokeSizingMode
									end)
									i7.cS[z7].Thickness = D7.Thickness
								end
							else
							end
						end
						break
					end
				end
			end
		end
		local function z7(c7)
			pcall(function()
				c7.Active = true
				c7.Interactable = true
			end)
			for D7, D7 in ipairs(c7:GetDescendants()) do
				if D7:IsA("GuiObject") then
					D7.Active = false
				end
			end
		end
		local function c7()
			local D7 = {}
			local N7 = t7.ActivePets.Frame
			local V7 = pI(N7, S)
			local I7, j7 = V7 and V7.Thickness or h7, E7(N7)
			if not j7 then
				return false
			end
			local E7, h7, K7 = A(j7, "Header"), A(j7, "ScrollingFrame"), A(j7, "Close")
			V7 = A(h7, "Template")
			local X7 = A(V7, "Spacer")
			local U7 = X7 and (X7:FindFirstChild("Unequip", true))
			if U7 and U7.Parent ~= X7 then
				local G7 = U7.Parent
				U7.Parent = X7
				U7.AnchorPoint = R
				G7:Destroy()
			end
			local G7 = A(X7, "TextLabel")
			if E7 and h7 and K7 and X7 then
				if U7 then
					if not G7 then
						j7:Destroy()
						return false
					end
				else
					j7:Destroy()
					return false
				end
			else
				j7:Destroy()
				return false
			end
			for Cu, Cu in ipairs(h7:GetChildren()) do
				if Cu ~= V7 then
					if Cu:IsA("GuiObject") then
						Cu:Destroy()
					end
				end
			end
			MI(A(j7, "EquipBest"))
			local Cu = pI(j7, t)
			local Ou, pu = Cu and Cu.AspectRatio or 1.25, O[7].MouseEnabled
			local Mu = not pu
			local Zu, nu, du =
				(if pu then Mu else 1.2) or 1,
				(if pu then Mu else 1.15) or 1,
				PI and qI.ChilliStealPanelFrame and qI.ChilliStealPanelFrame()
			Mu = du and (pI(du, t))
			pu = Mu and Mu.AspectRatio or 0.86 / nu
			local qu = pu / Ou
			D7[1] = Mu and du.Size or O[16](0.3 * Zu, 0.62 * Zu * nu)
			j7.Size = D7[1]
			Cu = Cu or (O[10](t, j7))
			D7[2] = O[11].AspectType.FitWithinMaxSize
			Cu.AspectRatio = pu
			Cu.AspectType = D7[2]
			local function Cu(Pu, ru)
				return O[14](Pu.X, O[15](Pu.Y.Scale * ru, Pu.Y.Offset))
			end
			E7.Size, E7.Position, K7.Size = Cu(E7.Size, qu), Cu(E7.Position, qu), Cu(K7.Size, qu)
			du, Ou, Zu = h7.Size.Y.Scale, h7.Position.Y.Scale, h7.AnchorPoint.Y
			local Pu, ru, wu, bu, Tu =
				(Ou - du * Zu) * qu, 1 - (1 - (Ou + du * (1 - Zu))) * qu, 0.115 * qu, 0.02 * qu, 0.06 * qu
			pu = V(I(Y, 0.5, Pu + bu, 0.92, wu), j7)
			X(pu, 0.02)
			local function yu(lu, Wu, Eu)
				local Fu = s7(v(U7:Clone(), lu, Wu))
				a7(Fu, Eu)
				Fu.l.Visible = false
				return Fu
			end
			local function lu(Wu, Eu, Fu, su, au, Ju, Yu)
				local Ru = {}
				local eu = s7(v(U7:Clone(), Wu, Eu))
				if su then
					Ru[1] = eu.l
					Ru[2] = (O[16](su, au))
					Ru[1].Size = Ru[2]
				end
				if Ju then
					J7(eu.l, Ju)
				end
				a7(eu, Fu)
				e7(eu)
				if Yu then
					Q7(eu.b, Yu)
				end
				return eu
			end
			Mu, Ou = {}, { "force", "min", "rar", "acct" }
			for Wu, Eu in ipairs(Ou) do
				D7[6] = s7
				D7[4] = v
				D7[5] = U7:Clone()
				D7[3] = {}
				D7[3].a = s
				D7[3].s = O[16](0.235, 1)
				D7[3].o = Wu
				nu = (D7[6](D7[4](D7[5], D7[3], pu)))
				v(nu.l, I(s, 0.5, 0.68, 0.88, 0.52))
				D7[8] = v
				D7[9] = nu.l:Clone()
				D7[7] = {}
				D7[7].p = O[16](0.5, 0.25)
				D7[7].s = O[16](0.88, 0.33)
				D7[10] = (D7[8](D7[9], D7[7], nu.b))
				nu.Cap = D7[10]
				Mu[Eu] = nu
			end
			local function Wu(Eu, Fu)
				local su = G7:Clone()
				MI(pI(su, x))
				return v(su, Eu, Fu)
			end
			local Eu = Pu + bu * 1.6 + wu
			local Fu = Wu(I(Y, 0.5, Eu, 0.9, Tu, { xa = k }), j7)
			pu = Pu + bu * 2.2 + wu + Tu
			Tu = { top = pu, st = Eu, bottom = ru, aY = Zu, gap = bu, sx = h7.Size.X, px = h7.Position.X }
			i7.geo = Tu
			local function su()
				local au = X7:Clone()
				for Ju, Ju in ipairs(au:GetChildren()) do
					if not (Ju:IsA(S)) then
						if not (Ju:IsA("UICorner")) then
							if not (Ju:IsA(x)) then
								Ju:Destroy()
							end
						end
					end
				end
				return au
			end
			local function au(Ju)
				return v(su(), I(Y, 0.5, Eu, 0.92, Ju * qu, { v = false }), j7)
			end
			local Eu = au(O[7].TouchEnabled and not O[7].KeyboardEnabled and 0.46 or 0.32)
			Pu = au(0.13)
			OI(O[16](0.21875, 0.64), O[16](0.025, 0), Pu)
			i7.opts = {}
			for Ju, Yu in ipairs(uI) do
				nu = lu({ o = Ju, v = true }, Pu, nil, 0.88, 0.64, Yu[1], function()
					hI.rar = Yu[2]
					HI()
					vI.drawer = nil
				end)
				D7[11] = (O[10]("UITextSizeConstraint", nu.l))
				D7[12] = Yu[2]
				nu.tc = D7[11]
				nu.v = D7[12]
				i7.opts[Ju] = nu
			end
			local function Ju(Yu, Ru, eu, fu, Qu, uu, Au, hu)
				local mu = {}
				local ku = au(0.13)
				local Lu = yu(I(R, 0.96, 0.5, 0.24, 0.66), ku, Yu)
				local gu = B
				local iu = I
				local tu = s
				local xu = {}
				xu.bt = 1
				xu.ff = Lu.l.FontFace
				xu.ts = true
				xu.tc = O[23]
				xu.z = Lu.l.ZIndex + 1
				local Su = gu("TextBox", iu(tu, 0.5, 0.5, 0.86, 0.7, xu), Lu.b)
				K(Su, 1, 0.3)
				local Lu = N
				local gu = I
				local iu = e
				local tu = {}
				tu.bc = O[12](30, 28, 42)
				local xu = Lu(gu(iu, 0.06, 0.5, 0.6, 0.3, tu), ku)
				j(xu, 0.3)
				K(xu, 2, 0.15, M)
				local Lu = N
				local gu = {}
				gu.bc = O[23]
				gu.s = O[16](0, 1)
				local iu = Lu(gu, xu)
				j(iu, 0.3)
				B(x, { Color = Yu.Color, r = Yu.Rotation }, iu)
				local Lu = yu
				local gu = {}
				gu.a = s
				gu.s = O[16](1.7, 1.7)
				gu.z = 5
				gu.Active = false
				local tu = Lu(gu, xu, BI.Knob).b
				local Lu = B
				local gu = t
				local Hu = {}
				Hu.AspectRatio = 0.55
				Hu.AspectType = O[11].AspectType.FitWithinMaxSize
				Hu.DominantAxis = O[11].DominantAxis.Height
				Lu(gu, Hu, tu)
				mu[2] = B
				mu[1] = {}
				mu[1].t = ""
				mu[1].bt = 1
				mu[1].p = O[16](0.02, 0)
				mu[1].s = O[16](0.68, 1)
				mu[1].z = 6
				Yu = (mu[2]("TextButton", mu[1], ku))
				local mu
				local function Lu(gu)
					local Hu = {}
					Hu[1] = iu
					Hu[2] = tu
					Hu[3] = (O[16](gu, 1))
					Hu[4] = (O[16](gu, 0.5))
					Hu[1].Size = Hu[3]
					Hu[2].Position = Hu[4]
				end
				local function gu(iu)
					local tu = O[22]((iu - xu.AbsolutePosition.X) / O[21](1, xu.AbsoluteSize.X), 0, 1)
					Lu(tu)
					iu = Qu(tu)
					if iu ~= hI[Ru] then
						hI[Ru] = iu
						J7(Su, uu(iu))
						J7(eu.l, uu(iu))
					end
				end
				WI(Yu.InputBegan, function(eu)
					if A7(eu) then
						mu = eu
						gu(eu.Position.X)
					end
				end)
				WI(O[7].InputChanged, function(eu)
					local Qu = mu
						and (eu == mu or mu.UserInputType == u7.MouseButton1 and eu.UserInputType == u7.MouseMovement)
					if Qu then
						gu(eu.Position.X)
					end
				end)
				WI(O[7].InputEnded, function(eu)
					local Qu = mu and (eu == mu or eu.UserInputType == u7.MouseButton1)
					if Qu then
						mu = nil
						Lu(fu(hI[Ru]))
						HI()
						p7()
					end
				end)
				WI(Su.FocusLost, function()
					local u7 = Au(Su.Text)
					if u7 then
						hI[Ru] = u7
						HI()
					else
						M7(hu)
					end
					Su.Text = uu(hI[Ru])
					p7()
				end)
				Yu = {
					f = ku,
					sync = function()
						if not mu then
							Lu(fu(hI[Ru]))
						end
						if not (Su:IsFocused()) then
							J7(Su, uu(hI[Ru]))
						end
					end,
				}
				return Yu
			end
			du = i7
			du.sl = {
				force = Ju(
					aI,
					"gap",
					Mu.force,
					function(u7)
						return u7 / 60
					end,
					function(u7)
						return O[20](u7 * 60 + 0.5)
					end,
					kI,
					function(u7)
						u7 = u7:lower():gsub("[%ss]", "")
						local Yu = u7 == "off" and 0 or o(u7)
						return Yu and O[22](O[20](Yu + 0.5), 0, 60)
					end,
					"Type seconds from 0 to 60, like 5"
				),
				min = Ju(
					KI,
					"min",
					Mu.min,
					function(u7)
						return O[22](math.log(u7 / 5000000000) / 5.298317366548036, 0, 1)
					end,
					function(u7)
						local Yu = 5000000000 * 200 ^ u7
						u7 = 10 ^ O[20](math.log10(Yu) - 1)
						return O[22](O[20](Yu / u7 + 0.5) * u7, 5000000000, 1000000000000)
					end,
					LI,
					function(u7)
						local Yu = tI(u7)
						return Yu and (O[21](5000000000, Yu))
					end,
					"Type a value like 50B or 1.5T (5B/s or more)"
				),
			}
			Ou = pI(E7, x)
			if Ou then
				Ou.Color = BI.Head
				Ou.Rotation = 0
			end
			i7.hg = Ou
			Ou = A(E7, "Title")
			J7(Ou, "Chilli Finder")
			if Ou then
				D7[13] = {}
				D7[13].edge = K(E7, 2, nil, O[23])
				Ju = D7[13]
				Ju.edge.Enabled = false
				D7[15] = B
				D7[16] = x
				D7[14] = {}
				D7[14].r = -11
				D7[14].Color = XI(0, O[12](225, 170, 255), 0.5, O[12](250, 225, 255), 1, O[12](190, 120, 255))
				D7[17] = (D7[15](D7[16], D7[14], Ju.edge))
				Ju.eg = D7[17]
				D7[19] = B
				D7[18] = {}
				D7[18].bt = 1
				D7[18].Image = "rbxassetid://100155632293857"
				D7[18].ImageColor3 = M
				D7[18].ScaleType = O[11].ScaleType.Stretch
				D7[18].a = s
				D7[18].z = O[21](1, Ou.ZIndex - 1)
				D7[18].v = false
				D7[20] = (D7[19]("ImageLabel", D7[18], Ou.Parent))
				Ju.ink = D7[20]
				i7.glx = Ju
			end
			local function tI(XI)
				if II() then
					return false
				end
				if vI.who then
					M7("No active booking. Book hours at chillihub.pro")
				else
					vI.drawer = "sign"
					M7(XI)
				end
				return true
			end
			du = s7(A(E7, "PlusEquip"))
			if du then
				Ju = du.b
				v(Ju, I(s, 0.85, 0.5, 0.24, 0.5))
				D7[21] = du.l
				D7[22] = (O[16](0.84, 0.62))
				D7[21].Size = D7[22]
				e7(du)
				local XI, u7, Yu = E7.AnchorPoint, E7.Size, E7.Position
				D7[26] = s7
				D7[24] = v
				D7[25] = Ju:Clone()
				D7[23] = {}
				D7[23].a = O[13](1, 1)
				D7[23].v = false
				D7[23].z = E7.ZIndex - 1
				D7[23].p = O[16](
					Yu.X.Scale + u7.X.Scale * (1 - XI.X) - u7.X.Scale * 0.03,
					Yu.Y.Scale - u7.Y.Scale * XI.Y + u7.Y.Scale * 0.24
				)
				D7[23].s = O[16](u7.X.Scale * 0.29, u7.Y.Scale * 0.8)
				wu = (D7[26](D7[24](D7[25], D7[23], j7)))
				v(wu.l, I(s, 0.5, 0.35, 0.88, 0.4, { rt = true }))
				a7(wu, y7)
				e7(wu)
				Q7(wu.b, function()
					if II() then
						hI.list = (hI.list + 1) % 3
						HI()
						W7()
					end
				end)
				z7(wu.b)
				i7.lb = wu
				z7(Ju)
				local XI = 0
				D7[30] = s7
				D7[28] = v
				D7[29] = wu.b:Clone()
				D7[27] = {}
				D7[27].p = O[16](wu.b.Position.X.Scale - wu.b.Size.X.Scale * 1.12, wu.b.Position.Y.Scale)
				D7[27].s = O[16](wu.b.Size.X.Scale * 0.68, wu.b.Size.Y.Scale)
				local u7 = D7[30](D7[28](D7[29], D7[27], j7))
				J7(u7.l, "Blacklist Only")
				a7(u7, hI.bl and y7 or d7)
				e7(u7)
				Q7(u7.b, function()
					if II() then
						local Yu = hI.bl
						hI.bl = if Yu then nil else not Yu
						a7(u7, hI.bl and y7 or d7)
						HI()
						W7()
					end
				end)
				z7(u7.b)
				i7.bl = u7
				local function u7()
					local z7 = {}
					if O[19]() - XI < 0.25 then
						return
					end
					z7[1] = (O[19]())
					XI = z7[1]
					R7()
					if tI("Sign in with your chillihub.pro account to use Auto Join") then
						if not vI.who then
							vI.view = nil
						end
						return
					end
					vI.auto = not vI.auto
					vI.autoAt = EI() * 1000
					W7()
					if not vI.auto then
						pcall(function()
							O[5]:SetTeleportSetting("__ChilliFinderAuto", false)
						end)
					end
					p7()
				end
				WI(Ju.Activated, u7)
				WI(Ju.InputBegan, function(XI)
					if A7(XI) then
						u7()
					end
				end)
			end
			for XI, XI in ipairs(K7:GetDescendants()) do
				if XI:IsA("ImageLabel") then
					XI:Destroy()
				elseif XI:IsA("ImageButton") then
					XI:Destroy()
				end
			end
			wu = s7(K7)
			if wu.l then
				if wu.l:IsA("TextLabel") then
					v(wu.l, { v = true, rt = false, t = ">" })
				end
			end
			e7(wu)
			Q7(K7, S7)
			E7 = A(X7, "Icon")
			if E7 then
				v(E7, I(s, 0.09, 0.5, 0.15, 1.3))
			end
			D7[32] = v
			D7[33] = G7
			D7[31] = {}
			D7[31].a = e
			D7[31].xa = g
			D7[31].s = O[16](0.5, 0.4)
			D7[31].p = O[16](0.18, 0.3)
			D7[32](D7[33], D7[31])
			if not (pI(G7, x)) then
				O[10](x, G7)
			end
			D7[35] = v
			D7[36] = G7:Clone()
			D7[34] = {}
			D7[34].Name = "Value"
			D7[34].s = O[16](0.5, 0.36)
			D7[34].p = O[16](0.18, 0.72)
			wu = (D7[35](D7[36], D7[34], X7))
			pI(wu, x):Destroy()
			wu.RichText = true
			v(U7, I(R, 0.975, 0.5, 0.2, 0.7))
			D7[37] = s7(U7).l
			D7[38] = (O[16](0.8, 0.56))
			D7[37].Size = D7[38]
			MI(A(X7, "Btns"))
			V7.Size = Cu(V7.Size, 0.48)
			V7.Visible = false
			V7.Parent = nil
			i7.cards = {}
			for MI = 1, 30, 1 do
				Cu = v(V7:Clone(), { v = false, o = MI }, h7)
				local XI, R7 = A(Cu, "Spacer"), { f = Cu }
				R7.icon = A(XI, "Icon")
				R7.name = A(XI, "TextLabel")
				R7.val = A(XI, "Value")
				R7.b = s7(A(XI, "Unequip"))
				if R7.icon then
					D7[42] = B
					D7[40] = I
					D7[41] = s
					D7[39] = {}
					D7[39].bt = 1
					D7[39].t = "GONE"
					D7[39].tc = O[12](255, 62, 62)
					D7[39].ts = true
					D7[39].z = R7.icon.ZIndex + 1
					D7[39].v = false
					D7[39].ff = R7.name.FontFace
					Ju = (D7[42]("TextLabel", D7[40](D7[41], 0.5, 0.5, 0.92, 0.22, D7[39]), R7.icon))
					E7 = (pI(R7.name, S))
					E7 = E7 and E7:Clone() or O[10](S)
					D7[43] = (O[12](45, 8, 12))
					E7.Color = D7[43]
					E7.Parent = Ju
					R7.gone = Ju
				end
				R7.ng = pI(R7.name, x)
				D7[45] = v
				D7[46] = R7.name
				D7[44] = {}
				D7[44].ts = false
				D7[44].tt = O[11].TextTruncate.AtEnd
				D7[44].s = O[16](0.585, 0.4)
				D7[45](D7[46], D7[44])
				D7[48] = v
				D7[49] = R7.val:Clone()
				D7[47] = {}
				D7[47].rt = false
				D7[47].ts = false
				D7[47].a = O[13](0.5, 1)
				D7[47].p = O[16](0.09, 0.97)
				D7[47].s = O[16](0, 0.3)
				D7[47].AutomaticSize = O[11].AutomaticSize.X
				D7[47].xa = k
				D7[47].z = R7.icon and R7.icon.ZIndex + 1 or R7.val.ZIndex
				D7[47].v = false
				D7[50] = (D7[48](D7[49], D7[47], XI))
				R7.mh = D7[50]
				D7[51] = (O[10](x, R7.mh))
				R7.mg = D7[51]
				e7(R7.b)
				Q7(R7.b.b, function()
					local A = R7.e
					if not A then
						return
					end
					if tI("Sign in with your chillihub.pro account to join") then
						return
					end
					if Z7 and Z7.e == A then
						n7("Stopped")
					elseif A.gone == true then
						M7("This egg is gone")
					elseif T7(A) then
						M7("This egg is gone")
					else
						b7(A)
					end
				end)
				i7.cards[MI] = R7
			end
			Cu, wu = i7.cards[1], Tu.bottom - Tu.top
			nu = V7.Size.Y.Scale * wu * 0.72
			D7[53] = v
			D7[54] = au(nu / qu)
			D7[52] = {}
			D7[52].a = O[13](0.5, 1)
			D7[52].p = O[16](0.5, Tu.bottom)
			D7[52].v = true
			Ju = (D7[53](D7[54], D7[52]))
			Tu.bottom = Tu.bottom - nu - bu
			E7 = Tu.bottom - Tu.top
			h7.Size, h7.Position = ZI(Tu.sx, E7), ZI(Tu.px, Tu.top + E7 * Zu)
			V7.Size = ZI(V7.Size.X, 0.2)
			Zu = i7
			for A, A in ipairs(Zu.cards) do
				A.f.Size = V7.Size
			end
			Zu = i7
			Zu.foot, Tu.bFull, Tu.bFoot, Tu.cFull = Ju, Tu.bottom + nu + bu, Tu.bottom, 0.2 * E7 / wu
			D7[60] = v
			D7[58] = v
			D7[59] = Cu.name:Clone()
			D7[56] = I
			D7[57] = e
			D7[55] = {}
			D7[55].t = YI
			D7[55].ts = true
			D7[55].tt = O[11].TextTruncate.None
			D7[62] = D7[58](D7[59], D7[56](D7[57], 0.05, 0.32, 0.62, 0.4, D7[55]), Ju):FindFirstChildOfClass(x)
			D7[61] = {}
			D7[61].Color = O[18](O[23], O[12](225, 225, 235))
			D7[61].r = 90
			D7[60](D7[62], D7[61])
			v(
				Cu.val:Clone(),
				I(
					e,
					0.05,
					0.72,
					0.62,
					0.32,
					{ rt = true, ts = true, t = '<font color="#C8C2DC">Create your account and get Chilli Finder</font>' }
				),
				Ju
			)
			local function A(MI, tI, XI, b7)
				Q7(MI.b, function()
					local R7 = pcall(setclipboard, YI)
					J7(MI.l, R7 and "Copied!" or "chillihub.pro")
					M7(R7 and XI or b7)
					task.delay(2, function()
						J7(MI.l, tI)
					end)
				end)
			end
			A(
				lu(I(R, 0.97, 0.5, 0.27, 0.62), Ju, y7, 0.82, 0.56, "Copy Link"),
				"Copy Link",
				"chillihub.pro copied, paste it in your browser",
				"Open chillihub.pro in your browser"
			)
			local MI = V(I(Y, 0.5, pu, 0.9, ru - pu - 0.02, { v = false, z = 5 }), j7)
			D7[64] = B
			D7[63] = {}
			D7[63].Padding = O[15](PI and 0.022 or 0.018, 0)
			D7[63].SortOrder = m
			D7[63].HorizontalAlignment = Q
			D7[64]("UIListLayout", D7[63], MI)
			local YI = G7.FontFace
			local function tI(XI, b7)
				local R7 = V
				local u7 = {}
				u7.s = O[16](1, b7)
				u7.o = XI
				u7.z = 6
				local XI = R7(u7, MI)
				XI:SetAttribute("ac", true)
				return XI
			end
			local function XI(b7, R7, u7, A7, z7, X7)
				return lu(I(R, 1, 0.5, R7, 1, { o = b7, z = 7 }), X7, A7, 0.84, 0.6, u7, z7)
			end
			local function b7(R7, u7, A7)
				local z7 = tI(R7, PI and 0.085 or 0.07)
				Wu(I(e, 0.02, 0.5, 0.64, 0.62, { o = 0, xa = g, t = u7, z = 6 }), z7)
				return XI(0, 0.3, "", KI, A7, z7)
			end
			Ju = tI(9, 0)
			D7[65] = O[10]("UIFlexItem", Ju)
			D7[66] = O[11].UIFlexMode.Fill
			D7[65].FlexMode = D7[66]
			D7[68] = V
			D7[67] = {}
			D7[67].a = s
			D7[67].p = O[16](0.5, 0.5)
			D7[67].z = 6
			local tI = D7[68](D7[67], Ju)
			local function R7()
				local u7 = {}
				u7[1] = tI
				u7[2] = (O[14](1, 0, 0, MI.AbsoluteSize.Y * 0.095))
				u7[1].Size = u7[2]
			end
			R7()
			WI(MI:GetPropertyChangedSignal("AbsoluteSize"), R7)
			X(tI, 0.025)
			local function u7(A7, z7, X7, G7, Yu, Ru)
				local eu = {}
				A7.Active = false
				local fu = yu(A7, z7, BI.Field)
				eu[6] = B
				eu[2] = I
				eu[3] = e
				eu[4] = X7
				eu[5] = G7
				eu[1] = {}
				eu[1].bt = 1
				eu[1].ff = YI
				eu[1].ts = true
				eu[1].tc = O[23]
				eu[1].PlaceholderText = Yu
				eu[1].PlaceholderColor3 = O[12](196, 190, 214)
				eu[1].t = ""
				eu[1].ClearTextOnFocus = false
				eu[1].xa = g
				eu[1].z = fu.l.ZIndex + 1
				A7 = (eu[6]("TextBox", eu[2](eu[3], eu[4], 0.5, eu[5], 1, eu[1]), fu.b))
				eu[8] = B
				eu[7] = {}
				eu[7].PaddingTop = O[15](Ru, 0)
				eu[7].PaddingBottom = O[15](Ru, 0)
				eu[8]("UIPadding", eu[7], A7)
				K(A7, 1.2, 0.35)
				return A7
			end
			local function e(g, K)
				local A7, z7 = I(Y, 0.5, g, 0.92, 0.22), Eu
				return u7(A7, z7, 0.05, 0.9, K, 0.21)
			end
			local function g(K, A7, z7, X7)
				local G7, yu = I(Y, K, 0.73, 0.44, 0.22), Eu
				return lu(G7, yu, z7, 0.86, 0.82, A7, X7)
			end
			wu = i7
			wu.hint = v(Cu.val:Clone(), I(Y, 0.5, 0.04, 0.9, 0.15, { rt = true, ts = true, xa = k }), Eu)
			i7.hint0 =
				'<font color="#C8C2DC">Sign in with your </font><font color="#FFFFFF">chillihub.pro</font><font color="#C8C2DC"> account</font>'
			i7.hint.Text = i7.hint0
			local K = e(0.23, "Username or email")
			local A7 = e(0.48, "Password")
			K.Text = H(cI.u or "")
			local z7, X7, G7 = vI.sess and "" or H(cI.p or ""), false, false
			if cI.p then
				cI.p = nil
				NI(cI)
			end
			local function yu()
				X7 = true
				local Yu = A7
				Yu.Text = G7 and z7 or string.rep("*", #z7)
				Yu = A7
				Yu.CursorPosition = #z7 + 1
				X7 = false
			end
			yu()
			local function Yu()
				local Ru = {}
				WI(A7:GetPropertyChangedSignal("Text"), function()
					if X7 then
						return
					end
					local X7 = A7.Text
					if G7 then
						z7 = X7
					elseif #X7 > #z7 then
						z7 ..= X7:sub(#z7 + 1)
					elseif #X7 < #z7 then
						local eu = z7
						z7 = eu:sub(1, #X7)
					end
					if not G7 then
						yu()
					end
				end)
				local X7 = A7
				Ru[1] = (O[16](0.74, 1))
				X7.Size = Ru[1]
				local X7
				X7 = lu(I(R, 0.985, 0.5, 0.19, 0.78, { z = A7.ZIndex }), A7.Parent, d7, 0.84, 0.6, "Show", function()
					G7 = not G7
					Y7(X7, G7 and "Hide" or "Show", G7 and KI or d7)
					yu()
				end)
			end
			Yu()
			local function R(X7)
				local G7 = {}
				if not RI then
					return M7("This executor cannot send requests")
				end
				local Ru, eu
				if X7 then
					Ru = {}
					Ru.rt = cI.rt
					eu = Ru
				else
					local fu = K.Text:match("^%s*(.-)%s*$")
					if fu == "" then
						return M7("Enter your username or email")
					end
					if z7 == "" then
						return M7("Enter your password")
					end
					Ru, cI.u = { u = fu, p = z7 }, fu
					eu = Ru
				end
				G7[1] = (fI())
				G7[2] = (eI())
				G7[3] = (math.floor(EI() * 1000))
				G7[4] = O[9].UserId
				eu.hwid = G7[1]
				eu.hw2 = G7[2]
				eu.ts = G7[3]
				eu.rid = G7[4]
				if not X7 then
					vI.acct = "Signing in..."
				end
				task.spawn(function()
					local eI = pcall
					local fI = RI
					local RI = {}
					RI.Url = FI .. "joiner/login"
					RI.Method = "POST"
					RI.Headers = { ["Content-Type"] = "text/plain" }
					RI.Body = gI(O[6]:JSONEncode(eu), sI)
					local G7, Ru = eI(fI, RI)
					local RI = G7 and type(Ru) == "table" and iI(Ru.Body, sI)
					vI.dirty = true
					if not RI then
						if not X7 then
							vI.acct = "Could not reach chillihub.pro, try again"
						end
						return
					end
					if RI.rt == false then
						cI.rt = nil
						vI.who = nil
						NI(cI)
					end
					if RI.rt then
						Ru = cI
						Ru.rt = RI.rt
						NI(cI)
					end
					if not X7 then
						z7 = ""
						yu()
					end
					if not RI.ok then
						vI.acct = RI.error or "Sign in failed"
						if not X7 then
							vI.who = nil
						end
						return
					end
					vI.who = RI.username
					if not RI.active then
						Ru = RI.booking or {}
						vI.whoAt = os.clock() + math.clamp((Ru.startsInMs or 120000) / 1000 + 2, 5, 120)
						if vI.drawer == "sign" then
							vI.drawer = nil
						end
						vI.acct = Ru.state == "upcoming"
								and ("Hi %s, your %s booking starts in %d min"):format(
									RI.username,
									Ru.plan or "",
									(Ru.startsInMs or 0) // 60000
								)
							or ("Hi %s, no active booking. Book hours at chillihub.pro"):format(RI.username)
						return
					end
					O7()
					qI.ChilliFinderOwner = vI.me
					vI.sess = {
						token = RI.token,
						secret = RI.secret,
						plan = RI.plan,
						delayMs = RI.delayMs,
						endTs = RI.endTs,
						username = RI.username,
					}
					table.clear(vI.eggs)
					table.clear(vI.seen)
					vI.last = 0
					vI.wsAt = 0
					vI.acct = nil
					vI.view = nil
					vI.drawer = nil
					VI()
					if not X7 then
						vI.auto = false
						pcall(function()
							O[5]:SetTeleportSetting("__ChilliFinderAuto", false)
						end)
					end
				end)
			end
			WI(K.FocusLost, function(RI)
				if RI then
					A7:CaptureFocus()
				end
			end)
			WI(A7.FocusLost, function(RI)
				if RI then
					R()
				end
			end)
			g(0.26, "Sign In", aI, R)
			A(
				g(0.74, "Sign Up", y7),
				"Sign Up",
				"Link copied, open chillihub.pro in your browser to sign up",
				"Open chillihub.pro in your browser to sign up"
			)
			function i7.signFix()
				local RI = Eu
				local eI = au(O[7].TouchEnabled and not O[7].KeyboardEnabled and 0.46 or 0.32)
				local fI, NI, VI, X7 = K.Text, K, A7, "move"
				local G7, Ru = pcall(function()
					for eu, eu in ipairs(RI:GetChildren()) do
						if eu:IsA("TextLabel") then
							eu.Parent = eI
						end
					end
					Eu = eI
					i7.sib = eI
					X7 = "boxes"
					local eu, fu, Qu = e(0.23, vI.mask("Username or email")), vI.mask
					Qu, K = e(0.48, fu("Password")), eu
					A7 = Qu
					Qu, fu = i7, K
					fu.Text, Qu.user = fI, fu
					X7 = "wire"
					Yu()
					yu()
					WI(K.FocusLost, function(e)
						if e then
							A7:CaptureFocus()
						end
					end)
					WI(A7.FocusLost, function(e)
						if e then
							R()
						end
					end)
					X7 = "buttons"
					g(0.26, "Sign In", aI, R)
					A(
						g(0.74, "Sign Up", y7),
						"Sign Up",
						"Link copied, open chillihub.pro in your browser to sign up",
						"Open chillihub.pro in your browser to sign up"
					)
				end)
				if not G7 then
					for e, e in ipairs(eI:GetChildren()) do
						if e:IsA("TextLabel") then
							e.Parent = RI
						end
					end
					local e = i7
					Eu = RI
					i7.sib = RI
					K, A7 = NI, VI
					e.user = NI
					pcall(eI.Destroy, eI)
					error("signFix " .. X7 .. ": " .. tostring(Ru), 0)
				end
				vI.sgN, vI.sgOk, eI.Position = 0, true, RI.Position
				pcall(RI.Destroy, RI)
			end
			function vI.relogin()
				R(true)
			end
			if not vI.sess then
				if cI.rt then
					task.defer(R, true)
				elseif z7 ~= "" then
					task.defer(R)
				end
			end
			D7[69] = {}
			D7[69].info = {}
			D7[71] = Wu
			D7[70] = {}
			D7[70].a = Vector2.zero
			D7[70].p = O[14]()
			D7[70].s = O[16](1, 0.07)
			D7[70].o = -1
			D7[70].xa = k
			D7[70].t = ""
			D7[70].z = 6
			D7[69].head = D7[71](D7[70], MI)
			pu = D7[69]
			pu.head:SetAttribute("ac", true)
			D7[73] = v
			D7[74] = su()
			D7[72] = {}
			D7[72].a = Vector2.zero
			D7[72].p = O[14]()
			D7[72].s = O[16](1, 0.2)
			D7[72].o = 0
			D7[72].z = 6
			D7[72].v = true
			nu = (D7[73](D7[74], D7[72], MI))
			nu:SetAttribute("ac", true)
			OI(O[16](0.31, 0.42), O[16](0.02, 0.06), nu)
			R7 = { "PLAN", "TIME LEFT", "ENDS AT", "FEED", "DELAY", "FINDER" }
			for R, e in ipairs(R7) do
				Zu, wu, Tu = V({ o = R, z = 7 }, nu), Cu.val:Clone(), { rt = true, ts = true, xa = k, z = 8 }
				Tu.t = '<font color="#C8C2DC">' .. e .. "</font>"
				v(wu, I(Y, 0.5, 0, 1, 0.38, Tu), Zu)
				D7[76] = v
				D7[77] = Cu.name:Clone()
				D7[75] = {}
				D7[75].ts = true
				D7[75].tt = O[11].TextTruncate.None
				D7[75].a = O[13](0.5, 1)
				D7[75].p = O[16](0.5, 1)
				D7[75].s = O[16](1, 0.58)
				D7[75].xa = k
				D7[75].z = 8
				D7[75].t = ""
				E7 = (D7[76](D7[77], D7[75], Zu))
				pu.info[e] = { l = E7, g = pI(E7, x) }
			end
			local function R(e, A, k, g, K)
				local OI = b7(e, A, function() end)
				local e = OI.l
				local A = B
				local RI = {}
				RI.bt = 1
				RI.a = e.AnchorPoint
				RI.p = e.Position
				RI.s = e.Size
				RI.ff = YI
				RI.ts = true
				RI.tc = O[23]
				RI.TextTransparency = 1
				RI.t = ""
				RI.PlaceholderText = "0-" .. k .. "s"
				RI.z = e.ZIndex + 1
				local eI = A("TextBox", RI, e.Parent)
				WI(eI.Focused, function()
					eI.TextTransparency = 0
					e.Visible = false
				end)
				WI(eI.FocusLost, function()
					local A = {}
					local RI = eI.Text:lower():gsub("%s", "")
					local fI, NI = RI:match("^(%d*%.?%d+)([sm]?)$")
					local VI = RI == "off" and 0 or fI and o(fI) * (NI == "m" and 60 or 1)
					if VI then
						A[1] = hI
						A[2] = g
						A[3] = (O[22](O[20](VI + 0.5), 0, k))
						A[1][A[2]] = A[3]
						HI()
						W7()
					else
						M7(K)
					end
					eI.Text = ""
					eI.TextTransparency = 1
					e.Visible = true
					vI.dirty = true
				end)
				return OI
			end
			pu.age =
				R(3, "Max egg age for Auto Join", 300, "age", "Type seconds from 0 to 300, like 45 or 3m (0 = Off)")
			pu.night = R(4, "Skip joins before night", 60, "night", "Type seconds from 0 to 60, like 15 (0 = Off)")
			pu.hold = b7(5, "Wait if egg here matches filter", function()
				hI.hold = not hI.hold
				HI()
			end)
			pu.rel = (
				if PI
					then not PI
					else b7(6, "Auto load after join", function()
						hI.reload = not hI.reload
						HI()
					end)
			) or nil
			pu.stl = b7(7, "Skip stolen pets this cycle", function()
				hI.stl = not hI.stl
				HI()
				W7()
			end)
			XI(2, 0.31, "Sign Out", BI.Stop, function()
				cI.rt = nil
				z7 = ""
				yu()
				lI("Signed out")
				vI.who = nil
				vI.view = nil
			end, tI)
			XI(3, 0.31, "Back", d7, function()
				vI.view = nil
			end, tI)
			D7[79] = V
			D7[78] = {}
			D7[78].s = O[16](1, 0.99)
			D7[78].o = 20
			D7[78].z = 6
			D7[78].v = false
			local R = D7[79](D7[78], MI)
			R:SetAttribute("eg", true)
			local e = ""
			local A = u7(I(Vector2.zero, 0.005, 0, 0.6, 0.07), R, 0.06, 0.88, "Search eggs", 0.24)
			D7[81] = v
			D7[82] = Cu.val:Clone()
			D7[80] = {}
			D7[80].rt = true
			D7[80].ts = true
			D7[80].a = O[13](1, 0)
			D7[80].p = O[16](0.99, 0.012)
			D7[80].s = O[16](0.38, 0.048)
			D7[80].xa = O[11].TextXAlignment.Right
			D7[80].z = 8
			local k = D7[81](D7[82], D7[80], R)
			local function g(K, OI)
				local RI = V
				local V = {}
				V.p = O[16](0, K)
				V.s = O[16](1, OI)
				V.z = 6
				local K = RI(V, R)
				X(K, 0.014)
				return K
			end
			D7[85] = g(0.085, 0.068)
			D7[86] = g(0.9, 0.095)
			D7[84] = B
			D7[83] = {}
			D7[83].bt = 1
			D7[83].bs = 0
			D7[83].p = O[16](0, 0.168)
			D7[83].s = O[16](1, 0.72)
			D7[83].ScrollBarThickness = 4
			D7[83].ScrollBarImageColor3 = O[12](200, 190, 230)
			D7[83].CanvasSize = O[14]()
			D7[83].AutomaticCanvasSize = O[11].AutomaticSize.Y
			D7[83].ScrollingDirection = O[11].ScrollingDirection.Y
			D7[83].z = 7
			local V, K, OI = D7[85], D7[86], D7[84]("ScrollingFrame", D7[83], R)
			D7[88] = B
			D7[87] = {}
			D7[87].SortOrder = m
			D7[87].HorizontalAlignment = Q
			D7[87].CellPadding = O[17](6, 6)
			local R = D7[88]("UIGridLayout", D7[87], OI)
			D7[90] = B
			D7[89] = {}
			D7[89].PaddingTop = O[15](0, 4)
			D7[89].PaddingBottom = O[15](0, 6)
			D7[89].PaddingLeft = O[15](0, 4)
			D7[89].PaddingRight = O[15](0, 9)
			D7[90]("UIPadding", D7[89], OI)
			local function Q()
				local m = {}
				local RI = OI.AbsoluteSize.X - 13
				if RI > 40 then
					local eI = O[20]((RI - 18) / 4)
					m[1] = R
					m[2] = (O[17](eI, O[20](eI * 1.02)))
					m[1].CellSize = m[2]
				end
			end
			WI(OI:GetPropertyChangedSignal("AbsoluteSize"), Q)
			local R, m, RI, eI, fI =
				{},
				0,
				false,
				{},
				{ { "All", 0 }, { "Divine", 10 }, { "Eternal", 9 }, { "Secret", 8 }, { "Picked", -1 } }
			local function tI()
				local NI = {}
				local VI = #(hI.only or {})
				k.Text = VI > 0 and '<font color="#7CF25A">' .. VI .. " picked</font>"
					or '<font color="#C8C2DC">All eggs</font>'
				for k, u7 in ipairs(fI) do
					local A7, z7 = eI[k], m
					a7(A7, z7 == u7[2] and y7 or d7)
				end
				for k, u7 in ipairs(R) do
					VI, k = oI
					if VI then
						local A7 = oI
						k = A7[u7.n] == true
					else
						k = VI
					end
					local VI, A7 = u7.b, m == 0 or m == -1 and k
					local z7 = (A7 or u7.r == m) and (e == "" or u7.l:find(e, 1, true) ~= nil)
					VI.Visible = z7
					NI[1] = u7.st
					NI[2] = u7.st
					NI[3] = u7.st
					NI[4] = k and O[12](255, 204, 64) or u7.c
					NI[5] = k and 2.5 or 1.5
					NI[6] = k and 0 or 0.6
					NI[1].Color = NI[4]
					NI[2].Thickness = NI[5]
					NI[3].Transparency = NI[6]
					NI[7] = u7.b
					NI[8] = u7.dot
					NI[9] = k and O[12](48, 38, 22) or O[12](24, 21, 34)
					NI[10] = k == true
					NI[7].BackgroundColor3 = NI[9]
					NI[8].Visible = NI[10]
				end
			end
			for k, NI in ipairs(fI) do
				eI[k] = XI(k, 0.18, NI[1], d7, function()
					m = NI[2]
					tI()
					OI.CanvasPosition = Vector2.zero
				end, V)
				D7[91] = eI[k].l
				D7[92] = (O[16](0.86, 0.58))
				D7[91].Size = D7[92]
			end
			WI(A:GetPropertyChangedSignal("Text"), function()
				e = A.Text:lower():gsub("^%s+", ""):gsub("%s+$", "")
				tI()
				OI.CanvasPosition = Vector2.zero
			end)
			local function e()
				return type(hI.only) == "table" and hI.only or {}
			end
			local function A(k)
				hI.only = k
				r7()
				HI()
				W7()
				tI()
			end
			local function k()
				local eI = {}
				if RI then
					return
				end
				RI = true
				local RI = {}
				pcall(function()
					local fI = {}
					for HI, NI in next, require(O[3].Data.Assets).Directory, nil do
						HI = type(NI) == "table" and NI.Rarity
						local VI = HI and o(HI.Order or HI.Index or HI.Rank)
						if NI.DisplayName then
							if VI then
								if VI >= 8 then
									if not fI[NI.DisplayName] then
										fI[NI.DisplayName] = true
										RI[#RI + 1] = {
											n = NI.DisplayName,
											r = VI,
											rn = H(HI.DisplayName or HI._id or ""),
											v = o(NI.EarningRate) or 0,
										}
									end
								end
							end
						end
					end
				end)
				table.sort(RI, function(fI, HI)
					if fI.r ~= HI.r then
						return fI.r > HI.r
					end
					return fI.v > HI.v
				end)
				for fI, HI in ipairs(RI) do
					local RI = xI(HI.n)
					local NI = B
					local VI = {}
					VI.t = ""
					VI.AutoButtonColor = false
					VI.bc = O[12](24, 21, 34)
					VI.bt = 0.05
					VI.o = fI
					VI.z = 8
					local r7, u7 = RI, NI("TextButton", VI, OI)
					j(u7, 0.12)
					eI[2] = B
					eI[3] = S
					eI[1] = {}
					eI[1].ApplyStrokeMode = O[11].ApplyStrokeMode.Border
					fI = (eI[2](eI[3], eI[1], u7))
					eI[7] = B
					eI[5] = I
					eI[6] = Y
					eI[4] = {}
					eI[4].bt = 1
					eI[4].Image = r7.icon
					eI[4].ScaleType = O[11].ScaleType.Fit
					eI[4].z = 9
					eI[7]("ImageLabel", eI[5](eI[6], 0.5, 0.05, 0.72, 0.54, eI[4]), u7)
					eI[11] = B
					eI[9] = I
					eI[10] = Y
					eI[8] = {}
					eI[8].bt = 1
					eI[8].ff = YI
					eI[8].t = HI.n
					eI[8].ts = true
					eI[8].tc = O[23]
					eI[8].TextStrokeTransparency = 0.35
					eI[8].z = 9
					local OI = eI[11]("TextLabel", eI[9](eI[10], 0.5, 0.61, 0.92, 0.19, eI[8]), u7)
					eI[13] = B
					eI[14] = x
					eI[12] = {}
					eI[12].r = 90
					eI[12].Color = r7.grad and HI.r ~= 8 and r7.grad.Color
						or O[18](HI.r == 8 and O[12](225, 230, 240) or r7.color)
					eI[13](eI[14], eI[12], OI)
					eI[16] = v
					eI[17] = OI:Clone()
					eI[15] = {}
					eI[15].t = HI.rn:upper()
					eI[15].p = O[16](0.5, 0.82)
					eI[15].s = O[16](0.66, 0.12)
					eI[15].TextStrokeTransparency = 0.6
					eI[16](eI[17], eI[15], u7)
					eI[19] = N
					eI[18] = {}
					eI[18].bc = O[23]
					eI[18].a = O[13](1, 0)
					eI[18].p = O[16](0.95, 0.05)
					eI[18].s = O[16](0.2, 0.2)
					eI[18].z = 10
					eI[18].v = false
					OI = (eI[19](eI[18], u7))
					j(OI, 1)
					O[10](t, OI)
					eI[21] = B
					eI[22] = x
					eI[20] = {}
					eI[20].r = 90
					eI[20].Color = O[18](O[12](255, 222, 90), O[12](255, 150, 20))
					eI[21](eI[22], eI[20], OI)
					eI[24] = B
					eI[25] = S
					eI[23] = {}
					eI[23].Thickness = 1.5
					eI[23].Color = O[12](70, 40, 0)
					eI[24](eI[25], eI[23], OI)
					local YI = { { 0.36, 0.58, 0.3, 45 }, { 0.58, 0.48, 0.56, -50 } }
					for RI, RI in ipairs(YI) do
						eI[33] = j
						eI[32] = N
						eI[27] = I
						eI[28] = s
						eI[29] = RI[1]
						eI[30] = RI[2]
						eI[31] = RI[3]
						eI[26] = {}
						eI[26].bs = 0
						eI[26].bc = O[23]
						eI[26].r = RI[4]
						eI[26].z = 11
						eI[33](eI[32](eI[27](eI[28], eI[29], eI[30], eI[31], 0.14, eI[26]), OI), 1)
					end
					R[#R + 1] = { b = u7, st = fI, dot = OI, n = HI.n, l = HI.n:lower(), r = HI.r, c = r7.color }
					Q7(u7, function()
						local OI, YI = e(), HI.n
						local RI = table.find(OI, YI)
						if RI then
							table.remove(OI, RI)
						else
							OI[#OI + 1] = YI
						end
						A(OI)
					end)
				end
				Q()
			end
			XI(1, 0.3, "Select all", KI, function()
				local Q = e()
				for e, e in ipairs(R) do
					if e.b.Visible then
						if not (table.find(Q, e.n)) then
							Q[#Q + 1] = e.n
						end
					end
				end
				A(Q)
			end, K)
			XI(2, 0.3, "Clear", d7, function()
				A({})
			end, K)
			XI(3, 0.3, "Done", aI, function()
				vI.view = "ac"
			end, K)
			pu.only = b7(2, "Only these eggs", function()
				k()
				m = 0
				tI()
				vI.view = "eg"
			end)
			local function R(e)
				vI.drawer = vI.drawer ~= e and e or nil
				vI.view = nil
			end
			local function e()
				if jI() then
					vI.drawer, vI.view = nil, vI.view ~= "ac" and "ac" or nil
				else
					R("sign")
				end
			end
			i7.acctF = e
			for Q, A in next, Mu, nil do
				e7(A)
				Q7(A.b, Q == "acct" and e or function()
					R(Q)
				end)
			end
			if du then
				g = s7(du.b:Clone())
				Cu = g.b
				D7[93] = (O[16](0.1, 0.5))
				D7[94] = (O[16](0.665, 0.5))
				Cu.Size = D7[93]
				Cu.Position = D7[94]
				D7[95] = (pI(Cu, t) or O[10](t, Cu))
				D7[95].AspectRatio = 1
				g.l.Visible = false
				E7 = B(
					"ImageLabel",
					I(
						s,
						0.5,
						0.5,
						0.74,
						0.74,
						{ bt = 1, Image = "rbxasset://textures/ui/Settings/MenuBarIcons/GameSettingsTab.png", z = g.l.ZIndex
							+ 1 }
					),
					Cu
				)
				O[10](t, E7)
				V =
					{ { -2, 0 }, { 2, 0 }, { 0, -2 }, { 0, 2 }, { -1.5, -1.5 }, { 1.5, 1.5 }, { -1.5, 1.5 }, { 1.5, -1.5 } }
				for R, R in ipairs(V) do
					wu, R7 = E7:Clone(), { ImageColor3 = M, z = E7.ZIndex - 1 }
					D7[96] = (O[14](0.5, R[1], 0.5, R[2]))
					R7.p = D7[96]
					v(wu, R7, Cu)
				end
				a7(g, KI)
				e7(g)
				Q7(Cu, e)
				Cu.Parent = du.b.Parent
				i7.gear = g
			end
			Zu = au(0.1)
			X(Zu, 0.02)
			i7.rb = {}
			for R = 1, 5, 1 do
				i7.rb[R] = lu({ a = s, o = R, v = false }, Zu, nil, 0.9, 0.6, nil, function()
					vI.askRoom(R)
				end)
			end
			K, e, nu = i7, i7, Zu.Size.Y.Scale + bu
			K.rs = Zu
			e.rsH = nu
			D7[98] = N
			D7[97] = {}
			D7[97].bc = M
			D7[97].bt = 0.45
			D7[97].bs = 0
			D7[97].a = O[13](0.5, 1)
			D7[97].p = O[16](0.5, 1)
			D7[97].s = O[16](1, 1.14)
			D7[97].Active = true
			D7[97].v = false
			D7[97].z = 50
			Ju = (D7[98](D7[97], j7))
			D7[103] = v
			D7[104] = au(0.3)
			D7[100] = I
			D7[101] = s
			D7[102] = 0.3 * qu
			D7[99] = {}
			D7[99].v = true
			D7[99].bc = O[12](30, 28, 42)
			D7[99].bt = 0
			local R = D7[103](D7[104], D7[100](D7[101], 0.5, 0.54, 0.84, D7[102], D7[99]), Ju)
			local function Q(A, m)
				return v(Fu:Clone(), I(Y, 0.5, A, 0.9, m, { TextWrapped = true, t = "" }), R)
			end
			nu, Cu, wu, e = i7, i7, Q(0.1, 0.24), Q(0.36, 0.28)
			nu.askT = wu
			Cu.askB = e
			local function Y(A, m, k, t)
				return lu(I(s, A, 0.8, 0.42, 0.26), R, k, 0.88, 0.6, m, t)
			end
			nu = i7
			nu.askC = Y(0.27, "Cancel", d7, function()
				vI.ask = nil
			end)
			Tu = i7
			Tu.askS = Y(0.73, "Switch", aI, function()
				local Y = vI.ask
				vI.ask = nil
				if Y then
					vI.setRoom(Y)
				end
			end)
			ru, Q, R7, bu, wu, Zu, V, E7, nu = i7, i7, i7, i7, i7, i7, i7, i7, i7
			i7.ask = Ju
			ru.B = Mu
			Q.V = pu
			R7.ov = MI
			bu.stat = Fu
			wu.scroll = h7
			Zu.title = Ou
			V.autoB = du
			E7.pk = Pu
			nu.sib = Eu
			E7, Zu, Ou = i7, i7, N7.Position
			E7.panel = j7
			Zu.home = Ou
			vI.tx = {}
			vI.txOn = nil
			vI.sgOk = nil
			for Y, Y in ipairs(j7:GetDescendants()) do
				if Y:IsA("TextLabel") or Y:IsA("TextButton") then
					if Y.Text ~= "" then
						vI.tx[Y] = { Y.Text, Y.Visible, Y.TextTransparency }
					end
				end
			end
			j7.Position = i7.home
			for Y, Y in ipairs(j7:GetDescendants()) do
				if Y:IsA(S) then
					if not (Y:GetAttribute("own")) then
						g, R7 = pcall(function()
							return Y.StrokeSizingMode
						end)
						if g then
							if R7 ~= O[11].StrokeSizingMode.ScaledSize then
								g7[Y] = Y.Thickness / I7
							end
						else
							g7[Y] = Y.Thickness / I7
						end
					end
				end
			end
			if PI then
				i7.cS = {}
				bu, Pu = ipairs, C[20](K7:GetDescendants())
				for Y, Y in bu(C:QH(Pu)) do
					if Y:IsA(S) then
						g7[Y] = nil
						i7.cS[#i7.cS + 1] = Y
					end
				end
			end
			F7(j7)
			U7 = U7:Clone()
			V7:Destroy()
			local Y = t7.ActivePets
			local R = O[10]("ScreenGui")
			R.Name, R.Archivable, R.ResetOnSpawn, R.IgnoreGuiInset, R.ZIndexBehavior, R.DisplayOrder =
				l7(), false, false, Y.IgnoreGuiInset, Y.ZIndexBehavior, Y.DisplayOrder
			R.Enabled = false
			pcall(function()
				R.ScreenInsets = Y.ScreenInsets
			end)
			i7.gui = R
			j7.Parent = R
			R.Parent = m7
			e = Z[20]
			if e then
				Q = Z[20]
				if Q.langRoot then
					nu = Z[20]
					nu.langRoot(R)
				end
			end
			WI(j7:GetPropertyChangedSignal("AbsoluteSize"), L7)
			Tu, K, ru = ipairs, {}, t7.ActivePets
			C:EH(K, 0, ru, t7.Growing)
			for Y, Y in Tu(K) do
				if Y then
					WI(Y:GetPropertyChangedSignal("Enabled"), function()
						if Y.Enabled then
							if _7 then
								S7(true)
							end
						end
					end)
				end
			end
			return true
		end
		local function Y(R)
			local e = {}
			if type(R) == "table" then
				if R.rooms ~= nil then
					e[1] = vI
					e[2] = vI
					e[3] = vI
					e[4] = R.rooms or nil
					e[5] = R.room
					e[6] = O[19]() + (o(R.roomNext) or 0) / 1000
					e[1].rooms = e[4]
					e[2].room = e[5]
					e[3].roomAt = e[6]
					vI.dirty = true
				end
			end
		end
		vI.setRoom = function(R)
			if R == vI.room then
				return
			elseif not vI.sess then
				return
			end
			local e = vI.sess
			task.spawn(function()
				local Q, A = pcall(O[1].HttpGet, O[1], FI .. "joiner/room?s=" .. e.token .. "&r=" .. R)
				local m = Q and iI(A, e.secret, true)
				if not m then
					return M7("Could not change room, try again")
				end
				Y(m)
				if not m.ok then
					vI.ask = R
					return
				end
				table.clear(vI.eggs)
				table.clear(vI.seen)
				vI.roomNew = true
				TI(m.eggs)
				W7()
				p7()
			end)
		end
		vI.askRoom = function(R)
			if R ~= vI.room then
				vI.ask = R
			end
		end
		local function R(e)
			local Q = i7
			for A, A in ipairs(Q.cards) do
				A.f.Size = ZI(A.f.Size.X, e)
			end
		end
		local function e(Q, A)
			Y7(Q, A and "ON" or "OFF", A and aI or d7)
		end
		vI.fakeG = function()
			local Q = O[19]()
			if Q < (vI.fgAt or 0) then
				return vI.fgV
			end
			vI.fgAt = Q + 5
			for Q in next, qI, nil do
				if type(Q) == "string" then
					if Q:find("^__ChilliV%d") then
						vI.fgV = true
						return true
					elseif Q == "__ChilliOrigQueue" then
						vI.fgV = true
						return true
					elseif Q == "__ChilliOnTpHooked" then
						vI.fgV = true
						return true
					elseif Q == "__ChilliBootQueuedSession" then
						vI.fgV = true
						return true
					end
				end
			end
			return vI.fgV
		end
		vI.guard = function()
			local Q, A = O[19](), i7.gui
			if A then
				if getconnections then
					if Q < (vI.gdAt or 0) then
						return
					end
				else
					return
				end
			else
				return
			end
			vI.gdAt = Q + 0.2
			local m, k = wI.own, false
			local function g(t)
				local V, I = pcall(getconnections, t)
				if V then
					for V, V in ipairs(I) do
						t = V.Function
						if t then
							if not m[t] then
								k = true
								pcall(V.Disable, V)
							end
						end
					end
				end
			end
			local function t(V)
				k = false
				g(V.Changed)
				g(V.AncestryChanged)
				g(V.ChildAdded)
				for I, I in ipairs(vI.gdP) do
					local K, X = pcall(V.GetPropertyChangedSignal, V, I)
					if K then
						g(X)
					end
				end
				V = k
				return V
			end
			local k, V, I = vI.gdL or {}, vI.gdH
			if V then
				I = V
			else
				local K, X = setmetatable, { __mode = "k" }
				I = K({}, X)
			end
			vI.gdL = k
			vI.gdH = I
			if vI.gdOn ~= A then
				vI.gdOn = A
				WI(A.DescendantAdded, function(K)
					vI.gdL[#vI.gdL + 1] = K
					if vI.junk(K) then
						task.defer(pcall, K.Destroy, K)
					end
				end)
				for K, K in ipairs(A:GetDescendants()) do
					if vI.junk(K) then
						pcall(K.Destroy, K)
					end
				end
				k = i7.title
				while k and k ~= A do
					vI.gdH[k] = true
					k = k.Parent
				end
				local K, X, OI, MI = ipairs, {}, i7.sib, i7.hint
				C:EH(X, 0, OI, MI, i7.user)
				for OI, OI in K(X) do
					vI.gdH[OI] = true
				end
			end
			g(A.DescendantAdded)
			g(A.ChildAdded)
			g(A.DescendantRemoving)
			g(A.AncestryChanged)
			g(A:GetPropertyChangedSignal("Enabled"))
			if #vI.gdL == 0 and Q >= (vI.gdW or 0) then
				vI.gdW = Q + 30
				for Q, Q in ipairs(A:GetDescendants()) do
					if Q:IsA("GuiObject") then
						vI.gdL[#vI.gdL + 1] = Q
					end
				end
			end
			for Q in next, vI.gdH, nil do
				if Q.Parent then
					t(Q)
				else
					vI.gdH[Q] = nil
				end
			end
			for Q = 1, 10, 1 do
				k = table.remove(vI.gdL)
				if not k then
					break
				end
				if vI.junk(k) then
					pcall(k.Destroy, k)
				elseif k.Parent then
					if t(k) then
						vI.gdH[k] = true
					end
				end
			end
			if i7.title then
				I, V = ipairs, i7.title
				for Q, Q in I(V:GetChildren()) do
					if Q:IsA("GuiObject") then
						pcall(Q.Destroy, Q)
					end
				end
			end
			A = qI.__ChilliV5State
			if type(A) == "table" then
				for Q, k in next, A, nil do
					if type(k) == "function" then
						if not m[k] then
							A[Q] = vI.nop
						end
					end
				end
			end
		end
		k7 = Z[20]
		if k7 then
			QI = Z[20]
			QI.fakeG = vI.fakeG
		end
		vI.fbFix = function(Q, A)
			local m, k =
				ipairs,
				{
					Q:GetPropertyChangedSignal("Visible"),
					Q:GetPropertyChangedSignal("Parent"),
					Q.Changed,
					Q.AncestryChanged,
				}
			for g, g in m(k) do
				local k, t = pcall(getconnections, g)
				if k then
					for k, k in ipairs(t) do
						if k.Enabled then
							if k.Function then
								if not wI.own[k.Function] then
									pcall(k.Disable, k)
								end
							end
						end
					end
				end
			end
			for k, k in ipairs(A:GetChildren()) do
				if k ~= Q then
					if k.Name:find("^ChilliFinder") then
						k:Destroy()
					end
				end
			end
			m = gethui and gethui()
			if m then
				for Q, Q in ipairs(m:GetChildren()) do
					if Q.Name:find("^ChilliGV") then
						Q:Destroy()
					end
				end
			end
		end
		vI.junk = function(Q)
			return Q.Name:sub(1, 6) == "Chilli"
		end
		vI.gdP = {
			"Text",
			"ContentText",
			"TextTransparency",
			"Visible",
			"TextColor3",
			"Size",
			"Position",
			"ImageTransparency",
			"BackgroundTransparency",
		}
		vI.nop = function() end
		vI.reclaim = function()
			if not vI.gdT then
				vI.gdT = true
				task.spawn(function()
					while true do
						local Q = rI and vI.fakeV
						if not Q then
							break
						end
						pcall(vI.guard)
						pcall(vI.reclaim)
						task.wait(0.2)
					end
					vI.gdT = nil
				end)
			end
			vI.sw = vI.sw or {}
			if i7.panel then
				if not i7.panel.Visible then
					i7.panel.Visible = true
				end
			end
			local Q, A = pairs, vI.tx or {}
			for m, k in Q(A) do
				local g = m.Parent
				if g then
					local t, V = vI.mask(k[1]), vI.sw[m]
					if V then
						if V.Parent ~= g then
							pcall(V.Destroy, V)
							vI.sw[m] = nil
							m.Text = ""
							V = nil
						else
						end
					else
					end
					if V then
					else
						m.RichText = true
						if vI.txOn then
							if m.Text ~= t then
								local I = m:Clone()
								I.Name = "t" .. math.random(1000000000)
								I.RichText = true
								I.Text = t
								I.Visible = true
								I.TextTransparency = 0
								for K, K in ipairs(I:GetChildren()) do
									if K:IsA("UIStroke") then
										K.Enabled = true
									end
								end
								for K, K in ipairs(m:GetChildren()) do
									if K:IsA("UIStroke") then
										K.Enabled = false
									end
								end
								I.Parent, vI.sw[m] = g, I
								V = I
							else
								if m.Text ~= t then
									m.Text = t
								end
							end
						else
							if m.Text ~= t then
								m.Text = t
							end
						end
						if not vI.txOn then
							m.Visible = k[2]
						end
						if m.TextTransparency ~= k[3] then
							m.TextTransparency = k[3]
						end
					end
					if V then
						if V.Text ~= t then
							V.Text = t
						end
						local k = m ~= i7.stat or m.Visible
						if V.Visible ~= k then
							V.Visible = k
						end
						if V.TextTransparency ~= 0 then
							V.TextTransparency = 0
						end
						if m.TextTransparency ~= 1 then
							m.TextTransparency = 1
						end
					end
				end
			end
			Q, A = i7.B.acct, os.clock()
			Q.par = Q.par or Q.b.Parent
			local m, k = vI.txOn
			if m then
				local g = Q.b.Visible
				k = if g then Q.b.Parent ~= Q.par else not g
			else
				k = m
			end
			if k and A >= (Q.at or 0) then
				local g, t = Q.b, Q.b:Clone()
				for V, I in pairs(Q) do
					if typeof(I) == "Instance" then
						if I ~= g then
							if I ~= Q.par then
								m = t:FindFirstChild(I.Name, true)
								Q[V], vI.tx[I] = m, nil
								if m then
									if m:IsA("TextLabel") then
										m.RichText = true
									end
								end
							end
						end
					end
				end
				t.Name, t.Visible, Q.b, Q.at = "b" .. math.random(1000000000), true, t, A + 1
				t.Parent = Q.par
				Q7(t, i7.acctF)
				pcall(g.Destroy, g)
			end
			if not Q.b.Visible then
				Q.b.Visible = true
			end
			if vI.drawer == "sign" then
				Q, m = ipairs, i7
				k = C[20](m.sib:GetDescendants())
				for g, t in Q(C:QH(k)) do
					if t:IsA("TextBox") then
						g = t
						while true do
							local k = g and g ~= i7.sib
							if not k then
								break
							end
							if g:IsA("GuiObject") then
								if not g.Visible then
									g.Visible = true
								end
							end
							if g:IsA("TextBox") then
								if g.TextTransparency > 0 then
									g.TextTransparency = 0
								end
							end
							g = g.Parent
						end
					end
				end
			end
			Q = vI.sgOk
			m = if Q then vI.drawer == "sign" and not i7.sib.Visible else not Q
			if m then
				if A >= (vI.sgAt or 0) then
					if (vI.sgN or 0) < 3 then
						vI.sgAt, vI.sgN = A + 2, (vI.sgN or 0) + 1
						i7.signFix()
					end
				end
			end
			vI.txOn = true
		end
		local function Q()
			local A = {}
			if not i7.panel then
				return
			end
			local m = i7.title and i7.title.ContentText
			if not vI.fakeV then
				local k = i7.vip
				local g, t = (if k then not k else m) and m ~= "" and m ~= "Chilli Finder"
				if g then
					t = g
				else
					k = Z[20]
					if k then
						local g = Z[20]
						t = g.fake
					else
						t = k
					end
				end
				if t then
					vI.fakeV = true
				elseif vI.fakeG() then
					vI.fakeV = true
				end
			end
			if vI.fakeV then
				local k, g = pcall(vI.reclaim)
				if not k then
					vI.rcE = g
				end
			end
			m = II()
			local k, g = m and (zI()), jI()
			local t = g and vI.view or nil
			local V = not t
			local I = (if t then V else vI.drawer ~= (g and "sign")) and vI.drawer or nil
			local K, X, OI, MI = I == "rar", i7.geo, i7.B, i7.V
			local PI = O[19]()
			i7.ov.Visible, i7.scroll.Visible, i7.sib.Visible, i7.pk.Visible, i7.stat.Visible =
				t ~= nil, t == nil, I == "sign", K, I == nil and V
			if I == "sign" then
				local YI = PI - vI.msgAt < 6 and vI.msg ~= "" and vI.msg or vI.acct
				J7(
					i7.hint,
					YI
							and '<font color="#FFD24A">' .. YI:gsub("[<>&]", ""):gsub(
								"chillihub%.pro",
								'<font color="#FFFFFF">chillihub.pro</font>'
							) .. "</font>"
						or i7.hint0
				)
			end
			local YI = i7
			for RI, eI in pairs(YI.sl) do
				eI.f.Visible = I == RI
				if I == RI then
					eI.sync()
				end
			end
			if K then
				local RI, eI = O[21](8, O[20](i7.pk.AbsoluteSize.Y * 0.4)), i7
				for fI, fI in ipairs(eI.opts) do
					fI.tc.MaxTextSize = RI
					a7(fI, fI.v == hI.rar and aI or KI)
				end
			end
			YI = m and H(vI.sess.plan or "") or false
			if i7.vip ~= YI then
				i7.vip = YI
				if i7.hg then
					i7.hg.Color = YI and BI.HeadVip or BI.Head
				end
				a7(i7.hp, YI and BI.HudVip or BI.Hud)
				local RI = i7.title
				if RI then
					local eI, fI, QI = pI(RI, x), pI(RI, S), i7
					QI.t0 = QI.t0 or { f = RI.FontFace, c = RI.TextColor3, p = RI.Position, s = fI and fI.Color }
					J7(RI, "Chilli Finder")
					A[1] = i7.t0.p
					A[2] = YI and Font.new("rbxasset://fonts/families/GothamSSm.json", O[11].FontWeight.Heavy)
						or i7.t0.f
					A[3] = YI and O[23] or i7.t0.c
					RI.Position = A[1]
					RI.FontFace = A[2]
					RI.TextColor3 = A[3]
					if eI then
						eI.Enabled = not YI
					end
					if fI then
						fI.Color = YI and M or i7.t0.s
					end
				end
			end
			if i7.foot.Visible == g then
				i7.foot.Visible, X.bottom = not g, g and X.bFull or X.bFoot
				R(g and X.cFull or 0.2)
			end
			YI = m and vI.rooms ~= nil
			local M = YI and i7.rsH or 0
			if i7.hr ~= YI then
				i7.hr = YI
				local RI = O[16](0.5, X.st + M)
				i7.stat.Position, i7.sib.Position, i7.pk.Position = RI, RI, RI
				local eI = i7
				for fI, fI in pairs(eI.sl) do
					fI.f.Position = RI
				end
				if g then
					R(X.cFull * (X.bottom - X.top) / (X.bottom - X.top - M))
				end
			end
			i7.rs.Visible = YI and V
			if YI then
				local R, RI = #vI.rooms, i7
				for eI, fI in ipairs(RI.rb) do
					V = vI.rooms[eI]
					fI.b.Visible = V ~= nil
					if V then
						A[4] = fI.b
						A[5] = (O[16]((0.94 - 0.02 * (R - 1)) / R, 0.72))
						A[4].Size = A[5]
						Y7(
							fI,
							("Room %d: %d %s"):format(eI, V, V == 1 and "user" or "users"),
							eI == vI.room and aI or KI
						)
					end
				end
			else
				vI.ask = nil
			end
			i7.ask.Visible = vI.ask ~= nil
			if vI.ask then
				V = math.ceil((vI.roomAt or 0) - PI)
				J7(i7.askT, V > 0 and "Switch cooldown" or ("Switch to Room %d?"):format(vI.ask))
				J7(
					i7.askB,
					V > 0 and ("You can switch again in %d:%02d."):format(V // 60, V % 60)
						or "You can only join new eggs after switching.\10Switch cooldown: 2 min."
				)
				J7(i7.askC.l, V > 0 and "OK" or "Cancel")
				A[6] = i7.askC.b
				A[7] = i7.askS.b
				A[8] = (O[16](V > 0 and 0.5 or 0.27, 0.8))
				A[9] = V <= 0
				A[6].Position = A[8]
				A[7].Visible = A[9]
			end
			YI = I and (I == "sign" and i7.sib or i7.pk).Size.Y.Scale or 0
			V = YI > 0 and X.st + M + YI + X.gap or X.top + M
			YI = ZI(X.sx, X.bottom - V)
			if i7.scroll.Size ~= YI then
				i7.scroll.Size, i7.scroll.Position = YI, ZI(X.px, V + (X.bottom - V) * X.aY)
			end
			X, YI = ipairs, i7.ov
			for R, R in X(YI:GetChildren()) do
				if R:IsA("GuiObject") then
					R.Visible = t ~= nil and R:GetAttribute(t) == true
				end
			end
			J7(OI.force.Cap, "FORCE JOIN")
			V, X, YI = OI.force, kI(hI.gap), I == "force" and y7 or hI.gap > 0 and aI
			Y7(V, X, YI or d7)
			J7(OI.min.Cap, "MIN VALUE")
			Y7(OI.min, LI(hI.min), I == "min" and y7 or KI)
			J7(OI.rar.Cap, "RARITY")
			Y7(OI.rar, uI[table.find(AI, hI.rar) or 1][1], K and y7 or KI)
			M = m and vI.sess.endTs / 1000 - EI() or 0
			J7(OI.acct.Cap, m and H(vI.sess.plan):upper() or "ACCOUNT")
			YI, X = OI.acct, m and ("%dh%02dm"):format(M // 3600, M % 3600 // 60) or g and "No plan"
			Y7(YI, X or I == "sign" and "Hide" or "Sign In", (I == "sign" or t) and d7 or y7)
			if i7.autoB then
				Y7(i7.autoB, vI.auto and "AUTO ON" or "AUTO OFF", vI.auto and aI or d7)
			end
			a7(i7.gear, (t == "ac" or I == "sign") and aI or KI)
			V = i7.stat
			YI = Z7
					and ("%s %s  |  try %d  |  %ds%s"):format(
						Z7.force and "Force joining" or "Joining",
						Z7.e.name,
						Z7.tries,
						O[21](0, Z7.stop - PI),
						Z7.why ~= "" and "  |  " .. Z7.why or ""
					)
				or PI - vI.msgAt < 6 and vI.msg ~= "" and vI.msg
			K, OI = YI
				or (if m
					then not m
					else vI.acct
						or (#vI.top > 0 and "Top 5 recent eggs" or "No big eggs right now")
							.. "  |  Book at chillihub.pro")
				or (if k then not k else "Paused: Finder runs in another script")
				or vI.auto and q7() and "Auto waits: night is close"
				or vI.auto and hI.hold and vI.hold and "Auto waits: an egg here matches your filter"
				or vI.newWait and "Waiting for new eggs to join"
			if K then
				OI = K
			else
				g, X, I =
					vI.ws and "Live" or "Connecting",
					#vI.top,
					vI.auto and (#(vI.pick or {}) > 0 and "  |  Auto joining" or "  |  Auto waits")
				OI = ("%s  |  %d eggs%s"):format(g, X, I or "")
			end
			J7(V, OI)
			if i7.lb then
				i7.lb.b.Visible = m == true
				J7(i7.lb.l, ({ [0] = "Matching Eggs", "Top Value", "Newest" })[hI.list])
			end
			if i7.bl then
				i7.bl.b.Visible = m == true
			end
			A[10] = i7.stat
			A[11] = Z7 and O[12](255, 196, 77) or O[23]
			A[10].TextColor3 = A[11]
			if t == "ac" then
				PI = m and vI.sess or { username = vI.who, endTs = EI() * 1000 }
				J7(MI.head, "Signed in as " .. H(PI.username or "?"))
				YI = (O[21](0, O[20](PI.endTs / 1000 - EI())))
				M = (O[12](255, 120, 110))
				X = (O[12](255, 200, 80))
				g = (O[12](124, 242, 90))
				local function R(ZI, RI, eI)
					local fI = {}
					local QI = MI.info[ZI]
					J7(QI.l, RI)
					fI[1] = QI.g
					fI[2] = (O[18](eI))
					fI[1].Color = fI[2]
					QI.g.Rotation = 90
				end
				R("PLAN", m and H(PI.plan or "?"):upper() or "NONE", m and O[12](255, 214, 90) or M)
				K = not m
				R(
					"TIME LEFT",
					(if m then K else "-")
						or YI >= 3600 and ("%dh %02dm"):format(YI // 3600, YI % 3600 // 60)
						or ("%dm %02ds"):format(YI // 60, YI % 60),
					YI < 600 and M or O[23]
				)
				R("ENDS AT", m and os.date("%H:%M", O[20](PI.endTs / 1000)) or "-", O[23])
				R("FEED", (if m then K else "Off") or vI.ws and "Live" or "Polling", vI.ws and g or X)
				R(
					"DELAY",
					(if m then K else "-") or (PI.delayMs or 0) > 0 and "+" .. PI.delayMs / 1000 .. "s" or "Instant",
					(PI.delayMs or 0) > 0 and X or g
				)
				R("FINDER", (if m then K else "-") or k and "Here" or "Other", k and g or M)
				V = #(hI.only or {})
				Y7(MI.only, V > 0 and V .. (V == 1 and " egg" or " eggs") or "All", V > 0 and y7 or KI)
				e(MI.hold, hI.hold)
				I, R =
					MI.age,
					hI.age > 0
						and (
							hI.age < 60 and hI.age .. "s"
							or hI.age // 60 .. "m" .. (hI.age % 60 > 0 and " " .. hI.age % 60 .. "s" or "")
						)
				Y7(I, R or "Off", hI.age > 0 and KI or d7)
				Y7(MI.night, hI.night > 0 and hI.night .. "s" or "Off", hI.night > 0 and KI or d7)
				if MI.rel then
					e(MI.rel, hI.reload)
				end
				e(MI.stl, hI.stl)
			end
			OI, V = ipairs, i7.cards
			for R, e in OI(V) do
				X = _7 and t == nil and vI.top[R] or nil
				e.e = X
				nI(e.f, "Visible", X ~= nil)
				if X then
					g = e.f.AbsoluteSize.Y
					if e.ek ~= X or e.eh ~= g then
						e.ek = X
						e.eh = g
						R, I = xI(X.name), H(X.mutation or "")
						if e.icon then
							nI(e.icon, "Image", R.icon)
						end
						YI = I:match("^%s*([^,]-)%s*,") or I:match("^%s*(.-)%s*$")
						A[14] = YI ~= ""
						if A[14] then
							A[13] = UI[YI]
							if not A[13] then
								A[12] = {}
								C:EH(A[12], 0, YI, O[12](225, 225, 235))
								A[13] = A[12]
							end
							A[14] = A[13]
						end
						K = A[14] or nil
						nI(e.name, "TextSize", O[21](8, O[20](g * 0.33)))
						e.mh.Visible = K ~= nil
						if K then
							if e.mk ~= YI then
								e.mk = YI
								J7(e.mh, K[1])
								A[15] = e.mg
								A[16] = K[2] and O[18](K[2]) or GI
								A[15].Color = A[16]
							end
						end
						J7(e.name, H(X.name))
						nI(e.mh, "TextSize", O[21](7, O[20](g * 0.2)))
						if e.nk ~= X.name then
							e.nk = X.name
							PI = X.rarity == 8
							A[17] = e.ng
							A[18] = R.grad and not PI and R.grad.Color or O[18](PI and O[12](220, 226, 236) or R.color)
							A[17].Color = A[18]
							e.ng.Rotation = R.grad and R.grad.Rotation or 90
						end
					end
					M = m and (X.gone == true or T7(X)) or false
					if e.gone then
						if e.gone.Visible ~= M then
							e.gone.Visible = M
							e.icon.ImageTransparency = M and 0.5 or 0
						end
					end
					local R = H(X.valueText or "")
					J7(
						e.val,
						'<font color="#7CF25A">$'
							.. (R ~= "" and R or H(X.value))
							.. "</font>"
							.. ((o(X.size) or 0) > 0 and ('  <font color="#FFD24A">x%.2f</font>'):format(X.size) or "")
							.. (m and (X.pm or 0) > 0 and ('  <font color="#9FD1FF">%d/%d</font>'):format(
								X.pc or 0,
								X.pm
							) or "")
							.. '  <font color="#B8B4C8">'
							.. C7(X)
							.. "</font>"
					)
					local A, g, t = Z7 and Z7.e == X, mI(X), k and X.jobId and not (hI.bl and X.placeId ~= w7)
					local k, V = e.b, A and "Stop" or g and "Here"
					R = V
						or M and "Gone"
						or (if m then t else not m) and "Join"
						or hI.bl and X.placeId ~= w7 and "Normal"
					local e, V = R or "Locked", A and BI.Stop or (g or M) and d7
					Y7(
						k,
						e,
						V
							or (if m then not m else y7)
							or t and (hI.list > 0 and not (vI.pickSet or {})[X] and KI or aI)
							or d7
					)
				end
			end
			if i7.badge then
				OI = m and #(vI.pick or {}) or 0
				i7.badge.Visible = OI > 0
				if i7.bIcon then
					nI(i7.bIcon, "Image", vI.top[1] and xI(vI.top[1].name).icon or i7.bIcon0)
				end
				J7(i7.badgeT, OI > 99 and "99+" or H(OI))
			end
		end
		local function M()
			if vI.ws then
				return
			elseif vI.wsP then
				return
			elseif vI.wsC then
				return
			elseif os.clock() < vI.wsAt then
				return
			elseif II() then
				if not (zI()) then
					return
				end
			else
				return
			end
			vI.wsAt = os.clock() + 3
			local R = WebSocket and (WebSocket.connect or WebSocket.new)
				or syn and syn.websocket and syn.websocket.connect
			if not R then
				return
			end
			vI.wsC = true
			task.spawn(function()
				local e, A = pcall(R, "wss://chillihub.pro/roblox-mcp/eggws")
				vI.wsC = nil
				if e then
					if not A then
						return
					end
				else
					return
				end
				local R = vI.sess
				local e, m = A.OnMessage or A.MessageReceived, A.OnClose or A.Closed
				if not (rI and R and e) then
					pcall(function()
						A:Close()
					end)
					return
				end
				e:Connect(function(e)
					vI.wsMsg = os.clock()
					if vI.wsP == A then
						vI.wsP = nil
						vI.ws = A
						vI.dirty = true
					end
					if #vI.inbox < 200 then
						vI.inbox[#vI.inbox + 1] = { e, R.secret }
					end
				end)
				if m then
					m:Connect(function()
						if vI.wsP == A then
							vI.wsP = nil
						end
						if vI.ws == A then
							vI.ws = nil
							vI.aj = nil
							vI.ajKey = nil
							vI.dirty = true
						end
					end)
				end
				pcall(function()
					local e = A
					local m = gI
					local k = O[6]
					local g = {}
					g.session = R.token
					g.ts = math.floor(EI() * 1000)
					g.lk = 1
					g.rid = O[9].UserId
					e:Send(m(k:JSONEncode(g), sI))
				end)
				vI.wsP = A
				task.delay(6, function()
					if vI.wsP == A then
						vI.wsP = nil
						pcall(function()
							A:Close()
						end)
					end
				end)
			end)
		end
		JI = function(R, e)
			local A, m = pcall(O[1].HttpGet, O[1], R)
			if not A then
				return nil, H(m):find("401") and "expired" or ""
			end
			return iI(m, e, true), H(m)
		end
		local function R()
			local e, A = false, 0
			local m = O[19]()
			pcall(function()
				local k, g, t, V =
					require(O[3].Data.Assets).Directory,
					require(O[3].Shared.Modules.Mutations),
					pairs,
					require(O[3].Client.EggState).ReadFieldEggs().Records
				for I, K in t(V) do
					A += 1
					I = type(K) == "table"
						and K.State ~= "Claimed"
						and K.Uid
						and not H(K.Uid):find("^FirstAreaEgg")
						and k[K.AssetCategory]
					local k, t = I and I.Rarity
					if I then
						local V = oI
						local X = not V
						if V then
							local V = oI
							t = V[I.DisplayName] == true
						else
							t = X
						end
					else
						t = I
					end
					if t and (k and o(k.RarityNumber or k.Rank) or 0) >= hI.rar then
						local k, t = {}, {}
						local function V(X)
							if type(X) == "string" then
								if X ~= "" then
									if X ~= "Normal" then
										if X ~= "None" then
											if not t[X] then
												t[X] = true
												k[#k + 1] = X
											end
										end
									end
								end
							end
						end
						V(K.BaseMutation)
						if type(K.Mutations) == "table" then
							for t, X in next, K.Mutations, nil do
								V(type(t) == "string" and X == true and t or X)
							end
						end
						local t, X = pcall(g.EarningsFor, k)
						V = o(K.AssetScale) or 1
						if
							(o(I.EarningRate) or 0)
								* (V > 5 and (V / 5) ^ 1.2 * 19.637875755794113 or V ^ 1.85)
								* (t and o(X) or 1)
							>= O[21](hI.min, 1)
						then
							e = true
							break
						end
					end
				end
			end)
			if A > 0 then
				if not vI.loadAt then
					vI.loadAt = m
				end
			end
			if not e and m - vI.arrived < 8 then
				if vI.loadAt then
					if not (m - vI.loadAt >= 1.5) then
						return true
					end
				else
					return true
				end
			end
			return e
		end
		local e = false
		pcall(function()
			local A = {}
			A[1] = O[5]:GetTeleportSetting("__ChilliFinderAuto") == O[1].JobId
			e = A[1]
			O[5]:SetTeleportSetting("__ChilliFinderAuto", false)
		end)
		if e then
			vI.auto, vI.autoAt = true, EI() * 1000
		end
		local e, A, m, k, g = false, 0, 0, 0, 0
		local function t()
			t7 = x7()
			if not t7 then
				return
			end
			local V, I = pcall(function()
				return o7() and c7()
			end)
			if V and I then
				e = true
			else
				H7()
				if not V then
					qI.ChilliFinderErr = H(I)
				end
			end
		end
		local V = {
			"\226\151\162",
			"\226\151\163",
			"\226\151\164",
			"\226\151\165",
			"\226\150\178",
			"\226\150\188",
			"\226\151\134",
			"\226\150\147",
			"\226\150\146",
			"\226\150\145",
			"/",
			"\\",
			"X",
			"#",
			"%",
		}
		local I = O[12](255, 242, 255)
		local K = O[12](217, 166, 255)
		local X = O[12](168, 85, 247)
		local OI, MI = { K, X, I }, { n = 0 }
		local ZI = Random.new()
		local function nI(PI, aI)
			return ZI:NextInteger(PI, aI)
		end
		local function PI(aI, YI)
			return ZI:NextNumber(aI or 0, YI or 1)
		end
		local function ZI(aI)
			local YI, RI, eI = MI.p, MI.l, aI.o
			if RI then
				if RI.Parent then
					RI.Text, RI.Position, RI.Rotation, RI.TextTransparency = eI.t, eI.p, eI.r, eI.a
					local aI, fI = pI(RI, S), pI(RI, x)
					if aI then
						if eI.s then
							aI.Color = eI.s
						end
					end
					if fI then
						if eI.f then
							fI.Offset = eI.f
						end
					end
				end
			end
			if YI then
				for aI, aI in ipairs(YI.gh) do
					aI.TextTransparency = 1
				end
				YI.top.Visible, YI.bot.Visible, YI.sg.Visible, YI.sc.Visible = false, false, false, false
				for aI, aI in ipairs(YI.sh) do
					aI.BackgroundTransparency = 1
				end
			end
		end
		local function aI()
			if MI.b then
				pcall(ZI, MI.b)
			end
			if MI.p then
				for YI, YI in ipairs(MI.p.all) do
					pcall(YI.Destroy, YI)
				end
			end
			MI.p = nil
			MI.b = nil
		end
		local function YI(RI)
			local eI = {}
			local fI = RI.Parent
			local QI, uI = pI(RI, S), { all = {}, gh = {}, sh = {} }
			local function AI(mI)
				table.insert(uI.all, mI)
				return mI
			end
			local function mI()
				local kI = RI:Clone()
				kI:ClearAllChildren()
				kI.Name = l7()
				kI.BackgroundTransparency = 1
				if QI then
					QI:Clone().Parent = kI
				end
				return kI
			end
			local function QI()
				return AI(
					N(
						{ Name = l7(), bt = 1, bs = 0, ClipsDescendants = true, a = RI.AnchorPoint, z = RI.ZIndex, v = false },
						fI
					)
				)
			end
			local function kI(LI, gI, tI)
				local xI = N({ Name = l7(), bs = 0, bc = LI, bt = gI, a = s, z = RI.ZIndex + tI, v = false }, fI)
				B(
					x,
					{
						Transparency = NumberSequence.new({
							NumberSequenceKeypoint.new(0, 1),
							NumberSequenceKeypoint.new(0.5, 0),
							NumberSequenceKeypoint.new(1, 1),
						}),
					},
					xI
				)
				return AI(xI)
			end
			uI.top, uI.bot = QI(), QI()
			eI[4] = AI
			eI[2] = v
			eI[3] = mI()
			eI[1] = {}
			eI[1].a = Vector2.zero
			eI[1].p = O[16](0, 0)
			eI[5] = (eI[4](eI[2](eI[3], eI[1], uI.top)))
			uI.tt = eI[5]
			uI.bt = AI(v(mI(), { a = Vector2.zero }, uI.bot))
			uI.sg, uI.sc = kI(X, 0.72, 1), kI(I, 0.05, 2)
			kI = ipairs
			eI[6] = {}
			eI[7] = (O[12](240, 183, 255))
			C:EH(eI[6], 0, eI[7], O[12](191, 200, 255))
			QI = eI[6]
			for B, B in kI(QI) do
				local kI, LI, gI, tI = table.insert, uI.gh, mI(), { tc = B, TextTransparency = 1 }
				eI[8] = (O[21](RI.ZIndex - 1, 1))
				tI.z = eI[8]
				kI(LI, (AI(v(gI, tI, fI))))
			end
			for B = 1, 7, 1 do
				QI = N({ Name = l7(), bs = 0, bc = B % 2 == 0 and K or I, bt = 1, a = s, z = RI.ZIndex + 2 }, fI)
				j(QI, 0, 1)
				table.insert(uI.sh, (AI(QI)))
			end
			eI[9] = MI
			eI[10] = MI
			eI[11] = O[19]() + PI(0.6, 1.6)
			eI[9].p = uI
			eI[10].n = eI[11]
		end
		local function s(B)
			local v = {}
			for N = 1, #B, 1 do
				v[N] = B:sub(N, N)
			end
			for N = 1, nI(1, 2), 1 do
				B = nI(1, #v)
				if v[B] ~= " " then
					v[B] = V[nI(1, #V)]
				end
			end
			return table.concat(v)
		end
		local function B(v)
			local N = {}
			local V, I, j = MI.p, MI.l, MI.b
			if V then
				if I then
					if not I.Parent then
						return
					end
				else
					return
				end
			else
				return
			end
			if not j then
				if v < MI.n then
					return
				end
				if I.AbsoluteSize.X <= 0 then
					MI.n = v + 1
					return
				end
				local RI, eI = pI(I, S), pI(I, x)
				MI.b = {
					c = v,
					nx = 0,
					e = 0,
					d = PI(0.14, 0.4),
					s = PI(0.38, 0.62),
					o = {
						t = I.Text,
						p = I.Position,
						r = I.Rotation,
						a = I.TextTransparency,
						s = RI and RI.Color or nil,
						f = eI and eI.Offset or nil,
					},
				}
				return
			end
			if v < j.nx then
				return
			end
			j.nx, j.e = v + 0.03, v - j.c
			if j.e >= j.d then
				ZI(j)
				MI.b, MI.n = nil, v + PI(1.4, 4)
				return
			end
			local RI, eI, fI, QI = j.o, O[22](j.e / j.d, 0, 1), nI(-4, 4), nI(-3, 3)
			local uI, AI = RI.r + PI(-2, 2), PI() < 0.6 and s(RI.t) or RI.t
			N[1] = RI.p + O[17](fI, QI)
			I.Position = N[1]
			I.Rotation = uI
			I.Text = AI
			local s, mI, kI, LI = I.Size, j.s, nI(3, 12), nI(0, 5)
			local j, gI, tI, xI, HI = s.X.Scale, s.X.Offset, s.Y.Scale, s.Y.Offset, 1 - mI
			s = (O[14](0, 0, tI * mI, xI * mI))
			I.TextTransparency = 1
			N[2] = V.top
			N[3] = V.top
			N[4] = V.top
			N[5] = (O[14](j, gI, tI * mI, xI * mI))
			N[6] = RI.p + O[17](kI, -LI)
			N[2].Size = N[5]
			N[3].Position = N[6]
			N[4].Rotation = uI
			N[7] = V.tt
			N[8] = V.tt
			N[9] = (O[16](1, 1 / mI))
			N[7].Size = N[9]
			N[8].Text = AI
			N[10] = V.bot
			N[11] = V.bot
			N[12] = V.bot
			N[13] = (O[14](j, gI, tI * HI, xI * HI))
			N[14] = RI.p + O[17](-kI, LI) + s
			N[10].Size = N[13]
			N[11].Position = N[14]
			N[12].Rotation = uI
			N[15] = V.bt
			N[16] = V.bt
			N[17] = V.bt
			N[18] = (O[16](1, 1 / HI))
			N[19] = (O[16](0, -mI / HI))
			N[15].Size = N[18]
			N[16].Position = N[19]
			N[17].Text = AI
			V.top.Visible, V.bot.Visible = true, true
			v = (PI())
			LI = RI.p + O[14](j * 0.5, gI * 0.5, tI * mI, xI * mI)
			N[20] = V.sg
			N[21] = V.sg
			N[22] = V.sg
			N[23] = V.sg
			N[24] = V.sg
			N[25] = (O[14](j * 1.1, gI * 1.1, 0, 10))
			N[26] = (1 - v) * 0.25 + 0.6
			N[27] = v > 0.5 and K or X
			N[20].Position = LI
			N[21].Size = N[25]
			N[22].BackgroundTransparency = N[26]
			N[23].BackgroundColor3 = N[27]
			N[24].Visible = true
			N[28] = V.sc
			N[29] = V.sc
			N[30] = V.sc
			N[31] = (O[14](j * (v * 0.3 + 0.75), gI, 0, 2))
			N[28].Position = LI
			N[29].Size = N[31]
			N[30].Visible = true
			kI, HI = pI(I, S), pI(I, x)
			if kI then
				if RI.s then
					kI.Color = PI() < 0.5 and OI[nI(1, #OI)] or RI.s
				end
			end
			if HI then
				N[32] = (O[13](PI(-0.5, 0.5), 0))
				HI.Offset = N[32]
			end
			for s, x in ipairs(V.gh) do
				I = s ~= 1 and -1 or 1
				N[33] = RI.p + O[17](fI + I * 3, QI + I * 2)
				x.Text = AI
				x.Rotation = uI
				x.TextTransparency = 0.3
				x.Position = N[33]
			end
			for s, x in ipairs(V.sh) do
				AI, I, xI = s * 7919 % 97 / 97, s % 2 ~= 0 and -1 or 1, nI(3, 9)
				N[34] = (O[17](xI, xI))
				N[35] = AI * 360 + eI * 180 * I
				N[36] = LI + O[17]((AI - 0.5) * 68 * eI, I * 22 * eI * (0.4 + AI * 0.6))
				x.Size = N[34]
				x.Rotation = N[35]
				x.Position = N[36]
				x.BackgroundTransparency = eI
			end
		end
		WI(O[4].RenderStepped, function()
			local s = {}
			local x, S, v = O[19](), i7.glx, i7.title
			if S then
				if v then
					local N = i7.vip and _7 and true or false
					if S.ink.Visible ~= N then
						S.ink.Visible = N
						S.edge.Enabled = N
					end
					if N then
						s[1] = S.eg
						s[2] = (O[13](-1 + 2 * (x % 3.2 / 3.2), 0))
						s[1].Offset = s[2]
						local N, V = S.ink.Parent, O[21](v.TextBounds.X, 1)
						if N.AbsoluteSize.X > 0 then
							s[3] = S.ink
							s[4] = S.ink
							s[5] = (
								O[16]((v.AbsolutePosition.X - N.AbsolutePosition.X + V / 2) / N.AbsoluteSize.X, 0.56)
							)
							s[6] = (O[16](O[22](V * 1.3 / N.AbsoluteSize.X, 0.1, 0.9), 0.95))
							s[3].Position = s[5]
							s[4].Size = s[6]
						end
						if MI.l ~= v then
							aI()
							MI.l = v
							YI(v)
						end
						B(x)
					elseif MI.b then
						ZI(MI.b)
						MI.b = nil
					end
				end
			end
			if not e then
				if x >= g then
					g = x + 2
					S = pcall(t)
					if e then
						g = 0
					elseif S then
					else
						pcall(restoreLeft)
						v = { "hudGui", "gui" }
						for s, t in ipairs(v) do
							s = i7[t]
							if s then
								s:Destroy()
							end
						end
						i7, _7 = {}, false
					end
				end
				return
			end
			if
				not (
					t7.Eggs:IsDescendantOf(O[1])
					and t7.ActivePets:IsDescendantOf(O[1])
					and i7.btn
					and i7.btn:IsDescendantOf(O[1])
				)
			then
				e = false
				H7()
				i7, _7 = {}, false
				return
			end
			if x >= g then
				g = x + 0.25
				B7()
				pcall(v7)
				if _7 then
					if qI.ChilliFinderHidden then
						S7()
					elseif not (zI()) then
						S7()
					end
				end
			end
			if Z7 then
				if x > Z7.stop or not II() then
					vI.failed[Z7.e.jobId] = x + (Z7.a and hI.gap > 0 and 1 or 300)
					v = Z7.a
					S = if v
						then not v
						else Z7.tries > 1 and ("Gave up after %d tries"):format(Z7.tries) or "Could not join"
					n7(S or nil)
				end
				if Z7 then
					if not Z7.fly then
						if q7() then
							n7("Night is close, join stopped")
						end
					end
				end
				if Z7 then
					if x >= Z7.next then
						if not (Z7.fly and x - Z7.fly < 10) then
							if Z7.force then
								P7()
							elseif Z7.tries == 0 then
								P7()
							end
						end
					end
				end
			end
			v = x >= k and (vI.dirty or Z7 or x - (vI.drawn or 0) >= 1)
			if v then
				k = x + 0.25
				vI.drawn = x
				vI.dirty = false
				W7()
				f7(Q)
			end
			if SI then
				if x >= SI then
					SI = nil
					_I()
				end
			end
		end)
		task.spawn(function()
			local function s()
				local e = {}
				local Q = O[19]()
				for k = 1, 20, 1 do
					k = table.remove(vI.inbox, 1)
					if not k then
						break
					end
					local g = iI(k[1], k[2], true)
					Y(g)
					if g then
						if g.eggs then
							TI(g.eggs)
						end
					end
					if g then
						vI.ajIn(g)
					end
				end
				if Q >= A then
					local k = II() and (vI.ws and 15 or 2)
					A = Q + (k or 3)
					if II() then
						if zI() then
							if vI.ws then
								if O[19]() - (vI.wsMsg or 0) > 50 then
									O7()
								end
							end
							M()
							if not vI.ws then
								local M, g = JI(
									FI
										.. "joiner/feed?s="
										.. vI.sess.token
										.. "&since="
										.. vI.last
										.. "&lk=1&rid="
										.. O[9].UserId,
									vI.sess.secret
								)
								if M then
									Y(M)
									TI(M.eggs)
								elseif g:find("expired") then
									k = DI()
									if k and k.token ~= vI.sess.token then
										vI.sess = k
										vI.wsAt = 0
									elseif cI.rt and vI.relogin and O[19]() - (vI.rl or -10000) > 20 then
										e[1] = vI
										e[2] = (O[19]())
										e[1].rl = e[2]
										vI.sess = nil
										vI.relogin()
									else
										lI("Signed in somewhere else. Sign in again to use it here")
										vI.who = nil
									end
								end
							end
						else
							O7()
						end
					elseif vI.sess then
						lI("Your booking ended. Book more hours at chillihub.pro")
						vI.whoAt = Q + 120
					elseif vI.who and cI.rt and vI.relogin and zI() and Q >= (vI.whoAt or 0) then
						vI.whoAt = Q + 120
						vI.relogin()
					elseif _7 then
						A = Q + 2.5 + math.random()
						local M = JI(FI .. "eggtop.js", sI)
						if M and type(M.eggs) == "table" then
							for Y, Y in ipairs(M.eggs) do
								Y.value = o(Y.value) or 0
							end
							vI.sample = M.eggs
							vI.dirty = true
						end
					else
						A = Q + 0.5
					end
				end
				if Q >= m then
					m = Q + 1
					if _7 then
						if vI.drawer == "sign" then
							p7()
						elseif vI.view == "ac" then
							p7()
						elseif vI.ask then
							p7()
						end
					end
				end
				local M = vI.auto and hI.hold and R() or false
				if M ~= vI.hold then
					if vI.hold then
						if not M then
							vI.autoAt = EI() * 1000
							W7()
						end
					end
					vI.hold = M
					vI.dirty = true
				end
				M = vI.ws and (vI.auto or vI.ajKey)
				if M then
					local M = (vI.hold or q7()) and 3 or Z7 and (Z7.fly and 2 or 1)
					local Y = M or 0
					M = table.concat(
						{
							H(vI.auto),
							hI.min,
							hI.rar,
							hI.age,
							Y,
							vI.autoAt or 0,
							H(vI.anyP()),
							H(hI.bl),
							type(hI.only) == "table" and table.concat(hI.only, ",") or "",
						},
						"|"
					)
					if M ~= vI.ajKey then
						vI.ajKey = M
						if vI.auto then
							if not vI.aj then
								vI.ajT = Q + 0.5
							end
						end
						e[4] = vI.ajSend
						e[3] = {}
						e[3].a = "s"
						e[3].on = vI.auto == true
						e[3].min = hI.min
						e[3].rar = hI.rar
						e[3].only = hI.only
						e[3].age = hI.age
						e[3].since = vI.autoAt or 0
						e[3].job = O[1].JobId
						local M, R, A, m = e[4], e[3], hI.bl and w7
						if A then
							m = A
						else
							local e = vI.anyP()
							m = if e then not e else O[1].PlaceId
						end
						R.place = m or 0
						R.st = Y
						M(R)
					end
				end
				vI.hereCheck(Q)
				vI.stealCheck(Q)
				if vI.auto then
					if II() then
						if zI() then
							if vI.hold then
								vI.gate = nil
							else
								vI.pickNext()
							end
						else
							vI.gate = nil
						end
					else
						vI.gate = nil
					end
				else
					vI.gate = nil
				end
			end
			while true do
				local O = rI
				if not O then
					break
				end
				local O, M = pcall(s)
				if not O then
					qI.ChilliFinderErr = H(M)
				end
				task.wait((#vI.inbox > 0 or vI.gate) and 0 or 0.2)
			end
		end)
		qI.ChilliFinderPanelCleanup = function()
			qI.ChilliFinderHidden = nil
			pcall(aI)
			rI = false
			O7()
			if qI.ChilliFinderOwner == vI.me then
				qI.ChilliFinderOwner = nil
			end
			if qI.ChilliFinderPanelClose == S7 then
				qI.ChilliFinderPanelClose = nil
			end
			for O, O in ipairs(wI) do
				pcall(O.Disconnect, O)
			end
			H7()
			if SI then
				_I()
			end
			qI.ChilliFinderPanelCleanup = nil
		end
	end)
	l.ChilliFinderBeforeTeleport = function()
		local O = Z[20]
		if O.beforeTeleport then
			pcall(Z[20].beforeTeleport)
		end
	end
	table.insert(Z[20].cleanup, function()
		if l.ChilliFinderPanelCleanup then
			l.ChilliFinderPanelCleanup()
		end
	end)
	w("53_promo#1", function()
		local O, M, s =
			Color3.fromRGB,
			"https://discord.gg/CJK4bs2mgT",
			{
				{ "#FF6A55", "New Scripts &amp; Updates", "Patch notes and new game scripts are posted there first." },
				{ "#FFB054", "Giveaways", "Member giveaways and events are announced in the server." },
				{ "#9AA3FF", "Support", "Ask for help, report bugs and get answers from the team." },
				{ "#6EE49C", "Suggestions", "Request features and vote on what gets added next." },
			}
		local Y, R, e = 11.4 + #s * 3.35 + 2.4 + 0.4, { Perks = {} }, 0
		local function Q()
			local A = pcall(setclipboard or toclipboard, M)
			c(A and "Discord Link Copied" or "Discord Link", M)
			if not R.Copy then
				return
			end
			e += 1
			local m = e
			R.Copy.Set({ Text = A and "<b>Copied!</b>" or "<b>See Notice</b>", Background = A and "#2EB070"
				or "#5865F2" })
			task.delay(1.8, function()
				if m == e then
					R.Copy.Set({ Text = "<b>Copy Link</b>", Background = "#5865F2" })
				end
			end)
		end
		local function e(A, ...)
			local m = { ... }
			for k, k in ipairs(m) do
				k.Set({ Width = A })
			end
		end
		local function A(m, k, g)
			k = math.max(k / math.max(g, 1), 14) - 0.4
			e(k, R.Hero, R.Invite, R.Header, R.Tip)
			e(math.max(1, k - 5.2 - 0.5), R.Title, R.Subtitle, R.Members)
			e(math.max(1, k - 6.4 - 1.5), R.Label, R.Link)
			m, g = R.Copy.Set, {}
			g.X = k - 6.4 - 0.5
			m(g)
			for m, m in ipairs(R.Perks) do
				e(k, m[1])
				e(math.max(1, k - 1.2), m[2], m[3])
			end
		end
		local function e(m)
			local k = ColorSequenceKeypoint.new
			local function g(t, x, S, H, o, B, v, N)
				N = N or {}
				N.Parent, N.X, N.Y, N.Height, N.Scale, N.Text, N.Color, N.Wrap = t, x, S, H, o, B, v, N.Wrap or false
				return m:Text(N)
			end
			R.Hero = m:Frame({
				Name = "Hero",
				X = 0.2,
				Y = 0.2,
				Height = 5.4,
				Background = "#FFFFFF",
				Gradient = ColorSequence.new(O(74, 24, 18), O(14, 11, 15)),
				GradientRotation = 0,
				Corner = 0.35,
				StrokeColor = "#FF6A40",
				StrokeThickness = 0.0909,
				StrokeTransparency = 0.55,
			})
			m:Image({ Parent = R.Hero, X = 0.5, Y = 0.6000000000000001, Width = 4.2, Height = 4.2, Image = p[2]("logo") })
			R.Title = g(
				R.Hero,
				5.2,
				0.45,
				1.6,
				1.45,
				"<b>Chilli Hub</b>",
				nil,
				{
					Gradient = ColorSequence.new({ k(0, O(255, 218, 96)), k(0.5, O(255, 152, 60)), k(
						1,
						O(255, 82, 64)
					) }),
					GradientRotation = 0,
					TextStrokeTransparency = 1,
				}
			)
			R.Subtitle = g(R.Hero, 5.2, 2.1, 1, nil, "Official Discord Community", "#DCDCE8")
			R.Members = g(
				R.Hero,
				5.2,
				3.3,
				1.2,
				nil,
				('<font color="#6EE49C">%s</font>  <b>%s</b>  <font color="#B8B8CC">Members</font>'):format(
					utf8.char(9679),
					"180K+"
				)
			)
			R.Invite = m:Frame({
				Name = "Invite",
				X = 0.2,
				Y = 6.2,
				Height = 3.6,
				BackgroundTransparency = 0.5,
				Corner = 0.35,
				StrokeColor = "#5865F2",
				StrokeThickness = 0.0909,
				StrokeTransparency = 0.35,
			})
			R.Label = g(R.Invite, 0.6, 0.35, 0.9, 0.78, "<b>INVITE LINK</b>", "#9C9CB4")
			R.Link = g(R.Invite, 0.6, 1.35, 1.6, 1.05, M:sub(9), nil, { Font = "code" })
			R.Copy = m:Button({
				Parent = R.Invite,
				Y = 0.8,
				Width = 6.4,
				Height = 2,
				Text = "<b>Copy Link</b>",
				Background = "#5865F2",
				BackgroundTransparency = 0,
				HoverTransparency = 0.15,
				PressTransparency = 0.3,
				StrokeColor = "#9AA3FF",
				StrokeThickness = 0.0909,
				Callback = Q,
			})
			R.Header = g(nil, 0.30000000000000004, 10.45, 1, 0.8, "<b>WHAT YOU GET</b>", "#9C9CB4")
			for M, t in ipairs(s) do
				k =
					m:Frame({ Name = "Perk", X = 0.2, Y = 11.4 + (M - 1) * 3.35 + 0.2, Height = 3, BackgroundTransparency = 0.68, Corner = 0.35 })
				m:Frame({ Parent = k, X = 0.3, Y = 0.45, Width = 0.22, Height = 2.1, Background = t[1], Corner = 0.11 })
				R.Perks[M] = {
					k,
					g(k, 0.85, 0.3, 1.1, nil, "<b>" .. t[2] .. "</b>", t[1]),
					g(k, 0.85, 1.35, 1.5, 0.86, t[3], "#C8C8D8", { Wrap = true }),
				}
			end
			R.Tip = g(
				nil,
				0.30000000000000004,
				Y - 2.2 - 0.2,
				2,
				0.8,
				"Paste the copied link into your browser or the Discord app to join.",
				"#8A8AA2",
				{ Wrap = true }
			)
			m:SetContentLines(Y)
			m:OnResize(A)
		end
		local M, s = dI.Community, { Name = "Discord", ShowTitle = false, Layout = "free" }
		s.Style, s.Build =
			{
				TextScale = 0.84,
				LineHeight = 1.1,
				MinLines = math.ceil(Y),
				MaxLines = math.ceil(Y),
				BackgroundTransparency = 0.5,
				ScrollBarColor = O(170, 174, 184),
				TextColor = O(255, 255, 255),
				TextStrokeTransparency = 0.7,
			},
			e
		M:Surface(s)
		dI.Community:Button("Copy Discord Link", nil, Q)
	end)
	w("53_promo#2", function()
		local O, M, s, Y, R, e, Q, A, m, k, g, t, x, S =
			"https://raw.githubusercontent.com/tienkhanh1/Venyx/main/VenyxHub",
			'loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/Venyx/main/VenyxHub"))()',
			"#E4E6EC",
			3.05,
			1.2999999999999998,
			6.949999999999999,
			5.8999999999999995,
			13.999999999999998,
			17.65,
			{
				{ "Smoother & faster", "Less lag, quick to load." },
				{ "More steal methods", "Teleport, Fast tween and more." },
				{ "Steal from players", "Hits whoever takes your egg." },
				{ "Easy setup", "Bring your Chilli config over." },
			},
			{},
			{},
			false,
			0
		local function H()
			local o = pcall(setclipboard or toclipboard, M)
			c(o and "Venyx Loader Copied" or "Venyx Loader", o and "Paste it into your executor to run Venyx." or M)
			S += 1
			local B = S
			local v, N = g.Copy.Set, {}
			N.Text = o and "Copied" or "See notice"
			v(N)
			task.delay(1.8, function()
				if B == S then
					g.Copy.Set({ Text = "Copy" })
				end
			end)
		end
		local S, o =
			{
				A = "Steal / Auto Steal/Auto steal/",
				F = "Steal / Auto Steal/Filter/",
				H = "Steal / Auto Steal/Auto hop server/",
				B = "Event / Butterfly/Butterfly bloom/",
				M = "Event / Butterfly/Butterfly machine/",
				C = "Event / Butterfly/Wisp companion/",
				U = "Farm / Mutate/Auto mutate/",
				V = "Farm / Mutate/Mutate filter/",
				G = "Farm / Pen/Auto place/",
				T = "Farm / Pen/Auto hatch/",
				D = "Farm / Treadmill/Treadmill/",
				O = "Farm / Treadmill/Progress/",
				S = "Farm / Sell/Pets/",
				E = "Farm / Sell/Eggs/",
				J = "Farm / Sell/Favorite/",
				X = "Farm / Fuse/Fuse machine/",
				Y = "Farm / Fuse/Fuse filter/",
				Z = "Event / AA/",
				N = "Player / ESP/",
				I = "Player / Move/",
				Cb = "Player / Combat/",
				Wb = "System / Webhook/",
				Sv = "System / Server/",
				Op = "System / Optimizer/",
				St = "Steal / Egg Predictor/Egg showcase/",
				Ss = "Event / Star/Shooting Star/",
			},
			"@Farm|Auto Steal\10Target Areas=F:Zones:z|Min Rarity=F:Rarities:r|Min Steal Value=F:Min value /s:m|Target Specific Eggs=F:Only these eggs:e|Steal Missing Index Eggs=A:|Drop Eggs At Safe Zone=A:|Steal Priority=F:Steal first:Best Rarity>Best rarity,Biggest Weight>Biggest,Best Mutation>Best mutation,Highest Value>Best value,Lowest Value>Lowest value\10@Farm|Shooting Star\10Auto Catch Shooting Star=Ss:\10@Farm|Butterfly Bloom\10Auto Butterfly Bloom=B:|Catch Mode=B:|Catch Priority=B:|Catch Butterflies=B:Catch:b|Tween Speed  =B:Catch speed|Auto Trade Up=M:|Trade Up Tiers=M:Trade:t|Smart Trade For Essence=M:|Auto Craft Essence=M:\10@Farm|Butterfly Bloom\10Auto Wisp=C:Auto wisp quest|Auto Banjo Cricket=C:\10@Farm|Auto Mutation\10Auto Mutate=U:|Mutations To Use=U:Use items|Mutate Min Rarity=V:Rarities:r|Mutate Min Value=V:Min value /s:m|Mutate Target Eggs=V:Only these eggs:e|Mutate Priority=U:Mutate first:Highest Value>Best value,Best Rarity>Best rarity,Biggest Size>Biggest\10@Farm|Auto Place Egg\10Auto Place Egg=G:Auto place|Place Egg Rule=G:Place when:Always>Always,Steal Idle>Steal is idle,After Steal>Right after a steal,Night Only>Only at night|Place Egg Order=G:Place first:Biggest Size>Biggest,Highest Value>Best value,Smallest Size>Smallest|Place Rarities=G:Rarities:l|Place Specific Eggs=G:Only these eggs:e|Min Place Value=G:Min value /s:m\10@Farm|Auto Treadmill\10Auto Treadmill=D:\10@Farm|Auto Hatch & Equip\10Auto Hatch=T:|Hatch Min Rarity=T:Rarities:r|Min Hatch Value=T:Min value /s:m|Hatch Specific Eggs=T:Only these eggs:e|Auto Equip Best=T:Equip best pets\10@Farm|Auto Sell\10Auto Sell Pet=S:Auto sell pets|Pet Max Rarity=S:Sell rarities:x|Pet Sell Value=S:Only below /s:m|Keep Mutated Pets=S:Keep mutated|Blacklist Sell Pets=S:Never sell:e|Auto Sell Egg=E:Auto sell eggs|Egg Max Rarity=E:Sell rarities:x|Egg Sell Value=E:Only below /s:m|Keep Mutated Eggs=E:Keep mutated|Blacklist Sell Eggs=E:Never sell:e\10@Farm|Auto Fuse Machine\10Auto Fuse Machine=X:Auto fuse|Fuse Priority Mode=X:Fuse first:Lowest Rarity First>Lowest rarity,Highest Rarity First>Highest rarity,Most Copies First>Most copies,Lowest Value First>Lowest value|Pets To Use=X:Use pets:Lowest To Highest>Lowest value first,Highest To Lowest>Highest value first|Max Rarity to Fuse=Y:Rarities:x|Specific Species to Fuse=Y:Only these pets:e|Skip Mutated Pets=X:Skip mutated|Eject Incomplete Slots=X:Eject odd pets\10@Farm|Auto Favorite\10Auto Favorite Pet=J:Auto favorite|Favorite Rule=J:Match:Match Any>Any picked rule,Match All>All picked rules|Favorite Min Rarity=J:Rarities:r|Min Favorite Value=J:Min value /s:m|Always Favorite Species=J:Always favorite:e|Auto Favorite Equipped=J:Favorite equipped\10@Admin Abuse|Capture The Egg\10Auto Capture Event Egg=Z:Capture the egg/|Take It From The Holder=Z:Capture the egg/|Hold Height=Z:Capture the egg/|Keep Away Distance=Z:Capture the egg/Keep away\10@Admin Abuse|Admin Treadmill\10Use Admin Treadmill=Z:Admin abuse/Admin treadmill\10@Admin Abuse|Minigame Eggs\10Auto Steal Minigame Egg=Z:Minigame eggs/\10@Player|ESP\10ESP Eggs=N:Field eggs/Egg ESP|ESP Fixed Size=N:Field eggs/Fixed size|ESP Own Base Eggs=N:Others/Pen egg ESP|ESP Other Base Eggs=N:Others/Other pens ESP|ESP Min Rarity=N:Field eggs/Rarities:r|ESP Show Info=N:Field eggs/Show:i|Min ESP Value=N:Field eggs/Min value /s:m|ESP Guards=N:Others/Guard ESP|ESP Players=N:Others/Player ESP\10@Player|Movement\10Speed Boost=I:Movement/|Boost Speed=I:Movement/|Infinite Jump=I:Movement/\10@Player|Character\10Invisibility=I:Protection/Invisible|Anti Ragdoll=I:Protection/|Anti Trap=I:Protection/Ignore traps|Instant Prompts=I:Protection/\10@Player|Combat\10Auto Hit Nearest Player=Cb:Auto hit/Hit who:h|Auto Hit Egg Holders=Cb:Auto hit/Hit who:h|Hit Aura=Cb:Hit aura/|Hit Tween Speed=Cb:Auto hit/Chase speed\10@Predictor|Discord Webhook\10Webhook URL=Wb:Discord webhook/Webhook URL|Ping @everyone=Wb:Discord webhook/Ping everyone|Notify On=Wb:What to post/:w|Webhook Min Rarity=Wb:What to post/Rarities:r|Webhook Min Value=Wb:What to post/Min value /s:m\10@Predictor|Egg Predictor\10Sort By=St:Sort eggs:Value>Value,Rarity>Rarity,Time Left>Time left|Preview Card=St:\10@Progress|Auto Progression\10Auto Buy Trail=O:Auto buy trails|Auto Upgrade Base=O:|Auto Upgrade Treadmill=D:|Auto Claim=O:Auto claim offline cash|Auto Claim Index=O:Auto claim index rewards\10@Server|Server\10Auto Load Script=Sv:Join and stay/|Server Hop Mode=Sv:Server/Hop to:Least Players>Least players,Most Players>Most players,Random>Random|Auto Rejoin When Disconnect=Sv:Join and stay/Rejoin on kick\10@Misc|Performance\10FPS Cap=Op:Frame rate/FPS cap|Optimizer=Op:Graphics/Low graphics|FPS and Ping=Op:Frame rate/Show FPS and ping|Disable 3D Render=Op:Graphics/Disable 3D Render|Background Color=Op:Graphics/\10@Misc|Utility\10Anti AFK=I:Protection/Anti AFK\10@Auto Hop|Egg Finder\10Auto Hop=H:|Hop Mode=H:Hop when:Until An Egg Matches>No egg matches here,Steal Then Hop>After stealing a match,After A Rare Spawns>A rare egg spawned|Rarity To Wait For=H:Rare from|First Hop Delay=H:First hop after\10"
		local function B(v)
			return type(v) == "table" and v or {}
		end
		local function v(N)
			return table.find(f, (tostring(N or ""):gsub("^%d+ %- ", "")))
		end
		local function N(V, I)
			local j = {}
			for K, X in ipairs(B(V)) do
				K = I(tostring(X))
				if K then
					j[#j + 1] = K
				end
			end
			return j
		end
		local function V(I, j, K)
			return N(I, function(I)
				return (I:gsub(j, K))
			end)
		end
		local I = _({ "Icon", "Name", "Rarity", "Value", "Mutation", "Size", "Weight", "Area" })
		local j = {
			r = function(K)
				if K == "Any" then
					return table.clone(f)
				end
				if K == "Off" then
					return {}
				end
				local X = v(K)
				return X and { table.unpack(f, 1, X) }
			end,
			x = function(K)
				if K == "Off" then
					return {}
				end
				local X = v(K)
				return X and { table.unpack(f, X) }
			end,
			m = function(f)
				f = tonumber(f) or 0
				return f > 0 and math.floor(10 ^ (3 + f * 0.009) + 0.5) or 0
			end,
			e = function(f)
				return V(V(f, " %(%d+%)$", ""), " %[[^%]]*%]$", "")
			end,
			z = function(f)
				return #B(f) < 13 and B(f) or {}
			end,
			l = function(f)
				return #B(f) > 0 and f or nil
			end,
			b = function(f)
				return V(f, " Butterfly$", "")
			end,
			t = function(f)
				return V(f, " To ", " to ")
			end,
			i = function(f)
				return N(f, function(f)
					return I[f] and f
				end)
			end,
		}
		local function f(v)
			local V, I, K = {}, B(v.Values)
			for X in o:gmatch("[^\10]+") do
				local o, OI = X:match("^@(.-)|(.+)$")
				if o then
					K = type(I[o]) == "table" and I[o][OI] or nil
					if K then
					else
						for o, o in next, I, nil do
							if type(o) == "table" and type(o[OI]) == "table" then
								K = o[OI]
								break
							end
						end
					end
				else
					if K then
						for o in X:gmatch("[^|]+") do
							local X, OI, pI, MI = o:match("^(.-)=(.-):([^:]*):?(.*)$")
							pI = if MI ~= "w" and (pI == "" or pI:sub(-1) == "/")
								then pI .. X:sub(1, 1) .. X:sub(2):lower()
								else pI
							local ZI, nI = K[X], (S[OI] or OI) .. pI
							o = type(ZI) == "table" and ZI.Value
							if type(ZI) == "table" and o ~= nil then
								if MI == "h" then
									if o == true then
										V[S.Cb .. "Auto hit/Auto hit"], V[nI] =
											true, X:find("Holders") and "Egg holders" or "Nearest player"
									end
								elseif MI == "w" then
									OI = _(B(o)) or {}
									V[nI .. "Post stolen eggs"], V[nI .. "Post fused eggs"], V[nI .. "Post when bag is full"] =
										OI["Egg Stolen"] == true, OI["Egg Fused"] == true, OI["Inventory Full"] == true
								else
									if j[MI] then
										o = j[MI](o)
									else
										if MI ~= "" then
											local _ = {}
											for B, j in MI:gmatch("([^,>]+)>([^,]+)") do
												_[B] = j
											end
											o = type(o) == "table" and N(o, function(B)
												return _[B] or B
											end) or _[o]
										else
										end
									end
									if o ~= nil then
										V[nI] = o
									end
								end
							end
						end
					end
				end
			end
			I = type(v.States) == "table" and v.States["Anti Guard Enabled"]
			if type(I) == "table" then
				if type(I.Value) == "boolean" then
					V[S.A .. "Anti guard"] = I.Value
				end
			end
			return V
		end
		local S
		S = W(y, function()
			if not x then
				return
			end
			x = false
			S:Disconnect()
			pcall(function()
				local S, _ = "ChilliLibrary/Games/" .. tostring(n.GameId ~= 0 and n.GameId or n.PlaceId), "Default"
				pcall(function()
					local o = T:JSONDecode(readfile(S .. "/config_state.json"))
					local B = type(o) == "table"
						and type(o.StartupConfig or o.SelectedConfig) == "string"
						and (o.StartupConfig or o.SelectedConfig)
					_ = B or _
				end)
				local o = S .. "/configs/" .. _ .. ".json"
				local S = isfile(o) and readfile(o) or isfile(o .. ".bak") and readfile(o .. ".bak")
				o = type(S) == "string" and T:JSONDecode(S)
				S = type(o) == "table" and f(o)
				if S then
					if next(S) then
						if not (isfolder("Venyx")) then
							makefolder("Venyx")
						end
						writefile("Venyx/FromChilli.json", T:JSONEncode(S))
					end
				end
			end)
			pcall(b.SetTeleportSetting, b, "__ChilliAutoLoadScriptEnabled", false)
			_G.__ChilliAutoLoadQueued = nil
			if l.ChilliHubSaeCleanup then
				pcall(l.ChilliHubSaeCleanup)
			end
			local f, S = pcall(n.HttpGet, n, O)
			local O = f and type(S) == "string" and loadstring(S)
			if O then
				pcall(O)
			end
		end)
		local function O(f, S, _)
			S = math.max(S / math.max(_, 1), 8)
			_, f = (S - 0.5) / 2, math.max(1, S - Q - 5 - 1.6)
			g.Hero.Set({ Width = S })
			g.Name.Set({ Width = f })
			g.About.Set({ Width = f })
			local o, B = g.Switch.Set, {}
			B.X = S - 5 - R
			o(B)
			g.Card.Set({ Width = S })
			for o, B in ipairs(t) do
				f = 0.3 + (o - 1) % 2 * (_ + 0.5)
				B[1].Set({ X = f + 0.25, Width = 0.8 })
				B[2].Set({ X = f + 1.05, Width = _ - 1.4 })
				B[3].Set({ X = f + 1.05, Width = _ - 1.4 })
			end
			g.Loader.Set({ Width = S })
			g.Code.Set({ Width = S - 5 })
			g.Copy.Set({ X = S - 3.9 })
		end
		local function f(S)
			local _ = "rbxasset://fonts/families/Montserrat.json"
			local o, B, v, N =
				Font.new(_, Enum.FontWeight.ExtraBold),
				Font.new(_, Enum.FontWeight.Bold),
				Font.new(_, Enum.FontWeight.SemiBold),
				Font.new("rbxasset://fonts/families/RobotoMono.json", Enum.FontWeight.Medium)
			local function V(I, j, K)
				return S:Frame({
					Name = I,
					Y = j,
					Height = K,
					Background = "#14151A",
					Corner = 0.4,
					StrokeColor = "#FFFFFF",
					StrokeThickness = 0.0909,
					StrokeTransparency = 0.82,
				})
			end
			local function I(j, K, X, OI, pI, MI, ZI, nI, qI)
				return S:Text({ Parent = j, X = K, Y = X, Height = OI, Scale = pI, Wrap = qI == true, Font = MI, Text = ZI, Color = nI })
			end
			g.Hero = V("Hero", 0, 6.6)
			local j = S:Image({
				Parent = S:Frame({
					Parent = g.Hero,
					X = R,
					Y = R,
					Width = 4,
					Height = 4,
					Background = "#0D0E12",
					Corner = 0.8,
					StrokeColor = "#FFFFFF",
					StrokeThickness = 0.0909,
					StrokeTransparency = 0.7,
				}),
				X = 0.65,
				Y = 0.65,
				Width = 2.7,
				Height = 2.7,
			})
			task.spawn(function()
				local R = "Venyx/mark1.png"
				local K, X = pcall(isfile, R)
				if K and X then
				else
					R = "Chilli Hub/VenyxMark1.png"
					local OI, pI = pcall(isfile, R)
					if not (OI and pI) then
						local OI, pI = pcall, crypt and (crypt.base64decode or crypt.base64 and crypt.base64.decode)
						local MI, ZI = OI(
							pI or base64_decode,
							"iVBORw0KGgoAAAANSUhEUgAAAIYAAACACAYAAADOIBGMAAAPWklEQVR4nOydedRd0xnGn8/qH6VKQtIEFVESJTGFGKrRIk1Lo9RUZZWlWLS0S9qaaQ1VStAGCdpGzFMQjURVUkPNpVTFGErNbRUd1Oo/PI+7b9Z1c+6Z9rvvOefe81trr/199557hr3f8+7pfd+9DGpqIlgGNTUR1IJRE8kSwXjvvfdWYLqOaRxq+grW+eZMVzMt2/xsiWAMDAz8i9kzTA/xgCNQ0xewrk9idh/TE5SB/zU/H2g76BPMXmb6CNPNTHvw4P+gpudgXQ9hNpvpc0z/ZxrGun6r+f2H+hj84m/MrnD/bs+0iCfYCjU9BetUdfsYGkIhLmoVChHV+Ty/5e8RTHfxRMegpidgXZ7FbD7TsJaPz28/binBoOTcy+yqto9P4QmvZFoONZWEdbcS0wL+OaXtK2mLR9qP7zRcPS/isz2ZHuXJx6OmUrDOvshsEdN2EV9Pj/pNpGBQgu5idm/EV2sxPcAL7Y2aSsC6+g6z3zANj/j6Ntb1g1G/i5vgOj3mu8t4we+jptSwjo5lNi3mkFM7fTGA+BO/xGy1mENOo8QdjZrSwbqbyizu5X2BdTey05dJU+KnJ3x/FG/gUtSUBg0QmG5EvFCI2LpN0hgrMnuVaVnEs5Bpx9aZs5ruw/r6OBr9ic8kHKpZ7lVYX+90OiBWY/CHb6NDr7UN9Xbn88Y+hppCYNkPQuMFTRIKcW6cUIhYjeEuqGny15GOu5m250X/jZquwTpamdltTOunOPxdptVZR/+IOyhx2d1Nk09DOjR9fqtTaTVdwL24v0c6oRBnJgmFSNQY7uJj0JhbT4tW6ybyBv6LmmCwXoYyu4Np3Qw/G816eSbpoFSGOjyRZs1uQXq2YJqDmmC4gYGmuLMIxdw0QiGyWHCdjWxM5M3/GjXmsFyXR2P0sQGycVbaA1M1JS03pOnTTZCN6ymlu6LGBGdl9VumzyIb97AeUptQZLX5nIXs7MKHqZsVO65BdqEQs7IcnFVjaNld0+SDkZ3zKLGHoiY3LP8LmR2I7GhkOTLLBGQmjeEmRc5EPg7hg30XNblg2R2OfEIhzsg6K51JYwg3uym70BWRj0m8yVtRkxqW+WRmc5EPzVloQuvdLD/K7Ffi5iauQH5m80HXQU0qWFZjmV2J/MzMKhQir8PR+cjPCmgIx6dQEwvLaCQanc3lkZ9fIAe5BIMS+Ciz3yE/eguuQk1H3FzFPGSbwGpnHutqMXLg46LoozXEeD58kr1HP3MJ03rwI+0a11Jk7ny2worV+skY+LEXpdqnDe05WK4nMvsh/Lif5boFcuLr1OzTCV1yDhbEhqj5AJbFV+AvFGI2PPDVGJro0tA1ycIrib8wbeT8Z/sW1yFX/83X4EleZav7uJd6aQxe+E1mF8GfNZkuRs1l8BcKcZGvz7FFfIxzYMPOzgeiL+GzH8lsS9hwLjzxakqauEWynWDD+pT2LEZBlYfltxGzh2HDNSy/r8ETq4g6vkPXVmaij3DzFVfDjhkwwEQwKKEyGklrMJyE5jdORv+gfsVo2PAc6+J2GGAZg+tU2HEchSOrQVDl4DN+AXZNsDCbMDTpYwg3dP0n7FA/Y3yeBaAq4JqQB+A35d3O8lYG2GYaww1dLSa8mmg95UfoXU6DrVBcbmmVb6YxBN+CbeC3uBbFBBeWoWdgOclzbwFs2dAtbppgKhiCD30/s81gxxNM43qlSXHGvHLHWBN2PMTy2RSGhAgAewlskbr9MXoHNSGWQiFy2VzEEUJjaEr3r0wrwZa1+VY8iwrDstEy+iLY8nemEdYa1VxjuA6QySRLGz9B9Unt8JOBs0M0s+YaQ/DNWB0NrWGN/GEXooKwTOR05bUU3oGhaZyUsxIkyDxv9EU0vKWs+Rmqy1TYMzeEUIiQuw+EUJtj+ebthorhohyOhD0hyvgDgjQlTVggMsAZCVue4lvyaVQIlsNzsB+JLGY5jEIgQu9XYrnq2mQdFnRlXB3dTg7WQiGs7GAiCa0xPsnsRdgjX8xRZTcFdIFNNMQOEWFoaKj+hQiqMXjjcoD+FexReKEjUX5OQBihODekUIigGkPwrVF/4AmEYZiLEVY6nGFvqAm5UXkdidISfE80PsCTzEI5MZdZa5yEMMwLLRQiuMYQfHt2R8MHMwRDWFBvoETweWWR9RTCsBOfN3gIq67sosgHuRZhZkLFQSgfUxCGxd0QCtHN7TVDaYzDnDVUKeC9rMLsYIQhVBkuRTcFI8ToRGhIaOHSZ8VRCIeFc1cqutLHaMK36ZfM9oc98rpareh5DW0vhUaMMl+XzShm8Pm+jS7RTY0hzkMY1JTsgeLRmkgIoRChyi6SrmoMwbdKIY63hj2P843yDcngBZ9NUXfXhj3z+WxfRhfptsYQeaP+JbGe89MoBF57R4QRCtH1ADNd1xiChagxvpX3VSsL+GYVIhx8pjuZTYA9hWjCIjSGCGWmN9Et3HUVXlO7S4YQClGIu2ZRgiEn3lCzld9C9wk1WniF2qKQIHaFCIYzXs0dOCyBvNFzc+H8RL6JMPwUBVGUxhASjBBbZA1lZXnHh8iAhsmDYI9cPs39RdJSmGBQayhOVCibxa5NBCHcWs3UInelLGRU0sTt/KeZwhC7L45w1urBCGhzISeiNQcK3DqsyKakqTV+jjB0Y9U11GLZmQMF7ydXqMYQzi4yhBXWoyzcoPFDA83H6GUZUfQWpYVqDMECkNoMsQ6wQcg5DZ5bztYhJummFS0UonDBcGTdiC8tSfub+xBiUx51NkMN4zNRCsFwXuwhjFD2RTj2hj3Ty2KmWHgfo0nAHv62LOzbYAjvdXtm82HPYNchL5yyNCXSGnLjCzGvEcLX9auw57SyCIUojcYQfBOHM3sVtrzGAl8FhvA+pe4tA8Oob7GG64iXgtJoDMGCeQ32HdHhrMgvwQieS3E5raMFTSuTUIhSCYZDgWStVeqesMPyXEJzOIUtlnWidILh3pzDYItJ9F0XX2xn2DLFxUgtFWXUGBIO7V1i6aA0iJW6C/zR7kMfhR3P8lktg+aaUUrBcFj7ilg0AdbNyNEoKaUalbTDt/xx2IVVlnHQsLy+JyFipfNe1kdJKbPGEEfADjUBPib41nMX30OJKbVg8I26CbbR/3w6oZYTZXPKvr99qZsS4bbefAQ2vMkKyTUHwfuQG6SVQdFo3sczKDFlb0qkNf4Eu+0pBrOCM5v58zeTYScUM8ouFKL0guE4Aw1zNwv2QXasjItlZ3ECKkAlBMMZxVptrZWpn0FtsRyzHWGD+kxDUAGqojEkHFpDeRL+DHV+pmnZgWlF+KNguNoPdRGvfyPTeBQAr7st02ym2HgllREMh5WXWZahp9Uw9TAK9z1o7PWmGdQHWDk3Ma2DLuAE4kH+qSD9Cnh/U9zxpR+VtMOHuwH+6xVvsZIGpzmQ13ub2Qrw40peby93vqhAdcfz+yCb9bidIKYzTW75eBGvNzbud1XTGEKhjHwj5wxK05y4gPa+QqEFsiVbk7tAdX9oO+ZkXuslJtMFOp7vODR2apzc9tWxSb+tnGCwYGWyPx3+7JXimDwjmHbOibDjjIrqtxrTDazME+GJgtUxaXFOnvLD276+nfdzY9I5KteUCBelT3MBw+HHqiykVztcYwSzF+CHvOxGR7ka8vxz0HmEpKH5xDy7IvK8mzOTh/zIDod8nue9I+E0lWxKpDU0C2nhnxq3FmMRfe+Qgc7+p3GuDXLCulMdRmSAx+ue70Nnobg0jVCISmqMJk5dfh35eYMFNSTivAoM/zL8AsTP4rn3izuA11FY6eMRz0E8z4UJ55EGlZaIWySU9hqTdnW5khqjhRPgx8qug9aObEF8dw1I01dQZKGkuZkLeI8dTf/4nfomdyN55XjfLCYHlRYMPujT8HeKPsZF8/0A/r0Gsx/Aj1N4b88nHeQCyGjkk7QL4hG8r1ntH/KzTZg9xLRBwu/lmpBpB+1KNyWChSM7C3VEffxUVbgKTqvpb3mvJRV0HM+zEjLtaMRnUESeNJGTZYKwm3xb+RtNvF2O5LiiC3n8RGSk8oIh3Pj/BpSDHVgRNyMjfAYtFKbRVH9EQ4jSOILLbnZcHrfHnhAMkbIjF5rjWAmnICd8Bu0sYLVgJyQUDyMHPSMYImBk3jT8mZXg0wQ13RM03BwLf3ZOM5HViaqPStopUmN4W7W7KDrboLES68M+PkIhekowXEzMzO27AVfx2nNggNsET9GN826Gtz/PcSk86ammRFAdr4rG3ECI3QujeJ1pXWtvMj7HODT2kstio7o778Nk//hea0r0xr3CrJsb9h44EMDFkOfU6GNehp9cbyUUoucEQ7CALkG2Qs3LTF5rLgJAjaFdrr+R4Se78DdmEYR6rilpwkLSGohWJ01jY7SgEdDGAwHCLvLeZb+RNxaXyS6LPSsYwu1fYumw1IqEwsrfZQm8Z5nd+TQJml6fwHt7EB70ZFPSxHl7hfAmPyOQUGwJ//vVEsHNbs0nNz2tMQQLaBgaoxSrQPCKFTZ2wDjON+9zY2baDMdqq1BZum2W14m7pzWGYMFoOGkZenH3AEKh/pA6sUlCIQMlLYhpJ8qke5D1+bXISc8LhmBFKvSiRbyNQ90w0prr0LD5jEPW6tvw+lotncm/t2NK6vhOirPliKPnm5JWWEjaWSnvNpwyi7MwDv4QKVdVNTcziddf1PbbTZndguRJsF352+uRgX4TDM2KKhhLVs8yNUdjBoyj9vJ+5HiUtKYhDTU5xmhZ+7EtQGc7T/EOGqOop5GSvmhKmrhZ0TRuA+0cEEAo1Bm+IOEwrXlM6CQUwoXb1sLbYzHnkQFSpt2S+kowhOtvZNn79RgXwMWaqYh3fzhYTRfTO0hAZoQubFOcmePWFMbUM6l91ZS0wkKSit444bB7WOBbwf7acgtY2OFr9SNkvpfLgZvnlkbUdHrUIqJWbEelCU3ddxqjBfmQxu0Lshj2MT2bdJru1sTZ2LxCIVx4SEUhujviaw2LU43O+lZjCL5dCnHQabEtSDgkXlMjm4vbPlbUoP3ymuHFXEvRAbT9d+v8SKq45f2sMZr9jagVyQMGwoVDavVqf8VdayNroRA85wxmo/DhtRdZlU9J+m1fC4ZwS/TntHx0Ij9LY8qfGb7BBzBTWAJ5hR3OtFaoazVR4H4mNZuT0JgmF4fyXmKH7H3dlDRxuy1rLuAlFmKwzXx5HbXvj2WdbDK+BzWfijE6l/fRcRRTC0ZNJH3flNREUwtGTSTvAwAA///2y1mvAAAABklEQVQDALNzu4AFm6hAAAAAAElFTkSuQmCC"
						)
						if MI then
							if type(ZI) == "string" then
								if not (ZI:sub(2, 4) == "PNG") then
									return
								end
							else
								return
							end
						else
							return
						end
						pcall(makefolder, "Chilli Hub")
						pcall(writefile, R, ZI)
					end
				end
				X, K = pcall(getcustomasset, R)
				if X then
					if type(K) == "string" then
						j.Set({ Image = K })
					end
				end
			end)
			g.Name = I(g.Hero, Q, 1.4, 1.85, 1.6, o, "Venyx")
			g.About = I(g.Hero, Q, 3.4, 2.4, 0.9, v, "Smoother, faster and more ways to steal.", s, true)
			g.Switch = S:Button({
				Parent = g.Hero,
				Y = 2.15,
				Width = 5,
				Height = 2.3,
				Text = "Try now",
				Font = o,
				Color = "#0D0E12",
				Scale = 1.2,
				Background = "#FFFFFF",
				BackgroundTransparency = 0,
				HoverTransparency = 0.1,
				PressTransparency = 0.2,
				Corner = 0.45,
				Callback = function(R)
					if x then
						return
					end
					R.Set({ Text = "<b>Loading...</b>", Background = "#2EB070" })
					x = true
				end,
			})
			g.Card = V("Features", e, 2 * Y + 0.6)
			for R, e in ipairs(k) do
				_ = 0.35 + math.floor((R - 1) / 2) * Y
				t[R] = {
					I(g.Card, 0, _, 1.25, 1, o, utf8.char(10003)),
					I(g.Card, 0, _, 1.25, 1.02, B, e[1]),
					I(g.Card, 0, _ + 1.3, 1.3, 0.88, v, e[2], s),
				}
			end
			g.Loader = V("Loader", A, 3.6)
			g.Code = I(g.Loader, 0.55, 0.35, 2.9000000000000004, 0.8, N, M, "#E8E9EE", true)
			g.Copy = S:Button({
				Parent = g.Loader,
				Y = 0.8,
				Width = 3.4,
				Height = 2,
				Text = "Copy",
				Font = B,
				Background = "#2B2D35",
				BackgroundTransparency = 0,
				HoverTransparency = 0.15,
				PressTransparency = 0.3,
				Corner = 0.35,
				Callback = H,
			})
			S:SetContentLines(m)
			S:OnResize(O)
		end
		local O, M = dI.Venyx, { Name = "Venyx", ShowTitle = false, Layout = "free" }
		M.Style, M.Build =
			{
				TextScale = 1.15,
				LineHeight = 1.1,
				MinLines = m,
				MaxLines = 18,
				Padding = 0,
				BackgroundTransparency = 1,
				StrokeTransparency = 1,
				ScrollBarColor = Color3.fromRGB(170, 174, 184),
				TextColor = Color3.new(1, 1, 1),
				TextStrokeTransparency = 1,
			},
			f
		O:Surface(M)
	end)
	w("56_shrine#1", function()
		pcall(function()
			local O, M = ipairs, { gethui and gethui(), d("CoreGui") }
			for s, s in O(M) do
				for O, O in ipairs(s:GetChildren()) do
					if O.Name == "ShrineFinder" then
						O:Destroy()
					end
				end
			end
		end)
		if l.ShrineFinder then
			pcall(l.ShrineFinder)
		end
		local O, M = d("TweenService"), Enum
		local s = Color3.fromRGB
		local Y = UDim2.new
		local R = UDim2.fromOffset
		local e = UDim2.fromScale
		local f = Vector2.new
		local Q = Color3.new(1, 1, 1)
		local A = Color3.new(0, 0, 0)
		local m = s(255, 214, 90)
		local k = M.EasingStyle.Back
		local g = M.TextXAlignment.Center
		local t = M.TextXAlignment.Left
		local x, S, H, _, o =
			M.ScaleType.Fit,
			"rbxasset://fonts/families/GothamSSm.json",
			19.637875755794113,
			{
				{ id = "Divine", n = 0, ld = true, pets = { "ArchAngel", "World Burner" }, out = "Aetheron" },
				{ id = "Eternal", n = 1, ld = true, pets = { "Pegasus", "Skeleton Horse" }, out = "Equinox" },
				{ id = "Enchanted", n = 2, pets = { "Royal Skywhale", "Cosmic Lion" }, out = "World Spirit" },
				{ id = "Xenorath", n = 4, pets = { "Nebuloth Kraken", "Obsidian Rex" }, out = "Xenorath" },
			},
			{}
		o.blue = { s(0, 110, 255), s(0, 205, 255), s(0, 32, 92), s(175, 225, 255) }
		o.gray = { s(84, 86, 104), s(128, 130, 150), s(22, 22, 28), s(190, 192, 206) }
		o.red = { s(205, 0, 0), s(255, 70, 70), s(75, 0, 0), s(255, 185, 185) }
		local B, v, N, V, I, j, K, X =
			{
				a = "AnchorPoint",
				p = "Position",
				s = "Size",
				z = "ZIndex",
				v = "Visible",
				bt = "BackgroundTransparency",
				bc = "BackgroundColor3",
				o = "LayoutOrder",
				t = "Text",
				i = "Image",
				st = "ScaleType",
				bs = "BorderSizePixel",
			},
			{},
			{},
			{},
			{},
			{},
			{},
			{ __mode = "k" }
		for OI, OI in ipairs(_) do
			v[OI.id], N[OI.n] = OI, OI
			for pI, MI in ipairs(OI.pets) do
				V[MI] = { t = OI, s = pI }
			end
		end
		local OI = setmetatable({}, X)
		local pI, MI, ZI, nI, dI, qI, PI, rI, wI, TI, lI, WI, EI =
			setmetatable({}, X),
			{},
			{},
			{ status = {}, have = {} },
			{ v = 0, kick = 1 },
			{},
			{},
			{},
			{},
			{},
			{},
			{},
			{ n = 0 }
		local X, FI, sI, aI, JI, YI, RI = l.ShrineBase or "https://chillihub.pro/shrine"
		local eI, fI, QI, uI = 760, 510, 1
		local AI, hI, mI, kI, LI, gI = false, 1, "", 1
		local iI, tI = false
		local xI, SI = false
		local HI, _I, oI, BI, vI, zI, cI, DI = true, 0, 0, 0, 0, false, 0
		local NI, VI = false, c
		local function c() end
		local II, jI, KI, XI, UI, GI, C7, O7, p7, M7
		local function Z7(n7)
			local d7, q7 = Z[20]
			if d7 then
				local P7 = Z[20]
				q7 = P7.tr
			else
				q7 = d7
			end
			d7 = nil
			if q7 then
				local P7 = Z[20]
				d7 = P7.tr(n7)
			else
				d7 = q7
			end
			return d7 or n7
		end
		local n7
		W(b.TeleportInitFailed, function(d7, q7, P7)
			local r7, w7 = n7, Z[1]
			if d7 ~= w7 then
				return
			elseif not r7 then
				return
			elseif os.clock() - r7.t > 30 then
				return
			end
			if r7.n < 1 then
				if q7 ~= M.TeleportResult.GameFull then
					r7.n = 1
					task.delay(1, function()
						pcall(b.TeleportToPlaceInstance, b, r7.pl, r7.job, Z[1])
					end)
					return
				end
			end
			n7 = nil
			c(Z7("Could not join") .. ": " .. (P7 ~= "" and P7 or tostring(q7)):gsub("Enum%.TeleportResult%.", ""))
		end)
		local function d7(q7)
			c(q7)
			if not xI then
				pcall(VI, "Fusion Finder", (Z7(q7):gsub("<[^>]->", "")))
			end
		end
		local function VI(q7, P7, r7)
			local w7 = { Parent = r7 }
			for r7, b7 in next, P7, nil do
				w7[B[r7] or r7] = b7
			end
			return F(q7, w7)
		end
		local function B(q7)
			local P7 = h(q7)
			return tostring(P7 and P7.Icon or "")
		end
		local function q7(P7, ...)
			local r7 = { ... }
			for w7, w7 in ipairs(r7) do
				P7 = P7 and (P7:FindFirstChild(w7))
			end
			return P7
		end
		local function P7(r7, w7)
			local b7 = r7:FindFirstChild(w7)
			if b7 then
				b7:Destroy()
			end
		end
		local function r7(w7, b7)
			return ('<font color="#%s">%s</font>'):format(w7, b7)
		end
		local function w7(b7)
			return r7("C8C8D8", b7)
		end
		local function b7(T7)
			return r7("FFD65A", ("x%.2f"):format(T7))
		end
		local function T7(y7)
			local l7 = 0
			while y7 >= 1000 and l7 < #u do
				y7, l7 = y7 / 1000, l7 + 1
			end
			return y7, l7
		end
		local function y7(l7)
			return (("%.1f"):format(l7):gsub("%.0$", ""))
		end
		local function l7(W7)
			local E7, F7 = T7(W7)
			return "$" .. (F7 == 0 and tostring(math.floor(E7)) or y7(E7) .. u[F7]) .. "/s"
		end
		local function W7(E7)
			return r7("00FF00", l7(E7))
		end
		local function E7(F7)
			F7 = math.max(0, os.time() - F7)
			return F7 < 60 and "just now"
				or F7 < 3600 and math.floor(F7 / 60) .. "m ago"
				or math.floor(F7 / 3600) .. "h ago"
		end
		local function F7(s7, a7, J7)
			local Y7 = s7 .. a7
			if j[Y7] == nil then
				local R7, e7 = pcall(function()
					return require(P.Shared.Util.AssetItems).WeightKg({ Category = s7, Scale = a7, Mutations = J7 or {} })
				end)
				e7 = R7 and tonumber(e7)
				j[Y7] = false
				if e7 then
					local s7, a7 = T7(e7)
					j[Y7] = (s7 >= 10 and tostring(math.floor(s7 + 0.5)) or y7(s7)) .. (u[a7] or "") .. " kg"
				end
			end
			return j[Y7] or ""
		end
		local function u(j, T7, y7)
			return b7(T7) .. "  " .. r7("AEB8CC", F7(j, T7, y7))
		end
		local function j(T7)
			return nI.status[T7.tier] ~= "COMPLETED" and nI.have[v[T7.tier].pets[3 - T7.side]] ~= nil
		end
		local function T7(y7, s7, a7, J7, Y7)
			local R7 =
				O:Create(y7, TweenInfo.new(a7 or 0.16, J7 or M.EasingStyle.Quad, Y7 or M.EasingDirection.Out), s7)
			R7:Play()
			return R7
		end
		local function O(y7, s7, a7, J7)
			local Y7 = F(
				"UIListLayout",
				{
					FillDirection = s7 and M.FillDirection.Horizontal or M.FillDirection.Vertical,
					Padding = UDim.new(0, a7 or 0),
					SortOrder = M.SortOrder.LayoutOrder,
					VerticalAlignment = s7 and M.VerticalAlignment.Center or M.VerticalAlignment.Top,
					Parent = y7,
				}
			)
			if J7 == 1 then
				Y7.HorizontalAlignment = M.HorizontalAlignment.Center
			elseif J7 then
				pcall(function()
					Y7.HorizontalFlex = M.UIFlexAlignment.Fill
				end)
			end
		end
		local function y7(s7, a7, J7, Y7, R7)
			F(
				"UIPadding",
				{
					PaddingLeft = UDim.new(0, a7),
					PaddingRight = UDim.new(0, J7),
					PaddingTop = UDim.new(0, Y7),
					PaddingBottom = UDim.new(0, R7),
					Parent = s7,
				}
			)
		end
		local function s7(a7, J7)
			pcall(function()
				a7.StrokeSizingMode = M.StrokeSizingMode.FixedSize
			end)
			a7.Thickness = J7
		end
		local function a7(J7)
			for Y7, R7 in ipairs(J7:GetDescendants()) do
				if R7:IsA("UIStroke") then
					Y7 = R7.Parent
					s7(
						R7,
						(Y7:IsA("TextLabel") or Y7:IsA("TextBox")) and 1.8
							or R7.Name == "UIStrokeClr" and 1.4
							or Y7:IsA("ImageButton") and 2.2
							or 1.6
					)
				end
			end
		end
		local function J7(Y7, R7, e7, f7, Q7, u7)
			local A7 = JI:Clone()
			A7.AnchorPoint, A7.Position, A7.Size, A7.Text, A7.RichText, A7.TextScaled, A7.TextSize, A7.TextWrapped, A7.ZIndex, A7.TextXAlignment, A7.TextTruncate =
				f(), e7, f7, R7, true, false, Q7, false, 3, u7 or t, M.TextTruncate.AtEnd
			A7.Parent = Y7
			s7(A7.UIStroke, math.clamp(Q7 * 0.13, 1.2, 2.8))
			return A7
		end
		local function Y7(R7, e7)
			for f7, f7 in ipairs(R7:GetChildren()) do
				if f7:IsA("UIGradient") then
					f7:Destroy()
				end
			end
			local f7 = e7 and (h(e7))
			e7 = f7 and f7.Rarity and f7.Rarity.RarityGradient
			if typeof(e7) == "Instance" then
				e7:Clone().Parent = R7
			end
			return R7
		end
		local function h(R7, e7, f7, Q7, u7, A7)
			local h7 = Z[74]
			Y7(J7(R7, "<b>" .. h7(e7) .. "</b>", f7, Q7, u7, A7), e7).TextColor3 = Q
		end
		local function R7(e7, f7, Q7, u7)
			if not YI then
				return J7(e7, r7("00FF00", f7), Q7, u7, u7.Y.Offset - 2)
			end
			local A7 = YI:Clone()
			for h7, h7 in ipairs(A7:GetChildren()) do
				if not (h7:IsA("UIStroke")) then
					if not (h7:IsA("UIGradient")) then
						h7:Destroy()
					end
				end
			end
			A7.AnchorPoint = f()
			A7.Position = Q7
			A7.Size = u7
			A7.Text = f7
			A7.TextScaled = true
			A7.TextXAlignment = t
			A7.ZIndex = 3
			A7.Visible = true
			A7.Parent = e7
			return A7
		end
		local function e7(f7, Q7, u7, A7, h7, m7)
			return R7(f7, l7(L(Q7, u7, A7)), h7, m7)
		end
		local function f7(Q7, u7, A7, h7)
			local m7 = Y7(R7(Q7, u7, A7, h7))
			m7.RichText, m7.FontFace = true, Font.new(m7.FontFace.Family, M.FontWeight.ExtraBold, M.FontStyle.Normal)
		end
		local function Q7(u7, A7, h7, m7)
			VI(
				"ImageLabel",
				{ s = R(A7, A7), p = e(0.5, 0.5), a = f(0.5, 0.5), bt = 1, i = B(u7), st = x, z = 3 },
				VI(
					"ImageLabel",
					{
						s = R(A7 * 1.5, A7 * 1.5),
						p = m7,
						a = f(0.5, 0.5),
						bt = 1,
						i = "rbxassetid://109516122757226",
						ImageTransparency = 0.5,
						z = 2,
					},
					h7
				)
			)
		end
		local function u7(A7, h7, m7)
			for k7, L7 in ipairs(h7 or {}) do
				if I[L7] then
					VI("ImageLabel", { s = R(m7, m7), bt = 1, i = I[L7], st = x, o = k7, z = 24 }, A7)
				end
			end
		end
		local function A7(h7, m7, k7, L7, g7, i7, t7)
			if m7 then
				if #m7 > 0 then
					local x7 = VI("Frame", { a = L7, p = g7, s = i7, bt = 1, z = 24 }, h7)
					O(x7, true, t7, 1)
					u7(x7, m7, k7)
				end
			end
		end
		local function h7(m7, k7, L7, g7, i7)
			return VI("Frame", { s = k7, p = L7 or Y(), a = g7 or f(), o = i7 or 0, bt = 1 }, m7)
		end
		local function m7(k7, L7)
			k7.AnchorPoint, k7.Position, k7.Size = f(0.5, 0.5), e(0.5, 0.5), e(1, 1)
			k7.Parent = L7
			return F("UIScale", { Parent = k7 })
		end
		local function k7(L7, g7, i7)
			local t7 = L7:IsA("GuiButton") and L7 or VI("TextButton", { t = "", bt = 1, s = e(1, 1), z = 9 }, L7)
			t7.AutoButtonColor = false
			t7.Active = true
			local function L7()
				T7(g7, { Scale = 1.06 })
			end
			t7.MouseEnter:Connect(L7)
			local function L7()
				T7(g7, { Scale = 1 })
			end
			t7.MouseLeave:Connect(L7)
			local function L7()
				T7(g7, { Scale = 0.92 }, 0.08)
			end
			t7.MouseButton1Down:Connect(L7)
			local function L7()
				T7(g7, { Scale = 1.06 }, 0.25, k)
			end
			t7.MouseButton1Up:Connect(L7)
			t7.Activated:Connect(function()
				K.snd.PlaybackSpeed = 0.93 + math.random() * 0.13
				K.snd:Play()
				i7()
			end)
		end
		local function L7(g7, i7)
			k7(g7, g7:FindFirstChild("PressScale") or F("UIScale", { Parent = g7 }), i7)
		end
		local function g7(i7, t7)
			i7.Scale = 0.8
			task.delay((t7 or 0) * 0.03, function()
				T7(i7, { Scale = 1 }, 0.32, k)
			end)
		end
		local function i7(t7, x7, S7)
			if not MI[t7] then
				MI[t7] = true
				g7(x7, S7)
			end
		end
		local function t7(x7, S7, H7, _7, o7, B7, v7, z7, c7)
			local D7, N7 = h7(x7, _7, B7, v7, z7), aI:Clone()
			N7.BackgroundColor3, N7.Price.Text = Q, S7
			v7 = m7(N7, D7)
			local function x7(S7)
				S7 = o[S7]
				N7.UIGradient.Color, N7.UIStroke.Color, N7.UIStrokeClr.Color =
					S7 and ColorSequence.new(S7[1], S7[2]) or aI.UIGradient.Color,
					S7 and S7[3] or aI.UIStroke.Color,
					S7 and S7[4] or aI.UIStrokeClr.Color
			end
			x7(H7)
			a7(N7)
			s7(N7.Price.UIStroke, math.clamp(_7.Y.Offset * 0.07, 1.4, 2.4))
			k7(N7, v7, o7)
			pI[D7] = function(o, S7)
				if o then
					N7.Price.Text = o
				end
				if S7 then
					x7(S7)
				end
			end
			if c7 then
				_7 = N7.Price.Size
				N7.Price.Size = Y(_7.X.Scale * 0.85, _7.X.Offset, _7.Y.Scale * 0.85, _7.Y.Offset)
			end
			return D7, N7
		end
		local function o(x7, S7, H7, _7, o7, B7, v7, z7)
			return t7(x7, S7, H7, _7, o7, B7, v7, z7, true)
		end
		local function x7(S7, H7, _7, o7)
			local B7, v7 = h7(S7, H7, _7, nil, o7), sI:Clone()
			for S7, S7 in ipairs(v7:GetChildren()) do
				if not (S7:IsA("UIStroke")) then
					S7:Destroy()
				end
			end
			v7.Active = false
			pcall(function()
				v7.Selectable = false
			end)
			_7 = m7(v7, B7)
			s7(v7.UIStroke, 2)
			return v7, B7, _7
		end
		local function S7(H7, _7, o7)
			return VI(
				"ScrollingFrame",
				{
					p = _7,
					s = o7,
					bt = 1,
					bs = 0,
					ScrollBarThickness = 5,
					ScrollBarImageColor3 = s(21, 21, 21),
					CanvasSize = Y(),
					AutomaticCanvasSize = M.AutomaticSize.Y,
					ScrollingDirection = M.ScrollingDirection.Y,
				},
				H7
			)
		end
		local function H7(_7)
			for o7, o7 in ipairs(_7:GetChildren()) do
				if o7:IsA("GuiObject") then
					o7:Destroy()
				end
			end
		end
		local function _7(o7, B7)
			F("UICorner", { CornerRadius = UDim.new(B7, B7 == 1 and 0 or 4), Parent = o7 })
		end
		local function o7(B7, v7, z7, c7, D7, N7)
			return VI(
				"TextBox",
				{
					p = z7,
					s = c7,
					bt = 1,
					t = "",
					PlaceholderText = v7,
					PlaceholderColor3 = N7,
					FontFace = Font.new(S, M.FontWeight.Bold),
					TextSize = 15,
					TextColor3 = D7,
					TextXAlignment = t,
					ClearTextOnFocus = false,
					z = 4,
				},
				B7
			)
		end
		local function B7(v7, z7, c7, D7, N7)
			local V7 = FI:Clone()
			for I7, I7 in ipairs(V7:GetChildren()) do
				if not (I7.Name == "Header" or I7.Name == "Close" and c7 == 66) then
					if not (I7:IsA("UIStroke")) then
						I7:Destroy()
					end
				end
			end
			V7.AnchorPoint, V7.Position, V7.Size = f(0.5, 0.5), e(0.5, 0.5), R(v7, z7)
			V7.Visible = true
			a7(V7)
			z7, v7 = ipairs, { V7, V7.Header }
			for I7, I7 in z7(v7) do
				for v7, v7 in ipairs(I7:GetChildren()) do
					if v7:IsA("UIStroke") then
						s7(v7, v7.Color.R < 0.2 and D7 or N7)
					end
				end
			end
			V7.Header.Size = Y(1, 0, 0, c7)
			return V7
		end
		local function v7(z7, c7, D7, N7)
			local V7 = z7.Header
			V7.Title.Text, V7.Title2Stroke.Text = c7, c7
			s7(V7.Title.UIStroke, D7)
			s7(V7.Title2Stroke.UIStroke, N7)
		end
		local function z7()
			local c7, D7, N7 = {}, {}, Z[67]
			local V7 = N7()
			if V7 then
				if not (type(V7.Inventory) == "table") then
					return
				end
			else
				return
			end
			for I7, I7 in ipairs(type(V7.EquippedAssets) == "table" and V7.EquippedAssets or {}) do
				D7[I7] = true
			end
			for I7, j7 in next, V7.Inventory, nil do
				N7 = type(j7) == "table" and V[j7.Category]
				if N7 then
					local V7, K7 = type(j7.Mutations) == "table" and j7.Mutations or {}, tonumber(j7.Scale) or 1
					local X7, U7, G7 =
						#c7 + 1,
						{ uid = I7, id = j7.Category, sc = K7, muts = V7, v = L(j7.Category, K7, V7) },
						nI.status[N7.t.id] == "COMPLETED" and "Shrine done"
							or j7.IsFavorite and "Favorited"
							or D7[I7] and "In your pen"
					V7 = G7 or j7.IsStolenDNA and "Stolen DNA" or j7.InFuse and "In a fuse"
					U7.why, c7[X7] = V7 or nil, U7
				end
			end
			table.sort(c7, function(D7, N7)
				if D7.why == nil ~= (N7.why == nil) then
					return D7.why == nil
				end
				return D7.v > N7.v
			end)
			WI = c7
			nI.have = {}
			for D7, D7 in ipairs(c7) do
				if not D7.why then
					nI.have[D7.id] = nI.have[D7.id] or D7.sc
				end
			end
		end
		local function c7(D7, N7, V7, I7, j7, K7)
			local X7, U7, G7 = V[D7].t.out, L(D7, N7, V7), I7 and not V[D7].t.ld and L(I7, j7, K7) or 0
			if G7 > U7 then
				N7, V7, U7 = j7, K7, G7
			else
			end
			G7 = L(X7, 1, V7)
			K7 = nil
			if G7 > 0 then
				if L(X7, N7, V7) < U7 then
					I7 = U7 / G7
					K7 = I7 <= H and I7 ^ 0.5405405405405405 or 5 * (I7 / H) ^ 0.8333333333333334
				else
					K7 = N7
				end
			else
				K7 = N7
			end
			return X7, K7, math.max(L(X7, K7, V7), U7)
		end
		local function H(D7)
			local N7 = v[D7.tier].pets[3 - D7.side]
			if gI then
				if gI.id == N7 then
					D7 = gI
					return D7
				end
			end
			D7 = WI
			for V7, V7 in ipairs(D7) do
				if V7.id == N7 then
					if not V7.why then
						return V7
					end
				end
			end
		end
		local function D7(N7, V7)
			local I7 = H(N7)
			if not I7 then
				return ""
			end
			local j7, K7, X7 = c7(I7.id, I7.sc, I7.muts, v[N7.tier].pets[N7.side], N7.sc, N7.muts)
			N7 = Z[74]
			return (V7 and "" or w7("You get ")) .. r7("FFD65A", N7(j7)) .. " " .. W7(X7) .. " " .. b7(K7)
		end
		local function N7(V7, I7, j7, K7, X7, U7, G7, Cu)
			local Ou = VI("Frame", { p = R(I7, 0), s = Y(0, j7, 1, 0), bt = 1 }, V7)
			J7(Ou, r7("FFD65A", "<b>" .. K7 .. "</b>"), R(-40, -6), Y(1, 80, 0, 24), 19, g)
			Q7(X7, 84, Ou, Y(0.5, 0, 0, 66))
			h(Ou, X7, R(0, 112), Y(1, 0, 0, 22), 20, g)
			if not U7 then
				return J7(Ou, r7("FF6868", Cu or ""), R(0, 140), Y(1, 0, 0, 20), 16, g)
			end
			e7(Ou, X7, U7, G7, R(0, 138), Y(1, 0, 0, 26)).TextXAlignment = g
			J7(Ou, u(X7, U7, G7), R(0, 166), Y(1, 0, 0, 18), 17, g)
			A7(Ou, G7, 20, f(0.5, 0), Y(0.5, 0, 0, 188), Y(1, 0, 0, 20), 2)
		end
		local function V7(I7)
			local j7, K7 = pcall(n.HttpGet, n, X .. I7)
			if j7 then
				if type(K7) ~= "string" then
					return nil
				end
			else
				return nil
			end
			j7, I7 = pcall(T.JSONDecode, T, K7)
			return j7 and type(I7) == "table" and I7 or nil
		end
		local function I7(j7)
			local K7 = {}
			for X7, U7 in next, j7, nil do
				K7[#K7 + 1] = X7 .. "=" .. T:UrlEncode(tostring(U7))
			end
			return table.concat(K7, "&")
		end
		local j7 = bit32.bxor
		local K7 = bit32.band
		local X7 = bit32.rshift
		local U7 = bit32.lshift
		local function G7(Cu, Ou)
			for pu = 1, #Cu, 1 do
				Ou = j7(Ou, Cu:byte(pu))
				Ou = (Ou % 256 * 16777216 + Ou * 403) % 4294967296
			end
			return Ou
		end
		local function Cu(Ou)
			Ou = j7(Ou, U7(Ou, 13))
			Ou = j7(Ou, X7(Ou, 17))
			return j7(Ou, U7(Ou, 5))
		end
		local function U7(Ou, pu)
			Ou.ts = math.floor(J() * 1000)
			Ou = T:JSONEncode(Ou)
			local J, Mu = ("%08x%08x"):format(math.random(0, 2147483646), math.random(0, 2147483646)), {}
			local Zu, nu = (G7(pu .. J, 2166136261)), (G7(J .. pu, 2654435769))
			for du = 1, #Ou, 1 do
				Zu, nu = Cu(Zu), Cu(nu)
				Mu[du] = ("%02x"):format(j7(Ou:byte(du), K7(j7(X7(Zu, 8), X7(nu, 16)), 255)))
			end
			local j7 = table.concat(Mu)
			local K7, X7 = G7(j7 .. pu, 3735928559), C[20](G7(pu .. j7, 3405691582))
			return ("c3.%s.%s.%08x%08x"):format(J, j7, K7, C:QH(X7))
		end
		local J = {
			update = "Fusion Finder was updated, get the new script",
			["in use"] = "This account uses Fusion Finder on another device",
			busy = "Too many accounts on this network",
			slow = "Too fast, wait a moment",
			["type listed"] = "You already listed this pet, one of each pet",
			["too many offers"] = "You can list up to 8 pets",
			["bad pet"] = "That pet was not accepted",
			["bad account"] = "Roblox account not found",
			["bad invite"] = "Invite not accepted",
			empty = "Links are not allowed in chat",
			done = "This shrine is already done for you or for them",
			offline = "They just went offline, try another player",
			["in room"] = "You are in a room, finish or cancel it first",
			joining = "Wait, one of you is joining the other's server",
		}
		local function j7(K7)
			return nI.status[K7] == "COMPLETED"
		end
		local function K7()
			local X7 = {}
			for G7, Cu in next, nI.status, nil do
				if Cu == "COMPLETED" then
					if v[G7] then
						X7[#X7 + 1] = G7
					end
				end
			end
			table.sort(X7)
			return table.concat(X7, ",")
		end
		local function X7(G7, Cu)
			return G7 and G7.e and (J[G7.e] or (Cu or "") .. tostring(G7.e)) or "Could not reach the server"
		end
		local function J()
			local G7 = Z[1]
			local Cu = "ChilliLibrary/ShrineFinder_" .. G7.UserId .. ".txt"
			if not dI.tried then
				dI.tried = true
				local Ou, pu = pcall(readfile, Cu)
				local Mu, Zu = tostring(Ou and pu or ""):match("^([%w_-]+)|([%w_-]+)$")
				if Mu then
					pu = V7("/me?" .. I7({ s = Mu, v = 0 }))
					if pu then
						if pu.inn ~= nil then
							dI.s = Mu
							dI.k = Zu
							dI.v = 0
							if pu.post then
								task.spawn(GI, "unlist")
							end
							return Mu
						end
					end
				end
			end
			if os.clock() < (dI.hiAt or 0) then
				return
			end
			local Ou, pu = pcall(function()
				return d("RbxAnalyticsService"):GetClientId()
			end)
			local Mu, Zu = pcall(function()
				return gethwid and gethwid()
			end)
			local nu, du = {}, Z[1]
			nu.uid = du.UserId
			du, G7 = Ou and tostring(pu)
			if du then
				G7 = du
			else
				pu = nil
				pu, G7 = Z[1], tostring(Z[1].UserId)
			end
			nu.cid = G7
			nu.hw = Mu and Zu and tostring(Zu) or ""
			Zu = V7("/hi?d=" .. U7(nu, "sHr3-hI-q7Vx2mKp9ZwT4n"))
			dI.s, dI.k = Zu and Zu.ok and Zu.s or nil, Zu and Zu.k
			dI.v = 0
			dI.closed = Zu and Zu.e == "closed" or nil
			if dI.s then
				pcall(makefolder, "ChilliLibrary")
				pcall(writefile, Cu, dI.s .. "|" .. tostring(dI.k))
			else
				dI.hiAt = os.clock() + 15
				if not dI.closed then
					if (Zu and Zu.e) ~= dI.he then
						dI.he = Zu and Zu.e
						c(X7(Zu))
					end
				end
			end
			return dI.s
		end
		local function G7(Cu)
			return V7("/a?s=" .. dI.s .. "&d=" .. U7(Cu, dI.k))
		end
		dI.L = {}
		local function U7(Cu)
			local Ou = V[Cu]
			return Ou.t.id .. "|" .. Ou.s
		end
		local function Cu()
			iI = gI ~= nil and dI.L[U7(gI.id)] ~= nil
			if K.listB then
				pI[K.listB](iI and "LISTED" or "LIST ME", iI and "blue" or "green")
			end
		end
		local function Ou(pu)
			local Mu = dI.L[pu]
			if not Mu then
				return
			end
			dI.L[pu] = nil
			pu = #rI
			for Zu = pu, 1, -1 do
				if rI[Zu].id == Mu.id then
					table.remove(rI, Zu)
				end
			end
		end
		local function pu(Mu)
			local Zu, nu, du =
				table.insert,
				rI,
				{ id = Mu.id, mine = true, tier = Mu.tier, side = Mu.side, sc = Mu.sc, muts = Mu.muts }
			du.at = os.time()
			Zu(nu, 1, du)
		end
		local function Mu()
			for Zu, nu in next, dI.L, nil do
				local du = os.time() - nu.at < 600
					and GI(
						"list",
						{ tier = v[nu.tier].n, side = nu.side, sc = ("%.3f"):format(nu.sc), muts = table.concat(
							nu.muts or {},
							","
						) }
					)
				Ou(Zu)
				if du then
					if du.ok then
						nu.id = du.id
						dI.L[Zu] = nu
						pu(nu)
					end
				end
			end
			Cu()
		end
		GI = function(Zu, nu)
			nu = nu or {}
			nu.a, nu.dn = Zu, K7()
			if not dI.s then
				if not (J()) then
					return nil
				end
			end
			local du = G7(nu)
			if du then
				if du.e == "expired" then
					if J() then
						if next(dI.L) then
							if Zu ~= "list" then
								if Zu ~= "unlist" then
									Mu()
								end
							end
						end
						du = (G7(nu))
					else
					end
				else
				end
			else
			end
			dI.kick = 0
			return du
		end
		local function G7(Zu)
			local nu, du, qu = {}, {}, { rI, Zu }
			for Zu, Zu in ipairs(qu) do
				for qu, qu in ipairs(Zu) do
					nu[qu.id] = qu
					du[#du + 1] = qu
				end
			end
			qI, PI = du, nu
		end
		local function Zu()
			local nu, du = {}, qI
			for qu, qu in ipairs(du) do
				if qu.rq then
					nu[#nu + 1] = qu
				elseif qu.mid then
					nu[#nu + 1] = qu
				end
			end
			return nu
		end
		local function nu()
			local du, qu = pcall(n.HttpGet, n, X .. "/list.js?t=" .. os.time())
			dI.fail = du and type(qu) == "string" and qu:sub(1, 1) == "{" and 0 or (dI.fail or 0) + 1
			if du then
				if type(qu) ~= "string" then
					return
				elseif qu == dI.raw then
					return
				end
			else
				return
			end
			local X, Pu = pcall(T.JSONDecode, T, qu)
			if X then
				if type(Pu) ~= "table" then
					return
				elseif type(Pu.p) ~= "table" then
					return
				end
			else
				return
			end
			dI.raw, dI.closed = qu, Pu.closed == 1 or nil
			qu, du = {}, {}
			for T, T in next, dI.L, nil do
				du[T.id] = true
			end
			local T, ru = ipairs, Pu.p
			for wu, bu in T(ru) do
				Pu = N[tonumber(bu[2]) or -1]
				if Pu then
					wu = PI
					X = wu[bu[1]] or { id = bu[1], seen = os.clock() }
					X.mine, X.tier, X.side, X.sc, X.at =
						du[bu[1]], Pu.id, tonumber(bu[3]) or 1, tonumber(bu[4]) or 1, tonumber(bu[6]) or os.time()
					X.muts = type(bu[5]) == "string" and bu[5] ~= "" and bu[5]:split(",") or nil
					qu[#qu + 1] = X
				end
			end
			rI = qu
			G7(Zu())
			II()
		end
		local function T(N, X)
			local du = PI[N] or { id = N }
			du.tier, du.side, du.sc, du.at, du.muts = X.tier, X.side, X.sc, X.at, #X.muts > 0 and X.muts or nil
			return du
		end
		local function N()
			if not dI.s then
				return
			end
			local X = V7("/me?" .. I7({ s = dI.s, v = dI.v }))
			if X then
				if X.e == "expired" then
					if J() then
						if next(dI.L) then
							Mu()
						end
					end
					return
				end
			end
			if X then
				if X.inn == nil then
					return
				end
			else
				return
			end
			local V7, I7 = X.pend or 0, false
			if type(X.posts) == "table" then
				local Mu = {}
				for du, du in ipairs(X.posts) do
					Mu[du] = true
				end
				for du, qu in next, dI.L, nil do
					if Mu[qu.id] then
					else
						if os.time() - qu.at > 5 then
							Ou(du)
							I7 = true
						else
						end
					end
				end
				if I7 then
					Cu()
					if dI.pend then
						if V7 > dI.pend then
							d7("Your offer ended after 10 minutes, press LIST ME to list again")
						end
					end
				end
			end
			dI.pend = V7
			dI.v = X.v
			for Mu, du in next, wI, nil do
				if du == "out" then
					wI[Mu] = nil
				end
			end
			for Mu, Mu in ipairs(X.out or {}) do
				wI[Mu] = "out"
			end
			local Mu, du, qu = {}, {}, {}
			for Pu, Pu in ipairs(X.inn or {}) do
				V7 = "r:" .. Pu.id
				I7 = T(V7, Pu)
				I7.rq = Pu.id
				Mu[#Mu + 1] = I7
				du[V7] = true
				wI[V7] = "in"
			end
			for Pu, ru in ipairs(X.m or {}) do
				V7 = "m:" .. ru.id
				Pu, I7 = T(V7, ru), {}
				Pu.mid, Pu.uid, Pu.dn = ru.id, ru.uid ~= 0 and ru.uid or nil, ru.dn ~= "" and ru.dn or "Partner"
				if ru.jn == 2 then
					if Pu.jn ~= 2 then
						d7("Your partner is joining your server")
					end
				end
				Pu.jn = ru.jn
				local T = Pu.uid ~= nil and q:GetPlayerByUserId(Pu.uid) ~= nil
				if T then
					if not Pu.here then
						d7("Your partner is in your server")
					end
				end
				Pu.here = T
				T = ru.on == false and ru.jn ~= 2
				if T then
					if not Pu.off then
						d7("Your partner went offline")
					end
				end
				Pu.off = T
				Mu[#Mu + 1] = Pu
				du[V7] = true
				wI[V7], qu[ru.tier] = "ok", V7
				for T, T in ipairs(ru.msgs) do
					I7[#I7 + 1] =
						{ me = T.me, kind = T.k ~= "text" and T.k or nil, t = T.t, n = T.n, max = T.x, pl = T.p }
				end
				TI[V7] = I7
			end
			for T, Pu in next, wI, nil do
				if Pu == "in" then
					if not du[T] then
						wI[T] = nil
						TI[T] = nil
					end
				elseif Pu == "ok" then
					if not du[T] then
						wI[T] = nil
						TI[T] = nil
					end
				end
			end
			lI = qu
			G7(Mu)
			I7, Mu = next, dI.L
			for T, Pu in I7, Mu, nil do
				qu = lI
				if qu[Pu.tier] then
					Ou(T)
				end
			end
			Cu()
			if X.ended then
				if X.ended.id ~= dI.ended then
					I7 = X.ended.why
					dI.ended = X.ended.id
					V7, qu =
						c, I7 == "done" and "Shrine done!" or I7 == "idle" and "Match ended: no reply for 5 minutes"
					V7(qu or I7 == "left" and "Your partner left" or "Your partner cancelled the match")
				end
			end
			V7 = not dI.seen
			dI.seen = dI.seen or {}
			qu = next
			for T in qu, du, nil do
				if not dI.seen[T] then
					dI.seen[T] = true
					Mu = PI[T]
					if T:sub(1, 2) == "m:" then
						if dI.want ~= T then
							d7(Z7("Matched!") .. " " .. D7(Mu))
							if not tI then
								dI.want = T
							end
							if xI then
							elseif V7 then
							else
								M7(true)
							end
						end
					elseif V7 then
					else
						d7(Z7("New request:") .. " " .. Z[74](v[Mu.tier].pets[Mu.side]) .. "  " .. D7(Mu))
					end
				end
			end
			if dI.want then
				V7 = PI
				if V7[dI.want] then
					I7 = PI
					tI = I7[dI.want]
					dI.want = nil
					C7(2)
				end
			end
			if tI then
				X, V7 = du[tI.id]
				if X then
					qu = PI
					V7 = qu[tI.id]
				else
					V7 = X
				end
				tI = V7 or nil
			end
			II()
			jI()
			KI()
		end
		local function T(X, d7)
			local V7 = wI[X.id]
			local function I7(Mu, du, qu)
				o(d7, Mu, du, R(98, 30), qu, Y(1, -9, 1, -9), f(1, 1))
			end
			if X.mine then
				I7("YOURS", "gray", function()
					O7(
						"Remove offer?",
						function(d7)
							N7(d7, 137, 250, "YOU GIVE", v[X.tier].pets[X.side], X.sc, X.muts)
						end,
						"REMOVE",
						"red",
						function()
							for d7, Mu in next, dI.L, nil do
								if Mu.id == X.id then
									task.spawn(GI, "unlist", { id = Mu.id })
									Ou(d7)
								end
							end
							Cu()
							G7(Zu())
							II()
							c("You left the list")
						end,
						560,
						372
					)
				end)
				return
			end
			if V7 == "ok" then
				I7("CHAT", "blue", function()
					UI(X)
				end)
				return
			end
			if V7 == "out" then
				I7("SENT", "gray", function()
					c("Waiting for them to accept")
				end)
				return
			end
			if V7 == "in" then
				I7("OPEN", "blue", function()
					C7(2)
				end)
				return
			end
			V7 = lI
			if V7[X.tier] then
				I7("MATCHED", "gray", function()
					c("You already have a partner for this shrine")
				end)
				return
			end
			if next(lI) then
				I7(Z7("IN ROOM"), "gray", function()
					c("You are in a room, finish or cancel it first")
				end)
				return
			end
			if j7(X.tier) then
				I7(Z7("DONE"), "gray", function()
					c("You already finished this shrine")
				end)
				return
			end
			I7("REQUEST", nil, function()
				local d7 = H(X)
				if not d7 then
					local V7 = c
					return V7("You need the matching pet in your bag")
				end
				wI[X.id] = "out"
				II()
				c("Request sent! " .. D7(X))
				task.spawn(function()
					local V7, I7, Mu = GI, { to = X.id }, d7.sc
					I7.sc = ("%.3f"):format(Mu)
					I7.muts = table.concat(d7.muts or {}, ",")
					Mu = V7("req", I7)
					if not (Mu and Mu.ok) then
						wI[X.id] = nil
						II()
						V7, I7 =
							c,
							Mu and Mu.e == "gone" and "That offer is gone"
								or Mu
									and Mu.e == "declined"
									and ("They declined you, try again in %ds"):format(tonumber(Mu.w) or 30)
						V7(I7 or X7(Mu, "Could not send: "))
					end
				end)
			end)
		end
		local function X(d7, V7)
			OI[V7.tm] = nil
			V7.h:Destroy()
			ZI[d7] = nil
		end
		local function d7(V7)
			local I7, Mu, du, qu, Pu = {}, {}, 0, ipairs, rI
			for rI, ru in qu(Pu) do
				local wu, bu, Tu = v[ru.tier].pets[ru.side], if uI then ru.tier == uI else not uI
				if bu then
					rI = ru.mine
					if rI then
						Tu = rI
					else
						local rI = (if LI then wu == LI else not LI) and (if AI then j(ru) else not AI)
						if rI then
							local yu = mI == ""
							if yu then
								Tu = yu
							else
								local yu = Z[74]
								Tu = yu(wu):lower():find(mI, 1, true)
							end
						else
							Tu = rI
						end
					end
				else
					Tu = bu
				end
				if Tu then
					ru.v = L(wu, ru.sc)
					I7[#I7 + 1] = ru
				end
			end
			table.sort(I7, function(rI, ru)
				if rI.mine ~= ru.mine then
					return rI.mine == true
				end
				if hI == 2 then
					return rI.v > ru.v
				end
				if hI == 3 then
					return rI.sc > ru.sc
				end
				return rI.at > ru.at
			end)
			if V7 then
				qu = K
				qu.frz = qu.frz or os.clock()
				Pu = {}
				for rI, rI in ipairs(I7) do
					if ZI[rI.id] then
						Pu[#Pu + 1] = rI
					else
						du = if (rI.seen or 0) > K.frz then du + 1 else du
					end
				end
				table.sort(Pu, function(rI, ru)
					return ZI[rI.id].h.LayoutOrder < ZI[ru.id].h.LayoutOrder
				end)
				I7 = Pu
			else
				K.frz = nil
			end
			K.pill.Visible = V7 and du > 0
			if K.pill.Visible then
				pI[K.pill](("+%d NEW OFFER%s"):format(du, du == 1 and "" or "S"))
			end
			local rI, du, ru = false, 0, false
			for wu, bu in ipairs(I7) do
				if wu > 50 then
					break
				end
				rI = rI or bu.mine == true
				Pu, qu = v[bu.tier].pets[bu.side], gI and V[gI.id]
				local Tu, yu, lu = u(Pu, bu.sc, bu.muts), j(bu), L(Pu, bu.sc, bu.muts)
				if qu then
					if qu.t.id == bu.tier then
						if qu.s ~= bu.side then
							if qu.t.ld then
							else
								local j, j, Wu = c7(gI.id, gI.sc, gI.muts, Pu, bu.sc, bu.muts)
								Tu = b7(bu.sc) .. "  " .. r7("AEB8CC", "Est.") .. " " .. W7(Wu) .. " " .. b7(j)
							end
						else
						end
					else
					end
				else
				end
				local j, b7, Wu, Eu = tostring(bu.mine), bu.at, tostring(wI[bu.id]), lI
				local Fu, su = tostring(Eu[bu.tier]), C[20](tostring(yu))
				local au, Ju = ("%s|%s|%s|%s|%s|%s|%s"):format(j, b7, Tu, lu, Wu, Fu, C:QH(su)), ZI[bu.id]
				Mu[bu.id] = true
				if Ju then
					if Ju.sig ~= au then
						X(bu.id, Ju)
						Ju = nil
					else
					end
				else
				end
				if Ju then
					Ju.h.LayoutOrder, Ju.h.Visible = wu, true
					Fu = E7(bu.at)
					if Ju.tm.Text ~= Fu then
						Ju.tm.Text = Fu
					end
				else
					if du < 15 then
						du += 1
						j, Wu, b7 = x7(K.grid, Y(), nil, wu)
						if bu.mine then
							j.UIStroke.Color = m
						elseif yu then
							j.UIStroke.Color = s(60, 200, 0)
						end
						Q7(Pu, 88, j, Y(0, 44, 0.5, 0))
						h(j, Pu, R(88, 7), Y(1, -200, 0, 20), 18)
						Eu = J7(j, E7(bu.at), Y(1, -9, 0, 8), R(110, 18), 15, M.TextXAlignment.Right)
						Eu.AnchorPoint = f(1, 0)
						OI[Eu] = bu
						A7(j, bu.muts, 16, f(0.5, 1), Y(0, 44, 1, -4), R(82, 16), 0)
						R7(j, l7(lu), R(88, 31), Y(1, -222, 0, 24))
						f7(j, Tu, R(88, 59), Y(1, -200, 0, 19))
						T(bu, j)
						ZI[bu.id] = { h = Wu, tm = Eu, sig = au }
						i7(bu.mine and "mine" or bu.id, b7, math.min(wu, 8))
					else
						ru = true
					end
				end
			end
			if ru then
				zI, cI = true, 0
			end
			if not rI then
				MI.mine = nil
			end
			qu = 0
			for T, j in next, ZI, nil do
				if Mu[T] then
				else
					if V7 then
						j.h.Visible = false
					else
						qu += 1
						if qu > 100 then
							X(T, j)
						elseif PI[T] then
							j.h.Visible = false
						else
							X(T, j)
						end
					end
				end
			end
			rI = K
			for T, j in next, rI.FI, nil do
				Pu = T ~= "All" and nI.status[T] == "COMPLETED"
				j.ok.Visible, j.b.Icon.ImageTransparency = Pu, Pu and 0.3 or 0
			end
			if not K.noRow then
				Pu = K
				Pu.noRow = h7(Pu.grid, Y())
				J7(K.noRow, w7("No partner matches yet"), Y(0, 0, 0.5, -10), Y(1, 0, 0, 20), 15, g)
			end
			K.noRow.Visible = #I7 == 0
		end
		local function T(j, X, MI, ZI, rI, b7, V7)
			local I7 = VI(
				"TextLabel",
				{
					p = ZI,
					s = rI,
					bt = 1,
					t = X,
					RichText = false,
					TextWrapped = true,
					FontFace = Font.new(S, M.FontWeight.Heavy),
					TextSize = MI,
					TextColor3 = b7 or s(240, 240, 248),
					TextXAlignment = V7 or t,
					TextYAlignment = M.TextYAlignment.Center,
					z = 5,
				},
				j
			)
			F("UIStroke", { Color = A, Thickness = MI > 12 and 1.6 or 1.2, Parent = I7 })
			return I7
		end
		local function t(S, j, X, MI, ZI, rI)
			_7(
				VI(
					"ImageLabel",
					{
						a = X,
						p = MI,
						s = R(ZI, ZI),
						bc = Q,
						bt = 0.9,
						bs = 0,
						st = x,
						z = rI,
						i = ("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150"):format(j or 1),
					},
					S
				),
				1
			)
		end
		local function S(j, X, MI)
			local ZI, rI = (TI[tI.id] or {})[X - 1], j.me == true
			local b7 = X == 1 and 0 or ZI and ZI.me == true == rI and 5 or 12
			local V7 = rI and 1 or 0
			local function I7(Mu, du)
				local qu = VI("Frame", { s = Y(1, 0, 0, Mu + b7), bt = 1, o = X }, K.msgs)
				if b7 ~= 5 then
					local X
					if rI then
						local Pu = Z[1]
						X = Pu.UserId
					else
						X = rI
					end
					t(qu, X or tI.uid, f(V7, 0), Y(V7, 0, 0, b7), 32, 5)
				end
				local X = VI("Frame", { bs = 0 })
				local Pu = m7(X, h7(qu, R(du, Mu), Y(V7, rI and -40 or 40, 0, b7), f(V7, 0)))
				_7(X, 0)
				X.BackgroundColor3, X.BackgroundTransparency = rI and Q or s(120, 190, 255), rI and 0.83 or 0.8
				if MI then
					g7(Pu)
				end
				return X
			end
			if j.kind == "join" then
				T(
					I7(30, 260),
					rI and Z7("You are joining their server...")
						or (tI and tI.dn or "Partner") .. " " .. Z7("is joining your server..."),
					14,
					R(14, 0),
					Y(1, -28, 1, 0),
					m
				)
				return
			end
			if j.kind then
				local X = j.kind == "server"
				local MI, b7 = not rI or X, X and (j.n or 0) >= (j.max or 1)
				ZI = I7(40, MI and 260 or 200)
				T(
					ZI,
					rI and (X and "YOU SHARED YOUR SERVER" or "YOU SHARED YOUR NAME")
						or X and "SERVER INVITE"
						or "ROBLOX NAME",
					11,
					R(14, 4),
					Y(1, MI and -100 or -28, 0, 13),
					m
				)
				T(
					ZI,
					X
							and ("%d/%d players%s"):format(
								j.n or 0,
								j.max or 0,
								b7 and '  <font color="#FF6868">FULL</font>' or ""
							)
						or "@" .. j.t,
					15,
					R(14, 18),
					Y(1, MI and -100 or -28, 0, 18)
				).RichText =
					true
				if MI then
					local MI, rI = X and "JOIN" or "COPY", X and (b7 and "gray" or "green")
					o(ZI, MI, rI or "blue", R(70, 28), function()
						if not X then
							pcall(setclipboard, j.t)
							local X = c
							return X("Name copied!")
						end
						if j.t == n.JobId then
							local X = c
							return X("You are already in this server")
						end
						if b7 then
							local X = c
							return X("Their server is full")
						end
						c("Teleporting to their server...")
						local X = tI and tI.mid
						task.spawn(function()
							local MI = not X
							if X then
								task.spawn(function()
									pcall(GI, "join", { m = X })
									MI = true
								end)
							end
							local X = os.clock()
							while true do
								local rI = not MI and os.clock() - X < 1.5
								if not rI then
									break
								end
								task.wait()
							end
							n7 = { t = os.clock(), n = 0, pl = tonumber(j.pl) or n.PlaceId, job = j.t }
							local X, X, MI = Z[1], pcall(b.TeleportToPlaceInstance, b, n7.pl, j.t, Z[1])
							if not X then
								c(Z7("Could not join") .. ": " .. tostring(MI):sub(1, 60))
							end
						end)
					end, Y(1, -10, 0.5, 0), f(1, 0.5))
				end
				return
			end
			ZI = d("TextService"):GetTextSize(j.t, 15, M.Font.GothamBlack, f(236, 10000))
			T(
				I7(math.max(math.ceil(ZI.Y) + 8, 26), math.max(math.ceil(ZI.X) + 28, 52)),
				j.t,
				15,
				R(14, 0),
				Y(1, -28, 1, 0),
				nil,
				ZI.X + 28 < 52 and g or nil
			)
		end
		local function b(T)
			return T and tostring(T.me) .. (T.kind or "") .. tostring(T.t) or ""
		end
		local function T()
			task.delay(0.05, function()
				K.msgs.CanvasPosition = f(0, 100000)
			end)
		end
		KI = function()
			local j, X = tI and TI[tI.id] or {}, K.thHead
			local MI = tI ~= nil and EI.p == tI.id and #j >= EI.n and #j - EI.n < 60 and b(j[EI.n]) == EI.sig
			X:ClearAllChildren()
			if not MI then
				H7(K.msgs)
			end
			K.thBody.Visible, K.emptyC.Visible = tI ~= nil, tI == nil
			if not tI then
				EI.p = nil
				return
			end
			local ZI = tI
			local rI = v[ZI.tier].pets[ZI.side]
			t(X, ZI.uid, f(0.5, 0.5), R(30, 28), 40, 4)
			local t, n7 =
				ZI.dn or "Partner",
				ZI.here and '  <font color="#7CF25A">' .. Z7("in your server") .. "</font>"
					or ZI.jn == 2 and '  <font color="#FFD24A">' .. Z7("joining your server") .. "</font>"
			J7(
				X,
				"<b>"
					.. t
					.. "</b>"
					.. (n7 or ZI.off and '  <font color="#FF6868">' .. Z7("offline") .. "</font>" or ""),
				R(58, 7),
				Y(1, -170, 0, 22),
				19
			)
			J7(X, D7(ZI), R(58, 31), Y(1, -170, 0, 18), 14)
			o(X, "CANCEL", "red", R(84, 26), function()
				local t = ZI.jn
				if t then
					if t > 0 then
						if not ZI.here then
							local t = c
							return t("Wait, one of you is joining the other's server")
						end
					end
				end
				O7(
					"Cancel match?",
					function(t)
						N7(t, 137, 250, ("Stop fusing with %s?"):format(ZI.dn or "your partner"), rI, ZI.sc, ZI.muts)
						J7(t, D7(ZI), Y(0, 0, 1, -50), Y(1, 0, 0, 26), 21, g)
						J7(
							t,
							w7("The chat closes and both of you go back to the list."),
							Y(0, 0, 1, -20),
							Y(1, 0, 0, 20),
							16,
							g
						)
					end,
					"YES, CANCEL",
					"red",
					function()
						p7(ZI, false)
					end,
					560,
					396
				)
			end, Y(1, -10, 0, 28), f(1, 0.5))
			X = MI and EI.n + 1 or math.max(1, #j - 59)
			EI.p, EI.n, EI.sig = ZI.id, #j, b(j[#j])
			if X > #j then
				return
			end
			for t = X, #j, 1 do
				S(j[t], t, MI and not j[t].me)
			end
			T()
		end
		local function t(j)
			task.spawn(function()
				local X = GI("accept", { id = j.rq })
				if not (X and X.ok) then
					local MI = c
					return MI(X7(X, "Could not match: "))
				end
				c("Matched! " .. D7(j))
				for MI, ZI in next, dI.L, nil do
					if ZI.tier == j.tier then
						Ou(MI)
					end
				end
				Cu()
				dI.want = "m:" .. tostring(X.id)
				N()
			end)
		end
		jI = function()
			local j, X, MI = K.side, 0, {}
			H7(j)
			local function ZI(rI)
				if not MI[rI] then
					MI[rI] = true
					X += 1
					J7(h7(j, Y(1, 0, 0, 22), nil, nil, X), "<b>" .. rI .. "</b>", Y(), e(1, 1), 15)
				end
			end
			local function MI(rI, n7)
				X += 1
				local b7 = v[rI.tier]
				local H7 = b7.pets[rI.side]
				local V7 = b7.pets[3 - rI.side]
				local I7, Mu, Mu = x7(j, Y(1, 0, 0, n7 and 144 or 104), nil, X)
				if tI == rI or n7 then
					I7.UIStroke.Color = m
					s7(I7.UIStroke, tI == rI and 3 or 2)
				end
				Q7(H7, 52, I7, R(42, 38))
				h(I7, H7, R(76, 8), Y(1, -84, 0, 19), 17)
				e7(I7, H7, rI.sc, rI.muts, R(76, 29), Y(1, -84, 0, 21))
				f7(I7, u(H7, rI.sc, rI.muts), R(76, 52), Y(1, -84, 0, 16))
				A7(I7, rI.muts, 14, f(0.5, 0), R(42, 62), R(70, 14), 0)
				J7(I7, D7(rI, true), R(8, n7 and 78 or 80), Y(1, -14, 0, n7 and 24 or 18), n7 and 18 or 14)
				if n7 then
					b7 = VI("Frame", { p = Y(0, 8, 1, -38), s = Y(1, -16, 0, 30), bt = 1 }, I7)
					O(b7, true, 6, 2)
					o(b7, "ACCEPT", nil, R(100, 30), function()
						if j7(rI.tier) then
							local u = c
							return u("You already finished this shrine")
						end
						if next(lI) then
							local u = c
							return u("You are in a room, finish or cancel it first")
						end
						local u = lI
						if u[rI.tier] then
							local u = c
							return u("You already have a partner for this shrine")
						end
						local u = H(rI)
						O7(
							"Accept partner?",
							function(h)
								N7(h, 0, 250, "THEY GIVE", H7, rI.sc, rI.muts)
								N7(h, 274, 250, "YOU GIVE", V7, u and u.sc, u and u.muts, "Not in your bag")
								J7(h, D7(rI), Y(0, 0, 1, -30), Y(1, 0, 0, 30), 24, g)
							end,
							"ACCEPT",
							nil,
							function()
								t(rI)
							end,
							560,
							372
						)
					end, nil, nil, 1)
					o(b7, "DECLINE", "red", R(100, 30), function()
						O7(
							"Decline request?",
							function(u)
								N7(u, 137, 250, "THEY GIVE", H7, rI.sc, rI.muts)
								J7(u, D7(rI), Y(0, 0, 1, -30), Y(1, 0, 0, 30), 24, g)
							end,
							"DECLINE",
							"red",
							function()
								wI[rI.id] = nil
								II()
								jI()
								task.spawn(GI, "decline", { id = rI.rq })
							end,
							560,
							372
						)
					end, nil, nil, 2)
				else
					k7(I7, Mu, function()
						tI = rI
						jI()
						KI()
					end)
				end
				i7((n7 and "rq:" or "ch:") .. rI.id, Mu, X)
			end
			local u, h, t = {}, 0, qI
			for H, H in ipairs(t) do
				if wI[H.id] == "in" then
					u[#u + 1] = H
				end
			end
			table.sort(u, function(H, rI)
				return (H.at or 0) > (rI.at or 0)
			end)
			t = #u
			if j.CanvasPosition.Y > 8 and K.rqS then
				local H = {}
				for rI, rI in ipairs(u) do
					if K.rqS[rI.id] then
						H[#H + 1] = rI
					else
						h += 1
					end
				end
				u = H
			else
				K.rqS = {}
				for H, rI in ipairs(u) do
					if H <= 20 then
						K.rqS[rI.id] = true
					end
				end
			end
			if K.rqPill then
				K.rqPill.Visible = h > 0
			end
			if h > 0 then
				if K.rqPill then
					pI[K.rqPill](("+%d NEW REQUEST%s"):format(h, h == 1 and "" or "S"))
				end
			end
			for h, H in ipairs(u) do
				if h > 20 then
					break
				end
				ZI("REQUESTS")
				MI(H, true)
			end
			local u = qI
			for h, h in ipairs(u) do
				if wI[h.id] == "ok" then
					ZI("CHATS")
					MI(h)
				end
			end
			if X == 0 then
				J7(h7(j, Y(1, 0, 0, 40), nil, nil, 1), w7("No chats yet"), Y(0, 0, 0.5, -9), Y(1, 0, 0, 18), 14, g)
			end
			u = tostring(t)
			K.dot.Visible, K.dotT.Text, K.dot.Size = t > 0, u, R(#u > 2 and #u * 11 + 8 or 28, 28)
		end
		O7 = function(u, h, t, H, j, X, MI)
			local ZI =
				VI("TextButton", { s = e(1, 1), bc = A, bt = 0.45, t = "", AutoButtonColor = false, z = 60 }, K.gui)
			local qI = B7(X, MI, 50, 5, 2)
			qI.Parent = ZI
			v7(qI, u, 2.4, 4)
			h(VI("Frame", { p = R(18, 60), s = Y(1, -36, 1, -124), bt = 1 }, qI))
			local function u()
				ZI:Destroy()
			end
			o(qI, "BACK", "gray", R(150, 42), u, Y(0.5, -8, 1, -14), f(1, 1))
			o(qI, t, H, R(150, 42), function()
				u()
				j()
			end, Y(0.5, 8, 1, -14), f(0, 1))
			h = workspace.CurrentCamera.ViewportSize
			H = math.min(QI * 1.15, X and 0.96 * h.X / X or 9, MI and 0.92 * h.Y / MI or 9)
			T7(F("UIScale", { Scale = H * 0.8, Parent = qI }), { Scale = H }, 0.32, k)
		end
		p7 = function(u, h, t)
			if not u then
				return
			end
			if u.mid then
				task.spawn(GI, "end", { m = u.mid, done = h and 1 or 0, here = u.here and 1 or 0 })
			end
			local H, o, j
			H, o, j, wI[u.id] = lI, u.tier, u.id, nil
			H[o], TI[j] = nil, nil
			if h then
				nI.status[u.tier] = "COMPLETED"
			end
			if tI == u then
				tI = nil
			end
			II()
			jI()
			KI()
			j = t or h and "Shrine done!"
			c(j or "Match cancelled")
		end
		local function u(h, t, H)
			local o = TI[tI.id]
			o[#o + 1] = h
			S(h, #o)
			EI.n, EI.sig = #o, b(h)
			T()
			t.m = tI.mid
			task.spawn(function()
				local b = GI("msg", t)
				if b and b.ok and H then
					c(H)
				elseif b then
					if b.e then
						if b.e ~= "gone" then
							c(X7(b))
						end
					end
				end
			end)
		end
		local function b(T)
			T = tostring(T or ""):gsub("^%s+", ""):gsub("%s+$", ""):sub(1, 120)
			if T ~= "" then
				if tI then
					K.tb.Text = ""
					u({ me = true, t = T }, { t = T })
				end
			end
		end
		local function T(h, t, S, H)
			if tI then
				u(
					{ me = true, kind = h, t = t, n = S, max = H, pl = n.PlaceId },
					{ k = h, t = t, n = S, x = H, p = n.PlaceId },
					(S and "Server" or "Name") .. " shared with your partner!"
				)
			end
		end
		UI = function(u)
			tI = u
			TI[u.id] = TI[u.id] or {}
			C7(2)
			jI()
			KI()
		end
		II = function()
			zI = true
		end
		local function u(h, t)
			if not gI then
				return
			end
			local S, H, o = U7(gI.id), V[gI.id], gI
			if h then
				if dI.L[S] then
					local h = c
					return h("You already listed this pet, one of each pet")
				end
				pI[K.listB]("LISTED", "blue")
				local h = GI(
					"list",
					{ tier = H.t.n, side = H.s, sc = ("%.3f"):format(o.sc), muts = table.concat(o.muts or {}, ",") }
				)
				if h and h.ok then
					local j =
						{ id = h.id, tier = H.t.id, side = H.s, sc = o.sc, muts = o.muts and #o.muts > 0 and o.muts
							or nil, at = os.time() }
					dI.L[S] = j
					pu(j)
					if t then
						c("You are listed! Players can send you a request")
					end
				else
					c(X7(h, "Could not list: "))
				end
			else
				local h = dI.L[S]
				if h then
					task.spawn(GI, "unlist", { id = h.id })
					Ou(S)
				end
				if t then
					c("You left the list")
				end
			end
			Cu()
			G7(Zu())
			II()
		end
		local function h()
			local t = K.offBox
			t:ClearAllChildren()
			pI[K.pickB](gI and "CHANGE" or "CHOOSE PET", gI and "gray" or "blue")
			if not gI then
				return J7(t, w7("Choose the shrine pet you want to give"), R(14, 19), Y(1, -20, 0, 20), 16)
			end
			local S, H, o = c7(gI.id, gI.sc, gI.muts)
			Q7(gI.id, 42, t, Y(0, 32, 0.5, 0))
			local j = Z[74]
			J7(
				t,
				"<b>" .. j(gI.id) .. "</b>  " .. W7(L(gI.id, gI.sc, gI.muts)) .. ("  x%.2f"):format(gI.sc),
				R(62, 9),
				Y(1, -66, 0, 20),
				17
			)
			J7(
				t,
				w7("Est. ")
					.. r7("FFD65A", Z[74](S))
					.. " "
					.. W7(o)
					.. (" x%.2f "):format(H)
					.. r7("AEB8CC", F7(S, H, gI.muts)),
				R(62, 30),
				Y(1, -66, 0, 17),
				14
			)
		end
		local function L(t, S)
			local H = K.INVT:Clone()
			local o = H.BaseTemplate.Mutations
			H.Name, H.LayoutOrder, H.Visible, H.AutoButtonColor, H.BackgroundColor3, H.BackgroundTransparency, H.UIStroke.Thickness =
				"Pet", S, true, false, A, 0.5, 0
			H.BaseTemplate.Amount.Visible, o.Visible, H.FavIcon.Visible, H.Icon.Image, H.Icon.ImageColor3 =
				false, false, false, B(t.id), t.why and s(110, 110, 110) or Q
			Y7(H.ToolName, t.id)
			Y7(H.Shadow, t.id)
			S = nil
			S, H.ToolName.Text, H.Shadow.Visible, H.Weight.Visible, H.Weight.Text, H.Weight.Size =
				Z[74], Z[74](t.id), true, true, ("x%.2f"):format(t.sc), e(0.44, 0.17)
			R7(H, l7(t.v), e(0.05, 0.03), e(0.5, 0.16)).ZIndex = 24
			if #t.muts > 0 then
				o.Visible, o.Position, o.Size, o.ZIndex, o.Template.Visible =
					true, e(0.05, 0.19), e(0.9, 0.15), 24, false
				for S, S in ipairs(o:GetChildren()) do
					if S:IsA("UIListLayout") then
						S.SortOrder, S.Padding = M.SortOrder.LayoutOrder, UDim.new(0, 3)
					end
				end
				u7(o, t.muts, 22)
			end
			if t.why then
				o = J7(H, r7("FF6868", t.why), e(0, 0.42), e(1, 0.17), 14, g)
				H.BackgroundTransparency = 0.75
				o.TextScaled = true
				o.ZIndex = 25
				o.BackgroundTransparency = 0.35
				o.BackgroundColor3 = A
			end
			if gI then
				if gI.uid == t.uid then
					H.UIStroke.Color, H.UIStroke.Thickness = m, 3
				end
			end
			H.Parent = K.pgrid
			if not t.why then
				k7(H, H:FindFirstChild("ButtonUIScale") or F("UIScale", { Parent = H }), function()
					gI = t
					Cu()
					K.picker.Visible = false
					h()
					II()
					jI()
					KI()
					c(Z[74](t.id) .. " selected, press LIST ME")
				end)
			end
		end
		local function A()
			local t = Z[9]
			local S, S, H = t("RF/ShrineFusion/AskState")
			if S then
				if type(H) == "table" then
					if not (type(H.Status) == "table") then
						return
					end
				else
					return
				end
			else
				return
			end
			t = K7()
			nI.status = H.Status
			if K7() == t then
				return
			end
			pcall(z7)
			NI = true
			S = false
			for t, H in next, dI.L, nil do
				if j7(H.tier) then
					task.spawn(GI, "unlist", { id = H.id })
					Ou(t)
					S = true
				else
				end
			end
			if gI then
				if j7(V[gI.id].t.id) then
					gI = nil
				end
			end
			Cu()
			if S then
				c("You finished this shrine, your offer was removed")
			end
			task.spawn(GI, "st")
			II()
		end
		local function t()
			task.spawn(A)
			local S, H = ipairs, K.pgrid
			for o, o in S(H:GetChildren()) do
				if o.Name == "Pet" then
					o:Destroy()
				end
			end
			H = WI
			for S, o in ipairs(H) do
				L(o, S)
			end
			K.picker.EmptyState.Visible, K.picker.Visible, K.psc.Scale = #WI == 0, true, 0.6
			T7(K.psc, { Scale = 1 }, 0.3, k)
		end
		C7 = function(L)
			kI = L
			local S, H = ipairs, K.tabs
			for o, V in S(H) do
				V.BackgroundColor3 = o == L and Q or s(104, 111, 122)
				K.pages[o].Visible = o == L
			end
			g7(K.pages[L]:FindFirstChildOfClass("UIScale") or F("UIScale", { Parent = K.pages[L] }))
		end
		local function L()
			if K.grid then
				K.grid.CanvasPosition = Vector2.zero
			end
			K.frz = nil
		end
		local function S(H)
			L()
			uI, LI = H, nil
			local o = H and v[H]
			if o then
				local V, j = ipairs, o.pets
				for X, MI in V(j) do
					if gI and gI.id == MI then
						LI = o.pets[3 - X]
					elseif not gI then
						if nI.have[MI] then
							LI = o.pets[3 - X]
						end
					end
				end
			end
			XI()
			o = K
			for V, j in next, o.FI, nil do
				local o, X, MI = V == (H or "All"), j.sc, {}
				MI.Scale = o and 1.12 or 0.92
				T7(X, MI, 0.2)
				j.b.SectionTitle.TextColor3 = o and m or Q
			end
			II()
		end
		XI = function()
			local m = uI and v[uI]
			K.q.Parent.Parent.Visible, K.wantBox.Visible = not m, m ~= nil
			pI[K.WB[0]]("BOTH", LI == nil and "blue" or "gray")
			for H = 1, 2, 1 do
				local o, V = pI[K.WB[H]]
				if m then
					local j = Z[74]
					V = j(m.pets[H]):upper()
				else
					V = m
				end
				local j, X = V or ""
				if m then
					V = LI
					X = V == m.pets[H]
				else
					X = m
				end
				o(j, X and "blue" or "gray")
				K.WI[H].Image = m and B(m.pets[H]) or ""
			end
		end
		M7 = function(m)
			if m == xI then
				return
			end
			xI = m
			if m then
				task.spawn(function()
					pcall(z7)
					NI = true
				end)
				dI.kick = 0
				h()
				S(uI)
				jI()
				KI()
				C7(kI)
				K.gui.Enabled, K.wsc.Scale = true, QI * 0.6
				T7(K.wsc, { Scale = QI }, 0.32, k)
			else
				local H, o = K.wsc, {}
				o.Scale = QI * 0.6
				T7(H, o, 0.18, M.EasingStyle.Quad, M.EasingDirection.In).Completed:Once(function()
					if not xI then
						K.gui.Enabled = false
					end
				end)
			end
			if SI then
				task.spawn(pcall, function()
					if m then
						SI:select()
					else
						SI:deselect()
					end
				end)
			end
		end
		local function m()
			local H = Z[1]
			local o, V = H.PlayerGui, d("SoundService")
			local j, X, MI =
				o.PetFuse.FuseMain,
				q7(o, "HUD", "GameHUD", "BottomLeft", "Money", "Value"),
				q7(o, "Index", "Frame", "TabButtons", "World")
			FI, YI, RI = j, X, MI
			local ZI, nI, qI, rI, TI =
				K,
				FI.FuseInputs.Input1,
				FI.Fuse,
				FI.Info1,
				q7(P, "Controllers", "GUI", "BackpackController", "Main", "InventoryTemplate")
			sI, aI, JI = nI, qI, rI
			ZI.INVT = TI
			pcall(function()
				local EI, FI = next, Z[34]
				local sI, aI = FI.Mut.All()
				for FI, JI in EI, sI, aI do
					I[FI] = JI.IconAssetId and "rbxassetid://" .. tostring(JI.IconAssetId)
				end
			end)
			I.Boss, I.Scrambled, I.Enchanted, I.Nitro, I.Spectral =
				i.fractured, i.scramble, i.essence, i.nitro, i.spectral
			task.spawn(A)
			H = K
			H.snd = F("Sound", { SoundId = "rbxassetid://100671636189844", Volume = 3.4, Parent = V })
			pcall(function()
				K.snd.SoundGroup = V:FindFirstChild("Gameplay")
			end)
			local V = d("CoreGui")
			pcall(function()
				local d = gethui()
				if typeof(d) == "Instance" then
					V = d
				end
			end)
			ZI, MI =
				F(
					"ScreenGui",
					{
						ResetOnSpawn = false,
						IgnoreGuiInset = true,
						DisplayOrder = 40,
						ZIndexBehavior = M.ZIndexBehavior.Sibling,
						Enabled = false,
						Parent = V,
					}
				),
				B7(eI, fI, 66, 6, 2.2)
			j = nil
			j, ZI.Name = K, "ShrineFinder"
			j.gui = ZI
			MI.Parent = ZI
			TI = MI.Close
			v7(MI, "Fusion Finder", 2.8, 4.6)
			s7(TI.UIStroke, 2.6)
			s7(TI.TextLabel.UIStroke, 2.6)
			TI.Size, TI.AnchorPoint, TI.Position = R(50, 50), f(0.5, 0.5), Y(1, -36, 0, 10)
			j = K
			j.wsc = F("UIScale", { Parent = MI })
			local function d()
				local V, I = workspace.CurrentCamera.ViewportSize, game:GetService("UserInputService")
				QI = I.TouchEnabled and not I.KeyboardEnabled and math.min(0.66 * V.Y / fI, 0.97 * V.X / eI)
					or math.min(0.575 * V.Y / fI, 0.95 * V.X / (eI + 300))
				K.wsc.Scale = QI
			end
			d()
			nI = K
			nI.cv = W(workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), d)
			do
				local V, I = x7(MI, R(600, 40), Y(0.5, 0, 1, 16))
				I.AnchorPoint = f(0.5, 0)
				I.Visible = false
				I.ZIndex = 20
				V.BackgroundTransparency = 0.2
				local EI, FI = J7(V, "", Y(), e(1, 1), 18, g), 0
				function c(c)
					FI += 1
					local V = FI
					c = Z7(c)
					EI.Text, I.Visible, I.Position = c, true, Y(0.5, 0, 1, 4)
					T7(I, { Position = Y(0.5, 0, 1, 16) }, 0.3, k)
					task.delay(2.4, function()
						if V == FI then
							I.Visible = false
						end
					end)
				end
			end
			rI = eI - 32
			d, j, ZI = VI("Frame", { p = R(16, 52), s = R(rI, fI - 66), bt = 1 }, MI), rI - 276, K
			ZI.off = VI("Frame", { s = e(1, 1), bt = 0.12, bc = s(24, 24, 34), z = 40, v = false }, d)
			VI("UICorner", { CornerRadius = UDim.new(0, 10) }, K.off)
			H = K
			H.offT = J7(H.off, "", e(0.06, 0.3), e(0.88, 0.4), 24, g)
			K.offT.TextWrapped, K.offT.ZIndex = true, 41
			X, H =
				VI("Frame", { a = f(1, 0), p = R(-14, 40), s = R(168, 150), bt = 1 }, MI),
				VI("Frame", { p = Y(1, 26, 0, 24), s = Y(0, 96, 1, -24), bt = 1 }, MI)
			O(X, false, 10)
			O(H, false, 6)
			nI, ZI, rI, qI = K, K, K, K
			K.pages = {}
			nI.tabs = {}
			ZI.FI = {}
			rI.WB = {}
			qI.WI = {}
			ZI, rI = ipairs, { "Find", "Chats" }
			for k, c in ZI(rI) do
				K.pages[k] = VI("Frame", { a = f(0.5, 0.5), p = e(0.5, 0.5), s = e(1, 1), bt = 1, v = k == 1 }, d)
				nI, qI = h7(X, Y(1, 0, 0, 64), nil, nil, k), RI:Clone()
				qI.TextLabel.Text = c
				if k == 2 then
					qI.Icon.Image, qI.Icon.Size = p[2]("chat"), e(0.3, 0.9)
				end
				c = m7(qI, nI)
				a7(qI)
				s7(qI.UIStroke, 3)
				s7(qI.StrokeHolder.UIStrokeClr, 2.4)
				s7(qI.TextLabel.UIStroke, 2.6)
				k7(qI, c, function()
					C7(k)
				end)
				K.tabs[k] = qI
			end
			ZI = K
			ZI.dot = VI(
				"Frame",
				{ a = f(0.5, 0.5), p = Y(1, -19, 0, 17), s = R(28, 28), bc = s(255, 20, 20), z = 10, v = false },
				K.tabs[2]
			)
			_7(K.dot, 1)
			F("UIStroke", { Thickness = 2.4, Parent = K.dot })
			rI = K
			rI.dotT = J7(rI.dot, "", e(0.5, 0.5), Y(1, -6, 1, -6), 18, g)
			K.dotT.AnchorPoint, K.dotT.TextScaled, K.dotT.ZIndex = f(0.5, 0.5), true, 11
			d, X, qI, ZI, nI = q7(o, "RobuxShop", "Frame", "ButtonsHolder", "Featured"), ipairs, {}, _[1], _[2]
			C:EH(qI, 0, { id = "All" }, ZI, nI, _[3], _[4])
			for C, p in X(qI) do
				nI, ZI = h7(H, Y(1, 0, 0, 86), nil, nil, C), d:Clone()
				ZI.SectionTitle.Text, ZI.SectionTitle.TextColor3, ZI.Icon.Image =
					p.id, Q, p.out and B(p.out) or RI.Icon.Image
				P7(ZI, "NavigationTouchTarget")
				rI = m7(ZI, nI)
				ZI.Size = R(72, 72)
				s7(ZI.SectionTitle.UIStroke, 2.2)
				k7(ZI, rI, function()
					S(p.out and p.id)
				end)
				local C, k, S = K.FI, p.id, { b = ZI, sc = rI }
				S.ok, C[k] =
					VI(
						"ImageLabel",
						{ a = f(1, 1), p = Y(1, 0, 1, -18), s = R(34, 34), bt = 1, i = i.check, st = x, v = false, z = 10 },
						ZI
					),
					S
			end
			qI = K.pages[1]
			rI = VI("Frame", { s = Y(1, 0, 0, 34), bt = 1 }, qI)
			O(rI, true, 8)
			local C, p
			C = t7(rI, "CAN FUSE", "gray", R(130, 34), function()
				AI = not AI
				pI[C](nil, AI and "green" or "gray")
				II()
			end, nil, nil, 1)
			p = t7(rI, "NEWEST", "blue", R(130, 34), function()
				hI = hI % 3 + 1
				pI[p](({ "NEWEST", "MOST $/S", "BIGGEST" })[hI])
				L()
				II()
			end, nil, nil, 2)
			X = x7(rI, R(j, 34), nil, 3)
			X.BackgroundTransparency = 0.3
			nI = K
			nI.q = o7(X, "Search pet...", R(10, 0), Y(1, -20, 1, 0), Q, s(160, 160, 175))
			W(K.q:GetPropertyChangedSignal("Text"), function()
				mI = K.q.Text:lower()
				L()
				II()
			end)
			H = K
			H.wantBox = VI("Frame", { s = R(j, 34), bt = 1, o = 4, v = false }, rI)
			O(K.wantBox, true, 8)
			K.WB[0] = t7(K.wantBox, "BOTH", "gray", R(80, 34), function()
				LI = nil
				L()
				XI()
				II()
			end, nil, nil, 0)
			for C = 1, 2, 1 do
				X, H = t7(K.wantBox, "", "gray", Y(0, (j - 96) / 2, 0, 34), function()
					LI = v[uI].pets[C]
					L()
					XI()
					II()
				end, nil, nil, C)
				rI = H.Price
				K.WB[C], rI.AnchorPoint, rI.Position, rI.Size =
					X, f(0.5, 0.5), Y(0.5, 18, 0.5, 0), Y(1, -60, rI.Size.Y.Scale, rI.Size.Y.Offset)
				K.WI[C] =
					VI("ImageLabel", { a = f(0, 0.5), p = Y(0, 6, 0.5, 0), s = R(40, 40), bt = 1, st = x, z = 8 }, H)
			end
			rI = K
			rI.grid = S7(qI, R(0, 42), Y(1, 0, 1, -108))
			F(
				"UIGridLayout",
				{ CellSize = Y(0.5, -5, 0, 86), CellPadding = R(8, 8), SortOrder = M.SortOrder.LayoutOrder, Parent = K.grid }
			)
			y7(K.grid, 2, 8, 2, 4)
			W(K.grid:GetPropertyChangedSignal("CanvasPosition"), function()
				if K.grid.CanvasPosition.Y <= 8 then
					if K.pill.Visible then
						II()
					end
				end
			end)
			rI = K
			rI.pill = t7(qI, "NEW OFFERS", "blue", R(200, 30), function()
				K.grid.CanvasPosition = Vector2.zero
				II()
			end, Y(0.5, 0, 0, 46), f(0.5, 0))
			K.pill.Visible, K.pill.ZIndex = false, 40
			d, j = x7(qI, Y(1, 0, 0, 58), Y(0, 0, 1, -58)), K
			j.offBox = VI("Frame", { s = Y(1, -270, 1, 0), bt = 1 }, d)
			qI = K
			qI.pickB = t7(d, "CHOOSE PET", "blue", R(130, 40), function()
				t()
			end, Y(1, -146, 0.5, 0), f(1, 0.5))
			X = K
			X.listB = t7(d, "LIST ME", nil, R(126, 40), function()
				if not gI then
					return t()
				end
				task.spawn(u, not iI, true)
			end, Y(1, -10, 0.5, 0), f(1, 0.5))
			local C = o.PetFuse.FusePetInventory:Clone()
			C.Visible, C.ZIndex, C.AnchorPoint, C.Position, C.Size = false, 50, f(0.5, 0.5), e(0.5, 0.5), R(eI, fI)
			P7(C, "IncludeEquipped")
			P7(C, "UIAspectRatioConstraint")
			C.Header.Title.Text, C.Header.Title2Stroke.Text, C.Title.Text, C.EmptyState.Text =
				"Choose Pet", "Choose Pet", "Select the pet you will give!", "No shrine pet in your bag yet."
			nI = nil
			nI, C.Parent = K, MI
			nI.picker = C
			pcall(function()
				C.Title.UITextSizeConstraint.MaxTextSize = 26
			end)
			MI, X, rI, nI = K, K, F("UIScale", { Parent = C }), C.ScrollingFrame
			MI.psc = rI
			X.pgrid = nI
			K.pgrid.UIGridLayout.CellSize, K.pgrid.UIGridLayout.CellPadding = R(156, 156), R(14, 14)
			L7(C.Close, function()
				C.Visible = false
			end)
			ZI, MI = K.pages[2], K
			MI.side = S7(ZI, Y(), Y(0, 240, 1, 0))
			o = K
			o.rqPill = t7(ZI, "NEW REQUESTS", "blue", R(210, 30), function()
				K.side.CanvasPosition = Vector2.zero
				K.rqS = nil
				jI()
			end, Y(0, 120, 0, 6), f(0.5, 0))
			K.rqPill.Visible, K.rqPill.ZIndex = false, 40
			W(K.side:GetPropertyChangedSignal("CanvasPosition"), function()
				if K.side.CanvasPosition.Y <= 8 then
					if K.rqPill.Visible then
						jI()
					end
				end
			end)
			O(K.side, false, 6)
			y7(K.side, 2, 10, 2, 4)
			MI, d, qI = x7(ZI, Y(1, -250, 1, 0), R(250, 0)), K, K
			nI, ZI =
				VI("Frame", { s = Y(1, 0, 0, 58), bt = 1 }, MI),
				VI("Frame", { p = R(0, 58), s = Y(1, 0, 1, -58), bt = 1 }, MI)
			d.thHead = nI
			qI.thBody = ZI
			d = K
			d.msgs = S7(d.thBody, Y(), Y(1, 0, 1, -58))
			O(K.msgs, false, 0)
			y7(K.msgs, 12, 14, 12, 8)
			d = VI("Frame", { p = Y(0, 10, 1, -48), s = Y(1, -20, 0, 40), bt = 1 }, K.thBody)
			t7(d, "SERVER", "blue", R(92, 40), function()
				T("server", n.JobId, #q:GetPlayers(), q.MaxPlayers)
			end, Y())
			t7(d, "NAME", "gray", R(76, 40), function()
				local C = Z[1]
				T("name", C.Name)
			end, R(98, 0))
			qI = VI("Frame", { p = R(182, 0), s = Y(1, -270, 1, 0), bc = s(24, 24, 32), bs = 0 }, d)
			F("UICorner", { CornerRadius = UDim.new(0, 10), Parent = qI })
			F("UIStroke", { Color = s(82, 82, 107), Thickness = 1.5, Parent = qI })
			rI = K
			rI.tb = o7(qI, "Message...", R(12, 0), Y(1, -24, 1, 0), s(240, 240, 248), s(120, 124, 150))
			t7(d, "SEND", nil, R(80, 40), function()
				b(K.tb.Text)
			end, e(1, 0), f(1, 0))
			X = K
			X.emptyC =
				J7(MI, w7("Accept a request, or send one from Find"), Y(0, 10, 0.5, -11), Y(1, -20, 0, 22), 16, g)
			W(K.tb.FocusLost, function(C)
				if C then
					b(K.tb.Text)
				end
			end)
			L7(TI, function()
				M7(false)
			end)
			task.spawn(function()
				pcall(function()
					local C = require(P.Packages.TopBarPlus)
					for O, O in pairs(C.getIcons()) do
						if O.name == "ChilliShrineFusion" then
							O:destroy()
						end
					end
					local O = next(C.getIcons()) ~= nil
					SI = C.new()
						:setName("ChilliShrineFusion")
						:setImage(B("Xenorath"))
						:setImageScale(0.85)
						:setCaption("Fusion Finder")
						:setOrder(102)
					if not O then
						SI:align("Right")
					end
					SI:bindEvent("selected", function()
						l.ShrineFinderWant = true
					end)
					SI:bindEvent("deselected", function()
						l.ShrineFinderWant = false
					end)
				end)
				if not SI then
					l.ShrineFinderWant = true
				end
			end)
		end
		local C = W(y, function()
			local O = os.clock()
			if _I ~= 1 then
				if _I ~= 0 then
					return
				elseif O < BI then
					return
				end
				BI = O + 2
				local p = Z[1]
				if not (q7(p, "PlayerGui", "PetFuse", "FuseMain")) then
					return
				end
				if pcall(m) then
					_I = 1
				else
					pcall(game.Destroy, K.gui)
					pcall(game.Destroy, K.snd)
					if K.cv then
						K.cv:Disconnect()
					end
					K = {}
					oI += 1
					_I = oI >= 3 and -1 or 0
				end
				return
			end
			if zI then
				if xI then
					if O >= cI then
						local p
						p, zI = O + 0.25, false
						cI = p
						d7(K.grid.CanvasPosition.Y > 8)
					end
				end
			end
			if xI and O >= vI then
				vI = O + 20
				for p, M in next, OI, nil do
					p.Text = E7(M.at)
				end
			end
			if DI then
				O = DI
				DI = nil
				if lI[O] then
					local p = PI
					p7(p[lI[O]], true)
				end
			end
			O = l.ShrineFinderWant
			if O ~= nil then
				l.ShrineFinderWant = nil
				M7(O)
			end
			if NI then
				NI = false
				if gI then
					O = WI
					for p, p in ipairs(O) do
						if p.uid == gI.uid then
							gI = p
						end
					end
				end
				h()
				II()
				jI()
				KI()
			end
		end)
		task.spawn(function()
			local O, p, M = 0, 0, 0
			while true do
				local n = HI
				if not n then
					break
				end
				task.wait(0.25)
				local d, q = os.clock(), next(lI) ~= nil or next(wI) ~= nil
				q = next(dI.L) ~= nil or q
				n = dI.closed or (dI.fail or 0) >= 2
				if K.off then
					if K.off.Visible ~= (n and true or false) then
						K.off.Visible = n and true or false
					end
				end
				if n then
					if K.offT then
						local P, b, T = "Fusion Finder is closed for now. It will be back soon.", Z[20]
						if b then
							local F = Z[20]
							T = F.tr
						else
							T = b
						end
						b = nil
						if T then
							local F = Z[20]
							b = F.tr(P)
						else
							b = T
						end
						P = b or P
						if K.offT.Text ~= P then
							K.offT.Text = P
						end
					end
				end
				if xI or next(dI.L) then
					if d >= (dI.stAt or 0) then
						dI.stAt = d + 20
						task.spawn(A)
					end
				end
				if xI then
					if not dI.s then
						J()
					end
				end
				if xI then
					if d >= O then
						n = d + 1
						nu()
						O = n
					else
					end
				else
				end
				n = dI.s and (xI or q)
				local O = n and (d >= p or dI.kick == 0)
				if O then
					local P, b = xI
					if P then
						n = kI == 2 and tI and 1 or q and 1.5
						b = n or 5
					else
						b = P
					end
					p = d + (b or 3)
					dI.kick = 1
					N()
				else
				end
				if next(lI) then
					if d >= M then
						O, n = d + 3, Z[67]
						local p = n()
						if p and type(p.ShrineFusion) == "table" then
							local n = lI
							for d in next, n, nil do
								if type(p.ShrineFusion[d]) == "table" then
									DI = d
								end
							end
						end
						M = O
					else
					end
				else
				end
			end
		end)
		local function O()
			HI = false
			C:Disconnect()
			if K.cv then
				K.cv:Disconnect()
			end
			pcall(game.Destroy, K.gui)
			pcall(game.Destroy, K.snd)
			if SI then
				local C = SI
				task.spawn(pcall, function()
					C:destroy()
				end)
			end
			if l.ShrineFinder == O then
				l.ShrineFinder = nil
			end
		end
		l.ShrineFinder = O
		table.insert(Z[20].cleanup, function()
			if l.ShrineFinder == O then
				O()
			end
		end)
	end)
	w("57_fake#1", function()
		local function C(O, p)
			local M, n = O and O.Parent and O.Text ~= p
			if M then
				local d, q = O.Text, Z[20]
				local O, P = q.tr
				if O then
					q = Z[20]
					P = q.tr(p)
				else
					P = O
				end
				n = d ~= (P or p)
			else
				n = M
			end
			return n
		end
		local O, p = setmetatable, { __mode = "k" }
		local M = O({}, p)
		local function O(p, n)
			if C(p, n) then
				local d = M[p]
				if d then
					if d >= 5 then
						return
					end
				end
			else
				return
			end
			M[p] = (M[p] or 0) + 1
			local M, d = pcall(getconnections, p:GetPropertyChangedSignal("Text"))
			if M then
				for M, M in ipairs(d) do
					pcall(M.Disable, M)
				end
			end
			p.Text = n
		end
		task.spawn(function()
			while true do
				local p = Z[56]
				if not p then
					break
				end
				p = Z[20]
				if not p.fake then
					if C(z.tl, z.t0) then
						local M = Z[20]
						M.fake = true
					else
						local M = Z[20]
						if C(M.fbL, "Finder") then
							local C = Z[20]
							C.fake = true
						else
							local C = Z[20]
							if C.fakeG then
								local C = Z[20]
								if C.fakeG() then
									local C = Z[20]
									C.fake = true
								end
							end
						end
					end
				end
				p = Z[20]
				if p.fake then
					local C = Z[20]
					O(C.fbL, "Finder")
				end
				task.wait(1)
			end
		end)
	end)
	w("90_run#1", function()
		local C =
			{ Mutate = true, Bloom = true, Combat = true, Machine = true, Banjo = true, Skyfall = true, Storm = true }
		for O, O in ipairs(U) do
			if C[O.name] then
				O.vis = true
			end
		end
		local function C(O)
			local p = Z[20]
			return p.rank[O.name] or O.pri or 9
		end
		local function O(p)
			local M, n = pcall(p.on)
			return M and n
		end
		local function p()
			table.sort(U, function(M, n)
				local d, q = M.mover and C(M) or 99, n.mover and C(n) or 99
				if d ~= q then
					return d < q
				end
				return M.i < n.i
			end)
		end
		local M, n = Z[20], Z[20]
		M.order = function()
			local M = Z[20]
			if M.unblock then
				local M = Z[20]
				M.unblock()
			end
			p()
		end
		n.rank2 = C
		p()
		local function p(M)
			local n = Z[20]
			local d, q = n.lock
			if d then
				n = Z[20]
				q = n.lock()
			else
				q = d
			end
			return q ~= nil and M.name ~= q
		end
		local function M()
			local n = Z[20]
			if n.invisBusy then
				local d, q = Z[20], Z[20]
				d.busyAt = q.busyAt or os.clock()
				q, d = Z[20], os.clock() - Z[20].busyAt
				if d > 20 then
					local d, q = Z[20], Z[20]
					d.invisBusy = false
					q.busyAt = nil
				end
			else
				local d = Z[20]
				d.busyAt = nil
			end
			n = Z[20]
			local d, q = n.invisBusy
			if d then
				q = d
			else
				n = nil
				n, q = Z[20], os.clock() < (Z[20].invisSettle or 0)
			end
			return q
		end
		local n = Z[20]
		n.needVis = function(n, d)
			local q = n.vis
			return (if type(q) == "function" then q(d) else q) == true
		end
		local function n(d)
			return d.rank or C(d)
		end
		local C = Z[20]
		C.better = function(C)
			local d = Z[20]
			for q, q in ipairs(d.queue or {}) do
				if q ~= C then
					if not q.aux then
						return n(q) < math.max(C.erank or 0, n(C))
					end
				end
			end
			return false
		end
		local function C(d, q, P)
			local w = Z[20]
			if w.lagoonGate then
				local b = Z[20]
				if not (b.lagoonGate(d, P)) then
					return false
				end
			end
			w = Z[20]
			if w.caveGate then
				local b = Z[20]
				if not (b.caveGate(d, P)) then
					return false
				end
			end
			w = Z[20]
			local b = w.needVis(d, q)
			if b then
				q = Z[20]
				if q.invisible() then
					d.flipped = true
					w = Z[20]
					if not (w.body(false)) then
						return false
					end
				end
			end
			if not b then
				q = Z[20]
				if q.invisWant() then
					w = Z[20]
					if not (w.invisible()) then
						if d.name ~= "Steal" then
							local d = Z[20]
							d.body(true)
						end
					end
				end
			end
			return P()
		end
		local function d(q, P)
			local w = Z[4]
			if w then
				CI(w)
				local b = os.clock()
				while true do
					local T = w.busy and Z[56]
					if not (T and os.clock() - b < 10) then
						break
					end
					task.wait()
				end
				if w.busy then
					w.busy = false
					if Z[4] == w then
						Z[4] = nil
					end
				end
			end
			Z[4], q.busy, q.t0, q.plan, q.idle, q.erank = q, true, os.clock(), P, nil, n(q)
			local w = q.tok
			local function b()
				local T = Z[56] and q.tok == w and O(q) and a() and not p(q) and not M()
				return T
			end
			task.spawn(function()
				local w, T = pcall(function()
					if not (C(q, P, b)) then
						return "prep"
					end
					return q.run(P, b)
				end)
				q.acted = w and T == true
				if not w then
					local C = Z[11]
					C(q.name .. ": " .. tostring(T):sub(1, 60), "err")
				end
				if T == "prep" then
					q.at = math.max(q.at, os.clock() + 2)
				end
				if q.flipped then
					if not q.acted then
						if os.clock() - q.t0 < 8 then
							q.at = math.max(q.at, os.clock() + 2)
						end
					end
				end
				q.flipped = nil
				w = Z[8]
				local C, P = w(), Z[15]
				w = P()
				if C then
					if C.PlatformStand then
						P = Z[20]
						if P.lock then
							T = Z[20]
							if not (T.lock()) then
								C.PlatformStand = false
							end
						else
							C.PlatformStand = false
						end
					end
				end
				if w then
					if not w.Anchored then
						T = Z[33]
						w.AssemblyLinearVelocity = T
					end
				end
				w, T = Z[20], Z[20]
				q.busy, q.idle, q.plan, w.mvEnd = false, nil, nil, os.clock()
				T.lastMV = q
				if Z[4] == q then
					Z[4] = nil
				end
			end)
		end
		local function C(q)
			if q.ready then
				local P, w = pcall(q.ready)
				return P and w
			end
			return q.lastWant ~= false
		end
		local function q(P, w)
			local b, T = n(P), n(w)
			if b ~= T then
				return b < T
			end
			return P.i < w.i
		end
		local function P()
			local w, b = {}, Z[20]
			b.schedTok = w
			while true do
				local T, F = Z[56]
				if T then
					b = Z[20]
					F = b.schedTok == w
				else
					F = T
				end
				if not F then
					break
				end
				T, F = xpcall(function()
					local w, b, s, J = os.clock(), {}, {}, ipairs
					for Y, R in J(U) do
						if R.mover then
							if R ~= Z[4] then
								if R.on then
									if O(R) then
										Y = C(R)
										R.inq = Y and true or nil
										if Y then
											R.rank = type(Y) == "number" and Y or nil
											b[#b + 1], s[#s + 1] = R, R
										elseif not R.ready then
											if w >= R.at then
												R.rank = nil
												s[#s + 1] = R
											end
										end
									end
								end
							end
						end
					end
					table.sort(b, q)
					table.sort(s, q)
					local C, q = Z[20], Z[20]
					C.queue = b
					q.queueAt = w
					J = M()
					if if J then not J else a() then
						b = ipairs
						for M, a in b(s) do
							M, q = Z[4], p(a)
							local p, Y = not q
							if q then
								Y = p
							else
								local R, e = not M
								if M then
									local f, Q = M.soft or M.idle
									if f then
										Q = f
									else
										local f, u = a.preempt
										if f then
											u = f
										else
											local A, h = a.name == "Steal"
											if A then
												C = Z[20]
												h = C.dawnNow
											else
												h = A
											end
											if h then
												A = Z[20]
												u = A.dawnNow()
											else
												u = h
											end
										end
										if u then
											local C, A = M.hold
											if C then
												f = Z[21]
												A = (f())
											else
												A = C
											end
											Q = not A
										else
											Q = u
										end
									end
									e = Q and n(a) < M.erank
								else
									e = R
								end
								Y = e or a.urgent and not M.hold
							end
							if Y then
								if not a.aux then
									p = Z[20]
									if p.stealDawn then
										local C = Z[20]
										if C.stealDawn(n(a)) then
											break
										end
									end
								end
								if w < a.at then
									if a.inq then
										break
									end
									continue
								elseif a.busy then
									if a.inq then
										break
									end
									continue
								end
								a.at = w + a.gap
								local C, p = pcall(a.want)
								if C then
									if p == "wait" then
										break
									end
								end
								a.lastWant = C and p ~= nil and p ~= false
								if a.lastWant then
									if Z[4] == M then
										d(a, p)
										break
									end
								end
							end
						end
					end
					J = ipairs
					for C, C in J(U) do
						b, s = Z[56] and not C.mover
						if b then
							q = C.busy
							s = if q then w - (C.bAt or w) > 30 else not q
						else
							s = b
						end
						if s then
							if w >= C.at then
								if C.on then
									if O(C) then
										C.at = w + C.gap
										C.bAt = w
										C.busy = true
										task.spawn(function()
											pcall(C.fn)
											C.busy = false
										end)
									end
								end
							end
						end
					end
				end, debug.traceback)
				if not T then
					local C = Z[20]
					C.schedErr = F
					C = Z[11]
					C("Scheduler: " .. tostring(F):sub(1, 60), "err")
				end
				task.wait(0.25)
			end
		end
		local function C()
			local O, p = xpcall(P, debug.traceback)
			if not O then
				local O = Z[20]
				O.schedErr = "outer: " .. tostring(p)
			end
		end
		task.spawn(C)
		W(y, function()
			if Z[56] then
				local O, O = Z[20], os.clock() - (Z[20].queueAt or os.clock())
				if O > 15 then
					local O, O = Z[20], os.clock() - (Z[20].schedAt or 0)
					if O > 15 then
						local O = Z[20]
						O.schedAt = os.clock()
						O = Z[11]
						O("Scheduler restarted", "warn")
						task.spawn(C)
					end
				end
			end
		end)
		local C = G({ name = "Guard", gap = 0.5 })
		C.on = function()
			local O, p = Z[4] ~= nil and Z[4].name ~= "Treadmill"
			if O then
				local M = Z[20]
				p = (M.hold or 0) == 0
			else
				p = O
			end
			O = nil
			if p then
				local M = Z[20]
				O = not M.lock()
			else
				O = p
			end
			return O
		end
		C.fn = function()
			local O = Z[15]
			local p = O()
			if p then
				if p.Anchored then
					C.n = (C.n or 0) + 1
					if C.n >= 2 then
						C.n = 0
						Z[13](function()
							return true
						end)
					end
				else
					C.n = 0
				end
			else
				C.n = 0
			end
		end
		local C = G({ name = "Info", gap = 1 })
		C.on = function()
			return true
		end
		C.fn = function()
			local C = Z[20]
			if C.tick then
				local C = Z[20]
				D("tick", C.tick)
			end
		end
	end)
	l.ChilliHubSaeCleanup = function()
		local C = Z[1]
		local O, p = C.Character
		if O then
			C = Z[1]
			p = C.Character:GetAttribute("InvisApplied")
		else
			p = O
		end
		Z[56] = false
		O = Z[20]
		for M, M in ipairs(O.cleanup or {}) do
			pcall(M)
		end
		for M, M in ipairs(E) do
			pcall(M.Disconnect, M)
		end
		O = Z[25]
		O.god = false
		pcall(bI)
		C = Z[8]
		if C() then
			pcall(yI, Z[8]())
		end
		pcall(z.Destroy, z)
		if l.StopChilliLink then
			pcall(l.StopChilliLink)
		end
		l.ChilliHubSaeCleanup = nil
		task.spawn(function()
			for C = 1, 2, 1 do
				task.wait(0.5)
				C = Z[9]
				C("RF/Treadmill/AskDoff")
			end
			if p then
				local C = Z[20]
				C.respawn(true)
			end
		end)
	end
	z:Finish()
	if #r > 0 then
		pcall(
			writefile,
			"ChilliLibrary/SAE_LoadErrors.txt",
			os.date("!%Y-%m-%d %H:%M:%S") .. " SAE v2290\10" .. table.concat(r, "\10")
		)
	end
	pcall(writefile, "ChilliLibrary/SAE_LoadPart.txt", "done")
	pcall(getgenv().ChilliHubLoadStep, 10)
	task.delay(1, pcall, function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/tienkhanh1/spicy/refs/heads/main/DiscordLink"))()
	end)
end
