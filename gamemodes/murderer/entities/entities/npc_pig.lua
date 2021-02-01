AddCSLuaFile()

ENT.PrintName		= "Pig"
ENT.Author			= "HobbyPsychopath" 
ENT.Information		= "A cute following pig!"
ENT.Spawnable			= true
ENT.AdminSpawnable		= false
ENT.Category = "Toybox Classics"

ENT.Base = "base_ai" 
ENT.Type = "ai" 
ENT.AutomaticFrameAdvance = true 

function ENT:SelectSchedule()
	local close = false
	local ply = player.GetAll()[1]
	local tbl = player.GetAll()
	for k,v in pairs(tbl) do
		if v:GetPos():Distance(self:GetPos()) < 500 then
			close = true
			ply = v
		end
	end

	if close and IsValid(ply) then
		self:SetLastPosition(ply:GetPos())
		self:SetSchedule(SCHED_FORCED_GO_RUN)
	end
end

if !SERVER then return end
function ENT:Initialize()
	self:SetModel( "models/animals/pig.mdl"  )
	--self:SetModel("models/Humans/Group01/Male_04.mdl")
	self:SetHullType( HULL_HUMAN )
	self:SetHullSizeNormal( )
	self:SetNPCState( NPC_STATE_SCRIPT )
	self:SetSolid(  SOLID_BBOX )
	self:CapabilitiesAdd( bit.bor(CAP_MOVE_GROUND, CAP_SQUAD) )
	self:SetUseType( SIMPLE_USE )
	self:DropToFloor()
	self:SetMaxYawSpeed( 5000 )
end

function ENT:OnTakeDamage()
	return false
end