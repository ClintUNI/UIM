local objectList = require(script.Parent.ObjectList)
local types = require(script.Parent.Types)

local page = {} :: types.PageClass
page["__index"] = page

local module = {}

function module.new(name: string): types.Page
    local self = setmetatable({
        Name= name,
        Weight = 0,

        Buttons = objectList.new() :: types.ObjectList<types.Button, types.Page>,
        Components = objectList.new(),

        _ = {},
    }, page)

    self.Buttons.Parent = self
    self.Components.Parent = self

    return self
end

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

    local manager = parent.Parent
    self.Container = manager.Packages.Trove.new()

    if self._.OnBuild then
        self._.OnBuild(self)
    end

    self._.Status = "Built"
end

function page:GetStatus(): "Built" | "Stored"
    return self._.Status
end

function page:StatusIs(status: "Built" | "Stored")
    return status == self._.Status
end

function page:Open()
    if self.Frame then
        self.Frame.Visible = true
    end

    if self._.OnOpen then
        self._.OnOpen(self)
    end
end

function page:Back()
    if self.Parent then
        self.Parent:OpenLastPage()
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
    self.Components:CleanAll()
    self.Buttons:CleanAll()

    if self.Container then
        self.Container:Destroy()
    end

    self._.Status = "Stored"
end

function page:Remove()
    self:Clean()

    self.Components:CloseAll()
    self.Components:RemoveAll()

    self.Buttons:CloseAll()
    self.Buttons:RemoveAll()
    
    if self.Frame then
        self.Frame:Destroy()
    end
end

--[[ Helper ]]

function page:GetManager(): types.Manager
    return self.Parent.Parent
end

return module
