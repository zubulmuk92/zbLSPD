-- Menu patron

local societypolicemoney = nil
local rafraichissement = false

function menuPatron()
    local zbmenuPatron = RageUI.CreateMenu("Commissaire LSPD", "Intéractions")
    
    RageUI.Visible(zbmenuPatron, not RageUI.Visible(zbmenuPatron))
    while zbmenuPatron do
        Citizen.Wait(0)
            RageUI.IsVisible(zbmenuPatron, true, true, true, function()


                if societypolicemoney == nil or rafraichissement == true then
                    ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)
                        societypolicemoney = money
                        rafraichissement = false
                        return societypolicemoney
                    end, ESX.PlayerData.job.name)
                end

                if societypolicemoney ~= nil then
                    RageUI.Separator(" ~b~↓     ~w~Argent société : "..societypolicemoney.."$~b~    ↓ ")
                end

                RageUI.ButtonWithStyle("Retirer argent de société",nil, {RightBadge = RageUI.BadgeStyle.Cash}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local amount = KeyboardInput("Montant", "", 10)
                        amount = tonumber(amount)
                        if amount == nil then
                            ESX.ShowNotification("~r~ERREUR~s~: Montant invalide.")
                        else
                            TriggerServerEvent('esx_society:withdrawMoney', 'police', amount)
                            rafraichissement = true
                        end
                    end
                end)

                RageUI.ButtonWithStyle("Déposer argent de société",nil, {RightBadge = RageUI.BadgeStyle.Cash}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local amount = KeyboardInput("Montant", "", 10)
                        amount = tonumber(amount)
                        if amount == nil then
                            ESX.ShowNotification("~r~ERREUR~s~: Montant invalide.")
                        else
                            TriggerServerEvent('esx_society:depositMoney', 'police', amount)
                            rafraichissement = true
                        end
                    end
                end)

                RageUI.Separator(" ~b~↓     ~w~Gestion du personnel~b~    ↓ ")

                
                RageUI.ButtonWithStyle("Recruter la personne",nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, function(Hovered, Active, Selected)
                    if Selected then
                        if ESX.PlayerData.job.grade_name == 'boss' then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
       
                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ShowAboveRadarMessage('~r~ERREUR : ~w~Aucun citoyen proche.')
                            else
                                TriggerServerEvent('zubul:recruterUnJoueur', GetPlayerServerId(closestPlayer), ESX.PlayerData.job.name, 0)
                            end
                        else
                            ShowAboveRadarMessage('~r~ERREUR : ~w~Tu n\'es pas assez gradé.')
                        end
                    end
                end)

                RageUI.ButtonWithStyle("Virer la personne",nil, {RightBadge = RageUI.BadgeStyle.Alert}, true, function(Hovered, Active, Selected)
                    if Selected then
                        if ESX.PlayerData.job.grade_name == 'boss' then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
       
                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ShowAboveRadarMessage('~r~ERREUR : ~w~Aucun citoyen proche.')
                            else
                                TriggerServerEvent('zubul:virerUnJoueur', GetPlayerServerId(closestPlayer))
                            end
                        else
                            ShowAboveRadarMessage('~r~ERREUR : ~w~Tu n\'es pas assez gradé.')
                        end
                    end
                end)

                RageUI.ButtonWithStyle("Promouvoir la personne",nil, {RightBadge = RageUI.BadgeStyle.Star}, true, function(Hovered, Active, Selected)
                    if Selected then
                        if ESX.PlayerData.job.grade_name == 'boss' then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
       
                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ShowAboveRadarMessage('~r~ERREUR : ~w~Aucun citoyen proche.')
                            else
                                TriggerServerEvent('zubul:promouvoirUnJoueur', GetPlayerServerId(closestPlayer))
                            end
                        else
                            ShowAboveRadarMessage('~r~ERREUR : ~w~Tu n\'es pas assez gradé.')
                        end
                    end
                end)

                RageUI.ButtonWithStyle("Demote la personne",nil, {RightBadge = RageUI.BadgeStyle.Alert}, true, function(Hovered, Active, Selected)
                    if Selected then
                        if ESX.PlayerData.job.grade_name == 'boss' then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
       
                            if closestPlayer == -1 or closestDistance > 3.0 then
                                ShowAboveRadarMessage('~r~ERREUR : ~w~Aucun citoyen proche.')
                            else
                                TriggerServerEvent('zubul:destituerUnJoueur', GetPlayerServerId(closestPlayer))
                            end
                        else
                            ShowAboveRadarMessage('~r~ERREUR : ~w~Tu n\'es pas assez gradé.')
                        end
                    end
                end)

            end, function()
            end)
        if not RageUI.Visible(zbmenuPatron) then
            zbmenuPatron = RMenu:DeleteType("Commissaire LSPD", true)
        end
    end
