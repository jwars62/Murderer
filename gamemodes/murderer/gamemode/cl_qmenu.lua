local ments

local radialOpen = false
local prevSelected, prevSelectedVertex

function GM:OpenRadialMenu(elements)
	if isopened == false then
		radialOpen = true
		gui.EnableScreenClicker(true)
		ments = elements or {}
		prevSelected = nil
	end
end

function GM:CloseRadialMenu()
	radialOpen = false
	gui.EnableScreenClicker(false)
end

local function getSelected()
	local mx, my = gui.MousePos()
	local sw,sh = ScrW(), ScrH()
	local total = #ments
	local w = math.min(sw * 0.45, sh * 0.45)
	local h = w
	local sx, sy = sw / 2, sh / 2
	local x2,y2 = mx - sx, my - sy
	local ang = 0
	local dis = math.sqrt(x2 ^ 2 + y2 ^ 2)
	if dis / w <= 1 then
		if y2 <= 0 && x2 <= 0 then
			ang = math.acos(x2 / dis)
		elseif x2 > 0 && y2 <= 0 then
			ang = -math.asin(y2 / dis)
		elseif x2 <= 0 && y2 > 0 then
			ang = math.asin(y2 / dis) + math.pi
		else
			ang = math.pi * 2 - math.acos(x2 / dis)
		end
		return math.floor((1 - (ang - math.pi / 2 - math.pi / total) / (math.pi * 2) % 1) * total) + 1
	end
end

function GM:RadialMousePressed(code, vec)
	if radialOpen then
		local selected = getSelected()
		if selected && selected > 0 && code == MOUSE_LEFT then
			self:CloseRadialMenu()
			if selected == 1 then 
				self:showlist()
			elseif selected && ments[selected] then
				RunConsoleCommand("mu_taunt", ments[selected].Code)
			end
		end		
	end
end

local elements
local function addElement(transCode, code)
	local t = {}
	t.TransCode = transCode
	t.Code = code
	table.insert(elements, t)
end

concommand.Add("+menu", function (client, com, args, full)
	if client:Alive() && client:Team() == 2 then
		elements = {}
		addElement("Help", "help")
		addElement("Funny", "funny")
		addElement("Morose", "morose")
		GAMEMODE:OpenRadialMenu(elements)
	end
end)

concommand.Add("-menu", function (client, com, args, full)
	GAMEMODE:RadialMousePressed(MOUSE_LEFT)
end)

local tex = surface.GetTextureID("VGUI/white.vmt")

local function drawShadow(n,f,x,y,color,pos)
	draw.DrawText(n,f,x + 1,y + 1,color_black,pos)
	draw.DrawText(n,f,x,y,color,pos)
end

local circleVertex

local fontHeight = draw.GetFontHeight("MersRadial")
function GM:DrawRadialMenu()
	if radialOpen then
		local sw,sh = ScrW(), ScrH()
		local total = #ments
		local w = math.min(sw * 0.45, sh * 0.45)
		local h = w
		local sx, sy = sw / 2, sh / 2

		local selected = getSelected() or -1


		if !circleVertex then
			circleVertex = {}
			local max = 50
			for i = 0, max do
				local vx, vy = math.cos((math.pi * 2) * i / max), math.sin((math.pi * 2) * i / max)

				table.insert(circleVertex, {x = sx + w* 1 * vx, y= sy + h* 1 * vy})
			end
		end

		surface.SetTexture(tex)
		local defaultTextCol = color_white
		if selected <= 0 || selected ~= selected then
			surface.SetDrawColor(20,20,20,180)
		else
			surface.SetDrawColor(20,20,20,120)
			defaultTextCol = Color(150,150,150)
		end
		surface.DrawPoly(circleVertex)

		local add = math.pi * 1.5 + math.pi / total
		local add2 = math.pi * 1.5 - math.pi / total

		for k,ment in pairs(ments) do
			local x,y = math.cos((k - 1) / total * math.pi * 2 + math.pi * 1.5), math.sin((k - 1) / total * math.pi * 2 + math.pi * 1.5)

			local lx, ly = math.cos((k - 1) / total * math.pi * 2 + add), math.sin((k - 1) / total * math.pi * 2 + add)

			local textCol = defaultTextCol
			if selected == k then
				local vertexes = prevSelectedVertex

				if prevSelected != selected then
					prevSelected = selected
					vertexes = {}
					prevSelectedVertex = vertexes
					local lx2, ly2 = math.cos((k - 1) / total * math.pi * 2 + add2), math.sin((k - 1) / total * math.pi * 2 + add2)

					table.insert(vertexes, {x = sx, y = sy})

					table.insert(vertexes, {x = sx + w* 1 * lx2, y= sy + h* 1 * ly2})

					local max = math.floor(50 / total)
					for i = 0, max do
						local addv = (add - add2) * i / max + add2
						local vx, vy = math.cos((k - 1) / total * math.pi * 2 + addv), math.sin((k - 1) / total * math.pi * 2 + addv)

						table.insert(vertexes, {x = sx + w* 1 * vx, y= sy + h* 1 * vy})
					end

					table.insert(vertexes, {x = sx + w* 1 * lx, y= sy + h* 1 * ly})

				end

				surface.SetTexture(tex)
				surface.SetDrawColor(20,120,255,120)
				surface.DrawPoly(vertexes)

				textCol = color_white
			end

			drawShadow(translate["voice" .. ment.TransCode], "MersRadial", sx + w * 0.6 * x, sy + h * 0.6 * y - fontHeight / 3,textCol, 1)
			drawShadow(translate["voice" .. ment.TransCode .. "Description"], "MersRadialSmall", sx + w * 0.6 * x, sy + h * 0.6 * y + fontHeight / 2, textCol, 1)

		end
	end
