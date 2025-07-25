--[[---------------------------------------------------------------------------------------------------------------------------
  ______     ______        _____     ______     __   __     ______     ______     ______    
 /\  __ \   /\  ___\      /\  __-.  /\  __ \   /\ "-.\ \   /\  ___\   /\  ___\   /\  ___\   
 \ \  __<   \ \  __ \     \ \ \/\ \ \ \  __ \  \ \ \-.  \  \ \ \____  \ \  ___\  \ \___  \  
  \ \_\ \_\  \ \_____\     \ \____-  \ \_\ \_\  \ \_\\"\_\  \ \_____\  \ \_____\  \/\_____\ 
   \/_/ /_/   \/_____/      \/____/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_____/   \/_____/ 
   
   Made by Team Noxious -- R6 Dances

---------------------------------------------------------------------------------------------------------------------------]]--

if not game:IsLoaded() then game["Loaded"]:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

local lp = game["Players"]["LocalPlayer"]
local bp = lp:WaitForChild("Backpack")

local rs = game["Run Service"]
local instud = rs:IsStudio()

-------------------------------------------------------------------------------------------------------------------------------

-- credits to MrY7zz & xhayper
function makeanim(name, song, animid, pitch, startt, endt)
	local tool = Instance.new("Tool")
	tool["Name"] = tostring(name)
	tool["RequiresHandle"] = false
	tool["Parent"] = bp

	local file = tostring(name) .. ".mp3"
	if song and not instud then
		writefile(file, game:HttpGet(song))
	end

	if not instud and not getgenv()["Animator"] then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Boxten-Keyes/music/refs/heads/main/music%23%5Bscripts%5D/music%23%5Breanimators%5D/music%23%5Bxhayper%20animator%5D.lua"))()
	end

	local animator = getgenv()["Animator"]
	if not animator then return end

	local anim, sound
	local conn, endconn

	local function stop()
		if anim then anim:Stop(); anim:Destroy(); anim = nil end
		if sound then sound:Stop(); sound:Destroy(); sound = nil end
		if conn then conn:Disconnect(); conn = nil end
		if endconn then endconn:Disconnect(); endconn = nil end
	end

	tool["Equipped"]:Connect(function()
		stop()
		task.wait(0.1)

		local character = lp["Character"] or lp["CharacterAdded"]:Wait()
		local hrp = character:WaitForChild("HumanoidRootPart")

		anim = animator.new(character, tonumber(animid))
		anim["Looped"] = true
		anim:Play()

		sound = Instance.new("Sound")
		sound["SoundId"] = getcustomasset(file)
		sound["Volume"] = 2
		sound["Looped"] = false
		sound["PlaybackSpeed"] = tonumber(pitch)
		sound["Parent"] = hrp

		local start = startt or 0
		local ending = endt

		sound:Play()
		sound["TimePosition"] = start

		local function looptrimmed()
			if not sound then return end
			sound["TimePosition"] = start
			sound:Play()
		end

		endconn = sound["Ended"]:Connect(function()
			if not ending then
				looptrimmed()
			end
		end)

		if ending and ending > start then
			conn = rs["Heartbeat"]:Connect(function()
				if sound and sound["IsPlaying"] and sound["TimePosition"] >= ending then
					looptrimmed()
				end
			end)
		end
	end)

	tool["Unequipped"]:Connect(stop)
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
makeanim("Kazotsky Kick", "https://files.catbox.moe/3mupm8.mp3", 9158896160, 1, 0.5)

-- dance 13 (who is you)
makeanim("Who Is You", "https://files.catbox.moe/cqxyp6.mp3", 137714761719347, 1)

-- dance 14 (chegou 3)
makeanim("Chegou 3", "https://files.catbox.moe/mssm2m.mp3", 89046713686252, 1)

-------------------------------------------------------------------------------------------------------------------------------
