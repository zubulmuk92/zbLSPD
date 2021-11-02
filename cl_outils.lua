-- creation du blip

Citizen.CreateThread(function()
    local policemap = AddBlipForCoord(zbConfig.BlipCoordonnes.x, zbConfig.BlipCoordonnes.y, zbConfig.BlipCoordonnes.z)
    SetBlipSprite(policemap, zbConfig.BlipSprite)
    SetBlipColour(policemap, zbConfig.BlipColour)
    SetBlipScale(policemap,zbConfig.BlipScale)
    SetBlipAsShortRange(policemap, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(zbConfig.NomDuBlip)
    EndTextCommandSetBlipName(policemap)

    local nomPed = GetHashKey(zbConfig.GarageLSPDPed.model)
    while not HasModelLoaded(nomPed) do
        RequestModel(nomPed)
        Wait(60)
    end
    local spawnPos = vector3(zbConfig.GarageLSPDPed.x,zbConfig.GarageLSPDPed.y,zbConfig.GarageLSPDPed.z-1)
    local heading = zbConfig.GarageLSPDPed.heading

    local ped = CreatePed(9, nomPed, spawnPos, heading, false, false)

    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    FreezeEntityPosition(ped, true)

    local nomPed2 = GetHashKey(zbConfig.ArmurerieLSPDPed.model)
    while not HasModelLoaded(nomPed2) do
        RequestModel(nomPed2)
        Wait(60)
    end
    local spawnPos2 = vector3(zbConfig.ArmurerieLSPDPed.x,zbConfig.ArmurerieLSPDPed.y,zbConfig.ArmurerieLSPDPed.z-1)
    local heading2 = zbConfig.ArmurerieLSPDPed.heading

    local ped2 = CreatePed(9, nomPed2, spawnPos2, heading2, false, false)

    SetEntityInvincible(ped2, true)
    SetBlockingOfNonTemporaryEvents(ped2, true)
    FreezeEntityPosition(ped2, true)

end)

function creerBlipEntite(entity,nom,sprite,display,scale,colour)

    Citizen.CreateThread(function()
        local blip = AddBlipForEntity(entity)
                    
        SetBlipSprite (blip, sprite)
        SetBlipDisplay(blip, display)
        SetBlipScale  (blip, scale)
        SetBlipColour (blip, colour)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(nom)
        EndTextCommandSetBlipName(blip)
    end)
end

local shieldEntity = nil

local animDict = "combat@gestures@gang@pistol_1h@beckon"
local animName = "0"

local prop = "prop_ballistic_shield"

function ActiverBouclier()
    shieldActive = true
    local ped = PlayerPedId()
    local pedPos = GetEntityCoords(ped, false)
    
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Citizen.Wait(250)
    end

    TaskPlayAnim(ped, animDict, animName, 8.0, -8.0, -1, (2 + 16 + 32), 0.0, 0, 0, 0)

    RequestModel(GetHashKey(prop))
    while not HasModelLoaded(GetHashKey(prop)) do
        Citizen.Wait(250)
    end

    local shield = CreateObject(GetHashKey(prop), pedPos.x, pedPos.y, pedPos.z, 1, 1, 1)
    shieldEntity = shield
    AttachEntityToEntity(shieldEntity, ped, GetEntityBoneIndexByName(ped, "IK_L_Hand"), 0.0, -0.05, -0.10, -30.0, 180.0, 40.0, 0, 0, 1, 0, 0, 1)
    SetWeaponAnimationOverride(ped, GetHashKey("Gang1H"))
    SetEnableHandcuffs(ped, true)
end

function DesactiverBouclier()
    local ped = PlayerPedId()
    DeleteEntity(shieldEntity)
    ClearPedTasksImmediately(ped)
    SetWeaponAnimationOverride(ped, GetHashKey("Default"))
    SetEnableHandcuffs(ped, false)
    shieldActive = false
end

-- Livery menu

OpenClothUi = function()
    if not opened then
        local PlayerData = ESX.GetPlayerData()
        -- print('2')
        if PlayerData.job.name == "police" and IsPedInAnyVehicle(PlayerPedId(), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), 0), -1) == PlayerPedId()) and GetVehicleBodyHealth(GetVehiclePedIsIn(PlayerPedId(), 0), -1) >= 1000 then
            
         SendNUIMessage({action = 'showui'})
            SetNuiFocus(true, true)
            SendNUIMessage({action = 'showMenu'})
            opened = true
        else
            
        end
    else
        -- print('31')
        if SendNUIMessage({action = 'hideui'}) then
            SetNuiFocus(false, false)
            opened = false
        end
    end
end


RegisterNUICallback('CloseMenu:NuiCallback', function(data)

    if data.data then
        opened = false
        SetNuiFocus(false, false)
    end
end)


