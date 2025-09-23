
local PLUGIN = PLUGIN

function PLUGIN:VerticalScale( size )
	return size * ( ScrH() / 360.0 )
end

function PLUGIN:SC( size )
	return math.Round(math.min(SScale(size), PLUGIN:VerticalScale(size)) / 3, 0)
end

local function SC(size)
	return PLUGIN:SC(size)
end

function PLUGIN:LoadFonts(font, genericFont)
    surface.CreateFont("dfExitButton", {
        font = genericFont,
        size = SC(20),
        extended = true,
        weight = 700
    })

    surface.CreateFont("dfTitle", {
        font = genericFont,
        size = SC(60),
        extended = true,
        weight = 700
    })

    surface.CreateFont("dfTitleSmaller", {
        font = genericFont,
        size = SC(40),
        extended = true,
        weight = 700
    })

    surface.CreateFont("dfSubtext", {
        font = genericFont,
        size = SC(20),
        extended = true,
        weight = 300
    })

    surface.CreateFont("dfButton", {
        font = genericFont,
        size = SC(18),
        extended = true,
        weight = 700
    })

    surface.CreateFont("dfButtonSmaller", {
        font = genericFont,
        size = SC(16),
        extended = true,
        weight = 700
    })

    surface.CreateFont("dfButtonNoBold", {
        font = genericFont,
        size = SC(18),
        extended = true,
        weight = 300
    })
end

local s650, s850, s20, s30, s40, s100, s68, s126 = SC(650), SC(850), SC(20), SC(30), SC(40), SC(100), SC(68), SC(126)
local s67, s145, s153, s200, s120, s70, s56, s125 = SC(67), SC(145), SC(153), SC(200), SC(120), SC(70), SC(56), SC(125)
local s115, s36, s10, s33, s112, s260, s65, s13 = SC(115), SC(36), SC(10), SC(33), SC(112), SC(260), SC(65), SC(13)
local s140, s5, s1, s4 = SC(140), SC(5), SC(1), SC(4)

local fadeInTime = 0.5
local lightUpDuration = 2 -- Duration in seconds for the full transition

local clFadeInDuration = 0.5
local clStayDuration = 0.5
local clMoveAndResizeDuration = 0.5 -- Duration for moving and resizing logo

local PANEL = {}

function PANEL:Init()
    surface.PlaySound(ix.config.Get("datafileStartupSound"))
    self:SetSize(s650, s850)
    self:MakePopup()
    self:Center()
    self:SetAlpha(0)
    self:AlphaTo(255, fadeInTime, 0)
    self:DockPadding(s70, s30, s30, s30)

    self.startTime = CurTime()
    self.pulseOffsetTime = CurTime()

    self.logoSize = s200
    self.logoFactor = 1.0
    self.combineLogoAlpha = 0
    self.combineLogoRoundPolyAlpha = 0

    self:NoClipping(true)

    self.primaryColor = ix.config.Get("datafileColorPrimary")
    self.darkPrimaryColor = Color(self.primaryColor.r * 0.6, self.primaryColor.g * 0.6, self.primaryColor.b * 0.6, 255)
    self.bgColor = ix.config.Get("datafileColorBG")
    self.mediumColor = ix.config.Get("datafileColorMedium")
    self.darkColor = ix.config.Get("datafileColorDark")
    self.subtextColor = ix.config.Get("datafileColorSubtext")
    self.green = ix.config.Get("datafileColorGreen")
    self.red = ix.config.Get("datafileColorRed")
    self.staticRed, self.staticGreen = Color(213, 20, 61, 255), Color(16, 187, 76, 255)

    self:CreateClose()
    self:CreateTitle()
    self:CreateInfoText()
    self:CreateNotesSection()
    self:CreateButtonPanel()
end

function PANEL:CreateClose()
    local close = self:Add("DButton")
    close:SetFont("dfExitButton")
    close:SetText(L("dfClose"))
    close:SetTextColor(self.primaryColor)
    close:SetContentAlignment(5)
    close:SetSize(s100, s30)
    close:SetPos(self:GetWide() - close:GetWide() - s10, s10)
    close.DoClick = function()
        surface.PlaySound(ix.config.Get("datafileCloseSound"))
        self:Remove()
    end

    close.Paint = function(this, w, h)
        surface.SetDrawColor(self.mediumColor)
        surface.DrawRect(0, 0, w, h)
    end
end

function PANEL:CreateTitle()
    self.title = self:Add("DLabel")
    self.title:SetFont("dfTitle")
    self.title:SetText(L("dfUnknown"))
    self.title:SizeToContents()
    self.title:Dock(TOP)
    self.title:DockMargin(0, 0, 0, 0)
    self.title:SetAlpha(0)
    self.title:AlphaTo(255, fadeInTime, lightUpDuration)
    self.title.bolBlink = false

    self.title.lastBlinkTime = SysTime()
    self.title.blinkInterval = 0.5

    self.title.Think = function()
        if self.title.bolBlink then
            local currentTime = SysTime()
            if currentTime - self.title.lastBlinkTime >= self.title.blinkInterval then
                local isRed = self.title:GetColor().r == 213
                self.title:SetTextColor(isRed and color_white or self.staticRed)
                self.title.lastBlinkTime = currentTime
            end
        else
            self.title:SetTextColor(color_white)
        end
    end

    self.cid = self:Add("DLabel")
    self.cid:SetFont("dfTitleSmaller")
    self.cid:SetText("##00000")
    self.cid:SetTextColor(self.subtextColor)
    self.cid:SizeToContents()
    self.cid:Dock(TOP)
    self.cid:DockMargin(0, 0, 0, s20)
    self.cid:SetAlpha(0)
    self.cid:AlphaTo(255, fadeInTime, lightUpDuration)

    self:CreateAnimatedHorizontalSep(self, s30)
