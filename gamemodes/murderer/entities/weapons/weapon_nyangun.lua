
AddCSLuaFile()
AddCSLuaFile( "effects/jrules_nyan_tracer.lua" )
AddCSLuaFile( "effects/jrules_nyan_bounce.lua" )

SWEP.Slot = 2
SWEP.SlotPos = 0
SWEP.DrawWeaponInfoBox = false

SWEP.Base = "weapon_base"
SWEP.PrintName = "NyanCat Gun"
SWEP.Category = "JeremyRules Sweps"
SWEP.ViewModel = "models/weapons/c_smg1.mdl"
SWEP.WorldModel = "models/weapons/w_smg1.mdl"
SWEP.Spawnable = true
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.ViewModelFOV = 54
SWEP.UseHands = true
SWEP.HoldType = "smg"

SWEP.Primary.ClipSize = 1
SWEP.Primary.Delay = 0.1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.Delay = 0.5
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:PrimaryAttack()
	if ( !self:CanPrimaryAttack() ) then return end

	if ( self.Owner:IsNPC() ) then
		self:EmitSound( "weapons/nyan/nya" .. math.random( 1, 2 ) .. ".wav", 100, math.random( 60, 80 ) )
	else
		if ( self.LoopSound ) then
			self.LoopSound:ChangeVolume( 1, 0.1 )
		else
			self.LoopSound = CreateSound( self.Owner, Sound( "weapons/nyan/nyan_loop.wav" ) )
			if ( self.LoopSound ) then self.LoopSound:Play() end
		end
		if ( self.BeatSound ) then self.BeatSound:ChangeVolume( 0, 0.1 ) end
	end

	if ( IsFirstTimePredicted() ) then
	
		local bullet = {}
		bullet.Num = 1
		bullet.Src = self.Owner:GetShootPos()
		bullet.Dir = self.Owner:GetAimVector()
		bullet.Spread = Vector( 0.01, 0.01, 0 )
		bullet.Tracer = 1
		bullet.Force = 0
		bullet.Damage = 8
		//bullet.AmmoType = "Ar2AltFire" -- For some extremely stupid reason this breaks the tracer effect
		bullet.TracerName = "jrules_nyan_tracer"
		self.Owner:FireBullets( bullet )

		self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	end

	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay )
	
	self:Idle()
end

function SWEP:SecondaryAttack()
	if ( !self:CanSecondaryAttack() ) then return end
	
	if ( IsFirstTimePredicted() ) then
		self:EmitSound( "weapons/nyan/nya" .. math.random( 1, 2 ) .. ".wav", 100, math.random( 85, 100 ) )

		local bullet = {}
		bullet.Num = 6
		bullet.Src = self.Owner:GetShootPos()
		bullet.Dir = self.Owner:GetAimVector()
		bullet.Spread = Vector( 0.10, 0.1, 0 )
		bullet.Tracer = 1
		bullet.Force = 0
		bullet.Damage = 10
		//bullet.AmmoType = "Ar2AltFire"
		bullet.TracerName = "jrules_nyan_tracer"
		self.Owner:FireBullets( bullet )

		self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
	end

	self:SetNextPrimaryFire( CurTime() + self.Secondary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Secondary.Delay ) 
	
	self:Idle()
end

--[[function SWEP:Reload()
	if ( !self.Owner:KeyPressed( IN_RELOAD ) ) then return end
	if ( self:GetNextPrimaryFire() > CurTime() ) then return end

	if ( SERVER ) then
		local ang = self.Owner:EyeAngles()
		local ent = ents.Create( "ent_nyan_bomb" )
		if ( IsValid( ent ) ) then
			ent:SetPos( self.Owner:GetShootPos() + ang:Forward() * 28 + ang:Right() * 24 - ang:Up() * 8 )
			ent:SetAngles( ang )
			ent:SetOwner( self.Owner )
			ent:Spawn()
			ent:Activate()
			
			local phys = ent:GetPhysicsObject()
			if ( IsValid( phys ) ) then phys:Wake() phys:AddVelocity( ent:GetForward() * 1337 ) end
		end
	end
	
	self:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	self:EmitSound( "weapons/nyan/nya" .. math.random( 1, 2 ) .. ".wav", 100, math.random( 60, 80 ) )
	
	self:SetNextPrimaryFire( CurTime() + 1 )
	self:SetNextSecondaryFire( CurTime() + 1 ) 
	
	self:Idle()
end]]

function SWEP:DoImpactEffect( trace, damageType )
	local effectdata = EffectData()
	effectdata:SetStart( trace.HitPos )
	effectdata:SetOrigin( trace.HitNormal + Vector( math.Rand( -0.5, 0.5 ), math.Rand( -0.5, 0.5 ), math.Rand( -0.5, 0.5 ) ) )
	util.Effect( "jrules_nyan_bounce", effectdata )

	return true
end

function SWEP:FireAnimationEvent( pos, ang, event )
	return true
end

function SWEP:KillSounds()
	if ( self.BeatSound ) then self.BeatSound:Stop() self.BeatSound = nil end
	if ( self.LoopSound ) then self.LoopSound:Stop() self.LoopSound = nil end
	timer.Destroy( "rb655_idle" .. self:EntIndex() )
end

function SWEP:OnRemove()
	self:KillSounds()
end

function SWEP:OnDrop()
	self:KillSounds()
end

function SWEP:Deploy()
	self:SendWeaponAnim( ACT_VM_DRAW )
	self:SetNextPrimaryFire( CurTime() + self:SequenceDuration() )

	if ( CLIENT ) then return true end
	
	self:Idle()

	self.BeatSound = CreateSound( self.Owner, Sound( "weapons/nyan/nyan_beat.wav" ) )
	if ( self.BeatSound ) then self.BeatSound:Play() end

	return true
end

function SWEP:Holster()
	self:KillSounds()
	return true
end

function SWEP:Think()
	if ( self.Owner:IsPlayer() && ( self.Owner:KeyReleased( IN_ATTACK ) || !self.Owner:KeyDown( IN_ATTACK ) ) ) then
		if ( self.LoopSound ) then self.LoopSound:ChangeVolume( 0, 0.1 ) end
		if ( self.BeatSound ) then self.BeatSound:ChangeVolume( 1, 0.1 ) end
	end
end

function SWEP:DoIdle()
	self:SendWeaponAnim( ACT_VM_IDLE )
	timer.Adjust( "rb655_idle" .. self:EntIndex(), self:SequenceDuration(), 0, function()
		if ( !IsValid( self ) ) then timer.Destroy( "rb655_idle" .. self:EntIndex() ) return end
		self:SendWeaponAnim( ACT_VM_IDLE )
	end )
end

function SWEP:Idle()
	if ( CLIENT || !IsValid( self.Owner ) ) then return end
	timer.Create( "rb655_idle" .. self:EntIndex(), self:SequenceDuration(), 1, function()
		if ( !IsValid( self ) ) then return end
		self:DoIdle()
	end )
end

if ( SERVER ) then return end

killicon.Add( "weapon_nyangun", "nyan/killicon", color_white )

SWEP.WepSelectIcon = Material( "nyan/selection.png" )

function SWEP:DrawWeaponSelection( x, y, w, h, a )
	surface.SetDrawColor( 255, 255, 255, a )
	surface.SetMaterial( self.WepSelectIcon )
	
	local size = math.min( w, h )
	surface.DrawTexturedRect( x + w / 2 - size / 2, y, size, size )
end
