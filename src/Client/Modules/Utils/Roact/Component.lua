-- Component
-- kisperal 
-- August 14, 2020



local Component = {}

function Component:Wrap(acomponent, name)
    local Roact: Roact = self.Shared.Roact
    local newComponent = Roact.Component:extend(name or "")
end

return Component