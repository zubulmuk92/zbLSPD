RegisterNUICallback("getCameras", function(data, cb)
    cb({data=Config.Cameras, success=true})
end)

RegisterNUICallback("openCamera", function(data, cb)
    local camData = Config.Cameras[data.id]
    CreateCCTVCamera(camData)
end)

RegisterNUICallback("getInfo", function(data, cb)
    WaitForLoaded()
    Citizen.Wait(150)
    local result = TriggerCallback("gfx-mdt:getInfo")
    cb({data=result, success=true})
end)

local dutyList = {}

RegisterNUICallback("getOnDutyList",  function(data, cb)
    WaitForLoaded()
    Citizen.Wait(150)
    local result = getOnDutyList()
    local duty = {}
    for i = 1, #result do
        if result[i].ableToUse then
            table.insert(duty, result[i])
        end
    end
    cb({data=duty, success=true})
end)

RegisterNUICallback("getMessages", function(data, cb)
    local result = TriggerCallback("gfx-mdt:getMessages")
    cb({data=result, success=true})
end)

RegisterNUICallback("addMessage", function(data, cb)
    local result = TriggerCallback("gfx-mdt:addMessage", data)
    cb({data=result, success=true})
end)

RegisterNUICallback("getNotifications", function(data, cb)
    local result = TriggerCallback("gfx-mdt:getNotifications")
    cb({data=result, success=true})
end)

RegisterNUICallback("getFinesForSelect", function(data, cb)
    local result = TriggerCallback("gfx-mdt:getFinesForSelect")
    cb({data=result, success=true})
end)

RegisterNUICallback("getUsersForSelect", function(data, cb)
    local result = TriggerCallback("gfx-mdt:getUsersForSelect")
    
    cb({data=result, success=true})
end)

RegisterNUICallback("getVehiclesForSelect", function(data, cb)
    local result = TriggerCallback("gfx-mdt:getVehiclesForSelect")
    cb({data=result, success=true})
end)

RegisterNUICallback("getRanksForSelect", function(data, cb)
    cb({data=Config.CrimeTags, success=true})
end)

RegisterNUICallback("getDepartment", function(data, cb)
    local result = TriggerCallback("gfx-mdt:getDepartment")
    cb({data=result, success=true})
end)

RegisterNUICallback("triggerPanicButton", function(data, cb)
    TriggerServerEvent("gfx-mdt:triggerPanic", data.type, GetEntityCoords(PlayerPedId()))
    cb({success=true})
end)

RegisterNUICallback("addFines", function(data, cb)
    local result = TriggerCallback("gfx-mdt:addFines", data)
    cb({data=result, success=true})
end)

RegisterNUICallback("editFine", function(data, cb)
    local result = TriggerCallback("gfx-mdt:editFine", data)
    cb({data=result, success=true})
end)

RegisterNUICallback("getFines", function(data, cb)
    local result = TriggerCallback("gfx-mdt:getFines")
    cb({data=result, success=true})
end)

RegisterNUICallback("deleteFine", function(data, cb)
    TriggerServerEvent("gfx-mdt:deleteFine", data.id)
    cb({success=true, id = data.id})
end)

RegisterNUICallback("addRecords", function(data, cb)
    local result = TriggerCallback("gfx-mdt:addRecords", data)
    cb({data=result, success=true})
end)

RegisterNUICallback("getRecords", function(data, cb)
    local result = TriggerCallback("gfx-mdt:getRecords")
    cb({data=result, success=true})
end)

RegisterNUICallback("getRecordDetail", function(data, cb)
    local result = TriggerCallback("gfx-mdt:getRecordDetail", data.id)
    result.repotedPolice = result.addedBy
    cb({data=result, success=true})
end)

RegisterNUICallback("deleteRecord", function(data, cb)
    local result = TriggerCallback("gfx-mdt:deleteRecord", data.id)
    cb({success=true, id = data.id})
end)

RegisterNUICallback("addRanksForRecord", function(data, cb)
    local result = TriggerCallback("gfx-mdt:addRanksForRecord", data)
    cb({success=true, data = result})
end)

RegisterNUICallback("addEvidencesForRecord", function(data, cb)
    local result = TriggerCallback("gfx-mdt:addEvidencesForRecord", data)
    cb({success=true, data = result})
end)

