
local PANEL = {}
local PLUGIN = PLUGIN

local s600, s30 = PLUGIN:SC(600), PLUGIN:SC(30)

local function FixDMenuFont(menu)
    for _, v in pairs(menu:GetChildren()[1]:GetChildren()) do
        if v:GetClassName() == "Label" then
            v:SetFont("dfButtonSmaller")
        end
    end
end

function PANEL:Init()
	self:SetSearchEnabled(false)

    for name, v in pairs(self.categories) do
        if name == "Datafile" then continue end
        v:SetTall(0)
    end

    self:ReplaceBoolWithButton("Datafile Loyalty Tiers", L("dfSet"), function()
        if ix.gui.datafileTierManager and IsValid(ix.gui.datafileTierManager) then
            ix.gui.datafileTierManager:Remove()
        end

        ix.gui.datafileTierManager = vgui.Create("ixDatafileTierManager")
        ix.gui.datafileTierManager:SetTitle(L("dfSet"))
    end)

    self:ReplaceBoolWithButton("Datafile Excluded Factions", L("dfSetExcluded"), function()
        if ix.gui.datafileExcludedFactions and IsValid(ix.gui.datafileExcludedFactions) then
            ix.gui.datafileExcludedFactions:Remove()
        end

        ix.gui.datafileExcludedFactions = vgui.Create("ixDatafileFactionManager")
        ix.gui.datafileExcludedFactions:SetTitle(L("dfSetExcluded"))
    end)

    self:ReplaceBoolWithButton("Datafile Allowed Factions", L("dfSetAllowed"), function()
        if ix.gui.datafileAllowedFactions and IsValid(ix.gui.datafileAllowedFactions) then
            ix.gui.datafileAllowedFactions:Remove()
        end

        ix.gui.datafileAllowedFactions = vgui.Create("ixDatafileAllowedFactionsManager")
        ix.gui.datafileAllowedFactions:SetTitle(L("dfSetAllowed"))
    end)
end

function PANEL:ReplaceBoolWithButton(name, buttonText, callback)
    for _, row in pairs(self.rows) do
        if row:GetText() != name then continue end
        for _, v in pairs(row:GetChildren()) do
            if v:GetName() == "ixCheckBox" then v:SetWide(0) end
        end

        local config = row:Add("DButton")
        config:Dock(RIGHT)
        config:SetText(buttonText)
        config:SetFont("ixMenuButtonFont")
        config:SizeToContents()
        config.DoClick = function()
            surface.PlaySound("helix/ui/press.wav")

            if callback then
                callback()
            end
        end
    end
end

vgui.Register("ixDatafileManager", PANEL, "ixConfigManager")

PANEL = {}

function PANEL:Init()
    self:SetSize(s600, s600)
    self:MakePopup()
    self:Center()

    PLUGIN.tierManager = self

    self.primaryColor = ix.config.Get("datafileColorPrimary")
    self.mediumColor = ix.config.Get("datafileColorMedium")

    self.content = self:Add("ixDatafileDListView")
    self.content:AddColumn( L("dfName") )
    self.content:AddColumn( L("dfPointsReq") )
    self.content:AddColumn( L("dfColor") )

    local toFix = {L("dfName"), L("dfPointsReq"), L("dfColor")}
    self.content:FixColumnWidth(s600 / 3, toFix)
    self.content:PaintColumns(self.mediumColor, "dfButton")

    local menu

	self.content.OnRowRightClick = function(list, lineId, line)
        menu = DermaMenu()
        menu:AddOption( L("dfRemove"), function()
            surface.PlaySound("helix/ui/press.wav")

            net.Start("ixDatafileRemoveTier")
            net.WriteUInt(line.tierID, 32)
            net.WriteBool(false)
            net.SendToServer()
        end )
        menu:Open()

        FixDMenuFont(menu)
    end

    self.content:CreateBottomButton(L("dfAddTier"), function()
        Derma_StringRequest(L("dfName"), L("dfInputName"), "", function(name)
            surface.PlaySound("helix/ui/press.wav")

            Derma_StringRequest(L("dfPointsReq"), L("dfPointsReqExplainer"), "", function(pointsRequired)
                if !isnumber(tonumber(pointsRequired)) then LocalPlayer():NotifyLocalized("dfNoLetters") return end
                surface.PlaySound("helix/ui/press.wav")
                net.Start("ixDatafileAddTier")
                net.WriteString(name)
                net.WriteString(pointsRequired)
                net.SendToServer()
            end)
        end
        )
    end)

    self:UpdateTiers()
