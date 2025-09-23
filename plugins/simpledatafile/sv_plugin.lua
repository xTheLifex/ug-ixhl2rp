
local PLUGIN = PLUGIN

ix.datafile = ix.datafile or {}
ix.datafile.cached = ix.datafile.cached or {}
ix.datafile.tiers = ix.datafile.tiers or {}
ix.datafile.excludedFactions = ix.datafile.excludedFactions or {}
ix.datafile.allowedFactions = ix.datafile.allowedFactions or {"metropolice", "ota"}

ix.log.AddType("dfOpenedDatafile", function(client, opener, openedName, id)
    return string.format("%s opened the datafile of %s (ID: %s).", opener, openedName, id)
end)

ix.log.AddType("dfCreatedDatafile", function(client, characterName, id)
    return string.format("Created a datafile for %s (ID: %s).", characterName, id)
end)

ix.log.AddType("dfCachedDatafile", function(client, cachedName, id)
    return string.format("Cached the datafile for %s (ID: %s).", cachedName, id)
end)

ix.log.AddType("dfAddedNote", function(client, adder, type, id)
    return string.format("%s added a %s note to a datafile with the ID %s.", adder, type, id)
end)

ix.log.AddType("dfRemovedNote", function(client, remover, type, id)
    return string.format("%s removed a %s note from a datafile with the ID %s.", remover, type, id)
end)

ix.log.AddType("dfToggledBOL", function(client, toggler, toggledDatafile)
    return string.format("%s toggled BOL on a datafile with the ID %s.", toggler, toggledDatafile)
end)

ix.log.AddType("dfToggledCitizenship", function(client, toggler, toggledDatafile)
    return string.format("%s toggled the citizenship on a datafile with the ID %s.", toggler, toggledDatafile)
end)

function PLUGIN:DatabaseConnected()
    local query = mysql:Create("ix_df_notes")
    query:Create("id", "INT(11) UNSIGNED NOT NULL AUTO_INCREMENT")
    query:Create("datafile_id", "INT(11) UNSIGNED DEFAULT NULL")
    query:Create("poster", "TEXT")
    query:Create("type", "TINYINT(1) UNSIGNED DEFAULT 1")
    query:Create("text", "TEXT")
    query:Create("timestamp", "TEXT")
    query:Create("points", "INT(11) DEFAULT 0")
    query:PrimaryKey("id")
    query:Execute()

    query = mysql:Create("ix_df_datafiles")
    query:Create("id", "INT(11) UNSIGNED NOT NULL AUTO_INCREMENT")
    query:Create("last_location", "TEXT")
    query:Create("citizenship", "TINYINT(1) UNSIGNED DEFAULT 1")
    query:Create("bol", "TINYINT(1) UNSIGNED DEFAULT 0")
    query:Create("points", "INT(11) DEFAULT 0")
    query:PrimaryKey("id")
    query:Execute()
end

function PLUGIN:CanOpenDatafile(requester)
    if !requester or requester and !IsValid(requester) then return false end

    local character = requester.GetCharacter and requester:GetCharacter()
    if !character then return false end

    local faction = character.GetFaction and character:GetFaction()
    if !faction then return false end

    local shouldBeAllowed = false
    local factionIndices = ix.faction.indices[faction]
    for _, v in pairs(ix.datafile.allowedFactions) do
        if v == factionIndices.uniqueID then
            shouldBeAllowed = true
            break
        end
    end

    if !shouldBeAllowed then requester:NotifyLocalized("dfNotCombine") return false end

    return true
end

function PLUGIN:OpenDatafile(requester, sTarget)
    if !self:CanOpenDatafile(requester) then return end
    if !sTarget then return end

    local target

    local numberedVersion = tonumber(sTarget)
    local isCID = string.len(sTarget) == 5 and isnumber(numberedVersion) and numberedVersion > 0

    for _, v in pairs(ix.char.loaded) do
        if (ix.util.StringMatches(isCID and v:GetData("cid") or v:GetName(), sTarget)) then
            target = v
        end
    end

    if target then
        target:OpenDatafile(requester)
        return
    end

    -- no loaded char with the searched string
    self:FindDatafileInDB(requester, sTarget, isCID)
end

