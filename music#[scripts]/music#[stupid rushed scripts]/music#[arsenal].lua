-------------------------------------------------------------------------------------------------------------------------------

if not game:IsLoaded() then game["Loaded"]:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

local players = game:GetService("Players")
local runservice = game:GetService("RunService")
local player = players.LocalPlayer
local camera = workspace.CurrentCamera
local uis = game:GetService("UserInputService")
local onmobile = uis:TouchEnabled()

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
	circle.Size = onmobile and UDim2.new(0, 221, 0, 221) or UDim2.new(0, 421, 0, 421)
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

local function isOnCrosshair(worldPos)
	local screenPos, onScreen = camera:WorldToViewportPoint(worldPos)
	if not onScreen then return false end

	local crossX = camera.ViewportSize.X/2
	local crossY = camera.ViewportSize.Y/2

	local delta = Vector2.new(screenPos.X - crossX, screenPos.Y - crossY)
	return delta.Magnitude <= 3
end

local function removecircle()
	if circle then circle:Destroy() end
	circle = nil
end

local function isobstructing(part)
	if not part then return true end

	if part.Transparency >= 0.9 then
		return false
	end

	if not part.CanCollide then
		return false
	end

	if part:IsDescendantOf(player.Character) or part:IsDescendantOf(camera) then
		return false
	end

	if part:IsA("TrussPart") or part:IsA("WedgePart") then
		return true
	end

	local size = part.Size
	local minDimension = math.min(size.X, size.Y, size.Z)
	if minDimension < 1 then
		return false
	end

	return true
end

local triggerEnabled = false
local lockedTarget = nil
local holdingon = false

local function simulateMouseDown()
	if not holdingon then 
		game:GetService("VirtualInputManager"):SendMouseButtonEvent(camera.ViewportSize.X/2, camera.ViewportSize.Y/2, 0, true, game, 0) 
		holdingon = true 
	end
end

local function simulateMouseUp()
	if holdingon then task.wait()
		game:GetService("VirtualInputManager"):SendMouseButtonEvent(camera.ViewportSize.X/2, camera.ViewportSize.Y/2, 0, false, game, 0) 
		holdingon = false 
	end
end

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
		local raydir = targetPart.Position - rayorigin

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
				if lockedTarget.Position.Y - mypos.Y <= 400 then
					return lockedTarget
				end
			end
		end
	end
	lockedTarget = nil

	local bestTarget = nil
	local bestDistance = math.huge
	local lowestHealth = math.huge

	for _, p in ipairs(players:GetPlayers()) do
		if p == player then continue end
		local char = p.Character
		if not char then continue end

		local humanoid = char:FindFirstChildOfClass("Humanoid")
		local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
		local head = char:FindFirstChild("Head")
		if not humanoid or humanoid.Health <= 0 or not hrp then continue end
		if p.Team and p.Team == player.Team then continue end
		if char:FindFirstChildOfClass("ForceField") then continue end

		local yDiff = hrp.Position.Y - mypos.Y
		if yDiff > 500 then continue end

		local targetPart
		local backOffset = -hrp.CFrame.LookVector * 1.5

		if head and math.random() <= 0.3 and isPartVisible(head, char) then
			targetPart = head
		elseif isPartVisible(hrp, char) then
			targetPart = hrp
		else
			continue
		end

		local dist = (targetPart.Position - mypos).Magnitude
		if dist < bestDistance or (dist == bestDistance and humanoid.Health < lowestHealth) then
			bestTarget = targetPart
			bestDistance = dist
			lowestHealth = humanoid.Health
		end
	end

	lockedTarget = bestTarget
	return bestTarget
end

local smoothSpeed = 23

runservice.RenderStepped:Connect(function(dt)
	if toggle then
		local target = getclosestvisibleenemypart()
		if target then
			lockedTarget = target

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
		else
			lockedTarget = nil
			simulateMouseUp()
		end
	end
end)

local triggerDelay = 0.3
local timeOnCrosshair = 0
local isShooting = false

runservice.RenderStepped:Connect(function(dt)
	if not triggerEnabled then 
		timeOnCrosshair = 0
		if isShooting then
			simulateMouseUp()
			isShooting = false
		end
		return 
	end

	local shouldShoot = false

	if lockedTarget and lockedTarget.Parent and lockedTarget.Position then
		if isOnCrosshair(lockedTarget.Position) then
			shouldShoot = true
		end
	end

	if shouldShoot then
		timeOnCrosshair = timeOnCrosshair + dt

		if timeOnCrosshair >= triggerDelay and not isShooting then
			simulateMouseDown()
			isShooting = true
		end
	else
		timeOnCrosshair = 0
		if isShooting then
			simulateMouseUp()
			isShooting = false
		end
	end
end)

local function toggleTriggerBot(state)
	triggerEnabled = state
