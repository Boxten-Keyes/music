--[[---------------------------------------------------------------------------------------------------------------------------
  ______     __  __     __    __     ______   __  __     __  __     ______     __     ______    
 /\  ___\   /\ \_\ \   /\ "-./  \   /\  __ \ /\ \_\ \   /\ \_\ \   /\  ___\   /\ \   /\  ___\   
 \ \___  \  \ \____ \  \ \ \-./\ \  \ \  __/ \ \  __ \  \ \____ \  \ \___  \  \ \ \  \ \___  \  
  \/\_____\  \/\_____\  \ \_\ \ \_\  \ \_\    \ \_\ \_\  \/\_____\  \/\_____\  \ \_\  \/\_____\ 
   \/_____/   \/_____/   \/_/  \/_/   \/_/     \/_/\/_/   \/_____/   \/_____/   \/_/   \/_____/
                                                                                                       
   Made by Team Symphysis - qapacity's animations
   
---------------------------------------------------------------------------------------------------------------------------]]--

task.wait(0.1)

-------------------------------------------------------------------------------------------------------------------------------

function prang()
	local s = Instance.new("Sound")
	s.SoundId = "rbxassetid://8426701399"
	s.Parent = game:GetService("SoundService")
	s:Play()
	s.Ended:Connect(function() s:Destroy() end)
end

function notify(te, tt, d)
	task.spawn(function() task.spawn(prang) game:GetService("StarterGui"):SetCore("SendNotification", {Title = te, Text = tt, Duration = d}) end)
end

task.spawn(function() notify("qapacity's anims | symphysis", "made by qapacity. enjoy!", 4) end)

-------------------------------------------------------------------------------------------------------------------------------

task.spawn(function()
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local LocalPlayer = Players.LocalPlayer
	local TOOL_NAME = "crawler"
	local WALK_ANIMATION_ID = "rbxassetid://282574440"
	local WALK_SPEED_THRESHOLD = 1

	local function createCustomTool()
		if LocalPlayer:FindFirstChildOfClass("Backpack"):FindFirstChild(TOOL_NAME) then return end

		local tool = Instance.new("Tool")
		tool.Name = TOOL_NAME
		tool.RequiresHandle = false
		tool.CanBeDropped = false

		tool.Parent = LocalPlayer:WaitForChild("Backpack")
	end

	createCustomTool()

	local walkAnim = Instance.new("Animation")
	walkAnim.AnimationId = WALK_ANIMATION_ID

	local currentTrack = nil
	local animator = nil
	local equipped = false
	local humanoid = nil

	local function stopTrack()
		if currentTrack then
			currentTrack:Stop()
			currentTrack = nil
		end
	end

	local function startTrack()
		if animator and not currentTrack then
			currentTrack = animator:LoadAnimation(walkAnim)
			currentTrack.Priority = Enum.AnimationPriority.Movement
			currentTrack.Looped = true
			currentTrack:Play()
		end
	end

	local function setupTool(tool)
		if tool:IsA("Tool") and tool.Name == TOOL_NAME then
			tool.Equipped:Connect(function()
				equipped = true
			end)
			tool.Unequipped:Connect(function()
				equipped = false
				stopTrack()
			end)
		end
	end

	local function onCharacterAdded(char)
		humanoid = char:WaitForChild("Humanoid")
		local hrp = char:WaitForChild("HumanoidRootPart")

		animator = humanoid:FindFirstChildWhichIsA("Animator")
		if not animator then
			animator = Instance.new("Animator")
			animator.Parent = humanoid
		end

		for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
			setupTool(tool)
		end
		for _, item in ipairs(char:GetChildren()) do
			if item:IsA("Tool") then
				setupTool(item)
			end
		end

		LocalPlayer.Backpack.ChildAdded:Connect(setupTool)
		char.ChildAdded:Connect(setupTool)

		RunService.Heartbeat:Connect(function()
			if not equipped or not humanoid or not hrp then
				stopTrack()
				return
			end

			local velocity = hrp.Velocity
			local speed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude

			if speed > WALK_SPEED_THRESHOLD then
				startTrack()
			else
				stopTrack()
			end
		end)
	end

	if LocalPlayer.Character then
		onCharacterAdded(LocalPlayer.Character)
	end
	LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
end)

