--[[---------------------------------------------------------------------------------------------------------------------------
  ______     __  __     __    __     ______   __  __     __  __     ______     __     ______    
 /\  ___\   /\ \_\ \   /\ "-./  \   /\  __ \ /\ \_\ \   /\ \_\ \   /\  ___\   /\ \   /\  ___\   
 \ \___  \  \ \____ \  \ \ \-./\ \  \ \  __/ \ \  __ \  \ \____ \  \ \___  \  \ \ \  \ \___  \  
  \/\_____\  \/\_____\  \ \_\ \ \_\  \ \_\    \ \_\ \_\  \/\_____\  \/\_____\  \ \_\  \/\_____\ 
   \/_____/   \/_____/   \/_/  \/_/   \/_/     \/_/\/_/   \/_____/   \/_____/   \/_/   \/_____/
                                                                                                       
   Made by Team Symphysis - FE Fling All
   
---------------------------------------------------------------------------------------------------------------------------]]--

task.wait(0.1)

-------------------------------------------------------------------------------------------------------------------------------

task.spawn(function()
	local rs = game:GetService("RunService")
	local hb = rs.Heartbeat
	local rsd = rs.RenderStepped
	local lp = game.Players.LocalPlayer
	local z = Vector3.zero
	local function f(c)
		local r = c:WaitForChild("HumanoidRootPart")
		if r then
			local con
			con = hb:Connect(function()
				if not r.Parent then
					con:Disconnect()
				end
				local v = r.AssemblyLinearVelocity
				r.AssemblyLinearVelocity = z
				rsd:Wait()
				r.AssemblyLinearVelocity = v
			end)
		end
	end
	f(lp.Character)
	lp.CharacterAdded:Connect(f)
end)

-------------------------------------------------------------------------------------------------------------------------------

function prang()
	local s = Instance.new("Sound")
	s.SoundId = "rbxassetid://8426701399"
	s.Parent = game:GetService("SoundService")
	s:Play()
	s.Ended:Connect(function() s:Destroy() end)
end

-------------------------------------------------------------------------------------------------------------------------------

cl = nil

function setc(state)
	local chr = game:GetService("Players").LocalPlayer.Character
	if not chr then return end

	for _, p in pairs(chr:GetDescendants()) do
		if p:IsA("BasePart") then
			p.CanCollide = state
		end
	end
end

function dc()
	if cl then return end

	cl = game:GetService("RunService").Stepped:Connect(function()
		setc(false)
	end)
end

function rc()
	if cl then
		cl:Disconnect()
		cl = nil
	end
	setc(true)
end

-------------------------------------------------------------------------------------------------------------------------------

function af()
	if antifling then
		antifling:Disconnect()
		antifling = nil
	end
	antifling = game:GetService("RunService").Stepped:Connect(function()
		for _, player in pairs(game.Players:GetPlayers()) do
			if player ~= game.Players.LocalPlayer and player.Character then
				for _, v in pairs(player.Character:GetDescendants()) do
					if v:IsA("BasePart") then
						v.CanCollide = false
					end
				end
			end
		end
	end)
end

function uaf()
	if antifling then
		antifling:Disconnect()
		antifling = nil
	end
end

-------------------------------------------------------------------------------------------------------------------------------

walkflinging = false

function wf()
	walkflinging = true
	local humanoid = game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
	if humanoid then
		humanoid.Died:Connect(function()
			walkflinging = false
		end)
	end
	local function getRoot(char)
		local rootPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
		return rootPart
	end
	repeat game:GetService("RunService").Heartbeat:Wait()
		local character = game.Players.LocalPlayer.Character
		local root = game.Players.LocalPlayer.Character
		local vel, movel = nil, 0.1

		while not (character and character.Parent and root and root.Parent) do
			game:GetService("RunService").Heartbeat:Wait()
			character = game.Players.LocalPlayer.Character
			root = getRoot(character)
		end

		vel = root.Velocity
		root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)

		game:GetService("RunService").RenderStepped:Wait()
		if character and character.Parent and root and root.Parent then
			root.Velocity = vel
		end

		game:GetService("RunService").Stepped:Wait()
		if character and character.Parent and root and root.Parent then
			root.Velocity = vel + Vector3.new(0, movel, 0)
			movel = movel * -1
		end
	until walkflinging == false
