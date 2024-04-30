local types = require(script.Parent.Types)

local component: types.ComponentClass = {} :: types.ComponentClass
component["__index"] = component

local module = {}

function module.new(name: string): types.Component
    local self = setmetatable({
        Name= name,
        _ = {},
    }, component)

    return self
end

--[[ Buttons ]]

function component:BuildButtons()
    for _, button: types.Button in self.Buttons.Stored do
        button:Build(self)
    end
end

function component:AddButton(button: types.Button)
    self.Buttons.Stored[button.Name] = button
end

function component:RemoveButtons()
    self.Buttons.Active = {}
    self.Buttons.Stored = {}
end

--

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
end

function component:Update(command: string, parameters: {}): ()
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
    if self.Container then
        self.Container:Remove()
    end

    self:RemoveButtons()
end

return module