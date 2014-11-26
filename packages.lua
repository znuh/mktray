
-- ensure that pin 1 is in bottom left corner

packages = {
	["DO214"]		= { 5.6, 2.9},
	["TSSOP8"] 		= { 3.0, 6.4 }, -- rotated
	["TSSOP14"] 	= { 6.4, 5.1}, -- P1 ok
	["TSSOP16"] 	= { 6.4, 5.1}, -- P1 ok
	["QFN64"] 		= { 9.0, 9.0}, -- P1 ok
	["QFN36_6x6"]	= { 6.0, 6.0}, -- P1 ok
	["MSOP08"]		= { 3.1, 5.1 }, -- rotated
	["MSOP10"] 		= { 3.0, 4.9 }, -- rotated
	["MLF32"] 		= { 5.0, 5.0}, -- P1 ok
	["54CSP"] 		= { 8.0, 8.0}, -- P1 ok
	["TFBGA180"] 	= { 12.0, 12.0}, -- P1 ok
	["FBGA-84"] 	= { 12.5, 8.0}, -- P1 ok
	["DFN-6(3x3)"] 	= { 3.0, 3.0}, -- P1 ok
	["DFN-12(3x3)"] = { 3.0, 3.0}, -- P1 ok
	["CS324"] 		= { 15.0, 15.0}, -- P1 ok
	["SO8"] 		= { 4.9, 6.0}, -- rotated
	["SOT-363"] 	= { 2.1, 2.1, notch = false},
	["SOT23-5L"] 	= { 2.9, 2.8, notch = false},
	["SOT23-5"] 	= { 2.9, 2.8, notch = false},
	["SOT23"] 		= { 2.9, 2.4, notch = false}, 
	["TSOPII"]		= { 22.3, 11.8}, -- P1 ok
}
