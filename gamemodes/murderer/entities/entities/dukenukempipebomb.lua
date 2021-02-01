AddCSLuaFile()

local e={}
e.RenderGroup = RENDERGROUP_TRANSLUCENT
e.Type			 = "anim"
e.PrintName		= "PipeBombv"
e.Author			= "Jvs"
e.Information		= ""
e.Category		= "Other"
e.Spawnable			= false
e.AdminSpawnable		= false
e.Detonated=false;
e.IsPipebomb=true;
function e:Initialize()
	if(SERVER)then
	self:SetModel( "models/Nirrti/Pipebomb/pipebomb.mdl" )		
	self:SetMoveType( MOVETYPE_VPHYSICS );
	self:PhysicsInit( SOLID_VPHYSICS );
	self:GetPhysicsObject():AddGameFlag( FVPHYSICS_NO_NPC_IMPACT_DMG );
	self:GetPhysicsObject():AddGameFlag( FVPHYSICS_NO_IMPACT_DMG );
	self:PhysWake()
	end
end

function e:OnTakeDamage(dmgfo)
	--we check if another pipebomb triggered us,there's no point in this,since the player blows up every pipebomb
	if IsValid(dmgfo:GetInflictor()) && dmgfo:GetInflictor():GetClass()==self:GetClass() then return end
	if !self.Detonated && dmgfo:GetDamage()>1 then
		self:Explode();
	end
end
function e:Explode()
	if self.Detonated then return end
	self.Detonated=true;
	local attacker=IsValid(self:GetOwner()) and self:GetOwner() or self
	util.BlastDamage( self,attacker,self:GetPos(),260,140 );
	util.ScreenShake( self:GetPos(), 25, 150.0, 1.0, 500 );
	local speed = self:GetPhysicsObject():GetVelocity()
	local effectdata = EffectData()
	effectdata:SetScale(127)
	effectdata:SetOrigin( self:GetPos())
	effectdata:SetMagnitude(128)
	local effectstring=(self:WaterLevel()>2) and "WaterSurfaceExplosion" or "HelicopterMegaBomb"
	util.Effect( effectstring, effectdata )
	local eff=EffectData();
	eff:SetOrigin(self:GetPos())
	for i=0,7 do
		util.Effect( "pipebombgib", eff )
	end
	//"BaseExplosionEffect.Sound"
	if self:WaterLevel()<2 then self:EmitSound("dukenukem3d/pipebomb/Pexplode.wav",100,100) end

	self:Remove();
end

function e:Touch(entity)
end
function e:PhysicsCollide( data, physobj )
 
	// Play sound on bounce
	if (data.Speed > 50 && data.DeltaTime > 0.2 ) then
		
		if data.HitEntity:IsWorld() then
			self:EmitSound( "dukenukem3d/pipebomb/Pbounce.wav")
			//self:EmitSound( "physics/metal/metal_barrel_impact_hard7.wav",100,255 )
			local phob=self:GetPhysicsObject();
			phob:AddVelocity( (data.HitNormal*-1) *(data.Speed/2.3))
		end
	end
end

scripted_ents.Register(e, "dukenukempipebomb")