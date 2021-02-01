AddCSLuaFile()

if CLIENT then
	CreateClientConVar("brooms_enablefp", "0", true, false)
	CreateClientConVar("brooms_drawendparts", "1", true, false)
	CreateClientConVar("brooms_fullmousectrl", "0", true, false)
	CreateClientConVar("brooms_drawcircle", "0", true, false)
	CreateClientConVar("brooms_camdist", "200", true, false)

	local function setupConVars(ply)
		RunConsoleCommand("brooms_enablefp", "0")
		RunConsoleCommand("brooms_drawendparts", "1")
		RunConsoleCommand("brooms_fullmousectrl", "0")
		RunConsoleCommand("brooms_drawcircle", "0")
		RunConsoleCommand("brooms_camdist", "200")
		
		if ply and ply:IsValid() and ply:IsPlayer() and ply:IsSuperAdmin() then
			net.Start("brooms_sendcl")
				net.WriteEntity(ply)
			net.SendToServer()
		end
	end
	
	concommand.Add("brooms_setupconvars", setupConVars)
	
	local function setup(p)
		/***
			Client settings
		***/
	
		p:AddControl("Label", { Text = "Client settings" })
		p:AddControl("CheckBox", { Label = "Enable first person mode", Command = "brooms_enablefp"})
		p:AddControl("CheckBox", { Label = "Enable particles", Command = "brooms_drawendparts"})
		p:AddControl("CheckBox", { Label = "Enable full mouse control", Command = "brooms_fullmousectrl"})
		p:AddControl("CheckBox", { Label = "Enable correcting circle", Command = "brooms_drawcircle"})
		p:AddControl("Slider", { Label = "Camera distance (200 default)", Min = 50, Max = 500, Command = "brooms_camdist" })
		
		/***
			Server settings
		***/
		p:AddControl("Label", { Text = "\nServer settings" })
		p:AddControl("Slider", { Label = "Maximum speed (2 default)", Min = 1, Max = 20, Command = "brooms_speed_max" })
		p:AddControl("CheckBox", { Label = "Fix the roll angle", Command = "brooms_fixroll"})
		
		
		p:AddControl("Button", { Label = "Default", Command = "brooms_setupconvars" })
	end

	hook.Add("PopulateToolMenu", "brooms_kekc_menu", function() spawnmenu.AddToolMenuOption("Utilities", "Brooms", "Settings", "Settings", "", "", setup) end)
else
	util.AddNetworkString("brooms_sendcl")
	net.Receive("brooms_sendcl", function()
		local ply = net.ReadEntity()
		
		if not ply then return end
		if not ply:IsValid() then return end
		if not ply:IsSuperAdmin() then return end
		
		RunConsoleCommand("brooms_speed_max", "2")
		RunConsoleCommand("brooms_fixroll", "1")
	end)

	CreateConVar("brooms_speed_max", "2", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Maximum speed")
	CreateConVar("brooms_fixroll", "1", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Fix the roll angle")
end









