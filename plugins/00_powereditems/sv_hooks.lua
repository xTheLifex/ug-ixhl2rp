
function PLUGIN:Think()
	self.nextThink = self.nextThink or 0
	if (self.nextThink > CurTime()) then return end
	self.nextThink = CurTime() + 1

	for _, ply in ipairs(player.GetAll()) do
		local char = ply:GetCharacter()
        local inventory = char and char:GetInventory()

        if not inventory then continue end
        
        for _, item in pairs(inventory:GetItems(false)) do
            if (item.base == "base_powered") then
                if (item:IsConsumingBattery(item)) then
                    local decay = 100/ (item.batteryLife or 3600)
                    local charge = math.Clamp((item:GetData("battery", 0) - decay), 0, 100)
                    item:SetData("battery", charge)

                    if (charge <= 0) then
                        item:OnBatteryDepleted()
                        ply:Notify(string.format("Your %s's battery is depleted!", (item:GetName() or item.name)))
                    end
                end
            end
        end
	end
end