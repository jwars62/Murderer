AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()   
	self:SetMoveType( MOVETYPE_NONE )
	self:SetSolid( SOLID_NONE )
	self:SetCollisionGroup( COLLISION_GROUP_NONE )
	self:DrawShadow(false)
--	self:SetModel("")
end
function ENT:Think()
--	local player = self:GetOwner()
	if self.Owner:IsBot() then self:SetColor(Color(0,255,0,255)) else
	self:SetColor( Color( self.Owner:GetInfo("gmod_glowsticks_red"), self.Owner:GetInfo("gmod_glowsticks_green"), self.Owner:GetInfo("gmod_glowsticks_blue"), 255) )
	end
--	self:SetMaterial(player:GetMaterial())
end