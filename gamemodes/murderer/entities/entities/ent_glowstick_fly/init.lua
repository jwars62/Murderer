AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	self:SetModel("models/glowstick/stick.mdl") 
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	if phys:IsValid() then phys:Wake() end
	if GetConVar("gmod_glowsticks_lifetime_infinite"):GetBool() == false then
		local lifetime = GetConVar("gmod_glowsticks_lifetime"):GetFloat()
		timer.Simple(lifetime, function() if self:IsValid() then self:Remove() else return end end)
	end
end

function ENT:SpawnFunction( ply, tr )
    if ( !tr.Hit ) then return end
    local ent = ents.Create("ent_glowstick_fly")
    ent:SetPos( tr.HitPos + tr.HitNormal * 16 )
    ent:Spawn()
    ent:Activate()
    return ent
end
ents.Create("prop_physics")

function ENT:OnTakeDamage(dmg)
	self.Entity:Remove()
end

function ENT:Use(ply)
	ply:GiveAmmo( 1, "glowsticks", true )
	self.Entity:Remove()
end