RegisterNUICallback("deleteEvidenceFromRecord", function(data, cb)
    local result = TriggerCallback("gfx-mdt:deleteEvidenceFromRecord", data)
    cb({success=true, data = result})
end)

RegisterNUICallback("deleteRankFromRecord", function(data, cb)
    local result = TriggerCallback("gfx-mdt:deleteRankFromRecord", data)
    cb({success=result.success, data = result.data, error = result.error, message = result.message})
end)

RegisterNUICallback("editReportTextFromRecord", function(data, cb)
    local result = TriggerCallback("gfx-mdt:editReportTextFromRecord", data)
    cb({success=true, data = result})
end)

RegisterNUICallback("addOffenders", function(data, cb)
    local result = TriggerCallback("gfx-mdt:addOffenders", data)
    cb({success=result.success, data = result.data, error = result.error, message = result.message})
end)

RegisterNUICallback("deleteOffender", function(data, cb)
    local result = TriggerCallback("gfx-mdt:deleteOffender", data)
    cb({success=result.success, data = result.data, error = result.error, message = result.message})
end)

RegisterNUICallback("addWanteds", function(data, cb)
    local result = TriggerCallback("gfx-mdt:addWanteds", data)
    cb({success=true, data = result})
end)

RegisterNUICallback("deleteWanted", function(data, cb)
    local result = TriggerCallback("gfx-mdt:deleteWanted", data)
    cb({success=true, data = result})
end)

RegisterNUICallback("takePicture", function(data, cb)
    CreateMobilePhone(1)
    CellCamActivate(true, true)
    Citizen.Wait(100)
    SetVisibility(false)
    local p = promise:new()
    local takingPhoto = true
    Citizen.CreateThread(function()
        while takingPhoto do
            Wait(0)
            DisableControlAction(0, 24, true)
            DisableControlAction(0, 142, true)
            DisableControlAction(0, 257, true)
            if IsDisabledControlJustPressed(0, 24) then
                DestroyMobilePhone()    
                exports['screenshot-basic']:requestScreenshotUpload(tostring(Config.discordWebhook), "files[]", function(data)
                    local image = json.decode(data)
                    Wait(400)
                    p:resolve(image.attachments[1].proxy_url)
                end)            
                takingPhoto = false
            end
        end
        Citizen.Wait(250)
        SetVisibility(true)
        CellCamActivate(false, false)
    end)
    local returnData = Citizen.Await(p)
    cb({success=true, data = {imageURL = returnData}})
end)

RegisterNUICallback("getOffenderDetail", function(data, cb)
    local result = TriggerCallback("gfx-mdt:getOffenderDetail", data)
    cb({success=true, data = result})
end)

RegisterNUICallback("getPoliceDetail", function(data, cb)
    local result = TriggerCallback("gfx-mdt:getPoliceDetail", data)
    cb({success=true, data = result})
end)

RegisterNUICallback("getWanteds", function(data, cb)
    local result = TriggerCallback("gfx-mdt:getWanteds", data)
    cb({success=true, data = result})
end)

RegisterNUICallback("addPolices", function(data, cb)
    local result = TriggerCallback("gfx-mdt:addPolices", data)
    cb({success=result.success, data = result.data, error = result.error, message = result.message})
end)

RegisterNUICallback("getHotWantedList", function(data, cb)
    local result = TriggerCallback("gfx-mdt:getHotWantedList", data)
    cb({success=true, data = result})
end)

RegisterNUICallback("getWantedDetail", function(data, cb)
    local result = TriggerCallback("gfx-mdt:getWantedDetail", data)
    cb({success=true, data = result})
end)

RegisterNUICallback("addEvidenceToWanted", function(data, cb)
    local result = TriggerCallback("gfx-mdt:addEvidenceToWanted", data)
    cb({success=true, data = result})
end)

RegisterNUICallback("editReportTextFromWanted", function(data, cb)
    local result = TriggerCallback("gfx-mdt:editReportTextFromWanted", data)
    cb({success=true, data = result})
end)

RegisterNUICallback("addRankToWanted", function(data, cb)
    local result = TriggerCallback("gfx-mdt:addRankToWanted", data)
    cb({success=true, data = result})
end)

