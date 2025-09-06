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

--[[local tween = Galaxy.Libraries.tween
local targetinfo = Galaxy.Libraries.targetinfo
local getfontsize = Galaxy.Libraries.getfontsize
local getcustomasset = Galaxy.Libraries.getcustomasset--]]

Bedwars.Functions.hasItem = function(item: string)
    return Bedwars.Inventory:FindFirstChild(item)
end
Bedwars.Functions.getWeapon = function()
    local bS
    local bSM = 0
    for i, v in pairs(Bedwars.Meta.Weapons) do
        local n = v[1]
        local m = v[2]
        if m > bSM and Bedwars.Functions.hasItem(n) then
            bS = n
            bSM = m
        end
    end
    return Bedwars.Inventory:FindFirstChild(bS)
end

local function getNearestPlayer(range)
	for i,v in pairs(Players:GetPlayers()) do
		if v ~= lplr and v.Team ~= lplr.Team and isAlive(v) and isAlive(lplr) then
			local distance = v:DistanceFromCharacter(lplr.Character.PrimaryPart.Position)
			if distance < range then
				return v
			end
		end
	end
	return nil
end

run(function()
local KillAura, Visuals, BoxE, Swing
local AuraCon, lastHit
local lastEmHp
     local Box = Instance.new("Part", workspace)
    Box.CFrame = CFrame.new(0, 10000, 0)
    Box.Transparency = 0.5
    Box.Material = Enum.Material.Neon
    Box.Anchored = true
    Box.CanCollide = false
    Box.Color = Color3.fromRGB(255,0,0)

    local SwingAnim = Instance.new("Animation")
    SwingAnim.AnimationId = Bedwars.Animations.SWORD_SWING
    local loadAnim = lplr.Character.Humanoid:LoadAnimation(SwingAnim)

    table.insert(CharAddedConnections, function()
        loadAnim = lplr.Character.Humanoid:LoadAnimation(SwingAnim)
    end)

    KillAura = Galaxy.Categories.Combat.CreateModule({
        Name = "KillAura",
        Function = function(called)
            if called then
                lastHit = tick()
                AuraCon = RunService.Heartbeat:Connect(function()
                    local Nearest = getNearestPlayer(18)

                    if (tick() - lastHit) > 0.05 and Nearest then
                        local Sword = Bedwars.Functions.getWeapon()

                        Client:Get("SwordHit"):SendToServer({
                            weapon = Sword,
                            entityInstance = Nearest.Character,
                            chargedAttack = {chargeRatio = 0},
                            validate = {
                                targetPosition = {value = Nearest.Character.PrimaryPart.Position},
                                selfPosition = {value = lplr.Character.PrimaryPart.Position},
                            },
                        })

                        if BoxE.Enabled then
                            Box.CFrame = Nearest.Character.PrimaryPart.CFrame
                        end

                        if Swing.Option ~= "None" then
                            if Swing.Option == "OnHit" and Nearest.Character.Humanoid.Health > lastEmHp then
                                return
                            end
                            loadAnim:Play()
                        end

                        lastEmHp = Nearest.Character.Humanoid.Health
                    end
                end)
            else
                AuraCon:Disconnect()
            end
        end
    })
    Swing = KillAura:CreateDropdown({
        Name = "Swing Mode",
        Options = {"None", "OnHit", "Always"}
    })
    --[[Visuals = KillAura:Create_Toggle({
        Name = "Visuals",
        Function = function(called)
            repeat task.wait() until Box
            Box.Instance.Visuals = called
        end
    })--]]
    BoxE = KillAura:CreateToggle({
        Name = "Display Box",
    })
  end)
