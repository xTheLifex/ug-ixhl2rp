PLUGIN.name = "Life's Foods"
PLUGIN.description = "A bunch of food items."
PLUGIN.author = "TheLife"
PLUGIN.authorColor = Color(55,180,230)
PLUGIN.maxLength = 512

function PLUGIN:AddFoodItemTable(t)
    print("[Life's Food Items] Registering Items...")
    for id, data in pairs(t) do
        
        local ITEM = ix.item.Register(id, "base_food_item", false, nil, true)
        if (!ITEM) then
            print("[Life's Food Items] Failed to register " .. id)
            break
        end
        
        for k,v in pairs(data) do 
            ITEM[k] = v
        end

        ITEM.category = "Consumables"
        ITEM.description = data.desc or data.description

    end
end

/* -------------------------------- Includes -------------------------------- */
ix.util.Include("sh_fooditems.lua")
