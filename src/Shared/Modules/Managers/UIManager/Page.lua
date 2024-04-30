local types = require(script.Parent.Types)

local page: types.PageClass = {} :: types.PageClass
page["__index"] = page

local module = {}

function module.new(name: string): types.Page
    local self = setmetatable({
        Name= name,
        Buttons = {
            Active = {},
            Stored = {},
        },
        Components = {
            Open = {},
            Stored = {},
        },

        _ = {},
    }, page)

    return self
end

--[[ Buttons ]]

function page:BuildButtons()
    for _, button: types.Button in self.Buttons.Stored do
        button:Build(self)
    end
end

function page:AddButton(button: types.Button)
    self.Buttons.Stored[button.Name] = button
end

function page:RemoveButtons()
    self.Buttons.Active = {}
    self.Buttons.Stored = {}
end

--

--[[ Components ]]

function page:BuildComponents()
    for _, component: types.Button in self.Components.Stored do
        component:Build(self)
    end
end

function page:AddComponent(component: types.Component)
    self.Components.Stored[component.Name] = component
end

function page:GetComponent(component: string): types.Component
    return self.Components.Stored[component]
end

function page:RemoveComponents()
    for _, component: types.Component in self.Components.Open do
        component:Clean()
    end

    self.Components.Open = {}
    self.Components.Stored = {}
end

--

--[[ Page ]]

function page:OnBuild(callback: (self: types.Page) -> ())
    self._.OnBuild = callback
end

function page:OnOpen(callback: (self: types.Page) -> ())
    self._.OnOpen = callback
end

function page:OnClose(callback: (self: types.Page) -> ())
    self._.OnClose = callback
end

function page:Build(parent: types.Window)
    self:Clean()

    self.Parent = parent

    self.Container = parent.Manager.Packages.Trove.new()

    if self._.OnBuild then
        self._.OnBuild(self)
    end
end

function page:Open()
    if self.Frame then
        self.Frame.Visible = true
    end

    if self._.OnOpen then
        self._.OnOpen(self)
    end
end

function page:Close()
    if self.Frame then
        self.Frame.Visible = false
    end

    if self._.OnClose then
        self._.OnClose(self)
    end
end

function page:Clean()
    self:RemoveComponents()
    self:RemoveButtons()

    self.Container:Remove()
end

function page:Remove()
    self:Clean()
    
    if self.Frame then
        self.Frame:Destroy()
    end
end

--[[ Helper ]]

function page:GetManager(): types.Manager
    return self.Parent.Manager
end

return module