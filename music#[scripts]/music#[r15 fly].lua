-------------------------------------------------------------------------------------------------------------------------------

if not game:IsLoaded() then game["Loaded"]:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

local players = game["Players"]
local player = players["LocalPlayer"]
local runservice = game["Run Service"]
local userinputservice = game["UserInputService"]
local mouse = player:GetMouse()
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
button["Text"] = "F:X"
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
clik["Parent"] = workspace
clik["Name"] = "canttouchthis"
clik["Volume"] = 0.4

function playclicksound()
	local newsound = clik:Clone()
	newsound["Parent"] = clik["Parent"]
	newsound:Play()
	newsound["Ended"]:Connect(function() newsound:Destroy() end)
end

-------------------------------------------------------------------------------------------------------------------------------

function playanim(id, time, speed)
	pcall(function()
		local char = player["Character"] or player["CharacterAdded"]:Wait()
		char["Animate"]["Disabled"] = false
		local hum = char:WaitForChild("Humanoid")
		for _, track in pairs(hum:GetPlayingAnimationTracks()) do track:Stop() end
		char["Animate"]["Disabled"] = true
		local anim = Instance.new("Animation")
		anim["AnimationId"] = "rbxassetid://" .. id
		local loaded = hum:LoadAnimation(anim)
		loaded:Play()
		loaded["TimePosition"] = time
		loaded:AdjustSpeed(speed)
	end)
end

function stopanim()
	local char = player["Character"] or player["CharacterAdded"]:Wait()
	char["Animate"]["Disabled"] = false
	for _, track in pairs(char:WaitForChild("Humanoid"):GetPlayingAnimationTracks()) do
		track:Stop()
	end
end

function resetanims()
	task.wait()
	task.spawn(function()
		local char = player["Character"] or player["CharacterAdded"]:Wait()
		local human = char and char:WaitForChild("Humanoid", 15)
		local animate = char and char:WaitForChild("Animate", 15)

		if animate then
			animate["Disabled"] = true
			for _, v in ipairs(human:GetPlayingAnimationTracks()) do
				v:Stop()
			end
			animate["Disabled"] = false
		end
	end)
end

function getmovedirectionanim(dir)
	if dir["Magnitude"] < 0.1 then return "idle" end
	local cam = workspace["CurrentCamera"]
	local look = cam["CFrame"]["LookVector"]
	local right = cam["CFrame"]["RightVector"]

	local forward = look:Dot(dir)
	local sideways = right:Dot(dir)

	if math.abs(forward) > math.abs(sideways) then
		return forward > 0 and "w" or "s"
	else
		return sideways > 0 and "d" or "a"
	end
end

-------------------------------------------------------------------------------------------------------------------------------

local flytoggle = false
local flyspeed = 200
local flying = false
local ctrl = {f = 0, b = 0, l = 0, r = 0}
local lastctrl = {f = 0, b = 0, l = 0, r = 0}
local keydownfunction, keyupfunction

