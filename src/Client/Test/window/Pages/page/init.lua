local replicated = game:GetService("ReplicatedStorage")

local types = require(replicated.Modules.Managers.UIManager.Types)
local Page = require(replicated.Modules.Managers.UIManager.Page)

local page = Page.new(script.Name)

page:OnBuild(function(self: types.Page): ()
    self.Frame = Instance.new("Frame")

    self.Frame.Visible = false
    self.Frame.Size = UDim2.fromScale(0.2, 0.2)
    self.Frame.Position = UDim2.fromScale(0.5, 0.5)
    
    self.Frame.Parent = self.Parent.ScreenGui

    for _, component: Instance in script.Components:GetChildren() do
        if not component:IsA("ModuleScript") then continue end

        self:AddComponent(require(component))
        self:OpenComponent(component.Name)
    end
end)

return page