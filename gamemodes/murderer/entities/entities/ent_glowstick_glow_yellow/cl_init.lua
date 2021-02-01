include("shared.lua")

function ENT:Initialize()
end

function ENT:Draw()
end

function ENT:Think()
	local rgba = self:GetColor();
    local dlight = DynamicLight( self:EntIndex() )
	if ( dlight ) then
		dlight.Pos = self:GetPos()
		dlight.r = 255
		dlight.g = 255
		dlight.b = 0
		dlight.Brightness = 0
		dlight.Size = 256
		dlight.Decay = 0
		dlight.DieTime = CurTime() + 0.05
	end
end