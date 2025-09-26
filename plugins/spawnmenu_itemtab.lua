PLUGIN.name = "Spawn Menu: Items"
PLUGIN.author = "Rune Knight, TheLife"
PLUGIN.description = "Adds a tab to the spawn menu which players can use to spawn items."
PLUGIN.license = [[Copyright 2021 Rune Knight

This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/ or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.]]

--[[
	STEAM: https://steamcommunity.com/profiles/76561198028996329/
	DISCORD: Rune Knight#5972
]]
CAMI.RegisterPrivilege({
    Name = "Spawn Menu: Items - Spawning",
    MinAccess = "superadmin"
})

function PLUGIN:GetExpectedIcon(s)
    local i = {
        ["Ammunition"] = "icon16/tab.png", -- :shrug:
        ["Clothing"] = "icon16/user_suit.png",
        ["Outfit"] = "icon16/user_suit.png",
        ["Consumables"] = "icon16/pill.png",
        ["Medical"] = "icon16/heart.png",
        ["misc"] = "icon16/error.png",
        ["Permits"] = "icon16/note.png",
        ["Storage"] = "icon16/package.png",
        ["Weapons"] = "icon16/gun.png",
        ["Consumable Packages"] = "icon16/box.png",
        ["Food and Drinks"] = "icon16/cake.png",
        ["Junk"] = "icon16/bin.png",
        ["Attachments"] = "icon16/gun.png",
        ["Armor & Vests"] = "icon16/shield.png",
        ["Tools"] = "icon16/wrench.png"
    }

    return hook.Run("GetIconsForSpawnMenuItems", s) or i[s] or "icon16/folder.png"
end

if SERVER then
    util.AddNetworkString("spawnmenuspawnitem")
    util.AddNetworkString("spawnmenugiveitem")
    ix.log.AddType("spawnmenuspawnitem", function(client, name) return string.format("%s has spawned \"%s\".", client:GetCharacter():GetName(), tostring(name)) end)

    net.Receive("spawnmenuspawnitem", function(len, client)
        local u = net.ReadString()
        if not CAMI.PlayerHasAccess(client, "Spawn Menu: Items - Spawning", nil) then return end

        for _, t in pairs(ix.item.list) do
            if t.uniqueID == u then
                ix.item.Spawn(t.uniqueID, client:GetShootPos() + client:GetAimVector() * 84 + Vector(0, 0, 16))
                ix.log.Add(client, "spawnmenuspawnitem", t.name)
                break
            end
        end
    end)

    net.Receive("spawnmenugiveitem", function(len, client)
        local u = net.ReadString()
        if not CAMI.PlayerHasAccess(client, "Spawn Menu: Items - Spawning", nil) then return end

        for _, t in pairs(ix.item.list) do
            if t.uniqueID == u then
                client:GetCharacter():GetInventory():Add(t.uniqueID)
                ix.log.Add(client, "spawnmenuspawnitem", t.name)
                client:Notify("You have given yourself a " .. t.name .. ". Check your inventory.")
                break
            end
        end
    end)
