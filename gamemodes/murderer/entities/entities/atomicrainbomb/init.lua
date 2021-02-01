AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( "shared.lua" )

function ENT:Initialize()
	self.Entity:SetModel( "models/props_phx/ball.mdl" )
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	self.Entity:SetUseType(SIMPLE_USE)
	self.Entity:SetMaterial("models/shiny")

	self.BeepTimer = 0
	self.SpeedRate = 1
	self.Beeps = 0
		
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
end

function ENT:Use()
	self.U = self.U or 0
	if self.U ~= 1 then
		--timer.Simple( 11, function() self:start() end )
		--timer.Simple( 16, function() self:finish() end ) 
		self.U = 1
		--self:beep()
	end
	print(self:GetClass())
	self:BeepFX()
end

function ENT:Think()
	if self.U == 1 and self.BeepTimer == 0 then
		self.BeepTimer = CurTime() + self.SpeedRate
		return
	end

	if self.BeepTimer < CurTime() and self.BeepTimer ~= 0 and self.U == 1 then
		self:beep()
		self.BeepTimer = CurTime() + self.SpeedRate
	end
end

function ENT:beep()
	self.Beeps = self.Beeps + 1
	
	if self.Beeps < 5 then
		self.SpeedRate = 1
	elseif self.Beeps < 8 then
		self.SpeedRate = 0.5
	else
		self.SpeedRate = 0.25
	end

	if self.Beeps == 17 then
		self:start()
		return
	end

	if self.Beeps == 30 then
		self:finish()
	end

	print(self.Beeps)

	if self.Beeps < 17 then
		self:BeepFX()
	end
end

function ENT:BeepFX()
	local angle = math.random(0, 1536)
	local color = Color(255,255,255)
	if(angle < 255 && angle >= 0) then
		color = Color(255,angle,0)
	end
	if(angle < 511 && angle >= 255) then
		color = Color(511-angle,255,0)
	end   
	if(angle < 767 && angle >= 511) then
		color = Color(0,255,angle-511)
	end
	if(angle < 1023 && angle >= 767) then
		color = Color(0,1023-angle,255)
	end 
	if(angle < 1279 && angle >= 1023) then
		color = Color(angle-1023,0,255)
	end
	if(angle < 1535 && angle >= 1279) then
		color = Color(255,0,1535-angle)
	end 
	if(angle > 1535) then
		color = Color(255,0,0)
	end
	self:EmitSound("hl1/fvox/beep.wav")
	self:SetColor(color)
end

function ENT:start()
	if !IsValid(self) then return end
	local pos = self:GetPos()

	self.glow1 = ents.Create("env_lightglow")
	self.glow1:SetKeyValue("rendercolor", "255 255 255")
	self.glow1:SetKeyValue("VerticalGlowSize", "500")
	self.glow1:SetKeyValue("HorizontalGlowSize", "500")
	self.glow1:SetKeyValue("MaxDist", "100")
	self.glow1:SetKeyValue("MinDist", "4000")
	self.glow1:SetKeyValue("HDRColorScale", "100")
	self.glow1:SetPos( pos + Vector(0,0,32) )
	self.glow1:Spawn()
	
	self.glow4 = ents.Create("env_lightglow")
	self.glow4:SetKeyValue("rendercolor", "255 255 255")
	self.glow4:SetKeyValue("VerticalGlowSize", "200")
	self.glow4:SetKeyValue("HorizontalGlowSize", "200")
	self.glow4:SetKeyValue("MaxDist", "500")
	self.glow4:SetKeyValue("MinDist", "0")
	self.glow4:SetKeyValue("HDRColorScale", "100")
	self.glow4:SetPos( pos + Vector(0,0,32) )
	self.glow4:Spawn()
	
	self.blastwave2 = ents.Create("blastwave2")
	self.blastwave2:SetPos( pos + Vector(0,0,32) )
	self.blastwave2:SetOwner(self)
	self.blastwave2:Spawn()

	self:SetNoDraw(true)
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:PhysicsDestroy()
	self:DrawShadow(false)
end

function ENT:finish()
	self.glow1:Remove()
	self.glow4:Remove()
	self.blastwave2:Remove()
	self:Remove()
end