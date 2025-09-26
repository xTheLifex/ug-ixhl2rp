

ITEM.name = "Item"
ITEM.model = "models/Gibs/HGIBS.mdl"
ITEM.width = 1
ITEM.height = 1

ITEM.models = {}

function ITEM:OnInstanced(index, x, y, item)
    self:SetData("model", self.models[math.random(#self.models)])
end

function ITEM:GetModel()
    local model = self:GetData("model")
    if not model then
        self:SetData("model", self.models[math.random(#self.models)])
    end
    return self:GetData("model") or self.model
end