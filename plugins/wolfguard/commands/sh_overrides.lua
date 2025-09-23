local PLUGIN = PLUGIN
local gray = Color(125,125,125)
local highlight = Color(43,147,189)
local white = Color(255,255,255)

-- Helper function to override a command
local function OverrideCommand(name, data)
    local command = ix.command.list[name:lower()]
    if not command then return end

    for key, value in pairs(data) do
        command[key] = value
    end
end


-- Define all overrides here
local overrides = {}

/* -------------------------------------------------------------------------- */
/*                                CharGiveFlag                                */
/* -------------------------------------------------------------------------- */

overrides["CharGiveFlag"] = {
    OnRun = function(self, client, target, flags)
		-- show string request if no flags are specified
		if (!flags) then
			local available = ""

			-- sort and display flags the character already has
			for k, _ in SortedPairs(ix.flag.list) do
				if (!target:HasFlags(k)) then
					available = available .. k
				end
			end

			return client:RequestString("@flagGiveTitle", "@cmdCharGiveFlag", function(text)
				ix.command.Run(client, "CharGiveFlag", {target:GetName(), text})
			end, available)
		end

		target:GiveFlags(flags)
        PLUGIN:AlertAdminsOption("wgPrintDefaultCommands", client, "has given ", target:GetPlayer(), " \"", highlight, flags, white, "\" flags.")
		for _, v in player.Iterator() do
			if (self:OnCheckAccess(v) or v == target:GetPlayer()) then
				v:NotifyLocalized("flagGive", client:GetName(), target:GetName(), flags)
			end
		end
    end,
    arguments = {
        ix.type.character,
        bit.bor(ix.type.string, ix.type.optional)
    }
}

/* -------------------------------------------------------------------------- */
/*                                CharTakeFlag                                */
/* -------------------------------------------------------------------------- */

overrides["CharTakeFlag"] = {
    OnRun = function (self, client, target, flags)
        if (!flags) then
			return client:RequestString("@flagTakeTitle", "@cmdCharTakeFlag", function(text)
				ix.command.Run(client, "CharTakeFlag", {target:GetName(), text})
			end, target:GetFlags())
		end

		target:TakeFlags(flags)
        PLUGIN:AlertAdminsOption("wgPrintDefaultCommands", client, "has taken \"", highlight, flags, white, "\" flags from ", target:GetPlayer())
		for _, v in player.Iterator() do
			if (self:OnCheckAccess(v) or v == target:GetPlayer()) then
				v:NotifyLocalized("flagTake", client:GetName(), flags, target:GetName())
			end
		end
    end,
    arguments = {
        ix.type.character,
        bit.bor(ix.type.string, ix.type.optional)
    }
}


/* -------------------------------------------------------------------------- */
/*                                CharSetModel                                */
/* -------------------------------------------------------------------------- */

overrides["CharSetModel"] = {
    OnRun = function(self, client, target, model)
        target:SetModel(model)
        target:GetPlayer():SetupHands()

        if (not model or model:len() == 0) then
            return client:RequestString("Model", "Change the target's model to the one specified.", function(text)
                ix.command.Run(client, "CharSetModel", {target:GetName(), text})
            end, client:GetModel())
        end

        PLUGIN:AlertAdminsOption("wgPrintDefaultCommands", client, "has changed ", target:GetPlayer(), "'s model to ", gray, model)
        for _, v in player.Iterator() do
            if (self:OnCheckAccess(v) or v == target:GetPlayer()) then
                v:NotifyLocalized("cChangeModel", client:GetName(), target:GetName(), model)
            end
        end
    end,
    arguments = {
        ix.type.character,
        bit.bor(ix.type.string, ix.type.optional)
    }
}

/* -------------------------------------------------------------------------- */
/*                                 CharSetSkin                                */
/* -------------------------------------------------------------------------- */

overrides["CharSetSkin"] = {
    OnRun = function (self, client, target, skin)
        target:SetData("skin", skin)
		target:GetPlayer():SetSkin(skin or 0)

        PLUGIN:AlertAdminsOption("wgPrintDefaultCommands", client, " has set ", target:GetPlayer(), "'s skin to ", skin or 0)
		for _, v in player.Iterator() do
			if (self:OnCheckAccess(v) or v == target:GetPlayer()) then
				v:NotifyLocalized("cChangeSkin", client:GetName(), target:GetName(), skin or 0)
			end
		end
    end
}


-- Apply all overrides
for name, data in pairs(overrides) do
    OverrideCommand(name, data)
end
