local playerMeta = FindMetaTable("Player")

function playerMeta:IsCombine()
	local faction = self:Team()
	return faction == FACTION_MPF or faction == FACTION_OTA
end

function playerMeta:IsAirwatch()
	return self:IsDispatch()
end

function playerMeta:IsDispatch()
	local name = self:Name()
	local faction = self:Team()
	
	local scanner = Schema:IsCombineRank(name, "SCN")
	local claw = Schema:IsCombineRank(name, "SHIELD")
	return (self:IsCombine() and (scanner or shield)) 
end

function playerMeta:IsHighRank()
	local name = self:Name()
	local ranks = {"OfC", "CmD", "EpU", "DvL", "i1", "i2"}
	local ranking = false
	for _, rank in ipairs(ranks) do
		if Schema:IsCombineRank(name, rank) then
			ranking = true
		end
	end
	return self:IsAirwatch() or ranking
end
