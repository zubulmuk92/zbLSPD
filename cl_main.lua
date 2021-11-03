ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- INIT

local PlayerData = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
     PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job  
	Citizen.Wait(5000) 
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
    ESX.PlayerData.job2 = job2
end)

local service = false
local etatservice = false
local depannageencours = false
local extramenu = false

-- Création touche pour ouvrir menu

Keys.Register('F6', 'LSPD', 'Ouvrir le menu LSPD', function()
	if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
    	MenuF6()
	end
end)

-- Menu armurerie

function menuArmurerie()
    local zbmenuArmurerie = RageUI.CreateMenu("Armurerie LSPD", "Armes disponibles")
    
    RageUI.Visible(zbmenuArmurerie, not RageUI.Visible(zbmenuArmurerie))
    while zbmenuArmurerie do
        Citizen.Wait(0)
            RageUI.IsVisible(zbmenuArmurerie, true, true, true, function()

                RageUI.ButtonWithStyle("Rendre ses armes",nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                    if Selected then                
                        TriggerServerEvent('zubul:rendrearmes')
                    end
                end)    

                RageUI.Checkbox("Equiper un gillet-par-balle",nil, equiper,{},function(Hovered,Ative,Selected,Checked)
                    if Selected then
    
                        equiper = Checked
    
                        if Checked then
                            equiperGPB()
                            SetPedArmour(GetPlayerPed(-1), 100)
                        else
                            enleverGPB()
                            SetPedArmour(GetPlayerPed(-1), 0)
                        end
                    end
                end)

                RageUI.Separator("~b~ ↓      ~w~Ton grade : ~b~"..ESX.PlayerData.job.grade_label.." ~b~      ↓ ~w~")

                for k,v in pairs(zbConfig.ArmesArmurerieLSPD) do

                    if ESX.PlayerData.job.grade >= zbConfig.ArmesArmurerieLSPD[k].gradeMin then
                        RageUI.ButtonWithStyle(zbConfig.ArmesArmurerieLSPD[k].nom, "Prendre un(e) "..zbConfig.ArmesArmurerieLSPD[k].nom, {RightBadge = RageUI.BadgeStyle.Gun}, true, function(Hovered, Active, Selected)
                            if Selected then

                                TriggerServerEvent('zubul:prendrearmes', zbConfig.ArmesArmurerieLSPD[k].model,zbConfig.ArmesArmurerieLSPD[k].nom)

                            end
                        end) 
                    end
                end

            end, function()
            end)
        if not RageUI.Visible(zbmenuArmurerie) then
            zbmenuArmurerie = RMenu:DeleteType("Armurerie LSPD", true)
        end
    end
end

-- Menu véhicule liste

