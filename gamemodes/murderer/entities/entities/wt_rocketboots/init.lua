--Send files to client
AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

--Include shared code
include('shared.lua')

--Serverside only code below here

--This is pretty much the only function we need to define, the rest comes from the base entity
function ENT:Use(ply,acc,unk)
	ply:GiveRocketBoots(math.huge)
	self:Remove()
end