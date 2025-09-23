
FACTION.name = "Metropolice Force"
FACTION.description = "A paramilitary force in charge of maintaing combine control. Humans working for the Civil Protection."
FACTION.color = Color(50, 100, 150)
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

FACTION.canSeeWaypoints = true
FACTION.canAddWaypoints = true
FACTION.canRemoveWaypoints = true
FACTION.canUpdateWaypoints = true
FACTION.isDefault = false
FACTION.runSounds = {[0] = "NPC_MetroPolice.RunFootstepLeft", [1] = "NPC_MetroPolice.RunFootstepRight"}

function FACTION:OnCharacterCreated(client, character)

end

function FACTION:GetDefaultName(client)
	return "MPF-RCT." .. Schema:ZeroNumber(math.random(1, 99999), 5), true
end

function FACTION:OnTransferred(character)
	character:SetName(self:GetDefaultName())
end

function FACTION:OnNameChanged(client, oldValue, value)
	local character = client:GetCharacter()

	
	-- if (!Schema:IsCombineRank(oldValue, "RCT") and Schema:IsCombineRank(value, "RCT")) then
	-- 	character:JoinClass(CLASS_MPR)
	-- elseif (!Schema:IsCombineRank(oldValue, "OfC") and Schema:IsCombineRank(value, "OfC")) then
	-- 	character:SetModel("models/policetrench.mdl")
	-- elseif (!Schema:IsCombineRank(oldValue, "EpU") and Schema:IsCombineRank(value, "EpU")) then
	-- 	character:JoinClass(CLASS_EMP)
	-- end
	
end

FACTION_MPF = FACTION.index
