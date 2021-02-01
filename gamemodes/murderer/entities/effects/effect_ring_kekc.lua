AddCSLuaFile()

function EFFECT:Init(data)
	self.Start = data:GetOrigin()
	self.Ang = data:GetAngles()

	self.Emitter = ParticleEmitter(self.Start)
	
	for i = 1, 300 do
		self.Ang:RotateAroundAxis(self.Ang:Forward(), i)

		local p = self.Emitter:Add("particle/particle_glow_04_additive", self.Start)

		p:SetDieTime(0.5)
		p:SetStartAlpha(255)
		p:SetEndAlpha(0)
		p:SetStartSize(1)
		p:SetEndSize(3)
		p:SetRoll(math.Rand(-10, 10))
		p:SetRollDelta(math.Rand(-10, 10))

		p:SetVelocity(self.Ang:Up() * math.random(20, 25))
		
		p:SetColor(math.random(0, 255), math.random(0, 255), math.random(0, 255))
	end
	
	self.Emitter:Finish()
end

function EFFECT:Think()
	return false
end

function EFFECT:Render()
end





