-------------------------------------------------------------------------------------------------------------------------------

if not game:IsLoaded() then game["Loaded"]:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

local players = game:GetService("Players")
local runservice = game:GetService("RunService")
local player = players["LocalPlayer"]
local camera = workspace["CurrentCamera"]

-------------------------------------------------------------------------------------------------------------------------------

local toggle = false
local circle = nil

local function makecircle()
	if circle then circle:Destroy() end

	local screengui = player:FindFirstChildOfClass("PlayerGui")
	if not screengui then return end
	local gui = screengui:FindFirstChild("GUI")
	if not gui then return end
	local crosshairs = gui:FindFirstChild("Crosshairs")
	if not crosshairs then return end
	local crosshair = crosshairs:FindFirstChild("Crosshair"):FindFirstChild("Dot")
	if not crosshair then return end

	circle = Instance.new("Frame")
	circle.AnchorPoint = Vector2.new(0.5, 0.5)
	circle.Size = UDim2.new(0, 421, 0, 421)
	circle.Position = crosshair.Position
	circle.BackgroundTransparency = 1
	circle.ZIndex = crosshair.ZIndex - 1
	circle.Parent = crosshair

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = circle

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Transparency = 0
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = circle
end

local function removecircle()
	if circle then circle:Destroy() end
	circle = nil
end

local function isobstructing(part)
	if not part then return true end
	if part.Transparency >= 0.9 then return false end
	if not part.CanCollide then return false end
	if part:IsDescendantOf(player.Character) or part:IsDescendantOf(camera) then return false end
	if part:IsA("TrussPart") or part:IsA("WedgePart") then return true end

	local size = part.Size
	local minDimension = math.min(size.X, size.Y, size.Z)
	if minDimension < 1 then
		return true
	end

	return true
end

local lockedTarget = nil

local function getclosestvisibleenemypart()
	local mychar = player.Character
	if not mychar or not mychar:FindFirstChild("HumanoidRootPart") then 
		lockedTarget = nil
		return nil 
	end

	local myhrp = mychar.HumanoidRootPart
	local mypos = myhrp.Position

	local function isVisible(targetPart, char)
		local rayorigin = camera.CFrame.Position
		local targetPos = targetPart.Position
		local raydir = (targetPos - rayorigin)
		local raylength = raydir.Magnitude

		local raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances = {player.Character, camera, char}
		raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
		raycastParams.IgnoreWater = true

		local raycastResult = workspace:Raycast(rayorigin, raydir, raycastParams)

		if raycastResult then
			local hitPart = raycastResult.Instance
			if hitPart and not hitPart:IsDescendantOf(char) then
				return false
			end
		end

		return true
	end

	local function isPartVisible(targetPart, char)
		if not targetPart then return false end

		local screenpos, onscreen = camera:WorldToViewportPoint(targetPart.Position)
		if not onscreen then return false end

		return isVisible(targetPart, char)
	end

	if lockedTarget and lockedTarget.Parent then
		local humanoid = lockedTarget.Parent:FindFirstChildOfClass("Humanoid")
		if humanoid and humanoid.Health > 0 then
			if isPartVisible(lockedTarget, lockedTarget.Parent) then
				return lockedTarget
			end
		end
	end
	lockedTarget = nil

	local bestPart = nil
	local bestDistance = math.huge
	local lowestHealth = math.huge

	for _, p in ipairs(players:GetPlayers()) do
		if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character:FindFirstChild("HumanoidRootPart") then
			local hwrapClone = workspace:FindFirstChild("HWRAP_" .. p.Name)
			if not hwrapClone or #hwrapClone:GetChildren() == 0 then return end
			
			local char = p.Character
			local humanoid = char:FindFirstChildOfClass("Humanoid")
			if humanoid.Health <= 0 then continue end
			if p.Team and p.Team == player.Team then continue end
			if char:FindFirstChildOfClass("ForceField") then continue end

			local head = char:FindFirstChild("Head")
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if not hrp then continue end

			local distToHRP = (hrp.Position - mypos).Magnitude

			if head and isPartVisible(head, char) then
				local dist = (head.Position - mypos).Magnitude
				if dist < bestDistance or (dist == bestDistance and humanoid.Health < lowestHealth) then
					bestPart = head
					bestDistance = dist
					lowestHealth = humanoid.Health
				end
			end

			if hrp and isPartVisible(hrp, char) then
				local dist = (hrp.Position - mypos).Magnitude
				if dist < bestDistance or (dist == bestDistance and humanoid.Health < lowestHealth) then
					bestPart = hrp
					bestDistance = dist
					lowestHealth = humanoid.Health
				end
			end

			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") and (part.Name == "UpperTorso" or part.Name == "LowerTorso") then
					if isPartVisible(part, char) then
						local dist = (part.Position - mypos).Magnitude
						if dist < bestDistance or (dist == bestDistance and humanoid.Health < lowestHealth) then
							bestPart = part
							bestDistance = dist
							lowestHealth = humanoid.Health
						end
					end
				end
			end
		end
	end

	lockedTarget = bestPart
	return bestPart
