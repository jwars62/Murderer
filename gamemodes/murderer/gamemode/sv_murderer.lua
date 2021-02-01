local PlayerMeta = FindMetaTable("Player")

util.AddNetworkString("your_are_a_murderer")

GM.MurdererWeight = CreateConVar("mu_murder_weight_multiplier", 2, bit.bor(FCVAR_NOTIFY), "Multiplier for the weight of the murderer chance" )

function PlayerMeta:SetMurderer(bool)
	self.Murderer = bool
	if bool then
		self.MurdererChance = 1
	end
	net.Start( "your_are_a_murderer" )
	net.WriteUInt(bool and 1 or 0, 8)
	net.Send( self )
end

function PlayerMeta:GetMurderer(bool)
	return self.Murderer
end

function PlayerMeta:SetMurdererRevealed(bool)
	self:SetNWBool("MurdererFog", bool)
	if bool then
		if !self.MurdererRevealed then
		end
	else
		if self.MurdererRevealed then
		end
	end
	self.MurdererRevealed = bool
end

function PlayerMeta:GetMurdererRevealed()
	return self.MurdererRevealed
end

function GM:LoadArmMd()
	local text = file.ReadDataAndContent("murder/ArmMu.txt")
	if text != "" && text then
		MuWeapon = {}
		local i = 1
		for arme in text:gmatch("[^\r\n]+") do
		table.insert(MuWeapon, arme)
		end
	end
end

local MuWeapon = {
        "weapon_mu_knife",
        "weapon_lordi_sledgehammer",
        "weapon_chainsaw_new",
        "weapon_nessbat",
        "weapon_dmcosiris",
	"memesfryingpan",
}

local NO_KNIFE_TIME = 30
function GM:MurdererThink()

	

	local text = file.ReadDataAndContent("murder/ArmMu.txt")
	if text != "" && text then
		MuWeapon = {}
		local i = 1
		for arme in text:gmatch("[^\r\n]+") do
		table.insert(MuWeapon, arme)
		end
	end

	local players = team.GetPlayers(2)
	local murderer
	for k,ply in pairs(players) do
		if ply:GetMurderer() then
			murderer = ply
			break
		end
	end

	// regenerate knife if on ground
	if IsValid(murderer) && murderer:Alive() then
		for k, muw in pairs(MuWeapon) do
			if murderer:HasWeapon(muw) then
				murderer.LastHadKnife = CurTime()
			else
				if murderer.LastHadKnife && murderer.LastHadKnife + NO_KNIFE_TIME < CurTime() then
					for k, ent in pairs(ents.FindByClass("weapon_mu_knife")) do
						ent:Remove()
					end
					for k, ent in pairs(ents.FindByClass("mu_knife")) do
						ent:Remove()
					end
						murderer:Give("weapon_mu_knife")
				end
			end
		end
	end
end