end

function PANEL:UpdateTiers()
    net.Start("ixDatafileUpdateTiers")
    net.SendToServer()
end

function PANEL:Populate(tTiers)
    for _, v in pairs(self.content:GetLines()) do
        v:SetVisible(false)
    end

    for id, v in pairs(tTiers) do
        local line = self.content:AddLine( (v.name or ""), (v.pointsRequired or "0") )
        line.tierID = id
        line.color = v.color or color_white
    end

    self.content:PaintLines("dfButtonSmaller", self.primaryColor)

    for _, v in pairs(self.content:GetLines()) do
        local color = v:Add("ixSettingsRowColor")
        color:Dock(RIGHT)
        color:SetWide(s600 / 3)
        color.text:Remove()
        color.panel:Dock(FILL)
        color:SetValue(v.color)
        color.OnValueChanged = function(_, newColor)
            net.Start("ixDatafileUpdateTierColor")
            net.WriteColor(Color(newColor.r, newColor.g, newColor.b, newColor.a), true)
            net.WriteString(v.tierID)
            net.SendToServer()
        end
    end
end

vgui.Register("ixDatafileTierManager", PANEL, "ixDatafileDFrame")

PANEL = {}

function PANEL:Init()
    self:SetSize(s600, s600)
    self:MakePopup()
    self:Center()

    PLUGIN.factionManager = self

    self.primaryColor = ix.config.Get("datafileColorPrimary")
    self.mediumColor = ix.config.Get("datafileColorMedium")

    self.content = self:Add("ixDatafileDListView")
    self.content:AddColumn( L("dfExcludedFaction") )

    local toFix = {L("dfExcludedFaction")}
    self.content:FixColumnWidth(s600, toFix)
    self.content:PaintColumns(self.mediumColor, "dfButton")
    self.content.OnRemove = function(this)
        if this.choicePopup and IsValid(this.choicePopup) then
            this.choicePopup:Remove()
        end
    end

    local menu

	self.content.OnRowRightClick = function(list, lineId, line)
        menu = DermaMenu()
        menu:AddOption( L("dfRemove"), function()
            surface.PlaySound("helix/ui/press.wav")

            net.Start("ixDatafileRemoveExcludedFaction")
            net.WriteString(line.factionUnique)
            net.SendToServer()
        end )
        menu:Open()

        FixDMenuFont(menu)
    end

    self.content:CreateBottomButton(L("dfAddExcludedFaction"), function()
        self.content.choicePopup = vgui.Create("ixDatafileDFrame")
        self.content.choicePopup:MakePopup()
        self.content.choicePopup:SetSize(self:GetWide() / 2, self:GetTall() / 2)
        self.content.choicePopup:Center()
        self.content.choicePopup:SetTitle(L("dfAddExcludedFaction"))

        local content = self.content.choicePopup:Add("DScrollPanel")
        content:Dock(FILL)

        for _, v in pairs(ix.faction.teams) do
            local faction = content:Add("DButton")
            faction:Dock(TOP)
            faction:SetTall(s30)
            faction:SetFont("dfButtonSmaller")
            faction:DockMargin(0, 0, 0, s30 / 3)
            faction:SetText(v.name)
            faction.Paint = function(this, w, h)
                surface.SetDrawColor(self.mediumColor)
                surface.DrawRect(0, 0, w, h)
            end

            faction.DoClick = function()
                surface.PlaySound("helix/ui/press.wav")

                net.Start("ixDatafileAddExcludedFaction")
                net.WriteString(v.uniqueID)
                net.SendToServer()
            end
        end
    end)

    self:UpdateExcludedFactions()
end

function PANEL:UpdateExcludedFactions()
    net.Start("ixDatafileUpdateExcludedFactions")
    net.SendToServer()
end

function PANEL:Populate(tExcludedFactions)
    for _, v in pairs(self.content:GetLines()) do
        v:SetVisible(false)
    end

    for _, v in pairs(tExcludedFactions) do
        local line = self.content:AddLine( (ix.faction.teams[v] and ix.faction.teams[v].name or "") )
        line.factionUnique = v
    end

    self.content:PaintLines("dfButtonSmaller", self.primaryColor)
