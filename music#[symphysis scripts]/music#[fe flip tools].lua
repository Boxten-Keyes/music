--[[---------------------------------------------------------------------------------------------------------------------------
  ______     __  __     __    __     ______   __  __     __  __     ______     __     ______    
 /\  ___\   /\ \_\ \   /\ "-./  \   /\  __ \ /\ \_\ \   /\ \_\ \   /\  ___\   /\ \   /\  ___\   
 \ \___  \  \ \____ \  \ \ \-./\ \  \ \  __/ \ \  __ \  \ \____ \  \ \___  \  \ \ \  \ \___  \  
  \/\_____\  \/\_____\  \ \_\ \ \_\  \ \_\    \ \_\ \_\  \/\_____\  \/\_____\  \ \_\  \/\_____\ 
   \/_____/   \/_____/   \/_/  \/_/   \/_/     \/_/\/_/   \/_____/   \/_____/   \/_/   \/_____/
                                                                                                       
   Made by Team Symphysis - FE Flip Tools
   
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

task.spawn(function() notify("fe flip tools | symphysis", "made by incognito. enjoy!", 4) end)

-------------------------------------------------------------------------------------------------------------------------------

local player = game.Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

local function performfrontflip(character)
	local humanoid = character:WaitForChild("Humanoid")
	local rootPart = character:WaitForChild("HumanoidRootPart")

	humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	humanoid.Sit = true

	local lookVector = rootPart.CFrame.LookVector
	local spinDirection = Vector3.new(-lookVector.Z, 0, lookVector.X)

	local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
	if torso then
		local bodyVelocity = Instance.new("BodyAngularVelocity", torso)
		bodyVelocity.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		bodyVelocity.AngularVelocity = spinDirection * -10
		bodyVelocity.P = 1000

		wait(0.4)
		bodyVelocity:Destroy()
	end

	wait(0.2)
	humanoid.Sit = false
end

local function performbackflip(character)
	local humanoid = character:WaitForChild("Humanoid")
	local rootPart = character:WaitForChild("HumanoidRootPart")

	humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	humanoid.Sit = true

	local lookVector = rootPart.CFrame.LookVector
	local spinDirection = Vector3.new(-lookVector.Z, 0, lookVector.X)

	local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
	if torso then
		local bodyVelocity = Instance.new("BodyAngularVelocity", torso)
		bodyVelocity.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		bodyVelocity.AngularVelocity = spinDirection * 10
		bodyVelocity.P = 1000

		wait(0.4)
		bodyVelocity:Destroy()
	end

	wait(0.2)
	humanoid.Sit = false
end

-------------------------------------------------------------------------------------------------------------------------------

local function onToolActivated(tool)
	local character = player.Character
	if character then
		if tool.Name == "frontflip" then
			performfrontflip(character)
		elseif tool.Name == "backflip" then
			performbackflip(character)
		end
	end
end

local function connectToolEvents(tool)
	if tool:IsA("Tool") then
		tool.RequiresHandle = false
		tool.Activated:Connect(function()
			onToolActivated(tool)
		end)
	end
end

local function giveTools()
	local backpack = player:FindFirstChild("Backpack")
	if not backpack then return end

	if not backpack:FindFirstChild("FrontFlipTool") then
		local frontFlipTool = Instance.new("Tool")
		frontFlipTool.Name = "frontflip"
		frontFlipTool.RequiresHandle = false
		frontFlipTool.Parent = backpack
		connectToolEvents(frontFlipTool)
	end

	if not backpack:FindFirstChild("BackFlipTool") then
		local backFlipTool = Instance.new("Tool")
		backFlipTool.Name = "backflip"
		backFlipTool.RequiresHandle = false
		backFlipTool.Parent = backpack
		connectToolEvents(backFlipTool)
	end
end

local function initializeCharacter(character)
	character:WaitForChild("Humanoid")
	character:WaitForChild("HumanoidRootPart")

	giveTools()

	local backpack = player:WaitForChild("Backpack")
	for _, tool in pairs(backpack:GetChildren()) do
		connectToolEvents(tool)
	end

	backpack.ChildAdded:Connect(function(tool)
		connectToolEvents(tool)
	end)
end

player.CharacterAdded:Connect(function(character)
	initializeCharacter(character)
end)

if player.Character then
	initializeCharacter(player.Character)
end

-------------------------------------------------------------------------------------------------------------------------------

game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)

-------------------------------------------------------------------------------------------------------------------------------
