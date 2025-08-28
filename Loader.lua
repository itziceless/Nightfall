repeat task.wait() until game:IsLoaded()

LicenseKeys = {
    ["OWNER-Q4R7-T8Y2-U1I5"] = { type = "FOREVER", firstUse = nil },
    ["ADMIN-P3L9-K2J6-M7N4"] = { type = "FOREVER", firstUse = nil },
    ["ADMIN-A1B5-C8D2-E9F6"] = { type = "FOREVER", firstUse = nil },
    ["PRIVATE-G7H3-J2K5-L8M1"] = { type = "FOREVER", firstUse = nil },
    ["PRIVATE-X4Y9-Z1A7-B6C3"] = { type = "FOREVER", firstUse = nil },
    ["PRIVATE-D2E8-F3G5-H1I9"] = { type = "FOREVER", firstUse = nil },
    ["J6K4-L7M2-N9O1"] = { type = "1M", firstUse = nil },
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


-- Function to check if a key is valid
function getgenv().VerifyLicenseKey(key)
    local info = LicenseKeys[key]
    if not info then return false end

    if info.type == "FOREVER" then
        return true
    end

    -- Start timer on first use
    if not info.firstUse then
        info.firstUse = os.time()
        return true
    end

    local elapsed = os.time() - info.firstUse
    if info.type == "1D" and elapsed <= 86400 then return true end
    if info.type == "1W" and elapsed <= 604800 then return true end
    if info.type == "1M" and elapsed <= 2592000 then return true end

    return false
end

for _, v in pairs(LicenseKeys) do 
    if getgenv().CheckLicense == LicenseKeys then
        whitelisted = true
        break
    end
end
     
if whitelisted then
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
        if isfile(file) and select(1, readfile(file):find('--This watermark is used to delete the file if its cached, remove it to make the file persist after Galaxy updates.')) == 1 then
            delfile(file)
        end
    end
end

if isfolder('Galaxy') then
    wipefolder('Galaxy')
end

for _, folder in {'Galaxy', 'Galaxy/Games', 'Galaxy/Libs', 'Galaxy/UI', 'Galaxy/Config'} do
    if not isfolder(folder) then
        makefolder(folder)
    end
end

if not isfile('Galaxy/UI/Main.lua') then
    writefile('Galaxy/UI/Main.lua', loadstring(game:HttpGet("https://raw.githubusercontent.com/itziceless/Galaxy/refs/heads/main/UI/Main.lua", true))())
end

if not isfile('Galaxy/Games/Universal.lua') then
    writefile('Galaxy/Games/Universal.lua', loadstring(game:HttpGet("https://raw.githubusercontent.com/itziceless/Galaxy/refs/heads/main/Games/Universal.lua", true))())
end

loadfile('Galaxy/UI/Main.lua')
loadfile('Galaxy/Games/Universal.lua')
	else
	game:GetService("Players").LocalPlayer:Kick('Key Invalid or Expired. Get a key in our discord. \n https://discord.gg/ryDhGJkEyP (also in youre clipboard)')
	setclipboard("https://discord.gg/ryDhGJkEyP")
end
