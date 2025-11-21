-------------------------------------------------------------------------------------------------------------------------------

local rs = game:GetService("RunService")
local lp = game:GetService("Players").LocalPlayer

-------------------------------------------------------------------------------------------------------------------------------

local TOOL_NAME = "drift"
local ANIMATION_ID = "rbxassetid://17360699557"

task.wait(1)

local function giveTool()
	local backpack = lp:WaitForChild("Backpack")
	if backpack:FindFirstChild(TOOL_NAME) then return nil end

	local tool = Instance.new("Tool")
	tool.Name = TOOL_NAME
	tool.RequiresHandle = false
	tool.CanBeDropped = false
	tool.Parent = backpack

	return tool
end

local function setup(tool)
	if not tool then return end

	local character = lp.Character or lp.CharacterAdded:Wait()
	local humanoid = character:WaitForChild("Humanoid")
	local hrp = character:WaitForChild("HumanoidRootPart")
	local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

	local animation = Instance.new("Animation")
	animation.AnimationId = ANIMATION_ID

	local animTrack = animator:LoadAnimation(animation)
	animTrack.Priority = Enum.AnimationPriority.Action
	animTrack.Looped = false

	local active = false
	local originalProperties = {}
	local newPartConnection = nil
	local speedcon = nil
	local animationLoopTask = nil

	local function makePartSlippery(part)
		if part:IsA("BasePart") and not part:IsDescendantOf(character) and not originalProperties[part] then
			local props = part.CustomPhysicalProperties
			if props then
				originalProperties[part] = PhysicalProperties.new(
					props.Density,
					props.Friction,
					props.Elasticity,
					props.FrictionWeight,
					props.ElasticityWeight
				)
			else
				originalProperties[part] = PhysicalProperties.new(0.7, 0.3, 0.5)
			end

			part.CustomPhysicalProperties = PhysicalProperties.new(1, 0, 1, 10, 1)
		end
	end

	local function makeAllSlippery()
		for _, part in ipairs(game.Workspace:GetDescendants()) do
			makePartSlippery(part)
		end
	end

	local function restoreParts()
		for part, props in pairs(originalProperties) do
			if part and part:IsA("BasePart") and part.Parent then
				part.CustomPhysicalProperties = props
			end
		end

		table.clear(originalProperties)
	end

	local function playAnimationAtTime(time)
		if not animTrack.IsPlaying then
			animTrack:Play()
		end
		animTrack.TimePosition = time or 0
	end

	tool.Equipped:Connect(function()
		if active then return end
		active = true

		humanoid.WalkSpeed = 8

		playAnimationAtTime(0)
		
		for _, child in pairs(character:GetDescendants()) do
			if child.ClassName == "Part" then
				child.CustomPhysicalProperties = PhysicalProperties.new(3.8, 0.3, 0.5)
			end
		end

		task.wait(1)

		if not speedcon then
			humanoid.WalkSpeed = 75
			speedcon = humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
				if active and humanoid.WalkSpeed ~= 75 then
					humanoid.WalkSpeed = 75
				end
			end)
		end

		task.delay(1, function()
			if not active then return end

			if animationLoopTask then
				animationLoopTask:Disconnect()
				animationLoopTask = nil
			end

			local loopBind = rs.Heartbeat:Connect(function()
				if not active then return end
				if animTrack.TimePosition >= 6.2 then -- 2.5 + 7.8
					animTrack.TimePosition = 3
				end
			end)

			animationLoopTask = loopBind
		end)

		makeAllSlippery()

		newPartConnection = game.Workspace.DescendantAdded:Connect(makePartSlippery)
	end)

	tool.Unequipped:Connect(function()
		if not active then return end
		active = false
		humanoid.WalkSpeed = 16

		if animTrack and animTrack.IsPlaying then
			animTrack:Stop()
		end

		if animationLoopTask then
			animationLoopTask:Disconnect()
			animationLoopTask = nil
		end

		if newPartConnection then
			newPartConnection:Disconnect()
			newPartConnection = nil
		end

		if speedcon then
			speedcon:Disconnect()
			speedcon = nil
		end

		task.wait(1)
		restoreParts()
	end)
end

-------------------------------------------------------------------------------------------------------------------------------

local tool = giveTool()
setup(tool)

lp.CharacterAdded:Connect(function()
	task.wait(0.5)
	local tool = giveTool()
	setup(tool)
end)

-------------------------------------------------------------------------------------------------------------------------------