end

local highlights = {}
local espEnabled = false

local function highlightCharacter(plr)
	if plr == player then return end
	local char = plr.Character
	if not char then return end

	if highlights[plr] then
		highlights[plr]:Destroy()
	end

	local hl = Instance.new("Highlight")
	hl.Parent = char
	hl.Adornee = char
	hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	hl.FillTransparency = 0.4
	hl.OutlineTransparency = 0

	if plr.Team then
		hl.FillColor = plr.Team.TeamColor.Color
		hl.OutlineColor = Color3.fromRGB(255, 255, 255)
	else
		hl.FillColor = Color3.fromRGB(255, 255, 255)
		hl.OutlineColor = Color3.fromRGB(255, 255, 255)
	end

	highlights[plr] = hl
end

local function removeHighlight(plr)
	if highlights[plr] then
		highlights[plr]:Destroy()
		highlights[plr] = nil
	end
end

local function updateHighlights()
	for _, plr in ipairs(players:GetPlayers()) do
		if espEnabled and plr.Character then
			highlightCharacter(plr)
		else
			removeHighlight(plr)
		end
	end
end

players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		if espEnabled then
			highlightCharacter(plr)
		end
	end)
end)

players.PlayerRemoving:Connect(removeHighlight)
runservice.RenderStepped:Connect(updateHighlights)

local function toggleESP(state)
	espEnabled = state
	if not espEnabled then
		for plr, _ in pairs(highlights) do
			removeHighlight(plr)
		end
	end
end

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

local function repos(ui, row, col, totalRows, totalCols)
	local buttonWidth = 90
	local buttonHeight = 55
	local spacing = 10

	local totalWidth = (buttonWidth * totalCols) + (spacing * (totalCols - 1))
	local totalHeight = (buttonHeight * totalRows) + (spacing * (totalRows - 1))

	local sw, sh = camera.ViewportSize.X, camera.ViewportSize.Y
	local startX = (sw - totalWidth) / 2
	local startY = (sh - totalHeight) / 2 - 56

	local x = startX + (col - 1) * (buttonWidth + spacing)
	local y = startY + (row - 1) * (buttonHeight + spacing)

	ui.Position = UDim2.new(0, x, 0, y)
end

local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = gethui() or game:GetService("CoreGui")
if screenGui.Parent:FindFirstChild("Stupid Rushed Script") then screenGui.Parent:FindFirstChild("Stupid Rushed Script"):Destroy() end
screenGui.Name = "Stupid Rushed Script"

-------------------------------------------------------------------------------------------------------------------------------

local function maketoggle(keybind, key, text, initialState, callback, row, col, totalRows, totalCols)
	local toggled = initialState or false

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 90, 0, 55)
	btn.TextStrokeTransparency = 1
	repos(btn, row, col, totalRows, totalCols)
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

	local function updvisual()
		if toggled then
			btn.TextColor3 = Color3.fromRGB(0, 255, 0)
			stroke.Color = Color3.fromRGB(0, 255, 0)
		else
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			stroke.Color = Color3.fromRGB(255, 255, 255)
		end
	end

	updvisual()

	local function toggleButton()
		clik()
		toggled = not toggled
		updvisual()
		if callback then callback(toggled) end
	end

	btn.MouseButton1Click:Connect(toggleButton)
	
	if keybind and key then
		game["UserInputService"].InputBegan:Connect(function(input, gp)
			if gp then return end
			if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode[key] then
				toggleButton()
			end
		end)
	end

	return btn
end

-------------------------------------------------------------------------------------------------------------------------------

local buttons = {
	{keybind = true, key = "R", type = "toggle", text = "Toggle Camlock [R]", callback = function(s) toggle = s if s then makecircle() else removecircle() end end},
	{keybind = false, key = nil, type = "toggle", text = "Toggle ESP", callback = function(s) toggleESP(s) end},
	{keybind = true, key = "Z", type = "toggle", text = "Toggle Trigger Bot [Z]", callback = function(s) toggleTriggerBot(s) end}
}

-------------------------------------------------------------------------------------------------------------------------------

local maxcolumns = 5
local maxbuttonspercolumn = 8
local totalbuttons = #buttons

local columns = math.min(maxbuttonspercolumn, math.ceil(totalbuttons / maxcolumns))
local rows = math.ceil(totalbuttons / columns)

local buttonindex = 1
for col = 1, columns do
	for row = 1, rows do
		if buttonindex > totalbuttons then break end

		local buttondata = buttons[buttonindex]
		if buttondata.type == "toggle" then
			maketoggle(buttondata.keybind, buttondata.key, buttondata.text, false, buttondata.callback, row, col, rows, columns)
		end

		buttonindex = buttonindex + 1
	end
end

-------------------------------------------------------------------------------------------------------------------------------
