-------------------------------------------------------------------------------------------------------------------------------

-- im bored okay
if not game:IsLoaded() then game["Loaded"]:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

local adingrunning = false
local debounce = false
local adingtask = nil

-------------------------------------------------------------------------------------------------------------------------------

local function p(k)
	game:GetService("VirtualInputManager"):SendKeyEvent(true, k, false, nil)
	task.wait(0.05)
	game:GetService("VirtualInputManager"):SendKeyEvent(false, k, false, nil)
end

local function r()
	game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum["KeyCode"]["A"], false, nil)
	game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum["KeyCode"]["D"], false, nil)
end

local function adadad()
	while adingrunning do
		k(Enum["KeyCode"]["A"]) if not adingrunning then break end task.wait()
		k(Enum["KeyCode"]["D"]) if not adingrunning then break end task.wait()
	end
end

-------------------------------------------------------------------------------------------------------------------------------

game["UserInputService"]["InputBegan"]:Connect(function(input, processed)
	if processed then return end
	if input["KeyCode"] == Enum["KeyCode"]["R"] and not debounce then
		debounce = true
		
		adingrunning = not adingrunning
		if adingtask then task.cancel(adingtask) adingtask = nil r() end
		if adingrunning then adingtask = task.spawn(adadad) end
		
		debounce = false
	end
end)

-------------------------------------------------------------------------------------------------------------------------------
