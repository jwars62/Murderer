AddCSLuaFile()

local ENT = {}
ENT.Type = "anim"
function ENT:Initialize()

	local partent = self.Entity
	self.tracedata = partent:GetVar("tracedata",{couldnotfindtable = true})
	local data = self.tracedata --hurrr local variables are faster
	
	if data.couldnotfindtable then return end
	
	
	partent:SetMoveType(data.movetype)
	partent:PhysicsInitSphere(data.collisionsize, "default_silent")
	partent:SetCollisionBounds(Vector()*data.collisionsize*-1, Vector()*data.collisionsize)
	
	local phys = partent:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end
	
	partent:SetTrigger(true)
	partent:SetNotSolid(true)
	partent:SetCollisionGroup(data.mask)
	partent:DrawShadow(false)

	if data.worldcollide then
		partent:SetMoveType(data.movetype) 
	end
	
	
	if data.runonkill then
		timer.Simple(data.killtime, function() calculatedata(data, Entity(0)) end)
	else
		partent:Fire("kill", "", data.killtime )
	end
	
	
	
	
	partent:SetNetworkedString("model",data.model)
	partent:SetNetworkedBool("dodraw",data.dodraw)
	partent:SetNetworkedBool("doblur",data.doblur)
	partent:SetNetworkedBool("issprite",data.issprite)
	partent:SetNetworkedFloat("collisionsize",data.collisionsize)
	partent:SetNetworkedInt("rcolor",data.color.r)
	partent:SetNetworkedInt("bcolor",data.color.b)
	partent:SetNetworkedInt("gcolor",data.color.g)
	partent:SetNetworkedInt("acolor",data.color.a)
	
	self.Color = Color(255,255,255,255)

end


function ENT:Draw()

	
	local dodraw = dodraw or self.Entity:GetNetworkedBool("dodraw")
	if not dodraw then return false end
	
	
	local issprite = issprite or self.Entity:GetNetworkedBool("issprite")
	local doblur = doblur or self.Entity:GetNetworkedBool("doblur")
	local model = model or self.Entity:GetNetworkedString("model")
	local color = color or Color( self.Entity:GetNetworkedInt("rcolor",255), self.Entity:GetNetworkedInt("gcolor",255), self.Entity:GetNetworkedInt("bcolor",255), self.Entity:GetNetworkedInt("acolor",255) )
	local collisionsize = collisionsize or self.Entity:GetNetworkedFloat("collisionsize")*2
	
	
	if issprite then
	
		local pos = self.Entity:GetPos()
		local vel = self.Entity:GetVelocity()
		render.SetMaterial(Material(model))

		if doblur then
			local lcolor = render.GetLightColor( pos ) * 2
			lcolor.x = color.r * mathx.Clamp( lcolor.x, 0, 1 )
			lcolor.y = color.g * mathx.Clamp( lcolor.y, 0, 1 )
			lcolor.z = color.b * mathx.Clamp( lcolor.z, 0, 1 )
			
			
			for i = 1, 7 do
				local col = Color( lcolor.x, lcolor.y, lcolor.z, 200 / i )
				render.DrawSprite( pos + vel*(i*-0.004), collisionsize, collisionsize, col )
			end
		end
		
		render.DrawSprite(pos, collisionsize, collisionsize, color)

	else
	
		self.Entity:DrawModel() 
		
	end

	self.Entity:DrawShadow(false)
	
end

local lasthit = 0

local calculatedata = function(data,hitent)

	local collisionsize = data.collisionsize
	local speed = data.speed
	local curtime = CurTime()
	local filter = data.filter
	local ent = data.entid
	local entpos = ent:GetPos()
	local particleang = ent:GetVelocity():GetNormalized()

	
	if lasthit < curtime then
	lasthit = curtime + 14*collisionsize/speed
	else return end
	
	if hitent == Entity(0) then 
	hitent = ent
	else
		 
		if filter ~= {} then
			for k,v in pairs(filter) do
				if hitent == v then 
				return 
				end
			end
		end
	end
	
	
	local trace = {}
	local offsetvec = particleang*collisionsize
	
	trace.startpos = entpos - offsetvec*1.2
	trace.endpos = entpos + offsetvec*3
	trace.filter = filter
	trace.mask = data.mask
	
	local traceRes = util.TraceLine(trace)
		if not traceRes.Hit then 
			for i=1,5 do 
			trace.startpos = entpos - particleang*(collisionsize + 3*i)
			trace.endpos = entpos + particleang*(collisionsize + 18*i)
			traceRes = util.TraceLine(trace)
			if traceRes.Hit then break end
			end
		end
		
	
	traceRes.StartPos = data.startpos
	traceRes.particlepos = entpos
	traceRes.caller = ent
	traceRes.owner = data.owner
	traceRes.activator = hitent
	traceRes.tracedata = data
	traceRes.time = curtime - data.starttime
	
	--Run our function
	data.func(traceRes)

end

function ENT:PhysicsCollide(physdata, physobj)

end

function ENT:Touch(hitEnt)

	calculatedata(self.tracedata,hitEnt)

end 

function ENT:OnRemove()

end



function ENT:OnTakeDamage(dmginfo)

end


function ENT:Use(activator, caller)
	
end

scripted_ents.Register(ENT, "trace_particle", true)