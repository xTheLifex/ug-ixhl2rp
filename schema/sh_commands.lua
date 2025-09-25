/* -------------------------------------------------------------------------- */
/*                                  Dispatch                                  */
/* -------------------------------------------------------------------------- */

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		if (!client:IsRestricted()) then
			ix.chat.Send(client, "dispatch", message)
		else
			return "@notNow"
		end
	end

	function COMMAND:OnCheckAccess(client)
		return client.IsHighRank and client:IsHighRank() or client:IsAdmin()
	end

	ix.command.Add("Dispatch", COMMAND)
end

/* -------------------------------------------------------------------------- */
/*                               Radio Dispatch                               */
/* -------------------------------------------------------------------------- */


do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text
	COMMAND.alias = {"RadioDisp", "DispRadio"}
	function COMMAND:OnRun(client, message)
		local receivers = {}
		for k,v in ipairs(player.GetAll()) do
			if (v:IsCombine()) then
				table.insert(receivers, v)
			end
		end
		ix.chat.Send(client, "radio", message, true, receivers, {dispatch=true})
	end

	function COMMAND:OnCheckAccess(client)
		return client.IsHighRank and client:IsHighRank() or client:IsAdmin()
	end

	ix.command.Add("RadioDispatch", COMMAND)
end


/* -------------------------------------------------------------------------- */
/*                                    Radio                                   */
/* -------------------------------------------------------------------------- */

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text
	COMMAND.alias = {"R"}

	function COMMAND:OnRun(client, message)
		local character = client:GetCharacter()
		local radios = character:GetInventory():GetItemsByUniqueID("handheld_radio", true)
		local item

		for k, v in ipairs(radios) do
			if (v:GetData("enabled", false)) then
				item = v
				break
			end
		end

		if (item) then
			if (!client:IsRestricted()) then
				ix.chat.Send(client, "radio", message)
				ix.chat.Send(client, "radio_eavesdrop", message)
			else
				return "@notNow"
			end
		elseif (#radios > 0) then
			return "@radioNotOn"
		else
			return "@radioRequired"
		end
	end

	ix.command.Add("Radio", COMMAND)
end

/* -------------------------------------------------------------------------- */
/*                                   SetFreq                                  */
/* -------------------------------------------------------------------------- */

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.number

	function COMMAND:OnRun(client, frequency)
		local character = client:GetCharacter()
		local inventory = character:GetInventory()
		local itemTable = inventory:HasItem("handheld_radio")

		if (itemTable) then
			if (string.find(frequency, "^%d%d%d%.%d$")) then
				character:SetData("frequency", frequency)
				itemTable:SetData("frequency", frequency)

				client:Notify(string.format("You have set your radio frequency to %s.", frequency))
			end
		end
	end

	ix.command.Add("SetFreq", COMMAND)
end

/* -------------------------------------------------------------------------- */
/*                                   Request                                  */
/* -------------------------------------------------------------------------- */

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		local character = client:GetCharacter()
		local inventory = character:GetInventory()

		if (inventory:HasItem("request_device") or client:IsCombine() or client:Team() == FACTION_ADMIN) then
			if (!client:IsRestricted()) then
				Schema:AddCombineDisplayMessage("@cRequest")

				ix.chat.Send(client, "request", message)
				ix.chat.Send(client, "request_eavesdrop", message)
			else
				return "@notNow"
			end
		else
			return "@needRequestDevice"
		end
	end

	ix.command.Add("Request", COMMAND)
end

/* -------------------------------------------------------------------------- */
/*                                  Broadcast                                 */
/* -------------------------------------------------------------------------- */

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.text

	function COMMAND:OnRun(client, message)
		if (!client:IsRestricted()) then
			ix.chat.Send(client, "broadcast", message)
		else
			return "@notNow"
		end
	end

	ix.command.Add("Broadcast", COMMAND)
end

/* -------------------------------------------------------------------------- */
/*                                 PermitGive                                 */
/* -------------------------------------------------------------------------- */

do
	local COMMAND = {}
	COMMAND.adminOnly = true
	COMMAND.arguments = {
		ix.type.character,
		ix.type.text
	}

	function COMMAND:OnRun(client, target, permit)
		local itemTable = ix.item.Get("permit_" .. permit:lower())

		if (itemTable) then
			target:GetInventory():Add(itemTable.uniqueID)
		end
	end

	ix.command.Add("PermitGive", COMMAND)
end

/* -------------------------------------------------------------------------- */
/*                                 PermitTake                                 */
/* -------------------------------------------------------------------------- */

do
	local COMMAND = {}
	COMMAND.adminOnly = true
	COMMAND.arguments = {
		ix.type.character,
		ix.type.text
	}
	COMMAND.syntax = "<string name> <string permit>"

	function COMMAND:OnRun(client, target, permit)
		local inventory = target:GetInventory()
		local itemTable = inventory:HasItem("permit_" .. permit:lower())

		if (itemTable) then
			inventory:Remove(itemTable.id)
		end
	end

	ix.command.Add("PermitTake", COMMAND)
end

/* -------------------------------------------------------------------------- */
/*                                  ViewData                                  */
/* -------------------------------------------------------------------------- */

do
	local COMMAND = {}
	COMMAND.arguments = ix.type.character

	function COMMAND:OnRun(client, target)
		local targetClient = target:GetPlayer()

		if (!hook.Run("CanPlayerViewData", client, targetClient)) then
			return "@cantViewData"
		end

		netstream.Start(client, "ViewData", targetClient, target:GetData("cid") or false, target:GetData("combineData"))
	end

	ix.command.Add("ViewData", COMMAND)
end

/* -------------------------------------------------------------------------- */
/*                               ViewObjectives                               */
/* -------------------------------------------------------------------------- */

do
	local COMMAND = {}

	function COMMAND:OnRun(client, arguments)
		if (!hook.Run("CanPlayerViewObjectives", client)) then
			return "@noPerm"
		end

		netstream.Start(client, "ViewObjectives", Schema.CombineObjectives)
	end

	ix.command.Add("ViewObjectives", COMMAND)
end

/* -------------------------------------------------------------------------- */
/*                                 CharSearch                                 */
/* -------------------------------------------------------------------------- */

do
	local COMMAND = {}
	local SEARCH_DISTANCE = 192
	local CONSENT_TIMEOUT = 20 -- seconds

	function COMMAND:OnRun(client, arguments)
		if client:IsRestricted() then
			return "You cannot do this while tied up!"
		end

		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target) and target:IsPlayer()) then
			if (target:IsRestricted()) then
				Schema:SearchPlayer(client, target)
			else
				client.nextSearchAttempt = client.nextSearchAttempt or 0
				if (client.nextSearchAttempt > CurTime()) then
					return "Please wait before trying to search again!"
				end

				if (target.pendingSearch) then
					if (target.pendingSearch.requester != client) then
						target.pendingSearch = nil
					elseif (CurTime() > target.pendingSearch.expireTime) then
						target.pendingSearch = nil
					elseif (target.pendingSearch.consent == true) then
						Schema:SearchPlayer(client, target)
						client:Notify("Searching " .. target:GetName() .. "...")
						return
					else
						client:Notify("Please wait for their consent!")
						return
					end
				end

				target.pendingSearch = {
					requester = client,
					expireTime = CurTime() + CONSENT_TIMEOUT
				}

				target:Notify(client:GetName() .. " wants to search you. Type /AcceptSearch to allow. Expires in " .. CONSENT_TIMEOUT .. " seconds.")
				client.nextSearchAttempt = CurTime() + 1
				return "Search request sent..."
			end
		else
			return "You must look at someone!"
		end
	end

	ix.command.Add("CharSearch", COMMAND)
