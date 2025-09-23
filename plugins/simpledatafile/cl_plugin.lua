
local PLUGIN = PLUGIN

function PLUGIN:ScreenResolutionChanged()
    if !PLUGIN.datafile or PLUGIN.datafile and !IsValid(PLUGIN.datafile) then return end
    PLUGIN.datafile:Remove()
end