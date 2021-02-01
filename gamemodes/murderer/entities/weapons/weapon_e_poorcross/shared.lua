AddCSLuaFile();

if CLIENT then
	SWEP.PrintName          = "weapon_e_poorcross"
   SWEP.Slot               = 2

   SWEP.ViewModelFlip      = false
   
   SWEP.IconLetter         = "B"
end

SWEP.Base                  = "weapon_base"

SWEP.Instructions = "Pray it!";

SWEP.WorldModel = "models/weapons/horrorween/w_cross.mdl";
SWEP.ViewModel = "models/weapons/horrorween/v_cross.mdl";
SWEP.HoldType = "melee";

SWEP.AdminSpawnable = true;
SWEP.Spawnable = true;
  
SWEP.Primary.DefaultClip = 0;
SWEP.Primary.Automatic = true;
SWEP.Primary.ClipSize = -1;
SWEP.Primary.Damage = 1;
SWEP.Primary.Delay = 0.65;
SWEP.Primary.Ammo = "";

SWEP.Secondary.DefaultClip = 0;
SWEP.Secondary.Automatic = false;
SWEP.Secondary.ClipSize = -1;
SWEP.Secondary.Delay = 1;
SWEP.Secondary.Ammo	= "";

SWEP.ViewModelFOV       = 50

SWEP.UseHands = true

function SWEP:DrawWorldModel()
	self:DrawModel()
end

function SWEP:Initialize()

	self:SetHoldType( "melee" )
	self:SetWeaponHoldType( "melee" )

end

function SWEP:Deploy()

end



-- A function to do the SWEP's hit effects.
function SWEP:DoHitEffects()

	local trace			= {}
		trace.start		= self.Owner:GetShootPos()
		trace.endpos	= self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 64 )
		trace.filter	= self.Owner
		
	local traceHit		= util.TraceLine( trace )
	
	if ( traceHit.Hit ) then
		self:SendWeaponAnim(ACT_VM_HITCENTER)
		self:EmitSound("totod/crosshit.wav")
	else
		self:SendWeaponAnim(ACT_VM_MISSCENTER)
		self:EmitSound("totod/re_all_sfx/KNIFE01.wav")
	end
end

-- Called when the player attempts to primary fire.
function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	
	self:DoHitEffects()
	
	local trace			= {}
		trace.start		= self.Owner:GetShootPos()
		trace.endpos	= self.Owner:GetShootPos() + ( self.Owner:GetAimVector() * 64 )
		trace.filter	= self.Owner
		
	local traceHit		= util.TraceLine( trace )

	
	if (traceHit.Hit) then
		
		util.ImpactTrace( traceHit, DMG_CLUB );
		
		if SERVER then
			self.Owner:TraceHullAttack( self.Owner:GetShootPos(), traceHit.HitPos, Vector( -16, -16, -16 ), Vector( 36, 36, 36 ), 20, DMG_CLUB, 1 );
		end

	end
	
	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
end

function SWEP:CanSecondaryAttack()
	return false
end

function util.ImpactTrace( pTrace, iDamageType, pCustomImpactName )
	if ( pTrace.HitSky ) then
		return
	end
	
	pCustomImpactName = pCustomImpactName or "Impact"
	
	local data = EffectData()
	data:SetOrigin( pTrace.HitPos )
	data:SetStart( pTrace.StartPos )
	data:SetSurfaceProp( pTrace.SurfaceProps )
	data:SetDamageType( iDamageType )
	data:SetHitBox( pTrace.HitBox )
	
	local pEntity = pTrace.Entity
	
	data:SetEntity( pEntity )
	
	if SERVER then
		data:SetEntIndex( pEntity:EntIndex() )
	end
	
	// Send it on its way
	util.Effect( pCustomImpactName, data )
end