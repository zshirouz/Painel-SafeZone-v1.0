fx_version 'cerulean'
game 'gta5'

author 'ShirouZ'
description 'Sistema de Safezone Customizado'

dependency 'vrp'

shared_scripts {
    "@vrp/lib/utils.lua"
}

shared_scripts {
    'config.lua'
}

client_scripts {
    "client.lua"
}

server_scripts {
    "server.lua"
}

ui_page "html/index.html"

files {
    "html/index.html",
    "html/style.css",
    "safezones_custom.json"
}
