local Nightfall = shared.Nightfall
local loadstring = function(...)
	local res, err = loadstring(...)
	if err and Nightfall then 
		Nightfall:CreateNotification('Nightfall', 'Failed to load : '..err, 30, 'alert') 
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
			return game:HttpGet('https://raw.githubusercontent.com/itziceless/Nightfall/'..readfile('Nightfall/profiles/commit.txt')..'/'..select(1, path:gsub('Nightfall/', '')), true) 
		end)
		if not suc or res == '404: Not Found' then 
			error(res) 
		end
		if path:find('.lua') then 
			res = '--delete this if you dont want nightfall to update\n'..res 
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

Nightfall.Place = 6872274481
if isfile('Nightfall/Games/'..Nightfall.Place..'.lua') then
	loadstring(readfile('Nightfall/Games/'..Nightfall.Place..'.lua'), 'bedwars')()
else
	if not shared.NightfallDeveloper then
		local suc, res = pcall(function() 
			return game:HttpGet('https://raw.githubusercontent.com/itziceless/Nightfall/'..readfile('Nightfall/profiles/commit.txt')..'/games/'..Nightfall.Place..'.lua', true) 
		end)
		if suc and res ~= '404: Not Found' then
			loadstring(downloadFile('Nightfall/Games/'..Nightfall.Place..'.lua'), 'bedwars')()
		end
	end
end
