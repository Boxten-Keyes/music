-------------------------------------------------------------------------------------------------------------------------------

if not game:IsLoaded() then game.Loaded:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

local plrs = game:GetService("Players")  
local plr = plrs.LocalPlayer
local onmobile = game:GetService("UserInputService").TouchEnabled

-------------------------------------------------------------------------------------------------------------------------------

local function getroot(character)  
	return character and (character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso"))  
end  

local function equipgun()  
	local character = plr.Character  
	local gun = plr.Backpack:FindFirstChild("Gun") or (character and character:FindFirstChild("Gun"))  
	if gun and gun.Parent == plr.Backpack then  
		gun.Parent = character  
		task.delay(.17, function()  
			if gun.Parent == character then  
				gun.Parent = plr.Backpack  
			end  
		end)  
		return true  
	elseif gun and gun.Parent == character then  
		return true  
	end  
	return false  
end  

local function hasknife(player)  
	return player.Backpack:FindFirstChild("Knife") or (player.Character and player.Character:FindFirstChild("Knife"))  
end  

local function getmurderer()  
	for _, player in pairs(plrs:GetPlayers()) do  
		if player ~= plr and hasknife(player) and player.Character then  
			return player  
		end  
	end  
	return nil  
end

-------------------------------------------------------------------------------------------------------------------------------

local function shootmurderer()  
	local target = getmurderer()  
	if target and target.Character then  
		local targetRoot = getroot(target.Character)  
		local originRoot = getroot(plr.Character)  
		if not targetRoot or not originRoot then return end  

		local camera = workspace.CurrentCamera  
		local screenPoint, onScreen = camera:WorldToViewportPoint(targetRoot.Position)  
		if onScreen and (originRoot.Position - targetRoot.Position).Magnitude < 30 then  
			local args = {  
				[1] = 1,  
				[2] = targetRoot.Position,  
				[3] = "AH2"  
			}  
			local gun = plr.Character and plr.Character:FindFirstChild("Gun")  
			if gun and gun:FindFirstChild("KnifeLocal") and gun.KnifeLocal:FindFirstChild("CreateBeam") then  
				gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))  
			end  
			return  
		end  

		local distance = (originRoot.Position - targetRoot.Position).Magnitude  
		local velocity = targetRoot.AssemblyLinearVelocity  
		local direction = targetRoot.CFrame.LookVector  

		local predictionTime = math.clamp(distance / 100, 0.05, 0.18)  
		local predictedPosition = targetRoot.Position   
			+ velocity * predictionTime   
			+ direction * (2.2 * predictionTime)  

		predictedPosition = targetRoot.Position:Lerp(predictedPosition, 0.5)  

		if predictedPosition.Y < targetRoot.Position.Y then  
			predictedPosition = Vector3.new(predictedPosition.X, targetRoot.Position.Y, predictedPosition.Z)  
		end  

		local args = {  
			[1] = 1,  
			[2] = predictedPosition,  
			[3] = "AH2"  
		}  

		local gun = plr.Character and plr.Character:FindFirstChild("Gun")  
		if gun and gun:FindFirstChild("KnifeLocal") and gun.KnifeLocal:FindFirstChild("CreateBeam") then  
			gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))  
		end  
	end  
end

-------------------------------------------------------------------------------------------------------------------------------

local roles
local lastData

local function difftable(t1, t2)
	if typeof(t1) ~= typeof(t2) then return true end
	if typeof(t1) ~= "table" then return t1 ~= t2 end
	for k, v in pairs(t1) do
		if difftable(v, t2[k]) then return true end
	end
	for k, v in pairs(t2) do
		if t1[k] == nil then return true end
	end
	return false
end

local function updroles()
	local success, data = pcall(function() 
		return game:GetService("ReplicatedStorage"):FindFirstChild("GetPlayerData", true):InvokeServer() 
	end)
	if success and data and difftable(data, lastData) then
		roles = data
		lastData = data
	end
	task.delay(1.4, updroles)
end

updroles()

local function isalive(player)
	local roleData = roles and roles[player.Name]
	return roleData and not roleData.Killed and not roleData.Dead
end