function startflying()
	if flying then return end
	flying = true

	local char = player["Character"] or player["CharacterAdded"]:Wait()
	local uppertorso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:WaitForChild("HumanoidRootPart")
	local speed = 0

	local bg = Instance.new("BodyGyro", uppertorso)
	bg["P"] = 9e4
	bg["maxTorque"] = Vector3.new(9e9, 9e9, 9e9)
	bg["cframe"] = uppertorso["CFrame"]

	local bv = Instance.new("BodyVelocity", uppertorso)
	bv["velocity"] = Vector3.new(0, 0.1, 0)
	bv["maxForce"] = Vector3.new(9e9, 9e9, 9e9)

	playanim(10714347256, 4, 0)

	keydownfunction = mouse["KeyDown"]:Connect(function(key)
		local k = key:lower()
		if k == "w" then ctrl.f = 1 playanim(10714177846, 4.65, 0)
		elseif k == "s" then ctrl.b = -1 playanim(10147823318, 4.11, 0)
		elseif k == "a" then ctrl.l = -1 playanim(10147823318, 3.55, 0)
		elseif k == "d" then ctrl.r = 1 playanim(10147823318, 4.81, 0)
		end
	end)

	keyupfunction = mouse["KeyUp"]:Connect(function(key)
		local k = key:lower()
		if k == "w" then ctrl.f = 0
		elseif k == "s" then ctrl.b = 0
		elseif k == "a" then ctrl.l = 0
		elseif k == "d" then ctrl.r = 0
		end
		playanim(10714347256, 4, 0)
	end)

	local lastdir = nil

	coroutine.wrap(function()
		local lastdir = nil
		while flying and char and char["Parent"] do
			runservice["RenderStepped"]:Wait()
			char["Humanoid"]["PlatformStand"] = true

			local movevec = char["Humanoid"]["MoveDirection"]
			local hasinput = movevec["Magnitude"] > 0.1
			local camlook = camera["CFrame"]["LookVector"]

			local flatcamlook = Vector3.new(camlook["X"], 0, camlook["Z"])["Unit"]
			local forwarddot = hasinput and flatcamlook:Dot(movevec["Unit"]) or 0

			local verticaly = 0
			if math.abs(forwarddot) > 0.7 then
				if forwarddot < 0 then
					verticaly = -camlook["Y"] * movevec["Magnitude"]
				else
					verticaly = camlook["Y"] * movevec["Magnitude"]
				end
			end

			local flydir = hasinput and Vector3.new(movevec["X"], verticaly, movevec["Z"])["Unit"] or Vector3.new(0, 0.1, 0)

			local animdir
			if hasinput then
				local forward = camera["CFrame"]["LookVector"]:Dot(movevec)
				local right = camera["CFrame"]["RightVector"]:Dot(movevec)

				if math.abs(forward) > math.abs(right) then
					animdir = forward > 0 and "w" or "s"
				else
					animdir = right > 0 and "d" or "a"
				end
			else
				animdir = "idle"
			end

			if animdir ~= lastdir then
				lastdir = animdir
				if animdir == "w" then
					playanim(10714177846, 4.65, 0)
				elseif animdir == "s" then
					playanim(10147823318, 4.11, 0)
				elseif animdir == "a" then
					playanim(10147823318, 3.55, 0)
				elseif animdir == "d" then
					playanim(10147823318, 4.81, 0)
				else
					playanim(10714347256, 4, 0)
				end
			end

			if hasinput then
				speed += flyspeed * 0.1
				if speed > flyspeed then speed = flyspeed end
			elseif speed > 0 then
				speed -= flyspeed * 0.1
				if speed < 0 then speed = 0 end
			end

			bv["velocity"] = flydir * speed

			local movevec = char["Humanoid"]["MoveDirection"]
			local camlook = camera["CFrame"]["LookVector"]
			local flatcamlook = Vector3.new(camlook["X"], 0, camlook["Z"])["Unit"]
			local forwarddot = (movevec["Magnitude"] > 0 and flatcamlook:Dot(movevec["Unit"])) or 0

			local tiltangle = 0

			if forwarddot > 0.7 then
				tiltangle = -math.rad(50 * speed / flyspeed)
			elseif forwarddot < -0.7 then
				tiltangle = math.rad(25 * speed / flyspeed)
			else
				tiltangle = 0
			end

			bg["CFrame"] = camera["CFrame"] * CFrame.Angles(tiltangle, 0, 0)
		end

		ctrl = {f = 0, b = 0, l = 0, r = 0}
		lastctrl = {f = 0, b = 0, l = 0, r = 0}
		speed = 0
		bg:Destroy()
		bv:Destroy()

		if char and char:FindFirstChild("Humanoid") then
			char["Humanoid"]["PlatformStand"] = false
		end
	end)()
end

function stopflying()
	if not flying then return end
	flying = false
	if keydownfunction then keydownfunction:Disconnect() end
	if keyupfunction then keyupfunction:Disconnect() end
	stopanim()
	resetanims()
end

-------------------------------------------------------------------------------------------------------------------------------

button["MouseButton1Click"]:Connect(function()
	playclicksound()
	flytoggle = not flytoggle
	button["Text"] = flytoggle and "F:O" or "F:X"
	button["BackgroundColor3"] = flytoggle and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(0, 0, 0)
	button["BorderColor3"] = flytoggle and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
	button["TextColor3"] = flytoggle and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
	if flytoggle then startflying() else stopflying() resetanims() end
end)

player["CharacterAdded"]:Connect(function()
	flytoggle = false
	stopflying()
	button["Text"] = "F:X"
	button["BackgroundColor3"] = Color3.fromRGB(0, 0, 0)
	button["BorderColor3"] = Color3.fromRGB(255, 255, 255)
	button["TextColor3"] = Color3.fromRGB(255, 255, 255)
end)

-------------------------------------------------------------------------------------------------------------------------------