end

/* -------------------------------------------------------------------------- */
/*                                Accept Search                               */
/* -------------------------------------------------------------------------- */
do
	local COMMAND = {}
	
	function COMMAND:OnRun(client, arguments)
		if not client.pendingSearch then return "You do not have a pending search request!" end

		if (client.pendingSearch.expireTime < CurTime()) then
			client.pendingSearch = nil
			return "The request has expired!"
		end

		local requester = client.pendingSearch.requester
		client.pendingSearch.consent = true
		client:Notify("You have consented to being searched! Tell them to /CharSearch again.")
		requester:Notify(client:GetName() .. " has consented to your search!")
		
	end

	ix.command.Add("AcceptSearch", COMMAND)
end


/* -------------------------------------------------------------------------- */
/*                                Check Edicts                                */
/* -------------------------------------------------------------------------- */

do
	ix.command.Add("CheckEdicts", {
		description = "Displays how many entities there are on the map.",
		adminOnly = true,
		OnRun = function(self, client)
			local count = 0
		
			for k, v in pairs(ents.GetAll()) do
				count=count+1
			end

			local countLeft = 8192 - count
		
			client:Notify(string.format("There are currently %s entities on the map. You can have %s more.", count, countLeft))
		end;
	})
end

/* -------------------------------------------------------------------------- */
/*                                Clear Decals                                */
/* -------------------------------------------------------------------------- */

