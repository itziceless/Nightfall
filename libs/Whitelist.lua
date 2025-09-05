cloneref = cloneref or function(o)
    return o
end

local sv = function(n)
    return cloneref(game:GetService(n))
end

local plrs = sv("Players")
local http = sv("HttpService")
local chat = sv("TextChatService")
local lighting = sv("Lighting")
local coreGui = sv("CoreGui")

-- Fake admin list
local raw = [[
{
    "adminList": {
        "1": "cool guy",
        "2": "useless idiot",
        "3": "very very cool guy"
    }
}
]]

local data = http:JSONDecode(raw)
local tags = {}

local colors = {
    ["cool guy"] = "#ff0000ff",
    ["useless idiot"] = "#0000eeff",
    ["very very cool guy"] = "#ff00aeff"
}

local function tag(u, t, c)
    tags[u] = {txt = t, col = c}
end

-- Prefix/tag system
chat.OnIncomingMessage = function(msg: TextChatMessage)
    local p = Instance.new("TextChatMessageProperties")
    if msg.TextSource then
        local plr = plrs:GetPlayerByUserId(msg.TextSource.UserId)
        if plr and tags[plr.Name] then
            local d = tags[plr.Name]
            p.PrefixText = "<font color='" .. d.col .. "'>[" .. d.txt .. "]</font> " .. msg.PrefixText
        end
    end
    return p
end

-- Helper to get player by name
local function getPlayerByName(name)
    for _, p in ipairs(plrs:GetPlayers()) do
        if p.Name:lower():find(name:lower()) then
            return p
        end
    end
    return nil
end

-- Command table
local commands = {
    kill = function(target)
        if target.Character then target.Character:BreakJoints() end
    end,

    kick = function(target, _, args)
        if target then
            local reason = table.concat(args, " ")
            target:Kick("👤 Kicked by admin\n💬 " .. (reason ~= "" and reason or "no reason"))
        end
    end,

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
        local targetHRP = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        local adminHRP = admin.Character and admin.Character:FindFirstChild("HumanoidRootPart")
        if targetHRP and adminHRP then
            targetHRP.CFrame = adminHRP.CFrame + Vector3.new(2,0,0)
        end
    end,

    goto = function(target, admin)
        local targetHRP = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        local adminHRP = admin.Character and admin.Character:FindFirstChild("HumanoidRootPart")
        if targetHRP and adminHRP then
            adminHRP.CFrame = targetHRP.CFrame + Vector3.new(2,0,0)
        end
    end,

    speed = function(target, _, args)
        local hum = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
        local num = tonumber(args[1])
        if hum and num then hum.WalkSpeed = num end
    end,

    jump = function(target, _, args)
        local hum = target.Character and target.Character:FindFirstChildOfClass("Humanoid")
        local num = tonumber(args[1])
        if hum and num then hum.JumpPower = num end
    end,

    fling = function(target)
        local hrp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.Velocity = Vector3.new(0,500,0) + Vector3.new(math.random(-200,200),0,math.random(-200,200))
        end
    end,

    trip = function(target)
        if target.Character then
            local hum = target.Character:FindFirstChildOfClass("Humanoid")
            local hrp = target.Character:FindFirstChild("HumanoidRootPart")
            if hum and hrp then
                hrp.Velocity = hrp.CFrame.LookVector * 15
                hum:ChangeState(Enum.HumanoidStateType.FallingDown)
            end
        end
    end,

    blind = function(target)
        if target == plrs.LocalPlayer then
            local gui = Instance.new("ScreenGui")
            gui.Name = "BlindGUI"
            gui.IgnoreGuiInset = true
            gui.Parent = coreGui

            local blurFrame = Instance.new("Frame")
            blurFrame.Size = UDim2.fromScale(1,1)
            blurFrame.BackgroundColor3 = Color3.new(0,0,0)
            blurFrame.BackgroundTransparency = 0
            blurFrame.Parent = gui
        end
    end,

    crash = function(target)
    if target == plrs.LocalPlayer then
        task.spawn(function()
            repeat
                local part = Instance.new("Part")
                part.Size = Vector3.new(1e10, 1e10, 1e10)
                part.Parent = workspace
            until false
        end)
    end
end,

shutdown = function(target)
    if target == plrs.LocalPlayer then
        game:Shutdown()
    end
end,

    help = function(_, _, _)
        local cmdList = {}
        for k,_ in pairs(commands) do
            table.insert(cmdList, "!"..k)
        end
        local msg = "Available commands: " .. table.concat(cmdList, ", ")
        print(msg)
        local textChannel = chat:GetTextChannels()[1]
        if textChannel then
            textChannel:SendAsync(msg)
        end
    end,
}

-- Admin setup
local function addAdmin(p, role)
    tag(p.Name, role, colors[role] or "#07fc03")

    p.Chatted:Connect(function(msg)
        if not data.adminList[plrs.LocalPlayer.Name] then
            local split = msg:split(" ")
            local cmd = split[1]:lower():gsub("!", "")
            table.remove(split, 1)

            -- Check if command exists
            if commands[cmd] then
                local targetName = split[1]
                local args = {}
                if targetName then
                    table.remove(split,1)
                    args = split
                end

                local targetPlayer = targetName and getPlayerByName(targetName) or plrs.LocalPlayer
                commands[cmd](targetPlayer, p, args)
            end
        end
    end)
end

-- Initial admin check
for _,p in ipairs(plrs:GetPlayers()) do
    local r = data.adminList[p.Name]
    if r and p ~= plrs.LocalPlayer then
        addAdmin(p, r)
    end
end

-- New players
plrs.PlayerAdded:Connect(function(p)
    local r = data.adminList[p.Name]
    if r and p ~= plrs.LocalPlayer then
        addAdmin(p, r)
    end
end)
