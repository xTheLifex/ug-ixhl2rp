
local PLUGIN = PLUGIN

PLUGIN.name = "Simple Datafile"
PLUGIN.author = "Fruity"
PLUGIN.description = "Adds a simple datafile system for HL2RP. Get it on gmodstore."
PLUGIN.url = "https://www.gmodstore.com/market/view/helix-hl2-rp-simple-datafile"

ix.util.Include("sv_net.lua")
ix.util.Include("cl_net.lua")
ix.util.Include("sv_plugin.lua")
ix.util.Include("meta/sv_character.lua")

ix.command.Add("Datafile", {
	description = "@dfCmdDatafile",
	arguments = ix.type.text,
	OnRun = function(self, requester, target)
		PLUGIN:OpenDatafile(requester, target)
	end
})

ix.char.RegisterVar("datafile", {
	field = "datafile",
	fieldType = ix.type.number,
	default = 0,
	bNoDisplay = true,
    bNoNetworking = true
})

ix.config.Add("datafileDefaultLocation", "TRAIN STATION", "The default text to display as location on new datafiles.", nil, {
	category = "Datafile"
})

ix.config.Add("datafileButtonClickSound", "buttons/button14.wav", "Sound clicking standard buttons.", nil, {
	category = "Datafile"
})

ix.config.Add("datafileButtonHeaderSound", "buttons/combine_button1.wav", "Sound clicking header buttons.", nil, {
	category = "Datafile"
})

ix.config.Add("datafileStartupSound", "buttons/button9.wav", "Sound starting up the datafile.", nil, {
	category = "Datafile"
})

ix.config.Add("datafileButtonNavSound", "buttons/button15.wav", "Sound clicking page navigation.", nil, {
	category = "Datafile"
})

ix.config.Add("datafileCloseSound", "buttons/button18.wav", "The sound when closing the datafile.", nil, {
	category = "Datafile"
})

ix.config.Add("datafileNotesLoadAmount", 5, "The amount of notes to load per page in the datafile.", nil, {
	category = "Datafile", data = {min = 1, max = 16}
})

ix.config.Add("datafileLoyaltyTiers", true, "Set the different loyalty tiers available in the datafile.", nil, {
	category = "Datafile"
})

ix.config.Add("datafileExcludedFactions", true, "Set factions that should not have a datafile created.", nil, {
	category = "Datafile"
})

ix.config.Add("datafileAllowedFactions", true, "Set factions that are allowed to open the datafile.", nil, {
	category = "Datafile"
})

ix.config.Add("datafileNotesMaxCharacters", 500, "The maximum amount of text characters in a datafile note.", nil, {
	category = "Datafile", data = {min = 1, max = 1000}
})

ix.config.Add("datafileActRecordPointsUpperLimit", 3, "The maximum amount of loyalty points able to given in an act.", nil, {
	category = "Datafile", data = {min = 1, max = 15}
})

ix.config.Add("datafileActRecordPointsLowerLimit", -3, "The lowest amount of loyalty points able to given in an act.", nil, {
	category = "Datafile", data = {min = -15, max = 0}
})

local colors = {
	ColorPrimary = Color(27, 125, 212),
	ColorBG = Color(2, 21, 38),
	ColorMedium = Color(7, 45, 76),
	ColorDark = Color(5, 30, 45),
	ColorSubtext = Color(210, 210, 210),
	ColorGreen = Color(16, 187, 76),
	ColorRed = Color(213, 20, 61)
}

do
	for key, color in pairs(colors) do
		ix.config.Add("datafile"..key, color, "Controls a color of the datafile.", nil, {
			category = "Datafile"
		})
	end
end