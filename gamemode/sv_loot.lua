local PlayerMeta = FindMetaTable("Player")
local EntityMeta = FindMetaTable("Entity")

if !LootItems then
	LootItems = {}
end

local LootModels = {}
LootModels["breenbust"] = "models/props_combine/breenbust.mdl"
LootModels["huladoll"] = "models/props_lab/huladoll.mdl"
LootModels["beer1"] = "models/props_junk/glassbottle01a.mdl"
LootModels["beer2"] = "models/props_junk/glassjug01.mdl"
LootModels["cactus"] = "models/props_lab/cactus.mdl"
LootModels["lamp"] = "models/props_lab/desklamp01.mdl"
LootModels["clipboard"] = "models/props_lab/clipboard.mdl"
LootModels["suitcase1"] = "models/props_c17/suitcase_passenger_physics.mdl"
LootModels["suitcase2"] = "models/props_c17/suitcase001a.mdl"
LootModels["battery"] = "models/items/car_battery01.mdl"
LootModels["skull"] = "models/Gibs/HGIBS.mdl"
LootModels["baby"] = "models/props_c17/doll01.mdl"
LootModels["antlionhead"] = "models/Gibs/Antlion_gib_Large_2.mdl"
LootModels["briefcase"] = "models/props_c17/BriefCase001a.mdl"
LootModels["breenclock"] = "models/props_combine/breenclock.mdl"
LootModels["sawblade"] = "models/props_junk/sawblade001a.mdl"
LootModels["wrench"] = "models/props_c17/tools_wrench01a.mdl"
LootModels["consolebox"] = "models/props_c17/consolebox01a.mdl"
LootModels["cashregister"] = "models/props_c17/cashregister01a.mdl"
LootModels["familyphoto"] = "models/props_lab/frame002a.mdl"
LootModels["book1"] = "models/FO3/misc/BookChinese_0.mdl"
LootModels["book3"] = "models/FO3/misc/BookDcJournal_0.mdl"
LootModels["book4"] = "models/FO3/misc/BookDuckandCover_0.mdl"
LootModels["book5"] = "models/FO3/misc/BookElectronics_0.mdl"
LootModels["book6"] = "models/FO3/misc/BookFlamethrower_0.mdl"
LootModels["book7"] = "models/FO3/misc/BookGrognak_0.mdl"
LootModels["book8"] = "models/FO3/misc/bookguns.mdl"
LootModels["book9"] = "models/FO3/misc/Bookjunkton.mdl"
LootModels["book10"] = "models/FO3/misc/BookTumbler_0.mdl"
LootModels["book11"] = "models/FO3/misc/BookLying_0.mdl"
LootModels["book12"] = "models/FO3/misc/BookofScience_0.mdl"
LootModels["book13"] = "models/FO3/misc/BookTesla01_0.mdl"

local FruitModels = {
	"models/props_junk/watermelon01.mdl"
}

util.AddNetworkString("GrabLoot")
util.AddNetworkString("SetLoot")

function GM:LoadLootData() 
	local mapName = game.GetMap()
	local jason = file.ReadDataAndContent("murder/" .. mapName .. "/loot.txt")
	if jason then
		local tbl = util.JSONToTable(jason)
		LootItems = tbl
	end
end

function GM:CountLootItems()
	return #LootItems
end

function GM:SpawnLoot()
	for k, ent in pairs(ents.FindByClass("mu_loot")) do
		ent:Remove()
	end

	for k, data in pairs(LootItems) do
		self:SpawnLootItem(data)
	end
end

function GM:SpawnLootItem(data)
	for k, ent in pairs(ents.FindByClass("mu_loot")) do
		if ent.LootData == data then
			ent:Remove()
		end
	end

	local ent = ents.Create("mu_loot")
	ent:SetModel(data.model)
	ent:SetPos(data.pos)
	ent:SetAngles(data.angle)
	ent:Spawn()

	ent.LootData = data
	-- print(data.pos, data.model, ent)

	return ent
