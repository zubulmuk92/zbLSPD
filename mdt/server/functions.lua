if Config.Framework == "esx" then
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.Framework == "oldesx" then
    ESX = nil
    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent("esx:getSharedObject", function(obj)
                ESX = obj
            end)
            Citizen.Wait(0)
        end
    end)
elseif Config.Framework == "qb" then
    QBCore = nil
    Citizen.CreateThread(function()
        while QBCore == nil do
            TriggerEvent("QBCore:GetObject", function(obj)
                QBCore = obj
            end)
            Citizen.Wait(0)
        end
    end)
elseif Config.Framework == "newqb" then
    QBCore = exports['qb-core']:GetCoreObject()
end

function GetCharName(source)
    local retval = "Unknown"
    local p = promise:new()
    if Config.Framework == "esx" or Config.Framework == "oldesx" then
        local xPlayer = ESX.GetPlayerFromId(source) or ESX.GetPlayerFromIdentifier(source)
        if xPlayer then
            p:resolve(xPlayer.getName())
        else
            ExecuteSql("SELECT * FROM users WHERE identifier = @identifier", {
                ["@identifier"] = source
            }, function(result)
                if result[1] then
                    p:resolve(result[1].firstname.. " " ..result[1].lastname)
                end
            end)
        end
    elseif Config.Framework == "newqb" or Config.Framework == "qb" then
        local xPlayer = QBCore.Functions.GetPlayer(source) or QBCore.Functions.GetPlayerByCitizenId(source)
        if xPlayer then
            p:resolve(xPlayer.PlayerData.charinfo.firstname.. " " ..xPlayer.PlayerData.charinfo.lastname)
        else
            ExecuteSql("SELECT * FROM players WHERE citizenid = @citizenid", {
                ["@citizenid"] = source
            }, function(result)
                if result[1] then
                    local charinfo = json.decode(result[1].charinfo)
                    p:resolve(charinfo.firstname.. " " ..charinfo.lastname)
                end
            end)
        end
    end
    return Citizen.Await(p)
end

function GetPoliceCount()
    local retval = 0
    local players = GetPlayers()
    for i = 1, #players do
        players[i] = tonumber(players[i])
        if Config.Framework == "qb" or Config.Framework == "newqb" then
            local xPlayer = QBCore.Functions.GetPlayer(players[i])
            if xPlayer then
                if xPlayer.PlayerData.job.name == "police" then
                    retval = retval + 1
                end
            end
        elseif Config.Framework == "esx" or Config.Framework == "oldesx" then
            local xPlayer = ESX.GetPlayerFromId(players[i])
            if xPlayer then
                if xPlayer.job.name == "police" then
                    retval = retval + 1
                end
            end
        end
    end
    return retval
end

function GetPoliceRank(source)
    local retval = "Unknown"
    local p = promise:new()
    if Config.Framework == "qb" or Config.Framework == "newqb" then
        local xPlayer = QBCore.Functions.GetPlayer(source) or QBCore.Functions.GetPlayerByCitizenId(source)
        if xPlayer then
            retval = xPlayer.PlayerData.job.grade.name
            p:resolve(retval)
        else
            ExecuteSql("SELECT * FROM players WHERE citizenid = @citizenid", {
                ["@citizenid"] = source
            }, function(result)
                if result[1] then
                    local job = json.decode(result[1].job)
                    retval = job.grade.name
                    p:resolve(retval)
                end
            end)
        end
    elseif Config.Framework == "esx" or Config.Framework == "oldesx" then
        local xPlayer = ESX.GetPlayerFromId(source) or ESX.GetPlayerFromIdentifier(source)
        if xPlayer then
            retval = xPlayer.job.grade_label
            p:resolve(retval)
        else
            ExecuteSql("SELECT * FROM users WHERE identifier = @identifier", {
                ["@identifier"] = source
            }, function(result)
                if result[1] then
                    retval = Config.JobGrades[result[1].job_grade] and Config.JobGrades[result[1].job_grade].label or "Unknown"
                    p:resolve(retval)
                end
            end)
        end
    end
    local result = Citizen.Await(p)
    return result
end

