if SERVER then
	AddCSLuaFile()
end

sound.Add(
	{
		name = "WT_RocketBoots.Thrust",
		sound = "^thrusters/rocket04.wav",
		channel = CHAN_BODY,
		pitchstart = 100,
		pitchend = 100,
		level = 80,
		volume = 1.0,
	}
)


sound.Add(
	{
		name = "WT_RocketBoots.Launch",
		sound = "^thrusters/rocket04.wav",
		channel = CHAN_BODY,
		pitchstart = 100,
		pitchend = 100,
		level = 110,
		volume = 1.0,
	}
)

