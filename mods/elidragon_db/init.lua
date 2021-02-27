local class = elidragon.class

local db = {}

local paths = {}
local worldpath = minetest.get_worldpath()

function db:constructor(name, initial_data, dir)
	paths[self] = dir or worldpath .. "/" .. name .. ".json"
	self:load(initial_data or {})
end

function db:load(initial_data)
	local file = io.open(paths[self], "r")
	local data = file and minetest.parse_json(file:read()) or {}
	if file then
		file:close()
	end
	for k, v in pairs(data) do
		self[k] = v
	end
	for k, v in pairs(initial_data) do
		if not rawget(self, k) then
			self[k] = v
		end
	end
end

function db:save()
	local file = assert(io.open(paths[self], "w"))
	file:write(minetest.write_json(self))
	file:close()
end

function db:close()
	self:save()
	paths[self] = nil
end

minetest.register_on_shutdown(function()
	for d in pairs(private) do
		d:save()
	end
end)

elidragon.db = class(db)
