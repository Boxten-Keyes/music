--[[---------------------------------------------------------------------------------------------------------------------------
  ______     ______   __     __  __        ______     ______        _____     ______     __   __     ______     ______     ______    
 /\  ___\   /\  __ \ /\ \   /\ \/ /       /\  __ \   /\  ___\      /\  __-.  /\  __ \   /\ "-.\ \   /\  ___\   /\  ___\   /\  ___\   
 \ \  ___\  \ \  __/ \ \ \  \ \  _"-.     \ \  __<   \ \  __ \     \ \ \/\ \ \ \  __ \  \ \ \-.  \  \ \ \____  \ \  ___\  \ \___  \  
  \ \_____\  \ \_\    \ \_\  \ \_\ \_\     \ \_\ \_\  \ \_____\     \ \____-  \ \_\ \_\  \ \_\\"\_\  \ \_____\  \ \_____\  \/\_____\ 
   \/_____/   \/_/     \/_/   \/_/\/_/      \/_/ /_/   \/_____/      \/____/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_____/   \/_____/ 
   
   Made by gObl00x, Edited by Team Noxious -- Epik R6 Dances

---------------------------------------------------------------------------------------------------------------------------]]--

if not game:IsLoaded() then game["Loaded"]:Wait() end ER6D = {}

-------------------------------------------------------------------------------------------------------------------------------

ER6D["local player"] = game["Players"]["LocalPlayer"]
ER6D["character"] = ER6D["local player"]["Character"]
ER6D["backpack"] = ER6D["local player"]:WaitForChild("Backpack")

ER6D["run service"] = game["Run Service"]
ER6D["in studio"] = ER6D["run service"]:IsStudio()

-------------------------------------------------------------------------------------------------------------------------------

local a, s = nil, nil

if not ER6D["in studio"] then
	if not getgenv()["Animator"] then
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Boxten-Keyes/music/refs/heads/main/music%23%5Bscripts%5D/music%23%5Bepik%20r6%20dances%5D/music%23%5Bxhayper%20animator%5D.lua"))()
	end
end

-- credits to MrY7zz & xhayper
function makeanim(name, song, animid)
	local t = Instance.new("Tool")
	t["Name"] = tostring(name)
	t["RequiresHandle"] = false
	t["Parent"] = ER6D["backpack"]
	
	s = tostring(name) .. ".mp3"
	if song ~= nil then writefile(s, game:HttpGet(tostring(song))) end

	t["Equipped"]:Connect(function()
		if a then
			a:Stop()
			a:Destroy()
		end
		
		if s then
			s:Stop()
			s:Destroy()
		end
		
		task.wait()
				
		if ER6D["character"] then
			a = Animator.new(ER6D["character"], tonumber(animid))
			a:Play()
			a["Looped"] = true
			
			s = Instance.new("Sound")
			s["SoundId"] = getcustomasset(ER6D["song file name"])
			s["Volume"] = 2
			s["Parent"] = ER6D["character"]:WaitForChild("HumanoidRootPart")
			s["Looped"] = true
			s:Play()
		end
	end)

	t["Unequipped"]:Connect(function()
		if a then
			a:Stop()
			a:Destroy()
		end
		
		if s then
			s:Stop()
			s:Destroy()
		end
	end)
end

-------------------------------------------------------------------------------------------------------------------------------

-- dance 1 (two)
makeanim("Two", "https://files.catbox.moe/9x4a71.mp3", 137845929482571)

-- dance 2 (chinese dance / beat da koto nai)
makeanim("Chinese Dance", "https://files.catbox.moe/uvzvd1.mp3", 124210157097622)

-- dance 3 (rakuten point)
makeanim("Rakuten Point", "https://files.catbox.moe/bn9omy.mp3", 18985726113)

-- dance 4 (hakari)
makeanim("Hakari", "https://files.catbox.moe/3wworz.mp3", 92699725136780)

-- dance 11 (california girls)
makeanim("California Girls", "https://files.catbox.moe/s1belf.mp3", 121768360244671)

-- dance 12 (emotional prism)
makeanim("Emotional Prism", "https://files.catbox.moe/28vmzm.mp3", 132979558739339)

-- dance 13 (#brooklynbloodpop)
makeanim("#BrooklynBloodPop!", "https://files.catbox.moe/f4jsc9.mp3", 132026285699359)

-- dance 15 (soda pop)
makeanim("Soda Pop", "https://files.catbox.moe/ap73us.mp3", 77909248721162)

-- dance 16 (ksuuvi stomp)
makeanim("Ksuuvi Stomp", "https://files.catbox.moe/300n51.mp3", 87138990788698)

-- dance 17 (mesmerizer)
makeanim("Mesmerizer", "https://files.catbox.moe/k42abp.mp3", 107578737342278)

-- dance 18 (locked)
makeanim("Locked", "https://files.catbox.moe/5vxthn.mp3", 76975616044095)

-------------------------------------------------------------------------------------------------------------------------------
