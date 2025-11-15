-------------------------------------------------------------------------------------------------------------------------------

if not game:IsLoaded() then game["Loaded"]:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

local players = game:GetService("Players")
local runservice = game:GetService("RunService")
local localplayer = players["LocalPlayer"]

local tracked = {}

-------------------------------------------------------------------------------------------------------------------------------

local function isplr(part)
	for _, plr in ipairs(players:GetPlayers()) do
		if plr["Character"] and part:IsDescendantOf(plr["Character"]) then
			return true
		end
	end
	return false
end

-------------------------------------------------------------------------------------------------------------------------------

local function fetchmoving()
	local moving_parts = {}
	for _, part in ipairs(workspace:GetDescendants()) do
		if part:IsA("BasePart")
			and not isplr(part)
			and not part:IsDescendantOf(workspace["Terrain"]) then

			local speed = part["AssemblyLinearVelocity"]["Magnitude"]
			if speed > 0.05 then
				table.insert(moving_parts, part)
			end
		end
	end
	return moving_parts
end

-------------------------------------------------------------------------------------------------------------------------------

local function disablecollisions()
	for _, part in ipairs(fetchmoving()) do
		if not tracked[part] then
			tracked[part] = {
				can_collide = part["CanCollide"],
				can_touch = part["CanTouch"],
				can_query = part["CanQuery"]
			}
			part["CanCollide"] = false
			part["CanTouch"] = false
			part["CanQuery"] = false
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------

local function restorecollisions()
	for part, original_state in pairs(tracked) do
		if part and part:IsDescendantOf(workspace) then
			local velocity = part["AssemblyLinearVelocity"]["Magnitude"]
			if velocity < 0.05 then
				part["CanCollide"] = original_state["can_collide"]
				part["CanTouch"] = original_state["can_touch"]
				part["CanQuery"] = original_state["can_query"]
				tracked[part] = nil
			end
		else
			tracked[part] = nil
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------

while true do
	task.wait()
	disablecollisions()
end

-------------------------------------------------------------------------------------------------------------------------------
