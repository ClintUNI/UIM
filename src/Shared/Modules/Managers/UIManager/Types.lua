local replicated = game:GetService("ReplicatedStorage")
local signal = require(replicated.Modules.Utility.Signal)
local trove = require(replicated.Modules.Utility.Trove)


--

--[[ == Template == ]]

type TemplateClass<Object, MethodOptions, Parameters> = {
    Files: {
        [string]: (self: Object, parameters: {}?) -> ()
    },
    Create: ((self: Template<Object, MethodOptions, Parameters>, method: MethodOptions, callback: (self: Object, parameters: Parameters?) -> ()) -> ()),
    Fire: ((self: Template<Object, MethodOptions, Parameters>, method: MethodOptions, object: Object, parameters: Parameters?) -> ()),
}

export type Template<Object, MethodOptions, Parameters> = typeof(setmetatable({} :: TemplateClass<Object, MethodOptions, Parameters>, {}))

--[[ == ObjectList == ]]

export type ListableObject = (Button | Component | Page)

export type ObjectListClass<LO, P> = {
    Parent: P,

    Opened: { [string]: boolean },
    Built: { [string]: LO },
    Stored: { [string]: LO },

    RecentlyOpenedName: string,
    LastOpenedName: string,

    Add: (self: ObjectList<LO, P>, object: LO) -> (),
    Get: (self: ObjectList<LO, P>, name: string) -> (LO?),
    Remove: (self: ObjectList<LO, P>, name: string) -> (),
    RemoveAll: (self: ObjectList<LO, P>) -> (),
    Build: (self: ObjectList<LO, P>, name: string) -> (),
    BuildAll: (self: ObjectList<LO, P>) -> (),
    Open: (self: ObjectList<LO, P>, name: string, mode: ("Weighted" | "Forced")?) -> (),
    OpenAll: (self: ObjectList<LO, P>) -> (),
    OpenPrevious: (self: ObjectList<LO, P>) -> (),
    Close: (self: ObjectList<LO, P>, name: string) -> (),
    CloseAll: (self: ObjectList<LO, P>) -> (),
    Clean: (self: ObjectList<LO, P>,  name: string) -> (),
    CleanAll: (self: ObjectList<LO, P>) -> (),
}

export type ObjectList<LO, P> = typeof(setmetatable({} :: ObjectListClass<LO, P>, {}))


--[[ == Interfaces == ]]

type BuildableObject<Self, Parent> = {
    Parent: Parent,

    _: {
        Status: "Stored" | "Built",

        OnBuild: (self: Self) -> ()?,
    },

    OnBuild: (self: Self, callback: (self: Self) -> ()) -> (),
    Build: (self: Self, parent: Parent) -> (),

    GetStatus: (self: Self) -> ("Stored" | "Built"),
    StatusIs: (self: Self, status: "Stored" | "Built") -> (boolean),
}

type CleanableObject<Self> = {
    Clean: (self: Self) -> (),
    Remove: (self: Self) -> (),
}

type RenderableObject<Self> = {
    _: {
        OnOpen: (self: Self) -> ()?,
        OnClose: (self: Self) -> ()?,
    },

    OnOpen: (self: Self, callback: (self: Self) -> ()) -> (),
    OnClose: (self: Self, callback: (self: Self) -> ()) -> (),

    Open: (self: Self) -> (),
    Close: (self: Self) -> (),
}

--

export type ButtonEvents = "Pressed" | "Released" | "Hovered" | "HoverLeft"

export type ButtonClass = {
    Name: string,
    ButtonGui: GuiButton,

    _: {
        OnPressed: (self: Button) -> ()?,
        OnReleased: (self: Button) -> ()?,
        OnHovered: (self: Button) -> ()?,
        OnHoverLeft: (self: Button) -> ()?,
    },

    OnPressed: (self: Button, callback: (self: Button) -> ()) -> (),
    OnReleased: (self: Button, callback: (self: Button) -> ()) -> (),
    OnHovered: (self: Button, callback: (self: Button) -> ()) -> (),
    OnHoverLeft: (self: Button, callback: (self: Button) -> ()) -> (),

    Pressed: (self: Button) -> (),
    Released: (self: Button) -> (),
    Hovered: (self: Button) -> (),
    HoverLeft: (self: Button) -> (),

    Remove: (self: Button) -> (),
} & BuildableObject<Button, Page | Component> & RenderableObject<Button>

export type Button = typeof(setmetatable({} :: ButtonClass, {}))

--

export type ComponentClass = {
    Name: string,
    Frame: Frame,

    Container: trove.Trove,

    Buttons: ObjectList<Button, Component>,

    BuildButtons: (self: Component) -> (),
    AddButton: (self: Component, button: Button) -> (),
    CloseAllButtons: (self: Component) -> (),
    RemoveButtons: (self: Component) -> (),

    _: {
        UpdateCallbacks: { [string]: (self: Page, parameters: {}) -> () },
    },

    OnUpdate: (self: Component, command: string, callback: (self: Component) -> ()) -> (),

    Update: (self: Component, command: string, parameters: {}?) -> (),
} & BuildableObject<Component, Page> & CleanableObject<Component> & RenderableObject<Component>

export type Component = typeof(setmetatable({} :: ComponentClass, {}))

--

export type PageClass = {
    Name: string,
    Weight: number,
    Frame: Frame,

    Container: trove.Trove,

    Buttons: ObjectList<Button, Page>,
    Components: ObjectList<Component, Page>,

    GetManager: (self: Window) -> (Manager),
} & BuildableObject<Page, Window> & CleanableObject<Page> & RenderableObject<Page>

export type Page = typeof(setmetatable({} :: PageClass, {}))

--

export type WindowClass = {
    Name: string,
    ScreenGui: ScreenGui,
    Pages: ObjectList<Page, Window>,

    --[[ Not used, at the moment.]]
    Events: {
        PageOpened: signal.Signal<Page, boolean>,
        PageClosed: signal.Signal<Page, boolean>,
    },
} & BuildableObject<Window, Manager> & CleanableObject<Window> & RenderableObject<Window>

export type Window = typeof(setmetatable({} :: WindowClass, {}))

--

export type Manager = {
    Events: {
        WindowOpened: signal.Signal<Window, boolean>,
        WindowClosed: signal.Signal<Window, boolean>,
    },

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
        Build and open a ```Window``` object and log its opened state based on the given name.
        
        @param name ```string```
    ]=]
    OpenWindowByName: (self: Manager, name: string) -> (),

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
