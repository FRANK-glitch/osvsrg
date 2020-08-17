-- Object Pool
-- kisperal 
-- August 15, 2020



local ObjectPool = {}

function ObjectPool:new(properties)
    --[[
        properties = {
            scrollSpeedMs = 500 > the scroll speed of the notes in milliseconds
            hitObjects = {<table>} > the times, lanes, and types of the notes/holds
            keybinds = {<table>} > the keybinds to check for when executing logic for note pressing
        }
    ]]--
    local objectPool = {
        pool = {};
        index = 1;
        hitObjects = properties.hitObjects;
        keybinds = properties.keybinds;
    }

    local HitObject = self.Controllers.Engine.HitObject
    local Result = self.Controllers.Engine.Result
    local Timings = Result.Timings
    local Input = self.Controllers.UserInput
    local Keyboard = Input:Get("Keyboard")

    function objectPool:Update(songPosition)
        --// CHECK FOR NEW OBJECTS
        for i = self.index, #self.hitObjects do
            local curOb = self.hitObjects[i]
            --// CHECK IF WE NEED TO SPAWN THIS OBJECT
            if curOb.Time <= songPosition then
                local endTime = curOb.Duration ~= nil and curOb.Time + curOb.Duration or nil
                self:Pool({
                    track = curOb.Track,
                    time = curOb.Time,
                    endTime = endTime,
                    id = i,
                })
            end

            if curOb.Time > songPosition then
                break
            end
        end
        --// HANDLE POOLED OBJECTS
        for i, curHitObject in pairs(self.pool) do
            curHitObject:Update(songPosition)
            local keys = {
                Keyboard:IsDown(self.keybinds[1]);
                Keyboard:IsDown(self.keybinds[2]);
                Keyboard:IsDown(self.keybinds[3]);
                Keyboard:IsDown(self.keybinds[4]);
            }
            for k, v in pairs(keys) do
                if curHitObject.track == k then
                    local judgement = curHitObject:CurrentJudgement()
                    if judgement ~= 0 then
                        
                    end
                end
            end
        end
    end

    function objectPool:Depool(id)
        for i, v in pairs(self.pool) do
            if v.id == id then
                table.remove(self.pool, i)
            end
        end
    end

    function objectPool:Pool(properties)
        --[[
            properties = {
                track = 4 > the track of the hit object to be pooled
                time = 15000 > the time of the hit object to be pooled
                endTime = 18450 > the end time of the hit object to be pooled
            }
        ]]--
        self.pool[#self.pool+1] = HitObject:new({
            startTime = startTime;
            endTime = endTime;
            track = track;
            scrollSpeedMs = properties.scrollSpeedMs;
        })
    end

    return objectPool
end

return ObjectPool