task.spawn(function()
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local TOOL_NAME = "jerk off"
	local ANIMATION_ID = "rbxassetid://72042024"
	local ANIMATION_ID2 = "rbxassetid://168268306"

	local function giveTool()
		if LocalPlayer:FindFirstChildOfClass("Backpack"):FindFirstChild(TOOL_NAME) then return end

		local tool = Instance.new("Tool")
		tool.Name = TOOL_NAME
		tool.RequiresHandle = false
		tool.CanBeDropped = false
		tool.Parent = LocalPlayer:WaitForChild("Backpack")

		return tool
	end

	local function setupTool(tool)
		local animTrack = nil
		local animTrack2 = nil
		local loopConnection = nil
		local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

		local animation = Instance.new("Animation")
		animation.AnimationId = ANIMATION_ID
		local animation2 = Instance.new("Animation")
		animation2.AnimationId = ANIMATION_ID2

		tool.Equipped:Connect(function()
			if animTrack then
				animTrack:Stop()
				animTrack = nil
			end
			if loopConnection then
				loopConnection:Disconnect()
				loopConnection = nil
			end

			animTrack = animator:LoadAnimation(animation)
			animTrack.Priority = Enum.AnimationPriority.Action
			animTrack.Looped = false
			animTrack:Play()
			animTrack.TimePosition = 0.4
			animTrack:AdjustSpeed(0.8)

			animTrack2 = animator:LoadAnimation(animation2)
			animTrack.Priority = Enum.AnimationPriority.Action
			animTrack2:Play()
			animTrack2.TimePosition = 1
			animTrack2:AdjustSpeed(0)

			loopConnection = game:GetService("RunService").Heartbeat:Connect(function()
				if animTrack and animTrack.Length > 0 and animTrack.TimePosition >= animTrack.Length then
					animTrack:Play()
					animTrack.TimePosition = 0.4
					animTrack:AdjustSpeed(0.8)
				end
			end)
		end)

		tool.Unequipped:Connect(function()
			if animTrack then
				animTrack:Stop()
				animTrack = nil
			end
			if animTrack2 then
				animTrack2:Stop()
				animTrack2 = nil
			end
			if loopConnection then
				loopConnection:Disconnect()
				loopConnection = nil
			end
		end)
	end

	local tool = giveTool()
	setupTool(tool)
end)

task.spawn(function()
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local TOOL_NAME = "austrian salute"
	local ANIMATION_ID = "rbxassetid://176236333"

	local function giveTool()
		if LocalPlayer:FindFirstChildOfClass("Backpack"):FindFirstChild(TOOL_NAME) then return end

		local tool = Instance.new("Tool")
		tool.Name = TOOL_NAME
		tool.RequiresHandle = false
		tool.CanBeDropped = false
		tool.Parent = LocalPlayer:WaitForChild("Backpack")

		return tool
	end

	local function setupTool(tool)
		local animTrack = nil
		local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

		local animation = Instance.new("Animation")
		animation.AnimationId = ANIMATION_ID

		tool.Equipped:Connect(function()
			if animTrack then animTrack:Stop() end
			animTrack = animator:LoadAnimation(animation)
			animTrack.Priority = Enum.AnimationPriority.Action
			animTrack:Play()
			task.wait(0.1)
			animTrack:AdjustSpeed(0)
		end)

		tool.Unequipped:Connect(function()
			if animTrack then
				animTrack:Stop()
				animTrack = nil
			end
		end)
	end

	local tool = giveTool()
	setupTool(tool)
end)