function vehiculeListe()
    local zbVehiculeListe = RageUI.CreateMenu("Garage LSPD", "Véhicules disponibles")
    
    RageUI.Visible(zbVehiculeListe, not RageUI.Visible(zbVehiculeListe))
    while zbVehiculeListe do
        Citizen.Wait(0)
            RageUI.IsVisible(zbVehiculeListe, true, true, true, function()

                RageUI.ButtonWithStyle("Ranger un véhicule",nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                    if Selected then                
                        if IsPedInAnyVehicle(PlayerPedId()) then

                            local vehicule = GetVehiclePedIsIn(PlayerPedId(), false)
                            DeleteEntity(vehicule)

                            if DiscordWebHook then
                                TriggerServerEvent("zubul:discordRetourVehicule")
                            end
                            
                        else
                            RageUI.CloseAll()
                            ESX.ShowNotification("~r~ERREUR~s~: Tu n'es pas dans un véhicule.")
                        end
                    end
                end)    

                if zbConfig.ExtraMenu then

                    RageUI.Checkbox("Menu Extra","Ouvrir ou non le menu des extras à la livraison du véhicule", menu,{},function(Hovered,Ative,Selected,Checked)
                        if Selected then
        
                            menu = Checked
        
                            if Checked then
                                extramenu = true
                            else
                                extramenu = false
                            end
                        end
                    end)
                end

                RageUI.Separator("~b~ →      ~w~Ton grade : ~b~"..ESX.PlayerData.job.grade_label.." ~b~      ← ~w~")

                RageUI.Separator("~b~ ↓ ~w~     Voitures     ~b~ ↓ ~w~")

                for k,v in pairs(zbConfig.VoitureGarageLSPD) do

                    if ESX.PlayerData.job.grade >= zbConfig.VoitureGarageLSPD[k].gradeMin then
                        RageUI.ButtonWithStyle(zbConfig.VoitureGarageLSPD[k].nom, "Prendre pour véhicule de fonction un(e) "..zbConfig.VoitureGarageLSPD[k].nom, {RightBadge = RageUI.BadgeStyle.Car}, true, function(Hovered, Active, Selected)
                            if Selected then

                                local voiture = GetHashKey(zbConfig.VoitureGarageLSPD[k].model)

                                if zbConfig.DiscordWebHook then
                                    TriggerServerEvent("zubul:discordPrendreVehicule",zbConfig.VoitureGarageLSPD[k].nom)
                                end

                                RequestModel(voiture)
                                while not HasModelLoaded(voiture) do
                                    RequestModel(voiture)
                                    RageUI.Text({ message = "Spawn du véhicule en cours ...", time_display = 1 })
                                    Citizen.Wait(0)
                                end

                                local vehicle = CreateVehicle(voiture, zbConfig.CoordonnesVehiculeSpawn.x, zbConfig.CoordonnesVehiculeSpawn.y, zbConfig.CoordonnesVehiculeSpawn.z, zbConfig.CoordonnesVehiculeSpawn.heading, true, false)
                                SetEntityAsMissionEntity(vehicle, true, true)
                                local plaque = "LSPD "..math.random(00,99)
                                SetVehicleNumberPlateText(vehicle, plaque)
                                SetPedIntoVehicle(PlayerPedId(),vehicle,-1)

                                RageUI.CloseAll()
                                if extramenu == true then
                                    OpenClothUi() 
                                end
                            end
                        end) 
                    end
                end

                RageUI.Separator("~b~ ↓ ~w~     Motos     ~b~ ↓ ~w~")

                for k,v in pairs(zbConfig.MotoGarageLSPD) do

                    if ESX.PlayerData.job.grade >= zbConfig.MotoGarageLSPD[k].gradeMin then
                        RageUI.ButtonWithStyle(zbConfig.MotoGarageLSPD[k].nom, "Prendre pour véhicule de fonction un(e) "..zbConfig.MotoGarageLSPD[k].nom, {RightBadge = RageUI.BadgeStyle.Bike}, true, function(Hovered, Active, Selected)
                            if Selected then

                                local voiture = GetHashKey(zbConfig.MotoGarageLSPD[k].model)

                                if zbConfig.DiscordWebHook then
                                    TriggerServerEvent("zubul:discordPrendreVehicule",zbConfig.MotoGarageLSPD[k].nom)
                                end

                                RequestModel(voiture)
                                while not HasModelLoaded(voiture) do
                                    RequestModel(voiture)
                                    RageUI.Text({ message = "Spawn de la moto en cours ...", time_display = 1 })
                                    Citizen.Wait(0)
                                end

                                local vehicle = CreateVehicle(voiture, zbConfig.CoordonnesVehiculeSpawn.x, zbConfig.CoordonnesVehiculeSpawn.y, zbConfig.CoordonnesVehiculeSpawn.z, zbConfig.CoordonnesVehiculeSpawn.heading, true, false)
                                SetEntityAsMissionEntity(vehicle, true, true)
                                local plaque = "LSPD "..math.random(00,99)
                                SetVehicleNumberPlateText(vehicle, plaque)
                                SetPedIntoVehicle(PlayerPedId(),vehicle,-1)

                                RageUI.CloseAll()
                                if extramenu == true then
                                    OpenClothUi() 
                                end
                            end
                        end)
                    end
                end

            end, function()
            end)
        if not RageUI.Visible(zbVehiculeListe) then
            zbVehiculeListe = RMenu:DeleteType("Garage LSPD", true)
        end
    end
end

-- Menu recherche plaque

