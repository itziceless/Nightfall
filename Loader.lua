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

for _, folder in {'Galaxy', 'Galaxy/Games', 'Galaxy/PremiumGames', 'Galaxy/Configs', 'Galaxy/Libs', 'Galaxy/UI'} do
	if not isfolder(folder) then
		makefolder(folder)
	end
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
			res = '--Remove this if you want to keep the files the same after updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end
local loadstring = function(...)
	local res, err = loadstring(...)
	if err and vape then
		API:CreateNotification('Galaxy', 'Failed to load : '..err, 30)
	end
	return res
end

if not shared.GalaxyDeveloper then
	local _, subbed = pcall(function()
		return game:HttpGet('https://raw.githubusercontent.com/itziceless/Galaxy/'..readfile('Galaxy/Libs/commit.txt')..'/games/'..game.PlaceId..'.lua', true)
	end)
	local commit = subbed:find('currentOid')
	commit = commit and subbed:sub(commit + 13, commit + 52) or nil
	commit = commit and #commit == 40 and commit or 'main'
	if commit == 'main' or (isfile('Galaxy/Libs/commit.txt') and readfile('Galaxy/Libs/commit.txt') or '') ~= commit then
		wipeFolder('Galaxy/PremiumGames')
		wipeFolder('Galaxy/Games')
		wipeFolder('Galaxy/UI')
		wipeFolder('Galaxy/Libs')
	end
	writefile('Galaxy/Libs/commit.txt', commit)
end

if not isfile('Galaxy/UI/UI.txt') then
	writefile('Galaxy/UI/UI.txt', 'Main')
end
local gui = readfile('Galaxy/UI/UI.txt')

local Galaxy = loadstring(downloadFile('Galaxy/UI/'..gui..'.lua'), 'gui')()
loadstring(downloadFile('Galaxy/Games/Universal.lua'), 'Universal')()
	local path = "Galaxy/Games/" .. game.PlaceId .. ".lua"

if isfile(path) then
    -- Load from local file
    local src = readfile(path)
    loadstring(src)()
else
    -- Try fetching from GitHub
    local suc, res = pcall(function()
        return game:HttpGet(
            "https://raw.githubusercontent.com/itziceless/Galaxy/"
            .. readfile("Galaxy/Libs/commit.txt")
            .. "/Games/"
            .. game.PlaceId
            .. ".lua",
            true
        )
    end)

    if suc and res and res ~= "404: Not Found" then
        -- Save locally for next time
        loadstring(downloadFile('Galaxy/Games/' .. game.PlaceId .. '.lua'), tostring(game.PlaceId))()
    end
end
print(suc, res)
loadstring(game:HttpGet("https://raw.githubusercontent.com/itziceless/Galaxy/refs/heads/main/libs/Whitelist.lua", true))()

--[[local LicenseKeys = {
    "OWNER-Q4R7-T8Y2-U1I5",
    "ADMIN-P3L9-K2J6-M7N4",
    "ADMIN-A1B5-C8D2-E9F6",
    "PRIVATE-G7H3-J2K5-L8M1",
    "PRIVATE-X4Y9-Z1A7-B6C3",
    "PRIVATE-D2E8-F3G5-H1I9",
    --[[["J6K4-L7M2-N9O1"] = { type = "1M", firstUse = nil },
    ["P8Q3-R5S1-T6U7"] = { type = "FOREVER", firstUse = nil },
    ["V2W9-X3Y6-Z8A4"] = { type = "1D", firstUse = nil },
    ["B5C1-D7E2-F4G9"] = { type = "1W", firstUse = nil },
    ["H3I8-J1K7-L2M5"] = { type = "1M", firstUse = nil },
    ["N6O2-P4Q8-R1S3"] = { type = "FOREVER", firstUse = nil },
    ["T7U3-V5W9-X2Y6"] = { type = "1D", firstUse = nil },
    ["Z8A1-B3C6-D5E2"] = { type = "1W", firstUse = nil },
    ["F4G7-H2I9-J6K3"] = { type = "1M", firstUse = nil },
    ["L1M5-N8O2-P3Q7"] = { type = "FOREVER", firstUse = nil },
    ["R9S4-T2U6-V1W5"] = { type = "1D", firstUse = nil },
    ["X3Y7-Z5A9-B2C8"] = { type = "1W", firstUse = nil },
    ["D6E1-F8G3-H4I7"] = { type = "1M", firstUse = nil },
    ["J2K9-L5M1-N3O8"] = { type = "FOREVER", firstUse = nil },
    ["P7Q4-R9S2-T5U1"] = { type = "1D", firstUse = nil },
    ["V6W3-X8Y1-Z4A5"] = { type = "1W", firstUse = nil },
    ["B9C2-D5E8-F1G4"] = { type = "1M", firstUse = nil },
    ["H7I2-J4K6-L9M3"] = { type = "FOREVER", firstUse = nil },
    ["N1O5-P8Q3-R6S2"] = { type = "1D", firstUse = nil },
}
	
local whitelisted = false

for _, v in pairs(LicenseKeys) do 
    if getgenv().CheckLicense == LicenseKeys then
        whitelisted = true
        break
    end
end
     
if whitelisted then
loadfile('Galaxy/UI/Main.lua')
loadfile('Galaxy/PremiumGames/Universal.lua')
	print("loaded in premium mode")
	else
	loadfile('Galaxy/UI/Main.lua')
	loadfile('Galaxy/Games/Universal.lua')
	print("loaded in normal mode")
end--]]