task.spawn(function()
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local TOOL_NAME = "dab"
	local ANIMATION_ID = "rbxassetid://248263260"

	local function giveTool()
		if LocalPlayer:FindFirstChildOfClass("Backpack"):FindFirstChild(TOOL_NAME) then return end

		local tool = Instance.new("Tool")
		tool.Name = TOOL_NAME
		tool.RequiresHandle = false
		tool.CanBeDropped = false
		tool.Parent = LocalPlayer:WaitForChild("Backpack")

		return tool
	end

	local function setupTool(tool)
		local animTrack = nil
		local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

		local animation = Instance.new("Animation")
		animation.AnimationId = ANIMATION_ID

		tool.Equipped:Connect(function()
			if animTrack then animTrack:Stop() end
			animTrack = animator:LoadAnimation(animation)
			animTrack.Priority = Enum.AnimationPriority.Action
			animTrack:Play()
		end)

		tool.Unequipped:Connect(function()
			if animTrack then
				animTrack:Stop()
				animTrack = nil
			end
		end)
	end

	local tool = giveTool()
	setupTool(tool)
end)

task.spawn(function()
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local TOOL_NAME = "arm helicopter"
	local ANIMATION_ID = "rbxassetid://259438880"

	local function giveTool()
		if LocalPlayer:FindFirstChildOfClass("Backpack"):FindFirstChild(TOOL_NAME) then return end

		local tool = Instance.new("Tool")
		tool.Name = TOOL_NAME
		tool.RequiresHandle = false
		tool.CanBeDropped = false
		tool.Parent = LocalPlayer:WaitForChild("Backpack")

		return tool
	end

	local function setupTool(tool)
		local animTrack = nil
		local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

		local animation = Instance.new("Animation")
		animation.AnimationId = ANIMATION_ID

		tool.Equipped:Connect(function()
			if animTrack then animTrack:Stop() end
			animTrack = animator:LoadAnimation(animation)
			animTrack.Priority = Enum.AnimationPriority.Action
			animTrack:Play()
			animTrack:AdjustSpeed(999)
		end)

		tool.Unequipped:Connect(function()
			if animTrack then
				animTrack:Stop()
				animTrack = nil
			end
		end)
	end

	local tool = giveTool()
	setupTool(tool)
end)

task.spawn(function()
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local TOOL_NAME = "lay down"
	local ANIMATION_ID = "rbxassetid://181526230"

	local function giveTool()
		if LocalPlayer:FindFirstChildOfClass("Backpack"):FindFirstChild(TOOL_NAME) then return end

		local tool = Instance.new("Tool")
		tool.Name = TOOL_NAME
		tool.RequiresHandle = false
		tool.CanBeDropped = false
		tool.Parent = LocalPlayer:WaitForChild("Backpack")

		return tool
	end

	local function setupTool(tool)
		local animTrack = nil
		local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

		local animation = Instance.new("Animation")
		animation.AnimationId = ANIMATION_ID

		tool.Equipped:Connect(function()
			if animTrack then animTrack:Stop() end
			animTrack = animator:LoadAnimation(animation)
			animTrack.Priority = Enum.AnimationPriority.Action
			animTrack:Play()
			animTrack:AdjustSpeed(0)
		end)

		tool.Unequipped:Connect(function()
			if animTrack then
				animTrack:Stop()
				animTrack = nil
			end
		end)
	end

	local tool = giveTool()
	setupTool(tool)
end)

task.spawn(function()
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local TOOL_NAME = "t pose"
	local ANIMATION_ID = "rbxassetid://188242481"

	local function giveTool()
		if LocalPlayer:FindFirstChildOfClass("Backpack"):FindFirstChild(TOOL_NAME) then return end

		local tool = Instance.new("Tool")
		tool.Name = TOOL_NAME
		tool.RequiresHandle = false
		tool.CanBeDropped = false
		tool.Parent = LocalPlayer:WaitForChild("Backpack")

		return tool
	end

	local function setupTool(tool)
		local animTrack = nil
		local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

		local animation = Instance.new("Animation")
		animation.AnimationId = ANIMATION_ID

		tool.Equipped:Connect(function()
			if animTrack then animTrack:Stop() end
			animTrack = animator:LoadAnimation(animation)
			animTrack.Priority = Enum.AnimationPriority.Action
			animTrack:Play()
			animTrack:AdjustSpeed(0)
		end)

		tool.Unequipped:Connect(function()
			if animTrack then
				animTrack:Stop()
				animTrack = nil
			end
		end)
	end

	local tool = giveTool()
	setupTool(tool)
end)