function PLUGIN:FindDatafileInDB(requester, sTarget, isCID)
    local whereClause
    local orderByClause = ""
    local selectClause = "id, name, datafile, data, faction"
    if isCID then
        whereClause = string.format("data LIKE '%%\"cid\":\"%s\"%%'", sTarget)
    else
        whereClause = string.format("name LIKE '%%%s%%'", sTarget)
        orderByClause = string.format("ORDER BY ABS(LENGTH(name) - LENGTH('%s')) ASC", sTarget)
    end

    local query = string.format("SELECT %s FROM ix_characters WHERE %s %s LIMIT 1", selectClause, whereClause, orderByClause)
    mysql:RawQuery(query, function(result)
        if !self:QueryCheck(result) then requester:NotifyLocalized("dfCouldNotFindDf") return end

        local row = result[1]
        local data = util.JSONToTable(row.data)
        if data then
            row.cid = data.cid
            row.data = nil -- Remove the data field as we've extracted the CID value
        end

        row.faction = ix.faction.teams[row.faction].uniqueID
        local dfID = row.datafile and tonumber(row.datafile)
        if dfID and dfID > 0 then
            self:CacheDatafile(requester, dfID, row.name, row.cid, row.faction, function(datafile)
                ix.log.Add(requester, "dfOpenedDatafile", requester:GetCharacter():GetName(), row.name, dfID)

                self:SendDatafile(requester, datafile)
            end)
        else
            self:DBFindError(requester)
        end
    end)
end

function PLUGIN:SendDatafile(requester, datafile)
    net.Start("ixOpenDatafile")
    net.WriteUInt(tonumber(datafile.id), 32)
    net.WriteString(datafile.last_location.location)
    net.WriteUInt(datafile.last_location.timestamp, 32)
    net.WriteBit(datafile.citizenship == 1 and true or false)
    net.WriteBit(datafile.bol == 1 and true or false)
    net.WriteInt(tonumber(datafile.points), 8)
    net.WriteTable(ix.datafile.tiers)
    net.WriteString(datafile.name)
    net.WriteUInt(datafile.cid or 0, 17)
    net.WriteString(datafile.faction)
    net.Send(requester)
end

function PLUGIN:DBFindError(requester)
    if requester and IsValid(requester) then
        requester:NotifyLocalized(L("dfCouldNotFindDf"))
    end
end

function PLUGIN:ShouldSkipDatafileCreation(character)
    local shouldSkip = false
    local faction = ix.faction.indices[character:GetFaction()]
    for _, v in pairs(ix.datafile.excludedFactions) do
        if v == faction.uniqueID then
            shouldSkip = true
            break
        end
    end

    return shouldSkip
end

function PLUGIN:OnCharacterCreated(client, character)
    if self:ShouldSkipDatafileCreation(character) then return end

    self:CreateDatafile(client, character)
end

function PLUGIN:CreateDatafile(client, character, callback)
    if !client or client and !IsValid(client) then return end
    if !character then client:NotifyLocalized("dfCreationError") return end

    local charID = character.GetID and character:GetID()
    if !charID then client:NotifyLocalized("dfCreationError") return end

    local defaultLocation = {
        location = ix.config.Get("datafileDefaultLocation", "TRAIN STATION"),
        timestamp = os.time()
    }

    local insert = mysql:Insert("ix_df_datafiles")
    insert:Insert("last_location", util.TableToJSON(defaultLocation))
    insert:Callback(function(_, _, insertID)
        local charName = character.GetName and character:GetName() or L("dfUnknown", client)
        ix.log.Add(client, "dfCreatedDatafile", charName, insertID)
        client:AddCombineDisplayMessage("@dfCombineDatafileCreated")

        character:SetDatafile(insertID)

        local faction = ix.faction.indices[character:GetFaction()]
        PLUGIN:CacheDatafile(client, insertID, charName, character:GetData("cid"), faction.uniqueID, callback)
    end)

    insert:Execute()
end

function PLUGIN:PlayerLoadedCharacter(client, character)
    if self:ShouldSkipDatafileCreation(character) then return end

    if !client or client and !IsValid(client) then return end
    if !character then client:NotifyLocalized("dfLoadingError") return end

    local datafileID = character:GetDatafile()
    if !datafileID or datafileID <= 0 then
        self:CreateDatafile(client, character)
        return
    end

    local faction = ix.faction.indices[character:GetFaction()]
    self:CacheDatafile(client, datafileID, character:GetName(), character:GetData("cid"), faction.uniqueID)
end

