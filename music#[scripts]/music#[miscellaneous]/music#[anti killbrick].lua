---------------------------------------------------------------------------------------------------------------------------

if not game:IsLoaded() then game["Loaded"]:Wait() end

-------------------------------------------------------------------------------------------------------------------------------

function iskillbrick(part)
    if not part:IsA("BasePart") then return false end

    local namelower = part["Name"]:lower()
    if namelower:find("kill") or namelower:find("lava") then
        return true
    end

    for _, descendant in ipairs(part:GetDescendants()) do
        if descendant:IsA("Script") or descendant:IsA("LocalScript") then
            local source = nil
            pcall(function() source = descendant["Source"] end)
            if source and (source:lower():find("humanoid") and source:lower():find("health")) then
                return true
            end
        end
    end

    return false
end

function disablekillbrick(part)
    part["CanTouch"] = false
    part["CanCollide"] = false
    part["Transparency"] = 0.5
    part["Material"] = Enum.Material.Neon
    part["BrickColor"] = BrickColor.new("Really black")

    for _, scriptobj in ipairs(part:GetDescendants()) do
        if scriptobj:IsA("Script") or scriptobj:IsA("LocalScript") then
            scriptobj:Destroy()
        end
    end

    if getconnections then
        for _, conn in ipairs(getconnections(part["Touched"])) do
            conn:Disable()
        end
    end
end

game:GetService("RunService")["RenderStepped"]:Connect(function()
    for _, part in ipairs(workspace:GetDescendants()) do
        if iskillbrick(part) then
            disablekillbrick(part)
        end
    end
end)

---------------------------------------------------------------------------------------------------------------------------