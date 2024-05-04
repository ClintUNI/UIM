local ReplicatedStorage = game:GetService("ReplicatedStorage")
local signal = require(ReplicatedStorage.Modules.Utility.Signal)
local types = require(script.Parent.Types)

local window: types.WindowClass = {} :: types.WindowClass
window["__index"] = window

local module = {}

function module.new(name: string): types.Window
    local self = setmetatable({
        Name= name,
        Pages = {
            Open = {},
            Stored = {},
        },

        Events = {
            PageOpened = signal.new(),
            PageClosed = signal.new(),
        },

        _ = {},
    }, window)

    return self
end

--[[ Pages ]]

local function addPageTo(self: types.Window, page: types.Page): ()
    local pageName = page.Name
    page:Build(self)
    page:Open()
    self.Pages.Open[pageName] = page

    self._.LastOpenedPageName = self._.RecentlyOpenedPageName or pageName
    self._.RecentlyOpenedPageName = pageName
end

--[[ Page Methods ]]

function window:BuildPages()
    for _, page: types.Page in self.Pages.Stored do
        page:Build(self)
    end
end

function window:AddPage(page: types.Page): {AsOpened: () -> ()}
    self.Pages.Stored[page.Name] = page

    return {
        AsOpened = function()
            addPageTo(self, page)
        end
    }
end

function window:GetPage(page: string): types.Page
    return self.Pages.Stored[page]
end

function window:OpenPage(page: string, command: "Weighted" | "Forced"?)
    local pageModule: types.Page = self.Pages.Stored[page]
    if pageModule then
        if command then
            if command:upper() == "WEIGHTED" then
                self:CloseAllPages(function(openPage: types.Page)
                    return openPage.Weight < pageModule.Weight
                end)
            elseif command:upper() == "FORCED" then
                self:CloseAllPages()
            end
        end

        addPageTo(self, pageModule)

        self.Events.PageOpened:Fire(pageModule)
    end
end

function window:OpenLastPage()
    self:OpenPage(self._.LastOpenedPageName, "Forced")
end

function window:ClosePage(page: string)
    local pageModule: types.Page = self.Pages.Open[page]
    if pageModule then
        pageModule:Close()
        pageModule:Clean()
        self.Pages.Open[page] = nil

        self.Events.PageClosed:Fire(pageModule)
    end
end

function window:CloseAllPages(middleware: (types.Page) -> (boolean)?)
    for _, page: types.Page in self.Pages.Open do
        if not middleware or not middleware(page) then
            continue
        end

        page:Close()
        page:Clean()

        self.Pages.Open[page.Name] = nil
    end
end

function window:CleanPages()
    for _, page: types.Page in self.Pages.Open do
        page:Close()
        page:Clean()
    end

    self.Pages.Open = {}
end

function window:RemoveAllPages()
    for _, page: types.Page in self.Pages.Open do
        page:Remove()
    end

    self.Pages.Open = {}
    self.Pages.Stored = {}
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

    self.Manager = manager

    if self._.OnBuild then
        self._.OnBuild(self)
    end
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
    self:CleanPages()
end

function window:Remove()
    self:Clean()
    self:RemoveAllPages()
    
    if self.ScreenGui then
        self.ScreenGui:Destroy()
    end
end

return module