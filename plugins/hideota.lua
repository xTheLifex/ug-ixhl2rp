PLUGIN.name     = 'Hide OTA'
PLUGIN.author   = 'TheLife'
PLUGIN.description = "Hides OTA from scoreboard."

if CLIENT then
    function PLUGIN:ShouldShowPlayerOnScoreboard(client)
        local character = client:GetCharacter()
        local myCharacter = LocalPlayer():GetCharacter()

        if (character:GetFaction() == FACTION_OTA) then 
            if (!LocalPlayer():IsCombine()) and (myCharacter:GetFaction() != FACTION_ADMIN) then
                return false
            end
        end
    end
end
