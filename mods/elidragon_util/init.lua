local util = {}

function util.get_far_node(pos)
	local node = minetest.get_node(pos)
	if node.name ~= "ignore" then
		return node
	end
	minetest.get_voxel_manip():read_from_map(pos, pos)
	return minetest.get_node(pos)
end

function util.find_free_position_near(pos)
	local tries = {
		{x =  1, y =  0, z =  0},
		{x = -1, y =  0, z =  0},
		{x =  0, y =  0, z =  1},
		{x =  0, y =  0, z = -1},
	}
	for _, d in ipairs(tries) do
		local p = vector.add(pos, d)
		if not minetest.registered_nodes[minetest.get_node(p).name].walkable then
			return p, true
		end
	end
	return pos, false
end  

elidragon.util = util
