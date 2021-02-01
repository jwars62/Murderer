
AddCSLuaFile()


if CLIENT then
   SWEP.PrintName          = "weapon_e_bananaf"
   SWEP.Slot               = 2

   SWEP.ViewModelFlip      = false
   
   SWEP.IconLetter         = "B"
end

SWEP.Base                  = "weapon_base"
SWEP.Weight = 5

SWEP.AutoSwitchTo = true
SWEP.AutoSwitchFrom = false

SWEP.DrawAmmo = true
SWEP.DrawCrosshair = true

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ShouldDropOnDie = true

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 64
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.AutRecoil = 3
SWEP.Primary.Damage = 1
SWEP.Primary.NumShots = 1
SWEP.Primary.Spread = 0
SWEP.Primary.Cone = 0
SWEP.Primary.Delay = 0.4
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Automatic     = false

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.Automatic = false

SWEP.ViewModel = "models/weapons/horrorween/v_banana_gun.mdl"
SWEP.WorldModel = "models/weapons/horrorween/w_banana_gun.mdl"
SWEP.UseHands = true


local sndFire = Sound("physics/flesh/flesh_squishy_impact_hard4.wav")

function SWEP:Initialize()

	self:SetHoldType( "pistol" )
	self:SetWeaponHoldType( "pistol" )

end

function SWEP:Deploy()
	self.Owner:GetViewModel():SetPlaybackRate(0.9)
end

function SWEP:DrawWorldModel()
	self:DrawModel()
end

function SWEP:PrimaryAttack()
	
	if(!self:CanPrimaryAttack()) then
		return
	end
	
	if ( self.Weapon:Clip1() <= 0 ) then

		self:EmitSound( "Weapon_Pistol.Empty" )
		self:SetNextPrimaryFire( CurTime() + 0.2 )
		self:Reload()
		return

	end
	
	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	
	self.Owner:LagCompensation( true )

	self:EmitSound( sndFire )
	
	local bullet = {}
		bullet.Num 		= self.Primary.NumShots
		bullet.Src 		= self.Owner:GetShootPos()
		bullet.Dir 		= self.Owner:GetAimVector()
		bullet.Spread 	= Vector( self.Primary.Spread, self.Primary.Spread, 0 )
		bullet.Tracer	= 1	
		bullet.TracerName = "Tracer"
		bullet.Force	= 1
		bullet.Damage	= self.Primary.Damage
		bullet.AmmoType = self.Primary.Ammo 
 
	self.Owner:FireBullets( bullet )
	self:ShootEffects()
	self.Owner:ViewPunch( Angle( -1, 0, 0 ) )
	
	if ( self:Clip1() <= 0 ) then 
 
		if ( self:Ammo1() <= 0 ) then return end
 
		self.Owner:RemoveAmmo( self.Primary.TakeAmmo, self:GetPrimaryAmmoType() )
 
	return end
 
	self:SetClip1( self:Clip1() - self.Primary.TakeAmmo )	
	
	self.Owner:LagCompensation( false )
	
	self:Reload()
	
end

function SWEP:ShootEffects()
 
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:MuzzleFlash()
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
 
end

function SWEP:CanSecondaryAttack()
	return false
end

function SWEP:Reload()
	
	self:DefaultReload(ACT_VM_RELOAD)
	self:SetNextPrimaryFire( CurTime() + 1.5 )
end








