function TriggerCallback(name, ...)
    local id = GetRandomIntInRange(0, 999999)
    local eventName = "gfx-mdt:triggerCallback:" .. id
    local eventHandler
    local promise = promise:new()
    RegisterNetEvent(eventName)
    local eventHandler = AddEventHandler(eventName, function(...)
        promise:resolve(...)
    end)

    SetTimeout(15000, function()
        promise:resolve("timeout")
        RemoveEventHandler(eventHandler)
    end)
    local args = {...}
    TriggerServerEvent(name, id, args)

    local result = Citizen.Await(promise)
    RemoveEventHandler(eventHandler)
    return result
end

function CreateBlip(coords, sprite, color, text, scale)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipColour(blip, color)
    SetBlipScale(blip, scale)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Prefix..""..text)
    EndTextCommandSetBlipName(blip)
    return blip
end

function GetStreetName(coords)
    local s1, _ = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
    local street = GetStreetNameFromHashKey(s1)
    return street:gsub("%-", " ")
end