local function getrole(player)
	local roleData = roles and roles[player.Name]
	if roleData and isalive(player) then
		local role = roleData.Role
		if role == "Innocent" then
			return Color3.fromRGB(0, 255, 0)
		elseif role == "Sheriff" then
			return Color3.fromRGB(0, 0, 255)
		elseif role == "Hero" then
			return Color3.fromRGB(255, 255, 0)
		elseif role == "Murderer" then
			return Color3.fromRGB(255, 0, 0)
		end
	end
	return Color3.fromRGB(0, 0, 0)
end

-------------------------------------------------------------------------------------------------------------------------------

local nameloop = false

local function applyESPName(player, color)
	local character = player.Character
	if not character then return end

	local hrp = character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local gui = hrp:FindFirstChild("NameESP")
	local textLabel

	if not gui then
		gui = Instance.new("BillboardGui")
		gui.Name = "NameESP"
		gui.Adornee = hrp
		gui.Size = UDim2.new(0, 200, 0, 50)
		gui.AlwaysOnTop = true
		gui.Parent = hrp

		textLabel = Instance.new("TextLabel")
		textLabel.Parent = gui
		textLabel.Size = UDim2.new(1, 0, 1, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = player.DisplayName .. "\n(@" .. player.Name .. ")"
		textLabel.TextXAlignment = Enum.TextXAlignment.Center
		textLabel.TextYAlignment = Enum.TextYAlignment.Center
		textLabel.Font = Enum.Font.Code
		textLabel.TextSize = 14
		textLabel.TextStrokeTransparency = 0
		textLabel.TextStrokeColor3 = Color3.new(1, 1, 1)
	else
		textLabel = gui:FindFirstChildOfClass("TextLabel")
	end

	if textLabel then
		textLabel.TextColor3 = color
	end
end

local function clearESPName()
	for _, player in pairs(plrs:GetPlayers()) do
		local char = player.Character
		if char then
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if hrp then
				local gui = hrp:FindFirstChild("NameESP")
				if gui then gui:Destroy() end
			end
		end
	end
end

local function startnameesp()
	if nameloop then return end
	nameloop = true

	task.spawn(function()
		while nameloop do
			for _, player in pairs(plrs:GetPlayers()) do
				if player ~= plr then
					local color = getrole(player)
					applyESPName(player, color)
				end
			end
			task.wait(1)
		end
	end)
end

local function stopnameesp()
	nameloop = false
	clearESPName()
end

local highlightUpdateLoop, highlightCleanupLoop, highloop

local function applyHighlight(player, fillColor)
	if not highloop then return end
	local character = player.Character
	if character and character:FindFirstChild("HumanoidRootPart") then
		local highlight = character:FindFirstChild("Highlight")
		if not highlight then
			highlight = Instance.new("Highlight")
			highlight.Parent = character
		end
		highlight.FillColor = fillColor
	end
end

local function clearHighlight()
	for _, player in pairs(plrs:GetPlayers()) do
		local character = player.Character
		if character then
			local highlight = character:FindFirstChild("Highlight")
			if highlight then
				highlight:Destroy()
			end
		end
	end
end

local function startplayeresp()
	if highlightUpdateLoop or highlightCleanupLoop then return end highloop = true
	highlightUpdateLoop = task.spawn(function()
		while highloop do
			for _, player in pairs(plrs:GetPlayers()) do
				if player == plr then continue end
				local color = getrole(player)
				applyHighlight(player, color, color)
			end
			task.wait(1)
		end
	end)
	highlightCleanupLoop = task.spawn(function()
		while highloop do
			for _, player in pairs(plrs:GetPlayers()) do
				if player == plr then continue end
				if not isalive(player) then
					applyHighlight(player, Color3.fromRGB(0, 0, 0))
				end
			end
			task.wait(1)
		end
	end)
end

local function stopplayeresp()
	highloop = false
	if highlightUpdateLoop then
		task.cancel(highlightUpdateLoop)
		highlightUpdateLoop = nil
	end
	if highlightCleanupLoop then
		task.cancel(highlightCleanupLoop)
		highlightCleanupLoop = nil
	end
	clearHighlight()
end

local activedrop, gunespconn, gunespactive

function gunesploop(part)
	if not part:FindFirstChild("GunDropESPHighlight") then
		local h = Instance.new("Highlight")
		h.Name = "GunDropESPHighlight"
		h.FillColor = Color3.fromRGB(150, 150, 150)
		h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		h.Parent = part
	end
	if not part:FindFirstChild("GunDropESPBillboard") then
		local b = Instance.new("BillboardGui")
		b.Name = "GunDropESPBillboard"
		b.Adornee = part
		b.Size = UDim2.new(0, 200, 0, 30)
		b.AlwaysOnTop = true
		b.Parent = part
		local t = Instance.new("TextLabel")
		t.Size = UDim2.new(1, 0, 1, 0)
		t.BackgroundTransparency = 1
		t.TextColor3 = Color3.fromRGB(150, 150, 150)
		t.TextStrokeTransparency = 0
		t.TextStrokeColor3 = Color3.new(1, 1, 1)
		t.Text = "Gun Drop"
		t.Font = Enum.Font.Code
		t.TextSize = 14
		t.Parent = b
	end
	activedrop = part
end

function stopgunesploop()
	local d = activedrop
	if d then
		local h = d:FindFirstChild("GunDropESPHighlight")
		if h then h:Destroy() end
		local b = d:FindFirstChild("GunDropESPBillboard")
		if b then b:Destroy() end
		activedrop = nil
	end
end

function gundropesp()
	gunespactive = true
	if gunespconn then return end
	local ex = workspace:FindFirstChild("GunDrop", true)
	if ex and ex:IsA("Part") then gunesploop(ex) end
	gunespconn = workspace.DescendantAdded:Connect(function(c)
		if c.Name == "GunDrop" and c:IsA("Part") then gunesploop(c) end
	end)
end

function nogundropesp()
	if gunespconn then gunespconn:Disconnect() end
	gunespconn = nil
	gunespactive = false
	stopgunesploop()
end

-------------------------------------------------------------------------------------------------------------------------------

local function touch(a, b)
	firetouchinterest(a, b, 0)
	firetouchinterest(a, b, 1)
end

function bringgun()
	local c = plr.Character
	local r = c and c:FindFirstChild("HumanoidRootPart")
	local d = workspace:FindFirstChild("GunDrop", true)
	if r and d then touch(r, d) end
end

-------------------------------------------------------------------------------------------------------------------------------

function stabsheriff()
	local character = plr.Character or plr.CharacterAdded:Wait()
	local backpack = plr:FindFirstChild("Backpack")

	local knife = character:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife"))

	if knife and knife.Parent == backpack then
		knife.Parent = character
		repeat task.wait() until knife.Parent == character
	end

	if knife and knife.Parent == character then
		local stabEvent = knife:FindFirstChild("Stab")

		if stabEvent then
			for _, target in ipairs(plrs:GetPlayers()) do
				if target ~= plr then
					local targetCharacter = target.Character
					local targetBackpack = target:FindFirstChild("Backpack")

					local hasGun = (targetCharacter and targetCharacter:FindFirstChild("Gun")) or 
						(targetBackpack and targetBackpack:FindFirstChild("Gun"))

					if hasGun then
						local humanoidRootPart = targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart")

						if humanoidRootPart then
							stabEvent:FireServer("Slash")
							firetouchinterest(humanoidRootPart, knife.Handle, 1)
							firetouchinterest(humanoidRootPart, knife.Handle, 0)
						end
					end
				end
			end
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------

function clik() 
	task.spawn(function()
		local s = Instance.new("Sound") 
		s.SoundId = "rbxassetid://87152549167464"
		s.Parent = workspace
		s.Volume = 1.2 
		s.TimePosition = 0.1 
		s:Play() 
	end)
end

function repos(ui, row, col, totalRows, totalCols)
	local buttonWidth = 90
	local buttonHeight = 55
	local spacing = 10

	local totalWidth = (buttonWidth * totalCols) + (spacing * (totalCols - 1))
	local totalHeight = (buttonHeight * totalRows) + (spacing * (totalRows - 1))

	local sw, sh = game.Workspace.CurrentCamera.ViewportSize.X, game.Workspace.CurrentCamera.ViewportSize.Y
	local startX = (sw - totalWidth) / 2
	local startY = (sh - totalHeight) / 2 - 56

	local x = startX + (col - 1) * (buttonWidth + spacing)
	local y = startY + (row - 1) * (buttonHeight + spacing)

	ui.Position = UDim2.new(0, x, 0, y)
end

local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = gethui() or game:GetService("CoreGui")
if screenGui.Parent:FindFirstChild("Stupid Rushed Script") then screenGui.Parent:FindFirstChild("Stupid Rushed Script"):Destroy() end
screenGui.Name = "Stupid Rushed Script"

-------------------------------------------------------------------------------------------------------------------------------

local function makebutton(text, callback, row, col, totalRows, totalCols)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 90, 0, 55)
	btn.TextStrokeTransparency = 1
	repos(btn, row, col, totalRows, totalCols)
	btn.BackgroundTransparency = 0.3
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	btn.Font = Enum.Font.Code
	btn.BorderSizePixel = 0
	btn.TextSize = 13
	btn.TextXAlignment = Enum.TextXAlignment.Center
	btn.TextYAlignment = Enum.TextYAlignment.Center
	btn.Active = true
	btn.Draggable = true
	btn.TextWrapped = true
	btn.Text = text
	btn.Parent = screenGui

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = Color3.new(1, 1, 1)
	stroke.Parent = btn
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	btn.MouseButton1Click:Connect(function()
		clik()
		if callback then callback() end
	end)

	return btn
