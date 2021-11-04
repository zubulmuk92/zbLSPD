function envoieDiscordWebhook (name,message,color,url)
    local DiscordWebHook = url
	local embeds = {
		{
			["title"]="LSPD | Los Santos Police Department",
			["description"]=message,
			["type"]="rich",
			["color"] =color,
			["footer"]=  {
			["text"]= name,
			},
		}
	}
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function getMaximumGrade(jobname)
	local queryDone, queryResult = false, nil

	MySQL.Async.fetchAll('SELECT * FROM job_grades WHERE job_name = @jobname ORDER BY `grade` DESC ;', {
		['@jobname'] = jobname
	}, function(result)
		queryDone, queryResult = true, result
	end)

	while not queryDone do
		Citizen.Wait(10)
	end

	if queryResult[1] then
		return queryResult[1].grade
	end

	return nil
end

ESX.RegisterServerCallback('zubul:recuperationAddonInventory', function(source, cb)
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterNetEvent('zubul:recuperationAddonInventoryUnParUn')
AddEventHandler('zubul:recuperationAddonInventoryUnParUn', function(itemName, count)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		if count > 0 and inventoryItem.count >= count then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
				TriggerClientEvent('esx:showNotification', _source, 'Vous avez retiré ~r~'..inventoryItem.label.." x"..count)
				if zbConfig.DiscordWebHook then
					local date = os.date("%d/%m/%y %X")
		
					envoieDiscordWebhook("Retrait objet(s) saisie","**"..xPlayer.getName().."** a retiré de la saisie "..count.." "..inventoryItem.label.."\n\nDate : *"..date.."*", 9764864, zbConfig.DiscordWebHookLienSaisies)
				end
		else
			TriggerClientEvent('esx:showNotification', _source, "Quantité invalide")
		end

		
	end)
end)

ESX.RegisterServerCallback('zubul:recupererInventaireJoueur', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	cb({items = items})
end)

RegisterNetEvent('zubul:deposerSaisieZebiJenAiMarre')
AddEventHandler('zubul:deposerSaisieZebiJenAiMarre', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local sourceItem = xPlayer.getInventoryItem(itemName)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		if sourceItem.count >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			xPlayer.showNotification('Vous avez déposé ~g~'..count.." "..inventoryItem.label)
		else
			TriggerClientEvent('esx:showNotification', _source, "Quantité invalide")
		end

		if zbConfig.DiscordWebHook then
			local date = os.date("%d/%m/%y %X")

            envoieDiscordWebhook("Depôt objet(s) saisie","**"..xPlayer.getName().."** a déposé en saisie "..count.." "..inventoryItem.label.."\n\nDate : *"..date.."*", 34816, zbConfig.DiscordWebHookLienSaisies)
        end
	end)
end)


ESX.RegisterServerCallback('zubul:recupererInfoVehicule', function(source, cb, plate)

	MySQL.Async.fetchAll('SELECT owner, vehicle FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)

		local wouaf = {
			plate = plate
		}

		if result[1] then
			MySQL.Async.fetchAll('SELECT firstname, lastname FROM users WHERE identifier = @identifier',  {
				['@identifier'] = result[1].owner
			}, function(result2)

				wouaf.owner = result2[1].firstname .. ' ' .. result2[1].lastname

				wouaf.vehicle = json.decode(result[1].vehicle)

				cb(wouaf)

			end)
		else
			cb(wouaf)
		end
	end)
end)

-- TODO

ESX.RegisterServerCallback('zubul:recuperationArmesEnStock', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_' .. xPlayer.job.name, function(store)
		local weapons = store.get('weapons') or {}
		cb(weapons)
	end)
end)

ESX.RegisterServerCallback('zubul:ajouterArmesSaisie', function(source, cb, weaponName, weaponAmmo,nom)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getSharedDataStore', 'society_' .. xPlayer.job.name, function(store)
		local weapons = store.get('weapons') or {}
		weaponName = string.lower(weaponName) -- prq ca marche en miniscule et pas majuscules ? je n'est pas la réponse mdr

		table.insert(weapons, {
			name = weaponName,
			ammo = weaponAmmo,
			label = nom,
		})

		xPlayer.removeWeapon(weaponName)
		store.set('weapons', weapons)

		if zbConfig.DiscordWebHook then
			local date = os.date("%d/%m/%y %X")

            envoieDiscordWebhook("Ajout arme saisie","**"..xPlayer.getName().."** a déposé en saisie un(e) "..nom..", avec "..weaponAmmo.." balles\n\nDate : *"..date.."*", 34816, zbConfig.DiscordWebHookLienSaisies)
        end
		
		cb()

	end)
end)

ESX.RegisterServerCallback('zubul:suppressionArmesSaisie', function(source, cb, weaponName, weaponAmmo,nom)
	local xPlayer = ESX.GetPlayerFromId(source)

	if not xPlayer.hasWeapon(weaponName) then
		TriggerEvent('esx_datastore:getSharedDataStore', 'society_' .. xPlayer.job.name, function(store)
			local weapons = store.get('weapons') or {}
			weaponName = string.lower(weaponName)

			for i = 1, #weapons, 1 do
				if weapons[i].name == weaponName and weapons[i].ammo == weaponAmmo then
					table.remove(weapons, i)

					store.set('weapons', weapons)
					xPlayer.addWeapon(weaponName, weaponAmmo)
					if zbConfig.DiscordWebHook then
						local date = os.date("%d/%m/%y %X")

						envoieDiscordWebhook("Retrait arme saisie","**"..xPlayer.getName().."** a retiré de la saisie un(e) "..nom..", avec "..weaponAmmo.." balles\n\nDate : *"..date.."*", 9764864, zbConfig.DiscordWebHookLienSaisies)
					end
					break
				end
			end

			cb()
		end)
	else
		xPlayer.showNotification('Vous possédez déjà cette arme !')
		cb()
	end
end)