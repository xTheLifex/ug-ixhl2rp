function PLUGIN:InitializedPlugins()
    self.pflags = ix.plugin.Get("playerflags") or ix.plugin.Get("sh_playerflags")
end
