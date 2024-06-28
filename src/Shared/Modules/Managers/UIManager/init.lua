local ReplicatedStorage = game:GetService("ReplicatedStorage")
local replicated = game:GetService("ReplicatedStorage")
local signal = require(ReplicatedStorage.Modules.Utility.Signal)
local trove = require(replicated.Modules.Utility.Trove)
local types = require(script.Types)

local manager: types.Manager = {
    Events = {
        WindowOpened = signal.new(),
        WindowClosed = signal.new(),
    },

    Packages = {Trove = trove},

    Windows = {
        Open = {},
        Stored = {},
    },
} :: types.Manager

--[[ Window Methods ]]

function manager:GetWindow(name: string)
    return self.Windows.Stored[name]
end

function manager:OpenWindow(window: types.Window)
    window:Build(self)
    window:Open()

    self.Windows.Open[window.Name] = window

    self.Events.WindowOpened:Fire(window, true)
end

function manager:OpenWindowByName(name: string)
    self:OpenWindow(self:GetWindow(name))
end

function manager:CloseWindow(window: types.Window)
    window:Close()
    window:Remove()

    self.Windows.Open[window.Name] = nil

    self.Events.WindowClosed:Fire(window, true)
end

function manager:CloseAllWindows()
    for _, window in self.Windows.Open do
        self:CloseWindow(window)
    end

    self.Windows.Open = {}
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
