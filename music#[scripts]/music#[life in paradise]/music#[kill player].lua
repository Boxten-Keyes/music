local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

-- Create GUI
local screenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
screenGui.Name = "StrollerAbuseGui"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 250, 0, 120)
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
usernameBox.ClearTextOnFocus = false
usernameBox.TextColor3 = Color3.new(1,1,1)
usernameBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
usernameBox.Font = Enum.Font.SourceSans
usernameBox.TextSize = 16
usernameBox.ClearTextOnFocus = true

local activateButton = Instance.new("TextButton", frame)
activateButton.Size = UDim2.new(1, -20, 0, 30)
activateButton.Position = UDim2.new(0, 10, 0, 50)
activateButton.Text = "Stroller Yeet"
activateButton.TextColor3 = Color3.new(1,1,1)
activateButton.BackgroundColor3 = Color3.fromRGB(90, 0, 0)
activateButton.Font = Enum.Font.SourceSansBold
activateButton.TextSize = 16

local function getTargetPlayer(partial)
	partial = partial:lower()

	-- First, try to match by DisplayName
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.DisplayName:lower():find(partial) then
			return player
		end
	end

	-- If no display name matched, fall back to username
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Name:lower():find(partial) then
			return player
		end
	end

	return nil
end

local strollerkilling = false

-- Core action logic
local function yeetPlayer(target)
	local char = LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
 if strollerkilling then return end
 strollerkilling = true

	local stroller = LocalPlayer.Backpack:FindFirstChild("Stroller") or char:FindFirstChild("Stroller")
	if not stroller then
		warn("Stroller not found in backpack or character.")
		return
	end

	local targetChar = target.Character
	if not targetChar then return end

	local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
	if not targetHRP then return end

 oldcframe = hrp.CFrame

	-- Bring target in front of you
	targetHRP.CFrame = hrp.CFrame * CFrame.new(0, 0, -5)
	task.wait(0.1)

	-- Equip stroller
	stroller.Parent = char
	task.wait(0.1)

	-- Bring player to void
	Workspace.FallenPartsDestroyHeight = 0 / 0
	hrp.CFrame = CFrame.new(0, -3000, 0)
	task.wait(0.4)

	-- Unequip
	stroller.Parent = LocalPlayer.Backpack

	-- Return
	hrp.CFrame = oldcframe
	task.wait(0.1)

	hrp.CFrame = oldcframe
 strollerkilling = false
end

-- Button click connection
activateButton.MouseButton1Click:Connect(function()
	local input = usernameBox.Text
	local target = getTargetPlayer(input)
	if not target then
		warn("No matching player found.")
		return
	end

	-- Perform the stroller yeet repeatedly (optional loop)
	for i = 1, 1 do
		yeetPlayer(target)
		task.wait(0.5)
	end
end)