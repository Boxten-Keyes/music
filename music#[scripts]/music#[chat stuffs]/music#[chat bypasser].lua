-------------------------------------------------------------------------------------------------------------------------------

-- made by gazer / GazerHa
if not game:IsLoaded() then game["Loaded"]:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

local players = game:GetService("Players")
local textchatservice = game:GetService("TextChatService")
local replicatedstorage = game:GetService("ReplicatedStorage")
cloneref = cloneref or function(o) return o end
local coregui = cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui") or game["Players"]["LocalPlayer"]:WaitForChild("PlayerGui")
local localplayer = players["LocalPlayer"]

-------------------------------------------------------------------------------------------------------------------------------

local function bypassencode(str)
	local inv = {"\u{FE2D}", "\u{FE2B}", "\u{FE2D}"}
	local map = {["0"]="０",["1"]="１",["2"]="２",["3"]="３",["4"]="４",["5"]="５",["6"]="６",["7"]="７",["8"]="８",["9"]="９",[" "]="\b"}
	local function r() return inv[math.random(#inv)] end
	return str:gsub(".", function(c)
		if c:match("%a") then return r()..c..r()
		elseif map[c] then return map[c]
		else return c end end)
end

-------------------------------------------------------------------------------------------------------------------------------

local function splitbydelimiter(str, delim)
	local result = {}
	for word in string.gmatch(str, "([^"..delim.."]+)") do
		table.insert(result, word)
	end
	return result
end

local function splitbybypassedchunks(bypassed, maxlen)
	local parts, current = {}, ""
	local words = splitbydelimiter(bypassed, "\b")
	for _, word in ipairs(words) do
		local next = current ~= "" and current.."\b"..word or word
		if #next > maxlen then
			if current ~= "" then table.insert(parts, current) end
			current = word
		else
			current = next
		end end
	if current ~= "" then table.insert(parts, current) end
	return parts
end

-------------------------------------------------------------------------------------------------------------------------------

local cachedchannels = {}

local function sendbypassedmessage(message, recipient)
	local firstchar = message:sub(1, 1)
	local skipencoding = firstchar == "/" or firstchar == "-" or firstchar == ";" or firstchar == ":" or firstchar == "!"

	local finalmessages = {}

	if skipencoding then
		table.insert(finalmessages, message) 
	else
		local prefix, suffix = "\u{05BE}>ˑ\u{0008}", "ˑ\u{0008}"
		local bypassed = bypassencode(message):gsub(" ", "\b")
		local chunks = splitbybypassedchunks(bypassed, 140)
		for _, chunk in ipairs(chunks) do
			table.insert(finalmessages, prefix .. chunk .. suffix)
		end
	end

	for _, final in ipairs(finalmessages) do
		local channel = nil

		if recipient and recipient ~= "All" then
			channel = cachedchannels[recipient]
			if not channel or not channel:IsDescendantOf(textchatservice)
				or not channel:FindFirstChild(recipient)
				or not channel:FindFirstChild(localplayer["Name"]) then
				cachedchannels[recipient] = nil
				channel = nil
			end
			if not channel then
				for _, ch in pairs(textchatservice["TextChannels"]:GetChildren()) do
					if ch["Name"]:find("RBXWhisper:") and ch:FindFirstChild(recipient) then
						channel = ch
						cachedchannels[recipient] = ch
						break
					end end end end

		if not channel then
			channel = textchatservice["TextChannels"]:FindFirstChild("RBXGeneral")
				or textchatservice["TextChannels"]:FindFirstChild("General")
		end

		if channel then
			channel:SendAsync(final)
		else
			local ev = replicatedstorage:FindFirstChild("DefaultChatSystemChatEvents")
			if ev then
				local say = ev:FindFirstChild("SayMessageRequest")
				if say then say:FireServer(final, "All") end
			end 
		end
		task.wait(0.3)
	end 
end

-------------------------------------------------------------------------------------------------------------------------------

local function match(str, pattern)
	return string.match(str, pattern)
end

local function gettargetname(targetchip)
	if targetchip and targetchip:IsA("TextButton") then
		local displayname = match(targetchip["Text"] or "", "^%[To%s+(.-)%]$")
		if displayname and displayname ~= "" then
			for _, plr in ipairs(players:GetPlayers()) do
				if plr["DisplayName"]:lower() == displayname:lower() then
					return plr["Name"]
				end 
			end 
		end 
	end
	return "All"
end

-------------------------------------------------------------------------------------------------------------------------------

task.spawn(function()
	repeat task.wait() until coregui:FindFirstChild("ExperienceChat")
	local experiencechat = coregui:WaitForChild("ExperienceChat")
	local applayout = experiencechat:FindFirstChild("appLayout")
	if not applayout then return end

	local chatinputbar = applayout:FindFirstChild("chatInputBar")
	if not chatinputbar then return end

	local background = chatinputbar:FindFirstChild("Background")
	if not background then return end

	local container = background:FindFirstChild("Container")
	if not container then return end

	local textcontainer = container:FindFirstChild("TextContainer")
	local textboxcontainer = textcontainer and textcontainer:FindFirstChild("TextBoxContainer")
	local chatbox = textboxcontainer and textboxcontainer:FindFirstChild("TextBox")
	local sendbutton = container:FindFirstChild("SendButton")
	local targetchip = textcontainer and textcontainer:FindFirstChild("TargetChannelChip")

	if chatbox then
		chatbox["FocusLost"]:Connect(function(enterpressed)
			if enterpressed and chatbox["Text"] ~= "" then
				local msg = chatbox["Text"]
				local recipient = gettargetname(targetchip)
				chatbox["Text"] = ""
				local lowered = msg:lower()
				task.defer(function()
					sendbypassedmessage(lowered, recipient)
				end)
			end 
		end) 
	end
end)

-------------------------------------------------------------------------------------------------------------------------------
