fx_version "adamant"
games { "rdr3" }

rdr3_warning 'I acknowledge this is a prerelease build of RedM and I am aware my resources *will* become incompatible once RedM ships.'

description 'delete prop'
version '1.0'

client_script {
    'client.lua',
    'config.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/click.mp3',
    'html/close.mp3'
}
