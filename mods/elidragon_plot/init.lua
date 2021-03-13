local plot = {
	loaded = {}
}

local loaded = plot.loaded
local old_is_protected = minetest.is_protected

function minetest.is_protected(pos, name)
	return old_is_protected(pos, name)
end

function plot.get(pos)
end

elidragon.plot = plot
