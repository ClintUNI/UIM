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
        
        if page.Name == DEFAULT_PAGE then 
            self:AddPage(require(page)).AsOpened() 
        else 
            self:AddPage(require(page)) 
        end
    end
end)

return window