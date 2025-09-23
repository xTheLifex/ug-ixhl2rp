
local PLUGIN = PLUGIN

util.AddNetworkString("ixOpenDatafile")
util.AddNetworkString("ixDatafileUpdateNotes")
util.AddNetworkString("ixDatafileAddNote")
util.AddNetworkString("ixDatafileRemoveNote")
util.AddNetworkString("ixDatafileAddTier")
util.AddNetworkString("ixDatafileRemoveTier")
util.AddNetworkString("ixDatafileUpdateTiers")
util.AddNetworkString("ixDatafileUpdateTierColor")
util.AddNetworkString("ixDatafileAddExcludedFaction")
util.AddNetworkString("ixDatafileRemoveExcludedFaction")
util.AddNetworkString("ixDatafileUpdateExcludedFactions")
util.AddNetworkString("ixDatafileAddAllowedFaction")
util.AddNetworkString("ixDatafileRemoveAllowedFaction")
util.AddNetworkString("ixDatafileUpdateAllowedFactions")
util.AddNetworkString("ixDatafileUpdatePoints")
util.AddNetworkString("ixDatafileUpdateLastSeen")
util.AddNetworkString("ixDatafileUpdateBOLCitizenship")

net.Receive("ixDatafileUpdateNotes", function(_, client)
    local datafileID = net.ReadUInt(32)
    local noteType = net.ReadUInt(2)
    local currentPage = net.ReadUInt(32)
    local bNextPage = net.ReadBool()

    PLUGIN:RequestNotes(client, datafileID, noteType, currentPage, bNextPage)
end)

net.Receive("ixDatafileAddNote", function(_, client)
    local datafileID = net.ReadUInt(32)
    local noteType = net.ReadUInt(2)
    local text = net.ReadString()
    local points = net.ReadInt(32)
    local poster = client.GetCharacter and client:GetCharacter():GetName() or "@dfUnknown"

    PLUGIN:AddNote(client, datafileID, noteType, poster, text, points)
end)

net.Receive("ixDatafileRemoveNote", function(_, client)
    local datafileID = net.ReadUInt(32)
    local noteType = net.ReadUInt(2)
    local noteID = net.ReadUInt(32)

    PLUGIN:RemoveNote(client, datafileID, noteID, noteType)
end)

net.Receive("ixDatafileAddTier", function(_, client)
    local name = net.ReadString()
    local pointsRequired = net.ReadString()
    pointsRequired = tonumber(pointsRequired)

    PLUGIN:AddTier(client, name, pointsRequired)
end)

net.Receive("ixDatafileRemoveTier", function(_, client)
    local id = net.ReadUInt(32)
    PLUGIN:RemoveTier(client, id)
end)

net.Receive("ixDatafileUpdateTiers", function(_, client)
    if !PLUGIN:CheckForConfigAccess(client) then return end

    net.Start("ixDatafileAddTier")
    net.WriteTable(ix.datafile.tiers)
    net.Send(client)
end)

net.Receive("ixDatafileUpdateTierColor", function(_, client)
    local color = net.ReadColor(true)
    local tierID = net.ReadString()

    PLUGIN:UpdateTierColor(client, color, tierID)
end)

net.Receive("ixDatafileAddExcludedFaction", function(_, client)
    local factionUnique = net.ReadString()

    PLUGIN:AddExcludedFaction(client, factionUnique)
end)

net.Receive("ixDatafileRemoveExcludedFaction", function(_, client)
    local factionUnique = net.ReadString()

    PLUGIN:RemoveExcludedFaction(client, factionUnique)
end)

net.Receive("ixDatafileUpdateExcludedFactions", function(_, client)
    if !PLUGIN:CheckForConfigAccess(client) then return end

    net.Start("ixDatafileAddExcludedFaction")
    net.WriteTable(ix.datafile.excludedFactions)
    net.Send(client)
end)

net.Receive("ixDatafileAddAllowedFaction", function(_, client)
    local factionUnique = net.ReadString()

    PLUGIN:AddAllowedFaction(client, factionUnique)
end)

net.Receive("ixDatafileRemoveAllowedFaction", function(_, client)
    local factionUnique = net.ReadString()

    PLUGIN:RemoveAllowedFaction(client, factionUnique)
end)

net.Receive("ixDatafileUpdateAllowedFactions", function(_, client)
    if !PLUGIN:CheckForConfigAccess(client) then return end

    net.Start("ixDatafileAddAllowedFaction")
    net.WriteTable(ix.datafile.allowedFactions)
    net.Send(client)
end)

net.Receive("ixDatafileUpdateLastSeen", function(_, client)
    local datafileID = net.ReadUInt(32)

    PLUGIN:UpdateLastSeen(client, datafileID)
end)

net.Receive("ixDatafileUpdateBOLCitizenship", function(_, client)
    local datafileID = net.ReadUInt(32)
    local nType = net.ReadBit()
    local nActive = net.ReadBit()
    local reason = net.ReadString()

    PLUGIN:SetBOLCitizenship(client, datafileID, nType, nActive, reason)
end)