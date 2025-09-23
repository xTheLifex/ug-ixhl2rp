


--[[
    =====================================
    Life's Food Items - Item Definition
    =====================================

    Use this format to define various types of food-related items.
    Once the items are defined in a table, pass them into:
        PLUGIN:AddFoodItemTable(items)

    Supports:
    - Regular food (with optional trash item)
    - Trash items (junk, not usable)
    - Package items (contain multiple items/tokens when unpacked)

    --------------------
    🍔 Item Structure
    --------------------
    ["unique_id"] = {
        name        = "Tasty Food",                   -- Display name (default: "Unknown Food Item")
        desc        = "A tasty food item.",           -- Description (fallback: default food/junk text)
        model       = "models/...",                   -- Model path (default: garbage bag)
        models      = {                               -- OPTIONAL: random model list
                        "models/food1.mdl",
                        "models/food2.mdl"
                      },
        skin        = 0,                              -- OPTIONAL: Model skin (default: 0)
        category    = "Food and Drinks",              -- Category (auto-sets to "Junk"/"Consumable Packages" if trash/package)

        hp          = 15,                             -- OPTIONAL: HP restored when consumed (default: 10)
        trash       = "empty_wrapper",                -- OPTIONAL: Item to spawn after consumption (goes to inventory or spawns)
        istrash     = true,                           -- Marks item as trash (non-usable, changes category/desc)
        pack        = {                               -- Marks item as a package and defines its contents
            ["water_bottle"] = 2,                     -- Item IDs and amounts
            ["token"] = 15                            -- OR use "token"/"tokens" to give money
        }
    }

    -------------------------
    🍽️ Examples
    -------------------------
    local foodItems = {
        ["apple"] = {
            name = "Apple",
            desc = "A juicy red apple.",
            model = "models/props/cs_italy/orange.mdl",
            hp = 10,
            trash = "apple_core"
        },

        ["apple_core"] = {
            name = "Apple Core",
            istrash = true,
            model = "models/props_junk/garbage_takeoutcarton001a.mdl"
        },

        ["ration_pack"] = {
            name = "Civil Ration",
            model = "models/weapons/w_packatc.mdl",
            pack = {
                ["water_bottle"] = 1,
                ["sandwich"] = 1,
                ["token"] = 20
            }
        }
    }

    PLUGIN:AddFoodItemTable(foodItems)

    -------------------------
    🔥 Notes
    -------------------------
    - `istrash` disables item functions and marks the item as junk.
    - `pack` turns the item into a package with an "Unpack" option.
    - If both `istrash` and `pack` are false/nil, the item gets a "Consume" function.
    - After consumption, `trash` item is added or spawned if inventory is full.
    - You can add random model selection via `models = {...}`.
]]