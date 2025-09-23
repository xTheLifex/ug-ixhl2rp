-- ____ _ _    ____ _  _ ___    ____ ____ _  _ _  _ ____ _  _ ___  ____ -- 
-- [__  | |    |___ |\ |  |     |    |  | |\/| |\/| |__| |\ | |  \ [__  -- 
-- ___] | |___ |___ | \|  |     |___ |__| |  | |  | |  | | \| |__/ ___] --

/* -------------------------------------------------------------------------- */
/*                            Character Management                            */
/* -------------------------------------------------------------------------- */
local PLUGIN = PLUGIN
local red = Color(255,0,0)
local blue = Color(0,110,225)
local white = Color(255,255,255)
local gray = Color(125,125,125)
local NOT_IMPLEMENTED = "Command not yet implemented."

do
	local COMMAND = {}
    COMMAND.privilege = "Helix - Manage Player Flags"
    COMMAND.superAdminOnly = true
    COMMAND.alias = {"SilentKill"}
    COMMAND.arguments = {
        ix.type.player
    }
    COMMAND.argumentNames = {"Victim"}
    COMMAND.description = "Silently kills a player."

	function COMMAND:OnRun(client, target)
        target:Kill()
        PLUGIN:AlertAdmins(client, "slain ", target, "silently.")
	end
	
	ix.command.Add("SilentSlay", COMMAND)
end


do
	local COMMAND = {}
	COMMAND.privilege = "Helix - Manage Player Flags"
	COMMAND.superAdminOnly = true
	COMMAND.arguments = {
		ix.type.character,
		bit.bor(ix.type.text, ix.type.optional)
	}
    COMMAND.alias = {"SilentSetName"}
    COMMAND.argumentNames = {"Character", "New Name"}
    COMMAND.description = "Silently sets someone's character name."

	function COMMAND:OnRun(client, target, newName)
		local oldName = target:GetName()

		if (not newName or newName:len() == 0) then
			return client:RequestString("@chgName", "@chgNameDesc", function(text)
				ix.command.Run(client, "SilentSetName", {target:GetName(), text})
			end, target:GetName())
		end

		local color = ix.faction.Get(target:GetFaction()).color or Color(125, 125, 125)
		PLUGIN:AlertAdmins(client, " has changed ", blue, target:GetPlayer():SteamName(), white, "'s character name from ", color, oldName, white, " to ", color, newName, white, " silently.")
        target:SetName(newName:gsub("#", "#​"))
	end

	ix.command.Add("SilentCharSetName", COMMAND)
end

do
	local COMMAND = {}
    COMMAND.privilege = "Helix - Manage Player Flags"
    COMMAND.superAdminOnly = true
    COMMAND.arguments = {
        ix.type.character,
        bit.bor(ix.type.string, ix.type.optional)
    }
    COMMAND.alias = {"SilentSetModel"}
    COMMAND.argumentNames = {"Character", "Model Path"}
    COMMAND.description = "Silently sets someone's model to something else."

	function COMMAND:OnRun(client, target, model)

        if (not model or model:len() == 0) then
            return client:RequestString("Model", "Change the target's model to the one specified.", function(text)
                ix.command.Run(client, "SilentCharSetModel", {target:GetName(), text})
			end, client:GetModel())
		end

        target:SetModel(model)
        target:GetPlayer():SetupHands()
        PLUGIN:AlertAdmins(client, " has set ", target:GetPlayer(), "'s model to \"", gray, model, white, "\", silently.")
	end
	
	ix.command.Add("SilentCharSetModel", COMMAND)
end

/* -------------------------------------------------------------------------- */
/*                                Whitelisting                                */
/* -------------------------------------------------------------------------- */

/* -------------------------------- Whitelist ------------------------------- */
do
	local COMMAND = {}
    COMMAND.privilege = "Helix - Manage Player Flags"
    COMMAND.superAdminOnly = true
    COMMAND.arguments = {
        ix.type.player,
        ix.type.text
    }
    COMMAND.alias = {"SilentWhitelist"}
    COMMAND.argumentNames = {"Player", "Whitelist"}
    COMMAND.description = "Silently whitelists someone to a certain faction."

	function COMMAND:OnRun(client, target, name)
        if (name == "") then
			return "@invalidArg", 2
		end

		local faction = ix.faction.teams[name]

		if (!faction) then
			for _, v in ipairs(ix.faction.indices) do
				if (ix.util.StringMatches(L(v.name, client), name) or ix.util.StringMatches(v.uniqueID, name)) then
					faction = v

					break
				end
			end
		end

		if (faction) then
			if (target:SetWhitelisted(faction.index, true)) then
                PLUGIN:AlertAdmins(client, " has whitelisted ", target, " to ", (faction.color or white), faction.name, white, " whitelist, silently.")
			end
		else
			return "@invalidFaction"
		end
	end
	
	ix.command.Add("SilentPlyWhitelist", COMMAND)
end

/* ------------------------------ De-Whitelist ------------------------------ */
do
	local COMMAND = {}
    COMMAND.privilege = "Helix - Manage Player Flags"
    COMMAND.superAdminOnly = true
    COMMAND.alias = {"SilentDeWhitelist", "SilentPlyDeWhitelist", "SilentUnWhitelist"}
    COMMAND.arguments = {
        ix.type.player,
        ix.type.string
    }
    COMMAND.argumentNames = {"Player", "Whitelist"}
    COMMAND.description = "Silently unwhitelists someone from a certain faction."

	function COMMAND:OnRun(client, target, name)
        if (name == "") then
			return "@invalidArg", 2
		end

		local faction = ix.faction.teams[name]

		if (!faction) then
			for _, v in ipairs(ix.faction.indices) do
				if (ix.util.StringMatches(L(v.name, client), name) or ix.util.StringMatches(v.uniqueID, name)) then
					faction = v

					break
				end
			end
		end

        if (faction) then
			if (target:SetWhitelisted(faction.index, false)) then
                PLUGIN:AlertAdmins(client, " has unwhitelisted ", target, " from ", (faction.color or white), faction.name, white, " whitelist, silently.")
			end
		else
			return "@invalidFaction"
		end
	end
	
	ix.command.Add("SilentPlyUnWhitelist", COMMAND)