end

function GM:LootThink()

	local delai = self.delai:GetInt()

	if self:GetRound() == 1 then

		if !self.LastSpawnLoot || self.LastSpawnLoot < CurTime() then
			self.LastSpawnLoot = CurTime() + delai

			local data = table.Random(LootItems)
			if data then
				self:SpawnLootItem(data)
			end
		end
	end
end

function GM:SaveLootData()

	// ensure the folders are there
	if !file.Exists("murder/","DATA") then
		file.CreateDir("murder")
	end

	local mapName = game.GetMap()
	if !file.Exists("murder/" .. mapName .. "/","DATA") then
		file.CreateDir("murder/" .. mapName)
	end

	// JSON!
	local jason = util.TableToJSON(LootItems)
	file.Write("murder/" .. mapName .. "/loot.txt", jason)
end

function GM:AddLootItem(ent)
	local data = {}
	data.model = ent:GetModel()
	data.material = ent:GetMaterial()
	data.pos = ent:GetPos()
	data.angle = ent:GetAngles()
	table.insert(LootItems, data)
end

local function giveMagnum(ply)
	// if they already have the gun, drop the first and give them a new one
	if ply:HasWeapon("weapon_mu_magnum") then
		ply:DropWeapon(ply:GetWeapon("weapon_mu_magnum"))
	end
	if ply:GetTKer() then
		// if they are penalised, drop the gun on the floor
		ply.TempGiveMagnum = true // temporarily allow them to pickup the gun
		ply:Give("weapon_mu_magnum")
		ply:DropWeapon(ply:GetWeapon("weapon_mu_magnum"))
	else
		ply:Give("weapon_mu_magnum")
		ply:SelectWeapon("weapon_mu_magnum")
	end
end

function GM:SaveArm()

 glowstick = {
        "weapon_glowstick_aqua",
        "weapon_glowstick_blue",
        "weapon_glowstick_green",
        "weapon_glowstick_purple",
        "weapon_glowstick_red",
	"weapon_e_poorcross",
	"weapon_minecraft_torch",
	"weapon_glowstick_yellow",
	"weapon_gascan",
}

 jojo = {
        "weapon_vilka",
        "hermitupurple",
        "epitaph_huita",
        "king_crimshuita",
        "jjgma_goldexperience",
	"weapon_ninjaknife",
	"star_platinum_the_world",
	"sticky_finger",
	"stone_free",
	"the_hand",
	"the_world_high_dio",
	"real_knife_admin",
	"3dgear",
	"rocketboots",
	"killer_queen",
	"jjgma_purplehaze",
}

 armdx = {
	"thomas_gun",
	"weapon_undertale_sans",
	"qtg_weapon_underswap_papyrus",
	"aero_smith",
	"the_world",
}

 armop = {
	"weapon_e_poorcross",
	"gidzco_shrekzooka",
	"weapon_undertale_sans",
	"qtg_weapon_underswap_papyrus",
	"weapon_midascannon",
	"weapon_tzar_vodka",
	"sup",
	"aero_smith",
	"turbine",
	"weapon_megumin",
}

 armgt = {
	"weapon_nyangun",
	"weapon_rptdnw",
	"weapon_dearsistah",
	"sex_pistol",
	"weapon_e_poorcross",
	"glow",
	"sup",
}

 arm = {
        "weapon_e_banana",
        "deika_raygunmark2",
	"weapon_bladebow",
	"sup",
}

