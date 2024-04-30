local replicated = game:GetService("ReplicatedStorage")

local types = require(replicated.Modules.Managers.UIManager.Types)
local Window = require(replicated.Modules.Managers.UIManager.Window)

local window = Window.new(script.Name)

window:OnBuild(function(self: types.Window): ()
    self.ScreenGui = Instance.new("ScreenGui")

    self.ScreenGui.Enabled = false
    self.ScreenGui.Parent = game:GetService("Players").LocalPlayer.PlayerGui
end)

return window