-------------------------------------------------------------------------------------------------------------------------------

-- made by anthony / AnthonyIsntHere
if not game:IsLoaded() then game["Loaded"]:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

local players = game:GetService("Players")
local localplayer = players["LocalPlayer"]
local character, humanoid, rootpart
local camera = workspace["CurrentCamera"]

-------------------------------------------------------------------------------------------------------------------------------

local function getnearestplayers()
	if rootpart then
		for _, x in next, players:GetPlayers() do
			if x ~= localplayer then
				local x_character = x["Character"]
				local x_humanoid = x_character and x_character:FindFirstChildWhichIsA("Humanoid")
				local x_rootpart = x_humanoid and x_humanoid["RootPart"]
				if x_rootpart and (rootpart["Position"] - x_rootpart["Position"])["Magnitude"] < 2 then
					for _, animtrack in next, x_humanoid:GetPlayingAnimationTracks() do
						if animtrack["Animation"] and 
							(animtrack["Animation"]["AnimationId"]:match("148840371") or 
								animtrack["Animation"]["AnimationId"]:match("5918726674")) then
							return true
						end
					end
					return false
				end
			end
		end
	end
	return false
end

-------------------------------------------------------------------------------------------------------------------------------

workspace["FallenPartsDestroyHeight"] = 0 / 0

-------------------------------------------------------------------------------------------------------------------------------

local isvoiding = false

while true do
	character = localplayer["Character"]
	humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
	rootpart = humanoid and humanoid["RootPart"]

	if getnearestplayers() and humanoid and rootpart and not isvoiding then
		isvoiding = true
		local currentposition = rootpart["Velocity"]["Magnitude"] < 50 and rootpart["CFrame"] or camera["Focus"]
		local timer = tick()

		repeat
			rootpart["CFrame"] = CFrame.new(0, -499, 0) * CFrame.Angles(math.rad(90), 0, 0)
			rootpart["AssemblyLinearVelocity"] = Vector3.new()
			task.wait()
		until tick() > timer + 1

		rootpart["AssemblyLinearVelocity"] = Vector3.new()
		rootpart["CFrame"] = currentposition
		humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		isvoiding = false
	end
	task.wait()
end

-------------------------------------------------------------------------------------------------------------------------------
