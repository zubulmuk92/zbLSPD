function GetVehicleBrandAndModel(modelName)
    if Config.Framework == "esx" or Config.Framework == "oldesx" then
        return "Unknown"
    elseif Config.Framework == "qb" or Config.Framework == "newqb" then
        return QBCore.Shared.Vehicles[modelName].brand.. " " ..QBCore.Shared.Vehicles[modelName].name
    end
end