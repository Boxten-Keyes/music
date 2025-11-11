-------------------------------------------------------------------------------------------------------------------------------

if not game:IsLoaded() then game.Loaded:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

local plr = game:GetService("Players")
local rs = game:GetService("RunService")
local cgui = game:GetService("CoreGui")
local thresh = 4000 -- enable and then re-disable 3D rendering when memory exceeds this threshold

-------------------------------------------------------------------------------------------------------------------------------

local enabled = false
local connection

local function taml(state)
	enabled = state

	if not enabled then
		rs:Set3dRenderingEnabled(true)
		if connection then
			connection:Disconnect()
			connection = nil
		end
		return
	else
		RunService:Set3dRenderingEnabled(false)
	end

	local ps = cgui:WaitForChild("RobloxGui"):WaitForChild("PerformanceStats")

	for _, b in pairs(ps:GetDescendants()) do
		if b:IsA("TextButton") and b.Name == "PS_Button" then
			local tp = b:FindFirstChild("StatsMiniTextPanelClass")
			local tl = tp and tp:FindFirstChild("TitleLabel")
			if tl and string.find(tl.Text:lower(), "mem") then
				local v = tp:FindFirstChild("ValueLabel")
				if v then
					connection = v:GetPropertyChangedSignal("Text"):Connect(function()
						if not enabled or not v or not v.Parent then return end
						local memValue = tonumber(v.Text:match("%d+%.?%d*"))
						if memValue and memValue > thresh then
							rs:Set3dRenderingEnabled(true)
							task.delay(1, function()
								rs:Set3dRenderingEnabled(false)
							end)
						end
					end)
				end
				break
			end
		end
	end
end

-------------------------------------------------------------------------------------------------------------------------------

function clk() 
	task.spawn(function()
		local s = Instance.new("Sound") 
		s.SoundId = "rbxassetid://87152549167464"
		s.Parent = workspace
		s.Volume = 1.2 
		s.TimePosition = 0.1 
		s:Play() 
	end)
end

local function rp(ui, r, c, tr, tc)
	local bw = 90
	local bh = 55
	local sp = 10

	local tw = (bw * tc) + (sp * (tc - 1))
	local th = (bh * tr) + (sp * (tr - 1))

	local sw, sh = cam.ViewportSize.X, cam.ViewportSize.Y
	local sx = (sw - tw) / 2
	local sy = (sh - th) / 2 - 56

	local x = sx + (c - 1) * (bw + sp)
	local y = sy + (r - 1) * (bh + sp)

	ui.Position = UDim2.new(0, x, 0, y)
end

local sg = Instance.new("ScreenGui")
sg.ResetOnSpawn = false
sg.Parent = gethui() or cgui
if sg.Parent:FindFirstChild("Stupid Rushed Script") then sg.Parent:FindFirstChild("skidded from ksu"):Destroy() end
sg.Name = "skidded from ksu"

local function mtg(kb, k, t, is, cb, r, c, tr, tc)
	local tg = is or false

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 90, 0, 55)
	btn.TextStrokeTransparency = 1
	rp(btn, r, c, tr, tc)
	btn.BackgroundTransparency = 0.3
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	btn.Font = Enum.Font.Code
	btn.BorderSizePixel = 0
	btn.TextSize = 13
	btn.TextXAlignment = Enum.TextXAlignment.Center
	btn.TextYAlignment = Enum.TextYAlignment.Center
	btn.Active = true
	btn.Draggable = true
	btn.TextWrapped = true
	btn.Text = t
	btn.Parent = sg

	local strk = Instance.new("UIStroke")
	strk.Thickness = 1
	strk.Color = Color3.new(1, 1, 1)
	strk.Parent = btn
	strk.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local function uv()
		if tg then
			btn.TextColor3 = Color3.fromRGB(0, 255, 0)
			strk.Color = Color3.fromRGB(0, 255, 0)
		else
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			strk.Color = Color3.fromRGB(255, 255, 255)
		end
	end

	uv()

	local function tbtn()
		clk()
		tg = not tg
		uv()
		if cb then cb(tg) end
	end

	btn.MouseButton1Click:Connect(tbtn)

	if kb and k then
		game["UserInputService"].InputBegan:Connect(function(i, gp)
			if gp then return end
			if i.UserInputType == Enum.UserInputType.Keyboard and i.KeyCode == Enum.KeyCode[k] then
				tbtn()
			end
		end)
	end

	return btn
end

-------------------------------------------------------------------------------------------------------------------------------

local btns = {
	{kb = false, k = nil, typ = "tg", t = "Toggle Anti Memory Leak", cb = function(s) taml(s) end}
}

-------------------------------------------------------------------------------------------------------------------------------

local mc = 5
local mbpc = 8
local tb = #btns

local cols = math.min(mbpc, math.ceil(tb / mc))
local rows = math.ceil(tb / cols)

local bi = 1
for col = 1, cols do
	for row = 1, rows do
		if bi > tb then break end

		local bd = btns[bi]
		if bd.typ == "tg" then
			mtg(bd.kb, bd.k, bd.t, false, bd.cb, row, col, rows, cols)
		end

		bi = bi + 1
	end
end

-------------------------------------------------------------------------------------------------------------------------------
