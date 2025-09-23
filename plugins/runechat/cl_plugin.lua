/* -------------------------------------------------------------------------- */
/*                               Config & Setup                               */
/* -------------------------------------------------------------------------- */
local PLUGIN = PLUGIN



-- ix.option.Add(key, optionType, default, data)
ix.option.Add("runechatEnable", ix.type.bool, true)

runechat = runechat or {}
runechat.messages = runechat.messages or {}
runechat.opacity = 190 -- Overall opacity for runechat
runechat.font = "runechat"
runechat.fontYell = "runechatYell"
runechat.fontWhisper = "runechatWhisper"
runechat.fontAction = "runechat"
runechat.fontRadio = "runechat"

local allowedClasses = {
    ["ic"] = true,
    ["y"] = true,
    ["w"] = true,
    ["me"] = true,
    ["mel"] = true,
    ["mec"] = true,
    ["looc"] = false, -- Enable LOOC here.
    ["ooc"] = false, -- Enable OOC here.
    ["radio"] = true, -- Enable Radio here.
    ["radio_eavesdrop"] = true, -- Enable Radio Eavesdrop here.
    ["request"] = true, -- Enable Request Device here
}

local classFormat = {
    ["ic"]      = "\"%s\"",
    ["y"]    = "\"%s\"",
    ["w"] = "\"%s\"",
    ["looc"]    = "[%s]",
    ["ooc"]     = "[%s]",
    ["radio"]   = ": %s :",
    ["radio_eavesdrop"]   = ": %s :",
    ["request"] = "! %s !",
    ["me"]      = "** %s",
    ["mec"]      = "* %s",
    ["mel"]      = "**** %s",
}

local classFonts = {
    ["ic"]      = runechat.font,
    ["y"]    = runechat.fontYell,
    ["w"] = runechat.fontWhisper,
    ["looc"]    = runechat.font,
    ["ooc"]     = runechat.font,
    ["radio"]   = runechat.font,
    ["request"] = runechat.font,
    ["me"]      = runechat.font,
    ["mel"]      = runechat.fontYell,
    ["mec"]      = runechat.fontWhisper
}

/* -------------------------------------------------------------------------- */
/*                                    Fonts                                   */
/* -------------------------------------------------------------------------- */
local FONT_USED = ix.config.Get("font") or "Courier New"

surface.CreateFont("runechat", {
    size = math.max(ScreenScale(8), 18) * ix.option.Get("chatFontScale", 1),
    weight = 400, 
    antialias = true,
    font = FONT_USED,
    italic = false,
});

surface.CreateFont("runechatWhisper", {
    size = math.max(ScreenScale(4), 18) * ix.option.Get("chatFontScale", 1),
    weight = 400, 
    antialias = true,
    font = FONT_USED,
    italic = true,
});

surface.CreateFont("runechatYell", {
    size = math.max(ScreenScale(16), 18) * ix.option.Get("chatFontScale", 1),
    weight = 400, 
    antialias = true,
    font = FONT_USED,
    italic = false,
});

/* -------------------------------------------------------------------------- */
/*                                  Rendering                                 */
/* -------------------------------------------------------------------------- */

local function IsPlayerVisibleToLocalPlayer(ply)
    local traceData = {
        start = LocalPlayer():EyePos(),
        endpos = ply:EyePos(),
        filter = {LocalPlayer(), ply}
    }
    local trace = util.TraceLine(traceData)
    return not trace.Hit or trace.Entity == ply
end

