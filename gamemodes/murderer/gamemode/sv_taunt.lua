taunts = {}

function addTaunt(cat, soundFile, sex)
	if !taunts[cat] then
		taunts[cat] = {}
	end
	if !taunts[cat][sex] then
		taunts[cat][sex] = {}
	end
	local t = {}
	t.sound = soundFile
	t.sex = sex
	t.category = cat
	table.insert(taunts[cat][sex], t)
end

// male
addTaunt("help", "vo/npc/male01/help01.wav", "male")

addTaunt("scream", "vo/npc/male01/runforyourlife01.wav", "male")
addTaunt("scream", "vo/npc/male01/runforyourlife02.wav", "male")
addTaunt("scream", "vo/npc/male01/runforyourlife03.wav", "male")
addTaunt("scream", "vo/npc/male01/watchout.wav", "male")
addTaunt("scream", "vo/npc/male01/gethellout.wav", "male")


// female
addTaunt("help", "vo/npc/female01/help01.wav", "female")

addTaunt("scream", "vo/npc/female01/runforyourlife01.wav", "female")
addTaunt("scream", "vo/npc/female01/runforyourlife02.wav", "female")
addTaunt("scream", "vo/npc/female01/watchout.wav", "female")
addTaunt("scream", "vo/npc/female01/gethellout.wav", "female")


local taunt, taunt_dirs = file.Find( "sound/taunts/custom/*", "DOWNLOAD" )
for i,tauntName in ipairs(taunt) do addTaunt("morose", "../../../download/sound/taunts/custom/" .. tauntName, "female") end
for i,tauntName in ipairs(taunt) do addTaunt("morose", "../../../download/sound/taunts/custom/" .. tauntName, "male") end

local tl = {'01-oh-yeah.mp3',
'12_3.mp3',
'peter_leur_chevilles.mp3',
'padoru-padoru.mp3',
'8-morts-6-blessesma-lubulul.mp3',
'eric-andre-let-me-in-meme.mp3',
'tes-pas-drole-tu-fais-meme-pas-rire',
'AAAAAH.mp3',
'allahu akbar.mp3',
'anime-wow-sound-effect-mp3cut.mp3',
'ara-ara.mp3',
'arouf-gangsta-anerve-interdit-de-paname-ngz-audiotrimmer.mp3',
'arroto_-_timo_pra_msg.mp3',
'asus-yamete-kudasai.mp3',
'badass.mp3',
'blend-w.mp3',
'careless_whispers.mp3',
'Minecraft_Antoine_Daniel_Musi.mp3',
'Enorme_Jamy_c_est_pas_sorcier.mp3',
'antoine-daniel-rire-de-droite.mp3',
'ta-gueule-fanta.mp3',
'ouais-mais-cest-pas-toi-qui-decide.mp3',
'cest-non.mp3',
'cuisine.mp3',
'de-1-quand-tu-parle-tu-begaye.mp3',
'deez nuts.mp3',
'deja-vu.mp3',
'dry-fart.mp3',
'duck-running-in-the-90s.mp3',
"el-vento-d_oro.mp3",
'et-ca-fait-bim-bam-boum-explosion-allah-akbar.mp3',
'euh-nique-ta-mere-marine-le-pen-plus.mp3',
'ffff_1.mp3',
'gabe the dog remix.mp3',
'haaaaaaaaaaaaaaaaaaaaaaa.mp3',
'irch.wav',
'jackass.mp3',
'je-suis-papa-jean-marie-bigard_Zd00IQJ.mp3',
'je-suis-pas-pd-on-baise-pas-dans-mon-cul.mp3',
'kazoo kid.mp3',
'kazoo-kid-song-original.mp3',
'kiniro-mosaic-ayaya-ayaya_Hdugg5f.mp3',
'loituma.mp3',
'maiscenaipaposible.mp3',
'monsters_inc_themeer.mp3',
'motus-boule-noire.mp3',
'movie_1.mp3',
'nanimp3.mp3',
'nein.mp3',
'never gonna hit those notes.mp3',
'noot noot.mp3',
'oh-mon-dieu-les-gens-qui-parlent-en-francais-ils-ont-tellement-de-charisme-pokimane.mp3',
'oni-chan.mp3',
'original_zeowGW1.mp3',
'oui.mp3',
'pokemon-go-song-by-misha.mp3',
'pokemon-theme-song-original2.mp3',
'pornhub-community-intro.mp3',
'rero-rero-rero.mp3',
'rha-rha-rha.mp3',
'ripsave_-_Laink_a_fait_une_grosse_betise_.mp3',
'savage-fap.mp3',
'saxroll.mp3',
'schmula.mp3',
'spooky skeletons.mp3',
'squidward-making-wii-sports-earrape-mp3cut.mp3',
'street_fighter_2_guiles_theme-1.mp3',
'succ.mp3',
'thomas the rapper.mp3',
'tmpdbnm_5a3.mp3',
'tout_allume_2.mp3',
'ussr-anthem-short2.mp3',
'veterinaire.mp3',
'waw.mp3',
'well-be-right-back.mp3',
'why-are.mp3'}

function Savet()
	local taunt, taunt_dirs = file.Find( "sound/taunts/*", "GAME" )
	local txt = ""
	for k, map in pairs(taunt) do
			txt = txt .. "'" .. map .. "';\r\n"
	end
	file.Write("murder/tauntlist.txt", txt)
end

concommand.Add( "mu_Save_taunt", function()
	Savet()
end) 


for i,tauntName in ipairs(tl) do addTaunt("funny", "taunts/" .. tauntName, "female") end
for i,tauntName in ipairs(tl) do addTaunt("funny", "taunts/" .. tauntName, "male") end

function GM:lst()
	return taunts["funny"]
end

concommand.Add("mu_taunt", function (ply, com, args, full)
	if ply.LastTaunt && ply.LastTaunt > CurTime() then return end
	if !ply:Alive() then return end
	if ply:Team() != 2 then return end

	if #args < 1 then return end
	local cat = args[1]:lower()
	if !taunts[cat] then return end

	local sex = string.lower(ply.ModelSex or "male")
	if !taunts[cat][sex] then return end

	local taunt = table.Random(taunts[cat][sex])
	ply:EmitSound(taunt.sound)

	ply.LastTaunt = CurTime() + SoundDuration(taunt.sound) + 0.3
end)