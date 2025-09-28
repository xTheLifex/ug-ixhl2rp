PLUGIN.name = "Admin ESP"
PLUGIN.author = "Akiran, ZeMysticalTaco(Original ESP), TheLife"
PLUGIN.description = "A modular ESP admin system for Helix."

local dimDistance = 2048

local EntitiesESPList = {
	["ix_item"] = Color(255, 255, 255),
	["ix_money"] = Color(255, 251, 0),
	["ix_shipment"] = Color(255, 255, 255),
	["ix_container"] = Color(51, 255, 209),
	["ix_vendor"] = Color(255, 185, 0),
	["ix_vendor_new"] = Color(255, 185, 0),
	["ix_questgiver"] = Color(43, 96, 49),
	["ix_combinelock"] = Color(255, 255, 255),
	["ix_rationdispenser"] = Color(255, 255, 255),
	["ix_scavengingpile"] = Color(56, 43, 96),
	["ix_station"] = Color(102, 89, 170),
	["ix_vendingmachine"] = Color(255, 255, 255),
	["prop_ragdoll"] = Color(255, 255, 255),
}

local WildcardEntities = {
	["npc_"] = Color(255,0,0)
}

local ItemCategoryColor = {
	["Weapons"] = Color(255,50,50),
	["Ammunition"] = Color(155,50,50),
	["Food"] = Color(100,255,100),
	["Crafting"] = Color(150,200,50),
	["Clothes"] = Color(65,200,150),
	["Attachments"] = Color(50,255,175),
	["Survival"] = Color(50,255,175)
}

-- Helper function to match wildcard entities
local function MatchesWildcard(class)
	for prefix, color in pairs(WildcardEntities) do
		if string.StartWith(class, prefix) then
			return true, color, prefix
		end
	end
	return false
end

local function WildcardESPHandler(ent, color)
	return "[" .. ent:GetClass() .. "]", color
end


for ent,color in pairs(EntitiesESPList) do
	local data = scripted_ents.Get(ent)
	local name = '"' .. ent .. '"'
	if data and data.PrintName then
		name = data.PrintName
	end

	ix.lang.AddTable("english", {	
		["optESP" .. ent] = "ESP for " .. name,
		["optdESP" .. ent] = "Enables Admin ESP for entities of the " .. ent .. " type.",
	})
	ix.option.Add("ESP" .. ent, ix.type.bool, false, {
		category = "observer",
		hidden = function()
			return !CAMI.PlayerHasAccess(LocalPlayer(), "Helix - Observer", nil)
		end
	})
end

for prefix, color in pairs(WildcardEntities) do
	local name = '"' .. prefix .. '*"'
	ix.lang.AddTable("english", {
		["optESP" .. prefix] = "ESP for " .. name,
		["optdESP" .. prefix] = "Enables Admin ESP for all entities starting with " .. prefix,
	})
	ix.option.Add("ESP" .. prefix, ix.type.bool, false, {
		category = "observer",
		hidden = function()
			return !CAMI.PlayerHasAccess(LocalPlayer(), "Helix - Observer", nil)
		end
	})
end


ix.lang.AddTable("english", {
	optEnableAdminESP = "Enable Admin ESP",
	optdEnableAdminESP = "Enables Admin ESP for you.",
	optEnableAreaESP = "Enable Area ESP",
	optdEnableAreaESP = "Displays areas just like in AreaEdit mode.",
})

ix.option.Add("enableAdminESP", ix.type.bool, true, {
	category = "observer",
	hidden = function()
		return !CAMI.PlayerHasAccess(LocalPlayer(), "Helix - Observer", nil)
	end
})

ix.option.Add("enableAreaESP", ix.type.bool, false, {
	category = "observer",
	hidden = function()
		return !CAMI.PlayerHasAccess(LocalPlayer(), "Helix - Observer", nil)
	end
})

-- Modular rendering handlers for specific entity classes
local ESPHandlers = {}

ESPHandlers["ix_item"] = function(ent)
	local itemTable = ent:GetItemTable()
	local name = itemTable and itemTable.name or "Unknown Item"
	local color = ItemCategoryColor[itemTable and itemTable.category] or EntitiesESPList["ix_item"]
	return "[Item] " .. name, color
end

ESPHandlers["ix_vendor"] = function(ent)
	return "[Vendor] " .. (ent:GetDisplayName() or "Vendor"), EntitiesESPList["ix_vendor"]
end

ESPHandlers["ix_vendor_new"] = ESPHandlers["ix_vendor"]

ESPHandlers["ix_questgiver"] = function(ent)
	return "[Quest] " .. (ent:GetNetVar("Name") or "Questgiver"), EntitiesESPList["ix_questgiver"]
end

ESPHandlers["ix_money"] = function(ent)
	return "[Money] $" .. (ent:GetAmount() or 0), EntitiesESPList["ix_money"]
end

ESPHandlers["ix_container"] = function(ent)
	return "[Container] " .. (ent:GetDisplayName() or "Container"), EntitiesESPList["ix_container"]
end

ESPHandlers["ix_scavengingpile"] = function(ent)
	return "[Scavenging] " .. (ent:GetDisplayName() or "Pile"), EntitiesESPList["ix_scavengingpile"]
end

ESPHandlers["ix_station"] = function(ent)
	return "[Station] " .. (ent:GetDisplayName() or "Station"), EntitiesESPList["ix_station"]
end

-- Default fallback if no handler exists
local function DefaultESPHandler(ent)
	local class = ent:GetClass()
	local color = EntitiesESPList[class] or Color(255, 255, 255)
	return "[" .. class .. "]", color
end

