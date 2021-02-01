if SERVER then
    AddCSLuaFile()
end

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.ViewModel = "models/weapons/memesFryingPan/c_memesFryingPan.mdl"
SWEP.WorldModel = "models/weapons/memesFryingPan/w_memesFryingPan.mdl"
SWEP.HoldType = "melee"
SWEP.PrintName = "Frying Pan"
SWEP.Base = "weapon_base"
SWEP.m_WeaponDeploySpeed = 1.1
SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.Primary.Ammo = "none"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true

SWEP.Secondary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false

SWEP.Primary.Range = 100
SWEP.Primary.RangeSquared = SWEP.Primary.Range * SWEP.Primary.Range
SWEP.Primary.Damage = 1000
SWEP.Primary.ImpactDecal = "Impact.Metal"
SWEP.Primary.WorldImpactSound = "Weapon_Crowbar.Melee_HitWorld"
SWEP.Primary.EntImpactSound = "SolidMetal.ImpactHard"
SWEP.Primary.PlayerImpactSound = "SolidMetal.BulletImpact"
SWEP.Primary.SwingSound = "Weapon_Crowbar.Single"
SWEP.Primary.AttackDelay = 0.4
SWEP.Primary.SwingOccursAt = 0.16

function SWEP:PlaceImpactDecal(trace)
    local Pos1 = trace.HitPos + trace.HitNormal
    local Pos2 = trace.HitPos - trace.HitNormal

	if ( SERVER ) then
		util.Decal( self.Primary.ImpactDecal, Pos1, Pos2, self.Owner )
    end
end

function SWEP:Initialize()
    self:SetHoldType(self.HoldType)
end

function SWEP:CanPrimaryAttack()
    if self:GetNextPrimaryFire() <= CurTime() and IsValid(self.Owner) and IsValid(self.Weapon) then
        self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
        self.Owner:SetAnimation(PLAYER_ATTACK1)
        self.Weapon:EmitSound(self.Primary.SwingSound,100,100,1,CHAN_WEAPON)
        self:SetNextPrimaryFire(CurTime() + self.Primary.AttackDelay)
        return true
    else
        return false
    end
end

function SWEP:Reload()
    return true
end

function SWEP:CanSecondaryAttack()
    return false
end

local BONE_MULTIPLIERS = {
    ["ValveBiped.Bip01_Pelvis"] = 1,
    ["ValveBiped.Bip01_Spine"] = 1,
    ["ValveBiped.Bip01_Spine1"] = 1,
    ["ValveBiped.Bip01_Spine2"] = 1,
    ["ValveBiped.Bip01_Spine4"] = 1,
    ["ValveBiped.Bip01_Head1"] = 2,
    ["ValveBiped.Bip01_Neck1"] = 2,
    ["ValveBiped.forward"] = 2,
    ["ValveBiped.Bip01_R_Clavicle"] = 1.25,
    ["ValveBiped.Bip01_R_UpperArm"] = 1,
    ["ValveBiped.Bip01_R_Forearm"] = 0.85,
    ["ValveBiped.Bip01_R_Hand"] = 0.25,
    ["ValveBiped.Anim_Attachment_RH"] = 0.25,
    ["ValveBiped.Bip01_L_Clavicle"] = 1.25,
    ["ValveBiped.Bip01_L_UpperArm"] = 1,
    ["ValveBiped.Bip01_L_Forearm"] = 0.85,
    ["ValveBiped.Bip01_L_Hand"] = 0.25,
    ["ValveBiped.Anim_Attachment_LH"] = 0.25,
    ["ValveBiped.Bip01_R_Thigh"] = 1,
    ["ValveBiped.Bip01_R_Calf"] = 0.85,
    ["ValveBiped.Bip01_R_Foot"] = 0.25,
    ["ValveBiped.Bip01_R_Toe0"] = 0.25,
    ["ValveBiped.Bip01_L_Thigh"] = 1,
    ["ValveBiped.Bip01_L_Calf"] = 0.85,
    ["ValveBiped.Bip01_L_Foot"] = 0.25,
    ["ValveBiped.Bip01_L_Toe0"] = 0.25,
    ["ValveBiped.Bip01_L_Finger4"] = 0.25,
    ["ValveBiped.Bip01_L_Finger41"] = 0.25,
    ["ValveBiped.Bip01_L_Finger42"] = 0.25,
    ["ValveBiped.Bip01_L_Finger3"] = 0.25,
    ["ValveBiped.Bip01_L_Finger31"] = 0.25,
    ["ValveBiped.Bip01_L_Finger32"] = 0.25,
    ["ValveBiped.Bip01_L_Finger2"] = 0.25,
    ["ValveBiped.Bip01_L_Finger21"] = 0.25,
    ["ValveBiped.Bip01_L_Finger22"] = 0.25,
    ["ValveBiped.Bip01_L_Finger1"] = 0.25,
    ["ValveBiped.Bip01_L_Finger11"] = 0.25,
    ["ValveBiped.Bip01_L_Finger12"] = 0.25,
    ["ValveBiped.Bip01_L_Finger0"] = 0.25,
    ["ValveBiped.Bip01_L_Finger01"] = 0.25,
    ["ValveBiped.Bip01_L_Finger02"] = 0.25,
    ["ValveBiped.Bip01_R_Finger4"] = 0.25,
    ["ValveBiped.Bip01_R_Finger41"] = 0.25,
    ["ValveBiped.Bip01_R_Finger42"] = 0.25,
    ["ValveBiped.Bip01_R_Finger3"] = 0.25,
    ["ValveBiped.Bip01_R_Finger31"] = 0.25,
    ["ValveBiped.Bip01_R_Finger32"] = 0.25,
    ["ValveBiped.Bip01_R_Finger2"] = 0.25,
    ["ValveBiped.Bip01_R_Finger21"] = 0.25,
    ["ValveBiped.Bip01_R_Finger22"] = 0.25,
    ["ValveBiped.Bip01_R_Finger1"] = 0.25,
    ["ValveBiped.Bip01_R_Finger11"] = 0.25,
    ["ValveBiped.Bip01_R_Finger12"] = 0.25,
    ["ValveBiped.Bip01_R_Finger0"] = 0.25,
    ["ValveBiped.Bip01_R_Finger01"] = 0.25,
    ["ValveBiped.Bip01_R_Finger02"] = 0.25,
    ["ValveBiped.Bip01_L_Elbow"] = 0.9,
    ["ValveBiped.Bip01_L_Ulna"] = 0.85,
    ["ValveBiped.Bip01_R_Ulna"] = 0.85,
    ["ValveBiped.Bip01_R_Shoulder"] = 1,
    ["ValveBiped.Bip01_L_Shoulder"] = 1,
    ["ValveBiped.Bip01_R_Trapezius"] = 1,
    ["ValveBiped.Bip01_R_Wrist"] = 0.25,
    ["ValveBiped.Bip01_R_Bicep"] = 1,
    ["ValveBiped.Bip01_L_Bicep"] = 1,
    ["ValveBiped.Bip01_L_Trapezius"] = 1,
    ["ValveBiped.Bip01_L_Wrist"] = 0.25,
    ["ValveBiped.Bip01_R_Elbow"] = 0.9
}