end

function PANEL:CreateInfoText()
    self.infoText = self:Add("Panel")
    self.infoText:Dock(TOP)
    self.infoText:SetAlpha(0)
    self.infoText:AlphaTo(255, fadeInTime, lightUpDuration)
    self.infoText:DockMargin(0, 0, 0, s30)
    self.infoText.rows = {}

    self.infoText.left = self.infoText:Add("Panel")
    self.infoText.left:Dock(LEFT)
    self.infoText.left:DockMargin(0, 0, s30, 0)

    self.infoText.right = self.infoText:Add("Panel")
    self.infoText.right:Dock(FILL)
    self.infoText.right:DockPadding(s30, 0, 0, 0)
    self.infoText.right.Paint = function(this, w, h)
        surface.SetDrawColor(self.primaryColor)
        surface.DrawLine(0, 0, 0, h)
    end
end

function PANEL:CreateInfoTextRow(parent, title, text, textColor)
    local row = parent:Add("Panel")
    row:Dock(TOP)
    row:DockMargin(0, 0, 0, s10)

    local titleLabel = row:Add("DLabel")
    titleLabel:Dock(LEFT)
    titleLabel:SetText((title or "N/A")..": ")
    titleLabel:SetFont("dfExitButton")
    titleLabel:SizeToContents()

    row.textLabel = row:Add("DLabel")
    row.textLabel:Dock(LEFT)
    row.textLabel:SetText(text or "N/A")
    row.textLabel:SetTextColor(textColor or self.subtextColor)
    row.textLabel:SetFont("dfSubtext")
    row.textLabel:SizeToContents()

    row:SetTall(math.max(row.textLabel:GetTall(), titleLabel:GetTall()))

    parent:SetWide(math.max(parent:GetWide(), titleLabel:GetWide() + row.textLabel:GetWide()))

    local rowH = row:GetTall() + s10
    self.infoText:SetTall(math.min(self.infoText:GetTall() + rowH, rowH * 3 - s10 )) -- max rows 3 and get rid of last margin

    self.infoText.rows[#self.infoText.rows + 1] = row

    return row
end

function PANEL:CreateNotesSection()
    self.notes = self:Add("Panel")
    self.notes:Dock(FILL)
    self.notes:SetAlpha(0)
    self.notes:AlphaTo(255, fadeInTime, lightUpDuration)
    self.notes.Paint = function(this, w, h)
        surface.SetDrawColor(self.primaryColor)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    self.notes.buttonRow = self.notes:Add("Panel")
    self.notes.buttonRow:Dock(TOP)
    self.notes.buttonRow:SetTall(s30)
    self.notes.buttonRow.buttons = {}

    self.notes.content = self.notes:Add("DScrollPanel")
    self.notes.content:Dock(FILL)
    self.notes.content.rows = {}

    self.notes.navigationRow = self.notes:Add("Panel")
    self.notes.navigationRow:Dock(BOTTOM)
    self.notes.navigationRow:SetTall(s30)
    self.notes.navigationRow:DockPadding(0, 0, s5, 0)
    self.notes.navigationRow.Paint = function(this, w, h)
        surface.SetDrawColor(self.primaryColor)
        surface.DrawRect(0, 0, w, h)
    end

    self.curPage = self.notes.navigationRow:Add("DLabel")
    self.curPage:SetFont("dfButtonSmaller")
    self.curPage:SetText(L("dfPage")..": "..(self.notes.currentPage or 1))
    self.curPage:Dock(LEFT)
    self.curPage:DockMargin(s10, 0, 0, 0)
    self.curPage:SizeToContents()

    self.next = self:CreateNavigationButton(self.notes.navigationRow, true)
    self.previous = self:CreateNavigationButton(self.notes.navigationRow)

    self.headerButtons = {}
    self.notesButton = self:CreateNotesButton(L("dfNotes"), 1)
    self.loyalistButton = self:CreateNotesButton(L("dfLoyalistActivity"), 2)
    self.medicalRecords = self:CreateNotesButton(L("dfMedicalRecords"), 3)
end

function PANEL:CreateNavigationButton(parent, bNext)
    local button = parent:Add("DButton")
    button:SetText(bNext and L("dfNextPage") or L("dfPreviousPage"))
    button:SetFont("dfButtonSmaller")
    button:Dock(RIGHT)
    button:SizeToContents()
    button:DockMargin(s5, s5, 0, s5)
    button.Paint = nil

    button.DoClick = function()
        surface.PlaySound(ix.config.Get("datafileButtonNavSound"))

        net.Start("ixDatafileUpdateNotes")
        net.WriteUInt(self.datafileID, 32)
        net.WriteUInt(self.notes.currentType, 2)
        net.WriteUInt(self.notes.currentPage, 32)
        net.WriteBool(bNext)
        net.SendToServer()
    end

    return button
end

function PANEL:CreateNotesButton(text, noteType)
    local button = self.notes.buttonRow:Add("DButton")
    button:SetText(text or "")
    button:SetFont("dfButton")
    button:Dock(LEFT)
    button.type = noteType

    self.notes.buttonRow.buttons[#self.notes.buttonRow.buttons + 1] = button

    for k, v in pairs(self.notes.buttonRow.buttons) do
        v:SetWide(math.max(self.notes.buttonRow:GetWide(),
        (s650 - s100) / #self.notes.buttonRow.buttons) + (k == 3 and s1 or 0))
    end

    button.Paint = function(this, w, h)
        if this.active then
            surface.SetDrawColor(self.primaryColor)
        else
            surface.SetDrawColor(self.mediumColor)
        end

        surface.DrawRect(0, 0, w, h)

        surface.SetDrawColor(self.primaryColor)
        surface.DrawOutlinedRect(0, 0, w, h)
    end

    button.DoClick = function(this, shouldNotPlaySound)
        if !shouldNotPlaySound then
            surface.PlaySound(ix.config.Get("datafileButtonHeaderSound"))
        end

        self.notes.currentPage = 1
        self.notes.currentType = tonumber(noteType)

        net.Start("ixDatafileUpdateNotes")
        net.WriteUInt(self.datafileID, 32)
        net.WriteUInt(self.notes.currentType, 2)
        net.WriteUInt(self.notes.currentPage, 32)
        net.SendToServer()
    end

    self.headerButtons[#self.headerButtons + 1] = button

    return button
end

function PANEL:CreateNotesRow(bSecond, tNoteData)
    local row = self.notes.content:Add("Panel")
    row:Dock(TOP)
    row:SetTall(s65)
    row:DockPadding(s20, s13, s20, s13)
    row.Paint = function(this, w, h)
        if !bSecond then
            surface.SetDrawColor(self.darkColor)
        else
            surface.SetDrawColor(self.mediumColor)
        end

        surface.DrawRect(1, 0, w - 2, h - 1)
    end

    row.left = row:Add("Panel")
    row.left:Dock(FILL)
    row.left:DockMargin(0, 0, s30, 0)

    self:CreateNotesRowText(row.left, tNoteData.text or L("dfNotAvailable"))

    local actionRow = row.left:Add("Panel")
    actionRow:Dock(TOP)

    local button = actionRow:Add("DButton")
    button:Dock(LEFT)
    button:SetText(L("dfViewNote"))
    button:SetFont("dfButton")
    button:SetContentAlignment(4)
    button:SizeToContents()
    button.Paint = nil
    button.DoClick = function()
        surface.PlaySound(ix.config.Get("datafileButtonClickSound"))

        self:CreatePopupWindow("dfViewNote", tNoteData.text, nil, function()
            net.Start("ixDatafileRemoveNote")
            net.WriteUInt(self.datafileID, 32)
            net.WriteUInt(tNoteData.type, 2)
            net.WriteUInt(tNoteData.id, 32)
            net.SendToServer()
        end, L("dfRemove"), false)
    end

    if tonumber(tNoteData.type) == 2 then
        local divider = actionRow:Add("DShape")
        divider:SetType("Rect")
        divider:Dock(LEFT)
        divider:SetWide(1)
        divider:DockMargin(0, s4, s5, s4)
        divider:SetColor(color_white)

        local points = actionRow:Add("DLabel")
        points:SetFont("dfButton")
        points:Dock(LEFT)
        points:SetText(L("dfPoints").." "..(tNoteData.points or "0"))
        points:SizeToContents()

        if tNoteData.points then
            tNoteData.points = tonumber(tNoteData.points)
            if tNoteData.points < 0 then points:SetTextColor(self.staticRed) end
            if tNoteData.points > 0 then points:SetTextColor(self.staticGreen) end
        end
    end

    actionRow:SetTall(button:GetTall())

    row.right = row:Add("Panel")
    row.right:Dock(RIGHT)

    self:CreateNotesRowText(row.right, tNoteData.poster or L("dfUnknown"), "dfButton", color_white, 6)
    self:CreateNotesRowText(row.right, os.date( "%H:%M:%S - %d/%m/%Y" , tNoteData.timestamp ) or L("dfUnknown"), nil, nil, 6)

    self.notes.content.rows[#self.notes.content.rows + 1] = row
end

function PANEL:CreateNotesRowText(parent, text, font, color, contentAlignment)
    local textLabel = parent:Add("DLabel")
    textLabel:Dock(TOP)
    textLabel:SetFont(font or "dfButtonNoBold")
    textLabel:SetText(text or "")
    textLabel:SetColor(color or self.subtextColor)
    textLabel:SetContentAlignment(contentAlignment or 4)
    textLabel:SizeToContents()

    parent:SetWide(math.max(parent:GetWide(), textLabel:GetWide()))
end

function PANEL:CreatePopupWindow(title, content, bPoints, callback, callbackText, bEditable)
    local wh = s850 / 2

    if self.window and IsValid(self.window) then
        self.window:Remove()
    end

    self.window = vgui.Create("ixDatafileDFrame")
    self.window:SetSize(wh, wh)
    self.window:MakePopup()
    self.window:SetTitle(L(title))
    self.window:Center()

    local entry = self.window:Add("DTextEntry")
    entry:Dock(FILL)
    entry:SetFont("dfSubtext")
    entry:SetTextColor( self.subtextColor )
    entry:SetCursorColor( self.subtextColor )
    entry:SetPlaceholderColor(self.subtextColor)
    entry:SetPlaceholderText(L("dfTextQuery"))
    entry:SetMultiline(true)
    entry:SetText(content or "")
    entry:SetEditable(bEditable)
    entry:SetVerticalScrollbarEnabled(true)
    entry.Paint = function(this, w, h)
        surface.SetDrawColor(self.mediumColor)
        surface.DrawRect(0, 0, w, h)

        if (  !this:GetText() or this:GetText() == "" ) then
            local oldText = this:GetText()

            local str = this:GetPlaceholderText()
            if ( str:StartWith( "#" ) ) then str = str:utf8sub( 2 ) end
            str = language.GetPhrase( str )

            this:SetText( str )
            this:DrawTextEntryText( this:GetPlaceholderColor(), this:GetHighlightColor(), this:GetCursorColor() )
            this:SetText( oldText )

            return
        end

        this:DrawTextEntryText( this:GetTextColor(), this:GetHighlightColor(), this:GetCursorColor() )
    end

    if callback then
        local button = self.window:Add("DButton")
        button:SetFont("dfButton")
        button:SetText(callbackText or "")
        button:Dock(BOTTOM)
        button:SetTall(s30)
        button.Paint = function(this, w, h)
            surface.SetDrawColor(self.primaryColor)
            surface.DrawRect(0, 0, w, h)
        end

        button.DoClick = function()
            surface.PlaySound(ix.config.Get("datafileButtonClickSound"))

            local points = 0
            if self.window.numSlider and IsValid(self.window.numSlider) then
                points = self.window.numSlider:GetValue()
            end

            callback(entry:GetText(), points)

            self.window:Remove()
        end
    end

    if bPoints then
        self.window.numSlider = self.window:Add("ixSettingsRowNumber")
        self.window.numSlider:Dock(BOTTOM)
        self.window.numSlider:SetTall(s30)
        self.window.numSlider:SetValue(0)
        self.window.numSlider:SetMin(ix.config.Get("datafileActRecordPointsLowerLimit"))
        self.window.numSlider:SetMax(ix.config.Get("datafileActRecordPointsUpperLimit"))
        self.window.numSlider.setting.label:SetFont("dfButtonSmaller")
        self.window.numSlider.text:SetFont("dfButtonSmaller")
        self.window.numSlider.text:SetText(L("dfEnterPoints"))
        self.window.numSlider.text:SizeToContents()
        self.window.numSlider.text:SetExpensiveShadow(0)
        self.window.numSlider.text:DockMargin(s5, 0, 0, 0)
        self.window.numSlider.Paint = function(this, w, h)
            surface.SetDrawColor(self.darkPrimaryColor)
            surface.DrawRect(0, 0, w, h)
        end
    end
end

local bottomButtons = {
    topRow = {
        dfAddNote = {callback = function(_, title2) PLUGIN.datafile:CreatePopupWindow(title2, nil, nil,
            function(entryText)
                if !PLUGIN.datafile:CheckNoteCharacters(entryText) then return end
                PLUGIN.datafile:AddNote(1, entryText)
            end, L("dfAddEntry"), true)
        end, order = 1},
        dfRecordAct = {callback = function(_, title2) PLUGIN.datafile:CreatePopupWindow(title2, nil, true,
            function(entryText, points)
                if !PLUGIN.datafile:CheckNoteCharacters(entryText) then return end
                PLUGIN.datafile:AddNote(2, entryText, points)
            end, L("dfAddEntry"), true)
        end, order = 2},
        dfToggleCitizenship = {callback = function() PLUGIN.datafile:ToggleBOLCitizenship() end, order = 3}
    },

    bottomRow = {
        dfMedicalRecord = {callback = function(_, title2) PLUGIN.datafile:CreatePopupWindow(title2, nil, nil,
            function(entryText)
                if !PLUGIN.datafile:CheckNoteCharacters(entryText) then return end
                PLUGIN.datafile:AddNote(3, entryText)
            end, L("dfAddEntry"), true)
        end, order = 1},
        dfUpdateLastSeen = {callback = function()
            PLUGIN.datafile:RequestLastSeen()
        end, order = 2},
        dfPlaceBOL = {callback = function() PLUGIN.datafile:ToggleBOLCitizenship(true) end, order = 3}
    }
}

function PANEL:RequestLastSeen()
    net.Start("ixDatafileUpdateLastSeen")
    net.WriteUInt(tonumber(self.datafileID), 32)
    net.SendToServer()
end

function PANEL:ToggleBOLCitizenship(bBOL)
    if !self.bol or !self.citizenship then return end

    self:CreatePopupWindow(L("dfToggle").." "..(bBOL and L("dfBOL") or L("dfCitizenship")), nil, nil,
    function(entryText)
        if !PLUGIN.datafile:CheckNoteCharacters(entryText) then return end
        net.Start("ixDatafileUpdateBOLCitizenship")
        net.WriteUInt(tonumber(self.datafileID), 32)
        net.WriteBit(bBOL and 0 or 1)
        net.WriteBit(bBOL and (self.bol == 1 and 0 or 1) or self.citizenship == 1 and 0 or 1)
        net.WriteString(entryText)
        net.SendToServer()
    end, L("dfToggle"), true)
end

function PANEL:AddNote(type, text, points)
    net.Start("ixDatafileAddNote")
    net.WriteUInt(tonumber(self.datafileID), 32)
    net.WriteUInt(type, 2)
    net.WriteString(text)

    if points then
        net.WriteInt(points, 32)
    end

    net.SendToServer()
end

function PANEL:CheckNoteCharacters(text)
    if string.len(text) > ix.config.Get("datafileNotesMaxCharacters", 500) then
        LocalPlayer():NotifyLocalized("dfMaxCharacters")
        return false
    end

    if string.len(text) <= 0 then
        LocalPlayer():NotifyLocalized("dfMinCharacters")
        return false
    end

    return true
end

function PANEL:CreateButtonPanel()
    bottomButtons.topRow.dfAddNote.color = self.primaryColor
    bottomButtons.topRow.dfRecordAct.color = self.green
    bottomButtons.topRow.dfToggleCitizenship.color = self.red
    bottomButtons.bottomRow.dfUpdateLastSeen.color = self.primaryColor
    bottomButtons.bottomRow.dfMedicalRecord.color = self.primaryColor
    bottomButtons.bottomRow.dfPlaceBOL.color = self.red

    self.buttonPanel = self:Add("Panel")
    self.buttonPanel:Dock(BOTTOM)
    self.buttonPanel:SetTall(s112)
    self.buttonPanel:DockMargin(0, s30, 0, 0)

    self:CreateAnimatedHorizontalSep(self.buttonPanel, s36, lightUpDuration * 1.5)

    self.buttonPanel.topRow = self.buttonPanel:Add("Panel")
    self.buttonPanel.topRow:Dock(TOP)
    self.buttonPanel.topRow:SetTall(s30)
    self.buttonPanel.topRow:DockMargin(0, 0, 0, s10)
    self.buttonPanel.topRow:DockPadding(0, 0, s140, 0)
    self.buttonPanel.topRow:SetAlpha(0)
    self.buttonPanel.topRow:AlphaTo(255, fadeInTime, lightUpDuration)

    self.buttonPanel.bottomRow = self.buttonPanel:Add("Panel")
    self.buttonPanel.bottomRow:Dock(TOP)
    self.buttonPanel.bottomRow:SetTall(s30)
    self.buttonPanel.bottomRow:DockPadding(0, 0, s140, 0)
    self.buttonPanel.bottomRow:SetAlpha(0)
    self.buttonPanel.bottomRow:AlphaTo(255, fadeInTime, lightUpDuration)

    for row, tButtons in pairs(bottomButtons) do
        for lString, data in pairs(tButtons) do
            local button = self.buttonPanel[row]:Add("DButton")
            button:Dock(LEFT)
            button:DockMargin(0, 0, s10, 0)
            button:SetWide((s650 - s100 - s140 + s20) / 3)
            button:SetText(L(lString))
            button:SetFont("dfButtonSmaller")
            button:SetZPos(data.order)
            button.Paint = function(this, w, h)
                surface.SetDrawColor(data.color)
                surface.DrawRect(0, 0, w, h)
            end

            button.DoClick = function()
                surface.PlaySound(ix.config.Get("datafileButtonClickSound"))

                data:callback(lString)
            end
        end
    end
end

function PANEL:OnRemove()
    if self.window and IsValid(self.window) then
        self.window:Remove()
    end
end

function PANEL:Paint(w, h)
    self:InitializeLogoProperties()
    self:DrawBackground()
    self:DrawLoadupPolygons()
    self:DrawOutlines()
    self:DrawCombineLogoWrapper()
end

function PANEL:DrawOutline(polygon)
    for i = 1, #polygon do
        local start = polygon[i]
        local finish = polygon[i % #polygon + 1]

        if (start.x == s40 and start.y == 0 and finish.x == s40 and finish.y == s850 / 2) then
            continue
        elseif (start.x == s40 and start.y == s850 and finish.x == s40 and finish.y == 0) then
            surface.DrawLine(s40, s850, s40, s850 / 2)
            continue
        elseif start.x == s650 then
            surface.DrawLine(start.x - 1, start.y, finish.x - 1, finish.y)
        elseif start.x == (s650 - s40) or (start.x == s30 and finish.x == 0) then
            surface.DrawLine(start.x, start.y - 1, finish.x, finish.y - 1)
        else
            surface.DrawLine(start.x, start.y, finish.x, finish.y)
        end
    end
end

function PANEL:DrawCircle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5,
        v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is needed for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5,
    v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end

local cutCorners = {
    { x = s40, y = 0 },
    { x = s650, y = 0 },
    { x = s650, y = s850 - s40 },
    { x = s650 - s40, y = s850 },
    { x = s40, y = s850 },
}

local cutCorners2 = {
    { x = 0, y = s40 },
    { x = s40, y = 0 },
    { x = s40, y = s850 / 2 },
    { x = 0, y = s850 / 2 - s40 },
}

local cutCorners3 = {
    { x = 0, y = s850 / 1.5 - s20 },
    { x = s30, y = s850 / 1.5 + s30 - s20 },
    { x = s30, y = s850 },
    { x = 0, y = s850 },
}

function PANEL:DrawCombineLogo(x, y, alpha, roundPolyAlpha, factor)
    factor = factor or 1 -- Set default factor to 1 for no resizing

    local topShape = {
        {x = x + s56 * factor, y = y},
        {x = x + s200 * factor, y = y + s67 * factor},
        {x = x + s200 * factor, y = y + s145 * factor},
    }

    local midShape = {
        {x = x + s200 * factor, y = y + s145 * factor},
        {x = x + s153 * factor, y = y + s200 * factor},
        {x = x + s68 * factor, y = y + s120 * factor},
        {x = x + s126 * factor, y = y + s70 * factor},
    }
    local bottomShape = {
        {x = x, y = y + s56 * factor},
        {x = x + s153 * factor, y = y + s200 * factor},
        {x = x + s68 * factor, y = y + s200 * factor},
    }

    surface.SetDrawColor(ColorAlpha(self.primaryColor, alpha))
    draw.NoTexture()
    surface.DrawPoly(topShape)
    surface.DrawPoly(midShape)
    surface.DrawPoly(bottomShape)

    -- Draw the inner circle ("eye")
    local circleRadius = (s115 / 2) * factor
    local circleCenterX = x + s125 * factor
    local circleCenterY = y + s125 * factor

    draw.NoTexture()
    surface.SetDrawColor(ColorAlpha(self.bgColor, roundPolyAlpha))
    self:DrawCircle(circleCenterX, circleCenterY, circleRadius, 30)

    circleRadius = (s100 / 2) * factor

    draw.NoTexture()
    surface.SetDrawColor(ColorAlpha(self.primaryColor, alpha))
    self:DrawCircle(circleCenterX, circleCenterY, circleRadius, 30)
end

function PANEL:GetPulsatingColor()
    local pulseSpeed = 2 -- Adjust the speed as necessary
    local alpha = 0.5 * math.sin((CurTime() - self.pulseOffsetTime) * pulseSpeed + math.pi) + 0.5
    return Color(
        Lerp(alpha, self.darkPrimaryColor.r, self.primaryColor.r),
        Lerp(alpha, self.darkPrimaryColor.g, self.primaryColor.g),
        Lerp(alpha, self.darkPrimaryColor.b, self.primaryColor.b), 255
    )
end

function PANEL:DrawLoadupPolygons()
	surface.SetDrawColor( self.bgColor )
	draw.NoTexture()
	surface.DrawPoly( cutCorners )
    surface.DrawPoly( cutCorners2 )
    surface.DrawPoly( cutCorners3 )

    surface.SetDrawColor( self.primaryColor )

    local progress = math.min((CurTime() - self.startTime) / lightUpDuration, 1)

    for i = 1, 4 do
        local polyProgress = math.Clamp((progress - (i - 1) * 0.25) * 4, 0, 1)

        local currentColor
        if progress >= 1 then
            currentColor = self:GetPulsatingColor()
        else
            currentColor = Color(
                Lerp(polyProgress, self.bgColor.r, self.primaryColor.r),
                Lerp(polyProgress, self.bgColor.g, self.primaryColor.g),
                Lerp(polyProgress, self.bgColor.b, self.primaryColor.b), 255
            )
        end

        surface.SetDrawColor(currentColor)

        local cutCorners4 = {
            { x = 0, y = s850 / 1.5 - s20 - s36 * i },
            { x = s30, y = s850 / 1.5 + s30 - s20 - s36 * i },
            { x = s30, y = s850 / 1.5 + s30 - s20 - s36 * i + s20 },
            { x = 0, y = s850 / 1.5 - s20 - s36 * i + s20 },
        }

        surface.DrawPoly(cutCorners4)
    end
end

function PANEL:InitializeLogoProperties()
    local w, h = self:GetSize()
    local elapsedTime = CurTime() - self.startTime

    local logoPositionX = w / 2 - self.logoSize / 2
    local logoPositionY = h / 2 - self.logoSize / 2

    if elapsedTime < fadeInTime then
        self.combineLogoAlpha = 0
        self.combineLogoRoundPolyAlpha = 0
    elseif elapsedTime < fadeInTime + clFadeInDuration then
        self.combineLogoAlpha = ((elapsedTime - fadeInTime) / clFadeInDuration) * 255
        self.combineLogoRoundPolyAlpha = 255
    elseif elapsedTime < fadeInTime + clFadeInDuration + clStayDuration then
        self.combineLogoAlpha = 255
        self.combineLogoRoundPolyAlpha = 255
    elseif elapsedTime < fadeInTime + clFadeInDuration + clStayDuration + clMoveAndResizeDuration then
        local moveProgress = (elapsedTime - fadeInTime - clFadeInDuration - clStayDuration) / clMoveAndResizeDuration
        logoPositionX = Lerp(moveProgress, logoPositionX, w - self.logoSize * 0.55)
        logoPositionY = Lerp(moveProgress, logoPositionY, h - self.logoSize * 0.55)
        self.logoFactor = Lerp(moveProgress, 1, 0.4)
    else
        self.combineLogoAlpha = 255
        self.combineLogoRoundPolyAlpha = 255
        logoPositionX = w - self.logoSize * 0.55
        logoPositionY = h - self.logoSize * 0.55
        self.logoFactor = 0.4
    end

    self.logoPositionX = logoPositionX
    self.logoPositionY = logoPositionY
end

function PANEL:DrawBackground()
    Derma_DrawBackgroundBlur(self)

    surface.SetDrawColor(self.bgColor)
    draw.NoTexture()
    surface.DrawPoly(cutCorners)
    surface.DrawPoly(cutCorners2)
    surface.DrawPoly(cutCorners3)
end

function PANEL:DrawOutlines()
    surface.SetDrawColor(self.primaryColor)
    self:DrawOutline(cutCorners)
    self:DrawOutline(cutCorners2)
    self:DrawOutline(cutCorners3)

    local w, h = self:GetSize()
    surface.DrawRect(0, h - s10, s100, s10)
    surface.DrawRect(0, h - s100 - s10, s10, s100)
    surface.DrawRect(w - s100 - s10, 0, s100 + s10, s10)
    surface.DrawRect(w - s10, s10, s10, s100)

    local currentTime = CurTime()
    local timeElapsed = currentTime - self.startTime

    if timeElapsed < lightUpDuration then
        local progress = math.min(timeElapsed / lightUpDuration, 1)
        local currentY = Lerp(progress, s112, s112 + s260)

        surface.SetDrawColor(self.primaryColor)
        surface.DrawLine(s33, s112, s33, currentY)
    else
        surface.SetDrawColor(self.primaryColor)
        surface.DrawLine(s33, s112, s33, s112 + s260)
    end
end

function PANEL:DrawCombineLogoWrapper()
    self:DrawCombineLogo(self.logoPositionX, self.logoPositionY, self.combineLogoAlpha,
    self.combineLogoRoundPolyAlpha, self.logoFactor)
end

function PANEL:CreateAnimatedHorizontalSep(parent, bM, duration)
    duration = duration or lightUpDuration

    local line = parent:Add("Panel")
    line:Dock(TOP)
    line:SetTall(1)
    line:DockMargin(0, 0, 0, bM or 0)
    line.Paint = function(this, w, h)
        local currentTime = CurTime()
        local timeElapsed = currentTime - self.startTime

        if timeElapsed < duration then
            local progress = math.min(timeElapsed / duration, 1)
            local currentX = Lerp(progress, 0, w)

            surface.SetDrawColor(self.primaryColor)
            surface.DrawLine(0, 0, currentX, 0)
        else
            surface.SetDrawColor(self.primaryColor)
            surface.DrawLine(0, 0, w, 0)
        end
    end

    return line
end

function PANEL:AbbreviateText(text, len)
    if string.len(text) > len + 1 then
        return string.sub(text, 1, len) .. "..."
    else
        return text
    end
end

function PANEL:GetTierData(points)
    points = tonumber(points)
    local name, color = L("dfUnknown"), self.subtextColor

    if points == 0 then
        return name, color
    end

    local bestTier = nil

    for _, v in pairs(self.tiers) do
        if points > 0 then
            if (not bestTier or v.pointsRequired > bestTier.pointsRequired) and v.pointsRequired <= points then
                bestTier = v
            end
        elseif points < 0 then
            if (not bestTier or v.pointsRequired < bestTier.pointsRequired) and v.pointsRequired >= points then
                bestTier = v
            end
        end
    end

    if bestTier then
        if (points > 0 and bestTier.pointsRequired > 0) or (points < 0 and bestTier.pointsRequired < 0) then
            name = bestTier.name
            color = bestTier.color or self.subtextColor
        else
            return L("dfUnknown"), self.subtextColor
        end
    end

    return name, color
end


function PANEL:Populate(datafile, tiers)
    self.datafileID = datafile.id or 0
    self.tiers = tiers

    if datafile.cid and datafile.cid == 0 then datafile.cid = "00000" end

    self.title:SetText(datafile.name or L("dfUnknown"))
    self.title:SizeToContents()
    self.cid:SetText("##"..(datafile.cid or L("dfUnknown")))
    self.cid:SizeToContents()

    local sFaction = datafile.faction or L("dfUnknown")
    local faction = self:AbbreviateText(string.utf8upper(sFaction), 10)
    self:CreateInfoTextRow(self.infoText.left, L("dfStatus"), faction or L("dfUnknown"))

    local points = datafile.points or 0
    local pointsColor = self:GetLoyaltyPointsColor(points)
    local citActive = datafile.citizenship and tonumber(datafile.citizenship) == 1
    self.citPan = self:CreateInfoTextRow(self.infoText.left, L("dfCitizenship"), citActive and L("dfActive") or L("dfRevoked"),
    self:GetCitizenshipColor(tonumber(datafile.citizenship)))

    self.loyaltyPoints = self:CreateInfoTextRow(self.infoText.left, L("dfLoyaltyPoints"), points, pointsColor)

    local lTier, color = self:GetTierData(points)
    self.tier = self:CreateInfoTextRow(self.infoText.right, L("dfLoyaltyTier"), string.utf8upper(lTier), color)

    local lastLocation = datafile.last_location and datafile.last_location.location or L("dfUnknown")
    local timestamp = datafile.last_location and datafile.last_location.timestamp or os.time()
    self.lastLocation = self:CreateInfoTextRow(self.infoText.right, L("dfLastSpotted"), lastLocation)
    self.time = self:CreateInfoTextRow(self.infoText.right, L("dfTimeSpotted"), os.date( "%H:%M:%S - %d/%m/%Y" , timestamp ))

    self.notesButton:DoClick(true)

    self.title.bolBlink = datafile.bol == 1 and true or false
    self.bol = datafile.bol
    self.citizenship = datafile.citizenship
end

function PANEL:ClearNotes()
    for _, v in pairs(self.notes.content.rows) do
        if v and IsValid(v) then v:Remove() end
    end
end

function PANEL:GetLoyaltyPointsColor(points)
    points = tonumber(points)

    if points < 0 then return self.staticRed end
    if points > 0 then return self.staticGreen end

    return color_white
end

function PANEL:PopulateNotes(notes, datafileID, noteType, currentPage)
    if self.notes.currentType != noteType then return end
    if #table.GetKeys(notes) <= 0 and currentPage != self.notes.currentPage then return end

    for _, v in pairs(self.headerButtons) do
        if v.type != noteType then v.active = false continue end
        v.active = true
    end

    self.notes.currentPage = currentPage or 1
    self.curPage:SetText(L("dfPage")..": "..(self.notes.currentPage or 1))

    self:ClearNotes()

    if tonumber(self.datafileID) != tonumber(datafileID) then return end

    for key, tNoteData in pairs(notes) do
        local bSecond = key % 2 == 0
        self:CreateNotesRow(bSecond, tNoteData)
    end
end

function PANEL:UpdatePoints(datafileID, points)
    if tonumber(self.datafileID) != tonumber(datafileID) then return end
    if self.loyaltyPoints and self.loyaltyPoints.textLabel then
        if !IsValid(self.loyaltyPoints.textLabel) then return end

        self.loyaltyPoints.textLabel:SetTextColor(self:GetLoyaltyPointsColor(points))
        self.loyaltyPoints.textLabel:SetText(points)
        self.loyaltyPoints.textLabel:SizeToContents()

        local name, color = self:GetTierData(points)

        self.tier.textLabel:SetText(string.utf8upper(name))
        self.tier.textLabel:SetTextColor(color)
        self.tier.textLabel:SizeToContents()
    end
end

function PANEL:UpdateLastSeen(datafileID, sLastLocation, nTimestamp)
    if tonumber(self.datafileID) != tonumber(datafileID) then return end
    if !self.lastLocation or self.lastLocation and !IsValid(self.lastLocation) then return end
    if !self.time or self.time and !IsValid(self.time) then return end

    self.lastLocation.textLabel:SetText(self:AbbreviateText(sLastLocation, 15))
    self.lastLocation.textLabel:SizeToContents()

    self.time.textLabel:SetText(os.date( "%H:%M:%S - %d/%m/%Y" , nTimestamp ))
    self.time.textLabel:SizeToContents()
end

function PANEL:GetCitizenshipColor(nActive)
    return nActive == 1 and self.staticGreen or self.staticRed
end

function PANEL:UpdateBOLCitizenship(datafileID, nType, nActive)
    if tonumber(self.datafileID) != tonumber(datafileID) then return end
    if !self.citPan or self.citPan and !IsValid(self.citPan) then return end

    if nType == 1 then
        local prevParentWidth = self.citPan:GetWide()
        local prevTextWidth = self.citPan.textLabel:GetWide()
        self.citPan.textLabel:SetText(nActive == 1 and L("dfActive") or L("dfRevoked"))
        self.citPan.textLabel:SetColor(self:GetCitizenshipColor(nActive))
        self.citPan.textLabel:SizeToContents()
        self.infoText.left:SetWide(prevParentWidth - prevTextWidth + self.citPan.textLabel:GetWide())

        self.citizenship = nActive
        return
    end

    self.title.bolBlink = nActive == 1 and true or false
    self.bol = nActive
end

vgui.Register("ixDatafile", PANEL, "EditablePanel")