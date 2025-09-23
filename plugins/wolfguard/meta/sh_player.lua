local meta = FindMetaTable("Player")

function meta:IsOnLadder()
    return (self:GetMoveType() == MOVETYPE_LADDER)
end

function meta:IsAFK()
    return (self.isAFK == true)
end