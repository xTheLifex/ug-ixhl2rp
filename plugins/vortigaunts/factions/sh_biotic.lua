

FACTION.name = "Biotic"
FACTION.description = "Enslaved and chained, these Vortigaunts do not live free. Their bodies are weakened, and those responsible attempt to crush their will."
FACTION.color = Color(0, 188, 0, 255);
FACTION.runSounds = {[0] = "NPC_Vortigaunt.FootstepLeft", [1] = "NPC_Vortigaunt.FootstepRight"}
FACTION.weapons = {"ix_vortsweep"}
FACTION.isDefault = false
FACTION.models = {
	"models/vortigaunt_slave.mdl"
}

function FACTION:OnTransferred(client)
	local character = client:GetCharacter()
	character:SetModel(self.models[1])
end

FACTION_BIOTIC = FACTION.index
