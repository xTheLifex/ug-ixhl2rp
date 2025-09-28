PLUGIN.name = "Life's Clothes"
PLUGIN.description = "A bunch of clothing items you can wear."
PLUGIN.author = "TheLife"
PLUGIN.authorColor = Color(55,180,230)
PLUGIN.maxLength = 512


function PLUGIN:AddClothingItems(t)
    for id, data in pairs(t) do
        local base = data.base or "base_outfit" 
        local ITEM = ix.item.Register(id, "base_outfit", false, nil, true)
        if (!ITEM) then
            print("[Life's Clothes] Failed to register " .. id)
            continue
        end
        for k,v in pairs(data) do 
            ITEM[k] = v
        end
        ITEM.description = data.desc or data.description
        ITEM.model = data.model or "models/props_c17/briefcase001a.mdl"
        ITEM.sound = data.sound or "npc/combine_soldier/zipline_clothing2.wav"
        ITEM.base = "base_outfit"
    end
end

/* -------------------------------- Includes -------------------------------- */
ix.util.Include("sh_uniforms.lua")