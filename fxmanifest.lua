fx_version 'adamant'

author 'zubulmuk92'

description 'Script job LSPD , 0.01ms / RageUI V2'

game 'gta5'

shared_script {
    "zbConfig.lua"
}

client_scripts {
    "src/RMenu.lua",
    "src/menu/RageUI.lua",
    "src/menu/Menu.lua",
    "src/menu/MenuController.lua",
    "src/components/*.lua",
    "src/menu/elements/*.lua",
    "src/menu/items/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/panels/*.lua",
    "src/menu/windows/*.lua"
}

client_scripts {
    "cl_main.lua",
    "cl_commandant.lua",
    "cl_outils.lua",
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    "srv_main.lua",
    "srv_outils.lua"
}

-- MDT

shared_scripts {
	'mdt/locale.lua',
	'mdt/config.lua'
}

client_script "mdt/client/**/*"
server_script{
	"mdt/server/utils.lua",
	"mdt/server/*.lua"
}

ui_page 'mdt/web/build/index.html'
files {
	'mdt/web/build/index.html',
	'mdt/web/build/**/*',
}

escrow_ignore {
	"mdt/config.lua",
	"mdt/locale.lua",
	"mdt/client/**/*",
	"mdt/server/**/*"
}
dependency '/assetpacks'