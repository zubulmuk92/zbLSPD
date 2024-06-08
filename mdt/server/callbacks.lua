RegisterCallback("gfx-mdt:getInfo", function(source)
    local playerId = GetPlayerId(source)
    local data = {
        policeAvatar = getPlayerPP(playerId),
        policeName = GetCharName(source),
        policeRank = GetPoliceRank(source),
        onlinePolice = GetPoliceCount(),
        dailyRecordsCount = GetDailyRecordCount(),
        dailyWantedsCount = GetDailyWanteds(),
        totalRecordsCount = #Records,
        totalWantedsCount = #Wanteds,
    }
    return data
end)

RegisterCallback("gfx-mdt:getMessages", function(source)
    return Messages
end)

RegisterCallback("gfx-mdt:addMessage", function(source, data)
    local lastMessage = Messages[#Messages] or {
        id = 0
    }
    Messages[#Messages + 1] = {
        id = tonumber(lastMessage.id) + 1,
        text = data.text,
        title = data.title,
    }
    return Messages[#Messages]
end)

RegisterCallback("gfx-mdt:notifyMessage", function(source, data)
    local lastMessage = Messages[#Messages] or {
        id = 0
    }
    Messages[#Messages + 1] = {
        id = tonumber(lastMessage.id) + 1,
        message = data.message,
        title = data.title,
    }
    return Messages[#Messages]
end)

RegisterCallback("gfx-mdt:getNotifications", function(source)
    local startIndex = #Notifications - 9 > 0 and #Notifications - 9 or 1
    local endIndex = startIndex + 10
    local records = {}
    for i = startIndex, endIndex do
        if Notifications[i] then
            table.insert(records, Notifications[i])
        end
    end
    return records
end)

RegisterCallback("gfx-mdt:getUsersForSelect", function(source)
    local userList = {}
    ExecuteSql(("SELECT * FROM %s"):format(Config.UsersTable), {}, function(result)
        for i = 1, #result do
            local name = "Unknown"
            local fw = IsQBorESX()
            if fw == "qb" or fw == "newqb" then
                result[i].job = json.decode(result[i].job)
                result[i].charinfo = json.decode(result[i].charinfo)
                name = result[i].charinfo.firstname .. " " .. result[i].charinfo.lastname
            elseif fw == "esx" or fw == "oldesx" then
                name = result[i].firstname .. " " .. result[i].lastname
            end
            table.insert(userList, {
                label = name,
                value = Config.UsersTable == "users" and result[i].identifier or result[i].citizenid,
                avatar = result[i].avatar or Config.DefaultAvatar,
                isPolice = Config.Jobs[result[i].job] ~= nil and Config.Jobs[result[i].job].ableToUse,
            })
        end
    end)
    return userList
end)

RegisterCallback("gfx-mdt:getVehiclesForSelect", function(source)
    local userList = {}
    local vehicles = {}
    local p = promise:new()
    ExecuteSql(("SELECT * FROM %s"):format(Config.VehiclesTable), {}, function(result)
        if result then
            for i = 1, #result do
                if result[i] then
                    local fw = IsQBorESX()
                    local vehicleData = {
                        value = result[i].vehiclePlate,
                        label = result[i].vehiclePlate,
                        avatar = ((fw == "qb" or fw == "newqb") and result[i].image or result[i].avatar) or Config.DefaultVehicleAvatar,
                    }
                    Avatars[result[i].vehiclePlate] = vehicleData.avatar
                    table.insert(vehicles, vehicleData)
                end
            end
            p:resolve(vehicles)
        end
    end)
    return Citizen.Await(p)
end)

RegisterCallback("gfx-mdt:addFines", function(source, data)
    local money = MoneyToNumber(data.money)
    local playerName = GetCharName(source)
    local currentTime = os.time()
    local lastFine = Fines[#Fines] or {
        id = 0
    }
    table.insert(Fines, {
        id = tonumber(lastFine.id) + 1,
        lastEdited = ('Last edited 0 seconds ago by %s'):format(playerName),
        fields = {
            {text = data.name},
            {text = data.punishment},
            {text = playerName},
        },
        money = money,
        jailTime = data.jailTime,
        jailType = data.jailTimeType,
    })
    local fine = Fines[#Fines]
    AddNotify(Locales["title_fine_added"]:format(playerName), Locales["text_fine_added"]:format(data.name), "added")
    ExecuteSql("INSERT INTO gfxmdt_fines (id, name, jailTime, jailType, money, lastEdited, addedBy) VALUES (@id, @name, @jailTime, @jailType, @money, @lastEdited, @addedBy)", {
        ["@id"] = tonumber(lastFine.id) + 1,
        ['@name'] = data.name,
        ['@jailTime'] = data.jailTime,
        ['@money'] = money,
        ['@lastEdited'] = json.encode({time = currentTime, editedBy = playerName}),
        ["@jailType"] = data.jailTimeType,
        ['@addedBy'] = playerName,
    })
    return {id = fine.id, lastEdited = fine.lastEdited, addedBy = playerName}
end)

RegisterCallback("gfx-mdt:getFines", function(source, data)
    return Fines
end)

RegisterCallback("gfx-mdt:getFinesForSelect", function()
    local fines = {}
    for i = 1, #Fines do
        
        table.insert(fines, {
            label = Fines[i].name.. " - " ..Fines[i].jailTime.. " " ..Fines[i].jailType.. " - " ..NumberToMoney(Fines[i].money),
            value = Fines[i].id,
        })
    end
    return fines
end)

RegisterCallback("gfx-mdt:editFine", function(source, data)
    local playerName = GetCharName(source)
    local currentTime = os.time()
    local fine = GetFineFromId(data.id)
    fine.lastEdited = {
        time = currentTime,
        editedBy = playerName,
    }
    fine.fields = {
        {text = data.name},
        {text = data.punishment},
        {text = playerName},
    }
    AddNotify(Locales["title_fine_added"]:format(playerName), Locales["text_fine_added"]:format(data.name), "changed")
    ExecuteSql("UPDATE gfxmdt_fines SET name = @name, punishment = @punishment, lastEdited = @lastEdited WHERE id = @id", {
        ["@id"] = data.id,
        ['@name'] = data.name,
        ['@punishment'] = data.punishment,
        ['@lastEdited'] = json.encode({time = currentTime, editedBy = playerName}),
    })
    return fine
end)

RegisterCallback("gfx-mdt:addRecords", function(source, data)
    local playerName = GetCharName(source)
    local currentTime = os.time()
    local lastRecord = GetLastRecord() or {
        id = 0
    }
    local function ListRanks()
        local ranks = {}
        for i = 1, #data.ranks do
            table.insert(ranks, data.ranks[i].id)
        end
        return ranks
    end
    table.insert(Records, {
        id = tonumber(lastRecord.id) + 1,
        avatar = Config.DefaultAvatar,
        name = data.recordTitle,
        text = "#"..tonumber(lastRecord.id) + 1,
        ranks = data.ranks,
        date = os.date("%d.%m.%Y"),
        addedBy = playerName,
    })
    local record = Records[#Records]
    ExecuteSql("INSERT INTO gfxmdt_records (id, avatar, name, text, ranks, date, reportText, addedBy) VALUES (@id, @avatar, @name, @text, @ranks, @date, @reportText, @addedBy)", {
        ["@id"] = record.id,
        ['@avatar'] = record.avatar,
        ['@name'] = record.name,
        ['@text'] = record.text,
        ['@ranks'] = json.encode(ListRanks()),
        ['@date'] = record.date,
        ['@addedBy'] = record.addedBy,
        ["@reportText"] = Config.Locales["no_report_text"]
    })
    AddNotify(Locales["title_record_added"]:format(record.addedBy), Locales["text_record_added"]:format(record.name), "added")
    return record
end)

RegisterCallback("gfx-mdt:getRecords", function(source, data)
    local startIndex = #Records - 10 > 0 and #Records - 10 or 1
    local endIndex = startIndex + 9
    local records = {}
    for i = startIndex, endIndex do
        if Records[i] then
            table.insert(records, Records[i])
        end
    end
    return records
end)

RegisterCallback("gfx-mdt:getRecordDetail", function(source, id)
    local record = GetRecordFromId(id)
    record.reportedPolice = record.addedBy
    record.reportText = record.reportText or Config.Locales["no_report_text"]
    record.evidences = record.evidences or {}
    record.offenders = record.offenders or {}
    record.polices = record.polices or {}
    return record
end)

RegisterCallback("gfx-mdt:deleteRecord", function(source, id)
    ExecuteSql("DELETE FROM gfxmdt_records WHERE id = @id", {["@id"] = id})
    for i = 1, #Records do
        if Records[i].id == id then
            AddNotify(Locales["title_record_deleted"]:format(Records[i].addedBy), Locales["text_record_deleted"]:format(Records[i].name), "deleted")
            table.remove(Records, i)
            break
        end
    end
end)

RegisterCallback("gfx-mdt:addRanksForRecord", function(source, data)
    local record = GetRecordFromId(data.recordId)
    local rankIds = {}
    
    for i = 1, #record.ranks do
        table.insert(rankIds, record.ranks[i].id)
    end
    for i = 1, #data.ranks do
        if not tableContains(rankIds, data.ranks[i].id) then
            table.insert(rankIds, data.ranks[i].id)
            table.insert(record.ranks, data.ranks[i])
        end
    end
    local playerName = GetCharName(source)
    AddNotify(Locales["updated_record"]:format(playername, record.name), Locales["added_rank_record_text"]:format(#rankIds), "changed")
    ExecuteSql("UPDATE gfxmdt_records SET ranks = @ranks WHERE id = @id", {
        ["@ranks"] = json.encode(rankIds),
        ["@id"] = data.recordId,
    })
    return data.ranks
end)

RegisterCallback("gfx-mdt:deleteRankFromRecord", function(source, data)
    local record = GetRecordFromId(data.recordId)
    local rankIds = {}
    for i = 1, #record.ranks do
        table.insert(rankIds, record.ranks[i].id)
    end
    if #record.ranks == 1 then
        return {error = true, message = "You can't delete the last rank."}
    end
    for i = 1, #rankIds do
        if rankIds[i] == data.id then
            table.remove(rankIds, i)
            local playerName = GetCharName(source)
            AddNotify(Locales["updated_record"]:format(playername, record.name), Locales["removed_rank_record_text"]:format(Config.CrimeTags[data.id].label), "changed")
            break
        end
    end
    ExecuteSql("UPDATE gfxmdt_records SET ranks = @ranks WHERE id = @id", {
        ["@ranks"] = json.encode(rankIds),
        ["@id"] = data.recordId,
    })
    for i = 1, #record.ranks do
        if record.ranks[i].id == data.id then
            table.remove(record.ranks, i)
            break
        end
    end
    return {success = true, data = data.id}
end)

RegisterCallback("gfx-mdt:editReportTextFromRecord", function(source, data)
    local record = GetRecordFromId(data.id)
    local playerName = GetCharName(source)
    AddNotify(Locales["updated_record"]:format(playername, record.name), Locales["edited_reportText"], "changed")
    record.reportText = data.reportText

    ExecuteSql("UPDATE gfxmdt_records SET reportText = @reportText WHERE id = @id", {
        ["@reportText"] = data.reportText,
        ["@id"] = data.id,
    })
    return data.reportText
end)

RegisterCallback("gfx-mdt:addOffenders", function(source, data)
    print(json.encode(data))
    local record = GetRecordFromId(data.recordId)
    local cacheData = {}
    local playername = GetCharName(source)
    if record.offenders[#record.offenders] then
        record.offenders[#record.offenders].counter = record.offenders[#record.offenders].counter or #record.offenders
    end
    local lastOffender = record.offenders[#record.offenders] or {
        counter = 0
    }
    local containedCount = 0

    local fines = {}
    for i = 1, #data.fines do
        local v = data.fines[i]
        table.insert(fines, v.value)
        v.name = v.label
        v.id = v.value
        v.value = nil
        v.label = nil
    end

    for i = 1, #data.offenders do
        local offenderData = {
            id = data.offenders[i].value,
            date = os.date("%d.%m.%Y"),
            text = "#"..lastOffender.counter + 1,
            counter = lastOffender.counter + 1,
            fines = fines,
        }
        if not tableContains(record.offenders, offenderData.id, "id") then
            table.insert(record.offenders, offenderData)
            ExecuteSql("UPDATE gfxmdt_records SET offenders = @offenders WHERE id = @id", {
                ["@offenders"] = json.encode(record.offenders),
                ["@id"] = data.recordId,
            })
            offenderData.avatar = getPlayerPP(data.offenders[i].value)
            offenderData.name = GetCharName(data.offenders[i].value)
            offenderData.ranks = {
                {name = Config.CrimeTags[1].label, id = "1"}
            }
            offenderData.addedBy = playername
            table.insert(cacheData, offenderData)
            AddNotify(Locales["updated_record"]:format(playername, record.name), Locales["added_offenders"]:format(offenderData.name, record.name), "changed")
            local savedOffenderData = {
                id = offenderData.id,
                avatar = offenderData.avatar,
                name = offenderData.name,
                madeBy = offenderData.addedBy,
                ranks = {"1"},
                reportText =  'No report text',
                evidences =  {},
                fines = fines
            }
            if not Offenders[offenderData.id] then
                Offenders[offenderData.id] = savedOffenderData
                ExecuteSql("INSERT INTO gfxmdt_offenders (id, avatar, name, madeBy, ranks, reportText, evidences, fines) VALUES (@id, @avatar, @name, @madeBy, @ranks, @reportText, @evidences, @fines)", {
                    ["@id"] = savedOffenderData.id,
                    ['@avatar'] = savedOffenderData.avatar,
                    ['@name'] = savedOffenderData.name,
                    ['@madeBy'] = savedOffenderData.madeBy,
                    ['@ranks'] = json.encode(savedOffenderData.ranks),
                    ['@reportText'] = savedOffenderData.reportText,
                    ['@evidences'] = json.encode(savedOffenderData.evidences),
                    ["@fines"] = json.encode(savedOffenderData.fines)
                })
                Offenders[offenderData.id].ranks = offenderData.ranks
                Offenders[offenderData.id].fines = data.fines
            end
        else
            containedCount = containedCount + 1
        end
    end
    if containedCount ~= 0 then
        return {error = true, message = containedCount.. " offender(s) are already assigned to this record. Unassigned offenders will be added. Refresh the page to see the changes."}
    end
    return {data = cacheData, success = true}
end)

RegisterCallback("gfx-mdt:deleteOffender", function(source, data)
    local record = GetRecordFromId(data.recordId)
    local playername = GetCharName(source)
    local cacheData = {}
    for i = 1, #record.offenders do
        if record.offenders[i].id == data.id then
            table.remove(record.offenders, i)
            local offenderName = GetCharName(data.id)
            AddNotify(Locales["updated_record"]:format(playername, record.name), Locales["removed_offenders"]:format(offenderName), "changed")

            ExecuteSql("UPDATE gfxmdt_records SET offenders = @offenders WHERE id = @id", {
                ["@offenders"] = json.encode(record.offenders),
                ["@id"] = data.recordId,
            })
            break
        end
    end
    for i = 1, #record.offenders do
        local offenderData = record.offenders[i]
        offenderData.avatar = getPlayerPP(offenderData.id)
        offenderData.name = GetCharName(offenderData.id)
        offenderData.ranks = {
            {name = Config.CrimeTags[1].label, id = 1}
        }
        offenderData.addedBy = GetCharName(source)
        table.insert(cacheData, offenderData)
    end
    return {data = cacheData, success = true}
end)

RegisterCallback("gfx-mdt:getOnDutyList", function(source)
    local onDutyList = {}
    local players = GetPlayers()
    for i = 1, #players do
        local player = tonumber(players[i])
        local job = IsPolice(player, "mapColor")
        if job then
            local addBool, onDuty = false, false
            local fw = IsQBorESX()
            if fw == "qb" or fw == "newqb" then
                local qbplayer = QBCore.Functions.GetPlayer(player)
                if qbplayer.PlayerData.job.onduty then
                    addBool = qbplayer.PlayerData.citizenid
                    onDuty = qbplayer.PlayerData.job.onduty
                end
            elseif fw == "esx" or fw == "oldesx" then
                local esxplayer = ESX.GetPlayerFromId(player)
                addBool = esxplayer.identifier
            end
            if addBool then
                local ped = GetPlayerPed(player)
                local rankInfo = GetPoliceRank(player)
                local ableToUse = IsPolice(player, "ableToUse")
                if Appointments[addBool] == nil then
                    Appointments[addBool] = os.time()
                end
                table.insert(onDutyList, {
                    id = player,
                    ableToUse = ableToUse,
                    avatar = getPlayerPP(addBool),
                    name = GetCharName(player),
                    text = (fw == "esx" or fw == "oldesx") and 'Online' or (onDuty and 'On Duty' or 'Off Duty'),
                    level = rankInfo,
                    coords = ped ~= 0 and GetEntityCoords(ped) or false,
                    rankInfo = rankInfo,
                    circleColor = Config.Jobs[job].mapColor,
                    dutyTimes = ableToUse and ('Since %s'):format(GetTimeDiffAs(Appointments[addBool] or os.time())) or "",
                    appointementDate = ableToUse and os.date("%d/%m/%Y %H:%M", Appointments[addBool] or os.time()) or "",
                })
            end
        end
    end
    return onDutyList
end)

RegisterCallback("gfx-mdt:getLivemap", function()
    local mapData = {}
    local players = GetPlayers()
    for i = 1, #players do
        local player = tonumber(players[i])
        if IsPolice(player, "mapColor") then
            local addBool, onDuty = false, false
            local fw = IsQBorESX()
            if fw == "qb" or fw == "newqb" then
                local qbplayer = QBCore.Functions.GetPlayer(player)
                if qbplayer.PlayerData.job.onduty then
                    addBool = qbplayer.PlayerData.citizenid
                    onDuty = qbplayer.PlayerData.job.onduty
                end
            elseif fw == "esx" or fw == "oldesx" then
                local esxplayer = ESX.GetPlayerFromId(player)
                addBool = esxplayer.identifier
            end
            if addBool then
                local ped = GetPlayerPed(player)
                local rankInfo = GetPoliceRank(player)
                table.insert(mapData, {
                    id = player,
                    avatar = getPlayerPP(addBool),
                    name = GetCharName(player),
                    coords = ped ~= 0 and GetEntityCoords(ped) or false,
                    rankInfo = rankInfo,
                })
            end
        end
    end
    return mapData
end)

RegisterCallback("gfx-mdt:addEvidencesForRecord", function(source, data)
    local record = GetRecordFromId(data.recordId)
    local lastEvidence = record.evidences[#record.evidences] or {
        id = 0
    }
    local evidences = {
        id = tonumber(lastEvidence.id) + 1,
        name = data.name,
        image = data.image,
    }
    table.insert(record.evidences, evidences)
    ExecuteSql("UPDATE gfxmdt_records SET evidences = @evidences WHERE id = @id", {
        ["@evidences"] = json.encode(record.evidences),
        ["@id"] = data.recordId,
    })
    AddNotify(Locales["updated_record"]:format(GetCharName(source), record.name), Locales["added_evidence_to_record"], "changed")
    return evidences
end)

RegisterCallback("gfx-mdt:deleteEvidenceFromRecord", function(source, data)
    local record = GetRecordFromId(data.recordId)
    for i = 1, #record.evidences do
        if record.evidences[i].id == data.id then
            table.remove(record.evidences, i)
            AddNotify(Locales["updated_record"]:format(GetCharName(source), record.name), Locales["removed_evidence_from_record"], "changed")
            break
        end
    end
    ExecuteSql("UPDATE gfxmdt_records SET evidences = @evidences WHERE id = @id", {
        ["@evidences"] = json.encode(record.evidences),
        ["@id"] = data.recordId,
    })
    return data.id
end)

RegisterCallback("gfx-mdt:getOffenderDetail", function(source, data)
    return GetOffenderDeatils(data.id, source)
end)

RegisterCallback("gfx-mdt:getPoliceDetail", function(source, data)
    return GetPoliceDeatils(data.id, source)
end)

RegisterCallback("gfx-mdt:getWanteds", function(source, data)
    return Wanteds
end)

RegisterCallback("gfx-mdt:addWanteds", function(source, data)
    if next(data.ranks) == nil then
        data.ranks = {
            {
                id = 1,
                name = "None",    
            }
        }
    end
    local lastWanted = GetLastWnted() or {
        id = 0
    }
    local function ListRanks()
        local ranks = {}
        for i = 1, #data.ranks do
            table.insert(ranks, data.ranks[i].id)
        end
        return ranks
    end
    local wanted
    if data.type == "user" then
        wanted = {
            id = tonumber(lastWanted.id) + 1,
            avatar = getPlayerPP(data.suspectId),
            name = GetCharName(data.suspectId),
            text = "#"..tonumber(lastWanted.id) + 1,
            ranks = data.ranks,
            evidences = {},
            date = os.date("%d.%m.%Y"),
            addedBy = GetCharName(source),
            type = data.type,
        }
    else
        wanted = {
            id = tonumber(lastWanted.id) + 1,
            avatar = getPlayerPP(data.vehiclePlate),
            name = data.vehiclePlate,
            text = "#"..tonumber(lastWanted.id) + 1,
            ranks = {
                {
                    id = 1,
                    name = "None",    
                }
            },
            evidences = {},
            date = os.date("%d.%m.%Y"),
            addedBy = GetCharName(source),
            type = data.type,
        }
    end

    table.insert(Wanteds, wanted)
    AddNotify(Locales["created_wanted"]:format(GetCharName(source)), Locales["created_wanted_text"]:format(Wanteds[#Wanteds].name, data.ranks[1] and data.ranks[1].label or Config.CrimeTags[1].label), "user-added")

    ExecuteSql("INSERT INTO gfxmdt_wanteds (id, avatar, name, ranks, date, reportText, addedBy, evidences, type) VALUES (@id, @avatar, @name, @ranks, @date, @reportText, @addedBy, @evidences, @type)", {
        ["@id"] = Wanteds[#Wanteds].id,
        ['@avatar'] = Wanteds[#Wanteds].avatar,
        ['@name'] = Wanteds[#Wanteds].name,
        ['@ranks'] = json.encode(ListRanks()),
        ['@date'] = os.date("%d.%m.%Y"),
        ['@addedBy'] = Wanteds[#Wanteds].addedBy,
        ["@reportText"] = Config.Locales["no_report_text"],
        ["@evidences"] = json.encode(Wanteds[#Wanteds].evidences),
        ["@type"] = data.type,
    })
    return Wanteds[#Wanteds]
end)

RegisterCallback("gfx-mdt:deleteWanted", function(source, data)
    local officerName = GetCharName(source)
    for i = 1, #Wanteds do
        if Wanteds[i].id == data.id then
            AddNotify(Locales["wanted_deleted"]:format(officerName), Locales["wanted_deleted_text"]:format(Wanteds[i].name), "deleted")
            table.remove(Wanteds, i)
            break
        end
    end
    ExecuteSql("DELETE FROM gfxmdt_wanteds WHERE id = @id", {
        ["@id"] = data.id,
    })
    return data.id
end)

RegisterCallback("gfx-mdt:addPolices", function(source, data)
    local record = GetRecordFromId(data.recordId)
    local cacheData = {}
    local lastOffender = record.polices[#record.polices] or {
        id = 0
    }
    local containedCount = 0
    local sourceName = GetCharName(source)
    for i = 1, #data.polices do
        
        local policeData = {
            id = data.polices[i].value,
            date = os.date("%d.%m.%Y"),
        }
        if not tableContains(record.polices, policeData.id, "id") then
            table.insert(record.polices, policeData)
            ExecuteSql("UPDATE gfxmdt_records SET polices = @polices WHERE id = @id", {
                ["@polices"] = json.encode(record.polices),
                ["@id"] = data.recordId,
            })
            policeData.avatar = getPlayerPP(data.polices[i].value)
            policeData.name = GetCharName(data.polices[i].value)
            policeData.ranks = {
                {
                    id = 1,
                    name = GetPoliceRank(data.polices[i].value),    
                }
            }
            policeData.addedBy = GetCharName(source)
            table.insert(cacheData, policeData)
            AddNotify(Locales["updated_record"]:format(sourceName, record.name), Locales["added_polices"]:format(policeData.name), "changed")

            local savedPoliceData = {
                id = policeData.id,
                avatar = policeData.avatar,
                name = policeData.name,
                madeBy = policeData.addedBy,
                ranks = policeData.ranks,
                reportText =  'No report text',
                evidences =  {},
            }
            if not Polices[policeData.id] then
                Polices[policeData.id] = savedPoliceData
                ExecuteSql("INSERT INTO gfxmdt_polices (id, avatar, name, madeBy, ranks, reportText, evidences) VALUES (@id, @avatar, @name, @madeBy, @ranks, @reportText, @evidences)", {
                    ["@id"] = savedPoliceData.id,
                    ['@avatar'] = savedPoliceData.avatar,
                    ['@name'] = savedPoliceData.name,
                    ['@madeBy'] = savedPoliceData.madeBy,
                    ['@ranks'] = json.encode(savedPoliceData.ranks),
                    ['@reportText'] = savedPoliceData.reportText,
                    ['@evidences'] = json.encode(savedPoliceData.evidences),
                })
            end
        else
            containedCount = containedCount + 1
        end
    end
    if containedCount ~= 0 then
        return {error = true, message = containedCount.. " offender(s) are already assigned to this record. Unassigned offenders will be added. Refresh the page to see the changes."}
    end
    return {data = cacheData, success = true}
end)

RegisterCallback("gfx-mdt:getHotWantedList", function(source, data)
    return GetWantedsOfLastThreeDays()
end)

function GetWantedsOfLastThreeDays()
    local wanteds = {}
    local currentTime = os.time()
    for i = 1, #Wanteds do
        local wanted = Wanteds[i]
        local wantedTime = wanted.date
        local wantedTime = os.time({year = wantedTime:sub(7, 10), month = wantedTime:sub(4, 5), day = wantedTime:sub(1, 2)})
        local diff = currentTime - wantedTime
        local days = math.floor(diff / 86400)
        if days <= 3 then
            wanted.assignedPolice = wanted.addedBy
            wanted.avatarCircle = "blue"
            table.insert(wanteds, wanted)
        end
    end
    return wanteds
end

RegisterCallback("gfx-mdt:getWantedDetail", function(source, data)
    return GetWantedDeatils(data.id, source)
end)

RegisterCallback("gfx-mdt:addEvidenceToWanted", function(source, data)
    local wanted = GetWantedFromId(data.wantedId)
    local lastEvidence = wanted.evidences[#wanted.evidences] or {
        id = 0
    }
    local evidences = {
        id = tonumber(lastEvidence.id) + 1,
        name = data.name,
        image = data.image,
    }
    table.insert(wanted.evidences, evidences)
    AddNotify(Locales["updated_wanted"]:format(GetCharName(source), wanted.name), Locales["added_evidence_to_wanted"], "changed")

    ExecuteSql("UPDATE gfxmdt_wanteds SET evidences = @evidences WHERE id = @id", {
        ["@evidences"] = json.encode(wanted.evidences),
        ["@id"] = data.wantedId,
    })
    return evidences
end)

RegisterCallback("gfx-mdt:editReportTextFromWanted", function(source, data)
    local wanted = GetWantedFromId(data.id)
    wanted.reportText = data.reportText
    AddNotify(Locales["updated_wanted"]:format(GetCharName(source), wanted.name), Locales["edited_reportText"], "changed")
    ExecuteSql("UPDATE gfxmdt_wanteds SET reportText = @reportText WHERE id = @id", {
        ["@reportText"] = data.reportText,
        ["@id"] = data.id,
    })
    return data.reportText
end)

RegisterCallback("gfx-mdt:addRankToWanted", function(source, data)
    local wanted = GetWantedFromId(data.wantedId)
    local rankIds = {}
    
    for i = 1, #wanted.ranks do
        table.insert(rankIds, wanted.ranks[i].id)
    end
    local rankStr = ""
    for i = 1, #data.ranks do
        if not tableContains(rankIds, data.ranks[i].id) then
            table.insert(rankIds, data.ranks[i].id)
            rankStr = rankStr .. data.ranks[i].name .. ", "
            table.insert(wanted.ranks, data.ranks[i])
        end
    end
    if rankStr ~= "" then
        AddNotify(Locales["updated_wanted"]:format(GetCharName(source), wanted.name), Locales["addRankToWanted"]:format(rankStr:sub(1, #rankStr - 2)), "changed")
        ExecuteSql("UPDATE gfxmdt_wanteds SET ranks = @ranks WHERE id = @id", {
            ["@ranks"] = json.encode(rankIds),
            ["@id"] = data.wantedId,
        })
    end
    return data.ranks
end)



RegisterCallback("gfx-mdt:deleteRankFromWanted", function(source, data)
    local wanted = GetWantedFromId(data.wantedId)
    local rankIds = {}
    for i = 1, #wanted.ranks do
        table.insert(rankIds, wanted.ranks[i].id)
    end
    if #wanted.ranks == 1 then
        return {error = true, message = "You can't delete the last rank."}
    end
    for i = 1, #rankIds do
        if rankIds[i] == data.id then
            AddNotify(Locales["updated_wanted"]:format(GetCharName(source), wanted.name), Locales["deleted_rank_from_wanted"]:format(wanted.ranks[i].name), "changed")
            table.remove(rankIds, i)
            break
        end
    end
    ExecuteSql("UPDATE gfxmdt_wanteds SET ranks = @ranks WHERE id = @id", {
        ["@ranks"] = json.encode(rankIds),
        ["@id"] = data.wantedId,
    })
    for i = 1, #wanted.ranks do
        if wanted.ranks[i].id == data.id then
            table.remove(wanted.ranks, i)
            break
        end
    end
    return {success = true, data = data.id}
end)

RegisterCallback("gfx-mdt:getBanList", function(source)
    return Banlist
end)

RegisterCallback("gfx-mdt:addBannedUsers", function(source, data)
    local bannedUsers = data.bannedUsers
    local cacheData = {}
    local containedCount = 0
    local lastBanned = Banlist[#Banlist] or {
        counter = 0
    }
    local nameStr = ""
    for i = 1, #bannedUsers do
        local item = bannedUsers[i]
        if not tableContains(Banlist, item.id, "id") then    
            local userData = {
                id = item.id,
                avatar = getPlayerPP(item.id),
                name = item.name,
                text = "#"..(lastBanned.counter + 1),
                bans = {
                    {
                        id = 1,
                        name = GetPoliceRank(item.id),
                    }
                },
                status = os.date("%d.%m.%Y"),
                rank = GetCharName(source),
                counter = lastBanned.counter + 1,
            }
            nameStr = nameStr .. item.name .. ", "
            table.insert(cacheData, userData)
            ExecuteSql("INSERT INTO gfxmdt_banlist (id, name, addedBy, date, avatar, ranks) VALUES (@id, @name, @addedBy, @date, @avatar, @bans)", {
                ["@id"] = item.id,
                ["@name"] = item.name,
                ["@date"] = os.date("%d.%m.%Y"),
                ["@addedBy"] = userData.rank,
                ["@avatar"] = userData.avatar,
                ["@bans"] = json.encode(userData.bans),
            })
            Banlist[#Banlist + 1] = userData
        else
            containedCount = containedCount + 1
        end
    end
    if nameStr ~= "" then
        AddNotify(Locales["officer_banned"]:format(GetCharName(source), "LSPD"), Locales["addBannedUsers"]:format(nameStr:sub(1, #nameStr - 2)), "deleted")
    end 
    if containedCount ~= 0 then
        return {error = true, message = containedCount.." users are already banned. Please reload the page. Unbanned ones are added."}
    end
    return {success = true, data = cacheData}
end)

RegisterCallback("gfx-mdt:deleteBanList", function(source, data)
    local id = data.id
    local name = ""
    for i = 1, #Banlist do
        if Banlist[i].id == id then
            name = Banlist[i].name
            table.remove(Banlist, i)
            break
        end
    end
    AddNotify(Locales["officer_unbanned"]:format(GetCharName(source), "LSPD"), Locales["deleteBanList"]:format(name), "user-added")
    ExecuteSql("DELETE FROM gfxmdt_banlist WHERE id = @id", {
        ["@id"] = id,
    })
    -- return cacheData
end)

RegisterCallback("gfx-mdt:getSearchResults", function(source, data)
    local searchResults = {}
    local search = data.value
    local users = {}
    local records = {}
    local wanteds = {}
    local vehicles = {}
    ExecuteSql(("SELECT * FROM %s"):format(Config.UsersTable), {}, function(result)
        for i = 1, #result do
            local name, phone = "Unknown", "Unknown"
            local uid = Config.UsersTable == "users" and result[i].identifier or result[i].citizenid
            if IsQBorESX() == "qb" then
                result[i].charinfo = json.decode(result[i].charinfo)
                name = result[i].charinfo.firstname .. " " .. result[i].charinfo.lastname
                phone = tostring(result[i].charinfo.phone)
            elseif IsQBorESX() == "esx" then
                name = result[i].firstname .. " " .. result[i].lastname
                phone = tostring(result[i].phone_number)
            end
            if uid:lower():find(search:lower()) or name:lower():find(search:lower()) or phone:lower():find(search:lower()) then
                table.insert(users, {
                    uid = uid,
                    avatar = Avatars[Config.UsersTable == "users" and result[i].identifier or result[i].citizenid] or Config.DefaultAvatar,
                    name = name,
                })
            end
        end
    end)
    if Config.Framework == "qb" or Config.Framework == "newqb" then
        ExecuteSql("SELECT * FROM players INNER JOIN player_vehicles ON players.citizenid = player_vehicles.citizenid", {}, function(result)
            for i = 1, #result do
                local charinfo = json.decode(result[i].charinfo)
                local owner = result[i].citizenid
                if result[i].plate:lower():find(search:lower()) or owner:lower():find(search:lower()) or (charinfo.firstname.. " " ..charinfo.lastname):lower():find(search:lower()) then
                    local vehicleName = QBCore.Shared.Vehicles[result[i].vehicle].brand.. " " ..QBCore.Shared.Vehicles[result[i].vehicle].name
                    table.insert(vehicles, {
                        id = result[i].plate,
                        ownerUid = owner,
                        avatar = Config.DefaultAvatar,
                        plate = result[i].plate,
                        carName = GetVehicleBrandAndModel(result[i].vehicle),
                        owner = charinfo.firstname.. " " ..charinfo.lastname,
                        avatar = result[i].image or Config.DefaultVehicleAvatar
                    })
                end
            end
        end)
    elseif Config.Framework == "esx" or Config.Framework == "oldesx" then
        ExecuteSql("SELECT * FROM users INNER JOIN owned_vehicles ON users.identifier = owned_vehicles.owner", {}, function(result)
            for i = 1, #result do
                local owner = result[i].identifier
                if result[i].plate:lower():find(search:lower()) or owner:lower():find(search:lower()) or (result[i].firstname.. " " ..result[i].lastname):lower():find(search:lower()) then
                    table.insert(vehicles, {
                        id = result[i].plate,
                        ownerUid = owner,
                        avatar = result[i].avatar or Config.DefaultVehicleAvatar,
                        plate = result[i].plate,
                        carName = GetVehicleBrandAndModel(result[i].vehicle),
                        owner = result[i].firstname.. " " ..result[i].lastname,
                    })
                end
            end
        end)
    end
    for i = 1, #Records do
        local record = Records[i]
        if record.name:lower():find(search:lower()) then
            local rankId = record.ranks[1] and tonumber(record.ranks[1]) or 1
            table.insert(records, {
                id = record.id,
                avatar = record.avatar,
                name = record.name,
                rank = record.ranks[1].name,
                date = record.date,
            })
        end
    end
    for i = 1, #Wanteds do
        local wanted = Wanteds[i]
        if wanted.name:lower():find(search:lower()) then
            local rankId = wanted.ranks[1] and tonumber(wanted.ranks[1]) or 1
            table.insert(wanteds, {
                id = wanted.id,
                avatar = wanted.avatar,
                name = wanted.name,
                rank = wanted.ranks[1].name,
                date = wanted.date,
            })
        end
    end
    return {
        users = users,
        records = records,
        wanteds = wanteds,
        vehicles = vehicles,
    }
end)

RegisterCallback("gfx-mdt:getUserInfo", function(source, data)
    local userData = {
        avatar = Config.DefaultAvatar,
        name = 'Yordi',
        text = '#1',
        ranks = {},
        labels = {},
        licenses = {},
        evidences = {},
    }
    if Config.Framework == "qb" or Config.Framework == "newqb" then
        ExecuteSql("SELECT * FROM players WHERE citizenid=@citizenid", {
            ["@citizenid"] = data.uid,
        }, function(result)
            result[1].metadata = json.decode(result[1].metadata)
            result[1].charinfo = json.decode(result[1].charinfo)
            userData.avatar = Avatars[data.uid] or Config.DefaultAvatar
            userData.name = result[1].charinfo.firstname.. " " ..result[1].charinfo.lastname
            userData.text = data.uid
            if result[1].ranks then
                result[1].ranks = json.decode(result[1].ranks) 
                for i = 1, #result[1].ranks do
                    local rankId = tonumber(result[1].ranks[i])
                    table.insert(userData.ranks, {
                        name = Config.CrimeTags[rankId].label,
                        id = result[1].ranks[i],
                    })
                end
            end
            if result[1].evidences then
                result[1].evidences = json.decode(result[1].evidences) 
                for i = 1, #result[1].evidences do
                    table.insert(userData.evidences, {
                        id = result[1].evidences[i].id,
                        name = result[1].evidences[i].name,
                        image = result[1].evidences[i].image,
                    })
                end
            end
            for k, v in pairs(result[1].metadata.licences) do
                table.insert(userData.licenses, {
                    name = Config.Locales[k.."_license"],
                    status = v and "success" or "error",
                })
            end
        end)
    elseif Config.Framework == "esx" or Config.Framework == "oldesx" then
       ExecuteSql("SELECT * FROM users WHERE identifier=@identifier", {
            ["@identifier"] = data.uid,
        }, function(result)
            userData.avatar = Avatars[data.uid] or Config.DefaultAvatar
            userData.name = result[1].firstname.. " " ..result[1].lastname
            userData.text = result[1].identifier
            if result[1].ranks then
                result[1].ranks = json.decode(result[1].ranks) 
                for i = 1, #result[1].ranks do
                    local rankId = tonumber(result[1].ranks[i])
                    table.insert(userData.ranks, {
                        name = Config.CrimeTags[rankId].label,
                        id = result[1].ranks[i],
                    })
                end
            end
            ExecuteSql("SELECT * FROM user_licenses WHERE owner=@owner", {["@owner"] = data.uid}, function(result)
                for k, v in pairs(Config.LicenseTypes) do
                    local found = false
                    for i = 1, #result do
                        if result[i].type == k then
                            found = true
                            break
                        end
                    end
                    table.insert(userData.licenses, {
                        name = Config.Locales[k.."_license"],
                        status = found and "success" or "error",
                    })
                end
            end)
        end)
    end
    return userData
end)

RegisterCallback("gfx-mdt:addRankToUser", function(source, data)
    if Config.Framework == "qb" or Config.Framework == "newqb" then
        ExecuteSql("SELECT * FROM players WHERE citizenid=@citizenid", {
            ["@citizenid"] = data.uid,
        }, function(result)
            local ranks = {}
            if result[1].ranks then
                result[1].ranks = json.decode(result[1].ranks)
                for i = 1, #result[1].ranks do
                    table.insert(ranks, result[1].ranks[i])
                end
            end
            for i = 1, #data.ranks do
                if not tableContains(ranks, data.ranks[i].id) then
                    table.insert(ranks, data.ranks[i].id)
                end
            end
            ExecuteSql("UPDATE players SET ranks = @ranks WHERE citizenid = @citizenid", {
                ["@ranks"] = json.encode(ranks),
                ["@citizenid"] = data.uid,
            })
        end)
    elseif Config.Framework == "esx" or Config.Framework == "oldesx" then
        ExecuteSql("SELECT * FROM users WHERE identifier=@identifier", {
            ["@identifier"] = data.uid,
        }, function(result)
            local ranks = {}
            if result[1].ranks then
                result[1].ranks = json.decode(result[1].ranks)
                for i = 1, #result[1].ranks do
                    table.insert(ranks, result[1].ranks[i])
                end
            end
            for i = 1, #data.ranks do
                if not tableContains(ranks, data.ranks[i].id) then
                    table.insert(ranks, data.ranks[i].id)
                end
            end
            ExecuteSql("UPDATE users SET ranks = @ranks WHERE identifier = @identifier", {
                ["@ranks"] = json.encode(ranks),
                ["@identifier"] = data.uid,
            })
        end)
    end
    return data.ranks
end)

RegisterCallback("gfx-mdt:deleteRankFromUser", function(source, data)
    if Config.Framework == "qb" or Config.Framework == "newqb" then
        ExecuteSql("SELECT * FROM players WHERE citizenid=@citizenid", {
            ["@citizenid"] = data.uid,
        }, function(result)
            local ranks = {}
            if result[1].ranks then
                result[1].ranks = json.decode(result[1].ranks)
                for i = 1, #result[1].ranks do
                    table.insert(ranks, result[1].ranks[i])
                end
            end
            for i = 1, #ranks do
                if ranks[i] == data.id then
                    table.remove(ranks, i)
                    break
                end
            end
            ExecuteSql("UPDATE players SET ranks = @ranks WHERE citizenid = @citizenid", {
                ["@ranks"] = json.encode(ranks),
                ["@citizenid"] = data.uid,
            })
        end)
    elseif Config.Framework == "esx" or Config.Framework == "oldesx" then
        ExecuteSql("SELECT * FROM users WHERE identifier=@identifier", {
            ["@identifier"] = data.uid,
        }, function(result)
            local ranks = {}
            if result[1].ranks then
                result[1].ranks = json.decode(result[1].ranks)
                for i = 1, #result[1].ranks do
                    table.insert(ranks, result[1].ranks[i])
                end
            end
            for i = 1, #ranks do
                if ranks[i] == data.id then
                    table.remove(ranks, i)
                    break
                end
            end
            ExecuteSql("UPDATE users SET ranks = @ranks WHERE identifier = @identifier", {
                ["@ranks"] = json.encode(ranks),
                ["@identifier"] = data.uid,
            })
        end)
    end
    return data.id
end)

RegisterCallback("gfx-mdt:addEvidenceToUser", function(source, data) 
    local promise = promise:new()
    local evidence = {}
    local evidences = {}
    if Config.Framework == "qb" or Config.Framework == "newqb" then
        ExecuteSql("SELECT evidences FROM players WHERE citizenid=@citizenid", {
            ["@citizenid"] = data.uid,
        }, function(result)
            if result[1].evidences then
                result[1].evidences = json.decode(result[1].evidences)
                for i = 1, #result[1].evidences do
                    table.insert(evidences, result[1].evidences[i])
                end
            end
            local lastEvidence = evidences[#evidences] or {
                id = 0
            }
            evidence = {
                id = tonumber(lastEvidence.id) + 1,
                name = data.name,
                image = data.image,
            }
            promise:resolve(evidence)
            table.insert(evidences, evidence)
            ExecuteSql("UPDATE players SET evidences = @evidences WHERE citizenid = @citizenid", {
                ["@evidences"] = json.encode(evidences),
                ["@citizenid"] = data.uid,
            })
        end)
    elseif Config.Framework == "esx" or Config.Framework == "oldesx" then
        ExecuteSql("SELECT * FROM users WHERE identifier=@identifier", {
            ["@identifier"] = data.uid,
        }, function(result)
            if result[1].evidences then
                result[1].evidences = json.decode(result[1].evidences)
                for i = 1, #result[1].evidences do
                    table.insert(evidences, result[1].evidences[i])
                end
            end
            local lastEvidence = evidences[#evidences] or {
                id = 0
            }
            evidence = {
                id = tonumber(lastEvidence.id) + 1,
                name = data.name,
                image = data.image,
            }
            promise:resolve(evidence)
            table.insert(evidences, evidence)
            ExecuteSql("UPDATE users SET evidences = @evidences WHERE identifier = @identifier", {
                ["@evidences"] = json.encode(evidences),
                ["@identifier"] = data.uid,
            })
        end)
    end
    return Citizen.Await(promise)
end)

RegisterCallback("gfx-mdt:deleteEvidenceFromUser", function(source, data) 
    local evidences = {}
    if Config.Framework == "qb" or Config.Framework == "newqb" then
        ExecuteSql("SELECT evidences FROM players WHERE citizenid=@citizenid", {
            ["@citizenid"] = data.uid,
        }, function(result)
            if result[1].evidences then
                result[1].evidences = json.decode(result[1].evidences)
                for i = 1, #result[1].evidences do
                    table.insert(evidences, result[1].evidences[i])
                end
            end
            for i = 1, #evidences do
                if evidences[i].id == data.id then
                    table.remove(evidences, i)
                    break
                end
            end
            ExecuteSql("UPDATE players SET evidences = @evidences WHERE citizenid = @citizenid", {
                ["@evidences"] = json.encode(evidences),
                ["@citizenid"] = data.uid,
            })
        end)
    elseif Config.Framework == "esx" or Config.Framework == "oldesx" then
        ExecuteSql("SELECT * FROM users WHERE identifier=@identifier", {
            ["@identifier"] = data.uid,
        }, function(result)
            if result[1].evidences then
                result[1].evidences = json.decode(result[1].evidences)
                for i = 1, #result[1].evidences do
                    table.insert(evidences, result[1].evidences[i])
                end
            end
            for i = 1, #evidences do
                if evidences[i].id == data.id then
                    table.remove(evidences, i)
                    break
                end
            end
            ExecuteSql("UPDATE users SET evidences = @evidences WHERE identifier = @identifier", {
                ["@evidences"] = json.encode(evidences),
                ["@identifier"] = data.uid,
            })
        end)
    end
    return data.id
end)

RegisterCallback("gfx-mdt:deleteEvidenceFromWanted", function(source, data) 
    local wanted = GetWantedFromId(data.wantedId)
    for i = 1, #wanted.evidences do
        if wanted.evidences[i].id == data.id then
            table.remove(wanted.evidences, i)
            break
        end
    end
    ExecuteSql("UPDATE gfxmdt_wanteds SET evidences = @evidences WHERE id = @id", {
        ["@evidences"] = json.encode(wanted.evidences),
        ["@id"] = data.wantedId,
    })
    return data.id
end)

RegisterCallback("gfx-mdt:deletePolice", function(source, data)
    local recordId = data.recordId
    local record = GetRecordFromId(recordId)
    for i = 1, #record.polices do
        if record.polices[i].id == data.id then
            table.remove(record.polices, i)
            break
        end
    end
    ExecuteSql("UPDATE gfxmdt_records SET polices = @polices WHERE id = @id", {
        ["@polices"] = json.encode(record.polices),
        ["@id"] = recordId,
    })
    return data.id
end)

RegisterCallback("gfx-mdt:getVehicleInfo", function(source, data)
    local vehData = {}
    local p = promise:new()
    if Config.Framework == "qb" or Config.Framework == "newqb" then
        ExecuteSql("SELECT * FROM player_vehicles INNER JOIN players ON player_vehicles.citizenid = players.citizenid WHERE plate = @plate", {
            ["@plate"] = data.id,
        }, function(result)
            if result[1] then
                local charinfo = json.decode(result[1].charinfo)
                local owner = result[1].citizenid
                local vehicleName = QBCore.Shared.Vehicles[result[1].vehicle].brand.. " " ..QBCore.Shared.Vehicles[result[1].vehicle].name
                vehData = {
                    image = result[1].image or Config.DefaultVehicleAvatar,
                    carName = vehicleName,
                    numberPlate = result[1].plate,
                    ownerName = charinfo.firstname.. " " ..charinfo.lastname,
                }
                p:resolve(vehData)
            end
        end)
    elseif Config.Framework == "esx" or Config.Framework == "oldesx" then
        ExecuteSql("SELECT * FROM owned_vehicles INNER JOIN users ON owned_vehicles.owner = users.identifier WHERE plate = @plate", {
            ["@plate"] = data.id,
        }, function(result)
            if result[1] then
                local owner = result[1].owner
                vehData = {
                    image = result[1].avatar or Config.DefaultVehicleAvatar,
                    carName = "Maserati",
                    numberPlate = result[1].plate,
                    ownerName = result[1].firstname.. " " ..result[1].lastname,
                }
                p:resolve(vehData)
            end
        end)
    end
    return Citizen.Await(p)
end)

RegisterCallback("gfx-mdt:editReportTextFromPolice", function(source, data)
    local id = data.id
    ExecuteSql("UPDATE gfxmdt_polices SET reportText = @text WHERE id = @id", {
        ["@text"] = data.reportText,
        ["@id"] = id,
    })
    local police = GetPoliceDeatils(id, source)
    police.reportText = data.reportText
    return police.reportText
end)

RegisterCallback("gfx-mdt:editReportTextFromOffender", function(source, data)
    local id = data.id
    ExecuteSql("UPDATE gfxmdt_offenders SET reportText = @text WHERE id = @id", {
        ["@text"] = data.reportText,
        ["@id"] = id,
    })
    local offender = GetOffenderDeatils(id, source)
    offender.reportText = data.reportText
    return offender.reportText
end)

RegisterCallback("gfx-mdt:getDepartment", function(source)
    Config.Department.totalBans = GetBanCount()
    return Config.Department
end)

RegisterCallback("gfx-mdt:editDescriptionOfDepartment", function(source, data)
    local department = Config.Department
    department.description = data.description
    ExecuteSql("UPDATE gfxmdt_department SET description = @description", {
        ["@description"] = data.description,
    })
    return department.description
end)

RegisterCallback("gfx-mdt:addRankToOffender", function(source, data)
    local offender = GetOffenderDeatils(data.offenderId, source)
    local ranks = data.ranks
    for i = #ranks, 1, -1 do
        if not tableContains(offender.ranks, ranks[i].id, "id") then
            table.insert(offender.ranks, ranks[i])
        else
            table.remove(data.ranks, i)
        end
    end
    local function getListOfRanks()
        local rankIds = {}
        for i = 1, #offender.ranks do
            table.insert(rankIds, offender.ranks[i].id)
        end
        return rankIds
    end
    ExecuteSql("UPDATE gfxmdt_offenders SET ranks = @ranks WHERE id = @id", {
        ["@ranks"] = json.encode(getListOfRanks()),
        ["@id"] = data.offenderId,
    })
    return data.ranks
end)

RegisterCallback("gfx-mdt:deleteRankFromOffender", function(source, data)
    local offender = GetOffenderDeatils(data.offenderId, source)
    if #offender.ranks == 1 then
        return {error = true, message = "You can't delete the last rank."}
    end
    for i = 1, #offender.ranks do
        if offender.ranks[i].id == data.id then
            table.remove(offender.ranks, i)
            break
        end
    end
    local function getListOfRanks()
        local rankIds = {}
        for i = 1, #offender.ranks do
            table.insert(rankIds, offender.ranks[i].id)
        end
        return rankIds
    end
    ExecuteSql("UPDATE gfxmdt_offenders SET ranks = @ranks WHERE id = @id", {
        ["@ranks"] = json.encode(getListOfRanks()),
        ["@id"] = data.offenderId,
    })
    return {data = data.id, success = true}
end)

RegisterCallback("gfx-mdt:addEvidenceToOffender", function(source, data)
    local offender = GetOffenderDeatils(data.offenderId, source)
    local lastEvidence = offender.evidences[#offender.evidences] or {
        id = 0
    }
    local evidences = {
        id = tonumber(lastEvidence.id) + 1,
        name = data.name,
        image = data.image,
    }
    table.insert(offender.evidences, evidences)
    ExecuteSql("UPDATE gfxmdt_offenders SET evidences = @evidences WHERE id = @id", {
        ["@evidences"] = json.encode(offender.evidences),
        ["@id"] = data.offenderId,
    })
    return {success = true, data = evidences}
end)

RegisterCallback("gfx-mdt:deleteEvidenceFromOffender", function(source, data)
    local offender = GetOffenderDeatils(data.offenderId, source)
    for i = 1, #offender.evidences do
        if offender.evidences[i].id == data.id then
            table.remove(offender.evidences, i)
            break
        end
    end
    ExecuteSql("UPDATE gfxmdt_offenders SET evidences = @evidences WHERE id = @id", {
        ["@evidences"] = json.encode(offender.evidences),
        ["@id"] = data.offenderId,
    })
    return {success = true, data = data.id}
end)

RegisterCallback("gfx-mdt:addEvidenceToPolice", function(source, data)
    local police = GetPoliceDeatils(data.policeId, source)
    local lastEvidence = police.evidences[#police.evidences] or {
        id = 0
    }
    local evidences = {
        id = tonumber(lastEvidence.id) + 1,
        name = data.name,
        image = data.image,
    }
    table.insert(police.evidences, evidences)
    ExecuteSql("UPDATE gfxmdt_polices SET evidences = @evidences WHERE id = @id", {
        ["@evidences"] = json.encode(police.evidences),
        ["@id"] = data.policeId,
    })
    return {success = true, data = evidences}
end)

RegisterCallback("gfx-mdt:deleteEvidenceFromPolice", function(source, data)
    local police = GetPoliceDeatils(data.policeId, source)
    for i = 1, #police.evidences do
        if police.evidences[i].id == data.id then
            table.remove(police.evidences, i)
            break
        end
    end
    ExecuteSql("UPDATE gfxmdt_polices SET evidences = @evidences WHERE id = @id", {
        ["@evidences"] = json.encode(police.evidences),
        ["@id"] = data.policeId,
    })
    return {success = true, data = data.id}
end)

RegisterCallback("gfx-mdt:changeAvatarFromUser", function(source, data)
    Avatars[data.uid] = data.image
    ExecuteSql("INSERT INTO gfxmdt_avatars (id, avatar) VALUES (@uid, @avatar)", {
        ["@avatar"] = data.image,
        ["@uid"] = data.uid,
    })
    return {success = true, data = data.image}
end)

RegisterCallback("gfx-mdt:loadNotifications", function(source, data)
    local lastId = data.lastId
    if lastId == Notifications[1].id then
        return {success = true, noneData = true}
    end
    local notifications = {}
    local downValue = lastId - 10 < 1 and 1 or lastId - 10
    for i = lastId - 1, downValue, -1 do
        if Notifications[i] then
            table.insert(notifications, Notifications[i])
        end
        if #notifications == 10 then
            break
        end
    end
    return {success = true, data = notifications}
end)

RegisterCallback("gfx-mdt:loadRecords", function(source, data)
    local lastId = data.lastId
    if lastId == Records[1].id then
        return {success = true, noneData = true}
    end
    local records = {}
    local downValue = lastId - 10 < 1 and 1 or lastId - 10
    for i = lastId - 1, downValue, -1 do
        if Records[i] then
            table.insert(records, Records[i])
        end
        if #records == 10 then
            break
        end
    end
    return {success = true, data = records}
end)

RegisterCallback("gfx-mdt:changeImageFromVehicle", function(source, data)
    local image = data.image
    local plate = data.id
    if Config.Framework == "qb" or Config.Framework == "newqb" then
        ExecuteSql("UPDATE player_vehicles SET image = @image WHERE plate = @plate", {
            ["@image"] = image,
            ["@plate"] = plate,
        })
    elseif Config.Framework == "esx" then
        ExecuteSql("UPDATE owned_vehicles SET avatar = @image WHERE plate = @plate", {
            ["@image"] = image,
            ["@plate"] = plate,
        })
    end
end)

RegisterCallback("gfx-mdt:addFinesToOffender", function(source, data)
    local offenderId = data.offenderId
    local fines = data.fines
    local offender = GetOffenderDeatils(offenderId, source)
    local lastFine = offender.fines[#offender.fines] or {
        id = 0
    }
    for i = 1, #fines do
        local fine = fines[i]
        fine.id = fine.value
        fine.name = fine.label
        fine.label = nil
        table.insert(offender.fines, fine)
    end
    local function FormatFines()
        local ids = {}
        for i = 1, #offender.fines do
            table.insert(ids, offender.fines[i].id)
        end
        return ids
    end
    ExecuteSql("UPDATE gfxmdt_offenders SET fines = @fines WHERE id = @id", {
        ["@fines"] = json.encode(FormatFines()),
        ["@id"] = offenderId,
    })
    return {success = true, data = fines}
end)

RegisterCallback("gfx-mdt:deleteFinesFromOffender", function(source, data)
    local offenderId = data.offenderId
    local fineId = data.id
    local offender = GetOffenderDeatils(offenderId, source)
    for i = 1, #offender.fines do
        if offender.fines[i].id == fineId then
            table.remove(offender.fines, i)
            break
        end
    end
    local function FormatFines()
        local ids = {}
        for i = 1, #offender.fines do
            table.insert(ids, offender.fines[i].id)
        end
        return ids
    end
    ExecuteSql("UPDATE gfxmdt_offenders SET fines = @fines WHERE id = @id", {
        ["@fines"] = json.encode(FormatFines()),
        ["@id"] = offenderId,
    })
    return {success = true, data = fineId}
end)
