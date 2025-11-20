-------------------------------------------------------------------------------------------------------------------------------

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
-------------------------------------------------------------------------------------------------------------------------------

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = gethui and gethui() or game:GetService("CoreGui")
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 150)
frame.Position = UDim2.new(0, 50, 0, 350)
frame.BackgroundTransparency = 1
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local function makeKey(name, xOffset, yOffset, width, height)
	local btnFrame = Instance.new("Frame")
	btnFrame.Size = UDim2.new(0, width, 0, height)
	btnFrame.Position = UDim2.new(0, xOffset, 0, yOffset)
	btnFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	btnFrame.BackgroundTransparency = 0.65
	btnFrame.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Name = "a"
	stroke.Thickness = 1
	stroke.Color = Color3.new(1, 1, 1)
	stroke.Parent = btnFrame
	stroke.LineJoinMode = Enum.LineJoinMode.Miter

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.Name = "b"
	textLabel.Position = UDim2.new(0, 0, 0, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = name
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.Font = Enum.Font.SourceSans
	textLabel.TextSize = 17
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.TextYAlignment = Enum.TextYAlignment.Top
	textLabel.Parent = btnFrame

	local padding = Instance.new("UIPadding")
	padding.Parent = textLabel
	padding.PaddingLeft = UDim.new(0, 6)
	padding.PaddingTop = UDim.new(0, 4)

	return btnFrame, textLabel
end

-------------------------------------------------------------------------------------------------------------------------------

local W, WLabel = makeKey("W", 60, 0, 50, 50)
local A, ALabel = makeKey("A", 0, 60, 50, 50)
local S, SLabel = makeKey("S", 60, 60, 50, 50)
local D, DLabel = makeKey("D", 120, 60, 50, 50)

local Shift, ShiftLabel = makeKey("SHIFT", 120, 0, 113, 50)
local Space, SpaceLabel = makeKey("SPACE", 0, 120, 170, 50)

local LClick, LClickLabel = makeKey("L\nC", 180, 60, 21, 110)
local RClick, RClickLabel = makeKey("R\nC", 212, 60, 21, 110)

-------------------------------------------------------------------------------------------------------------------------------

local keys = {
	W = W, A = A, S = S, D = D,
	LeftShift = Shift, RightShift = Shift,
	Space = Space,
	MouseButton1 = LClick,
	MouseButton2 = RClick
}

-------------------------------------------------------------------------------------------------------------------------------

local pressedColor = Color3.fromRGB(0, 255, 0)
local normalColor = Color3.fromRGB(0, 0, 0)

local function pressKey(key)
	key.BackgroundColor3 = pressedColor
	key.a.Color = normalColor
	key.b.TextColor3 = normalColor
end

local function releaseKey(key)
	key.BackgroundColor3 = normalColor
	key.a.Color = Color3.new(1, 1, 1)
	key.b.TextColor3 = Color3.new(1, 1, 1)
end

-------------------------------------------------------------------------------------------------------------------------------

UserInputService.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		local key = keys[input.KeyCode.Name]
		if key then
			pressKey(key)
		end
	elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
		pressKey(keys.MouseButton1)
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
		pressKey(keys.MouseButton2)
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		local key = keys[input.KeyCode.Name]
		if key then
			releaseKey(key)
		end
	elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
		releaseKey(keys.MouseButton1)
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
		releaseKey(keys.MouseButton2)
	end
end)

-------------------------------------------------------------------------------------------------------------------------------
