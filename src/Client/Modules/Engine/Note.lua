-- Note
-- kisperal 
-- August 15, 2020



local NoteBase = require(script.Parent.NoteBase)

function Note:new(properties)
    local note = NoteBase:new(properties)

    return note
end

return Note