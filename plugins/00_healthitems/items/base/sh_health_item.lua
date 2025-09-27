
ITEM.name = "Health Item"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.description = "This item can heal people or yourself.."
ITEM.category = "Medical"
ITEM.base = "base_random_model"

ITEM.hp = 5

function ITEM:PopulateTooltip(tooltip)
	local font = "ixSmallFont"
	local info = tooltip:AddRowAfter("description", "info")
	local text = "This is a medical item."
    local color = Color(220,148,120)

	info:SetText(text)
	info:SetFont(font)
	info:SetBackgroundColor(color)
	info:SizeToContents()
end

ITEM.functions.Use = {
    name = "Use on Self",
    tip = "Use this item on yourself.",
    icon = "icon16/add.png",
    OnRun = function (item)
        local client = item.player
        local character = client:GetCharacter()

        if not client then return end
        if not character then return end

        if (client:Health() >= client:GetMaxHealth()) then
            client:Notify("You do not need any healing!")
            return false
        end
        
        client:SetHealth(math.min(client:Health() + (item.hp or 10), client:GetMaxHealth()))
        if (item.sound) then
            client:EmitSound(item.sound, 75, math.random(95, 105), 1)
        else
            client:EmitSound("npc/zombie/foot_slide" .. math.random(1, 3) .. ".wav", 75, math.random(90, 120), 1)
        end
    end,
    OnCanRun = function (item)
        local client = item.player
        if not client then return false end
        return (client:Health() < client:GetMaxHealth())
    end
}

ITEM.functions.Give = {
    name = "Use on Other",
    tip = "Use this item on another person.",
    icon = "icon16/add.png",
    OnRun = function (item)
        local client = item.player
        local character = client:GetCharacter()

		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

        if not target then
            client:Notify("Invalid target!")
            return false
        end

        if (target:Health() >= target:GetMaxHealth()) then
            target:Notify("You do not need any healing!")
            return false
        end

        target:SetHealth(math.min(target:Health() + (item.hp or 10), target:GetMaxHealth()))
        if (item.sound) then
            target:EmitSound(item.sound, 75, math.random(95, 105), 1)
        else
            target:EmitSound("npc/zombie/foot_slide" .. math.random(1, 3) .. ".wav", 75, math.random(90, 120), 1)
        end
    end,
    OnCanRun = function (item)
        if (item.entity) then return false end

        local client = item.player
        if not client then return false end
        
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity
        
        return IsValid(target)
    end
}