function PLUGIN:CacheDatafile(client, datafileID, name, cid, faction, callback)
    if ix.datafile.cached[datafileID] then
        ix.datafile.cached[datafileID].name = name
        ix.datafile.cached[datafileID].cid = cid
        ix.datafile.cached[datafileID].faction = faction

        if callback then
            callback(ix.datafile.cached[datafileID])
        end

        return
    end

    local query = mysql:Select("ix_df_datafiles")
    query:Select("id")
    query:Select("last_location")
    query:Select("citizenship")
    query:Select("bol")
    query:Select("points")
    query:Where("id", datafileID)
    query:Limit(1)
    query:Callback(function(result)
        if !self:QueryCheck(result) then client:NotifyLocalized("dfCouldNotFindDf") return end

        ix.datafile.cached[tonumber(result[1].id)] = self:CreateDatafileFromDB(result, name, cid, faction)
        ix.log.Add(client, "dfCachedDatafile", name, result[1].id)

        if callback then
            callback(ix.datafile.cached[datafileID])
        end

        client:AddCombineDisplayMessage("@dfCombineCachedDatafile")
    end)
    query:Execute()
end

function PLUGIN:CreateDatafileFromDB(result, name, cid, faction)
    local sUnknown = "@dfUnknown"

    local datafile = {
        id = result[1].id,
        last_location = util.JSONToTable(result[1].last_location or {}),
        citizenship = tonumber(result[1].citizenship) or 1,
        bol = tonumber(result[1].bol) or 0,
        name = name or sUnknown,
        cid = tonumber(cid),
        faction = faction or sUnknown,
        points = result[1].points or 0
    }

    return datafile
end

function PLUGIN:NextQueryCheck(client)
    if client.dfNextQuery and client.dfNextQuery > CurTime() then
        client:NotifyLocalized("dfWait")
        return false
    end

    client.dfNextQuery = CurTime() + 1

    return true
end

function PLUGIN:RequestNotes(requester, datafileID, noteType, currentPage, bNextPage)
    if !self:CanOpenDatafile(requester) then return end
    if !self:NextQueryCheck(requester) then return end

    currentPage = currentPage or 1
    currentPage = math.Clamp(currentPage + (bNextPage and 1 or -1), 1, 9999)

    local logsPerPage = ix.config.Get("datafileNotesLoadAmount")
    local offset = (currentPage - 1) * logsPerPage

    local queryStr = string.format(
        "SELECT id, datafile_id, poster, type, text, timestamp, points " ..
        "FROM ix_df_notes WHERE type = '%s' AND datafile_id = %d " ..
        "ORDER BY timestamp DESC LIMIT %d OFFSET %d",
        noteType, datafileID, logsPerPage, offset
    )

    mysql:RawQuery(queryStr, function(result)
        if !self:QueryCheck(result) then result = {} end

        net.Start("ixDatafileUpdateNotes")
        net.WriteTable(result)
        net.WriteUInt(tonumber(datafileID), 32)
        net.WriteUInt(tonumber(noteType), 2)
        net.WriteUInt(tonumber(currentPage), 32)
        net.Send(requester)
    end)
end

function PLUGIN:GetStringNoteType(client, nType)
    if nType == 1 then return L("dfStandard", client) end
    if nType == 2 then return L("dfLoyalist", client) end
    if nType == 3 then return L("dfMedical", client) end
end

function PLUGIN:AddNote(client, datafileID, noteType, poster, text, points)
    if !self:CanOpenDatafile(client) then return end

    local maxNoteCharacters = ix.config.Get("datafileNotesMaxCharacters", 500)
    if string.len(text) > maxNoteCharacters then return end

    local datafile = ix.datafile.cached[datafileID]
    if !datafile then return end

    local curPoints = datafile.points or 0
    points = tonumber(points) or 0
    curPoints = math.Clamp(curPoints + points, -100, 100)

    local insert = mysql:Insert("ix_df_notes")
    insert:Insert("datafile_id", datafileID)
    insert:Insert("poster", poster)
    insert:Insert("type", noteType)
    insert:Insert("text", text)
    insert:Insert("timestamp", os.time())
    insert:Insert("points", points)
    insert:Callback(function()
        local sNoteType = self:GetStringNoteType(client, noteType)
        ix.log.Add(client, "dfAddedNote", poster, sNoteType, datafileID)

        self:RequestNotes(client, datafileID, noteType, 1)
        client:NotifyLocalized("dfAddedNote", sNoteType)

        datafile.points = curPoints
        net.Start("ixDatafileUpdatePoints")
        net.WriteUInt(datafileID, 32)
        net.WriteInt(curPoints, 8)
        net.Send(client)

        local query = mysql:Update("ix_df_datafiles")
        query:Update("points", curPoints)
        query:Where("id", datafileID)
        query:Execute()

        local name = datafile.name or L("dfUnknown", client)
        local cid = datafile.cid or L("dfUnknown", client)

        if points ~= 0 then
            local message = (points > 0) and "@dfCombineAddedPoints" or "@dfCombineDatafileChange"
            client:AddCombineDisplayMessage(message, Color(255, 255, 255, 255), poster, points, name, cid)
        end
    end)

    insert:Execute()
