-------------------------------------------------------------------------------------------------------------------------------

if not game:IsLoaded() then game["Loaded"]:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

local players = game:GetService("Players")
local localplayer = players["LocalPlayer"]
local marketplaceservice = game:GetService("MarketplaceService")
local httpservice = game:GetService("HttpService")

-------------------------------------------------------------------------------------------------------------------------------

local function clik()
	local s = Instance.new("Sound") 
	s["SoundId"] = "rbxassetid://87152549167464"
	s["Parent"] = game["Workspace"]
	s["Volume"] = 1.2
	s["TimePosition"] = 0.1
	s:Play()
end

-------------------------------------------------------------------------------------------------------------------------------

local dw = {
	[16116270224] = true,
	[16552821455] = true,
	[18984416148] = true
}

local indw = dw[game["GameId"]] or false

-------------------------------------------------------------------------------------------------------------------------------

local gui = Instance.new("ScreenGui")
gui["Name"] = "AnimationLogger"
gui["Parent"] = localplayer:WaitForChild("PlayerGui")
gui["ResetOnSpawn"] = false

local function repos(ui, w, h)
	local sw, sh = workspace["CurrentCamera"]["ViewportSize"]["X"], workspace["CurrentCamera"]["ViewportSize"]["Y"]
	local cx, cy = (sw - w) / 2, (sh - h) / 2 - 56
	ui["Position"] = UDim2.new(0, cx, 0, cy)
end

local frame = Instance.new("Frame")
frame["Size"] = UDim2.new(0, 400, 0, 250)
frame["Position"] = UDim2.new(0.35, 0, 0.3, 0)
repos(frame, 400, 250)
frame["BackgroundColor3"] = Color3.fromRGB(30, 30, 30)
frame["BorderSizePixel"] = 0
frame["Parent"] = gui

task.spawn(function()
	local dragtoggle
	local dragspeed = 0.25
	local dragstart
	local startpos

	local function updatebuttoninput(input)
		local delta = input["Position"] - dragstart
		local position = UDim2.new(startpos["X"]["Scale"], startpos["X"]["Offset"] + delta["X"],
			startpos["Y"]["Scale"], startpos["Y"]["Offset"] + delta["Y"])
		game:GetService("TweenService"):Create(frame, TweenInfo.new(dragspeed), {["Position"] = position}):Play()
	end

	frame["InputBegan"]:Connect(function(input)
		if (input["UserInputType"] == Enum.UserInputType.MouseButton1 or input["UserInputType"] == Enum.UserInputType.Touch) then 
			dragtoggle = true
			dragstart = input["Position"]
			startpos = frame["Position"]
			input["Changed"]:Connect(function()
				if input["UserInputState"] == Enum.UserInputState.End then
					dragtoggle = false
				end
			end)
		end
	end)

	game:GetService("UserInputService")["InputChanged"]:Connect(function(input)
		if input["UserInputType"] == Enum.UserInputType.MouseMovement or input["UserInputType"] == Enum.UserInputType.Touch then
			if dragtoggle then
				updatebuttoninput(input)
			end
		end
	end)
end)

-------------------------------------------------------------------------------------------------------------------------------

local topbar = Instance.new("Frame")
topbar["Size"] = UDim2.new(0, 400, 0, 30)
topbar["BackgroundColor3"] = Color3.fromRGB(50, 50, 50)
topbar["BorderSizePixel"] = 0
topbar["Parent"] = frame

local titlelabel = Instance.new("TextLabel")
titlelabel["Size"] = UDim2.new(1, -140, 1, 0)
titlelabel["Position"] = UDim2.new(0, 0, 0, 0)
titlelabel["BackgroundTransparency"] = 1
titlelabel["Text"] = " Animation Logger"
titlelabel["Font"] = Enum.Font.RobotoMono
titlelabel["TextXAlignment"] = Enum.TextXAlignment.Left
titlelabel["TextColor3"] = Color3.new(1, 1, 1)
titlelabel["TextSize"] = 18
titlelabel["Parent"] = topbar

local function createbutton(name, position, size, color, text)
	local button = Instance.new("TextButton")
	button["Name"] = name
	button["Size"] = size
	button["Position"] = position
	button["BackgroundColor3"] = color
	button["Text"] = text
	button["TextColor3"] = Color3.new(1, 1, 1)
	button["TextSize"] = 16
	button["Font"] = Enum.Font.RobotoMono
	button["BorderSizePixel"] = 0
	button["BackgroundTransparency"] = 0.7
	button["Parent"] = topbar
	return button
