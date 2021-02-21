local plot = elidragon.plot

plot.config = {
	gap = 1000,
	road_width = 100,
	--[[min_y = 2000,
	max_y = 31000,]]--
	mapgen = {
		min_y = 1000,
		max_y = 31000,
		void_layer = {
			min_y = 1000,
			max_y = 2000,
			c_void = minetest.get_content_id("mcl_core:void"),
		},
		c_border = minetest.get_content_id("mcl_core:barrier"),	-- ToDo: make world border
	},
	--[[claiming = {
		auto_allocation = true,
		on_claim = function() -- create island and move there
		end
	},]]--
}

elidragon.skyblock = {}
