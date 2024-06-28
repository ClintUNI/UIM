local types = require(script.Parent.Types)

local button = {} :: types.ButtonClass
button["__index"] = button

local module = {}

function module.new(name: string): types.Button
    local self = setmetatable({
        Status = "Stored",
        Name= name,
        _ = {},
    }, button)

    return self
end

function button:OnBuild(callback: (self: types.Button) -> ())
    self._.OnBuild = callback
end

function button:OnOpen(callback: (self: types.Button) -> ())
    self._.OnOpen = callback
end

function button:OnClose(callback: (self: types.Button) -> ())
    self._.OnClose = callback
end

function button:Build(parent: types.Page | types.Component)
    self.Parent = parent

    if self._.OnBuild then
        self._.OnBuild(self)
    end
end

function button:GetStatus(): "Built" | "Stored"
    return self._.Status
end

function button:StatusIs(status: "Built" | "Stored")
    return status == self._.Status
end

function button:Open()
    if self.ButtonGui then
        self.ButtonGui.Active = true
        self.ButtonGui.Visible = true
    end

    if self._.OnOpen then
        self._.OnOpen(self)
    end
end

function button:Close()
    if self.ButtonGui then
        self.ButtonGui.Active = false
        self.ButtonGui.Visible = false
    end

    if self._.OnClose then
        self._.OnClose(self)
    end
end

--[[ Events ]]

function button:OnPressed(callback: (self: types.Button) -> ())
    self._.OnPressed = callback
end

function button:OnReleased(callback: (self: types.Button) -> ())
    self._.OnReleased = callback
end

function button:OnHovered(callback: (self: types.Button) -> ())
    self._.OnHovered = callback
end

function button:OnHoverLeft(callback: (self: types.Button) -> ())
    self._.OnHoverLeft = callback
end

function button:Pressed()
    if self._.OnPressed then
        self._.OnPressed(self)
    end
end

function button:Released()
    if self._.OnReleased then
        self._.OnReleased(self)
    end
end

function button:Hovered()
    if self._.OnHovered then
        self._.OnHovered(self)
    end
end

function button:HoverLeft()
    if self._.OnHoverLeft then
        self._.OnHoverLeft(self)
    end
end

function button:Remove()
    if self.ButtonGui then
        self.ButtonGui:Destroy()
    end
end

return module
