local Anticheat = {}

function Anticheat:NewCase(song, hits)
    --[[
        Anticheat Test Case
        -------------------

        What this does is creates a new Case object to run tests on. There are different stages in the pipeline. If the score makes it
        all the way through the pipeline without getting caught, then the score gets submitted to the database. You are welcome to help
        us add new stages to the pipeline!
    ]]--
    local TestCase = {Stages = {}}

    local function newStage(name, cb)
        TestCase.Stages[#TestCase.Stages+1] = {
            Callback = cb;
            Name = name;
        }
    end

    newStage("DetectImpossibleVibro", function(i)
        --[[
            Time, Track, Action, Result, Id
        ]]--
        local kpsFLAG = 54
        local kpsFLAGAT = 45000

        local lastTime = 0
        local kps = 0

        local msHELD = 0

        for i, v in pairs(hits) do
            if v.Time - lastTime >= 1000 then
                lastTime = v.Time

                if kps > kpsFLAG then
                    msHELD = msHELD + 1000
                else
                    msHELD = 0
                end
    
                if msHELD > kpsFLAGAT then
                    return false;
                end
                kps = 0
            end
            kps = kps + 1
        end

        return true;
    end)
    
    newStage("IsAutoplayed", function(i)
        local meanDifference = 0
        local total = 0
        for i, v in pairs(hits) do
            total = i
            if i >= 2 then
                meanDifference = meanDifference + (v.Deviation - hits[i-1].Deviation)
            end
        end

        meanDifference = meanDifference / total

        if meanDifference <= 0.00001 and meanDifference >= -0.00001 then
            return false
        end
        return true
    end)

    newStage("ClientModification", function(i)
        
    end)

    function TestCase:RunPipeline()
        for i, stage in pairs(TestCase.Stages) do
            print("Running stage " .. stage.Name)
            if stage.Callback(i) == false then
                return true
            end
        end
        return false
    end

    return TestCase
end

return Anticheat
