-------------------------------------------------------------------------------------------------------------------------------

if not game:IsLoaded() then game.Loaded:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

local plr = game:GetService("Players")
local rs = game:GetService("RunService")
local lp = plr.LocalPlayer
local cam = workspace.CurrentCamera
local ui = game:GetService("UserInputService")
local mob = ui.TouchEnabled
local test = false

-------------------------------------------------------------------------------------------------------------------------------

local tgl = false
local circ = nil
local circconn = nil

local function mcirc()
	task.spawn(function()
		if circ then 
			circ:Destroy() 
			circ = nil
		end

		circ = Instance.new("Frame")
		circ.AnchorPoint = Vector2.new(0.5, 0.5)
		circ.Size = mob and UDim2.new(0, 221, 0, 221) or UDim2.new(0, 421, 0, 421)
		circ.BackgroundTransparency = 1
		circ.BorderSizePixel = 0
		circ.ZIndex = 10
		circ.Parent = gethui() or game:GetService("CoreGui")

		local crn = Instance.new("UICorner")
		crn.CornerRadius = UDim.new(1, 0)
		crn.Parent = circ

		local strk = Instance.new("UIStroke")
		strk.Thickness = 1
		strk.Transparency = 0
		strk.Color = Color3.fromRGB(255, 255, 255)
		strk.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		strk.Parent = circ

		circconn = rs.RenderStepped:Connect(function()
			if circ then
				local mpos
				if mob then
					mpos = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
				else
					mpos = ui:GetMouseLocation()
				end
				circ.Position = UDim2.fromOffset(mpos.X, mpos.Y)
			end
		end)
	end)
end

local function rcirc()
	if circ then 
		circ:Destroy()
		circ = nil
	end

	if circconn then
		circconn:Disconnect()
		circconn = nil
	end
end

-------------------------------------------------------------------------------------------------------------------------------

local function onch(wp)
	local sp, os = cam:WorldToViewportPoint(wp)
	if not os then return false end

	local cx = cam.ViewportSize.X/2
	local cy = cam.ViewportSize.Y/2

	local d = Vector2.new(sp.X - cx, sp.Y - cy)
	return d.Magnitude <= 3
end

function missing(t, f, fb) if type(f) == t then return f end return fb end cloneref = missing("function", cloneref, function(...) return ... end)

local te = false
local lt = nil
local hon = false
local tc = true
local vim = cloneref(game:GetService("VirtualInputManager"))

local function mdown()
	if not hon then 
		vim:SendMouseButtonEvent(cam.ViewportSize.X/2, cam.ViewportSize.Y/2, 0, true, game, 0) 
		hon = true 
	end
end

local function mup()
	if hon then 
		task.wait()
		vim:SendMouseButtonEvent(cam.ViewportSize.X/2, cam.ViewportSize.Y/2, 0, false, game, 0) 
		hon = false 
	end
end

local function gettgt()
	local c = lp.Character
	if not c or not c:FindFirstChild("HumanoidRootPart") then 
		lt = nil
		return nil 
	end

	local hrp = c.HumanoidRootPart
	local mp = hrp.Position
	local lv = cam.CFrame.LookVector

	local function vis(tp, ch)
		local ro = cam.CFrame.Position
		local rd = tp.Position - ro

		local rp = RaycastParams.new()
		rp.FilterDescendantsInstances = {lp.Character, cam, ch}
		rp.FilterType = Enum.RaycastFilterType.Blacklist
		rp.IgnoreWater = true

		local rr = workspace:Raycast(ro, rd, rp)
		if rr then
			local hitPart = rr.Instance
			if hitPart then
				local t = hitPart.Transparency
				local c = hitPart.CanCollide
				local q = hitPart.CanQuery
				if t >= 1 or not c or not q then
					local remainDist = (tp.Position - rr.Position).Magnitude
					if remainDist > 1 then
						local newOrigin = rr.Position + (rd.Unit * 0.05)
						local newDir = tp.Position - newOrigin
						rp.FilterDescendantsInstances = {lp.Character, cam, ch, hitPart}
						local rr2 = workspace:Raycast(newOrigin, newDir, rp)
						if rr2 then
							local hp2 = rr2.Instance
							if hp2 and not hp2:IsDescendantOf(ch) then
								return false
							end
						end
					end
					return true
				elseif not hitPart:IsDescendantOf(ch) then
					return false
				end
			end
		end

		return true
	end

	local function pvis(tp, ch)
		if not tp then return false end
		local sp, os = cam:WorldToViewportPoint(tp.Position)
		if not os then return false end
		return vis(tp, ch)
	end

	if lt and lt.Parent then
		local h = lt.Parent:FindFirstChildOfClass("Humanoid")
		if h and h.Health > 0 and pvis(lt, lt.Parent) then
			local d = (lt.Position - mp).Magnitude
			if d <= 700 then
				return lt
			end
		end
	end

	lt = nil

	local bt = nil
	local cd = math.huge

	for _, p in ipairs(plr:GetPlayers()) do
		if p == lp then continue end

		local ch = p.Character
		if not ch then continue end

		local h = ch:FindFirstChildOfClass("Humanoid")
		local hrp = ch:FindFirstChild("HumanoidRootPart") or ch:FindFirstChild("UpperTorso")
		local hd = ch:FindFirstChild("Head")

		if not h or h.Health <= 0 or not hrp then continue end
		if tc and p.Team and p.Team == lp.Team then
			continue
		end

		local myTeam = lp.Team and lp.Team.Name
		local targetTeam = p.Team and p.Team.Name

		if myTeam == "Inmates" and targetTeam == "Criminals" then
			continue
		end

		if myTeam == "Criminals" and targetTeam == "Inmates" then
			continue
		end

		if ch:FindFirstChildOfClass("ForceField") then continue end

		local d = (hrp.Position - mp).Magnitude
		if d > 900 then continue end

		local tp
		if hd and pvis(hd, ch) then
			tp = hd
		elseif pvis(hrp, ch) then
			tp = hrp
		end

		if tp then
			if d < cd then
				cd = d
				bt = tp
			end
		end
	end

	lt = bt
	return bt
