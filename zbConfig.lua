zbConfig = {}

zbConfig = {
    -- Config du blip
    BlipCoordonnes = {x = 423.13, y = -978.85, z = 30.70},
    BlipSprite = 60,
    BlipColour = 29,
    BlipScale = 1.0,
    NomDuBlip = "LSPD",
    
    -- Config charPicture des notifications

    PictureNotification = "CHAR_ABIGAIL",

    -- Discord Webhook
    DiscordWebHook = true, -- mettre en true si vous voulez recevoir des messages discord , penser a mettre les liens des webhooks
    DiscordWebHookLienPriseService = "https://discordapp.com/api/webhooks/904732233053659136/y97QMxbJvLJQ55FkYMA8mRkb8YykURoXeIdp5A32qBliAw4QkVBqan_3hvFuIC8WaFfy",
    DiscordWebHookLienQuitterService = "https://discordapp.com/api/webhooks/904732233053659136/y97QMxbJvLJQ55FkYMA8mRkb8YykURoXeIdp5A32qBliAw4QkVBqan_3hvFuIC8WaFfy",

    DiscordWebHookLienSpawnVehicule ="https://discordapp.com/api/webhooks/904732233053659136/y97QMxbJvLJQ55FkYMA8mRkb8YykURoXeIdp5A32qBliAw4QkVBqan_3hvFuIC8WaFfy",
    DiscordWebHookLienRetourVehicule="https://discordapp.com/api/webhooks/904732233053659136/y97QMxbJvLJQ55FkYMA8mRkb8YykURoXeIdp5A32qBliAw4QkVBqan_3hvFuIC8WaFfy",

    DiscordWebHookLienPriseArmes ="https://discordapp.com/api/webhooks/904732233053659136/y97QMxbJvLJQ55FkYMA8mRkb8YykURoXeIdp5A32qBliAw4QkVBqan_3hvFuIC8WaFfy",
    DiscordWebHookLienRetourArmes="https://discordapp.com/api/webhooks/904732233053659136/y97QMxbJvLJQ55FkYMA8mRkb8YykURoXeIdp5A32qBliAw4QkVBqan_3hvFuIC8WaFfy",

    DiscordWebHookLienActionPatron="https://discordapp.com/api/webhooks/904732233053659136/y97QMxbJvLJQ55FkYMA8mRkb8YykURoXeIdp5A32qBliAw4QkVBqan_3hvFuIC8WaFfy",

    DiscordWebHookLienSaisies="https://discordapp.com/api/webhooks/904732233053659136/y97QMxbJvLJQ55FkYMA8mRkb8YykURoXeIdp5A32qBliAw4QkVBqan_3hvFuIC8WaFfy",
    -- Garage LSPD

    -- Coordonnes ouverture du menu/ped
    CoordonnesGarageLSPD = {x=441.37, y=-974.70, z=25.70},
    GarageLSPDPed = {x=441.37, y=-974.70, z=25.70, heading=179.49, model = "s_m_y_cop_01"},

    -- Config des véhicules disponbiles dans le menu
    -- model : modèle du véhicule , ex : adder,police,police2, etc...
    -- nom : le nom qui est affiché dans le menu, ex : Adder,Dodge de la police,Moto de police, etc...
    -- gradeMin : grade minimum pour accéder au véhicule ( de 0 à 5 )
    VoitureGarageLSPD = {
        {nom = "Dodge Challenger", model ="polcharger18", gradeMin =0},
        {nom = "Jeep Durango", model ="poldurango", gradeMin =1},
        {nom = "Dodge RAM", model ="polsilverado19", gradeMin =2},

    },

    MotoGarageLSPD = {
        {model = "Moto cross", nom ="polcross", gradeMin =1},
    },

    -- Coordonnes ouverture du menu/ped
    CoordonnesGarageHelicoLSPD = {x=463.74, y=-982.18, z=43.69},
    GarageHelicoLSPDPed = {x=463.74, y=-982.18, z=43.69, heading=90.26, model = "s_m_y_cop_01"},

    HelicoGarageLSPD = {
        {model = "polheli",nom="Hélicoptère",gradeMin=3},
    },

    -- Coordonnes de spawn du véhicules
    CoordonnesVehiculeSpawn = {x=449.36, y=-981.50, z=43.69, heading=3.21},

    -- Afficher le menu des extras lorsque l'on spawn un véhicule
    ExtraMenu = false,

    -- Coordonnes ouverture du menu/ped
    CoordonnesArmurerieLSPD = {x=480.422, y=-996.6329, z=30.67834},
    ArmurerieLSPDPed = {x=480.422, y=-996.6329, z=30.67834,heading=90.0,model="s_m_y_cop_01"},

    -- Config des armes disponbiles dans le menu
    -- model : modèle de l'arme , ex : weapon_assaultrifle,weapon_carabinerifle,weapon_rpg, etc...
    -- nom : le nom qui est affiché dans le menu, ex : Fusil d'assault,Carabine,Lance roquette, etc...
    -- gradeMin : grade minimum pour accéder aux armes ( de 0 à 5 )
    ArmesArmurerieLSPD = {
        {model="weapon_nightstick",nom="Matraque",gradeMin=0},
        {model="weapon_flashlight",nom="Lampe torche",gradeMin=0},
        {model="weapon_combatpistol",nom="Pisolet de combat",gradeMin=1},
        {model="weapon_smg",nom="SMG",gradeMin=2},
        {model="weapon_pumpshotgun",nom="Fusil à pompe",gradeMin=4},
        {model="weapon_carbinerifle",nom="Carabine",gradeMin=3},
    },
    -- Skin du gillet par balle
    GilletParBalleModel = {
        male = {
			bproof_1 = 2,  bproof_2 = 0
		},
		female = {
			bproof_1 = 2,  bproof_2 = 0
		}
    },

    -- Coordonnes ouverture du menu
    CoordonnesSaisieLSPD = {x=451.7538, y=-999.033, z=30.67834},

    -- Coordonnes ouverture du menu
    CoordonnesPatronLSPD = {x=460.7209, y=-985.556, z=30.71204},

    -- TODO : Vestiaire
    CoordonnesVetementLSPD = {x=462.844, y=-996.5011, z=30.67834},
    VetementLSPD = {
        recruit = {
            male = {
                tshirt_1 = 154,  tshirt_2 = 0, -- Numéro T-Shirt
                torso_1 = 55,   torso_2 = 0, -- Numéro Torse
                decals_1 = 0,   decals_2 = 0, -- Numéro Emblemes
                arms = 19,                      -- Numéro Bras
                pants_1 = 35,   pants_2 = 0, -- Numéro Pantalon
                shoes_1 = 24,   shoes_2 = 0, -- Numéro Chaussure
                helmet_1 = -1,  helmet_2 = 0, -- Numéro Casque
                chain_1 = 8,    chain_2 = 0, -- Numéro Chaînes
                ears_1 = 0,     ears_2 = 0 -- Numéro Accessoires Oreilles
            },
            female = {
                tshirt_1 = 154,  tshirt_2 = 0,
                torso_1 = 55,   torso_2 = 0,
                decals_1 = 0,   decals_2 = 0,
                arms = 19,
                pants_1 = 35,   pants_2 = 0,
                shoes_1 = 24,   shoes_2 = 0,
                helmet_1 = -1,  helmet_2 = 0,
                chain_1 = 8,    chain_2 = 0,
                ears_1 = 2,     ears_2 = 0
            }
        },


        officer = {
            male = {
                tshirt_1 = 154,  tshirt_2 = 0,
                torso_1 = 193,   torso_2 = 2,
                decals_1 = 0,   decals_2 = 0,
                arms = 20,
                pants_1 = 35,   pants_2 = 0,
                shoes_1 = 24,   shoes_2 = 0,
                helmet_1 = -1,  helmet_2 = 0,
                chain_1 = 8,    chain_2 = 0,
                ears_1 = 0,     ears_2 = 0
            },
            female = {
                tshirt_1 = 154,  tshirt_2 = 0,
                torso_1 = 193,   torso_2 = 2,
                decals_1 = 0,   decals_2 = 0,
                arms = 20,
                pants_1 = 35,   pants_2 = 0,
                shoes_1 = 24,   shoes_2 = 0,
                helmet_1 = -1,  helmet_2 = 0,
                chain_1 = 8,    chain_2 = 0,
                ears_1 = 2,     ears_2 = 0
            }
        },

        sergeant = {
            male = {
                tshirt_1 = 154,  tshirt_2 = 0,
                torso_1 = 193,   torso_2 = 0,
                decals_1 = 0,   decals_2 = 0,
                arms = 20,
                pants_1 = 35,   pants_2 = 0,
                shoes_1 = 24,   shoes_2 = 0,
                helmet_1 = -1,  helmet_2 = 0,
                chain_1 = 8,    chain_2 = 0,
                ears_1 = 0,     ears_2 = 0
            },
            female = {
                tshirt_1 = 154,  tshirt_2 = 0,
                torso_1 = 193,   torso_2 = 2,
                decals_1 = 0,   decals_2 = 0,
                arms = 20,
                pants_1 = 35,   pants_2 = 0,
                shoes_1 = 24,   shoes_2 = 0,
                helmet_1 = -1,  helmet_2 = 0,
                chain_1 = 8,    chain_2 = 0,
                ears_1 = 2,     ears_2 = 0
            }
        },


        lieutenant = {
            male = {
                tshirt_1 = 154,  tshirt_2 = 0,
                torso_1 = 13,   torso_2 = 0,
                decals_1 = 0,   decals_2 = 0,
                arms = 26,
                pants_1 = 35,   pants_2 = 0,
                shoes_1 = 24,   shoes_2 = 0,
                helmet_1 = -1,  helmet_2 = 0,
                chain_1 = 8,    chain_2 = 0,
                ears_1 = 0,     ears_2 = 0
            },
            female = {
                tshirt_1 = 154,  tshirt_2 = 0,
                torso_1 = 13,   torso_2 = 0,
                decals_1 = 0,   decals_2 = 0,
                arms = 26,
                pants_1 = 35,   pants_2 = 0,
                shoes_1 = 24,   shoes_2 = 0,
                helmet_1 = -1,  helmet_2 = 0,
                chain_1 = 8,    chain_2 = 0,
                ears_1 = 2,     ears_2 = 0
            }
        },

        capitaine = {
            male = {
                tshirt_1 = 154,  tshirt_2 = 0,
                torso_1 = 139,   torso_2 = 3,
                decals_1 = 0,   decals_2 = 0,
                arms = 24,
                pants_1 = 35,   pants_2 = 0,
                shoes_1 = 24,   shoes_2 = 0,
                helmet_1 = -1,  helmet_2 = 0,
                chain_1 = 8,    chain_2 = 0,
                ears_1 = 0,     ears_2 = 0
            },
            female = {
                tshirt_1 = 154,  tshirt_2 = 0,
                torso_1 = 139,   torso_2 = 3,
                decals_1 = 0,   decals_2 = 0,
                arms = 24,
                pants_1 = 35,   pants_2 = 0,
                shoes_1 = 24,   shoes_2 = 0,
                helmet_1 = -1,  helmet_2 = 0,
                chain_1 = 8,    chain_2 = 0,
                ears_1 = 2,     ears_2 = 0
            }
        },

        boss = {
            male = {
                tshirt_1 = 154,  tshirt_2 = 0,
                torso_1 = 139,   torso_2 = 3,
                decals_1 = 0,   decals_2 = 0,
                arms = 24,
                pants_1 = 35,   pants_2 = 0,
                shoes_1 = 24,   shoes_2 = 0,
                helmet_1 = -1,  helmet_2 = 0,
                chain_1 = 8,    chain_2 = 0,
                ears_1 = 0,     ears_2 = 0
            },
            female = {
                tshirt_1 = 154,  tshirt_2 = 0,
                torso_1 = 139,   torso_2 = 3,
                decals_1 = 0,   decals_2 = 0,
                arms = 24,
                pants_1 = 35,   pants_2 = 0,
                shoes_1 = 24,   shoes_2 = 0,
                helmet_1 = -1,  helmet_2 = 0,
                chain_1 = 8,    chain_2 = 0,
                ears_1 = 2,     ears_2 = 0
            }
        },
    }
}