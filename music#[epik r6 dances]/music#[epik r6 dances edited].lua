--[[---------------------------------------------------------------------------------------------------------------------------
  ______     ______   __     __  __        ______     ______       _____     ______     __   __     ______     ______     ______    
 /\  ___\   /\  __ \ /\ \   /\ \/ /       /\  __ \   /\  ___\     /\  __-.  /\  __ \   /\ "-.\ \   /\  ___\   /\  ___\   /\  ___\   
 \ \  ___\  \ \  __/ \ \ \  \ \  _"-.     \ \  __<   \ \  __ \    \ \ \/\ \ \ \  __ \  \ \ \-.  \  \ \ \____  \ \  ___\  \ \___  \  
  \ \_____\  \ \_\    \ \_\  \ \_\ \_\     \ \_\ \_\  \ \_____\    \ \____-  \ \_\ \_\  \ \_\\"\_\  \ \_____\  \ \_____\  \/\_____\ 
   \/_____/   \/_/     \/_/   \/_/\/_/      \/_/ /_/   \/_____/     \/____/   \/_/\/_/   \/_/ \/_/   \/_____/   \/_____/   \/_____/ 
   
   Made by gObl00x - Edited by Team Noxious

---------------------------------------------------------------------------------------------------------------------------]]--

local player = game.Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "The Hero"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("The Hero.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/The%20Hero.mp3"))     
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 133160365635320)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("The Hero.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "Two"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("Two.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/Two.mp3"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 137845929482571)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("Two.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "The Flop"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("The Flop.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/The%20Flop.mp3"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 84447598378239)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("The Flop.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "Club Penguin"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("Club Penguin.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/Club%20Penguin.mp3"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 89761302048916)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("Club Penguin.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "Breakdance"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("Breakdance.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/Breakdance.mp3"))

if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 132886479585903)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("Breakdance.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "Insanity"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("Insanity.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/Insanity.mp3"))

if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 139483347792972)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("Insanity.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "Mannrobics"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("Mannrobics.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/Mannrobics.mp3"))

if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 137456359844967)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("Mannrobics.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "Step"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("Step.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/Step.mp3"))

if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 124074233795203)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("Step.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end

	player.Character.Humanoid.WalkSpeed = 3
end)

tool.Unequipped:Connect(function()
	player.Character.Humanoid.WalkSpeed = 16
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "Poke Dance"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("Poke Dance.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/Poke%20Dance.mp3"))

if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 18986687692)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("Poke Dance.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "Spooky Month"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("Spooky Month.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/Spooky%20Month.mp3"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 15231364673)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("Spooky Month.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "Chinese Dance"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("Chinese Dance.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/Chinese%20Dance.mp3"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 124210157097622)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("Chinese Dance.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "Doodle"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("Doodle.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/Doodle.mp3"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 137721173051346)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("Doodle.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "Shinji Chair"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("Shinji Meme.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/Shinji%20Meme.mp3"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 130485792890829)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("Shinji Meme.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "Rakuten Lemonade"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("Rakuten Lemonade.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/Rakuten%20Lemonade.mp3"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 18985726113)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("Rakuten Lemonade.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "Lonely Lonely (Hakari)"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("Lonely Lonely.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/Lonely%20Lonely.mp3"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 92699725136780)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("Lonely Lonely.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end

	player.Character.Humanoid.WalkSpeed = 10

end)

tool.Unequipped:Connect(function()
	player.Character.Humanoid.WalkSpeed = 16
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "Boppin"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("Boppin.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/Boppin.mp3"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 13579968035)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("Boppin.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "Shuba Duck"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("Hey Ya.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/Hey%20Ya.mp3"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 13357063395)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("Hey Ya.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "Goopie"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("Goopie.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/Goopie.mp3"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 7828640127)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("Goopie.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "Prince of Egypt"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("Prince Of Egypt.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/Prince%20Of%20Egypt.mp3"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 100136360352723)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("Prince Of Egypt.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "WMD Boombox"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("Wipe me Down.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/Wipe%20me%20Down.mp3"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 72460213504303)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("Wipe me Down.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "Shoo Whop"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("Shoo Whop.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/Shoo%20Whop.mp3"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 121535445943256)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("Shoo Whop.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "PoPiPo"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("PoPiPo.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/PoPiPo.mp3"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 78991327797272)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("PoPiPo.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "Monoko"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("Monoko.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/Monoko.mp3"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 139889845987864)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("Monoko.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end

	player.Character.Humanoid.WalkSpeed = 8

end)

tool.Unequipped:Connect(function()
	player.Character.Humanoid.WalkSpeed = 16
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "Lagtrain"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("Lagtrain.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/Lagtrain.mp3"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 131559207454945)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("Lagtrain.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end

	player.Character.Humanoid.WalkSpeed = 20

end)

tool.Unequipped:Connect(function()
	player.Character.Humanoid.WalkSpeed = 16
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "Inside In My Head"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("In My Head.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/In%20My%20Head.mp3"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 114160464579438)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("In My Head.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "Lemon Melon Cookie"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("LMC.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/LMC.mp3"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 120262284704633)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("LMC.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "Get Down"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("Get Down.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/Get%20Down.mp3"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 98916367562022)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("Get Down.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "Dia Delicia"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("Dia Delicia.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/Dia%20Delicia.mp3"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 80641587562132)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("Dia Delicia.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "Epik"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("Epik.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/Epik.mp3"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 135424282094138)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("Epik.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "Shigure"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("Loli Dance.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/Loli%20Dance.mp3"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 14887006269)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("Loli Dance.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "I WANNA RUN AWAY🗣️"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("IWRA.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/IWRA.mp3"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 131562546189485)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("IWRA.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "WhatsApp Meme"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("WhatsApp Meme.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/WhatsApp%20Meme.mp3"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 131539514978219)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("WhatsApp Meme.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "Goofy"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("Goofy Song.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/Goofy%20Song.mp3"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 75148929064618)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("Goofy Song.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "Who Can It Be Now?"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("WCIBN.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/WCIBN.mp3"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 16240038168)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("WCIBN.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "Pretty Princess"
tool.RequiresHandle = false
tool.Parent = backpack

writefile("Pretty Princess Theme.mp3", game:HttpGet("https://github.com/gObl00x/Epik-Musics/raw/refs/heads/main/Pretty%20Princess%20Theme.mp3"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 118452043589079)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("Pretty Princess Theme.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------

local tool = Instance.new("Tool")
tool.Name = "California Girls"
tool.RequiresHandle = false
tool.Parent = backpack

-- TODO: replace this with the actual emote id
writefile("California Girls.mp3", game:HttpGet("aaa"))
if not getgenv()["Animator"] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/xhayper/Animator/main/Source/Main.lua"))()
end

local Anim = nil
local sound = nil

tool.Equipped:Connect(function()
	local character = player.Character
	if character then
		Anim = Animator.new(character, 120599274370272)
		Anim:Play()
		Anim.Stopped:Connect(function()
			Anim:Play()
		end)
		sound = Instance.new("Sound")
		sound.SoundId = getcustomasset("Pretty Princess Theme.mp3")
		sound.Volume = 2
		sound.Looped = true
		sound.Parent = game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
		sound:Play()
	end
end)

tool.Unequipped:Connect(function()
	if Anim then
		Anim:Stop()
		Anim:Destroy()
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end)

-------------------------------------------------------------------------------------------------------------------------------
