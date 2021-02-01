AddCSLuaFile()

ENT.Type = "anim"
ENT.Spawnable 	= false

function ENT:Draw()
	if SERVER then return end
	
	if not self:GetNWEntity("broom_driver"):IsValid() then return end

	local ply = self:GetNWEntity("broom_driver")
	self.GetPlayerColor = function() return ply:GetPlayerColor() end

	self:DrawModel()
end

function ENT:Initialize()
	if CLIENT then return end
	
	self:DrawShadow(false)
	self:SetMoveType(MOVETYPE_NONE)
	self:SetSolid(SOLID_NONE)
end