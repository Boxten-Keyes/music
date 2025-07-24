--[[
  Licensed under the MIT License (see LICENSE file for full details).
  Copyright (c) 2025 MrY7zz

  LEGAL NOTICE:
  You are REQUIRED to retain this license header under the terms of the MIT License.
  Removing or modifying this notice may violate copyright law.
]]
--// BY MrY7zz

-- R15 Reanimation Script (MrY7zz - Fixed R15 Support)

if not game:IsLoaded() then
	game.Loaded:Wait()
end

if not sethiddenproperty then
	task.spawn(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/somethingsimade/CurrentAngleV2/refs/heads/main/fallback.lua"))()
	end)
	repeat task.wait() until finished == true
	return
end

local UI = (gethui and gethui()) or (cloneref and cloneref(game:GetService("CoreGui"))) or game:GetService("Players").LocalPlayer:FindFirstChildOfClass("PlayerGui")

local function LoadUi(seconds)
	local ScreenGui = Instance.new("ScreenGui")
	local Frame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIGradient = Instance.new("UIGradient")
	local UIStroke = Instance.new("UIStroke")
	local UIStroke_2 = Instance.new("UIStroke")
	local UIStroke_3 = Instance.new("UIStroke")
	local TextLabel = Instance.new("TextLabel")
	local TextLabel_2 = Instance.new("TextLabel")
	ScreenGui.IgnoreGuiInset = true

	ScreenGui.Parent = UI
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	Frame.Parent = ScreenGui
	Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame.Size = UDim2.new(0, 429, 0, 79)
	Frame.Position = UDim2.new(0.5, -214, 0.01, 0)
	UIStroke.Parent = Frame
	UIStroke_2.Color = Color3.fromRGB(65, 65, 65)
	UIStroke_3.Color = Color3.fromRGB(65, 65, 65)
	UICorner.Parent = Frame

	UIGradient.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(79, 173, 255)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(85, 127, 179))
	}
	UIGradient.Rotation = 40
	UIGradient.Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0.00, 0.00),
		NumberSequenceKeypoint.new(0.07, 0.13),
		NumberSequenceKeypoint.new(1.00, 0.00)
	}
	UIGradient.Parent = Frame

	TextLabel.Parent = Frame
	TextLabel.BackgroundTransparency = 1.0
	TextLabel.Position = UDim2.new(0.265, 0, 0, 0)
	TextLabel.Size = UDim2.new(0, 200, 0, 50)
	TextLabel.Font = Enum.Font.BuilderSans
	TextLabel.Text = "MrY7zz's CurrentAngle V2 REANIMATE BY MrY7zz"
	TextLabel.TextColor3 = Color3.new(1, 1, 1)
	TextLabel.TextSize = 20
	UIStroke_2.Parent = TextLabel

	TextLabel_2.Parent = Frame
	TextLabel_2.BackgroundTransparency = 1.0
	TextLabel_2.Position = UDim2.new(-0.08, 0, 0.367, 0)
	TextLabel_2.Size = UDim2.new(0, 500, 0, 50)
	TextLabel_2.Font = Enum.Font.BuilderSans
	TextLabel_2.Text = tostring(seconds) .. " Seconds left for reanimate to load"
	TextLabel_2.TextColor3 = Color3.new(1, 1, 1)
	TextLabel_2.TextSize = 28
	UIStroke_3.Parent = TextLabel_2

	task.delay(seconds + 1.5, function()
		ScreenGui:Destroy()
	end)
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Wait for character to load
if not LocalPlayer.Character then
	LocalPlayer.CharacterAdded:Wait()
end

local character = LocalPlayer.Character
local humanoid = character:WaitForChild("Humanoid")
local rigType = humanoid.RigType

if rigType ~= Enum.HumanoidRigType.R15 then
	error("This version of the script only works with R15 rigs.")
end

-- UI
LoadUi(Players.RespawnTime)

-- Cloning character to fakeChar
local originalChar = character
originalChar.Archivable = true
local fakeChar = Players:CreateHumanoidModelFromDescription(
	humanoid.HumanoidDescription,
	Enum.HumanoidRigType.R15
)
fakeChar.Name = LocalPlayer.Name .. "_Fake"
fakeChar:SetPrimaryPartCFrame(originalChar.PrimaryPart.CFrame)
fakeChar.Parent = workspace
local currentFakeChar = fakeChar

-- Respawn logic
originalChar:BreakJoints()
LocalPlayer.CharacterAdded:Wait()
task.wait(0.3)
LocalPlayer.Character = fakeChar

-- Transparency setup
for _, part in ipairs(fakeChar:GetDescendants()) do
	if part:IsA("BasePart") or part:IsA("Decal") then
		part.Transparency = 1
	end
end

-- Joint mapping for R15
local function getJoint(part, name)
	return part:FindFirstChild(name) or part:FindFirstChildWhichIsA("Motor6D")
end

local newChar = LocalPlayer.Character
local newHumanoid = newChar:WaitForChild("Humanoid")
local fakeHumanoid = fakeChar:WaitForChild("Humanoid")

