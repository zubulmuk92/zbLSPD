ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
TriggerEvent('esx_society:registerSociety', 'police', 'Police', 'society_police', 'society_police', 'society_police', {type = 'public'})



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

RegisterServerEvent('zubul:recruterUnJoueur')
AddEventHandler('zubul:recruterUnJoueur', function(cible, job, grade)
    local xPlayer = ESX.GetPlayerFromId(source)
    local cibleJoueur = ESX.GetPlayerFromId(cible)

    if xPlayer.job.grade_name == 'boss' then
        cibleJoueur.setJob(job, grade)
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez ~g~recruté ' .. cibleJoueur.name .. '~w~.')
        TriggerClientEvent('esx:showNotification', cible, 'Vous avez été ~g~embauché par ' .. xPlayer.name .. '~w~.')
    end

    local date = os.date("%d/%m/%y %X")

    if zbConfig.DiscordWebHook then
        envoieDiscordWebhook("Recrutement","**"..xPlayer.name.."** a recruté "..cibleJoueur.name.."\n\nDate : *"..date.."*", 34816, zbConfig.DiscordWebHookLienActionPatron)
    end

end)

RegisterServerEvent('zubul:virerUnJoueur')
 AddEventHandler('zubul:virerUnJoueur', function(cible)
 	local xPlayer = ESX.GetPlayerFromId(source)
 	local cibleJoueur = ESX.GetPlayerFromId(cible)

 	if xPlayer.job.grade_name == 'boss' and xPlayer.job.name == cibleJoueur.job.name then
        cibleJoueur.setJob('unemployed', 0)
 		TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez ~r~viré ' .. cibleJoueur.name .. '~w~.')
 		TriggerClientEvent('esx:showNotification', cible, 'Vous avez été ~g~viré par ' .. xPlayer.name .. '~w~.')
 	else
 		TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
 	end

    local date = os.date("%d/%m/%y %X")

    if zbConfig.DiscordWebHook then
        envoieDiscordWebhook("Destitution","**"..xPlayer.name.."** a viré "..cibleJoueur.name.."\n\nDate : *"..date.."*", 9764864, zbConfig.DiscordWebHookLienActionPatron)
    end

end)

RegisterServerEvent('zubul:promouvoirUnJoueur')
AddEventHandler('zubul:promouvoirUnJoueur', function(cible)
    local xPlayer = ESX.GetPlayerFromId(source)
    local cibleJoueur = ESX.GetPlayerFromId(cible)

    if (cibleJoueur.job.grade == tonumber(getMaximumGrade(xPlayer.job.name)) - 1) then
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous devez demander une autorisation du ~r~Gouvernement~w~.')
    else
        if xPlayer.job.grade_name == 'boss' and xPlayer.job.name == cibleJoueur.job.name then
            cibleJoueur.setJob(cibleJoueur.job.name, tonumber(cibleJoueur.job.grade) + 1)

            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez ~g~promu ' .. cibleJoueur.name .. '~w~.')
            TriggerClientEvent('esx:showNotification', cible, 'Vous avez été ~g~promu par ' .. xPlayer.name .. '~w~.')
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
        end

        local date = os.date("%d/%m/%y %X")

        if zbConfig.DiscordWebHook then
            envoieDiscordWebhook("Promotion","**"..xPlayer.name.."** a promu "..cibleJoueur.name.."\n\nDate : *"..date.."*", 34816, zbConfig.DiscordWebHookLienActionPatron)
        end
    end
end)

RegisterServerEvent('zubul:destituerUnJoueur')
AddEventHandler('zubul:destituerUnJoueur', function(cible)
    local xPlayer = ESX.GetPlayerFromId(source)
    local cibleJoueur = ESX.GetPlayerFromId(cible)

    if (cibleJoueur.job.grade == 0) then
        TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous ne pouvez pas ~r~rétrograder~w~ d\'avantage.')
    else
        if xPlayer.job.grade_name == 'boss' and xPlayer.job.name == cibleJoueur.job.name then
            cibleJoueur.setJob(cibleJoueur.job.name, tonumber(cibleJoueur.job.grade) - 1)

            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez ~r~rétrogradé ' .. cibleJoueur.name .. '~w~.')
            TriggerClientEvent('esx:showNotification', cible, 'Vous avez été ~r~rétrogradé par ' .. xPlayer.name .. '~w~.')
        else
            TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous n\'avez pas ~r~l\'autorisation~w~.')
        end

        local date = os.date("%d/%m/%y %X")

        if zbConfig.DiscordWebHook then
            envoieDiscordWebhook("Demote","**"..xPlayer.name.."** a démote "..cibleJoueur.name.."\n\nDate : *"..date.."*", 2551280, zbConfig.DiscordWebHookLienActionPatron)
        end
    end
end)