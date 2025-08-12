local Players = game:GetService("Players")
local PathfindingService = game:GetService("PathfindingService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Dance animations
local dances = {
    "rbxassetid://182491037",
    "rbxassetid://182491277",
    "rbxassetid://182491368"
}

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 50)
toggleButton.Position = UDim2.new(0.5, -60, 0.5, 0)
toggleButton.Text = "Idle Bot OFF"
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Parent = screenGui
toggleButton.Active = true
toggleButton.Draggable = true

-- State
local enabled = false
local spinning = false
local currentAnimTrack
local stopLoop = false
local spinConnection

local function stopEverything()
    stopLoop = true
    spinning = false
    if spinConnection then
        spinConnection:Disconnect()
        spinConnection = nil
    end
    if currentAnimTrack then
        currentAnimTrack:Stop()
        currentAnimTrack = nil
    end
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Orientation = Vector3.new(0, hrp.Orientation.Y, 0)
    end
end

local function playRandomDance()
    if not LocalPlayer.Character then return end
    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if currentAnimTrack then
            currentAnimTrack:Stop()
        end
        local anim = Instance.new("Animation")
        anim.AnimationId = dances[math.random(#dances)]
        currentAnimTrack = humanoid:LoadAnimation(anim)
        currentAnimTrack.Priority = Enum.AnimationPriority.Action
        currentAnimTrack:AdjustWeight(999)
        currentAnimTrack:Play()
    end
end

local function spinCharacter()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if spinConnection then
        spinConnection:Disconnect()
    end
    
    spinning = true
    spinConnection = RunService.Heartbeat:Connect(function(dt)
        if spinning then
            -- Slower spin speed (90 degrees per second instead of 180)
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(100 * dt), 0)
        end
    end)
end

local function getRandomPosition(character)
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    -- Get a completely random direction and distance
    local angle = math.random() * 2 * math.pi
    local distance = math.random(6, 26) -- Walk 10-30 studs away
    local offset = Vector3.new(math.cos(angle) * distance, 0, math.sin(angle) * distance)
    
    -- Raycast to ensure we're not walking into walls
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local raycastResult = workspace:Raycast(hrp.Position, offset, raycastParams)
    if raycastResult then
        -- If we hit something, walk to the hit position minus a small buffer
        return raycastResult.Position - offset.Unit * 2
    end
    
    return hrp.Position + offset
end

local function walkToRandomPoint()
    spinning = false
    if currentAnimTrack then
        currentAnimTrack:Stop()
    end

    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp then return end

    -- Walk in 3 different directions
    for i = 1, math.random(4, 8) do
        if not enabled or stopLoop then break end

        local targetPos = getRandomPosition(character)
        if not targetPos then return end

        local path = PathfindingService:CreatePath()
        path:ComputeAsync(hrp.Position, targetPos)
        
        if path.Status == Enum.PathStatus.Success then
            local waypoints = path:GetWaypoints()
            for _, waypoint in ipairs(waypoints) do
                if not enabled or stopLoop then break end
                humanoid:MoveTo(waypoint.Position)
                if waypoint.Action == Enum.PathWaypointAction.Jump then
                    humanoid.Jump = true
                end
                humanoid.MoveToFinished:Wait()
            end
        end
    end
end

local function idleBotLoop()
    stopLoop = false
    while enabled and not stopLoop do
        spinCharacter()
        playRandomDance()
        task.wait(math.random(5, 10)) -- Idle time
        if not enabled or stopLoop then break end
        walkToRandomPoint()
    end
end

toggleButton.MouseButton1Click:Connect(function()
    enabled = not enabled
    toggleButton.Text = enabled and "Idle Bot ON" or "Idle Bot OFF"
    if enabled then
        task.spawn(idleBotLoop)
    else
        stopEverything()
    end
end)