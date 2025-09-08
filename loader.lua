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

for _, folder in {'Revenant', 'Revenant/Games', 'Revenant/PremiumGames', 'Revenant/Configs', 'Revenant/Libs', 'Revenant/UI'} do
	if not isfolder(folder) then
		makefolder(folder)
	end
end

local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/itziceless/Revenant/'..readfile('Revenant/Libs/commit.txt')..'/'..select(1, path:gsub('Revenant/', '')), true)
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
		API:CreateNotification('Revenant', 'Failed to load : '..err, 30)
	end
	return res
end

if not shared.RevenantDeveloper then
	local _, subbed = pcall(function()
		return game:HttpGet('https://raw.githubusercontent.com/itziceless/Revenant/'..readfile('Revenant/Libs/commit.txt')..'/games/'..game.PlaceId..'.lua', true)
	end)
	local commit = subbed:find('currentOid')
	commit = commit and subbed:sub(commit + 13, commit + 52) or nil
	commit = commit and #commit == 40 and commit or 'main'
	if commit == 'main' or (isfile('Revenant/Libs/commit.txt') and readfile('Revenant/Libs/commit.txt') or '') ~= commit then
		wipeFolder('Revenant/PremiumGames')
		wipeFolder('Revenant/Games')
		wipeFolder('Revenant/UI')
		wipeFolder('Revenant/Libs')
	end
	writefile('Revenant/Libs/commit.txt', commit)
end

if not isfile('Revenant/UI/UI.txt') then
	writefile('Revenant/UI/UI.txt', 'Main')
end
local gui = readfile('Revenant/UI/UI.txt')
loadstring(game:HttpGet("https://raw.githubusercontent.com/itziceless/Revenant/refs/heads/main/libs/Whitelist.lua", true))()
local Revenant = loadstring(downloadFile('Revenant/UI/'..gui..'.lua'), 'gui')()
loadstring(downloadFile('Revenant/Games/Universal.lua'), 'Universal')()
	if isfile('Revenant/Games/'..game.PlaceId..'.lua') then
		loadstring(readfile('Revenant/Games/'..game.PlaceId..'.lua'), tostring(game.PlaceId))(...)
	else
		if not shared.VapeDeveloper then
			local suc, res = pcall(function()
				return game:HttpGet('https://raw.githubusercontent.com/itziceless/Revenant/'..readfile('Revenant/Libs/commit.txt')..'/games/'..game.PlaceId..'.lua', true)
			end)
			if suc and res ~= '404: Not Found' then
				loadstring(downloadFile('Revenant/Games/'..game.PlaceId..'.lua'), tostring(game.PlaceId))(...)
			end
		end
	end