end

local ss = 22
local pld = 0.15
local pt = nil
local lst = 0
local clc = nil

local function stcl()
	if clc then return end

	clc = rs.RenderStepped:Connect(function(dt)
		if not tgl then return end

		local t = gettgt()
		if not t then
			pt, lst, lt = nil, 0, nil
			mup()
			return
		end

		if t ~= pt then
			pt, lst = t, tick()
			return
		end
		if tick() - lst < pld then return end

		local cp = cam.CFrame.Position
		local dir = (t.Position - cp).Unit
		local targetCF = CFrame.new(cp, cp + dir)

		local a = math.clamp(dt * ss, 0, 1)
		local ea = a < 0.5 and 4*a*a*a or 1 - ((-2*a+2)^3)/2

		cam.CFrame = cam.CFrame:Lerp(targetCF, ea)
	end)
end

local function spcl()
	if clc then
		clc:Disconnect()
		clc = nil
	end
end

local function tcl(s)
	tgl = s
	if s then
		stcl()
	else
		spcl()
		lt = nil
		mup()
	end
end

local td = 0.3
local toc = 0
local iss = false
local tbc

local function sttb()
	tbc = rs.RenderStepped:Connect(function(dt)
		if not te then
			toc = 0
			if iss then 
				mup() 
				iss = false 
			end
			return
		end

		local hit = lt and lt.Parent and onch(lt.Position)

		if mob then
			if hit then
				toc += dt
				if toc >= td and not iss then
					mdown()
					iss = true
				end
			else
				toc = 0
				if iss then 
					mup() 
					iss = false 
				end
			end
			return
		end

		if hit then
			mdown()
			mup()
		end
	end)
end

local function ttb(s)
	te = s
	if not s then 
		mup(); 
		iss = false; 
		toc = 0 
		if tbc then
			tbc:Disconnect()
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------

local function fire()
	local args = {
		Instance.new("Model", nil)
	}
	game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("GiverPressed"):FireServer(unpack(args))
end

local ia = false

local function ia(s)
	if s then 
		while ia do
			fire() task.wait()
			if not ia then break end
		end
	else
		ia = false
	end
end

-------------------------------------------------------------------------------------------------------------------------------

local et = {}
local ee = false

local function mbox(p)
	if p == lp then return end

	local c = p.Character
	if not c then return end
	if c:FindFirstChildOfClass("Humanoid").Health == 0 then return end

	if et[p] then
		et[p].sg:Destroy()
	end

	local sg = Instance.new("ScreenGui")
	sg.ResetOnSpawn = false
	sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	sg.IgnoreGuiInset = true
	sg.Parent = gethui() or game:GetService("CoreGui")

	local bf = Instance.new("Frame")
	bf.BackgroundTransparency = 1
	bf.Size = UDim2.new(0, 100, 0, 200)
	bf.Position = UDim2.new(0, 0, 0, 0)
	bf.Visible = false
	bf.Parent = sg

	local bs = Instance.new("UIStroke")
	bs.Thickness = 2
	bs.Transparency = 0
	bs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	bs.Parent = bf

	if p.Team then
		bs.Color = p.Team.TeamColor.Color
	else
		bs.Color = Color3.fromRGB(255, 255, 255)
	end

	et[p] = {
		sg = sg,
		bf = bf,
		bs = bs,
	}
