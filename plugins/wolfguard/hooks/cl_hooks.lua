/* -------------------------------------------------------------------------- */
/*                             Scoreboard Options                             */
/* -------------------------------------------------------------------------- */

function PLUGIN:PopulateScoreboardPlayerMenu(client, menu)
    -- ix.command.Run(client, "CharSetName", {target:GetName(), text})

    if (!LocalPlayer():IsAdmin()) then return end

    menu:AddOption("Set Name", function ()
        ix.command.Send("CharSetName", client:Nick())
    end)

    menu:AddOption("Set Description", function ()
        ix.command.Send("CharSetDesc", client:Nick())
    end)
end

function PLUGIN:IsPlayerRecognized(other)
    if (ix.option.Get("wgRecognizeBypass", false)) then return true end
end    