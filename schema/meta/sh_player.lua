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
