local replicated = game:GetService("ReplicatedStorage")
local trove = require(replicated.Modules.Utility.Trove)


--

export type ButtonClass = {
    Parent: Page | Component,
    Name: string,
    ButtonGui: GuiButton,

    _: {
        OnBuild: (self: Button) -> ()?,
        OnOpen: (self: Button) -> ()?,
        OnClose: (self: Button) -> ()?,

        OnPressed: (self: Button) -> ()?,
        OnReleased: (self: Button) -> ()?,
        OnHovered: (self: Button) -> ()?,
        OnHoverLeft: (self: Button) -> ()?,
    },

    OnBuild: (self: Button, callback: (self: Button) -> ()) -> (),
    OnOpen: (self: Button, callback: (self: Button) -> ()) -> (),
    OnClose: (self: Button, callback: (self: Button) -> ()) -> (),

    Build: (self: Button, parent: Page | Component) -> (),
    Open: (self: Button) -> (),
    Close: (self: Button) -> (),

    OnPressed: (self: Button, callback: (self: Button) -> ()) -> (),
    OnReleased: (self: Button, callback: (self: Button) -> ()) -> (),
    OnHovered: (self: Button, callback: (self: Button) -> ()) -> (),
    OnHoverLeft: (self: Button, callback: (self: Button) -> ()) -> (),

    Pressed: (self: Button) -> (),
    Released: (self: Button) -> (),
    Hovered: (self: Button) -> (),
    HoverLeft: (self: Button) -> (),

    Remove: (self: Button) -> (),
}

export type Button = typeof(setmetatable({} :: ButtonClass, {}))

--

export type ComponentClass = {
    Parent: Page,
    Name: string,
    Frame: Frame,

    Container: trove.Trove,

    Buttons: {
        Active: { [string]: Button },
        Stored: { [string]: Button },
    },

    BuildButtons: (self: Component) -> (),
    AddButton: (self: Component, button: Button) -> (),
    CloseAllButtons: (self: Component) -> (),
    RemoveButtons: (self: Component) -> (),

    _: {
        OnBuild: (self: Component) -> ()?,
        OnOpen: (self: Component) -> ()?,
        OnClose: (self: Component) -> ()?,

        UpdateCallbacks: { [string]: (self: Page, parameters: {}) -> () },
    },

    OnBuild: (self: Component, callback: (self: Component) -> ()) -> (),
    OnUpdate: (self: Component, command: string, callback: (self: Component) -> ()) -> (),
    OnOpen: (self: Component, callback: (self: Component) -> ()) -> (),
    OnClose: (self: Component, callback: (self: Component) -> ()) -> (),

    Build: (self: Component, parent: Page) -> (),
    Update: (self: Component, command: string, parameters: {}?) -> (),
    Open: (self: Component) -> (),
    Close: (self: Component) -> (),

    Clean: (self: Component) -> (),
    Remove: (self: Component) -> (),
}

export type Component = typeof(setmetatable({} :: ComponentClass, {}))

--

export type PageClass = {
    Parent: Window,
    Name: string,
    Frame: Frame,

    Container: trove.Trove,

    Buttons: {
        Active: { [string]: Button },
        Stored: { [string]: Button },
    },

    BuildButtons: (self: Page) -> (),
    AddButton: (self: Page, button: Button) -> (),
    GetButton: (self: Page, button: string) -> (),
    OpenButton: (self: Page, button: string) -> (),
    CloseButton: (self: Page, button: string) -> (),
    CloseAllButtons: (self: Page) -> (),
    RemoveButtons: (self: Page) -> (),

    Components: {
        Open: { [string]: Component },
        Stored: { [string]: Component },
    },

    BuildComponents: (self: Page) -> (),
    AddComponent: (self: Page, component: Component) -> (),
    GetComponent: (self: Page, component: string) -> (),
    OpenComponent: (self: Page, component: string) -> (),
    CloseComponent: (self: Page, component: string) -> (),
    CleanComponents: (self: Page) -> (),
    RemoveComponents: (self: Page) -> (),

    _: {
        OnBuild: (self: Page) -> ()?,
        OnOpen: (self: Page) -> ()?,
        OnClose: (self: Page) -> ()?,
    },

    OnBuild: (self: Page, callback: (self: Page) -> ()) -> (),
    OnOpen: (self: Page, callback: (self: Page) -> ()) -> (),
    OnClose: (self: Page, callback: (self: Page) -> ()) -> (),

    Build: (self: Page, parent: Window) -> (),
    Open: (self: Page) -> (),
    Close: (self: Page) -> (),

    Clean: (self: Page) -> (),
    Remove: (self: Page) -> (),

    GetManager: (self: Window) -> (Manager),
}

export type Page = typeof(setmetatable({} :: PageClass, {}))

--

export type WindowClass = {
    Manager: Manager,
    Name: string,
    ScreenGui: ScreenGui,
    Pages: {
        Open: { [string]: Page },
        Stored: { [string]: Page },
    },

    BuildPages: (self: Window) -> (),
    AddPage: (self: Window, page: Page) -> (),
    GetPage: (self: Window, page: string) -> (),
    OpenPage: (self: Window, page: string) -> (),
    ClosePage: (self: Window, page: string) -> (),
    RemovePages: (self: Window) -> (),
    CleanPages: (self: Window) -> (),

    _: {
        OnBuild: (self: Window) -> ()?,
        OnOpen: (self: Window) -> ()?,
        OnClose: (self: Window) -> ()?,
    },

    OnBuild: (self: Window, callback: (self: Window) -> ()) -> (),
    OnOpen: (self: Window, callback: (self: Window) -> ()) -> (),
    OnClose: (self: Window, callback: (self: Window) -> ()) -> (),

    Build: (self: Window, manager: Manager) -> (),
    Open: (self: Window) -> (),
    Close: (self: Window) -> (),

    Clean: (self: Window) -> (),
    Remove: (self: Window) -> (),
}

export type Window = typeof(setmetatable({} :: WindowClass, {}))

--

export type Manager = {
    --[=[
        Useful packages that may be used globally by all windows, pages, and so forth.
    ]=]
    Packages: {
        Trove: typeof(trove),
    },
    
    --[=[
        ```Window``` objects that are either ```Stored```, aka cached, or are in an ```Open``` state.
    ]=]
    Windows: {
        Open: { [string]: Window },
        Stored: { [string]: Window },
    },

    --[=[
        Locate a ```Window``` object stored under the provided name.
        
        @param name string

        @return ```Window```
    ]=]
    GetWindow: (self: Manager, name: string) -> (Window),

    --[=[
        Build and open a ```Window``` object and log its opened state.
        
        @param window ```Window```
    ]=]
    OpenWindow: (self: Manager, window: Window) -> (),

    --[=[
        Close and remove a ```Window``` object and log its state change.
        
        @param window ```Window```
    ]=]
    CloseWindow: (self: Manager, window: Window) -> (),

    --[=[
        Close and remove all open ```Window``` objects and log their state changes.
    ]=]
    CloseAllWindows: (self: Manager) -> (),

    --[=[
        Intended to only be run on the first time that the client boots up. \
        Receives a table of module scripts with which it will use to build the manager windows.

        @param source { ModuleScript } ```Window``` objects.
    ]=]
    Build: (self: Manager, source: { ModuleScript }) -> (),

    --[=[
        Will clean the manager by removing all the open ```Window``` objects.
    ]=]
    Clean: (self: Manager) -> (),
}

--

return {}