local replicated = game:GetService("ReplicatedStorage")
local uiManager = require(replicated.Modules.Managers.UIManager)
uiManager:Build(script.Parent.Test:GetChildren() :: {})

local default = uiManager:GetWindow("window")

uiManager:OpenWindow(default)
