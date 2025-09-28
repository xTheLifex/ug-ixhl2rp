local PLUGIN = PLUGIN

function PLUGIN:GetAdmins()
    local result = {}
    for _, ply in ipairs(player.GetAll()) do
        if (IsValid(ply) and ply:IsAdmin()) then
            table.insert(result, ply)
        end
    end

    return result
end


function PLUGIN:PlayerDeath(victim, inflictor, attacker)
    local white = Color(255, 255, 255)
    local red = Color(255, 0, 0)

    if attacker:GetClass() == "worldspawn" then
        local lastLadderTime = victim.lastLadderTime or 0
        local lastObserverTime = victim.lastObserverTime or 0

        if CurTime() - lastObserverTime <= 3 then
            self:AlertAdminsOption("wgPrintDeaths", victim, "fell out of noclip.")
            return
        elseif CurTime() - lastLadderTime <= 2 then
            self:AlertAdminsOption("wgPrintDeaths", victim, "probably fell off a ladder.")
            return
        else
            self:AlertAdminsOption("wgPrintDeaths", victim, ix.util.Pick({["died from fall damage."] = 4, ["broke their legs."] = 1,["fell from a high place."] = 1}))
            return
        end
    end
    

    if (inflictor == attacker) then
        self:AlertAdminsOption("wgPrintDeaths", victim, "was killed by ", red, attacker)
        return
    end 

    self:AlertAdminsOption("wgPrintDeaths", victim, "was killed by ", red, attacker, white, " using ", red, inflictor)
end

function PLUGIN:PlayerTick(client, movedata)
    -- Ladder tracking
    if (client:GetMoveType() == MOVETYPE_LADDER) then
        client.lastLadderTime = CurTime()
    end
end

function PLUGIN:OnPlayerObserve(client, state)
    if (!state) then client.lastObserverTime = CurTime() end
end

function PLUGIN:OnCharacterCreated(client, character)
    self:AlertAdminsOption("wgPrintCharacterEvents", client, " has created a new character: ''", character:GetName(), "''")
end

function PLUGIN:CharacterLoaded(character)
    local client = character:GetPlayer()
    self:AlertAdminsOption("wgPrintCharacterEvents", client, " has loaded their character ''", character:GetName(), "''")
end

function PLUGIN:PreCharacterDeleted(client, character)
    self:AlertAdminsOption("wgPrintCharacterEvents", client, " has deleted their character ''", character:GetName(), "''")
end

function PLUGIN:PlayerJoinedClass(client, class, oldClass)
    local newClassTable = ix.class.Get(class)
    local oldClassTable = ix.class.Get(oldClass)

    if (not newClassTable) or (not oldClassTable) then return end
    self:AlertAdminsOption("wgPrintCharacterEvents", client, " has changed class from ", (oldClassTable.name or "None") , " to ", (newClassTable.name or "Unknown"))    
end

function PLUGIN:WipeTables()
    self:AlertAdmins(Color(255,0,0), "Server database is being wiped.")
end

function PLUGIN:Think(deltaTime)
    self.nextThink = self.nextThink or 0
    if (self.nextThink > CurTime()) then
        return
    end

    for k,ply in ipairs(player.GetAll()) do
        ply.idleTime = ply.idleTime or 0

        if (ply:GetVelocity():LengthSqr() > 0) then
            ply.idleTime = 0
        else
            ply.idleTime = ply.idleTime + 1
        end

        

    end

    self.nextThink = CurTime() + 1
end

local white = Color(255,255,255)
local gray = Color(125,125,125)
local red = Color(125,25,25)
hook.Add("ULibPlayerKicked", "wgLogUlibKicks", function (steamid, reason, caller)
    if (caller and IsValid(caller)) then
        if reason then
            PLUGIN:AlertAdmins(steamid, " has been kicked by ", caller, " for the reason: ", reason)    
        else
            PLUGIN:AlertAdmins(steamid, " has been kicked by ", caller)    
        end
    else
        if reason then
            PLUGIN:AlertAdmins(steamid, " has been kicked for: ", reason)
        else
            PLUGIN:AlertAdmins(steamid, " has been kicked")
        end
    end
end)

hook.Add("ULibPlayerBanned", "wgLogUlibBans", function(steamid, data)
    local admin = (data and data.admin) or "Server"
    local bantime = " permanently"

    if data and data.unban and data.time then
        local duration = ULib.secondsToStringTime(data.unban - data.time)
        if duration and duration ~= "" then
            bantime = " for " .. duration
        end
    end

    local reason = data and data.reason or nil

    if reason and reason ~= "" then
        PLUGIN:AlertAdmins(red, admin, grey, " has banned ", white, steamid, grey, bantime, grey, " for: ", reason)
    else
        PLUGIN:AlertAdmins(red, admin, grey, " has banned ", white, steamid, grey, bantime)
    end
end)

hook.Add("ULibPlayerUnBanned", "wgLogUlibUnbans", function (steamid, admin)
    local caller = admin or "Server"
    PLUGIN:AlertAdmins(caller, " has unbanned ", steamid)
end)

hook.Add("ULibUserGroupChange", "wgLogUlibGroupChanges", function (id, allows, denies, newGroup, oldGroup)
    local id = id or "unknown"
    local oldGroup = oldGroup or "none"
    local newGroup = newGroup or "<group>"

    PLUGIN:AlertAdmins(gray, "Changed access rights of ", white, id, gray, " from ", white, oldGroup, gray, " to ", white, newGroup)
end)

hook.Add("ULibUserRemoved", "wgLogUlibUserRemove", function (steamid, data)
    PLUGIN:AlertAdmins(gray, "Removed all access rights from ", white, steamid, gray, ", previously: ", (data.group or "<unknown>"))
end)

hook.Add("ULibPlayerNameChanged", "wgLogUlibNameChange", function (steamid, oldName, newName)
    PLUGIN:AlertAdmins(steamid, " has changed their steam name from ", oldName, " to ", newName)
end)

hook.Add("EntityTakeDamage", "wgEntityTakeDamage", function(ent, dmginfo)
    local attacker = dmginfo:GetAttacker()

    if IsValid(attacker) and attacker:IsPlayer() then
        local weapon = attacker:GetActiveWeapon()

        if IsValid(weapon) and weapon:GetClass() == "ix_hands" then
            dmginfo:SetDamage(0) -- Cancel the damage
        end
    end
end)
