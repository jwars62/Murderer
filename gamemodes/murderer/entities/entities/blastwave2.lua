AddCSLuaFile()

ENT.Type   = "anim"
ENT.Base                = "base_anim"
ENT.PrintName           = "blastwave2"
ENT.RenderGroup         = RENDERGROUP_TRANSLUCENT
if (CLIENT) then
    --Explosion effects
    local EFFECT={} 
    function EFFECT:Init( data )
        local start = data:GetOrigin()
        local em = ParticleEmitter( start ) 
        for i=1,256 do
            local part2 = em:Add("particle/smokesprites_0005", start ) --Secondary Shockwave
            if part2 then
                part2:SetVelocity((Vector(math.random(-100,100),math.random(-100,100),0):GetNormal()+ Vector(0,0,0.1)) * 1500)
                local rad = math.abs(math.atan2(part2:GetVelocity().x,part2:GetVelocity().y))
                local angle = (rad/math.pi*1536)
                //local angle = math.random(0, 1536)
                if(angle < 255 && angle >= 0) then
                    part2:SetColor(255,angle,0)
                end
                if(angle < 511 && angle >= 255) then
                    part2:SetColor(511-angle,255,0)
                end   
                if(angle < 767 && angle >= 511) then
                    part2:SetColor(0,255,angle-511)
                end
                if(angle < 1023 && angle >= 767) then
                    part2:SetColor(0,1023-angle,255)
                end 
                if(angle < 1279 && angle >= 1023) then
                    part2:SetColor(angle-1023,0,255)
                end
                if(angle < 1535 && angle >= 1279) then
                    part2:SetColor(255,0,1535-angle)
                end 
                if(angle > 1535) then
                    part2:SetColor(255,0,0)
                end

                part2:SetDieTime(math.random(5,6))
                part2:SetLifeTime(math.random(0.5,1))
                part2:SetStartSize(50)
                part2:SetEndSize(math.random(200,250)) 
                part2:SetAirResistance(math.random(30,31))
                part2:SetGravity( Vector(0,0,200) )
                part2:SetRollDelta(math.random(-2,2))
            end
        end 
        for i=1,256 do
            local part5 = em:Add("particle/particle_noisesphere", start ) --other thing
            if part5 then
    part5:SetVelocity(Vector(math.random(-100,100),math.random(-100,100),math.random(-5,5)):GetNormal()* math.random(50,700))
                local rad = math.abs(math.atan2(part5:GetVelocity().x,part5:GetVelocity().y))
                local angle = (rad/math.pi*1536)
                //local angle = math.random(0, 1536)
                if(angle < 255 && angle >= 0) then
                    part5:SetColor(255,angle,0)
                end
                if(angle < 511 && angle >= 255) then
                    part5:SetColor(511-angle,255,0)
                end   
                if(angle < 767 && angle >= 511) then
                    part5:SetColor(0,255,angle-511)
                end
                if(angle < 1023 && angle >= 767) then
                    part5:SetColor(0,1023-angle,255)
                end 
                if(angle < 1279 && angle >= 1023) then
                    part5:SetColor(angle-1023,0,255)
                end
                if(angle < 1535 && angle >= 1279) then
                    part5:SetColor(255,0,1535-angle)
                end 
                if(angle > 1535) then
                    part5:SetColor(255,0,0)
                end

                part5:SetDieTime(math.random(6,7))
                part5:SetLifeTime(math.random(0.5,1))
                part5:SetStartSize(50)
                part5:SetEndSize(math.random(600,800)) 
                part5:SetAirResistance(math.random(10,11))
                //part5:SetGravity( Vector(0,0,350) )
                part5:SetRollDelta(math.random(-2,2))
            end
        end   

        for i=1,128 do
            local part4 = em:Add("particle/particle_smokegrenade1", start ) --rising thing
            if part4 then
    part4:SetVelocity(Vector(math.random(-10,100),math.random(-10,10),math.random(0,100)):GetNormal()* math.random(-100,100))
                local rad = math.abs(math.atan2(part4:GetVelocity().x,part4:GetVelocity().y))
                local angle = (rad/math.pi*1536)
                //local angle = math.random(0, 1536)
                if(angle < 255 && angle >= 0) then
                    part4:SetColor(255,angle,0)
                end
                if(angle < 511 && angle >= 255) then
                    part4:SetColor(511-angle,255,0)
                end   
                if(angle < 767 && angle >= 511) then
                    part4:SetColor(0,255,angle-511)
                end
                if(angle < 1023 && angle >= 767) then
                    part4:SetColor(0,1023-angle,255)
                end 
                if(angle < 1279 && angle >= 1023) then
                    part4:SetColor(angle-1023,0,255)
                end
                if(angle < 1535 && angle >= 1279) then
                    part4:SetColor(255,0,1535-angle)
                end 
                if(angle > 1535) then
                    part4:SetColor(255,0,0)
                end

                part4:SetDieTime(math.random(7,8))
                part4:SetLifeTime(math.random(0.5,1))
                part4:SetStartSize(50)
                part4:SetEndSize(math.random(600,700)) 
                part4:SetAirResistance(math.random(20,21))
                part4:SetGravity( Vector(0,0,math.random(0,350)) )
                part4:SetRollDelta(math.random(-0.5,0.5))
            end
        end   

        for i=1,256 do
            local part3 = em:Add("particle/particle_noisesphere", start ) --mushroom cloud
            if part3 then
    part3:SetVelocity(Vector(math.random(-100,100),math.random(-100,100),math.random(0,200)):GetNormal()* math.random(700,1000))
                local rad = math.abs(math.atan2(part3:GetVelocity().x,part3:GetVelocity().y))
                local angle = (rad/math.pi*1536)
                //local angle = math.random(0, 1536)
                if(angle < 255 && angle >= 0) then
                    part3:SetColor(255,angle,0)
                end
                if(angle < 511 && angle >= 255) then
                    part3:SetColor(511-angle,255,0)
                end   
                if(angle < 767 && angle >= 511) then
                    part3:SetColor(0,255,angle-511)
                end
                if(angle < 1023 && angle >= 767) then
                    part3:SetColor(0,1023-angle,255)
                end 
                if(angle < 1279 && angle >= 1023) then
                    part3:SetColor(angle-1023,0,255)
                end
                if(angle < 1535 && angle >= 1279) then
                    part3:SetColor(255,0,1535-angle)
                end 
                if(angle > 1535) then
                    part3:SetColor(255,0,0)
                end

                part3:SetDieTime(math.random(7,8))
                part3:SetLifeTime(math.random(0.5,1))
                part3:SetStartSize(50)
                part3:SetEndSize(math.random(800,900)) 
                part3:SetAirResistance(math.random(20,21))
                part3:SetGravity( Vector(0,0,350) )
                part3:SetRollDelta(math.random(-2,2))
            end
        end   
  
         for i=1, 1024 do
            local part = em:Add("particle/smokesprites_0009", start ) --Shockwave
            if part then
                part:SetVelocity(Vector(math.random(-10,10),math.random(-10,10),0):GetNormal() * math.random(1700,2000))
                local rad = math.abs(math.atan2(part:GetVelocity().x,part:GetVelocity().y))
                local angle = (rad/math.pi*1536)
                if(angle < 255 && angle >= 0) then
                    part:SetColor(255,angle,0)
                end
                if(angle < 511 && angle >= 255) then
                    part:SetColor(511-angle,255,0)
                end   
                if(angle < 767 && angle >= 511) then
                    part:SetColor(0,255,angle-511)
                end
                if(angle < 1023 && angle >= 767) then
                    part:SetColor(0,1023-angle,255)
                end 
                if(angle < 1279 && angle >= 1023) then
                    part:SetColor(angle-1023,0,255)
                end
                if(angle < 1535 && angle >= 1279) then
                    part:SetColor(255,0,1535-angle)
                end 
                if(angle > 1535) then
                    part:SetColor(255,0,0)
                end

                part:SetDieTime(math.random(5,6))
                part:SetLifeTime(math.random(1,2))
                if (math.Dist(0,0,part:GetVelocity().x,part:GetVelocity().y) >= 1500) then    
            part:SetStartSize((math.Dist(0,0,part:GetVelocity().x,part:GetVelocity().y)-1600)/4)
            part:SetEndSize((math.Dist(0,0,part:GetVelocity().x,part:GetVelocity().y)-1600)/1)
                else
                    part:SetStartSize(0)
                    part:SetEndSize(0)
                end
                part:SetAirResistance(5)
                //part:SetGravity( Vector(0,0,-100) )
                part:SetRollDelta(math.random(-2,2))
           
            end
        end
        for i=1,512 do
            local part1 = em:Add("particle/smokesprites_0010", start ) --Main Explosion
            if part1 then                                               part1:SetVelocity(Vector(math.random(-2,2),math.random(-2,2),math.random(-2,2)):GetNormal() * math.random(100,2400))
                part1:SetColor(255,255,255)
                part1:SetDieTime(math.random(2,3))
                part1:SetLifeTime(math.random(0.3,0.5))
                part1:SetStartSize(150 - (math.sqrt(part1:GetVelocity().x*part1:GetVelocity().x+part1:GetVelocity().y*part1:GetVelocity().y+part1:GetVelocity().z*part1:GetVelocity().z))/16)
                part1:SetEndSize(1200 - (math.sqrt(part1:GetVelocity().x*part1:GetVelocity().x+part1:GetVelocity().y*part1:GetVelocity().y+part1:GetVelocity().z*part1:GetVelocity().z))/2)
                part1:SetAirResistance(50)
                part1:SetRollDelta(math.random(-1,1))
            end
        end    
        em:Finish()
    end
    function EFFECT:Think()        
    end
    function EFFECT:Render() 
    end
    effects.Register(EFFECT,"wave2") 