end

function PLUGIN:RemoveNote(client, datafileID, noteID, noteType)
    if !self:CanOpenDatafile(client) then return end

    local query = mysql:Delete("ix_df_notes")
    query:Where("datafile_id", datafileID)
    query:Where("id", noteID)
    query:Execute()

    ix.log.Add(client, "dfRemovedNote", client:GetCharacter():GetName(), self:GetStringNoteType(client, noteType), datafileID)

    self:RequestNotes(client, datafileID, noteType, 1)
    client:AddCombineDisplayMessage("@dfCombineDatafileChange")
end

function PLUGIN:QueryCheck(result)
    if !result then return false end
    if !istable(result) or istable(result) and #result < 0 then return false end
    if !result[1] then return false end
    if !result[1].id then return false end

    return true
end

function PLUGIN:PreCharacterDeleted(client, character)
    local datafileID = character.GetDatafile and character:GetDatafile()
    if !datafileID then return end

    local query = mysql:Delete("ix_df_datafiles")
    query:Where("id", datafileID)
    query:Execute()

    query = mysql:Delete("ix_df_notes")
    query:Where("datafile_id", datafileID)
    query:Execute()

    ix.datafile.cached[datafileID] = nil

    client:AddCombineDisplayMessage("@dfCombineDatafileRemoved")
end

function PLUGIN:CheckForConfigAccess(client)
    if (!CAMI.PlayerHasAccess(client, "Helix - Manage Config", nil)) then
        return false
    end

    return true
end

