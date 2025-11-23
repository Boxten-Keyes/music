loadstring(game:HttpGet("https://scriptblox.com/raw/UPD-Blade-Ball-op-autoparry-with-visualizer-8652"))()

function missing(t, f, fb) if type(f) == t then return f end return fb end 
cloneref = missing("function", cloneref, function(...) return ... end)

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local VirtualInputManager = cloneref(game:GetService("VirtualInputManager"))
local Workspace = game:GetService("Workspace")

local Player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local Cooldown = tick()
local Parried = false
local Connection = nil

-- ✅ MOVEMENT CONFIG
local SAFE_POINT = Vector3.new(-280, 124, 152)
local FAR_DISTANCE = 100
local WALL_STOP_DISTANCE = 20
local randomMoveCooldown = 0
local circleStep = 1
local lastCirclePress = 0
local holdingKeys = {}

-- ✅ movement keys list
local MOVE_KEYS = {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D}

local function keyPress(key)
	if holdingKeys[key] then return end
	holdingKeys[key] = true
	VirtualInputManager:SendKeyEvent(true, key, false, game)
end

local function keyRelease(key)
	if not holdingKeys[key] then return end
	holdingKeys[key] = nil
	VirtualInputManager:SendKeyEvent(false, key, false, game)
end

local function releaseAllMovement()
	for key, _ in pairs(holdingKeys) do
		keyRelease(key)
	end
end

-- ✅ Wall check — avoids running into walls
local function nearWall(hrp)
	local ray = Ray.new(hrp.Position, hrp.CFrame.LookVector * WALL_STOP_DISTANCE)
	local hit = Workspace:FindPartOnRay(ray, Player.Character)

	return hit ~= nil
end

-- ✅ Random sporadic movement mode
local function randomMovement(hrp)
	if tick() < randomMoveCooldown then return end

	releaseAllMovement()

	local key = MOVE_KEYS[math.random(1, #MOVE_KEYS)]
	keyPress(key)

	if math.random() < 0.1 then -- occasional jump
		keyPress(Enum.KeyCode.Space)
		task.delay(0.2, function()
			keyRelease(Enum.KeyCode.Space)
		end)
	end

	randomMoveCooldown = tick() + math.random(0.25, 0.6)

	-- stop if near a wall
	if nearWall(hrp) then
		releaseAllMovement()
	end
end

-- ✅ Circle strafing movement mode
local function circleMovement()
	if tick() - lastCirclePress < 0.25 then return end -- adjust speed here

	releaseAllMovement()

	if circleStep == 1 then
		keyPress(Enum.KeyCode.W)
	elseif circleStep == 2 then
		keyPress(Enum.KeyCode.A)
	elseif circleStep == 3 then
		keyPress(Enum.KeyCode.S)
	elseif circleStep == 4 then
		keyPress(Enum.KeyCode.D)
	end

	circleStep = circleStep % 4 + 1
	lastCirclePress = tick()
end

-- ✅ BALL HANDLING (original code unchanged)
local function GetBall()
	for _, Ball in ipairs(Workspace.Balls:GetChildren()) do
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

Workspace.Balls.ChildAdded:Connect(function()
	local Ball = GetBall()
	if not Ball then return end
	ResetConnection()
	Connection = Ball:GetAttributeChangedSignal("target"):Connect(function()
		Parried = false
	end)
end)

-- ✅ MAIN LOOP
RunService.PreSimulation:Connect(function()
	local Character = Player.Character
	local HRP = Character and Character:FindFirstChild("HumanoidRootPart")
	if not HRP then releaseAllMovement() return end

	-- ✅ movement distance check
	local dist = (HRP.Position - SAFE_POINT).Magnitude

	if dist > FAR_DISTANCE then
		randomMovement(HRP)
	else
		circleMovement()
	end

	-- ✅ original parry logic
	local Ball = GetBall()
	if not Ball then return end

	local Speed = Ball.zoomies.VectorVelocity.Magnitude
	local Distance = (HRP.Position - Ball.Position).Magnitude

	if Ball:GetAttribute("target") == Player.Name and not Parried then
		if Distance / Speed <= 0.55 then
			local blockButton = Player:WaitForChild("PlayerGui"):FindFirstChild("Hotbar")
			blockButton = blockButton and blockButton:FindFirstChild("Block")

			if blockButton and blockButton:IsA("GuiButton") then
				-- simulate click
				local pos = blockButton.AbsolutePosition
				local size = blockButton.AbsoluteSize
				local x = pos.X + size.X/2
				local y = pos.Y + size.Y/2
				VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
				VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
			end

			Parried = true
			Cooldown = tick()

			task.delay(1, function()
				Parried = false
			end)
		end
	end
end)
