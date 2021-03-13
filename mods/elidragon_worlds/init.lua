local descriptions = {}

local current_world = elidragon.WORLD
for _, world in ipairs(elidragon.WORLDS) do
	if world ~= current_world then
		local desc = world:sub(1, 1):upper() .. world:sub(2)
		descriptions[world] = desc

		minetest.register_chatcommand(world, {
			description = "Join " .. desc,
			func = function(name)
				multiserver.redirect(name, world)
			end
		})
	end
end

multiserver.register_on_redirect_done(function(name, world, success)
	if not success then
		minetest.chat_send_player(name, minetest.colorize(mcl_colors.RED, descriptions[world] .. " is down."))
	end
end)

elidragon.worlds = {}
