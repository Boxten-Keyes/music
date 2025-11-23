loadstring(game:HttpGet("https://scriptblox.com/raw/UPD-Blade-Ball-op-autoparry-with-visualizer-8652"))()

function missing(t, f, fb) if type(f) == t then return f end return fb end cloneref = missing("function", cloneref, function(...) return ... end)

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local VirtualInputManager = cloneref(game:GetService("VirtualInputManager"))

local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Cooldown = tick()
local Parried = false
local Connection = nil

local holding = false

-- Movement variables
local TARGET_POSITION = Vector3.new(-280, 124, 152)
local TARGET_RADIUS = 100
local WALL_AVOIDANCE_DISTANCE = 20
local lastMovementChange = tick()
local currentMovementPattern = 1
local movementKeys = {"W", "A", "S", "D", "Space"}
local circlePatterns = {
    {"W", "D"}, -- Forward + Right
    {"S", "D"}, -- Back + Right  
    {"S", "A"}, -- Back + Left
    {"W", "A"}  -- Forward + Left
}
local activeKeys = {}

local function pressButton(guiButton)
    local pos = guiButton.AbsolutePosition
    local size = guiButton.AbsoluteSize

    local x = pos.X + size.X/2
    local y = pos.Y + size.Y/2

    VirtualInputManager:SendTouchEvent(1, x, y, true, game)
end

local function releaseButton(guiButton)
    if not holding then return end
    holding = false

    local absPos = guiButton.AbsolutePosition
    local absSize = guiButton.AbsoluteSize
    local x = absPos.X + absSize.X/2
    local y = absPos.Y + absSize.Y/2

    VirtualInputManager:SendTouchEvent(1, x, y, false, game)
end

local function GetBall()
    for _, Ball in ipairs(workspace.Balls:GetChildren()) do
        if Ball:GetAttribute("realBall") then
            return Ball
        end
    end
end

local function ResetConnection()
    if Connection then
        Connection:Disconnect()
        Connection = nil
    end
end

local function isNearWall(character, distance)
    if not character then return false end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    
    -- Simple raycast check in 4 directions
    local directions = {
        Vector3.new(1, 0, 0),   -- Right
        Vector3.new(-1, 0, 0),  -- Left
        Vector3.new(0, 0, 1),   -- Forward
        Vector3.new(0, 0, -1)   -- Backward
    }
    
    for _, dir in ipairs(directions) do
        local ray = Ray.new(hrp.Position, dir * distance)
        local hit = workspace:FindPartOnRayWithIgnoreList(ray, {character})
        if hit and hit.CanCollide then
            return true
        end
    end
    
    return false
end

local function releaseAllKeys()
    for key, _ in pairs(activeKeys) do
        VirtualInputManager:SendKeyEvent(false, key, false, game)
        activeKeys[key] = nil
    end
end

local function pressKey(key)
    if not activeKeys[key] then
        VirtualInputManager:SendKeyEvent(true, key, false, game)
        activeKeys[key] = true
    end
end

local function moveSporadically()
    -- Change movement pattern randomly every 0.5-1.5 seconds
    if tick() - lastMovementChange > math.random(5, 15) / 10 then
        releaseAllKeys()
        lastMovementChange = tick()
        
        -- Randomly press 1-3 keys
        local keysToPress = math.random(1, 3)
        local availableKeys = {"W", "A", "S", "D"}
        
        for i = 1, keysToPress do
            if #availableKeys > 0 then
                local randomIndex = math.random(1, #availableKeys)
                local key = availableKeys[randomIndex]
                table.remove(availableKeys, randomIndex)
                pressKey(key)
            end
        end
        
        -- Randomly jump occasionally (20% chance)
        if math.random(1, 5) == 1 then
            pressKey("Space")
        end
    end
end

local function moveInCircle()
    -- Change circle pattern every 0.8 seconds
    if tick() - lastMovementChange > 0.8 then
        releaseAllKeys()
        lastMovementChange = tick()
        currentMovementPattern = (currentMovementPattern % #circlePatterns) + 1
        
        local pattern = circlePatterns[currentMovementPattern]
        for _, key in ipairs(pattern) do
            pressKey(key)
        end
    end
end

-- Movement loop
RunService.Heartbeat:Connect(function()
    local character = Player.Character
    local hrp = character and character:FindFirstChild("HumanoidRootPart")
    
    if not character or not hrp then 
        releaseAllKeys()
        return 
    end
    
    local distanceToTarget = (hrp.Position - TARGET_POSITION).Magnitude
    local nearWall = isNearWall(character, WALL_AVOIDANCE_DISTANCE)
    
    -- If near a wall, move away by pressing opposite keys
    if nearWall then
        releaseAllKeys()
        -- Simple wall avoidance - press keys away from walls
        pressKey("W") -- Always try to move forward when near wall
        if math.random(1, 2) == 1 then
            pressKey("A")
        else
            pressKey("D")
        end
        return
    end
    
    -- Main movement logic
    if distanceToTarget > TARGET_RADIUS then
        moveSporadically()
    else
        moveInCircle()
    end
end)

workspace.Balls.ChildAdded:Connect(function()
    local Ball = GetBall()
    if not Ball then return end
    ResetConnection()
    Connection = Ball:GetAttributeChangedSignal("target"):Connect(function()
        Parried = false
    end)
end)

RunService.PreSimulation:Connect(function()
    local Ball = GetBall()
    local Character = Player.Character
    local HRP = Character and Character:FindFirstChild("HumanoidRootPart")

    if not Ball or not HRP then return end

    local Speed = Ball.zoomies.VectorVelocity.Magnitude
    local Distance = (HRP.Position - Ball.Position).Magnitude

    if Ball:GetAttribute("target") == Player.Name and not Parried then
        if Distance / Speed <= 0.55 then
            local blockButton = Player:WaitForChild("PlayerGui"):FindFirstChild("Hotbar")
            blockButton = blockButton and blockButton:FindFirstChild("Block")

            if blockButton and blockButton:IsA("GuiButton") then
                pressButton(blockButton)
                releaseButton(blockButton)
            end

            Parried = true
            Cooldown = tick()
    
            task.delay(1, function()
                Parried = false
            end)
        end
    end
end)

-- Cleanup when player leaves
Players.PlayerRemoving:Connect(function(player)
    if player == Player then
        releaseAllKeys()
        ResetConnection()
    end
end)
