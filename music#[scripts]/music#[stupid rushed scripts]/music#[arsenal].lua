-------------------------------------------------------------------------------------------------------------------------------

if not game:IsLoaded() then game.Loaded:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

local players = game:GetService("Players")
local runservice = game:GetService("RunService")
local player = players.LocalPlayer
local camera = workspace.CurrentCamera
local uis = game:GetService("UserInputService")
local onmobile = uis.TouchEnabled
local testing = false

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

local function removecircle()
	if circle then circle:Destroy() end
	circle = nil
end

local function isOnCrosshair(worldPos)
	local screenPos, onScreen = camera:WorldToViewportPoint(worldPos)
	if not onScreen then return false end

	local crossX = camera.ViewportSize.X/2
	local crossY = camera.ViewportSize.Y/2

	local delta = Vector2.new(screenPos.X - crossX, screenPos.Y - crossY)
	return delta.Magnitude <= 3
end

local function isobstructing(part)
	if not part then return true end

	if part.Transparency == 1 then
		return false
	end

	if not part:IsDescendantOf(workspace) then
		return false
	end

	if not part:IsA("BasePart") then
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

	if part.Transparency >= 0.95 then
		return false
	end

	return true
end

local triggerEnabled = false
local lockedTarget = nil
local holdingon = false
local teamcheck = true
local vim = cloneref(game:GetService("VirtualInputManager"))

local function simulateMouseDown()
	if not holdingon then 
		vim:SendMouseButtonEvent(camera.ViewportSize.X/2, camera.ViewportSize.Y/2, 0, true, game, 0) 
		holdingon = true 
	end
end

local function simulateMouseUp()
	if holdingon then task.wait()
		vim:SendMouseButtonEvent(camera.ViewportSize.X/2, camera.ViewportSize.Y/2, 0, false, game, 0) 
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
	local myLookVector = camera.CFrame.LookVector

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
		if humanoid and humanoid.Health > 0 and isPartVisible(lockedTarget, lockedTarget.Parent) then
			local dist = (lockedTarget.Position - mypos).Magnitude
			if dist <= 500 then
				return lockedTarget
			end
		end
	end

	lockedTarget = nil

	local bestTarget = nil
	local closestDistance = math.huge

	for _, p in ipairs(players:GetPlayers()) do
		if p == player then continue end

		local char = p.Character
		if not char then continue end

		local humanoid = char:FindFirstChildOfClass("Humanoid")
		local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
		local head = char:FindFirstChild("Head")

		if not humanoid or humanoid.Health <= 0 or not hrp then continue end
		if teamcheck and p.Team and p.Team == player.Team then continue end
		if char:FindFirstChildOfClass("ForceField") then continue end

		local dist = (hrp.Position - mypos).Magnitude
		if dist > 500 then continue end

		local targetPart
		if head and isPartVisible(head, char) then
			targetPart = head
		elseif isPartVisible(hrp, char) then
			targetPart = hrp
		end

		if targetPart then
			if dist < closestDistance then
				closestDistance = dist
				bestTarget = targetPart
			end
		end
	end

	lockedTarget = bestTarget
	return bestTarget
end

local smoothSpeed = 22
local preLockDelay = 0.15
local pendingTarget = nil
local lockStartTime = 0

runservice.RenderStepped:Connect(function(dt)
	if toggle then
		local target = getclosestvisibleenemypart()

		if target then
			if target ~= pendingTarget then
				pendingTarget = target
				lockStartTime = tick()
				return
			end

			if tick() - lockStartTime < preLockDelay then
				return
			end

			lockedTarget = pendingTarget

			local campos = camera.CFrame.Position
			local newlookvector = (lockedTarget.Position - campos).Unit
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
			pendingTarget = nil
			lockStartTime = 0
			lockedTarget = nil
			simulateMouseUp()
		end
	end
end)

local function togglecamlock(state)
	toggle = state
	if not state then
		lockedTarget = nil
		simulateMouseUp()
	end
	if state then makecircle() else removecircle() end
end

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

local function toggletriggerbot(state)
	triggerEnabled = state
end

local esptargets = {}
local espenabled = false

local function makebox(plr)
	if plr == player then return end

	local char = plr.Character
	if not char then return end

	if esptargets[plr] then
		esptargets[plr].ScreenGui:Destroy()
	end

	local sc = Instance.new("ScreenGui")
	sc.ResetOnSpawn = false
	sc.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	sc.IgnoreGuiInset = true
	sc.Parent = gethui() or game:GetService("CoreGui")

	local boxFrame = Instance.new("Frame")
	boxFrame.BackgroundTransparency = 1
	boxFrame.Size = UDim2.new(0, 100, 0, 200)
	boxFrame.Position = UDim2.new(0, 0, 0, 0)
	boxFrame.Visible = false
	boxFrame.Parent = sc

	local boxStroke = Instance.new("UIStroke")
	boxStroke.Thickness = 2
	boxStroke.Transparency = 0
	boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	boxStroke.Parent = boxFrame

	if plr.Team then
		boxStroke.Color = plr.Team.TeamColor.Color
	else
		boxStroke.Color = Color3.fromRGB(255, 255, 255)
	end

	esptargets[plr] = {
		ScreenGui = sc,
		BoxFrame = boxFrame,
		BoxStroke = boxStroke,
	}