else
    function PLUGIN:InitializedPlugins()
        if SERVER then return end
        RunConsoleCommand("spawnmenu_reload") -- If someone legit knows how to insert stuff into the spawn menu without breaking it or doing it before the spawn menu is created, please tell me. Otherwise, this is the best I got.
    end

    local PLUGIN = PLUGIN

    spawnmenu.AddCreationTab("Items", function()
        local p = vgui.Create("SpawnmenuContentPanel")
        local navBar = p.ContentNavBar
        local tree = navBar.Tree
        local itemListByCategory = {}
    
        for _, item in pairs(ix.item.list) do
            local cat = item.category or "Misc"
            itemListByCategory[cat] = itemListByCategory[cat] or {}
            table.insert(itemListByCategory[cat], item)
        end
    
        -- Create a panel wrapper to force the search bar to the top of the navBar
        local wrapper = vgui.Create("DPanel", navBar)
        wrapper:SetTall(24)
        wrapper:Dock(TOP)
        wrapper:DockMargin(0, 0, 0, 5)
        wrapper.Paint = nil
    
        local searchBox = vgui.Create("DTextEntry", wrapper)
        searchBox:Dock(FILL)
        searchBox:SetPlaceholderText("Search all items...")
        searchBox:SetUpdateOnType(true)
    
        local function BuildCategoryNodes()
            tree:Clear(true)
    
            for category, items in SortedPairs(itemListByCategory) do
                local icon16 = PLUGIN:GetExpectedIcon(category)
                local node = tree:AddNode(L(category), icon16)
    
                node.DoClick = function(self)
                    if self.PropPanel and IsValid(self.PropPanel) then
                        self.PropPanel:Remove()
                    end
    
                    self.PropPanel = vgui.Create("ContentContainer", p)
                    self.PropPanel:SetVisible(false)
                    self.PropPanel:SetTriggerSpawnlistChange(false)
    
                    for _, item in SortedPairsByMemberValue(items, "name") do
                        spawnmenu.CreateContentIcon("item", self.PropPanel, {
                            nicename = (item.GetName and item:GetName()) or item.name,
                            spawnname = item.uniqueID,
                            skin = item.skin,
                        })
                    end
    
                    p:SwitchPanel(self.PropPanel)
                end
            end
    
            local first = tree:Root():GetChildNode(0)
            if IsValid(first) then
                first:InternalDoClick()
            end
        end
    
        local function RefreshSearchResults(query)
            tree:Clear(true)
    
            local searchNode = tree:AddNode("Search Results", "icon16/magnifier.png")
    
            searchNode.DoClick = function(self)
                if self.PropPanel and IsValid(self.PropPanel) then
                    self.PropPanel:Remove()
                end
    
                self.PropPanel = vgui.Create("ContentContainer", p)
                self.PropPanel:SetVisible(false)
                self.PropPanel:SetTriggerSpawnlistChange(false)
    
                for _, item in SortedPairsByMemberValue(ix.item.list, "name") do
                    local name = (item.GetName and item:GetName()) or item.name
                    if string.find(string.lower(name), string.lower(query), 1, true) then
                        spawnmenu.CreateContentIcon("item", self.PropPanel, {
                            nicename = name,
                            spawnname = item.uniqueID,
                            skin = item.skin
                        })
                    end
                end
    
                p:SwitchPanel(self.PropPanel)
            end
    
            searchNode:InternalDoClick()
        end
    
        searchBox.OnValueChange = function(self, val)
            val = val or self:GetValue()
            if #val >= 2 then
                RefreshSearchResults(val)
            else
                BuildCategoryNodes()
            end
        end
    
        -- Build initial categories
        BuildCategoryNodes()
    
        return p
    end, "icon16/cog_add.png", 201)    

    spawnmenu.AddContentType("item", function(p, data)
        local n = data.nicename
        local u = data.spawnname
        local s = data.skin or 0
        local icon = vgui.Create("SpawnIcon", p)
        icon:SetWide(64)
        icon:SetTall(64)
        icon:InvalidateLayout(true)
        local t = ix.item.list
        local i = t[u]
        icon:SetModel((i.GetModel and i:GetModel()) or i.model, s)
        icon:SetTooltip(n)

        icon.OnMousePressed = function(this, code)
            surface.PlaySound("ui/buttonclickrelease.wav")
            if not CAMI.PlayerHasAccess(LocalPlayer(), "Spawn Menu: Items - Spawning", nil) then return end

            if code == MOUSE_LEFT then
                net.Start("spawnmenuspawnitem")
                net.WriteString(u)
                net.SendToServer()
            elseif code == MOUSE_RIGHT then
                net.Start("spawnmenugiveitem")
                net.WriteString(u)
                net.SendToServer()
            end
        end

        icon:InvalidateLayout(true)

        if IsValid(p) then
            p:Add(icon)
        end

        return icon
    end)
end