local objectList = require(script.Parent.ObjectList)
local types = require(script.Parent.Types)

local component = {} :: types.ComponentClass
component["__index"] = component

local module = {}

function module.new(name: string): types.Component
    local self = setmetatable({
        Name= name,
        Buttons = objectList.new(),
        
        _ = {
            UpdateCallbacks = {},
        },
    }, component)

    self.Buttons.Parent = self

    return self
end

function component:OnBuild(callback: (self: types.Component) -> ()): ()
    self._.OnBuild = callback
end

function component:OnUpdate(command: string, callback: (self: types.Component, parameters: {}) -> ()): ()
    self._.UpdateCallbacks[command] = callback
end

function component:OnOpen(callback: (self: types.Component) -> ()): ()
    self._.OnOpen = callback
end

function component:OnClose(callback: (self: types.Component) -> ()): ()
    self._.OnClose = callback
end

function component:Build(parent: types.Page): ()
    self:Clean()

    self.Parent = parent

    local window = parent.Parent
    self.Container = window.Manager.Packages.Trove.new()

    if self._.OnBuild then
        self._.OnBuild(self)
    end

    self._.Status = "Built"
end

function component:GetStatus(): "Built" | "Stored"
    return self._.Status
end

function component:StatusIs(status: "Built" | "Stored")
    return status == self._.Status
end

function component:Update(command: string, parameters: {}?): ()
    if self._.UpdateCallbacks[command] then
        self._.UpdateCallbacks[command](self, parameters)
    else
        warn("No update function exists inside of component.", self.Name, "| command:", command)
    end
end

function component:Open(): ()
    if self.Frame then
        self.Frame.Visible = true
    end

    if self._.OnOpen then
        self._.OnOpen(self)
    end
end

function component:Close(): ()
    if self.Frame then
        self.Frame.Visible = false
    end

    if self._.OnClose then
        self._.OnClose(self)
    end
end

function component:Clean(): ()
    self.Buttons:CleanAll()

    if self.Container then
        self.Container:Remove()
    end

    self._.Status = "Stored"
end

function component:Remove(): ()
    self:Clean()

    self.Buttons:RemoveAll()

    if self.Frame then
        self.Frame:Destroy()
    end
end

return module