end

local smoothSpeed = 23

runservice.RenderStepped:Connect(function(dt)
	if toggle then
		local target = getclosestvisibleenemypart()
		if target then
			local campos = camera.CFrame.Position
			local newlookvector = (target.Position - campos).Unit
			local newcf = CFrame.new(campos, campos + newlookvector)

			local alpha = math.clamp(dt * smoothSpeed, 0, 1)

			local easedAlpha
			if alpha < 0.5 then
				easedAlpha = 4 * alpha * alpha * alpha
			else
				easedAlpha = 1 - (-2 * alpha + 2)^3 / 2
			end

			camera.CFrame = camera.CFrame:Lerp(newcf, easedAlpha)
		end
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

function clik() 
	task.spawn(function()
		local s = Instance.new("Sound") 
		s.SoundId = "rbxassetid://87152549167464"
		s.Parent = workspace
		s.Volume = 1.2 
		s.TimePosition = 0.1 
		s:Play() 
	end)
end

function repos(ui, w, h, off)
	off = off or 0
	local sw, sh = game.Workspace.CurrentCamera.ViewportSize.X, game.Workspace.CurrentCamera.ViewportSize.Y
	local cx, cy = (sw - w) / 2, (sh - h) / 2 - 56
	ui.Position = UDim2.new(0, cx + off, 0, cy)
end

local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = gethui() or game:GetService("CoreGui")
if screenGui.Parent:FindFirstChild("Stupid Rushed Script") then screenGui.Parent:FindFirstChild("Stupid Rushed Script"):Destroy() end
screenGui.Name = "Stupid Rushed Script"

-------------------------------------------------------------------------------------------------------------------------------

local function maketoggle(text, initialState, callback, offset)
	local toggled = initialState or false

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 90, 0, 55)
	btn.TextStrokeTransparency = 1
	repos(btn, 90, 55, offset)
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
	btn.Text = text
	btn.Parent = screenGui

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = Color3.new(1, 1, 1)
	stroke.Parent = btn
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local function updateVisual()
		if toggled then
			btn.TextColor3 = Color3.fromRGB(0, 255, 0)
			stroke.Color = Color3.fromRGB(0, 255, 0)
		else
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			stroke.Color = Color3.fromRGB(255, 255, 255)
		end
	end

	updateVisual()

	local function toggleButton()
		clik()
		toggled = not toggled
		updateVisual()
		if callback then callback(toggled) end
	end

	btn.MouseButton1Click:Connect(toggleButton)

	game["UserInputService"].InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.R then
			toggleButton()
		end
	end)

	return btn
end

-------------------------------------------------------------------------------------------------------------------------------

maketoggle("Toggle Camlock [RC]", false, function(s) if s then toggle = true makecircle() else toggle = false removecircle() end end, 0)

-------------------------------------------------------------------------------------------------------------------------------
