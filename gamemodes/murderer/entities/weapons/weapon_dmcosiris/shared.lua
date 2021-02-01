


if ( SERVER ) then

	AddCSLuaFile( "shared.lua" )
	SWEP.HoldType			= "melee"
	
end

if ( CLIENT ) then

         SWEP.PrintName	                = "Osiris"	 
         SWEP.Author				= "TiggoRech"
         SWEP.Category		= "DmC: Devil May Cry (TR)" 
         SWEP.Slot			        = 1					 
         SWEP.SlotPos		        = 0
         SWEP.DrawAmmo                  = false					 
         SWEP.IconLetter			= "w"

         killicon.AddFont( "weapon_crowbar", 	"HL2MPTypeDeath", 	"6", 	Color( 255, 80, 0, 255 ) )

end


SWEP.Base				= "weapon_base"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.ViewModel		= "models/tiggomods/weapons/DmC5/v_osiris.mdl"	 
SWEP.WorldModel		= "models/tiggomods/weapons/DmC5/w_osiris.mdl"
SWEP.DrawCrosshair              = true

SWEP.ViewModelFOV = 65

SWEP.ViewModelFlip = false


SWEP.Weight				= 1			 
SWEP.AutoSwitchTo		= true		 
SWEP.AutoSwitchFrom		= false	
SWEP.CSMuzzleFlashes		= false	  	 		 
		 
SWEP.Primary.Damage			= 100000
SWEP.Primary.Force			= 0.75						 			  
SWEP.Primary.ClipSize		= -1		
SWEP.Primary.Delay			= 0.40
SWEP.Primary.DefaultClip	= 1		 
SWEP.Primary.Automatic		= true		 
SWEP.Primary.Ammo			= "none"	 

SWEP.Secondary.ClipSize		= -1			
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Damage			= 0		 
SWEP.Secondary.Automatic		= false		 
SWEP.Secondary.Ammo			= "none"

function SWEP:Initialize()

	self:SetWeaponHoldType( "melee2" )

end


SWEP.MissSound 				= Sound("weapons/tiggomods/DmC5/Osiris/sound1.wav")
SWEP.WallSound 				= Sound("weapons/tiggomods/DmC5/hitwall1.wav")

/*---------------------------------------------------------
PrimaryAttack
---------------------------------------------------------*/
function SWEP:PrimaryAttack()

	local tr = {}
	tr.start = self.Owner:GetShootPos()
	tr.endpos = self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 110 )
	tr.filter = self.Owner
	tr.mask = MASK_SHOT
	local trace = util.TraceLine( tr )

	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	if ( trace.Hit ) then

		if trace.Entity:IsPlayer() or string.find(trace.Entity:GetClass(),"npc") or string.find(trace.Entity:GetClass(),"prop_ragdoll") then
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1
			bullet.Damage = self.Primary.Damage
			self.Owner:FireBullets(bullet) 
		else
			self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
			bullet = {}
			bullet.Num    = 1
			bullet.Src    = self.Owner:GetShootPos()
			bullet.Dir    = self.Owner:GetAimVector()
			bullet.Spread = Vector(0, 0, 0)
			bullet.Tracer = 0
			bullet.Force  = 1000
			bullet.Damage = self.Primary.Damage
			self.Owner:FireBullets(bullet) 
			self.Weapon:EmitSound( self.WallSound )		
			util.Decal("ManhackCut", trace.HitPos + trace.HitNormal, trace.HitPos - trace.HitNormal)
		end
	else
		self.Weapon:EmitSound(self.MissSound,100,math.random(90,120))
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
	end
	
	timer.Simple( 0.05, function()
			self.Owner:ViewPunch( Angle( 0, 05, 0 ) )
	end )

	timer.Simple( 0.2, function()
			self.Owner:ViewPunch( Angle( 4, -05, 0 ) )
	end )
end

/*---------------------------------------------------------
Reload
---------------------------------------------------------*/
function SWEP:Reload()

	return false
end

/*---------------------------------------------------------
OnRemove
---------------------------------------------------------*/
function SWEP:OnRemove()

return true
end

/*---------------------------------------------------------
Holster
---------------------------------------------------------*/
function SWEP:Holster()

	return true
end

