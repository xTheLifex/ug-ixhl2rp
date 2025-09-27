local items = {
    ["ai2"] = {
        name = "AI-2 Individual First Aid Kit",
        desc = "A general purpose single-use medical kit. Handy for treating various injuries - wounds, bruises, regular and chemical burns and various types of poisoning.",
        model = "models/ug_imports/l4d2/medkit.mdl",
        hp = 25
    },
    ["bandage"] = {
        name = "Bandage",
        desc = "A loose roll of gauze, it doesn't look like it's been kept in the most sterile of places.",
        model = "models/props_wasteland/prison_toiletchunk01f.mdl",
        hp = 10
    },
    ["sterilebandage"] = {
        name = "Sterile Bandage",
        desc = "A finely packed roll of gauze, securely wrapped up.",
        model = "models/props_wasteland/prison_toiletchunk01f.mdl",
        hp = 15
    },
    ["painkillers"] = {
        name = "Paracetamol",
        desc = "A blister pack of paracetamol. It's probably enough to stop a light headache.",
        model = "models/ug_imports/l4d2/painpills.mdl",
        hp = 15
    },
    ["amphetamines"] = {
        name = "Amphetamines",
        desc = "A white pill bottle filled with ampetamine pills, enough to make you feel wired.",
        model = "models/ug_imports/l4d2/painpills.mdl",
        hp = -5
    },
    ["morphine"] = {
        name = "Morphine",
        desc = "An injector filled with a narcotic analgesic.",
        model = "models/ug_imports/l4d2/adrenaline.mdl",
        hp = 30
    },
    ["adrenaline"] = {
        name = "Adrenaline",
        desc = "An injector filled with a adrenaline.",
        model = "models/ug_imports/l4d2/adrenaline.mdl",
        skin = 1,
        hp = 5
    }
}

PLUGIN:AddItemTable(items)
