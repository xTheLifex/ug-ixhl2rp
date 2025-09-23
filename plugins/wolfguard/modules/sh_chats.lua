local PLUGIN = PLUGIN

/* -------------------------------------------------------------------------- */
/*                                 Staff Chat                                 */
/* -------------------------------------------------------------------------- */

ix.chat.Register("staffchat", {
	format = "[STAFF CHAT] %s: \"%s\"",
	indicator = "chatTalking",
	OnChatAdd = function (self, speaker, text)
		if !(LocalPlayer():IsAdmin()) then return end
		PLUGIN:SendChat(Color(25,125,255), "(STAFF) ", Color(255,255,255), speaker, ": ", text)
	end,
	CanHear = function(speaker, listener)
		return listener:IsAdmin() -- Only send to admins
	end,
	deadCanChat = true,
	description = "Internal Admin Chatter.",
})

do
	local COMMAND = {}
    COMMAND.alias = {"A","Help", "Admin", "AdminChat", "StaffChat"}
    COMMAND.arguments = {
        ix.type.text
    }

	function COMMAND:OnRun(client, text)
		if client:IsAdmin() then
			ix.chat.Send(client, "staffchat", text)
		else
			-- fall back to ahelp
			local red = Color(230,161,161)
			local white = Color(255,255,255)
			PLUGIN:AlertAdmins(red, "(AHELP) ", white, client, ": ", text)
			PLUGIN:SendChat(client, red, "(AHELP) ", Color(200,194,255), "You", white, " -> ", red, "Staff ", white, ": ", text)
		end
	end	
	
	ix.command.Add("AdminHelp", COMMAND)
end


/* -------------------------------------------------------------------------- */
/*                                  Staff PM                                  */
/* -------------------------------------------------------------------------- */
wg.staffpm = wg.staffpm or {}