end

function uwf()
	walkflinging = false
end

-------------------------------------------------------------------------------------------------------------------------------

function notify(te, tt, d)
	task.spawn(function() task.spawn(prang) game:GetService("StarterGui"):SetCore("SendNotification", {Title = te, Text = tt, Duration = d}) end)
end

-------------------------------------------------------------------------------------------------------------------------------

local oldpos = nil
local loopflinging = false

function fling()
	local Targets = {"All"}

	local Players = game:GetService("Players")
	local Player = Players.LocalPlayer

	local AllBool = false

	local GetPlayer = function(Name)
		Name = Name:lower()
		if Name == "all" or Name == "others" then
			AllBool = true
			return
		elseif Name == "random" then
			local GetPlayers = Players:GetPlayers()
			if table.find(GetPlayers,Player) then table.remove(GetPlayers,table.find(GetPlayers,Player)) end
			return GetPlayers[math.random(#GetPlayers)]
		elseif Name ~= "random" and Name ~= "all" and Name ~= "others" then
			for _,x in next, Players:GetPlayers() do
				if x ~= Player then
					if x.Name:lower():match("^"..Name) then
						return x;
					elseif x.DisplayName:lower():match("^"..Name) then
						return x;
					end
				end
			end
		else
			return
		end
	end

	local SkidFling = function(TargetPlayer)
		task.wait(0.1)
		local Character = Player.Character
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
		local RootPart = Humanoid and Humanoid.RootPart

		local TCharacter = TargetPlayer.Character
		local THumanoid
		local TRootPart
		local THead
		local Accessory
		local Handle

		if TCharacter:FindFirstChildOfClass("Humanoid") then
			THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
		end
		if THumanoid and THumanoid.RootPart then
			TRootPart = THumanoid.RootPart
		end
		if TCharacter:FindFirstChild("Head") then
			THead = TCharacter.Head
		end
		if TCharacter:FindFirstChildOfClass("Accessory") then
			Accessory = TCharacter:FindFirstChildOfClass("Accessory")
		end
		if Accessory and Accessory:FindFirstChild("Handle") then
			Handle = Accessory.Handle
		end

		if Character and Humanoid and RootPart then
			if RootPart.Velocity.Magnitude < 50 then
				oldpos = RootPart.CFrame
			end
			if THumanoid and THumanoid.Sit and not AllBool then
				return
			end
			if THead then
				workspace.CurrentCamera.CameraSubject = THead
			elseif not THead and Handle then
				workspace.CurrentCamera.CameraSubject = Handle
			elseif THumanoid and TRootPart then
				workspace.CurrentCamera.CameraSubject = THumanoid
			end
			if not TCharacter:FindFirstChildWhichIsA("BasePart") then
				return
			end

			local FPos = function(BasePart, Pos, Ang)
				RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
				Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
				RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
				RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
			end

			local SFBasePart = function(BasePart)
				local TimeToWait = 2
				local Time = tick()
				local Angle = 0

				repeat
					if RootPart and THumanoid then
						if BasePart.Velocity.Magnitude < 50 then
							Angle = Angle + 100

							FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
							task.wait()

							FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
							task.wait()

							FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
							task.wait()

							FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
							task.wait()

							FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
							task.wait()

							FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
							task.wait()
						else
							FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
							task.wait()

							FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
							task.wait()

							FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
							task.wait()

							FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
							task.wait()

							FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
							task.wait()

							FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
							task.wait()

							FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
							task.wait()

							FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
							task.wait()

							FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
							task.wait()

							FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
							task.wait()
						end
					else
						break
					end
				until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or TargetPlayer.Character ~= TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
			end

			workspace.FallenPartsDestroyHeight = 0/0

			local BV = Instance.new("BodyVelocity")
			BV.Name = "EpixVel"
			BV.Parent = RootPart
			BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
			BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)

			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

			if TRootPart and THead then
				if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
					SFBasePart(THead)
				else
					SFBasePart(TRootPart)
				end
			elseif TRootPart and not THead then
				SFBasePart(TRootPart)
			elseif not TRootPart and THead then
				SFBasePart(THead)
			elseif not TRootPart and not THead and Accessory and Handle then
				SFBasePart(Handle)
			end

			BV:Destroy()
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
			workspace.CurrentCamera.CameraSubject = Humanoid

			repeat
				RootPart.CFrame = oldpos * CFrame.new(0, .5, 0)
				Character:SetPrimaryPartCFrame(oldpos * CFrame.new(0, .5, 0))
				Humanoid:ChangeState("GettingUp")
				for _, x in ipairs(Character:GetChildren()) do
					if x:IsA("BasePart") then
						x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
					end
				end
				task.wait()
			until (RootPart.Position - oldpos.p).Magnitude < 25
			workspace.FallenPartsDestroyHeight = workspace.FallenPartsDestroyHeight
		end
	end

	if Targets[1] then for _,x in next, Targets do GetPlayer(x) end else return end

	if AllBool then
		for _,x in next, Players:GetPlayers() do
			SkidFling(x)
		end
	end
end

function safefling()
	local Targets = {"All"}
	local Players = game:GetService("Players")
	local Player = Players.LocalPlayer
	local AllBool = false

	local GetPlayer = function(Name)
		Name = Name:lower()
		if Name == "all" or Name == "others" then
			AllBool = true
			return
		elseif Name == "random" then
			local GetPlayers = Players:GetPlayers()
			if table.find(GetPlayers,Player) then table.remove(GetPlayers,table.find(GetPlayers,Player)) end
			return GetPlayers[math.random(#GetPlayers)]
		elseif Name ~= "random" and Name ~= "all" and Name ~= "others" then
			for _,x in next, Players:GetPlayers() do
				if x ~= Player then
					if x.Name:lower():match("^"..Name) then
						return x;
					elseif x.DisplayName:lower():match("^"..Name) then
						return x;
					end
				end
			end
		else
			return
		end
	end

	local SkidFling = function(TargetPlayer)
		task.wait(0.1)
		local Character = Player.Character
		local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
		local RootPart = Humanoid and Humanoid.RootPart

		local TCharacter = TargetPlayer.Character
		local THumanoid = TCharacter and TCharacter:FindFirstChildOfClass("Humanoid")
		local TRootPart = THumanoid and THumanoid.RootPart
		local THead = TCharacter and TCharacter:FindFirstChild("Head")
		local Accessory = TCharacter and TCharacter:FindFirstChildOfClass("Accessory")
		local Handle = Accessory and Accessory:FindFirstChild("Handle")

		if not (Character and Humanoid and RootPart) then return end

		if RootPart.Velocity.Magnitude < 50 then
			oldpos = RootPart.CFrame
		end

		if THumanoid and THumanoid.Sit and not AllBool then return end

		if THead then
			workspace.CurrentCamera.CameraSubject = THead
		elseif Handle then
			workspace.CurrentCamera.CameraSubject = Handle
		elseif THumanoid then
			workspace.CurrentCamera.CameraSubject = THumanoid
		end

		if not (TCharacter and TCharacter:FindFirstChildWhichIsA("BasePart")) then return end

		local FPos = function(BasePart, Pos, Ang)
			RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
			Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
			RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
			RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
		end

		local SFBasePart = function(BasePart)
			local TimeToWait = 2
			local Time = tick()
			local Angle = 0

			repeat
				if not (RootPart and THumanoid) then break end
				if BasePart.Velocity.Magnitude < 50 then
					Angle = Angle + 100

					FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
					task.wait()

					FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
					task.wait()

					FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
					task.wait()

					FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
					task.wait()

					FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
					task.wait()

					FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
					task.wait()
				else
					FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
					task.wait()

					FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
					task.wait()

					FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
					task.wait()

					FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
					task.wait()

					FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
					task.wait()

					FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
					task.wait()

					FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
					task.wait()

					FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
					task.wait()

					FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
					task.wait()

					FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
					task.wait()
				end
			until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or TargetPlayer.Character ~= TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
		end

		workspace.FallenPartsDestroyHeight = math.huge

		local BV = Instance.new("BodyVelocity")
		BV.Name = "EpixVel"
		BV.Parent = RootPart
		BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
		BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)

		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

		if TRootPart and THead then
			SFBasePart((TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 and THead or TRootPart)
		elseif TRootPart then
			SFBasePart(TRootPart)
		elseif THead then
			SFBasePart(THead)
		elseif Handle then
			SFBasePart(Handle)
		end

		BV:Destroy()
		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
		workspace.CurrentCamera.CameraSubject = Humanoid

		if oldpos then
			RootPart.CFrame = oldpos * CFrame.new(0, .5, 0)
			Character:SetPrimaryPartCFrame(oldpos * CFrame.new(0, .5, 0))
			Humanoid:ChangeState("GettingUp")
		end

		workspace.FallenPartsDestroyHeight = workspace.FallenPartsDestroyHeight
	end

	if not Targets[1] then return end
	for _,x in next, Targets do GetPlayer(x) end

	if AllBool then
		for _,x in next, Players:GetPlayers() do
			if x ~= Player then
				SkidFling(x)
			end
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------

local connections = {}
local flinging = false
local cd = 0.1

local function cleanconns()
	for _, conn in pairs(connections) do
		conn:Disconnect()
	end
	connections = {}
end

local function runloop(character)
	if not loopflinging then return end

	local humanoid = character:WaitForChild("Humanoid", 5)
	if not humanoid then return end

	connections.death = humanoid.Died:Connect(function()
		if loopflinging then task.wait(0) unloopfling() task.wait(0) loopfling() end
	end)

	while loopflinging and humanoid and humanoid.Health > 0 do
		if not flinging then
			flinging = true
			local success
			if game.PlaceId == 189707 then success = pcall(safefling) else success = pcall(fling) end
			flinging = false

			if not success then
			end
		end
		task.wait(cd)
	end
end

function loopfling()
	if loopflinging then return end

	local Players = game:GetService("Players")
	local Player = Players.LocalPlayer

	cleanconns()
	loopflinging = true

	connections.characterAdded = Player.CharacterAdded:Connect(function(character)
		if not loopflinging then return end

		while flinging do
			task.wait(0.1)
		end

		runloop(character)
	end)

	if Player.Character then
		runloop(Player.Character)
	end
end

function unloopfling()
	loopflinging = false
	cleanconns()
end

-------------------------------------------------------------------------------------------------------------------------------

function givelooptool(n, state)
	local function give()
		local bp = game.Players.LocalPlayer:WaitForChild("Backpack")

		local ex = bp:FindFirstChild(n)
		if ex then
			ex:Destroy()
		end

		local t = Instance.new("Tool")
		t.Name = n
		t.RequiresHandle = false
		t.CanBeDropped = false
		t.Parent = bp

		t.Equipped:Connect(function()
			task.spawn(function()
				if state then
					if loopflinging == true then
					else
						task.spawn(loopfling)
						task.spawn(dc)
						task.spawn(af)
						if game.PlaceId ~= 189707 then task.spawn(wf) end
					end
				else
					if loopflinging == false then
					else
						task.spawn(unloopfling)
						task.spawn(rc)
						task.spawn(uaf)
						if game.PlaceId ~= 189707 then task.spawn(uwf) end
					end
				end
			end)
		end)
	end

	give()

	game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
		task.wait()
		give()
	end)
end

function givetool()
	local function give()
		local bp = game.Players.LocalPlayer:WaitForChild("Backpack")

		local ex = bp:FindFirstChild("fling all")
		if ex then
			ex:Destroy()
		end

		local t = Instance.new("Tool")
		t.Name = "fling all"
		t.RequiresHandle = false
		t.CanBeDropped = false
		t.Parent = bp

		t.Equipped:Connect(function()
			task.spawn(function()
				if game.PlaceId == 189707 then task.spawn(safefling) else task.spawn(fling) end
			end)
		end)
	end

	give()

	game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
		task.wait()
		give()
	end)
end

-------------------------------------------------------------------------------------------------------------------------------
