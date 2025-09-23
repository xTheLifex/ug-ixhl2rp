
local s4, s30 = PLUGIN:SC(4), PLUGIN:SC(30)

local PANEL = {}

function PANEL:Init()
    self.primaryColor = ix.config.Get("datafileColorPrimary")
    self.bgColor = ix.config.Get("datafileColorBG")

	self.lblTitle:SetFont("dfButton")
	self.lblTitle:SizeToContents()
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(self.bgColor)
    surface.DrawRect(0, 0, w, h)

    surface.SetDrawColor(self.primaryColor)
    surface.DrawOutlinedRect(0, 0, w, h)

    surface.DrawRect(0, 0, w, self.lblTitle:GetTall() + s4)

    return true
end

vgui.Register("ixDatafileDFrame", PANEL, "DFrame")

PANEL = {}

function PANEL:Init()
    self:SetHeaderHeight(s30)
	self:SetDataHeight(s30)
    self:Dock(FILL)

    self.primaryColor = ix.config.Get("datafileColorPrimary")
end

function PANEL:Paint(w, h)
end

function PANEL:CreateBottomButton(text, callback)
    local button = self:Add("DButton")
    button:SetText(text or "")
    button:SetFont("dfButtonSmaller")
    button:Dock(BOTTOM)
    button:SetTall(s30)
    button.Paint = function(this, w, h)
        surface.SetDrawColor(self.primaryColor)
        surface.DrawRect(0, 0, w, h)
    end

    button.DoClick = function()
        surface.PlaySound("helix/ui/press.wav")

        if callback then
            callback()
        end
    end
end

function PANEL:FixColumnWidth(width, toFix)
    for _, v in pairs(self:GetChildren()) do
        if v:GetName() != "DListView_Column" then continue end
        for _, v2 in pairs(v:GetChildren()) do
            if v2:GetName() != "DButton" then continue end
            local text = v2:GetText()
            for _, name in pairs(toFix) do
                if text != name then continue end
                v:SetFixedWidth(width)
            end
        end
    end
end

function PANEL:PaintColumns(color, font)
	for _, v in pairs(self.Columns) do
		for _, v2 in pairs(v:GetChildren()) do
			v2:SetFont(font)
            v2.Paint = function(this, w, h)
                surface.SetDrawColor(color)
                surface.DrawRect(0, 0, w, h)
            end
		end
	end
end

function PANEL:PaintLines(font, color)
	for _, line in ipairs(self:GetLines()) do
		for _, label in pairs(line:GetChildren()) do
            if label:GetClassName() != "Label" then continue end
            label:SetContentAlignment(5)
			label:SetFont(font)
		end

		line.Paint = function(panel, width, height)
			if (panel:IsSelected() or panel.Hovered) then
				surface.SetDrawColor(color)
				surface.DrawRect(0, 0, width, height)
			end
		end

		for _, v2 in ipairs(line.Columns) do
			v2:SetTextColor(color_white)
		end
	end
end

vgui.Register("ixDatafileDListView", PANEL, "DListView")