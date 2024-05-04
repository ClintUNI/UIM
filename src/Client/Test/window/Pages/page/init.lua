local replicated = game:GetService("ReplicatedStorage")

local types = require(replicated.Modules.Managers.UIManager.Types)
local Page = require(replicated.Modules.Managers.UIManager.Page)

local page = Page.new(script.Name)

page:OnBuild(function(self: types.Page): ()
    local frame = Instance.new("Frame")
    frame.Visible = false
    frame.Size = UDim2.fromScale(0.5, 0.5)
    frame.Position = UDim2.fromScale(0.5, 0.5)
    frame.Parent = self.Parent.ScreenGui

    self.Frame = frame
    self.Container:Add(frame) --Because we creating it each time, and not just locating it from the cloned ScreenGui, we need to make sure it gets cleaned on page close.

    for _, component: Instance in script.Components:GetChildren() do
        if not component:IsA("ModuleScript") then 
            continue 
        end

        self:AddComponent(require(component)).AsOpened()
    end
end)

return page