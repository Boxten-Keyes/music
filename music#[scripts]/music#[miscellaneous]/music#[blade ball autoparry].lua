function missing(t, f, fb) if type(f) == t then return f end return fb end cloneref = missing("function", cloneref, function(...) return ... end)

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local VirtualInputManager = cloneref(game:GetService("VirtualInputManager"))

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Cooldown = tick()
local Parried = false
local Connection = nil
local EmoteActive = false

local TARGET_POSITION = Vector3.new(-280, 124, 152)
local MAX_DISTANCE = 100

local function pressButton(guiButton)
	local pos = guiButton.AbsolutePosition
	local size = guiButton.AbsoluteSize

	local x = pos.X + size.X/2
	local y = pos.Y + size.Y/2

	VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 1)
	VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 1)
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

local function StopEmote()
	if EmoteActive then
		local args = {
			false,
			"Emote1082",
			1763868261.462245
		}
		game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CustomEmote"):FireServer(unpack(args))
		EmoteActive = false
	end
end

local function CheckDistanceAndPlayEmote()
	local Character = Player.Character
	local HRP = Character and Character:FindFirstChild("HumanoidRootPart")

	if not HRP then return end

	local distance = (HRP.Position - TARGET_POSITION).Magnitude

	if distance > MAX_DISTANCE and not EmoteActive then
		local args = {
			true,
			"Emote1082",
			1763868261.462245
		}
		game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CustomEmote"):FireServer(unpack(args))
		EmoteActive = true

		local waitTime = math.random(7, 10) / 10
		task.delay(waitTime, function()
			if EmoteActive then
				local args = {
					false,
					"Emote1082",
					1763868261.462245
				}
				game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CustomEmote"):FireServer(unpack(args))
				EmoteActive = false
			end
		end)
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

Player.CharacterAdded:Connect(function()
	StopEmote()
end)

Player.CharacterRemoving:Connect(function()
	StopEmote()
end)

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

	if not HRP then 
		StopEmote()
		return 
	end

	CheckDistanceAndPlayEmote()

	if not Ball then return end

	if not IsBallComingTowardPlayer(Ball, HRP) then return end

	local timeToImpact = GetTimeToImpact(Ball, HRP)
	local Distance = (HRP.Position - Ball.Position).Magnitude

	if Ball:GetAttribute("target") == Player.Name and not Parried then
		if timeToImpact <= 0.4 and Distance < 50 then
			local blockButton = Player:WaitForChild("PlayerGui"):FindFirstChild("Hotbar")
			blockButton = blockButton and blockButton:FindFirstChild("Block")

			if blockButton and blockButton:IsA("GuiButton") then
				pressButton(blockButton)
			end

			Parried = true
			Cooldown = tick()

			task.delay(1, function()
				Parried = false
			end)
		end
	end
end)

while true do
	task.wait()
	CheckDistanceAndPlayEmote()
end
