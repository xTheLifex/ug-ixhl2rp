
util.AddNetworkString("ixAreaSync")
util.AddNetworkString("ixAreaAdd")
util.AddNetworkString("ixAreaRemove")
util.AddNetworkString("ixAreaChanged")

util.AddNetworkString("ixAreaEditStart")
util.AddNetworkString("ixAreaEditEnd")

ix.log.AddType("areaAdd", function(client, name)
	return string.format("%s has added area \"%s\".", client:Name(), tostring(name))
end)

ix.log.AddType("areaRemove", function(client, name)
	return string.format("%s has removed area \"%s\".", client:Name(), tostring(name))
end)

local function SortVector(first, second)
	return Vector(math.min(first.x, second.x), math.min(first.y, second.y), math.min(first.z, second.z)),
		Vector(math.max(first.x, second.x), math.max(first.y, second.y), math.max(first.z, second.z))
end

function ix.area.Create(name, type, positions, bNoReplicate, properties)
	
	local sortedPositions = {}
	for k,v in ipairs(positions) do
		local min, max = SortVector(v[1], v[2])
		table.insert(sortedPositions, {min, max})
	end

	ix.area.stored[name] = {
		type = type or "area",
		positions = sortedPositions,
		bNoReplicate = bNoReplicate,
		properties = properties
	}

	-- network to clients if needed
	if (!bNoReplicate) then
		net.Start("ixAreaAdd")
			net.WriteString(name)
			net.WriteString(type)
			net.WriteTable(sortedPositions)
			net.WriteTable(properties)
		net.Broadcast()
	end
end

function ix.area.Remove(name, bNoReplicate)
	ix.area.stored[name] = nil

	-- network to clients if needed
	if (!bNoReplicate) then
		net.Start("ixAreaRemove")
			net.WriteString(name)
		net.Broadcast()
	end
end
