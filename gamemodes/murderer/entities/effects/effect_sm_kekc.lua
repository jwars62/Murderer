AddCSLuaFile()

function EFFECT:Init(data)
	self.Start = data:GetOrigin()
	
	self.Emitter = ParticleEmitter(self.Start)
	
	if math.random(1, 11) == 2 then
		local p = self.Emitter:Add("particle/warp1_warp", self.Start)

		p:SetDieTime(0.5)
		p:SetStartAlpha(255)
		p:SetEndAlpha(0)
		p:SetStartSize(5)
		p:SetEndSize(30)
		p:SetRoll(math.Rand(-10, 10))
		p:SetRollDelta(math.Rand(-10, 10))

		p:SetVelocity(VectorRand() * 25)
		p:SetGravity(Vector(0, 0, math.random(0, 300)))
	end
	
	self.Emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end





