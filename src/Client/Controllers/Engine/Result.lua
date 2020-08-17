-- Result
-- kisperal 
-- August 16, 2020

local Names = {
    "Marvelous",
    "Perfect",
    "Great",
    "Good",
    "Bad",
    "Miss"
}

local Result = {
    Timings = {
        [Names[1]] = 20.5;
        [Names[2]] = 40.5;
        [Names[3]] = 73.5;
        [Names[4]] = 120.5;
        [Names[5]] = 154.5;
        [Names[6]] = 184.3;
    };
    Names = Names;
}

function Result:GetHitResult(msDifference)
    local n = 0
    for k, v in pairs(self.Timings) do
        n += 1
        if v >= msDifference then
            return n, k --Result.Timings index, judgement name
        end
    end
    return 0, nil
end

return Result