RegisterNUICallback("deleteRankFromWanted", function(data, cb)
    local result = TriggerCallback("gfx-mdt:deleteRankFromWanted", data)
    cb({success=result.success, data = result.data, error = result.error, message = result.message})

end)

RegisterNUICallback("getBanList", function(data, cb)
    local result = TriggerCallback("gfx-mdt:getBanList", data)
    cb({success=true, data = result})
end)

RegisterNUICallback("addBannedUsers", function(data, cb)
    local result = TriggerCallback("gfx-mdt:addBannedUsers", data)
    cb({success=result.success, data = result.data, error = result.error, message = result.message})
end)

RegisterNUICallback("getSearchResults", function(data, cb)
    local result = TriggerCallback("gfx-mdt:getSearchResults", data)
    cb({success=true, data = result})
end)

RegisterNUICallback("getUserInfo", function(data, cb)
    local result = TriggerCallback("gfx-mdt:getUserInfo", data)
    cb({success=true, data = result})
end)

RegisterNUICallback("getVehicleInfo", function(data, cb)
    local result = TriggerCallback("gfx-mdt:getVehicleInfo", data)
    cb({success = true, data = result})
end)

RegisterNUICallback("addRankToUser", function(data, cb)
    local result = TriggerCallback("gfx-mdt:addRankToUser", data)
    cb({success=true, data = result})
end)

RegisterNUICallback("addEvidenceToUser", function(data, cb)
    local result = TriggerCallback("gfx-mdt:addEvidenceToUser", data)
    cb({success=true, data = result})
end)

RegisterNUICallback("deleteEvidenceFromUser", function(data, cb)
    local result = TriggerCallback("gfx-mdt:deleteEvidenceFromUser", data)
    cb({success=true, data = result})
end)

RegisterNUICallback("deleteEvidenceFromWanted", function(data, cb)
    local result = TriggerCallback("gfx-mdt:deleteEvidenceFromWanted", data)
    cb({success=true, data = result})
end)

RegisterNUICallback("deletePolice", function(data, cb)
    local result = TriggerCallback("gfx-mdt:deletePolice", data)
    cb({success=true, data = result})
end)

RegisterNUICallback("deleteRankFromUser", function(data, cb)
    local result = TriggerCallback("gfx-mdt:deleteRankFromUser", data)
    cb({success=true, data = result})
end)

RegisterNUICallback("deleteBanList", function(data, cb)
    local result = TriggerCallback("gfx-mdt:deleteBanList", data)
    cb({success=true, data = result})
end)

RegisterNUICallback("editReportTextFromPolice", function(data, cb)
    local result = TriggerCallback("gfx-mdt:editReportTextFromPolice", data)
    cb({success=true, data = result})
end)

RegisterNUICallback("editReportTextFromOffender", function(data, cb)
    local result = TriggerCallback("gfx-mdt:editReportTextFromOffender", data)
    cb({success=true, data = result})
end)

RegisterNUICallback("editDescriptionOfDepartment", function(data, cb)
    local result = TriggerCallback("gfx-mdt:editDescriptionOfDepartment", data)
    cb({success=true, data = result})
end)

RegisterNUICallback("addRankToOffender", function(data, cb)
    local result = TriggerCallback("gfx-mdt:addRankToOffender", data)
    cb({success=true, data = result})
end)

RegisterNUICallback("deleteRankFromOffender", function(data, cb)
    local result = TriggerCallback("gfx-mdt:deleteRankFromOffender", data)
    cb({success=result.success, data = result.data, error = result.error, message = result.message})
end)

RegisterNUICallback("addEvidenceToOffender", function(data, cb)
    local result = TriggerCallback("gfx-mdt:addEvidenceToOffender", data)
    cb({success=result.success, data = result.data, error = result.error, message = result.message})
end)

RegisterNUICallback("deleteEvidenceFromOffender", function(data, cb)
    local result = TriggerCallback("gfx-mdt:deleteEvidenceFromOffender", data)
    cb({success=result.success, data = result.data, error = result.error, message = result.message})
end)

RegisterNUICallback("addEvidenceToPolice", function(data, cb)
    local result = TriggerCallback("gfx-mdt:addEvidenceToPolice", data)
    cb({success=result.success, data = result.data, error = result.error, message = result.message})
end)

