
-- all units in mm
tray_config = {
	w = 315/2,
	h = 135,
	-- fill currently only supported for eagle BRDs
	mode = 'outline', -- outline or fill
	--mode = 'fill', -- outline or fill
	expand = 0.1,	-- increase cavity sizes by this
	x_spacing = 2.5,	-- x spacing between cavities
	y_spacing = 2.5,	-- y spacing between cavities
	notches = 0.0,	-- notches for tweezers
	packages = {
		-- NB
		"TSSOP8", "TSSOP14", "QFN64", "QFN36_6x6", "MSOP10", "MLF32", 
		"54CSP", "TFBGA180", "FBGA-84", "DFN-6(3x3)", "DFN-12(3x3)", 
		"CS324", --"SO8", "SO8", 
		--"SOT-363", "SOT23-5L", "SOT23-5", "SOT23",
		-- IO
		"MSOP08", --"DO214", 
		-- GB
		--"TSOPII",
	}
}
