
PLUGIN.name = "Flashlight item"
PLUGIN.author = "SleepyMode"
PLUGIN.description = "Adds an item allowing players to toggle their flashlight."

function PLUGIN:PlayerSwitchFlashlight(client, bEnabled)
	local character = client:GetCharacter()
	local inventory = character and character:GetInventory()
	if not inventory then return false end
	local flashlight = inventory:HasItem("flashlight")

	if (inventory and flashlight) then
		local charged = (flashlight:GetData("battery", 0) > 0)
		
		if (charged) then
			return true
		else
			if (bEnabled) then
				return false
			else
				return true
			end
		end
	end

	return false
end