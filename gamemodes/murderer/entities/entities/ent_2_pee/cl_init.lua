include('shared.lua')
language.Add("ent_mad_grenadelauncher", "Grenade")

function ENT:Draw()
self.Entity:DrawModel()
end

function ENT:Think()
end

function ENT:IsTranslucent()
return true
end

