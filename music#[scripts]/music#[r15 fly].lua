task.wait(1)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local plr = Players.LocalPlayer
local mouse = plr:GetMouse()
local camera = workspace.CurrentCamera

function repos(ui, t, w, h)
	if not t then t = 0.5 end

	local screenWidth = game:GetService("Workspace").CurrentCamera.ViewportSize.X
	local screenHeight = game:GetService("Workspace").CurrentCamera.ViewportSize.Y

	local frameWidth = w
	local frameHeight = h
	local negative = 56

	local centerX = (screenWidth - frameWidth) / 2
	local centerY = (screenHeight - frameHeight) / 2 - negative
	local tweenInfo = TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

	local tween = game:GetService("TweenService"):Create(
		ui,
		tweenInfo,
		{Position = UDim2.new(0, centerX, 0, centerY)}
	)

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
buttonpad.PaddingTop = UDim.new(0, -3)
buttonpad.Parent = button

local clik = Instance.new"Sound"
clik.SoundId = "rbxassetid://226892749"
clik.Parent = game.Workspace
clik.Name = "canttouchthis"
clik.Volume = 0.4

function playclicksound()
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
	screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
else
	screenGui.Parent = gethui and gethui() or game:GetService("CoreGui")
end

local FlySpeed = 200
local Backpack = plr:WaitForChild("Backpack")

local screenGui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
screenGui.Name = "FlyDPadUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

local FlyPad = Instance.new("Frame")
FlyPad.Name = "FlyPad"
FlyPad.Size = UDim2.new(0, 180, 0, 180)
FlyPad.Position = UDim2.new(0, 10, 1, -200)
FlyPad.BackgroundTransparency = 1
FlyPad.Visible = false
FlyPad.Parent = screenGui

local function CreateDPadButton(name, text, pos, size)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Text = text
	btn.Size = size
	btn.Position = pos
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.BackgroundTransparency = 0.5
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.TextSize = 20
	btn.Parent = FlyPad

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0.2, 0)
	corner.Parent = btn

	return btn
end

local UpButton = CreateDPadButton("Up", "W", UDim2.new(0.5, -25, 0, 10), UDim2.new(0, 50, 0, 50))
local DownButton = CreateDPadButton("Down", "S", UDim2.new(0.5, -25, 0.5, 30), UDim2.new(0, 50, 0, 50))
local LeftButton = CreateDPadButton("Left", "A", UDim2.new(0, 10, 0.5, -25), UDim2.new(0, 50, 0, 50))
local RightButton = CreateDPadButton("Right", "D", UDim2.new(1, -60, 0.5, -25), UDim2.new(0, 50, 0, 50))

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

local function HandleMobileInput(key, state)
	if not flying then return end
	local k = key:lower()
	if k == "w" then 
		ctrl.f = state and 1 or 0
		if state then PlayAnim(10714177846, 4.65, 0) end
	elseif k == "s" then 
		ctrl.b = state and -1 or 0
		if state then PlayAnim(10147823318, 4.11, 0) end
	elseif k == "a" then 
		ctrl.l = state and -1 or 0
		if state then PlayAnim(10147823318, 3.55, 0) end
	elseif k == "d" then 
		ctrl.r = state and 1 or 0
		if state then PlayAnim(10147823318, 4.81, 0) end
	end

	if not state and ctrl.f == 0 and ctrl.b == 0 and ctrl.l == 0 and ctrl.r == 0 then
		PlayAnim(10714347256, 4, 0)
	end
end

UpButton.MouseButton1Down:Connect(function() HandleMobileInput("w", true) end)
UpButton.MouseButton1Up:Connect(function() HandleMobileInput("w", false) end)
UpButton.MouseLeave:Connect(function() HandleMobileInput("w", false) end)

DownButton.MouseButton1Down:Connect(function() HandleMobileInput("s", true) end)
DownButton.MouseButton1Up:Connect(function() HandleMobileInput("s", false) end)
DownButton.MouseLeave:Connect(function() HandleMobileInput("s", false) end)

LeftButton.MouseButton1Down:Connect(function() HandleMobileInput("a", true) end)
LeftButton.MouseButton1Up:Connect(function() HandleMobileInput("a", false) end)
LeftButton.MouseLeave:Connect(function() HandleMobileInput("a", false) end)

RightButton.MouseButton1Down:Connect(function() HandleMobileInput("d", true) end)
RightButton.MouseButton1Up:Connect(function() HandleMobileInput("d", false) end)
RightButton.MouseLeave:Connect(function() HandleMobileInput("d", false) end)

local function startFlying()
	if flying then return end
	flying = true
	if UserInputService.TouchEnabled then FlyPad.Visible = true end

	local char = plr.Character or plr.CharacterAdded:Wait()
	local UpperTorso = char:WaitForChild("UpperTorso")
	local speed = 0

	local bg = Instance.new("BodyGyro", UpperTorso)
	bg.P = 9e4
	bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
	bg.cframe = UpperTorso.CFrame

	local bv = Instance.new("BodyVelocity", UpperTorso)
	bv.velocity = Vector3.new(0, 0.1, 0)
	bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

	PlayAnim(10714347256, 4, 0)

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

	coroutine.wrap(function()
		while flying and char and char.Parent do
			RunService.RenderStepped:Wait()
			char.Humanoid.PlatformStand = true

			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				speed += FlySpeed * 0.10
				if speed > FlySpeed then speed = FlySpeed end
			elseif speed > 0 then
				speed -= FlySpeed * 0.10
				if speed < 0 then speed = 0 end
			end

			if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
				bv.velocity = (
					(workspace.CurrentCamera.CFrame.LookVector * (ctrl.f + ctrl.b)) +
						((workspace.CurrentCamera.CFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * 0.2, 0)).Position - workspace.CurrentCamera.CFrame.Position)
				) * speed
				lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
			elseif speed > 0 then
				bv.velocity = (
					(workspace.CurrentCamera.CFrame.LookVector * (lastctrl.f + lastctrl.b)) +
						((workspace.CurrentCamera.CFrame * CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * 0.2, 0)).Position - workspace.CurrentCamera.CFrame.Position)
				) * speed
			else
				bv.velocity = Vector3.new(0, 0.1, 0)
			end

			bg.CFrame = workspace.CurrentCamera.CFrame * CFrame.Angles(-math.rad((ctrl.f + ctrl.b) * 50 * speed / FlySpeed), 0, 0)
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

function resetanims()
	task.wait()
	task.spawn(function()
		local Char = Players.LocalPlayer.Character or Players.LocalPlayer.CharacterAdded:Wait()
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

local function stopFlying()
	if not flying then return end
	flying = false
	FlyPad.Visible = false
	if KeyDownFunction then KeyDownFunction:Disconnect() end
	if KeyUpFunction then KeyUpFunction:Disconnect() end
	StopAnim()
	resetanims()
end

button.MouseButton1Click:Connect(function()
	playclicksound()
	toggle = not toggle
	if toggle then startFlying() else stopFlying() end
	button.Text = toggle and "F:O" or "F:X"
	button.BackgroundColor3 = toggle and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 0, 0)
end)

Players.LocalPlayer.Character:FindFirstChild("Humanoid").Died:Connect(function()
	toggle = false
	stopFlying()
	button.Text = "F:X"
	button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
end)
