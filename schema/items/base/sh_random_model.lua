ITEM.name = "Item"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.width = 1
ITEM.height = 1

ITEM.models = {}

function ITEM:OnInstanced(index, x, y, item)
    if (self.models and #self.models > 0) then
        self:SetData("model", self.models[math.random(#self.models)])
    end
end

function ITEM:GetModel()
    local model = self:GetData("model") or self.model

    if (not model and self.models and #self.models > 0) then
        model = self.models[math.random(#self.models)]
        self:SetData("model", model)
    end

    return model or "models/Gibs/HGIBS.mdl"
end
