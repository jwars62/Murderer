--Include shared code
include('shared.lua')

--Clientside only code below here (it's exactly a copy of the base entity but with different text)

local Colors = {
	Black = Color(0,0,0),
	Black80 = Color(0,0,0,200),
	White = Color(255,255,255),
	White80 = Color(255,255,255,200),
	Yellow = Color(255,255,0),
}
local vector_up = Vector(0,0,1)
local vector_fwdy = Vector(0,1,0)
local vector_rightx = Vector(1,0,0)
local function OurDir(ent,vector)
	return ent:LocalToWorld(vector)-ent:LocalToWorld(vector_origin)
end

surface.CreateFont(
	"wt_rocketboots_font3",
	{
		font = "Verdana",
		size=18,
		weight = 500
	}
)

function ENT:Draw()
	--Draw our base
	self:DrawModel()
	
	--fade the whole thing by player distance
	local LP = LocalPlayer()
	local FullFadeDist = 400
	local FullVisDist = 300
	local PlayerDist = LP:GetShootPos():Distance(self:GetPos())
	local AlphaMultiplier = 1
	if PlayerDist>FullVisDist then
		if PlayerDist>FullFadeDist then
			AlphaMultiplier = 0
		else
			local Dp = PlayerDist-FullVisDist
			local P = Dp/(FullFadeDist-FullVisDist)
			AlphaMultiplier = 1 - math.Clamp(P, 0, 1)
		end
	end
	if AlphaMultiplier==0 then return end
	
	local OurUp = OurDir(self, vector_up)
	local OurFwd = OurDir(self, vector_fwdy)
	local OurRight = OurDir(self, vector_rightx)
	
	local Pos = self:GetPos()
	Pos = Pos+OurUp*self.ScreenOffsetZ
	Pos = Pos+OurRight*self.ScreenOffsetX
	Pos = Pos+OurFwd*self.ScreenOffsetY
	
	local Ang = self:GetAngles()
	Ang:RotateAroundAxis( OurRight, 90)
	
	local Scale = 8 --Increase this to fit more in the one space
	local iScale = 1/Scale
	
	cam.Start3D2D(Pos, Ang, iScale)
	
		surface.SetAlphaMultiplier(AlphaMultiplier)
	
		surface.SetDrawColor(Colors.Black)
		surface.SetTexture(0)
		surface.DrawRect(0,0,self.ScreenWidth*Scale,self.ScreenHeight*Scale)
		
		--helper for us to understand directions
		--[[surface.SetDrawColor(Color(255,0,0))
		surface.DrawRect(-5,-5,10,10)
		surface.SetDrawColor(Color(255,255,0))
		surface.DrawRect(0,0,10,10)]]
		
		draw.DrawText("Boot Remover", "wt_rocketboots_font1", --font 1 is defined in the base entity
			self.ScreenWidth*0.5*Scale, (self.ScreenHeight*0.5-5)*Scale,
			Colors.White,
			TEXT_ALIGN_CENTER,TEXT_ALIGN_CENTER)
		draw.DrawText("USE (E) to remove boots", "wt_rocketboots_font3", 
			self.ScreenWidth*0.5*Scale, (self.ScreenHeight*0.5+1)*Scale,
			Colors.Yellow,
			TEXT_ALIGN_CENTER)
	
		surface.SetAlphaMultiplier(1)
		
	cam.End3D2D()
	
end