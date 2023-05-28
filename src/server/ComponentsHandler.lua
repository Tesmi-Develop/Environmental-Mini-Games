local Components = script.Parent.ClassComponents
local ComponentsHandler = {}

function ComponentsHandler.Init()
    for i, component in Components:GetDescendants() do
        if component:IsA('ModuleScript') then
            if component == script then continue end
    
            ComponentsHandler[component.Name] = require(component)
        end
    end
end

return ComponentsHandler