do
	ix.command.Add("ClearDecals", {
		description = "Clears all decals for all players.",
		adminOnly = true,
		OnRun = function(self, client)
			for k, v in pairs(player.GetAll()) do
				v:ConCommand("r_cleardecals");
				client:Notify("You have cleared all decals.")
			end;
		end;
	})
end

/* -------------------------------------------------------------------------- */
/*                                Set Lock Type                               */
/* -------------------------------------------------------------------------- */

do
	local COMMAND = {}
	COMMAND.adminOnly = true
	COMMAND.alias = {"SetLockType"}
	COMMAND.arguments = {
		ix.type.string
	}
    COMMAND.argumentNames = {"Door Type"}
    COMMAND.description = "Sets the combine lock type on the door you're facing."

	function COMMAND:OnRun(client, argument)
		local data = {}
			data.start = client:GetShootPos()
			data.endpos = data.start + client:GetAimVector() * 96
			data.filter = client
		local target = util.TraceLine(data).Entity

		if (IsValid(target)) then
			local lock = ((target:GetClass() == "ix_combinelock") and target) or (target.ixLock)
			if not lock then return "Something went wrong!" end

			local str = string.lower(argument)
			for id, lockType in pairs(ix.CombineLockTypes) do
				if (ix.util.StringMatches(lockType.name, str)) then
					lock:SetLockType(id)
					return "Type set to " .. lockType.name
				end
			end
			return "Couldn't find a valid lock type for '" .. argument .. "'"
		else
			return "Not a valid combine lock!"
		end
	end

	ix.command.Add("DoorSetLockType", COMMAND)
end

/* -------------------------------------------------------------------------- */
/*                             Set Forcefield Type                            */
/* -------------------------------------------------------------------------- */

do
	local COMMAND = {}
	COMMAND.adminOnly = true
	COMMAND.alias = {"SetCombineForcefieldType"}
	COMMAND.arguments = {
		ix.type.string
	}
	COMMAND.argumentNames = {"Forcefield Type"}
	COMMAND.description = "Sets the forcefield type on the forcefield you're facing."

	function COMMAND:OnRun(client, argument)
		local trace = client:GetEyeTrace()
		local target = trace.Entity

		if IsValid(target) and target:GetClass() == "ix_forcefield" then
			local str = string.lower(argument)

			for id, forcefieldType in pairs(ix.ForcefieldTypes or {}) do
				if ix.util.StringMatches(forcefieldType[2], str) or ix.util.StringMatches(forcefieldType[4], str) then
					target:SetMode(id)
					return "Type set to " .. forcefieldType[2]
				end
			end

			return "Couldn't find a valid forcefield type for '" .. argument .. "'"
		else
			return "You're not looking at a valid forcefield!"
		end
	end

	ix.command.Add("SetForcefieldType", COMMAND)
end
