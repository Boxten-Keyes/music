-------------------------------------------------------------------------------------------------------------------------------

if not game:IsLoaded() then game.Loaded:Wait() end task.wait(1)

-------------------------------------------------------------------------------------------------------------------------------

function missing(t, f, fb) if type(f) == t then return f end return fb end cloneref = missing("function", cloneref, function(...) return ... end)

local runs = game:GetService("RunService")
local plrs = game:GetService("Players")
local vim = game:GetService("VirtualInputManager")
local plr = plrs.LocalPlayer

-------------------------------------------------------------------------------------------------------------------------------

local function pressbtn(guiButton)
	local pos = guiButton.AbsolutePosition
	local size = guiButton.AbsoluteSize

	local x = pos.X + size.X/2
	local y = pos.Y + size.Y/2

	vim:SendMouseButtonEvent(x, y, 0, true, game, 1)
	vim:SendMouseButtonEvent(x, y, 0, false, game, 1)
end

-------------------------------------------------------------------------------------------------------------------------------

local Cooldown = tick()
local Parried = false
local Connection = nil
local EmoteActive = false

local TARGET_POSITION = Vector3.new(-280, 124, 152)
local MAX_DISTANCE = 100

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

local function IsBallComingTowardPlayer(Ball, HRP)
	local ballPosition = Ball.Position
	local ballVelocity = Ball.zoomies.VectorVelocity
	local toPlayer = (HRP.Position - ballPosition).Unit

	local dotProduct = ballVelocity.Unit:Dot(toPlayer)

	return dotProduct > 0.3
end

local function GetTimeToImpact(Ball, HRP)
	local ballPosition = Ball.Position
	local playerPosition = HRP.Position
	local ballVelocity = Ball.zoomies.VectorVelocity

	local toPlayer = (playerPosition - ballPosition)
	local distance = toPlayer.Magnitude

	local approachSpeed = ballVelocity:Dot(toPlayer.Unit)

	if approachSpeed > 0 then
		return distance / approachSpeed
	end

	return math.huge
end

local function GetParryTiming(ballSpeed)
	if ballSpeed > 150 then
		return 0.85
	elseif ballSpeed > 100 then
		return 0.8
	elseif ballSpeed > 70 then
		return 0.75
	elseif ballSpeed > 40 then
		return 0.7
	else
		return 0.65
	end
end

-------------------------------------------------------------------------------------------------------------------------------

workspace.Balls.ChildAdded:Connect(function()
	local Ball = GetBall()
	if not Ball then return end
	ResetConnection()
	Connection = Ball:GetAttributeChangedSignal("target"):Connect(function()
		Parried = false
	end)
end)

runs.PreSimulation:Connect(function()
	local Ball = GetBall()
	local Character = plr.Character
	local HRP = Character and Character:FindFirstChild("HumanoidRootPart")

	if not Ball or not HRP then return end

	if Ball:GetAttribute("target") ~= plr.Name or Parried then return end

	local ballVel = Ball.zoomies.VectorVelocity
	if ballVel.Magnitude < 5 then return end

	local dirToPlayer = (HRP.Position - Ball.Position).Unit
	local alignment = ballVel.Unit:Dot(dirToPlayer)

	if alignment < 0.55 then return end
	local predictedPos = Ball.Position + ballVel * 0.08
	local predictedDistance = (predictedPos - HRP.Position).Magnitude

	local requiredDist = math.clamp(ballVel.Magnitude * 0.22, 18, 45)

	if predictedDistance <= requiredDist then
		local blockButton = plr:WaitForChild("PlayerGui"):FindFirstChild("Hotbar")
		blockButton = blockButton and blockButton:FindFirstChild("Block")

		if blockButton and blockButton:IsA("GuiButton") then
			pressbtn(blockButton)
		end

		Parried = true

		task.delay(0.8, function()
			Parried = false
		end)
	end
end)

-------------------------------------------------------------------------------------------------------------------------------
