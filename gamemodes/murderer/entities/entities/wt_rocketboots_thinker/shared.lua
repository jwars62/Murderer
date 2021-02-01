ENT.Type = "anim"
ENT.Base = "base_entity"
 
ENT.PrintName		= "The effect for the rocket boots"
ENT.Author			= "Whiterabbit"
ENT.Contact			= "whiterabbit"
ENT.Purpose			= "Rocket boots mother fucker"
ENT.Instructions	= "Spawned via lua."
ENT.Spawnable		= false

ENT.ThinkRate = 1/25

function ENT:AddBoostEffect(ply,force)

	if self.NextBoostEffect<CurTime() or force then

		local ed = EffectData()
		ed:SetEntity(ply)
		util.Effect("wt_rocketboots_effect", ed, true, true)
		
		self.NextBoostEffect = CurTime()+0.95
		
	end

end

function ENT:SetupDataTables()
	self:NetworkVar("Entity",0,"Player")
end

function ENT:Initialize()
	
	--Setup our model and shit
	self:SetModel("models/props_c17/suitcase_passenger_physics.mdl")
	
	--Make our physics box
	if SERVER then
		--self:PhysicsInit(SOLID_VPHYSICS)
		--local phys = self:GetPhysicsObject()
		--phys:Wake()
		--
		--self:SetUseType( SIMPLE_USE )
	end
	
	if CLIENT then
		self:SetNoDraw(true)
	end
	
	self.NextBoostEffect = CurTime()
		
	--print("Initialised rocketboots effect")

end

function ENT:OnRemove()
	if self.Sound then
		self.Sound:Stop()
	end
	if self.Sound2 then
		self.Sound2:Stop()
	end
	if IsValid(self:GetPlayer()) then --I can't think of any reason we would want to stay like this, so we'll set the player back to not rotationg
		self:GetPlayer():SetAllowFullRotation(false)
	end
end

function ENT:Think()

	--Manage NextThink for the client?
	--[[if CLIENT then
		if not self.LastThink then
			self.LastThink = 0
		end
		local curtime = CurTime()
		local dt = curtime-self.LastThink
		if dt<self.ThinkRate then --thinking too fast
			--print("Thinking too fast, dt=",dt,"needed = ",self.ThinkRate)
			return --exit for now, until we think some more
		end
		--print("Boots thinking",1/dt)
		self.LastThink = curtime
	end]]

	self:NextThink(CurTime()+0.01) --Think as fast as possible on the server, because thats what the client does
	
	--Make our sound
	if not self.Sound then
		self.Sound = CreateSound(self, "PhysicsCannister.ThrusterLoop")
		self.Sound:Play()
		self.Sound:ChangeVolume(0,0)
	end
	if not self.Sound2 then
		self.Sound2 = CreateSound(self, "WT_RocketBoots.Thrust")
		self.Sound2:Play()
		self.Sound2:ChangeVolume(0,0)
	end

	--Check the player is valid
	local ply = self:GetPlayer()
	if not IsValid(ply) then return true end
	
	--Default for when its not set yet
	if self.Boosting == nil then
		self.Boosting = false
		self.Sound:ChangeVolume(0,0)
		self.Sound2:ChangeVolume(0,0)
	end
	
	--Are we starting or stopping boosting
	if not self.Boosting  then
		if (not ply:IsOnGround()) and ply:KeyDown(IN_JUMP) then
			self.Boosting = true
			self.Sound:ChangeVolume(1,0.25)
			self.Sound2:ChangeVolume(0.8,0.25)
			self:AddBoostEffect(ply,true)
			self.NextBoostEffect = CurTime()+0.95
		end
	else
		--we were boosting, are still boosting?
		if (not ply:KeyDown(IN_JUMP)) or ply:IsOnGround() then
			self.Boosting = false
			self.Sound:ChangeVolume(0,0.25)
			self.Sound2:ChangeVolume(0,0.25)
		end
	end
	
	--Thinking time for velocity
	if not self.LastThink then
		self.LastThink = CurTime()
	end
	local Dti = 0 --This would be 1 if thinking was exactly on time. When thinking gets slower, this gets larger, so we should apply the same force every time
	if CurTime()>=self.LastThink+self.ThinkRate then
		local Dt = CurTime()-self.LastThink
		Dti = Dt/self.ThinkRate
		--print(Dti)
		self.LastThink = CurTime()
	end
	
	--We are flying
	if self.Boosting then
		
		ply:SetAllowFullRotation(true)
		
		--Only apply velocity if we are past our thinking time (dti is zero until we hit our think above)
		if Dti>0 then
			ply:SetVelocity( (39*Dti) * (ply:EyeAngles():Up()) )
		end
		
		self:AddBoostEffect(ply)
		
	else
		if ply:IsOnGround() then
			ply:SetAllowFullRotation(false)
		end
	end
	
	return true
	
end