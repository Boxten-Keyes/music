task.wait(1)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
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
button.Text = "CL:X"
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

local function getClosestVisibleEnemyPart()
	local closest = nil
	local minDist = math.huge
	local screenCenter = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)

	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player and p.Team ~= player.Team and p.Character and not p.Character:IsDescendantOf(camera) then
			local char = p.Character
			local head = char:FindFirstChild("Head")
			local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
			local humanoid = char:FindFirstChildOfClass("Humanoid")

			if head and torso and humanoid and humanoid.Health > 0 then
				-- Decide whether to target head or torso
				local targetPart = math.random() < 0.3 and head or torso

				-- Check visibility
				local camLook = camera.CFrame.LookVector
				local toTarget = (targetPart.Position - camera.CFrame.Position).Unit
				if camLook:Dot(toTarget) > 0.5 then
					local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
					if onScreen then
						local screenPoint = Vector2.new(screenPos.X, screenPos.Y)
						local distFromCenter = (screenPoint - screenCenter).Magnitude
						if distFromCenter <= 200 then
							local rayDir = (targetPart.Position - camera.CFrame.Position)
							local ray = Ray.new(camera.CFrame.Position, rayDir.Unit * rayDir.Magnitude)
							local hit = workspace:FindPartOnRayWithIgnoreList(ray, {player.Character, camera})
							if hit and hit:IsDescendantOf(char) then
								if distFromCenter < minDist then
									minDist = distFromCenter
									closest = targetPart
								end
							end
						end
					end
				end
			end
		end
	end

	return closest
end

RunService.RenderStepped:Connect(function()
	if toggle then
		local target = getClosestVisibleEnemyPart()
		if target then
			local camPos = camera.CFrame.Position
			local newLookVector = (target.Position - camPos).Unit
			local newCF = CFrame.new(camPos, camPos + newLookVector)

			local alpha = 0.2
			local easedAlpha
			if alpha < 0.5 then
				easedAlpha = 2 * alpha * alpha
			else
				easedAlpha = -1 + (4 - 2 * alpha) * alpha
			end

			camera.CFrame = camera.CFrame:Lerp(newCF, easedAlpha)
		end
	end
end)

button.MouseButton1Click:Connect(function()
	playclicksound()
	toggle = not toggle
	button.Text = toggle and "CL:O" or "CL:X"
	button.BackgroundColor3 = toggle and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 0, 0)
end)
