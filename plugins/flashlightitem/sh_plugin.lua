
PLUGIN.name = "Flashlight item"
PLUGIN.author = "SleepyMode"
PLUGIN.description = "Adds an item allowing players to toggle their flashlight."

function PLUGIN:PlayerSwitchFlashlight(client, bEnabled)
	local character = client:GetCharacter()
	local inventory = character and character:GetInventory()
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

function PLUGIN:Think()
	if not SERVER then return end
	self.nextThink = self.nextThink or 0
	if (self.nextThink > CurTime()) then return end
	self.nextThink = CurTime() + 1

	for _, ply in ipairs(player.GetAll()) do
		local char = ply:GetCharacter()
		if (ply:FlashlightIsOn()) then
			local flashlight = char:GetInventory():HasItem("flashlight")
			if flashlight then
				local decay = 10
				local charge = math.Clamp((flashlight:GetData("battery", 0) - decay), 0, 100)
				flashlight:SetData("battery", charge)
				if (charge <= 0) then
					ply:Flashlight(false)
					ply:Notify("Your flashlight's battery is depleted!")
				end
			end
		end
	end
end