task.wait(1)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local plr = Players.LocalPlayer
local mouse = plr:GetMouse()
local camera = workspace.CurrentCamera

local function repos(ui, t, w, h)
	if not t then t = 0.5 end

	local screenWidth = camera.ViewportSize.X
	local screenHeight = camera.ViewportSize.Y

	local centerX = (screenWidth - w) / 2
	local centerY = (screenHeight - h) / 2 - 56
	local tweenInfo = TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

	local tween = TweenService:Create(ui, tweenInfo, {
		Position = UDim2.new(0, centerX, 0, centerY)
	})
	tween:Play()
end

local toggle = false
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 48, 0, 48)
button.Position = UDim2.new(0, 20, 0, 80)
button.Text = "F:X"
button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
button.BorderColor3 = Color3.new(1, 1, 1)
button.TextColor3 = Color3.new(1, 1, 1)
button.TextSize = 20
button.Font = Enum.Font.RobotoMono
button.TextWrapped = true
button.Active = true
button.Draggable = true

local buttonpad = Instance.new("UIPadding")
buttonpad.PaddingTop = UDim.new(0, -2)
buttonpad.Parent = button

local clik = Instance.new("Sound")
clik.SoundId = "rbxassetid://226892749"
clik.Parent = workspace
clik.Name = "canttouchthis"
clik.Volume = 0.4

local function playclicksound()
	local newSound = clik:Clone()
	newSound.Parent = clik.Parent
	newSound:Play()
	newSound.Ended:Connect(function() newSound:Destroy() end)
end

repos(button, 0, 48, 48)

local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
button.Parent = screenGui

if RunService:IsStudio() then
	screenGui.Parent = plr:WaitForChild("PlayerGui")
else
	screenGui.Parent = gethui and gethui() or game:GetService("CoreGui")
end

local FlySpeed = 200
local flying = false
local ctrl = {f = 0, b = 0, l = 0, r = 0}
local lastctrl = {f = 0, b = 0, l = 0, r = 0}
local KeyDownFunction, KeyUpFunction

local function PlayAnim(id, time, speed)
	pcall(function()
		local char = plr.Character or plr.CharacterAdded:Wait()
		char.Animate.Disabled = false
		local hum = char:WaitForChild("Humanoid")
		for _, track in pairs(hum:GetPlayingAnimationTracks()) do
			track:Stop()
		end
		char.Animate.Disabled = true
		local anim = Instance.new("Animation")
		anim.AnimationId = "rbxassetid://" .. id
		local loaded = hum:LoadAnimation(anim)
		loaded:Play()
		loaded.TimePosition = time
		loaded:AdjustSpeed(speed)
	end)
end

local function StopAnim()
	local char = plr.Character or plr.CharacterAdded:Wait()
	char.Animate.Disabled = false
	for _, track in pairs(char:WaitForChild("Humanoid"):GetPlayingAnimationTracks()) do
		track:Stop()
	end
end

local function resetanims()
	task.wait()
	task.spawn(function()
		local Char = plr.Character or plr.CharacterAdded:Wait()
		local Human = Char and Char:WaitForChild("Humanoid", 15)
		local Animate = Char and Char:WaitForChild("Animate", 15)

		if Animate then
			Animate.Disabled = true
			for _, v in ipairs(Human:GetPlayingAnimationTracks()) do
				v:Stop()
			end
			Animate.Disabled = false
		end
	end)
end

local function getMoveDirectionAnim(dir)
	if dir.Magnitude < 0.1 then return "idle" end
	local cam = workspace.CurrentCamera
	local look = cam.CFrame.LookVector
	local right = cam.CFrame.RightVector

	local forward = look:Dot(dir)
	local sideways = right:Dot(dir)

	if math.abs(forward) > math.abs(sideways) then
		return forward > 0 and "w" or "s"
	else
		return sideways > 0 and "d" or "a"
	end
end

local function startFlying()
	if flying then return end
	flying = true

	local char = plr.Character or plr.CharacterAdded:Wait()
	local UpperTorso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:WaitForChild("HumanoidRootPart")
	local speed = 0

	local bg = Instance.new("BodyGyro", UpperTorso)
	bg.P = 9e4
	bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
	bg.cframe = UpperTorso.CFrame

	local bv = Instance.new("BodyVelocity", UpperTorso)
	bv.velocity = Vector3.new(0, 0.1, 0)
	bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

	PlayAnim(10714347256, 4, 0) -- idle fly

	KeyDownFunction = mouse.KeyDown:Connect(function(key)
		local k = key:lower()
		if k == "w" then ctrl.f = 1 PlayAnim(10714177846, 4.65, 0)
		elseif k == "s" then ctrl.b = -1 PlayAnim(10147823318, 4.11, 0)
		elseif k == "a" then ctrl.l = -1 PlayAnim(10147823318, 3.55, 0)
		elseif k == "d" then ctrl.r = 1 PlayAnim(10147823318, 4.81, 0)
		end
	end)

	KeyUpFunction = mouse.KeyUp:Connect(function(key)
		local k = key:lower()
		if k == "w" then ctrl.f = 0
		elseif k == "s" then ctrl.b = 0
		elseif k == "a" then ctrl.l = 0
		elseif k == "d" then ctrl.r = 0
		end
		PlayAnim(10714347256, 4, 0)
	end)

	local lastDir = nil