task.spawn(function()
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local TOOL_NAME = "hands up"
	local ANIMATION_ID = "rbxassetid://187951261"

	local function giveTool()
		if LocalPlayer:FindFirstChildOfClass("Backpack"):FindFirstChild(TOOL_NAME) then return end

		local tool = Instance.new("Tool")
		tool.Name = TOOL_NAME
		tool.RequiresHandle = false
		tool.CanBeDropped = false
		tool.Parent = LocalPlayer:WaitForChild("Backpack")

		return tool
	end

	local function setupTool(tool)
		local animTrack = nil
		local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

		local animation = Instance.new("Animation")
		animation.AnimationId = ANIMATION_ID

		tool.Equipped:Connect(function()
			if animTrack then animTrack:Stop() end
			animTrack = animator:LoadAnimation(animation)
			animTrack.Priority = Enum.AnimationPriority.Action
			animTrack:Play()
			animTrack:AdjustSpeed(0)
		end)

		tool.Unequipped:Connect(function()
			if animTrack then
				animTrack:Stop()
				animTrack = nil
			end
		end)
	end

	local tool = giveTool()
	setupTool(tool)
end)

task.spawn(function()
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local TOOL_NAME = "dance"

	local ANIMATIONS = {
		"rbxassetid://161099825",
		"rbxassetid://27789359",
		"rbxassetid://248263260",
		"rbxassetid://182435998",
		"rbxassetid://52155014",
		"rbxassetid://28488254",
		"rbxassetid://35634514",
		"rbxassetid://35654637",
		"rbxassetid://45834924",
		"rbxassetid://429703734",
		"rbxassetid://466755434",
		"rbxassetid://429730430",
		"rbxassetid://30196114",
		"rbxassetid://33796059",
		"rbxassetid://45834924",
		"rbxassetid://182491277",
		"rbxassetid://182491368",
	}

	local function giveTool()
		if LocalPlayer:FindFirstChildOfClass("Backpack"):FindFirstChild(TOOL_NAME) then return end

		local tool = Instance.new("Tool")
		tool.Name = TOOL_NAME
		tool.RequiresHandle = false
		tool.CanBeDropped = false
		tool.Parent = LocalPlayer:WaitForChild("Backpack")

		return tool
	end

	local function setupTool(tool)
		local animTrack = nil
		local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

		local function getRandomAnimation()
			local randomIndex = math.random(1, #ANIMATIONS)
			local animation = Instance.new("Animation")
			animation.AnimationId = ANIMATIONS[randomIndex]
			return animation
		end

		tool.Equipped:Connect(function()
			if animTrack then animTrack:Stop() end
			local animation = getRandomAnimation()
			animTrack = animator:LoadAnimation(animation)
			animTrack.Priority = Enum.AnimationPriority.Action
			animTrack:Play()
			animTrack.Looped = true
			animTrack:AdjustWeight(999)
		end)

		tool.Unequipped:Connect(function()
			if animTrack then
				animTrack:Stop()
				animTrack = nil
			end
		end)
	end

	local tool = giveTool()
	setupTool(tool)
end)

task.spawn(function()
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local TOOL_NAME = "the charleston"
	local ANIMATION_ID = "rbxassetid://429703734"

	local function giveTool()
		if LocalPlayer:FindFirstChildOfClass("Backpack"):FindFirstChild(TOOL_NAME) then return end

		local tool = Instance.new("Tool")
		tool.Name = TOOL_NAME
		tool.RequiresHandle = false
		tool.CanBeDropped = false
		tool.Parent = LocalPlayer:WaitForChild("Backpack")

		return tool
	end

	local function setupTool(tool)
		local animTrack = nil
		local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

		local animation = Instance.new("Animation")
		animation.AnimationId = ANIMATION_ID

		tool.Equipped:Connect(function()
			if animTrack then animTrack:Stop() end
			animTrack = animator:LoadAnimation(animation)
			animTrack.Priority = Enum.AnimationPriority.Action
			animTrack:Play()
		end)

		tool.Unequipped:Connect(function()
			if animTrack then
				animTrack:Stop()
				animTrack = nil
			end
		end)
	end

	local tool = giveTool()
	setupTool(tool)
end)

task.spawn(function()
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local TOOL_NAME = "kneel down"
	local ANIMATION_ID = "rbxassetid://287325678"

	local function giveTool()
		if LocalPlayer:FindFirstChildOfClass("Backpack"):FindFirstChild(TOOL_NAME) then return end

		local tool = Instance.new("Tool")
		tool.Name = TOOL_NAME
		tool.RequiresHandle = false
		tool.CanBeDropped = false
		tool.Parent = LocalPlayer:WaitForChild("Backpack")

		return tool
	end

	local function setupTool(tool)
		local animTrack = nil
		local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

		local animation = Instance.new("Animation")
		animation.AnimationId = ANIMATION_ID

		tool.Equipped:Connect(function()
			if animTrack then animTrack:Stop() end
			animTrack = animator:LoadAnimation(animation)
			animTrack.Priority = Enum.AnimationPriority.Action
			animTrack:Play()
			animTrack:AdjustSpeed(0)
		end)

		tool.Unequipped:Connect(function()
			if animTrack then
				animTrack:Stop()
				animTrack = nil
			end
		end)
	end

	local tool = giveTool()
	setupTool(tool)
end)

task.spawn(function()
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local TOOL_NAME = "cradle"
	local ANIMATION_ID = "rbxassetid://180612465"

	local function giveTool()
		if LocalPlayer:FindFirstChildOfClass("Backpack"):FindFirstChild(TOOL_NAME) then return end

		local tool = Instance.new("Tool")
		tool.Name = TOOL_NAME
		tool.RequiresHandle = false
		tool.CanBeDropped = false
		tool.Parent = LocalPlayer:WaitForChild("Backpack")

		return tool
	end

	local function setupTool(tool)
		local animTrack = nil
		local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

		local animation = Instance.new("Animation")
		animation.AnimationId = ANIMATION_ID

		tool.Equipped:Connect(function()
			if animTrack then animTrack:Stop() end
			animTrack = animator:LoadAnimation(animation)
			animTrack.Priority = Enum.AnimationPriority.Action
			animTrack:Play()
			animTrack.TimePosition = 0.6
			animTrack:AdjustSpeed(0)
		end)

		tool.Unequipped:Connect(function()
			if animTrack then
				animTrack:Stop()
				animTrack = nil
			end
		end)
	end

	local tool = giveTool()
	setupTool(tool)
end)

task.spawn(function()
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local TOOL_NAME = "jumping jacks"
	local ANIMATION_ID = "rbxassetid://429681631"

	local function giveTool()
		if LocalPlayer:FindFirstChildOfClass("Backpack"):FindFirstChild(TOOL_NAME) then return end

		local tool = Instance.new("Tool")
		tool.Name = TOOL_NAME
		tool.RequiresHandle = false
		tool.CanBeDropped = false
		tool.Parent = LocalPlayer:WaitForChild("Backpack")

		return tool
	end

	local function setupTool(tool)
		local animTrack = nil
		local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

		local animation = Instance.new("Animation")
		animation.AnimationId = ANIMATION_ID

		tool.Equipped:Connect(function()
			if animTrack then animTrack:Stop() end
			animTrack = animator:LoadAnimation(animation)
			animTrack.Priority = Enum.AnimationPriority.Action
			animTrack:Play()
		end)

		tool.Unequipped:Connect(function()
			if animTrack then
				animTrack:Stop()
				animTrack = nil
			end
		end)
	end

	local tool = giveTool()
	setupTool(tool)
end)

task.spawn(function()
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local TOOL_NAME = "frantic"
	local ANIMATION_ID = "rbxassetid://73137648"

	local function giveTool()
		if LocalPlayer:FindFirstChildOfClass("Backpack"):FindFirstChild(TOOL_NAME) then return end

		local tool = Instance.new("Tool")
		tool.Name = TOOL_NAME
		tool.RequiresHandle = false
		tool.CanBeDropped = false
		tool.Parent = LocalPlayer:WaitForChild("Backpack")

		return tool
	end

	local function setupTool(tool)
		local animTrack = nil
		local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

		local animation = Instance.new("Animation")
		animation.AnimationId = ANIMATION_ID

		tool.Equipped:Connect(function()
			if animTrack then animTrack:Stop() end
			animTrack = animator:LoadAnimation(animation)
			animTrack.Priority = Enum.AnimationPriority.Action
			animTrack:Play()
		end)

		tool.Unequipped:Connect(function()
			if animTrack then
				animTrack:Stop()
				animTrack = nil
			end
		end)
	end

	local tool = giveTool()
	setupTool(tool)
end)

task.spawn(function()
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local TOOL_NAME = "shocked"
	local ANIMATION_ID = "rbxassetid://94861246"

	local function giveTool()
		if LocalPlayer:FindFirstChildOfClass("Backpack"):FindFirstChild(TOOL_NAME) then return end

		local tool = Instance.new("Tool")
		tool.Name = TOOL_NAME
		tool.RequiresHandle = false
		tool.CanBeDropped = false
		tool.Parent = LocalPlayer:WaitForChild("Backpack")

		return tool
	end

	local function setupTool(tool)
		local animTrack = nil
		local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

		local animation = Instance.new("Animation")
		animation.AnimationId = ANIMATION_ID

		tool.Equipped:Connect(function()
			if animTrack then animTrack:Stop() end
			animTrack = animator:LoadAnimation(animation)
			animTrack.Priority = Enum.AnimationPriority.Action
			animTrack:Play()
			animTrack.TimePosition = 1.3
			animTrack:AdjustSpeed(0)
		end)

		tool.Unequipped:Connect(function()
			if animTrack then
				animTrack:Stop()
				animTrack = nil
			end
		end)
	end

	local tool = giveTool()
	setupTool(tool)
end)

task.spawn(function()
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local TOOL_NAME = "spin dance"
	local ANIMATION_ID = "rbxassetid://429730430"

	local function giveTool()
		if LocalPlayer:FindFirstChildOfClass("Backpack"):FindFirstChild(TOOL_NAME) then return end

		local tool = Instance.new("Tool")
		tool.Name = TOOL_NAME
		tool.RequiresHandle = false
		tool.CanBeDropped = false
		tool.Parent = LocalPlayer:WaitForChild("Backpack")

		return tool
	end

	local function setupTool(tool)
		local animTrack = nil
		local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

		local animation = Instance.new("Animation")
		animation.AnimationId = ANIMATION_ID

		tool.Equipped:Connect(function()
			if animTrack then animTrack:Stop() end
			animTrack = animator:LoadAnimation(animation)
			animTrack.Priority = Enum.AnimationPriority.Action
			animTrack:Play()
		end)

		tool.Unequipped:Connect(function()
			if animTrack then
				animTrack:Stop()
				animTrack = nil
			end
		end)
	end

	local tool = giveTool()
	setupTool(tool)
end)

task.spawn(function()
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local TOOL_NAME = "look right"
	local ANIMATION_ID = "rbxassetid://88016955"

	local function giveTool()
		if LocalPlayer:FindFirstChildOfClass("Backpack"):FindFirstChild(TOOL_NAME) then return end

		local tool = Instance.new("Tool")
		tool.Name = TOOL_NAME
		tool.RequiresHandle = false
		tool.CanBeDropped = false
		tool.Parent = LocalPlayer:WaitForChild("Backpack")

		return tool
	end

	local function setupTool(tool)
		local animTrack = nil
		local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

		local animation = Instance.new("Animation")
		animation.AnimationId = ANIMATION_ID

		tool.Equipped:Connect(function()
			if animTrack then animTrack:Stop() end
			animTrack = animator:LoadAnimation(animation)
			animTrack.Priority = Enum.AnimationPriority.Action
			animTrack:Play()
		end)

		tool.Unequipped:Connect(function()
			if animTrack then
				animTrack:Stop()
				animTrack = nil
			end
		end)
	end

	local tool = giveTool()
	setupTool(tool)
end)

task.spawn(function()
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local TOOL_NAME = "bow down"
	local ANIMATION_ID = "rbxassetid://204292303"

	local function giveTool()
		if LocalPlayer:FindFirstChildOfClass("Backpack"):FindFirstChild(TOOL_NAME) then return end

		local tool = Instance.new("Tool")
		tool.Name = TOOL_NAME
		tool.RequiresHandle = false
		tool.CanBeDropped = false
		tool.Parent = LocalPlayer:WaitForChild("Backpack")

		return tool
	end

	local function setupTool(tool)
		local animTrack = nil
		local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

		local animation = Instance.new("Animation")
		animation.AnimationId = ANIMATION_ID

		tool.Equipped:Connect(function()
			if animTrack then animTrack:Stop() end
			animTrack = animator:LoadAnimation(animation)
			animTrack.Priority = Enum.AnimationPriority.Action
			animTrack:Play()
			task.wait(0.9)
			animTrack:AdjustSpeed(0)
		end)

		tool.Unequipped:Connect(function()
			if animTrack then
				animTrack:Stop()
				animTrack = nil
			end
		end)
	end

	local tool = giveTool()
	setupTool(tool)
end)

task.spawn(function()
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local TOOL_NAME = "the thinker"
	local ANIMATION_ID = "rbxassetid://120735709"
	local ANIMATION_ID2 = "rbxassetid://120735762"
	local ANIMATION_ID3 = "rbxassetid://287325678"

	local function giveTool()
		if LocalPlayer:FindFirstChildOfClass("Backpack"):FindFirstChild(TOOL_NAME) then return end

		local tool = Instance.new("Tool")
		tool.Name = TOOL_NAME
		tool.RequiresHandle = false
		tool.CanBeDropped = false
		tool.Parent = LocalPlayer:WaitForChild("Backpack")

		return tool
	end

	local function setupTool(tool)
		local animTrack = nil
		local animTrack2 = nil
		local animTrack3 = nil
		local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

		local animation = Instance.new("Animation")
		animation.AnimationId = ANIMATION_ID

		local animation2 = Instance.new("Animation")
		animation2.AnimationId = ANIMATION_ID2

		local animation3 = Instance.new("Animation")
		animation3.AnimationId = ANIMATION_ID3

		tool.Equipped:Connect(function()
			if animTrack then animTrack:Stop() end
			if animTrack2 then animTrack2:Stop() end
			if animTrack3 then animTrack3:Stop() end
			animTrack = animator:LoadAnimation(animation)
			animTrack.Priority = Enum.AnimationPriority.Action
			animTrack:Play()
			animTrack2 = animator:LoadAnimation(animation2)
			animTrack2.Priority = Enum.AnimationPriority.Action
			animTrack2:Play()
			animTrack3 = animator:LoadAnimation(animation3)
			animTrack3.Priority = Enum.AnimationPriority.Action
			animTrack3:Play()
			animTrack3:AdjustWeight(999)
		end)

		tool.Unequipped:Connect(function()
			if animTrack then
				animTrack:Stop()
				animTrack = nil
			end
			if animTrack2 then
				animTrack2:Stop()
				animTrack2 = nil
			end
			if animTrack3 then
				animTrack3:Stop()
				animTrack3 = nil
			end
		end)
	end

	local tool = giveTool()
	setupTool(tool)
end)

task.spawn(function()
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local TOOL_NAME = "imitate sucking"
	local ANIMATION_ID = "rbxassetid://73177702"
	local ANIMATION_ID2 = "rbxassetid://183696478"

	local function giveTool()
		if LocalPlayer:FindFirstChildOfClass("Backpack"):FindFirstChild(TOOL_NAME) then return end

		local tool = Instance.new("Tool")
		tool.Name = TOOL_NAME
		tool.RequiresHandle = false
		tool.CanBeDropped = false
		tool.Parent = LocalPlayer:WaitForChild("Backpack")

		return tool
	end

	local function setupTool(tool)
		local animTrack = nil
		local animTrack2 = nil
		local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

		local animation = Instance.new("Animation")
		animation.AnimationId = ANIMATION_ID

		local animation2 = Instance.new("Animation")
		animation2.AnimationId = ANIMATION_ID2

		tool.Equipped:Connect(function()
			if animTrack then animTrack:Stop() end
			if animTrack2 then animTrack2:Stop() end
			animTrack = animator:LoadAnimation(animation)
			animTrack.Priority = Enum.AnimationPriority.Action
			animTrack:Play()
			animTrack:AdjustWeight(1)
			animTrack2 = animator:LoadAnimation(animation2)
			animTrack2.Priority = Enum.AnimationPriority.Action
			animTrack2:Play()
			animTrack2:AdjustWeight(1)
		end)

		tool.Unequipped:Connect(function()
			if animTrack then
				animTrack:Stop()
				animTrack = nil
			end
			if animTrack2 then
				animTrack2:Stop()
				animTrack2 = nil
			end
		end)
	end

	local tool = giveTool()
	setupTool(tool)
end)

task.spawn(function()
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local TOOL_NAME = "kneel suck"
	local ANIMATION_ID = "rbxassetid://73177702"
	local ANIMATION_ID2 = "rbxassetid://287325678"
	local ANIMATION_ID3 = "rbxassetid://183696478"

	local function giveTool()
		if LocalPlayer:FindFirstChildOfClass("Backpack"):FindFirstChild(TOOL_NAME) then return end

		local tool = Instance.new("Tool")
		tool.Name = TOOL_NAME
		tool.RequiresHandle = false
		tool.CanBeDropped = false
		tool.Parent = LocalPlayer:WaitForChild("Backpack")

		return tool
	end

	local function setupTool(tool)
		local animTrack1 = nil
		local animTrack2 = nil
		local animTrack3 = nil

		local function stopAll()
			if animTrack1 then animTrack1:Stop() animTrack1 = nil end
			if animTrack2 then animTrack2:Stop() animTrack2 = nil end
			if animTrack3 then animTrack3:Stop() animTrack3 = nil end
		end

		local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local humanoid = character:WaitForChild("Humanoid")
		local animator = humanoid:FindFirstChildOfClass("Animator") or Instance.new("Animator", humanoid)

		local animation1 = Instance.new("Animation")
		animation1.AnimationId = ANIMATION_ID

		local animation2 = Instance.new("Animation")
		animation2.AnimationId = ANIMATION_ID2

		local animation3 = Instance.new("Animation")
		animation3.AnimationId = ANIMATION_ID3

		tool.Equipped:Connect(function()
			stopAll()

			animTrack1 = animator:LoadAnimation(animation1)
			animTrack2 = animator:LoadAnimation(animation2)
			animTrack3 = animator:LoadAnimation(animation3)

			animTrack1.Priority = Enum.AnimationPriority.Action
			animTrack2.Priority = Enum.AnimationPriority.Action
			animTrack3.Priority = Enum.AnimationPriority.Action

			animTrack1:Play()
			animTrack2:Play()
			animTrack2:AdjustWeight(999)
			animTrack3:Play()
		end)

		tool.Unequipped:Connect(stopAll)
	end

	local tool = giveTool()
	setupTool(tool)
end)

-------------------------------------------------------------------------------------------------------------------------------
