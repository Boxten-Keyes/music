-------------------------------------------------------------------------------------------------------------------------------

if not game:IsLoaded() then game["Loaded"]:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

local players = game:GetService("Players")
local localplayer = players["LocalPlayer"]
local premiumbadge = " "
local verifiedbadge = ""
local friendsbadge = "rbxassetid://18207951972"

-------------------------------------------------------------------------------------------------------------------------------

local function nametags(player)
	local function oncharacteradded(character)
		local humanoidrootpart = character:WaitForChild("HumanoidRootPart", 0.5)
		local head = character:WaitForChild("Head", 0.5)

		local nametag = Instance.new("BillboardGui")
		nametag["Size"] = UDim2.new(3, 0, 3, 0)
		nametag["StudsOffsetWorldSpace"] = Vector3.new(0, 1.05358, 0)
		nametag["ExtentsOffsetWorldSpace"] = Vector3.new(0, 1.4537, 0)
		nametag["ResetOnSpawn"] = true
		nametag["MaxDistance"] = 50
		nametag["Adornee"] = head
		nametag["Parent"] = head

		local frame = Instance.new("Frame")
		frame["Size"] = UDim2.new(1, 0, 1, 0)
		frame["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		frame["BackgroundTransparency"] = 1
		frame["Parent"] = nametag

		local username = Instance.new("TextLabel")
		username["Size"] = UDim2.new(1, 0, 0.14, 0)
		username["Text"] = "(@" .. player["Name"] .. ")"
		-- username["Text"] = "(@gayestboxten)"
		username["AnchorPoint"] = Vector2.new(0.5, 0.5)
		username["Position"] = UDim2.new(0.5, 0, 0.15, 0)
		username["Font"] = Enum.Font.FredokaOne
		username["TextSize"] = 20
		username["TextScaled"] = true
		username["BackgroundTransparency"] = 1
		username["TextColor3"] = Color3.fromRGB(114, 117, 130)
		username["TextStrokeTransparency"] = 0
		username["TextStrokeColor3"] = Color3.new(0, 0, 0)
		username["Parent"] = frame

		local displayname = Instance.new("TextLabel")
		displayname["Size"] = UDim2.new(2, 0, 0.24, 0)
		displayname["BackgroundTransparency"] = 1
		displayname["Text"] = player["DisplayName"]
		-- displayname["Text"] = "GayestBoxten"
		displayname["AnchorPoint"] = Vector2.new(0.5, 0.5)
		displayname["Position"] = UDim2.new(0.5, 0, 0.35, 0)
		displayname["TextSize"] = 27
		displayname["TextColor3"] = Color3.fromRGB(255, 255, 255)
		displayname["TextStrokeTransparency"] = 0
		displayname["TextStrokeColor3"] = Color3.new(0, 0, 0)
		displayname["Font"] = Enum.Font.FredokaOne
		displayname["TextScaled"] = true
		displayname["Parent"] = frame

		if player["MembershipType"] == Enum.MembershipType.Premium then
			displayname["Text"] = premiumbadge .. player["DisplayName"]
		end

		if player["HasVerifiedBadge"] then
			displayname["Text"] = player["DisplayName"] .. verifiedbadge
		end

		if player["MembershipType"] == Enum.MembershipType.Premium and player["HasVerifiedBadge"] then
			displayname["Text"] = premiumbadge .. player["DisplayName"] .. verifiedbadge
		end

		local line = Instance.new("Frame")
		line["Size"] = UDim2.new(1.3, 0, 0.025, 0)
		line["AnchorPoint"] = Vector2.new(0.5, 0.5)
		line["Position"] = UDim2.new(0.5, 0, 0.5, 0)
		line["BackgroundColor3"] = Color3.fromRGB(255, 255, 255)
		line["Parent"] = nametag
		line["Name"] = "Line"

		local corner = Instance.new("UICorner")
		corner["CornerRadius"] = UDim.new(1, 0)
		corner["Parent"] = line
	end

	player["CharacterAdded"]:Connect(oncharacteradded)

	if player["Character"] then
		oncharacteradded(player["Character"])
	end
end

local function hiderobloxnametags()
	for _, player in ipairs(players:GetPlayers()) do
		if player["Character"] then
			local humanoid = player["Character"]:FindFirstChildOfClass("Humanoid")
			if humanoid then
				humanoid["DisplayDistanceType"] = Enum.HumanoidDisplayDistanceType.None
			end
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------

local currentplayers = players:GetPlayers()
for i = 1, #currentplayers do
	local player = currentplayers[i]
	nametags(player)
	hiderobloxnametags()
end

players["PlayerAdded"]:Connect(function()
	task.wait(0.5)
	hiderobloxnametags()
	nametags()
end)

-------------------------------------------------------------------------------------------------------------------------------
