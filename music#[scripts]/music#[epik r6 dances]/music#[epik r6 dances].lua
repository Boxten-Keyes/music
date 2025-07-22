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
ER6D["animator"] = nil

ER6D["run service"] = game["Run Service"]
ER6D["in studio"] = ER6D["run service"]:IsStudio()

-------------------------------------------------------------------------------------------------------------------------------

-- credits to MrY7zz & xhayper
function makeanim(name, song, animid)
	ER6D["animation tool"] = Instance.new("Tool")
	ER6D["animation tool"]["Name"] = tostring(name)
	ER6D["animation tool"]["RequiresHandle"] = false
	ER6D["animation tool"]["Parent"] = ER6D["backpack"]
	
	ER6D["song file name"] = tostring(name) .. ".mp3"
	writefile(ER6D["song file name"], game:HttpGet(tostring(song)))   
	
	if not ER6D["in studio"] then
		if not getgenv()["Animator"] then
			loadstring(game:HttpGet("https://raw.githubusercontent.com/Boxten-Keyes/music/refs/heads/main/music%23%5Bscripts%5D/music%23%5Bepik%20r6%20dances%5D/music%23%5Bxhayper%20animator%5D.lua"))()
			
			task.wait()
			
			ER6D["animator"] = Animator
		end
	end

	ER6D["animation"], ER6D["song"] = nil, nil

	ER6D["animation tool"]["Equipped"]:Connect(function()
		if ER6D["animation"] then
			ER6D["animation"]:Stop()
			ER6D["animation"]:Destroy()
		end
		
		if ER6D["song"] then
			ER6D["song"]:Stop()
			ER6D["song"]:Destroy()
		end
		
		task.wait()
				
		if ER6D["character"] then
			ER6D["animation"] = ER6D["animator"].new(ER6D["character"], tonumber(animid))
			ER6D["animation"]:Play()
			ER6D["animation"]["Looped"] = true
			
			ER6D["song"] = Instance.new("Sound")
			ER6D["song"]["SoundId"] = getcustomasset(ER6D["song file name"])
			ER6D["song"]["Volume"] = 2
			ER6D["song"]["Parent"] = ER6D["character"]:WaitForChild("HumanoidRootPart")
			ER6D["song"]["Looped"] = true
			ER6D["song"]:Play()
		end
	end)

	ER6D["animation tool"]["Unequipped"]:Connect(function()
		if ER6D["animation"] then
			ER6D["animation"]:Stop()
			ER6D["animation"]:Destroy()
		end
		
		if ER6D["song"] then
			ER6D["song"]:Stop()
			ER6D["song"]:Destroy()
		end
	end)
end

-------------------------------------------------------------------------------------------------------------------------------

-- dance 1 (two)
makeanim("Two", "https://files.catbox.moe/9x4a71.mp3", 137845929482571)

-- dance 2 (club penguin)
makeanim("Club Penguin", nil, 89761302048916)

-- dance 3 (insanity)
makeanim("Insanity", nil, 139483347792972)

-- dance 4 (chinese dance / beat da koto nai)
makeanim("Chinese Dance", nil, 124210157097622)

-- dance 5 (rakuten lemonade)
makeanim("Rakuten Lemonade", nil, 18985726113)

-- dance 6 (hakari)
makeanim("Hakari", nil, 92699725136780)

-- dance 7 (goopie)
makeanim("Goopie", nil, 7828640127)

-- dance 8 (prince of egypt)
makeanim("Prince of Egypt", nil, 100136360352723)

-- dance 9 (dia delicia / headlock)
makeanim("Dia Delicia", nil, 80641587562132)

-- dance 10 (who can it be now?)
makeanim("Who Can It Be Now?", nil, 16240038168)

-- dance 11 (california girls)
makeanim("California Girls", nil, 121768360244671)

-- dance 12 (emotional prism)
makeanim("Emotional Prism", "https://files.catbox.moe/28vmzm.mp3", 132979558739339)

-- dance 13 (#brooklynbloodpop)
makeanim("#BrooklynBloodPop!", nil, 132026285699359)

-- dance 14 (billy bounce)
makeanim("Billy Bounce", nil, 132026285699359)

-- dance 15 (soda pop)
makeanim("Soda Pop", "https://files.catbox.moe/ap73us.mp3", 77909248721162)

-- dance 16 (ksuuvi stomp)
makeanim("Ksuuvi Stomp", nil, 87138990788698)

-- dance 17 (mesmerizer)
makeanim("Mesmerizer", nil, 107578737342278)

-- dance 18 (locked)
makeanim("Locked", "https://files.catbox.moe/5vxthn.mp3", 76975616044095)

-------------------------------------------------------------------------------------------------------------------------------
