local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "StrollerAbuseGui"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 250, 0, 150)  -- Increased height to fit new button
frame.Position = UDim2.new(0, 20, 0.4, 0)
frame.BackgroundTransparency = 0.1
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.Draggable = true
frame.Active = true

local usernameBox = Instance.new("TextBox", frame)
usernameBox.Size = UDim2.new(1, -20, 0, 30)
usernameBox.Position = UDim2.new(0, 10, 0, 10)
usernameBox.PlaceholderText = "Enter target username..."
usernameBox.Text = ""
usernameBox.ClearTextOnFocus = true
usernameBox.TextColor3 = Color3.new(1,1,1)
usernameBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
usernameBox.Font = Enum.Font.SourceSans
usernameBox.TextSize = 16

local activateButton = Instance.new("TextButton", frame)
activateButton.Size = UDim2.new(1, -20, 0, 30)
activateButton.Position = UDim2.new(0, 10, 0, 50)
activateButton.Text = "Stroller Yeet"
activateButton.TextColor3 = Color3.new(1,1,1)
activateButton.BackgroundColor3 = Color3.fromRGB(90, 0, 0)
activateButton.Font = Enum.Font.SourceSansBold
activateButton.TextSize = 16

local bringButton = Instance.new("TextButton", frame)
bringButton.Size = UDim2.new(1, -20, 0, 30)
bringButton.Position = UDim2.new(0, 10, 0, 90)
bringButton.Text = "Bring Player"
bringButton.TextColor3 = Color3.new(1,1,1)
bringButton.BackgroundColor3 = Color3.fromRGB(0, 90, 0)
bringButton.Font = Enum.Font.SourceSansBold
bringButton.TextSize = 16

local function getTargetPlayer(partial)
	partial = partial:lower()

	if partial == "random" then
		local candidates = {}
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				table.insert(candidates, player)
			end
		end
		if #candidates > 0 then
			return candidates[math.random(1, #candidates)]
		else
			return nil
		end
	end

	if partial == "all" or partial == "others" then
		return partial
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.DisplayName:lower():find(partial) then
			return player
		end
	end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Name:lower():find(partial) then
			return player
		end
	end

	return nil
end

local strollerkilling = false
local strollerbringing = false

local function yeetPlayer(target)
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	if strollerkilling then return end
	strollerkilling = true

	local stroller = LocalPlayer.Backpack:FindFirstChild("Stroller") or char:FindFirstChild("Stroller")
	if not stroller then
		warn("Stroller not found in backpack or character.")
		strollerkilling = false
		return
	end

	local targetChar = target.Character
	if not targetChar then 
		strollerkilling = false
		return 
	end

	local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
	if not targetHRP then 
		strollerkilling = false
		return 
	end

	local oldcframe = hrp.CFrame

	targetHRP.CFrame = hrp.CFrame * CFrame.new(0, 0, -5)
	task.wait(0.1)

	stroller.Parent = char
	task.wait(0.1)

	Workspace.FallenPartsDestroyHeight = 0 / 0
	hrp.CFrame = CFrame.new(0, -3000, 0)
	task.wait(0.2)

	stroller.Parent = LocalPlayer.Backpack
	task.wait(0.2)

	hrp.CFrame = oldcframe
	task.wait(0.1)

	hrp.CFrame = oldcframe
	strollerkilling = false
end

local function bringPlayer(target)
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	if strollerbringing then return end
	strollerbringing = true

	local stroller = LocalPlayer.Backpack:FindFirstChild("Stroller") or char:FindFirstChild("Stroller")
	if not stroller then
		warn("Stroller not found in backpack or character.")
		strollerbringing = false
		return
	end

	local targetChar = target.Character
	if not targetChar then 
		strollerbringing = false
		return 
	end

	local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
	if not targetHRP then 
		strollerbringing = false
		return 
	end

	local oldcframe = hrp.CFrame

	targetHRP.CFrame = hrp.CFrame * CFrame.new(0, 0, -5)
	task.wait(0.1)

	stroller.Parent = char
	task.wait(0.1)

	-- No void teleport here, just bring them close

	stroller.Parent = LocalPlayer.Backpack
	task.wait(0.1)

	hrp.CFrame = oldcframe
	task.wait(0.1)

	hrp.CFrame = oldcframe
	strollerbringing = false
end

activateButton.MouseButton1Click:Connect(function()
	local input = usernameBox.Text
	local target = getTargetPlayer(input)

	if not target then
		warn("No matching player found.")
		return
	end

	if target == "all" or target == "others" then
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				local char = player.Character
				if char and not (char:FindFirstChild("Stroller")) then
					yeetPlayer(player)
					task.wait(0.5)
				end
			end
		end
	else
		yeetPlayer(target)
	end
end)

bringButton.MouseButton1Click:Connect(function()
	local input = usernameBox.Text
	local target = getTargetPlayer(input)

	if not target then
		warn("No matching player found.")
		return
	end

	if target == "all" or target == "others" then
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				local char = player.Character
				if char and not (char:FindFirstChild("Stroller")) then
					bringPlayer(player)
					task.wait(0.5)
				end
			end
		end
	else
		bringPlayer(target)
	end
end)