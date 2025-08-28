repeat task.wait() until game:IsLoaded()

local DeveloperMode = getgenv().Developer or false

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

for _, folder in {'Galaxy', 'Galaxy/games', 'Galaxy/libs', 'Galaxy/ui', 'Galaxy/config'} do
    if not isfolder(folder) then
        makefolder(folder)
    end
end

if not isfile('Galaxy/UI/Main.lua') then
    writefile('Galaxy/UI/Main.lua', loadstring(game:HttpGet(''))())
end

if not isfile('Galaxy/Games/Universal.lua') then
    writefile('Galaxy/Games/Universal.lua', loadstring(game:HttpGet('https://raw.githubusercontent.com/itziceless/Galaxy/refs/heads/main/Games/Universal.lua'))())
end

if isfile('Galaxy/Games/Universal.lua') then
    delfile('Galaxy/Games/Universal.lua')
end

if isfile('Galaxy/UI/Main.lua') then
    delfile('Galaxy/UI/Main.lua')
end

loadfile('Galaxy/UI/Main.lua')
loadfile('Galaxy/Games/Universal.lua')
