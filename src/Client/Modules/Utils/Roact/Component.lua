-- Component
-- kisperal 
-- August 14, 2020



local Component: AeroController = {}

function Component:Wrap(acomponent, name)
    local Roact: Roact = self.Shared.Roact
    local RoactRodux = self.Shared.RoactRodux

    local newComponent = Roact.Component:extend(name or self.Shared.StringUtil.RandomString(20))

    for i, v in pairs(acomponent) do
        if i ~= "mapStateToProps" and i ~= "mapDispatchToProps" then
            newComponent[i] = v
        end
    end

    --// GIVE THE ROACT COMPONENT ACCESS TO EVERYTHING THAT A NORMAL AGF COMPONENT DOES
    newComponent.Shared = self.Shared
    newComponent.Modules = self.Modules
    newComponent.Controllers = self.Controllers
    newComponent.Player = self.Player
    newComponent.Services = self.Services

    return newComponent
end

return Component