local playerdb = elidragon.playerdb

local ranks = {}

local players = playerdb.players
local admin = minetest.settings:get_string("name")
playerdb.initial_data.rank = "player"

function ranks.get(name)
	if name == "rpc" then
		return "system"
	end
	local playerdata = players[name]
	if not playerdata then
		return name == admin and "console" or "offline"
	end
	return playerdata.rank
end

function ranks.get_def(name)
	return ranks.defs[ranks.get(name)]
end

function ranks.get_player_name(name, brackets)
	local def = ranks.get_def(name)
	brackets = brackets or {"", ""}
	return minetest.colorize("#" .. def.color, def.tag) .. brackets[1] .. name .. brackets[2]
end

function ranks.reload(player)
	local name = player:get_player_name()
	local def = ranks.get_def(name)
	player:set_nametag_attributes({text = ranks.get_player_name(name)})
	minetest.set_player_privs(name, assert(def.privs))
end

function ranks.set(name, rank)
	if name == "rpc" then
		return false, "The rank of the rpc player cannot be changed."
	end
	if not ranks.defs[rank] then
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

minetest.register_on_joinplayer(function(player)
	minetest.chat_send_all(ranks.get_player_name(player) .. " has joined the Server.")
	ranks.reload(player)
end)

minetest.register_on_leaveplayer(function(player)
	minetest.chat_send_all(ranks.get_player_name(player) .. " has left the Server.")
end)

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
	local privs = minetest.string_to_privs(minetest.settings:get_string(setting))
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
		},
		admin = {
			tag = "[Admin]",
			color = "FF2D8D",
			description = "The Admin rank is for people with ssh access to the server, they have all privileges. They are members of the Elidragon group.",
			privs = all_privs,
		},
		moderator = {
			tag = "[Moderator]",
			color = "006BFF",
			description = "People who moderate the server.",
			privs = moderator_privs,
		},
		contributor = {
			tag = "[Contributor]",
			color = "9D00FF",
			description = "The Contributor rank is for people that contribute to the server software. It has the same privs as the MVP rank.",
			privs = mvp_privs,
		},
		builder = {
			tag = "[Builder]",
			color = "FF9C00",
			description = "The Builder rank is for people that have helped constructing the buildings in the lobby etc. It has the same privs as the MVP rank.",
			privs = mvp_privs,
		},
		mvp = {
			tag = "[MVP]",
			color = "0CDCD8",
			description = "The MVP rank can be purchased in out store (upcoming). It is purely cosmetic.",
			privs = mvp_privs,
		},
		vip = {
			tag = "[VIP]",
			color = "2BEC37",
			description = "The VIP rank can be purchased in out store (upcoming). It is purely cosmetic.",
			privs = vip_privs,
		},
		player = {
			tag = "",
			color = "FFFFFF",
			description = "This is the rank for normal players.",
			privs = default_privs,
		},
		console = {
			tag = "[Console] ",
			color = "000000",
			description = "This is an offline rank for the console.",
		},
		offline = {
			tag = "[Offline] ",
			color = "969696",
			description = "This is the default offline rank.",
		},
		system = {
			tag = "[System] ",
			color = "505050",
			description = "This is the rank for the rpc player, which is a bot.",
			privs = {},
		},
	}
end)