if (SERVER) then
	wg.staffpm.codenameList = {
		"Aegis",        -- Shield of protection
		"Tempest",      -- A storm of fury
		"Poseidon",     -- God of the sea
		"Phantom",      -- Mysterious and unseen
		"Valkyrie",     -- Chooser of the slain
		"Havoc",        -- Chaos and destruction
		"Eclipse",      -- A celestial phenomenon
		"Talon",        -- A sharp claw
		"Sentinel",     -- A watchful guardian
		"Inferno",      -- A raging fire
		"Warden",       -- Protector or overseer
		"Onyx",         -- Resilient and dark stone
		"Ragnarok",     -- End of the world in Norse myth
		"Shadow",       -- Stealthy and elusive
		"Titan",        -- A giant of immense strength
		"Oblivion",     -- A void of forgetfulness
		"Sovereign",    -- Supreme ruler
		"Zephyr",       -- A gentle wind
		"Nova",         -- A star bursting with brilliance
		"Guardian",     -- Defender and protector
		"Chimera",      -- A mythical hybrid beast
		"Cerberus",     -- Guardian of the underworld
		"Specter",      -- A ghostly apparition
		"Leviathan",    -- A sea monster of legend
		"Striker",      -- Swift and impactfulwords
		"Oracle",       -- Source of wisdom and foresight
		"Reaper",       -- Harbinger of fate
		"Bastion",      -- A stronghold of defense
		"Aurora",       -- The dawn or northern lights
		"Nemesis",      -- Agent of retribution
		"Cypher",        -- Keeper of secrets
		"Apollo",       -- God of light and prophecy
		"Artemis",      -- Goddess of the hunt and wilderness
		"Hades",        -- God of the underworld
		"Hyperion",     -- Titan of light
		"Nyx",          -- Primordial goddess of the night
		"Erebus",       -- Personification of darkness
		"Helios",       -- God of the sun
		"Thanatos",     -- Personification of death
		"Selene",       -- Goddess of the moon
		"Anubis",       -- Egyptian god of the dead and mummification
		"Raijin",       -- Japanese god of thunder
		"Susanoo",      -- Japanese god of storms and the sea
		"Kali",         -- Hindu goddess of destruction and transformation
		"Odin",         -- Allfather and Norse god of wisdom and war
		"Thor",         -- Norse god of thunder and strength
		"Freya",        -- Norse goddess of love and battle
		"Morrigan",     -- Celtic goddess of war and fate
		"Ares",         -- Greek god of war
		"Set",          -- Egyptian god of chaos and storms
		"Azazel",       -- Fallen angel, leader of the Watchers
		"Lilith",       -- First woman in some myths, later demonized
		"Behemoth",     -- Mythical beast of chaos
		"Asmodeus",     -- Demon of lust and wrath
		"Belial",       -- Symbol of worthlessness or deceit
		"Baal",         -- Ancient demon or god of storms
		"Leviathan",    -- Sea monster representing chaos
		"Mammon",       -- Demon of greed
		"Astaroth",     -- Demon prince of knowledge
		"Charybdis",    -- Sea monster creating deadly whirlpools
		"Fenrir",       -- Norse wolf destined to bring Ragnarok
		"Chernobog",    -- Slavic god of darkness and chaos
		"Abaddon",      -- Angel of destruction or abyss
		"Zagan",        -- Demon of alchemy and transformation
		"Dagon",        -- Philistine deity, later seen as a sea demon
		"Moloch",       -- God or demon associated with child sacrifice
		"Barbatos",     -- Demon of harmony and prophecy
		"Baphomet",     -- Symbol of balance and occult wisdom
		"Prometheus",   -- Titan who gifted fire to humanity
		"Hephaestus",   -- God of fire and craftsmanship
		"Janus",        -- Roman god of beginnings and duality
		"Eris",         -- Goddess of discord and chaos
		"Tiamat",       -- Babylonian primordial chaos dragon
		"Typhon",       -- Father of monsters in Greek mythology
		"Nemain",       -- Irish goddess of battle frenzy
		"Pele",         -- Hawaiian goddess of volcanoes and fire
		"Kukulkan",     -- Feathered serpent god of the Mayans
		"Moros",        -- Greek spirit of doom and fate
		"Izanami",      -- Japanese goddess of creation and death
		"Amaterasu",    -- Japanese sun goddess
		"Hecate",       -- Greek goddess of magic and crossroads
		"Skadi",        -- Norse goddess of winter and hunting
		"Ereshkigal",   -- Sumerian goddess of the underworld
		"Ouroboros",    -- Symbolic serpent eating its own tail
		"Phobos",       -- Greek god of fear and terror
		"Deimos",       -- Greek god of dread and panic
		"Yama",         -- Hindu and Buddhist lord of death
	}
	
	wg.staffpm.codenames = wg.staffpm.codenames or {}
	
	function wg.staffpm.AssignCodename(ply)
		if not IsValid(ply) then return end
		if not ply:IsAdmin() then return end

		-- Assign a random codename from the list
		if wg.staffpm.codenames[ply] == nil then
			local availableCodenames = {}
	
			-- Find codenames not already assigned
			for _, codename in ipairs(wg.staffpm.codenameList) do
				if not table.HasValue(wg.staffpm.codenames, codename) then
					table.insert(availableCodenames, codename)
				end
			end
	
			-- Assign a codename if any are available
			if #availableCodenames > 0 then
				local randomCodename = availableCodenames[math.random(#availableCodenames)]
				wg.staffpm.codenames[ply] = randomCodename
				--print(string.format("[STAFF PM] %s is now %s. ", ply:Nick(), randomCodename))
			else
				-- Fallback if all codenames are taken
				wg.staffpm.codenames[ply] = "Anonymous"
			end
		end
	end
	
	function wg.staffpm.RemoveCodename(ply)
		if IsValid(ply) then
			wg.staffpm.codenames[ply] = nil
		end
	end
	
	function wg.staffpm.GetCodename(ply)
		if not IsValid(ply) then return "Null" end
		if not ply:IsAdmin() then return "Non-Staff" end

		local codename = wg.staffpm.codenames[ply]
		if not codename then
			wg.staffpm.AssignCodename(ply)
		end
		codename = wg.staffpm.codenames[ply]
		return codename or "Null"
	end

	-- Hook for player connection
	hook.Add("PlayerInitialSpawn", "wgStaffPMAssignCodenameOnConnect", function(ply)
		wg.staffpm.AssignCodename(ply)
	end)

	-- Hook for player disconnection
	hook.Add("PlayerDisconnected", "wgStaffPMRemoveCodenameOnDisconnect", function(ply)
		wg.staffpm.RemoveCodename(ply)
	end)
end

local function AddUnique(tbl, val)
	for _, v in ipairs(tbl) do
		if v == val then return end
	end
	table.insert(tbl, val)
end

ix.chat.Register("staffpm", {
	format = "NOT USED",
	color = Color(70, 10, 10),
	deadCanChat = true,

	OnChatAdd = function(self, speaker, text, bAnonymous, data)
		local codename = data.codename or "Staff"
		local target = data.target
		local localPly = LocalPlayer()
		local red = Color(187, 26, 26)
		local white = Color(255, 255, 255)
		local hasPerms = CAMI.PlayerHasAccess(localPly, "WolfGuard - Staff Chat", nil)

		-- Message for the target (not a staff member)
		if IsValid(target) and target:SteamID() == localPly:SteamID() and not hasPerms then
			PLUGIN:SendChat(self.color, "[STAFF] ", red, codename, white, ": ", text)
			surface.PlaySound("hl1/fvox/buzz.wav")

		-- Message for staff members with permissions
		elseif hasPerms then
			local senderName = codename

			if ix.option.Get("wgStaffPmUseRealName") then
				senderName = speaker
			end

			PLUGIN:SendChat(self.color, "[STAFF PM] ", red, senderName, white, " -> ", target, ": ", text)
		end
	end
})

do
	local COMMAND = {}
	COMMAND.privilege = "WolfGuard - Staff PM"
	COMMAND.adminOnly = true
    COMMAND.alias = {"PMS", "PMStaff"}
    COMMAND.arguments = {
		ix.type.player,
        ix.type.text
    }	

	function COMMAND:OnRun(client, target, text)
		local listeners = PLUGIN:GetAdmins()
		AddUnique(listeners, client)
		AddUnique(listeners, target)
		
		local codename = wg.staffpm.GetCodename(client)
		ix.chat.Send(client, "staffpm", text, false, listeners, {target = target, codename = codename})
	end
	
	ix.command.Add("StaffPM", COMMAND)
end

-- CLIENT
-- function ix.chat.Send(speaker, chatType, text, anonymous, data)

-- SERVER
-- function ix.chat.Send(speaker, chatType, text, bAnonymous, receivers, data)