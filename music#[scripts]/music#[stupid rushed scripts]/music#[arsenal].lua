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
	local gui = screengui:WaitForChild("GUI")
	if not gui then return end
	local crosshairs = gui:WaitForChild("Crosshairs")
	if not crosshairs then return end
	local crosshair = crosshairs:WaitForChild("Crosshair"):WaitForChild("Dot")
	if not crosshair then return end

	circle = Instance.new("Frame")
	circle.Name = "AimCircle"
	circle.AnchorPoint = Vector2.new(0.5, 0.5)
	circle.Size = UDim2.new(0, 921, 0, 921)
	circle.Position = crosshair.Position
	circle.BackgroundTransparency = 1
	circle.ZIndex = crosshair.ZIndex - 1
	circle.Parent = crosshair

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = circle

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 2
	stroke.Transparency = 0.4
	stroke.Color = Color3.fromRGB(0, 0, 0)
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = circle
end

local function removecircle()
	if circle then circle:Destroy() end
	circle = nil
end

local function isobstructing(part)
	if not part then return false end
	if part.Transparency >= 1 then return false end
	if not part.CanCollide then return false end
	if part:IsDescendantOf(player.Character) or part:IsDescendantOf(camera) then return false end
	return true
end

local lockedTarget = nil

local function getclosestvisibleenemypart()
	local mychar = player.Character
	if not mychar or not mychar:FindFirstChild("HumanoidRootPart") then 
		lockedTarget = nil
		return nil 
	end

	local mypos = mychar.HumanoidRootPart.Position

	local screengui = player:FindFirstChildOfClass("PlayerGui")
	if not screengui then return nil end
	local gui = screengui:FindFirstChild("GUI")
	if not gui then return nil end
	local crosshairs = gui:FindFirstChild("Crosshairs")
	if not crosshairs then return nil end
	local crosshair = crosshairs:FindFirstChild("Crosshair"):FindFirstChild("Dot")
	if not crosshair then return nil end

	local crosspos = Vector2.new(
		crosshair.AbsolutePosition.X + crosshair.AbsoluteSize.X / 2,
		crosshair.AbsolutePosition.Y + crosshair.AbsoluteSize.Y / 2
	)

	local function isVisible(targetPart, char)
		local rayorigin = camera.CFrame.Position
		local raydir = (targetPart.Position - rayorigin)
		local ignorelist = {player.Character, camera}
		local hit = workspace:FindPartOnRayWithIgnoreList(Ray.new(rayorigin, raydir.Unit * raydir.Magnitude), ignorelist)

		while hit and not hit:IsDescendantOf(char) and not isobstructing(hit) do
			table.insert(ignorelist, hit)
			hit = select(1, workspace:FindPartOnRayWithIgnoreList(Ray.new(rayorigin, raydir.Unit * raydir.Magnitude), ignorelist))
		end

		return hit and hit:IsDescendantOf(char)
	end

	if lockedTarget and lockedTarget.Parent then
		local humanoid = lockedTarget.Parent:FindFirstChildOfClass("Humanoid")
		if humanoid and humanoid.Health > 0 then
			local screenpos, onscreen = camera:WorldToViewportPoint(lockedTarget.Position)
			if onscreen then
				local target2d = Vector2.new(screenpos.X, screenpos.Y)
				local distpixels = (target2d - crosspos).Magnitude
				if distpixels <= 921 and isVisible(lockedTarget, lockedTarget.Parent) then
					return lockedTarget
				end
			end
		end
	end
	lockedTarget = nil

	local bestPart = nil
	local lowestHealth = math.huge
	local closestScreenDist = math.huge

	for _, p in ipairs(players:GetPlayers()) do
		if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character:FindFirstChild("HumanoidRootPart") then
			local hwrap = workspace:FindFirstChild("HWRAP_" .. player.Name):WaitForChild("Gun")
			if not hwrap or not hwrap:IsA("MeshPart") then continue end

			local char = p.Character
			local humanoid = char:FindFirstChildOfClass("Humanoid")

			if humanoid.Health > 0 and (not p.Team or p.Team ~= player.Team) and not char:FindFirstChildOfClass("ForceField") then
				local head = char:FindFirstChild("Head")
				local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
				local targetpart = math.random() < 0.3 and head or torso

				if targetpart then
					local screenpos, onscreen = camera:WorldToViewportPoint(targetpart.Position)
					if onscreen then
						local target2d = Vector2.new(screenpos.X, screenpos.Y)
						local distpixels = (target2d - crosspos).Magnitude

						if distpixels <= 140 and isVisible(targetpart, char) then
							if humanoid.Health < lowestHealth or (humanoid.Health == lowestHealth and distpixels < closestScreenDist) then
								bestPart = targetpart
								lowestHealth = humanoid.Health
								closestScreenDist = distpixels
							end
						end
					end
				end
			end
		end
	end

	lockedTarget = bestPart
	return bestPart
end

runservice.RenderStepped:Connect(function()
	if toggle then
		local target = getclosestvisibleenemypart()
		if target then
			local campos = camera.CFrame.Position
			local newlookvector = (target.Position - campos).Unit
			local newcf = CFrame.new(campos, campos + newlookvector)

			local alpha = 0.31
			local easedalpha
			if alpha < 0.5 then
				easedalpha = 2 * alpha * alpha
			else
				easedalpha = -1 + (4 - 2 * alpha) * alpha
			end

			camera.CFrame = camera.CFrame:Lerp(newcf, easedalpha)
		end
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = gethui() or game:GetService("CoreGui")
if screenGui.Parent:FindFirstChild("ASNS") then screenGui.Parent:FindFirstChild("ASNS"):Destroy() end
screenGui.Name = "ASNS"

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

local camlock = Instance.new("TextButton")
camlock.Size = UDim2.new(0, 70, 0, 55)
camlock.TextStrokeTransparency = 1
repos(camlock, 70, 55)
camlock.BackgroundTransparency = 0.3
camlock.TextColor3 = Color3.fromRGB(255, 255, 255)
camlock.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
camlock.Font = Enum.Font.Code
camlock.BorderSizePixel = 0
camlock.TextSize = 13
camlock.TextXAlignment = Enum.TextXAlignment.Center
camlock.TextYAlignment = Enum.TextYAlignment.Center
camlock.Active = true
camlock.Draggable = true
camlock.TextWrapped = true
camlock.Text = "Toggle Camlock"
camlock.Parent = screenGui

local camlockbord = Instance.new("UIStroke")
camlockbord.Thickness = 1
camlockbord.Color = Color3.new(1, 1, 1)
camlockbord.Parent = camlock
camlockbord.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

camlock.MouseButton1Click:Connect(function()
	clik()
	toggle = not toggle
	if toggle then
		camlock.TextColor3 = Color3.fromRGB(0, 255, 0)
		camlockbord.Color = Color3.new(0, 1, 0)
		makecircle()
	else
		camlock.TextColor3 = Color3.fromRGB(255, 255, 255)
		camlockbord.Color = Color3.new(1, 1, 1)
		removecircle()
	end
end)

game["UserInputService"].InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	local key = input.KeyCode
	if key == Enum.KeyCode.R then
		clik()
		toggle = not toggle
		if toggle then
			camlock.TextColor3 = Color3.fromRGB(0, 255, 0)
			camlockbord.Color = Color3.new(0, 1, 0)
			makecircle()
		else
			camlock.TextColor3 = Color3.fromRGB(255, 255, 255)
			camlockbord.Color = Color3.new(1, 1, 1)
			removecircle()
		end
	end
end)

-------------------------------------------------------------------------------------------------------------------------------
