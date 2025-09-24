local metropolice = {
    ["default"] = {
        name = "Default",
    },
    ["elite"] = {
        name = "Elite",
        desc = "An elite-issue uniform worn by Civil Protection.",
        newSkin = 1
    },
    ["midnight"] = {
        name = "Midnight",
        desc = "A clandestine uniform worn by Civil Protection operatives.",
        newSkin = 2
    },
    ["slate"] = {
        name = "Slate",
        newSkin = 3
    },
    ["helix"] = {
        name = "Helix",
        desc = "A specialist-issue uniform worn by Civil Protection.",
        newSkin = 4
    },
    ["vice"] = {
        name = "Vice",
        newSkin = 5
    },
    ["nomad"] = {
        name = "Nomad",
        desc = "An elite-issue uniform worn by Civil Protection.",
        newSkin = 6
    },
    ["hua"] = {
        name = "HUA",
        desc = "A flashproof uniform worn by Civil Protection that serves as the base of 'Heavy Unit Armour'.",
        newSkin = 7,
        armor = 50
    },
    ["sword"] = {
        name = "Sword",
        desc = "An elite-issue uniform worn by Civil Protection.",
        newSkin = 8
    },
    ["urban"] = {
        name = "Urban",
        newSkin = 9
    },
    ["outland"] = {
        name = "Outland",
        desc = "An outland-patrol uniform worn by Civil Protection.",
        newSkin = 10,
    },
    ["retro"] = {
        name = "Expired",
        desc = "An outdated uniform that used to be worn by Civil Protection.",
        newSkin = 11,
    },
    ["industrial"] = {
        name = "Industrial",
        desc = "A standard-issue uniform worn by Civil Protection with a vaudeville theme.",
        newSkin = 12
    },
    ["rogue"] = {
        name = "Rogue",
        desc = "A vandalized Civil Protection uniform in Resistance colours.",
        newSkin = 13
    },
}

local metropoliceFinal = {}

for id, data in pairs(metropolice) do
    -- create the subtable for this uniform
    local uniformData = {}
    
    -- copy all extra fields dynamically
    for k, v in pairs(data) do
        uniformData[k] = v
    end

    -- inject defaults/overrides
    uniformData["replacements"] = "models/ug/police_custom.mdl"
    uniformData["name"] = "Civil Protection Uniform - " .. data.name
    uniformData["desc"] = data.desc or "A standard-issue uniform worn by Civil Protection."
    uniformData["base"] = data.base or "base_armor_clothes"
    uniformData["maxArmor"] = data.armor or data.maxArmor or 35
    uniformData["price"] = data.price or 120
    
    -- assign into final table
    metropoliceFinal["metropolice_uniform_" .. id] = uniformData
end

PLUGIN:AddClothingItems(metropoliceFinal)
