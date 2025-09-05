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

local Galaxy = readfile('Galaxy/UI/UI.txt')
--[[local tween = Galaxy.Libraries.tween
local targetinfo = Galaxy.Libraries.targetinfo
local getfontsize = Galaxy.Libraries.getfontsize
local getcustomasset = Galaxy.Libraries.getcustomasset--]]

print(Galaxy.Categories)

--[[local Speed
local SpeedSlider
local oldSpeed
Speed = Galaxy.Categories.Movement:CreateModule({
    Name = 'Speed',
    Legit = false,
    Function = function(state)
        if state then
			
        end
    end,
    Tooltip = 'Customizes player speed',
})
local SpeedSlider = Speed:CreateSlider({
    Name = 'Value',
    Legit = false,
    Default = 50,
    min = 1,
    max = 100
})--]]
