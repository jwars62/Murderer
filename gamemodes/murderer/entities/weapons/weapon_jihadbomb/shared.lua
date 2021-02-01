SWEP.Author = "Doktor haus"
SWEP.DrawCrosshair = false
SWEP.Spawnable = true
SWEP.AdminSpawnable	= true
SWEP.HoldType = "slam"
SWEP.FiresUnderwater = true
SWEP.ViewModelFOV = 65
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = "models/weapons/cstrike/c_c4.mdl"
SWEP.WorldModel = "models/weapons/w_c4.mdl"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 3
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Think()
	if self.Owner:KeyDown( IN_USE ) then
		self:SetWeaponHoldType("camera")
	end								
	if self.Owner:KeyReleased( IN_USE ) then
		self:SetWeaponHoldType("slam")
	end
end

function SWEP:OnRemove()
return
end

function SWEP:Deploy()
    self.Weapon:SendWeaponAnim( ACT_VM_DEPLOY )
    self.Owner:GetViewModel():SetPlaybackRate(1)
	self.Owner:DoAnimationEvent(ACT_FLINCH_STOMACH)
end

function SWEP:Reload()
end   

function SWEP:Initialize()
    util.PrecacheSound("JihadBomb/alala.wav")
    self:SetWeaponHoldType("slam")
end

function SWEP:PrimaryAttack()
	local ply = self.Owner
    self.Weapon:SetNextPrimaryFire(CurTime() + 2.5)
	self.Weapon:SetNextSecondaryFire( CurTime() + 2.5 )
    self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
    self.Owner:DoAnimationEvent(ACT_GMOD_GESTURE_TAUNT_ZOMBIE)
	self.Owner:EmitSound( "JihadBomb.Detonate" )
    if (SERVER) && ply:Alive() then
        timer.Simple(2.4, function()
		if !ply:Alive() then return end
		self:Asplode()
        end )
    end
end

function SWEP:Asplode()
    local k, v
    local ent = ents.Create( "env_explosion" )
    ent:SetPos( self.Owner:GetPos() )
    ent:SetOwner( self.Owner )
    ent:Spawn()
    ent:SetKeyValue( "iMagnitude", "256" )
    ent:Fire( "Explode", 0, 0 )
    ent:EmitSound( "BaseExplosionEffect.Sound", 100, 100 )
    self.Owner:Kill( )
    self.Owner:AddFrags( -1 )
end

function SWEP:SecondaryAttack()	
	self.Weapon:SetNextSecondaryFire( CurTime() + 1 )
    self.Owner:DoAnimationEvent(ACT_GMOD_GESTURE_WAVE)
    local TauntSound = Sound( "JihadBomb.Taunt" )
    self.Weapon:EmitSound( TauntSound )
end