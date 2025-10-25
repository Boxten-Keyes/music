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
	local gens = workspace:FindFirstChild("CurrentFloor"):FindFirstChildWhichIsA("Model"):FindFirstChild("Generators")
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
	local character = plr.Character or plr.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")

	local room = workspace:FindFirstChild("CurrentFloor")
	if not room then return end

	local roomModel = room:FindFirstChildWhichIsA("Model")
	if not roomModel then return end

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

local function repos(ui, w, h, off)
	off = off or 0
	local sw, sh = cam.ViewportSize.X, cam.ViewportSize.Y
	local cx, cy = (sw - w) / 2, (sh - h) / 2 - 56
	ui.Position = UDim2.new(0, cx + off, 0, cy)
end

local screenGui = Instance.new("ScreenGui")
screenGui.ResetOnSpawn = false
screenGui.Parent = gethui() or game:GetService("CoreGui")
if screenGui.Parent:FindFirstChild("lol") then screenGui.Parent:FindFirstChild("lol"):Destroy() end
screenGui.Name = "lol"

-------------------------------------------------------------------------------------------------------------------------------

local function makebutton(text, callback, offset)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 90, 0, 55)
	btn.TextStrokeTransparency = 1
	repos(btn, 90, 55, offset)
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

local function maketoggle(text, initialState, callback, offset)
	local toggled = initialState or false

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 90, 0, 55)
	btn.TextStrokeTransparency = 1
	repos(btn, 90, 55, offset)
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

	local function updateVisual()
		if toggled then
			btn.TextColor3 = Color3.fromRGB(0, 255, 0)
			stroke.Color = Color3.fromRGB(0, 255, 0)
		else
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			stroke.Color = Color3.fromRGB(255, 255, 255)
		end
	end

	updateVisual()

	btn.MouseButton1Click:Connect(function()
		clik()
		toggled = not toggled
		updateVisual()
		if callback then callback(toggled) end
	end)

	return btn
end

-------------------------------------------------------------------------------------------------------------------------------

makebutton("Use Valve", usevalve, 0)
makebutton("Use Air Horn", useairhorn, 0)
makebutton("Use Instructions", useinstructions, 0)
makebutton("Use Speed Candy", usespeedcandy, 0)
makebutton("Use Smoke Bomb", usesmokebomb, 0)
makebutton("Use Extraction Speed Candy", useextractionspeedcandy, 0)
makebutton("Use Jumper Cable", usejumper, 0)
makebutton("Use Bandage", usebandage, 0)
makebutton("Complete Generator", togen, 0)
makebutton("Teleport To Elevator", toelevator, 0)

maketoggle("Toggle Fullbright", false, function(state)
	if state then enableafb() else disableafb() end
end, 0)

-------------------------------------------------------------------------------------------------------------------------------
