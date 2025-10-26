-------------------------------------------------------------------------------------------------------------------------------

if not game:IsLoaded() then game.Loaded:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

local plrs = game:GetService("Players")
local plr = plrs.LocalPlayer
local r = game:GetService("RunService")
local rs = game:GetService("ReplicatedStorage")
local i = rs.Events.ItemEvent
local cam = workspace.CurrentCamera
local l = game:GetService("Lighting")

-------------------------------------------------------------------------------------------------------------------------------

local function usevalve() i:InvokeServer("Valve") end
local function useairhorn() i:InvokeServer("AirHorn") end
local function useinstructions() i:InvokeServer("Instructions") end
local function usesmokebomb() i:InvokeServer("SmokeBomb") end
local function usespeedcandy() i:InvokeServer("SpeedCandy") end
local function useextractionspeedcandy() i:InvokeServer("ExtractionSpeedCandy") end
local function usejumper() i:InvokeServer("JumperCable") end
local function usebandage() i:InvokeServer("Bandage") end

function checkforgenpps()
	local mod
	for _, model in pairs(workspace:FindFirstChild("CurrentFloor"):GetChildren()) do
		if model:IsA("Model") and model.Name:match("^%d+$") then
			mod = model
		end
	end

	local gens = mod:FindFirstChild("Generators")
	if gens then
		for _, v in ipairs(gens:GetDescendants()) do
			if v:IsA("ProximityPrompt") then
				local generator = v:FindFirstAncestorWhichIsA("Model")
				if generator then
					fireproximityprompt(v)
				end
			end
		end
	end
end

