Messages, Notifications, Wanteds, Records, Fines, Banlist, Avatars, Appointments, Offenders, Polices = {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
local finesLoaded = false

if Config.Open.command.enable then
    RegisterCommand(Config.Open.command.name, function(source, args, rawCommand)
        OpenMDT(source)
    end)
end

if Config.Open.item.enable then
    if Config.Framework == "esx" or Config.Framework == "oldesx" then
        ESX.RegisterUsableItem(Config.Open.item.name, function(source)
            OpenMDT(source)
        end)
    elseif Config.Framework == "qb" or Config.Framework == "newqb" then
        QBCore.Functions.CreateUseableItem(Config.Open.item.name, function(source)
            OpenMDT(source)
        end)
    end
end

function OpenMDT(source)
    if IsPolice(source) then
        TriggerClientEvent("gfx-mdt:client:openMDT", source)
    else
        Notify(source, "error", Config.Locales["not_in_service"])
    end
end

Citizen.CreateThread(function()
    ExecuteSql("SELECT * FROM gfxmdt_notifications", {}, function(result)
        Notifications = result
    end)
end)

Citizen.CreateThread(function()
    ExecuteSql("SELECT * FROM gfxmdt_fines", {}, function(result)
        Fines = result
        for i = 1, #Fines do
            Fines[i].fields = {
                {text = Fines[i].name},
                {text = Fines[i].jailTime.. " ".. Fines[i].jailType},
                {text = NumberToMoney(Fines[i].money)},
                {text = Fines[i].addedBy},
            }
            result[i].lastEdited = json.decode(result[i].lastEdited)
            Fines[i].lastEdited = ('Last edited %s ago by %s'):format(GetTimeDiffAs(result[i].lastEdited.time), result[i].addedBy)
        end
        finesLoaded = true
    end)
end)


Citizen.CreateThread(function()
    ExecuteSql("SELECT * FROM gfxmdt_banlist", {}, function(result)
        Banlist = result
        for i = 1, #Banlist do
            Banlist[i].ranks = json.decode(Banlist[i].ranks)
            Banlist[i].bans = Banlist[i].ranks
            Banlist[i].status = Banlist[i].date
            Banlist[i].text = "#"..i
            Banlist[i].counter = i
            Banlist[i].rank = Banlist[i].addedBy
        end
    end)
end)

Citizen.CreateThread(function()
    ExecuteSql("SELECT * FROM gfxmdt_avatars", {}, function(result)
        for i = 1, #result do
            Avatars[result[i].id] = result[i].avatar
        end
    end)
end)

Citizen.CreateThread(function()
    ExecuteSql("SELECT * FROM gfxmdt_wanteds", {}, function(result)
        for i = 1, #result do
            Wanteds[result[i].id] = result[i]
            Wanteds[result[i].id].ranks = json.decode(Wanteds[result[i].id].ranks)
            Wanteds[result[i].id].evidences = json.decode(Wanteds[result[i].id].evidences)
            Wanteds[result[i].id].text = "#"..i
            for j = 1, #Wanteds[result[i].id].ranks do
                local id = Wanteds[result[i].id].ranks[j]
                Wanteds[result[i].id].ranks[j] = {
                    name = Config.CrimeTags[tonumber(id)].label,
                    id = Wanteds[result[i].id].ranks[j],
                }
            end
        end
    end)
end)

Citizen.CreateThread(function()
    ExecuteSql("SELECT * FROM gfxmdt_offenders", {}, function(res)
        ExecuteSql("SELECT * FROM gfxmdt_polices", {}, function(res2)
            for i = 1, #res do
                Offenders[res[i].id] = res[i]
                Offenders[res[i].id].ranks = json.decode(Offenders[res[i].id].ranks)
                Offenders[res[i].id].evidences = json.decode(Offenders[res[i].id].evidences)
                Offenders[res[i].id].fines = json.decode(Offenders[res[i].id].fines) or {}
                
                while not finesLoaded do
                    Citizen.Wait(100)
                end

                local fines = {}
                for k,v in pairs(Offenders[res[i].id].fines) do
                    local id = tonumber(Offenders[res[i].id].fines[k])
                    local fineData = GetFineFromId(id)
                    local fine
                    if fineData then
                        fine = {
                            id = id,
                            name = fineData.name.. " - "..fineData.jailTime.. " ".. fineData.jailType.. " - " .. NumberToMoney(fineData.money),
                        }
                    else
                        fine = {
                            id = id,
                            name = Locales["unknown_fine"],
                        }
                    end
                    table.insert(fines, fine)
                end
                Offenders[res[i].id].fines = fines
                
                for j = 1, #Offenders[res[i].id].ranks do
                    local id = Offenders[res[i].id].ranks[j]
                    Offenders[res[i].id].ranks[j] = {
                        name = Config.CrimeTags[tonumber(id)].label,
                        id = Offenders[res[i].id].ranks[j],
                    }
                end
            end
            for i = 1, #res2 do
                Polices[res2[i].id] = res2[i]
                Polices[res2[i].id].ranks = json.decode(Polices[res2[i].id].ranks)
                Polices[res2[i].id].evidences = json.decode(Polices[res2[i].id].evidences)
            end
            ExecuteSql("SELECT * FROM gfxmdt_records", {}, function(result)
                Records = result
                for i = 1, #Records do
                    Records[i].ranks = json.decode(Records[i].ranks)
                    Records[i].evidences = json.decode(Records[i].evidences)
                    Records[i].offenders = json.decode(Records[i].offenders)
                    Records[i].polices = json.decode(Records[i].polices)
                    if #Records[i].ranks == 0 then
                        Records[i].ranks = {"1"}
                    end
                    for j = 1, #Records[i].ranks do
                        local id = Records[i].ranks[j]
                        Records[i].ranks[j] = {
                            name = Config.CrimeTags[tonumber(id)].label,
                            id = Records[i].ranks[j],
                        }
                    end
                    if Records[i].offenders then
                        for j = 1, #Records[i].offenders do
                            local id = Records[i].offenders[j].id
                            Records[i].offenders[j] = {
                                id = id,
                                date = Records[i].offenders[j].date,
                                text = "#"..j,
                                name = Offenders[id].name,
                                avatar = Offenders[id].avatar,
                                addedBy = Offenders[id].madeBy,
                                ranks = Offenders[id].ranks,
                            }
                        end
                    end
                    if Records[i].polices then
                        for j = 1, #Records[i].polices do
                            local id = Records[i].polices[j].id
                            Records[i].polices[j] = {
                                id = id,
                                date = Records[i].polices[j].date,
                                text = "#"..j,
                                name = Polices[id].name,
                                avatar = Polices[id].avatar,
                                addedBy = Polices[id].madeBy,
                                ranks = Polices[id].ranks,
                            }
                        end
                    end
                end
            end)
        end)
    end)
end)

Citizen.CreateThread(function()
    ExecuteSql("SELECT * FROM gfxmdt_appointment", {}, function(result)
        if #result == 0 then
            if Config.Framework == "esx" or Config.Framework == "oldesx" then
                ExecuteSql("SELECT * FROM users WHERE job = @job", {
                    ["@job"] = "police"
                }, function(result)
                    local policeCount = 0
                    for i = 1, #result do
                        policeCount = policeCount + 1
                        Appointments[result[i].identifier] = os.time()
                        ExecuteSql("INSERT INTO gfxmdt_appointment (id, date) VALUES (@id, @date)", {
                            ["@id"] = result[i].identifier,
                            ["@date"] = Appointments[result[i].identifier]
                        })
                    end
                    Config.Department.totalPersonal = (Config.Department.totalPersonal):format(policeCount)
                end)
            elseif Config.Framework == "qb" or Config.Framework == "newqb" then                                 
                ExecuteSql("SELECT * FROM players", {}, function(result)                                      
                    for i = 1, #result do               
                        local job = json.decode(result[i].job)              
                        if job.name == "police" then                  
                            Config.Department.totalPersonal = (Config.Department.totalPersonal):format(policeCount)                                                                                                                                                                                                                                                                                                                                                                             
                                                                                                                                                     
                            Appointments[result[i].citizenid] = os.time()
                            ExecuteSql("INSERT INTO gfxmdt_appointment (id, date) VALUES (@id, @date)", {                   
                                ["@id"] = result[i].citizenid,
                                ["@date"] = Appointments[result[i].citizenid]                       
                            })
                        end
                    end
                end)
            end
        else
            for k, v in pairs(result) do
                Appointments[v.id] = v.date
            end
        end
    end)
end)

Citizen.CreateThread(function()
    if Config.Framework == "esx" or Config.Framework == "oldesx" then
        ExecuteSql("SELECT * FROM users WHERE job = @job", {
            ["@job"] = "police"
        }, function(result)
            local policeCount = 0
            for i = 1, #result do
                policeCount = policeCount + 1
            end
            Config.Department.totalPersonal = (Config.Department.totalPersonal):format(policeCount)
        end)
    elseif Config.Framework == "qb" or Config.Framework == "newqb" then
        ExecuteSql("SELECT * FROM players", {}, function(result)
            local policeCount = 0
            for i = 1, #result do
                local job = json.decode(result[i].job)
                if job.name == "police" then
                    policeCount = policeCount + 1
                end
            end
            Config.Department.totalPersonal = (Config.Department.totalPersonal):format(policeCount)
        end)
    end
end)

if Config.Framework == "esx" or Config.Framework == "oldesx" then
    -- job changed events
    AddEventHandler("esx:setJob", function(source, job, lastJob)
        
    end)
elseif Config.Framework == "qb" or Config.Framework == "newqb" then
    -- job changed events
    AddEventHandler("QBCore:Server:OnJobUpdate", function(source, job)
        local src = source
        local xPlayer = QBCore.Functions.GetPlayer(src)
        if xPlayer then
            local job = xPlayer.PlayerData.job
            if job.name == "police" then
                if Appointments[xPlayer.PlayerData.citizenid] then return end
                local index = string.find(Config.Department.totalPersonal, '/', 1, true)
                Config.Department.totalPersonal = (Config.Department.totalPersonal):format(tonumber(string.sub(Config.Department.totalPersonal, 1, index - 1)) + 1)
                Appointments[xPlayer.PlayerData.citizenid] = os.time()
                ExecuteSql("INSERT INTO gfxmdt_appointment (id, date) VALUES (@id, @date)", {
                    ["@id"] = xPlayer.PlayerData.citizenid,
                    ["@date"] = os.time()
                })
            else
                if not Appointments[xPlayer.PlayerData.citizenid] then return end
                local index = string.find(Config.Department.totalPersonal, '/', 1, true)
                Config.Department.totalPersonal = (Config.Department.totalPersonal):format(tonumber(string.sub(Config.Department.totalPersonal, 1, index - 1)) - 1)
                Appointments[xPlayer.PlayerData.citizenid] = nil
                ExecuteSql("DELETE FROM gfxmdt_appointment WHERE id = @id", {
                    ["@id"] = xPlayer.PlayerData.citizenid
                })
            end
        end
    end)
end

Citizen.CreateThread(function()
    ExecuteSql("SELECT * FROM gfxmdt_department", {}, function(result)
        if result[1] then
            Config.Department.description = result[1].description
        end
    end)
end)