end

surface.CreateFont("MU.TauntFont", {
	font = "MersRadial",
	size = 16,
	weight = 500,
	antialias = true,
	shadow = false
})


local isplayed = false
isopened = false
local isforcedclose = false
local hastaunt = false

net.Receive("MU_ForceCloseTauntWindow", function()
	isforcedclose = true
end)

net.Receive("MU_AllowTauntWindow", function()
	isforcedclose = false
end)


local taunt, taunt_dirs = file.Find( "sound/taunts/custom/*", "DOWNLOAD" )
perso = taunt

tl = {'01-oh-yeah.mp3',
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

function GM:showlist()
	isopened = true
	selected = false
	local Frame = vgui.Create( "DFrame" )
	Frame:SetSize( 400, 600 ) 
	Frame:SetTitle( "Murderer | Taunt Menu" ) 
	Frame:Center() 
	Frame:SetVisible( true ) 
	Frame:SetDraggable( false ) 
	Frame:ShowCloseButton( true ) 
	gui.EnableScreenClicker(true)
	
	Frame.Paint = function(self,w,h)
		surface.SetDrawColor(Color(40, 40, 40, 180))
		surface.DrawRect(0, 0, w, h)
	end
	
	Frame.OnClose = function()
		isopened = false
		hastaunt = false
		gui.EnableScreenClicker(false)
	end
	
	local function frame_Think_Force()
		if isforcedclose == true and isopened == true then
			isopened = false
			hastaunt = false
			Frame:Close()
		end
	end
	hook.Add("Think", "CloseWindowFrame_Force", frame_Think_Force)
	
	local list = vgui.Create("DListView", Frame)
	
	list:SetMultiSelect(false)
	list:AddColumn("soundlist")
	list.m_bHideHeaders = true
	list:SetPos(10,52)
	list:SetSize(0,500)
	list:Dock(BOTTOM)
	
	local comb = vgui.Create("DComboBox", Frame)

	comb:Dock(TOP)
	comb:SetSize(0, 20)
	comb:AddChoice("personalized Taunts")
	comb:AddChoice("default Taunts")
	comb:SetValue("default Taunts")
	
	function comb:SortAndStyle(pnl)
		pnl:SortByColumn(1, false)

		pnl.Paint = function(self, w, h)
			surface.SetDrawColor(Color(50, 50, 50, 180))
			surface.DrawRect(0, 0, w, h)
		end

		local color = {
			hover 	= Color(80, 80, 80, 200),
			select 	= Color(120, 120, 120, 255),
			alt		= Color(60, 60, 60, 180),
			normal 	= Color(50, 50, 50, 180)
		}

		for _, line in pairs(pnl:GetLines()) do
			function line:Paint(w, h)
				if self:IsHovered() then
					surface.SetDrawColor(color.hover)
				elseif self:IsSelected() then
					surface.SetDrawColor(color.select)
				elseif self:GetAltLine() then
					surface.SetDrawColor(color.alt)
				else
					surface.SetDrawColor(color.normal)
				end
				surface.DrawRect(0, 0, w, h)
			end

			for _, col in pairs(line["Columns"]) do
				col:SetFont("MU.TauntFont")
				col:SetTextColor(color_white)
			end
		end
	end
	
	comb.OnSelect = function(pnl, idx, val)
		hastaunt = false
		list:Clear()

		local tauntList = {}
		if val == "personalized Taunts" then
			tauntList = perso
			print(chat)
			PrintTable(tauntList)
		elseif val == "default Taunts" then
			tauntList = tl
		end

		if tauntList then
			for _ , name in pairs(tauntList) do
				list:AddLine(name)
			end
		else
			list:AddLine("<< WARNING: NO TAUNTS DETECTED! >>")
		end

		pnl:SortAndStyle(list)
	end
	
	if !selected then
		for _ , name in pairs(tl) do
				list:AddLine(name)
		end
		selected = true
	end
	
	comb:SortAndStyle(list)
	
		local btnpanel = vgui.Create("DPanel", Frame)
	btnpanel:Dock(FILL)
	btnpanel:SetBackgroundColor(Color(20, 20, 20, 200))
	
	list.OnRowSelected = function() hastaunt = true end
	list.DoDoubleClick = function(id, line)
		hastaunt = true
		local getline = list:GetLine(list:GetSelectedLine()):GetValue(1)
		if val == "personalized" then
			surface.PlaySound("../../../download/sound/taunts/custom/" .. getline)
		else
			surface.PlaySound("taunts/" .. getline)
		end
		Frame:Close()
	end
end
