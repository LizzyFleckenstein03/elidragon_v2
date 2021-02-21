local plot = elidragon.plot

plot.config = {
	gap = 32,
	road_with = 8,
	mapgen = {
		enable = true,
		min_y = 9,
		max_y = 9,
		c_border = minetest.get_content_id("mcl_core:stonebrickcarved"),
	},
	claiming = {
		enable_autoclaim_command = true,
		max_plots = 5,
	},
}

elidragon.creative = {}