end

local function noesp(plr)
	if esptargets[plr] then
		esptargets[plr].ScreenGui:Destroy()
		esptargets[plr] = nil
	end
end

local function updateBoxESP(plr)
	if not espenabled or plr == player then return end

	local data = esptargets[plr]
	if not data then return end

	local char = plr.Character
	if not char then
		noesp(plr)
		return
	end

	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then
		noesp(plr)
		return
	end

	local cf, size = char:GetBoundingBox()

	local corners = {}
	for x = -0.5, 0.5, 1 do
		for y = -0.5, 0.5, 1 do
			for z = -0.5, 0.5, 1 do
				table.insert(corners, (cf.Position + (cf.RightVector * size.X * x) + (cf.UpVector * size.Y * y) + (cf.LookVector * size.Z * z)))
			end
		end
	end

	local minX, minY, maxX, maxY
	local onscreen = false
	for _, corner in ipairs(corners) do
		local screenPos, onScreen = camera:WorldToViewportPoint(corner)
		if onScreen then
			onscreen = true
			if not minX or screenPos.X < minX then minX = screenPos.X end
			if not maxX or screenPos.X > maxX then maxX = screenPos.X end
			if not minY or screenPos.Y < minY then minY = screenPos.Y end
			if not maxY or screenPos.Y > maxY then maxY = screenPos.Y end
		end
	end

	if not onscreen or not minX then
		data.BoxFrame.Visible = false
		return
	end

	data.BoxFrame.Visible = true

	local boxWidth = maxX - minX
	local boxHeight = maxY - minY
	local centerX = (minX + maxX) / 2
	local centerY = (minY + maxY) / 2

	data.BoxFrame.Size = UDim2.new(0, boxWidth, 0, boxHeight)
	data.BoxFrame.Position = UDim2.new(0, centerX - boxWidth / 2, 0, centerY - boxHeight / 2)

	if plr.Team then
		data.BoxStroke.Color = plr.Team.TeamColor.Color
	else
		data.BoxStroke.Color = Color3.fromRGB(255, 255, 255)
	end
end

local function updesp()
	for _, plr in ipairs(players:GetPlayers()) do
		if plr ~= player then
			if espenabled then
				if not esptargets[plr] then
					makebox(plr)
				end
				updateBoxESP(plr)
			else
				noesp(plr)
			end
		end
	end
end

local function toggleesp(state)
	espenabled = state
	if not espenabled then
		for plr in pairs(esptargets) do
			noesp(plr)
		end
	else
		for _, plr in ipairs(players:GetPlayers()) do
			if plr ~= player and plr.Character then
				makebox(plr)
			end
		end
	end
end

players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function()
		if espenabled then
			makebox(plr)
		end
	end)
end)

players.PlayerRemoving:Connect(noesp)
runservice.RenderStepped:Connect(updesp)

local testsound

local function playtest()
	local a = "https://files.catbox.moe/jt5t6y.mp3"
	local b = "Bomber (Slowed).mp3"
	local c, fileData = pcall(readfile, b)

	if not c then
		local audioContent = game:HttpGet(a)
		writefile(b, audioContent)
	end

	if not testsound then
		testsound = Instance.new("Sound")
		testsound.SoundId = getcustomasset(b)
		testsound.Volume = 1
		testsound.Parent = workspace
		testsound:Play()
		testsound.Looped = true
	end
end

function stoptest()
	if testsound then testsound:Destroy() testsound = nil end
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
	{keybind = true, key = "R", type = "toggle", text = "Toggle Camlock [R]", callback = function(s) togglecamlock(s) end},
	{keybind = false, key = nil, type = "toggle", text = "Toggle ESP", callback = function(s) toggleesp(s) end},
	{keybind = false, key = nil, type = "toggle", text = "Toggle No Team Check", callback = function(s) teamcheck = not s end},
	{keybind = true, key = "Z", type = "toggle", text = "Toggle Trigger Bot [Z]", callback = function(s) toggletriggerbot(s) end}
}

if testing == true then
	table.insert(buttons, {keybind = true, key = nil, type = "toggle", text = "Toggle Test", callback = function(s) if s then playtest() else stoptest() end end})
end

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
