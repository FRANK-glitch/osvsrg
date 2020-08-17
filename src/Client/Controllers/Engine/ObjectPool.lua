-- Object Pool
-- kisperal 
-- August 15, 2020



local ObjectPool = {}

local HttpService = game:GetService("HttpService")

local Engine = script.Parent
local HitObject = require(Engine.HitObject)
local Result = require(Engine.Result)
local Input = require(Engine.Input)

function ObjectPool:new(properties)
    --[[
        properties = {
            scrollSpeedMs = 500 > the scroll speed of the notes in milliseconds
            hitObjects = {<table>} > the times, lanes, and types of the notes/holds
            keybinds = {<table>} > the keybinds to check for when executing logic for note pressing
            callbacks = {
                poolChanged(pool) > fired whenever the note pool gets pooled to
                judgementIssued(judgement, name) > fired whenever a judgement gets issued
            }
        }
    ]]--
    local objectPool = {
        pool = {};
        index = 1;
        hitObjects = properties.hitObjects;
        keybinds = properties.keybinds;
    }

    local Timings = Result.Timings
    local UserInput = self.Controllers.UserInput
    local Keyboard = UserInput:Get("Keyboard")

    function objectPool:Update(songPosition)
        local keys = {
            Pressed = {};
            Released = {};
        }
        for i = 1, 4 do
            keys.Pressed[i] = Input:KeyJustPressed(self.keybinds[i])
            keys.Released[i] = Input:KeyJustReleased(self.keybinds[i])
        end
        --// CHECK FOR NEW OBJECTS

        local __print_line = false
        local __last_time = 0
        local __lanes = {false,false,false,false}

        for i = self.index, #self.hitObjects do
            self.index = i
            local curOb = self.hitObjects[i]
            --// CHECK IF WE NEED TO SPAWN THIS OBJECT
            if curOb.Time <= songPosition then
                local endTime = curOb.Duration ~= nil and curOb.Time + curOb.Duration or nil
                self:Pool({
                    track = curOb.Track,
                    startTime = curOb.Time,
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
            for n = 1, 4 do
                local kp = keys.Pressed[n]
                local kr = keys.Released[n]
                if kp or kr then
                    local j = curHitObject:CurrentJudgement()
                    if j ~= 0 then
                        print(j)
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
            startTime = properties.startTime;
            endTime = properties.endTime;
            track = properties.track;
            scrollSpeedMs = properties.scrollSpeedMs;
            id = properties.id;
        })
    end

    return objectPool
end

return ObjectPool