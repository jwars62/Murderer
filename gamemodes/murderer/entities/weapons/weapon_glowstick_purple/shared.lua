if ( CLIENT ) then
	language.Add ("ent_glowstick_fly", "Glow Stick")
	language.Add ("glowsticks_ammo", "Glow Sticks")
	language.Add ("cleanup_glowsticks", "Glow Sticks")
	language.Add ("cleaned_glowsticks", "Glow Sticks are gone!")
  	SWEP.DrawAmmo			= false
	SWEP.DrawCrosshair		= true
	SWEP.ViewModelFOV		= 35
	SWEP.ViewModelFlip		= false
	SWEP.CSMuzzleFlashes	= false
	SWEP.HoldType			= "slam"	
	SWEP.PrintName			= "Glow Stick Purple"
	SWEP.Author				= "Patrick Hunt"
end

SWEP.Author					= "Patrick Hunt"
SWEP.Contact				= "patrick07hunt@gmail.com"
SWEP.Purpose				= ""
SWEP.Instructions			= "Use primary attack to drop a glow stick and secondary to throw."
SWEP.HoldType				= "slam"
SWEP.Category				= "Glow Sticks"

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true

SWEP.ViewModel				= "models/weapons/c_glowstick.mdl"
SWEP.WorldModel				= "models/glowstick/stick.mdl"
SWEP.UseHands				= false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= 5
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "glowsticks"
SWEP.Primary.Delay			= 2

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Delay		= 2

function SWEP:Think()
end

function SWEP:Initialize()
	util.PrecacheSound("glowstick/glowstick_snap.wav");
	util.PrecacheSound("glowstick/glowstick_shake.wav");
	self:SetWeaponHoldType( self.HoldType )
end

function SWEP:Think()
	if self.Owner:IsBot() then self:SetColor(Color(255,0,255,255)) else -- Bots create a shipload of errors since they don't have any client vars on them so let's set them all green (or i'm just stupid)
	self:SetColor(Color(255, 0, 255, 255)) -- Paints world model in real time
	end
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW);
	self.Weapon:SetNextPrimaryFire(CurTime() + 1.75)
   return true
end

function SWEP:Reload()
	return true
end

function SWEP:PrimaryAttack()
	if ( self.Weapon:Ammo1() <= 0 ) then return end
	self.Weapon:SendWeaponAnim( ACT_VM_SECONDARYATTACK )
	self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:TakePrimaryAmmo(1)
		timer.Simple(0.5, function()
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
			if SERVER then
					local ent = ents.Create("ent_glowstick_fly")
					ent:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector() * 16))
					ent:SetAngles(self.Owner:EyeAngles())
					if self.Owner:IsBot() then ent:SetColor(Color(255,0,255,255)) else
					ent:SetColor( Color( 255, 0, 255, 255) )
					end
					ent:Spawn()
					ent:Activate()
				local phys = ent:GetPhysicsObject()
				phys:SetVelocity(self.Owner:GetAimVector() * 125)
				phys:AddAngleVelocity(Vector(math.random(-1000,1000),math.random(-1000,1000),math.random(-1000,1000)))
			end
		end)
		timer.Simple(1, function()
		self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
		end)
end

function SWEP:SecondaryAttack()
	if ( self.Weapon:Ammo1() <= 0 ) then return end
	self.Weapon:SendWeaponAnim( ACT_VM_THROW )
	self.Weapon:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	self:TakePrimaryAmmo(1)
		timer.Simple(0.5, function()
		self.Owner:SetAnimation( PLAYER_ATTACK1 )
			if SERVER then
					local ent = ents.Create("ent_glowstick_fly")
					ent:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector() * 16))
					ent:SetAngles(self.Owner:EyeAngles())
					if self.Owner:IsBot() then ent:SetColor(Color(255,0,255,255)) else
					ent:SetColor( Color( 255, 0, 2555, 255) )
					end
					ent:Spawn()
					ent:Activate()
				local phys = ent:GetPhysicsObject()
				phys:SetVelocity(self.Owner:GetAimVector() * 600)
				phys:AddAngleVelocity(Vector(math.random(-1000,1000),math.random(-1000,1000),math.random(-1000,1000)))
			end
		end)
		timer.Simple(1, function()
		self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
		end)
end

function SWEP:PreDrawViewModel( vm )
	Material("models/glowstick/glow"):SetVector("$color2", Vector(255, 0, 255) )
end

function SWEP:PostDrawViewModel( vm )
	Material("models/glowstick/glow"):SetVector("$color2", Vector(1, 1, 1) )
end

function SWEP:Holster()
	local worldmodel = ents.FindInSphere(self.Owner:GetPos(),0.6)
	for k, v in pairs(worldmodel) do 
		if v:GetClass() == "ent_glowstick_glow_purple" and v:GetOwner() == self.Owner then
		end
	end
return true
end

function SWEP:OnRemove()
	return true
end