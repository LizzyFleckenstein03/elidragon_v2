local schems = {}
schems.loaded = {}

function schems.get(name)
	return assert(schems.loaded[name])
end

function schems.load(name)
	local file = assert(io.open(minetest.get_modpath(minetest.get_current_modname()) .. "/schems/" .. name .. ".we", "r"))
	schems.loaded[name] = file:read()
	file:close()
end

function schems.add(pos, name)
	local schem = schems.get(name)
	worldedit.deserialize(pos, schem)
end

function schems.flip(name)
	local schem = schems.get(name)
	schem = schem:gsub("%[\"x\"%] =", "%[\"t\"%] =")
	schem = schem:gsub("%[\"z\"%] =", "%[\"x\"%] =")
	schem = schem:gsub("%[\"t\"%] =", "%[\"z\"%] =")
	schems.loaded[name .. "_flipped"] = schem
end

elidragon.schems = schems
