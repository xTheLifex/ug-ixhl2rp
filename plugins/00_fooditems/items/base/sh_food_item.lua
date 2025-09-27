
ITEM.name = "Food Item"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.width = 1
ITEM.height = 1
ITEM.description = "Sustenance."
ITEM.category = "Consumables"
ITEM.base = "base_random_model"

function ITEM:PopulateTooltip(tooltip)
	local font = "ixSmallFont"
	local info = tooltip:AddRowAfter("description", "info")
	local text = "This item can be consumed."
    local color = Color(95,225,65)

    if (self.pack) then
        text = "This item is a package and can be opened."
        color = Color(204,204,204)
    end

	info:SetText(text)
	info:SetFont(font)
	info:SetBackgroundColor(color)
	info:SizeToContents()
end

ITEM.functions.Consume = {
    name = "Consume",
    tip = "Consume this item",
    icon = "icon16/add.png",
    OnRun = function(item)
        local client = item.player
        local character = client:GetCharacter()
        local inventory = character:GetInventory()
        if (!client) then return false end
        
        client:EmitSound("npc/zombie/foot_slide" .. math.random(1, 3) .. ".wav", 75, math.random(90, 120), 1)
        if (item.trash ~= nil) then
            if (!inventory:Add(item.trash)) then
                ix.item.Spawn(item.trash, client)
            end
        end
    end,
    OnCanRun = function (item)
        return (item.pack == nil)
    end
}

ITEM.functions.Unpack = {
    name = "Unpackage",
    tip = "Unpackage this item",
    icon = "icon16/add.png",
    OnRun = function(item)
        local client = item.player
        local character = client:GetCharacter()
        local inventory = character:GetInventory()
        if (!client) then return false end

        for item, amount in pairs(item.pack) do
            if (item == "token" or item == "tokens") then
                local tokens = ix.config.Get("rationTokens", 20)
                if (amount > 0) then tokens = amount end
                character:GiveMoney(tokens)
                continue
            end

            for i=1, amount do
                if (!inventory:Add(item)) then
                    ix.item.Spawn(item, client)
                end
            end
        end

        if (item.trash ~= nil) then
            if (!inventory:Add(item.trash)) then
                ix.item.Spawn(item.trash, client)
            end
        end        

        --client:EmitSound("ambient/fire/mtov_flame2.wav", 75, math.random(160, 180), 0.35)
        client:EmitSound("npc/zombie/foot_slide" .. math.random(1, 3) .. ".wav", 75, math.random(90, 120), 1)
    end,
    OnCanRun = function (item)
        return (item.pack != nil)
    end
}