RandomMuWeapon = {
        "weapon_mu_knife",
        "weapon_mu_knife",
        "weapon_mu_knife",
        "weapon_chainsaw_new",
        "weapon_nessbat",
        "weapon_dmcosiris",
	"memesfryingpan",
}

		local txt = "lotterie bystander raretée 1 :\n"
		for k, map in pairs(arm) do
			txt = txt .. map .. "\r\n"
		end
		txt = txt .. "\nlotterie bystander raretée 2 :\n"
		for k, map in pairs(armgt) do
			txt = txt .. map .. "\r\n"
		end
		txt = txt .. "\nlotterie bystander raretée 3 :\n"
		for k, map in pairs(armop) do
			txt = txt .. map .. "\r\n"
		end
		txt = txt .. "\nlotterie bystander raretée 4 :\n"
		for k, map in pairs(armdx) do
			txt = txt .. map .. "\r\n"
		end
		txt = txt .. "\nlotterie murder :\n"
		for k, map in pairs(jojo) do
			txt = txt .. map .. "\r\n"
		end
		txt = txt .. "\nlumiere :\n"
		for k, map in pairs(glowstick) do
			txt = txt .. map .. "\r\n"
		end
		txt = txt .. "\narmes de départ du murder\n"
		for k, map in pairs(RandomMuWeapon) do
			txt = txt .. map .. "\r\n"
		end
		file.Write("murder/list_arm_def.txt", txt)

	local text = file.ReadDataAndContent("murder/lot_t1.txt")
	if !text then
		local txt = ""
		file.Write("murder/lot_t1.txt", txt)
	end
	
	local text = file.ReadDataAndContent("murder/lot_t2.txt")
	if !text then
		local txt = ""
		file.Write("murder/lot_t2.txt", txt)
	end
	
	local text = file.ReadDataAndContent("murder/lot_t3.txt")
	if !text then
		local txt = ""
		file.Write("murder/lot_t3.txt", txt)
	end
	
	local text = file.ReadDataAndContent("murder/lot_t4.txt")
	if !text then
		local txt = ""
		file.Write("murder/lot_t4.txt", txt)
	end
	
	local text = file.ReadDataAndContent("murder/lot_mu.txt")
	if !text then
			local txt = ""
		file.Write("murder/lot_mu.txt", txt)
	end
	
	local text = file.ReadDataAndContent("murder/lum.txt")
	if !text then
		local txt = ""
		file.Write("murder/lum.txt", txt)
	end
end

function GM:LoadArm()
	local text = file.ReadDataAndContent("murder/lum.txt")
	if text != "" then
		glowstick = {}
		local i = 1
		for arme in text:gmatch("[^\r\n]+") do
			table.insert(glowstick, arme)
		end
	end
	
	local text = file.ReadDataAndContent("murder/lot_mu.txt")
	if text != "" then
		jojo = {}
		local i = 1
		for arme in text:gmatch("[^\r\n]+") do
			table.insert(jojo, arme)
		end
	end
	
	local text = file.ReadDataAndContent("murder/lot_t4.txt")
	if text != "" then
		armdx = {}
		local i = 1
		for arme in text:gmatch("[^\r\n]+") do
			table.insert(armdx, arme)
		end
	end
	
	local text = file.ReadDataAndContent("murder/lot_t3.txt")
	if text != "" then
		armop = {}
		local i = 1
		for arme in text:gmatch("[^\r\n]+") do
			table.insert(armop, arme)
		end
		table.insert(armop, "sup")
	end
	
	local text = file.ReadDataAndContent("murder/lot_t2.txt")
	if text != "" then
		armgt = {}
		local i = 1
		for arme in text:gmatch("[^\r\n]+") do
			table.insert(armgt, arme)
		end
		table.insert(armgt, "sup")
	end
	
	local text = file.ReadDataAndContent("murder/lot_t1.txt")
	if text != "" then
		arm = {}
		local i = 1
		for arme in text:gmatch("[^\r\n]+") do
			table.insert(arm, arme)
		end
		table.insert(arm, "sup")
	end
end

