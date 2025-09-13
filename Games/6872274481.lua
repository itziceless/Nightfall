local loadstring = function(...)
    local res, err = loadstring(...)
    if err and vape then
        Nightfall:CreateNotification(
            'Nightfall',
            'Failed to load : ' .. err,
            30,
            'alert'
        )
    end
    return res
end
local isfile = isfile
    or function(file)
        local suc, res = pcall(function()
            return readfile(file)
        end)
        return suc and res ~= nil and res ~= ''
    end
local function downloadFile(path, func)
    if not isfile(path) then
        local suc, res = pcall(function()
            return game:HttpGet(
                'https://raw.githubusercontent.com/itziceless/Nightfall/'
                    .. readfile('Nightfall/Libs/commit.txt')
                    .. '/'
                    .. select(1, path:gsub('Nightfall/', '')),
                true
            )
        end)
        if not suc or res == '404: Not Found' then
            error(res)
        end
        if path:find('.lua') then
            res = '--remove this if you dont want the script to update.\n'
                .. res
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

local isnetworkowner = identifyexecutor
        and table.find({ 'Zenith' }, ({ identifyexecutor() })[1])
        and isnetworkowner
    or function()
        return true
    end
local gameCamera = workspace.CurrentCamera
    or workspace:FindFirstChildWhichIsA('Camera')
local lplr = playersService.LocalPlayer
local assetfunction = getcustomasset

local Nightfall = shared.Nightfall
local entitylib = loadstring(
    game:HttpGet(
        'https://raw.githubusercontent.com/itziceless/Nightfall/refs/heads/main/libs/entitylib.lua',
        true
    )
)()

local Client = require(replicatedStorage.TS.remotes).default.Client
local Knit = local Knit = require(ReplicatedStorage.rbxts_include.node_modules["@easy-games"].knit.src).KnitClient
	--[[if not debug.getupvalue(Knit.Start, 1) then
		repeat task.wait() until debug.getupvalue(Knit.Start, 1)
	end--]]
local Flamework = require(replicatedStorage['rbxts_include']['node_modules']['@flamework'].core.out).Flamework
local InventoryUtil = require(replicatedStorage.TS.inventory['inventory-util']).InventoryUtil
local Bedwars = {
		KnockbackUtil = debug.getupvalue(require(replicatedStorage.TS.damage["knockback-util"]).KnockbackUtil.calculateKnockbackVelocity, 1),
		AbilityController = Flamework.resolveDependency('@easy-games/game-core:client/controllers/ability/ability-controller@AbilityController'),
		AnimationType = require(replicatedStorage.TS.animation['animation-type']).AnimationType,
		AnimationUtil = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out['shared'].util['animation-util']).AnimationUtil,
		AppController = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out.client.controllers['app-controller']).AppController,
		BedBreakEffectMeta = require(replicatedStorage.TS.locker['bed-break-effect']['bed-break-effect-meta']).BedBreakEffectMeta,
		BedwarsKitMeta = require(replicatedStorage.TS.games.bedwars.kit['bedwars-kit-meta']).BedwarsKitMeta,
		BlockBreaker = Knit.Controllers.BlockBreakController.blockBreaker,
		BlockController = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['block-engine'].out).BlockEngine,
		BlockEngine = require(lplr.PlayerScripts.TS.lib['block-engine']['client-block-engine']).ClientBlockEngine,
		BlockPlacer = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['block-engine'].out.client.placement['block-placer']).BlockPlacer,
		BowConstantsTable = debug.getupvalue(Knit.Controllers.ProjectileController.enableBeam, 8),
		ClickHold = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['game-core'].out.client.ui.lib.util['click-hold']).ClickHold,
		Client = Client,
		ClientConstructor = require(replicatedStorage['rbxts_include']['node_modules']['@rbxts'].net.out.client),
		ClientDamageBlock = require(replicatedStorage['rbxts_include']['node_modules']['@easy-games']['block-engine'].out.shared.remotes).BlockEngineRemotes.Client,
		CombatConstant = require(replicatedStorage.TS.combat['combat-constant']).CombatConstant,
		DamageIndicator = Knit.Controllers.DamageIndicatorController.spawnDamageIndicator,
		DefaultKillEffect = require(lplr.PlayerScripts.TS.controllers.game.locker['kill-effect'].effects['default-kill-effect']),
		EmoteType = require(replicatedStorage.TS.locker.emote['emote-type']).EmoteType,
		GameAnimationUtil = require(replicatedStorage.TS.animation['animation-util']).GameAnimationUtil,
}
local remoteNames = {
		AfkStatus = debug.getproto(Knit.Controllers.AfkController.KnitStart, 1),
		AttackEntity = Knit.Controllers.SwordController.sendServerRequest,
		BeePickup = Knit.Controllers.BeeNetController.trigger,
		CannonAim = debug.getproto(Knit.Controllers.CannonController.startAiming, 5),
		CannonLaunch = Knit.Controllers.CannonHandController.launchSelf,
		ConsumeBattery = debug.getproto(Knit.Controllers.BatteryController.onKitLocalActivated, 1),
		ConsumeItem = debug.getproto(Knit.Controllers.ConsumeController.onEnable, 1),
		ConsumeSoul = Knit.Controllers.GrimReaperController.consumeSoul,
		ConsumeTreeOrb = debug.getproto(Knit.Controllers.EldertreeController.createTreeOrbInteraction, 1),
		DepositPinata = debug.getproto(debug.getproto(Knit.Controllers.PiggyBankController.KnitStart, 2), 5),
		DragonBreath = debug.getproto(Knit.Controllers.VoidDragonController.onKitLocalActivated, 5),
		DragonEndFly = debug.getproto(Knit.Controllers.VoidDragonController.flapWings, 1),
		DragonFly = Knit.Controllers.VoidDragonController.flapWings,
		DropItem = Knit.Controllers.ItemDropController.dropItemInHand,
		EquipItem = debug.getproto(require(replicatedStorage.TS.entity.entities['inventory-entity']).InventoryEntity.equipItem, 3),
		FireProjectile = debug.getupvalue(Knit.Controllers.ProjectileController.launchProjectileWithValues, 2),
		GroundHit = Knit.Controllers.FallDamageController.KnitStart,
		GuitarHeal = Knit.Controllers.GuitarController.performHeal,
		HannahKill = debug.getproto(Knit.Controllers.HannahController.registerExecuteInteractions, 1),
		HarvestCrop = debug.getproto(debug.getproto(Knit.Controllers.CropController.KnitStart, 4), 1),
		KaliyahPunch = debug.getproto(Knit.Controllers.DragonSlayerController.onKitLocalActivated, 1),
		MageSelect = debug.getproto(Knit.Controllers.MageController.registerTomeInteraction, 1),
		MinerDig = debug.getproto(Knit.Controllers.MinerController.setupMinerPrompts, 1),
		PickupItem = Knit.Controllers.ItemDropController.checkForPickup,
		PickupMetal = debug.getproto(Knit.Controllers.HiddenMetalController.onKitLocalActivated, 4),
		ReportPlayer = require(lplr.PlayerScripts.TS.controllers.global.report['report-controller']).default.reportPlayer,
		ResetCharacter = debug.getproto(Knit.Controllers.ResetController.createBindable, 1),
		SpawnRaven = debug.getproto(Knit.Controllers.RavenController.KnitStart, 1),
		SummonerClawAttack = Knit.Controllers.SummonerClawHandController.attack,
		WarlockTarget = debug.getproto(Knit.Controllers.WarlockStaffController.KnitStart, 2)
	}

