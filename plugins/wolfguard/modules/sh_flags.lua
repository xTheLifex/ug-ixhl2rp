/* -------------------------------------------------------------------------- */
/*                               Flag Management                              */
/* -------------------------------------------------------------------------- */
if not SERVER then return end
do
    /* ----------------------------- Character Flags ---------------------------- */

    function PLUGIN:GiveCharacterFlags(character, flags)
        
    end

    function PLUGIN:TakeCharacterFlags(character, flags)
        
    end

    /* ------------------------------ Player Flags ------------------------------ */

    function PLUGIN:GivePlayerFlags(client, flags)
        self.pflags:GivePlayerFlags(client, flags)
    end 

    function PLUGIN:TakePlayerFlags(client, flags)
        self.pflags:TakePlayerFlags(client, flags)
    end

    function PLUGIN:GivePlayerAllFlags(client, flags)
        self.pflags:GivePlayerAllFlags(client)
    end
end