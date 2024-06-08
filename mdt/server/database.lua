function ExecuteSql(query, parameters, cb)
    local promise = promise:new()
    local isBusy = true
    if Config.SQLScript == "oxmysql" then
        exports.oxmysql:execute(query, parameters, function(data)
            promise:resolve(data)
            isBusy = false

            if cb then
                cb(data)
            end
        end)
    elseif Config.SQLScript == "ghmattimysql" then
        exports.ghmattimysql:execute(query, parameters, function(data)
            promise:resolve(data)
            isBusy = false

            if cb then
                cb(data)
            end
        end)
    elseif Config.SQLScript == "mysql-async" then
        MySQL.Async.fetchAll(query, parameters, function(data)
            promise:resolve(data)
            isBusy = false
            if cb then
                cb(data)
            end
        end)
    end
    while isBusy do
        Citizen.Wait(0)
    end
    return Citizen.Await(promise)
end