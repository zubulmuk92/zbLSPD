local mdtOpened = false
local panicBlips = {}
local blipLoop = false
local prop = nil

-- RegisterNetEvent("jobUpdated", function()
--     getOnDutyList()
-- end)

RegisterNetEvent("gfx-mdt:client:openMDT", function()
    SetVisibility(true)
end)

RegisterNUICallback("hideFrame", function()
    SetVisibility(false)
end)

function SetVisibility(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        action = "setVisible",
        data = bool
    })
    mdtOpened = bool
    if bool then
        HoldTabletAnimLoop()
    else
        ClearTabletAnim(PlayerPedId())
        RemoveTabletProp()
    end
end

RegisterNetEvent("gfx-mdt:client:triggerPanic", function(panicType, name, coords)
    -- if mdtOpened then
    --     SendNUIMessage({
    --         action = "triggerPanic",
    --         data = {
    --             type = panicType,
    --             name = name,
    --             coords = coords
    --         }
    --     })
    -- end
    local blipData = Config.PanicTypes[panicType].blipData
    local blip = CreateBlip(coords, blipData.sprite, blipData.color, name, blipData.scale)
    table.insert(panicBlips, {
        blip = blip,
        type = panicType,
        started = GetGameTimer()
    })
    BlipLoop()
end)

function BlipLoop()
    if blipLoop then return end
    blipLoop = true
    Citizen.CreateThread(function()
        while #panicBlips > 0 do
            local time = GetGameTimer()
            for i = 1, #panicBlips do
                if time - panicBlips[i].started > Config.PanicTypes[panicBlips[i].type].blipData.blipDuration * 1000 then
                    RemoveBlip(panicBlips[i].blip)
                    table.remove(panicBlips, i)
                end
            end
            Wait(1000)
        end
        blipLoop = false
    end)
end

function HoldTabletAnimLoop()
    local ped = PlayerPedId()
    AttachTabletProp(ped)
    LoadAnimDict("amb@world_human_seat_wall_tablet@female@base")
    Citizen.CreateThread(function()
        while mdtOpened do
            if not IsEntityPlayingAnim(ped, "amb@world_human_seat_wall_tablet@female@base", "base", 3) then
                TaskPlayAnim(ped, "amb@world_human_seat_wall_tablet@female@base", "base", 8.0, -8, -1, 50, 0, false, false, false)
            end
            Wait(1000)
        end
        -- ClearTabletAnim(ped)
        -- RemoveTabletProp()
    end)
end

function LoadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

RegisterCommand("attch", function()
    local ped = PlayerPedId()
    mdtOpened = true
    HoldTabletAnimLoop()
end)

RegisterCommand("detach", function()
    mdtOpened = false
    RemoveTabletProp()
end)

function AttachTabletProp(ped)
    local bone = GetPedBoneIndex(ped, 28422)
    local model = GetHashKey("prop_cs_tablet")
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end
    prop = CreateObject(model, 1.0, 1.0, 1.0, 1, 1, 0)
    -- AttachEntityToEntity(prop, ped, bone, 0.03, -0.02, 0.0, 63,5, 460.0, 226.0, false, false, false, false, 2, false)
    AttachEntityToEntity(prop, ped, bone, 0.0, -0.01, 0.045, 0.0,0.0,0.0, true, false, false, false, 2, true)
    -- AttachEntityToEntityPhysically(prop, ped, bone, 0.03, -0.02, 0.0, 0.0, 0.0, 0.0, 63,5, 460.0, 226.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
    -- AttachEntityToEntity(prop, ped, bone, 0.03, -0.02, 0.0, 63,5, 460.0, 226.0, false, false, true, false, 0, false)
end

function RemoveTabletProp()
    DeleteEntity(prop)
    prop = nil
end

function ClearTabletAnim(ped)
    ClearPedTasks(ped)
end

AddEventHandler("onResourceStop", function(resource)
    if resource == GetCurrentResourceName() then
        RemoveTabletProp()
    end
end)

if Config.Framework == "qb" then
    QBCore = nil
    Citizen.CreateThread(function()
        while QBCore == nil do
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)
            Citizen.Wait(200)
        end
    end)
elseif Config.Framework == "newqb" then
    QBCore = exports["qb-core"]:GetCoreObject()
elseif Config.Framework == "esx" then
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.Framework == "oldesx" then
    ESX = nil
    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
            Citizen.Wait(200)
        end
    end)
end

function WaitForLoaded()
    if Config.Framework == "esx" or Config.Framework == "oldesx" then
        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end
    elseif Config.Framework == "qb" or Config.Framework == "newqb" then
        while QBCore.Functions.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end
    end
end