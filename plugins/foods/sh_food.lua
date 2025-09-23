function PLUGIN:AddFoodItemTable(t)
    print("[Life's Food] Registering Items...")
    for id, data in pairs(t) do
        local ITEM = ix.item.Register(id, nil, false, nil, true)
        if (!ITEM) then
            print("[Life's Food] Failed to register " .. id)
            break
        end
        
        for k,v in pairs(data) do 
            ITEM[k] = v
        end

        ITEM.description = data.desc or data.description
        ITEM.category = "Food and Drinks"
        
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
          

        local trashitem = data.trash or nil
        local istrash = data.istrash or false
        local pack = data.pack or nil
        local ispackage = false
        if (pack ~= nil) then ispackage = true end

        if (not data.desc) then
            if (istrash) then ITEM.description = "This is a trash item, of what once was a package of some sorts." end
            if (ispackage) then ITEM.description = "This is a package item and can be unpackaged." end
        end

        if (not data.category) then
            if (istrash) then ITEM.category = "Junk" end
            if (ispackage) then ITEM.category = "Consumable Packages" end
        end

        if (not istrash and not ispackage) then
            ITEM.functions.Consume = {
                name = "Consume",
                tip = "Consume this item",
                icon = "icon16/add.png",
                OnRun = function(item)
                    local client = item.player
                    local character = client:GetCharacter()
                    local inventory = character:GetInventory()
                    if (!client) then return false end
                    client:SetHealth(math.min(client:Health() + (data.hp or 10), client:GetMaxHealth()))
                    client:EmitSound("npc/zombie/foot_slide" .. math.random(1, 3) .. ".wav", 75, math.random(90, 120), 1)
                    if (data.trash ~= nil) then
                        if (!inventory:Add(data.trash)) then
                            ix.item.Spawn(data.trash, client)
                        end
                    end
                end
            }
        end

        if (ispackage) then
            ITEM.functions.Unpack = {
                name = "Unpack",
                tip = "Unpackage this item",
                icon = "icon16/add.png",
                OnRun = function(item)
                    local client = item.player
                    local character = client:GetCharacter()
                    local inventory = character:GetInventory()
                    if (!client) then return false end
                    for item, amount in pairs(data.pack) do
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
                    --client:EmitSound("ambient/fire/mtov_flame2.wav", 75, math.random(160, 180), 0.35)
                    client:EmitSound("npc/zombie/foot_slide" .. math.random(1, 3) .. ".wav", 75, math.random(90, 120), 1)
                end
            }
        end

    end
end

/* -------------------------------- Includes -------------------------------- */
ix.util.Include("sh_fooditems.lua")