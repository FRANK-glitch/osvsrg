-- Note Base
-- kisperal 
-- August 15, 2020



local NoteBase = {}

function NoteBase:new(properties)
    --[[
        properties = {
            startTime = 12345 > the time the hit object starts at
            endTime = 45678 > if not nil, this object is assumed to be a hold
        }
    ]]--
    local noteBase = {}

    function noteBase:UpdateVisualPosition() end
    function noteBase:GetStartTime() end
    function noteBase:GetEndTime() end
    function noteBase:GetStartAlpha() end
    function noteBase:GetEndAlpha() end

    return noteBase
end

return NoteBase