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
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'LSPD', '~g~Prise de service', "L'agent "..xPlayer.getName().." a pris son service." , 'CHAR_ABIGAIL', 8)
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
		TriggerClientEvent('esx:showAdvancedNotification', xPlayers[i], 'LSPD', '~r~Fin de service', "L'agent "..xPlayer.getName().." a quitté son service.", 'CHAR_ABIGAIL', 8)
	end

end)