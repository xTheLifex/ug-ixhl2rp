
ITEM.name = "Powered Item"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.description = "This item can be fit with a battery."
ITEM.category = "Misc"

function ITEM:PopulateTooltip(tooltip)
	local charge = self:GetData("battery", 0)
	local font = "ixSmallFont"
	local info = tooltip:AddRowAfter("description", "info")
	local text = string.format("Charge %s%%", charge)

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

function ITEM:OnBatteryRemoved()

end

function ITEM:OnBatteryDepleted()
	
end

function ITEM:OnBatteryReplaced()
	
end

function ITEM:OnBatteryInserted()

end

function ITEM:HasBattery()
	return (self:GetData("battery", 0) > 0)
end

function ITEM:IsConsumingBattery()
	return false
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

		item:OnBatteryRemoved()
		client:Notify(string.format("You remove the battery from the %s.", (item:GetName() or item.name)))
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
			
			client:Notify(string.format("You replace the battery in the %s.", (item:GetName() or item.name)))
			item:OnBatteryReplaced()
		else
			client:Notify(string.format("You insert the battery in the %s.", (item:GetName() or item.name)))
			item:OnBatteryInserted()
		end
		return false
	end,
	OnCanRun = function(item, data)
		local battery = ix.item.instances[data[1]]
		local isBattery = (battery.uniqueID == "battery")
		return isBattery
	end
}