function recherchePlaque(plaquerachercher)
    local zbPlaqueMenu = RageUI.CreateMenu("Plaque d'immatriculation", "Informations")
    RageUI.Visible(zbPlaqueMenu, not RageUI.Visible(zbPlaqueMenu))
    ESX.TriggerServerCallback('zubul:recupererInfoVehicule', function(wouf)
            while zbPlaqueMenu do
                Citizen.Wait(0)
                    RageUI.IsVisible(zbPlaqueMenu, true, true, true, function()
                        RageUI.ButtonWithStyle("Numéro de plaque : ", nil, {RightLabel = wouf.plate}, true, function(Hovered, Active, Selected)
                            if Selected then
                            end
                        end)

                        if not wouf.owner then
                            RageUI.ButtonWithStyle("Propriétaire : ", nil, {RightLabel = "Inconnu"}, true, function(Hovered, Active, Selected)
                                if Selected then
                                end
                            end)
                        else
                            local hashvoiture = wouf.vehicle.model
                            local nomvoituremodele = GetDisplayNameFromVehicleModel(hashvoiture)
                            local nomvoituretexte  = GetLabelText(nomvoituremodele)

                            RageUI.ButtonWithStyle("Propriétaire : ", nil, {RightLabel = wouf.owner}, true, function(Hovered, Active, Selected)
                                if Selected then
                                end
                            end)

                            RageUI.ButtonWithStyle("Modèle du véhicule : ", nil, {RightLabel = nomvoituretexte}, true, function(Hovered, Active, Selected)
                                if Selected then
                                end
                            end)

                        end
                    end, function()
                    end)
            end
    end, plaquerachercher)
    if not RageUI.Visible(zbPlaqueMenu) then
        zbPlaqueMenu = RMenu:DeleteType("Plaque d'immatriculation", true)
    end
end

-- Menu F6