end

-- Menu saisie

local nombreDobjets = 0
local nombreDarmes=0
local rafraichissementarmes = true
local rafraichissementobjets = true
local itemstock = {}

function menuSaisie()
    local zbmenuSaisie = RageUI.CreateMenu("Saisie LSPD", "Objets disponibles")
    
    RageUI.Visible(zbmenuSaisie, not RageUI.Visible(zbmenuSaisie))
    while zbmenuSaisie do
        Citizen.Wait(0)
            RageUI.IsVisible(zbmenuSaisie, true, true, true, function()

                if rafraichissementobjets == true then
                    ESX.TriggerServerCallback('zubul:recuperationAddonInventory', function(items) 
                        itemstock = items
                        nombreDobjets = 0
                       
                        for k,v in pairs(itemstock) do 
                            nombreDobjets=nombreDobjets+v.count
                        end
                        return nombreDobjets
                    end)
                    rafraichissementobjets=false
                end
                RageUI.Separator(" ~b~↓     ~w~Nombre d'objets : "..nombreDobjets.."~b~    ↓ ")

                RageUI.ButtonWithStyle("Déposer",nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, function(Hovered, Active, Selected)
                    if Selected then
                        rafraichissementobjets = true
                        deposerObjets()
                        RageUI.CloseAll()
                    end
                end)
                if ESX.PlayerData.job.grade <= 1 then
                    RageUI.ButtonWithStyle("Retirer",nil, {RightBadge = RageUI.BadgeStyle.Lock}, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end)
                else
                    RageUI.ButtonWithStyle("Retirer",nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, function(Hovered, Active, Selected)
                        if Selected then
                            rafraichissementobjets = true
                            retirerObjets()
                            RageUI.CloseAll()
                        end
                    end)
                
                end

                if rafraichissementarmes == true then
                    ESX.TriggerServerCallback('zubul:recuperationArmesEnStock', function(weapons)
                        nombreDarmes = 0
                        for i=1, #weapons, 1 do
                            nombreDarmes=nombreDarmes+1
                        end
                        return nombreDarmes
                    end)
                end

                RageUI.Separator(" ~b~↓     ~w~Nombre d'armes : "..nombreDarmes.."~b~    ↓ ")

                RageUI.ButtonWithStyle("Déposer",nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, function(Hovered, Active, Selected)
                    if Selected then
                        rafraichissementobjets = true
                        deposerArmes()
                        RageUI.CloseAll()
                    end
                end)
                if ESX.PlayerData.job.grade <= 1 then
                    RageUI.ButtonWithStyle("Retirer",nil, {RightBadge = RageUI.BadgeStyle.Lock}, true, function(Hovered, Active, Selected)
                        if Selected then
                        end
                    end)
                else
                    RageUI.ButtonWithStyle("Retirer",nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, function(Hovered, Active, Selected)
                        if Selected then
                            rafraichissementobjets = true
                            retirerArmes()
                            RageUI.CloseAll()
                        end
                    end)
                end

            end, function()
            end)
        if not RageUI.Visible(zbmenuSaisie) then
            zbmenuSaisie = RMenu:DeleteType("Saisie LSPD", true)
        end
    end
end