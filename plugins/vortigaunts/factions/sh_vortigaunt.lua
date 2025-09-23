
FACTION.name = "Vortigaunt"
FACTION.description = "Those Vortigaunts that live free. Not from this planet, and formerly resided in the Xen dimension before coming to Earth. Wise, articulate, powerful."
FACTION.color = Color(0, 188, 0, 255);
FACTION.runSounds = {[0] = "NPC_Vortigaunt.FootstepLeft", [1] = "NPC_Vortigaunt.FootstepRight"}
FACTION.weapons = {"ix_vortbeam", "ix_vortheal"}
FACTION.isDefault = false
FACTION.models = {
	"models/vortigaunt_rp/vortigaunt.mdl"
}


function FACTION:OnTransferred(client)
	local character = client:GetCharacter()
	character:SetModel(self.models[1])
end

FACTION_VORT = FACTION.index
