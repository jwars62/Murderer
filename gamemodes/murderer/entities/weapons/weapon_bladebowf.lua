AddCSLuaFile()

SWEP.Category = "Toybox Classics"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true

SWEP.PrintName            = "Blade-bow"            
SWEP.Slot                = 2
SWEP.DrawAmmo            = true
SWEP.DrawCrosshair        = true
SWEP.Weight                = 5
SWEP.AutoSwitchTo        = false
SWEP.AutoSwitchFrom        = false
SWEP.Author            = ""
SWEP.Contact        = ""
SWEP.Purpose        = ""
SWEP.Instructions    = "Right click to charge blade.\nLeft click to fire it."
SWEP.ViewModel            = "models/weapons/c_crossbow.mdl"
SWEP.WorldModel            = "models/weapons/w_crossbow.mdl"
SWEP.Primary.ClipSize        = -1
SWEP.Primary.DefaultClip    = -1
SWEP.Primary.Automatic        = false
SWEP.Primary.Ammo            = "none"
SWEP.Secondary.ClipSize        = -1
SWEP.Secondary.DefaultClip    = -1
SWEP.Secondary.Automatic    = false
SWEP.Secondary.Ammo            = "none"

SWEP.UseHands = true

//I take NO responibility for this code, continue downwards at your own risk!

SWEP.LastPrimary = 0
SWEP.MaxSpinSpeed = 3000
SWEP.MinSpinSpeed = 1500
SWEP.SpinSpeedIncr = 650
SWEP.SpinAng = 0

local e = {}
e.Type = "anim"

