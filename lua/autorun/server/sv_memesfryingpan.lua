util.AddNetworkString("memesfryingpan_ragdoll")
util.AddNetworkString("memesfryingpan_unragdoll")
util.AddNetworkString("memesfryingpan_updateragdollcolor")

local player_meta_table = FindMetaTable("Player")

local function SetInvisiblePlayer(ply,enable)
    if not ply:IsValid() then return end

    if enable then
        visibility = visibility or 0
        ply:DrawShadow( false )
        ply:SetMaterial( "models/effects/vol_light001" )
        ply:SetRenderMode( RENDERMODE_TRANSALPHA )
        ply:Fire( "alpha", visibility, 0 )

        if IsValid( ply:GetActiveWeapon() ) then
            ply:GetActiveWeapon():SetRenderMode( RENDERMODE_TRANSALPHA )
            ply:GetActiveWeapon():Fire( "alpha", visibility, 0 )
            ply:GetActiveWeapon():SetMaterial( "models/effects/vol_light001" )
            if ply:GetActiveWeapon():GetClass() == "gmod_tool" then
                ply:DrawWorldModel( false ) -- tool gun has problems
            else
                ply:DrawWorldModel( true )
            end
        end
    else
        ply:DrawShadow( true )
        ply:SetMaterial( "" )
        ply:SetRenderMode( RENDERMODE_NORMAL )
        ply:Fire( "alpha", 255, 0 )
        local activeWeapon = ply:GetActiveWeapon()
        if IsValid( activeWeapon ) then
            activeWeapon:SetRenderMode( RENDERMODE_NORMAL )
            activeWeapon:Fire( "alpha", 255, 0 )
            activeWeapon:SetMaterial( "" )
        end
    end
end

function player_meta_table:SetInvisible(enable)
    SetInvisiblePlayer(self,enable)
end

function SpawnRagdoll(model,pos,angles,color)
    local ragdoll = nil
    ragdoll = ents.Create("prop_ragdoll")
    if IsValid(ragdoll) then
        ragdoll:SetModel(model)
        ragdoll:SetColor(Color(255,255,255,255))
        ragdoll:SetPos(pos)
        ragdoll:SetAngles(Angle(0,angles.Yaw,0))

        local r, g, b = color.r / 255, color.g / 255, color.b / 255

        ragdoll.GetPlayerColor = function() return Vector(r,g,b) end
        net.Start("memesfryingpan_updateragdollcolor")
            net.WriteEntity(ragdoll)
            net.WriteVector(Vector(r,g,b))
        net.Broadcast()

        ragdoll:Spawn()
        ragdoll:Activate()

        return ragdoll
    else
        return nil
    end
end

local function RagdollPlayer(ply)
    local ragdoll = SpawnRagdoll(ply:GetModel(),ply:GetPos(),ply:GetAngles(),ply:GetPlayerColor())
    ragdoll:SetVelocity(ply:GetVelocity())

    ply.WeaponsToRegive = {}
    for k,v in pairs(ply:GetWeapons()) do
        ply.WeaponsToRegive[k] = v:GetClass()
    end
    ply.AmmoToRegive = {}
    for ammoID,amount in pairs(ply:GetAmmo()) do
        ply.AmmoToRegive[ammoID] = amount
    end

    ply:Spectate(OBS_MODE_IN_EYE)
    ply:SpectateEntity(ragdoll)
    ply:SetParent(ragdoll)
    ply:StripWeapons()

    ply:SetNWBool("memesfryingpan_ragdolled",true)
    ply:SetNWEntity("memesfryingpan_ragdoll",ragdoll)

    net.Start("memesfryingpan_ragdoll")
        net.WriteEntity(ragdoll)
    net.Send(ply)

    return ragdoll
end

function player_meta_table:Ragdoll()
    return RagdollPlayer(self)
end 

local function UnragdollPlayer(ply)
    ply:SetNWBool("memesfryingpan_ragdolled",false)
    local ragdoll = ply:GetNWEntity("memesfryingpan_ragdoll",nil)

    ply:SetParent()
    ply:UnSpectate()
    ply:Spawn()

    if ply.WeaponsToRegive then
        ply:StripWeapons()
        for k,v in pairs(ply.WeaponsToRegive) do
            ply:Give(v,true)
        end
    end

    if ply.AmmoToRegive then
        for ammoID,amount in pairs(ply.AmmoToRegive) do
            ply:SetAmmo(amount,ammoID)
        end
    end

    if IsValid(ragdoll) then
        ply:SetPos(ragdoll:GetPos())
        ragdoll:Remove()
        ply:SetNWEntity("memesfryingpan_ragdoll",nil)
    end

    net.Start("memesfryingpan_unragdoll")
        net.WriteBool(true)
    net.Send(ply)
end

function player_meta_table:Unragdoll()
    UnragdollPlayer(self)
end

local to_unragdoll = {}

local GROUND_TRACE_LENGTH = 100
local GROUND_TRACE_DIRECTION = Vector(0,0,-1) * GROUND_TRACE_LENGTH

local function RagdollOnGround(ragdoll)
    local tr = util.QuickTrace(ragdoll:GetPos(), GROUND_TRACE_DIRECTION, ragdoll)
    if not tr.Hit then
        for boneid=0,ragdoll:GetBoneCount(),1 do
            tr = util.QuickTrace(ragdoll:GetBonePosition(boneid), GROUND_TRACE_DIRECTION, ragdoll)
            if tr.Hit then
                break
            end
        end
        return tr.Hit
    else
        return true
    end
end

local function UnragdollBacklog()
    for i,ply in ipairs(to_unragdoll) do
        local ragdoll = ply:GetNWEntity("memesfryingpan_ragdoll",nil)
        if RagdollOnGround(ragdoll) then
            ply:Unragdoll()
            table.remove(to_unragdoll,i)
        end
    end
end

hook.Add("Think","memesfryingpan_unragdollbacklog",UnragdollBacklog)

local function BeginUnragdollTimerPlayer(ply,time)
    timer.Simple(time,function()
        if IsValid(ply) then
            local ragdoll = ply:GetNWEntity("memesfryingpan_ragdoll",nil)
            if not RagdollOnGround(ragdoll) then
                table.insert(to_unragdoll, ply)
            else
                ply:Unragdoll()
            end
        end
    end)
end

function player_meta_table:BeginUnragdollTimer(time)
    BeginUnragdollTimerPlayer(self,time)
end


local function ThrowRagdollPlayer(ply,tr,force)
    local ragdoll = ply:Ragdoll()
    local phys = ragdoll:GetPhysicsObjectNum( tr.PhysicsBone )
    local push = tr.HitNormal * force

    phys:ApplyForceCenter( push )
end

function player_meta_table:ThrowRagdoll(tr,force)
    ThrowRagdollPlayer(self,tr,force)
end