end

/* -------------------------------------------------------------------------- */
/*                                    Flags                                   */
/* -------------------------------------------------------------------------- */

/* -------------------------------- Character ------------------------------- */
do
	local COMMAND = {}
    COMMAND.privilege = "Helix - Manage Player Flags"
    COMMAND.superAdminOnly = true
    COMMAND.arguments = {
        ix.type.player
    }

	function COMMAND:OnRun(client, target)
        return NOT_IMPLEMENTED
	end
	
	ix.command.Add("SilentCharGiveFlags", COMMAND)
end

do
	local COMMAND = {}
    COMMAND.privilege = "Helix - Manage Player Flags"
    COMMAND.superAdminOnly = true
    COMMAND.arguments = {
        ix.type.player
    }

	function COMMAND:OnRun(client, target)
        return NOT_IMPLEMENTED
	end
	
	ix.command.Add("SilentCharTakeFlags", COMMAND)
end

do
	local COMMAND = {}
    COMMAND.privilege = "Helix - Manage Player Flags"
    COMMAND.superAdminOnly = true
    COMMAND.arguments = {
        ix.type.player
    }

	function COMMAND:OnRun(client, target)
        return NOT_IMPLEMENTED
	end
	
	ix.command.Add("SilentCharGiveAllFlags", COMMAND)
end

do
	local COMMAND = {}
    COMMAND.privilege = "Helix - Manage Player Flags"
    COMMAND.superAdminOnly = true
    COMMAND.arguments = {
        ix.type.player
    }

	function COMMAND:OnRun(client, target)
        return NOT_IMPLEMENTED
	end
	
	ix.command.Add("SilentCharTakeAllFlags", COMMAND)
end

/* --------------------------------- Player --------------------------------- */
do
	local COMMAND = {}
    COMMAND.privilege = "Helix - Manage Player Flags"
    COMMAND.superAdminOnly = true
    COMMAND.alias = {"SilentPlayerGiveFlags"}
    COMMAND.arguments = {
        ix.type.player,
        ix.type.text
    }
    COMMAND.argumentNames = {"Player", "Flags"}
    COMMAND.description = "Silently gives flags to a player."

	function COMMAND:OnRun(client, target, flags)
        if not PLUGIN.pflags then return "Missing Player Flags Plugin" end

        PLUGIN:GivePlayerFlags(target, flags)
        client:NotifyLocalized("You've given " .. target:SteamName() .. "''" .. flags .. "'' silently.")
        PLUGIN:AlertAdmins(client, " has given ", target, " ''", flags, "'' flags silently.")
	end
	
	ix.command.Add("SilentPlyGiveFlags", COMMAND)
end

do
	local COMMAND = {}
    COMMAND.privilege = "Helix - Manage Player Flags"
    COMMAND.superAdminOnly = true
    COMMAND.alias = {"SilentPlayerTakeFlags"}
    COMMAND.arguments = {
        ix.type.player,
        bit.bor(ix.type.text, ix.type.optional)
    }
    COMMAND.argumentNames = {"Player", "Flags"}
    COMMAND.description = "Silently takes flags from a player."

	function COMMAND:OnRun(client, target, flags)
        if not PLUGIN.pflags then return "Missing Player Flags Plugin" end

        PLUGIN:TakePlayerFlags(target, flags)
        client:NotifyLocalized("You've taken " .. target:SteamName() .. "''" .. flags .. "'' silently.")
        PLUGIN:AlertAdmins(client, " has taken ", target, " ''", flags, "'' flags silently.")
	end
	
	ix.command.Add("SilentPlyTakeFlags", COMMAND)
end

do
	local COMMAND = {}
    COMMAND.privilege = "Helix - Manage Player Flags"
    COMMAND.superAdminOnly = true
    COMMAND.alias = {"SilentPlayerGiveAllFlags"}
    COMMAND.arguments = {
        ix.type.player
    }
    COMMAND.argumentNames = {"Player"}
    COMMAND.description = "Silently gives all available flags to a player."

	function COMMAND:OnRun(client, target)
        if not PLUGIN.pflags then return "Missing Player Flags Plugin" end

        PLUGIN:GivePlayerAllFlags(target)
        client:NotifyLocalized("You've given " .. target:SteamName() .. " ALL FLAGS, silently.")
        PLUGIN:AlertAdmins(client, " has given ", target, red, "ALL", Color(255,255,255), " flags silently.")
	end
	
	ix.command.Add("SilentPlyGiveAllFlags", COMMAND)
end

do
	local COMMAND = {}
    COMMAND.privilege = "Helix - Manage Player Flags"
    COMMAND.superAdminOnly = true
    COMMAND.alias = {"SilentPlayerTakeAllFlags"}
    COMMAND.arguments = {
        ix.type.player
    }
    COMMAND.argumentNames = {"Player"}
    COMMAND.description = "Silently takes all available flags from a player."

	function COMMAND:OnRun(client, target)
        if not PLUGIN.pflags then return "Missing Player Flags Plugin" end

        return NOT_IMPLEMENTED
	end
	
	ix.command.Add("SilentPlyTakeAllFlags", COMMAND)
end