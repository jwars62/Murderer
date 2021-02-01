resource.AddFile("materials/vgui/entities/glowstick.vmt")
resource.AddFile("materials/vgui/entities/glowstick.vtf")
resource.AddFile("models/glowstick/v_glowstick.mdl")
resource.AddFile("models/glowstick/stick.mdl")
resource.AddFile("materials/models/glowstick/glow.vmt")
resource.AddFile("materials/models/glowstick/glow.vtf")
resource.AddFile("materials/models/glowstick/01.vmt")
resource.AddFile("materials/models/glowstick/01.vtf")
resource.AddFile("glowstick/glowstick_shake.wav")
resource.AddFile("glowstick/glowstick_snap.wav")

CreateConVar( "gmod_glowsticks_lifetime_infinite", "0", FCVAR_NOTIFY, "Sets glow stick's lifetime to infinite")
CreateConVar( "gmod_glowsticks_lifetime", "25", FCVAR_NOTIFY, "Sets glow stick's lifetime in seconds")

hook.Add( "PlayerInitialSpawn", "GlowSticksSpawnAndSay", 
	function( ply ) 
		ply:PrintMessage( HUD_PRINTTALK, "Glow Sticks are available on this server. Customization is also available in the Options menu!" )
	end )