function IsPolice(source, key)
    key = key or "ableToUse"
    local retval = false
    if Config.Framework == "qb" or Config.Framework == "newqb" then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if xPlayer then
            if Config.Jobs[xPlayer.PlayerData.job.name] and Config.Jobs[xPlayer.PlayerData.job.name][key] then
                retval = xPlayer.PlayerData.job.name
            end
        end
    elseif Config.Framework == "esx" or Config.Framework == "oldesx" then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            if Config.Jobs[xPlayer.job.name] and Config.Jobs[xPlayer.job.name][key] then
                retval = xPlayer.job.name
            end
        end
    end
    return retval
end

function IsQBorESX()
    local retval = "esx"
    if Config.Framework == "qb" or Config.Framework == "newqb" then
        retval = "qb"
    end
    return retval
end

function GetRecordFromId(id)
    local retval = nil
    for i = 1, #Records do
        if tonumber(Records[i].id) == tonumber(id) then
            retval = Records[i]
            break
        end
    end
    return retval
end

function GetWantedFromId(id)
    local retval = nil
    for i = 1, #Wanteds do
        if tonumber(Wanteds[i].id) == tonumber(id) then
            retval = Wanteds[i]
            break
        end
    end
    return retval
end

function GetDailyRecordCount()
    local retval = 0
    for i = 1, #Records do
        if Records[i].date == os.date("%d.%m.%Y") then
            retval = retval + 1
        end
    end
    return retval
end

GetDailyWanteds = function()
    local retval = 0
    for i = 1, #Wanteds do
        if Wanteds[i].date == os.date("%d.%m.%Y") then
            retval = retval + 1
        end
    end
    return retval
end

function GetOffenderDeatils(id, source)
    return Offenders[id] or {
        id = id,
        avatar = "https://cdn.discordapp.com/attachments/1094660235479744552/1130093407583338607/eyyyyyyyoooooohabeeeeeer.png",
        name = GetCharName(id),
        madeBy = GetCharName(source),
        ranks = {
            {label = Config.CrimeTags[1].label, value = 1},
        },
        reportText =  'No report text',
        evidences =  {},
        fines = {},
    }
end

function GetPoliceDeatils(id, source)
    return Polices[id] or {
        id = id,
        avatar = "https://cdn.discordapp.com/attachments/1094660235479744552/1130093407583338607/eyyyyyyyoooooohabeeeeeer.png",
        name = GetCharName(id),
        madeBy = GetCharName(source),
        ranks = {},
        reportText =  'No report text',
        evidences =  {},
    }
end

function GetWantedDeatils(id, source)
    local wanted = GetWantedFromId(id)
    wanted.madeBy = wanted.addedBy
    return wanted
end

function GetFineFromId(id)
    local retval = nil
    for i = 1, #Fines do
        if tonumber(Fines[i].id) == tonumber(id) then
            retval = Fines[i]
            break
        end
    end
    return retval
end

function GetBanCount()
    local retval = 0
    for i = 1, #Banlist do
        retval = retval + 1
    end
    return retval
end

function AddNotify(title, text, nType)
    local id = Notifications[#Notifications] and Notifications[#Notifications].id + 1 or 1
    local notifyData = {
        id = id,
        title = title,
        text =  text,
        type =  nType,
    }
    table.insert(Notifications, notifyData)
    ExecuteSql("INSERT INTO `gfxmdt_notifications` (`id`, `title`, `text`, `type`) VALUES (@id, @title, @text, @type)", {
        ["@id"] = notifyData.id,
        ["@title"] = notifyData.title,
        ["@text"] = notifyData.text,
        ["@type"] = notifyData.type,
    }, function(result)
        if result then
            TriggerClientEvent("qb-police:client:UpdateNotifications", -1, notifyData)
        end
    end)
end

function GetLastRecord()
    local retval = nil
    for i = 1, #Records do
        if not retval then
            retval = Records[i]
        elseif Records[i].id > retval.id then
            retval = Records[i]
        end
    end
    return retval
end

function GetLastWnted()
    local retval = nil
    for i = 1, #Wanteds do
        if not retval then
            retval = Wanteds[i]
        elseif Wanteds[i].id > retval.id then
            retval = Wanteds[i]
        end
    end
    return retval
end