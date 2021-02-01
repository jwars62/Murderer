CreateClientConVar("gmod_glowsticks_red", "255", true, true)
CreateClientConVar("gmod_glowsticks_green", "255", true, true)
CreateClientConVar("gmod_glowsticks_blue", "255", true, true)
CreateClientConVar("gmod_glowsticks_alpha", "255", true, true)

local function GlowSticks_Menu( Panel )
	local logo = vgui.Create( "DImage" );
	logo:SetImage( "vgui/gs_logo" );
	logo:SetSize( 300, 150 );

	Panel:AddPanel( logo );
	Panel:AddControl( "Label", {Text = "Server Settings"})
	Params = {}
	Panel:AddControl( "CheckBox", { Label = "Should glow sticks live forever?", Command = "gmod_glowsticks_lifetime_infinite" } )
	Params["Label"] = "Glow Sticks Lifetime in seconds"
	Params["Command"] = "gmod_glowsticks_lifetime"
	Params["Type"] = "Integer"
	Params["Min"] = "5"
	Params["Max"] = "60"
	Panel:AddControl( "Slider", Params)
	Panel:AddControl( "Label", {Text = "Client Settings"})
	Panel:AddControl("Color", {
	Label = "Glow Sticks Color",
	Red = "gmod_glowsticks_red",
	Blue = "gmod_glowsticks_blue",
	Green = "gmod_glowsticks_green",
	Alpha = "gmod_glowsticks_alpha",
	ShowHSV = 1,
	ShowRGB = 1,
	Multiplier = 255
	})
	Panel:AddControl( "Label", {Text = "Glow Sticks by Patrick Hunt"})
end

local function LoadMenu()
	spawnmenu.AddToolMenuOption("Options", "Player", "Glowsticks", "Glow Sticks Options", "", "", GlowSticks_Menu)
end
hook.Add( "PopulateToolMenu", "Glow Sticks Load Menu", LoadMenu )