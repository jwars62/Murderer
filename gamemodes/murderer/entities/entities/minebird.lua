AddCSLuaFile()

ENT.Type 			= "anim"
ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.Category = "Toybox Classics"
ENT.PrintName = "Mine!"
ENT.Author = "Atomic Taco"
ENT.Information = ""
ENT.AutomaticFrameAdvance = true

hook.Add( "ShouldCollide", "MineCollide", function( ent1, ent2 )
    if ent1.Bird and ent2:GetClass( ) == "prop_physics" or
        ent1:GetClass( ) == "prop_physics" and ent2.Bird then
        
        return false
    end
end )

if CLIENT then
    ENT.RenderGroup = RENDERGROUP_BOTH
    
    function ENT:Draw( )
        self.Entity:DrawModel( )
    end
    
    function ENT:DrawTranslucent( )
        self:Draw( )
    end
end

if SERVER then
    hook.Add( "PlayerSpawnedProp", "MinePropOwner", function( ply, mdl, ent )
        ent.Owner = ply
    end )
    
    hook.Add( "PlayerSpawnedNPC", "MinePropOwner", function( ply, npc )
        npc.Owner = ply
    end )
    
    function ENT:Initialize( )
        self.Entity:SetModel( "models/Seagull.mdl" )
        self.Entity:PhysicsInit( SOLID_VPHYSICS )
        self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
        self.Entity:SetSolid( SOLID_VPHYSICS )
        self.Entity:DrawShadow( false )
        
        local phys_obj = self.Entity:GetPhysicsObject( )
        
        if phys_obj:IsValid( ) then
            phys_obj:Wake( )
        end
        
        self.Entity:StartMotionController( )
        self.MovementTable = { }
        self.Speed = math.random( 200, 400 )
        
        self.NextMine = CurTime( )
        
        self.Target = nil
    end
    
    function ENT:Think( )
        if not IsValid( self.Target ) then
            for k, v in pairs( ents.FindByClass( "prop_physics" ) ) do
                if IsValid(v.Owner) and v.Owner:IsPlayer() then
                    self.Target = v
                    self.TargetAdd = VectorRand( ) * Vector( 10, 10, 10 )
                    break
                end
            end
        end
        
        local seq = self.Entity:LookupSequence( "Fly" )
        local seq2 = self.Entity:LookupSequence( "Idle01" )
        
        if self.Entity:GetSequence( ) ~= seq and IsValid( self.Target ) then
            self.Entity:ResetSequence( seq )
        elseif self.Entity:GetSequence( ) ~= seq2 and not IsValid( self.Target ) then
            self.Entity:ResetSequence( seq2 )
        end
        
        local speed = self.Entity:GetVelocity( ):Length( )
        self.Entity:SetPlaybackRate( self.Speed / 200 )
        
        if CurTime( ) > self.NextMine then
            if IsValid( self.Target ) then
                self.Entity:EmitSound( "mine" .. math.random( 1, 4 ) .. ".wav", 511 )
            end
            
            self.NextMine = CurTime( ) + 1
        end
        
        self:NextThink( CurTime( ) )
        return true
    end
    
    function ENT:PhysicsSimulate( phys, dtime )
        phys:Wake( )
        
        if not IsValid( self.Target ) then
            self.MovementTable.secondstoarrive = 0.1
            self.MovementTable.pos = self.Entity:GetPos( ) - Vector( 0, 0, self.Speed )
            self.MovementTable.angle = Angle( 180, 0, 180 )
            self.MovementTable.maxangular = 5000
            self.MovementTable.maxangulardamp = 10000
            self.MovementTable.maxspeed = self.Speed
            self.MovementTable.maxspeeddamp = 10000
            self.MovementTable.dampfactor = 0.8
            self.MovementTable.teleportdistance = 0
            self.MovementTable.deltatime = dtime
            
            phys:ComputeShadowControl( self.MovementTable )
            
            return
        end
        
        self.MovementTable.secondstoarrive = 0.1
        self.MovementTable.pos = self.Target:GetPos( ) + self.TargetAdd
        self.MovementTable.angle = ( self.Entity:GetPos( ) - self.MovementTable.pos ):Angle( ) + Angle( 180, 0, 180 )
        self.MovementTable.maxangular = 5000
        self.MovementTable.maxangulardamp = 10000
        self.MovementTable.maxspeed = self.Speed
        self.MovementTable.maxspeeddamp = 10000
        self.MovementTable.dampfactor = 0.8
        self.MovementTable.teleportdistance = 0
        self.MovementTable.deltatime = dtime
        
        phys:ComputeShadowControl( self.MovementTable )
    end
    
    function ENT:SpawnFunction( ply, tr )
        local ent = ents.Create( ClassName )
        ent:SetPos( tr.HitPos + tr.HitNormal * 16 )
        ent:Spawn( )
        ent:Activate( )
        ent.Master = ply
        ent.Bird = true
        
        return ent
    end
end