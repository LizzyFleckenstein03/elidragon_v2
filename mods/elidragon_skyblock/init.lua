local plot, plotmg = elidragon.plot, elidragon.plotmg

plot.config = {
	gap = 1000,
	road_width = 100,
	min_y = 2000,
	max_y = 31000,
	auto_allocation = true,
	on_claim = function() -- create island and move there
	end
}

plotmg.config = {
	min_y = 1000,
	max_y = 31000,
	c_border = minetest.get_content_id("mcl_core:barrier"),
}

elidragon.skyblock = {}
