RegisterServerEvent("gfx-mdt:triggerPanic", function(panicType, coords)
    local src = source
    if IsPolice(src) then
        local players = GetPlayers()
        local name = GetCharName(src)
        for i = 1, #players do
            players[i] = tonumber(players[i])
            if IsPolice(players[i]) then
                TriggerClientEvent("gfx-mdt:client:triggerPanic", players[i], panicType, name, coords)
            end
        end
    end
end)

RegisterServerEvent("gfx-mdt:deleteFine", function(id)
    local src = source
    ExecuteSql("DELETE FROM gfxmdt_fines WHERE id = @id", {["@id"] = id})
end)

RegisterServerEvent("gfx-mdt:AddDispatch", function(data)
    local players = GetPlayers()
    for i = 1, #players do
        players[i] = tonumber(players[i])
        if IsPolice(players[i], "ableToUse") then
            TriggerClientEvent("gfx-mdt:client:AddDispatch", players[i], data)
        end
    end
end)

RegisterServerEvent("gfx-mdt:RemoveDispatch", function(id)
    TriggerClientEvent("gfx-mdt:client:RemoveDispatch", -1, id)
end)