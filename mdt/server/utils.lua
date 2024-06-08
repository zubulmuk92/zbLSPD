if Config.Framework == "qb" then
    QBCore = nil
    TriggerEvent("QBCore:GetObject", function(obj)
        QBCore = obj
    end)
elseif Config.Framework == "newqb" then
    QBCore = exports["qb-core"]:GetCoreObject()
elseif Config.Framework == "esx" then
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.Framework == "oldesx" then
    ESX = nil
    TriggerEvent("esx:getSharedObject", function(obj)
        ESX = obj
    end)
end

function RegisterCallback(name, cb)
    RegisterNetEvent(name, function(id, args)
        local src = source
        local eventName = "gfx-mdt:triggerCallback:" .. id
        CreateThread(function()
            local result = cb(src, table.unpack(args))
            TriggerClientEvent(eventName, src, result)
        end)
    end)
end

function tableContains(table, element, key)
    for i = 1, #table do
        if key then
            if table[i][key] == element then
                return true
            end
        else
            if table[i] == element then
                return true
            end
        end
    end
    return false
end

function getPlayerPP(id)
    return Avatars[id] and Avatars[id] or Config.DefaultAvatar
end

RegisterCallback("getPlayerPP", function(source, id)
    local avatar = getPlayerPP(id)
    return avatar
end)

exports("GetConfig", function()
    return Config
end)

exports("GetIdentifier", function(source, type)
    return GetIdentifier(source, type)
end)

function GetIdentifier(source, type)
    local identifiers = GetPlayerIdentifiers(source)
    for _, v in pairs(identifiers) do
        if string.find(v, type) then
            return v
        end
    end
end

function GetTimeDiffAs(time)
    local diff = os.time() - time
    local days = math.floor(diff / 86400)
    local hours = math.floor(diff / 3600)
    local minutes = math.floor(diff / 60)
    local seconds = diff
    if days > 0 then
        return ("%s days"):format(days)
    elseif hours > 0 then
        return ("%s hours"):format(hours)
    elseif minutes > 0 then
        return ("%s minutes"):format(minutes)
    elseif seconds > 0 then
        return ("%s seconds"):format(seconds)
    end
    return "0 seconds"
end

function GetPlayerId(source)
    if Config.Framework == "esx" or Config.Framework == "oldesx" then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            return xPlayer.identifier
        else
            local promise = promise:new()
            ExecuteSql(false, "SELECT * FROM users WHERE identifier=@identifier", {["@identifier"] = source}, function(result)
                if result[1] then
                    promise:resolve(result[1].identifier)
                end
            end)
            return Citizen.Await(promise)
        end
    elseif Config.Framework == "newqb" or Config.Framework == "qb" then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if xPlayer then
            return xPlayer.PlayerData.citizenid
        else
            local promise = promise:new()
            ExecuteSql(false, "SELECT * FROM players WHERE citizenid=@citizenid", {["@citizenid"] = source}, function(result)
                if result[1] then
                    promise:resolve(result[1].citizenid)
                end
            end)
            return Citizen.Await(promise)
        end
    end
end

function Notify(source, type, msg)
    if Config.Framework == "esx" or Config.Framework == "oldesx" then
        TriggerClientEvent("esx:showNotification", source, msg)
    elseif Config.Framework == "newqb" or Config.Framework == "qb" then
        TriggerClientEvent("QBCore:Notify", source, msg, type)
    end
end


function NumberToMoney(number)
    local retval = ""
    local i = 0
    repeat
        retval = retval .. string.sub(number, -3 * (i + 1), -3 * i - 1) .. ","
        i = i + 1
    until string.len(number) <= 3 * i
    retval = string.sub(retval, 1, -2)
    return Config.MoneySymbol..string.reverse(retval)
end

function MoneyToNumber(money)
    money = money:gsub("%$", "")
    money = money:gsub("%,", "")
    return tonumber(money)
end