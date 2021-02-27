local plot = {}

local old_is_protected = minetest.is_protected

function minetest.is_protected(pos, name)
	return old_is_protected(pos, name)
end

elidragon.plot = plot
