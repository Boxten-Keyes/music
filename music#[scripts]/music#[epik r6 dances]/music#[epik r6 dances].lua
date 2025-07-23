--[[---------------------------------------------------------------------------------------------------------------------------
  ______     ______   __     __  __        ______     ______        _____     ______     __   __     ______     ______     ______    
 /\  ___\   /\  __ \ /\ \   /\ \/ /       /\  __ \   /\  ___\      /\  __-.  /\  __ \   /\ "-.\ \   /\  ___\   /\  ___\   /\  ___\   
 \ \  ___\  \ \  __/ \ \ \  \ \  _"-.     \ \  __<   \ \  __ \     \ \ \/\ \ \ \  __ \  \ \ \-.  \  \ \ \____  \ \  ___\  \ \___  \  
  \ \_____\  \ \_\    \ \_\  \ \_\ \_\     \ \_\ \_\  \ \_____\     \ \____-  \ \_\ \_\  \ \_\\"\_\  \ \_____\  \ \_____\  \/\_____\ 
   \/_____/   \/_/     \/_/   \/_/\/_/      \/_/ /_/   \/_____/      \/____/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_____/   \/_____/ 
   
   Made by gObl00x, Edited by Team Noxious -- Epik R6 Dances

---------------------------------------------------------------------------------------------------------------------------]]--

if not game:IsLoaded() then game["Loaded"]:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

local lp = game.Players.LocalPlayer
local bp = lp:WaitForChild("Backpack")

local runService = game:GetService("RunService")
local instud = runService:IsStudio()

-------------------------------------------------------------------------------------------------------------------------------

-- credits to MrY7zz & xhayper
function makeanim(name, songUrl, animid, pitch, startTime, endTime)
	local tool = Instance.new("Tool")
	tool.Name = tostring(name)
	tool.RequiresHandle = false
	tool.Parent = bp

	local fileName = tostring(name) .. ".mp3"
	if songUrl and not instud then
		writefile(fileName, game:HttpGet(songUrl))
	end

	if not instud and not getgenv().Animator then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Boxten-Keyes/music/refs/heads/main/music%23%5Bscripts%5D/music%23%5Bepik%20r6%20dances%5D/music%23%5Bxhayper%20animator%5D.lua"))()
	end

	local animatorModule = getgenv().Animator
	if not animatorModule then return end

	local animInstance, soundInstance
	local heartbeatConnection, endedConnection

	local function stopEverything()
		if animInstance then animInstance:Stop(); animInstance:Destroy(); animInstance = nil end
		if soundInstance then soundInstance:Stop(); soundInstance:Destroy(); soundInstance = nil end
		if heartbeatConnection then heartbeatConnection:Disconnect(); heartbeatConnection = nil end
		if endedConnection then endedConnection:Disconnect(); endedConnection = nil end
	end

	tool.Equipped:Connect(function()
		stopEverything()

		local character = lp.Character or lp.CharacterAdded:Wait()
		local hrp = character:WaitForChild("HumanoidRootPart")

		animInstance = animatorModule.new(character, tonumber(animid))
		animInstance.Looped = true
		animInstance:Play()

		soundInstance = Instance.new("Sound")
		soundInstance.SoundId = getcustomasset(fileName)
		soundInstance.Volume = 2
		soundInstance.Looped = false
    soundInstance.PlaybackSpeed = tonumber(pitch)
		soundInstance.Parent = hrp

		local start = startTime or 0
		local ending = endTime -- might be nil

		soundInstance:Play()
		soundInstance.TimePosition = start

		local function loopTrimmed()
			if not soundInstance then return end
			soundInstance.TimePosition = start
			soundInstance:Play()
		end

		-- Listen for end of full song (if no custom end time)
		endedConnection = soundInstance.Ended:Connect(function()
			if not ending then
				loopTrimmed()
			end
		end)

		-- Custom end cutoff & loop manually
		if ending and ending > start then
			heartbeatConnection = game:GetService("RunService").Heartbeat:Connect(function()
				if soundInstance and soundInstance.IsPlaying and soundInstance.TimePosition >= ending then
					loopTrimmed()
				end
			end)
		end
	end)

	tool.Unequipped:Connect(stopEverything)
end

-------------------------------------------------------------------------------------------------------------------------------

-- dance 1 (two)
makeanim("Two", "https://files.catbox.moe/9x4a71.mp3", 137845929482571, 1, 0.2)

-- dance 2 (chinese dance / beat da koto nai)
makeanim("Chinese Dance", "https://files.catbox.moe/uvzvd1.mp3", 124210157097622, 1)

-- dance 3 (rakuten point)
makeanim("Rakuten Point", "https://files.catbox.moe/bn9omy.mp3", 18985726113, 1, 0.2, 11.47)

-- dance 4 (hakari)
makeanim("Hakari", "https://files.catbox.moe/3wworz.mp3", 92699725136780, 1.03)

-- dance 5 (california girls)
makeanim("California Girls", "https://files.catbox.moe/s1belf.mp3", 121768360244671, 1, 0.27)

-- dance 6 (emotional prism)
makeanim("Emotional Prism", "https://files.catbox.moe/28vmzm.mp3", 132979558739339, 1)

-- dance 7 (#brooklynbloodpop)
makeanim("BrooklynBloodPop", "https://files.catbox.moe/f4jsc9.mp3", 132026285699359, 1)

-- dance 8 (soda pop)
makeanim("Soda Pop", "https://files.catbox.moe/ap73us.mp3", 77909248721162, 1)

-- dance 9 (ksuuvi stomp)
makeanim("Ksuuvi Stomp", "https://files.catbox.moe/300n51.mp3", 87138990788698, 1)

-- dance 10 (mesmerizer)
makeanim("Mesmerizer", "https://files.catbox.moe/k42abp.mp3", 107578737342278, 1, 0.2)

-- dance 11 (locked)
makeanim("Locked", "https://files.catbox.moe/5vxthn.mp3", 76975616044095, 1)

-- dance 12 (kazotsky kick)
makeanim("Kazotsky Kick", "https://files.catbox.moe/3mupm8.mp3", 9158896160, 1)

-- dance 13 (who is you)
makeanim("Who Is You", "https://files.catbox.moe/cqxyp6.mp3", 137714761719347, 1)

-- dance 14 (chegou 3)
makeanim("Chegou 3", "https://files.catbox.moe/mssm2m.mp3", 89046713686252, 1)

-------------------------------------------------------------------------------------------------------------------------------