function TableGet(tbl,key,fallback)
    local value = tbl[key]
    if value == nil then
        return fallback
    else
        return value 
    end
end 

function SWEP:Deploy()
    self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
end

local DebugMaterial = false

function SWEP:Think()
    if CLIENT and DebugMaterial then
        if IsValid(self.Owner) then
            local vm = self.Owner:GetViewModel()
            vm:SetMaterial("models/debug/debugwhite")
        end
    end
end

function SWEP:DoPrimaryAttack()
    if IsValid(self.Weapon) and IsValid(self.Owner) then
        local tr = self.Owner:GetEyeTrace()
        if tr.Hit then
            local HitPos = tr.HitPos 
            local EyePos = self.Owner:EyePos()
            if EyePos:DistToSqr(HitPos) <= self.Primary.RangeSquared then
                if IsValid( tr.Entity ) then
		    self:EmitSound("kouisine.mp3",150,100,1)
                    local ent = tr.Entity
                    local boneHit = ent:TranslatePhysBoneToBone( tr.PhysicsBone )
                    local boneName = ent:GetBoneName( boneHit )
                    local multiplier = TableGet(BONE_MULTIPLIERS,boneName,1)
                    local force = -40000 * multiplier

                    if SERVER then
                        local dmg = math.Round(self.Primary.Damage * TableGet(BONE_MULTIPLIERS,boneName,1))
                        ent:TakeDamage(self.Primary.Damage,self.Owner,self.Weapon)

                        if ent:IsPlayer() and ent:Alive() and (not ent:HasGodMode()) and (not ent:GetNWBool("memesfryingpan_ragdolled",false)) and (not ent:IsFlagSet(FL_FROZEN)) then
                            ent:ThrowRagdoll(tr,force)
                            ent:BeginUnragdollTimer(5 * multiplier)
                        end
                    end
                else
                    self:PlaceImpactDecal(tr)
                    self.Weapon:EmitSound(self.Primary.WorldImpactSound,100,100,1,CHAN_WEAPON)
                end
            end
        end
    end 
end

function SWEP:PrimaryAttack()
    if SERVER and game.SinglePlayer() then self:CallOnClient("PrimaryAttack") end

    if self:CanPrimaryAttack() then
        timer.Simple(self.Primary.SwingOccursAt, function()
            self:DoPrimaryAttack()
        end)
    end
end

--


--[[ if CLIENT then
	local WorldModel = ClientsideModel( SWEP.WorldModel )

	-- Settings...
	WorldModel:SetSkin( 1 )
	WorldModel:SetNoDraw( true )

	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if ( IsValid( _Owner ) ) then
			-- Specify a good position
			local offsetVec = Vector( 3, -1, -10 )
			local offsetAng = Angle( 90, 0, 0 )

			local boneid = _Owner:LookupBone( "ValveBiped.Bip01_R_Hand" ) -- Right Hand
			if !boneid then return end

			local matrix = _Owner:GetBoneMatrix( boneid )
			if !matrix then return end

			local newPos, newAng = LocalToWorld( offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles() )

			WorldModel:SetPos( newPos )
			WorldModel:SetAngles( newAng )

			WorldModel:SetupBones()
		else
			WorldModel:SetPos( self:GetPos() )
			WorldModel:SetAngles( self:GetAngles() )
		end

		WorldModel:DrawModel()
	end
end
 ]]
--