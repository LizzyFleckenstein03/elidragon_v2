local request = {}

function request.register(def)
	local sysname, description, progressive, preposition, func = def.name, def.description, def.progressive, def.func
	local desc_capitalized = (description:sub(1, 1)):upper() .. description:sub(2)

	local request_pool = {}

	minetest.register_on_leaveplayer(function(name)
		request_pool[name] = nil
	end)

	local main_cmd = def.main_cmd or sysname

	minetest.register_chatcommand(main_cmd, {
		description = "Request to " .. description .. " " .. preposition .. " another player",
		params = "<player>",
		func = function(name, param)
			if param == "" then
				return false, "Usage: /" .. main_cmd .. " <player>"
			end
			if not minetest.get_player_by_name(param) then
				return false, "There is no player by that name. Keep in mind this is case-sensitive, and the player must be online"
			end
			request_pool[param] = name
			minetest.after(60, function()
				if request_pool[param] then
					minetest.chat_send_player(name, "Request timed-out.")
					minetest.chat_send_player(param, "Request timed-out.")
					request_pool[param] = nil
				end
			end)
			minetest.chat_send_player(param, name .. " is requesting to " .. description .. " " .. preposition .. " you. /" .. sysname .. "accept to accept")
			return true, desc_capitalized .. " request sent! It will timeout in 60 seconds."
		end
	})

	minetest.register_chatcommand(sysname .. "accept", {
		description = "Accept " .. description .. " request from another player",
		func = function(name)
			if not minetest.get_player_by_name(name) then return false, "You have to be online to use this command" end
			local other = request_pool[name]
			if not other then return false, "Usage: /" .. sysname .. "accept allows you to accept " .. description .. " requests sent to you by other players" end
			if not minetest.get_player_by_name(other) then return false, other .. " doesn't exist, or just disconnected/left (by timeout)." end
			minetest.chat_send_player(other, desc_capitalized .. " request accepted!")
			func(name, other)
			request_pool[name] = nil
			return true, other .. " is " .. progressive .. " " .. preposition .. " you."
		end
	})

	minetest.register_chatcommand(sysname .. "deny", {
		description = "Deny " .. description .." request from another player",
		func = function(name)
			local other = request_pool[name]
			if not other then return false, "Usage: /" .. sysname .. "deny allows you to deny " .. description .. " requests sent to you by other players." end
			minetest.chat_send_player(other, desc_capitalized .. " request denied.")
			request_pool[name] = nil
			return false, "You denied the " .. description .. " request " .. other .. " sent you."
		end
	})
end

elidragon.request = request
