PLUGIN.name = "No Drop for NPCs"
PLUGIN.author = "Shazzy"
PLUGIN.description = "Stops NPCs dropping entities on death."

ix.config.Add("npcWeaponRemoval", true, "Should NPCs' weapons be removed upon death?", nil, {
    category = "NPCs",
    type = ix.type.bool
})

if (SERVER) then

    function PLUGIN:OnNPCKilled(npc, attacker, inflictor)

        if ix.config.Get("npcWeaponRemoval", true) and IsValid(npc) then

            local weapon = npc:GetActiveWeapon()
            if IsValid(weapon) then
                weapon:Remove()
            end

            if npc:HasSpawnFlags(8) then
                npc:SetKeyValue("spawnflags", bit.band(npc:GetSpawnFlags(), bit.bnot(8)))
            end
        end
    end
end