local PLUGIN = PLUGIN

if (SERVER) then

    util.AddNetworkString("wgSendChat")
    function PLUGIN:AlertAdmins(...)
        local filter = RecipientFilter()
        for _,ply in player.Iterator() do
            if (ply:IsAdmin()) then
                filter:AddPlayer(ply)
            end 
        end
        net.Start("wgSendChat")
        net.WriteTable({...})
        net.Send(filter)
    end    

    function PLUGIN:AlertAdminsOption(opt, ...)
        local filter = RecipientFilter()
        for _,ply in player.Iterator() do
            if (ply:IsAdmin() and ix.option.Get(ply, opt)) then
                filter:AddPlayer(ply)
            end 
        end
        net.Start("wgSendChat")
        net.WriteTable({...})
        net.Send(filter)
    end    

    function PLUGIN:SendChat(receivers, ...)
        if not receivers then return end

        if (IsValid(receivers) and istable(receivers)) then
            local filter = RecipientFilter()
            for _,ply in ipairs(receivers) do
                filter:AddPlayer(ply)
            end

            net.Start("wgSendChat")
            net.WriteTable({...})
            net.Send(filter)
            return
        elseif(isentity(receivers) and receivers:IsPlayer()) then
            net.Start("wgSendChat")
            net.WriteTable({...})
            net.Send(receivers)
            return
        end

        self:Error("Failed to parse SendChat parameters. Not a table or player.")
    end
end

if (CLIENT) then
    function PLUGIN:SendChat(...)
        local final = {Color(0,155,255), "[WG] ", Color(255,255,255)}
        local data = {...}
        
        for i = 1, #data do
            local item = data[i]
            if IsEntity(item) and item:IsPlayer() then
                table.insert(final, Color(0, 110, 255))
                table.insert(final, item:SteamName())
                table.insert(final, Color(255,255,255))
                table.insert(final, " (")
                table.insert(final, item)
                table.insert(final, Color(255,255,255))
                table.insert(final, ") ")
            else
                table.insert(final, item)
            end
        end
        
        chat.AddText(unpack(final))
    end

    net.Receive("wgSendChat", function ()
        local data = net.ReadTable()
        if not data then return end
        PLUGIN:SendChat(unpack(data))
    end)
end