RegisterNUICallback('livery:0', function (data)
    local src = source
    local   player = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())

    -- local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
--   local   player = GetPlayerPed(src)
 if IsPedInAnyVehicle(PlayerPedId(), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), 0), -1) == PlayerPedId()) then
    SetVehicleMod(vehicle, 48 , 0)
else
    ESX.ShowNotification('~r~ERREUR~w~ :  Tu n\'es pas dans un véhicule.')
end
end)

RegisterNUICallback('livery:1', function (data)
    local src = source
    local   player = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())

    -- local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
--   local   player = GetPlayerPed(src)
 if IsPedInAnyVehicle(PlayerPedId(), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), 0), -1) == PlayerPedId()) then
    SetVehicleMod(vehicle, 48 , 1)
else
   ESX.ShowNotification('~r~ERREUR~w~ :  Tu n\'es pas dans un véhicule.')
end
end)
RegisterNUICallback('livery:2', function (data)
    local src = source
    local   player = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())

    -- local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
--   local   player = GetPlayerPed(src)
 if IsPedInAnyVehicle(PlayerPedId(), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), 0), -1) == PlayerPedId()) then
    SetVehicleMod(vehicle, 48 , 2)
else
   ESX.ShowNotification('~r~ERREUR~w~ :  Tu n\'es pas dans un véhicule.')
end
end)

RegisterNUICallback('livery:3', function (data)
    local src = source
    local   player = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())

    -- local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
--   local   player = GetPlayerPed(src)
 if IsPedInAnyVehicle(PlayerPedId(), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), 0), -1) == PlayerPedId()) then
    SetVehicleMod(vehicle, 48 , 3)
else
   ESX.ShowNotification('~r~ERREUR~w~ :  Tu n\'es pas dans un véhicule.')
end
end)

RegisterNUICallback('livery:-1', function (data)
    local src = source
    local   player = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())

    -- local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
--   local   player = GetPlayerPed(src)
 if IsPedInAnyVehicle(PlayerPedId(), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), 0), -1) == PlayerPedId()) then
    SetVehicleMod(vehicle, 48 , -1)
else
   ESX.ShowNotification('~r~ERREUR~w~ :  Tu n\'es pas dans un véhicule.')
end
end)


RegisterNUICallback('extra:1', function (data)
    local src = source
    local   player = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())

    -- local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
--   local   player = GetPlayerPed(src)
 if IsPedInAnyVehicle(PlayerPedId(), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), 0), -1) == PlayerPedId()) then
    SetVehicleExtra(vehicle , 1, 0)
else
   ESX.ShowNotification('~r~ERREUR~w~ :  Tu n\'es pas dans un véhicule.')
end
end)


RegisterNUICallback('extra:2', function (data)
    local src = source
    local   player = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())

    -- local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
--   local   player = GetPlayerPed(src)
 if IsPedInAnyVehicle(PlayerPedId(), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), 0), -1) == PlayerPedId()) then
    SetVehicleExtra(vehicle , 2, 0)
else
   ESX.ShowNotification('~r~ERREUR~w~ :  Tu n\'es pas dans un véhicule.')
end
end)
RegisterNUICallback('extra:3', function (data)
    local src = source
    local   player = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())

    -- local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
--   local   player = GetPlayerPed(src)
 if IsPedInAnyVehicle(PlayerPedId(), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), 0), -1) == PlayerPedId()) then
    SetVehicleExtra(vehicle , 3, 0)
else
   ESX.ShowNotification('~r~ERREUR~w~ :  Tu n\'es pas dans un véhicule.')
end
end)
RegisterNUICallback('extra:4', function (data)
    local src = source
    local   player = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())

    -- local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
--   local   player = GetPlayerPed(src)
 if IsPedInAnyVehicle(PlayerPedId(), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), 0), -1) == PlayerPedId()) then
    SetVehicleExtra(vehicle , 4, 0)
else
   ESX.ShowNotification('~r~ERREUR~w~ :  Tu n\'es pas dans un véhicule.')
end
end)
RegisterNUICallback('extra:5', function (data)
    local src = source
    local   player = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())

    -- local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
--   local   player = GetPlayerPed(src)
 if IsPedInAnyVehicle(PlayerPedId(), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), 0), -1) == PlayerPedId()) then
    SetVehicleExtra(vehicle , 5, 0)
else
   ESX.ShowNotification('~r~ERREUR~w~ :  Tu n\'es pas dans un véhicule.')
end
end)
RegisterNUICallback('extra:6', function (data)
    local src = source
    local   player = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())

    -- local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
--   local   player = GetPlayerPed(src)
 if IsPedInAnyVehicle(PlayerPedId(), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), 0), -1) == PlayerPedId()) then
    SetVehicleExtra(vehicle , 6, 0)
