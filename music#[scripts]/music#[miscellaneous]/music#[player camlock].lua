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
button["Size"] = UDim2.new(0, 48, 0, 48)
repos(button, 48, 48)
button["Text"] = "CL:X"
button["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
button["BorderColor3"] = Color3.new(1, 1, 1)
button["TextColor3"] = Color3.new(1, 1, 1)
button["TextSize"] = 20
button["Font"] = Enum.Font.RobotoMono
button["TextWrapped"] = true
button["Active"] = true
button["Draggable"] = true
button["Parent"] = screengui

local buttonpad = Instance.new("UIPadding")
buttonpad["PaddingTop"] = UDim.new(0, -2)
buttonpad["Parent"] = button

local clik = Instance.new("Sound")
clik["SoundId"] = "rbxassetid://226892749"
clik["Parent"] = game["Workspace"]
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
	local closest = nil
	local mindist = math.huge
	local screencenter = Vector2.new(camera["ViewportSize"]["X"] / 2, camera["ViewportSize"]["Y"] / 2)

	for _, p in ipairs(players:GetPlayers()) do
		if p ~= player and p["Team"] ~= player["Team"] and p["Character"] and not p["Character"]:IsDescendantOf(camera) then
			local char = p["Character"]
			local head = char:FindFirstChild("Head")
			local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
			local humanoid = char:FindFirstChildOfClass("Humanoid")

			if head and torso and humanoid and humanoid["Health"] > 0 then
				local targetpart = math.random() < 0.3 and head or torso
				local camlook = camera["CFrame"]["LookVector"]
				local totarget = (targetpart["Position"] - camera["CFrame"]["Position"])["Unit"]

				if camlook:Dot(totarget) > 0.5 then
					local screenpos, onscreen = camera:WorldToViewportPoint(targetpart["Position"])
					if onscreen then
						local screenpoint = Vector2.new(screenpos["X"], screenpos["Y"])
						local distfromcenter = (screenpoint - screencenter)["Magnitude"]

						if distfromcenter <= 200 then
							local rayorigin = camera["CFrame"]["Position"]
							local raydir = (targetpart["Position"] - rayorigin)
							local ignorelist = {player["Character"], camera}
							local hit, _ = workspace:FindPartOnRayWithIgnoreList(Ray.new(rayorigin, raydir["Unit"] * raydir["Magnitude"]), ignorelist)

							while hit and not hit:IsDescendantOf(char) and not isobstructing(hit) do
								table.insert(ignorelist, hit)
								hit, _ = workspace:FindPartOnRayWithIgnoreList(Ray.new(rayorigin, raydir["Unit"] * raydir["Magnitude"]), ignorelist)
							end

							if hit and hit:IsDescendantOf(char) then
								if distfromcenter < mindist then
									mindist = distfromcenter
									closest = targetpart
								end
							end
						end
					end
				end
			end
		end
	end

	return closest
end

runservice["RenderStepped"]:Connect(function()
	if toggle then
		local target = getclosestvisibleenemypart()
		if target then
			local campos = camera["CFrame"]["Position"]
			local newlookvector = (target["Position"] - campos)["Unit"]
			local newcf = CFrame.new(campos, campos + newlookvector)

			local alpha = 0.2
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
	button["BorderColor3"] = toggle and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
	button["TextColor3"] = toggle and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
end)

-------------------------------------------------------------------------------------------------------------------------------
