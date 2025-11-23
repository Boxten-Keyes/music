loadstring(game:HttpGet("https://scriptblox.com/raw/UPD-Blade-Ball-op-autoparry-with-visualizer-8652"))()

function missing(t, f, fb) if type(f) == t then return f end return fb end cloneref = missing("function", cloneref, function(...) return ... end)

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local VirtualInputManager = cloneref(game:GetService("VirtualInputManager"))

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Cooldown = tick()
local Parried = false
local Connection = nil

local holding = false

local function pressButton(guiButton)
	local pos = guiButton.AbsolutePosition
	local size = guiButton.AbsoluteSize

	local x = pos.X + size.X/2
	local y = pos.Y + size.Y/2

	VirtualInputManager:SendTouchEvent(1, x, y, true, game)
end

local function releaseButton(guiButton)
	if not holding then return end
	holding = false

	local absPos = guiButton.AbsolutePosition
	local absSize = guiButton.AbsoluteSize
	local x = absPos.X + absSize.X/2
	local y = absPos.Y + absSize.Y/2

	VirtualInputManager:SendTouchEvent(1, x, y, false, game)
end

local function GetBall()
	for _, Ball in ipairs(workspace.Balls:GetChildren()) do
		if Ball:GetAttribute("realBall") then
			return Ball
		end
	end
end

local function ResetConnection()
	if Connection then
		Connection:Disconnect()
		Connection = nil
	end
end

workspace.Balls.ChildAdded:Connect(function()
	local Ball = GetBall()
	if not Ball then return end
	ResetConnection()
	Connection = Ball:GetAttributeChangedSignal("target"):Connect(function()
		Parried = false
	end)
end)

RunService.PreSimulation:Connect(function()
	local Ball = GetBall()
	local Character = Player.Character
	local HRP = Character and Character:FindFirstChild("HumanoidRootPart")

	if not Ball or not HRP then return end

	local Speed = Ball.zoomies.VectorVelocity.Magnitude
	local Distance = (HRP.Position - Ball.Position).Magnitude

	if Ball:GetAttribute("target") == Player.Name and not Parried then
		if Distance / Speed <= 0.55 then
			local blockButton = Player:WaitForChild("PlayerGui"):FindFirstChild("Hotbar")
			blockButton = blockButton and blockButton:FindFirstChild("Block")

			if blockButton and blockButton:IsA("GuiButton") then
				pressButton(blockButton)
				releaseButton(blockButton)
			end

			Parried = true
			Cooldown = tick()
	
			task.delay(1, function()
				Parried = false
			end)
		end
	end
end)

local VIM = cloneref(game:GetService("VirtualInputManager"))
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local HRP = nil

local SPORADIC_ACTIVE = false
local CIRCLE_ACTIVE = false
local CURRENT_KEY = nil
local STOP_MOVING = false

local function pressKey(key)
	VIM:SendKeyEvent(true, key, false, game)
end

local function releaseKey(key)
	VIM:SendKeyEvent(false, key, false, game)
end

local function releaseCurrent()
	if CURRENT_KEY then
		releaseKey(CURRENT_KEY)
		CURRENT_KEY = nil
	end
end

-- stays 20 studs away from walls
local function nearWall()
	local origin = HRP.Position
	local directions = {
		Vector3.new(1, 0, 0),
		Vector3.new(-1, 0, 0),
		Vector3.new(0, 0, 1),
		Vector3.new(0, 0, -1),
	}

	for _, dir in ipairs(directions) do
		local ray = workspace:Raycast(origin, dir * 20)
		if ray then return true end
	end
	return false
end

-- ✅ NEW — sporadic holding movement
task.spawn(function()
	local keys = {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.Space}

	while task.wait() do
		if SPORADIC_ACTIVE and not CIRCLE_ACTIVE then
			if not CURRENT_KEY then
				-- choose random key & duration
				local key = keys[math.random(1, #keys)]
				local duration = math.random(50, 300) / 100  -- 0.5–3s

				if nearWall() then
					-- avoid pressing key into wall
					key = Enum.KeyCode.S
				end

				CURRENT_KEY = key
				pressKey(key)

				task.delay(duration, function()
					if CURRENT_KEY == key and SPORADIC_ACTIVE then
						releaseCurrent()
					end
				end)
			end
		else
			releaseCurrent()
		end
	end
end)

-- ✅ circular movement (unchanged)
task.spawn(function()
	local circleKeys = {Enum.KeyCode.W, Enum.KeyCode.D, Enum.KeyCode.S, Enum.KeyCode.A}
	local index = 1

	while task.wait(0.25) do
		if CIRCLE_ACTIVE and not SPORADIC_ACTIVE then
			releaseCurrent()
			local key = circleKeys[index]
			index = (index % #circleKeys) + 1
			CURRENT_KEY = key
			pressKey(key)
		end
	end
end)

-- ✅ mode switching logic
local function updateMovement()
	local char = Player.Character
	HRP = char and char:FindFirstChild("HumanoidRootPart")
	if not HRP then return end

	local dist = (HRP.Position - Vector3.new(-280, 124, 152)).Magnitude

	if dist > 100 then
		SPORADIC_ACTIVE = true
		CIRCLE_ACTIVE = false
	else
		SPORADIC_ACTIVE = false
		CIRCLE_ACTIVE = true
	end
end

RunService.Heartbeat:Connect(updateMovement)
