AddCSLuaFile( )
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Friendly Gnome"
ENT.Author = "Tater_Bonanza & fixed by Hds46"
ENT.Spawnable = true
ENT.AdminOnly = true
ENT.Category = "Toybox Entities"

local function CanEntityBeSetOnFire( ent )

	if ( ent:GetClass() == "sent_friendgnome" ) then return true end

	return false

end

properties.Add( "ignite_gnome", {
	MenuLabel = "Don't ignite me!",
	Order = 1200,
	MenuIcon = "icon16/fire.png",

	Filter = function( self, ent, ply )

		if ( !IsValid( ent ) ) then return false end
		if ( ent:IsPlayer() ) then return false end
		if ( !CanEntityBeSetOnFire( ent ) ) then return false end

		return !ent:IsOnFire()
	end,

	Action = function( self, ent )

		self:MsgStart()
			net.WriteEntity( ent )
		self:MsgEnd()

	end,

	Receive = function( self, length, player )

		local ent = net.ReadEntity()

		if ( !self:Filter( ent, player ) ) then return end

		ent:Ignite( 360 )

	end

} )


if CLIENT then
language.Add("sent_friendgnome","Friendly Gnome")
end

-- I wonder if this really does anything
local pairs = pairs
local unpack = unpack
local table = table
local math = math

-- Taken from valve matrix library
local function Vecs2Ang( vf, vr, vu )
    local fx, fy, fz = vf.x, vf.y, vf.z
    local lx, ly, lz = vr.x, vr.y, vr.z
    local uz = vu.z

    local xyDist = math.sqrt( fx * fx + fy * fy )

    local ang = Angle()
        -- enough here to get angles?
    if xyDist > 0.001 then
        -- (yaw) in our space, forward is the X axis
        ang.y =  math.deg( math.atan2( fy, fx ) )

        -- (pitch)
        ang.p = math.deg( math.atan2( -fz, xyDist ) )

        -- (roll)
        ang.r =  math.deg( math.atan2( lz, uz ) )
    else -- forward is mostly Z, gimbal lock-
        -- (yaw) forward is mostly z, so use right for yaw
       ang.y =  math.deg( math.atan2( -lx, ly ) )

        -- (pitch)
       ang.p =  math.deg( math.atan2( -fz, xyDist ) )

        -- Assume no roll in this case as one degree of freedom has been lost (i.e. yaw == roll)
        ang.r = 0
    end

    return ang
end

local function roll( p )
    return math.random() < p
end

local function randerval( t )
    return math.Rand( t[1], t[2] )
end

---------------------
------ SERVER -------
---------------------
if SERVER then

-- Base sounds
ENT.sndDrawKnife = Sound( "weapons/knife/knife_deploy1.wav" )
ENT.sndStab = Sound( "weapons/knife/knife_stab.wav" )
ENT.sndLaser = Sound( "k_lab.teleport_spark" )
ENT.sndLaserCharge = Sound( "ambient/levels/labs/teleport_mechanism_windup1.wav" )
ENT.sndEvilLaugh = Sound( "ravenholm.madlaugh02" )
ENT.sndWindup2 = Sound( "ambient/levels/labs/teleport_mechanism_windup2.wav" )
ENT.sndWindup4 = Sound( "ambient/levels/labs/teleport_mechanism_windup4.wav" )
ENT.sndWindup5 = Sound( "ambient/levels/labs/teleport_mechanism_windup5.wav" )
ENT.sndShit = Sound( "citadel.br_ohshit" )
ENT.sndTimeMachine = Sound( "HL1/ambience/port_suckin1.wav" )
ENT.sndBreathe = Sound( "k_lab.teleport_breathing" )
ENT.sndParticleSuck = Sound( "HL1/ambience/particle_suck2.wav" )
ENT.sndPop = Sound( "ambient/water/drip3.wav" )
ENT.sndDeath = Sound( "vo/npc/Barney/ba_ohshit03.wav" )

-- Base parameters
local THINK_DELAY = 0.2 -- delay between thinking

-- Minimum distances (help decide behaviour)
local DIST_ATTACK = 120 -- Will attack if closer than this
local DIST_CREEP = 1500 -- Will do creepy things if closer than this
local DIST_STALK = 2500 -- Will creep toward player if closer than this

-- Probabilities (per frame)
local PROB_ATTACK = 0.6
local PROB_CREEP = 0.5
local PROB_TELEPORT = 0.7
local PROB_TELEPORT_RANDOM = 0.17
local PROB_FIND_VICTIM = 0.001

