local ReplicatedStorage = game:GetService("ReplicatedStorage")
local uis = game:GetService("UserInputService")
local types = require(ReplicatedStorage.Modules.Managers.UIManager.Types)
local Signal = require(ReplicatedStorage.Modules.Utility.Signal)
local module = {}

local draggable: types.DraggableClass = {} :: types.DraggableClass
draggable["__index"] = draggable

function module.new(name: string): types.Draggable
    local self = setmetatable({
        Name = name,
        DragEvent = Signal.new(),

        _ = {
            IsDragging = false,
            DragStartTime = 0,
        },
    }, draggable)

    return self
end

--[[ Draggable ]]

--[[
    Use TouchSwipe for mobile, and MouseButton1Down with MouseButton1Up for PC
]]

function draggable:OnBuild(callback: (self: types.Draggable) -> ())
    self._.OnBuild = callback
end

function draggable:Build(parent: types.Page | types.Component)
    self.Parent = parent

    if self._.OnBuild then
        self._.OnBuild(self)
    end

    if self.DragButton then
        if uis.MouseEnabled then
            self.Parent.Container:ConnectMethod(self.DragButton.MouseButton1Down, "_DragStart", self, {})
            self.Parent.Container:ConnectMethod(self.DragButton.MouseButton1Up, "_DragStop", self, {})
        else
            self.Parent.Container:Connect(self.DragButton.TouchPan, function(touchPositions: {Vector2}, scale: number, velocity: number, state: Enum.UserInputState)
                self:_MobileDrag(touchPositions, scale, velocity, state)
            end)
        end
    end
end

function draggable:IsDragging(): boolean
    return self._.IsDragging
end

function draggable:_DragStart()
    if self._.IsDragging then
        return
    end

    self._.IsDragging = true
    self._.DragStartTime = os.clock()

    self.DragEvent:Fire(Enum.UserInputType.Touch, true)
end

function draggable:_DragStop()
    self._.IsDragging = false

    self.DragEvent:Fire(Enum.UserInputType.Touch, false)
end

function draggable:_MobileDrag(touchPositions: {Vector2}, scale: number, velocity: number, state: Enum.UserInputState)
    if self._.IsDragging and state == Enum.UserInputState.Begin then
        return
    end

    self._.IsDragging = state == Enum.UserInputState.Begin
    self._.DragStartTime = self._.IsDragging and os.clock() or 0

    self.DragEvent:Fire(Enum.UserInputType.Touch, state, touchPositions, scale, velocity)
end

function draggable:Clean()
    self.DragEvent:DisconnectAll()
end

function draggable:Destroy()
    self:Clean()
    setmetatable(getmetatable(self), nil)
end

return module