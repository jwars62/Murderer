AddCSLuaFile()

// Cloudscript version of ninja knife...

if CLIENT then
	language.Add("weapon_ninjaknife", "Ninja Knife")
end

SWEP.PrintName = "Ninja Knife"
SWEP.Author = "Emi"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.Slot			= 1; 
	
//SWEP.Base = "weapon_base"

SWEP.Category = "Toybox Classics"

SWEP.Primary.Ammo = false
SWEP.Secondary.Ammo = false

SWEP.UseHands = true

SWEP.AnimPrefix = "knife"

local tFallback = {
	["ViewModel"] = {
		[0] = "models/weapons/c_crowbar.mdl",
		[1] = "models/weapons/cstrike/c_knife_t.mdl",
		[2] = "models/weapons/v_models/v_knife_spy.mdl"
	},
	["Anims"] = {
		[2] = {
			["draw"] = "draw",
			["idle"] = "idle",
			["backstab_idle"] = "backstab_idle",
			["backstab_down"] = "backstab_down",
			["backstab_up"] = "backstab_up",
			["_slashes"] = {"stab_a","stab_b","stab_c"},
			["_dmgdelay"] = 0.1,
			["_blood"] = {Vector(1, 0, 0), Vector(0, -1, 0), Vector(0, 1, 0)},
			["backstab"] = "backstab",
		},
		[1] = {
			["draw"] = "draw",
			["idle"] = "idle",
			["backstab_idle"] = "idle",
			["backstab_down"] = "__noanim__",
			["backstab_up"] = "__noanim__",
			["_slashes"] = {"midslash1","midslash2"},
			["_dmgdelay"] = 0.2,
			["_blood"] = {Vector(0, -1, 0), Vector(0, -1, 0)},
			["backstab"] = "stab",
		},
		[0] = {
			["draw"] = "draw",
			["idle"] = "idle01",
			["backstab_idle"] = "idle01",
			["backstab_down"] = "__noanim__",
			["backstab_up"] = "__noanim__",
			["_slashes"] = {"misscenter1","misscenter2"},
			["_dmgdelay"] = 0.1,
			["_blood"] = {Vector(0, 1, -2), Vector(0, 1, -1)},
			["backstab"] = "hitkill1",
		},
	},
	["Sounds"] = {
		[2] = {
			["sndKnifeHit"] = Sound("Weapon_Knife.HitFlesh"),
			["sndKnifeWorld"] = Sound("Weapon_Knife.HitWorld"),
			["sndKnifeSwing"] = Sound("Weapon_Knife.Miss"),
			["sndKnifeStab"] = Sound("Weapon_Knife.Stab"),
		},
		[1] = {
			["sndKnifeHit"] = Sound("Weapon_Knife.Hit"),
			["sndKnifeWorld"] = Sound("Weapon_Knife.HitWall"),
			["sndKnifeSwing"] = Sound("Weapon_Knife.Slash"),
			["sndKnifeStab"] = Sound("Weapon_Knife.Stab"),
		},
		[0] = {
			["sndKnifeHit"] = Sound("Weapon_Crowbar.Melee_Hit"),
			["sndKnifeWorld"] = Sound("Weapon_Crowbar.Melee_HitWorld"),
			["sndKnifeSwing"] = Sound("Weapon_Crowbar.Single"),
			["sndKnifeStab"] = Sound("Weapon_Crowbar.Melee_Hit"),
		},
	},
	["AnimPrefix"] = {
		[2] = "knife",
		[1] = "knife",
		[0] = "melee",
	},
}

local AllowCSS = file.Exists("models/weapons/v_knife_t.mdl", "GAME")
local AllowTF2 = file.Exists("models/weapons/v_models/v_knife_spy.mdl", "GAME")

local DefaultIndex = 0
if(AllowTF2) then
	DefaultIndex = 2
elseif(AllowCSS) then
	DefaultIndex = 1
else
	DefaultIndex = 0
end

SWEP.ViewModel = tFallback["ViewModel"][DefaultIndex]	
SWEP.WorldModel = "models/weapons/w_knife_t.mdl"

//AccessorFuncNW(SWEP,"m_bCloaked","Cloaked",false,FORCE_BOOL)

function SWEP:GetCloaked()
	return self:GetNetworkedBool("m_bCloaked",false)
end

local function LoadViewModelIndex()
	if(!file.Exists("nk.txt", "DATA")) then
		return nil
	end
	
	return tonumber(file.Read("nk.txt", "DATA"))
end

local function SaveViewModelIndex(id)
	file.Write("nk.txt", tostring(id))
end


function SWEP:SetupDataTables()
	self:NetworkVar("Float", 0, "ViewModelIndex")
	self:NetworkVar("Float", 1, "KnifeCount")
	self:NetworkVar("Entity", 2, "DashStabTarget")
end

local Spy = CreateConVar("nk_spymode","1", bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED))

local tBlood =
{
	["npc_antlionguard"] =
	{
		["Type"] = "SingleColour",
		["Colour"] = Vector(255,255,0),
	},
	["npc_antlion"] =
	{
		["Type"] = "SingleColour",
		["Colour"] = Vector(255,255,0),
	},
	["npc_antlion_grub"] =
	{
		["Type"] = "SingleColour",
		["Colour"] = Vector(255,255,0),
	},
	["npc_antlion_worker"] =
	{
		["Type"] = "SingleColour",
		["Colour"] = Vector(255,255,128),
	},
	["npc_barnacle"] =
	{
		["Type"] = "SingleColour",
		["Colour"] = Vector(255,255,0),
	},
	["npc_fastzombie_torso"] =
	{
		["Type"] = "SingleColour",
		["Colour"] = Vector(255,255,0),
	},
	["npc_fastzombie"] =
	{
		["Type"] = "SingleColour",
		["Colour"] = Vector(255,255,0),
	},
	["npc_headcrab"] =
	{
		["Type"] = "SingleColour",
		["Colour"] = Vector(255,255,0),
	},
	["npc_headcrab_black"] =
	{
		["Type"] = "SingleColour",
		["Colour"] = Vector(255,255,0),
	},
	["npc_headcrab_poison"] = // Did you know there were two different kinds? I didnt, until I stabbed a black headcrab that had jumped off of a poison zombie. Apparently they get their own classname.
	{
		["Type"] = "SingleColour",
		["Colour"] = Vector(255,255,0),
	},
	["npc_headcrab_fast"] =
	{
		["Type"] = "SingleColour",
		["Colour"] = Vector(255,255,0),
	},
	["npc_poisonzombie"] =
	{
		["Type"] = "SingleColour",
		["Colour"] = Vector(255,255,0),
	},
	["npc_zombie"] =
	{
		["Type"] = "SingleColour",
		["Colour"] = Vector(255,255,0),
	},
	["npc_zombie_torso"] =
	{
		["Type"] = "SingleColour",
		["Colour"] = Vector(255,255,0),
	},
	["npc_zombine"] =
	{
		["Type"] = "SingleColour",
		["Colour"] = Vector(255,255,0),
	},
	["npc_combine_camera"] =
	{
		["Type"] = "Sparks",
	},
	["npc_cscanner"] =
	{
		["Type"] = "Sparks",
	},
	["npc_clawscanner"] =
	{
		["Type"] = "Sparks",
	},
	["npc_helicopter"] =
	{
		["Type"] = "Sparks",
	},
	["npc_gunship"] =
	{
		["Type"] = "Sparks",
	},
	["npc_combinedropship"] =
	{
		["Type"] = "Sparks",
	},
	["npc_dog"] =
	{
		["Type"] = "Sparks",
	},
	["npc_hunter"] =
	{
		["Type"] = "SingleColour",
		["Colour"] = Vector(225,225,225),
	},
	["npc_manhack"] =
	{
		["Type"] = "Sparks",
	},
	["npc_rollermine"] =
	{
		["Type"] = "Sparks",
	},
	["npc_turret_floor"] =
	{
		["Type"] = "Sparks",
	},
	["npc_strider"] =
	{
		["Type"] = "Sparks",
	},
}

