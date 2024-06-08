local dispatches = {}
local colors = {
    "red",
    "white",
    "orange"
}

function AddDispatch(title, coords, texts, circleColor)
    local formattedTexts = {}
    for i = 1, #texts do
        table.insert(formattedTexts, {
            id = i,
            text = texts[i],
        })
    end
    TriggerServerEvent("gfx-mdt:AddDispatch", {
        id = next(dispatches) == nil and 1 or dispatches[#dispatches].id + 1,
        name = title,
        position = {coords.y, coords.x},
        texts = formattedTexts,
        circleColor = circleColor or colors[math.random(1, #colors)]
    })
end

exports("AddDispatch", AddDispatch)
RegisterNetEvent("gfx-mdt:sendDispatch", AddDispatch)

RegisterNetEvent("gfx-mdt:client:AddDispatch", function(dispatch)
    print(29, json.encode(dispatch))
    table.insert(dispatches, dispatch)
end)

RegisterNetEvent("gfx-mdt:client:RemoveDispatch", function(id)
    RemoveDispatch(id)
end)

function GetDispatches()
    return dispatches
end

RemoveDispatch = function(id)
    for i = 1, #dispatches do
        if dispatches[i].id == id then
            table.remove(dispatches, i)
            break
        end
    end
end

-- thread credit to qb-dispatch

Citizen.CreateThread(function()
    local cooldown = 0
    local isBusy = false
	while true do
		Citizen.Wait(0)
        local playerPed = PlayerPedId()
        if IsPedShooting(playerPed) and (cooldown == 0 or cooldown - GetGameTimer() < 0) and not isBusy and Config.Dispatches.GunShot then
            isBusy = true
            local weapon = GetSelectedPedWeapon(playerPed)
            local name = GetWeaponName(weapon)
            local shooterGender = GetEntityModel(playerPed) == `mp_m_freemode_01` and Locales["male"] or Locales["female"]
            if IsPedCurrentWeaponSilenced(playerPed) then
                cooldown = GetGameTimer() + math.random(25000, 30000)
                AddDispatch("Gunshot Alert", GetEntityCoords(playerPed), {Locales["silenced_gunshot"], Locales["weapon_name"]:format(name), Locales["gender"]:format(shooterGender)})
            else
                cooldown = GetGameTimer() + math.random(15000, 20000)
                AddDispatch("Gunshot Alert", GetEntityCoords(playerPed), {Locales["gunshot"], Locales["weapon_name"]:format(name), Locales["gender"]:format(shooterGender)})
            end
            isBusy = false
        end
    end
end)