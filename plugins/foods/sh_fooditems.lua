


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


local items = {
    ["food_apple"] = {
        name = "Apple",
        desc = "A fresh, juicy apple.",
        models = {"models/foodnhouseholditems/apple.mdl", "models/foodnhouseholditems/apple.mdl", "models/foodnhouseholditems/apple2.mdl"}
    },
    ["food_bagel"] = {
        name = "Bagel",
        desc = "A dense, chewy ring of bread with a golden crust.",
        models = {"models/foodnhouseholditems/bagel1.mdl", "models/foodnhouseholditems/bagel2.mdl", "models/foodnhouseholditems/bagel3.mdl"}
    },
    ["food_burger"] = {
        name = "Burger",
        desc = "A juicy, grilled beef patty tucked between two toasted buns with cheese, lettuce, tomato, and a splash of sauce.",
        models = {"models/foodnhouseholditems/burgergtaiv.mdl", "models/foodnhouseholditems/burgergtasa.mdl", "models/foodnhouseholditems/burgersims2.mdl"}
    },
    ["food_cabbage"] = {
        name = "Cabbage",
        desc = "A round, leafy green vegetable. ",
        models = {"models/foodnhouseholditems/cabbage1.mdl", "models/foodnhouseholditems/cabbage2.mdl", "models/foodnhouseholditems/cabbage3.mdl"}
    },
    ["food_grape"] = {
        name = "Grapes",
        desc = "A small bunch of plump, juicy grapes, bursting with sweetness.",
        models = {"models/foodnhouseholditems/grapes1.mdl", "models/foodnhouseholditems/grapes2.mdl", "models/foodnhouseholditems/grapes3.mdl"}
    },
    ["food_bread"] = {
        name = "Bread Loaf",
        desc = "A hearty loaf of freshly baked bread. Golden crust on the outside, soft and warm on the inside. ",
        models = {"models/foodnhouseholditems/bread-1.mdl", "models/foodnhouseholditems/bread-2.mdl", "models/foodnhouseholditems/bread-3.mdl","models/foodnhouseholditems/bread_loaf.mdl"}
    },
    ["food_bagette"] = {
        name = "Bagette",
        desc = "A long, crusty loaf of French bread with a soft, airy interior.",
        model = "models/foodnhouseholditems/bagette.mdl"
    },
    ["food_watermelon"] = {
        name = "Watermelon",
        desc = "A large, juicy slice of watermelon with vibrant pink flesh and a crisp green rind. ",
        model = "models/foodnhouseholditems/watermelon_unbreakable.mdl"
    },
    ["food_chickenwrap"] = {
        name = "Chicken Wrap",
        desc = "A warm tortilla wrapped around seasoned grilled chicken, crisp lettuce, tangy sauce, and maybe a surprise tomato or two. Portable, filling, and dangerously delicious.",
        model = "models/foodnhouseholditems/chicken_wrap.mdl"
    },
    ["food_chili"] = {
        name = "Chili",
        desc = "A fiery, vibrant chili pepper, often used to add heat and spice to a variety of dishes.",
        model = "models/foodnhouseholditems/chili.mdl"
    },
    ["food_carrot"] = {
        name = "Carrot",
        desc = "A crunchy, orange root vegetable packed with vitamins and a natural sweetness.",
        model = "models/foodnhouseholditems/carrot.mdl"
    },
    ["food_leek"] = {
        name = "Leek",
        desc = "A long, slender vegetable with a mild, onion-like flavor.",
        model = "models/foodnhouseholditems/leek.mdl"
    },
    ["food_gourd"] = {
        name = "Gourd",
        desc = "A round, firm, and often brightly colored vegetable with a tough skin.",
        model = "models/foodnhouseholditems/gourd.mdl"
    },
    ["food_hotdog"] = {
        name = "Hot Dog",
        desc = "A classic street food: a juicy sausage tucked inside a soft, warm bun.",
        model = "models/foodnhouseholditems/hotdog.mdl"
    },
    ["food_potato"] = {
        name = "Potato",
        desc = "A small, dirt-flecked tuber, slightly shriveled but edible.",
        model = "models/foodnhouseholditems/potato.mdl"
    },
    ["food_cheezeit"] = {
        name = "Cheeze Its",
        desc = "A crinkled, faded bag of Cheez-Its, its iconic orange color dulled by time. The crackers inside have long since lost their crunch, turning into a stale, hardened snack that only the bravest would dare to consume. The faint scent of artificial cheese lingers, but it's mostly a reminder of how far this snack has come.",
        model = "models/foodnhouseholditems/chipscheezit.mdl"
    },
    ["food_doritos"] = {
        name = "Doritos",
        desc = "A faded and crinkled bag of Doritos, its once vibrant orange packaging now barely legible. The chips inside have long since lost their signature crunch, turning into stale, flat triangles of mystery. Despite the years, a faint whiff of cheesy goodness remains, though its now more nostalgic than appetizing.",
        model = "models/foodnhouseholditems/chipsdoritos2.mdl"
    },
    ["food_fritos"] = {
        name = "Fritos",
        desc = "A wrinkled, nearly unrecognizable bag of Fritos, its once-golden color faded and the bag now crinkled with age. The chips inside have lost their signature crunch, now reduced to stale, oily remnants of their former self.",
        model = "models/foodnhouseholditems/chipsfritos.mdl"
    },
    ["food_lays"] = {
        name = "Lays",
        desc = "A crinkled and faded bag of Lays potato chips, its classic yellow packaging barely legible after two decades. The chips inside are now stale and brittle, their crisp texture replaced by a soggy, crumbly version of their former selves. A faint scent of salty potatoes remains, but its mostly overtaken by the musty odor of time.",
        model = "models/foodnhouseholditems/chipslays.mdl"
    },
    ["food_pumpkin"] = {
        name = "Pumpkin",
        desc = "A large, orange squash with a thick, sweet flesh.",
        model = "models/foodnhouseholditems/pumpkin01.mdl"
    },
    ["food_pretzel"] = {
        name = "Pretzel",
        desc = "A warm, salty snack with a crispy exterior and a soft, chewy interior.",
        model = "models/foodnhouseholditems/pretzel.mdl"
    },
    ["food_pizza"] = {
        name = "Pizza",
        desc = "A single, delicious slice of pizza with gooey melted cheese, a crispy crust, and a perfect balance of sauce and toppings.",
        model = "models/foodnhouseholditems/pizzaslice.mdl"
    },
    ["food_sweetroll"] = {
        name = "Sweet Roll",
        desc = "A soft, warm, and cinnamon-sweetened pastry.",
        model = "models/foodnhouseholditems/sweetroll.mdl"
    },
    ["food_pancake"] = {
        name = "Pancakes",
        desc = "A stack of fluffy, golden pancakes, lightly crisped on the edges, drenched in syrup and topped with butter.",
        model = "models/foodnhouseholditems/pancakes.mdl"
    },
    ["food_egg"] = {
        name = "Egg",
        desc = "A fresh, shell-protected egg, packed with protein and versatility.",
        models = {"models/foodnhouseholditems/egg1.mdl", "models/foodnhouseholditems/egg2.mdl"}
    },
    ["food_cheesewheel"] = {
        name = "Cheese Wheel",
        desc = "A large, round wheel of rich, aged cheese, its firm outer rind hiding a creamy, flavorful interior.",
        models = {"models/foodnhouseholditems/cheesewheel1a.mdl", "models/foodnhouseholditems/cheesewheel2a.mdl"}
    },
    ["food_eggplant"] = {
        name = "Eggplant",
        desc = "A glossy, deep purple vegetable with a tender flesh and slightly bitter taste.",
        model = "models/foodnhouseholditems/eggplant.mdl"
    },
    ["food_tomato"] = {
        name = "Tomato",
        desc = "A ripe, juicy tomato, bursting with flavor and rich in vitamins.",
        model = "models/foodnhouseholditems/tomato.mdl"
    },
    ["food_corn"] = {
        name = "Corn",
        desc = "A golden cob of corn, fresh and full of kernels.",
        model = "models/foodnhouseholditems/corn.mdl"
    },
    ["food_croissant"] = {
        name = "Croissant",
        desc = "A buttery, flaky French pastry thats golden on the outside and soft on the inside. Perfect with a cup of coffee, or just on its own for a moment of indulgence.",
        model = "models/foodnhouseholditems/croissant.mdl"
    },
    ["food_coconut"] = {
        name = "Coconut",
        desc = "A hard-shelled tropical fruit filled with refreshing coconut water and creamy white flesh.",
        model = "models/foodnhouseholditems/coconut.mdl"
    },
    ["food_pear"] = {
        name = "Pear",
        desc = "A juicy, sweet fruit with a smooth texture and delicate flavor.",
        model = "models/foodnhouseholditems/pear.mdl"
    },
    ["food_picklejar"] = {
        name = "Jar of Pickles",
        desc = "A jar filled with tangy, briny pickles, crisp cucumbers soaked in vinegar, spices, and a touch of mystery.",
        model = "models/foodnhouseholditems/picklejar.mdl"
    },
    ["food_pineapple"] = {
        name = "Pineapple",
        desc = "A tropical fruit with a spiky outer rind and a sweet, tangy interior.",
        model = "models/foodnhouseholditems/pineapple.mdl"
    },
    ["food_applepie"] = {
        name = "Apple Pie",
        desc = "A warm, flaky pastry filled with cinnamon-spiced apples, baked to golden perfection.",
        model = "models/foodnhouseholditems/pie.mdl"
    },
    ["food_chocolatine"] = {
        name = "Chocolatine",
        desc = "A delicious, flaky pastry filled with rich, melty chocolate.",
        model = "models/foodnhouseholditems/chocolatine.mdl"
    },
    ["food_orange"] = {
        name = "Orange",
        desc = "A bright, juicy fruit with a vibrant, tangy flavor and a refreshing burst of citrus in every bite.",
        model = "models/foodnhouseholditems/orange.mdl"
    },
    ["food_cookies"] = {
        name = "Cookies",
        desc = "A sealed package of soft, sweet cookies, each bite a comforting blend of sugar and vanilla. ",
        model = "models/foodnhouseholditems/cookies.mdl"
    },
    ["food_bellpepper"] = {
        name = "Bell Pepper",
        desc = "A crisp, sweet pepper with a bright, vibrant color.",
        models = {"models/foodnhouseholditems/pepper1.mdl", "models/foodnhouseholditems/pepper2.mdl", "models/foodnhouseholditems/pepper3.mdl"}
    },
    ["food_donut"] = {
        name = "Donut",
        desc = "A deep-fried dough pastry, glazed with sugar and topped with a variety of sweet toppings.",
        model = "models/foodnhouseholditems/donut.mdl"
    },
    ["food_banana"] = {
        name = "Banana",
        desc = "A single ripe banana with a smooth yellow peel and sweet, soft flesh.",
        model = "models/foodnhouseholditems/bananna.mdl"
    },
    ["food_cake_slice"] = {
        name = "Slice of Cake",
        desc = "A sweet, fluffy slice of cake layered with frosting.",
        model = "models/foodnhouseholditems/cake1a.mdl"
    }, 
    --[[["food_fries"] = {
        name = "French Fries",
        desc = "Food Example",
        model = "models/foodnhouseholditems/mcdfrenchfries.mdl",
        trash = "food_fries_empty"
    },
    ["food_fries_empty"] = {
        name = "Empty Fries Package",
        desc = "Trash Example",
        model = "models/foodnhouseholditems/mcdfrenchfriesempty.mdl",
        istrash = true 
    },]]
    ["drink_coke"] = {
        name = "Coke",
        desc = "A dusty, dented can of Coca-Cola, long past its prime. The label is faded, the contents questionable, and the carbonation likely a distant memory. Best approached with curiosity,and caution.",
        model = "models/foodnhouseholditems/sodacan01.mdl",
        trash = "drink_coke_empty"
    },
    ["drink_coke_empty"] = {
        name = "Empty Coke",
        desc = "A classic can of Coca-Cola, now empty and a little battered. The red label is faded, but it still carries the faint scent of cola and carbonation, though the fizz has long since gone.",
        model = "models/foodnhouseholditems/sodacan01.mdl",
        istrash = true
    },
    ["drink_coke_cherry"] = {
        name = "Cherry Coke",
        desc = "A faded relic of sugary history. This Cherry Coke has been sitting untouched for two decades. The once-vibrant red label is dulled and dusty, and whatevers sloshing around inside probably shouldnt be carbonated or consumed.",
        model = "models/foodnhouseholditems/sodacan02.mdl",
        trash = "drink_coke_cherry_empty"
    },
    ["drink_coke_cherry_empty"] = {
        name = "Empty Cherry Coke",
        desc = "A once-fizzy can of Cherry Coke, now hollow and slightly crushed. The iconic red label has faded, but the faint scent of cherry cola still clings to its walls.",
        model = "models/foodnhouseholditems/sodacan02.mdl",
        istrash = true
    },
    ["drink_coke_life"] = {
        name = "Coke Life",
        desc = "A dusty, green-labeled can of Coke Life, the short-lived stevia-sweetened variant of the classic cola. After 20 years in storage, its contents are more science experiment than soft drink.",
        model = "models/foodnhouseholditems/sodacan03.mdl",
        trash = "drink_coke_life_empty"
    },
    ["drink_coke_life_empty"] = {
        name = "Empty Coke Life",
        desc = "A rare green can from Cokes brief flirtation with stevia and good intentions. Now its just an empty, slightly dented piece of beverage history.",
        model = "models/foodnhouseholditems/sodacan03.mdl",
        istrash = true
    },
    ["drink_pepsi"] = {
        name = "Pepsi",
        desc = "The can is faded and slightly swollen. Probably from the ancient syrup fermenting inside. Smells like flat cola and bad decisions.",
        model = "models/foodnhouseholditems/sodacan04.mdl",
        trash = "drink_pepsi_empty"
    },
    ["drink_pepsi_empty"] = {
        name = "Empty Pepsi",
        desc = "A once-bubbly cola container, now just an empty aluminum husk. The labels faded, and there's a sticky ring where the drink once lived. Still makes a nice clank when kicked.",
        model = "models/foodnhouseholditems/sodacan04.mdl",
        istrash = true
    },
    ["drink_sprite"] = {
        name = "Sprite",
        desc = "A long-forgotten can of lemon-lime soda, now more yellow than green and with carbonation long since passed. The citrusy scent is faint, buried beneath hints of metal and time.",
        model = "models/foodnhouseholditems/sodacan05.mdl",
        trash = "drink_sprite_empty"
    },
    ["drink_sprite_empty"] = {
        name = "Empty Sprite",
        desc = "A lightweight, slightly dented aluminum can that once held lemon-lime soda. Now its just trash, or treasure, depending on how creative you are.",
        model = "models/foodnhouseholditems/sodacan05.mdl",
        istrash = true
    },
    ["drink_dew"] = {
        name = "Mountain Dew",
        desc = "A faded, dented can of Mountain Dew, now a time capsule of citrusy energy. The neon yellow is barely visible beneath layers of age, and the liquid inside is more a shadow of its former self than the fizzy, sugar-packed drink it once was. Approach with caution.",
        model = "models/foodnhouseholditems/sodacan06.mdl",
        trash = "drink_dew_empty"
    },
    ["drink_dew_empty"] = {
        name = "Empty Sprite",
        desc = "A crumpled, faded can of Mountain Dew, its vibrant green label nearly lost to time. Theres nothing left inside, but the faint scent of citrus and sugar still lingers in the air.",
        model = "models/foodnhouseholditems/sodacan06.mdl",
        istrash = true
    },
    ["drink_monster"] = {
        name = "Monster",
        desc = "A battered, faded can of Monster Energy, aged two decades. The once-vibrant logo is now barely visible, and the liquid inside has likely long lost any trace of its original fizz. What was once a quick energy boost is now more of an industrial experiment.",
        model = "models/foodnhouseholditems/sodacanb01.mdl",
        trash = "drink_monster_empty"
    },
    ["drink_monster_empty"] = {
        name = "Empty Monster",
        desc = "A crumpled, dented can of Monster Energy, its iconic logo faded and the remnants of its contents long gone. The can still carries the lingering scent of artificial energy and a faint trace of caffeine.",
        model = "models/foodnhouseholditems/sodacanb01.mdl",
        istrash = true
    },
    ["drink_monster1"] = {
        name = "Blue Monster",
        desc = "A faded can of Blue Monster Energy, its once-vibrant blue color now dulled with age. The logo is barely visible, and the liquid inside is a mystery, likely long past its prime. Its a relic of energy drinks gone by.",
        model = "models/foodnhouseholditems/sodacanb02.mdl",
        trash = "drink_monster1_empty"
    },
    ["drink_monster1_empty"] = {
        name = "Empty Blue Monster",
        desc = "A crumpled, dented can of Monster Energy, its iconic logo faded and the remnants of its contents long gone. The can still carries the lingering scent of artificial energy and a faint trace of caffeine.",
        model = "models/foodnhouseholditems/sodacanb02.mdl",
        istrash = true
    },
    ["drink_monster2"] = {
        name = "Red Monster",
        desc = "A faded can of Blue Monster Energy, its once-vibrant red color now dulled with age. The logo is barely visible, and the liquid inside is a mystery, likely long past its prime. Its a relic of energy drinks gone by.",
        model = "models/foodnhouseholditems/sodacanb03.mdl",
        trash = "drink_monster2_empty"
    },
    ["drink_monster2_empty"] = {
        name = "Empty Red Monster",
        desc = "A crumpled, dented can of Monster Energy, its iconic logo faded and the remnants of its contents long gone. The can still carries the lingering scent of artificial energy and a faint trace of caffeine.",
        model = "models/foodnhouseholditems/sodacanb03.mdl",
        istrash = true
    },
    ["drink_volt"] = {
        name = "Volt",
        desc = "A once-popular can of Volt Energy Drink, now aged and barely recognizable. The neon yellow label has faded, and the liquid inside is a murky mystery. Its likely lost all of its original fizz and power, replaced by a strange, metallic odor.",
        model = "models/foodnhouseholditems/sodacanb04.mdl",
        trash = "drink_volt_empty"
    },
    ["drink_volt_empty"] = {
        name = "Empty Volt",
        desc = "A crushed and worn can of Volt Energy Drink, its once-vibrant neon yellow label nearly worn away. Theres nothing left inside, but it still carries a faint smell of artificial energy and sugar.",
        model = "models/foodnhouseholditems/sodacanb04.mdl",
        istrash = true
    },
    ["drink_redbull"] = {
        name = "Red Bull",
        desc = "An ancient can of Red Bull, its vibrant logo faded and the contents long past their prime. What was once the go-to energy booster has now become a timeworn relic, its once fizzy and energizing properties likely completely gone.",
        model = "models/foodnhouseholditems/sodacanc01.mdl",
        trash = "drink_redbull_empty"
    },
    ["drink_redbull_empty"] = {
        name = "Empty Red Bull",
        desc = "A crumpled, faded can of Red Bull, once a symbol of energy and vitality. The iconic blue and silver logo is now barely visible, and the remnants of its contents are long gone, leaving only the faint scent of sugar and caffeine.",
        model = "models/foodnhouseholditems/sodacanc01.mdl",
        istrash = true
    },
    ["drink_beer_master"] = {
        name = "Bottle of Master",
        desc = "A vintage bottle of beer, aged for 20 years. The label is worn, and the liquid inside is likely flat and stale, but it carries the nostalgia of a bygone era.",
        model = "models/foodnhouseholditems/beer_master.mdl",
        trash = "drink_beer_master_empty"
    },
    ["drink_beer_stoltz"] = {
        name = "Bottle of Stoltz",
        desc = "A vintage bottle of beer, aged for 20 years. The label is worn, and the liquid inside is likely flat and stale, but it carries the nostalgia of a bygone era.",
        model = "models/foodnhouseholditems/beer_stoltz.mdl",
        trash = "drink_beer_stoltz_empty"
    },
    ["drink_beer_master_empty"] = {
        name = "Empty Master Bottle",
        desc = "A discarded beer bottle, now empty. Still retains some weight and can be used as a makeshift projectile or thrown to create distractions.",
        model = "models/foodnhouseholditems/beer_master.mdl",
        istrash = true 
    },
    ["drink_beer_stoltz_empty"] = {
        name = "Empty Stoltz Bottle",
        desc = "A discarded beer bottle, now empty. Still retains some weight and can be used as a makeshift projectile or thrown to create distractions.",
        model = "models/foodnhouseholditems/beer_stoltz.mdl",
        istrash = true 
    },
    ["drink_champagne_bleuterd"] = {
        name = "Bottle of Bleuterd",
        desc = "A vintage bottle of champagne, aged for 20 years. The label is worn, and the liquid inside is likely flat and stale, but it carries the nostalgia of a bygone era.",
        model = "models/foodnhouseholditems/champagne2.mdl",
        trash = "drink_champagne_bleuterd_empty"
    },
    ["drink_champagne_bleuterd_empty"] = {
        name = "Empty Bleuterd Bottle",
        desc = "A discarded champagne bottle, now empty. Still retains some weight and can be used as a makeshift projectile or thrown to create distractions.",
        model = "models/foodnhouseholditems/champagne2b.mdl",
        istrash = true 
    },
    ["drink_champagne_talloires"] = {
        name = "Bottle of Talloires",
        desc = "A vintage bottle of champagne, aged for 20 years. The label is worn, and the liquid inside is likely flat and stale, but it carries the nostalgia of a bygone era.",
        model = "models/foodnhouseholditems/champagne3.mdl",
        trash = "drink_champagne_talloires_empty"
    },
    ["drink_champagne_talloires_empty"] = {
        name = "Empty Talloires Bottle",
        desc = "A discarded champagne bottle, now empty. Still retains some weight and can be used as a makeshift projectile or thrown to create distractions.",
        model = "models/foodnhouseholditems/champagne3.mdl",
        istrash = true 
    },
    ["drink_beer_duff"] = {
        name = "Can of Duff",
        desc = "A vintage can of Duff, aged for 20 years. The label is worn, and the liquid inside is likely flat and stale, but it carries the nostalgia of a bygone era.",
        model = "models/foodnhouseholditems/beercan01.mdl",
        trash = "drink_beer_duff_empty"
    },
    ["drink_beer_duff_empty"] = {
        name = "Empty Duff Can",
        desc = "A crushed and discarded beer can.",
        model = "models/foodnhouseholditems/beercan01.mdl",
        istrash = true 
    },
    ["drink_beer_pisswasser"] = {
        name = "Can of Pisswasser",
        desc = "A vintage can of Pisswasser, aged for 20 years. The label is worn, and the liquid inside is likely flat and stale, but it carries the nostalgia of a bygone era.",
        model = "models/foodnhouseholditems/beercan02.mdl",
        trash = "drink_beer_pisswasser_empty"
    },
    ["drink_beer_pisswasser_empty"] = {
        name = "Empty Duff Can",
        desc = "A crushed and discarded beer can.",
        model = "models/foodnhouseholditems/beercan02.mdl",
        istrash = true 
    },
    ["drink_beer_hopknot"] = {
        name = "Can of Hop Knot",
        desc = "A vintage can of Hop Knot, aged for 20 years. The label is worn, and the liquid inside is likely flat and stale, but it carries the nostalgia of a bygone era.",
        model = "models/foodnhouseholditems/beercan03.mdl",
        trash = "drink_beer_hopknot_empty"
    },
    ["drink_beer_hopknot_empty"] = {
        name = "Empty Hop Knot Can",
        desc = "A crushed and discarded beer can.",
        model = "models/foodnhouseholditems/beercan03.mdl",
        istrash = true 
    },
    ["food_applejacks"] = {
        name = "Box of AppleJacks",
        desc = "A dusty, faded cereal box from two decades ago. The Apple Jacks inside are stale, slightly discolored, and clump together like artifacts from a forgotten breakfast table. Definitely expired, but hey—still kinda smells like cinnamon.",
        model = "models/foodnhouseholditems/applejacks.mdl",
        trash = "food_applejacks_empty"
    },
    ["food_applejacks_empty"] = {
        name = "Empty Box of Applejacks",
        desc = "An empty cardboard box that once held the sweet, cinnamon-y joy of Apple Jacks. Now it's just a shell of its former glory. Crumbs inside, but not a flake in sight.",
        model = "models/foodnhouseholditems/applejacks.mdl",
        istrash = true 
    },
    ["food_cheerios"] = {
        name = "Box of Cheerios",
        desc = "A sun-faded, brittle box of Cheerios dating back two decades. The contents are dry, tasteless, and harder than stone, but technically... still food. Probably.",
        model = "models/foodnhouseholditems/cheerios.mdl",
        trash = "food_cheerios_empty"
    },
    ["food_cheerios_empty"] = {
        name = "Empty Box of Cheerios",
        desc = "A once-beloved box of wholesome breakfast cereal, now completely empty. The inside smells faintly of oats and childhood.",
        model = "models/foodnhouseholditems/cheerios.mdl",
        istrash = true 
    },
    ["food_chocorings"] = {
        name = "Box of Choco Rings",
        desc = "A crumbling, timeworn box of off-brand chocolate cereal from two decades ago. The rings inside are fossilized, the chocolate scent faint but oddly persistent. Eating it is more of a challenge than a meal.",
        model = "models/foodnhouseholditems/chocorings.mdl",
        trash = "food_chocorings_empty"
    },
    ["food_chocorings_empty"] = {
        name = "Empty Box of Choco Rings",
        desc = "A hollow, faded box that once contained the delicious chocolate rings of childhood nostalgia. Now, its just an empty vessel.",
        model = "models/foodnhouseholditems/chocorings.mdl",
        istrash = true 
    },
    ["food_cokopops"] = {
        name = "Box of Cok O Pops",
        desc = "A suspiciously preserved, ancient box of Cok-O-Pops. The budget cousin of something that once tasted like chocolate. The cereal inside has fused into a single, brittle brick. Smells like cardboard and broken dreams.",
        model = "models/foodnhouseholditems/cokopops.mdl",
        trash = "food_cokopops_empty"
    },
    ["food_cokopops_empty"] = {
        name = "Empty Box of Cok O Pops",
        desc = "The box is faded, the mascot long forgotten, and the nutrition facts unreadable. Once home to questionable chocolatey puffs, now its just air and memories.",
        model = "models/foodnhouseholditems/cokopops.mdl",
        istrash = true 
    },
    ["food_cornflakes"] = {
        name = "Box of Corn Flakes",
        desc = "A dusty, sun-bleached relic from the pantry apocalypse. The flakes inside have long since lost all crunch and now resemble thin shards of ancient parchment. Smells faintly of cardboard, disappointment, and a simpler time.",
        model = "models/foodnhouseholditems/kellogscornflakes.mdl",
        trash = "food_cornflakes_empty"
    },
    ["food_cornflakes_empty"] = {
        name = "Empty Box of Corn Flakes",
        desc = "An empty box that once held the plainest of cereals. The front features a faded rooster and a smile thats seen too much. Now its just a hollow shell, both literally and spiritually.",
        model = "models/foodnhouseholditems/kellogscornflakes.mdl",
        istrash = true 
    },
    ["food_bigmac"] = {
        name = "Big Mac",
        desc = "A nearly unrecognizable, 20-year-old Big Mac, encased in a decaying shell of its former self. The once-juicy patties have shriveled, the lettuce is now a strange, crisp relic, and the special sauce... well, its anyones guess. Despite the obvious signs of age, it still retains the shape of the famous fast food sandwich",
        model = "models/foodnhouseholditems/mcdburger.mdl",
    },
    ["food_bigmac_empty"] = {
        name = "Empty Big Mac Box",
        desc = "A faded, slightly crushed box that once held the iconic Big Mac. The logo is barely visible, and the edges have yellowed with time. The faint smell of fast food nostalgia lingers, but the box is now a relic of a time when fast food felt timeless.",
        model = "models/foodnhouseholditems/mcdburgerboxempty.mdl",
        istrash = true 
    },
    ["food_neapolitan"] = {
        name = "Tub of Neapolitan",
        desc = "A frozen tub packed with three classic flavors: chocolate, vanilla, and strawberry.",
        model = "models/foodnhouseholditems/icecream1.mdl",
        trash = "food_neapolitan_empty"
    },
    ["food_neapolitan_empty"] = {
        name = "Empty Tub of Neapolitan",
        desc = "A once-glorious tub that held chocolate, vanilla, and strawberry dreams. Now scraped clean, with only faint streaks of melted memories left on the inside walls.",
        model = "models/foodnhouseholditems/icecream_empty1.mdl",
        istrash = true 
    },
    ["food_vanilla"] = {
        name = "Tub of Vanilla",
        desc = "A frozen tub packed with vanilla ice cream.",
        model = "models/foodnhouseholditems/icecream2.mdl",
        trash = "food_vanilla_empty"
    },
    ["food_vanilla_empty"] = {
        name = "Empty Tub of Vanilla",
        desc = "A once-glorious tub that held vanilla dreams. Now scraped clean, with only faint streaks of melted memories left on the inside walls.",
        model = "models/foodnhouseholditems/icecream_empty2.mdl",
        istrash = true 
    },
    ["food_strawberry"] = {
        name = "Tub of Strawberry",
        desc = "A frozen tub packed with strawberry ice cream.",
        model = "models/foodnhouseholditems/icecream3.mdl",
        trash = "food_strawberry_empty"
    },
    ["food_strawberry_empty"] = {
        name = "Empty Tub of Strawberry",
        desc = "A once-glorious tub that held strawberry dreams. Now scraped clean, with only faint streaks of melted memories left on the inside walls.",
        model = "models/foodnhouseholditems/icecream_empty3.mdl",
        istrash = true 
    },
    ["food_chocolate"] = {
        name = "Tub of Chocolate",
        desc = "A frozen tub packed with chocolate ice cream.",
        model = "models/foodnhouseholditems/icecream4.mdl",
        trash = "food_chocolate_empty"
    },
    ["food_chocolate_empty"] = {
        name = "Empty Tub of Chocolate",
        desc = "A once-glorious tub that held chocolate dreams. Now scraped clean, with only faint streaks of melted memories left on the inside walls.",
        model = "models/foodnhouseholditems/icecream_empty4.mdl",
        istrash = true 
    },
    ["food_pistachio"] = {
        name = "Tub of Pistachio",
        desc = "A frozen tub packed with pistachio ice cream.",
        model = "models/foodnhouseholditems/icecream5.mdl",
        trash = "food_pistachio_empty"
    },
    ["food_pistachio_empty"] = {
        name = "Empty Tub of Pistachio",
        desc = "A once-glorious tub that held pistachio dreams. Now scraped clean, with only faint streaks of melted memories left on the inside walls.",
        model = "models/foodnhouseholditems/icecream_empty5.mdl",
        istrash = true 
    },
    ["food_licorice"] = {
        name = "Tub of Licorice",
        desc = "A frozen tub packed with licorice ice cream.",
        model = "models/foodnhouseholditems/icecream6.mdl",
        trash = "food_licorice_empty"
    },
    ["food_licorice_empty"] = {
        name = "Empty Tub of Licorice",
        desc = "A once-glorious tub that held licorice dreams. Now scraped clean, with only faint streaks of melted memories left on the inside walls.",
        model = "models/foodnhouseholditems/icecream_empty6.mdl",
        istrash = true 
    },
    ["food_milk"] = {
        name = "Carton of Milk",
        desc = "A cold, sealed carton of fresh milk.",
        model = "models/foodnhouseholditems/milk.mdl",
        trash = "food_milk_empty"
    },

    ["food_milk_empty"] = {
        name = "Empty Carton of Milk",
        desc = "A used milk carton, completely drained and slightly crumpled.",
        model = "models/foodnhouseholditems/milk.mdl",
        istrash = true 
    },
    ["food_milk1"] = {
        name = "Carton of Milk",
        desc = "A cold, sealed carton of fresh milk.",
        model = "models/foodnhouseholditems/milk2.mdl",
        trash = "food_milk1_empty"
    },
    ["food_breenswater"] = {
        name = "Can of Breens Water",
        desc = "A sleek aluminum can bearing the dignified likeness of Dr. Wallace Breen.",
        model = "models/props_lunk/popcan01a.mdl",
        trash = "food_can_empty"
    },
    ["food_breens_sparklingwater"] = {
        name = "Can of Breens Sparkling Water",
        desc = "A sleek aluminum can of sparkling water, adorned with the serene, effervescent visage of Dr. Wallace Breen refreshment, refined by Combine approval.",
        model = "models/props_lunk/popcan01a.mdl",
        trash = "food_can_empty"
    },
    ["food_loyalistwater"] = {
        name = "Can of Loyalist Water",
        desc = "An elegant, matte-finished can adorned with the Union's insignia and a golden loyalist designation stamp.",
        model = "models/props_lunk/popcan01a.mdl",
        trash = "food_can_empty"
    },
    ["food_standardsupplements"] = {
        name = "Standard Supplements",
        desc = "A union stamped vaccum sealed food package, distributed daily to maintain optimal mental clarity and civic compliance.",
        model = "models/mres/consumables/tag_mre.mdl",
        trash = "food_standardsupplements_empty"
    },
    ["food_loyalistuppliments"] = {
        name = "Loyalist Supplements",
        desc = "A union stamped vaccum sealed food package, distributed daily to maintain optimal mental clarity and civic compliance.",
        model = "models/mres/consumables/pag_mre.mdl",
        trash = "food_loyalistsupplements_empty"
    },
    ["food_loyalistcereal"] = {
        name = "Box of Loyalist Cereal",
        desc = "A fortified, neatly packaged breakfast ration reserved for the most loyal citizens.",
        model = "models/pg_plops/pg_food/pg_tortellinap.mdl",
        trash = "food_loyalistcereal_empty"
    },
    ["food_bioticwater"] = {
        name = "Can of Biotic Water",
        desc = "A carefully sealed green can, labeled with the official Combine insignia.",
        model = "models/props_cunk/popcan01a.mdl",
        trash = "food_can_empty"
    },
    ["food_bioticsupplements"] = {
        name = "Package of Biotic Supplements",
        desc = "A green vaccum sealed food package, distributed daily to maintain optimal mental clarity and civic compliance.",
        model = "models/mres/consumables/lag_mre.mdl",
        trash = "food_bioticsupplements_empty"
    },
    ["food_prioritysupplements"] = {
        name = "Package of Priority Supplements",
        desc = "A neatly wrapped box bearing the Union's official stamp, distributed daily to promote mental clarity, emotional stability, and unwavering civic compliance.",
        model = "models/pg_plops/pg_food/pg_tortellinat.mdl",
        trash = "food_prioritysupplements_empty"
    },
    ["food_combinesupplements"] = {
        name = "Package of Combine Supplements",
        desc = "A sterile, foil-sealed blister pack marked with the Union insignia and a series of encoded batch numbers.",
        model = "models/mres/consumables/zag_mre.mdl",
        trash = "food_combinesupplements_empty"
    },
    ["food_minimalsupplements"] = {
        name = "Box of Minimal Supplements",
        desc = "A box, distributed daily to promote unwavering civic compliance.",
        model = "models/pg_plops/pg_food/pg_tortellinan.mdl",
        trash = "food_minimalsupplements_empty"
    },
    ["food_combinewater"] = {
        name = "Can of Combine Water",
        desc = "A sleek, industrial-grade aluminum can stamped with a Black Union insignia.",
        model = "models/props_cunk/popcan01a.mdl",
        trash = "food_can_empty"
    },
    ["food_minimalwater"] = {
        name = "Can of Minimal Water",
        desc = "A sleek, industrial-grade aluminum can.",
        model = "models/props_cunk/popcan01a.mdl",
        trash = "food_can_empty"
    },
    ["food_gin"] = {
        name = "Bottle of Gin",
        desc = "A cold, matte-green bottle, and a tamper-sealed cap, marked For Controlled Civic Celebration Only.",
        model = "models/bioshockinfinite/jin_bottle.mdl",
        trash = "food_gin_empty"
    },
    ["food_tequila"] = {
        name = "Bottle of Tequila",
        desc = "A cold, matte-green bottle, and a tamper-sealed cap, marked For Controlled Civic Celebration Only.",
        model = "models/hlvr/props/bottles/bottle_o_gin.mdl",
        trash = "food_tequila_empty"
    },
    ["food_beer"] = {
        name = "Bottle of Beer",
        desc = "A cold, matte-brown bottle, and a tamper-sealed cap, marked For Controlled Civic Celebration Only.",
        model = "models/bioshockinfinite/hext_bottle_lager.mdl",
        trash = "food_beer_empty"
    },
    ["food_vodka"] = {
        name = "Bottle of Vodka",
        desc = "A cold, clear bottle, a tamper-sealed cap, marked For Controlled Civic Celebration Only.",
        model = "models/hlvr/props/bottles/garbage_glassbottle001a.mdl",
        trash = "food_vodka_empty"
    },
    ["food_whiskey"] = {
        name = "Bottle of Whiskey",
        desc = "A cold, matte-brown bottle, a tamper-sealed cap, marked For Controlled Civic Celebration Only.",
        model = "models/hlvr/props/bottles/garbage_glassbottle001a.mdl",
        trash = "food_whiskey_empty"
    },
    ["food_rum"] = {
        name = "Bottle of Rum",
        desc = "A cold, matte-green bottle, a tamper-sealed cap, marked For Controlled Civic Celebration Only.",
        model = "models/hlvr/props/bottles/garbage_glassbottle003a.mdl",
        trash = "food_rum_empty"
    },
    ["food_moonshine"] = {
        name = "Bottle of Moonshine",
        desc = "A cold, matte-brown bottle, a tamper-sealed cap, marked For Controlled Civic Celebration Only.",
        model = "models/props_junk/glassjug01.mdl",
        trash = "food_moonshine_empty"
    },
    ["food_moonshine_empty"] = {
        name = "Empty Bottle of Moonshine",
        desc = "A discarded Moonshine bottle.",
        model = "models/props_junk/glassjug01.mdl",
       istrash = true
    },
    ["food_rum_empty"] = {
        name = "Empty Bottle of Rum",
        desc = "A discarded whiskey bottle.",
        model = "models/hlvr/props/bottles/garbage_glassbottle003a.mdl",
       istrash = true
    },
    ["food_whiskey_empty"] = {
        name = "Empty Bottle of Whiskey",
        desc = "A discarded whiskey bottle.",
        model = "models/hlvr/props/bottles/garbage_glassbottle001a.mdl",
       istrash = true
    },
    ["food_vodka_empty"] = {
        name = "Empty Bottle of Vodka",
        desc = "A discarded vodka bottle.",
        model = "models/hlvr/props/bottles/bottle_vodka.mdl",
       istrash = true
    },
    ["food_tequila_empty"] = {
        name = "Empty Bottle of Tequila",
        desc = "A discarded tequila bottle.",
        model = "models/hlvr/props/bottles/bottle_o_gin.mdl",
       istrash = true
    },
    ["food_beer_empty"] = {
        name = "Empty Bottle of Beer",
        desc = "A discarded beer bottle.",
        model = "models/bioshockinfinite/jin_bottle.mdl",
       istrash = true
    },
    ["food_gin_empty"] = {
        name = "Empty Bottle of Gin",
        desc = "A discarded gin bottle.",
        model = "models/bioshockinfinite/jin_bottle.mdl",
       istrash = true
    },
    ["food_combinesupplements_empty"] = {
        name = "Empty Package of Combine Supplements",
        desc = "A discarded black union stamped food package.",
        model = "models/mres/consumables/zag_mre.mdl",
       istrash = true
    },
    ["food_prioritysupplements_empty"] = {
        name = "Empty Package of Priority Supplements",
        desc = "A discarded yellow union stamped box.",
        model = "models/pg_plops/pg_food/pg_tortellinat.mdl",
       istrash = true
    },
    ["food_loyalistsupplements_empty"] = {
        name = "Empty Package of Loyalist Supplements",
        desc = "A discarded red union stamped food package.",
        model = "models/mres/consumables/pag_mre.mdl",
       istrash = true
    },
    ["food_bioticsupplements_empty"] = {
        name = "Empty Package of Biotic Supplements",
        desc = "A discarded green union stamped food package.",
        model = "models/mres/consumables/lag_mre.mdl",
       istrash = true
    },
    ["food_loyalistcereal_empty"] = {
        name = "Empty box of Loyalist Cereal",
        desc = "A discarded union stamped box.",
        model = "models/pg_plops/pg_food/pg_tortellinap.mdl",
        istrash = true 
    },
    ["food_standardsupplements_empty"] = {
        name = "Empty Box of Supplements",
        desc = "A discarded food package.",
        model = "models/mres/consumables/lag_mre.mdl",
        istrash = true 
    },
    ["food_milk1_empty"] = {
        name = "Empty Carton of Milk",
        desc = "A used milk carton, completely drained and slightly crumpled.",
        model = "models/foodnhouseholditems/milk2.mdl",
        istrash = true 
    },
    ["food_miniwheat"] = {
        name = "Box of Frosted Mini Wheats",
        desc = "A box sealed tight by time itself. The once-frosted squares within are now hardened like bricks, their sugary tops faded to a ghostly white. Each bite is a gamble between dental disaster and nostalgic euphoria.",
        model = "models/foodnhouseholditems/miniwheats.mdl",
        trash = "food_miniwheats_empty"
    },
    ["food_miniwheats_empty"] = {
        name = "Empty Box of Frosted Mini Wheats",
        desc = "The frosted warriors are long gone, but the box remains. A hollow monument to forgotten breakfasts. Faint traces of sugar cling to the seams like frosty ghosts of mornings past.",
        model = "models/foodnhouseholditems/miniwheats.mdl",
        istrash = true 
    },
    ["food_envirokidz"] = {
        name = "Box of Frosted Mini Wheats",
        desc = "A cardboard tomb from a bygone era of eco-conscious breakfasts. The cereal inside, once shaped like endangered animals, is now fossilized into a crunchy crypt of stale granola. The box still boasts that it’s gluten-free, but time was not.",
        model = "models/foodnhouseholditems/pandapuffs.mdl",
        trash = "food_envirokidz_empty"
    },
    ["food_envirokidz_empty"] = {
        name = "Empty Box of Frosted Mini Wheats",
        desc = "A faded, earth-toned box once filled with animal-shaped, slightly sweetened cereal for the environmentally conscious kid. Now empty, save for a few ancient crumbs and the crushing weight of time.",
        model = "models/foodnhouseholditems/pandapuffs.mdl",
        istrash = true 
    },
    ["food_eggcarton_empty"] = {
        name = "Empty Egg Carton",
        desc = "A battered, empty carton that once cradled six eggs.",
        model = "models/foodnhouseholditems/egg_box3.mdl",
        istrash = true 
    },
    ["food_pizzabox_empty"] = {
        name = "Empty Pizza Box",
        desc = "A grease-stained cardboard box that once held a delicious, cheesy pizza.",
        model = "models/foodnhouseholditems/pizzaboxbottom.mdl",
        istrash = true 
    },
    ["food_pizzabox1_empty"] = {
        name = "Empty Pizza Box",
        desc = "A grease-stained cardboard box that once held a delicious, cheesy pizza.",
        model = "models/foodnhouseholditems/pizzaboxtop.mdl",
        istrash = true 
    },
    ["food_ration_empty"] = {
        name = "Empty Ration Package",
        desc = "An opened and flattened Combine-issued ration wrapper, its sterile surface now creased and torn. ",
        model = "models/weapons/w_packate.mdl",
        istrash = true 
    },
    ["food_can_empty"] = {
        name = "Empty Can",
        desc = "An opened and empty Combine-issued can. ",
        model = "models/props_nunk/popcan01a.mdl",
        istrash = true 
    },
    --[[["package_ration"] = {
        name = "Ration",
        desc = "It's a ration package..",
        model = "models/weapons/w_package.mdl",
        pack = { 
            ["tokens"] = 10, -- This gives the character tokens.
            ["food_fries"] = 2, -- This gives character 2 fries.
        }
    }]]
    ["package_banana"] = {
        name = "Bunch of Bananas",
        desc = "A ripe bunch of sweet, yellow bananas. Packed with energy and potassium.",
        model = "models/foodnhouseholditems/bananna_bunch.mdl",
        pack = { 
            ["food_banana"] = 5, --
        }
    },
    ["package_bioticration"] = {
        name = "Biotic Ration",
        desc = "A vaccum sealed, biotic-grade package bearing a Combine insignia.",
        model = "models/weapons/w_packatb.mdl",
        pack = { 
            ["food_ration_empty"] = 1, --
            ["food_bioticsupplements"] = 1,
            ["food_bioticwater"] = 1,
            ["tokens"] = 4,
        }
    },
    ["package_loyalistration"] = {
        name = "Loyalist Ration",
        desc = "A vaccum sealed, loayalist-grade package bearing a Combine insignia.",
        model = "models/weapons/w_packatl.mdl",
        pack = { 
            ["food_ration_empty"] = 1, --
            ["food_loyalistsupplements"] = 1,
            ["food_loyalistwater"] = 1,
            ["food_loyalistcereal"] = 1,
            ["tokens"] = 40,
        }
    },
    ["package_combineration"] = {
        name = "Combine Ration",
        desc = "A vaccum sealed, Combine-grade package bearing a Combine insignia.",
        model = "models/weapons/w_packatm.mdl",
        pack = { 
            ["food_ration_empty"] = 1, --
            ["food_combinesupplements"] = 1,
            ["food_combinewater"] = 1,
            ["tokens"] = 80,
        }
    },
    ["package_priorityration"] = {
        name = "Priority Ration",
        desc = "A vaccum sealed, priority-grade package bearing a Combine insignia.",
        model = "models/weapons/w_packatp.mdl",
        pack = { 
            ["food_ration_empty"] = 1, --
            ["food_prioritysupplements"] = 1,
            ["food_breens_sparklingwater"] = 1,
            ["tokens"] = 60,
        }
    },
    ["package_standardration"] = {
        name = "Standard Ration",
        desc = "A vaccum sealed, regulation-grade package bearing a Combine insignia.",
        model = "models/weapons/w_packatc.mdl",
        pack = { 
            ["food_ration_empty"] = 1, --
            ["food_standardsupplements"] = 1,
            ["food_breenswater"] = 1,
            ["tokens"] = 20,
        }
    },
    ["package_minimalration"] = {
        name = "Minimal Ration",
        desc = "A vaccum sealed, package bearing a Combine insignia.",
        model = "models/weapons/w_packati.mdl",
        pack = { 
            ["food_ration_empty"] = 1, --
            ["food_minimalsupplements"] = 1,
            ["food_minimalwater"] = 1,
            ["tokens"] = 10,
        }
    },
    ["package_egg"] = {
        name = "Carton of Eggs",
        desc = "A carton containing six fresh eggs, each encased in its fragile shell.",
        model = "models/foodnhouseholditems/egg_box4.mdl",
        pack = { 
            ["food_egg"] = 6, --
            ["food_eggcarton_empty"] = 1,
        }
    },
    ["package_bigmac"] = {
        name = "Big Mac",
        desc = "A timeworn, faded Big Mac box that still contains the burger, now a peculiar artifact of fast food history. The box is crushed and yellowed, and the sandwich inside looks... well, its hard to say exactly what it looks like after two decades. The faint, questionable scent of processed cheese and mystery meat might still be there.",
        model = "models/foodnhouseholditems/mcdburgerboxclosed.mdl",
        pack = { 
            ["food_bigmac"] = 1, --
            ["food_bigmac_empty"] = 1,
        }
    },
    ["package_pizza"] = {
        name = "Box of Pizza",
        desc = "A warm, slightly greasy pizza box containing a few fresh slices of cheesy, saucy goodness.",
        model = "models/foodnhouseholditems/pizzabox.mdl",
        pack = { 
            ["food_pizza"] = 6, --
            ["food_pizzabox_empty"] = 1,
            ["food_pizzabox1_empty"] = 1,
        }
    },
    ["package_cake"] = {
        name = "Cake",
        desc = "A full, beautifully decorated cake ready for slicing.",
        model = "models/foodnhouseholditems/cake.mdl",
        pack = { 
            ["food_cake_slice"] = 6, --
        }
    }
}

PLUGIN:AddFoodItemTable(items)