local function GetClosestPlayer(options)
    options = options or {}
    local distanceLimit = options.Distance or 50
    local teamCheck = options.TeamCheck or false
    local wallCheck = options.WallCheck or false
    local targetPartName = options.TargetPart or 'HumanoidRootPart'

    local closestPlayer = nil
    local shortestDistance = distanceLimit

    for _, player in pairs(playersService:GetPlayers()) do
        if
            player ~= lplr
            and player.Character
            and player.Character:FindFirstChild(targetPartName)
        then
            if teamCheck and player.Team == lplr.Team then
                continue
            end

            local part = player.Character[targetPartName]
            local screenPos, onScreen =
                gameCamera:WorldToViewportPoint(part.Position)
            local mousePos = game:GetService('UserInputService')
                :GetMouseLocation()
            local distance = (
                Vector2.new(screenPos.X, screenPos.Y)
                - Vector2.new(mousePos.X, mousePos.Y)
            ).Magnitude

            if distance < shortestDistance then
                if wallCheck then
                    local ray = Ray.new(
                        gameCamera.CFrame.Position,
                        (part.Position - gameCamera.CFrame.Position).Unit
                            * (part.Position - gameCamera.CFrame.Position).Magnitude
                    )
                    local hit = workspace:FindPartOnRay(ray, lplr.Character)
                    if hit and not hit:IsDescendantOf(player.Character) then
                        continue
                    end
                end
                closestPlayer = player
                shortestDistance = distance
            end
        end
    end

    return closestPlayer
end

--COMBAT
task.spawn(function()
	local oldUP = Bedwars.KnockbackUtil.kbUpwardStrength
	local oldDS = Bedwars.KnockbackUtil.kbDirectionStrength
	local newUP
	local newDS
	local velocity
	Velocity = Nightfall.Categories.Combat:CreateModule({
		Name = "Velocity",
		Legit = true,
		Function = function(called)
			if called then
				Bedwars.KnockbackUtil.kbUpwardStrength = newUP.Get()
				Bedwars.KnockbackUtil.kbDirectionStrength = newDS.Get()
				else
				Bedwars.KnockbackUtil.kbUpwardStrength = oldUP
				Bedwars.KnockbackUtil.kbDirectionStrength = oldDS
			end
		end,
	})
	newUP = Velocity:CreateSlider({
		Name = "Upward Strength",
		Min = 0,
		Max = 10,
		Default = 0
})
newDS = Velocity:CreateSlider({
		Name = "Direction Strength",
		Min = 0,
		Max = 10,
		Default = 0
})
end)
--MOVEMENT

--PLAYER
task.spawn(function()
    local Mode
    local NoFallDamage
    local root = lplr.Character.PrimaryPart
	local rayParams = RaycastParams.new()
    NoFallDamage = Nightfall.Categories.Player:CreateModule({
        Name = 'No Fall',
        Legit = true,
        Function = function(called)
            if called then
                repeat
                    if Mode.Get() == "Bounce" then
                    if root.AssemblyLinearVelocity.Y < -80 then
                        root.AssemblyLinearVelocity = Vector3.new(
                            root.AssemblyLinearVelocity.X,
                            -2,
                            root.AssemblyLinearVelocity.Z
                        )
                    end
				end
                until not NoFallDamage.Enabled
            end
        end,
    })
    Mode = NoFallDamage:CreateDropdown({
        Name = 'Mode',
        Default = 'Bounce',
        Options = { 'Bounce' },
    })
end)
--RENDER

--PREMIUM
