sound.Add(
{
    name = "Glowstick.Shake",
    channel = CHAN_USER_BASE+1,
    volume = 0.2,
	pitch = { 95, 110 },
    soundlevel = SNDLVL_IDLE,
    sound = "glowstick/glowstick_shake.wav"
})
sound.Add(
{
    name = "Glowstick.Snap",
    channel = CHAN_USER_BASE+1,
    volume = 0.7,
	pitch = { 95, 110 },
    soundlevel = SNDLVL_IDLE,
    sound = "glowstick/glowstick_snap.wav"
})
	
game.AddAmmoType( {
	name = "glowsticks",
	dmgtype = DMG_CRUSH,
	tracer = TRACER_NONE,
	plydmg = 0,
	npcdmg = 0,
	force = 0,
	maxcarry = 5
} )

cleanup.Register( "glowsticks" )