hook.Add("PostDrawEffects", "ixRunechatRender", function()
    if (!ix.option.Get("runechatEnable", true)) then return end
    local minPlayers = math.Round(ix.config.Get("runechatMinimumPlayers", 1))
    local range = math.Round(ix.config.Get("runechatMaxRange", 2048))

    for _, ply in ipairs(player.GetAll()) do
        if not IsValid(ply) or not ply:Alive() then continue end
        if not IsPlayerVisibleToLocalPlayer(ply) then continue end
        if (ply:GetMoveType() == MOVETYPE_NOCLIP) then continue end
        if (ply == LocalPlayer() and (!ix.option.Get("thirdpersonEnabled", false))) then continue end

        local nearbyCount = 0
        -- Count players within the specified range
        for _, other in ipairs(player.GetAll()) do
            if not IsValid(other) or not other:Alive() then continue end -- (or other == ply) add this to stop counting yourself.
            if ply:GetPos():DistToSqr(other:GetPos()) <= (range * range) then
                nearbyCount = nearbyCount + 1
            end
        end

        -- Adjust opacity based on player proximity or count
        if nearbyCount < minPlayers then
            runechat.opacity = math.max(runechat.opacity - FrameTime() * 100, 0)
        else
            runechat.opacity = math.min(runechat.opacity + FrameTime() * 100, 190)
        end

        if runechat.opacity <= 0 then continue end -- Skip if completely faded

        local messages = runechat.messages[ply]
        if not messages or #messages == 0 then continue end

        local height = 12
        local bone = ply:LookupBone("ValveBiped.Bip01_Head1")
        local pos = ply:GetPos() + Vector(0, 0, 64+height)
        if bone then
            local pos = ply:GetBonePosition(bone) + Vector(0,0,height)
        end
        local offsetY = 0
        for i = #messages, 1, -1 do -- Draw messages in reverse order
            local runemsg = messages[i]
            if not runemsg or not runemsg.text then continue end

            local ixChatClass = ix.chat.classes[runemsg.class]
            local remainingTime = runemsg.time - CurTime()
            local messageOpacity = runechat.opacity
            
            -- If ragdolled, fade faster.
            if (IsValid(ply.ixRagdoll)) then
                if (remainingTime > 2) then
                    runemsg.time = CurTime() + 1
                end
            end

            -- Fade messages with less than 2 seconds left
            if remainingTime <= 2 then
                messageOpacity = math.max((remainingTime / 2) * 255, 0)
            end
            
            -- Respect overall opacity
            messageOpacity = math.min(messageOpacity, runechat.opacity)            

            

            local color = ixChatClass.color or Color(255,255,255)
            color.a = messageOpacity

            local font = classFonts[runemsg.class] or runechat.font or "Monofonto"
            
            local screenPos = (pos + Vector(0, 0, offsetY)):ToScreen()
            if screenPos.visible then
                cam.Start2D()
                draw.NoTexture()
                surface.SetDrawColor(color)
                draw.SimpleTextOutlined(
                    runemsg.text,
                    font,
                    screenPos.x,
                    screenPos.y,
                    color,
                    TEXT_ALIGN_CENTER,
                    TEXT_ALIGN_CENTER,
                    0.5,
                    Color(0,0,0, messageOpacity)
                )
                cam.End2D()
            end
            offsetY = offsetY + 6 -- Spacing between messages
        end
    end
end)

/* -------------------------------------------------------------------------- */
/*                                 Processing                                 */
/* -------------------------------------------------------------------------- */

function AddRunechatMessage(ply, text, class)
    if not IsValid(ply) then return end
    local maxMessages = math.floor(ix.config.Get("runechatMaxMessages", 4))
    local messageLength = math.floor(ix.config.Get("runechatMessageLength", 256))
    local class = class or "ic"
    local text = text
    
    local formattedText = string.sub(text, 1, messageLength) -- Truncate to max length
    if (string.len(text) > messageLength) then 
        formattedText = formattedText .. "..."
    end
    formattedText = string.format(classFormat[class] or "%s", formattedText)

    runechat.messages[ply] = runechat.messages[ply] or {}
    local runemsg = {
        text = formattedText,
        time = CurTime() + (ix.config.Get("runechatMessageTime", 60)),
        class = class
    }

    table.insert(runechat.messages[ply], runemsg)

    -- Remove oldest messages if exceeding maxMessages
    if #runechat.messages[ply] > maxMessages then
        table.remove(runechat.messages[ply], 1)
    end
end

function PLUGIN:Think()
    for ply, messages in pairs(runechat.messages) do
        for i = #messages, 1, -1 do
            local runemsg = messages[i]
            if runemsg.time <= CurTime() then
                table.remove(messages, i) -- Remove expired messages
            end
        end

        -- Remove the player entry if no messages left
        if #messages == 0 then
            runechat.messages[ply] = nil
        end
    end
end


-- local info = {
--     chatType = chatType,
--     text = text,
--     anonymous = anonymous,
--     data = data
-- }

hook.Add("MessageReceived", "ixRunechatMessageReceived", function (client, info)
    if (info.anonymous == true) then return end
    local text = info.text
    local class = info.chatType
    local allowed = (allowedClasses[class] == true)
    if !allowed then return end
    AddRunechatMessage(client, text, class)
end)