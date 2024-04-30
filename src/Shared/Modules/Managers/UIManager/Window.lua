local types = require(script.Parent.Types)

local window: types.WindowClass = {} :: types.WindowClass
window["__index"] = window

local module = {}

function module.new(name: string): types.Window
    local self = setmetatable({
        Name= name,
        Pages = {
            Open = {},
            Stored = {},
        },

        _ = {},
    }, window)

    return self
end

function window:BuildPages()
    for _, page: types.Page in self.Pages.Stored do
        page:Build(self)
    end
end

function window:AddPage(page: types.Page)
    self.Pages.Stored[page.Name] = page
end

function window:GetPage(page: string): types.Page
    return self.Pages.Stored[page]
end

function window:RemovePages()
    for _, page: types.Page in self.Pages.Open do
        page:Remove()
    end

    self.Pages.Open = {}
    self.Pages.Stored = {}
end

function window:OnBuild(callback: (self: types.Window) -> ())
    self._.OnBuild = callback
end

function window:OnOpen(callback: (self: types.Window) -> ())
    self._.OnOpen = callback
end

function window:OnClose(callback: (self: types.Window) -> ())
    self._.OnClose = callback
end

function window:Build(manager: types.Manager)
    self:Clean()

    self.Manager = manager

    if self._.OnBuild then
        self._.OnBuild(self)
    end
end

function window:Open()
    if self.ScreenGui then
        self.ScreenGui.Enabled = true
    end

    if self._.OnOpen then
        self._.OnOpen(self)
    end
end

function window:Close()
    if self.ScreenGui then
        self.ScreenGui.Enabled = false
    end

    if self._.OnClose then
        self._.OnClose(self)
    end
end

function window:Clean()
    self:RemovePages()
end

function window:Remove()
    self:Clean()
    
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

return module