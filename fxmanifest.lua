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

-- fFouille by Fellow 

client_scripts {
    "fFouille/cl_fouille.lua",
}

server_scripts {
    "fFouille/srv_fouille.lua",
}

-- Livery Menu UI

ui_page {
	'html/index.html',
}

files {
	'html/fonts/*.woff',
	'html/fonts/*.woff2',
	'html/fonts/*.ttf',
	'html/css/*.css',
	'html/js/*.js',
	'html/index.html',
	"html/fontawesome/webfonts/*.ttf",
	"html/fontawesome/css/*.css",
	"html/img/*.png",
}