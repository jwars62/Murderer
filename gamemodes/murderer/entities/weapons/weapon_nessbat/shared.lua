if( SERVER ) then
AddCSLuaFile( "shared.lua" )
end


if( CLIENT ) then
SWEP.BounceWeaponIcon = false
SWEP.WepSelectIcon	= surface.GetTextureID("weapons/nessbat") --
killicon.Add("nessbat","weapons/nessbat",Color(255,255,255))  ---
end

SWEP.PrintName 		= "Ness's Homerun Bat"
SWEP.Slot 			= 1
SWEP.SlotPos 		= 0
SWEP.DrawAmmo 		= false
SWEP.DrawCrosshair 	= true
SWEP.Author			= "Jeffw773"
SWEP.Instructions	= "Left click to hit a homerun"
SWEP.Contact		= "jeffw773@gmail.com"
SWEP.Purpose		= "To knock one out of the park!"
SWEP.Category		= "Jeffw773's Weapons"

SWEP.ViewModelFOV	= 80
SWEP.ViewModelFlip	= false

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true


SWEP.ViewModel      = "models/weapons/v_nessbat.mdl"
SWEP.WorldModel   	= "models/weapons/w_nessbat.mdl"

SWEP.Primary.Delay				= 0.5
SWEP.Primary.ClipSize			= -1
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.Automatic   		= false
SWEP.Primary.Ammo         		= "none"

SWEP.Secondary.Delay			= 0.4
SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Automatic  	 	= false
SWEP.Secondary.Ammo         	= "none"


function SWEP:Initialize()
self:SetWeaponHoldType("sword")
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim( ACT_VM_DRAW )
	self:SetNextPrimaryFire(CurTime() + 0.7)
	self:SetNextSecondaryFire(CurTime() + 0.7)
return true
end

function SWEP:OnRemove()
return true
end

function SWEP:PrimaryAttack()
	local trace = self.Owner:GetEyeTrace()

		if trace.HitPos:Distance(self.Owner:GetShootPos()) <= 75 then

		if trace.Entity:IsValid() then
		
	self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	bullet = {}
	bullet.Num    = 20
	bullet.Src    = self.Owner:GetShootPos()
	bullet.Dir    = self.Owner:GetAimVector()
	bullet.Spread = Vector(0, 0, 0)
	bullet.Tracer = 0
	bullet.Force  = 100000
	bullet.Damage = 19500
self.Owner:FireBullets(bullet)
self.Owner:SetAnimation( PLAYER_ATTACK1 );
self.Weapon:EmitSound("Nessbat/bat_sound.wav")

	self.Weapon:SetNextSecondaryFire( CurTime() + self.Secondary.Delay )
	self.Weapon:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self.Owner:LagCompensation(true)
	self.Owner:LagCompensation(false)
	self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER2)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

end

elseif !trace.Entity:IsValid()  then 
	self.Weapon:EmitSound("weapons/iceaxe/iceaxe_swing1.wav")
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	
end

end

function SWEP:Bash()

end

function StopTimer(ply)
	if not ply:GetActiveWeapon():IsValid() then return false end
	timer.Stop("Slash")
	timer.Stop("Bash")
	ply:LagCompensation( false )
end
hook.Add("DoPlayerDeath", "StopTimer", StopTimer)


local ActIndex = {}
	ActIndex["pistol"] 		= ACT_HL2MP_IDLE_PISTOL
	ActIndex["smg"] 			= ACT_HL2MP_IDLE_SMG1
	ActIndex["grenade"] 		= ACT_HL2MP_IDLE_GRENADE
	ActIndex["ar2"] 			= ACT_HL2MP_IDLE_AR2
	ActIndex["shotgun"] 		= ACT_HL2MP_IDLE_SHOTGUN
	ActIndex["rpg"]	 		= ACT_HL2MP_IDLE_RPG
	ActIndex["physgun"] 		= ACT_HL2MP_IDLE_PHYSGUN
	ActIndex["crossbow"] 		= ACT_HL2MP_IDLE_CROSSBOW
	ActIndex["melee"] 		= ACT_HL2MP_IDLE_MELEE
	ActIndex["slam"] 			= ACT_HL2MP_IDLE_SLAM
	ActIndex["normal"]		= ACT_HL2MP_IDLE
	ActIndex["knife"]			= ACT_HL2MP_IDLE_KNIFE
	ActIndex["sword"]			= ACT_HL2MP_IDLE_MELEE2
	ActIndex["passive"]		= ACT_HL2MP_IDLE_PASSIVE
	ActIndex["fist"]			= ACT_HL2MP_IDLE_FIST

function SWEP:SetWeaponHoldType(t)

	local index = ActIndex[t]
	
	if (index == nil) then
		Msg("SWEP:SetWeaponHoldType - ActIndex[ \""..t.."\" ] isn't set!\n")
		return
	end

self.ActivityTranslate = {}
self.ActivityTranslate [ ACT_MP_STAND_IDLE ]				= index
self.ActivityTranslate [ ACT_MP_WALK ]						= index+1
self.ActivityTranslate [ ACT_MP_RUN ]						= index+2        
self.ActivityTranslate [ ACT_MP_CROUCH_IDLE ]				= index+3
self.ActivityTranslate [ ACT_MP_CROUCHWALK ]				= index+4
self.ActivityTranslate [ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]	= index+5
self.ActivityTranslate [ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]	= index+5
self.ActivityTranslate [ ACT_MP_RELOAD_STAND ]				= index+6
self.ActivityTranslate [ ACT_MP_RELOAD_CROUCH ]				= index+6
self.ActivityTranslate [ ACT_MP_JUMP ]						= index+7
self.ActivityTranslate [ ACT_RANGE_ATTACK1 ]				= index+8
	if t == "normal" then
		self.ActivityTranslate [ ACT_MP_JUMP ] = ACT_HL2MP_JUMP_SLAM
	end
	if t == "passive" then
		self.ActivityTranslate [ ACT_MP_CROUCH_IDLE ] = ACT_HL2MP_CROUCH_IDLE
	end	
	self:SetupWeaponHoldTypeForAI(t)
end

function SWEP:TranslateActivity(act)

	if (self.Owner:IsNPC()) then
		if (self.ActivityTranslateAI[act]) then
			return self.ActivityTranslateAI[act]
		end

		return -1
	end

	if (self.ActivityTranslate[act] != nil) then
		return self.ActivityTranslate[act]
	end
	
	return -1
end