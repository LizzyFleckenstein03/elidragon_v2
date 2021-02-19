local grouplist = elidragon.grouplist

local old_on_dig = minetest.registered_nodes["lucky_block:lucky_block"].on_dig

minetest.override_item("lucky_block:lucky_block", {
	tiles = {"elidragon_luckyblock.png"},
	inventory_image = minetest.inventorycube("elidragon_luckyblock.png"),
	light_source = nil,
	on_dig = function(pos, node, digger)
		if not minetest.is_protected(pos, digger:get_player_name()) then old_on_dig(pos, node, digger) end
	end
})

minetest.override_item("lucky_block:void_mirror", {
	tiles = {"default_glass.png^[brighten"},
})

minetest.register_alias_force("lucky_block:super_lucky_block", "lucky_block:lucky_block")

local armor_parts = {"head", "torso", "legs", "feet"}
local armor_list = {}
for _, n in pairs(armor_parts) do
	armor_list[n] = grouplist.register("armor_" .. n)
end
local head_list = grouplist.register("head")

lucky_block:add_blocks({
	{"cus", function (pos, player)
		minetest.set_node(pos, {name = "mcl_armor_stand:armor_stand"})
		local nodedef = minetest.registered_nodes["mcl_armor_stand:armor_stand"]
		local node = minetest.get_node(pos)
		local armor_pieces = {}
		for _, n in ipairs(armor_parts) do
			local piece_list = armor_list[n]
			table.insert(armor_pieces, ItemStack(piece_list[math.random(#piece_list)]))
		end
		local function equip_armor(i)
			local piece = armor_pieces[i]
			if not piece then return end
			nodedef.on_rightclick(pos, node, player, ItemStack(piece))
			minetest.after(0.5, equip_armor, i + 1)
		end
		minetest.after(0.5, equip_armor, 1)
	end},
	{"dro", {"mcl_core:goldblock", "mcl_core:gold_ingot", "mcl_core:gold_nugget"}, 256},
	{"dro", {"mcl_core:dirt", "mcl_core:sand", "mcl_core:gravel"}, 64},
	{"spw", "mobs_mc:zombie", 5},
	{"spw", "mobs_mc:husk", 5},
	{"spw", "mobs_mc:spider", 4},
	{"spw", "mobs_mc:cave_spider", 4},
	{"spw", "mobs_mc:skeleton", 2},
	{"spw", "mobs_mc:stray", 2},
	{"spw", "mobs_mc:creeper", 1},
	{"spw", "mobs_mc:creeper_charged", 1},
	{"spw", "mobs_mc:enderman", 1},
	{"spw", "mobs_mc:mooshroom", 1},
	{"spw", "mobs_mc:slime_big", 1},
	{"spw", "mobs_mc:bat", 10},
	{"spw", "mobs_mc:chicken", 3},
	{"spw", "mobs_mc:cow", 1},
	{"spw", "mobs_mc:horse", 1},
	{"spw", "mobs_mc:llama", 1},
	{"spw", "mobs_mc:ocelot", 1},
	{"spw", "mobs_mc:parrot", 1},
	{"spw", "mobs_mc:pig", 1},
	{"spw", "mobs_mc:rabbit", 3},
	{"spw", "mobs_mc:sheep", 1},
	{"spw", "mobs_mc:wolf", 1},
	{"nod", "mcl_cake:cake"},
	{"nod", "mcl_farming:pumpkin"},
	{"dro", ("music_record"), 1},
	{"dro", grouplist.register("horse_armor"), 1},
	{"nod", grouplist.register("glazed_terracotta")},
	{"nod", grouplist.register("hardened_clay")},
	{"nod", grouplist.register("concrete")},
})

elidragon.lucky_block = {}
