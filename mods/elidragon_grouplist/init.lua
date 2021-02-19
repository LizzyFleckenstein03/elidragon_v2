local grouplist = {}
grouplist.lists = {}

function grouplist.register(group)
	local list = {}
	grouplists.lists[group] = list
	return list
end

function grouplist.get(group)
	return grouplist.lists[group] or {}
end

function grouplist.insert(item, group)
	table.insert(grouplist.get(group), item)
end

minetest.register_on_mods_loaded(function()
	for nodename, nodedef in pairs(minetest.registered_items) do
		for group, list in pairs(grouplist.lists) do
			if nodedef.groups[group] and nodedef.groups[group] > 0 then
				table.insert(list, nodename)
			end
		end
	end
end)

elidragon.grouplist = grouplist
