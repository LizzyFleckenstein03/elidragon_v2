local plot, schems = elidragon.plot, elidragon.schems

plot.config = {
	gap = 50,
	road_width = 10,
	mapgen = {
		min_y = 9,
		max_y = 9,
		c_border = minetest.get_content_id("mcl_stairs:slab_stonebrick"),
		road_schem = "elidragon_creative_road",
		road_schem_offset = -3,
	},
	claiming = {
		enable_autoclaim_command = true,
		max_plots = 5,
	},
}

schems.load("elidragon_creative_road")
schems.flip("elidragon_creative_road")

elidragon.creative = {}