local function DrawTextBackground(x, y, text, font, backgroundColor, padding)
	font = font or "ixSubTitleFont"
	padding = padding or 8
	backgroundColor = backgroundColor or Color(88, 88, 88, 255)

	surface.SetFont(font)
	local textWidth, textHeight = surface.GetTextSize(text)
	local width, height = textWidth + padding * 2, textHeight + padding * 2

	ix.util.DrawBlurAt(x, y, width, height)
	surface.SetDrawColor(0, 0, 0, 40)
	surface.DrawRect(x, y, width, height)

	derma.SkinFunc("DrawImportantBackground", x, y, width, height, backgroundColor)

	surface.SetTextColor(color_white)
	surface.SetTextPos(x + padding, y + padding)
	surface.DrawText(text)

	return height
end


function PLUGIN:HUDPaint()
	local client = LocalPlayer()
	if (!ix.option.Get("enableAdminESP", true)) then return end
	if not (client:IsAdmin() and client:GetMoveType() == MOVETYPE_NOCLIP and not client:InVehicle()) then return end

	local scrW, scrH = ScrW(), ScrH()

	for _, ent in ipairs(ents.GetAll()) do
		local class = ent:GetClass()
		local isListed = EntitiesESPList[class]
		local matchesWildcard, wildcardColor, wildcardPrefix = MatchesWildcard(class)
		
		if not isListed and not matchesWildcard then continue end
		local showESP = (isListed and ix.option.Get("ESP" .. class, false)) or (matchesWildcard and ix.option.Get("ESP" .. wildcardPrefix, false))
		if not showESP then continue end		
		local pos = ent:GetPos():ToScreen()
		local distance = client:GetPos():Distance(ent:GetPos())
		local factor = 1 - math.Clamp(distance / dimDistance, 0, 1)
		local size = math.max(10, 32 * factor)
		local alpha = math.max(255 * factor, 80)

		local text, color
		if ESPHandlers[class] then
			text, color = ESPHandlers[class](ent)
		elseif matchesWildcard then
			text, color = WildcardESPHandler(ent, wildcardColor)
		else
			text, color = DefaultESPHandler(ent)
		end		

		ix.util.DrawText(text, pos.x, pos.y - size, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha)
	end

	for _, ply in ipairs(player.GetAll()) do
		if ply == client or not ply:GetCharacter() then continue end

		local pos = ply:GetPos():ToScreen()
		local distance = client:GetPos():Distance(ply:GetPos())
		local factor = 1 - math.Clamp(distance / dimDistance, 0, 1)
		local size = math.max(10, 32 * factor)
		local alpha = math.max(255 * factor, 80)
		local col = team.GetColor(ply:Team())

		local status = ply:GetUserGroup()
		if ply:IsUserGroup("superadmin") then status = "SA"
		elseif ply:IsUserGroup("admin") then status = "A"
		elseif ply:IsUserGroup("operator") then status = "O"
		elseif ply:IsUserGroup("producer") then status = "P"
		end

		local wep = ply:GetActiveWeapon()
		local wepName = IsValid(wep) and wep.PrintName or "No Weapon"

		ix.util.DrawText(ply:Name(), pos.x, pos.y - size, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha)
		ix.util.DrawText(ply:SteamName() .. " [" .. status .. "]", pos.x, pos.y - size + 20, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha)
		ix.util.DrawText("H: " .. ply:Health() .. " A: " .. ply:Armor(), pos.x, pos.y - size + 40, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha)
		ix.util.DrawText(wepName, pos.x, pos.y - size + 60, Color(255, 100, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, nil, alpha)
	end

	if (ix.area.bEditing) then return end
	if (!ix.option.Get("enableAreaESP", false)) then return end
	local id = LocalPlayer():GetArea()
	local area = ix.area.stored[id]
	local height = ScrH()

	if (area) then
		DrawTextBackground(64, height - 64 - ScreenScale(12), id, "ixSmallTitleFont", area.properties.color)
	end
end

-- return world center, local min, and local max from world start/end positions
function PLUGIN:GetLocalAreaPosition(startPosition, endPosition)
	local center = LerpVector(0.5, startPosition, endPosition)
	local min = WorldToLocal(startPosition, angle_zero, center, angle_zero)
	local max = WorldToLocal(endPosition, angle_zero, center, angle_zero)

	return center, min, max
end

function PLUGIN:PostDrawTranslucentRenderables(bDepth, bSkybox)
	local client = LocalPlayer()
	if not (client:IsAdmin() and client:GetMoveType() == MOVETYPE_NOCLIP and not client:InVehicle()) then return end
	if (bSkybox or ix.area.bEditing or !ix.option.Get("enableAreaESP")) then
		return
	end

	local betterArea = ix.plugin.Get("betterarea")
	if (betterArea and betterArea.DrawAllAreas) then
		betterArea:DrawAllAreas()
		return
	end

	-- draw all areas
	for k, v in pairs(ix.area.stored) do
		local center, min, max = self:GetLocalAreaPosition(v.startPosition, v.endPosition)
		local color = ColorAlpha(v.properties.color or ix.config.Get("color"), 255)

		render.DrawWireframeBox(center, angle_zero, min, max, color)

		cam.Start2D()
			local centerScreen = center:ToScreen()
			local _, textHeight = draw.SimpleText(
				k, "BudgetLabel", centerScreen.x, centerScreen.y, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			if (v.type != "area") then
				draw.SimpleText(
					"(" .. L(v.type) .. ")", "BudgetLabel",
					centerScreen.x, centerScreen.y + textHeight, color, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER
				)
			end
		cam.End2D()
	end

end