end

vgui.Register("ixDatafileFactionManager", PANEL, "ixDatafileDFrame")

PANEL = {}

function PANEL:Init()
    self:SetSize(s600, s600)
    self:MakePopup()
    self:Center()

    PLUGIN.allowedFactionManager = self

    self.primaryColor = ix.config.Get("datafileColorPrimary")
    self.mediumColor = ix.config.Get("datafileColorMedium")

    self.content = self:Add("ixDatafileDListView")
    self.content:AddColumn( L("dfAllowedFaction") )

    local toFix = {L("dfAllowedFaction")}
    self.content:FixColumnWidth(s600, toFix)
    self.content:PaintColumns(self.mediumColor, "dfButton")
    self.content.OnRemove = function(this)
        if this.choicePopup and IsValid(this.choicePopup) then
            this.choicePopup:Remove()
        end
    end

    local menu

	self.content.OnRowRightClick = function(list, lineId, line)
        menu = DermaMenu()
        menu:AddOption( L("dfRemove"), function()
            surface.PlaySound("helix/ui/press.wav")

            net.Start("ixDatafileRemoveAllowedFaction")
            net.WriteString(line.factionUnique)
            net.SendToServer()
        end )
        menu:Open()

        FixDMenuFont(menu)
    end

    self.content:CreateBottomButton(L("dfAddAllowedFaction"), function()
        self.content.choicePopup = vgui.Create("ixDatafileDFrame")
        self.content.choicePopup:MakePopup()
        self.content.choicePopup:SetSize(self:GetWide() / 2, self:GetTall() / 2)
        self.content.choicePopup:Center()
        self.content.choicePopup:SetTitle(L("dfAddAllowedFaction"))

        local content = self.content.choicePopup:Add("DScrollPanel")
        content:Dock(FILL)

        for _, v in pairs(ix.faction.teams) do
            local faction = content:Add("DButton")
            faction:Dock(TOP)
            faction:SetTall(s30)
            faction:SetFont("dfButtonSmaller")
            faction:DockMargin(0, 0, 0, s30 / 3)
            faction:SetText(v.name)
            faction.Paint = function(this, w, h)
                surface.SetDrawColor(self.mediumColor)
                surface.DrawRect(0, 0, w, h)
            end

            faction.DoClick = function()
                surface.PlaySound("helix/ui/press.wav")

                net.Start("ixDatafileAddAllowedFaction")
                net.WriteString(v.uniqueID)
                net.SendToServer()
            end
        end
    end)

    self:UpdateAllowedFactions()
end

function PANEL:UpdateAllowedFactions()
    net.Start("ixDatafileUpdateAllowedFactions")
    net.SendToServer()
end

function PANEL:Populate(tAllowedFactions)
    for _, v in pairs(self.content:GetLines()) do
        v:SetVisible(false)
    end

    for _, v in pairs(tAllowedFactions) do
        local line = self.content:AddLine( (ix.faction.teams[v] and ix.faction.teams[v].name or "") )
        line.factionUnique = v
    end

    self.content:PaintLines("dfButtonSmaller", self.primaryColor)
end

vgui.Register("ixDatafileAllowedFactionsManager", PANEL, "ixDatafileDFrame")

hook.Add("MenuSubpanelCreated", "ixRemoveDatafileCategory", function(subpanelName, panel)
    if subpanelName != "config" then return end

    local configManager = false
    for _, v in pairs(panel:GetChildren()) do
        if v:GetName() != "ixConfigManager" then continue end

        configManager = v
    end


    if configManager and IsValid(configManager) then
        if !configManager.categories then return end
        for name, v in pairs(configManager.categories) do
            if name != "Datafile" then continue end
            if !IsValid(v) then continue end

            v:SetTall(0)
        end
    end
end)

hook.Add("CreateMenuButtons", "ixDatafile", function(tabs)
    if (!CAMI.PlayerHasAccess(LocalPlayer(), "Helix - Manage Config", nil)) then
        return
    end

    tabs["config"].Sections[L("dfConfig")] = {
        Create = function(info, container)
            ix.gui.datafileManager = container:Add("ixDatafileManager")
        end
    }
end)