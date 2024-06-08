Config = {
    Open = {
        command = {
            enable = true,
            name = "mdt",
        },
        item = {
            enable = false,
            name = "mdt",
        }
    },
    MoneySymbol = "$", -- this is for the money symbol
    Framework = "oldesx", --esx, oldesx, qb, newqb
    SQLScript = "oxmysql", --ghmattimysql, mysql-async, oxmysql
    discordWebhook = "WEBHOOK_HERE", -- this is for uploading photos to discord
    DefaultAvatar = "https://cdn.discordapp.com/attachments/1094660235479744552/1130093407583338607/eyyyyyyyoooooohabeeeeeer.png",
    DefaultVehicleAvatar = "https://www.shutterstock.com/image-vector/white-cute-car-icon-heading-600w-568159381.jpg",
    Prefix = "!", -- this is for the prefix of blips you can set it as "" if you dont want one
    CrimeTags = {
        [1] = {label = "None"},
        [2] = {label = "Suspect"},
        [3] = {label = "Murderer"},
        [4] = {label = "Smuggler"},
        [5] = {label = "Robber"},
    },
    Permissions = {
        addMessage = {'Chief', 'Officer'}, --Only these players can add message.
        addFines = {'Chief', 'Officer'}, -- Only these players can add fines.
        editFines = {'Chief', 'Officer'}, -- Only these players can edit fines.  
    },
    Department = {
        image = 'https://mcrpfivem.com/uploads/monthly_2021_03/20210317182554_1.jpg.6944611b4b8b1219b363b8a4b31b7d64.jpg',
        name = 'LSPD',
        totalBans = 0,
        totalPersonal = ('%s/16'),
        location = '03506 Grover Ranch East Marlee 83511-7455',
        description = 'Default Description',
    },
    Jobs = {
        ["police"] = {
            ableToUse = true,
            mapColor = "blue" -- only blue, orange, red, purple
        },
        ["sheriff"] = {
            ableToUse = true,
            mapColor = "orange"
        },
        ["ambulance"] = {
            ableToUse = false,
            mapColor = "red"
        },
    },
    PanicTypes = {
        ["safe"] = {
            blipData = {
                sprite = 1,
                color = 18,
                scale = 1.5,
                blipDuration = 30, -- seconds
            }
        },
        ["normal"] = {
            blipData = {
                sprite = 1,
                color = 5,
                scale = 1.7,
                blipDuration = 45, -- seconds
            }
            
        },
        ["emergency"] = {
            blipData = {
                sprite = 1,
                color = 1,
                scale = 1.9,
                blipDuration = 60, -- seconds
            }
        }
    },
    LicenseTypes = {
        ["dmv"] = true
    },
    Cameras = {
        {
            id = 1,
            title = "Police Station",
            image = "https://cdn.discordapp.com/attachments/1094660235479744552/1130093407583338607/eyyyyyyyoooooohabeeeeeer.png",
            coords = vector3(434.26, -978.0, 33.04),
            rotation = vector3(0.0, 0.0, 120.0),
            fov = 60.0,
            canRotate = true,
            canMove = true,
            canZoom = true,
        },
        {
            id = 2,
            title = "Airport",
            image = "https://cdn.discordapp.com/attachments/1094660235479744552/1130093407583338607/eyyyyyyyoooooohabeeeeeer.png",
            coords = vector3(-2489.92, 3067.633, 32.809),
            rotation = vector3(0.0, 0.0, 120.0),
            fov = 60.0,
            canRotate = true,
            canMove = true,
            canZoom = true,
        },
    },
    JobGrades = {
        [1] = "Officer",
        [2] = "Sergeant"
    },
    Dispatches = {
        StealVehicle = true,
        GunShot = true,
    }
}

Config.UsersTable = (Config.Framework == "esx" or Config.Framework == "oldesx") and "users" or "players"
Config.VehiclesTable = (Config.Framework == "esx" or Config.Framework == "oldesx") and "owned_vehicles" or "owned_vehicles"

for i = 1, #Config.CrimeTags do
    Config.CrimeTags[i].value = tostring(i)
end

Config.Locales = Locales