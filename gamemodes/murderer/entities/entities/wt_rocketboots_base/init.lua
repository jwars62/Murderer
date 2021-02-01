--Send files to client
AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

--Include shared code
include('shared.lua')

--Serverside only code below here

function ENT:SpawnFunction( ply, tr, ClassName )

	if not tr.Hit then return end

	local Pos = tr.HitPos + tr.HitNormal * 30
	local Ang = ply:EyeAngles()
	Ang.p = 0
	Ang.y = Ang.y - 90

	local ent = ents.Create( ClassName )
	ent:SetCreator( ply )
	ent:SetPos( Pos )
	ent:SetAngles( Ang )
	ent:Spawn()
	ent:Activate()

	ent:DropToFloor()

	return ent

end

function ENT:Use(ply,acc,unk)
	ply:GiveRocketBoots(15)
	self:Remove()
end