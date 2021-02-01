AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include('shared.lua')

ENT.BaseBulletModel = "models/hunter/misc/sphere025x025.mdl"

if SERVER then 
function ENT:Initialize()
self.Owner = self.Entity:GetOwner()
if !IsValid(self.Owner) then self:Remove() return end




self.Entity:SetModel(self.BaseBulletModel)
self.Entity:PhysicsInit( SOLID_VPHYSICS )
self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
self.Entity:SetSolid( SOLID_VPHYSICS )
self.Entity:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
self.Entity:DrawShadow( false )
self.Entity:GetPhysicsObject():EnableGravity( true )
self.Entity:SetModelScale(.05 )
local trail = util.SpriteTrail(self.Entity, 0,  Color(255,255,0), false, 1, 1, .03, .05 / ( .1 ) * 0.5, "trails/laser")
	self.Entity:SetColor( Color(255,255,0)) 
	self.Entity:SetMaterial("Models/effects/vol_light001")

	
end

function ENT:Think()
timer.Simple(4,function() if self:IsValid() then 
self.Entity:Remove() 
end end)

if self.Entity:WaterLevel() > 2  then

end

local phys = self.Entity:GetPhysicsObject()
if (phys:IsValid()) then
phys:EnableGravity(true)
end
end

function ENT:Explosion()
end


function ENT:PhysicsCollide(data, physobj)
--self.Entity:EmitSound(Sound("piss/piss.wav"))
timer.Simple(.01,function() if self:IsValid() then self.Entity:Remove() end end)
end

end