coroutine.wrap(function()
	local lastDir = nil
	while flying and char and char.Parent do
		RunService.RenderStepped:Wait()
		char.Humanoid.PlatformStand = true

local moveVec = char.Humanoid.MoveDirection
local hasInput = moveVec.Magnitude > 0.1
local camLook = camera.CFrame.LookVector

local flatCamLook = Vector3.new(camLook.X, 0, camLook.Z).Unit
local forwardDot = hasInput and flatCamLook:Dot(moveVec.Unit) or 0

local verticalY = 0
if math.abs(forwardDot) > 0.7 then
    -- Flip vertical Y when moving backward
    if forwardDot < 0 then
        verticalY = -camLook.Y * moveVec.Magnitude
    else
        verticalY = camLook.Y * moveVec.Magnitude
    end
end

local flyDir = hasInput and Vector3.new(moveVec.X, verticalY, moveVec.Z).Unit or Vector3.new(0, 0.1, 0)

		-- Determine animation direction
		local animDir
		if hasInput then
			local forward = camera.CFrame.LookVector:Dot(moveVec)
			local right = camera.CFrame.RightVector:Dot(moveVec)

			if math.abs(forward) > math.abs(right) then
				animDir = forward > 0 and "w" or "s"
			else
				animDir = right > 0 and "d" or "a"
			end
		else
			animDir = "idle"
		end

		-- Animation play
		if animDir ~= lastDir then
			lastDir = animDir
			if animDir == "w" then
				PlayAnim(10714177846, 4.65, 0)
			elseif animDir == "s" then
				PlayAnim(10147823318, 4.11, 0)
			elseif animDir == "a" then
				PlayAnim(10147823318, 3.55, 0)
			elseif animDir == "d" then
				PlayAnim(10147823318, 4.81, 0)
			else
				PlayAnim(10714347256, 4, 0)
			end
		end

		-- Speed management
		if hasInput then
			speed += FlySpeed * 0.1
			if speed > FlySpeed then speed = FlySpeed end
		elseif speed > 0 then
			speed -= FlySpeed * 0.1
			if speed < 0 then speed = 0 end
		end

		-- Apply velocity
		bv.velocity = flyDir * speed

		-- Camera tilt for effect
local moveVec = char.Humanoid.MoveDirection
local camLook = camera.CFrame.LookVector
local flatCamLook = Vector3.new(camLook.X, 0, camLook.Z).Unit
local forwardDot = (moveVec.Magnitude > 0 and flatCamLook:Dot(moveVec.Unit)) or 0

local tiltAngle = 0

if forwardDot > 0.7 then
    -- Tilt forward when flying forward
    tiltAngle = -math.rad(50 * speed / FlySpeed)
elseif forwardDot < -0.7 then
    -- Tilt backward when flying backward (smaller angle)
    tiltAngle = math.rad(25 * speed / FlySpeed)
else
    -- No tilt otherwise
    tiltAngle = 0
end

bg.CFrame = camera.CFrame * CFrame.Angles(tiltAngle, 0, 0)
	end

	ctrl = {f = 0, b = 0, l = 0, r = 0}
	lastctrl = {f = 0, b = 0, l = 0, r = 0}
	speed = 0
	bg:Destroy()
	bv:Destroy()

	if char and char:FindFirstChild("Humanoid") then
		char.Humanoid.PlatformStand = false
	end
end)()
end

local function stopFlying()
	if not flying then return end
	flying = false
	if KeyDownFunction then KeyDownFunction:Disconnect() end
	if KeyUpFunction then KeyUpFunction:Disconnect() end
	StopAnim()
	resetanims()
end

button.MouseButton1Click:Connect(function()
	playclicksound()
	toggle = not toggle
	button.Text = toggle and "F:O" or "F:X"
	button.BackgroundColor3 = toggle and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 0, 0)
	button.BorderColor3 = toggle and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
	button.TextColor3 = toggle and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
	if toggle then startFlying() else stopFlying() end
end)

plr.Character:WaitForChild("Humanoid").Died:Connect(function()
	toggle = false
	stopFlying()
	button.Text = "F:X"
	button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	button.BorderColor3 = Color3.fromRGB(255, 255, 255)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
end)