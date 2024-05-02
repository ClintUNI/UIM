local replicated = game:GetService("ReplicatedStorage")

local types = require(replicated.Modules.Managers.UIManager.Types)
local Window = require(replicated.Modules.Managers.UIManager.Window)

local DEFAULT_PAGE = "page"

local window = Window.new(script.Name)

window:OnBuild(function(self: types.Window): ()
    self.ScreenGui = Instance.new("ScreenGui")

    self.ScreenGui.Enabled = false
    self.ScreenGui.Parent = game:GetService("Players").LocalPlayer.PlayerGui

    for _, page: Instance in script.Pages:GetChildren() do
        if not page:IsA("ModuleScript") then continue end
        self:AddPage(require(page))
    end

    self:OpenPage(DEFAULT_PAGE)
end)

return window