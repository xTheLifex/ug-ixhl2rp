
ITEM.name = "Flashlight"
ITEM.model = Model("models/ug_imports/clockwork/flashlight.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "A standard flashlight that can be toggled."
ITEM.category = "Tools"

ITEM:Hook("drop", function(item)
	item.player:Flashlight(false)
end)

function ITEM:PopulateTooltip(tooltip)
	local charge = self:GetData("battery", 0)
	local font = "ixSmallFont"
	local info = tooltip:AddRowAfter("description", "info")
	local text = "Charge: " .. charge .. "%"

	local color = Color(0,255,0)

	if ( charge < 10) then
		color = Color(255,0,0)
	elseif ( charge < 25) then
		color = Color(255,64,0)
	elseif ( charge < 50) then
		color = Color(255,136,0)
	elseif ( charge < 75) then
		color = Color(255,255,0)
	end


	info:SetText(text)
	info:SetFont(font)
	info:SetBackgroundColor(color)
	info:SizeToContents()
end

ITEM.functions.RemoveBattery = {
	name = "Remove Battery",
	icon = "icon16/cancel.png",
	OnRun = function (item, data)
		local client = item.player
		local character = client:GetCharacter()
		local inventory = character and character:GetInventory()
		local charge = item:GetData("battery", 0)
		
		if (charge <= 0) then return false end

		local ejectedBattery = inventory:Add("battery", 1, {
			power = charge
		})
		
		if (!ejectedBattery) then
			ix.item.Spawn("battery", client, function (battery, ent)
				battery:SetData("power", charge)
			end)
		end

		client:Flashlight(false)
		item:SetData("battery", 0)
		return false
	end,
	OnCanRun = function (item, data)
		return (item:GetData("battery", 0) > 0)
	end
}

ITEM.functions.combine = {
	OnRun = function(item, data)
		local client = item.player
		local character = client:GetCharacter()
		local inventory = character and character:GetInventory()
		local battery = ix.item.instances[data[1]]
		local oldCharge = item:GetData("battery", 0)

		item:SetData("battery", battery:GetData("power", 0))
		battery:Remove()
		if (oldCharge > 0) then
			local oldBattery = inventory:Add("battery", 1, {
				power = oldCharge
			})

			if (!oldBattery) then
				oldBattery = ix.item.Spawn("battery", client, function (item, ent)
					item:SetData("power", oldCharge)
				end)
			end
			
			client:Notify("You replace the battery in the flashlight.")
		else
			client:Notify("You insert the battery in the flashlight.")
		end
		return false
	end,
	OnCanRun = function(item, data)
		local battery = ix.item.instances[data[1]]
		local isBattery = (battery.uniqueID == "battery")
		return isBattery
	end
}