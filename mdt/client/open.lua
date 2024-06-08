function GetWeaponName(weaponHash)
    if Config.Framework == "esx" or Config.Framework == "oldesx" then
        return ESX.GetWeaponLabel(weaponHash)
    elseif Config.Framework == "qb" or Config.Framework == "newqb" then
        return QBCore.Shared.Weapons[weaponHash]["label"]
    end
end