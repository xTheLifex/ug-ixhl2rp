
--[[
    ============================================
    Life's Health Items - Item Table Documentation
    ============================================

    Use this format to define new health-related items for your plugin.
    After defining your items in a table, pass it to PLUGIN:AddItemTable(items)

    --------------------
    🔧 Item Structure
    --------------------
    ["unique_id"] = {
        name        = "Pretty Name",              -- Item display name (default: "Unnamed Health Item")
        desc        = "A short description.",     -- Item description (fallbacks: desc > description > default string)
        model       = "models/...mdl",            -- Model path (default: garbage_bag001a)
        models      = {                           -- OPTIONAL: list of random models
                        "models/foo.mdl",
                        "models/bar.mdl"
                      },
        width       = 1,                          -- Inventory width (default: 1)
        height      = 1,                          -- Inventory height (default: 1)
        skin        = 0,                          -- Model skin (default: 0)
        category    = "Health Items",             -- Category in inventory (default: "Medical Items")

        hp          = 25,                         -- OPTIONAL: Amount to heal (default: 10 if none set and no custom use)
        sound       = "path/to/sound.wav",        -- OPTIONAL: Custom sound on use

        use         = function(item)              -- OPTIONAL: Custom use function. Overrides default heal behavior.
                        local client = item.player
                        client:SetHealth(client:GetMaxHealth())
                    end,

        functions   = {                           -- OPTIONAL: Full custom override of item functions
            ["Use"] = {
                name = "Use",
                tip = "Use this item",
                icon = "icon16/add.png",
                OnRun = function(item)
                    -- Your code here
                end
            }
        }
    }

    -------------------------
    📦 Example Usage
    -------------------------
    local items = {
        ["simple_medkit"] = {
            name = "Basic Medkit",
            desc = "Restores a small amount of health.",
            model = "models/props_junk/garbage_milkcarton002a.mdl",
            hp = 15,
        },

        ["custom_maxheal"] = {
            name = "Advanced Medkit",
            desc = "Fully restores your health.",
            model = "models/props_lab/box01a.mdl",
            use = function(item)
                local client = item.player
                client:SetHealth(client:GetMaxHealth())
            end
        }
    }

    PLUGIN:AddItemTable(items)

    -------------------------
    🔥 Notes
    -------------------------
    - If 'models' is defined (as a table of model strings), a random model will be picked and stored per item instance.
    - If 'use' is defined, it'll override default healing behavior (uses 'hp' value otherwise).
    - If you fully define 'functions', you're on your own — don't define 'hp' or 'use' in that case unless you're using them inside.
]]
    
local items = {
    ["carkit"] = {
        name = "Car First Aid Kit",
        desc = "A fabric pouch secured with a zipper, containing an abundence of sterile dressings, bandages and alcohol wipes",
        model = "models/illusion/eftcontainers/carmedkit.mdl",
        hp = 30
    },
    ["salewa"] = {
        name = "Salewa First Aid Kit",
        desc = "A waterproof rolltop first aid pouch packed with anything you'd need when in the great outdoors, ranging from wound compresses to burn gel.",
        model = "models/illusion/eftcontainers/salewa.mdl",
        hp = 40
    },
    ["ai2"] = {
        name = "AI-2 Individual First Aid Kit",
        desc = "A general purpose single-use medical kit. Handy for treating various injuries - wounds, bruises, regular and chemical burns and various types of poisoning.",
        model = "models/illusion/eftcontainers/ai2.mdl",
        hp = 25
    },
    ["ifak"] = {
        name = "IFAK",
        desc = "A pouch of medical supplies typically carried around by active military personnel. It carries everything you'd ever need.",
        model = "models/illusion/eftcontainers/ifak.mdl",
        hp = 50
    },
    ["bandage"] = {
        name = "Bandage",
        desc = "A loose roll of gauze, it doesn't look like it's been kept in the most sterile of places.",
        model = "models/illusion/eftcontainers/bandage.mdl",
        hp = 10
    },
    ["sterilebandage"] = {
        name = "Sterile Bandage",
        desc = "A finely packed roll of gauze, securely wrapped up.",
        model = "models/illusion/eftcontainers/armybandage.mdl",
        hp = 15
    },
    ["painkillers"] = {
        name = "Paracetamol",
        desc = "A blister pack of paracetamol. It's probably enough to stop a light headache.",
        model = "models/illusion/eftcontainers/painkiller.mdl",
        hp = 15
    },
    ["amphetamines"] = {
        name = "Amphetamines",
        desc = "A white pill bottle filled with ampetamine pills, enough to make you feel wired.",
        model = "models/illusion/eftcontainers/ibuprofen.mdl",
        hp = -5
    },
    ["morphine"] = {
        name = "Morphine",
        desc = "An injector filled with a narcotic analgesic.",
        model = "models/illusion/eftcontainers/morphine.mdl",
        hp = 30
    },
    ["splint"] = {
        name = "Splint",
        desc = "A medical device used to stabilize a broken or fractured bone by holding it in place.",
        model = "models/illusion/eftcontainers/splint.mdl",
        hp = 5
    },
    ["adrenaline"] = {
        name = "Adrenaline",
        desc = "An injector filled with a adrenaline.",
        model = "models/illusion/eftcontainers/morphine.mdl",
        skin = 1,
        hp = 5
    }
}

PLUGIN:AddItemTable(items)
