local Math = require(script.Parent.Math)

local calc = {}

-- LEGEND: Time, Type, Track, Duration

local function getStream(hits)
    local r = 0
    for i = 1, #hits do
        local hit = hits[i]
        if i > 2 then
            local prevHit = hits[i-1]
            local difference = math.abs(hit.Time - prevHit.Time)
            if prevHit.Track ~= hit.Track and difference <= 200 then
                r = r + (difference/20000)
            end
        end
    end
    return r
end

local function getChord(hits)
    return 0
end

local function getJS(hits)
    return 0
end

local function getHS(hits)
    return 0
end

local function getJack(hits)
    local jacksInARow = 0
    local r = 0
    for i = 1, #hits do
        local hit = hits[i]
        if i > 2 then
            jacksInARow = jacksInARow + 1
            local prevHit = hits[i-1]
            local difference = math.abs(hit.Time - prevHit.Time)
            if prevHit.Track == hit.Track and difference <= 400 then
                local cJks = math.clamp(jacksInARow, 1, 12)
                r = r + (cJks*difference/17000)
            else
                jacksInARow = 0
            end
        end
    end
    return r
end

local function genDataset()
    return {
        jack=0;
        chord=0;
        stream=0;
        handstream=0;
        jumpstream=0;
    }
end

local function timespanData(hits, startAtMs, timespanMs)
    if timespanMs == nil then
        timespanMs = 1000
    end
    local self = genDataset()

    local endAtMs = startAtMs + timespanMs
    local index = 0
    for i, v in pairs(hits) do
        if v.Time >= startAtMs then
            index = i
            break
        end
    end

    for i = index, #hits do
        local curOb = hits[i]
        if curOb ~= nil then
            if curOb.Time <= endAtMs then
                local lastNotes = {}
                for n = i, i-4, -1 do
                    local pHit = hits[n]
                    if pHit ~= nil then
                        lastNotes[#lastNotes+1] = pHit
                    end
                end

                table.sort(lastNotes, function(a, b)
                    return a.Time > b.Time
                end)

                self.jack = self.jack + getJack(lastNotes)
                self.handstream = self.handstream + getHS(lastNotes)
                self.jumpstream = self.jumpstream + getJS(lastNotes)
                self.stream = self.stream + getStream(lastNotes)
                self.chord = self.chord + getChord(lastNotes)
            else
                break
            end
        end
    end
    return self
end

function calc:DoRating(song)
    local data = song:GetData()
    local rating = 0;
    if data.totalNotes < 20 then
        return 0
    end

    local tsData = timespanData(data.HitObjects, 0, data.songLength*1000)

    local i = 0

    for k, v in pairs(tsData) do
        i = i + 1
        rating = rating + v
    end
    rating = rating / 2
    
    print(rating, song:GetDisplayName())
    return rating
end

return calc