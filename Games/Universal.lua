local loadstring = function(...)
	local res, err = loadstring(...)
	if err and vape then
		Galaxy:CreateNotification('Galaxy', 'Failed to load : '..err, 30, "alert")
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
			return game:HttpGet('https://raw.githubusercontent.com/itziceless/Galaxy/'..readfile('Galaxy/Libs/commit.txt')..'/'..select(1, path:gsub('Galaxy/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
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

local Galaxy = shared.Galaxy
local entitylib = loadstring(game:HttpGet("https://raw.githubusercontent.com/itziceless/Galaxy/refs/heads/main/libs/entitylib.lua", true))()
--[[local tween = Galaxy.Libraries.tween
local targetinfo = Galaxy.Libraries.targetinfo
local getfontsize = Galaxy.Libraries.getfontsize
local getcustomasset = Galaxy.Libraries.getcustomasset--]]

entitylib.start()
task.spawn(function()
local AimAssist
local Part, FOV, Speed
local CircleColor, CircleTransparency, CircleFilled, CircleObject
local RightClick
local moveConst = Vector2.new(1, 0.77) * math.rad(0.5)

local function wrapAngle(num)
	num = num % math.pi
	num = num - (num >= (math.pi / 2) and math.pi or 0)
	num = num + (num < -(math.pi / 2) and math.pi or 0)
	return num
end

AimAssist = Galaxy.Categories.Combat:CreateModule({
	Name = "AimAssist",
	Legit = false,
	Function = function(called)
		if CircleObject then
			CircleObject.Visible = called
		end

		if called then
			local ent
			local rightClicked = not RightClick.Enabled or inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)

			-- RenderStepped loop
			local connection
			connection = runService.RenderStepped:Connect(function(dt)
				if CircleObject then
					CircleObject.Position = inputService:GetMouseLocation()
				end

				if rightClicked then
					ent = entitylib.EntityMouse({
						Range = FOV.Get(),
						Part = Part.Get(),
						Origin = gameCamera.CFrame.Position
					})

					if ent then
						local facing = gameCamera.CFrame.LookVector
						local targetPos = (ent[Part.Value].Position - gameCamera.CFrame.Position).Unit
						targetPos = targetPos == targetPos and targetPos or Vector3.zero

						if targetPos ~= Vector3.zero then
							local diffYaw = wrapAngle(math.atan2(facing.X, facing.Z) - math.atan2(targetPos.X, targetPos.Z))
							local diffPitch = math.asin(facing.Y) - math.asin(targetPos.Y)
							local angle = Vector2.new(diffYaw, diffPitch) / (moveConst * UserSettings():GetService("UserGameSettings").MouseSensitivity)
							angle *= math.min(Speed.Value * dt, 1)
							mousemoverel(angle.X, angle.Y)
						end
					end
				end
			end)

			-- Right click handlers
			if RightClick.Enabled then
				inputService.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton2 then
						ent = nil
						rightClicked = true
					end
				end)
				inputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton2 then
						rightClicked = false
					end
				end)
			end
		end
	end,
	Tooltip = "Smoothly aims to closest valid target"
})

-- Part selector
Part = AimAssist:CreateDropdown({
	Name = "Part",
	Default = "RootPart",
	List = {"RootPart", "Head"}
})

-- FOV Slider
FOV = AimAssist:CreateSlider({
	Name = "FOV",
	Min = 0,
	Max = 1000,
	Default = 100,
})

-- Speed Slider
Speed = AimAssist:CreateSlider({
	Name = "Speed",
	Min = 0,
	Max = 30,
	Default = 15
})

-- Range Circle Toggle
AimAssist:CreateToggle({
	Name = "Range Circle",
	Function = function(enabled)
		if enabled then
			CircleObject = Drawing.new("Circle")
			CircleObject.Filled = CircleFilled.Enabled
			CircleObject.Radius = FOV.Get()
			CircleObject.NumSides = 100
			CircleObject.Transparency = 1 - CircleTransparency.Value
			CircleObject.Visible = AimAssist.Enabled
		else
			if CircleObject then
				pcall(function()
					CircleObject.Visible = false
					CircleObject:Remove()
				end)
				CircleObject = nil
			end
		end

		CircleColor.Object.Visible = enabled
		CircleTransparency.Object.Visible = enabled
		CircleFilled.Object.Visible = enabled
	end
})

-- Circle Transparency
CircleTransparency = AimAssist:CreateSlider({
	Name = "Transparency",
	Min = 0,
	Max = 1,
	Decimal = 10,
	Default = 0.5,
})

-- Circle Filled
CircleFilled = AimAssist:CreateToggle({
	Name = "Circle Filled",
	Function = function(enabled)
		if CircleObject then
			CircleObject.Filled = enabled
		end
	end,
})

-- Require right click toggle
RightClick = AimAssist:CreateToggle({
	Name = "Require right click",
	Function = function()
		if AimAssist.Enabled then
			AimAssist:Toggle()
			AimAssist:Toggle()
		end
	end
})
end)
task.spawn(function()
local Speed
local SpeedValue
local SpeedMode
local SpeedSlider
local oldSpeed
Speed = Galaxy.Categories.Movement:CreateModule({
    Name = 'Speed',
    Legit = false,
    Function = function(called)
        if called then
                SpeedCon = runService.Heartbeat:Connect(function(deltaTime)
                    if SpeedMode.Get() == "CFrame" then
                        lplr.Character.PrimaryPart.CFrame += (lplr.Character.Humanoid.MoveDirection * SpeedValue.Get()) * deltaTime
                    elseif SpeedMode.Get() == "Velocity" then
                        lplr.Character.PrimaryPart.Velocity = Vector3.new(lplr.Character.Humanoid.MoveDirection.X * SpeedValue.Get(), lplr.Character.PrimaryPart.Velocity.Y, lplr.Character.Humanoid.MoveDirection.Z * SpeedValue.Get())
                    end
                end)
            else
                SpeedCon:Disconnect()
        end
    end,
    Tooltip = 'Customizes player speed',
})
SpeedValue = Speed:CreateSlider({
    Name = 'Value',
    Legit = false,
    Default = 50,
    min = 1,
    max = 100
})
SpeedMode = Speed:CreateDropdown({
	Name = 'Mode',
	Default = 'Velocity',
	Options = {"Velocity", "Cframe", "Pulse"}
})
end)
task.spawn(function()
local Rejoin
Rejoin = Galaxy.Categories.Misc:CreateModule({
    Name = 'Rejoin',
    Legit = false,
    Function = function(called)
        if called then
				Galaxy.ConfigSystem.CanSave = false
                teleportService:Teleport(game.PlaceId, lplr, teleportService:GetLocalPlayerTeleportData())		
        end
    end,
    Tooltip = 'Makes you rejoin your current server',
})
end)
