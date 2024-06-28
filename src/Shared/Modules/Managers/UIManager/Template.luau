local types = require(script.Parent.Types)

local module = {}

local template = {}
template["__index"] = template

function module.new<Object, MethodOptions, Parameters>(): types.Template<Object, MethodOptions, Parameters>
    return setmetatable({
        Files = {},
    } :: types.TemplateClass<Object, MethodOptions, Parameters>, template) :: types.Template<Object, MethodOptions, Parameters>
end

function template:Create<Object, MethodOptions, Parameters>(method: MethodOptions, callback: (self: Object, parameters: Parameters?) -> ()): ()
    self.Files[method] = callback
end

function template:Fire<Object, MethodOptions, Parameters>(method: MethodOptions, object: Object, parameters: Parameters?): ()
    if self.Files[method] then
        self.Files[method](object, parameters)
    end
end

return module
