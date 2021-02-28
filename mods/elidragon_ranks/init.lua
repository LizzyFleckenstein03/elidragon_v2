local playerdb = elidragon.playerdb

local ranks = {}

local players = playerdb.players
local admin = minetest.settings:get("name")
local server = minetest.settings:get("server_name")
playerdb.initial_data.rank = "player"

function ranks.get(name)
	local rank
	if name == "rpc" then
		rank = "system"
	else
		local playerdata = players[name]
		if playerdata then
			rank = playerdata.rank
		else
			rank = name == admin and "console" or "offline"
		end
	end
	return rank, ranks.defs[rank]
end

function ranks.get_player_name(name, brackets)
	local _, rank_def = ranks.get(name)
	brackets = brackets or {"", ""}
	return minetest.colorize("#" .. rank_def.color, rank_def.tag) .. brackets[1] .. name .. brackets[2]
end

function ranks.reload(player)
	local name = player:get_player_name()
	local rank, rank_def = ranks.get(name)
	player:set_nametag_attributes({text = rank == "system" and "" or ranks.get_player_name(name)})
	minetest.set_player_privs(name, assert(rank_def.privs))
end

function ranks.set(name, rank)
	if name == "rpc" then
		return false, "The rank of the rpc player cannot be changed."
	end
	local rank_def = ranks.defs[rank]
	if not rank_def or rank_def.can_assign == false then
		return false, "Invalid rank."
	end
	local player = minetest.get_player_by_name(name)
	if not player then
		return false, name .. " is not online."
	end
	local playerdata = players[name]
	playerdata.rank = rank
	playerdata:save()
	ranks.reload(player)
end

function ranks.iterate_players(list)
	local players = {}
	for _, player in ipairs(list or minetest.get_connected_players()) do
		local name = player:get_player_name()
		if name ~= "rpc" then
			local rank, rank_def = ranks.get(name)
			table.insert(players, {
				name = name,
				ref = player,
				rank = rank,
				rank_def = rank_def,
				value = rank_def.value
			})
		end
	end
	table.sort(players, function(a, b)
		return a.value > b.value
	end)
	local i = 0
	return function()
		i = i + 1
		local player = players[i]
		if player then
			return i, player.name, player.ref, player.rank, player.rank_def
		end
	end
end

minetest.register_on_joinplayer(ranks.reload)

function minetest.send_join_message(name)
	if name ~= "rpc" then
		minetest.chat_send_all("*** " .. ranks.get_player_name(name) .. " joined " .. server .. ".")
	end
end

function minetest.send_leave_message(name, timed_out)
	if name ~= "rpc" then
		minetest.chat_send_all("*** " .. ranks.get_player_name(name) .. " left " .. server .. (timed_out and " (timed out)" or "") .. ".")
	end
end

minetest.register_on_chat_message(function(name, message)
	if not minetest.check_player_privs(name, {shout = true}) then
		return
	end
	minetest.chat_send_all(ranks.get_player_name(name, {"<", ">"}) .. " " .. message)
	return true
end)

minetest.register_chatcommand("rank", {
	params = "<player> <rank>",
	description = "Set a player's rank",
	privs = {privs = true},
	func = function(name, param)
		local target = param:split(" ")[1] or ""
		local rank = param:split(" ")[2] or ""
		return ranks.set(target, rank)
	end,
})

local function get_privs_setting(setting, tbl)
	local privs = minetest.string_to_privs(minetest.settings:get(setting))
	if tbl then
		for k, v in pairs(tbl) do
			privs[k] = v
		end
	end
	return privs
end

minetest.register_on_mods_loaded(function()
	local all_privs = minetest.registered_privileges
	local default_privs = get_privs_setting("default_privs")
	local moderator_privs = get_privs_setting("moderator_privs", default_privs)
	local vip_privs = get_privs_setting("vip_privs", default_privs)
	local mvp_privs = get_privs_setting("mvp_privs", vip_privs)


	ranks.defs = {
		developer = {
			tag = "[Developer]",
			color = "900A00",
			description = "The Developer rank is for the admins who maintain the server software.",
			privs = all_privs,
			value = 7,
		},
		admin = {
			tag = "[Admin]",
			color = "FF2D8D",
			description = "The Admin rank is for people with ssh access to the server, they have all privileges. They are members of the Elidragon group.",
			privs = all_privs,
			value = 6,
		},
		moderator = {
			tag = "[Moderator]",
			color = "006BFF",
			description = "People who moderate the server.",
			privs = moderator_privs,
			value = 5,
		},
		contributor = {
			tag = "[Contributor]",
			color = "9D00FF",
			description = "The Contributor rank is for people that contribute to the server software. It has the same privs as the MVP rank.",
			privs = mvp_privs,
			value = 4,
		},
		builder = {
			tag = "[Builder]",
			color = "FF9C00",
			description = "The Builder rank is for people that have helped constructing the buildings in the lobby etc. It has the same privs as the MVP rank.",
			privs = mvp_privs,
			value = 3,
		},
		mvp = {
			tag = "[MVP]",
			color = "0CDCD8",
			description = "The MVP rank can be purchased in out store (upcoming). It is purely cosmetic.",
			privs = mvp_privs,
			value = 2,
		},
		vip = {
			tag = "[VIP]",
			color = "2BEC37",
			description = "The VIP rank can be purchased in out store (upcoming). It is purely cosmetic.",
			privs = vip_privs,
			value = 1,
		},
		player = {
			tag = "",
			color = "FFFFFF",
			description = "This is the rank for normal players.",
			privs = default_privs,
			value = 0,
		},
		console = {
			tag = "[Console]",
			color = "000000",
			description = "This is an offline rank for the console.",
			can_assign = false,
		},
		offline = {
			tag = "[Offline]",
			color = "969696",
			description = "This is the default offline rank.",
			can_assign = false,
		},
		system = {
			tag = "[System]",
			color = "505050",
			description = "This is the rank for the rpc player, which is a bot.",
			privs = {},
			can_assign = false,
		},
	}
end)

elidragon.ranks = ranks
