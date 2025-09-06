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
local AimAssistConnection

AimAssist = Galaxy.Categories.Combat:CreateModule({
	Name = "AimAssist",
	Legit = false,
	Function = function(called)
		if called then
			-- Enable
			AimAssistConnection = runService.RenderStepped:Connect(function()
				local closestChar, closestHead, closestDist
				for _, player in ipairs(Players:GetPlayers()) do
					if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
						local head = player.Character.Head
						local screenPos, onScreen = gameCamera:WorldToViewportPoint(head.Position)
						if onScreen then
							local mouse = inputService:GetMouseLocation()
							local dist = (Vector2.new(screenPos.X, screenPos.Y) - mouse).Magnitude
							if not closestDist or dist < closestDist then
								closestChar = player.Character
								closestHead = head
								closestDist = dist
							end
						end
					end
				end

				if closestHead then
					-- Smoothly move camera
					local targetCF = CFrame.new(Camera.CFrame.Position, closestHead.Position)
					Camera.CFrame = Camera.CFrame:Lerp(targetCF, 0.15) -- adjust smoothing speed here
				end
			end)
		else
			-- Disable
			if AimAssistConnection then
				AimAssistConnection:Disconnect()
				AimAssistConnection = nil
			end
		end
		Tooltip = "Smoothly aims to closest valid target",
	end,
})
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
