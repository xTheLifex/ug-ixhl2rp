PLUGIN.name = "Life's Health Items"
PLUGIN.description = "A bunch of items."
PLUGIN.author = "TheLife"
PLUGIN.authorColor = Color(235,85,255)
PLUGIN.maxLength = 512

function PLUGIN:AddItemTable(t)
    for id, data in pairs(t) do
        --           ix.item.Register(uniqueID, baseID, isBaseItem, path, luaGenerated)
        local ITEM = ix.item.Register(id, "base_health_item", false, nil, true)
        if (!ITEM) then
            print("[Life's Health Items] Failed to register " .. id)
            continue
        end

        for k,v in pairs(data) do 
            ITEM[k] = v
        end

        ITEM.category = "Medical"
        ITEM.description = data.desc or data.description
    end
end


/* -------------------------------- Includes -------------------------------- */
ix.util.Include("sh_healthitems.lua")