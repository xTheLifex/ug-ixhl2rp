--[[
    =====================================
    Life's Filler Items - Item Template
    =====================================

    These are basic, often non-functional items used for roleplay flavor, worldbuilding,
    scene dressing, or lore purposes. They're easy to make and entirely visual/custom.

    After defining your items in a table, pass them to:
        PLUGIN:AddItemTable(items)

    ------------------------
    📦 Item Structure
    ------------------------
    ["unique_id"] = {
        name        = "Item Name",                    -- Display name (default: "Unnamed Item")
        desc        = "A small descriptive blurb.",   -- Description text (fallbacks: desc > description > generic)
        model       = "models/...",                   -- Model path (default: garbage bag)
        models      = {                               -- OPTIONAL: random model selection pool
                        "models/thing1.mdl",
                        "models/thing2.mdl"
                      }
        skin        = 0,                              -- OPTIONAL: Model skin variant (default: 0)
        category    = "Props and Misc",               -- Inventory category (default: "Filler Items")
        width       = 1,                              -- OPTIONAL: Inventory grid width (default: 1)
        height      = 1                               -- OPTIONAL: Inventory grid height (default: 1)
    }

    ------------------------
    🧸 Examples
    ------------------------
    local items = {
        ["lucky_charm"] = {
            name = "Lucky Charm",
            desc = "A small trinket believed to bring good fortune.",
            model = "models/props_lab/jar01a.mdl",
            category = "Trinkets",
            width = 1,
            height = 1
        }

        ["burnt_paper"] = {
            name = "Burnt Note Fragment",
            desc = "The corner of a note. The writing is too charred to read.",
            models = {
                "models/props_junk/garbage_newspaper001a.mdl",
                "models/props_junk/garbage_takeoutcarton001a.mdl"
            }
        }
    }

    PLUGIN:AddItemTable(items)

    ------------------------
    🧠 Notes
    ------------------------
    - This system is meant for simple prop items that don't do anything functional.
    - `models` can be a table for randomization — useful for junk, scraps, paper, etc.
    - No use function is defined, but you can extend this system with your own if needed.
    - Good for background clutter, scavenging RP, and environmental storytelling.
]]

local items = {
    ["ration_token"] = {
        name = "Ration Coupon",
        category = "misc",
        desc = "This token lets you get an extra ration by resetting your ration delay timer.",
        model = "models/bioshockinfinite/hext_coin.mdl",
        OnUse = {
            name = "Use",
            tip = "Get a second ration",
            icon = "icon16/asterisk_yellow.png",
            OnCanRun = function (item, data)
                local client = item.player
                local cid = client:GetCharacter():GetInventory():HasItem("cid")
                return (cid:GetData("nextRationTime", 0) > os.time())
            end,
            OnRun = function (item)
                local client = item.player
                local cid = client:GetCharacter():GetInventory():HasItem("cid")
                cid:SetData("nextRationTime", os.time())
                client:NotifyLocalized("You've used your ration coupon.")
                return true
            end
        }
    }
}
PLUGIN:AddItemTable(items)


