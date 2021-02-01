AddCSLuaFile()

ENT.Type   = "anim"
ENT.Spawnable	= true
ENT.Category		= "Toybox Classics"
ENT.PrintName           = "Bouncy Gnome"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT

ENT.Colors = {
    Color( 0, 0, 255, 255 ),
    Color( 255, 0, 0, 255 ),
    Color( 0, 255, 0, 255 ),
    Color( 255, 0, 255, 255 ),
    Color( 255, 255, 0, 255 ),
    Color( 0, 255, 255, 255 )
}


function ENT:Initialize()

    if ( SERVER ) then
        self.IsSpamming = true
        self.Entity:SetModel( "models/props_junk/gnome.mdl" )
        self.Entity:PhysicsInitSphere( 22, "metal_bouncy" )
        self.Entity:SetCollisionBounds( Vector( -16, -16, -16 ), Vector( 16, 16, 16 ) )
        
            
        
         local color = table.Random( self.Colors )
        self.Trail = util.SpriteTrail(self, 0, color, false, 20, 10, 1, 0.1, "trails/smoke.vmt")
        
        print("Please use the phys gun to make him bounce :D ")
        
         
            
      
            
    end
    
end


function ENT:SpawnFunction( ply, tr )

    if ( !tr.Hit ) then return end
    
    local SpawnPos = tr.HitPos + tr.HitNormal * 16
    
    local ent = ents.Create( ClassName )
        ent:SetPos( SpawnPos )
    ent:Spawn()
    ent:Activate()
    
    return ent
    
    
    
end

// Copy here and paste! You cheeky monkey!

function ENT:PhysicsCollide( data, physobj )
    
    


    if (data.Speed > 80 && data.DeltaTime > 0.2 ) then
        
            self.Entity:EmitSound("vo/npc/male01/pain0"..math.random(1,9)..".wav", 70, 200) 
 
      

        
    end
        
    end
function ENT:Draw()
    
    if not CLIENT then return end
    self.Entity:DrawModel()
    
    local Pos = self:GetPos()
    local Ang = self:GetAngles()
    
    surface.SetFont("HUDNumber5")
    local TextWidth = surface.GetTextSize("Bounce me :D")
    
    Ang:RotateAroundAxis(Ang:Up(), 90)
    
    cam.Start3D2D(Pos + Ang:Up() * -11.5, Ang, 0.11)
    draw.WordBox(2, -TextWidth*0.5, -30, "Bounce me :D", "HUDNumber5", Color(140, 0, 0, 100), Color(255,255,255,255))
    cam.End3D2D()
end