else
   ESX.ShowNotification('~r~ERREUR~w~ :  Tu n\'es pas dans un véhicule.')
end
end)
RegisterNUICallback('extra:7', function (data)
    local src = source
    local   player = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())

    -- local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
--   local   player = GetPlayerPed(src)
 if IsPedInAnyVehicle(PlayerPedId(), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), 0), -1) == PlayerPedId()) then
    SetVehicleExtra(vehicle , 7, 0)
else
   ESX.ShowNotification('~r~ERREUR~w~ :  Tu n\'es pas dans un véhicule.')
end
end)
RegisterNUICallback('extra:8', function (data)
    local src = source
    local   player = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())

    -- local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
--   local   player = GetPlayerPed(src)
 if IsPedInAnyVehicle(PlayerPedId(), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), 0), -1) == PlayerPedId()) then
    SetVehicleExtra(vehicle , 8, 0)
else
   ESX.ShowNotification('~r~ERREUR~w~ :  Tu n\'es pas dans un véhicule.')
end
end)


RegisterNUICallback('extra:-1', function (data)
    local src = source
    local   player = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())

    -- local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
--   local   player = GetPlayerPed(src)
 if IsPedInAnyVehicle(PlayerPedId(), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), 0), -1) == PlayerPedId()) then
    SetVehicleExtra(vehicle , 1, 1)
else
   ESX.ShowNotification('~r~ERREUR~w~ :  Tu n\'es pas dans un véhicule.')
end
end)

RegisterNUICallback('extra:-2', function (data)
    local src = source
    local   player = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())

    -- local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
--   local   player = GetPlayerPed(src)
 if IsPedInAnyVehicle(PlayerPedId(), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), 0), -1) == PlayerPedId()) then
    SetVehicleExtra(vehicle , 2, 1)
else
   ESX.ShowNotification('~r~ERREUR~w~ :  Tu n\'es pas dans un véhicule.')
end
end)



RegisterNUICallback('extra:-3', function (data)
    local src = source
    local   player = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())

    -- local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
--   local   player = GetPlayerPed(src)
 if IsPedInAnyVehicle(PlayerPedId(), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), 0), -1) == PlayerPedId()) then
    SetVehicleExtra(vehicle , 3, 1)
else
   ESX.ShowNotification('~r~ERREUR~w~ :  Tu n\'es pas dans un véhicule.')
end
end)


RegisterNUICallback('extra:-4', function (data)
    local src = source
    local   player = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())

    -- local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
--   local   player = GetPlayerPed(src)
 if IsPedInAnyVehicle(PlayerPedId(), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), 0), -1) == PlayerPedId()) then
    SetVehicleExtra(vehicle , 4, 1)
else
   ESX.ShowNotification('~r~ERREUR~w~ :  Tu n\'es pas dans un véhicule.')
end
end)

RegisterNUICallback('extra:-5', function (data)
    local src = source
    local   player = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())

    -- local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
--   local   player = GetPlayerPed(src)
 if IsPedInAnyVehicle(PlayerPedId(), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), 0), -1) == PlayerPedId()) then
    SetVehicleExtra(vehicle , 5, 1)
else
   ESX.ShowNotification('~r~ERREUR~w~ :  Tu n\'es pas dans un véhicule.')
end
end)

RegisterNUICallback('extra:-6', function (data)
    local src = source
    local   player = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())

    -- local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
--   local   player = GetPlayerPed(src)
 if IsPedInAnyVehicle(PlayerPedId(), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), 0), -1) == PlayerPedId()) then
    SetVehicleExtra(vehicle , 6, 1)
else
   ESX.ShowNotification('~r~ERREUR~w~ :  Tu n\'es pas dans un véhicule.')
end
end)

RegisterNUICallback('extra:-7', function (data)
    local src = source
    local   player = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())

    -- local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
--   local   player = GetPlayerPed(src)
 if IsPedInAnyVehicle(PlayerPedId(), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), 0), -1) == PlayerPedId()) then
    SetVehicleExtra(vehicle , 7, 1)
else
    ESX.ShowNotification('~r~ERREUR~w~ :  Tu n\'es pas dans un véhicule.')
end
end)

RegisterNUICallback('extra:-8', function (data)
    local src = source
    local   player = PlayerPedId()
	local vehicle = GetVehiclePedIsIn(PlayerPedId())

    -- local playerVeh = GetVehiclePedIsIn(PlayerPedId(), false)
--   local   player = GetPlayerPed(src)
 if IsPedInAnyVehicle(PlayerPedId(), 0) and (GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), 0), -1) == PlayerPedId()) then
    SetVehicleExtra(vehicle , 8, 1)
else
    ESX.ShowNotification('~r~ERREUR~w~ :  Tu n\'es pas dans un véhicule.')
end
end)

-- Fin livery menu