end

local function maketoggle(text, initialState, callback, row, col, totalRows, totalCols)
	local toggled = initialState or false

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 90, 0, 55)
	btn.TextStrokeTransparency = 1
	repos(btn, row, col, totalRows, totalCols)
	btn.BackgroundTransparency = 0.3
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	btn.Font = Enum.Font.Code
	btn.BorderSizePixel = 0
	btn.TextSize = 13
	btn.TextXAlignment = Enum.TextXAlignment.Center
	btn.TextYAlignment = Enum.TextYAlignment.Center
	btn.Active = true
	btn.Draggable = true
	btn.TextWrapped = true
	btn.Text = text
	btn.Parent = screenGui

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = Color3.new(1, 1, 1)
	stroke.Parent = btn
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local function updvisual()
		if toggled then
			btn.TextColor3 = Color3.fromRGB(0, 255, 0)
			stroke.Color = Color3.fromRGB(0, 255, 0)
		else
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			stroke.Color = Color3.fromRGB(255, 255, 255)
		end
	end

	updvisual()

	btn.MouseButton1Click:Connect(function()
		clik()
		toggled = not toggled
		updvisual()
		if callback then callback(toggled) end
	end)

	return btn
end

-------------------------------------------------------------------------------------------------------------------------------

local buttons = {
	{type = "button", text = "Grab Gun", callback = bringgun},
	{type = "button", text = "Kill Sheriff", callback = stabsheriff},
	{type = "button", text = "Shoot Murderer", callback = shootmurderer},
	{type = "toggle", text = "Toggle ESP", callback = function(s)
		if s then
			task.spawn(startplayeresp)
			task.spawn(startnameesp)
			task.spawn(gundropesp)
		else
			task.spawn(stopplayeresp)
			task.spawn(stopnameesp)
			task.spawn(stopgunesploop)
		end
	end}
}

-------------------------------------------------------------------------------------------------------------------------------

local maxcolumns = 5
local maxbuttonspercolumn = 8
local totalbuttons = #buttons

local columns = math.min(maxcolumns, math.ceil(totalbuttons / maxbuttonspercolumn))
local rows = math.ceil(totalbuttons / columns)

local buttonindex = 1
for col = 1, columns do
	for row = 1, rows do
		if buttonindex > totalbuttons then break end

		local buttondata = buttons[buttonindex]
		if buttondata.type == "button" then
			makebutton(buttondata.text, buttondata.callback, row, col, rows, columns)
		elseif buttondata.type == "toggle" then
			maketoggle(buttondata.text, false, buttondata.callback, row, col, rows, columns)
		end

		buttonindex = buttonindex + 1
	end
end

-------------------------------------------------------------------------------------------------------------------------------
