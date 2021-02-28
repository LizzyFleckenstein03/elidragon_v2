local plot, schems = elidragon.plot, elidragon.schems

local plotmg = {}

minetest.register_on_generated(function(minp, maxp)
	collectgarbage()

	local config = assert(plot.config)
	local mgconfig = assert(plotmg.config)

	local min_y, max_y = mgconfig.min_y, mgconfig.max_y

	if maxp.y < min_y or minp.y > max_y then
		return
	end

	local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
	local data = vm:get_data()
	local area = VoxelArea:new({MinEdge = emin, MaxEdge = emax})

	local function do_multiples(low, high, base, add, func)
		for p = math.ceil(low / base), math.floor(high / base) do
			func(p * base + add)
		end
	end

	local function do_borders(low, high, base, road, func)
		do_multiples(low - road, high - road, base,  road, func)
		do_multiples(low + road, high + road, base, -road, func)
	end

	min_y, max_y = math.max(minp.y, min_y), math.min(maxp.y, max_y)

	local gap, road_width = config.gap, config.road_width
	local road_width_half = road_width / 2

	do_borders(minp.x, maxp.x, gap, road_width_half, function(x)
		do_multiples(minp.z - gap + road_width_half, maxp.z - road_width_half, gap, road_width_half, function(start_z)
			for idx in area:iter(x, min_y, math.max(minp.z, start_z), x, max_y, math.min(maxp.z, start_z + gap - road_width)) do
				data[idx] = mgconfig.c_border
			end
		end)
	end)

	do_borders(minp.z, maxp.z, gap, road_width_half, function(z)
		do_multiples(minp.x - gap + road_width_half, maxp.x - road_width_half, gap, road_width_half, function(start_x)
			for idx in area:iter(math.max(minp.x, start_x), min_y, z, math.min(maxp.x, start_x + gap - road_width), max_y, z) do
				data[idx] = mgconfig.c_border
			end
		end)
	end)

	vm:set_data(data)
	vm:calc_lighting()
	vm:update_liquids()
	vm:write_to_map()

	local road_schem = mgconfig.road_schem

	if road_schem and min_y == mgconfig.min_y then
		do_multiples(minp.x, maxp.x, gap, 0, function(x)
			do_multiples(minp.z, maxp.z, gap, 0, function(z)
				schems.add(vector.new(x + road_width_half, min_y + mgconfig.road_schem_offset, z - road_width_half + 1), road_schem)
				schems.add(vector.new(x - road_width_half + 1, min_y + mgconfig.road_schem_offset, z + road_width_half), road_schem .. "_flipped")
			end)
		end)
	end
end)

elidragon.plotmg = plotmg
