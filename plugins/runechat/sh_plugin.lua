/* -------------------------------------------------------------------------- */
/*                                  RUNECHAT                                  */
/* -------------------------------------------------------------------------- */


local function AddConfig(key, default, desc, callback, data)
    ix.config.Add(key, default, desc, callback, {
        category = "Runechat",
        data = data or {}
    })
end


AddConfig("runechatMinimumPlayers", 1, "Minimum players before runechat shows up.", nil, {min = 1, max = 12})
AddConfig("runechatMessageLength", 256, "Message Length for runechat text.", nil, {min = 1, max = 512})
AddConfig("runechatMessageTime", 32, "Time runechat text stays on screen.", nil, {min = 1, max = 120})
AddConfig("runechatMaxMessages", 4, "The maximum amount of messages allowed to display.", nil, {min = 1, max = 12})
AddConfig("runechatMaxRange", 2048, "The range to consider activating runechat if crowded..", nil, {min = 1, max = 2048})

ix.util.Include("cl_plugin.lua");

