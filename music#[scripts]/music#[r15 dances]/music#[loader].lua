--[[---------------------------------------------------------------------------------------------------------------------------
  ______    __    ______        _____     ______     __   __     ______     ______     ______    
 /\  __ \  /\ \  /\  ___\      /\  __-.  /\  __ \   /\ "-.\ \   /\  ___\   /\  ___\   /\  ___\   
 \ \  __<  \ \ \ \ \___  \     \ \ \/\ \ \ \  __ \  \ \ \-.  \  \ \ \____  \ \  __\   \ \___  \  
  \ \_\ \_\ \ \_\ \/\_____\     \ \____-  \ \_\ \_\  \ \_\\"\_\  \ \_____\  \ \_____\  \/\_____\ 
   \/_/ /_/  \/_/  \/_____/      \/____/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_____/   \/_____/ 
   
   Edited by Team Noxious -- R15 Dances

---------------------------------------------------------------------------------------------------------------------------]]--

--// Settings
local settings = _G

settings["Use default animations"] = true
settings["Fake character transparency level"] = 1 --// 0 to disable
settings["Disable character scripts"] = true
settings["Fake character should collide"] = false
settings["Parent real character to fake character"] = false
settings["Respawn character"] = true --// Only should be disabled if your character havent played ANY animations, otherwise it breaks the reanimate
settings["Instant respawn"] = false --// Instant respawns the character, it will still wait the respawn time, but your character wont be dead. Requires: replicatesignal function. Enable if you want the feature
settings["Hide HumanoidRootPart"] = false --// Enabled by default. when enabled, your chat bubble or name tag will not appear above your character, but you will have your character immortal in the Fencing arena.
settings["PermaDeath fake character"] = false --// When enabled, when you die when the reanimate is on, you wont respawn. If you want respawn, set it to false
settings["R15 Reanimate"] = true

settings["Names to exclude from transparency"] = {
    --[[ Example:
    ["HumanoidRootPart"] = true,
    ["Left Arm"] = true
    ]]
}

(function() if getgenv then return getgenv() else return _G end end)().fling = nil
local finished = false

task.spawn(function()
	loadstring(game:HttpGet("https://github.com/Boxten-Keyes/music/raw/refs/heads/main/music%23%5Bscripts%5D/music%23%5Breanimators%5D/music%23%5Bcurrent%20angle%20v2%5D.lua"))()
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Boxten-Keyes/music/refs/heads/main/music%23%5Bscripts%5D/music%23%5Br6%20dances%5D/music%23%5Br15%20dances%5D.lua"))()
end)

repeat task.wait() until finished

-------------------------------------------------------------------------------------------------------------------------------