function PLUGIN:AddTier(client, name, pointsRequired)
    if !self:CheckForConfigAccess(client) then return end

    local sameAmount = false

    for _, v in pairs(ix.datafile.tiers) do
        if pointsRequired == tonumber(v.pointsRequired) then
            sameAmount = true
        end
    end

    if sameAmount then client:NotifyLocalized("dfSame") return end

    ix.datafile.tiers[#ix.datafile.tiers + 1] = {name = name, pointsRequired = pointsRequired}

    net.Start("ixDatafileAddTier")
    net.WriteTable(ix.datafile.tiers)
    net.Send(client)
end

function PLUGIN:RemoveTier(client, tierID)
    if !self:CheckForConfigAccess(client) then return end

    ix.datafile.tiers[tierID] = nil

    net.Start("ixDatafileAddTier")
    net.WriteTable(ix.datafile.tiers)
    net.Send(client)
end

function PLUGIN:UpdateTierColor(client, color, tierID)
    if !self:CheckForConfigAccess(client) then return end

    ix.datafile.tiers[tonumber(tierID)].color = color
    client:NotifyLocalized("dfTierColorUpdated")

    self:SaveData()
end

function PLUGIN:AddExcludedFaction(client, factionUnique)
    if !self:CheckForConfigAccess(client) then return end

    local same = false

    for _, v in pairs(ix.datafile.excludedFactions) do
        if v == factionUnique then
            same = true
        end
    end

    if same then client:NotifyLocalized("dfSameExclude") return end

    ix.datafile.excludedFactions[#ix.datafile.excludedFactions + 1] = factionUnique

    net.Start("ixDatafileAddExcludedFaction")
    net.WriteTable(ix.datafile.excludedFactions)
    net.Send(client)
end

function PLUGIN:RemoveExcludedFaction(client, factionUnique)
    if !self:CheckForConfigAccess(client) then return end

    for key, v in pairs(ix.datafile.excludedFactions) do
        if v == factionUnique then
            ix.datafile.excludedFactions[key] = nil
            break
        end
    end

    net.Start("ixDatafileAddExcludedFaction")
    net.WriteTable(ix.datafile.excludedFactions)
    net.Send(client)
end

function PLUGIN:AddAllowedFaction(client, factionUnique)
    if !self:CheckForConfigAccess(client) then return end

    local same = false

    for _, v in pairs(ix.datafile.allowedFactions) do
        if v == factionUnique then
            same = true
        end
    end

    if same then client:NotifyLocalized("dfSameAllowedFaction") return end

    ix.datafile.allowedFactions[#ix.datafile.allowedFactions + 1] = factionUnique

    net.Start("ixDatafileAddAllowedFaction")
    net.WriteTable(ix.datafile.allowedFactions)
    net.Send(client)
end

function PLUGIN:RemoveAllowedFaction(client, factionUnique)
    if !self:CheckForConfigAccess(client) then return end

    for key, v in pairs(ix.datafile.allowedFactions) do
        if v == factionUnique then
            ix.datafile.allowedFactions[key] = nil
            break
        end
    end

    net.Start("ixDatafileAddAllowedFaction")
    net.WriteTable(ix.datafile.allowedFactions)
    net.Send(client)
end

function PLUGIN:GetClientLocation(client)
    local areaInfo = ix.area.stored[client.ixArea]
    if (!areaInfo) then
        return L("dfUnknown", client)
    end

    if (areaInfo.type != "area" or !areaInfo.properties.display) then
        return L("dfUnknown", client)
    end

    return string.utf8upper(client.ixArea)
end

function PLUGIN:UpdateLastSeen(client, datafileID)
    if !self:CanOpenDatafile(client) or !self:NextQueryCheck(client) then return end

    local cachedDatafile = ix.datafile.cached[datafileID]
    if !cachedDatafile then return end

    local clientLocation = self:GetClientLocation(client)
    local currentTime = os.time()

    cachedDatafile.last_location = {
        location = clientLocation,
        timestamp = currentTime
    }

    local query = mysql:Update("ix_df_datafiles")
    query:Update("last_location", util.TableToJSON(cachedDatafile.last_location))
    query:Where("id", datafileID)
    query:Execute()

    net.Start("ixDatafileUpdateLastSeen")
    net.WriteUInt(datafileID, 32)
    net.WriteString(clientLocation)
    net.WriteUInt(currentTime, 32)
    net.Send(client)

    client:NotifyLocalized("dfUpdatedLastSeen")
    client:AddCombineDisplayMessage("@dfCombineDatafileChange")
end

function PLUGIN:SendCitizenshipBOLToggleMessage(datafile, toggler, togglerName, nActive, sType)
    if !toggler or toggler and !IsValid(toggler) then return end
    local unknown = L("dfUnknown", toggler)

    datafile.name = datafile.name or unknown
    datafile.cid = datafile.cid or unknown

    local lType = (sType == "bol") and L("dfBOL", toggler) or L("dfCitizenship", toggler)
    local activeDisabled = (nActive == 1) and L("dfActive", toggler) or
    ((sType == "citizenship") and L("dfRevoked", toggler) or L("dfDisabled", toggler))

    local red, green = Color(255, 0, 0, 255), Color(0, 255, 0, 255)
    local color = (nActive == 1 and sType == "citizenship") and green or (nActive == 0 and sType == "bol") and green or red

    toggler:AddCombineDisplayMessage("@dfToggledBOL", color, togglerName, lType, activeDisabled, datafile.name, datafile.cid)
end

function PLUGIN:SetBOLCitizenship(client, datafileID, nType, nActive, reason)
    if !self:CanOpenDatafile(client) then return end

    local sType = nType == 0 and "bol" or "citizenship"
    ix.datafile.cached[datafileID][sType] = nActive

    local query = mysql:Update("ix_df_datafiles")
    query:Update(sType, nActive)
    query:Where("id", datafileID)
    query:Execute()

    net.Start("ixDatafileUpdateBOLCitizenship")
    net.WriteUInt(datafileID, 32)
    net.WriteBit(nType)
    net.WriteBit(nActive)
    net.Send(client)

    local msg = nActive == 1 and L("dfActive", client) or L("dfRevoked", client)
    local typeString = sType == "bol" and L("dfBOL", client) or L("dfCitizenship", client)
    local notif = string.utf8upper(typeString).." "..msg
    client:Notify(notif)

    if !client or client and !IsValid(client) then return end

    local character = client.GetCharacter and client:GetCharacter()
    if !character then return end

    local charName = character.GetName and character:GetName() or L("dfUnknown", client)

    self:AddNote(client, datafileID, 1, charName, notif..": "..reason, 0)
    self:SendCitizenshipBOLToggleMessage(ix.datafile.cached[datafileID], client, charName, nActive, sType)

    if sType == "bol" then
        ix.log.Add(client, "dfToggledBOL", charName, datafileID)
        return
    end

    ix.log.Add(client, "dfToggledCitizenship", charName, datafileID)
end

function PLUGIN:SaveData()
    ix.data.Set("datafileTiers", ix.datafile.tiers, true)
    ix.data.Set("datafileExcludedFactions", ix.datafile.excludedFactions, true)
    ix.data.Set("datafileAllowedFactions", ix.datafile.allowedFactions, true)
end

function PLUGIN:LoadData()
    ix.datafile.tiers = ix.data.Get("datafileTiers", {}, true)
    ix.datafile.excludedFactions = ix.data.Get("datafileExcludedFactions", {}, true)
    ix.datafile.allowedFactions = ix.data.Get("datafileAllowedFactions", {"metropolice", "ota"}, true)
end