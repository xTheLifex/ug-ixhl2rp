local rations = {
    ["package_bioticration"] = {
        name = "Biotic Ration",
        desc = "A vaccum sealed, biotic-grade package bearing a Combine insignia.",
        pack = { 
            ["tokens"] = 4,
        },
        skin = 5
    },
    ["package_loyalistration"] = {
        name = "Loyalist Ration",
        desc = "A vaccum sealed, loayalist-grade package bearing a Combine insignia.",
        pack = { 
            ["tokens"] = 40,
        },
        skin = 2
    },
    ["package_civilprotectionration"] = {
        name = "Combine Ration",
        desc = "A vaccum sealed, Combine-grade package bearing a Combine insignia.",
        pack = { 
            ["tokens"] = 80,
        },
        skin = 4
    },
    ["package_priorityration"] = {
        name = "Priority Ration",
        desc = "A vaccum sealed, priority-grade package bearing a Combine insignia.",
        pack = { 
            ["tokens"] = 60,
        },
        skin = 3
    },
    ["package_standardration"] = {
        name = "Standard Ration",
        desc = "A vaccum sealed, regulation-grade package bearing a Combine insignia.",
        pack = { 
            ["tokens"] = 20,
        }
    },
    ["package_minimalration"] = {
        name = "Minimal Ration",
        desc = "A vaccum sealed, package bearing a Combine insignia.",
        pack = { 
            ["tokens"] = 10,
        },
        skin = 1,
    },
}

for id, data in pairs(rations) do
    data["model"] = "models/ug_imports/uubranded/ration.mdl"
end

PLUGIN:AddFoodItemTable(rations)