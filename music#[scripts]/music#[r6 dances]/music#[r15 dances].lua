--[[---------------------------------------------------------------------------------------------------------------------------
  ______     ______        _____     ______     __   __     ______     ______     ______    
 /\  __ \   /\  ___\      /\  __-.  /\  __ \   /\ "-.\ \   /\  ___\   /\  ___\   /\  ___\   
 \ \  __<   \ \  __ \     \ \ \/\ \ \ \  __ \  \ \ \-.  \  \ \ \____  \ \  ___\  \ \___  \  
  \ \_\ \_\  \ \_____\     \ \____-  \ \_\ \_\  \ \_\\"\_\  \ \_____\  \ \_____\  \/\_____\ 
   \/_/ /_/   \/_____/      \/____/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_____/   \/_____/ 
   
   Made by Team Noxious -- R15 Dances

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
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Boxten-Keyes/music/refs/heads/main/music%23%5Bscripts%5D/music%23%5Br6%20dances%5D/music%23%5Bxhayper%20animator%5D.lua"))()
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

-- dance 1 (dia delicia)
makeanim("Dia Delicia", "https://files.catbox.moe/9x4a71.mp3", 113510757669180, 1, 0)

-- dance 2 (who can it be now)
makeanim("Who Can It Be Now", "https://files.catbox.moe/uvzvd1.mp3", 130496945823800, 1)

-- dance 3 (rakuten point)
makeanim("Rakuten Point", "https://files.catbox.moe/bn9omy.mp3", 18985726113, 1, 0.2, 11.47)

-- dance 4 (caramelldansen)
makeanim("Caramelldansen", "https://files.catbox.moe/3wworz.mp3", 115289059988164, 1.03)

-- dance 5 (california girls)
makeanim("California Girls", "https://files.catbox.moe/s1belf.mp3", 123486263490186, 1, 0.27)

-- dance 8 (soda pop)
makeanim("Soda Pop", "https://files.catbox.moe/ap73us.mp3", 99232423242037, 1)

-- dance 13 (who is you)
makeanim("Who Is You", "https://files.catbox.moe/cqxyp6.mp3", 125113429514020, 1)

-------------------------------------------------------------------------------------------------------------------------------