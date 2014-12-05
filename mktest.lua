--[[
  mktest.lua - custom tray generator for pick&place machines
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

local base_w, base_h
local expand

if #arg ~= 4 then
	print("usage: "..arg[0].." <output file> <package name> <lower bound> <upper bound>")
	print("example: "..arg[0].." test.brd QFN64 -0.5 0.5")
	print("will generate QFN64 packages with expand from -0.5 up to +0.5")
	return
end

local mytray = new_tray(arg[1])
local pkg = arg[2]
local exp_min = tonumber(arg[3])
local exp_max = tonumber(arg[4])

assert(packages[pkg], "can't find package "..arg[2])
assert(type(exp_min) == "number", "lower bound for expand invalid")
assert(type(exp_max) == "number", "upper bound for expand invalid")

-- use two rows if one isn't sufficient
tray_config.packages = { pkg, pkg }

base_w, base_h = packages[pkg][1], packages[pkg][2]
expand = exp_min

-- save original draw_package
mytray.draw_package_ = mytray.draw_package

-- new draw_package function: call original one after expanding package
function mytray:draw_package(pkg, x, y)
	if expand > exp_max then return end
	pkg[1] = base_w + expand
	pkg[2] = base_h + expand
	self:draw_package_(pkg, x, y)
	expand = expand + 0.1
end

mytray:make_tray()
mytray:save(arg[1])
