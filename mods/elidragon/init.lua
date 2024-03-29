local proxy = {
	WORLDS = {"lobby", "creative", "survival", "skyblock"},
	WORLD = minetest.settings:get("world")
}

elidragon = setmetatable({}, {
	__index = function(t, k)
		return proxy[k]
	end,
	__newindex = function(t, k, v)
		assert(not proxy[k])
		proxy[k] = v
	end,
})