RegisterNUICallback("deleteEvidenceFromPolice", function(data, cb)
    local result = TriggerCallback("gfx-mdt:deleteEvidenceFromPolice", data)
    cb({success=result.success, data = result.data, error = result.error, message = result.message})
end)

RegisterNUICallback("deleteEvidenceFromPolice", function(data, cb)
    local result = TriggerCallback("gfx-mdt:deleteEvidenceFromPolice", data)
    cb({success=result.success, data = result.data, error = result.error, message = result.message})
end)

RegisterNUICallback("changeAvatarFromUser", function(data, cb)
    local result = TriggerCallback("gfx-mdt:changeAvatarFromUser", data)
    cb({success=result.success, data = {image = result.data}, error = result.error, message = result.message})
end)

RegisterNUICallback("loadNotifications", function(data, cb)
    local result = TriggerCallback("gfx-mdt:loadNotifications", data)
    cb({success=result.success, noneData = result.noneData, data = result.data})
end)

RegisterNUICallback("loadRecords", function(data, cb)
    local result = TriggerCallback("gfx-mdt:loadRecords", data)
    cb({success=result.success, noneData = result.noneData, data = result.data})
end)

RegisterNUICallback("changeImageFromVehicle", function(data, cb)
    TriggerCallback("gfx-mdt:changeImageFromVehicle", data)
    cb({success=true, data = {image = data.image}})
end)

RegisterNUICallback("getPermissions", function(data, cb)
    cb({success=true, data = Config.Permissions})
end)

RegisterNUICallback("getLiveMap", function(data, cb)
    local mapData = {
        activePolices = {},
        dispatchs = GetDispatches()
    }
    for i = 1, #dutyList do
        local ped = GetPlayerPed(GetPlayerFromServerId(dutyList[i].id))
        local coords = ped ~= 0 and GetEntityCoords(ped) or dutyList[i].coords
        table.insert(mapData.activePolices, {
            id = dutyList[i].id,
            position = {coords.y, coords.x},
            avatar = dutyList[i].avatar,
            name = dutyList[i].name,
            rank = dutyList[i].rankInfo,
            circleColor = dutyList[i].circleColor,
            isMe = GetPlayerServerId(PlayerId()) == dutyList[i].id
        })
    end
    cb({success = true, data = mapData})
    return {success = true, data = mapData}
end)

RegisterNUICallback("getLocales", function(data, cb)
    cb({
        success = true,
        data = {
            pageDescription = {
                none =  'Page description none.',
                homepage =  'Homepage Description',
                records =  'Records Description',
                wanteds =  'Wanteds Description',
                fines =  'Fines Description',
                department =  'Department Description',
                liveMap = 'Live Map Description',
            }
        }
    })
end)

RegisterNUICallback("addFinesToOffender", function(data, cb)
    local result = TriggerCallback("gfx-mdt:addFinesToOffender", data)
    cb({success=result.success, data = result.data, error = result.error, message = result.message})
end)

RegisterNUICallback("deleteFinesFromOffender", function(data, cb)
    local result = TriggerCallback("gfx-mdt:deleteFinesFromOffender", data)
    cb({success=result.success, data = result.data, error = result.error, message = result.message})
end)

function getOnDutyList()
    local result = TriggerCallback("gfx-mdt:getOnDutyList")
    for i = 1, #result do
        result[i].ped = result[i].id ~= GetPlayerServerId(PlayerId()) and GetPlayerPed(GetPlayerFromServerId(result[i].id)) or PlayerPedId()
        result[i].coords = result[i].coords and result[i].coords or (result[i].ped ~= -1 and GetEntityCoords(result[i].ped) or false)
        result[i].location = result[i].coords and GetStreetName(result[i].coords) or false
        result[i].marker = {
            id = 1,
            name = result[i].name,
            avatar = result[i].avatar,
            rank = result[i].rankInfo,
            position = {result[i].coords.y, result[i].coords.x}
        }
        table.insert(dutyList, result[i])
    end
    return result
end

RegisterNUICallback("setGPS", function(data, cb)
    local x, y = data.x, data.y
    x, y = x + 0.0, y + 0.0
    SetNewWaypoint(y, x)
end)

RegisterNUICallback("deleteDispatch", function(data, cb)
    TriggerServerEvent("gfx-mdt:RemoveDispatch", data.id)
    cb({success=true, id = data.id})
end)