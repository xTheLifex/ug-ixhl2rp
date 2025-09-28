PLUGIN.name = "Life's Filler Items"
PLUGIN.description = "A bunch of items."
PLUGIN.author = "TheLife"
PLUGIN.authorColor = Color(55,180,230)
PLUGIN.maxLength = 512

function PLUGIN:AddItemTable(t)
    for id, data in pairs(t) do
        local ITEM = ix.item.Register(id, nil, false, nil, true)
        if (!ITEM) then
            print("[Life's Filler Items] Failed to register " .. id)
            continue
        end

        for k,v in pairs(data) do 
            ITEM[k] = v
        end

        if (data.OnUse) then
            ITEM.functions.OnUse = data.OnUse
        end

        ITEM.description = data.desc or data.description
        ITEM.category = data.category or "Junk"
        ITEM.base = "base_random_model"    
    end
end

/* -------------------------------- Includes -------------------------------- */
ix.util.Include("sh_filleritems.lua")