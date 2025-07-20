--[[---------------------------------------------------------------------------------------------------------------------------
  ______     ______   ______     __   __     ______     __    
 /\  __ \   /\  __ \ /\  ___\   /\ "-.\ \   /\  __ \   /\ \   
 \ \ \/\ \  \ \  __/ \ \  __\   \ \ \-.  \  \ \  __ \  \ \ \  
  \ \_____\  \ \_\    \ \_____\  \ \_\\"\_\  \ \_\ \_\  \ \_\ 
   \/_____/   \/_/     \/_____/   \/_/ \/_/   \/_/\/_/   \/_/ 
                                                                                                       
   Made by ChatGPT - Player camlock
   
---------------------------------------------------------------------------------------------------------------------------]]--

task.wait(0.1)

-------------------------------------------------------------------------------------------------------------------------------

function prang()
	local s = Instance.new("Sound")
	s.SoundId = "rbxassetid://8426701399"
	s.Parent = game:GetService("SoundService")
	s:Play()
	s.Ended:Connect(function() s:Destroy() end)
end

function notify(te, tt, d)
	task.spawn(function() task.spawn(prang) game:GetService("StarterGui"):SetCore("SendNotification", {Title = te, Text = tt, Duration = d}) end)
end

task.spawn(function() notify("player camlock | symphysis", "made by chatgpt. enjoy!", 4) end)

-------------------------------------------------------------------------------------------------------------------------------

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local toggle = false
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 140, 0, 40)
button.Position = UDim2.new(0, 20, 0, 80)
button.Text = "Toggle Player Camlock"
button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
button.TextColor3 = Color3.new(1, 1, 1)
button.TextSize = 14
button.Font = Enum.Font.GothamSemibold
button.Draggable = true
button.Active = true
button.Selectable = true

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CamlockGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = gethui and gethui() or game["CoreGui"]
button.Parent = screenGui

local function getClosestVisibleEnemyPart()
    local closest = nil
    local minDist = math.huge
    local screenCenter = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Team ~= player.Team and p.Character and not p.Character:IsDescendantOf(camera) then
            local char = p.Character
            local head = char:FindFirstChild("Head")
            local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
            local humanoid = char:FindFirstChildOfClass("Humanoid")

            if head and torso and humanoid and humanoid.Health > 0 then
                -- Decide whether to target head or torso
                local targetPart = math.random() < 0.3 and head or torso

                -- Check visibility
                local camLook = camera.CFrame.LookVector
                local toTarget = (targetPart.Position - camera.CFrame.Position).Unit
                if camLook:Dot(toTarget) > 0.5 then
                    local screenPos, onScreen = camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local screenPoint = Vector2.new(screenPos.X, screenPos.Y)
                        local distFromCenter = (screenPoint - screenCenter).Magnitude
                        if distFromCenter <= 200 then
                            local rayDir = (targetPart.Position - camera.CFrame.Position)
                            local ray = Ray.new(camera.CFrame.Position, rayDir.Unit * rayDir.Magnitude)
                            local hit = workspace:FindPartOnRayWithIgnoreList(ray, {player.Character, camera})
                            if hit and hit:IsDescendantOf(char) then
                                if distFromCenter < minDist then
                                    minDist = distFromCenter
                                    closest = targetPart
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return closest
end

RunService.RenderStepped:Connect(function()
	if toggle then
    local target = getClosestVisibleEnemyPart()
		if target then
			local camPos = camera.CFrame.Position
			local newLookVector = (target.Position - camPos).Unit
			local newCF = CFrame.new(camPos, camPos + newLookVector)

			-- InOutQuad easing
			local alpha = 0.3
			local easedAlpha
			if alpha < 0.5 then
				easedAlpha = 2 * alpha * alpha
			else
				easedAlpha = -1 + (4 - 2 * alpha) * alpha
			end

			camera.CFrame = camera.CFrame:Lerp(newCF, easedAlpha)
		end
	end
end)

button.MouseButton1Click:Connect(function()
    toggle = not toggle
    button.Text = toggle and "Camlock: ON" or "Camlock: OFF"
    button.BackgroundColor3 = toggle and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(40, 40, 40)
end)

-------------------------------------------------------------------------------------------------------------------------------
