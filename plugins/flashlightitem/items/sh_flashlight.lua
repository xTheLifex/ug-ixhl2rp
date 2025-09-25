
ITEM.name = "Flashlight"
ITEM.base = "base_powered"
ITEM.model = Model("models/ug_imports/clockwork/flashlight.mdl")
ITEM.width = 1
ITEM.height = 1
ITEM.description = "A standard flashlight that can be toggled."
ITEM.category = "Tools"
ITEM.batteryLife = 5 -- seconds

ITEM:Hook("drop", function(item)
	item.player:Flashlight(false)
end)

function ITEM:IsConsumingBattery()
	return self:GetOwner():FlashlightIsOn()
end

function ITEM:OnBatteryRemoved()
	self:GetOwner():Flashlight(false)
end

function ITEM:OnBatteryDepleted()
	self:GetOwner():Flashlight(false)
end