-- Playfield
-- kisperal 
-- August 17, 2020

local Roact: Roact

local Playfield = {}

function Playfield:init()
    Roact = self.Shared.Roact
end

function Playfield:render()
    return Roact.createElement("")
end

return Playfield