if SERVER then
    
    hook.Add("CreateEntityRagdoll","attach_saw_blade",function(ent,doll)
    
        for k,v in pairs(ents.FindByClass("saw_blade")) do
                
            if v:GetPos():Distance(doll:GetPos()) < 30 then
                  
                local closest
                local dist
                    
                for i=0,doll:GetPhysicsObjectCount()-1 do
                        
                    local phys = doll:GetPhysicsObjectNum(i)
                        
                    local d = phys:GetPos():Distance(v:GetPos())
                        
                    if !dist or d < dist then
                            
                        dist = d
                        closest = i
                    end
                end
                  
                v:GetPhysicsObject():SetMass(0.1)  
                constraint.Weld(v,doll,0,closest,0,true)
                v.Stuck = true
                    
                break
            end
        end
    end)
    
    local SliceSound = Sound("ambient/machines/slicer1.wav")
    
    hook.Add("EntityTakeDamage","lol",function(e,i,a,_,dmg)
    
            if IsValid(a) and a:IsPlayer() and a:GetActiveWeapon().SpinSpeed and a:GetActiveWeapon().SpinSpeed > 50 then
                
            sound.Play(SliceSound,e:GetPos(),75,100)
                
            local pos = e:NearestPoint(dmg:GetDamagePosition())
               
            local ef = EffectData()
                ef:SetOrigin(pos)
            util.Effect("BloodImpact",ef)
        end
    end)
    
    function e:Initialize()
       
        self:SetModel("models/props_junk/sawblade001a.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        
        self.Stuck = false
        
        local phys = self:GetPhysicsObject()
        
        if IsValid(phys) then
            
            phys:AddGameFlag(bit.bor(FVPHYSICS_DMG_SLICE, FVPHYSICS_WAS_THROWN))
        end
    end
        
    function e:PhysicsCollide(data,phys)
        
        if self.Stuck or data.OurOldVelocity:Length() < 50 or  math.abs(data.HitNormal:Dot(self:GetUp())) > 0.3 then return end
               
        self.Stuck = true
        
        self:SetPos(data.HitPos-data.HitNormal*math.random(3,7))
        
        self:EmitSound(SliceSound)
        
        local ef = EffectData()
        ef:SetOrigin(data.HitPos)
        ef:SetNormal(data.HitNormal*-1)
        util.Effect("manhacksparks",ef)
                
        if data.HitEntity:IsWorld() then
           
            self:SetMoveType(MOVETYPE_NONE)
            return
        end
        
        if data.HitEntity:GetClass():match("^npc_") then
            
            phys:SetVelocity(data.OurOldVelocity)
            return
        end
        
        phys:SetMass(0.1)
        
        local bone = 0
        
        for i=0,data.HitEntity:GetPhysicsObjectCount()-1 do
            
            if data.HitEntity:GetPhysicsObjectNum(i) == data.HitObject then
                
                bone = i
                break
            end
        end
                             
        timer.Simple(0,function(a,b,bone) constraint.Weld(a,b,0,bone,0,true) end,self,data.HitEntity,bone)        
    end
    
    local FompSound = Sound("weapons/crossbow/bolt_fly4.wav")
    local BlastSound = Sound("weapons/gauss/fire1.wav")
    
    local ChargeSound = Sound("vehicles/tank_turret_loop1.wav")
        
    function SWEP:Initialize()
        
        self:InstallDataTable()
        
        self:DTVar("Int",0,"SpinSpeed")
        //self:DTVar("Int",1,"LastPrimary")
        
        self.dt.SpinSpeed = 0
        self.LastPrimary = 0
        
        self:CallOnRemove(0,function(self) 
                
            if self.ChargeSound then
                    
                self.ChargeSound:Stop()
            end
        end,self)
       
        self.FompSound = CreateSound(self,FompSound) 
        self.BlastSound = CreateSound(self,BlastSound)
        
        self.ChargeSound = CreateSound(self,ChargeSound)
    end

    function SWEP:OnRemove()
    	self:Holster()
    end
end

    function SWEP:Holster()
        
        if self.ChargeSound then
            
            self.ChargeSound:Stop()
        end
        
        self.dt.SpinSpeed = 0

        if CLIENT and IsValid(self.Owner) and IsValid(self.Owner:GetViewModel()) and self.Owner:GetViewModel():LookupBone("ValveBiped.bolt") then
      		self.Owner:GetViewModel():ManipulateBoneScale(self.Owner:GetViewModel():LookupBone("ValveBiped.bolt"), Vector(1, 1, 1))
        end

        return true
    end

if CLIENT then
        
    function e:Draw()
    
        self:DrawModel()
    end
    
    local function BuildBones(self)
        
    end

    function SWEP:Initialize()
        
        self:InstallDataTable()
        
        self:DTVar("Int",0,"SpinSpeed")
        //self:DTVar("Int",1,"LastPrimary")
        
        self.dt.SpinSpeed = 0
        self.LastPrimary = 0
               
        SafeRemoveEntity(self._muzzle)
        self._muzzle = ClientsideModel("models/props_junk/sawblade001a.mdl")
        self._muzzle:SetNoDraw(true)
        
        if !IsValid(self.Owner) then return end
        
        local vm = self.Owner:GetViewModel()
        
        local old = vm.BuildBonePositions
        
        if old then
            
            vm.BuildBonePositions = function(...)
                
                old(...)
                BuildBones(...)
            end
        else
        
            vm.BuildBonePositions = BuildBones
        end
    end
    
    function SWEP:GetViewModelPosition(pos,ang)
        
        pos = pos-ang:Forward()*3
        ang:RotateAroundAxis(ang:Up(),-5)
       
        return pos,ang 
    end
    
    function SWEP:ViewModelDrawn()
        if !IsValid(self.Owner) or !IsValid(self._muzzle) or self.LastPrimary+0.3 > CurTime() then return end
        
        local vm = self.Owner:GetViewModel()
                                
        local matrix = vm:GetBoneMatrix(vm:LookupBone("ValveBiped.bolt"))
        
        if !matrix then return end
        
        local pos = matrix:GetTranslation()
        local ang = matrix:GetAngles()
        
        self._muzzle:SetRenderOrigin(pos+ang:Up()*14+ang:Right()*-0.05) 
        ang:RotateAroundAxis(ang:Forward(),-90)
        ang:RotateAroundAxis(ang:Up(),self.SpinAng)
        self._muzzle:SetRenderAngles(ang)
        self._muzzle:SetupBones()

        vm:ManipulateBoneScale(vm:LookupBone("ValveBiped.bolt"), Vector(0.1, 0.1, 0.1))
        
        self._muzzle:DrawModel()
    end
end

scripted_ents.Register(e,"saw_blade",true)

function SWEP:Reload()
end

function SWEP:Think() 
    
    if !IsValid(self.Owner) then return end
    
    if self.dt.SpinSpeed >= self.MinSpinSpeed 
        and self.Owner:KeyDown(IN_ATTACK) 
        and self.LastPrimary+1 < CurTime() then
        
        self:PrimaryAttack()
        self.LastPrimary = CurTime()
        self.dt.SpinSpeed = 0
    end
    
    self.SpinAng = (self.SpinAng+self.dt.SpinSpeed*FrameTime())%360
    
    if !SERVER or self.LastPrimary+2 > CurTime() then return end
    
    if self.Owner:KeyDown(IN_ATTACK2) then
        
        if !self.ChargeSound:IsPlaying() then
            
            self.ChargeSound:PlayEx(0.5,0)
        end
        
        self.dt.SpinSpeed = self.dt.SpinSpeed+self.SpinSpeedIncr*FrameTime()
    else
                
        self.dt.SpinSpeed = self.dt.SpinSpeed*0.99
    end
                
    if self.dt.SpinSpeed < 5 then
            
        self.ChargeSound:Stop()
    end
       
    self.ChargeSound:ChangePitch(155*self.dt.SpinSpeed/self.MaxSpinSpeed)
    self.ChargeSound:ChangeVolume(0.25+0.25*self.dt.SpinSpeed/(self.MaxSpinSpeed*0.9))
        
    self.NextSlice = self.NextSlice or 0
        
    if self.dt.SpinSpeed > 20 and self.NextSlice < CurTime() then
           
        self.NextSlice = CurTime()+math.min(3,200/self.dt.SpinSpeed)
            
        self.Owner:TraceHullAttack(self.Owner:GetShootPos(),
            self.Owner:GetShootPos()+self.Owner:GetAimVector()*5,
            Vector(-16,-16,-8),
            Vector(16,16,8),
            10,
            DMG_SLASH,
            5,
            true)
    end
    
    self.dt.SpinSpeed = math.Clamp(self.dt.SpinSpeed,0,self.MaxSpinSpeed)
end


function SWEP:PrimaryAttack()
    
    if CLIENT or !IsValid(self.Owner) or self.dt.SpinSpeed < self.MinSpinSpeed then return end
    
    self.ChargeSound:Stop()
    
    self.FompSound:Stop()
    self.FompSound:Play()
    
    self.FompSound:ChangeVolume(1-self.dt.SpinSpeed/self.MaxSpinSpeed)
    
    self.BlastSound:Stop()
    self.BlastSound:Play()
    
    self.BlastSound:ChangeVolume(self.dt.SpinSpeed/self.MaxSpinSpeed)
    
    local blade = ents.Create("saw_blade")   
    blade:SetCollisionGroup(20)
    blade:Spawn()
    blade:SetPos(self.Owner:GetShootPos())
    blade:SetAngles(self.Owner:EyeAngles())
    blade:SetOwner(self.Owner)
        
    SafeRemoveEntityDelayed(blade,math.random(30,50))
        
    local phys = blade:GetPhysicsObject()
    
    if IsValid(phys) then
        
        phys:Wake()
        phys:SetVelocity(self.Owner:GetAimVector()*self.dt.SpinSpeed)
        phys:AddAngleVelocity(Vector(0,0,self.dt.SpinSpeed))
    end
    
    self.dt.SpinSpeed = 0
    self.LastPrimary = CurTime()
            
    self:SendWeaponAnim(ACT_VM_RELOAD)
    
    self:SetNextPrimaryFire(CurTime()+2)
end

function SWEP:SecondaryAttack()
        
end

function SWEP:ShouldDropOnDie()
    return false
end

 
 