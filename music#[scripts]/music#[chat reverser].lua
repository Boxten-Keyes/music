local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

-- GUI presence check
if CoreGui:FindFirstChild("ReverseChatGui") then return end

-- Reversal utility
local function reverseString(str)
	return string.reverse(str)
end

-- Get target recipient (for whisper)
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

-- Message sender (reversed)
local function sendReversedMessage(message, recipient)
	local reversed = reverseString(message)
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
		channel:SendAsync(reversed)
	else
		-- Fallback to legacy system
		local ev = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
		if ev then
			local say = ev:FindFirstChild("SayMessageRequest")
			if say then
				say:FireServer(reversed, "All")
			end
		end
	end
end

-- Hook chat bar
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
					sendReversedMessage(msg, recipient)
				end)
			end
		end)
	end
end)
