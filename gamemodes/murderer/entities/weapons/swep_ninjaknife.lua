AddCSLuaFile()

if CLIENT then
	language.Add("swep_ninjaknife", "Ninja Knife")
end

SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.Category = "Toybox Classics"

SWEP.ViewModelFOV = 70

SWEP.PrintName = "Ninja Knife"
SWEP.Author = "Emi, LeadKiller"

SWEP.Primary.Ammo = false
SWEP.Secondary.Ammo = false

SWEP.ViewModel = "models/weapons/v_models/v_knife_spy.mdl"
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"
SWEP.UseHands = true
SWEP.Slot                = 1
SWEP.SlotPos		 = 1

function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "ViewModelIndex")
	self:NetworkVar("Float", 1, "NextReloadTime")
	self:NetworkVar("Float", 2, "ViewModelType")
	self:NetworkVar("Float", 3, "NextThink")
end

function SWEP:Initialize()
	self:SetHoldType("knife")
end

function SWEP:ViewModelChange()
	local vmnum = self:GetViewModelIndex()

	if vmnum == 0 then
		if IsMounted("tf") then
			self:SetViewModelIndex(3)
			self:ViewModelChange()
		elseif IsMounted("cstrike") then
			self:SetViewModelIndex(2)
			self:ViewModelChange()
		else
			self:SetViewModelIndex(1)
			self:ViewModelChange()
		end
	elseif vmnum == 1 then
		self.Owner:GetViewModel():SetModel("models/weapons/c_crowbar.mdl")
		self:SetViewModelType(1)
		self:SendWeaponAnim(ACT_VM_DRAW)
		self.sndKnifeHit = "Weapon_Crowbar.Melee_Hit"
		self.sndKnifeWorld = "Weapon_Crowbar.Melee_HitWorld"
		self.sndKnifeSwing = "Weapon_Crowbar.Single"
		self.sndKnifeStab = "Weapon_Crowbar.Melee_Hit"
	elseif vmnum == 2 then
		self.Owner:GetViewModel():SetModel("models/weapons/cstrike/c_knife_t.mdl")
		self:SetViewModelType(2)
		self:SendWeaponAnim(ACT_VM_SWINGMISS)
		self.Owner:SendLua("surface.PlaySound('weapons/knife/knife_deploy1.wav')")
		self.sndKnifeHit = "Weapon_Knife.Hit"
		self.sndKnifeWorld = "Weapon_Knife.HitWall"
		self.sndKnifeSwing = "Weapon_Knife.Slash"
		self.sndKnifeStab = "Weapon_Knife.Stab"
	elseif vmnum == 3 then
		self.Owner:GetViewModel():SetModel("models/weapons/v_models/v_knife_spy.mdl")
		self:SetViewModelType(3)
		self:SendWeaponAnim(ACT_VM_DRAW)
		self.sndKnifeHit = "Weapon_Knife.HitFlesh"
		self.sndKnifeWorld = "Weapon_Knife.HitWorld"
		self.sndKnifeSwing = "Weapon_Knife.Miss"
		self.sndKnifeStab = "Weapon_Knife.Stab"
	end
	--self:SendWeaponAnim(ACT_VM_SWINGHARD) -- hit hard crowbar, idle knife, backstab spy knife
	--self:SendWeaponAnim(ACT_VM_DRAW) -- draw crowbar, swing knife, draw spy knife
	--self:SendWeaponAnim(ACT_VM_SWINGMISS) -- nothing crowbar, draw knife, nothing spy knife
end

function SWEP:ViewModelSwing()
	local vm = self:GetViewModelType()
	if vm == 1 then
		self:SendWeaponAnim(ACT_VM_SWINGHARD)
	elseif vm == 2 then
		self:SendWeaponAnim(ACT_VM_DRAW)
	elseif vm == 3 then
		self:SendWeaponAnim(ACT_VM_SWINGHARD)
	end
end

function SWEP:PrimaryAttack()
	if self:GetNextPrimaryFire() > CurTime() then return end
	self:GetOwner():SetAnimation(PLAYER_ATTACK1)
	self:ViewModelSwing()
	self:SetNextPrimaryFire(CurTime() + self:SequenceDuration())
	self:ShootBullet()
end

function SWEP:ShootBullet( damage, num_bullets, aimcone )
	local bullet = {}
	bullet.Num 	= num_bullets
	bullet.Src 	= self.Owner:GetShootPos() -- Source
	bullet.Dir 	= self.Owner:GetAimVector() -- Dir of bullet
	bullet.Spread 	= Vector( 0, 0, 0 )	-- Aim Cone
	bullet.Tracer	= 0 -- Show a tracer on every x bullets
	bullet.Force	= 1024 -- Amount of force to give to phys objects
	bullet.Damage	= 10
	bullet.Distance = 64
	bullet.AmmoType = ""
	bullet.Callback = function(_, tr, dmginfo)
		dmginfo:SetDamageForce(tr.Normal * 1024)
		if tr.Hit then
			print("gay")
			if tr.Entity and tr.Entity:Health() and !tr.Entity:IsWorld() and (tr.Entity:IsNPC() or tr.Entity:IsPlayer()) then
				print("ENTITY")
				print(tr.Entity)
				local ent = tr.Entity
				if ent:Health() and ent:IsPlayer() or ent:IsNPC() then
					self:EmitSound(self.sndKnifeStab)
				end
			else
				print("WORLD")
				self:EmitSound(self.sndKnifeWorld)
			end
		else
			print("nah")
			self:EmitSound(self.sndKnifeSwing)
		end
	end

	self.Owner:FireBullets( bullet )
end

function SWEP:CanPrimaryAttack()
	return true
end

function SWEP:Think()
	self:CustomThink()
end

function SWEP:CustomThink()

end

function SWEP:Deploy()
	self:ViewModelChange()
end

function SWEP:Reload()
	if self:GetNextReloadTime() > CurTime() then return end
	print("FUCK")
	self:SetNextReloadTime(CurTime() + 1)
	local vmnum = self:GetViewModelIndex()

	if vmnum < 3 then
		self:SetViewModelIndex(vmnum + 1)
		self:ViewModelChange()
		print("ADDED")
	else
		self:SetViewModelIndex(1)
		self:ViewModelChange()
		print("RESET")
		print(vmnum)
	end
print("RELOADED")
	return true
end

