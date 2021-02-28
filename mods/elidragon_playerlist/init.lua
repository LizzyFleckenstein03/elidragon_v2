local ranks = elidragon.ranks

local player_huds = {}

controls.register_on_press(function(player, key)
	if key == "sneak" then
		local name = player:get_player_name()
		local huds = {}
		for i, n, _, rank, rank_def in ranks.iterate_players() do
			table.insert(huds, player:hud_add({
				hud_elem_type = "text",
				position = {x = 0.5, y = 0},
				offset = {x = 20, y = 53 + (i - 1) * 18},
				text = n,
				alignment = {x = 1, y = 1},
				scale = {x = 100, y = 100},
				number = tonumber(rank_def.color, 16),
			}))
			table.insert(huds, player:hud_add({
				hud_elem_type = "image",
				position = {x = 0.5, y = 0},
				offset = {x = 0, y = 50 + (i - 1) * 18},
				text = "server_ping_" .. math.max(1, math.ceil(4 - minetest.get_player_information(n).avg_rtt * 4)) .. ".png",
				alignment = {x = -1, y = 1},
				scale = {x = 1.5, y = 1.5},
				number = 0xFFFFFF,
			}))
		end
		player_huds[name] = huds
	end
end)

controls.register_on_release(function(player, key)
	if key == "sneak" and player then
		for _, id in ipairs(player_huds[player:get_player_name()] or {}) do
			player:hud_remove(id)
		end
	end
end)

elidragon.playerlist = {}
