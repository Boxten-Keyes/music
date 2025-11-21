-------------------------------------------------------------------------------------------------------------------------------

if not game:IsLoaded() then game.Loaded:Wait() end task.wait(1)

-------------------------------------------------------------------------------------------------------------------------------

local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local cam = workspace.CurrentCamera

-------------------------------------------------------------------------------------------------------------------------------

local dances = {
	"rbxassetid://182491037",
	"rbxassetid://182491277",
	"rbxassetid://182491368"
}

local enabled = false
local spinning = false
local currentAnimTrack
local stopLoop = false
local spinConnection

local function stopall()
	stopLoop = true
	spinning = false
	if spinConnection then
		spinConnection:Disconnect()
		spinConnection = nil
	end
	if currentAnimTrack then
		currentAnimTrack:Stop()
		currentAnimTrack = nil
	end
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		hrp.Orientation = Vector3.new(0, hrp.Orientation.Y, 0)
	end
end

local function dance()
	if not LocalPlayer.Character then return end
	local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		if currentAnimTrack then
			currentAnimTrack:Stop()
		end
		local anim = Instance.new("Animation")
		anim.AnimationId = dances[math.random(#dances)]
		currentAnimTrack = humanoid:LoadAnimation(anim)
		currentAnimTrack.Priority = Enum.AnimationPriority.Action
		currentAnimTrack:AdjustWeight(999)
		currentAnimTrack:Play()
	end
end

local function spin()
	local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	if spinConnection then
		spinConnection:Disconnect()
	end

	spinning = true
	spinConnection = RunService.Heartbeat:Connect(function(dt)
		if spinning then
			hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(100 * dt), 0)
		end
	end)
end

local function getrandompos(character)
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return nil end

	local angle = math.random() * 2 * math.pi
	local distance = math.random(6, 26)
	local offset = Vector3.new(math.cos(angle) * distance, 0, math.sin(angle) * distance)

	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {character}
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

	local raycastResult = workspace:Raycast(hrp.Position, offset, raycastParams)
	if raycastResult then
		return raycastResult.Position - offset.Unit * 2
	end

	return hrp.Position + offset
end

local function walktorandompoint()
	spinning = false
	if currentAnimTrack then
		currentAnimTrack:Stop()
	end

	local character = LocalPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local hrp = character and character:FindFirstChild("HumanoidRootPart")
	if not humanoid or not hrp then return end

	for i = 1, math.random(4, 8) do
		if not enabled or stopLoop then break end

		local targetPos = getrandompos(character)
		if not targetPos then return end

		local path = PathfindingService:CreatePath()
		path:ComputeAsync(hrp.Position, targetPos)

		if path.Status == Enum.PathStatus.Success then
			local waypoints = path:GetWaypoints()
			for _, waypoint in ipairs(waypoints) do
				if not enabled or stopLoop then break end
				humanoid:MoveTo(waypoint.Position)
				if waypoint.Action == Enum.PathWaypointAction.Jump then
					humanoid.Jump = true
				end
				humanoid.MoveToFinished:Wait()
			end
		end
	end
end

local function idleloop()
	stopLoop = false
	while enabled and not stopLoop do
		spin()
		dance()
		task.wait(math.random(3, 10))
		if not enabled or stopLoop then break end
		walktorandompoint()
	end
end

function toggleidler(state)
	enabled = state
	if enabled then
		task.spawn(idleloop)
	else
		stopall()
	end
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
sg.Parent = gethui() or cgui
if sg.Parent:FindFirstChild("skidded from ksu") then sg.Parent:FindFirstChild("skidded from ksu"):Destroy() end
sg.Name = "skidded from ksu"

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
		game["UserInputService"].InputBegan:Connect(function(i, gp)
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
	{kb = false, k = nil, typ = "tg", t = "Toggle Dynamic Anti-AFK", cb = function(s) toggleidler(s) end}
}

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
		if bd.typ == "tg" then
			mtg(bd.kb, bd.k, bd.t, false, bd.cb, row, col, rows, cols)
		end

		bi = bi + 1
	end
end

-------------------------------------------------------------------------------------------------------------------------------