-- Cooldowns (won't think for this long after action)
local COOLDOWN_TELEPORT = {1,3}
local COOLDOWN_TELEPORT_RANDOM = {1,15}
local COOLDOWN_ATTACK = {4,8}
local COOLDOWN_VICTIMDEATH = {10,20}
local COOLDOWN_REMOVE = {2,30}

local STAB_MAX_DIST = 80

-- Teleport
local TELEPORT_MAX_DIST_FROM_PLR = 800
local TELEPORT_MIN_DIST_FROM_PLR = 75
local TELEPORT_MAX_TRIES = 20
local TELEPORT_SPREAD_DIST = {250,550} -- try again this distance away if we can't teleport somewhere
local TELEPORT_RANDOM_TRIES = 15
local TELEPORT_RANDOM_SPREAD = {2000,12000}

-- Stalking
local STALK_DISTANCE_FRACTION = 0.65

-- Sounds
local CREEP_SPACING = {8,15} -- Minimum time before playing another sound
local CREEP_DISTANCE_FRACTION = 0.65


ENT.CREEPY_SOUNDS = {
    "k_lab.teleport_breathing",
    "d3_citadel.stalker_breathing",
    "npc_citizen.behindyou01",
    "npc_citizen.behindyou02",
    "song_radio1",
    "d1_trainstation.playground_memory",
    "npc/zombie_poison/pz_breathe_loop1.wav",
    "ambient/levels/citadel/strange_talk10.wav",
    "ambient/levels/citadel/strange_talk3.wav",
    "ambient/levels/citadel/strange_talk4.wav",
    "ambient/levels/citadel/strange_talk8.wav",
    "ambient/levels/citadel/citadel_ambient_scream_loop1.wav",
    "ambient/voices/cough2.wav",
    "ambient/voices/crying_loop1.wav",
    "ambient/creatures/town_scared_breathing1.wav",
    "ambient/atmosphere/tone_quiet.wav",
    "music/stingers/HL1_stinger_song7.mp3",
    "music/stingers/industrial_suspense1.wav",
    "music/stingers/industrial_suspense2.wav",
    "NPC_AntlionGuard.GrowlIdle",
    "NPC_Strider.Creak",
    "ambient/atmosphere/cave_hit3.wav",
    "ambient/atmosphere/cave_hit4.wav",
    "ambient/atmosphere/cave_hit6.wav",
    "ambient/atmosphere/hole_hit1.wav",
    "ambient/atmosphere/hole_hit5.wav",
    "ambient/atmosphere/tone_alley.wav"
}
for k,v in pairs( ENT.CREEPY_SOUNDS ) do
    ENT.CREEPY_SOUNDS[ k ] = { snd = Sound( v ), dur = SoundDuration( v ) }
end

ENT.PAIN_SOUNDS = {}
for i = 1, 9 do
    ENT.PAIN_SOUNDS[ i ] = Sound( "vo/ravenholm/monk_pain0" .. i .. ".wav" )
end

function ENT:IsPossesedGnome()
    return true
end

function ENT:Initialize()
    self:SetModel( "models/props_junk/gnome.mdl" )
    self:PhysicsInit( SOLID_VPHYSICS )

    local phys = self:GetPhysicsObject()      
    if phys:IsValid() then  
        phys:SetInertia( Vector( 0.2, 0.2, 0.2 ) )
        phys:Wake()      
    end
    
    -- Get and store our bounding vertices for LOS checking and stuff
    local maxs = self:OBBMaxs()
    local mins = self:OBBMins()
    local center = self:OBBCenter()
    
    self.Height = mins.z
    self.Width = 0.5 * math.sqrt( (maxs.x-mins.x)*(maxs.x-mins.x) + (maxs.y-mins.y)*(maxs.y-mins.y) )
    self.Radius = self:BoundingRadius()
    
    self.Vertices = {
        mins,
        Vector( maxs.x, mins.y, mins.z ),
        Vector( mins.x, maxs.y, mins.z ),
        Vector( mins.x, mins.y, maxs.z ),
        maxs,
        Vector( mins.x, maxs.y, maxs.z ),
        Vector( maxs.x, mins.y, maxs.z ),
        Vector( maxs.x, maxs.y, mins.z ),
        center
    }
    
    self.CurSound = CreateSound( self, "" ) -- The CSoundPatch we are currently playing
    self.NextEmitSound = 0
    
    self.Attack = self.KnifeAttack
    self.InAttack = false
    self.AttackTime = CurTime()
    
    self.IsBeingCreepy = false
    self.WakeTime = CurTime()
    
    self.NextEmitPain = CurTime()
    self.HP = 30
end

function ENT:SetVictim( plr )
    self.Victim = plr
    self:SetNWEntity( "Victim", plr )
    self.Demonization = 0
end

function ENT:HasVictim()
    return IsValid( self.Victim )
end

-- Choose a random player to torture
function ENT:FindVictim()
    if not roll( PROB_FIND_VICTIM ) then return end
    local players = player.GetAll()
    self:SetVictim( players[ math.random( 1, #players ) ] )
end

function ENT:HasLOS( ent )
    for _,vec in pairs( self.Vertices ) do
        if ent:VisibleVec( ent:LocalToWorld( vec ) ) then return true end
    end
    return false
end

function ENT:CanVictimSeePos( pos, ang )
    ang = ang or Angle( 0, 0, 0 )
    local viewent, viewpos, viewangles, maxcos
    
    if self.Victim:IsPlayer() then
        viewent = self.Victim:GetViewEntity() -- In case he's looking through a camera or something
        if viewent == self.Victim then
            viewpos = self.Victim:EyePos() 
            viewangles = self.Victim:EyeAngles()
        else
            if viewent:GetClass() == "gmod_cameraprop" and viewent.dt.entTrack == self then 
                return true -- bug hack for camera
            end
            
            viewpos = viewent:GetPos()    
            viewangles = viewent:GetAngles()
        end
        maxcos = math.cos( math.Clamp( self.Victim:GetFOV(), 40, 180 ) * 0.0176 ) -- 0.0176 is a bit more than pi/180
    else
        viewent = self.Victim
        viewpos = viewent:EyePos()
        viewangles = viewent:GetAngles()
        maxcos = 0
    end
    
    for _,vec in pairs( self.Vertices ) do
        vec = LocalToWorld( pos, ang, vec, Angle( 0, 0, 0 ) )
        if ( vec - viewpos ):GetNormalized():Dot( viewangles:Forward() ) < maxcos then return false end
    end
    
    local trace = {
        start = viewpos,
        mask = MASK_OPAQUE,
        filter = { viewent, self }
    }
    local tr
    local los = false
    for _,vec in pairs( self.Vertices ) do
        vec = LocalToWorld( pos, ang, vec, Angle( 0, 0, 0 ) )
        trace.endpos = vec
        tr = util.TraceLine( trace )
        for i = 1,10 do 
            if tr.StartSolid then
                table.insert( trace.filter, tr.Entity )
                tr = util.TraceLine( trace )
            else break end
        end
        
        los = los or tr.Fraction > 0.999
    end
    
    if not los then return false end

    return true
end

local function dropknife( self )
    if not IsValid( self ) then return end
    if not IsValid( self.Knife ) then return end
    
    local wepos = self:LocalToWorld( self.Knife:GetLocalPos() )
    self.Knife:SetParent( nil )
    self.Knife:SetPos( wepos ) -- Dunno why this works
    self.Knife:Fire( "kill", "", "0.5" )
end
ENT.KnifeAttack = {
    delay = 1.3,
    mindelay = 0.6,

    start = function( self )
        self.Knife = ents.Create( "prop_physics" ) 
        self.Knife:SetModel( "models/weapons/w_knife_t.mdl" )
        self.Knife:SetOwner( self )
        self.Knife:SetParent( self )
        self.Knife:SetLocalPos( Vector( 5, 0, 15 ) )
        self.Knife:SetLocalAngles( Angle( 10, 0, 0 ) )
        self.Knife:Spawn()
        
        self:EmitSound( self.sndDrawKnife, 500, 100 )
    end,
    
    stop = dropknife,
    
    attack = function( self )
        if self.Victim:GetPos():Distance( self:GetPos() ) > DIST_ATTACK then
            dropknife( self )
            return
        end
        self:Free()
        local phys = self:GetPhysicsObject()
        phys:EnableMotion( true )
        local stabvec = ( self.Victim:EyePos() - self:GetPos() ) * 2 + Vector( 0, 0, 100 )
        phys:AddVelocity( stabvec )
        

		local dmginfo = DamageInfo()
        dmginfo:SetDamage( 99999 )
        dmginfo:SetAttacker( self )
        dmginfo:SetDamageForce( self:GetForward()*(3000*10) ) 
        dmginfo:SetInflictor( (IsValid(self.Knife)) and self.Knife or self )
        self.Victim:TakeDamageInfo( dmginfo )
        self:EmitSound( self.sndStab, 500, 100 )
        timer.Simple( 2,function() dropknife(self) end)
    end
}
ENT.LaserAttack = {
    delay = 4.4,
    mindelay = 1.5,

    start = function( self )
        self.LaserSound = CreateSound( self.Victim, self.sndLaserCharge )
        self.LaserSound:PlayEx( 1, 100 )
        umsg.Start( "fgnome_lasercharge" )
            umsg.Entity( self )
            umsg.Bool( true )
        umsg.End()
    end,
    
    stop = function( self )
        if self.LaserSound then
            self.LaserSound:Stop()
        end
        umsg.Start( "fgnome_lasercharge" )
            umsg.Entity( self )
            umsg.Bool( false )
        umsg.End()
    end,
    
    attack = function( self )
        if not self:HasLOS( self.Victim ) then return end
        local dmginfo = DamageInfo()
        dmginfo:SetAttacker( self )
        dmginfo:SetInflictor( self )
        dmginfo:SetDamage( 99999 )
        dmginfo:SetDamageType( DMG_DISSOLVE )
        self.Victim:TakeDamageInfo( dmginfo )
        self.LaserSound:Stop()
        local snd = CreateSound( self.Victim, self.sndLaser )
        snd:SetSoundLevel( 0.27 )
        snd:PlayEx( 1, 100 )
    end
}

local function secret_stopsounds( self )
    self.InSecretAttack = false
    if self.Windup2 then
        self.Windup2:Stop()
    end
    if self.Windup4 then
        self.Windup4:Stop()
    end
    if self.Windup5 then
        self.Windup5:Stop()
    end
end

local sndBoom = Sound( "explode_1" )
local sndBigBoom = Sound( "d3_citadel.timestop_explosion" )
local sndBoomThunder = Sound( "k_lab.teleport_debris" )
local sndMadLaugh = Sound( "ravenholm.madlaugh03" )
local sndHax = Sound( "vo/npc/male01/hacks01.wav" )
local sndZap = Sound( "ambient.electrical_random_zap_1" )

local Grav_Original
local function MEGASPLODE( attacker, victim, pos )
    print( "MEGASPLODE MODE ACTIVATED" )
    if not attacker:IsValid() then attacker = GetWorldEntity() end

    if victim:IsValid() then
        pos = victim:GetPos()
    
        victim:SetGravity( 1 )
    
        victim:SetDSP( 0 )
        victim:EmitSound( sndHax, 160, 100 )

        local dmginfo = DamageInfo()
        dmginfo:SetAttacker( attacker )
        dmginfo:SetInflictor( attacker )
        dmginfo:SetDamage( 99999 )
        dmginfo:SetDamageType( DMG_ALWAYSGIB )
        victim:TakeDamageInfo( dmginfo )
    end

    util.BlastDamage( attacker, attacker, pos, 2000, 999 )
    
    local psys = ents.Create( "info_particle_system" )
    psys:SetPos( pos )
    psys:SetKeyValue( "effect_name", "explosion_silo" )
    psys:Spawn()
    psys:Activate()
    psys:Fire( "start", "", 0 )
    psys:Fire( "kill", "", 20 )
    
    local fent = ents.Create( "env_fade" )
    fent:SetKeyValue( "duration", "1" )
    fent:SetKeyValue( "holdtime", "0" )
    fent:SetKeyValue( "renderamt", "255" )
    fent:SetKeyValue( "rendercolor", "255 245 230" )
    fent:SetKeyValue( "spawnflags", 1 )
    fent:Fire( "kill", 1 )
    fent:Fire( "Fade", 0 )
    
    util.ScreenShake( pos, 10, 20, 2, 3000 )
    
    sound.Play( sndMadLaugh, pos, 160, 100 )
    sound.Play( sndBoom, pos, 160, 100 )
    sound.Play( sndBoomThunder, pos, 160, 100 )
end
ENT.SecretAttack = {
    delay = 15.7,
    mindelay = 0.001,

    start = function( self )
        self.InSecretAttack = true
    
        self.Windup2 = CreateSound( self.Victim, self.sndWindup2 )
        self.Windup4 = CreateSound( self.Victim, self.sndWindup4 )
        self.Windup5 = CreateSound( self.Victim, self.sndWindup5 )
        self.Windup2:PlayEx( 1, 100 )

        timer.Simple( 1.3, function() if self:IsValid() and self.InSecretAttack then self.Windup4:PlayEx( 1, 100 ) end end )
        timer.Simple( 7.4, function() if self:IsValid() and self.InSecretAttack then self.Windup5:PlayEx( 1, 100 ) end end )
        umsg.Start( "fgnome_secretcharge" )
            umsg.Entity( self )
            umsg.Bool( true )
        umsg.End()
    end,
    
    stop = function( self )
        self.InSecretAttack = false
        secret_stopsounds( self )
        umsg.Start( "fgnome_secretcharge" )
            umsg.Entity( self )
            umsg.Bool( false )
        umsg.End()
    end,
    
    attack = function( self )
        self.InSecretAttack = false
        secret_stopsounds( self )
        self.Shit = CreateSound( self.Victim, self.sndShit )
        
        -- Disable gravity and send shit flying
        Grav_Original = Grav_Original or physenv.GetGravity()
        physenv.SetGravity( vector_origin )
        for k,ent in pairs( ents.FindInSphere( self.Victim:GetPos(), 8000 ) ) do 
            if not ent:IsPlayer() and ent ~= self then
                ent:NextThink( CurTime() + 7 )
                phys = ent:GetPhysicsObject()
                if phys:IsValid() then
				    phys:EnableMotion( true )
                    phys:AddVelocity( Vector( math.Rand(-1,-1),math.Rand(-1,-1),math.Rand(0.7,1) ):GetNormalized() * math.Rand(10,20) )
                    phys:AddAngleVelocity( Vector( math.Rand( -10, 10 ), math.Rand( -10, 10 ), math.Rand( -10, 10 ) ) )
                end    
            end
        end
        
        self:Free()
        phys = self:GetPhysicsObject()
        if phys:IsValid() then
            phys:AddVelocity( Vector( math.Rand(-1,-1),math.Rand(-1,-1),math.Rand(4,6) ):GetNormalized() * math.Rand(4,6) )
            phys:AddAngleVelocity( Vector( math.Rand( -8, 8 ), math.Rand( -8, 8 ), math.Rand( -8, 8 ) ) )
        end
        self.Victim:SetGravity( -0.001 )
        self.Victim:SetLocalVelocity( Vector( math.Rand(-1,-1),math.Rand(-1,-1),math.Rand(0.7,1) ):GetNormalized() * math.Rand(4,8) )
        
        sound.Play( self.sndTimeMachine, self:GetPos(), 160, 100 )
        
        self.sndbreath = CreateSound( self.Victim, self.sndBreathe )
        self.sndbreath:Play()
        self.Victim:SetDSP( 21 )
        
        
        local s = CurTime()
        local tname = "fgnome_badasslightning" .. self:EntIndex()
        timer.Create( tname, 0.15, 0, function()
            if CurTime() - s > 7 then timer.Remove( tname ) return end
            if math.random() > 0.2 then return end
            if self:IsValid() then
                local fx = EffectData()
                fx:SetEntity( self )
                fx:SetOrigin( self:LocalToWorld( self:OBBCenter() ) )
                fx:SetStart( self:LocalToWorld( self:OBBCenter() ) )
                fx:SetScale( 10 )
                fx:SetMagnitude( 100 )
                util.Effect( "TeslaHitboxes", fx )
            end
            sound.Play( sndZap, self:GetPos(), 100, 100 )
        end)
        timer.Simple( 8, function() if Grav_Original then physenv.SetGravity( Grav_Original ) Grav_Original = nil end end )
        timer.Simple( 6, function() self.sndbreath:Stop() end)
        timer.Simple( 7, function() MEGASPLODE(self,self.Victim,self.Victim:GetPos()) end)
        timer.Simple( 3.5, function() self.Shit:PlayEx( 1, 43 ) end)
        timer.Simple( 10, function() 
            if self:IsValid() then 
                local fx = EffectData()
                fx:SetOrigin( self:LocalToWorld( self:OBBCenter() ) )
                fx:SetScale( 5 )
                fx:SetMagnitude( 5 )
                util.Effect( "AR2Impact", fx )
                self:TeleportRandom()
            end
        end)
    end
}

function ENT:StartAttack( attack )
    self:KillSounds() -- So they don't loop annoyingly or anything

    self.Attack = attack
    self.InAttack = true
    self.AttackTime = CurTime()
    attack.start( self )
    
    local tname = "fgnome_attack" .. self:EntIndex()
    timer.Create( tname, attack.delay, 1, function()
        if not IsValid( self ) then return end
        if not self.InAttack then return end
        self.Attack.attack( self )
        self.InAttack = false
        if self:CheckRTCamera( self:GetPos() ) or self:CheckRTCamera( self.Victim:GetPos() )  then
            self:BlackOutRTCamera( 3 )
        end
        if self.Victim:Health() <= 0 then
            self:PlayDead()
            self:SleepFor( randerval( COOLDOWN_VICTIMDEATH ) )
            self.sndLaugh = CreateSound( self.Victim, self.sndEvilLaugh )
            timer.Simple( 2, function(ent)
                self.sndLaugh:PlayEx( 1, 48 )
                if self:IsValid() then
                    local fx = EffectData()
                    fx:SetOrigin( self:LocalToWorld( self:OBBCenter() ) )
                    fx:SetScale( 5 )
                    fx:SetMagnitude( 5 )
                    util.Effect( "AR2Impact", fx )
                    self:TeleportRandom()
					self:Remove()
                end
            end)
        end
    end )
end

function ENT:StopAttack()
    if not self.InAttack then return end
    
    timer.Remove( "fgnome_attack" .. self:EntIndex() )
    
    self.Attack.stop( self )
    self.InAttack = false
    self:SleepFor( randerval( COOLDOWN_ATTACK ) )
end

function ENT:AttackCritical() -- It's too late mwahahaha
    return self.InAttack and CurTime() > self.AttackTime + self.Attack.mindelay
end

-- Remove all constraints, velocity
function ENT:Free()
    constraint.RemoveAll( self )
    self:SetParent( nil )
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:EnableMotion( false )
        phys:EnableMotion( true )
    end
end

-- Teleports to the exact pos and normal
function ENT:Relocate( pos, normal )
    normal = normal or util.TraceLine{ start = pos, endpos = pos - Vector( 0, 0, self.Height ), filter = self, mask = MASK_SOLID }.HitNormal
    if normal:Dot( vector_up ) < 0.8 then return false end
    if util.TraceEntity( { start = pos, endpos = pos, filter = self, mask = MASK_SOLID }, self ).Hit then return false end
    
    -- Calculate spawn pos
    local spawnpos = pos + normal * ( self.Height + 1 )
    -- Calculate spawn angle
    local spawnang 
    if IsValid( self.Victim ) then
        local f = ( self.Victim:GetPos() - spawnpos )
        f = f - f:Dot( normal ) * normal
        f:Normalize()
        spawnang = Vecs2Ang( f, normal:Cross( f ), normal )
        
        if self:CanVictimSeePos( spawnpos, spawnang ) then return false end
        
        -- Checkif the RT camera can see us
        if self:CheckRTCamera( self:GetPos() ) or self:CheckRTCamera( spawnpos ) then
            self:BlackOutRTCamera( 0.8 )
        end
        
    else
        spawnang = normal:Cross( VectorRand() ):Angle()
    end
    
    -- Get rid of all constraints (they mess up SetPos)
    self:Free()

    self:SetPos( spawnpos )
    self:SetAngles( spawnang )
    
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:EnableMotion( false )
    end
    return true
end

-- Attempts to teleport near the given position
function ENT:TeleportToPos( pos )


    for i=1, TELEPORT_MAX_TRIES do
        
        local tr = util.TraceLine(
            {
                start     = pos,
            endpos     = pos - Vector( 0, 0, 64),
                filter     = { self, self.Kinfe },
                mask     = MASK_NPCSOLID
            } )
        
        local spawnpos = tr.HitPos + Vector( 0, 0, self.Width + 8 )
        
        if util.PointContents( spawnpos ) then
            
            self:SetPos( spawnpos )
			local phys = self:GetPhysicsObject()
            if phys:IsValid() then
            phys:EnableMotion( false )
            end
			if IsValid(self.Victim) then
			local x = self:GetPos().x - self.Victim:GetPos().x
            local y = self:GetPos().y - self.Victim:GetPos().y
            local fullAng = (90/(math.abs(x)+math.abs(y)))*x
            if y > 0 then
            fullAng = -(fullAng) -180
            end
            self:DropToFloor()
            self:SetAngles(Angle(0,fullAng+90,0) )
			end
            
            -- Jostle it a bit in case it's stuck
            local phys = self:GetPhysicsObject()
            phys:ApplyForceCenter( VectorRand() * 2 )
            break
            
        end
        
        pos = pos + Vector( math.Rand( -20, 20 ), math.Rand( -20, 20 ), math.Rand( -5, 5 ) )
        
    end
        
end

-- Teleport onto an entity
function ENT:TeleportToEntity( ent )
    local radius = ent:BoundingRadius()
    local top = ent:LocalToWorld( ent:OBBCenter() ) + Vector( 0, 0, radius )
    
    local trace = {
        mask    = MASK_SOLID,
        filter     = { self }
    }
    local tr
    
    for i = 1, TELEPORT_RANDOM_TRIES do
        trace.start = top + VectorRand():GetNormalized() * math.Rand( 0, radius )
        trace.endpos = trace.start - Vector( 0, 0, 2 * radius )
        tr = util.TraceLine( trace )
        if tr.Entity == ent and self:Relocate( tr.HitPos, tr.HitNormal ) then
            local phys = self:GetPhysicsObject()
            if phys:IsValid() then
                phys:EnableMotion( true )
            end
            constraint.Weld( self, ent, 0, tr.PhysicsBone, 0, true )
            return true
        end
    end
    
    return false
end

function ENT:TeleportBehindVictim()
    local plraim = self.Victim:EyeAngles():Forward() + 0.2 * VectorRand()
    plraim.z = 0
    plraim:Normalize()
    
    local plrpos = self.Victim:EyePos()
    local tr = util.TraceLine( {
        start     = plrpos - plraim * TELEPORT_MIN_DIST_FROM_PLR,
        endpos     = plrpos - plraim * TELEPORT_MAX_DIST_FROM_PLR,
        mask    = MASK_SOLID,
        filter     = { self, self.Victim },
    } )
    
    local hitpos = tr.HitPos + tr.HitNormal * ( self.Width + 1 )
    local telepos = tr.StartPos + ( hitpos - tr.StartPos ) * math.random()
    
    if self:TeleportToPos( telepos ) then
        self:SleepFor( randerval( COOLDOWN_TELEPORT ) )
        return true
    end
    return self:TeleportRandom()
end

-- Teleport towards the victim
function ENT:CreepForward(Disp)
    if self:TeleportToPos( self:GetPos() + Disp * CREEP_DISTANCE_FRACTION) then
        self:SleepFor( randerval( COOLDOWN_TELEPORT ) )
        return true
    end
    return false
end

-- Teleport to random location
function ENT:TeleportRandom( startpos )
    startpos = startpos or self:GetPos()
    local dist
    local maxdist = 0
    local curpos = startpos
    local testpos
    local bnonsolid = false
    for i = 1, TELEPORT_RANDOM_TRIES do
        dist = randerval( TELEPORT_RANDOM_SPREAD )
        testpos = curpos - startpos
        testpos.z = 0
        testpos:Normalize()
        testpos = testpos + Vector( math.Rand(-1,1), math.Rand(-1,1), math.Rand(-0.15,0.15) ):GetNormalized()
        testpos:Normalize()
        testpos = curpos + testpos * dist
        if util.PointContents( testpos ) and MASK_SOLID == 0 then
            bnonsolid = true
        elseif util.PointContents( testpos + Vector( 0, 0, 0.4 * dist ) ) and MASK_SOLID == 0 then
            testpos = testpos + Vector( 0, 0, 0.4 * dist )
            bnonsolid = true
        elseif util.PointContents( testpos + Vector( 0, 0, -0.4 * dist ) ) and MASK_SOLID == 0 then
            testpos = testpos + Vector( 0, 0, -0.4 * dist )
            bnonsolid = true
        end
        
        if bnonsolid then
            dist = testpos:Distance( startpos )
            if dist > maxdist then
                maxdist = dist
                curpos = testpos
            end
        end
        bnonsolid = false
    end
    
    if self:TeleportToPos( curpos ) then
        self:SleepFor( randerval( COOLDOWN_TELEPORT_RANDOM ) )
        return true
    end
    return false
end


function ENT:EmitCreepySounds()
    if CurTime() < self.NextEmitSound then return end
    
    self:KillSounds()
    local sndtab = self.CREEPY_SOUNDS[ math.random( 1, #self.CREEPY_SOUNDS ) ]

    self.CurSound = CreateSound( self.Victim, sndtab.snd )
    self.CurSound:PlayEx( 1, 100 )

    self.NextEmitSound = CurTime() + randerval( CREEP_SPACING ) + sndtab.dur
end

function ENT:Banish()
    self.Banished = true
    self:NextThink( -1 )
    self:Extinguish()
    
    self:Free()
    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:EnableGravity( false )
        phys:AddVelocity( Vector( math.Rand(-1,-1),math.Rand(-1,-1),math.Rand(4,6) ):GetNormalized() * math.Rand(4,6) )
        phys:AddAngleVelocity( Vector( math.Rand( -15, 15 ), math.Rand( -15, 15 ), math.Rand( -15, 15 ) ) )
    end
    
    timer.Simple( 9,function() sound.Play(self.sndParticleSuck, self:GetPos(), 160, 100) end)

    timer.Simple( 14, function()
        if self:IsValid() then
            local phys = self:GetPhysicsObject()
            if phys:IsValid() then phys:EnableMotion( false ) end
            self:EmitSound( self.sndDeath, 160, 200 )
        end
    end  )
    
    umsg.Start( "fgnome_deathsequence" )
        umsg.Entity( self )
        umsg.Bool( true )
    umsg.End()
    
    timer.Simple( 15, function() 
        if self:IsValid() then 
            sound.Play( self.sndPop, self:GetPos(), 160, 100 )
            self:Remove() 
        end
    end )
end

function ENT:KillSounds()
    self.CurSound:Stop()
end

function ENT:SetEvilEyes( b )
    self:SetNWBool( "evileyes", b )
end


function ENT:PlayDead()
    -- Don't have glowing red eyes!
    if self:GetEvilEyes() then
        self:SetEvilEyes( false )
    end
    
    if not self.IsBeingCreepy then return end
    
    -- Act normal!
    self.IsBeingCreepy = false

    -- Be quiet!
    self:KillSounds()
    
    -- Hide your knife!
    self:StopAttack()
end

function ENT:BeCreepy()
    if self.WakeTime > CurTime() then return end 
    self.IsBeingCreepy = true
	
    -- Decide what creepy things we should do based on chance, distance, and line of sight from target
    local dist = self:GetPos():Distance( self.Victim:EyePos() )
    local Disp = self.Victim:GetShootPos() - self:GetPos()
    -- Teleport behind victim if he's too far away or we can't see him
    if dist > DIST_STALK or not self:HasLOS( self.Victim ) then
        if roll( PROB_TELEPORT ) then
            self:TeleportBehindVictim()
        end
    -- Always creep toward victim until attack
    elseif dist > DIST_ATTACK then
        if roll( PROB_TELEPORT ) then
		    self:SleepFor( randerval( COOLDOWN_TELEPORT ) )
            self:CreepForward(Disp)
        end
     -- Attack when in range
    else
        if roll( PROB_ATTACK ) then
            local attack 
            if roll( 0.6 ) then
                attack = self.LaserAttack
            elseif roll( 0.97 ) then
                attack = self.KnifeAttack
            else
                attack = self.SecretAttack
            end
            
            self:StartAttack( attack )
            return
        end
    end

    -- Always do creepy things when within creep distance
    if dist <= DIST_CREEP then
        if roll( PROB_CREEP ) then
            if math.random() < 0.2 then
                self:SetEvilEyes( true )
            else
                self:EmitCreepySounds()
            end
        end
    end
    
    if self.WakeTime > CurTime() then return end 
    
    -- Teleport to random location at any time
    if roll( PROB_TELEPORT_RANDOM ) then
        self:TeleportRandom()
    end
    
    -- Teleport onto victim's car if he has one
    --[[if roll( PROB_TELEPORT_CARJACK ) then
        self:TeleportToEntity()
    end
    if not self.IsBeingCreepy then return end]]    

end

-- Blacks out the RT camera if it is looking at the input position for the given duration.  Returns true if the camera was blacked out.
function ENT:CheckRTCamera( pos )
    local cament = RenderTargetCamera 
    if not IsValid( cament ) then return false end
    if not self:HasLOS( cament ) then return false end

    local camdir = ( pos - cament:GetPos() ):GetNormalized()
    if camdir:Dot( cament:GetAngles():Forward() ) < 0.65 then return false end -- the camera isn't looking at us so don't do anything

    return true
end

function ENT:BlackOutRTCamera( dur )
    umsg.Start( "fgnome_blackoutRT" )
        umsg.Entity( self )
        umsg.Float( dur )
    umsg.End()
end

function ENT:SleepFor( d )
    self.WakeTime = CurTime() + d
end

function ENT:Think()
    self:NextThink( CurTime() + THINK_DELAY )

    if not self:HasVictim() or ( self.Victim:IsPlayer() and not self.Victim:Alive() ) then
        self:FindVictim()
        return true
    end
    
    if self:CanVictimSeePos( self:GetPos(), self:GetAngles() ) and not self:AttackCritical() then -- OHSHI.. he sees us!
        -- Pretend like nothing happened
        self:PlayDead()
        if math.random() < 0.006 then
            self:SetEvilEyes( true ) -- Flash the evil eye every now and then
        end
        return true
    end
    if self.InAttack then
        if self.Victim:IsPlayer() and not self.Victim:Alive() then
            self:StopAttack()
        end
    else
        self:BeCreepy()
    end
    
    return true
end

function ENT:OnTakeDamage( dmginfo )
    if self.HP <= 0 then return end
    
    -- Only take fire damage
    if dmginfo:IsDamageType( DMG_BURN ) or dmginfo:IsDamageType( DMG_DIRECT ) then
        self.HP = self.HP - dmginfo:GetDamage()
        
        if CurTime() > self.NextEmitPain then
            self:EmitSound( self.PAIN_SOUNDS[ math.random( 1, #self.PAIN_SOUNDS ) ], 160, 200 )
            self.NextEmitPain = CurTime() + math.Rand( 0.3, 0.7 )
        end
        
        if self.HP <= 0 then self:Banish() end
    end
end

function ENT:EndTouch( ent )
    if self:HasVictim() then return end
    if ent:IsPlayer() then
        self:SetVictim( ent )
    end
end

function ENT:Use( activator, caller )
    if self:HasVictim() then return end
    if activator:IsPlayer() then
        self:SetVictim( activator )
    end
end

function ENT:OnRemove()
    self:StopAttack()
    self:KillSounds()
    
	local pos = self:GetPos()
	local ang = self:GetAngles()
	local victim = self:GetVictim()
    if not self.Banished then
        timer.Simple( randerval( COOLDOWN_REMOVE ), function()
            local ent = ents.Create( "sent_friendgnome" )
            
            ent:SetPos( pos )
            ent:SetAngles( ang )
            ent:Spawn()
            ent:Activate()
            
            if victim:IsValid() then ent:SetVictim( victim ) end
            ent:TeleportRandom()
        end)    
    end
end

hook.Add( "GravGunOnPickedUp", "fgnenome_gravpickup", function( plr, ent )
    if ent.IsPossesedGnome then
        if not ent:HasVictim() then
            ent:SetVictim( plr )
        end
    end
end )

hook.Add( "PhysgunPickup", "fgnenome_physpickup", function( plr, ent )
    if ent.IsPossesedGnome then
        if not ent:HasVictim() then
            ent:SetVictim( plr )
        end
    end
end )

end

---------------------
------ CLIENT -------
---------------------
if CLIENT then

--ENT.sndStatic = Sound( "ambient/levels/prison/radio_random2.wav" )
ENT.sndStatic = Sound( "HL1/ambience/deadsignal2.wav" )

local GNOMES = {}

function ENT:Initialize()
    --self.matGlow = Material( "sprites/light_glow02" )
    self.matGlow = Material( "sprites/light_glow02_add" )
    self.matLaser = Material( "trails/laser" )
    self.EyeColor = Color( 200, 0, 0, 255 )
    self.SecretEyeColor = Color( 230, 230, 255, 255 )
    
    -- Don't get the textures until after the effect is spawned (otherwise bad crashy things happen)
    self.matRT = Material( "pp/rt" )
    -- Fortunately this gives the default texture, regardless of what $basetexture is currently set to
    self.texRT = self.matRT:GetTexture( "$basetexture" )
    
    self.InLaserCharge = false
    self.LaserChargeTime = CurTime()
    
    self.InSecretCharge = false
    self.SecretChargeTime = CurTime()
    
    self.StaticSound = CreateSound( self, "" )

    self.StaticTextures = { 
        Material( "effects/filmscan256" ):GetTexture( "$basetexture" ), 
        Material( "effects/security_noise2" ):GetTexture( "$basetexture" ),
        Material( "effects/tvscreen_noise001a" ):GetTexture( "$texture2" )
    }
    
    GNOMES[ self ] = self
end

hook.Add( "RenderScreenspaceEffects", "fgnome_blur", function()
    local bdraw = false
    for k,v in pairs( GNOMES ) do
        if v.InSecretCharge and CurTime() - v.SecretChargeTime > 15.7 then
            bdraw = true
        end
    end
    if bdraw then
        DrawMotionBlur( 0.2, 0.9, 0.02 )
    end
end )

usermessage.Hook( "fgnome_blackoutRT", function( um )
    local gnome = um:ReadEntity()
    if not gnome:IsValid() then return end
    local dur = um:ReadFloat()
    
    gnome:BlackOutRTCamera( dur )
end )
function ENT:BlackOutRTCamera( dur )
    if self:GetVictim():IsValid() then
        self.StaticSound = CreateSound( self:GetVictim(), self.sndStatic )
        self.StaticSound:ChangeVolume( 0.4 )
        self.StaticSound:Play()
    end
    
    hook.Add( "HUDPaint", "fgnome_blackoutRT", function()
        self.matRT:SetTexture( "$basetexture", self.StaticTextures[ math.random( 1, 3 ) ] )
    end )
    
    timer.Simple( dur, self.RestoreRTCamera, self )
end

function ENT:RestoreRTCamera()
    if not IsValid( self ) then return end
    if self:GetVictim():IsValid() then
        self.StaticSound:Stop()
    end
    hook.Remove( "HUDPaint", "fgnome_blackoutRT" )
    self.matRT:SetTexture( "$basetexture", self.texRT )
end

usermessage.Hook( "fgnome_lasercharge", function( um )
    local gnome = um:ReadEntity()
    if not gnome:IsValid() then return end
    
    gnome.InLaserCharge = um:ReadBool()
    if gnome.InLaserCharge then
        gnome.LaserChargeTime = CurTime()
        local dlight = DynamicLight( gnome:EntIndex() )
        if dlight then
            dlight.Pos = gnome:GetPos()
            dlight.r = gnome.EyeColor.r
            dlight.g = gnome.EyeColor.g
            dlight.b = gnome.EyeColor.b
            dlight.Brightness = 2
            dlight.Size = 0
            dlight.Decay = 0
            dlight.DieTime = CurTime() + 3
            gnome.DLight = dlight
        end
    end
end )

local sndScream = Sound( "ambient/levels/citadel/citadel_ambient_scream_loop1.wav" )
local sndDeathWind = Sound( "ambient/levels/labs/teleport_mechanism_windup3.wav" )
local sndDeathThunder = Sound( "ambient/levels/labs/teleport_postblast_thunder1.wav" )
usermessage.Hook( "fgnome_deathsequence", function( um )
    local gnome = um:ReadEntity()
    if not gnome:IsValid() then return end
    
    local scream = CreateSound( gnome, sndScream )
    scream:SetSoundLevel( 0.27 )
    scream:PlayEx( 1, 129 )
    timer.Simple( 13.37,function() scream:Stop() end)
    gnome:EmitSound( sndDeathWind, 160, 65 )
    gnome:EmitSound( sndDeathThunder, 160, 65 )
    
    gnome.InDeathSequence = um:ReadBool()
    if gnome.InDeathSequence then
        gnome.DeathTime = CurTime()
        local dlight = DynamicLight( gnome:EntIndex() )
        if dlight then
            dlight.Pos = gnome:GetPos()
            dlight.r = 255
            dlight.g = 255
            dlight.b = 255
            dlight.Brightness = 2
            dlight.Size = 0
            dlight.Decay = 0
            dlight.DieTime = CurTime() + 3
            gnome.DLight = dlight
        end
    end
end )

usermessage.Hook( "fgnome_secretcharge", function( um )
    local gnome = um:ReadEntity()
    if not gnome:IsValid() then return end
    
    gnome.InSecretCharge = um:ReadBool()
    if gnome.InSecretCharge then
        gnome.SecretChargeTime = CurTime()
        local dlight = DynamicLight( gnome:EntIndex() )
        if dlight then
            dlight.Pos = gnome:GetPos()
            dlight.r = gnome.SecretEyeColor.r
            dlight.g = gnome.SecretEyeColor.g
            dlight.b = gnome.SecretEyeColor.b
            dlight.Brightness = 3
            dlight.Size = 0
            dlight.Decay = 0
            dlight.DieTime = CurTime() + 3
            gnome.DLight = dlight
        end
    end
end )

function ENT:Think()
    if self.InDeathSequence then
        local chrgtime = ( CurTime() - self.DeathTime ) / 13.37
        if chrgtime > 1 then self.InDeathSequence = false end
        local pos = self:LocalToWorld( self:OBBCenter() )
        self.Emitter = self.Emitter or ParticleEmitter( pos )
        self.Emitter:SetPos( pos )
        
        local dir = VectorRand():GetNormalized()
        local speed = 50 + 300 * chrgtime * chrgtime
        local dist = math.Rand( 24, 36 )
        local p = self.Emitter:Add( "effects/yellowflare", pos + dir * dist )
        p:SetVelocity( dir * -speed + self:GetVelocity() )
        p:SetDieTime( dist / speed )
        p:SetStartAlpha( 0 )
        p:SetEndAlpha( 100 + 155 * chrgtime * chrgtime )
        p:SetStartSize( math.Rand( 10, 20 ) )
        p:SetEndSize( 1 )
        p:SetRoll( math.Rand( -180, 180 ) )
        p:SetRollDelta( math.Rand(-1,1) )
        p:SetColor( TimedSin( 6, 65, 255, 0 ), TimedSin( 7, 65, 255, 4 ), TimedSin( 5, 65, 255, 8 ) )
    end

end

function ENT:Draw()
    local victim = self:GetVictim()
    if victim:IsValid() and victim ~= LocalPlayer() then return false end
    
    self:DrawModel()
    
    if self:GetEvilEyes() then
        local eyepos1 = self:LocalToWorld( Vector( 2.310, 1.503, 17.718 ) )
        local eyepos2 = self:LocalToWorld( Vector( 2.756, -0.261, 17.474 ) )
        render.SetMaterial( self.matGlow )
        render.DrawSprite( eyepos1, 3, 3, self.EyeColor )
        render.DrawSprite( eyepos2, 3, 3, self.EyeColor )
    end
    
    if self.InDeathSequence then
        local chrgtime = ( CurTime() - self.DeathTime ) / 13.37
        local eyepos1 = self:LocalToWorld( Vector( 2.310, 1.503, 17.718 ) )
        local eyepos2 = self:LocalToWorld( Vector( 2.756, -0.261, 17.474 ) )
        
        local ctimesqrd = chrgtime * chrgtime
        local clr = Color( TimedSin( 6, 65, 255, 0 ), TimedSin( 7, 65, 255, 4 ), TimedSin( 5, 65, 255, 8 ) )
        
        render.SetMaterial( self.matGlow )
        render.DrawSprite( eyepos1, 50 * ctimesqrd, 35 * ctimesqrd, clr )
        render.DrawSprite( eyepos2, 50 * ctimesqrd, 35 * ctimesqrd, clr )
        
        if self.DLight then
            self.DLight.r = clr.r
            self.DLight.g = clr.g
            self.DLight.b = clr.b
            self.DLight.Pos = self:GetPos()
            self.DLight.Size = 400 * ctimesqrd
            self.DLight.Decay = 1000 * ctimesqrd
            self.DLight.DieTime = CurTime() + 3 * ctimesqrd
        end
    
    elseif self.InSecretCharge then
        local chrgtime = ( CurTime() - self.SecretChargeTime ) / 15.7
        local eyepos1 = self:LocalToWorld( Vector( 2.310, 1.503, 17.718 ) )
        local eyepos2 = self:LocalToWorld( Vector( 2.756, -0.261, 17.474 ) )
        render.SetMaterial( self.matGlow )
        if CurTime() - self.SecretChargeTime > 22.6 then
            self.InSecretCharge = false
        elseif chrgtime > 1 then
            render.DrawSprite( eyepos1, 10, 8, self.SecretEyeColor )
            render.DrawSprite( eyepos2, 10, 8, self.SecretEyeColor )
        else
            local ctimesqrd = chrgtime * chrgtime
            render.DrawSprite( eyepos1, 100 * ctimesqrd, 70 * ctimesqrd, self.SecretEyeColor )
            render.DrawSprite( eyepos2, 100 * ctimesqrd, 70 * ctimesqrd, self.SecretEyeColor )
            if self.DLight then
                self.DLight.Pos = self:GetPos()
                self.DLight.Size = 600 * ctimesqrd
                self.DLight.Decay = 2000 * ctimesqrd
                self.DLight.DieTime = CurTime() + 4 * ctimesqrd
            end

        end
    elseif self.InLaserCharge then
        local chrgtime = ( CurTime() - self.LaserChargeTime ) / 4.4
        local eyepos1 = self:LocalToWorld( Vector( 2.310, 1.503, 17.718 ) )
        local eyepos2 = self:LocalToWorld( Vector( 2.756, -0.261, 17.474 ) )
        render.SetMaterial( self.matGlow )
        if chrgtime > 1.15 then
            self.InLaserCharge = false
        elseif chrgtime > 1 then
            render.DrawSprite( eyepos1, 10, 6, self.EyeColor )
            render.DrawSprite( eyepos2, 10, 6, self.EyeColor )
            
            local lpos1 = self:GetVictim():LocalToWorld( self:GetVictim():OBBCenter() + Vector( 8, 0, 0 ) )
            local lpos2 = self:GetVictim():LocalToWorld( self:GetVictim():OBBCenter() - Vector( 8, 0, 0 ) )
            render.DrawSprite( lpos1, 30, 30, self.EyeColor )
            render.DrawSprite( lpos2, 30, 30, self.EyeColor )
            
            render.SetMaterial( self.matLaser )
            render.DrawBeam( eyepos1, lpos1, 5, 0, 5, self.EyeColor )
            render.DrawBeam( eyepos2, lpos2, 5, 0, 5, self.EyeColor )
        else
            local ctimecbd = chrgtime * chrgtime * chrgtime
            render.SetMaterial( self.matGlow )
            render.DrawSprite( eyepos1, 50 * ctimecbd, 35 * ctimecbd, self.EyeColor )
            render.DrawSprite( eyepos2, 50 * ctimecbd, 35 * ctimecbd, self.EyeColor )
            if self.DLight then
                self.DLight.Pos = self:GetPos()
                self.DLight.Size = 300 * ctimecbd
                self.DLight.Decay = 1000 * ctimecbd
                self.DLight.DieTime = CurTime() + 3 * ctimecbd
            end

        end
    end
    

end

function ENT:OnRemove()
    self:RestoreRTCamera()
    self:StopSound( sndScream )
    GNOMES[ self ] = nil
end

end



---------------------
------ SHARED -------
---------------------
function ENT:GetVictim()
    return self:GetNWEntity( "Victim", NULL )
end

function ENT:GetEvilEyes()
    return self:GetNWBool( "evileyes", false )
end

function ENT:SpawnFunction( plr, tr )
    if not tr.Hit then return end
    
    local ent = ents.Create( ClassName )
    local spawnpos = tr.HitPos + tr.HitNormal * ent:OBBMins().z
    -- Calculate spawn angle
    local f = ( plr:GetShootPos() - spawnpos )
    f = f - f:Dot( tr.HitNormal ) * tr.HitNormal
    f:Normalize()
    local spawnang = Vecs2Ang( f, tr.HitNormal:Cross( f ), tr.HitNormal )

    ent:SetPos( spawnpos )
    ent:SetAngles( spawnang )
    ent:Spawn()
    ent:Activate()
    
    return ent
end
