local replicated = game:GetService("ReplicatedStorage")
local trove = require(replicated.Modules.Utility.Trove)
local types = require(script.Types)

local manager: types.Manager = {
    Packages = {Trove = trove},

    Windows = {
        Open = {},
        Stored = {},
    },
} :: types.Manager

function manager:GetWindow(name: string)
    return self.Windows.Stored[name]
end

function manager:OpenWindow(window: types.Window)
    window:Build(self)
    window:Open()

    self.Windows.Open[window.Name] = window
end

function manager:CloseWindow(window: types.Window)
    window:Close()
    window:Remove()

    self.Windows.Open[window.Name] = nil
end

function manager:Build(source: { ModuleScript })
    self:Clean()

    for _, module: ModuleScript in source do
        local window: types.Window = require(module) :: types.Window

        self.Windows.Stored[window.Name] = window
    end
end

function manager:Clean()
    for _, window in self.Windows.Open do
        window:Remove()
    end

    self.Windows = {
        Open = {},
        Stored = {},
    }
end

return manager