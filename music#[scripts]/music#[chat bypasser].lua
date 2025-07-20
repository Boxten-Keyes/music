local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
cloneref = cloneref or function(o) return o end
local COREGUI = cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
local LocalPlayer = Players.LocalPlayer
local guiName = "NOT BETTER"

if COREGUI:FindFirstChild(guiName) then
    return
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = guiName
screenGui.Parent = COREGUI

local function bypassEncode(str)
	local INV = {"\u{FE2D}", "\u{FE2B}", "\u{FE2D}"}
	local map = {["0"]="０",["1"]="１",["2"]="２",["3"]="３",["4"]="４",["5"]="５",["6"]="６",["7"]="７",["8"]="８",["9"]="９",[" "]="\b"}
	local function r() return INV[math.random(#INV)] end
	return str:gsub(".", function(c)
		if c:match("%a") then return r()..c..r()
		  elseif map[c] then return map[c]
		  else return c end end) end

local function splitByDelimiter(str, delim)
	local result = {}
	for word in string.gmatch(str, "([^"..delim.."]+)") do
		table.insert(result, word)
	end
	return result
end

local function splitByBypassedChunks(bypassed, maxLen)
	local parts, current = {}, ""
	local words = splitByDelimiter(bypassed, "\b")
	for _, word in ipairs(words) do
	local next = current ~= "" and current.."\b"..word or word
		if #next > maxLen then
			if current ~= "" then table.insert(parts, current) end
			current = word
		else
			current = next
		  end end
	if current ~= "" then table.insert(parts, current) end
	return parts
  end

local CachedChannels = {}

local function sendBypassedMessage(message, recipient)
	local firstChar = message:sub(1, 1)
	local skipEncoding = firstChar == "/" or firstChar == "-" or firstChar == ";" or firstChar == ":" or firstChar == "!"

	local finalMessages = {}

	if skipEncoding then
		table.insert(finalMessages, message) 
	else
		local prefix, suffix = "\u{05BE}>ˑ\u{0008}", "ˑ\u{0008}"
		local bypassed = bypassEncode(message):gsub(" ", "\b")
		local chunks = splitByBypassedChunks(bypassed, 140)
		for _, chunk in ipairs(chunks) do
			table.insert(finalMessages, prefix .. chunk .. suffix)
		end
	end

	for _, final in ipairs(finalMessages) do
		local channel = nil

		if recipient and recipient ~= "All" then
			channel = CachedChannels[recipient]
			if not channel or not channel:IsDescendantOf(TextChatService)
				or not channel:FindFirstChild(recipient)
				or not channel:FindFirstChild(LocalPlayer.Name) then
				CachedChannels[recipient] = nil
				channel = nil
			end
			if not channel then
				for _, ch in pairs(TextChatService.TextChannels:GetChildren()) do
					if ch.Name:find("RBXWhisper:") and ch:FindFirstChild(recipient) then
						channel = ch
						CachedChannels[recipient] = ch
						break
					end end end end

		if not channel then
			channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
				or TextChatService.TextChannels:FindFirstChild("General")
		end

		if channel then
			channel:SendAsync(final)
		else
			local ev = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
			if ev then
				local say = ev:FindFirstChild("SayMessageRequest")
				if say then say:FireServer(final, "All") end
			end 
        end
		task.wait(0.3)
	end 
end

local function Match(str, pattern)
	return string.match(str, pattern)
end

local function getTargetName(targetChip)
	if targetChip and targetChip:IsA("TextButton") then
		local displayName = Match(targetChip.Text or "", "^%[To%s+(.-)%]$")
		if displayName and displayName ~= "" then
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr.DisplayName:lower() == displayName:lower() then
					return plr.Name
	  			end 
            end 
        end 
    end
    return "All"
end


task.spawn(function()
	repeat task.wait() until COREGUI:FindFirstChild("ExperienceChat")
	local experienceChat = COREGUI:WaitForChild("ExperienceChat")
	local appLayout = experienceChat:FindFirstChild("appLayout")
	if not appLayout then return end

	local chatInputBar = appLayout:FindFirstChild("chatInputBar")
	if not chatInputBar then return end

	local background = chatInputBar:FindFirstChild("Background")
	if not background then return end

	local container = background:FindFirstChild("Container")
	if not container then return end

	local textContainer = container:FindFirstChild("TextContainer")
	local textBoxContainer = textContainer and textContainer:FindFirstChild("TextBoxContainer")
	local chatBox = textBoxContainer and textBoxContainer:FindFirstChild("TextBox")
	local sendButton = container:FindFirstChild("SendButton")
	local targetChip = textContainer and textContainer:FindFirstChild("TargetChannelChip")

	
	if chatBox then
		chatBox.FocusLost:Connect(function(enterPressed)
		if enterPressed and chatBox.Text ~= "" then
		local msg = chatBox.Text
		local recipient = getTargetName(targetChip)
		chatBox.Text = ""
        local lowered = msg:lower()
		task.defer(function()
		     sendBypassedMessage(lowered, recipient)
		end)
    end 
    end) 
    end

	if sendButton then
	sendButton:Destroy()
end
end)
