mktray
======

custom tray generator for pick&amp;place machines
* install LuaXML from http://viremo.eludi.net/LuaXML/ or via luarocks
* modify tray_config.lua for your custom tray
* add missing package definitions in packages.lua
* run *lua mktray.lua mytray.brd* to generate a eagle board 
* OR: run *lua mktray.lua mytray.svg* to generate a SVG file
