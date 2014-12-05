--[[
  mktray.lua - custom tray generator for pick&place machines
  URL: https://github.com/znuh/mktray
 
  Copyright (C) 2014 Benedikt Heinz, <hunz@mailbox.org>
 
  This program is free software; you can redistribute it and/or
  modify it under the terms of the GNU General Public License as
  published by the Free Software Foundation; either version 2 of
  the License, or (at your option) any later version.
 
  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details. ]]--

require "tray_config"
require "packages"
require "tray"

expand_packages()

local mytray = new_tray(arg[1])
mytray:make_tray()
mytray:save(arg[1])
