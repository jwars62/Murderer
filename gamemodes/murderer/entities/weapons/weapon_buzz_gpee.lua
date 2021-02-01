----------------------------------------------------------------------------------------------------------------|
--Buzzofwar-- Please do not steal or copy this! I  put much effort and time into perfecting it to make it simple|
----------------------------------------------------------------------------------------------------------------|

//General Settings \\
SWEP.Author 			= "Buzzofwar"                           -- Your name.
SWEP.Contact 			= "Buzzofwar"                     		-- How Pepole chould contact you.
SWEP.base 				= "weapon_base"							-- What base should the swep be based on.
SWEP.ViewModel 			= "models/weapons/c_arms_citizen.mdl" 	-- The viewModel, the model you se when you are holding it.
SWEP.WorldModel 		= ""   									-- The worlmodel, The model yu when it's down on the ground.
SWEP.HoldType 			= "normal"                            	-- How the swep is hold Pistol smg greanade melee.
SWEP.PrintName 			= "GMod Pee 2.0"                         	-- your sweps name.
SWEP.Category 			= "Gmod Pee Mod"                		-- Make your own catogory for the swep.
SWEP.ReloadSound 		= ""           							-- Reload sound.
SWEP.Instructions 		= "Pee with left click"              	-- How do pepole use your swep.
SWEP.Purpose 			= "Sometimes you just got to go"        -- What is the purpose with this.
SWEP.AdminSpawnable 	= true                          		-- Is the swep spawnable for admin.
SWEP.ViewModelFlip 		= true									-- If the model should be fliped when you see it.
SWEP.UseHands			= false									-- Weather the player model should use its hands.
SWEP.AutoSwitchTo 		= true                           		-- when someone walks over the swep, chould i automatectly change to your swep.
SWEP.Spawnable 			= true                               	-- Can everybody spawn this swep.
SWEP.AutoSwitchFrom 	= true                         			-- Does the weapon get changed by other sweps if you pick them up.
SWEP.FiresUnderwater 	= true                       			-- Does your swep fire under water.
SWEP.DrawCrosshair 		= false                           		-- Do you want it to have a crosshair.
SWEP.DrawAmmo 			= false                                 -- Does the ammo show up when you are using it.
SWEP.ViewModelFOV 		= 50                             		-- How much of the weapon do u see.
SWEP.Weight 			= 0                                   	-- Chose the weight of the Swep.
SWEP.SlotPos 			= 0                                    	-- Deside wich slot you want your swep do be in.
SWEP.Slot 				= 0                                     -- Deside wich slot you want your swep do be in.
SWEP.SwayScale			= 0										-- The Sway.
SWEP.BobScale			= 0										-- The amount of bob there should be.
//General settings\\
--------------------------------------------------------------------------------|
SWEP.Base						= "weapon_base"
SWEP.Primary.Ammo         		= "none"
SWEP.Primary.Sound 				= "npc/roller/mine/rmine_explode_shock1.wav" 
SWEP.Primary.TakeAmmo 			= 0
SWEP.Primary.Recoil				= 0
SWEP.Primary.Spread 			= 0  
SWEP.Primary.Damage				= 0
SWEP.Primary.ClipSize			= -1
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.NumberofShots 		= 0
SWEP.Primary.Delay 				= .02
SWEP.Primary.Force 				= 0
SWEP.Primary.Automatic   		= true							
SWEP.Primary.BulletShot 		= true
--------------------------------------------------------------------------------|
SWEP.Secondary.ClipSize			= -1
SWEP.Secondary.DefaultClip		= -1
SWEP.Secondary.Automatic		= false
SWEP.Secondary.Ammo				= "none"
SWEP.Secondary.Delay 			= 8
--------------------------------------------------------------------------------|
--------------------------------------------------------------------------------|
local ShootSound = Sound ("piss/piss.wav");
local ShootSound2 = Sound ("piss/peeeepeeee.mp3");
local unzip = Sound ("piss/zipperdown.wav");
local zip = Sound ("piss/zipperup.wav");

function SWEP:Initialize()  
self:SetWeaponHoldType( self.HoldType )
util.PrecacheSound(self.Primary.Sound) 
 self.Weapon:EmitSound (unzip);
end 
function SWEP:OnRemove()
 self.Weapon:EmitSound (zip);
return true 
end
function SWEP:Deploy()
 self.Weapon:EmitSound (unzip);
end
function SWEP:Holster()
self.Weapon:EmitSound (zip);
return true
end
function SWEP:Think()

end

function SWEP:throw_attack(range)
       
       self.Weapon:EmitSound (ShootSound)
        if (!SERVER) then return end;
		
		
        local ent = ents.Create ("ent_2_pee");
		local ang = self.Owner:GetAimVector():Angle()
		local trail = util.SpriteTrail(ent, 0, Color(255,255,0), false, 5, 1, .2, 1/(15+1)*0.5, "trails/laser.vmt")
		ent:SetPos(self.Owner:GetShootPos() +ang:Forward() *5 +ang:Right() *0 +ang:Up() *-30)
       	ent:SetAngles(ang)
		ent:SetOwner(self.Owner)
        ent:Spawn();
		local phys = ent:GetPhysicsObject();
        phys:ApplyForceCenter (self.Owner:GetAimVector():GetNormalized() * range);
		phys:AddAngleVelocity(Vector(0,2,0))
		if IsValid(phys) then
		phys:ApplyForceCenter(ang:Forward() *0 +ang:Up() *165)
		phys:AddAngleVelocity(Vector(0,0,0))
	end
		
end

function SWEP:PrimaryAttack()
local ply = self.Owner:EyeAngles().y
self.Owner:SetEyeAngles(Angle(0, ply, 0))
self:throw_attack (75);

self.Weapon:SetNextPrimaryFire( CurTime() + 0.9 )
self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
end

function SWEP:SecondaryAttack()

self.Weapon:EmitSound (ShootSound2);

end

function SWEP:Reload()
end