end

local clearbutton = createbutton("ClearButton", UDim2.new(1, -116, 0, 5), UDim2.new(0, 60, 0, 20), Color3.fromRGB(200, 50, 50), "Clear")
local minimizebutton = createbutton("MinimizeButton", UDim2.new(1, -51, 0, 5), UDim2.new(0, 20, 0, 20), Color3.fromRGB(50, 50, 200), "–")
local xbutton = createbutton("CloseButton", UDim2.new(1, -25, 0, 5), UDim2.new(0, 20, 0, 20), Color3.fromRGB(200, 50, 50), "X")

-------------------------------------------------------------------------------------------------------------------------------

local fakeframe = Instance.new("Frame")
fakeframe["Size"] = UDim2.new(1, 0, 1, -30)
fakeframe["Position"] = UDim2.new(0, 0, 0, 30)
fakeframe["BorderSizePixel"] = 0
fakeframe["BackgroundColor3"] = Color3.fromRGB(20, 20, 20)
fakeframe["Parent"] = frame

local scrollframe = Instance.new("ScrollingFrame")
scrollframe["Size"] = UDim2.new(1, 0, 0, 210)
scrollframe["Position"] = UDim2.new(0, 5, 0, 35)
scrollframe["CanvasSize"] = UDim2.new(0, 0, 0, 0)
scrollframe["ScrollBarThickness"] = 0
scrollframe["BorderSizePixel"] = 0
scrollframe["BackgroundTransparency"] = 1
scrollframe["BackgroundColor3"] = Color3.fromRGB(20, 20, 20)
scrollframe["Parent"] = frame

local loglayout = Instance.new("UIListLayout")
loglayout["Padding"] = UDim.new(0, 5)
loglayout["Parent"] = scrollframe

-------------------------------------------------------------------------------------------------------------------------------

local function extractanimationid(fullid)
	local justid = string.gsub(fullid, "http://www%.roblox%.com/asset/%?id=", "")
	justid = string.gsub(justid, "rbxassetid://", "")
	return justid
end

local function getanimationcreator(assetid)
	local success, result = pcall(function()
		return marketplaceservice:GetProductInfo(assetid)
	end)

	if success and result then
		return result["Creator"]["Name"]
	end
	return "Unknown"
end

-------------------------------------------------------------------------------------------------------------------------------

local loggedanimations = {}