end

local function resp(p)
	if et[p] then
		et[p].sg:Destroy()
		et[p] = nil
	end
end

local function uesp(p)
	if not ee or p == lp then return end

	local d = et[p]
	if not d then return end

	local c = p.Character
	if not c then
		resp(p)
		return
	end

	local hrp = c:FindFirstChild("HumanoidRootPart")
	if not hrp then
		resp(p)
		return
	end

	local cf, sz = c:GetBoundingBox()

	local crn = {}
	for x = -0.5, 0.5, 1 do
		for y = -0.5, 0.5, 1 do
			for z = -0.5, 0.5, 1 do
				table.insert(crn, (cf.Position + (cf.RightVector * sz.X * x) + (cf.UpVector * sz.Y * y) + (cf.LookVector * sz.Z * z)))
			end
		end
	end

	local mnx, mny, mxx, mxy
	local os = false
	for _, cr in ipairs(crn) do
		local sp, osr = cam:WorldToViewportPoint(cr)
		if osr then
			os = true
			if not mnx or sp.X < mnx then mnx = sp.X end
			if not mxx or sp.X > mxx then mxx = sp.X end
			if not mny or sp.Y < mny then mny = sp.Y end
			if not mxy or sp.Y > mxy then mxy = sp.Y end
		end
	end

	if not os or not mnx then
		d.bf.Visible = false
		return
	end

	d.bf.Visible = true

	local bw = mxx - mnx
	local bh = mxy - mny
	local cx = (mnx + mxx) / 2
	local cy = (mny + mxy) / 2

	d.bf.Size = UDim2.new(0, bw, 0, bh)
	d.bf.Position = UDim2.new(0, cx - bw / 2, 0, cy - bh / 2)

	if p.Team then
		d.bs.Color = p.Team.TeamColor.Color
	else
		d.bs.Color = Color3.fromRGB(255, 255, 255)
	end
end

local function ue()
	for _, p in ipairs(plr:GetPlayers()) do
		if p ~= lp then
			local char = p.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")

			if not hum or hum.Health <= 0 or not char then
				resp(p)
			else
				if ee then
					if not et[p] then
						mbox(p)
					end
					uesp(p)
				else
					resp(p)
				end
			end
		end
	end
end

local function tes(s)
	ee = s
	if not ee then
		for p in pairs(et) do
			resp(p)
		end
	else
		for _, p in ipairs(plr:GetPlayers()) do
			if p ~= lp and p.Character then
				mbox(p)
			end
		end
	end
end

plr.PlayerAdded:Connect(function(p)
	p.CharacterAdded:Connect(function()
		if ee then
			mbox(p)
		end
	end)
end)

plr.PlayerRemoving:Connect(resp)
rs.RenderStepped:Connect(ue)

-------------------------------------------------------------------------------------------------------------------------------

local function tobase(cf) lp.Character.HumanoidRootPart.CFrame = CFrame.new(-976, 108, 2055) end
local function tocell(cf) lp.Character.HumanoidRootPart.CFrame = CFrame.new(965, 101, 2483) end

-------------------------------------------------------------------------------------------------------------------------------

local ts

local function ptst()
	local a = "https://files.catbox.moe/jt5t6y.mp3"
	local b = "Bomber (Slowed).mp3"
	local c, fd = pcall(readfile, b)

	if not c then
		local ac = game:HttpGet(a)
		writefile(b, ac)
	end

	if not ts then
		ts = Instance.new("Sound")
		ts.SoundId = getcustomasset(b)
		ts.Volume = 1
		ts.Parent = workspace
		ts:Play()
		ts.Looped = true
	end
end

function stst()
	if ts then ts:Destroy() ts = nil end
end

-------------------------------------------------------------------------------------------------------------------------------

function clk() 
	task.spawn(function()
		local s = Instance.new("Sound") 
		s.SoundId = "rbxassetid://87152549167464"
		s.Parent = workspace
		s.Volume = 1.2 
		s.TimePosition = 0.1 
		s:Play() 
	end)
end

local function rp(ui, r, c, tr, tc)
	local bw = 90
	local bh = 55
	local sp = 10

	local tw = (bw * tc) + (sp * (tc - 1))
	local th = (bh * tr) + (sp * (tr - 1))

	local sw, sh = cam.ViewportSize.X, cam.ViewportSize.Y
	local sx = (sw - tw) / 2
	local sy = (sh - th) / 2 - 56

	local x = sx + (c - 1) * (bw + sp)
	local y = sy + (r - 1) * (bh + sp)

	ui.Position = UDim2.new(0, x, 0, y)
end