local function togen()
	task.spawn(function()
		local character = plr.Character or plr.CharacterAdded:Wait()
		local hrp = character:WaitForChild("HumanoidRootPart")

		local room = workspace:FindFirstChild("CurrentFloor")
		if not room then return end

		local roomModel
		for _, model in pairs(room:GetChildren()) do
			if model:IsA("Model") and model.Name:match("^%d+$") then
				roomModel = model
			end
		end

		local generatorsFolder = roomModel:FindFirstChild("Generators")
		if not generatorsFolder then return end

		local availableGenerators = {}
		for _, gen in ipairs(generatorsFolder:GetChildren()) do
			if gen:FindFirstChild("Stats") then
				local stats = gen.Stats
				local active = stats:FindFirstChild("ActivePlayer")
				local completed = stats:FindFirstChild("Completed")

				if active and completed then
					if not active.Value and not completed.Value then
						table.insert(availableGenerators, gen)
					end
				end
			end
		end

		if #availableGenerators == 0 then return end

		local randomGenerator = availableGenerators[math.random(1, #availableGenerators)]
		if not randomGenerator.PrimaryPart then return end

		local genCFrame = randomGenerator.PrimaryPart.CFrame
		local forwardPos = genCFrame.Position + genCFrame.LookVector * 4
		local targetCFrame = CFrame.new(forwardPos, genCFrame.Position) * CFrame.new(0, 2.3, 0)
		hrp.CFrame = targetCFrame

		task.spawn(function() for _ = 1, 10 do checkforgenpps() task.wait(0.1) end end)
		task.spawn(function() for _ = 1, 10 do usevalve() task.wait(0.1) end end)
	end)
end

function toelevator()
	local c = workspace:FindFirstChild("Elevators"):FindFirstChildWhichIsA("Model"):FindFirstChild("MonsterBlocker")
	local character = plr.Character or plr.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")
	if c and hrp then
		local e = c.CFrame * CFrame.new(0, -10.5, 0) * CFrame.Angles(0, math.rad(-90), 0)
		hrp.CFrame = e
	end
end

originallightingsetting = {}

function savelighting()
	originallightingsetting.Brightness = l.Brightness
	originallightingsetting.ClockTime = l.ClockTime
	originallightingsetting.FogEnd = l.FogEnd
	originallightingsetting.GlobalShadows = l.GlobalShadows
	originallightingsetting.OutdoorAmbient = l.OutdoorAmbient
end

savelighting()

function relighting()
	l.Brightness = originallightingsetting.Brightness
	l.ClockTime = originallightingsetting.ClockTime
	l.FogEnd = originallightingsetting.FogEnd
	l.GlobalShadows = originallightingsetting.GlobalShadows
	l.OutdoorAmbient = originallightingsetting.OutdoorAmbient
end

altfullbrightenabled = false
altfullbrightconnection = nil

function enableafb()
	if altfullbrightenabled then return end
	altfullbrightenabled = true

	task.spawn(function() savelighting() end)

	altfullbrightconnection = r.RenderStepped:Connect(function()
		if altfullbrightenabled then
			l.Brightness = 2
			l.FogEnd = 100000
			l.GlobalShadows = false
			l.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
		end
	end)
end

function disableafb()
	if not altfullbrightenabled then return end
	altfullbrightenabled = false

	task.spawn(function() relighting() end)

	if altfullbrightconnection then
		altfullbrightconnection:Disconnect()
		altfullbrightconnection = nil
	end
end

autovotebestcardenabled = false
autovotebestcardthread = nil

function votebest()
	local voter = game.Workspace.Info:WaitForChild("CardVote")
	local event = rs:WaitForChild("Events"):WaitForChild("CardVoteEvent")

	task.spawn(function() local c = voter:FindFirstChild("DyleFloor") if c then event:FireServer(c) end end)
	task.spawn(function() local c = voter:FindFirstChild("PipingTape") if c then event:FireServer(c) end end)
	task.spawn(function() local c = voter:FindFirstChild("DandyDiscount") if c then event:FireServer(c) end end)
	task.spawn(function() local c = voter:FindFirstChild("Elevator") local c2 = voter:FindFirstChild("Elevator2") if c then event:FireServer(c) end if c2 then event:FireServer(c2) end end)
	task.spawn(function() local c = voter:FindFirstChild("SurvivalPoint") local c2 = voter:FindFirstChild("SurvivalPoint2") if c then event:FireServer(c) end if c2 then event:FireServer(c2) end end)
	task.spawn(function() local c = voter:FindFirstChild("RandomItem") local c2 = voter:FindFirstChild("RandomItem2") if c then event:FireServer(c) end if c2 then event:FireServer(c2) end end)
	task.spawn(function() local c = voter:FindFirstChild("AbilityCooldown") local c2 = voter:FindFirstChild("AbilityCooldown2") if c then event:FireServer(c) end if c2 then event:FireServer(c2) end end)
	task.spawn(function() local c = voter:FindFirstChild("GlowLight") if c then event:FireServer(c) end end)
	task.spawn(function() local c = voter:FindFirstChild("MonsterPanicReduction") if c then event:FireServer(c) end end)
	task.spawn(function() local c = voter:FindFirstChild("ItemRarity") local c2 = voter:FindFirstChild("ItemRarity2") if c then event:FireServer(c) end if c2 then event:FireServer(c2) end end)
	task.spawn(function() local c = voter:FindFirstChild("Stamina") local c2 = voter:FindFirstChild("Stamina2") if c then event:FireServer(c) end if c2 then event:FireServer(c2) end end)
	task.spawn(function() local c = voter:FindFirstChild("Machine") if c then event:FireServer(c) end end)
	task.spawn(function()
		local v = false
		for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
			local c = p.Character
			local h = c and c:FindFirstChildOfClass("Humanoid")
			if h and h.Health < 2 then
				v = true
				break
			end
		end

		local c = voter:FindFirstChild("Heal")
		local c2 = voter:FindFirstChild("Heal2")
		if c and v then event:FireServer(c) end
		if c2 and v then event:FireServer(c2) end
	end)
end

function monitorcards()
	local voter = game.Workspace.Info:WaitForChild("CardVote")

	local function tryvote()
		if not autovotebestcardenabled or alreadyVoted then return end

		task.delay(1, function()
			if not autovotebestcardenabled or alreadyVoted then return end
			if #voter:GetChildren() > 0 then
				votebest()
				alreadyVoted = true
			end
		end)
	end

	voter.ChildAdded:Connect(tryvote)
	voter.ChildRemoved:Connect(function() if #voter:GetChildren() == 0 then alreadyVoted = false end end)
	if #voter:GetChildren() > 0 then tryvote() end
end

function autovotebestcard()
	if autovotebestcardenabled then return end
	autovotebestcardenabled = true
	alreadyVoted = false
	task.spawn(monitorcards)
end

function unautovotebestcard()
	autovotebestcardenabled = false
	alreadyVoted = false
end

function firepp()
	for _, descendant in ipairs(workspace:GetDescendants()) do
		if descendant:IsA("ProximityPrompt") then
			fireproximityprompt(descendant)
		end
	end
end

autofarmenabled = false

function startautofarm()
	if autofarmenabled then return end 
	autofarmenabled = true
	task.spawn(autovotebestcard)

	task.spawn(function()
		while autofarmenabled do
			togen()
			task.wait(0.2)
		end
	end)
	
	task.spawn(function()
		while autofarmenabled do
			if game.Workspace.Info.RequiredGenerators.Value == game.Workspace.Info.GeneratorsCompleted.Value then toelevator() end task.wait()
		end
	end)
	
	task.spawn(function()
		while autofarmenabled do
			if game.Workspace.Info.GeneratorsCompleted.Value == 0 then task.spawn(firepp) end task.wait()
		end
	end)
	
	task.spawn(function()
		while autofarmenabled do
			if plr.Character.Humanoid.Health == 2 or plr.Character.Humanoid.Health == 1 then usebandage() end task.wait(2)
		end
	end)
	
	task.spawn(function()
		while autofarmenabled do
			useextractionspeedcandy() task.wait(0.1)
		end
	end)
end

function stopautofarm()
	if not autofarmenabled then return end 
	autofarmenabled = false
	task.spawn(unautovotebestcard)
end

-------------------------------------------------------------------------------------------------------------------------------

local function clik() 
	task.spawn(function()
		local s = Instance.new("Sound") 
		s.SoundId = "rbxassetid://87152549167464"
		s.Parent = workspace
		s.Volume = 1.2 
		s.TimePosition = 0.1 
		s:Play() 
	end)
end

local function repos(ui, row, col, totalRows, totalCols)
	local buttonWidth = 90
	local buttonHeight = 55
	local spacing = 10

	local totalWidth = (buttonWidth * totalCols) + (spacing * (totalCols - 1))
	local totalHeight = (buttonHeight * totalRows) + (spacing * (totalRows - 1))

	local sw, sh = cam.ViewportSize.X, cam.ViewportSize.Y
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
	{type = "button", text = "Use Valve", callback = usevalve},
	{type = "button", text = "Use Air Horn", callback = useairhorn},
	{type = "button", text = "Use Instructions", callback = useinstructions},
	{type = "button", text = "Use Speed Candy", callback = usespeedcandy},
	{type = "button", text = "Use Smoke Bomb", callback = usesmokebomb},
	{type = "button", text = "Use Extraction Speed Candy", callback = useextractionspeedcandy},
	{type = "button", text = "Use Jumper Cable", callback = usejumper},
	{type = "button", text = "Use Bandage", callback = usebandage},
	{type = "button", text = "Complete Generator", callback = togen},
	{type = "button", text = "Teleport To Elevator", callback = toelevator},
	{type = "toggle", text = "Toggle Fullbright", callback = function(s) if s then enableafb() else disableafb() end end},
	{type = "toggle", text = "Toggle Autofarm", callback = function(s) if s then startautofarm() else stopautofarm() end end}
}

-------------------------------------------------------------------------------------------------------------------------------

local maxcolumns = 5
local maxbuttonspercolumn = 8
local totalbuttons = #buttons

local columns = math.min(maxbuttonspercolumn, math.ceil(totalbuttons / maxcolumns))
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
