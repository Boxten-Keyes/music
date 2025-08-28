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

local function isobstructing(part)
	if not part then return false end
	if part["Transparency"] >= 1 then return false end
	if not part["CanCollide"] then return false end
	if part:IsDescendantOf(player["Character"]) or part:IsDescendantOf(camera) then return false end
	return true
end

local function getclosestvisibleenemypart()
	local closestPart = nil
	local closestChar = nil
	local minCharDist = math.huge
	local campos = camera.CFrame.Position

	for _, p in ipairs(players:GetPlayers()) do
		if p ~= player and p.Team ~= player.Team and p.Character and not p.Character:IsDescendantOf(camera) then
			local char = p.Character
			local humanoid = char:FindFirstChildOfClass("Humanoid")

			if humanoid and humanoid.Health > 0 then
				local root = char:FindFirstChild("HumanoidRootPart")
				if root then
					local dist = (root.Position - player.Character.HumanoidRootPart.Position).Magnitude
					if dist < minCharDist then
						local visiblePart = nil
						for _, part in ipairs(char:GetChildren()) do
							if part:IsA("BasePart") then
								local screenpos, onscreen = camera:WorldToViewportPoint(part.Position)
								if onscreen then
									local rayorigin = campos
									local raydir = (part.Position - rayorigin)
									local ignorelist = {player.Character, camera}
									local hit, _ = workspace:FindPartOnRayWithIgnoreList(
										Ray.new(rayorigin, raydir.Unit * raydir.Magnitude),
										ignorelist
									)

									while hit and not hit:IsDescendantOf(char) and not isobstructing(hit) do
										table.insert(ignorelist, hit)
										hit, _ = workspace:FindPartOnRayWithIgnoreList(
											Ray.new(rayorigin, raydir.Unit * raydir.Magnitude),
											ignorelist
										)
									end

									if hit and hit:IsDescendantOf(char) then
										visiblePart = part
										break
									end
								end
							end
						end

						if visiblePart then
							minCharDist = dist
							closestChar = char
							closestPart = visiblePart
						end
					end
				end
			end
		end
	end

	return closestPart
end

runservice["RenderStepped"]:Connect(function()
	if toggle then
		local target = getclosestvisibleenemypart()
		if target then
			local campos = camera["CFrame"]["Position"]
			local newlookvector = (target["Position"] - campos)["Unit"]
			local newcf = CFrame.new(campos, campos + newlookvector)

			local alpha = 0.3
			local easedalpha
			if alpha < 0.5 then
				easedalpha = 2 * alpha * alpha
			else
				easedalpha = -1 + (4 - 2 * alpha) * alpha
			end

			camera["CFrame"] = camera["CFrame"]:Lerp(newcf, easedalpha)
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