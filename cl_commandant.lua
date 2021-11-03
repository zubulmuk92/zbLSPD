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

            end, function()
            end)
        if not RageUI.Visible(zbmenuPatron) then
            zbmenuPatron = RMenu:DeleteType("Commissaire LSPD", true)
        end
    end
end

-- Menu saisie

local nombreDobjets = 0
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
                        print(nombreDobjets)
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

                RageUI.Separator(" ~b~↓     ~w~Nombre d'armes : "..nombreDobjets.."~b~    ↓ ")

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