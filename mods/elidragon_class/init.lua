local function class(classdef)
	local metatable = {
		__index = classdef,
	}

	return function (...)
		local object = setmetatable({}, metatable)
		if object.constructor then
			object:constructor(...)
		end
		return object
	end
end

elidragon.class = class
