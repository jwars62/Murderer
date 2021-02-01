ENT.Type = "anim"
ENT.Base = "base_entity"
 
ENT.PrintName		= "Rocket Boots (Base)"
ENT.Author			= "Whiterabbit"
ENT.Contact			= "whiterabbit"
ENT.Category		= "Whiterabbit"
ENT.Purpose			= "Rocket boots mother fucker"
ENT.Instructions	= "This is the base for other entities to use. It's a case you pick up that equips rocket boots to the player."
ENT.Spawnable		= false --the base entity isn't spawnable, you should inherit from it instead of modifying it 

function ENT:Initialize()
	
	--Setup our model and shit
	self:SetModel("models/props_c17/suitcase_passenger_physics.mdl")
	
	--Make our physics box
	if SERVER then
		self:PhysicsInit(SOLID_VPHYSICS)
		local phys = self:GetPhysicsObject()
		phys:Wake()
		
		self:SetUseType( SIMPLE_USE )
	end
	
	--Vgui shit
	if CLIENT then
		local mins = Vector(-12.767012, -3.586730, -18.074169) --got these values by measuring the model we are using
		local maxs = Vector(12.767011, 3.586730, 0.931436)
		
		self.ScreenWidth = math.abs(mins.x)+math.abs(maxs.x)-2
		self.ScreenHeight = math.abs(mins.z)+math.abs(maxs.z)-4
		
		self.ScreenOffsetX = -self.ScreenWidth/2
		self.ScreenOffsetY = -3.6 --magic numbers fuck yeah (it's slightly bigger than the the y componenet of ours mins/maxs, found by testing)
		self.ScreenOffsetZ = -2 --these just push the screen outside of our model
	end
		
end