local newTorso = newChar:WaitForChild("UpperTorso")
local fakeTorso = fakeChar:WaitForChild("UpperTorso")
local newRoot = newChar:WaitForChild("HumanoidRootPart")
local fakeRoot = fakeChar:WaitForChild("HumanoidRootPart")

local limbMap = {
	RootJoint = fakeRoot,
	Neck = fakeChar:WaitForChild("Head"),
	["Left Shoulder"] = fakeChar:WaitForChild("LeftUpperArm"),
	["Right Shoulder"] = fakeChar:WaitForChild("RightUpperArm"),
	["Left Hip"] = fakeChar:WaitForChild("LeftUpperLeg"),
	["Right Hip"] = fakeChar:WaitForChild("RightUpperLeg")
}

local jointMap = {
	RootJoint = getJoint(newRoot, "RootJoint"),
	Neck = getJoint(newChar:WaitForChild("Head"), "Neck"),
	["Left Shoulder"] = getJoint(newTorso, "Left Shoulder"),
	["Right Shoulder"] = getJoint(newTorso, "Right Shoulder"),
	["Left Hip"] = getJoint(newChar:WaitForChild("LeftUpperLeg"), "Left Hip"),
	["Right Hip"] = getJoint(newChar:WaitForChild("RightUpperLeg"), "Right Hip")
}

-- Setup
local flinging = false
local NaN = 0 / 0
local Vector3_new = Vector3.new

-- Step Reanimation using Motor6D.Transform
local function stepReanimate()
	if flinging then return end

	-- Reposition real character
	newRoot.CFrame = fakeRoot.CFrame + Vector3_new(0, math.random(1, 2) / 100, 0)
	newRoot.Velocity = Vector3.zero
	newRoot.RotVelocity = Vector3.zero

	for jointName, limb in pairs(limbMap) do
		local joint = jointMap[jointName]
		if joint and joint:IsA("Motor6D") and limb:IsA("BasePart") then
			local rel = fakeTorso.CFrame:ToObjectSpace(limb.CFrame)
			joint.Transform = rel
		end
	end
end

-- Disable collisions for real and fake characters
local function disableCollisions()
	pcall(function()
		for _, char in ipairs({ newChar, fakeChar }) do
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
					part.Massless = true
				end
			end
		end
	end)
end

-- Optional click fling (by MrY7zz)
local function setDestroyHeight(height)
	pcall(function()
		workspace.FallenPartsDestroyHeight = height
	end)
end

local currentDestroyHeight = workspace.FallenPartsDestroyHeight

local function flingTarget(targetCharacter, duration)
	if targetCharacter == newChar then return end
	flinging = true
	local start = tick()
	local connection

	connection = RunService.Heartbeat:Connect(function()
		if tick() - start > duration then
			setDestroyHeight(currentDestroyHeight)
			flinging = false
			connection:Disconnect()
			return
		end
		if targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
			local hrp = targetCharacter.HumanoidRootPart
			local velocity = hrp.Velocity
			local direction = velocity.Magnitude > 1 and velocity.Unit or Vector3_new(0, 0, 0)
			local predictedPos = (hrp.CFrame).Position + direction * math.random(5, 12)

			newRoot.CFrame = CFrame.new(predictedPos)
			newRoot.Velocity = Vector3_new(9e7, 9e7 * 10, 9e7)
			newRoot.RotVelocity = Vector3_new(9e8, 9e8, 9e8)
		else
			flinging = false
			connection:Disconnect()
		end
	end)
end

getgenv().fling = function(character, duration, yield)
	setDestroyHeight(NaN)
	if yield then
		flingTarget(character, duration)
	else
		task.spawn(flingTarget, character, duration)
	end
end

-- Optional click fling trigger
local clickFlingEnabled = _G["Click Fling"] or false
local mouse = LocalPlayer:GetMouse()

if clickFlingEnabled then
	mouse.Button1Down:Connect(function()
		local target = mouse.Target
		if not target then return end
		local targetChar = target:FindFirstAncestorOfClass("Model")
		if not targetChar then return end

		local targetPlayer = Players:GetPlayerFromCharacter(targetChar)
		if not targetPlayer or targetPlayer == LocalPlayer then return end

		fling(targetChar, 2.5, true)
	end)
end

-- Setup reanimation loop + camera
RunService.PostSimulation:Connect(stepReanimate)
RunService.PreSimulation:Connect(disableCollisions)

newHumanoid.PlatformStand = true
newHumanoid.AutoRotate = false

workspace.CurrentCamera.CameraSubject = fakeHumanoid

-- Auto cleanup if fake character dies
local permadeath = _G["PermaDeath fake character"] ~= false
if not permadeath then
	fakeHumanoid.Died:Once(function()
		newChar:BreakJoints()
		LocalPlayer.Character = newChar
		fakeChar:Destroy()
	end)
end

-- Finalize
finished = true

-- Optional anim loader
if _G["Use default animations"] then
	task.spawn(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/somethingsimade/CurrentAngleV2/refs/heads/main/anims"))()
	end)
end