include('shared.lua')

SWEP.PrintName = "Jihad Bomb"
SWEP.Category = "Doktor haus' SWEPs"		
SWEP.Slot = 3
SWEP.SlotPos = 0
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.WepSelectIcon = surface.GetTextureID("vgui/hud/weapon_jihadbomb")
killicon.Add( "env_explosion", "vgui/hud/kill/weapon_jihadbomb", Color(255,255,255, 150) )

function SWEP:WorldBoom()
	surface.EmitSound( "JihadBomb.Explode" )
end