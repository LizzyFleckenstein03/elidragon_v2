local plot, plotmg, schems = elidragon.plot, elidragon.plotmg, elidragon.schems

plot.config = {
	gap = 50,
	road_width = 10,
	enable_autoclaim_command = true,
	max_plots_per_player = 5,
}

plotmg.config = {
	min_y = 9,
	max_y = 9,
	c_border = minetest.get_content_id("mcl_stairs:slab_stonebrick"),
	road_schem = "elidragon_creative_road",
	road_schem_offset = -3,
}

schems.load("elidragon_creative_road")
schems.flip("elidragon_creative_road")

elidragon.creative = {}
