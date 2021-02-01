--Include shared code
include('shared.lua')

do --effect (should be moved to its own file)

	local EFF = {}
	
	function EFF:Init(d)
		local ply = d:GetEntity()
		if not IsValid(ply) then return end
		
		self:SetPos(ply:GetPos())
		
		self.DieTime = CurTime()+1
		
		--Feet sparkles
		self.Emitter = ParticleEmitter(ply:GetPos())
		self.Player = ply
	end
	
	function EFF:Think()
		--Will we die?
		self.Dead = self.DieTime<CurTime() or self.Player:IsOnGround()
		
		--Did we die?
		if self.Dead then
		
			self.Emitter:Finish()
			
		else
		
			local Up = self.Player:EyeAngles():Up()
		
			local Foot1 = self.Player:LookupBone("ValveBiped.Bip01_R_Foot")
			local Foot2 = self.Player:LookupBone("ValveBiped.Bip01_L_Foot")
			local Foot1Pos = self.Player:GetBonePosition(Foot1)
			local Foot2Pos = self.Player:GetBonePosition(Foot2)

			local p
			
			--RIGHT FOOT FLAME
			p = self.Emitter:Add("particles/flamelet"..math.random(1,5), Foot1Pos + Up*-3)
			p:SetDieTime(1+math.random()*0.5)
			p:SetStartAlpha(200+math.random(55))
			p:SetEndAlpha(0)
			p:SetStartSize(8+math.random()*3)
			p:SetEndSize(0)
			p:SetRoll(math.random()*3)
			p:SetRollDelta(math.random()*2-1)
			
			--RIGHT FOOT SMOKE
			p = self.Emitter:Add("particles/smokey", Foot1Pos + Up*-3)
			p:SetDieTime(1+math.random()*0.5)
			p:SetStartAlpha(180+math.random(55))
			p:SetEndAlpha(0)
			p:SetStartSize(8+math.random()*3)
			p:SetEndSize(2+math.random()*10)
			p:SetRoll(math.random()*3)
			p:SetRollDelta(math.random()*2-1)
			p:SetVelocity( Up*-10 )
			
			--LEFT FOOT FLAME
			p = self.Emitter:Add("particles/flamelet"..math.random(1,5), Foot2Pos + Up*-3)
			p:SetDieTime(1+math.random()*0.5)
			p:SetStartAlpha(200+math.random(55))
			p:SetEndAlpha(0)
			p:SetStartSize(8+math.random()*3)
			p:SetEndSize(0)
			p:SetRoll(math.random()*3)
			p:SetRollDelta(math.random()*2-1)
			
			--LEFT FOOT SMOKE
			p = self.Emitter:Add("particles/smokey", Foot2Pos + Up*-3)
			p:SetDieTime(1+math.random()*0.5)
			p:SetStartAlpha(180+math.random(55))
			p:SetEndAlpha(0)
			p:SetStartSize(8+math.random()*3)
			p:SetEndSize(2+math.random()*10)
			p:SetRoll(math.random()*3)
			p:SetRollDelta(math.random()*2-1)
			p:SetVelocity( Up*-10 )
			
		end
		
		return not self.Dead
	end
	
	function EFF:Render()
	
	end
	
	effects.Register(EFF,"wt_rocketboots_effect")

end

--Clientside only code below here

function ENT:Draw()
	--Draw our base
	--self:DrawModel()
end