local function createlogentry(animationname, animationid, source)
	local displayid = extractanimationid(animationid)
	local numericid = tonumber(displayid)

	local entryframe = Instance.new("Frame")
	entryframe["Size"] = UDim2.new(0, 390, 0, 80)
	entryframe["Position"] = UDim2.new(0, 10, 0, 10)
	entryframe["BackgroundColor3"] = Color3.fromRGB(40, 40, 40)
	entryframe["BorderSizePixel"] = 0
	entryframe["Parent"] = scrollframe

	local namelabel = Instance.new("TextLabel")
	namelabel["Size"] = UDim2.new(1, -10, 0, 20)
	namelabel["Position"] = UDim2.new(0, 5, 0, 5)
	namelabel["BackgroundTransparency"] = 1
	namelabel["Text"] = "Name: " .. animationname
	namelabel["Font"] = Enum.Font.RobotoMono
	namelabel["TextColor3"] = Color3.new(1, 1, 1)
	namelabel["TextSize"] = 16
	namelabel["BorderSizePixel"] = 0
	namelabel["TextXAlignment"] = Enum.TextXAlignment.Left
	namelabel["Parent"] = entryframe

	local idlabel = Instance.new("TextLabel")
	idlabel["Size"] = UDim2.new(1, -10, 0, 20)
	idlabel["Position"] = UDim2.new(0, 5, 0, 22)
	idlabel["BackgroundTransparency"] = 1
	idlabel["Text"] = "ID: " .. displayid
	idlabel["BorderSizePixel"] = 0
	idlabel["Font"] = Enum.Font.RobotoMono
	idlabel["TextColor3"] = Color3.new(1, 1, 1)
	idlabel["TextSize"] = 16
	idlabel["TextXAlignment"] = Enum.TextXAlignment.Left
	idlabel["Parent"] = entryframe

	local creator = Instance.new("TextLabel")
	creator["Size"] = UDim2.new(1, -10, 0, 20)
	creator["Position"] = UDim2.new(0, 5, 0, 39)
	creator["BackgroundTransparency"] = 1
	creator["Text"] = "Creator: " .. getanimationcreator(numericid)
	creator["BorderSizePixel"] = 0
	creator["Font"] = Enum.Font.RobotoMono
	creator["TextColor3"] = Color3.new(0.8, 0.8, 0.8)
	creator["TextSize"] = 14
	creator["TextXAlignment"] = Enum.TextXAlignment.Left
	creator["Parent"] = entryframe

	local sourcelabel = Instance.new("TextLabel")
	sourcelabel["Size"] = UDim2.new(1, -10, 0, 20)
	sourcelabel["Position"] = UDim2.new(0, 5, 0, 54)
	sourcelabel["BackgroundTransparency"] = 1
	sourcelabel["Text"] = "Source: " .. source
	sourcelabel["Font"] = Enum.Font.RobotoMono
	sourcelabel["BorderSizePixel"] = 0
	sourcelabel["TextColor3"] = Color3.new(0.8, 0.8, 0.8)
	sourcelabel["TextSize"] = 14
	sourcelabel["TextXAlignment"] = Enum.TextXAlignment.Left
	sourcelabel["Parent"] = entryframe

	local playbutton = Instance.new("TextButton")
	playbutton["Size"] = UDim2.new(0, 70, 0, 20)
	playbutton["Position"] = UDim2.new(1, -75, 0, 5)
	playbutton["BackgroundColor3"] = Color3.fromRGB(60, 150, 60)
	playbutton["Text"] = "Play"
	playbutton["Font"] = Enum.Font.RobotoMono
	playbutton["BorderSizePixel"] = 0
	playbutton["TextColor3"] = Color3.new(1, 1, 1)
	playbutton["TextSize"] = 14
	playbutton["Parent"] = entryframe

	local stopbutton = Instance.new("TextButton")
	stopbutton["Size"] = UDim2.new(0, 70, 0, 20)
	stopbutton["Position"] = UDim2.new(1, -75, 0, 30)
	stopbutton["BackgroundColor3"] = Color3.fromRGB(150, 60, 60)
	stopbutton["Text"] = "Stop"
	stopbutton["Font"] = Enum.Font.RobotoMono
	stopbutton["BorderSizePixel"] = 0
	stopbutton["TextColor3"] = Color3.new(1, 1, 1)
	stopbutton["TextSize"] = 14
	stopbutton["Parent"] = entryframe

	local copybutton = Instance.new("TextButton")
	copybutton["Size"] = UDim2.new(0, 70, 0, 20)
	copybutton["Position"] = UDim2.new(1, -75, 0, 55)
	copybutton["BackgroundColor3"] = Color3.fromRGB(60, 60, 60)
	copybutton["Text"] = "Copy ID"
	copybutton["Font"] = Enum.Font.RobotoMono
	copybutton["BorderSizePixel"] = 0
	copybutton["TextColor3"] = Color3.new(1, 1, 1)
	copybutton["TextSize"] = 14
	copybutton["Parent"] = entryframe
	
	local track = nil
	
	playbutton["MouseButton1Click"]:Connect(function()
		if localplayer.Character then
			local humanoid = localplayer.Character:FindFirstChildOfClass("Humanoid")
			if humanoid then
				if track then
					track:Stop()
					track = nil
				end

				local animation = Instance.new("Animation")
				animation.AnimationId = "rbxassetid://" .. numericid

				track = humanoid:LoadAnimation(animation)
				track:Play()

				playbutton.Text = "Playing"
				task.delay(1, function()
					if playbutton then
						playbutton.Text = "Play"
					end
				end)
			end
		end
	end)

	stopbutton["MouseButton1Click"]:Connect(function()
		if track then
			track:Stop()
			track = nil
			stopbutton.Text = "Stopped"
			task.delay(1, function()
				if stopbutton then
					stopbutton.Text = "Stop"
				end
			end)
		end
	end)

	copybutton["MouseButton1Click"]:Connect(function()
		clik()
		local justid = string.gsub(animationid, "rbxassetid://", "")
		if setclipboard then
			setclipboard(justid)
			copybutton["Text"] = "Copied!"
			task.wait(1)
			copybutton["Text"] = "Copy ID"
		else
			copybutton["Text"] = "Error"
			task.wait(1)
			copybutton["Text"] = "Copy ID"
		end
	end)

	return entryframe
