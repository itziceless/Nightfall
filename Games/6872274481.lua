local loadstring = function(...)
	local res, err = loadstring(...)
	if err and vape then
		Nightfall:CreateNotification('Nightfall', 'Failed to load : '..err, 30, "alert")
	end
	return res
end
local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/itziceless/Nightfall/'..readfile('Nightfall/Libs/commit.txt')..'/'..select(1, path:gsub('Nightfall/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--remove this if you dont want the script to update.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end
local run = function(func)
	func()
end
local queue_on_teleport = queue_on_teleport or function() end
local cloneref = cloneref or function(obj)
	return obj
end

local playersService = cloneref(game:GetService('Players'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local runService = cloneref(game:GetService('RunService'))
local inputService = cloneref(game:GetService('UserInputService'))
local tweenService = cloneref(game:GetService('TweenService'))
local lightingService = cloneref(game:GetService('Lighting'))
local marketplaceService = cloneref(game:GetService('MarketplaceService'))
local teleportService = cloneref(game:GetService('TeleportService'))
local httpService = cloneref(game:GetService('HttpService'))
local guiService = cloneref(game:GetService('GuiService'))
local groupService = cloneref(game:GetService('GroupService'))
local textChatService = cloneref(game:GetService('TextChatService'))
local contextService = cloneref(game:GetService('ContextActionService'))
local coreGui = cloneref(game:GetService('CoreGui'))

local isnetworkowner = identifyexecutor and table.find({'Zenith'}, ({identifyexecutor()})[1]) and isnetworkowner or function()
	return true
end
local gameCamera = workspace.CurrentCamera or workspace:FindFirstChildWhichIsA('Camera')
local lplr = playersService.LocalPlayer
local assetfunction = getcustomasset

local Nightfall = shared.Nightfall
local entitylib = loadstring(game:HttpGet("https://raw.githubusercontent.com/itziceless/Nightfall/refs/heads/main/libs/entitylib.lua", true))()

local function GetClosestPlayer(options)
    options = options or {}
    local distanceLimit = options.Distance or 50
    local teamCheck = options.TeamCheck or false
    local wallCheck = options.WallCheck or false
    local targetPartName = options.TargetPart or "HumanoidRootPart"

    local closestPlayer = nil
    local shortestDistance = distanceLimit

    for _, player in pairs(playersService:GetPlayers()) do
        if player ~= lplr and player.Character and player.Character:FindFirstChild(targetPartName) then
            if teamCheck and player.Team == lplr.Team then continue end

            local part = player.Character[targetPartName]
            local screenPos, onScreen = gameCamera:WorldToViewportPoint(part.Position)
            local mousePos = game:GetService("UserInputService"):GetMouseLocation()
            local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude

            if distance < shortestDistance then
                if wallCheck then
                    local ray = Ray.new(gameCamera.CFrame.Position, (part.Position - gameCamera.CFrame.Position).Unit * (part.Position - gameCamera.CFrame.Position).Magnitude)
                    local hit = workspace:FindPartOnRay(ray, lplr.Character)
                    if hit and not hit:IsDescendantOf(player.Character) then continue end
                end
                closestPlayer = player
                shortestDistance = distance
            end
        end
    end

    return closestPlayer
end

task.spawn(function()
    local AimAssist
    local Smoothness
    local Circle
    local Distance
    local TeamCheck
    local WallCheck
    local UseTriggerButton
    local TargetPart
    local CircleColor
    AimAssist = Nightfall.Categories.Movement:CreateModule({
        Name = 'Aim Assist',
        Legit = true,
        Function = function(enabled)
            if enabled then
                runService.RenderStepped:Connect(function()
                    local target = GetClosestPlayerr({
                        Distance = Distance.Get(),
                        TeamCheck = TeamCheck.Get(),
                        WallCheck = WallCheck.Get(),
                        TargetPart = TargetPart.Get()
                    })
                    if target and target.Character and target.Character:FindFirstChild(TargetPart.Get()) then
                        local targetPos = target.Character[TargetPart.Get()].Position
                        local currentCFrame = gameCamera.CFrame
                        local targetCFrame = CFrame.new(currentCFrame.Position, targetPos)
                        gameCamera.CFrame = currentCFrame:Lerp(targetCFrame, Smoothness.Get())
                    end
                end)
            end
            Tooltip = 'Aims Camera at player.',
        end,
    })
    Circle = AimAssist:CreateToggle({
        Name = "Enable Circle",
        Default = true
    })

    TeamCheck = AimAssist:CreateToggle({
        Name = "Team Check",
        Default = false
    })

    WallCheck = AimAssist:CreateToggle({
        Name = "Wall Check",
        Default = false
    })

    -- Sliders
    Smoothness = AimAssist:CreateSlider({
        Name = "Smoothness",
        Min = 0,
        Max = 1,
        Default = 0.2
    })

    Distance = AimAssist:CreateSlider({
        Name = "Aim Distance",
        Min = 1,
        Max = 300,
        Default = 50
    })
    TargetPart = AimAssist:CreateDropdown({
        Name = "Target Part",
        Default = "HumanoidRootPart",
        Options = {"Head", "HumanoidRootPart"}
    })
end)
