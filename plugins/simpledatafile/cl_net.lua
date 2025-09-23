
local PLUGIN = PLUGIN

net.Receive("ixOpenDatafile", function()
    local datafileID = net.ReadUInt(32)
    local lastLocation = net.ReadString()
    local lastLocationTime = net.ReadUInt(32)
    local citizenship = net.ReadBit()
    local bol = net.ReadBit()
    local points = net.ReadInt(8)
    local tiers = net.ReadTable()
    local name = net.ReadString()
    local cid = net.ReadUInt(17)
    local faction = net.ReadString()

    local datafile = {
        id = datafileID,
        last_location = {location = lastLocation, timestamp = lastLocationTime},
        citizenship = citizenship,
        bol = bol,
        points = points,
        name = name,
        cid = cid,
        faction = faction
    }

    PLUGIN.datafile = vgui.Create("ixDatafile")
    PLUGIN.datafile:Populate(datafile, tiers)
end)

net.Receive("ixDatafileUpdateNotes", function()
    local notes = net.ReadTable()
    local datafileID = net.ReadUInt(32)
    local noteType = net.ReadUInt(2)
    local currentPage = net.ReadUInt(32)

    if !PLUGIN.datafile or PLUGIN.datafile and !IsValid(PLUGIN.datafile) then return end
    PLUGIN.datafile:PopulateNotes(notes, datafileID, noteType, currentPage)
end)

net.Receive("ixDatafileAddTier", function()
    local tiers = net.ReadTable()

    if !PLUGIN.tierManager or PLUGIN.tierManager and !IsValid(PLUGIN.tierManager) then return end
    PLUGIN.tierManager:Populate(tiers)
end)

net.Receive("ixDatafileAddExcludedFaction", function()
    local factions = net.ReadTable()

    if !PLUGIN.factionManager or PLUGIN.factionManager and !IsValid(PLUGIN.factionManager) then return end
    PLUGIN.factionManager:Populate(factions)
end)

net.Receive("ixDatafileAddAllowedFaction", function()
    local factions = net.ReadTable()

    if !PLUGIN.allowedFactionManager or PLUGIN.allowedFactionManager and !IsValid(PLUGIN.allowedFactionManager) then return end
    PLUGIN.allowedFactionManager:Populate(factions)
end)

net.Receive("ixDatafileUpdatePoints", function()
    local datafileID = net.ReadUInt(32)
    local points = net.ReadInt(8)

    if !PLUGIN.datafile or PLUGIN.datafile and !IsValid(PLUGIN.datafile) then return end
    PLUGIN.datafile:UpdatePoints(datafileID, points)
end)

net.Receive("ixDatafileUpdateLastSeen", function()
    local datafileID = net.ReadUInt(32)
    local sLastLocation = net.ReadString()
    local nTimestamp = net.ReadUInt(32)

    if !PLUGIN.datafile or PLUGIN.datafile and !IsValid(PLUGIN.datafile) then return end
    PLUGIN.datafile:UpdateLastSeen(datafileID, sLastLocation, nTimestamp)
end)

net.Receive("ixDatafileUpdateBOLCitizenship", function()
    local datafileID = net.ReadUInt(32)
    local nType = net.ReadBit()
    local nActive = net.ReadBit()

    if !PLUGIN.datafile or PLUGIN.datafile and !IsValid(PLUGIN.datafile) then return end
    PLUGIN.datafile:UpdateBOLCitizenship(datafileID, nType, nActive)
end)