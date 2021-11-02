zbConfig = {}

zbConfig = {
    -- Config du blip
    BlipCoordonnes = {x = 423.13, y = -978.85, z = 30.70},
    BlipSprite = 60,
    BlipColour = 29,
    BlipScale = 0.65,
    NomDuBlip = "LSPD",

    -- Discord Webhook
    DiscordWebHook = false, -- mettre en true si vous voulez recevoir des messages discord , penser a mettre les liens des webhooks
    DiscordWebHookLienPriseService = "https://discordapp.com/api/webhooks/904732233053659136/y97QMxbJvLJQ55FkYMA8mRkb8YykURoXeIdp5A32qBliAw4QkVBqan_3hvFuIC8WaFfy",
    DiscordWebHookLienQuitterService = "https://discordapp.com/api/webhooks/904732233053659136/y97QMxbJvLJQ55FkYMA8mRkb8YykURoXeIdp5A32qBliAw4QkVBqan_3hvFuIC8WaFfy",

    -- Garage LSPD

    -- Coordonnes ouverture du menu/ped
    CoordonnesGarageLSPD = {x=447.7582, y=-1028.374, z=28.62268},
    GarageLSPDPed = {x=447.7582, y=-1028.374, z=28.62268, heading = 28.8, model = "s_m_y_cop_01"},

    -- Config des véhicules disponbiles dans le menu
    -- model : modèle du véhicule , ex : adder,police,police2, etc...
    -- nom : le nom qui est affiché dans le menu, ex : Adder,Dodge de la police,Moto de police, etc...
    -- gradeMin : grade minimum pour accéder au véhicule ( de 0 à 5 )
    VehiculesGarageLSPD = {
        {model = "valor3", nom ="Test", gradeMin =0},
        {model = "police2", nom ="Test2", gradeMin =4},
        {model = "policeb", nom ="Test moto", gradeMin =0},
    },
    -- Coordonnes de spawn du véhicule
    CoordonnesVehiculeSpawn = {x=447.9956, y=-1022.334, z=28.48792,heading=90.7086},

    -- Afficher le menu des extras lorsque l'on spawn un véhicule
    ExtraMenu = true,

    CoordonnesArmurerieLSPD = {x=480.422, y=-996.6329, z=30.67834},
    ArmurerieLSPDPed = {x=480.422, y=-996.6329, z=30.67834,heading=90.0,model="s_m_y_cop_01"},

    ArmesArmurerieLSPD = {
        {model="weapon_combatpistol",nom="Pisolet de combat",grade=1},
        {model="weapon_smg",nom="SMG",grade=3},
    },
}