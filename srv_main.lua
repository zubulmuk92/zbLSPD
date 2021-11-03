ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)




RegisterNetEvent('zubul:prendreservice')
AddEventHandler('zubul:prendreservice', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers = ESX.GetPlayers()

    local date = os.date("%d/%m/%y %X")

    if zbConfig.DiscordWebHook then
        envoieDiscordWebhook("Prise de service","**"..xPlayer.getName().."** a pris son service.\n\nDate : *"..date.."*", 34816, zbConfig.DiscordWebHookLienPriseService)
    end	    

    for i=1, #xPlayers, 1 do
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'LSPD', '~g~Prise de service', "L'agent "..xPlayer.getName().." a pris son service." , zbConfig.PictureNotification, 8)
	end

end)

RegisterNetEvent('zubul:quitterservice')
AddEventHandler('zubul:quitterservice', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayers = ESX.GetPlayers()

    local date = os.date("%d/%m/%y %X")

    if zbConfig.DiscordWebHook then
        envoieDiscordWebhook("Fin de service","**"..xPlayer.getName().."** a quitté son service\n\nDate : *"..date.."*", 9764864, zbConfig.DiscordWebHookLienQuitterService)
    end

    for i=1, #xPlayers, 1 do
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'LSPD', '~r~Fin de service', "L'agent "..xPlayer.getName().." a quitté son service.", zbConfig.PictureNotification, 8)
	end

end)

RegisterNetEvent('zubul:rendrearmes')
AddEventHandler('zubul:rendrearmes', function()

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local date = os.date("%d/%m/%y %X")

    if zbConfig.DiscordWebHook then
        envoieDiscordWebhook("Retour armes","**"..xPlayer.getName().."** a rendu toutes ses armes.\n\nDate : *"..date.."*", 9764864, zbConfig.DiscordWebHookLienPriseArmes)
    end	

	for k,v in pairs(zbConfig.ArmesArmurerieLSPD) do
		xPlayer.removeWeapon(zbConfig.ArmesArmurerieLSPD[k].model)
	end

	TriggerClientEvent('esx:showAdvancedNotification', _source, 'LSPD',"Armurerie", "Vous avez bien ~r~déposé~w~ toutes vos armes.", zbConfig.PictureNotification, 8)
end)

RegisterNetEvent('zubul:prendrearmes')
AddEventHandler('zubul:prendrearmes', function(armes,nom)
    

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local date = os.date("%d/%m/%y %X")

    if zbConfig.DiscordWebHook then
        envoieDiscordWebhook("Prise d'arme","**"..xPlayer.getName().."** a pris un(e) "..nom..".\n\nDate : *"..date.."*", 34816, zbConfig.DiscordWebHookLienPriseArmes)
    end	

    xPlayer.addWeapon(armes, 256)
	TriggerClientEvent('esx:showAdvancedNotification', _source, 'LSPD',"Armurerie", "Vous avez bien ~g~récupéré~w~ un(e) "..nom.." .", zbConfig.PictureNotification, 8)

end)

RegisterNetEvent('zubul:discordPrendreVehicule')
AddEventHandler('zubul:discordPrendreVehicule', function(nom)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local date = os.date("%d/%m/%y %X")

    envoieDiscordWebhook("Prise de véhicule","**"..xPlayer.getName().."** a pris un(e) "..nom..".\n\nDate : *"..date.."*", 34816, zbConfig.DiscordWebHookLienSpawnVehicule)
end)

RegisterNetEvent('zubul:discordRetourVehicule')
AddEventHandler('zubul:discordRetourVehicule', function()

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local date = os.date("%d/%m/%y %X")

    envoieDiscordWebhook("Retour de véhicule","**"..xPlayer.getName().."** a rendu son véhicule.\n\nDate : *"..date.."*", 9764864, zbConfig.DiscordWebHookLienRetourVehicule)
end)