function SWEP:EmitBlood(Ent, Pos, Dir, Min, Max)
	if(!tBlood[Ent:GetClass()]) then
		local ED = EffectData()
		ED:SetOrigin(Pos)
		--ED:SetNormal(Dir)
		ED:SetScale(8)
		ED:SetMagnitude(512)
		ED:SetStart(Vector(255,0,0))
		for i=1, math.random(Min,Max) do
			util.Effect("bloodstream_nk",ED)
		end
	elseif(tBlood[Ent:GetClass()]["Type"] == "SingleColour") then
		local ED = EffectData()
		ED:SetOrigin(Pos)
		ED:SetNormal(Dir)
		ED:SetScale(8)
		ED:SetMagnitude(512)
		ED:SetStart(tBlood[Ent:GetClass()]["Colour"])
		for i=1, math.random(Min,Max) do
			util.Effect("bloodstream_nk",ED)
		end
	elseif(tBlood[Ent:GetClass()]["Type"] == "MultiColour") then
		local tColours = tBlood[Ent:GetClass()]["Colours"]
		local ED = EffectData()
		ED:SetOrigin(Pos)
		ED:SetNormal(Dir)
		ED:SetScale(8)
		ED:SetMagnitude(512)
		for i=1, math.random(Min,Max) do
			ED:SetStart(tColours[math.random(1,#tColours)])
			util.Effect("bloodstream_nk",ED)
		end
	elseif(tBlood[Ent:GetClass()]["Type"] == "Sparks") then
		local ED = EffectData()
		ED:SetOrigin(Pos)
		ED:SetNormal(Dir)
		ED:SetScale(256)
		ED:SetMagnitude(256)
		util.Effect("manhacksparks",ED)
	end
end

if(SERVER) then

__NinjaKnife_Thrown_Knives_Table = __NinjaKnife_Thrown_Knives_Table or {}
local KNIFE_OFFSET_ANGLE = Angle(60,0,0)
local KNIFE_RAGSEARCH_RANGE = 32
local KNIFE_PICKUP_RANGE = 64

local KnifeThrowSound = Sound("Weapon_Crowbar.Single") // Bleh.
local KnifeStickFlesh = Sound("Weapon_Crossbow.BoltHitBody")
local KnifeStickObj = Sound("Weapon_Crossbow.BoltHitWorld")

local function FixKnife(dead,Knife)
	Knife:SetParent(NULL)

	local Ragdolls = ents.FindInSphere(Knife:LocalToWorld(Knife:OBBCenter()), KNIFE_RAGSEARCH_RANGE)
	for _,R in pairs(Ragdolls) do
		if(R:GetClass() == "prop_ragdoll" || R:GetClass() == "hl2mp_ragdoll") then
			if(R:GetModel() == Knife.RagdollModel) then
				Knife:PhysicsInit(SOLID_VPHYSICS)
				Knife:SetMoveType(MOVETYPE_VPHYSICS)
				Knife:SetLocalVelocity(R:GetPhysicsObjectNum(Knife.RagdollBone):GetVelocity())
				Knife:SetPos(R:GetPhysicsObjectNum(Knife.RagdollBone):LocalToWorld(R:GetPhysicsObjectNum(Knife.RagdollBone):GetMassCenter()) + Knife.Normal * 8)
				Knife:SetAngles((Knife.Normal * -1):Angle() + KNIFE_OFFSET_ANGLE)
				constraint.Weld(Knife, R, 0, Knife.RagdollBone, 0, true)
				Knife.FindRagdoll = false
				Knife.RagdollModel = nil
				Knife.RagdollBone = nil
				Knife.Normal = nil
				break
			end
		end
	end
	
	if(Knife.FindRagdoll) then
		Knife:PhysicsInit(SOLID_VPHYSICS)
		Knife:SetMoveType(MOVETYPE_VPHYSICS)
		Knife:GetPhysicsObject():ApplyForceCenter(Knife.Normal * 1024 + Vector(0,0,512))
		Knife.FindRagdoll = false
		Knife.RagdollModel = nil
		Knife.RagdollBone = nil
		Knife.Normal = nil
	end
end

local function ThrownTick()
	for i,Knife in pairs(__NinjaKnife_Thrown_Knives_Table) do
		if(!IsValid(Knife)) then
			table.remove(__NinjaKnife_Thrown_Knives_Table, i)
		else	
			if(Knife.FindRagdoll == nil) then
				// Make the knife spin. Since I'm using MOVETYPE_FLYGRAVITY instead of MOVETYPE_VPHYSICS, I can't use AddAngleVelocity.
				Knife:SetAngles(Knife:GetAngles() + Angle(720 * FrameTime(), 0, 0))

				local pos = Knife:GetPos()
				local ang = Knife:GetVelocity():GetNormalized():Angle():Forward()
				local spd = Knife:GetVelocity():Length()
				
				local Trace = {
					start = pos,
					endpos = pos + ang * math.max(spd * 2,Knife:BoundingRadius()) * FrameTime(),
					filter = {Knife,Knife:GetOwner()},
				}
				
				local tr = util.TraceLine(Trace)
				
				if(!tr.Hit) then
					Trace.mask = MASK_NPCSOLID_BRUSHONLY
					Trace.endpos = pos + ang:Angle():Up() * -1 * math.max(spd / 4,Knife:BoundingRadius()) * FrameTime()
					tr = util.TraceLine(Trace)
				end
				if(!tr.Hit) then
					Trace.endpos = pos + ang:Angle():Up() * math.max(spd / 4,Knife:BoundingRadius()) * FrameTime()
					tr = util.TraceLine(Trace)
				end
				if(!tr.Hit) then
					Trace.endpos = pos + ang:Angle():Right() * -1 * math.max(spd / 4,Knife:BoundingRadius()) * FrameTime()
					tr = util.TraceLine(Trace)
				end
				if(!tr.Hit) then
					Trace.endpos = pos + ang:Angle():Right() * math.max(spd / 4,Knife:BoundingRadius()) * FrameTime()
					tr = util.TraceLine(Trace)
				end
				
				if(tr.Hit) then
					Knife.Trail:Remove()
				end
				
				if(IsValid(tr.Entity)) then
					// Stick a knife in em.
					// Step one: Kill them.
					tr.Entity:TakeDamage(100, Knife:GetOwner(), Knife)
					if(tr.Entity:IsNPC() && tr.Entity:Health() <= 0 && util.IsValidRagdoll(tr.Entity:GetModel())) then
						Knife.FindRagdoll = true
						Knife.RagdollModel = tr.Entity:GetModel()
						Knife.RagdollBone = tr.PhysicsBone
						Knife.Normal = tr.HitNormal
						Knife:EmitBlood(tr.Entity, tr.HitPos, tr.HitNormal, 4, 10)
						Knife:EmitSound(KnifeStickFlesh)
						// The rest of the steps are continued on the next tick hopefully the entity dies by then. If not, Ill have to make some changes.
					elseif(tr.Entity:IsNPC() && tr.Entity:Health() > 0) then
						// Strong NPC. Stick in them using parenting method, but make sure to stay alive after the parent is "removed".
						Knife.FindRagdoll = false
						Knife:SetAngles((tr.HitNormal * -1):Angle() + KNIFE_OFFSET_ANGLE)
						Knife:SetLocalVelocity(Vector()*0)
						Knife:SetMoveType(MOVETYPE_NOCLIP)
						Knife:SetParent(tr.Entity)
						Knife.RagdollModel = tr.Entity:GetModel()
						Knife.RagdollBone = tr.PhysicsBone
						Knife.Normal = tr.HitNormal
						tr.Entity:CallOnRemove("KnifeFixer_" .. Knife:EntIndex(),FixKnife,Knife)

						if(tr.MatType == MAT_FLESH || tr.MatType == MAT_ALIENFLESH || tr.MatType == MAT_ANTLION || tr.MatType == 45) then // 45 = metropolice helmet.
							Knife:EmitSound(KnifeStickFlesh)
							if(IsValid(tr.Entity)) then Knife:EmitBlood(tr.Entity, tr.HitPos, tr.HitNormal, 1, 2) end
						else
							Knife:EmitSound(KnifeStickObj)
						end
					elseif(!tr.Entity:IsNPC() && util.IsValidProp(tr.Entity:GetModel()) || util.IsValidRagdoll(tr.Entity:GetModel())) then
						Knife.FindRagdoll = false
						Knife:SetPos(tr.HitPos + tr.HitNormal * 8)
						Knife:SetAngles((tr.HitNormal * -1):Angle() + KNIFE_OFFSET_ANGLE)
						Knife:PhysicsInit(SOLID_VPHYSICS)
						Knife:SetMoveType(MOVETYPE_VPHYSICS)

						local PhysObj = tr.Entity:GetPhysicsObjectNum(tr.PhysicsBone)
						if(IsValid(PhysObj)) then
							PhysObj:ApplyForceOffset(tr.Normal * spd, tr.HitPos)
							Knife:GetPhysicsObject():SetVelocity(PhysObj:GetVelocity())
							constraint.Weld(Knife, tr.Entity, 0, tr.PhysicsBone or 0, 0, true, false)
						else
							Knife:GetPhysicsObject():ApplyForceOffset(tr.HitNormal * 1024 + Vector(0,0,512), tr.HitPos)
						end
						
						if(tr.MatType == MAT_FLESH || tr.MatType == MAT_ALIENFLESH || tr.MatType == MAT_ANTLION || tr.MatType == 45) then // 45 = metropolice helmet.
							Knife:EmitSound(KnifeStickFlesh)
							if(IsValid(tr.Entity)) then Knife:EmitBlood(tr.Entity, tr.HitPos, tr.HitNormal, 1, 2) end
						else
							Knife:EmitSound(KnifeStickObj)
						end
					elseif(tr.Entity:GetMaxHealth() > 0) then // Breakable bmodel. The glass on cs_office is evil.
						tr.Entity:Fire("break","",0)
						tr.Entity:Fire("kill","",0.05)
						Knife:PhysicsInit(SOLID_VPHYSICS)
						Knife:SetMoveType(MOVETYPE_VPHYSICS)
						Knife:GetPhysicsObject():ApplyForceOffset(tr.HitNormal * 1024 + Vector(0,0,512), tr.HitPos)
						Knife:EmitSound(KnifeStickObj)
						Knife.FindRagdoll = false
					else
						// Treat it like world - it probably is?
						Knife:SetPos(tr.HitPos + tr.HitNormal * 8)
						Knife:SetAngles((tr.HitNormal * -1):Angle() + KNIFE_OFFSET_ANGLE)
						Knife:SetLocalVelocity(Vector() * 0)
						Knife:SetMoveType(MOVETYPE_NONE)
						Knife:EmitSound(KnifeStickObj)
						Knife.FindRagdoll = false
					end
				elseif(tr.HitWorld && !tr.HitNoDraw) then
					Knife:SetPos(tr.HitPos + tr.HitNormal * 8)
					Knife:SetAngles((tr.HitNormal * -1):Angle() + KNIFE_OFFSET_ANGLE)
					Knife:SetLocalVelocity(Vector() * 0)
					Knife:SetMoveType(MOVETYPE_NONE)
					Knife:EmitSound(KnifeStickObj)
					Knife.FindRagdoll = false
				elseif(tr.Hit) then
					if(!tr.HitNoDraw) then
						Msg("Magical removal! Dumping trace table...\n")
						for k,v in pairs(tr) do
							Msg("\t",k,"\t=\t",v,"\n")
						end
					end
	//				Knife:EmitSound(KnifeStickObj)
					Knife:Remove() // Might revise this.
					table.remove(__NinjaKnife_Thrown_Knives_Table, i)
				end
			elseif(Knife.FindRagdoll == true) then
				// Try to find a ragdoll for the following ticks.
				Knife.TickCounter = (Knife.TickCounter or 0) + 1
				if(Knife.TickCounter > 5) then
					// Abort the "stick" method, drop the knife. NOTE: May have to increase this for antguard? Long death sequence...
					// After testing, the only long death sequence is via conventional means - with this knife, it dies instantly...
					Knife:PhysicsInit(SOLID_VPHYSICS)
					Knife:SetMoveType(MOVETYPE_VPHYSICS)
					Knife:GetPhysicsObject():ApplyForceCenter(Knife.Normal * 1024 + Vector(0,0,512))
					Knife.FindRagdoll = false
				else
					local Ragdolls = ents.FindInSphere(Knife:LocalToWorld(Knife:OBBCenter()), KNIFE_RAGSEARCH_RANGE)
					for _,R in pairs(Ragdolls) do
						if(R:GetClass() == "prop_ragdoll" || R:GetClass() == "hl2mp_ragdoll") then
							if(R:GetModel() == Knife.RagdollModel) then
								Knife:PhysicsInit(SOLID_VPHYSICS)
								Knife:SetMoveType(MOVETYPE_VPHYSICS)
								Knife:SetLocalVelocity(R:GetPhysicsObjectNum(Knife.RagdollBone):GetVelocity())
								Knife:SetPos(R:GetPhysicsObjectNum(Knife.RagdollBone):LocalToWorld(R:GetPhysicsObjectNum(Knife.RagdollBone):GetMassCenter()) + Knife.Normal * 8)
								Knife:SetAngles((Knife.Normal * -1):Angle() + KNIFE_OFFSET_ANGLE)
								constraint.Weld(Knife, R, 0, Knife.RagdollBone, 0, true, false)
								Knife.FindRagdoll = false
								Knife.RagdollModel = nil
								Knife.RagdollBone = nil
								Knife.Normal = nil
								break
							end
						end
					end
				end
			elseif(Knife.FindRagdoll == false) then
				local Players = player.GetAll()
				for _,P in pairs(Players) do
					if(table.HasValue(Knife:EntsInCone(P:GetShootPos(),P:GetAimVector(),64,30),Knife) && P:KeyDown(IN_USE)) then
						local Weap = P:GetWeapon(__NinjaKnife_Classname)
						if(!IsValid(Weap)) then
							Weap = P:GetWeapon(Knife.WeaponClass)
						end
						
						if(!IsValid(Weap)) then
							Weap = P:Give(__NinjaKnife_Classname)
							Weap:SetKnifeCount(1)
							P:SelectWeapon(__NinjaKnife_Classname)
						else
							Weap:PickedUpKnife()
						end
							
						Knife:Fire("Kill","",0.05) // Why use Kill? I'm not sure if Entity:Remove calls the CallOnRemove's...
						table.remove(__NinjaKnife_Thrown_Knives_Table,i)
						
						break
					end
				end
			end
		end
	end
end

if !(DoHook) then hook.Add("Tick", "NKThrownTick", ThrownTick) end
// Intelligent hooking...
local DoHook = true
for k,v in pairs(hook.GetTable()["Tick"]) do
	if(k == "NKThrownTick") then
		DoHook = false
	end
end

local Chain = CreateConVar("nk_chainstabs","0",FCVAR_ARCHIVE)

function SWEP:Initialize(bRe)
	self:SetHoldType(self.AnimPrefix)
	
	__NinjaKnife_Classname = self:GetClass() // Since SWEP.ClassName doesnt exist until a bit later...

	local VMIDX = -1
	if(bRe) then
		VMIDX = self:GetViewModelIndex() or DefaultIndex or 0
	else
		VMIDX = LoadViewModelIndex() or DefaultIndex or 0
	end
	
	if(VMIDX < 0 || VMIDX > 2) then VMIDX = 0 end
	self:SetViewModelIndex(VMIDX)
	
	self.ViewModel = tFallback["ViewModel"][VMIDX]
	
	self:SetNextAnimTime(CurTime())
	self:SetIdleAnimation("idle")
	self:SetDashStabTarget(NULL)
	self:SetCloaked(false)
	self:SetNextReload(CurTime())
	self.iSkin = math.random(0,1)

	self.sndKnifeHit = tFallback["Sounds"][VMIDX]["sndKnifeHit"]
	self.sndKnifeWorld = tFallback["Sounds"][VMIDX]["sndKnifeWorld"]
	self.sndKnifeSwing = tFallback["Sounds"][VMIDX]["sndKnifeSwing"]
	self.sndKnifeStab = tFallback["Sounds"][VMIDX]["sndKnifeStab"]
end

AccessorFunc(SWEP,"m_fNextAnim","NextAnimTime",FORCE_NUMBER)
AccessorFunc(SWEP,"m_sIdleAnim","IdleAnimation",FORCE_STRING)

local function pickrandom(...)
	local t = {...}
	return t[math.random(1,#t)]
end

function SWEP:ForceVMAnim(name)
	if(self.Owner:GetActiveWeapon() != self) then return 0 end

	local SeqTrans = tFallback["Anims"][self:GetViewModelIndex() or 0][name]
	local AddRet = nil
	if(type(SeqTrans) == "string" && SeqTrans == "__noanim__") then return 0 end // Possibly replace with idle animation.
	if(type(SeqTrans) == "table") then
		AddRet = math.random(1,#SeqTrans)
		SeqTrans = SeqTrans[AddRet]
	end
	
	local VM = self.Owner:GetViewModel()
	if(!IsValid(VM)) then
		ErrorNoHalt("Nonexistant viewmodel in ForceVMAnim!\n")
		self:SetNextAnimTime(CurTime() + 0.5)
		return 0.5
	end
	
	VM:SetPlaybackRate(1.0)
	VM:ResetSequence(VM:LookupSequence(SeqTrans) or "draw")
	VM:SetCycle(0)
	self:SetNextAnimTime(CurTime() + VM:SequenceDuration() - 0.05)
	return VM:SequenceDuration(), AddRet
end

local KNIFE_THINK_INTERVAL = 0.1 // s/think
local KNIFE_ANTIFALL_MINVEL = -300 // u/s
function SWEP:Think()
	if(self:GetNextAnimTime() <= CurTime()) then
		self:ForceVMAnim(self:GetIdleAnimation())
	end

	local bHas = (self:GetDashStabTarget() != NULL)

	self:TryFindDSTarget()

	if(bHas && self:GetDashStabTarget() == NULL) then
		self:ForceVMAnim("backstab_down")
		self:SetIdleAnimation("idle")
	elseif(!bHas && self:GetDashStabTarget() != NULL) then
		self:ForceVMAnim("backstab_up")
		self:SetIdleAnimation("backstab_idle")
	end

	self:NextThink(CurTime() + KNIFE_THINK_INTERVAL) // I only override this for a constant interval between thinks.

	local O = self.Owner
	local VZ = O:GetVelocity().z

	if(VZ > KNIFE_ANTIFALL_MINVEL) then
		return true
	end

	local Trace = {
		start = O:GetPos(),
		endpos = O:GetPos() + Vector(0,0,VZ) * KNIFE_THINK_INTERVAL,
		filter = {self, O},
		mins = O:OBBMins(),
		maxs = O:OBBMaxs(),
	}
	local tr = util.TraceEntityHull(Trace,O)
	if(tr.Hit) then
		local AddZ = (KNIFE_ANTIFALL_MINVEL - VZ) * KNIFE_THINK_INTERVAL * 2
		O:SetVelocity(Vector(0,0,AddZ))
	end

	return true
end

function SWEP:Deploy()
	self:ForceVMAnim("draw")
	if(IsValid(self.Owner:GetViewModel())) then self.Owner:GetViewModel():SetSkin(self.iSkin) end

	return true
end

function SWEP:Holster()
	self:SetCloaked(false)
	self.Owner:SetMaterial("")
	self.Owner:GetHands():SetMaterial("")
	self.Owner:DrawWorldModel(true)
	self.Owner:SetNoTarget(false)
	self:SetNextAnimTime(CurTime())
	if(IsValid(self.Owner:GetViewModel())) then self.Owner:GetViewModel():SetSkin(0) end

	return true
end

function SWEP:PrimaryAttack()
	if(self:GetDashStabTarget() != NULL) then
		self:DashStab()
	else
		self:BasicStab()
	end
end

function SWEP:SecondaryAttack()
	if(self.Owner:KeyDown(IN_USE)) then
		self:ThrowKnife()
	else
		self:ToggleCloak()
	end
end

AccessorFunc(SWEP, "m_fNextReload", "NextReload", FORCE_NUMBER)
function SWEP:Reload()
	if(self:GetNextReload() <= CurTime() && self.Owner:KeyDown(IN_USE)) then
		if(!AllowTF2 && !AllowCSS) then return end
	
		local CurIndex = self:GetViewModelIndex()
		local NewIndex = nil
		
		if(AllowTF2 && CurIndex == 2) then
			if(AllowCSS) then
				NewIndex = 1
			elseif(!AllowCSS && self.Owner:KeyDown(IN_SPEED)) then
				NewIndex = 0
			end
		elseif(AllowCSS && CurIndex == 1) then
			if(self.Owner:KeyDown(IN_SPEED)) then
				NewIndex = 0
			elseif(AllowTF2) then
				NewIndex = 2
			else
				NewIndex = nil
			end
		elseif(CurIndex == 0) then
			if(AllowTF2) then
				NewIndex = 2
			elseif(AllowCSS) then
				NewIndex = 1
			else
				NewIndex = nil
			end
		end
	
		if(NewIndex != nil) then
			self:SetViewModelIndex(NewIndex)
			SaveViewModelIndex(NewIndex)
			self:Initialize(true)
			self.Owner:GetViewModel():SetModel(Model(self.ViewModel))
		end
		self:SetNextReload(CurTime() + 1)
	end
end

function SWEP:EquipAmmo(newowner)
	local OtherWeapon = newowner:GetWeapon(__NinjaKnife_Classname)
	if(!IsValid(OtherWeapon)) then
		OtherWeapon = newowner:GetWeapon(self:GetClass())
	end
	
	if(IsValid(OtherWeapon)) then
		OtherWeapon:SetKnifeCount(OtherWeapon:GetKnifeCount() + 4)
		OtherWeapon:PickedUpKnife()
	end
end

function SWEP:Equip(newowner)
//	self:SetKnifeCount(self:GetKnifeCount() + 5)
end

//////////////////////////////////////////////////////////////////////////////////////////
// Functions for the various options													//
//////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////
// PRIMARY ATTACK FUNCTIONS //
//////////////////////////////

////////////////
// BASIC STAB //
////////////////
function SWEP:BasicStab()
	local ABC, Time
	Time, ABC = self:ForceVMAnim("_slashes")
	timer.Simple(tFallback["Anims"][self:GetViewModelIndex()]["_dmgdelay"], function() if IsValid(self) then self:DoStab(ABC) end end)
	
	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	self:SetNextPrimaryFire(CurTime() + Time)
end

local KNIFE_BASIC_RANGE = 64
function SWEP:DoStab(ABC)
	local P = self.Owner

	local Trace = {
		start = P:GetShootPos(),
		endpos = P:GetShootPos() + P:GetAimVector() * KNIFE_BASIC_RANGE,
		filter = {self,P},
		mask = MASK_SHOT_HULL,
		mins = Vector(-4,-4,-4),
		maxs = Vector(4,4,4),
	}

	local tr = util.TraceHull(Trace)

	local DI = DamageInfo()
	DI:SetInflictor(self)
	DI:SetAttacker(self.Owner)
	DI:SetDamage(10)
	DI:SetDamageForce(tr.Normal * 1024)
	DI:SetDamagePosition(tr.HitPos)

	if(tr.Hit) then
		if(tr.Entity:IsPlayer() || tr.Entity:IsNPC()) then
			local Ent = tr.Entity

			self:EmitSound(self.sndKnifeHit)

			if(Ent:IsNPC() || (Ent:IsPlayer() && GAMEMODE:PlayerShouldTakeDamage(Ent,self.Owner,self))) then
				DI:SetDamage(20)
				Ent:TakeDamageInfo(DI) // I really should whip up a DamageInfo to use on this.
			end

			local Forward = P:GetAimVector()
			local RelDir = tFallback["Anims"][self:GetViewModelIndex()]["_blood"][ABC]
			local Normal = (Forward * RelDir.x + Forward:Angle():Right() * -RelDir.y + Forward:Angle():Up() * RelDir.z):GetNormalized()
			self:EmitBlood(Ent, tr.HitPos, Normal, 1, 1)
		elseif(tr.Entity:GetMaxHealth() > 0) then
			if(tr.Entity:GetMaxHealth() <= 5 && tr.Entity:Health() > 0) then
				tr.Entity:Fire("break","",0) // Workaround hack for breakable props...
				tr.Entity:Fire("kill","",0.05)
			end
			// Bleh, not checking materials stuff at all.
			tr.Entity:TakeDamageInfo(DI)
			tr.Entity:TakePhysicsDamage(DI) // This doesnt seem to work unless in scripted entities?
			if(IsValid(tr.Entity:GetPhysicsObject())) then tr.Entity:GetPhysicsObject():ApplyForceOffset(DI:GetDamageForce(),DI:GetDamagePosition()) end
			self:EmitSound(self.sndKnifeWorld)
		else
			// Todo: Decal!
			self:EmitSound(self.sndKnifeWorld)
		end
	else
		self:EmitSound(self.sndKnifeSwing)
	end
end

////////////////////////
// DASHSTAB FUNCTIONS //
////////////////////////
function SWEP:EntsInCone(pos,dir,range,fov)
	local tEnts = ents.FindInSphere(pos,range)

	for i,Ent in pairs(tEnts) do
		local EPos = Ent:LocalToWorld(Ent:OBBCenter())
		local DirTo = (EPos - pos):GetNormalized()
		local AngleTo = math.deg(math.acos(DirTo:Dot(dir)))
		
		if(AngleTo > fov) then
			tEnts[i] = nil
		end
	end

	return tEnts
end

local KNIFE_DASHSTAB_RANGE = 128
local KNIFE_DASHSTAB_RANGE_CHAIN = 512
local KNIFE_DASHSTAB_FOV = 30
local KNIFE_DASHSTAB_FOV_SPY = 60
function SWEP:TryFindDSTarget()
	local P = self.Owner
	local Range = KNIFE_DASHSTAB_RANGE
	local FOV = KNIFE_DASHSTAB_FOV
	if(Chain:GetBool() == true) then Range = KNIFE_DASHSTAB_RANGE_CHAIN end
	if(Spy:GetBool() == true) then FOV = KNIFE_DASHSTAB_FOV_SPY end
	local Ents = self:EntsInCone(P:GetShootPos(),P:GetAimVector(),Range,FOV)
	local tNPCs = {}
	local tPlayers = {}

	// This logic is a mess - clean it up!
	for _,Ent in pairs(Ents) do
		local EPos = Ent:LocalToWorld(Ent:OBBCenter())
		if(!Spy:GetBool() ||
			(Ent:GetForward():DotProduct(P:GetAimVector()) > 0 && EPos:Distance(P:GetShootPos()) <= Ent:BoundingRadius() * 1.3)
			) then
			if(Ent:IsPlayer() && Ent != P && Ent:Health() > 0 &&
				(!Ent:GetActiveWeapon().GetCloaked || Ent:GetActiveWeapon():GetCloaked() == false)
				) then
				table.insert(tPlayers,Ent)
			elseif(Ent:IsNPC() && Ent:Health() > 0) then
				table.insert(tNPCs,Ent)
			end
		end
	end

	if(GetConVar("sbox_plpldamage") != nil && GetConVar("sbox_plpldamage"):GetBool() == false) then
		if(#tPlayers > 0) then
			self:SetDashStabTarget(tPlayers[math.random(1,#tPlayers)])
		elseif(#tNPCs > 0) then
			self:SetDashStabTarget(tNPCs[math.random(1,#tNPCs)])
		else
			self:SetDashStabTarget(NULL)
		end
		return
	else
		if(#tNPCs > 0) then
			self:SetDashStabTarget(tNPCs[math.random(1,#tNPCs)])
		elseif(#tPlayers > 0) then
			self:SetDashStabTarget(tPlayers[math.random(1,#tPlayers)])
		else
			self:SetDashStabTarget(NULL)
		end
		return
	end
end

function SWEP:DashStab()
	local P = self.Owner
	local E = self:GetDashStabTarget()
	local EnemyForward = E:GetForward()
	if(E:IsPlayer()) then
		local A = E:GetAimVector():Angle()
		A.Pitch = 0
		EnemyForward = A:Forward()
	end

	if(!Spy:GetBool()) then
		P:SetPos(E:GetPos() + EnemyForward * -E:BoundingRadius() * 0.75)
		P:SetEyeAngles(EnemyForward:Angle())
		P:SetLocalVelocity((EnemyForward * -1) * 256 + Vector(0,0,1) * 256)
	end

	local Time = self:ForceVMAnim("backstab")
	self.Owner:SetAnimation( PLAYER_ATTACK1 )
	
	self.Owner:EmitSound(self.sndKnifeStab)
	self:SetIdleAnimation("idle")

	self:EmitBlood(E, E:LocalToWorld(E:OBBCenter()) + Vector(0,0,16), (EnemyForward * -0.5 + Vector(0,0,0.65)):GetNormalized(), 4, 8)

	local DI = DamageInfo()
	DI:SetDamage(E:Health())
	DI:SetDamageForce(EnemyForward * 65535 + Vector(0,0,-1) * 512)
	DI:SetDamagePosition(E:LocalToWorld(E:OBBCenter()) + Vector(0,0,16))
	DI:SetAttacker(P)
	DI:SetInflictor(self)
	if(E:GetClass() == "npc_helicopter") then DI:SetDamageType(DMG_AIRBOAT) end
	
//	E:TakeDamage(E:Health(),P,P)
	E:TakeDamageInfo(DI)
	E:TakePhysicsDamage(DI)
	if(IsValid(E:GetPhysicsObject())) then E:GetPhysicsObject():ApplyForceOffset(DI:GetDamageForce() / 3, DI:GetDamagePosition()) end
	
	self:SetDashStabTarget(NULL)
	if(Chain:GetBool() == false || Spy:GetBool() == true) then self:SetNextPrimaryFire(CurTime() + Time) end
end

////////////////////////////////
// SECONDARY ATTACK FUNCTIONS //
////////////////////////////////

///////////////////////
// KNIFE THROWING //
//////////////////////

local KNIFE_THROW_SPEED = 1024
function SWEP:ThrowKnife()
	local Ent = ents.Create("prop_physics")
	if(IsValid(Ent)) then
		Ent:SetOwner(self.Owner)
		Ent:SetPos(self.Owner:GetShootPos())
		Ent:SetAngles(self.Owner:GetAimVector():Angle())
		Ent:SetModel(self.WorldModel)
		
		if(!AllowCSS) then // No CSS. Dont want missing textures. :|
			Ent:SetMaterial("models/weapons/v_stunbaton/w_shaft01a")
		end

		Ent:Spawn()
		
		Ent:SetSolid(SOLID_NONE)
		Ent:SetNotSolid(true)
		Ent:SetMoveType(MOVETYPE_FLYGRAVITY)
		Ent:SetGravity(0.3)
		Ent:SetVelocity((self.Owner:GetAimVector():Angle() + Angle(-2.5,0,0)):Forward() * KNIFE_THROW_SPEED)
		Ent:Fire("Kill","",60) // Limit the lifespan of these knives regardless of what they hit.
		Ent.EmitBlood = self.EmitBlood
		Ent.EntsInCone = self.EntsInCone
		Ent.WeaponClass = self:GetClass()
		Ent.Trail = util.SpriteTrail(Ent, 0, Color(8,8,8,8), false, 16, 0, 0.25, 1/32, "trails/tube.vmt")
		
		table.insert(__NinjaKnife_Thrown_Knives_Table, Ent)
		
		self:EmitSound(KnifeThrowSound)

		if((self:GetKnifeCount() or 0) > 1) then
			self:SetKnifeCount(self:GetKnifeCount() - 1)
			local Time = self:ForceVMAnim("draw")
			self:SetNextSecondaryFire(CurTime() + Time)
		else
			self:SetCloaked(false)
			self.Owner:StripWeapon(self:GetClass())
		end
	end
end

function SWEP:PickedUpKnife()
	if self:GetKnifeCount() == 0 then
		self:SetKnifeCount(5)
	else
		self:SetKnifeCount(self:GetKnifeCount() + 1)
	end
	self:SetNextSecondaryFire(CurTime() + self:ForceVMAnim("draw"))
end

function SWEP:Equip()
	self:PickedUpKnife()
end

//////////////
// CLOAKING //	
//////////////
function SWEP:SetCloaked(inval)
	if(IsValid(self.Owner)) then
		if(util.tobool(inval) == true) then
			self.Owner:SetMaterial("effects/strider_bulge_dudv") // "sas/camo/refract") // Cloudscript, so I cant use my own materials. :(
			self.Owner:GetHands():SetMaterial("effects/strider_bulge_dudv")
			self.Owner:DrawWorldModel(false)
			self.Owner:SetNoTarget(true)
			self:HideFromNPCs()
		elseif(util.tobool(inval) == false) then
			self.Owner:SetMaterial("")
			self.Owner:GetHands():SetMaterial("")
			self.Owner:DrawWorldModel(true)
			self.Owner:SetNoTarget(false)
			self:AlertNPCs()
			self:SetNetworkedBool("m_bCloaked",false)
		else
			Error("Nil value passed to SetCloaked!\n")
		end
	end

	self:SetNetworkedBool("m_bCloaked",util.tobool(inval))
end

function SWEP:ToggleCloak()
	self:SetCloaked(!self:GetCloaked())

	self:SetNextSecondaryFire(CurTime() + 0.5)
end

function SWEP:HideFromNPCs()
	for i,NPC in pairs(ents.GetAll()) do
		if(NPC:IsNPC() && NPC:GetEnemy() == self.Owner) then
			NPC:MarkEnemyAsEluded(self.Owner)
		end
	end
end

local KNIFE_ALERT_RADIUS = 1024
function SWEP:AlertNPCs()
	for i,NPC in pairs(ents.FindInSphere(self.Owner:GetPos(), KNIFE_ALERT_RADIUS)) do
		if(NPC:IsNPC() && (NPC:Disposition(self.Owner) == D_HT || NPC:Disposition(self.Owner) == D_FR)) then
			if(!IsValid(NPC:GetEnemy())) then // I dunno - should I allow distractions?
				NPC:SetEnemy(self.Owner)
				NPC:UpdateEnemyMemory(self.Owner, self.Owner:GetPos())
			end			
		end
	end
end

//////////////////////
// RELOAD FUNCTIONS //
//////////////////////

function SWEP:OwnerChanged()
	self.OldOwner = self.Owner
end

function SWEP:OnRemove()
	if(IsValid(self.OldOwner)) then
		self.OldOwner:SetMaterial("")
		self.OldOwner:DrawWorldModel(true)
		self.OldOwner:SetNoTarget(false)
	end
end

elseif(CLIENT) then

function SWEP:Initialize()
	self:SetHoldType(tFallback["AnimPrefix"][self:GetViewModelIndex()])

	self.ViewModel = tFallback["ViewModel"][self:GetViewModelIndex()]
end

function SWEP:CustomAmmoDisplay()
	self.tAmmo = self.tAmmo or {}
	self.tAmmo.Draw = true
	return self.tAmmo
end

function SWEP:DrawHUD()
	self.tAmmo = self.tAmmo or {}
	self.tAmmo.Draw = true
	self.tAmmo.PrimaryClip = self:GetKnifeCount()
	self.tAmmo.PrimaryAmmo = -1
	self.tAmmo.SecondaryClip = -1
	self.tAmmo.SecondaryAmmo = -1
end

function SWEP:SetCloaked(inval)
	self:SetNetworkedBool("m_bCloaked", util.tobool(inval))
end

function SWEP:Holster()
	self:SetCloaked(false)
	self:CloakThink()

	return true
end

function SWEP:OnRemove()
	self:Holster()
end

function SWEP:Deploy()
	return true
end

function SWEP:Think()
	self:CloakThink()
	return
end

// TODO: Unnecessary calls to SetMaterial! Fixme!
// Maybe I should hook a proxy to m_bCloaked?
function SWEP:CloakThink()
	if(!IsValid(self.Owner)) then return end
	local VM = self.Owner:GetViewModel()
	if(!IsValid(VM)) then return end // Just wait a while - itll come back, eventually.
	if(self:GetCloaked() == true) then
		VM:SetMaterial("models/props_c17/fisheyelens")
		self.Owner:GetHands():SetMaterial("models/props_c17/fisheyelens")
	elseif(self:GetCloaked() == false) then
		VM:SetMaterial("")
		self.Owner:GetHands():SetMaterial("")
	end
end

// Remove this prediction check - players will always have prediction on...
// I only have it so I can view serverside if I like.
function SWEP:PrimaryAttack()
	if(GetConVar("cl_predictweapons"):GetBool() == true && self:GetDashStabTarget() != NULL) then
		self:CL_DashStab()
	end
end

function SWEP:SecondaryAttack()
	self:CloakThink()
end

function SWEP:Reload()
end

function SWEP:CL_DashStab()
	local P = self.Owner
	local E = self:GetDashStabTarget()

	self:SetDashStabTarget(NULL)

	local Forward = E:GetForward()
	self:EmitBlood(E, E:LocalToWorld(E:OBBCenter()), (Forward * -0.5 + Vector(0,0,0.5)):GetNormalized(), 4, 8)
end

function SWEP:OnRemove()
	if(!IsValid(self.Owner)) then return end
	local VM = self.Owner:GetViewModel()
	if(!IsValid(VM)) then return end // Just wait a while - itll come back, eventually.	
	VM:SetMaterial("")
end

///////////////
// Effect hax //
//////////////

////////////////////////////////////////
// bloodstream_nk										   //
// Shamelessly ripped from the old GMDM. //
///////////////////////////////////////

local EFFECT = {}

local BloodSprite = Material( "effects/bloodstream" )

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
		// Table to hold particles
		self.Particles = {}
		
		self.PlaybackSpeed	 = math.Rand( 2, 5 )
		self.Width			 = math.Rand( 8, 16 )
		self.ParCount		= data:GetScale() or 16
		self.Color			= data:GetStart()
		
		local Dir = VectorRand() * 0.15 + data:GetNormal() * 0.85

		local SpeedMin = data:GetMagnitude() or 1500
		if(data:GetMagnitude() == 0) then
			SpeedMin = 1500
		end
		local SpeedMax = SpeedMin * (5/3)
		local Speed = math.Rand( SpeedMin, SpeedMax )
		
		local SquirtDelay = math.Rand( 1, 3 )
		
		Dir.z = math.max( Dir.z, Dir.z * -1 )
		if (Dir.z > 0.5) then
			Dir.z = Dir.z - 0.5
		end
		
		for i=1, math.random( data:GetScale() / 2, data:GetScale() ) do
		
			Dir = Dir * 0.95 + VectorRand() * 0.02
		
			local p = {}
			
				p.Pos = data:GetOrigin()
				p.Vel = Dir * (Speed * (i /16))
				p.Delay = (16 - i)  * SquirtDelay
				p.Rest = false
			
			table.insert( self.Particles, p )
		
		end

		self.NextThink = CurTime() +  math.Rand( 0, 1 )
	
end


local function VectorMin( v1, v2 )
	
	if ( v1 == nil ) then return v2 end
	if ( v2 == nil ) then return v1 end
	
	local vr = Vector( v2.x, v2.y, v2.z )
	
	if ( v1.x < v2.x ) then vr.x = v1.x end
	if ( v1.y < v2.y ) then vr.y = v1.y end
	if ( v1.z < v2.z ) then vr.z = v1.z end
	
	return vr

end

local function VectorMax( v1, v2 )
	
	if ( v1 == nil ) then return v2 end
	if ( v2 == nil ) then return v1 end
	
	local vr = Vector( v2.x, v2.y, v2.z )
	
	if ( v1.x > v2.x ) then vr.x = v1.x end
	if ( v1.y > v2.y ) then vr.y = v1.y end
	if ( v1.z > v2.z ) then vr.z = v1.z end
	
	return vr

end

/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )

	//if ( self.NextThink > CurTime() ) then return true end

	local FrameSpeed = self.PlaybackSpeed * FrameTime()
	
	local bMoved = false
	local min = self.Entity:GetPos()
	local max = min
	
	self.Width = self.Width - 0.7 * FrameSpeed
	if ( self.Width < 0 ) then
		return false
	end
	
	for k, p in pairs( self.Particles ) do
	
			if ( p.Rest ) then
									
			// Waiting to be spawned. Some particles have an initial delay 
			// to give a stream effect..
			elseif ( p.Delay > 0 ) then
			
				p.Delay = p.Delay - 100 * FrameSpeed
			
			// Normal movement code. Handling particles in Lua isnt great for 
			// performance but since this is clientside and only happening sometimes
			// for short periods - it should be fine.
			else
				
				local InWater = util.PointContents(p.Pos) and CONTENTS_WATER != 0

				// Gravity
				p.Vel:Sub( Vector( 0, 0, 60 * FrameSpeed ) )
				
				// Air resistance
				p.Vel.x = math.Approach( p.Vel.x, 0, 2 * FrameSpeed )
				p.Vel.y = math.Approach( p.Vel.y, 0, 2 * FrameSpeed )
				if(InWater) then
					p.Vel.z = math.Approach( p.Vel.z, 10, 30 * FrameSpeed )
				else
//					p.Vel:Sub( Vector( 0, 0, 60 * FrameSpeed ) )
					p.Vel.z = math.Approach( p.Vel.z, -60, 60 * FrameSpeed )
				end
				
				local trace = {}
				trace.start	 = p.Pos
				trace.endpos	 = p.Pos + p.Vel * FrameSpeed
				trace.mask		 = MASK_NPCWORLDSTATIC
				local tr = util.TraceLine( trace )

				if (tr.Hit) then
								
					tr.HitPos:Add( tr.HitNormal * 2 )
					
					// If we hit the ceiling just stunt the vertical velocity
					// else enter a rested state
					if ( tr.HitNormal.z < -0.75 ) then
					
						p.Vel.z = 0
					
					else
					
						p.Rest = true
					
					end
		
				end
				
				// Add velocity to position
				p.Pos = tr.HitPos
				bMoved = true
			
			end
			
	end
	
	self.ParCount = table.Count( self.Particles )
	
	
	// I really need to make a better/faster way to do this
	if (bMoved) then
	
		for k, p in pairs( self.Particles ) do
		
			min = VectorMin( min, p.Pos )
			max = VectorMax( max, p.Pos )
			
		end

		local Pos = min + ((max - min) * 0.5)
		self.Entity:SetPos( Pos )
		self.Entity:SetCollisionBounds( Pos - min, Pos - max )
		self.Entity:SetRenderBoundsWS(min,max)
	end
	
	
	// Returning false kills the effect
	return (self.ParCount > 0)
	
end


/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()

	render.SetMaterial( BloodSprite )
	
	local LastPos = nil
	local pCount = 0
	
	// I don't know what kind of performance hit this gives us..
	local LightColor = render.GetLightColor( self.Entity:GetPos() ) * 255
	LightColor.r = math.Clamp(LightColor.r, 0.25, 0.75)
	LightColor.g = math.Clamp(LightColor.g, 0.25, 0.75)
	LightColor.b = math.Clamp(LightColor.b, 0.25, 0.75)
	local color = Color( self.Color.x * LightColor.r * 0.5, self.Color.y * LightColor.g * 0.5, self.Color.z * LightColor.b * 0.5, 255 )

	for k, p in pairs( self.Particles ) do
	
		local Sin = math.sin( (pCount / (self.ParCount-2)) * math.pi )
		
		if ( LastPos ) then
		
			render.DrawBeam( LastPos,		 
					 p.Pos,
					 self.Width * Sin,					
					 1,					
					 0,				
					 color )
		
		end
		
		pCount = pCount + 1
		LastPos = p.Pos
	
	end
	
	
	--render.DrawSprite( self.Entity:GetPos(), 32, 32, color_white )
	
end

effects.Register(EFFECT, "bloodstream_nk")

end

 
