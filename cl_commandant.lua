-- Menu patron

function menuPatron()
    local zbmenuPatron = RageUI.CreateMenu("Commissaire LSPD", "Intéractions")
    
    RageUI.Visible(zbmenuPatron, not RageUI.Visible(zbmenuPatron))
    while zbmenuPatron do
        Citizen.Wait(0)
            RageUI.IsVisible(zbmenuPatron, true, true, true, function()

                if societypolicemoney ~= nil then
                    RageUI.ButtonWithStyle("Argent société :", nil, {RightLabel = "$" .. societypolicemoney}, true, function()
                    end)
                end

                RageUI.ButtonWithStyle("Retirer argent de société",nil, {RightBadge = RageUI.BadgeStyle.Cash}, true, function(Hovered, Active, Selected)
                    if Selected then
                        local amount = KeyboardInput("Montant", "", 10)
                        amount = tonumber(amount)
                        if amount == nil then
                            ESX.ShowNotification("~r~ERREUR~s~: Montant invalide.")
                        else
                            TriggerServerEvent('esx_society:withdrawMoney', 'police', amount)
                            rafraichirArgentSociete()
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
                            rafraichirArgentSociete()
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

function menuSaisie()
    local zbmenuSaisie = RageUI.CreateMenu("Saisie LSPD", "Armes disponibles")
    
    RageUI.Visible(zbmenuSaisie, not RageUI.Visible(zbmenuSaisie))
    while zbmenuSaisie do
        Citizen.Wait(0)
            RageUI.IsVisible(zbmenuSaisie, true, true, true, function()

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
        if not RageUI.Visible(zbmenuSaisie) then
            zbmenuSaisie = RMenu:DeleteType("Saisie LSPD", true)
        end
    end
end