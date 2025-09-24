PLUGIN.name = "Life's Filler Items"
PLUGIN.description = "A bunch of items."
PLUGIN.author = "TheLife"
PLUGIN.authorColor = Color(235,85,255)
PLUGIN.maxLength = 512

function PLUGIN:AddItemTable(t)
    local count = 0

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

        if (data.models and data.models[1]) then
            ITEM.model = data.models[1]
    
            function ITEM:OnInstanced(index, x, y, item)
                self:SetData("model", data.models[math.random(#data.models)])
            end
        
            function ITEM:GetModel()
                local model = self:GetData("model")
                if not model then
                    self:SetData("model", data.models[math.random(#data.models)])
                end
                return self:GetData("model") or data.model
            end
        end

        count = count + 1        
    end

    print("[Life's Filler Items] Registered " .. tostring(count) .. " items.")
end

/* -------------------------------- Includes -------------------------------- */
ix.util.Include("sh_filleritems.lua")