end

function ENT:Initialize()
    sound.Play("ambient/explosions/explode_6.wav", self:GetPos(), 100, 100)
    sound.Play("ambient/explosions/explode_6.wav", self:GetPos(), 100, 100) 
    sound.Play("ambient/explosions/explode_6.wav", self:GetPos(), 100, 100) 
   // WorldSound("ambient/explosions/explode_6.wav", self:GetPos(), 100, 100)  

    if (!SERVER) then return end
    local e = EffectData()
    e:SetOrigin( self:GetPos() + Vector(0,0,64) ) 
    util.Effect( "wave2", e )
    util.ScreenShake( self:GetPos(), 5, 5, 6, 5000 )
end

function ENT:Draw()
end

function ENT:Think()
    if (!SERVER) then return end
    self.R = self.R or 512
    self.S = self.S or 1
    local targets2 = ents.FindInSphere( self:GetPos(), 256)
    local targets3 = ents.FindInSphere( self:GetPos(), self.R)
    local pos = self:GetPos()
    for k, e in pairs( targets2 ) do
        if (e:GetClass() != "env_laser" && e:GetClass() != "env_lightglow" && e:GetClass() != "effects" && e:GetClass() != "remover" && e:GetClass() != "player" && e:GetClass() != "physgun_beam" && e:GetClass() != "blastwave" && e:GetClass() != "blastwave2"&& e:GetClass() != "prop_ragdoll" && e:GetClass() != "atomicrainbomb" && e:GetClass() != "info_player_start" && !string.find(e:GetClass(), "func_")) then
            e:Remove()
        end
        if (e:IsPlayer() or e:IsNPC()) then
            e:TakeDamage(9999, self:GetOwner(), self:GetOwner())
        end
    end
    for k, f in pairs( targets3 ) do
        if (f:GetClass() != "prop_ragdoll" && f:GetMoveType() == 6) then
            if (self.S < 60) then
                constraint.RemoveAll(f)
            end
            if (constraint.HasConstraints(f) == false) then
                f:TakeDamage(100 - self.S)
            end
            local phy = f:GetPhysicsObject()
            if phy:IsValid()then
                if (self.S < 70) then
                    phy:EnableMotion(true)
                end
                phy:ApplyForceCenter((phy:GetPos()-pos):GetNormal()*10000000/self.S)
            end
        end
        if (f:GetMoveType() == 3) then
            f:TakeDamage(1000 - (self.S*10))
        end
    end
    self.R = self.R + 280
    self.S = self.S + 4.35
end