function MenuF6()

    local zbMainMenu = RageUI.CreateMenu("LSPD", "Interactions")

    RageUI.Visible(zbMainMenu, not RageUI.Visible(zbMainMenu))

    while zbMainMenu do
        Citizen.Wait(0)


        RageUI.IsVisible(zbMainMenu, true, true, true, function()

            RageUI.Checkbox("Prendre/Quitter son service",nil, service,{},function(Hovered,Ative,Selected,Checked)
                if Selected then

                    service = Checked

                    if Checked then
                        etatservice = true
                        TriggerServerEvent('zubul:prendreservice')
                    else
                        etatservice = false
                        TriggerServerEvent('zubul:quitterservice')
                    end
                end
            end)

            if etatservice then
                RageUI.Separator("~b~"..ESX.PlayerData.job.grade_label.." - "..GetPlayerName(PlayerId()))

                RageUI.Separator(" ~b~↓ ~w~Intéraction citoyen~b~ ↓ ")

                -- Interaction citoyen 1.0

                RageUI.ButtonWithStyle("Donner une amende",nil, {RightLabel = "→"}, true, function(_,_,s)
                    local player, distance = ESX.Game.GetClosestPlayer()
                    if s then
                        local raison = ""
                        local montant = 0
                        AddTextEntry("FMMC_MPM_NA", "Objet de la facture")
                        DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Donnez le motif de la facture :", "", "", "", "", 30)
                        while (UpdateOnscreenKeyboard() == 0) do
                            DisableAllControlActions(0)
                            Wait(0)
                        end
                        if (GetOnscreenKeyboardResult()) then
                            local result = GetOnscreenKeyboardResult()
                            if result then
                                raison = result
                                result = nil
                                AddTextEntry("FMMC_MPM_NA", "Montant de la facture")
                                DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Indiquez le montant de la facture :", "", "", "", "", 30)
                                while (UpdateOnscreenKeyboard() == 0) do
                                    DisableAllControlActions(0)
                                    Wait(0)
                                end
                                if (GetOnscreenKeyboardResult()) then
                                    result = GetOnscreenKeyboardResult()
                                    if result then
                                        montant = result
                                        result = nil
                                        if player ~= -1 and distance <= 3.0 then
                                            TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_police', ('Police'), montant)
                                            TriggerEvent('esx:showAdvancedNotification', 'Fl~g~ee~s~ca ~g~Bank', 'Facture envoyée : ', 'Vous avez envoyé une facture d\'un montant de : ~g~'..montant.. '$ ~s~pour cette raison : ~b~' ..raison.. '', 'CHAR_BANK_FLEECA', 9)
                                        else
                                            ESX.ShowNotification("~r~ERREUR~s~: Aucun citoyen proche.")
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)

                RageUI.ButtonWithStyle("Interagir avec le citoyen",nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                    if Selected then                
                        TriggerEvent('fellow:MenuFouille')
                    end
                end)    

                if ESX.PlayerData.job.grade_name == 'boss' then
                    RageUI.ButtonWithStyle("Donner le PPA", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                        if (Selected) then
                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestPlayer ~= -1 and closestDistance <= 3.0 then
                                TriggerServerEvent('esx_license:addLicense', GetPlayerServerId(closestPlayer), 'weapon')
                                ESX.ShowNotification("Vous avez bien ~g~donné~w~ le PPA à "..GetPlayerName(closestPlayer))
                         else
                            ESX.ShowNotification('~r~ERREUR~s~: Aucun citoyen proche.')
                        end
                    end
                    end)
                end

                RageUI.Separator(" ~b~↓ ~w~Intéraction véhicule~b~ ↓ ")

                -- Interaction vehicule 1.1

                RageUI.ButtonWithStyle("Mettre le véhicule en fourrière","~r~Attention~w~ , le dépanneur s'arretera exactement à l'endroit où vous l'apellez , pensez a vous décaler.", {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                    if Selected then                

                        local miaous = ESX.Game.GetVehicleInDirection()
            
                        if DoesEntityExist(miaous) then
                            local headingJoueur = GetEntityHeading(PlayerPedId())
                            local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
                            local pedjoueur = PlayerPedId()
                            local vehicule = GetHashKey("flatbed")

                            ESX.ShowAdvancedNotification('LSPD', 'Demande de ~o~fourrière', 'Un dépanneur est en route.', "CHAR_ABIGAIL", 8)
                            
                            RequestModel(vehicule)
                            while not HasModelLoaded(vehicule) do
                            Wait(1)
                            end
                            
                            local coords = GetEntityCoords(pedjoueur,true)

                            local found, outPos, outHeading = GetClosestVehicleNodeWithHeading(coords['x']+50, coords['y']+50, coords['z'], 1, 3.0, 0)
                            local found2, outPos2, outHeading2 = GetClosestVehicleNodeWithHeading(coords['x'], coords['y'], coords['z'], 1, 3.0, 0)

                            if found then
                            local spawned_car = CreateVehicle(vehicule, outPos, outHeading, true, false)
                            SetVehicleOnGroundProperly(spawned_car)
                            SetModelAsNoLongerNeeded(vehicule)
                            SetVehicleEngineOn(spawned_car, true, true, false)

                            creerBlipEntite(spawned_car,"~o~Dépanneur",67,4,0.6,47)

                            local ped_hash = GetHashKey("csb_trafficwarden")
                            RequestModel(ped_hash)
                            while not HasModelLoaded(ped_hash) do
                                Citizen.Wait(1)
                            end	

                            local depanneurPed = CreatePedInsideVehicle(spawned_car, "PED_TYPE_CIVMALE", "csb_trafficwarden", -1, true, false)
                            local carDistance = GetEntityCoords(spawned_car)
                            local distance = GetDistanceBetweenCoords(coords['x'],coords['y'],coords['z'], carDistance.x,carDistance.y,carDistance.z, true)
                            
                            TaskVehicleDriveToCoord(depanneurPed, spawned_car, coords['x'],coords['y'],coords['z'], 6.0, false, vehicule, 2883621, 10, 0)

                            depannageencours = true

                            local point = "..."
                            local pointcount = 1

                            while depannageencours do

                                RageUI.Text({ message = "~o~Dépannage en cours ...\n~w~( ne pas ouvrir votre menu f6 )", time_display = 300 })

                                Citizen.Wait(300)

                                carDistance = GetEntityCoords(spawned_car)
                                distance = GetDistanceBetweenCoords(coords['x'],coords['y'],coords['z'], carDistance.x,carDistance.y,carDistance.z, true)
                                if distance < 8.0 then
                                    depannageencours=false
                                end

                            end
                            SetVehicleEngineOn(spawned_car, false, true, false)
                            Citizen.Wait(1500)
                            TaskLeaveVehicle(depanneurPed, spawned_car, 0)
                            
                            TaskGoToCoordAnyMeans(depanneurPed,x,y,z, headingJoueur, 0, 0, 0, 0xbf800000)

                            Citizen.Wait(5000)

                            TaskStartScenarioInPlace(depanneurPed, 'WORLD_HUMAN_CLIPBOARD', 0, true)
                            Citizen.Wait(5000)
                            ClearPedTasks(depanneurPed)
                            AttachEntityToEntity(miaous, spawned_car, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)

                            TaskEnterVehicle(depanneurPed, spawned_car, 5000, -1, 2.0, 1, 0)

                            Citizen.Wait(5000)

                            TaskVehicleDriveToCoord(depanneurPed, spawned_car, -230.7824, -1173.442, 22.84326, 18.0, false, vehicule, 2883621, 10, 0)

                            local depannageencours2 = true

                            while depannageencours2 == true do
                                Citizen.Wait(500)
                                carDistance = GetEntityCoords(spawned_car)
                                distance = GetDistanceBetweenCoords(-230.7824, -1173.442, 22.84326, carDistance.x,carDistance.y,carDistance.z, true)
                                if distance < 3.0 then
                                    ClearPedTasksImmediately(depanneurPed)
                                    DeletePed(depanneurPed)
                                    DeleteVehicle(spawned_car)
                                    DeleteVehicle(miaous)
                                    DeleteBlip(blip)

                                    depannageencours2 = false
                                end
                            end
                            -- apres c'est du not found
                            end
                        else
                            ESX.ShowNotification("~r~ERREUR~s~: Aucun véhicule proche.")    
                        end
                        ESX.ShowAdvancedNotification('LSPD', 'Demande de ~o~fourrière', 'Le véhicule a bien été déposer en fourrière.', "CHAR_ABIGAIL", 8)
                    end
                end)
                
                RageUI.ButtonWithStyle("Rechercher une plaque",nil, {RightLabel = "→→"}, true, function(Hovered, Active, Selected)
                    if Selected then                
                        local numplaque = KeyboardInput("Combien ?", "", 10)
                        local taille = string.len(numplaque)
                        if not numplaque or taille < 2 or taille > 10 then
                            ESX.ShowNotification("~r~ERREUR ~w~: Le numéro entré est invalide.")
                        else
                            RageUI.CloseAll()
                            recherchePlaque(numplaque)
                        end
                    end
                end)

                RageUI.Separator('~b~↓~w~ Divers ~b~↓')

                RageUI.Checkbox("Bouclier",nil, bouclier,{},function(Hovered,Ative,Selected,Checked)
                    if Selected then
    
                        bouclier = Checked
    
    
                        if Checked then
                            ActiverBouclier()
                            
                        else
                            DesactiverBouclier()
                        end
                    end
                end)


            end

        end, function() 
        end)

        if not RageUI.Visible(zbMainMenu) then
            zbMainMenu = RMenu:DeleteType("LSPD", true)
        end

    end

end

-- Zones d'ouverture de menu

Citizen.CreateThread(function()
    while true do

        local sleep = 600
        
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
        local plyCoords = GetEntityCoords(PlayerPedId(), false)
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, zbConfig.CoordonnesGarageLSPD.x, zbConfig.CoordonnesGarageLSPD.y, zbConfig.CoordonnesGarageLSPD.z)
        if dist <= 8.0 then
            sleep = 0
            DrawMarker(20, zbConfig.CoordonnesGarageLSPD.x, zbConfig.CoordonnesGarageLSPD.y, zbConfig.CoordonnesGarageLSPD.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 0, 255, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist <= 3.0 then
                sleep = 0   
                RageUI.Text({ message = "Appuyez sur ~b~[E]~s~ pour accéder au garage", time_display = 1 })
                if IsControlJustPressed(1,51) then           
                    vehiculeListe()
                end   
            end
        end

    Citizen.Wait(sleep)

    end
end)

Citizen.CreateThread(function()
    while true do

        local sleep2 = 600
        
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
        local plyCoords2 = GetEntityCoords(PlayerPedId(), false)
        local dist2 = Vdist(plyCoords2.x, plyCoords2.y, plyCoords2.z, zbConfig.CoordonnesArmurerieLSPD.x, zbConfig.CoordonnesArmurerieLSPD.y, zbConfig.CoordonnesArmurerieLSPD.z)
        if dist2 <= 8.0 then
            sleep2 = 0
            DrawMarker(20, zbConfig.CoordonnesArmurerieLSPD.x, zbConfig.CoordonnesArmurerieLSPD.y, zbConfig.CoordonnesArmurerieLSPD.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 0, 0, 255, 255, 0, 1, 2, 0, nil, nil, 0)
            end
            if dist2 <= 3.0 then
                sleep2 = 0   
                RageUI.Text({ message = "Appuyez sur ~b~[E]~s~ pour accéder à l'armurerie", time_display = 1 })
                if IsControlJustPressed(1,51) then           
                    menuArmurerie()
                end   
            end
        end

    Citizen.Wait(sleep2)

    end
end)