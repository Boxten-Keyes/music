-------------------------------------------------------------------------------------------------------------------------------

if not game:IsLoaded() then game["Loaded"]:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

local players = game:GetService("Players")
local runservice = game:GetService("RunService")
local player = players["LocalPlayer"]
local camera = workspace["CurrentCamera"]

-------------------------------------------------------------------------------------------------------------------------------

local screengui = Instance.new("ScreenGui")
screengui["ResetOnSpawn"] = false
if runservice:IsStudio() then screengui["Parent"] = player:WaitForChild("PlayerGui") else screengui["Parent"] = gethui and gethui() or game:GetService("CoreGui") end

function repos(ui, w, h)
	local sw, sh = camera["ViewportSize"]["X"], camera["ViewportSize"]["Y"]
	local cx, cy = (sw - w) / 2, (sh - h) / 2 - 56
	ui["Position"] = UDim2.new(0, cx, 0, cy)
end

local button = Instance.new("TextButton")
button["Size"] = UDim2.new(0, 46, 0, 46)
repos(button, 48, 48)
button["Text"] = "CL:X"
button["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
button["TextColor3"] = Color3.new(1, 1, 1)
button["TextSize"] = 20
button["BorderSizePixel"] = 0
button["Font"] = Enum.Font.RobotoMono
button["TextWrapped"] = true
button["Active"] = true
button["Draggable"] = true
button["Parent"] = screengui
button["ZIndex"] = 3

local buttonpad = Instance.new("UIPadding")
buttonpad["PaddingTop"] = UDim.new(0, -2)
buttonpad["Parent"] = button

local buttonbor = Instance.new("Frame")
buttonbor["Size"] = UDim2.new(0, 48, 0, 48)
buttonbor["Position"] = UDim2.new(0, -1, 0, 1)
buttonbor["BorderSizePixel"] = 1
buttonbor["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
buttonbor["BorderColor3"] = Color3.new(0, 0, 0)
buttonbor["Parent"] = button
buttonbor["ZIndex"] = 2

function addgradient()
	local gradient = Instance.new("UIGradient")	
	if not flytoggle then 
		gradient.Color = ColorSequence.new {
			ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(0.5, Color3.new(0, 0, 0)),
			ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
		}
	else
		gradient.Color = ColorSequence.new {
			ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
			ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
			ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
		}
	end
	gradient.Parent = buttonbor

	local rotationSpeed = 1
	task.spawn(
		function()
			while true do
				gradient.Rotation = (gradient.Rotation + rotationSpeed) % 360
				task.wait(0.03)
			end
		end
	)
end

addgradient()

local clik = Instance.new("Sound")
clik["SoundId"] = "rbxassetid://226892749"
clik["Parent"] = workspace
clik["Name"] = "canttouchthis"
clik["Volume"] = 0.4

function playclicksound()
	local newsound = clik:Clone()
	newsound["Parent"] = clik["Parent"]
	newsound:Play()
	newsound["Ended"]:Connect(function() newsound:Destroy() end)
end

-------------------------------------------------------------------------------------------------------------------------------

local toggle = false
local lockedTarget = nil
local lockedPart = nil
local maxLockDistance = 300

local function isobstructing(part)
	if not part then return false end
	if part.Transparency >= 1 then return false end
	if not part.CanCollide then return false end
	if part:IsDescendantOf(player.Character) or part:IsDescendantOf(camera) then return false end
	return true
end

local function getFirstVisiblePart(char)
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
			local rayOrigin = camera.CFrame.Position
			local rayDir = part.Position - rayOrigin
			local ignoreList = {player.Character, camera}
			local hit, _ = workspace:FindPartOnRayWithIgnoreList(Ray.new(rayOrigin, rayDir.Unit * rayDir.Magnitude), ignoreList)

			while hit and not hit:IsDescendantOf(char) and not isobstructing(hit) do
				table.insert(ignoreList, hit)
				hit, _ = workspace:FindPartOnRayWithIgnoreList(Ray.new(rayOrigin, rayDir.Unit * rayDir.Magnitude), ignoreList)
			end

			if hit and hit:IsDescendantOf(char) then
				return part
			end
		end
	end
	return nil
end

local function getClosestVisibleEnemy()
	local closestChar = nil
	local closestDist = math.huge
	local camPos = camera.CFrame.Position
	local screencenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)

	for _, p in ipairs(players:GetPlayers()) do
		if p ~= player and p.Team ~= player.Team and p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
			local char = p.Character
			local humanoid = char:FindFirstChildOfClass("Humanoid")
			if humanoid.Health <= 0 then continue end

			-- Check for head/torso visibility first
			local head = char:FindFirstChild("Head")
			local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
			local partToCheck = nil

			if head and torso then
				if getFirstVisiblePart(head.Parent) == head then
					partToCheck = head
				elseif getFirstVisiblePart(torso.Parent) == torso then
					partToCheck = torso
				else
					partToCheck = getFirstVisiblePart(char)
				end
			else
				partToCheck = getFirstVisiblePart(char)
			end

			if partToCheck then
				local screenPos, onscreen = camera:WorldToViewportPoint(partToCheck.Position)
				if onscreen then
					local distFromCenter = (Vector2.new(screenPos.X, screenPos.Y) - screencenter).Magnitude
					if distFromCenter < closestDist then
						closestDist = distFromCenter
						closestChar = char
					end
				end
			end
		end
	end

	if closestChar then
		lockedTarget = closestChar
		lockedPart = (closestChar:FindFirstChild("Head") and getFirstVisiblePart(closestChar) == closestChar.Head) and closestChar.Head
			or (closestChar:FindFirstChild("UpperTorso") and getFirstVisiblePart(closestChar) == closestChar.UpperTorso) and closestChar.UpperTorso
			or getFirstVisiblePart(closestChar)
	else
		lockedTarget = nil
		lockedPart = nil
	end
end

runservice.RenderStepped:Connect(function()
	if toggle then
		if not lockedTarget or not lockedTarget.Parent or lockedTarget:FindFirstChildOfClass("Humanoid").Health <= 0 then
			getClosestVisibleEnemy()
		end

		if lockedTarget and lockedPart then
			local camPos = camera.CFrame.Position
			if (lockedPart.Position - camPos).Magnitude > maxLockDistance then
				lockedTarget = nil
				lockedPart = nil
				return
			end

			local newLookVector = (lockedPart.Position - camPos).Unit
			local newCFrame = CFrame.new(camPos, camPos + newLookVector)

			local alpha = 0.25
			local easedAlpha = alpha < 0.5 and 2 * alpha * alpha or -1 + (4 - 2 * alpha) * alpha
			camera.CFrame = camera.CFrame:Lerp(newCFrame, easedAlpha)
		end
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

button["MouseButton1Click"]:Connect(function()
	playclicksound()
	toggle = not toggle
	button["Text"] = toggle and "CL:O" or "CL:X"
	button["BackgroundColor3"] = toggle and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 0, 0)
	buttonbor["BackgroundColor3"] = toggle and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
	buttonbor["BorderColor3"] = toggle and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 0, 0)
	button["TextColor3"] = toggle and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
end)

game["UserInputService"].InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	local key = input.KeyCode
	if key == Enum.KeyCode.R then
		playclicksound()
		toggle = not toggle
		button["Text"] = toggle and "CL:O" or "CL:X"
		button["BackgroundColor3"] = toggle and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 0, 0)
		buttonbor["BackgroundColor3"] = toggle and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
		buttonbor["BorderColor3"] = toggle and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 0, 0)
		button["TextColor3"] = toggle and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
	end
end)

-------------------------------------------------------------------------------------------------------------------------------
