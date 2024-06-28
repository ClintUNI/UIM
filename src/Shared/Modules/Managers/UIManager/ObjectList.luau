local types = require(script.Parent.Types)

local module = {}

local list = {}
list["__index"] = list

function module.new<T, P>(): types.ObjectList<T, P>
    local self = setmetatable({
        Parent = nil,

        Opened = {},
        Built = {},
        Stored = {},
    }, list)

    return self
end

function list:Add(object: types.ListableObject)
    self.Stored[object.Name] = object
end

function list:Get(name: string): types.ListableObject?
    return self.Stored[name]
end

function list:Remove(name: string)
    self:Clean(name)
    self.Stored[name] = nil
end

function list:RemoveAll()
    self:CleanAll()
    self.Stored = {}
end

function list:Open(name: string, mode: ("Weighted" | "Forced")?)
    local objectToBuild = self.Built[name]
    if objectToBuild and objectToBuild:StatusIs("Built") then
        if mode and mode == "Weighted" and objectToBuild.Weight then
            for openName: string, status: boolean in self.Opened do
                local openObject = self.Built[openName]
                if status == true and openObject.Weight and openObject.Weight < objectToBuild.Weight then
                    self:Close(openName)
                end
            end
        elseif mode == "Forced" then
            self:CloseAll()
        end

        objectToBuild:Open()
        self.Opened[name] = true

        self.LastOpenedName = self.RecentlyOpenedName or name
        self.RecentlyOpenedName = name
    end
end

function list:OpenAll()
    for name: string, _: types.ListableObject in self.Stored do
        self:Open(name)
    end
end

function list:OpenPrevious()
    self:Open(self.LastOpenedName, "Forced")
end

function list:Close(name: string)
    if self.Built[name] then
        self.Built[name]:Close()
        self.Opened[name] = false
    end
end

function list:CloseAll()
    for name: string, status: boolean in self.Opened do
        if status == true then
            self:Close(name)
        end
    end

    self.Opened = {}
end

function list:Build(name: string)
    local object = self.Stored[name]
    if object and not object:StatusIs("Built") then
        object:Build(self.Parent)
        self.Built[name] = object
    end
end

function list:BuildAll()
    for _, object in self.Stored do
        if object:StatusIs("Built") then 
            continue 
        end
        task.spawn(function()
            object:Build(self.Parent)
            self.Built[object.Name] = object
        end)
    end
end

function list:Clean(name: string)
    local object = self.Built[name]
    if object then
        if object["Clean"] then
            self.Built[name]:Clean()
        end

        self.Built[name] = nil
    end
end

function list:CleanAll()
    for _, object in self.Stored do
        self:Clean(object.Name)
    end

    self.Built = {}
end

return module
