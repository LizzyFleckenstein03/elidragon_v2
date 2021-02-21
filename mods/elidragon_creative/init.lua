local plot = elidragon.plot

plot.config = {
	gap = 32,
	road_width = 8,
	mapgen = {
		min_y = 9,
		max_y = 9,
		c_border = minetest.get_content_id("mcl_stairs:slab_stonebrick"),
	},
	claiming = {
		enable_autoclaim_command = true,
		max_plots = 5,
	},
}

elidragon.creative = {}
