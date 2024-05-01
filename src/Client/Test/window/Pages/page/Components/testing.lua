local replicated = game:GetService("ReplicatedStorage")

local types = require(replicated.Modules.Managers.UIManager.Types)
local Component = require(replicated.Modules.Managers.UIManager.Component)

local component = Component.new(script.Name)

component:OnBuild(function(self: types.Component): ()
    self.Frame = Instance.new("Frame")

    self.Frame.Visible = false
    self.Frame.Size = UDim2.fromScale(0.2, 0.2)
    self.Frame.Position = UDim2.fromScale(0.8, 0.8)
    self.Frame.BackgroundColor3 = Color3.new(1, 0, 0)
    
    self.Frame.Parent = self.Parent.Frame

    task.delay(2, function()
        self:Update("Size")
    end)
end)

component:OnUpdate("Size", function(self: types.Component, _: {}?)
    self.Frame.Size = UDim2.fromScale(0.1, 0.1)
end)

return component