-------------------------------------------------------------------------------------------------------------------------------

if not game:IsLoaded() then game["Loaded"]:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

local players = game:GetService("Players")
local runservice = game:GetService("RunService")
local player = players.LocalPlayer
local camera = workspace.CurrentCamera
local uis = game:GetService("UserInputService")
local onmobile = uis.TouchEnabled

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

local players = game:GetService("Players")
local runservice = game:GetService("RunService")
local camera = workspace.CurrentCamera
local localPlayer = players.LocalPlayer

local espEnabled = false
local boxes = {}

-- Create a GUI container for all boxes
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BoxESP_GUI"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")

local function removeBox(plr)
	if boxes[plr] then
		boxes[plr]:Destroy()
		boxes[plr] = nil
	end
end

local function createBox(plr)
	removeBox(plr)

	local box = Instance.new("Frame")
	box.BackgroundTransparency = 1
	box.BorderSizePixel = 2
	box.BorderColor3 = plr.Team and plr.Team.TeamColor.Color or Color3.fromRGB(255, 255, 255)
	box.Visible = false
	box.ZIndex = 10
	box.Parent = screenGui

	boxes[plr] = box
end

local function updateBox(plr)
	if not espEnabled then return end
	local char = plr.Character
	if not char then
		removeBox(plr)
		return
	end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	local head = char:FindFirstChild("Head")
	local humanoid = char:FindFirstChildOfClass("Humanoid")

	if not hrp or not head or not humanoid then
		removeBox(plr)
		return
	end

	local box = boxes[plr]
	if not box then
		createBox(plr)
		box = boxes[plr]
	end

	local hrpPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
	if not onScreen then
		box.Visible = false
		return
	end

	-- Calculate the bounding box in 2D space
	local _, headPosOnScreen = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
	local _, footPosOnScreen = camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))

	local height = math.abs(headPosOnScreen.Y - footPosOnScreen.Y)
	local width = height / 2
	local x = hrpPos.X - width / 2
	local y = headPosOnScreen.Y

	box.Size = UDim2.new(0, width, 0, height)
	box.Position = UDim2.new(0, x, 0, y)
	box.Visible = true
end

local function updateAll()
	if not espEnabled then return end
	for _, plr in ipairs(players:GetPlayers()) do
		if plr ~= localPlayer then
			updateBox(plr)
		end
	end
end

runservice.RenderStepped:Connect(updateAll)

players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		if espEnabled then
			createBox(plr)
		end
	end)
end)

players.PlayerRemoving:Connect(removeBox)

local function toggleESP(state)
	espEnabled = state
	if not espEnabled then
		for plr, _ in pairs(boxes) do
			removeBox(plr)
		end
	else
		for _, plr in ipairs(players:GetPlayers()) do
			if plr ~= localPlayer and plr.Character then
				createBox(plr)
			end
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
