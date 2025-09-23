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
    ["control_box"] = {
        name = "Control Box",
        desc = "A decent-sized Control box. It is primarily used to regulate electricity flow in electrical components and connect them together.",
        model = "models/illusion/eftcontainers/controller.mdl",
        width = 3,
        height = 2,
        skin = 1,
    },


    ["bleach"] = {
        name = "Bleach",
        desc = "A bottle of bleach. It is used in general cleaning and removing color from fabrics.",
        model = "models/illusion/eftcontainers/bleach.mdl",
        width = 1,
        height = 2,
        skin = 1,
    },


    ["car_battery"] = {
        name = "Car Battery",
        desc = "A large rechargable car battery, seemingly ripped from an old car. It can reach up to 14.5 volts and can be connected to devices using wires.",
        model = "models/illusion/eftcontainers/carbattery.mdl",
        width = 2,
        height = 2,
        skin = 1,
    },


    ["circuit_board"] = {
        name = "Circuit Board",
        desc = "A printed circuit board which can be used in crafting devices, or connected to electronics.",
        model = "models/illusion/eftcontainers/circuitboard.mdl",
        width = 1,
        height = 1,
        skin = 1,
    },


    ["duct_tape"] = {
        name = "Duct Tape",
        desc = "A roll of white duct tape, can be used to tape things together.",
        model = "models/illusion/eftcontainers/ducttape.mdl",
        width = 1,
        height = 1,
        skin = 1,
    },


    ["electric_drill"] = {
        name = "Electric Drill",
        desc = "A power drill with a battery on the bottom of the handle. The battery can be recharged and the drill can be used for installing or removing screws.",
        model = "models/illusion/eftcontainers/electricdrill.mdl",
        category = "Tools",
        width = 2,
        height = 2,
        skin = 1,
    },


    ["engine"] = {
        name = "Engine",
        desc = "A small engine which can be used to power up devices and tools if there is a power source connected.",
        model = "models/illusion/eftcontainers/engine.mdl",
        category = "Tools",
        width = 3,
        height = 2,
        skin = 1,
    },


    ["flash_storage"] = {
        name = "Flash Storage Drive",
        desc = "A portable flash drive which can be used to store files and data from a computer.",
        model = "models/illusion/eftcontainers/flashstorage.mdl",
        category = "Tools",
        width = 1,
        height = 1,
        skin = 1,
    },


    ["gas_analyzer"] = {
        name = "Gas Analyzer",
        desc = "A small radio device which can detect toxic gases in the environment.",
        model = "models/illusion/eftcontainers/gasanalyser.mdl",
        category = "Tools",
        width = 1,
        height = 1,
        skin = 1,
    },

    ["gas_can"] = {
        name = "Gas Canister",
        desc = "A canister which can be filled with fuel and distributed to other industrial",
        model = "models/illusion/eftcontainers/gasoline.mdl",
        width = 2,
        height = 3,
        skin = 1,
    },

    ["geiger_counter"] = {
        name = "Geiger Counter",
        desc = "A device which detects radiation levels in the surrounding environment.",
        model = "models/illusion/eftcontainers/geigercounter.mdl",
        category = "Tools",
        width = 1,
        height = 1,
        skin = 1,
    },


    ["gold_chain"] = {
        name = "Gold Chain",
        desc = "A lengthy gold chain which can be worn around the wrist or the neck, it seems relatively clean.",
        model = "models/illusion/eftcontainers/goldchain.mdl",
        width = 1,
        height = 1,
        skin = 1,
    },


    ["graphics_card"] = {
        name = "Graphics Card",
        desc = "A graphics card extracted from a computer.",
        model = "models/illusion/eftcontainers/graphicscard.mdl",
        width = 1,
        height = 1,
        skin = 1,
    },


    ["water_hose"] = {
        name = "Water Hose",
        desc = "A flexible hollow tube which can be used to transfer liquids from one point to the other.",
        model = "models/illusion/eftcontainers/hose.mdl",
        width = 2,
        height = 1,
        skin = 1,
    },


    ["magnet"] = {
        name = "Magnet",
        desc = "A small piece of magnet that can be used in crafting electronic or magnetic devices.",
        model = "models/illusion/eftcontainers/magnet.mdl",
        width = 1,
        height = 1,
        skin = 1,
    },


    ["military_battery"] = {
        name = "Military-Grade Battery",
        desc = "A large Military-Grade battery which can be used to connect to electronic devices and fry them.",
        model = "models/illusion/eftcontainers/militarybattery.mdl",
        width = 3,
        height = 2,
        skin = 1,
    },


    ["military_board"] = {
        name = "Military-Grade Circuit Board",
        desc = "A large Military-Grade circuit board which can be used to connect to electronic devices and fry them.",
        model = "models/illusion/eftcontainers/militaryboard.mdl",
        width = 2,
        height = 1,
        skin = 1,
    },


    ["military_wires"] = {
        name = "Bundle of Wires",
        desc = "A large bundle of wires that can be used to connect devices together.",
        model = "models/illusion/eftcontainers/militarycable.mdl",
        width = 2,
        height = 1,
        skin = 1,
    },


    ["bundle_nuts"] = {
        name = "Bundle of Nuts",
        desc = "A small bundle of nuts that can be used in a large variety of ways.",
        model = "models/illusion/eftcontainers/nuts.mdl",
        width = 1,
        height = 1,
        skin = 1,
    },


    ["pliers"] = {
        name = "Pliers",
        desc = "A handy tool that can be used to cut wires and similar items, or hold them tightly.",
        model = "models/illusion/eftcontainers/pliers.mdl",
        category = "Tools",
        width = 1,
        height = 1,
        skin = 1,
    },


    ["power_cord"] = {
        name = "Power Cord",
        desc = "A power cord which can be used to connect a device to a power socket.",
        model = "models/illusion/eftcontainers/powercord.mdl",
        width = 1,
        height = 1,
        skin = 1,
    },


    ["power_supply_unit"] = {
        name = "Power Supply Unit",
        desc = "A power supply unit salvaged from a computer.",
        model = "models/illusion/eftcontainers/powersupplyunit.mdl",
        width = 1,
        height = 1,
        skin = 1,
    },


    ["gold_watch"] = {
        name = "Gold Watch",
        desc = "A gold watch which seems to be in good condition all things considered, the arms on the clock.",
        model = "models/illusion/eftcontainers/rolex.mdl",
        width = 1,
        height = 1,
        skin = 1,
    },


    ["screwdriver"] = {
        name = "Screwdriver",
        desc = "A screwdriver which can be used to remove or install screws. Could also be used to pry into devices and similar objects.",
        model = "models/illusion/eftcontainers/screwdriver.mdl",
        category = "Tools",
        width = 1,
        height = 1,
        skin = 1,
    },


    ["toolset"] = {
        name = "Set of Tools",
        desc = "A batch of tools that can be used in a large variety of situations.",
        model = "models/illusion/eftcontainers/toolset.mdl",
        category = "Tools",
        width = 2,
        height = 2,
        skin = 1,
    },

    ["rope"] = {
        name = "Rope",
        desc = "A folded rope which can be used to tie to objects.",
        model = "models/lostsignalproject/items/misc/rope.mdl",
        width = 1,
        height = 1,
        skin = 1,
    },

    ["propane"] = {
        name = "Propane Cannister",
        desc = "A propane cannister, partially filled with gas.",
        model = "models/illusion/eftcontainers/propanetank.mdl",
        width = 2,
        height = 2,
        skin = 1,
    },

    ["wirelesstransmitter"] = {
        name = "Wireless Transmitter",
        desc = "A small metallic device typically used to transmit signals wirelessly. It lacks the power to work. You can probably find something to do with this",
        model = "models/illusion/eftcontainers/wirelesstransmitter.mdl",
        width = 1,
        height = 1,
        skin = 1,
    },

    ["medscrap"] = {
        name = "Medical Scraps",
        desc = "A small mound of different medical supplies, It could fix you up in a pinch, or you could put it to better use",
        model = "models/illusion/eftcontainers/medpile.mdl",
        width = 1,
        height = 1,
        skin = 1,
    },

    ["gpblue"] = {
        name = "Blue Gunpowder",
        desc = "A bottle of blue gunpowder, typically used in the creation of medium calibre ammunition",
        model = "models/illusion/eftcontainers/gpblue.mdl",
        width = 1,
        height = 2,
        skin = 1,
    },

    ["gpred"] = {
        name = "Red Gunpowder",
        desc = "A bottle of red gunpowder, typically used in the creation of high calibre ammunition",
        model = "models/illusion/eftcontainers/gpred.mdl",
        width = 1,
        height = 2,
        skin = 1,
    },

    ["gpgreen"] = {
        name = "Green Gunpowder",
        desc = "A bottle of green gunpowder, typically used in the creation of small calibre ammunition",
        model = "models/illusion/eftcontainers/gpgreen.mdl",
        width = 1,
        height = 2,
        skin = 1,
    },

    ["dryfuel"] = {
        name = "Dry Fuel",
        desc = "Several pucks of compacted and combustible material. Typical used to start fires in the absence of decent fuel",
        model = "models/illusion/eftcontainers/dryfuel.mdl",
        width = 1,
        height = 1,
        skin = 1,
    },

    ["goldring"] = {
        name = "Skull Ring",
        desc = "A gold ring, modeled to look like a skull. It'd probably fetch a high price with the right people",
        model = "models/illusion/eftcontainers/skullring.mdl",
        width = 1,
        height = 1,
        skin = 1,
    },
	
    ["goldchain"] = {
        name = "Gold Chain",
        desc = "A gold chain. Typically used to display wealth in a rather egregious manner. It'd probably fetch a high price with the right people",
        model = "models/illusion/eftcontainers/goldchain.mdl",
        width = 1,
        height = 1,
        skin = 1,
    },

    ["matches"] = {
        name = "Matches",
        desc = "A small box of safety matches.",
        model = "models/illusion/eftcontainers/matches.mdl",
        width = 1,
        height = 1,
        skin = 1,
    },

    ["armor_kit"] = {
        name = "Armor Repair Kit",
        desc = "A box containing kevlar plates to replenish vests.",
        model = "models/lostsignalproject/items/repair/exo_repair_kit.mdl",
        category = "Tools",
        width = 2,
        height = 2,
        skin = 1,
        OnUse = {
            name = "Use",
            tip = "Replenishes your armor",
            icon = "icon16/add.png",
            OnRun = function(item)
                local client = item.player
                if not IsValid(client) then return false end

                local character = client:GetCharacter()
                if not character then return false end

                local inventory = character:GetInventory()

                for _, item in pairs(inventory:GetItems()) do
                    if item:GetData("equip", false) and item.outfitCategory == "armor" then
                        -- Armor item found
                        item:SetData("durability", item.maxArmor or 5)
                        client:SetArmor(item.maxArmor)
                        client:NotifyLocalized("Your armor has been repaired.")
                        return true
                    end
                end

                client:NotifyLocalized("You have no armor to repair!")
                return false
            end
        }
    },

    ["ration_token"] = {
        name = "Ration Coupon",
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
