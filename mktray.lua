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

xml = require("LuaXml")
require "tray_config"
require "packages"

-- base class
local base_tray = {}
base_tray.__index = base_tray

setmetatable(base_tray, {
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

-- initialize rectangle function to outline or fill
function base_tray:_init()
	if tray_config.mode == 'outline' then
		self.rect = self.rect_outline
	elseif tray_config.mode == 'fill' then
		self.rect = self.rect_filled
	end
	assert(self.rect, "mode must be outline or fill")
end

--[[ fallback function: rectangle outline w/ 4 lines
	 used by eagle - generates 4 wires
     not used by SVG
     SVG has its own rect_outline which generates a single path
     this makes laser-cutting faster ]]--
function base_tray:rect_outline(x1, y1, x2, y2, layer)
	self:line(x1, y1, x2, y1, layer)
	self:line(x2, y1, x2, y2, layer)
	self:line(x2, y2, x1, y2, layer)
	self:line(x1, y2, x1, y1, layer)
end

-- tray outline
function base_tray:draw_dimension(w,h)
	self:rect_outline(0,0,w,h,20)
end

-- draw a single package w/ or w/o notches
function base_tray:draw_package(pkg, x, y)
	self:rect(x, y, x + pkg[1], y + pkg[2])
	if tray_config.notches and (tray_config.notches > 0) and pkg.notch ~= false then
		self:rect(
			x+(pkg[1]/2)-(tray_config.notches/2), 
			y-tray_config.notches, 
			x+(pkg[1]/2)+(tray_config.notches/2), 
			y)
		self:rect(
			x+(pkg[1]/2)-(tray_config.notches/2), 
			y+pkg[2], 
			x+(pkg[1]/2)+(tray_config.notches/2), 
			y+pkg[2]+tray_config.notches)
	end
end

-- make a single row of identical packages
function base_tray:make_row(y_ofs, pkg)
	for x_ofs = tray_config.x_spacing, 
		tray_config.w - (pkg[1] + tray_config.x_spacing), 
		pkg[1] + tray_config.x_spacing do
		self:draw_package(pkg, x_ofs, y_ofs)
	end
end

-- generates all rows of packages
function base_tray:make_tray()
	local y_ofs = tray_config.y_spacing
	for i=1,#tray_config.packages do
		local pkg_name = tray_config.packages[i]
		local pkg = packages[pkg_name]
		assert(pkg,"package "..pkg_name.." not found")
		if y_ofs + (tray_config.y_spacing * 2) + pkg[2] <= tray_config.h then
			self:make_row(y_ofs, pkg)
		else
			print("couldn't fit package: ",pkg_name)
			--break
		end
		y_ofs = y_ofs + tray_config.y_spacing + pkg[2]
	end
end
-- base end

-- eagle output
eagle_tray = {}
eagle_tray.__index = eagle_tray

setmetatable(eagle_tray, {
  __index = base_tray, -- this is what makes the inheritance work
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function eagle_tray:_init()
  base_tray._init(self) -- call the base class constructor
  -- load template
  self.brd = xml.load("template.brd")
  -- base pointer for new elements
  self.plain = self.brd:find("plain")
end

function eagle_tray:line(x1, y1, x2, y2, layer)
	local l = layer or 46
	table.insert(self.plain, {[0]='wire', x1=x1, y1=y1, x2=x2, y2=y2, layer=l})
end

function eagle_tray:rect_filled(x1, y1, x2, y2)
	table.insert(self.plain, {[0]='rectangle', 
		x1=x1, y1=y1, x2=x2, y2=y2, layer = '46'})
end

function eagle_tray:save(fname)
	self.brd:save(fname)
end
-- eagle end

-- SVG output
svg_tray = {}
svg_tray.__index = svg_tray

setmetatable(svg_tray, {
  __index = base_tray, -- this is what makes the inheritance work
  __call = function (cls, ...)
    local self = setmetatable({}, cls)
    self:_init(...)
    return self
  end,
})

function svg_tray:_init()
  if tray_config.mode ~= 'outline' then
	 print("currently only mode 'outline' supported for SVG")
	 os.exit(23)
  end
  base_tray._init(self) -- call the base class constructor
  -- load template
  self.svg = xml.load("template.svg")
  -- base pointer for new objects
  self.g = self.svg:find("g")
  -- line style
  local linewidth = 0.1
  self.linestyle = "fill:none;stroke:#000000;stroke-width:" .. linewidth
  self.linestyle = self.linestyle .. "mm;stroke-linecap:butt;stroke-linejoin:miter;stroke-opacity:1"
  -- generate path IDs from this counter
  self.pathcnt = 0
  -- set new dimension for SVG
  local root = self.svg:find("svg")
  root.width = tray_config.w
  root.height = tray_config.h
end

function svg_tray:rect_filled(x1, y1, x2, y2)
	assert(false, "SVG:rect_filled not yet implemented")
end

-- this generates a single path of 4 consecutive lines
function svg_tray:rect_outline(x1, y1, x2, y2)
	table.insert(self.g, {[0]='path', 
		d=string.format("m %.1f,%.1f %.1f,0 0,%.1f, %.1f,0 0,%.1f z",x1,y1,x2-x1,y2-y1,x1-x2,y1-y2),
		style=self.linestyle,
		id="path_"..self.pathcnt
		})
		self.pathcnt = self.pathcnt + 1
end

function svg_tray:save(fname)
	self.svg:save(fname)
end
-- SVG end

-- this inflates all packages by the expand value given in the tray config
-- call only once
function expand_packages()
	for i=1,#packages do
		packages[i][1] = packages[i][1] + tray_config.expand
		packages[i][2] = packages[i][2] + tray_config.expand
	end
end

-- "main" starts here

expand_packages()

assert(arg[1],"no filename given")
local mytray
if arg[1]:match(".BRD$") or arg[1]:match(".brd$") then
	mytray = eagle_tray()
elseif arg[1]:match(".SVG$") or arg[1]:match(".svg$") then
	mytray = svg_tray()
end
assert(mytray, "unknown output type")
mytray:draw_dimension(tray_config.w, tray_config.h)
mytray:make_tray()
mytray:save(arg[1])