local function falselot(ply) 
	fake = {}
	for i, fke in pairs(arm) do
		if fke == "weapon_e_banana" then
			table.insert(fake, "weapon_e_bananaf")
		end
		if fke == "weapon_bladebow" then
			table.insert(fake, "weapon_bladebowf")
		end
		if fke == "deika_raygunmark2" then
			table.insert(fake, "deika_raygunmarkf")
		end
	end
	fa = table.Random(fake)
	ply:Give(fa)
	ply:SelectWeapon(fa)
end


function GM:PlayerPickupLoot(ply, ent)
	ply.LootCollected = ply.LootCollected + 1
	
	if !glowstick then
		self:SaveArm()
		self:LoadArm()
	end
	
	local pb1 = self.pb1:GetInt()
	local pb2 = self.pb2:GetInt()
	local pb3 = self.pb3:GetInt()
	local pm1 = self.pm1:GetInt()
	local pm2 = self.pm2:GetInt()
	local pm3 = self.pm3:GetInt()
	local pm4 = self.pm4:GetInt()

local dice = math.random(1,3)
	if !ply:GetMurderer() then
		if ply.LootCollected == pb2 then
			if dice == 3 then
				giveMagnum(ply)
			else
				ply:Give("weapon_e_banana")
				ply:SelectWeapon("weapon_e_banana")
			end
		end
		if ply.LootCollected == pb1 then
			nw = table.Random(glowstick)
			ply:Give(nw);
			ply:Give("weapon_buzz_gpee")
			ply:SelectWeapon(nw)
		end

		if ply.LootCollected == pb3 then
			nw = table.Random(arm)
			if nw == "sup" then
				nw = table.Random(armgt)
				if nw == "glow" then
					nw = table.Random(glowstick)
				elseif nw == "sup" then
					nw = table.Random(armop)
					if nw == "sup" then
						nw = table.Random(armdx)
					end
				end
			end
			ply:Give(nw);
			ply:SelectWeapon(nw)
		end
	end

	
	if ply:GetMurderer() then
		if ply.LootCollected == pm1 then
			nw = table.Random(glowstick)
			ply:Give(nw);
			ply:Give("weapon_buzz_gpee")
			ply:SelectWeapon(nw)
		end
		if ply.LootCollected == pm2 then
			if dice == 3 then
				ply:Give("weapon_fake");
			else
				ply:Give("weapon_e_bananaf")
				ply:SelectWeapon("weapon_e_bananaf")
			end
		end
		if ply.LootCollected == pm3 then
			ply:Give("weapon_jihadbomb")
		end
		if ply.LootCollected == pm4 then
			local lt = table.Random(jojo)
			if lt == "rocketboots" then
				ply:GiveRocketBoots(math.huge)
			else
				ply:Give(lt);
			end
			falselot(ply)
		end
	end


	ply:EmitSound("ambient/levels/canals/windchime2.wav", 100, math.random(40,160))
	ent:Remove()

	net.Start("GrabLoot")
	net.WriteUInt(ply.LootCollected, 32)
	net.Send(ply)
end

function PlayerMeta:GetLootCollected()
	return self.LootCollected
end

function PlayerMeta:SetLootCollected(loot)
	self.LootCollected = loot
	net.Start("SetLoot")
	net.WriteUInt(self.LootCollected, 32)
	net.Send(self)
end

local function getLootPrintString(data, plyPos) 
	local str = math.Round(data.pos.x) .. "," .. math.Round(data.pos.y) .. "," .. math.Round(data.pos.z) .. " " .. math.Round(data.pos:Distance(plyPos) / 12) .. "ft"
	str = str .. " " .. data.model
	return str
end

