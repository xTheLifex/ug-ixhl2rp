
local charMeta = ix.meta.character
local PLUGIN = PLUGIN

function charMeta:OpenDatafile(requester)
    local datafileID = self.GetDatafile and self:GetDatafile()
    if !datafileID and !self:ShouldSkipDatafileCreation(self) then
        PLUGIN:CreateDatafile(requester, self, function(cachedDatafile)
            ix.log.Add(requester, "dfOpenedDatafile", requester:GetCharacter():GetName(), self:GetName(), datafileID)

            PLUGIN:SendDatafile(requester, cachedDatafile)
        end)

        return
    end

    local faction = ix.faction.indices[self:GetFaction()].uniqueID
    PLUGIN:CacheDatafile(requester, datafileID, self:GetName(), self:GetData("cid"), faction, function(datafile)
        ix.log.Add(requester, "dfOpenedDatafile", requester:GetCharacter():GetName(), self:GetName(), datafileID)

        PLUGIN:SendDatafile(requester, datafile)
    end)
end