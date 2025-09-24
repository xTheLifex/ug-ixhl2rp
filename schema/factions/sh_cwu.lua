
FACTION.name = "Civil Worker's Union"
FACTION.description = "A group of people responsible for the civil infrastructure under the combine rule."
FACTION.color = Color(168, 118, 25)
FACTION.isDefault = true
FACTION.models = {
		"models/ug/humans/female_01.mdl",
		"models/ug/humans/female_02.mdl",
		"models/ug/humans/female_03.mdl",
		"models/ug/humans/female_04.mdl",
		"models/ug/humans/female_06.mdl",
		"models/ug/humans/female_07.mdl",
		"models/ug/humans/female_11.mdl",
		"models/ug/humans/female_17.mdl",
		"models/ug/humans/female_18.mdl",
		"models/ug/humans/female_19.mdl",
		"models/ug/humans/female_24.mdl",
		"models/ug/humans/female_25.mdl",
		"models/ug/humans/male_01.mdl",
		"models/ug/humans/male_02.mdl",
		"models/ug/humans/male_03.mdl",
		"models/ug/humans/male_04.mdl",
		"models/ug/humans/male_05.mdl",
		"models/ug/humans/male_06.mdl",
		"models/ug/humans/male_07.mdl",
		"models/ug/humans/male_08.mdl",
		"models/ug/humans/male_09.mdl",
		"models/ug/humans/male_10.mdl",
		"models/ug/humans/male_11.mdl",
		"models/ug/humans/male_12.mdl",
		"models/ug/humans/male_15.mdl",
		"models/ug/humans/male_16.mdl",
		"models/ug/humans/male_17.mdl"
}


function FACTION:OnCharacterCreated(client, character)
	local id = Schema:ZeroNumber(math.random(1, 99999), 5)
	local inventory = character:GetInventory()

	character:SetData("cid", id)

	inventory:Add("suitcase", 1)
	inventory:Add("cid", 1, {
		name = character:GetName(),
		id = id
	})
end

FACTION_CWU = FACTION.index