concommand.Add("mu_loot_add", function (ply, com, args, full)
	if (!ply:IsAdmin()) then return end

	if #args < 1 then
		ply:ChatPrint("Too few args (model)")
		return
	end

	local mdl = args[1]

	local name = args[1]:lower()
	if name == "rand" || name == "random" then
		mdl = table.Random(LootModels)
	elseif name == "fruit" then
		mdl = table.Random(FruitModels)
	elseif !name:find("%.mdl$") then
		if !LootModels[name] then
			ply:ChatPrint("Invalid model alias " .. name)
			return
		end

		mdl = LootModels[name]
	end


	local data = {}
	data.model = mdl
	data.pos = ply:GetEyeTrace().HitPos
	data.angle = ply:GetAngles() * 1
	data.angle.p = 0
	table.insert(LootItems, data)

	ply:ChatPrint("Added " .. #LootItems .. ": " .. getLootPrintString(data, ply:GetPos()) )

	GAMEMODE:SaveLootData()

	local ent = GAMEMODE:SpawnLootItem(data)
	local mins, maxs = ent:OBBMins(), ent:OBBMaxs()
	local pos = ent:GetPos()
	pos.z = pos.z - mins.z
	ent:SetPos(pos)

	data.pos = pos
	GAMEMODE:SaveLootData()
end)

concommand.Add("mu_loot_list", function (ply, com, args, full)
	if (!ply:IsAdmin()) then return end

	if #args < 0 then
		ply:ChatPrint("Too few args ()")
		return
	end


	ply:ChatPrint("Loot items ")
	for k, pos in pairs(LootItems) do
		ply:ChatPrint(k .. ": " .. getLootPrintString(pos, ply:GetPos()) )
	end
end)

concommand.Add("mu_loot_closest", function (ply, com, args, full)
	if (!ply:IsAdmin()) then return end

	if #args < 0 then
		ply:ChatPrint("Too few args ()")
		return
	end

	if #LootItems <= 0 then
		ply:ChatPrint("Loot list is empty")
		return
	end

	local closest
	for k, data in pairs(LootItems) do
		if !closest || (LootItems[closest].pos:Distance(ply:GetPos()) > data.pos:Distance(ply:GetPos())) then
			closest = k
		end
	end

	ply:ChatPrint(closest .. ": " .. getLootPrintString(LootItems[closest], ply:GetPos()) )
end)

concommand.Add("mu_loot_remove", function (ply, com, args, full)
	if (!ply:IsAdmin()) then return end

	if #args < 1 then
		ply:ChatPrint("Too few args (key)")
		return
	end

	local key = tonumber(args[1]) or 0
	if !LootItems[key] then
		ply:ChatPrint("Invalid key, position inexists")
		return
	end

	local data = LootItems[key]
	table.remove(LootItems, key)
	ply:ChatPrint("Remove " .. key .. ": " .. getLootPrintString(data, ply:GetPos()) )

	GAMEMODE:SaveLootData()
end)

concommand.Add("mu_loot_adjustpos", function (ply, com, args, full)
	if (!ply:IsAdmin()) then return end

	if #args < 0 then
		ply:ChatPrint("Too few args ()")
		return
	end

	local key
	local ent = ply:GetEyeTrace().Entity
	if IsValid(ent) && ent:GetClass() == "mu_loot" && ent.LootData then
		for k,v in pairs(LootItems) do
			if v == ent.LootData then
				key = k
			end
		end
	end
	if !key then
		ply:ChatPrint("Not a loot item")
		return
	end

	ent.LootData.pos = ent:GetPos()
	ent.LootData.angle = ent:GetAngles()

	ply:ChatPrint("Adjusted " .. key .. ": " .. getLootPrintString(ent.LootData, ply:GetPos()) )

	GAMEMODE:SaveLootData()
end)

concommand.Add("mu_loot_respawn", function (ply, com, args, full)
	if (!ply:IsAdmin()) then return end

	GAMEMODE:SpawnLoot()
end)

concommand.Add("mu_loot_models_list", function (ply, com, args, full)
	if (!ply:IsAdmin()) then return end

	ply:ChatPrint("Loot models")
	for alias, model in pairs(LootModels) do
		ply:ChatPrint(alias .. ": " .. model )
	end
end)