end

-------------------------------------------------------------------------------------------------------------------------------

local function loganimation(animationname, animationid, source)
	if not animationid or loggedanimations[animationid] then return end

	loggedanimations[animationid] = true
	createlogentry(animationname, animationid, source)

	scrollframe["CanvasSize"] = UDim2.new(0, 0, 0, loglayout["AbsoluteContentSize"]["Y"])
end

local function scananimationsfolder(character)
	local foundanimations = {}
	local animationsfolder = character:FindFirstChild("Animations")

	if animationsfolder then
		for _, anim in ipairs(animationsfolder:GetChildren()) do
			if anim:IsA("Animation") then
				table.insert(foundanimations, {
					name = anim["Name"],
					id = anim["AnimationId"]
				})
			end
		end
	end

	return foundanimations
end

local function trackanimationplaying(humanoid)
	if indw then return end

	local animationtrackconnection
	local function onanimationplayed(animationtrack)
		if not animationtrack or not animationtrack["Animation"] then return end

		local anim = animationtrack["Animation"]
		local cleanid = string.gsub(anim["AnimationId"], "rbxassetid://", "")
		loganimation(anim["Name"], cleanid, "Played Animation")
	end

	animationtrackconnection = humanoid["AnimationPlayed"]:Connect(onanimationplayed)

	return function()
		if animationtrackconnection then
			animationtrackconnection:Disconnect()
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------

local function setupcharacter(character)
	local humanoid = character:WaitForChild("Humanoid")

	for _, child in ipairs(scrollframe:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end
	loggedanimations = {}

	if indw then
		local animationsfolder = character:FindFirstChild("Animations")
		if animationsfolder then
			for _, anim in ipairs(animationsfolder:GetChildren()) do
				if anim:IsA("Animation") then
					local cleanid = string.gsub(anim["AnimationId"], "rbxassetid://", "")
					loganimation(anim["Name"], cleanid, "Character Animations")
				end
			end
		else
			task.spawn(function()
				task.wait(1)
				animationsfolder = character:FindFirstChild("Animations")
				if animationsfolder then
					for _, anim in ipairs(animationsfolder:GetChildren()) do
						if anim:IsA("Animation") then
							local cleanid = string.gsub(anim["AnimationId"], "rbxassetid://", "")
							loganimation(anim["Name"], cleanid, "Character Animations")
						end
					end
				end
			end)
		end
	else
		trackanimationplaying(humanoid)
	end
end

-------------------------------------------------------------------------------------------------------------------------------

local characterconnection

local function monitorcharacter()
	if characterconnection then
		characterconnection:Disconnect()
	end

	characterconnection = localplayer["CharacterAdded"]:Connect(function(character)
		setupcharacter(character)
	end)

	if localplayer["Character"] then
		setupcharacter(localplayer["Character"])
	end
end

monitorcharacter()

-------------------------------------------------------------------------------------------------------------------------------

clearbutton["MouseButton1Click"]:Connect(function()
	clik()
	for _, child in ipairs(scrollframe:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end
	loggedanimations = {}
	scrollframe["CanvasSize"] = UDim2.new(0, 0, 0, 0)
end)

xbutton["MouseButton1Click"]:Connect(function()
	clik()
	gui:Destroy()
end)

local isminimized = false
local originalsize = frame["Size"]

minimizebutton["MouseButton1Click"]:Connect(function()
	clik()
	isminimized = not isminimized
	if isminimized then
		minimizebutton["Text"] = "+"
		frame["Size"] = UDim2.new(originalsize["X"]["Scale"], originalsize["X"]["Offset"], 0, 30)
		scrollframe["Visible"] = false
	else
		minimizebutton["Text"] = "–"
		frame["Size"] = originalsize
		scrollframe["Visible"] = true
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

loglayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scrollframe["CanvasSize"] = UDim2.new(0, 0, 0, loglayout["AbsoluteContentSize"]["Y"])
end)

-------------------------------------------------------------------------------------------------------------------------------
