local ReplicatedStorage = game:GetService("ReplicatedStorage")
local objectList = require(script.Parent.ObjectList)
local signal = require(ReplicatedStorage.Modules.Utility.Signal)
local types = require(script.Parent.Types)

local window = {} :: types.WindowClass
window["__index"] = window

local module = {}

function module.new(name: string): types.Window
    local self = setmetatable({
        Name= name,

        Pages = objectList.new(),

        Events = {
            PageOpened = signal.new(),
            PageClosed = signal.new(),
        },

        _ = {},
    }, window)

    self.Pages.Parent = self

    return self
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

    self.Parent = manager

    if self._.OnBuild then
        self._.OnBuild(self)
    end

    self._.Status = "Built"
end

function window:GetStatus(): "Built" | "Stored"
    return self._.Status
end

function window:StatusIs(status: "Built" | "Stored"): boolean
    return status == self._.Status
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
    self.Pages:CleanAll()

    self._.Status = "Stored"
end

function window:Remove()
    self:Clean()
    
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

return module
