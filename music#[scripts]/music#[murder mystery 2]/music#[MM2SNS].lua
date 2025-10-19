local Players = game:GetService("Players")  
local LocalPlayer = Players.LocalPlayer  

local function getCharacterRootPart(character)  
	return character and (character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso"))  
end  

local function EquipGun()  
	local character = LocalPlayer.Character  
	local gun = LocalPlayer.Backpack:FindFirstChild("Gun") or (character and character:FindFirstChild("Gun"))  
	if gun and gun.Parent == LocalPlayer.Backpack then  
		gun.Parent = character  
		task.delay(.17, function()  
			if gun.Parent == character then  
				gun.Parent = LocalPlayer.Backpack  
			end  
		end)  
		return true  
	elseif gun and gun.Parent == character then  
		return true  
	end  
	return false  
end  

local function hasKnife(player)  
	return player.Backpack:FindFirstChild("Knife") or (player.Character and player.Character:FindFirstChild("Knife"))  
end  

local function getKnifePlayer()  
	for _, player in pairs(Players:GetPlayers()) do  
		if player ~= LocalPlayer and hasKnife(player) and player.Character then  
			return player  
		end  
	end  
	return nil  
end  

local function shootAtKnifePlayer()  
	local target = getKnifePlayer()  
	if target and target.Character then  
		local targetRoot = getCharacterRootPart(target.Character)  
		local originRoot = getCharacterRootPart(LocalPlayer.Character)  
		if not targetRoot or not originRoot then return end  

		local camera = workspace.CurrentCamera  
		local screenPoint, onScreen = camera:WorldToViewportPoint(targetRoot.Position)  
		if onScreen and (originRoot.Position - targetRoot.Position).Magnitude < 30 then  
			local args = {  
				[1] = 1,  
				[2] = targetRoot.Position,  
				[3] = "AH2"  
			}  
			local gun = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun")  
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

		local gun = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun")  
		if gun and gun:FindFirstChild("KnifeLocal") and gun.KnifeLocal:FindFirstChild("CreateBeam") then  
			gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))  
		end  
	end  
end  

local roles
local lastData

local function isDifferent(t1, t2)
	if typeof(t1) ~= typeof(t2) then return true end
	if typeof(t1) ~= "table" then return t1 ~= t2 end
	for k, v in pairs(t1) do
		if isDifferent(v, t2[k]) then return true end
	end
	for k, v in pairs(t2) do
		if t1[k] == nil then return true end
	end
	return false
end

local function updateRoles()
	local success, data = pcall(function() 
		return game:GetService("ReplicatedStorage"):FindFirstChild("GetPlayerData", true):InvokeServer() 
	end)
	if success and data and isDifferent(data, lastData) then
		roles = data
		lastData = data
	end
	task.delay(1.4, updateRoles)
end
updateRoles()

local function IsAlive(player)
	local roleData = roles and roles[player.Name]
	return roleData and not roleData.Killed and not roleData.Dead
end

local function getRoleColor(player)
	local roleData = roles and roles[player.Name]
	if roleData and IsAlive(player) then
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
	for _, player in pairs(Players:GetPlayers()) do
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

local function startESPName()
	if nameloop then return end
	nameloop = true

	task.spawn(function()
		while nameloop do
			for _, player in pairs(Players:GetPlayers()) do
				if player ~= LocalPlayer then
					local color = getRoleColor(player)
					applyESPName(player, color)
				end
			end
			task.wait(1)
		end
	end)
end

local function stopESPName()
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
	for _, player in pairs(Players:GetPlayers()) do
		local character = player.Character
		if character then
			local highlight = character:FindFirstChild("Highlight")
			if highlight then
				highlight:Destroy()
			end
		end
	end
end

local function startESPHighlight()
	if highlightUpdateLoop or highlightCleanupLoop then return end highloop = true
	highlightUpdateLoop = task.spawn(function()
		while highloop do
			for _, player in pairs(Players:GetPlayers()) do
				if player == LocalPlayer then continue end
				local color = getRoleColor(player)
				applyHighlight(player, color, color)
			end
			task.wait(1)
		end
	end)
	highlightCleanupLoop = task.spawn(function()
		while highloop do
			for _, player in pairs(Players:GetPlayers()) do
				if player == LocalPlayer then continue end
				if not IsAlive(player) then
					applyHighlight(player, Color3.fromRGB(0, 0, 0))
				end
			end
			task.wait(1)
		end
	end)
end

local function stopESPHighlight()
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

local function touch(a, b)
	firetouchinterest(a, b, 0)
	firetouchinterest(a, b, 1)
end

function bringgun()
	local c = LocalPlayer.Character
	local r = c and c:FindFirstChild("HumanoidRootPart")
	local d = workspace:FindFirstChild("GunDrop", true)
	if r and d then touch(r, d) end
end

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.R then
		if EquipGun() then  
			for i = 1, 11 do  
				task.spawn(function()  
					shootAtKnifePlayer()  
				end)  
			end  
		end
	elseif input.KeyCode == Enum.KeyCode.E then
		task.spawn(function() if not highloop then startESPHighlight() else stopESPHighlight() end end)
		task.spawn(function() if not nameloop then startESPName() else stopESPName() end end)
		task.spawn(function() if not gunespactive then gundropesp() else nogundropesp() end end)
	elseif input.KeyCode == Enum.KeyCode.G then
		task.spawn(function() bringgun() end)
	end
end)

local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = gethui() or game:GetService("CoreGui")
if screenGui.Parent:FindFirstChild("MM2SNS") then screenGui.Parent:FindFirstChild("MM2SNS"):Destroy() end
screenGui.Name = "MM2SNS"

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 307, 0, 99)
frame.Position = UDim2.new(0, 14, 0, 10)
frame.BackgroundTransparency = 0.5
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BorderSizePixel = 0
frame.ZIndex = 2
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -10, 1, 0)
label.TextStrokeTransparency = 0
label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
label.Position = UDim2.new(0, 4, 0, 6)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.fromRGB(255, 255, 255)
label.Font = Enum.Font.Code
label.TextSize = 14
label.ZIndex = 3
label.TextXAlignment = Enum.TextXAlignment.Left
label.TextYAlignment = Enum.TextYAlignment.Top
label.Text = "Murder Mystery 2 | Simple Necessity Script\n\nControls:\nPress R to shoot the murderer.\nPress E to toggle ESP.\nPress G to grab the gun if dropped."
label.Parent = frame
