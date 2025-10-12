repeat task.wait() until game:IsLoaded()

local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local delfile = delfile or function(file)
	writefile(file, '')
end

local function wipeFolder(path)
	if not isfolder(path) then return end
	for _, file in listfiles(path) do
		if file:find('loader') then continue end
		if isfile(file) and select(1, readfile(file):find('--Remove this if you want to keep the files the same after updates.')) == 1 then
			delfile(file)
		end
	end
end

for _, folder in {'Nightfall', 'Nightfall/Games', 'Nightfall/PremiumGames', 'Nightfall/Configs', 'Nightfall/Libs', 'Nightfall/UI'} do
	if not isfolder(folder) then
		makefolder(folder)
	end
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
			res = '--Remove this if you want to keep the files the same after updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end
local loadstring = function(...)
	local res, err = loadstring(...)
	if err and vape then
		API:CreateNotification('Nightfall', 'Failed to load : '..err, 30)
	end
	return res
end

if not shared.NightfallDeveloper then
	local _, subbed = pcall(function()
		return game:HttpGet('https://raw.githubusercontent.com/itziceless/Nightfall/'..readfile('Nightfall/Libs/commit.txt')..'/games/'..game.PlaceId..'.lua', true)
	end)
	local commit = subbed:find('currentOid')
	commit = commit and subbed:sub(commit + 13, commit + 52) or nil
	commit = commit and #commit == 40 and commit or 'main'
	if commit == 'main' or (isfile('Nightfall/Libs/commit.txt') and readfile('Nightfall/Libs/commit.txt') or '') ~= commit then
		wipeFolder('Nightfall/PremiumGames')
		wipeFolder('Nightfall/Games')
		wipeFolder('Nightfall/UI')
		wipeFolder('Nightfall/Libs')
	end
	writefile('Nightfall/Libs/commit.txt', commit)
end

if not isfile('Nightfall/UI/UI.txt') then
	writefile('Nightfall/UI/UI.txt', 'Main')
end
local gui = readfile('Nightfall/UI/UI.txt')
loadstring(game:HttpGet("https://raw.githubusercontent.com/itziceless/Nightfall/refs/heads/main/libs/Whitelist.lua", true))()
local NightfallUI = loadstring(downloadFile('Nightfall/UI/'..gui..'.lua'), 'gui')()
local Nightfall = shared.Nightfall
--loadstring(downloadFile('Nightfall/Games/Universal.lua'), 'Universal')()
	if isfile('Nightfall/Games/'..game.PlaceId..'.lua') then
		loadstring(readfile('Nightfall/Games/'..game.PlaceId..'.lua'), tostring(game.PlaceId))(...)
	else
		if not shared.NightfallDeveloper then
			local suc, res = pcall(function()
				return game:HttpGet('https://raw.githubusercontent.com/itziceless/Nightfall/'..readfile('Nightfall/Libs/commit.txt')..'/games/'..game.PlaceId..'.lua', true)
			end)
			if suc and res ~= '404: Not Found' then
				loadstring(downloadFile('Nightfall/Games/'..game.PlaceId..'.lua'), tostring(game.PlaceId))(...)
			end
		end
	end
NightFall.Load.Loaded = true
NightFall.Load.Time = os.clock() - NightFall.Load.Start
local LoadTime: string = string.format("%.1fs", NightFall.Load.Time)
Nightfall:CreateNotification("Nightfall", "Loaded in " .. LoadTime, 2)
