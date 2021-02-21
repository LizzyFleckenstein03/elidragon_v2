local plot = {}

minetest.register_on_generated(function(minp, maxp)
	local config = assert(plot.config)
	
	local mgconfig = config.mapgen
	
	if not mgconfig then
		return
	end

	local min_y, max_y = mgconfig.min_y, mgconfig.max_y

	if maxp.y < min_y or minp.y > max_y then
		return
	end

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local data = vm:get_data()
	local area = VoxelArea:new({MinEdge = emin, MaxEdge = emax})

	local void_layer = mgconfig.void_layer

	if void_layer then
		for idx in area:iter(minp.x, math.max(minp.y, void_layer.min_y), minp.z, maxp.x, math.min(maxp.y, void_layer.max_y), mapx.z) do
			data[idx] = void_layer.c_void
		end
	end

	local function do_multiples(low, high, base, add, func)
		for p = math.ceil(low / base), math.floor(high / base) do
			func(p * base + add)
		end
	end

	local function do_borders(low, high, base, road, func)
		local r = road / 2
		do_multiples(low - r, high - r, base,  r, func)
		do_multiples(low + r, high + r, base, -r, func)
	end

	do_borders(minp.x, maxp.x, config.gap, config.road_width, function(x)
		for idx in area:iter(x, math.max(minp.y, min_y), minp.z, x, math.min(maxp.y, max_y), maxp.z) do
			data[idx] = mgconfig.c_border
		end
	end)

	do_borders(minp.z, maxp.z, config.gap, config.road_width, function(z)
		for idx in area:iter(minp.x, math.max(minp.y, min_y), z, maxp.x, math.min(maxp.y, max_y), z) do
			data[idx] = mgconfig.c_border
		end
	end)

	vm:set_data(data)
	vm:calc_lighting()
	vm:update_liquids()
	vm:write_to_map()
end)

elidragon.plot = plot
