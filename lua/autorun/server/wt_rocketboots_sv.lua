do --resource/files
	resource.AddWorkshop('237544369')
end

do --player meta

	local PLY = FindMetaTable("Player")
	
	function PLY:GiveRocketBoots(intTime)
		intTime = intTime or 15
		
		self._wt_RocketBootsEquipped = true
		self._wt_RocketBootsEndTime = CurTime()+intTime
		
		if not IsValid(self._wt_RocketBootsEffect) then
			local e = ents.Create("wt_rocketboots_thinker")
			e:SetPos(self:GetPos()+Vector(0,0,5))
			e:SetPlayer(self)
			e:Spawn()
			e:SetParent( self )
			self:DeleteOnRemove( e )
			self._wt_RocketBootsEffect = e
		end
		
	end
	function PLY:RemoveRocketBoots()
		self._wt_RocketBootsEquipped = false
		self._wt_RocketBootsEndTime = CurTime()
		
		if IsValid(self._wt_RocketBootsEffect) then
			SafeRemoveEntity(self._wt_RocketBootsEffect)
			self._wt_RocketBootsEffect = nil
		end
	end
	
	function PLY:HasRocketBoots()
		return self._wt_RocketBootsEquipped
	end
	
	hook.Add("Think", "RemoveRocketBoots", function()
		for k,v in pairs(player.GetAll()) do
			if v:HasRocketBoots() then
				if v._wt_RocketBootsEndTime<CurTime() then
					v:RemoveRocketBoots()
				end
			end
		end
	end)

end --player meta