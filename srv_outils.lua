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