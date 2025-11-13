fx_version 'cerulean'
game 'gta5'

name 'legacy-lib'
author 'Legacy Scripts'
description 'Central compatibility + theme/branding library for Legacy resources'
version '1.1.0'

shared_scripts {
  'config.lua',
  '@ox_lib/init.lua'
}

server_scripts {
  'server/init.lua',
  'server/*.lua',
}

client_scripts {
  'client/init.lua',
  'client/*.lua',
}

files {
  'logo.png'
}

lua54 'yes'
