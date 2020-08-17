-- Song
-- kisperal 
-- August 15, 2020



local Song = {}

function Song:new(instance)
    local cachedId = nil
	local cachedRating = nil
	local cachedObNum = nil
	local cachedNpsGraph = nil

    local songObject = {}

    songObject.instance = instance
    songObject.data = require(self.instance)
	
	function songObject:GetData()
		return self.data
	end
	
	function songObject:GetName()
		return self.instance.Name
	end
	
	function songObject:GetDisplayName()
		local str = "[" .. self:GetDifficulty() .. "] " .. self:GetArtist() .. " - " .. self:GetSongName()
		
		local diffName = self:GetDifficultyName()
		
		if diffName ~= nil then
			str = "[" .. diffName .. "]" .. str
		end
		
		return str
	end

	function songObject:ConcatMetadata()
		return string.format("%s %s %s %s %s %s %s", 
			self:GetId(),
			self:GetDifficultyName(),
			self:GetDifficulty(),
			self:GetArtist(),
			self:GetCreator(),
			self:GetSongName(),
			self:GetName()
		)
	end
	
	function songObject:GetButtonColor()
		return self:GetData().AudioButtonColor or Color3.new(0.4,0.4,0.4)
	end
	
	function songObject:GetDifficulty()
		if cachedRating == nil then
			cachedRating = self:GetData().AudioDifficulty
		end
		return cachedRating
	end
	
	function songObject:GetSongVersion()
		return self:GetData().AudioSongVersion or 1
	end

	function songObject:GetLength()
		local hitObs = self:GetData().HitObjects
		local lastHitOb = hitObs[#hitObs]
		return lastHitOb.Time + (lastHitOb.Duration or 0)
	end

	function songObject:GetObjectNumber()
		if cachedObNum == nil then
			local hitObs = self:GetData().HitObjects
			local num = 0
			for i, v in pairs(hitObs) do
				num = num + v.Type
			end
			cachedObNum = num
		end
		return cachedObNum
	end

	function songObject:GetNpsGraph()
		if cachedNpsGraph == nil then
			local points = {}
			local objects = self:GetData().HitObjects
			local length = self:GetLength()

			local nps = 0
			local lastIndex = 1

			for i = 0, length, 1000 do
				for io = lastIndex, #objects do
					local itr_obj = objects[io]
					if itr_obj.Time > i then
						lastIndex = io
						points[#points+1] = nps
						break
					else
						nps = nps + 1
					end
				end
				nps = 0
			end
			cachedNpsGraph = points
		end
		return cachedNpsGraph
	end
	
	function songObject:GetId()
		if cachedId == nil then
			local ho = self:GetData().HitObjects
			local id = 0
			for i, obj in pairs(ho) do
				math.randomseed((obj.Time or 0) + (obj.Track or 0) + (obj.Type or 0) + (obj.Duration or 0))
				id = id + math.floor(math.random()*100)
			end
			cachedId = id
		end
		return cachedId
	end
	
	function songObject:GetDifficultyName()
		return self:GetData().AudioDifficultyName
	end
	
	function songObject:GetArtist()
		return self:GetData().AudioArtist
	end

	function songObject:GetCreator()
		return self:GetData().AudioMapper
	end
	
	function songObject:GetSongName() --not 100% accurate, expand later
		return self:GetData().AudioFilename
	end
	
	function songObject:GetColor()
		local diff = self:GetDifficulty()
		return self.Modules.Utils.Metrics:GetTierData(diff).Color
	end
	
    return songObject
end

return Song