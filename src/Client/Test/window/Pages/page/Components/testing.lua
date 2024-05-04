local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local replicated = game:GetService("ReplicatedStorage")

local Draggable = require(replicated.Modules.Managers.UIManager.UIObjects.Draggable)
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

    -- local draggablePage = Draggable.new("Test")
    -- draggablePage:OnBuild(function(draggable: types.Draggable)
    --     local button = Instance.new("TextButton")
    --     button.Size = UDim2.fromScale(1, 1)
    --     button.Position = UDim2.fromScale(0, 0)
    --     button.BackgroundColor3 = Color3.fromHSV(0.805556, 0.611765, 1.000000)
    --     button.Parent = self.Frame
    --     draggable.DragButton = button
    -- end)
    -- draggablePage:OnDragStart(function(draggable: types.Draggable)
    --     self:Update("DragLoop", { DragState = true })
    -- end)
    -- draggablePage:OnDragStop(function(draggable: types.Draggable)
    --     print("stopped!!!")
    -- end)

    -- draggablePage:Build(self)
end)

component:OnUpdate("DragLoop", function(self: types.Component, parameters: { DragState: boolean }?)
    if parameters and parameters.DragState then
        self.Container:Connect(RunService.Heartbeat, function()
            print(UserInputService:GetMouseLocation().X)
        end)
    else
        self.Container:Clean()
    end
end)

return component