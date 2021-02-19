local schems = {}
schems.loaded = {}

function schems.get(name)
	return schems.loaded[name].data
end

function schems.get_raw(name)
	return schems.loaded[name].raw
end

function schems.load(name)
	local schem = {}
	local file = io.open(minetest.get_modpath(minetest.get_current_modname()) .. "/schems/" .. name .. ".we", "r")
	schem.raw = file:read()
	file:seek("set")
	local _, _, contents = file:read("*number", 1, "*all")
	file:close()
	schem.data = minetest.deserialize(contents)
	schems.loaded[name] = schem
end

function schems.check(pos, name)
	local schem = schems.get(name)
	for _, n in ipairs(schem) do
		if minetest.get_node(vector.add(pos, n)).name ~= n.name then
			return false
		end
	end
	return true
end

function schems.remove(pos, name)
	local schem = schems.get(name)
	for _, n in ipairs(schem) do
		minetest.remove_node(vector.add(pos, n))
	end
end

function schems.add_schem(pos, schemname)
	local schem_raw = schems.get_raw(schemname)
	worldedit.deserialize(pos, schem_raw)
end

elidragon.schems = schems
