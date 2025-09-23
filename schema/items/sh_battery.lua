
ITEM.name = "Battery"
ITEM.model = Model("models/ug_imports/junk_6vbattery.mdl")
ITEM.description = "A standard battery."

function ITEM:OnInstanced(index, x, y, item)
    self:SetData("power", self:GetData("power", 100))
end

function ITEM:PopulateTooltip(tooltip)
	local charge = self:GetData("power", 0)
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