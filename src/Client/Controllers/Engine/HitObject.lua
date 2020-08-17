-- Note Base
-- kisperal 
-- August 15, 2020



local HitObject = {}

local Engine = script.Parent
local Result = require(Engine.Result)

function HitObject:new(properties)
    --[[
        properties = {
            startTime = 12345 > the time the hit object starts at
            endTime = 45678 > if not nil, this object is assumed to be a hold
            track = 4 > the lane of the hit object
            scrollSpeedMs = 560 > the current scroll speed of hit objects
            id = 457 > the unique id of the hit object
        }
    ]]--
    local NumberUtil = self.Shared.NumberUtil       

    local hitObject = {}

    function hitObject:Update(currentTimeMs)
        self.currentTimeMs = currentTimeMs or 0
    end
    function hitObject:GetStartTime() return properties.startTime end
    function hitObject:GetEndTime() return properties.endTime end
    function hitObject:GetStartAlpha()
        if properties.startTime then
            return NumberUtil.InverseLerp(properties.startTime, properties.startTime+properties.scrollSpeedMs, properties.currentTimeMs)
        end
        return nil
    end
    function hitObject:GetEndAlpha()
        if properties.endTime then
            return NumberUtil.InverseLerp(properties.endTime, properties.endTime+properties.scrollSpeedMs, properties.currentTimeMs)
        end
        return nil
    end
    function hitObject:CurrentJudgement()
        local val = (
            math.abs(
                self.type == 1 and (self.currentTimeMs-self.startTime) or
                self.type == 2 and (self.hit and (self.currentTimeMs-self.startTime) or (self.currentTimeMs-self.endTime))
            )
        )
        return Result:GetHitResult(val)
    end
    function hitObject:Hit()
        self.hit = true
        local judgement, name = self:CurrentJudgement()
        print(judgement, name)
    end
    function hitObject:Release()
        if self.type == 2 then
            local jnumber = self:CurrentJudgement()
            if jnumber == 0 then
                self.holdBroken = true
                return
            end
        end
        self.released = true
    end

    hitObject.type = properties.endTime == nil and 1 or 2
    hitObject.hit = false
    hitObject.released = false
    hitObject.currentTimeMs = 0
    hitObject.track = properties.track or 1
    hitObject.id = properties.id or -1
    hitObject.holdBroken = false
    hitObject.startTime = properties.startTime
    hitObject.endTime = properties.endTime

    return hitObject
end

return HitObject