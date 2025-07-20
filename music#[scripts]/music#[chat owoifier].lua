function owoify(text)
	local substitutions = {
		["r"] = "w",
		["l"] = "w",
		["R"] = "W",
		["L"] = "W",
		["no"] = "nyo",
		["No"] = "Nyo",
		["mo"] = "myo",
		["na"] = "nya",
		["ove"] = "uv",
		["th"] = "d",
	}

	for k, v in pairs(substitutions) do
		text = text:gsub(k, v)
	end

	local suffixes = { " owo", " UwU", " >w<", " ^w^", " rawr~", " nya~" }
	if math.random() < 0.5 then
		text = text .. suffixes[math.random(1, #suffixes)]
	end

	return text
end

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

if CoreGui:FindFirstChild("ReverseChatGui") then return end

local function getTargetName(targetChip)
	if targetChip and targetChip:IsA("TextButton") then
		local displayName = string.match(targetChip.Text or "", "^%[To%s+(.-)%]$")
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

local function send(message, recipient)
	local owoified = owoify(message)
	local channel = nil

	if recipient and recipient ~= "All" then
		for _, ch in pairs(TextChatService.TextChannels:GetChildren()) do
			if ch.Name:find("RBXWhisper:") and ch:FindFirstChild(recipient) then
				channel = ch
				break
			end
		end
	end

	if not channel then
		channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
			or TextChatService.TextChannels:FindFirstChild("General")
	end

	if channel then
		channel:SendAsync(owoified)
	else
		local ev = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
		if ev then
			local say = ev:FindFirstChild("SayMessageRequest")
			if say then
				say:FireServer(owoified, "All")
			end
		end
	end
end

task.spawn(function()
	repeat task.wait() until CoreGui:FindFirstChild("ExperienceChat")

	local experienceChat = CoreGui:WaitForChild("ExperienceChat")
	local chatInputBar = experienceChat:WaitForChild("appLayout"):WaitForChild("chatInputBar")
	local background = chatInputBar:WaitForChild("Background")
	local container = background:WaitForChild("Container")
	local textContainer = container:WaitForChild("TextContainer")
	local textBoxContainer = textContainer:WaitForChild("TextBoxContainer")
	local chatBox = textBoxContainer:WaitForChild("TextBox")
	local targetChip = textContainer:FindFirstChild("TargetChannelChip")

	if chatBox then
		chatBox.FocusLost:Connect(function(enterPressed)
			if enterPressed and chatBox.Text ~= "" then
				local msg = chatBox.Text
				local recipient = getTargetName(targetChip)
				chatBox.Text = ""
				task.defer(function()
					send(msg, recipient)
				end)
			end
		end)
	end
end)
