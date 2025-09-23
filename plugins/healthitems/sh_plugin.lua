PLUGIN.name = "Life's Health Items"
PLUGIN.description = "A bunch of items."
PLUGIN.author = "TheLife"
PLUGIN.maxLength = 512

function PLUGIN:AddItemTable(t)
    local count = 0

    for id, data in pairs(t) do
        local ITEM = ix.item.Register(id, nil, false, nil, true)
        if (!ITEM) then
            print("[Life's Health Items] Failed to register " .. id)
            continue
        end

        ITEM.name = data.name or "Unnamed Health Item"
        ITEM.description = data.desc or data.description or "A healing item."
        ITEM.model = data.model or "models/props_junk/garbage_bag001a.mdl"
        ITEM.skin = data.skin or 0
        ITEM.category = data.category or "Medical"
        ITEM.width = data.width or 1
        ITEM.height = data.height or 1

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

        -- Merge default function with any custom ones
        ITEM.functions = ITEM.functions or {}
        ITEM.functions.Use = ITEM.functions.Use or {
            name = "Use",
            tip = "Use this item",
            icon = "icon16/add.png",
            OnRun = function (item)
                local client = item.player
                local character = client:GetCharacter()
                client:SetHealth(math.min(client:Health() + (data.hp or 10), client:GetMaxHealth()))
                if (data.sound) then
                    client:EmitSound(data.sound, 75, math.random(95, 105), 1)
                else
                    client:EmitSound("npc/zombie/foot_slide" .. math.random(1, 3) .. ".wav", 75, math.random(90, 120), 1)
                end
            end
        }

        -- Replace only the OnRun if custom use func exists
        if (data.use and isfunction(data.use)) then
            ITEM.functions.Use.OnRun = data.use
        end

        count = count + 1
    end

    print("[Life's Health Items] Registered " .. tostring(count) .. " items.")
end


/* -------------------------------- Includes -------------------------------- */
ix.util.Include("sh_healthitems.lua")