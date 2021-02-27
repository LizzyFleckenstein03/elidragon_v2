local db = elidragon.db

local playerdb = {
	initial_data = {},
	players = {},
}

local players = playerdb.players
local env = assert(minetest.request_insecure_environment())

minetest.register_on_joinplayer(function (player)
	local name = player:get_player_name()
	if name ~= "rpc" then
		players[name] = db(name, playerdb.initial_data, "players", env)
	end
end)

minetest.register_on_leaveplayer(function (player)
	local name = player:get_player_name()
	if name ~= "rpc" then
		players[name]:close()
		players[name] = nil
	end
end)

elidragon.playerdb = playerdb