local sg = Instance.new("ScreenGui")
sg.ResetOnSpawn = false
sg.Parent = gethui() or game:GetService("CoreGui")
if sg.Parent:FindFirstChild("Stupid Rushed Script") then sg.Parent:FindFirstChild("Stupid Rushed Script"):Destroy() end
sg.Name = "Stupid Rushed Script"

-------------------------------------------------------------------------------------------------------------------------------

local function mbtn(t, cb, r, c, tr, tc)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 90, 0, 55)
	btn.TextStrokeTransparency = 1
	rp(btn, r, c, tr, tc)
	btn.BackgroundTransparency = 0.3
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	btn.Font = Enum.Font.Code
	btn.BorderSizePixel = 0
	btn.TextSize = 13
	btn.TextXAlignment = Enum.TextXAlignment.Center
	btn.TextYAlignment = Enum.TextYAlignment.Center
	btn.Active = true
	btn.Draggable = true
	btn.TextWrapped = true
	btn.Text = t
	btn.Parent = sg

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = Color3.new(1, 1, 1)
	stroke.Parent = btn
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	btn.MouseButton1Click:Connect(function()
		clk()
		if cb then cb() end
	end)

	return btn
end

local function mtg(kb, k, t, is, cb, r, c, tr, tc)
	local tg = is or false

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 90, 0, 55)
	btn.TextStrokeTransparency = 1
	rp(btn, r, c, tr, tc)
	btn.BackgroundTransparency = 0.3
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	btn.Font = Enum.Font.Code
	btn.BorderSizePixel = 0
	btn.TextSize = 13
	btn.TextXAlignment = Enum.TextXAlignment.Center
	btn.TextYAlignment = Enum.TextYAlignment.Center
	btn.Active = true
	btn.Draggable = true
	btn.TextWrapped = true
	btn.Text = t
	btn.Parent = sg

	local strk = Instance.new("UIStroke")
	strk.Thickness = 1
	strk.Color = Color3.new(1, 1, 1)
	strk.Parent = btn
	strk.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local function uv()
		if tg then
			btn.TextColor3 = Color3.fromRGB(0, 255, 0)
			strk.Color = Color3.fromRGB(0, 255, 0)
		else
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			strk.Color = Color3.fromRGB(255, 255, 255)
		end
	end

	uv()

	local function tbtn()
		clk()
		tg = not tg
		uv()
		if cb then cb(tg) end
	end

	btn.MouseButton1Click:Connect(tbtn)

	if kb and k then
		ui.InputBegan:Connect(function(i, gp)
			if gp then return end
			if i.UserInputType == Enum.UserInputType.Keyboard and i.KeyCode == Enum.KeyCode[k] then
				tbtn()
			end
		end)
	end

	return btn
end

-------------------------------------------------------------------------------------------------------------------------------

local btns = {
	{kb = true, k = "Z", typ = "tg", t = "Toggle Aim Circle", cb = function(s) if s then mcirc() else rcirc() end end},
	{kb = true, k = "Q", typ = "tg", t = "Toggle Camlock [Q]", cb = function(s) tcl(s) end},
	{kb = true, k = "T", typ = "tg", t = "Toggle Item Aura", cb = function(s) ia(s) end},
	{kb = false, k = nil, typ = "tg", t = "Toggle ESP", cb = function(s) tes(s) end},
	{kb = false, k = nil, typ = "tg", t = "Toggle No Team Check", cb = function(s) tc = not s end},
	{kb = true, k = "Z", typ = "tg", t = "Toggle Trigger Bot [Z]", cb = function(s) ttb(s) end},
	{kb = false, k = nil, typ = "btn", t = "Teleport To Cell", cb = function(s) tocell() end},
	{kb = false, k = nil, typ = "btn", t = "Teleport To Criminal Base", cb = function(s) tobase() end},
}

if test == true then
	table.insert(btns, {kb = true, k = nil, typ = "tg", t = "Toggle Test", cb = function(s) if s then ptst() else stst() end end})
end

-------------------------------------------------------------------------------------------------------------------------------

local mc = 5
local mbpc = 8
local tb = #btns

local cols = math.min(mbpc, math.ceil(tb / mc))
local rows = math.ceil(tb / cols)

local bi = 1
for col = 1, cols do
	for row = 1, rows do
		if bi > tb then break end

		local bd = btns[bi]

		if bd.typ == "btn" then
			mbtn(bd.t, bd.cb, row, col, rows, cols)

		elseif bd.typ == "tg" then
			mtg(bd.kb, bd.k, bd.t, false, bd.cb, row, col, rows, cols)
		end

		bi += 1
	end
end

-------------------------------------------------------------------------------------------------------------------------------
